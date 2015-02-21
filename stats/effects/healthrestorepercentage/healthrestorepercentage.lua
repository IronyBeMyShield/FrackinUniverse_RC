function init()

	self.restorepercentage = effect.configParameter("healthrestore") or 0.5
	status.modifyResourcePercentage("health", self.restorepercentage)
	
end