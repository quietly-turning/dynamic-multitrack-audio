
local files = { "gentle_wind1.ogg", "gentle_wind2.ogg", "strings.ogg" }
local song_dir = GAMESTATE:GetCurrentSong():GetSongDir()
local startTime = GetTimeSinceStart()
local uptime
local tilesize = 32

local sounds = {}
local durations = {}
local cycles = {}

-- only used once
local audio_fadein_secs = 30


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
  self:SetUpdateFunction(update)
end

-- --------------------------------------

for file in ivalues(files) do

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
      self:stop():play()
      cycles[file] = GetTimeSinceStart() - startTime
    end,
    AdjustVolumeCommand=function(self)
      local max_volume = uptime < audio_fadein_secs and uptime/audio_fadein_secs or 1
      self:get():volume(max_volume)
    end,
  }

end

return af