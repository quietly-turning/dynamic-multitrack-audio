local args = ...
local g = args[1]
local map_data = args[2]
local map_index = args[3]

g.Events[map_index] = {}
g.NPCs[map_index] = {}
-- -----------------------------------------------------------------------

local song_dir = GAMESTATE:GetCurrentSong():GetSongDir()
local tileset_luas = {}

-- -----------------------------------------------------------------------

-- returns a table of two values, right and down, both in tile units
local FindCenterOfMap = function()

   -- calculate which tile currently represents the center of what is currently
  -- displayed in the window in terms of tiles right and tiles down from top-left
  local MapCenter = {
    right=g.Player[g.CurrentMap].pos.x,
    down=g.Player[g.CurrentMap].pos.y
  }

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

-- -----------------------------------------------------------------------
local viewport = {
  h = math.ceil((_screen.h/map_data.tileheight) / g.map.zoom),
  w = math.ceil((_screen.w/map_data.tilewidth ) / g.map.zoom),
}
local half_height = viewport.h/2
local half_width  = viewport.w/2
-- -----------------------------------------------------------------------

-- color, to be reused in each loop iteration
local c = {1,1,1,1}

local GetLayerVerts = function(layer_lua, tileset_lua)

  -- -----------------------------------------------------------------------
  -- for debugging
  local row_str = ""
  -- -----------------------------------------------------------------------

  local tilewidth  = map_data.tilewidth
  local tileheight = map_data.tileheight
  local mapwidth   = map_data.width

  -- vert data for a single AMV
  local verts = {}

  local MapCenter = FindCenterOfMap()

  for d=math.ceil(MapCenter.down-half_height)-1, math.ceil(MapCenter.down+half_height) do
    d = clamp(d, 0, map_data.height-1)

    for r=math.ceil(MapCenter.right-half_width)-1, math.ceil(MapCenter.right+half_width) do
      r = clamp(r, 0, map_data.width-1)

      local i = (r) + (d*map_data.width)
      local tile_gid = layer_lua.data[i+1]

      -- -----------------------------------------------------------------------
      -- for debugging
      row_str = row_str .. ("%03d, "):format(tile_gid)
      -- -----------------------------------------------------------------------

      if (
        tile_gid ~= 0                               -- if the artist laid down a tile here (Tiled would export that tile as gid 0 if not)
        and (tile_gid >= tileset_lua.firstgid)      -- if the gid for this tile is within the range of tiles this tileset supports
        and (tile_gid <= tileset_lua.firstgid+tileset_lua.tilecount)
      ) then

        -- vertex position, these are the 4 corners of this single tile as it appears in the larger AMV
        local p = {
          -- x,                               y,                                            z
          { (i%mapwidth)*tilewidth,           math.floor(i/mapwidth)*tileheight,            1 },
          { (i%mapwidth)*tilewidth+tilewidth, math.floor(i/mapwidth)*tileheight,            1 },
          { (i%mapwidth)*tilewidth+tilewidth, math.floor(i/mapwidth)*tileheight+tileheight, 1 },
          { (i%mapwidth)*tilewidth,           math.floor(i/mapwidth)*tileheight+tileheight, 1 }
        }

        -- subtract this tileset's firstgid from this tile's gid so that the tileset's gids count up
        -- from 0 (instead of from firstgid) for the sake of finding finding a particular tile's coordinates
        -- within the texture
        tile_gid = tile_gid - tileset_lua.firstgid

        -- texture coordinates, these are the 4 corners of the specific section of the overall tileset texture
        -- we want drawn at this spot in this AMV
        local t = {
          -- tx, ty
          {scale(((tile_gid%tileset_lua.columns)+0)*tilewidth, 0, tileset_lua.imagewidth, 0, 1),  scale((math.floor(tile_gid/tileset_lua.columns)+0)*tileheight, 0, tileset_lua.imageheight, 0, 1) },
          {scale(((tile_gid%tileset_lua.columns)+1)*tilewidth, 0, tileset_lua.imagewidth, 0, 1),  scale((math.floor(tile_gid/tileset_lua.columns)+0)*tileheight, 0, tileset_lua.imageheight, 0, 1) },
          {scale(((tile_gid%tileset_lua.columns)+1)*tilewidth, 0, tileset_lua.imagewidth, 0, 1),  scale((math.floor(tile_gid/tileset_lua.columns)+1)*tileheight, 0, tileset_lua.imageheight, 0, 1) },
          {scale(((tile_gid%tileset_lua.columns)+0)*tilewidth, 0, tileset_lua.imagewidth, 0, 1),  scale((math.floor(tile_gid/tileset_lua.columns)+1)*tileheight, 0, tileset_lua.imageheight, 0, 1) },
        }

        table.insert(verts, {p[1], c, t[1]})
        table.insert(verts, {p[2], c, t[2]})
        table.insert(verts, {p[3], c, t[3]})
        table.insert(verts, {p[4], c, t[4]})
      end
    end
    -- -----------------------------------------------------------------------
    -- for debugging
    row_str = row_str .. "\n"
    -- -----------------------------------------------------------------------
  end

  -- -----------------------------------------------------------------------
  -- for debugging
  -- if layer_lua.name == "Ground" then
  --    SM(row_str)
  -- end
  -- -----------------------------------------------------------------------

  return verts
