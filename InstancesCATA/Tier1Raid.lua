--[[ *********************************************************
--   **      The Bastion of Twilight                        **
--   **                                                     **
--   **           - Halfus Wyrmbreaker -                    **
--   **           - Valiona & Theralion -                   **
--   **           - Twilight Ascendant Council -            **
--   **           - Cho'gall -                              **
--   *******************************************************]]


VBM_LoadInstance["The Bastion of Twilight"] = function()
	VBM_BOSS_DATA["Halfus Wyrmbreaker"] = {
		spells = {
			["Shadow Nova Cast"] = {
				event = "SPELL_CAST_START",
				spell = "Shadow Nova",
				mess = "* * * Kick Shadow Nova * * *",
				color = "purple",
				duration = 2;
				lowersound = true,
			},
			["Shadow Nova Kick"] = {
				event = "SPELL_INTERRUPT",
				interrupted = "Shadow Nova",
				dest = "Halfus Wyrmbreaker",
				mess = "* * * Interrupted * * *",
				color = "green",
				duration = 0.1,
			},
			--tank say warning
			["Malevolent Strikes"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				spell = "Malevolent Strikes",
				amount = 5,
				logic = ">",
				dest = VBM_YOU,
				func = function(s,d,a)
					vbm_say("Malevolent Strikes - "..a.." Stacks - "..VBM_YOU);
				end,
			},
		},
		emotes = {
			["roars furiously"] = {nil,false,function()
				vbm_debuffwarn("* * * Furious Roar * * *");
				VBM_PlaySoundFile(VBM_SIMON_SOUND);
				VBM_BossTimer(30,"Furious Roar",VBM_ICONS.."ability_warrior_battleshout");
			end},
		},
	};
	
	VBM_BOSS_DATA["Valiona"] = {
		realname = "Valiona & Theralion",
		start = function()
		
		end,
		spells = {
			["Devouring Flames"] = {
				event = "SPELL_CAST_START",
				spell = "Devouring Flames",
				boatsound = true,
				mess = "Devouring Flames ("..vbm_c_w.."2.5"..vbm_c..")",
				func = function()
					VBM_Delay(0.5,VBM_WarnTextCountdown,2,"Devouring Flames",vbm_c_r,"big");
				end,
			},
			["Blackout Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Blackout",
				simonsound = true,
				func = function(s,d)
					VBM_SetMarkOnName(d,8,10);
					VBM_BossArrow(d,8);
					vbm_bigwarn(vbm_c_t.."Stack on >>"..vbm_c_w..d..vbm_c_t.."<<");
				end,
			},
			["Blackout Tracker Remove"] = {
				event = "SPELL_AURA_REMOVED",
				spell = "Blackout",
				color = "green",
				mess = "* * * Done * * *",
				duration = 0.3,
			},
			["Fabulous Flames Damage"] = {
				event = "SPELL_DAMAGE",
				spell = "Fabulous Flames",
				dest = VBM_YOU,
				func = function() vbm_bigwarn("* * * Fabulous Flames Damage * * *",0.3,1,0,1); VBM_Flash(1,0.5,0.4,1,0,1); end,
				lowersound = true,
			},
		},
		debuffs = {
			["Engulfing Magic"] = {VBM_WarnTextIcon(vbm_c_purple.."Engulfing Magic","spell_holy_consumemagic"),function() 
				vbm_say("Engulfing Magic - "..VBM_YOU); 
			end},
			["Blackout"] = {nil,function() 
				vbm_say("Blackout - "..VBM_YOU); 
			end},
		},
		emotes = {
			["Deep Breath"] = {nil,false,function()
				vbm_infowarn("* * * Deep Breath * * *",5,1,0,0);
				VBM_PlaySoundFile(VBM_BOAT_SOUND);
			end},
			["Dazzling Destruction"] = {nil,false,function()
				vbm_bigwarn(vbm_c_purple.."* * * Void Zone Rain * * *");
				VBM_PlaySoundFile(VBM_PVPFLAG2_SOUND);
				VBM_BossTimer(60+50,"Deep Breath",VBM_ICONS.."spell_fire_twilightflamestrike");
			end},
		},

		during = function()
			local i;
			for i=1,GetNumGroupMembers() do
				if(VBM_CheckForDebuff("Twilight Meteorite","raid"..i)) then
					VBM_SetMarkOnName(UnitName("raid"..i),8,10);
					vbm_bigwarn(vbm_c_t.."Stack on >>"..vbm_c_w..UnitName("raid"..i)..vbm_c_t.."<<",0.1);
				end
			end
		end,
	};
	
	VBM_BOSS_DATA["Ignacious"] = {
		realname = "Twilight Ascendant Council",
		deadcheck = {"Elementium Monstrosity"},
		start = function()
			VBM_BossReset("Elementium Monstrosity");
			VBM_SF_Reset();
			VBM_BossStart("Elementium Monstrosity");
			--VBM_BossTimer(30,"Glaciate",VBM_ICONS.."spell_frost_frostnova");
		end,
		spells = {
			--phase 1
			["Glaciate"] = {
				event = "SPELL_CAST_START",
				spell = "Glaciate",
				boatsound = true,
				--timer = 30,
				texture = "spell_frost_frostnova",
				func = function()
					VBM_WarnTextCountdown(3,"Glaciate",vbm_c_r,"big");
				end,
			},
			["Hydro Lance Cast"] = {
				event = "SPELL_CAST_START",
				spell = "Hydro Lance",
				mess = "* * * Kick Hydro Lance * * *",
				color = "teal",
				duration = 2,
				lowersound = true,
			},
			["Hydro Lance Kick"] = {
				event = "SPELL_INTERRUPT",
				interrupted = "Hydro Lance",
				dest = "Feludius",
				mess = "* * * Interrupted * * *",
				color = "green",
				duration = 0.1,
			},
			["Aegis of Flame"] = {
				event = "SPELL_CAST_START",
				spell = "Aegis of Flame",
				simonsound = true,
				--timer = 30,
				texture = "spell_fire_sealoffire",
				func = function()
					vbm_infowarn(vbm_c_bronze.."* * * Aegis of Flame * * *");
				end,
			},
			["Aegis of Flame Tracker Remove"] = {
				event = "SPELL_AURA_REMOVED",
				spell = "Aegis of Flame",
				func = function()
					vbm_infowarn(vbm_c_g.."* * * Done * * *",0.3);
				end
			},
			["Heart of Ice Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Heart of Ice",
				func = function(s,d)
					VBM_SetMarkOnName(d,6,20);
					if(d==VBM_YOU) then
						vbm_say("Heart of Ice - "..VBM_YOU);
					end
				end,
			},
			["Burning Blood Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Burning Blood",
				func = function(s,d)
					VBM_SetMarkOnName(d,2,20);
					if(d==VBM_YOU) then
						vbm_say("Burning Blood - "..VBM_YOU);
					end
				end,
			},
			--phase 2
			["Quake"] = {
				event = "SPELL_CAST_START",
				spell = "Quake",
				boatsound = true,
				timer = 36,
				timername = "Thundershock",
				texture = "spell_nature_lightningoverload",
				func = function()
					VBM_WarnTextCountdown(3,"Quake",vbm_c_bronze,"big");
				end,
			},
			["Thundershock"] = {
				event = "SPELL_CAST_START",
				spell = "Thundershock",
				boatsound = true,
				timer = 32,
				timername = "Quake",
				texture = "spell_nature_earthquake",
				func = function()
					VBM_WarnTextCountdown(3,"Thundershock",vbm_c_t,"big");
				end,
			},
			["Lightning Rod Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Lightning Rod",
				func = function(s,d)
					VBM_Multi_Debuff_TrackThose(d,nil,nil,false,true,10,0.5)
				end,
			},
			--phase 3
			["Liquid Ice Damage"] = {
				event = "SPELL_DAMAGE",
				spell = "Liquid Ice",
				dest = VBM_YOU,
				func = function() vbm_bigwarn("* * * Liquid Ice Damage * * *",0.3,0,1,1); VBM_Flash(1,0.5,0.4,0,1,1); end,
				lowersound = true,
			},
		},
		debuffs = {
			["Waterlogged"] = {VBM_WarnTextIcon(vbm_c_lb.."Waterlogged","inv_elemental_primal_water")},
			["Lightning Rod"] = {VBM_WarnTextIcon("Lightning Rod","inv_rod_enchantedcobalt"),function() 
				vbm_say("Lightning Rod - "..VBM_YOU); 
				VBM_Delay(4,vbm_say,"Lightning Rod - "..VBM_YOU);
				VBM_Delay(8,vbm_say,"Lightning Rod - "..VBM_YOU);
				VBM_RC_Auto_Show(20, 1);
				vbm_infowarn(VBM_WarnTextIcon("Lightning Rod","inv_rod_enchantedcobalt"));
			end,false,function()
				VBM_RC_Auto_Hide();
			end},
		},
		emotes = {
			["We will handle them"] = {nil,false,function()
				vbm_infowarn("* * * Phase 2 * * *");
				VBM_BossTimer(30,"Quake",VBM_ICONS.."spell_nature_earthquake");
			end},
			["An impressive display"] = {nil,false,function()
				vbm_infowarn("* * * Phase 3 * * *");
			end},
			
		},
	};
	
	VBM_BOSS_DATA["Cho'gall"] = {
		start = function()
			VBM_BossTimer(60,"Corrupting Adherent",VBM_ICONS.."ability_rogue_shadowdance");
			VBM_BossTimer(10,"~Conversion~",VBM_ICONS.."Spell_arcane_mindmastery");
		end,
		spells = {
			["Corrupting Crash"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Corrupting Crash",
				simonsound = true,
				func = function()
					--vbm_debuffwarn(vbm_c_purple..VBM_WarnTextIcon(vbm_c_lb.."Corrupting Crash","Spell_shadow_painspike"),0.1);
					VBM_Delay(VBM_BOSSTARGETYOUDELAY,VBM_BossTargetYouWarning,"Corrupting Adherent","* * * Corrupting Crash on YOU * * *","Corrupting Crash - "..VBM_YOU);
					VBM_Delay(VBM_BOSSTARGETYOUDELAY,VBM_BossTargetYouMoreAlerts,"Corrupting Adherent",nil,true,1,0.5,1,0,1);
				end,
			},
			["Summon Corrupting Adherent"] = {
				event = "SPELL_CAST_START",
				spell = "Summon Corrupting Adherent",
				sound = true,
				timer = 93,
				timername = "Corrupting Adherent",
				texture = "ability_rogue_shadowdance",
				mess = "* * * Corrupting Adherent * * *",
				func = function()
					VBM_BossTimer(45,"Spawning Adds",VBM_ICONS.."Spell_shadow_summonvoidwalker");
				end,
			},
			["Conversion"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Conversion",
				pvpflag1sound = true,
				timer = 37,
				timername = "~Conversion~",
				texture = "Spell_arcane_mindmastery",
			},
			--tank stuff
			--[[
			["Shadow's Orders"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Shadow's Orders",
				lowersound = true,
				mess = "* * * Shadow's Orders * * *",
				color = "purple",
			},
			["Flame's Orders"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Flame's Orders",
				lowersound = true,
				mess = "* * * Flame's Orders * * *",
				color = "orange",
			},
			]]--
			--phase 2
			["Consume Blood of the Old God"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Consume Blood of the Old God",
				pvpflag2sound = true,
				func = function()
					vbm_infowarn("* * * Phase 2 * * *");
					VBM_RemoveTimer("Corrupting Adherent");
					VBM_RemoveTimer("Spawning Adds");
					VBM_RemoveTimer("~Conversion~");
				end,
			},
			["Darkened Creations"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Darkened Creations",
				boatsound = true,
				mess = "* * * Darkened Creations * * *",
				timer = 30,
				texture = "Spell_shadow_shadesofdarkness",
			},
		},
		debuffs = {
			["Corruption: Sickness"] = {VBM_WarnTextIcon("Corruption: Sickness","spell_deathknight_bloodplague"),function() 
				vbm_say("Corruption: Sickness - "..VBM_YOU); 
			end},
			["Corruption: Malformation"] = {VBM_WarnTextIcon("Corruption: Malformation","spell_shadow_shadowfiend"),function() 
				vbm_say("Corruption: Malformation - "..VBM_YOU); 
			end},
			
		},
		during = function()
			local found = {};
			local i;
			for i=1,GetNumGroupMembers() do
				if(UnitChannelInfo("raid"..i)=="Worshipping") then
					found[#found+1] = UnitName("raid"..i);
				end
			end
			if(#found>0) then
				VBM_LASTFOUND = true;
				table.sort(found);
				vbm_infowarn(VBM_WarnTextIcon(table.concat(found,", "),"Spell_arcane_mindmastery"),0.1);
			else
				if(VBM_LASTFOUND) then
					VBM_LASTFOUND = nil;
					vbm_clearinfowarn();
				end
			end
		end
	};
end

--[[ *********************************************************
--   **      Blackwing Descent                              **
--   **                                                     **
--   **           - Omnotron Defense System -               **
--   **           - Magmaw -                                **
--   **           - Maloriak -                              **
--   **           - Atramedes -                             **
--   **           - Chimaeron -                             **
--   **           - Lord Victor Nefarius -                  **
--   *******************************************************]]

VBM_LoadInstance["Blackwing Descent"] = function()
	VBM_BOSS_DATA["Omnotron Defense System Dummy"] = {
		realname = "Omnotron Defense System",
		deadcheck = {"Electron", "Arcanotron", "Magmatron", "Toxitron"},
		debuffs = {
			["Lightning Conductor"] = {VBM_WarnTextIcon(vbm_c_lb.."Lightning Conductor","spell_shaman_staticshock"),function() 
				vbm_say("Lightning Conductor - "..VBM_YOU); 
			end},
			["Acquiring Target"] = {VBM_WarnTextIcon("Flamethrower","ability_mage_firestarter"),function() 
				vbm_say("Flamethrower - "..VBM_YOU); 
			end},
		},
		emotes = {
			["unit shield systems online"] = {nil,false,function(text)
				local found,boss
				found,_,boss = string.find(text, "(.+) unit shield systems online");
				if(found) then
					vbm_bigwarn("* * * "..vbm_c_w..boss..vbm_c.." shield up * * *");
					if(UnitExists("target") and UnitName("target")==boss) then
						vbm_bigwarn("* * * Your target have shield * * *");
						VBM_PlaySoundFile(VBM_BOAT_SOUND);
					end
				end
			end},
		},
	};

	VBM_BOSS_DATA["Magmaw"] = {
		start = function()
			VBM_BossTimer(20,"Lava Spew",VBM_ICONS.."Spell_shaman_lavaburst");
			VBM_BossTimer(30,"Pillar of Flame",VBM_ICONS.."Ability_mage_firestarter");
		end,
		spells = {
			["Lava Spew"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Lava Spew",
				func = function()
					if(VBM_LoopLimitRun(1,10)) then
						vbm_bigwarn("* * * Lava Spew * * *");
						VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
						VBM_BossTimer(25,"Lava Spew",VBM_ICONS.."Spell_shaman_lavaburst");
					end
				end,
			},
			["Pillar of Flame"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Pillar of Flame",
				simonsound = true,
				color = "orange",
				mess = "* * * Pillar of Flame * * *",
				timer = 35,
				texture = "Ability_mage_firestarter",
			},
		},
		debuffs = {
			["Parasitic Infection"] = {VBM_WarnTextIcon(vbm_c_purple.."Parasitic Infection","Ability_hunter_pet_worm"),function() 
				vbm_say("Parasitic Infection - "..VBM_YOU); 
			end},
		},
		emotes = {
			["impaled on the spike"] = {nil,false,function()
				VBM_BossTimer(30,"Exposed Head",VBM_ICONS.."ability_hunter_mastermarksman");
				vbm_bigwarn(vbm_c_g.."* * * Exposed Head * * *");
			end},
		}
	};
	
	VBM_BOSS_DATA["Maloriak"] = {
		start = function()
			VBM_COUNT = 0;
			VBM_BossTimer(17,"First Vial",VBM_ICONS.."inv_alchemy_enchantedvial");
		end,
		spells = {
			["Remedy Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Remedy",
				simonsound = true,
				func = function()
					vbm_smallwarn("* * * Dispel Remedy * * *",5);
				end,
			},
			["Remedy Tracker Remove"] = {
				event = "SPELL_AURA_REMOVED",
				spell = "Remedy",
				func = function()
					vbm_smallwarn("* * * Done * * *",0.3,0,1,0);
				end,
			},
			["Flash Freeze Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Flash Freeze",
				pvpflag2sound = true,
				func = function(s,d)
					VBM_SetMarkOnName(d,8,10);
					vbm_bigwarn(vbm_c_t.."Flash Freeze >>"..vbm_c_w..d..vbm_c_t.."<<");
				end,
			},
			["Release Aberrations"] = {
				event = "SPELL_CAST_START",
				spell = "Release Aberrations",
				lowersound = true,
				func = function()
					VBM_COUNT = VBM_COUNT + 1;
					vbm_infowarn("Spawning adds >>"..vbm_c_w..VBM_COUNT..vbm_c.."<<",0.5);
				end,
			},
			["Release All Minions"] = {
				event = "SPELL_CAST_START",
				spell = "Release All Minions",
				boatsound = true,
				func = function()
					vbm_bigwarn(vbm_c_t.."* * * Phase 2 * * *");
					VBM_RemoveTimer("Next Vial");
				end,
			},
			--last phase
			["Absolute Zero"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Absolute Zero",
				color = "teal",
				mess = "* * * Absolute Zero * * *",
				sound = true,
			},
			["Magma Jets Damage"] = {
				event = "SPELL_DAMAGE",
				spell = "Magma Jets",
				dest = VBM_YOU,
				func = function() vbm_debuffwarn("* * * Magma Jets Damage * * *",0.3,1,0,0); VBM_Flash(1,0.5,0.4,1,0,0); end,
				lowersound = true,
			},
		},
		debuffs = {
			["Consuming Flames"] = {VBM_WarnTextIcon("Consuming Flames","Spell_fire_fire"),function() 
				vbm_say("Consuming Flames - "..VBM_YOU); 
			end},
			["Biting Chill"] = {VBM_WarnTextIcon(vbm_c_t.."Biting Chill","Spell_frost_arcticwinds"),function() 
				vbm_say("Biting Chill - "..VBM_YOU); 
			end},
			["Debilitating Slime"] = {VBM_WarnTextIcon(vbm_c_g.."Kill adds now","Inv_misc_slime_01"),nil,true},
		},
		emotes = {
			["blue"] = {nil,false,function()
				VBM_BossTimer(48,"Next Vial",VBM_ICONS.."inv_alchemy_enchantedvial");
				vbm_bigwarn(vbm_c_lb.."* * * Blue Phase * * *");
				VBM_PlaySoundFile(VBM_PVPFLAG_SOUND);
			end},
			["green"] = {nil,false,function()
				VBM_BossTimer(48,"Next Vial",VBM_ICONS.."inv_alchemy_enchantedvial");
				vbm_bigwarn(vbm_c_dg.."* * * Green Phase * * *");
				VBM_PlaySoundFile(VBM_PVPFLAG_SOUND);
			end},
			["red"] = {nil,false,function()
				VBM_BossTimer(48,"Next Vial",VBM_ICONS.."inv_alchemy_enchantedvial");
				vbm_bigwarn(vbm_c_r.."* * * Red Phase * * *");
				VBM_PlaySoundFile(VBM_PVPFLAG_SOUND);
			end},
		},
	};
	
	VBM_BOSS_DATA["Atramedes"] = {
		start = function()
			VBM_BossTimer(45,"Searing Flame",VBM_ICONS.."spell_fire_selfdestruct");
		end,
		spells = {
			--[[
			["Sonic Breath"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Sonic Breath",
				sound = true,
				mess = "* * * Sonic Breath * * *",
				func = function(s,d)
					VBM_BossTargetYouWarning("Atramedes","Sonic Breath on YOU","Sonic Breath - ");
				end,
			},
			]]
			["Searing Flame"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Searing Flame",
				color = "orange",
				boatsound = true,
				mess = "* * * Searing Flame * * *",
				timer = 45,
				texture = "spell_fire_selfdestruct",
			},
			["Tracking Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Tracking",
				func = function(s,d)
					VBM_SetMarkOnName(d,8,10);
					vbm_bigwarn("Reverberating Flame >>"..vbm_c_w..d..vbm_c.."<<");
					if(d==VBM_YOU) then
						VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
						vbm_debuffwarn("* * * Tracking You * * *");
						vbm_say("Reverberating Flame - "..VBM_YOU);
					end
				end,
			},
		},
		emotes = {
			["Yes%, run%! With every step your heart quickens%."] = {nil,false,function()
				VBM_BossTimer(81,"Searing Flame",VBM_ICONS.."spell_fire_selfdestruct");
			end},
		},
		during = function()
			local power = VBM_GetBossAltPower();
			if(power > 49) then
				vbm_infowarn("Sound ("..vbm_c_w..power..vbm_c.."%)",0.1);
				VBM_PlayRepeatWarnSound(VBM_LOWER_DONG_SOUND,4);
			end
		end,
	};
	
	VBM_BOSS_DATA["Chimaeron"] = {
		start = function()
			VBM_COUNT = 1;
			VBM_BossTimer(26,"Massacre "..VBM_COUNT,VBM_ICONS.."ability_creature_disease_02");
		end,
		spells = {
			["Massacre"] = {
				event = "SPELL_CAST_START",
				spell = "Massacre",
				simonsound = true,
				func = function()
					VBM_COUNT = VBM_COUNT + 1;
					VBM_BossTimer(30,"Massacre "..VBM_COUNT,VBM_ICONS.."ability_creature_disease_02");
					VBM_WarnTextCountdown(4,"Massacre",vbm_c_r,"big");
				end,
			},
			--tank say warning
			["Break"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				spell = "Break",
				amount = 1,
				logic = ">",
				dest = VBM_YOU,
				func = function(s,d,a)
					vbm_say("Break - "..a.." Stacks - "..VBM_YOU);
				end,
			},
			--phase 3
			["Mortality Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Mortality",
				dest = "Chimaeron",
				mess = "* * * Phase 3 * * *",
				pvpflag2sound = true,
				color = "teal",
			},
		},
		emotes = {
			["offline"] = {nil,false,function()
				vbm_infowarn("* * * Phase 2 * * *");
				VBM_PlaySoundFile(VBM_BOAT_SOUND);
				VBM_BossTimer(25,"Phase 2",VBM_ICONS.."inv_misc_gear_01");
			end},
			["online"] = {nil,false,function()
				vbm_infowarn("* * * Phase 1 * * *");
				VBM_PlaySoundFile(VBM_PVPFLAG_SOUND);
			end},
		},
	};
	
	VBM_BOSS_DATA["Onyxia"] = {
		deadcheck = {"Nefarian","Onyxia"},
		realname = "Nefarian",
		start = function()
			VBM_BossTimer(30,"Nefarian Landing",VBM_ICONS.."achievement_dungeon_blackwingdescent_raid_nefarian");
			VBM_LAST = 0;
			VBM_NEF = 100;
		end,
		spells = {
			["Shadowblaze Damage"] = {
				event = "SPELL_DAMAGE",
				spell = "Shadowblaze",
				dest = VBM_YOU,
				func = function() vbm_debuffwarn("* * * Shadowblaze Damage * * *",0.3,1,0,1); VBM_Flash(1,0.5,0.4,1,0,1); end,
				lowersound = true,
			},
			["Lava Damage"] = {
				event = "ENVIRONMENTAL_DAMAGE",
				spell = "Lava",
				dest = VBM_YOU,
				func = function() vbm_debuffwarn("* * * Lava Damage * * *",0.3,1,0,0); VBM_Flash(1,0.5,0.4,1,0,0); end,
				lowersound = true,
			},
		},
		emotes = {
			["The air crackles with electricity"] = {"* * * Electrocute Soon * * *",true,function()
				VBM_WarnTextCountdown(5,"Electrocute",vbm_c_r,"big");
			end},
		},
		during = function()
			--ony
			local ony = VBM_GetBossAltPower("Onyxia");
			if(ony>69) then
				if(ony~=VBM_LAST) then
					VBM_LAST = ony;
					vbm_infowarn("Onyxia ("..vbm_c_w..VBM_LAST..vbm_c.."%)");
					VBM_PlayRepeatWarnSound(VBM_LOWER_DONG_SOUND,4);
				end
			end
			
			--nef
			local nef = VBM_GetUnitReferens("Nefarian");
			if(nef) then
				local hp = VBM_UnitHealthPercent(nef);
				if(hp>5 and hp<95 and hp~=VBM_NEF) then
					VBM_NEF = hp;
					if(math.fmod(hp,10)==1) then
						vbm_bigwarn("Electrocute Soon ("..vbm_c_w..hp..vbm_c.."%)",20,1,1,0);
						VBM_PlaySoundFile(VBM_SIMON_SOUND);
					elseif(math.fmod(hp,10)==0) then
						vbm_bigwarn("Electrocute Soon ("..vbm_c_w..hp..vbm_c.."%)",20,1,0.5,0);
						VBM_PlaySoundFile(VBM_SIMON_SOUND);
					end
				end
			end
		end,
	};
	
	VBM_BOSS_DATA["Trash"] = {
		emotes = {
			[" unit activated%."] = {nil,false,function(text)
				local found,boss
				found,_,boss = string.find(text, "(.+) unit activated");
				if(found) then
					if(not VBM_OMNOTRON) then
						VBM_OMNOTRON = boss;
					end
					
					if(VBM_OMNOTRON == boss) then
						VBM_BossReset("Omnotron Defense System Dummy");
						VBM_SF_Reset();
						VBM_BossStart("Omnotron Defense System Dummy");
					end
				end
			end},
		},
	};
end

--[[ *********************************************************
--   **      Throne of the Four Winds                       **
--   **                                                     **
--   **           -  Conclave of Wind -                     **
--   **           - Al'Akir -                               **
--   *******************************************************]]

VBM_LoadInstance["Throne of the Four Winds"] = function()
	VBM_BOSS_DATA["Nezir"] = {
		start = function()
			VBM_COUNT = 1;
			if(VBM_DUNGEON_DIFFICULTY==2) then
				VBM_BossTimer(30,"Storm Shield",VBM_ICONS.."spell_frost_windwalkon");
			end
			VBM_BossTimer(90,"90 Energy ("..VBM_COUNT..")");
		end,
		realname = "Conclave of Wind",
		deadcheck = {"Nezir","Anshal","Rohash"},
		spells = {
			--Rohash
			["Wind Blast"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Wind Blast",
				mess = "* * * Wind Blast * * *",
				color = "teal",
				boatsound = true,
				texture = "ability_druid_galewinds",
				timer = 9,
				timername = "Wind Blast",
				func = function()
					VBM_BossTimer(60,"Wind Blast CD",VBM_ICONS.."inv_elemental_primal_air");
				end,
			},
			["Storm Shield"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Storm Shield",
				mess = "* * * Storm Shield * * *",
				sound = true,
				color = "yellow",
			},
			["Storm Shield Remove"] = {
				event = "SPELL_AURA_REMOVED",
				spell = "Storm Shield",
				color = "green",
				mess = "* * * Shield Down * * *",
				duration = 0.3,
			},
			--Nezir
			["Sleet Storm"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Sleet Storm",
				timer = 15,
				timername = "Sleet Storm",
				texture = "spell_frost_arcticwinds",
				func = function()
					vbm_bigwarn("* * * Sleet Storm ("..vbm_c_w..VBM_COUNT..vbm_c..") * * *");
					VBM_COUNT = VBM_COUNT + 1;
					if(VBM_DUNGEON_DIFFICULTY==2) then
						VBM_Delay(20,VBM_BossTimer,30,"Storm Shield",VBM_ICONS.."spell_frost_windwalkon");
					end
					VBM_Delay(20,VBM_BossTimer,90,"90 Energy ("..VBM_COUNT..")");
				end,
			},
			["Ice Patch Damage"] = {
				event = "SPELL_DAMAGE",
				spell = "Ice Patch",
				dest = VBM_YOU,
				func = function() vbm_debuffwarn("* * * Ice Patch Damage * * *",0.3,0,1,1); VBM_Flash(1,0.5,0.4,0,1,1); end,
				lowersound = true,
			},
			--Anshal
			["Nurture"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Nurture",
				func = function()
					vbm_debuffwarn("* * * Nurture * * *");
					VBM_PlaySoundFile(VBM_SIMON_SOUND);
				end,
			},
			["Toxic Spores"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Toxic Spores",
				func = function()
					if(VBM_LoopLimitRun(1,5)) then
						VBM_PlaySoundFile(VBM_LOWER_DONG_SOUND);
						vbm_debuffwarn("* * * Toxic Spores * * *",2,1,0.5,0);
					end
				end,
			},
		},
		during = function()
			--display Nezir power
			local target = VBM_GetUnitReferens("Nezir");
			if(target) then
				if(UnitPower(target) > 74) then
					vbm_infowarn("Energy ("..vbm_c_w..UnitPower(target)..vbm_c..")",0.1,1,1,0)
					VBM_PlayRepeatWarnSound(VBM_LOWER_DONG_SOUND,4);
				end
			end
		end
	};
	
	VBM_BOSS_DATA["Al'Akir"] = {
		start = function()
			VBM_BossTimer(22,"Wind Burst",VBM_ICONS.."spell_frost_windwalkon");
			VBM_PHASE = 1;
		end,
		spells = {
			--all time
			["Wind Burst"] = {
				event = "SPELL_CAST_START",
				spell = "Wind Burst",
				sound = true,
				func = function()
					VBM_WarnTextCountdown(5,"Wind Burst",vbm_c_r,"big");
				end,
				timer = 30,
				texture = "spell_frost_windwalkon",
			},
			--phase 1
			["Ice Storm Damage"] = {
				event = "SPELL_PERIODIC_DAMAGE",
				spell = "Ice Storm",
				dest = VBM_YOU,
				func = function() vbm_debuffwarn("* * * Ice Storm Damage * * *",0.3,0,1,1); VBM_Flash(1,0.5,0.4,0,1,1); end,
				lowersound = true,
			},
			--phase 2
			["Feedback Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Feedback",
				dest = "Al'Akir",
				timer = 20,
				texture = "spell_shaman_staticshock",
				timername = "Feedback",
				func = function(s,d,a)
					vbm_smallwarn("* * * Feedback ("..vbm_c_w.."1"..vbm_c..") * * *");
				end,
			},
			["Feedback Tracker2"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				spell = "Feedback",
				dest = "Al'Akir",
				timer = 20,
				texture = "spell_shaman_staticshock",
				timername = "Feedback",
				func = function(s,d,a)
					vbm_smallwarn("* * * Feedback ("..vbm_c_w..a..vbm_c..") * * *");
				end,
			},
			--phase 3
			["Lightning Clouds Damage"] = {
				event = "SPELL_DAMAGE",
				spell = "Lightning Clouds",
				dest = VBM_YOU,
				func = function() vbm_debuffwarn("* * * Lightning Clouds Damage * * *",0.3,1,1,0); VBM_Flash(1,0.5,0.4,1,1,0); end,
				lowersound = true,
			},
			["Wind Burst Damage"] = {
				event = "SPELL_DAMAGE",
				spell = "Wind Burst",
				func = function()
					if(VBM_PHASE==3) then
						if(VBM_LoopLimitRun(1,5)) then
							vbm_bigwarn("* * * Wind Burst * * *");
							VBM_PlaySoundFile(VBM_SIMON_SOUND);
							VBM_BossTimer(20,"Wind Burst",VBM_ICONS.."spell_frost_windwalkon");
						end
					end 
				end,
			},
			["Phase 3 Trigger"] = { 
				event = "UNIT_SPELLCAST_SUCCEEDED",
				special = true,
				func = function(src,spell,rank)
					if(spell=="Relentless Storm Initial Vehicle Ride Trigger") then
						vbm_infowarn("* * * Phase 3 * * *");
						VBM_PlaySoundFile(VBM_BOAT_SOUND);
						VBM_RemoveTimer("Stormling");
						VBM_RemoveTimer("Feedback");
						VBM_PHASE = 3;
						VBM_BossTimer(23,"Wind Burst",VBM_ICONS.."spell_frost_windwalkon");
					end
				end,
			},
			--[[
			["Lightning Clouds Trigger"] = { 
				event = "UNIT_SPELLCAST_SUCCEEDED",
				special = true,
				func = function(src,spell,rank)
					if(spell=="Lightning Clouds") then
						vbm_bigwarn("* * * Lightning Clouds * * *");
						VBM_PlaySoundFile(VBM_BOAT_SOUND);
					end
				end,
			},]]
			--Relentless Storm
		},
		debuffs = {
			["Lightning Rod"] = {VBM_WarnTextIcon("Lightning Rod","inv_rod_enchantedcobalt"),function() 
				vbm_say("Lightning Rod - "..VBM_YOU); 
			end},
		},
		emotes = {
			["Your futile persistance angers me"] = {nil,false,function()
				vbm_infowarn("* * * Phase 2 * * *");
				VBM_PHASE = 2;
				VBM_PlaySoundFile(VBM_BOAT_SOUND);
				VBM_RemoveTimer("Wind Burst");
				VBM_BossTimer(20,"Stormling",VBM_ICONS.."spell_shaman_thunderstorm");
			end},
			["Storms%! I summon you to my side%!"] = {nil,false,function()
				vbm_infowarn("* * * Stormling * * *",1);
				VBM_PlaySoundFile(VBM_SIMON_SOUND);
				VBM_BossTimer(20,"Stormling",VBM_ICONS.."spell_shaman_thunderstorm");
			end},
		},
	};
end
