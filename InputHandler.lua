local args = ...
local map_data = args[1]
local g = args[2]
local _start = { duration = 0, begin_time = 0 }

local PlayerIsFacingDirectionToTransfer = {
  Left = function(next_tile)
    return next_tile % map_data[g.CurrentMap].width == 1
  end,
  Right = function(next_tile)
    return next_tile % map_data[g.CurrentMap].width == 0
  end,
  Up = function(next_tile)
    return next_tile <= map_data[g.CurrentMap].width
  end,
  Down = function(next_tile)
    return next_tile > (map_data[g.CurrentMap].width * map_data[g.CurrentMap].height - map_data[g.CurrentMap].width)
  end,
}

local InitDialog = function(event)
  -- if we're only supposed to trigger this dialog once, and we've already done so, just return now
  if event.properties.seen and g.SeenEvents[event.properties.seen] then return end

  g.Dialog.Index = 1
  g.Dialog.Words = { event.properties.text }
  g.Dialog.Faces = { event.properties.img }
  g.Dialog.Speakers = {}
  g.Dialog.HideNames = event.properties.HideNames or false

  if event.properties.text2 then
    local i = 2
    while event.properties["text"..i] do
      table.insert(g.Dialog.Words, event.properties["text"..i])
      i = i + 1
    end
  end

  if event.properties.img2 then
    local i = 2
    while event.properties["text"..i] do
      table.insert(g.Dialog.Faces, event.properties["img"..i])
      i = i + 1
    end
  end

  if event.properties.speaker1 then
		g.Dialog.Speaker = event.properties.speaker1
		table.insert(g.Dialog.Speakers, event.properties.speaker1)
		local i = 2
		while event.properties["text"..i] do
			if event.properties["speaker"..i] then
				table.insert(g.Dialog.Speakers, event.properties["speaker"..i])
				g.Dialog.Speaker = event.properties["speaker"..i]
			else
				table.insert(g.Dialog.Speakers, g.Dialog.Speaker)
			end
			i = i + 1
		end
	end

  -- handle the case of dialog that we only want to trigger once ever
  if event.properties.seen then g.SeenEvents[event.properties.seen] = true end

  g.Dialog.ActorFrame:playcommand("UpdateText"):playcommand("Show")
  g.DialogIsActive = true
end

-- walk over a tile to trigger an event
g.TouchHandler = function(next_tile)
  local event = g.Events[g.CurrentMap][next_tile]

  if event and event.type == "Touch" and event.properties then

    -- walk to trigger dialog text
    if event.properties.text then
      InitDialog(event)
      return
    end

    -- walk to trigger map transfer
    if event.properties.TransferPlayer and PlayerIsFacingDirectionToTransfer[g.Player[g.CurrentMap].dir](next_tile) then
      g.next_map = {
        index = FindInTable(event.properties.TransferPlayer, g.maps),
        x = event.properties.TransferTileRight,
        y = event.properties.TransferTileDown
      }

      -- hardcode a transfer to blizzard as the end approaches
      -- if g.RunTime() > (177.5) then
      --   g.next_map = {
      --     index = g.FindInTable("Blizzard", g.maps),
      --     x = 7,
      --     y = 5
      --   }
      -- end

      g.SceneFade:playcommand("FadeToBlack")
    end
  end
end

-- press START to trigger an event
local InteractionHandler = function()

  -- maybe the player is holding START because they want to quit early
  -- start tracking how long START has been held just in case
  _start.begin_time = GetTimeSinceStart()

  -- if handling an event that must be interacted with
  if not g.DialogIsActive then
    local next_tile = g.Player[g.CurrentMap].NextTile[g.Player[g.CurrentMap].dir]()
    local event = g.Events[g.CurrentMap][next_tile]
		local npc = g.NPCs[g.CurrentMap][next_tile]

    if event and event.properties and event.properties.text then
      InitDialog(event)
    end
    if event and event.properties and event.properties.sound then
			SOUND:PlayOnce("./sfx/"..event.properties.sound..".ogg")
		end
    if npc then
			-- Using the npc's name located at next_tile, we can refer to the actual npc actor
			g.NPCs[g.CurrentMap][npc.name]:queuecommand("TurnToFacePlayer")
      
			if npc.properties and npc.properties.text then
				InitDialog(npc)
				if npc.properties.mission then
					mission = npc.properties.mission
					g.EnteringBattle = true
				end
			end
		end


    return false
  end

  -- if already handling dialog...
  if not g.Dialog.IsTweening then
    -- update the dialog index
    g.Dialog.Index = g.Dialog.Index + 1

    -- then, ensure that there is more to load
    if g.Dialog.Index <= #g.Dialog.Words then
      -- otherwise, clear the old text, then display the new text
      g.Dialog.ActorFrame:queuecommand("ClearText"):queuecommand("UpdateText"):queuecommand("Show")
    else
      -- otherwise, clear the old text, hide the dialog_box
      g.Dialog.ActorFrame:queuecommand("ClearText"):queuecommand("Hide")
      -- and change the flag
      g.DialogIsActive = false
    end
  else
    g.Dialog.ActorFrame:finishtweening()
    g.Dialog.IsTweening = false
  end