end

-- -----------------------------------------------------------------------

local af = Def.ActorFrame{}

-- zoom the map and the player some amount
af.InitCommand=function(self)
  self:zoom(g.map.zoom)
  self:SetDrawByZPosition(false):visible(false)
end

af.MoveMapCommand=function(self)
  local MapCenter = FindCenterOfMap()

  local x = -(MapCenter.right * map_data.tilewidth  * g.map.zoom - _screen.w/2)
  local y = -(MapCenter.down  * map_data.tileheight * g.map.zoom - _screen.h/2)

  self:GetParent():xy(x,y)
end

-- ----------------------------------------------------------------------------

for tileset_index, tileset_info in ipairs(map_data.tilesets) do

  -- When creating a new tileset in Tiled, there's a checkbox for "embed in map".
  -- If checked, the Lua for that tileset will appear directly in the main Lua
  -- table for the overall map. The "tilesets" key will be an array of tables for
  -- embedded tilesets.  For purposes here, that just works as-is.  We don't need
  -- to do anything more.
  --
  -- If left unchecked, Tiled will create a dedicated .tsx file for the tileset,
  -- which can also be exported to Lua, and *that* lua file will contain most
  -- (but not all!) of the data we need.
  -- The main Lua table for the overall map will have an incomplete entry
  -- in `tilesets`, containing only name, firstgid, and filename.
  -- `filename` is a path to the tsx file.
  -- This tilemapping system assumes that you have exported a .lua file from
  -- that .tsx file and that the tsx file and the exported lua file have the
  -- same name.

  -- if a .lua file for this tilemap was exported from a standalone .tsx file
  if tileset_info.filename ~= nil then
    local path = ("%smap_data/%s.lua"):format(song_dir, tileset_info.name)

    -- check if lua file was exported from Tiled
    if FILEMAN:DoesFileExist(path) then
      local name = tileset_info.name
      local firstgid = tileset_info.firstgid

      -- Get the contents of that lua file and merge the `name` and `firstgid`
      -- properties into it.  With that, we'll have a complete lua representation
      -- of that tileset.
      map_data.tilesets[tileset_index]          = dofile( ("%smap_data/%s.lua"):format(song_dir, tileset_info.name) )
      map_data.tilesets[tileset_index].name     = name
      map_data.tilesets[tileset_index].firstgid = firstgid

    -- if no corresponding lua file was found, emit an Error to StepMania
    else
      lua.ReportScriptError("\nNo corresponding .lua file was found for tileset \""..tileset_info.filename.."\"\nYou'll need to export one from Tiled.\n")
    end
  end

  -- otherwise, the lua table for this tileset was embedded in main map export file
  -- and we don't need to do any more work here to handle it
end

-- ----------------------------------------------------------------------------
-- helper function for debugging tables

local PrintKeys = function(tbl)
  local t = {}
  for k,v in pairs(tbl) do
    table.insert(t, k)
  end
  SM(t)
end

-- PrintKeys(tileset_luas)
-- ----------------------------------------------------------------------------


-- ----------------------------------------------------------------------------
-- time for a big ol' function that probably contains too much discrete work
-- and should be broken into smaller functions Someday™


local layer_index = 0

