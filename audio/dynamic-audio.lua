local g = ...
local playerPos

local song_dir = GAMESTATE:GetCurrentSong():GetSongDir()
local startTime = GetTimeSinceStart()
local uptime
local tilesize = 32

local sounds = {}
local durations = {}
local cycles = {}

-- only used once
local audio_fadein_secs = 10

local update = function(af, dt)
  uptime = GetTimeSinceStart() - startTime

  for name, sound in pairs(sounds) do
    if uptime - cycles[name] >= durations[name] then
      sound:playcommand("Loop")
    end

    sound:playcommand("AdjustVolume")
  end
end



-- --------------------------------------

local af = Def.ActorFrame{}

af.InitCommand=function(self)
  playerPos = g.Player[g.CurrentMap].pos
  self:SetUpdateFunction(update)
end

-- --------------------------------------

for file, v in pairs(g.DynamicAudio) do

  af[#af+1] = Def.Sound{
    File=song_dir .. "audio/" .. file,
    InitCommand=function(self)
      sounds[file] = self
      self:get():volume(0)
    end,
    OnCommand=function(self)
      durations[file] = self:get():get_length()
      self:stop():play()
      cycles[file] = GetTimeSinceStart() - startTime
    end,
    LoopCommand=function(self)
      self:play()
      cycles[file] = GetTimeSinceStart() - startTime
    end,
    AdjustVolumeCommand=function(self)
      local px_distance = math.pow(math.pow(playerPos.x*tilesize - v.x, 2) + math.pow(playerPos.y*tilesize - v.y, 2), 0.5)
      local max_volume = uptime < audio_fadein_secs and uptime/audio_fadein_secs or 1
      self:get():volume( scale(px_distance, 0, 475, max_volume, 0) )
    end,
  }

end

return af