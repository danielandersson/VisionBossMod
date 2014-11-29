--[[
	
]]--

VBM_LoadInstance["Serpentshrine Cavern"] = function()
	VBM_BOSS_DATA["Lady Vashj"] = {
		debuffs = {
			["Toxic Spores"] = {"* * Toxic Spores * *"},
			["Static Charge"] = {"* * Static Charge * *",function() SendChatMessage("Static Charge on me! Watch out!","SAY"); end},
		},
	};
end