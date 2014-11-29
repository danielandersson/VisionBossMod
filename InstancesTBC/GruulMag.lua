--[[
	
]]--

VBM_LoadInstance["Gruul's Lair"] = function()
	VBM_BOSS_DATA["Gruul the Dragonkiller"] = {
		debuffs = {
			["Cave In"] = {"* * Cave In * *"},
		},
	};
end

VBM_LoadInstance["Magtheridon's Lair"] = function()
	VBM_BOSS_DATA["Magtheridon"] = {
		spells = {
			["Blast Nova"] = {
				event = "SPELL_CAST_START",
				src = "Magtheridon",
				spell = "Blast Nova",
				mess = "* * * Blast Nova * * *",
				sound = true,
			},
		},
		emotes = {
			["Not again! Not again"] = {nil,false,function() vbm_bigwarn("* * * Success * * *",5,0,1,0); end},
		},
	};
end
