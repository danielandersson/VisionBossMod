--[[
	BOSS DATA
]]--

VBM_LoadInstance["Hyjal Summit"] = function()
	VBM_FRIENDLY_BOSSTAGGED["Thrall"] = true;
	VBM_FRIENDLY_BOSSTAGGED["Lady Jaina Proudmoore"] = true;
	
	VBM_BOSS_DATA["Rage Winterchill"] = {
		debuffs = {
			["Icebolt"] = {"* * Icebolt * *"},
		},
	};
	
	VBM_BOSS_DATA["Anetheron"] = {
		debuffs = {
			["Inferno"] = {"* * Infernal Stun * *"},
		},
		spells = {
			["Inferno"] = {
				event = "SPELL_CAST_START",
				spell = "Inferno",
				src = "Anetheron",
				func = function() VBM_BossSend("infernal") end,
			},
		},
		bossevent = VBM_Anetheron_Infernal,
	};
	
	VBM_BOSS_DATA["Kaz'rogal"] = {
		debuffs = {
			["Mark of Kaz'rogal"] = {nil,VBM_Kazrogal_Mark},
		},
	};
	
	VBM_BOSS_DATA["Azgalor"] = {
		debuffs = {
			["Doom"] = {"* * * Doom * * *"},
		},
	};
	
	VBM_BOSS_DATA["Archimonde"] = {
		debuffs = {
			["Doomfire"] = {"* * Doomfire * *"},
			["Air Burst"] = {"* * Air Burst * *"},
		},
		spells = {
			["Air Burst"] = {
				event = "SPELL_CAST_START",
				src = "Archimonde",
				spell = "Air Burst",
				func = function() VBM_BossSend("airburst") end,
			},
		},
		bossevent = VBM_Archimonde_AirBurst,
	};
end

--[[
	SPECIAL FUNCTIONS
]]--

function VBM_Kazrogal_Mark()
	if(UnitPowerType("player")==0) then --mana check
		if(UnitPower("player") > 3000) then
			vbm_debuffwarn("Draning you to "..(UnitPower("player")-3000).." Mana",5,0,1,0);
		else
			vbm_debuffwarn("Explode warning gain "..(3001-UnitPower("player")).." Mana",5,1,0,0);
			VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
		end
	end
end

function VBM_Anetheron_Infernal()
	if(VBM_MSG_FROM==VBM_YOU) then
		VBM_Delay(VBM_BOSSTARGETYOUDELAY,VBM_BossTargetYouWarning,"Anetheron","Infernal incomming on You!","Infernal incomming on Me! Run!");
	else
		VBM_BossTargetYouWarning("Anetheron","Infernal incomming on You!","Infernal incomming on Me! Run!");
	end
end

function VBM_Archimonde_AirBurst()
	if(VBM_MSG_FROM==VBM_YOU) then
		VBM_Delay(VBM_BOSSTARGETYOUDELAY,VBM_BossTargetYouWarning,"Archimonde","Air Burst incomming on You!","Air Burst incomming on Me! Run!");
	else
		VBM_BossTargetYouWarning("Archimonde","Air Burst incomming on You!","Air Burst incomming on Me! Run!");
	end
end