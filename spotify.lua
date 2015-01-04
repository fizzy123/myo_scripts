scriptId = 'com.nobr.base'

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

-- Unlock mechanism 

function unlock()
  unlocked = true
end

function relock()
	unlocked = false
end

function extendUnlock()
  unlockedSince = myo.getTimeMilliseconds()
end;

local angle, volume, forward, backward, appName
-- Implement Callbacks 
function onPoseEdge(pose, edge)
  pose = conditionallySwapWave(pose)

-- Unlock
  if pose == "thumbToPinky" then
		if unlocked == false then
      if edge == "off" then
        unlock()
      elseif edge == "on" then
        myo.vibrate("short")
        myo.vibrate("short")
      end
		end
    extendUnlock()
  end

  if pose == "fingersSpread" then
    if unlocked and edge == 'on' then
      myo.keyboard('space', 'press')
      extendUnlock()
    end
  end

  if pose == "waveIn" then
    if (unlocked and edge == "on") then
      forward = true
    elseif edge == "off" then 
      forward = false
    end
    extendUnlock()
  end

  if pose == "waveOut" then
    if (unlocked and edge == "on") then
      backward = true
    elseif edge == "off" then 
      backward = false
    end
    extendUnlock()
  end
  
  if pose == "fist" then
    if (unlocked and edge == "on") then 
      volume = true
      angle = myo.getRoll() * 180/3.14
    elseif (unlocked and edge == "off") then
      volume = false
    end
    extendUnlock()
  end
--	if pose == "fingersSpread" then
--		if unlocked and edge == "on" then
--			dragClick()
--		elseif unlocked and edge == "off" then
--			unDragClick()
--		end
--	end
end

-- Time since last activity before we lock
UNLOCKED_TIMEOUT = 2200

local KEYPRESS_RATE = 3
local COUNT = 0
function onPeriodic()
  COUNT = COUNT + 1
  if COUNT > KEYPRESS_RATE then
    COUNT = 0
  end

	if myo.getArm() == "unknown" then
		relock()
	end

  if COUNT == KEYPRESS_RATE then
    if forward then
      myo.keyboard('left_arrow', 'press' , 'shift')
      extendUnlock()
    end

    if backward then
      myo.keyboard('right_arrow', 'press', 'shift')
      extendUnlock()
    end
  end

  if volume == true then
    if angle - myo.getRoll() * 180 / 3.14 > 10 then
      myo.keyboard('up_arrow', 'press', "command")
      angle = myo.getRoll() * 180 / 3.14
      extendUnlock()
    elseif angle - myo.getRoll() * 180 /3.14 < -10 then
      myo.keyboard('down_arrow', 'press', "command")
      angle = myo.getRoll() * 180 / 3.14
      extendUnlock()
    end
  end

  if unlockedSince then
    if myo.getTimeMilliseconds() - unlockedSince > UNLOCKED_TIMEOUT then
      if unlocked then
        myo.vibrate("short")
      end
      unlocked = false
    end
  end
end

function onForegroundWindowChange(app, title)
	appName = title
	if app == 'com.spotify.client' then
    myo.debug('spotify')
    return true
  else
    return false
	end
end

function onActiveChange(isActive)
	unlocked = false
end
