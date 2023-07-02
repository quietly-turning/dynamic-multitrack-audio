-- simple dynamic audio experiment

-- ----------------------------------------------------------------------------
-- make an effort to namespace the many things we'll want to be
-- passing around our many files
local g = {}

-- filenames that correspond to lua exported from Tiled
g.maps = { "audio-experiment" }
g.CurrentMap = 1
g.collision_layer = {}

g.InputIsLocked = false
g.SleepDuration = 0.15

g.map = {
  af = nil,
  unscaled_zoom = 1.25
}
g.map.zoom = g.map.unscaled_zoom * (_screen.w/854)

g.Dialog = {
  Speaker = "nellie"
}

g.NPCs = {}
g.SeenEvents = {}
g.Events = {}
g.Player = {}
g.DynamicAudio = {}

g.TimeAtStart = GetTimeSinceStart()
g.RunTime = function() return GetTimeSinceStart() - g.TimeAtStart end

-- ----------------------------------------------------------------------------
-- helper functions

-- iterates over a numerically-indexed table (haystack) until a desired value (needle) is found
-- if found, return the index (number) of the desired value within the table
-- if not found, return nil
g.FindInTable = function(needle, haystack)
	for i = 1, #haystack do
		if needle == haystack[i] then
			return i
		end
	end
	return nil
end

-- TableToString() function via:
-- http://www.hpelbers.org/lua/print_r
-- Copyright 2009: hans@hpelbers.org
local TableToString = function(t, name, indent)
	local tableList = {}
	local table_r

	table_r = function(t, name, indent, full)
		local id = not full and name or type(name)~="number" and tostring(name) or '['..name..']'
		local tag = indent .. id .. ' = '
		local out = {}	-- result

		if type(t) == "table" then
			if tableList[t] ~= nil then
				table.insert(out, tag .. '{} -- ' .. tableList[t] .. ' (self reference)')
			else
				tableList[t]= full and (full .. '.' .. id) or id
				if next(t) then -- Table not empty
					table.insert(out, tag .. '{')
					for key,value in pairs(t) do
						table.insert(out,table_r(value,key,indent .. '|    ',tableList[t]))
					end
					table.insert(out,indent .. '}')
				else
					table.insert(out,tag .. '{}')
				end
			end
		else
			local val = type(t)~="number" and type(t)~="boolean" and '"'..tostring(t)..'"' or tostring(t)
			table.insert(out, tag .. val)
		end

		return table.concat(out, '\n')
	end

	return table_r(t,name or 'Value',indent or '')
end

g.SM = function( arg, duration )
	local msg

	-- if a table has been passed in, recursively stringify the table's keys and values
	if type( arg ) == "table" then
		msg = TableToString(arg)
	-- otherwise, Lua's standard tostring() should suffice
	else
		msg = tostring(arg)
	end

	MESSAGEMAN:Broadcast("SystemMessage", {Message=msg, Duration=duration})
	Trace(msg)
end

local OnlyShowFG = function()
  local screen = SCREENMAN:GetTopScreen()
  if not screen then
     lua.ReportScriptError("OnlyShowFG() failed to run because there is no Screen yet.")
     return nil
  end

  local layers = screen:GetChildren()

  for name,layer in pairs(layers) do
     if name ~= "SongForeground" then
        layer:visible(false)
     end
  end
end

-- ----------------------------------------------------------------------------

local map_data = {}
for i,map in ipairs(g.maps) do map_data[i] = LoadActor("./map_data/" .. map .. ".lua") end

-- map_af needs to be loaded prior to audio_af
-- so that we can position Def.Sound actors appropriately on the map
local visuals_af = LoadActor("./VisualsActorFrame.lua", {g, map_data})
local audio_af   = LoadActor("./audio/dynamic-audio.lua", g)
local dialog_box = LoadActor("./DialogBox/dialog_box.lua", {g})
local normal_audio_af = LoadActor("./audio/normal-audio.lua", g)

-- ----------------------------------------------------------------------------

local af = Def.ActorFrame{}
af.OnCommand=function(self)
  OnlyShowFG()

  SCREENMAN:set_input_redirected(PLAYER_1, true)
  SCREENMAN:set_input_redirected(PLAYER_2, true)
end
af.OffCommand=function(self)
  -- return input handling back to the engine
  SCREENMAN:set_input_redirected(PLAYER_1, false)
  SCREENMAN:set_input_redirected(PLAYER_2, false)
end

-- ----------------------------------------------------------------------------
-- keep alive
af[#af+1] = Def.Actor{ InitCommand=function(self) self:sleep(999) end }

-- ----------------------------------------------------------------------------
af[#af+1] = visuals_af
af[#af+1] = dialog_box
af[#af+1] = audio_af
af[#af+1] = normal_audio_af

-- ----------------------------------------------------------------------------
-- Quad used to fade to black while transitioning between maps
af[#af+1] = Def.Quad{
  InitCommand=function(self) self:diffuse(0,0,0,1):FullScreen():Center(); g.SceneFade = self end,
  OnCommand=function(self) self:queuecommand("InitialReveal") end,
  InitialRevealCommand=function(self)
    self:smooth(1):diffusealpha(0)
  end,
  FadeToBlackCommand=function(self)
    g.InputIsLocked = true
    self:smooth(0.5):diffusealpha(1):queuecommand("ChangeMap")
  end,
  FadeToClearCommand=function(self)
    g.InputIsLocked = false
    self:smooth(0.5):diffusealpha(0)
  end,
  ChangeMapCommand=function(self)
    local facing = g.Player[g.CurrentMap].dir
    local visuals_af = self:GetParent():GetChild("VisualsActorFrame")

    -- don't draw the old map
    visuals_af:GetChild("Map"..g.CurrentMap):visible(false)

    -- update CurrentMap index
    g.CurrentMap = g.next_map.index
    -- maintain the direction the player was last facing when transferring maps
    g.Player[g.CurrentMap].dir = facing

    -- call InitCommand on the player Sprite for this map, passing in starting position data specified in Tiled
    g.Player[g.CurrentMap].actor:playcommand("Init", {x=g.next_map.x, y=g.next_map.y} )

    -- reset this (just in case?)
    g.next_map = nil

    -- start drawing the new map and update its position if needed
    visuals_af:GetChild("Map"..g.CurrentMap):visible(true):playcommand("MoveMap")

    self:queuecommand("FadeToClear")
  end
}

return af