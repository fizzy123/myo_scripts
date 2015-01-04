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
end

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
        extendUnlock()
      end
		end
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

function onPeriodic()
	if myo.getArm() == "unknown" then
		relock()
	end

  if myo.getTimeMilliseconds() - unlockedSince > UNLOCKED_TIMEOUT then
    unlocked = false
  end
end

function onForegroundWindowChange(app, title)
	appName = title
  myo.debug('onForegroundWindowChange: ' .. app .. ', ' .. title)
	if myo.getArm() == "unknown" then
		relock()
		return false
	else
		return true
	end
end

function onActiveChange(isActive)
	unlocked = false
end


