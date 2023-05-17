local args = ...
local g = args[1]


local characters = {
  -- default values
  defaults = {
    img = nil,
    img_zoom = 1,
    box_color = "FFFFFF",
    namebox_color = "#995544",
    font = "Work Sans Medium",
    font_color = "#000000",
    font_zoom = 0.95,
    name_color = "#FFFFFF"
  },

  -- events from Tiled that we want some amount of dialogue_box customization for
  -- the keys here (for example: Window, ["Little Matt"], Richard) will match up with
  -- the "speaker" custom property from Tiled, for example:
  --        speaker1: Tejas
  --        speaker2: Little Matt
  --        speaker3: The Sound of The Wind
  --
  -- both Tejas and ["Little Matt"] are keys in this characters table;
  --    their dialogue boxes will be styled using the info here
  -- but ["The Sound of the Wind"] does not have a key here,
  --    so that dialoge will be styled using all defaults

  -- Window = {
  --   img = "Window",
  --   img_zoom = 0.235,
  -- },
  -- Archi = {
  --   img = "Archi",
  --   img_zoom = 0.235,
  --   font = "Founders Grotesk Regular",
  --   namebox_color = "#0F8F0F"
  -- },
  -- ["Mad Matt"] = {
  --   img = "Mad Matt",
  --   img_zoom = 0.235,
  --   font = "Avenir",
  --   namebox_color = "#BB0909"
  -- },
  -- Richard = {
  --   img = "SteveReen",
  --   img_zoom = 0.235,
  --   namebox_color = "#536CB5",
  -- },
  nellie = {
    img = "nellie",
    img_zoom = 0.5,
    namebox_color = "#374151",
    font_zoom = 0.825,
  },
  quietly = {
    img = "quietly",
    img_zoom = 0.3,
    box_color = "#1D1D1D",
    namebox_color = "#111111",
    name_color = "#AA5588",
    font = "Dank Mono Italic",
    font_zoom = 0.825,
    font_color = "#AA5588"
  },
}

-- Sometimes we want to style a dialogue box with color and font
-- but not reveal the character's name, as though we can hear them
-- but not yet see them.  To achieve this, create a "HideNames" Boolean
-- for the event in Tiled.
-- When showing that dialogue, show the player this string instead of the name.
local hidden_name = "???"

-- ---------------------------------------------------

-- helper function
-- accepts a key/value table
-- returns the just keys in an array
local KeysToArray = function(tbl)
  local t = {}
  for k,v in pairs(tbl) do
    table.insert(t, k)
  end
  return t
end

-- get a list of characters to compare against
-- so that if an event doesn't appear in this list,
-- we can use all fallback values for styling the dialogue box.
local characterKeys = KeysToArray(characters)

-- ---------------------------------------------------

local af = Def.ActorFrame{
  InitCommand=function(self)
    self:visible(false):diffusealpha(0)
      :xy(_screen.cx, _screen.h-64)
    g.Dialog.ActorFrame = self
  end,
  ShowCommand=function(self)
    self:visible(true):linear(0.333):diffusealpha(1)
  end,
  HideCommand=function(self)
    g.Dialog.Index = 1
    g.Dialog.BoxColor = nil
    g.DialogIsActive = false
    self:visible(false)
  end,
}

af[#af+1] = LoadActor("./box.png")..{
  InitCommand=function(self) self:zoom(0.245) end,
  ShowCommand=function(self)
    local speaker = g.Dialog.Speakers[g.Dialog.Index]
    if characters[speaker] and characters[speaker].box_color then
      self:diffuse(color(characters[speaker].box_color))
    else
      self:diffuse(color(characters.defaults.box_color))
    end
  end
}

-- the speaker's name and name box
af[#af+1] = Def.ActorFrame{
  Name="NameBoxAF",
  InitCommand=function(self)
    self:xy(-250,-56)
  end,
  ShowCommand=function(self)
    local speaker = g.Dialog.Speakers[g.Dialog.Index]
    self:visible(speaker ~= nil)
  end,

  -- name box stroke
  Def.Quad{
    Name="Stroke",
    InitCommand=function(self)
      self:zoomto(104,36):diffuse(0.15,0.15,0.15,1)
    end
  },
  -- name box
  Def.Quad{
    Name="Box",
    InitCommand=function(self)
      self:zoomto(100,32)
    end,
    ShowCommand=function(self)
      local speaker = g.Dialog.Speakers[g.Dialog.Index]
      if characters[speaker] and characters[speaker].namebox_color then
        self:diffuse(color(characters[speaker].namebox_color))
      else
        self:diffuse(color(characters.defaults.namebox_color))
      end
    end,
    HideCommand=function(self)
      self:diffuse(color(characters.defaults.namebox_color))
    end
  },

  -- BMT for the speaker's name
  LoadFont("Common Normal")..{
    Text=g.Dialog.Speaker[g.Dialog.Index],
    InitCommand=function(self) self:zoom(1.1) end,
    ShowCommand=function(self)
      if g.Dialog.Speakers[g.Dialog.Index] then
        if g.Dialog.HideNames then
          self:settext( hidden_name ):diffuse(1,1,1,1)
        else
          local speaker = g.Dialog.Speakers[g.Dialog.Index]
          if characters[speaker] and characters[speaker].name_color then
            self:diffuse(color(characters[speaker].name_color))
          else
            self:diffuse(color(characters.defaults.name_color))
          end
          self:settext(g.Dialog.Speakers[g.Dialog.Index])
        end
      end
    end,
    HideCommand=function(self) self:settext("") end
  }
}

local path = GAMESTATE:GetCurrentSong():GetSongDir() .. "fonts/20px fonts/"

for k,character in pairs(characters) do

  --custom font BMT for the words the speaker is saying
  af[#af+1] = Def.BitmapText{
    File=("%s%s/_%s 20px.ini"):format(path, (character.font or characters.defaults.font), (character.font or characters.defaults.font):lower()),

    InitCommand=function(self)
      self:cropright(1):zoom(character.font_zoom or characters.defaults.font_zoom)
    end,
    OnCommand=function(self)
      self:align(0,0):xy(-200, -30)
        :diffuse(color(character.font_color or characters.defaults.font_color))
        :wrapwidthpixels(480/self:GetZoom())
    end,
    ShowCommand=function(self, params)
      local speaker = g.Dialog.Speakers[g.Dialog.Index]

      if FindInTable(speaker, characterKeys) then
        self:visible(k == speaker)
      else
        self:visible(k == "defaults")
      end
    end,

    ClearTextCommand=function(self)
      self:settext(""):cropright(1)
    end,
    UpdateTextCommand=function(self)
      g.Dialog.IsTweening = true

      if g.Dialog.Words[g.Dialog.Index] then
        self:settext( g.Dialog.Words[g.Dialog.Index] )
          :linear(0.75):cropright(0):queuecommand("FinishUpdateText")
          DiffuseEmojis(self)
      else
        self:queuecommand("ClearText")
      end
    end,
    FinishUpdateTextCommand=function(self) g.Dialog.IsTweening = false end
  }


  -- character portrait / facial expressions
  if character.img then
    af[#af+1] = LoadActor("./"..character.img)..{
      InitCommand=function(self)
        self:zoom(character.img_zoom or characters.defaults.img_zoom):align(0.5, 1):visible(false):xy(-250, 42)
      end,
      ShowCommand=function(self, params)
        self:visible(g.Dialog.Speakers[g.Dialog.Index] == k and not g.Dialog.HideNames)
      end
    }
  end
end

return af