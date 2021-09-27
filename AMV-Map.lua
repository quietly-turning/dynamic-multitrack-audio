local args = ...
local g = args[1]
local map_data = args[2]
local map_index = args[3]

g.Events[map_index] = {}


-- returns a table of two values, right and down, both in tile units
local FindCenterOfMap = function()

	-- calculate which tile currently represents the center of what is currently
	-- displayed in the window in terms of tiles right and tiles down from top-left
	local MapCenter = {right=g.Player[g.CurrentMap].pos.x,  down=g.Player[g.CurrentMap].pos.y}

	-- half screen width in tile units
	local half_screen_width_in_tiles  = (_screen.w/(map_data.tilewidth*g.map.zoom))/2
	-- half screen height in tile units
	local half_screen_height_in_tiles = (_screen.h/(map_data.tileheight*g.map.zoom))/2

	-- if players are near the edge of a map, using the MapCenter, this will result
	-- in the map scrolling "too far" and the player seeing beyond the edge of the map
	-- clamp the MapCenter values here to prevent this from occuring

	-- left edge of map
	if (MapCenter.right < half_screen_width_in_tiles) then MapCenter.right = half_screen_width_in_tiles end
	-- right edge of map
	if (MapCenter.right > map_data.width - half_screen_width_in_tiles) then MapCenter.right = map_data.width - half_screen_width_in_tiles end
	-- top edge of map
	if (MapCenter.down < half_screen_height_in_tiles) then MapCenter.down = half_screen_height_in_tiles end
	-- bottom edge of map
	if (MapCenter.down > map_data.height - half_screen_height_in_tiles) then MapCenter.down = map_data.height - half_screen_height_in_tiles end

	return MapCenter
end


local viewport = {
	h = math.ceil((_screen.h/map_data.tileheight) / g.map.zoom),
	w = math.ceil((_screen.w/map_data.tilewidth) / g.map.zoom),
}
local half_height = viewport.h/2
local half_width  = viewport.w/2
-- color, to be reused in each loop iteration
local c = {1,1,1,1}

local GetLayerVerts = function(layer, tileset, tilewidth, tileheight, mapwidth, mapheight)

	-- vert data for a single AMV, where 1 tilelayer = 1 AMV
	local verts = {}

	local MapCenter = FindCenterOfMap()
	-- local row_str = ""

	-- for i=0,#layer.data-1 do
	for d=math.ceil(MapCenter.down-half_height)-1, math.ceil(MapCenter.down+half_height) do
		d = clamp(d, 0, map_data.height-1)

		for r=math.ceil(MapCenter.right-half_width)-1, math.ceil(MapCenter.right+half_width) do
			r = clamp(r, 0, map_data.width-1)

			local i = (r) + (d*map_data.width)


			-- row_str = row_str .. ("%03d, "):format(i)


			local tile_id = layer.data[i+1]-1

			if (tile_id ~= -1) then
				-- vertex position, these are the 4 corners of this single tile as it appears in the larger AMV
				local p = {
					-- x,                               y,                                            z
					{ (i%mapwidth)*tilewidth,           math.floor(i/mapwidth)*tileheight,            1 },
					{ (i%mapwidth)*tilewidth+tilewidth, math.floor(i/mapwidth)*tileheight,            1 },
					{ (i%mapwidth)*tilewidth+tilewidth, math.floor(i/mapwidth)*tileheight+tileheight, 1 },
					{ (i%mapwidth)*tilewidth,           math.floor(i/mapwidth)*tileheight+tileheight, 1 }
				}

				-- texture coordinates, these are the 4 corners of the specific section of the overall tileset texture we want drawn on this tile
				local t = {
					-- tx, ty
					{scale(((tile_id%tileset.columns)+0)*tilewidth, 0, tileset.imagewidth, 0, 1),	scale((math.floor(tile_id/tileset.columns)+0)*tileheight, 0, tileset.imageheight, 0, 1) },
					{scale(((tile_id%tileset.columns)+1)*tilewidth, 0, tileset.imagewidth, 0, 1),	scale((math.floor(tile_id/tileset.columns)+0)*tileheight, 0, tileset.imageheight, 0, 1) },
					{scale(((tile_id%tileset.columns)+1)*tilewidth, 0, tileset.imagewidth, 0, 1),	scale((math.floor(tile_id/tileset.columns)+1)*tileheight, 0, tileset.imageheight, 0, 1) },
					{scale(((tile_id%tileset.columns)+0)*tilewidth, 0, tileset.imagewidth, 0, 1),	scale((math.floor(tile_id/tileset.columns)+1)*tileheight, 0, tileset.imageheight, 0, 1) },
				}

				table.insert(verts, {p[1], c, t[1]})
				table.insert(verts, {p[2], c, t[2]})
				table.insert(verts, {p[3], c, t[3]})
				table.insert(verts, {p[4], c, t[4]})
			end
		end
		-- row_str = row_str .. "\n"
	end
	-- SM(viewport)

	return verts
end

-- -----------------------------------------------------------------------

local af = Def.ActorFrame{}

-- zoom the map and the player (but not the snow) some amount
af.InitCommand=function(self)
	self:zoom(g.map.zoom)

	-- The AMV_map will have been designed in the Tiled app to have "under" and "over" layers
	-- but the player sprite and event tiles might need to dynamically shift their sense of what
	-- draws under/over what.  We handle this by updating the z() value of the player and events to match their
	-- y() value (things further down the map draw OVER things higher up the map) and applying
	-- SetDrawByZPosition(true) to the entire ActorFrame.
	self:SetDrawByZPosition(true):visible(false)
