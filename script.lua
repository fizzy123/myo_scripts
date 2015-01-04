scriptId = 'com.thalmic.examples.myfirstscript'

function onForegroundWindowChange(app, title)
--  myo.debug('onForegroundWindowChange: ' .. app .. ', ' .. title)
  return true
end

function onPoseEdge(pose, edge)
--  myo.debug('onPoseEdge: ' .. pose .. ': ' .. edge)
end

function onPeriodic()
  --myo.debug('angles: ' .. myo.getRoll() * 180 / 3.14 .. ' | ' .. myo.getPitch() * 180 / 3.14 .. ' | ' .. myo.getYaw() * 180 / 3.14)
end
