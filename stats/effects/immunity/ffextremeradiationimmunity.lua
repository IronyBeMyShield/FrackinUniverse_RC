function init()
  effect.setParentDirectives("border=2;00FF0055;00000000")
  effect.addStatModifierGroup({
    {stat = "ffextremeradiationImmunity", amount = 1},
    {stat = "biomeradiationImmunity", amount = 1}
  })
end

function update(dt)
end

function uninit()
  
end