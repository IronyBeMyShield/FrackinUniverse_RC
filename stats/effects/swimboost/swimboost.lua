function init()
  local bounds = mcontroller.boundBox()
  animator.setParticleEmitterOffsetRegion("bubbles", mcontroller.boundBox())
  animator.setParticleEmitterActive("bubbles", true)
  status.addEphemeralEffect("liquidimmunity")
  self.mouthPosition = status.statusProperty("mouthPosition") or {0,0}
  self.mouthBounds = {self.mouthPosition[1], self.mouthPosition[2], self.mouthPosition[1], self.mouthPosition[2]}
  self.boostAmount = effect.configParameter("boostAmount", 0)
  self.riseAmount = effect.configParameter("riseAmount", 0)
  self.liquidMovementParameter = {
	liquidFriction = 2,
	airForce = 50,
	liquidForce = 100,
  }
end

function update(dt)
  
  mcontroller.controlParameters(self.liquidMovementParameter)
  local position = mcontroller.position()
  local worldMouthPosition = {
    self.mouthPosition[1] + position[1],
    self.mouthPosition[2] + position[2]
  }

  local liquidAtMouth = world.liquidAt(worldMouthPosition)
  if liquidAtMouth and (liquidAtMouth[1] == 1 or liquidAtMouth[1] == 2) then 
     mcontroller.controlModifiers({
      runModifier = self.boostAmount,
      jumpModifier = self.riseAmount
    })
	
  animator.setParticleEmitterActive("bubbles", mcontroller.running())
  else
  
  animator.setParticleEmitterActive("bubbles", false)
  end
end

function uninit()
  status.removeEphemeralEffect("liquidimmunity")
end