end

af.MoveMapCommand=function(self)
	local MapCenter = FindCenterOfMap()

	local x = -(MapCenter.right * map_data.tilewidth * g.map.zoom - _screen.w/2)
	local y = -(MapCenter.down * map_data.tileheight * g.map.zoom - _screen.h/2)

	self:GetParent():xy(x,y)
end

-- ----------------------------------------------------------------------------

local song_dir = GAMESTATE:GetCurrentSong():GetSongDir()

-- When creating a new tileset in Tiled, there's a checkbox for "embed in map"
-- if checked, the Lua for that tileset will appear directly in the main Lua
-- table for the overall map. The "tilesets" key will be an array of tables for
-- embedded tilesets.
-- if left unchecked, Tiled will create a dedicated .tsx file for the tileset,
-- which can also be exported to Lua.
-- Let's handle both cases here.
local tileset_lua

-- if exported from a standalone .tsx file
if map_data.tilesets[1].filename ~= nil then
	tileset_lua = LoadActor( ("%smap_data/%s.lua"):format(song_dir, map_data.tilesets[1].name) )

-- otherwise, if it's embedded in main map file
else
	tileset_lua = map_data.tilesets[1]
end

local path_to_texture = ("%smap_data/%s"):format(song_dir, tileset_lua.image)

-- TODO: support multiple tilesets in one map
--       Tiled certainly allows it, we should too

-- ----------------------------------------------------------------------------
-- find the collision data layer now and add it to the g table
-- we'll want to refer to it from within a few different files
for layer in ivalues(map_data.layers) do
	if layer.name == "Collision" then
		g.collision_layer[map_index] = layer
		break
	end
end


-- Loop through the layers exported from the Tiled app, and add either an AMV or a Sprite for each.
-- The parent ActorFrame (af) has SetDrawByZPosition(true) set, so the sequence in which these layers are
-- added to it does not dictate their draw order.  Each layer must be assigned a z() value appropriately.
for layer_index,layer in ipairs(map_data.layers) do

	-- this is a tiled layer that must be created using an AMV
	if layer.type == "tilelayer" and layer.visible and (layer.name:lower() ~= "collision") then

		-- an AMV for this layer in the map
		af[#af+1] = Def.ActorMultiVertex{
			InitCommand=function(self)
				self:SetDrawState( {Mode="DrawMode_Quads"} )
				self:LoadTexture( path_to_texture )
				self:SetTextureFiltering( false )
			end,
			MoveMapCommand=function(self)
				local layer_verts = GetLayerVerts(layer, tileset_lua, map_data.tilewidth, map_data.tileheight, map_data.width, map_data.height)

				self:SetVertices( layer_verts ):z(layer_index)
			end
		}

	-- for "Texture" layers, add a texture
	elseif layer.name == "Texture" then

		local obj = layer.objects[1]

		if not obj.properties.Parallax then
			if obj.properties.Texture then
				af[#af+1] = LoadActor(obj.properties.Texture)..{
					InitCommand=function(self)
						self:customtexturerect(0,0,1,1)
							:texcoordvelocity(obj.properties.vx or 0,obj.properties.vy or 0)
							:diffusealpha(obj.properties.alpha or 1)
							:xy(obj.x, obj.y)
							:z(layer_index)
							:align(0,0)
							:zoomto( obj.width, obj.height )

						if obj.tintcolor then
							self:diffuse( obj.tintcolor[1]/255, obj.tintcolor[2]/255, obj.tintcolor[3]/255, obj.tintcolor[4]/255 )
						end

					end
				}
			else
				lua.ReportScriptError("Object \""..obj.name.."\" is in a Texture Layer, but doesn't have a custom \"Texture\" property.  Skipping.")
			end
		end

	elseif layer.name == "Player" then

		-- Player sprite has enough logic that it gets its own Lua file
		af[#af+1] = LoadActor("./Player/player_sprite.lua", {g, map_data, layer, layer_index, map_index})

	elseif layer.name == "Dynamic Audio" then
		for obj in ivalues(layer.objects) do
			g.DynamicAudio[obj.properties.File] = {x=obj.x, y=obj.y}
		end

	elseif layer.name == "Interactive Events" then

		for event in ivalues(layer.objects) do
			local tile_num

			-- if an object from Tiled has a gid, we need to subtract 1 tile unit from the y position of this event
			if event.gid then
				tile_num = ((event.y/map_data.tileheight)-1) * map_data.width + (event.x/map_data.tilewidth) + 1
			else
			-- otherwise, if the object does not have a tile associated with it...
				tile_num = ((event.y/map_data.tileheight)) * map_data.width + (event.x/map_data.tilewidth) + 1
			end

			-- set Events data
			g.Events[map_index][tile_num] = event

			if event.gid then
				af[#af+1] = Def.Sprite{
					Texture=path_to_texture,
					InitCommand=function(self)
						self:animate(false)
							:align(0,0)
							:x(event.x)
							:y(event.y-map_data.tileheight)
							:z(layer_index)
							:setstate(event.gid-1)
							:SetTextureFiltering( false )
					end,
				}
			end
		end
	end
end

return af