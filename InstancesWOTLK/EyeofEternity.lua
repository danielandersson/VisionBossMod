--[[
	
]]--
VBM_LoadInstance["The Eye of Eternity"] = function()
	VBM_BOSS_DATA["Malygos"] = {
		spells = {
			["Vortex"] = {
				event = "SPELL_CAST_SUCCESS",
				src = "Malygos",
				spell = "Vortex",
				mess = "* * * Vortex * * *",
				timer = 70,
				texture = "spell_arcane_arcane01",
				func = function() VBM_BossTimer(10,"Landing",VBM_ICONS.."spell_magic_featherfall"); end,
			},
			["Engulf in Flames"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Engulf in Flames",
				selfsrc = true,
				func = function() VBM_BossTimer(2+VBM_Malygoz_countpet*4,"Engulf in Flames",VBM_ICONS.."spell_fire_burnout"); end,
			},
			["Static Field"] = {
				event = "SPELL_DAMAGE",
				spell = "Static Field",
				selfdest = true,
				mess = "* * Static Field Damage * *",
				duration = 0.3,
				sound = true,
			},
			["Static Field Cast"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Static Field",
				src = "Malygos",
				mess = "* * Casting Static Field * *",
				sound = true,
				timer = 15,
				timername = "Static Field",
				texture = "spell_arcane_massdispel";
				color = "purple";
			},
		},
		emotes = {
			["A Power Spark forms from a nearby rift"] = {nil,false,function() 
				VBM_Malygos_spark = VBM_Malygos_spark + 1;
				VBM_BossTimer(18,"Spark "..VBM_Malygos_spark.." Attackable", VBM_ICONS.."spell_arcane_arcane04");
			end},
			["Watch helplessly as your hopes are swept away"] = {nil,false,function() 
				VBM_AddMoreTime("Spark "..VBM_Malygos_spark.." Attackable",15);
			end},
			--[[
			["fixes his eyes on you"] = {nil,false,function() 
				vbm_debuffwarn("* * * Targeting You * * *");
				VBM_PlaySoundFile(VBM_LOWER_DONG_SOUND);
			end},
			["Now your benefactors make their appearance, but they are too late"] = {nil,false,function() 
				
			end},]]--
		},
		loadandreset = function()
			if(VBM_GetS("AutoMalygosUI")) then
				VBMMalygosFrame:Show();
			end
		end,
		start = function() 
			VBM_BossTimer(30,"Vortex", VBM_ICONS.."spell_arcane_arcane01");
			VBM_Malygos_spark = 0;
			VBM_BossTimer(10*60,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy");
			VBM_Malygoz_countpet = 0;
		end,
		during = function() 
			if(VBM_Malygoz_countpet ~= GetComboPoints("pet")) then
				VBM_Malygoz_countpet = GetComboPoints("pet");
				vbm_infowarn(VBM_Malygoz_countpet);
			end
		 end,
	};
end