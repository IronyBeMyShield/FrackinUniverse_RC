function init()

healP = effect.configParameter("healPercent", 0) -- Heal percent is the configParameter in the json statuseffects file
self.healingrate = (status.resourceMax("health") * healP) / effect.duration()
	
end



