--[[
	
]]--

VBM_LoadInstance["Karazhan"] = function()
	VBM_BOSS_DATA["Nightbane"] = {
		debuffs = {
			["Charred Earth"] = {"* * Charred Earth * *"},
		},
	};
	
	VBM_BOSS_DATA["The Big Bad Wolf"] = {
		spells = {
			["Red Riding Hood"] = {
				event = "SPELL_AURA_APPLIED",
				dest = VBM_YOU,
				spell = "Red Riding Hood",
				mess = "* * * Red Riding Hood * * *",
				sound = true,
			},
		},
	};
end