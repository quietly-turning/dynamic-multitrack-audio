local args = ...
local g = args[1]
local map_data = args[2]
local layer_data = args[3]
local layer_index = args[4]
local map_index = args[5]
local event = args[6]

local SleepDuration = g.SleepDuration
local pos = { x=nil, y=nil }


local npc = {
  file = event.name,
  name = event.name,
  dir = event.properties.dir and event.properties.dir or "Down",
  tweening = false,
  zoom = event.properties.zoom and event.properties.zoom or 1,
  state = 0,
  input = {
    Active    = nil,
    Up        = false,
    Down      = false,
    Left      = false,
    Right     = false,
    MenuRight = false,
    MenuLeft  = false,
    Start     = false,
    Select    = false,
  },
  NextTile = {
    Up=function()    return (pos.y-1) * map_data.width + (pos.x+1) end,
    Down=function()  return (pos.y+1) * map_data.width + (pos.x+1) end,
    Left=function()  return  pos.y    * map_data.width + pos.x     end,
    Right=function() return  pos.y    * map_data.width + (pos.x+2) end,
  },
}

local OppositeDir = {
  Left="Right",
  Right="Left",
  Up="Down",
  Down="Up"
}

local frames = {
  Down = {
    { Frame=0,  Delay=SleepDuration}
  },
  Left = {
    { Frame=1,  Delay=SleepDuration}
  },
  Right = {
    { Frame=2,  Delay=SleepDuration}
  },
  Up = {
    { Frame=3,  Delay=SleepDuration}
  }
}

local WillBeOffMap = {
  Up=function()    return pos.y < 1                 end,
  Down=function()  return pos.y > map_data.height-2 end,
  Left=function()  return pos.x < 1                 end,
  Right=function() return pos.x > map_data.width-2  end,
}

local UpdatePosition = function()
  -- Increment/Decrement the value as needed first
  if g.NPCs[map_index][npc.name].dir == "Up" then
    pos.y = pos.y - 1

  elseif g.NPCs[map_index][npc.name].dir == "Down" then
    pos.y = pos.y + 1

  elseif g.NPCs[map_index][npc.name].dir == "Left" then
    pos.x = pos.x - 1

  elseif g.NPCs[map_index][npc.name].dir == "Right" then
    pos.x = pos.x + 1
  end
end

return Def.Sprite{
  Texture="./Sprites/NPCs/" .. npc.file,
  InitCommand=function(self)
    if event.x and event.y then
      pos.x = event.x
      pos.y = event.y
    else
      pos.x = layer_data.objects[1].x/map_data.tilewidth
      pos.y = layer_data.objects[1].y/map_data.tileheight
    end
    self:animate(false)
    -- align to left and v-middle
      :align(0, 0.5)
    -- initialize the position
      :xy(event.x, event.y)
    -- initialize the sprite state
      :zoom(npc.zoom)
      :SetStateProperties( frames[npc.dir] )
      :setstate(npc.state)
      :SetTextureFiltering(false)
      
      -- add a reference to the NPC Sprite actor, keyed by the NPC's name
      -- we can use this for lookup in InputHandler.lua for "TurnToFacePlayer"
      g.NPCs[map_index][npc.name] = self
  end,
  UpdateSpriteFramesCommand=function(self)
    if npc.dir then
      self:SetStateProperties( frames[npc.dir]):setstate(npc.state)
    end
  end,
  TurnToFacePlayerCommand=function(self)
    npc.dir = OppositeDir[ g.Player[g.CurrentMap].dir ]
    self:queuecommand("UpdateSpriteFrames")
  end,
  TurnRightCommand=function(self)
    npc.dir = "Right"
    self:queuecommand("UpdateSpriteFrames")
  end,
  AnimationOnCommand=function(self)
    self:animate(true)
  end,
  AnimationOffCommand=function(self)
    self:animate(false):setstate(1)
  end,
  TweenCommand=function(self)
    -- collision check the impending tile
    if not WillCollide() and not WillBeOffMap[npc.dir]() then

      -- this does a good job of mitigating tween overflows resulting from button mashing
      -- self:stoptweening()
      npc.tweening = true

      -- we *probably* want to update the npc's map position
      -- UpdatePosition() does just that, if we should
      UpdatePosition()

      self:playcommand("AnimationOn")
        :linear(SleepDuration)
        :x(pos.x * map_data.tilewidth)
        :y(pos.y * map_data.tileheight)
        :z( layer_index )

      self:queuecommand("MaybeTweenAgain")
    end
  end,
  MaybeTweenAgainCommand=function(self)
    npc.tweening = false

    if npc.dir and npc.input[ npc.dir ] then
      self:playcommand("Tween")
    else
      self:stoptweening():queuecommand("AnimationOff")
    end
  end,
  AttemptToTweenCommand=function(self, params)

    -- Does the npc sprite's current direction match the direction
    -- we were just passed from the input handler?
    if npc.dir ~= params.dir then

      -- if not, update it
      npc.dir = params.dir
      -- and update the sprite's frames appropriately
      self:queuecommand("UpdateSpriteFrames")
    end

    -- don't allow us to go off the map
    if npc.dir and npc.input[ npc.dir ] and not npc.tweening then

      self:playcommand("AnimationOn")

      -- tween the npc sprite
      self:playcommand("Tween")
    end
  end
}