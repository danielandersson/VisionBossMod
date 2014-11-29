VBM_LoadInstance["Vault of Archavon"] = function()
	VBM_BOSS_DATA["Archavon the Stone Watcher"] = {
		spells = {
			["Stomp"] = {
				event = "SPELL_CAST_START",
				spell = "Stomp",
				texture = "ability_warstomp",
				timer = 45,
				mess = "* * * Stomp * * *",
			},
		},
		
		start = function() 
			--VBM_BossTimer(5*60,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy");
			VBM_BossTimer(45,"Stomp",VBM_ICONS.."ability_warstomp");
		end,
	};
	
	VBM_BOSS_DATA["Emalon the Storm Watcher"] = {
		spells = {
			--[[["Overcharged Cast"] = {
				event = "SPELL_CAST_START",
				spell = "Overcharged",
				sound = true,
				mess = "* * * Casting Overcharge * * *",
			},]]
			["Overcharged"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Overcharged",
				func = function(s,d)
					vbm_bigwarn(">>"..vbm_c_w..d..vbm_c_r.."<< Overcharged");
				end,
			},
		},
		emotes = {
			["overcharges"] = {"* * * Casting Overcharge * * *",true,function()
				VBM_BossTimer(45,"Overcharged",VBM_ICONS.."spell_nature_lightningoverload");
			end},
		},
		start = function()
			VBM_BossTimer(45,"Overcharged",VBM_ICONS.."spell_nature_lightningoverload");
		end,
	};
	
	VBM_BOSS_DATA["Koralon the Flame Watcher"] = {
		spells = {
			["Burning Breath"] = {
				event = "SPELL_CAST_START",
				spell = "Burning Breath",
				mess = "* * * Burning Breath * * *",
				simonsound = true,
				texture = "ability_mage_firestarter",
				timer = 46,
			},
			
		},
		start = function()
			VBM_BossTimer(8,"Burning Breath",VBM_ICONS.."ability_mage_firestarter");
		end,
		debuffs = {
			["Flaming Cinder"] = {"* * * Flaming Cinder * * *",function()
				VBM_Flash(1,0.5,0.4);
			end},
		},
	};
	VBM_BOSS_DATA["Toravon the Ice Watcher"] = {
		start = function()
			VBM_BossTimer(10,"Frozen Orb",VBM_ICONS.."spell_frost_frozencore");
		end,
		spells = {
			["Frozen Orb"] = {
				event = "SPELL_CAST_START",
				src = "Toravon the Ice Watcher",
				spell = "Frozen Orb",
				mess = "* * * Frozen Orb * * *",
				simonsound = true,
				texture = "spell_frost_frozencore",
				timer = 32,
			},
			
		},
	};
	
end