local HandleLayers
HandleLayer = function(layer)

  -- recurse as needed for layers from Tiled nested in groups
  if layer.type == "group" then
    for child_layer in ivalues(layer.layers) do
      HandleLayer(child_layer)
    end

  else
    -- we're using layer_index for z-indexing so layers draw "on top of"
    -- and "underneath" one another correctly.
    -- We should only increment layer_index for layers that aren't "group".
    -- "group" layers are just containers in Tiled; they have no tiledata to draw.
    layer_index = layer_index + 1
  end



  -- Whis tilemapping engine assumes that there is exactly 1 tile layer in Tiled
  -- named "Collision" or "collision".
  -- We won't draw this layer in StepMania, but we will interpret ANY non-0 tiles
  -- in it as "this tile is impassable."
  --
  -- I've found it's easiest to make a simple tileset with just a 32x32 red square
  -- and use that red square on the collision layer in Tiled to easily see where
  -- the player can and cannot walk.
  if layer.name:lower() == "collision" then
    -- find the collision data layer now and add it to the g table
    -- we'll want to refer to it from within a few different files
    g.collision_layer[map_index] = layer


  -- this is a tiled layer that must be created using an AMV
  elseif layer.type == "tilelayer" and layer.visible and (layer.name:lower() ~= "collision") then

    -- what tileset textures will be needed for this layer?
    -- let's figure that out now
    local tilesets_needed = {}

    -- loop through each gid in this layer's `data` table
    -- and determine which tileset is needed to represent it

    for i, gid in ipairs(layer.data) do

      for tileset_index, tileset_lua in ipairs(map_data.tilesets) do

        if not tileset_lua.tilecount then
          local err = ("\ntileset \"%s\" doesn't have a 'tilecount' property in its Lua table; it was probably exported from Tiled incorrectly.  You should check it.\n"):format(tileset_lua.name)
          lua.ReportScriptError(err)
          break
        end

        local firstgid = tileset_lua.firstgid
        local lastgid  = firstgid + tileset_lua.tilecount

        if (gid >= firstgid) and (gid <= lastgid) then

          -- if the tileset needed to draw this gid has not already
          -- been accounted for in tilesets_needed, add it
          if not FindInTable(tileset_lua.name, tilesets_needed) then
            table.insert(tilesets_needed, tileset_lua.name)
          end

          -- break from the (for tileset_data in ivalues(map_data.tilesets)) loop
          -- and move onto checking what tileset is needed to draw the next gid
          break
        end
      end
    end

    -- ----------------------------------------------------------------------------

    -- At this point, we should know how many tilesets are needed to draw this layer.
    -- Since AMVs in StepMania are limited to using a single texture,
    -- we'll need: 1 AMV per tileset_needed per Tiled layer.
    --
    -- as an example:
    -- a .lua file exported from Tiled might have 3 tile layers: "under", "under2", and "over"
    -- maybe the artist arranging these RPG maps in Tiled used:
    --    • 4 unique RPG Maker tilesets for "under"
    --    • 1 unique RPG Maker tileset  for "under2"
    --    • 2 unique RPG Maker tilesets for "over"
    --
    -- In StepMania, we'll need:
    --    • 4 AMVs for under
    --    • 1 AMV  for under2
    --    • 2 AMVs for over
    -- and each AMV will need to be passed the appropriate `path_to_texture`
    --
    -- The artist might have loaded additional tilesets into Tiled but not used any
    -- tiles from them.  They'll be ignored here; that's fine.
    --
    -- The artist might have only loaded 4 tilesets into Tiled, and used them across the 3 layers.
    -- We'll still need to handle (4+1+2) AMVs in StepMania.  This SM5 tilemapping engine is
    -- 1 AMV per tileset_needed per Tiled layer.
    --
    -- More efficient systems may exist, but this is not that.

    for tileset_name in ivalues(tilesets_needed) do

      local tileset_lua
      for tileset_index, _tileset_lua in ipairs(map_data.tilesets) do
        if tileset_name == _tileset_lua.name then
          tileset_lua = _tileset_lua
          break
        end
      end

      local path_to_texture = ("%smap_data/%s"):format(song_dir, tileset_lua.image)

      af[#af+1] = Def.ActorMultiVertex{
        InitCommand=function(self)
          self:SetDrawState( {Mode="DrawMode_Quads"} )
          self:LoadTexture( path_to_texture )
          self:SetTextureFiltering( false )
        end,
        MoveMapCommand=function(self)
          local layer_verts = GetLayerVerts(layer, tileset_lua)
          self:SetVertices( layer_verts ):z( layer_index )
        end
      }
    end



  -- for "Texture" layers, add a texture
  -- these can be semi-transparent fogs that slowly scroll over the entire map
  -- like in the endgame of UPSRT1
  -- or scrolling water effects that make a river look like it is flowing
  -- like in Your Drifting Mind
  --
  -- In this tilemapping engine, we support a few custom properties in Tiled
  -- for layers with name "Texture", specifically:
  --          vx:  (scroll velocity x) a float between 0 and 1
  --          vy:  (scroll velocity y) a float between 0 and 1
  --       alpha:  a float between 0 and 1
  --     Texture:  string, a path to the png file
  --
  -- these^ are all optional
  elseif layer.name:lower() == "texture" then

    local obj = layer.objects[1]

    if not obj.properties.Parallax then
      if obj.properties.Texture or obj.properties.texture  then
        af[#af+1] = LoadActor(obj.properties.Texture or obj.properties.texture)..{
          InitCommand=function(self)
            local img = {
              h = self:GetTexture():GetImageHeight(),
              w = self:GetTexture():GetImageWidth(),
            }

                               -- left   top               right              bottom
            self:customtexturerect(  0,    0,    obj.width/img.w,   obj.height/img.h)
              :texcoordvelocity(obj.properties.vx or 0, obj.properties.vy or 0)
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


  elseif layer.name:lower() == "playerlayer" then

    -- Player sprite has enough logic that it gets its own Lua file
    af[#af+1] = LoadActor("./Player/player_sprite.lua", {g, map_data, layer, layer_index, map_index})


  elseif layer.name:lower() == "npc" then
    for event in ivalues(layer.objects) do
      local tile_num

      -- if an object from Tiled has a gid, we need to subtract 1 tile unit from the y position of this event
      if event.gid then
        tile_num = ((event.y/map_data.tileheight)-1) * map_data.width + (event.x/map_data.tilewidth) + 1
      else
      -- otherwise, if the object does not have a tile associated with it...
        tile_num = ((event.y/map_data.tileheight)) * map_data.width + (event.x/map_data.tilewidth) + 1
      end
      -- set NPCs data
      g.NPCs[map_index][tile_num] = event
      af[#af+1] = LoadActor("./Sprites/NPCs/npc_sprites.lua", {g, map_data, layer, layer_index, map_index, event})
    end


  -- layers with name "dynamic audio" can be used to create areas on the map
  -- that play audio that becomes louder as the player gets closer to it
  -- for example, nellie the cat getting closer to the pianos in
  -- https://twitter.com/quietly_turning/status/1440145345128763404
  elseif layer.name:lower() == "dynamic audio" then
    for obj in ivalues(layer.objects) do
      g.DynamicAudio[obj.properties.File] = {x=obj.x, y=obj.y}
    end

  elseif layer.name:lower() == "interactive events" or layer.name:lower() == "events" then

    for event in ivalues(layer.objects) do
      local tile_num

      -- if an object from Tiled has a gid, we need to subtract 1 tile unit from the y position of this event
      -- TODO: fix this to work with multiple tilesets
      if event.gid then

        -- local tile_num = ((event.y/map_data.tileheight)-1) * map_data.width + (event.x/map_data.tilewidth) + 1
        -- -- add the data for this event-with-a-visual-tile to the global Events table
        -- g.Events[map_index][tile_num] = event
        -- -- add a Sprite to draw the desired tile for this event
        -- af[#af+1] = Def.Sprite{
        --   Texture=path_to_texture,
        --   InitCommand=function(self)
        --     self:animate(false)
        --       :align(0,0)
        --       :x(event.x)
        --       :y(event.y-map_data.tileheight)
        --       :z(layer_index)
        --       :setstate(event.gid-1)
        --       :SetTextureFiltering( false )
        --   end,
        -- }


      -- otherwise, if the object does not have a tile associated with it
      else
        -- figure out how many tilerows and tilecols this event covers
        local num_cols = math.ceil(event.width/map_data.tilewidth) - 1
        local num_rows = math.ceil(event.height/map_data.tileheight) - 1

        -- figure out the row and col this event starts on
        --
        -- example:  ForkingPath is 40 tiles wide and 52 tile high
        --   and thus has (40*52=2080) spots in the grid for tiles.
        --   The event for "Dialogue 3" might have
        --   a pixel width of 448, a pixel height of 256
        --   and a pixel xy of 416, 96.
        --   Finally, the map uses tiles that are 32x32 pixels.
        --
        --   For "Dialogue 3", we can calculate that:
        --     the starting row is (96/32)  = 3
        --     the starting col is (416/32) = 13
        --
        --   We can use 3 and 13 as for-loop bounds and add as many "event tiles" to
        --   g.Events as are needed to cover this event object from Tiled.
        local start_row = math.floor(event.y/map_data.tileheight)
        local start_col = math.floor(event.x/map_data.tilewidth)

        -- add as many Event tiles to g.Events as are needed to cover this event
        for row=start_row, start_row+num_rows do
          for col=start_col, start_col+num_cols do
            local tile_num = col + (row*map_data.width) + 1
            g.Events[map_index][tile_num] = event
          end
        end

      end
    end
  end
end

-- ----------------------------------------------------------------------------
-- Loop through the layers exported from the Tiled app, and add either an AMV or a Sprite for each.
-- The order (or, sequence) of these layers in the Tiled app matters.  Layers that are listed "higher up"
-- in Tiled's layer sidebar will draw "on top of" layers that are lower down in the list.
--
-- With this in mind, Tiled projects should be structured something like:
--
--   "collision" layer
--   some layer that should draw over the player and NPCs
--   another layer that should draw over the player and NPCs
--   player
--   NPCs
--   some layer that should draw under the player and NPCs
--   another layer that should draw under the player and NPCs
--
-- The "collision" layer is one exception to the idea that "sequence matters."  It isn't
-- drawn in StepMania; we only need data from it.

for layer in ivalues(map_data.layers) do
  HandleLayer(layer)
end

return af
