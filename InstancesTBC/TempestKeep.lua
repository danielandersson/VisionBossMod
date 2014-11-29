--[[
	
]]--

VBM_LoadInstance["Tempest Keep"] = function()
	VBM_BOSS_DATA["Al'ar"] = {
		debuffs = {
			["Flame Patch"] = {"* * Flame Patch * *"},
		},
	};
	
	VBM_BOSS_DATA["Void Reaver"] = {
		spells = {
			["Arcane Orb"] = {
				event = "SPELL_CAST_SUCCESS",
				dest = VBM_YOU,
				spell = "Arcane Orb",
				mess = "* * Arcane Orb Incomming * *",
				duration = 3,
				func = function() SendChatMessage("* * Arcane Orb Incomming! * *","SAY"); end,
			},
		},
	};
	
	VBM_BOSS_DATA["High Astromancer Solarian"] = {
		debuffs = {
			["Wrath of the Astromancer"] = {"* * Wrath of the Astromancer * *"},
		},
	};
	
	VBM_BOSS_DATA["Kael'thas Sunstrider"] = {
		emotes = {
			["sets eyes on"] = {nil,false,VBM_BossSend},
		},
		bossevent = VBM_Kaelthas,
	};
end

function VBM_Kaelthas(text)
	if(string.find(text,"sets eyes on "..UnitName("player"))) then
		vbm_bigwarn("* * Thaladred on You * *",5);
		VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
	end
end
