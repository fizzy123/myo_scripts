scriptId = 'com.nobr.kodi'
scriptTitle = "Kodi"
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

local COUNT = 1
local angle, volume, forward, backward, appName, roll
-- Implement Callbacks 
function onPoseEdge(pose, edge)
  pose = conditionallySwapWave(pose)

-- Unlock
  if pose == "doubleTap" then
    if edge == 'on' then
    end
  end

  if pose == "fingersSpread" then
    if edge == 'on' then
      myo.keyboard('return', 'press')
    end
  end

  if pose == "waveIn" then
    if edge == "on" then
	  roll = myo.getRoll() * 180 / 3.14
	  if roll < 70 then
        myo.keyboard('down_arrow', 'press')
	  elseif roll > 70 then
        myo.keyboard('left_arrow', 'press')
	  end
      forward = true
	  COUNT = 1
    elseif edge == "off" then 
      forward = false
    end
    extendUnlock()
  end

  if pose == "waveOut" then
    if edge == "on" then
	  roll = myo.getRoll() * 180 / 3.14
	  if roll < 70 then
        myo.keyboard('up_arrow', 'press')
	  elseif roll > 70 then
        myo.keyboard('right_arrow', 'press')
	  end
      backward = true
	  COUNT = 1
    elseif edge == "off" then 
      backward = false
    end
    extendUnlock()
  end
  
  if pose == "fist" then
    if edge == "on" then 
      volume = true
      angle = myo.getRoll() * 180/3.14
      myo.keyboard('backspace', 'press')
    elseif edge == "off" then
      volume = false
    end
    extendUnlock()
  end
  if edge == "off" then 
    myo.unlock("timed")
    COUNT = 1
  end
--	if pose == "fingersSpread" then
--		if unlocked and edge == "on" then
--			dragClick()
--		elseif unlocked and edge == "off" then
--			unDragClick()
--		end
--	end
end

local HOLD_WAIT = 50
local KEYPRESS_RATE = 10
function onPeriodic()
  COUNT = COUNT + 1
  if COUNT > HOLD_WAIT then
    if COUNT % KEYPRESS_RATE == 0 then
      if forward then
	    if roll < 70 then
          myo.keyboard('down_arrow', 'press')
	    elseif roll > 70 then
          myo.keyboard('left_arrow', 'press')
	    end
      end

      if backward then
	    if roll < 70 then
          myo.keyboard('up_arrow', 'press')
	    elseif roll > 70 then
          myo.keyboard('right_arrow', 'press')
	    end
      end
    end
  end

  if volume == true then
    if angle - myo.getRoll() * 180 / 3.14 > 10 then
      myo.keyboard('equal', 'press')
      angle = myo.getRoll() * 180 / 3.14
    elseif angle - myo.getRoll() * 180 /3.14 < -10 then
      myo.keyboard('minus', 'press')
      angle = myo.getRoll() * 180 / 3.14
    end
  end
end

function onForegroundWindowChange(app, title)
	if app == 'Kodi.exe' then
      return true
  else
    return false
	end
end

function onActiveChange(isActive)
	unlocked = false
end