end

local directional_movement = function(button)
  g.Player[g.CurrentMap].input.Active = button
  g.Player[g.CurrentMap].input[button] = true

  if not g.DialogIsActive then
    -- attempt to tween character
    g.Player[g.CurrentMap].actor:playcommand("AttemptToTween", {dir=button})
  end
end

-- ----------------------------------------------------------------------------
-- define per-button behavior for FirstPress input events here

local FirstPress = {
  Start = function() InteractionHandler() end,
  DeviceButton_escape = function() _start.begin_time = GetTimeSinceStart() end,

  MenuRight = function() end,
  MenuLeft  = function() end,

  Up    = function() directional_movement("Up")    end,
  Down  = function() directional_movement("Down")  end,
  Left  = function() directional_movement("Left")  end,
  Right = function() directional_movement("Right") end,
}

-- ----------------------------------------------------------------------------
-- define per-button behavior for Repeat input events here

local Repeat = {
  Start = function()
    _start.duration = GetTimeSinceStart() - _start.begin_time
    if _start.duration > 0.6 then
      SCREENMAN:GetTopScreen():StartTransitioningScreen("SM_DoNextScreen")
    elseif _start.duration > 0.15 then
      SCREENMAN:SystemMessage("Continue holding &START; to exit.")
    end

  end,
  DeviceButton_escape = function()
    _start.duration = GetTimeSinceStart() - _start.begin_time
    if _start.duration > 0.6 then
      SCREENMAN:GetTopScreen():begin_backing_out()
    elseif _start.duration > 0.15 then
      SCREENMAN:SystemMessage("Continue holding &BACK; to exit.")
    end

  end,
}

-- ----------------------------------------------------------------------------
-- finally, define per-button behavior for Release input events here

local Release = {
  Start               = function() _start.duration = 0; _start.begin_time = 0 end,
  DeviceButton_escape = function() _start.duration = 0; _start.begin_time = 0 end,
}

-- ----------------------------------------------------------------------------


local InputHandler = function(event)

  -- if any of these, don't attempt to handle input
  if not event.PlayerNumber or not event.button then return false end

  ----------------------------------------------------------------------------
  -- this should only be used to terminate input handling early for cutscenes
  if g.InputIsLocked then return false end


  ----------------------------------------------------------------------------
  if event.type == "InputEventType_FirstPress" then
    -- if the FirstPress table has a function to react to whichever
    -- button was just pressed, then call that function
    if FirstPress[event.button] then FirstPress[event.button]()
    elseif FirstPress[event.DeviceInput.button] then FirstPress[event.DeviceInput.button]()
    end

  elseif event.type == "InputEventType_Repeat" then
    -- the Repeat table is similar to FirstPress table
    if Repeat[event.button] then Repeat[event.button]()
    elseif Repeat[event.DeviceInput.button] then Repeat[event.DeviceInput.button]()
    end

  elseif event.type == "InputEventType_Release" then
    if Release[event.button] then Release[event.button]()
    elseif Release[event.DeviceInput.button] then Release[event.DeviceInput.button]()
    end


    -- if the button just released was the most recently active button, then no button is being held
    if event.button == g.Player[g.CurrentMap].input.Active then
      -- so mark the Active field as nil
      g.Player[g.CurrentMap].input.Active = nil
      -- and inform the player sprite to stop animating
      g.Player[g.CurrentMap].actor:queuecommand("AnimationOff")
    end

    -- either way, this button has been released, so mark it as false
    g.Player[g.CurrentMap].input[event.button] = false
  end

  return false
end

return InputHandler