scriptId = 'com.nobr.base'
scriptTitle = "Youtube"
scriptDetailsUrl = ""
-- Conditional wave

function conditionallySwapWave(pose)
  if myo.getArm() == "left" then
    if pose == "waveIn" then
      pose = "waveOut"
    elseif pose == "waveOut" then
      pose = "waveIn"
    end
  end
  return pose
end

function extendUnlock()
  myo.unlock("hold")
end;

local angle, volume, forward, backward, appName
-- Implement Callbacks 
function onPoseEdge(pose, edge)
  pose = conditionallySwapWave(pose)

-- Unlock
  if pose == "doubleTap" then
    if edge == 'on' then
      myo.keyboard('f', 'press')
    end
  end

  if pose == "fingersSpread" then
    if edge == 'on' then
      myo.keyboard('space', 'press')
    end
  end

  if pose == "waveIn" then
    if edge == "on" then
      forward = true
    elseif edge == "off" then 
      forward = false
    end
    extendUnlock()
  end

  if pose == "waveOut" then
    if edge == "on" then
      backward = true
    elseif edge == "off" then 
      backward = false
    end
    extendUnlock()
  end
  
  if pose == "fist" then
    if edge == "on" then 
      volume = true
      angle = myo.getRoll() * 180/3.14
    elseif (unlocked and edge == "off") then
      volume = false
    end
    extendUnlock()
  end
  if edge == "off" then 
    myo.unlock("timed")
  end
--	if pose == "fingersSpread" then
--		if unlocked and edge == "on" then
--			dragClick()
--		elseif unlocked and edge == "off" then
--			unDragClick()
--		end
--	end
end

local KEYPRESS_RATE = 3
local COUNT = 0
function onPeriodic()
  COUNT = COUNT + 1
  if COUNT > KEYPRESS_RATE then
    COUNT = 0
  end
  
  if COUNT == KEYPRESS_RATE then
    if forward then
      myo.keyboard('left_arrow', 'press')
    end

    if backward then
      myo.keyboard('right_arrow', 'press')
    end
  end

  if volume == true then
    if angle - myo.getRoll() * 180 / 3.14 > 10 then
      myo.keyboard('up_arrow', 'press')
      angle = myo.getRoll() * 180 / 3.14
    elseif angle - myo.getRoll() * 180 /3.14 < -10 then
      myo.keyboard('down_arrow', 'press')
      angle = myo.getRoll() * 180 / 3.14
    end
  end
end

function onForegroundWindowChange(app, title)
	appName = title
	if app == 'chrome.exe' then
    if string.find(title, 'YouTube') then
      return true
    end
  else
    return false
	end
end

function onActiveChange(isActive)
	unlocked = false
end
