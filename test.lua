scriptId = 'com.thalmic.examples.outputeverything'
scriptTitle = "Output Everything"
scriptDetailsUrl = "" -- We don't have this until it's submitted to the Myo Market

function onPoseEdge(pose, edge)
  roll = myo.getRoll() * 180 / 3.14
  myo.debug('MYo roll: ' .. roll)
  if pose == "waveIn" then
    if edge == "on" then
	  if roll < 60 then
	    myo.debug("down")
	  elseif roll > 60 then
	    myo.debug("left")
	  end
    end
  end

  if pose == "waveOut" then
    if edge == "on" then
      if roll < 60 then
	    myo.debug("up")
	  elseif roll > 60 then
	    myo.debug("right")
	  end
    end
  end
end

function onPeriodic()
	roll = myo.getRoll() * 180 / 3.14
end

function onForegroundWindowChange(app, title)
    myo.debug("onForegroundWindowChange: " .. app .. ", " .. title)
    return true
end

function activeAppName()
    return "Output Everything"
end

function onActiveChange(isActive)
    myo.debug("onActiveChange")
end