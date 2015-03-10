function init()
  animator.setParticleEmitterOffsetRegion("poisondrip", mcontroller.boundBox())
  animator.setParticleEmitterActive("poisondrip", true)
  effect.setParentDirectives("fade=005500=0.5")

  local slows = status.statusProperty("slows", {})
  slows["slimestick"] = 0.65
  status.setStatusProperty("slows", slows)
end

function update(dt)
  mcontroller.controlModifiers({
      groundMovementModifier = -0.1,
      runModifier = -0.1
    })
  mcontroller.controlParameters({
      normalGroundFriction = 1.7
    })
end

function uninit()
  local slows = status.statusProperty("slows", {})
  slows["slimestick"] = nil
  status.setStatusProperty("slows", slows)
end