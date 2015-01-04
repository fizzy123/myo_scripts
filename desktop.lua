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

local vertical
-- Implement Callbacks 
function onPoseEdge(pose, edge)
  pose = conditionallySwapWave(pose)

-- Unlock
  if pose == "thumbToPinky" then
		if unlocked == false then
      if edge == "off" then
        unlock()
        vertical = false
      elseif edge == "on" then
        myo.vibrate("short")
        myo.vibrate("short")
      end
		end
    extendUnlock()
  end

  if pose == "waveOut" then
    if (unlocked and edge == "on") then
      if vertical then
        myo.keyboard('down_arrow','press', 'control', 'alt')
      else
        myo.keyboard('left_arrow','press', 'control', 'alt')
      end
    end
    extendUnlock()
  end

  if pose == "waveIn" then
    if (unlocked and edge == "on") then
      if vertical then
        myo.keyboard('up_arrow','press', 'control', 'alt')
      elseif unlocked and edge == 'on' then
        myo.keyboard('right_arrow','press', 'control', 'alt')
      end
    end
    extendUnlock()
  end

  if pose == 'fist' then
    if (unlocked and edge == "on") then
      if vertical then
        vertical = false
      else 
        vertical = true
      end
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

local KEYPRESS_RATE = 10 
local COUNT = 0
local y, p
function onPeriodic()
  COUNT = COUNT + 1
  if COUNT > KEYPRESS_RATE then
    COUNT = 0
  end

	if myo.getArm() == "unknown" then
		relock()
	end

  if COUNT == KEYPRESS_RATE then
  end

  if unlockedSince then
    if myo.getTimeMilliseconds() - unlockedSince > UNLOCKED_TIMEOUT then
      if unlocked then
        myo.vibrate("short")
      end
      unlocked = false
    end
  end

  if y - myo.getYaw() * 180 / 3.14 > p - myo.getPitch() * 180 / 3.14 then
  --  myo.debug('horizontal')
  else
  --  myo.debug('vertical')
  end
  y = myo.getYaw() * 180 / 3.14
  p = myo.getPitch() * 180 / 3.14

--  myo.debug('angles: ' .. myo.getRoll() * 180 / 3.14 .. ' | ' .. myo.getPitch() * 180 / 3.14 .. ' | ' .. myo.getYaw() * 180 / 3.14)
end

function onForegroundWindowChange(app, title)
  y = myo.getYaw() * 180 / 3.14
  p = myo.getPitch() * 180 / 3.14
  appName = title
  return true
end

function onActiveChange(isActive)
	unlocked = false
end
