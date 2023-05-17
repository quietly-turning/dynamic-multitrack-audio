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
g.SleepDuration = 0.2

g.map = {
  af = nil,
  zoom = 2
}
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
  local screen = SCREENMAN:GetTopScreen()
  for name,layer in pairs(screen:GetChildren()) do
    if  name ~= "SongForeground" then
      layer:sleep(1):visible(false)
    end
  end

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