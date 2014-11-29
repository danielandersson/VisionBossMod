--[[
	
]]--

VBM_LoadInstance["Zul'Aman"] = function()
	VBM_BOSS_DATA["Akil'zon"] = {
		debuffs = {
			["Electrical Storm"] = {nil,function() SendChatMessage("ELECTRICAL STORM, GET TO ME FAST!","YELL"); end},
		},
	};
	
	VBM_BOSS_DATA["Halazzi"] = {
		spells = {
			["Lightning Totem"] = {
				event = "SPELL_CAST_START",
				src = "Halazzi",
				spell = "Lightning Totem",
				mess = "* * Lightning Totem * *",
			},
		},
	};
	
	VBM_BOSS_DATA["Zul'jin"] = {
		spells = {
			["Whirlwind"] = {
				event = "SPELL_CAST_SUCCESS",
				src = "Zul'jin",
				spell = "Whirlwind",
				mess = "* * * Whirlwind * * *",
				duration = 2,
			},
			["Creeping Paralysis"] = {
				event = "SPELL_CAST_SUCCESS",
				src = "Zul'jin",
				spell = "Creeping Paralysis",
				mess = "* * * Creeping Paralysis Mass Dispel * * *",
				sound = true,
			},
			["Column of Fire"] = {
				event = "SPELL_DAMAGE",
				spell = "Burn",
				dest = VBM_YOU,
				mess = "* * Column of Fire Damage * *",
				duration = 0.3,
			},
		},
		debuffs = {
			["Claw Rage"] = {"* * Claw Rage * *",function() SendChatMessage("Claw Rage on me!","SAY"); end},
			["Grievous Throw"] = {"* * Grievous Throw * *",function() SendChatMessage("Grievous Throw on me!","SAY"); end},
		},
	}
	
	VBM_BOSS_DATA["Trash"] = {
		emotes = {
			["Sound the alarm!"] = {"* * * Scout * * *",false},
		},
	};
end