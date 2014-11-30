--[[

]]--
VBM_LoadInstance["Icecrown Citadel"] = function()
	--[[
	***************************************************************
	[Storming the Citadel]
	* Lord Marrowgar
    * Lady Deathwhisper
    * Gunship Battle
    * Deathbringer Saurfang
	***************************************************************
	]]--
	
	VBM_BOSS_DATA["Lord Marrowgar"] = {
		start = function()
			VBM_BossTimer(45,"Bone Storm",VBM_ICONS.."ability_druid_cyclone");
		end,
		debuffs = {
			["Coldflame"] = {"* * * Coldflame * * *",function() VBM_Flash(1,0.5,0.4,1,0,0); end},
			["Impaled"] = {nil,function() 
				vbm_say("Impaled - "..VBM_YOU); 
			end},
		},
		spells = {
			["Bone Spike Graveyard"] = {
				event = "SPELL_CAST_START",
				spell = "Bone Spike Graveyard",
				mess = "* * * Bone Spike * * *",
				simonsound = true,
				color = "grey",
			},
			["Impaled Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Impaled",
				func = function(s,d)
					VBM_Multi_Debuff_Add(d,"Impale","debuff",true,false,nil,nil,10);
				end,
			},
			["Impaled Tracker Removed"] = {
				event = "SPELL_AURA_REMOVED",
				spell = "Impaled",
				func = function(s,d)
					VBM_Multi_Debuff_Remove(d,"Impale","debuff",true,false,nil,nil,10);
				end,
			},
			["Bone Storm"] = {
				event = "SPELL_CAST_START",
				spell = "Bone Storm",
				mess = "* * * Bone Storm * * *",
				boatsound = true,
				func = function()
					if(VBM_DUNGEON_DIFFICULTY==1) then
						VBM_BossTimer(23,"Bone Storm End",VBM_ICONS.."ability_whirlwind");
					else
						--hard mode
						VBM_BossTimer(23+10,"Bone Storm End",VBM_ICONS.."ability_whirlwind");
					end
					VBM_Delay(29,VBM_BossTimer,60,"Bone Storm",VBM_ICONS.."ability_druid_cyclone");
				end
			},
		},
	};
	VBM_BOSS_DATA["Lady Deathwhisper"] = {
		start = function()
			if(VBM_DUNGEON_DIFFICULTY==1) then
				VBM_LoopTimer_Setup(6,"Adds spawn",60,"achievement_boss_ladydeathwhisper");
			else
				--hard mode
				VBM_LoopTimer_Setup(6,"Adds spawn",45,"achievement_boss_ladydeathwhisper");
				VBM_BossTimer(30,"Dominate Mind",VBM_ICONS.."inv_belt_18");
			end
		end,
		emotes = {
			["Mana Barrier shimmers and fades away"] = {nil,false,function(text)
				if(VBM_DUNGEON_DIFFICULTY==1) then
					--remove on normal, adds continue on heroic
					VBM_LoopTimer_Remove("Adds spawn");
				else
					VBM_BossTimer(32,"Dominate Mind",VBM_ICONS.."inv_belt_18");
				end
				vbm_bigwarn("* * * Phase 2 * * *");
				VBM_PlaySoundFile(VBM_SIMON_SOUND);
			end},
		},
		spells = {
			["Summon Spirit"] = {
				event = "SPELL_SUMMON",
				spell = "Summon Spirit",
				func = function(s,d)
					if(VBM_LoopLimitRun(1,5)) then
						vbm_bigwarn(vbm_c_bronze.."* * * Spawning Ghosts * * *");
						VBM_PlaySoundFile(VBM_PVPFLAG2_SOUND);
						VBM_PlaySoundFile(VBM_PVPFLAG_SOUND);
					end
				end,
			},
			["Dark Transformation"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Dark Transformation",
				dest = "Cult Fanatic",
				mess = "* * * Deformed Fanatic * * *",
				sound = true,
			},
			["Dominate Mind Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Dominate Mind",
				func = function(s,d)
					if(VBM_DUNGEON_DIFFICULTY==1) then
						vbm_infowarn("Dominate Mind >>"..vbm_c_w..d..vbm_c_t.."<<");
						VBM_SetMarkOnName(d,8,12);
						VBM_BossTimer(12,VBM_GetTextClassColor(VBM_GetClass(d))..d..vbm_c_w.." Dominated",VBM_ICONS.."inv_belt_18");
					else
						--hard mode
						if(VBM_GetS("DeathwhisperMC")) then
							vbm_smallwarn("* * * Mind Control * * *",1);
						else
							VBM_Multi_Debuff_Add(d,"Dominate Mind","info",true,false,12,nil,20);
						end
						VBM_BossTimer(12,"Mind Control",VBM_ICONS.."spell_shadow_shadowworddominate");
						VBM_BossTimer(39,"Dominate Mind",VBM_ICONS.."inv_belt_18");
					end
				end,
			},
		},
	};
	VBM_BOSS_DATA["Deathbringer Saurfang"] = {
		start = function()
			VBM_BossTimer(40,"Adds Spawn",VBM_ICONS.."spell_shadow_summonfelhunter");
			VBM_MARK = 0;
		end,
		rangecheck = 11,
		emotes = {
			["Feast, my minions"] = {"* * * Adds Spawned * * *",true,function(text)
				VBM_BossTimer(40,"Adds Spawn",VBM_ICONS.."spell_shadow_summonfelhunter");
			end},
		},
		debuffs = {
			["Rune of Blood"] = {nil,function() 
				vbm_say("Rune of Blood - "..VBM_YOU); 
			end},
		},
		spells = {
			["Mark of the Fallen Champion Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Mark of the Fallen Champion",
				func = function(s,d)
					VBM_MARK = VBM_MARK + 1;
					vbm_infowarn("Mark of the Fallen Champion "..vbm_c_bronze..VBM_MARK..vbm_c.." >>"..vbm_c_w..d..vbm_c_t.."<<");
					VBM_SetMarkOnName(d,8,10);
				end,
			},
		},
	};

	--[[
	***************************************************************
	[The Plagueworks]
	* Festergut
    * Rotface
    * Professor Putricide
	***************************************************************
	]]--
	
	VBM_BOSS_DATA["Festergut"] = {
		start = function()
			VBM_BossTimer(120+10,"Pungent Blight",VBM_ICONS.."spell_shadow_abominationexplosion");
			VBM_BossTimer(20,"Gas Spore",VBM_ICONS.."spell_shadow_creepingplague");
			VBM_FAILED = false;
		end,
		spells = {
			["Pungent Blight"] = {
				event = "SPELL_CAST_START",
				spell = "Pungent Blight",
				boatsound = true,
				mess = "* * * Pungent Blight * * *",
				func = function()
					VBM_BossTimer(120+15,"Pungent Blight",VBM_ICONS.."spell_shadow_abominationexplosion");
					VBM_BossTimer(20,"Gas Spore",VBM_ICONS.."spell_shadow_creepingplague");
				end,
			},
			["Gas Spore Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Gas Spore",
				func = function(s,d)
					if((VBM_DUNGEON_SIZE==25 and VBM_LoopLimitRun(3,10)) or (VBM_DUNGEON_SIZE==10 and VBM_LoopLimitRun(2,10)) ) then
						VBM_Multi_Debuff_TrackThose(d,"Gas Spore","info",true,true,12);
						VBM_BossTimer(40,"Gas Spore",VBM_ICONS.."spell_shadow_creepingplague");
						VBM_BossTimer(12,"Gas Spore Explode",VBM_ICONS.."spell_shadow_callofbone");
					end
				end,
			},
			--tank say warning
			["Gastric Bloat"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				spell = "Gastric Bloat",
				amount = 7,
				logic = ">",
				dest = VBM_YOU,
				func = function(s,d,a)
					vbm_say("Gastric Bloat - "..a.." Stacks - "..VBM_YOU);
				end,
			},
			--hard mode
			["Malleable Goo Summon Trigger"] = { 
				event = "UNIT_SPELLCAST_SUCCEEDED",
				special = true,
				func = function(src,spell,rank)
					if(spell=="Malleable Goo Summon Trigger") then
						vbm_bigwarn(VBM_WarnTextIcon("Malleable Goo Casted","inv_misc_herb_evergreenmoss"),3,0,0.6,0);
						VBM_PlaySoundFile(VBM_PVPFLAG_SOUND);
						VBM_BossTimer(8,"Malleable Goo",VBM_ICONS.."inv_misc_herb_evergreenmoss");
					end
				end,
			},
		},
		debuffs = {
			["Gas Spore"] = {VBM_WarnTextIcon("Gas Spore","spell_shadow_creepingplague"),function() 
				vbm_say("Gas Spore - "..VBM_YOU); 
			end},
		},
		during = function()
			local i;
			for i=1,GetNumGroupMembers() do
				local name, rank, icon, count = UnitDebuff("raid"..i,"Inoculated");
				if(name and count > 2 and not VBM_FAILED) then
					VBM_FAILED = true;
					--vbm_infowarn(vbm_c_w..UnitName("raid"..i)..vbm_c_bronze.." failed Flu Shot Shortage");
					vbm_printc(vbm_c_w..UnitName("raid"..i)..vbm_c_p.." failed Flu Shot Shortage");
				end
			end
		end,
	};
	VBM_BOSS_DATA["Rotface"] = {
		start = function()
			if(VBM_DUNGEON_DIFFICULTY==2) then
				--hard mode
				VBM_BossTimer(25,"Vile Gas",VBM_ICONS.."ability_creature_cursed_01");
			end
		end,
		spells = {
			--damage trackers
			["Ooze Flood"] = {
				event = "SPELL_DAMAGE",
				spell = "Ooze Flood",
				dest = VBM_YOU,
				func = function() vbm_debuffwarn("* * * Ooze Flood Damage * * *",0.3,0,1,0.5); end,
				lowersound = true,
			},
			["Sticky Ooze"] = {
				event = "SPELL_DAMAGE",
				spell = "Sticky Ooze",
				dest = VBM_YOU,
				func = function() vbm_debuffwarn("* * * Sticky Ooze Damage * * *",0.3,0,1,0.5); end,
				lowersound = true,
			},
			["Radiating Ooze"] = {
				event = "SPELL_DAMAGE",
				spell = "Radiating Ooze",
				dest = VBM_YOU,
				func = function() vbm_debuffwarn("* * * Radiating Ooze Damage * * *",0.3,0,1,0.5); end,
				lowersound = true,
			},
			--spells
			["Slime Spray"] = {
				event = "SPELL_CAST_START",
				spell = "Slime Spray",
				simonsound = true,
				mess = "* * * Slime Spray * * *",
				func = function()
					VBM_BossTimer(6.5,"Slime Spray",VBM_ICONS.."spell_fire_felcano");
				end,
			},
			["Unstable Ooze Explosion"] = {
				event = "SPELL_CAST_START",
				spell = "Unstable Ooze Explosion",
				boatsound = true,
				func = function()
					--remove old
					VBM_DelayRemove("OOZEEXPLODE");
					VBM_WarnTextCountdownClear();
					--set new
					VBM_WarnTextCountdown(4,"Unstable Ooze Explosion",vbm_c_r,"big");
					VBM_DelayByName("OOZEEXPLODE",5,VBM_WarnTextCountdown,3,"Watch Out",vbm_c_bronze,"big");
				end,
			},
			["Mutated Infection Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Mutated Infection",
				func = function(s,d)
					vbm_infowarn("Mutated Infection >>"..vbm_c_w..d..vbm_c_t.."<<");
					VBM_SetMarkOnName(d,8,12);
					VBM_BossTimer(12,VBM_GetTextClassColor(VBM_GetClass(d))..d..vbm_c_w.." Infected",VBM_ICONS.."ability_creature_disease_02");
				end,
			},
			["Mutated Infection Tracker Removed"] = {
				event = "SPELL_AURA_REMOVED",
				spell = "Mutated Infection",
				func = function(s,d)
					VBM_RemoveTimer(VBM_GetTextClassColor(VBM_GetClass(d))..d..vbm_c_w.." Infected");
					VBM_RemoveMarkOnName(d);
				end,
			},
			--hard mode
			["Vile Gas"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Vile Gas",
				src = "Professor Putricide",
				func = function()
					if(VBM_LoopLimitRun(1,5)) then
						vbm_debuffwarn(vbm_c_bronze..VBM_WarnTextIcon("Casting Vile Gas","ability_creature_cursed_01"));
						VBM_BossTimer(30,"Vile Gas",VBM_ICONS.."ability_creature_cursed_01");
						VBM_PlaySoundFile(VBM_PVPFLAG2_SOUND);
					end
				end,
			},
		},
		debuffs = {
			["Mutated Infection"] = {"* * * Mutated Infection * * *"},
			["Vile Gas"] = {"* * * Vile Gas * * *",function() vbm_say("Vile Gas - "..VBM_YOU); end},
		},
	
	};
	VBM_BOSS_DATA["Professor Putricide"] = {
		start = function()
			VBM_BossTimer(25,"Unstable Experiment",VBM_ICONS.."spell_shadow_unstableaffliction_1");
			VBM_PHASE = 1;
		end,
		spells = { 
			--debuff trackers
			["Volatile Ooze Adhesive Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Volatile Ooze Adhesive",
				func = function(s,d)
					vbm_infowarn("Volatile Ooze Adhesive >>"..vbm_c_w..d..vbm_c_t.."<<");
					VBM_SetMarkOnName(d,8,10);
					if(d==VBM_YOU) then
						vbm_infowarn("* * * Volatile Ooze Adhesive * * *",5,0.5,0.5,1);
						vbm_say("Volatile Ooze Adhesive - "..VBM_YOU);
						VBM_PlaySoundFile(VBM_LOWER_DONG_SOUND);
						VBM_Delay(0.2,VBM_PlaySoundFile,VBM_LOWER_DONG_SOUND);
					end
				end,
			},
			["Gaseous Bloat Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Gaseous Bloat",
				func = function(s,d)
					vbm_infowarn("Gaseous Bloat >>"..vbm_c_w..d..vbm_c_t.."<<");
					VBM_SetMarkOnName(d,8,20);
					if(d==VBM_YOU) then
						vbm_infowarn("* * * Gaseous Bloat * * *",5,1,0.5,0.5);
						vbm_say("Gaseous Bloat - "..VBM_YOU);
						VBM_PlaySoundFile(VBM_LOWER_DONG_SOUND);
						VBM_Delay(0.2,VBM_PlaySoundFile,VBM_LOWER_DONG_SOUND);
					end
				end,
			},
			["Unbound Plague Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Unbound Plague",
				func = function(s,d)
					VBM_SetMarkOnName(d,2,20);
				end,
			},
			--damage taken tracker
			["Mutated Slime"] = {
				event = "SPELL_DAMAGE",
				spell = "Slime Puddle",
				dest = VBM_YOU,
				func = function() vbm_debuffwarn("* * * Mutated Slime Damage * * *",0.3,0,1,0.5); end,
				lowersound = true,
			},
			--phase 1 and 2
			["Unstable Experiment"] = {
				event = "SPELL_CAST_START",
				spell = "Unstable Experiment",
				mess = "* * * Unstable Experiment * * *",
				boatsound = true,
				func = function()
					VBM_BossTimer(40,"Unstable Experiment",VBM_ICONS.."spell_shadow_unstableaffliction_1");
				end,
			},
			--phase 2 and 3 spells
			["Choking Gas Bomb"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Choking Gas Bomb",
				src = "Professor Putricide",
				mess = VBM_WarnTextIcon("Choking Gas Bomb","spell_shadow_mindbomb"),
				pvpflag2sound = true,
				color = "orange",
				func = function()
					--VBM_BossTimer(10,"Bomb Explode",VBM_ICONS.."spell_shadow_mindbomb");
					VBM_BossTimer(35,"Choking Gas Bomb",VBM_ICONS.."spell_shadow_mindbomb");
				end,
			},
			["Malleable Goo"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Malleable Goo",
				src = "Professor Putricide",
				mess = VBM_WarnTextIcon("Malleable Goo","inv_misc_herb_evergreenmoss"),
				simonsound = true,
				color = "green",
				func = function()
					VBM_Delay(0.5,VBM_PlaySoundFile,VBM_SIMON_SOUND);
					if(VBM_DUNGEON_DIFFICULTY==1) then
						VBM_BossTimer(25,"Malleable Goo",VBM_ICONS.."inv_misc_herb_evergreenmoss");
					else
						VBM_BossTimer(20,"Malleable Goo",VBM_ICONS.."inv_misc_herb_evergreenmoss");
					end
				end,
			},
			--hard mode stuff
			["Volatile Experiment"] = {
				event = "SPELL_CAST_START",
				spell = "Volatile Experiment",
				sound = true,
				func = function()
					VBM_PHASE = VBM_PHASE + 1;
					if(VBM_PHASE==2) then
						vbm_bigwarn("* * * Phase 2 * * *"); -- 80%
					elseif(VBM_PHASE==3) then
						vbm_bigwarn("* * * Phase 3 * * *"); -- 35%
					end
					VBM_RemoveTimer("Unstable Experiment");
					VBM_RemoveTimer("Malleable Goo");
					VBM_RemoveTimer("Choking Gas Bomb");
				end,
			},
			--phase 2
			["Create Concoction"] = {
				event = "SPELL_CAST_START",
				spell = "Create Concoction",
				func = function()
					if(VBM_DUNGEON_DIFFICULTY==2) then
						VBM_BossTimer(30,"Create Concoction",VBM_ICONS.."trade_alchemy");
						VBM_Delay(35,function()
							VBM_BossTimer(12,"Malleable Goo",VBM_ICONS.."inv_misc_herb_evergreenmoss");
							VBM_BossTimer(16,"Choking Gas Bomb",VBM_ICONS.."spell_shadow_mindbomb");
						end);
					end
				end,
			},
			--phase 3
			["Guzzle Potions"] = {
				event = "SPELL_CAST_START",
				spell = "Guzzle Potions",
				func = function()
					if(VBM_DUNGEON_DIFFICULTY==2) then
						VBM_BossTimer(30,"Guzzle Potions",VBM_ICONS.."trade_alchemy");
						VBM_Delay(35,function()
							VBM_BossTimer(12,"Malleable Goo",VBM_ICONS.."inv_misc_herb_evergreenmoss");
							VBM_BossTimer(16,"Choking Gas Bomb",VBM_ICONS.."spell_shadow_mindbomb");
						end);
					end
				end,
			},
		},
		debuffs = {
			--hard mode only
			["Unbound Plague"] = {VBM_WarnTextIcon("Unbound Plague","spell_shadow_corpseexplode"),function() 
				vbm_say("Unbound Plague - "..VBM_YOU);
				if(VBM_DUNGEON_SIZE==25) then
					VBM_BossTimer(10,"Give Unbound Plague",VBM_ICONS.."spell_shadow_corpseexplode");
				else
					VBM_BossTimer(12,"Give Unbound Plague",VBM_ICONS.."spell_shadow_corpseexplode");
				end
				--add 3 imba arrows
				VBM_DelayByName("PLAGUECHECK",0.5,function()
					local lol={};
					local i,x,y;
					local px,py=VBM_GetPlayerMapPosition("player");
					for i=1,GetNumGroupMembers() do
						x,y = VBM_GetPlayerMapPosition("raid"..i);
						if(x+y > 0 and not VBM_CheckForDebuff("Plague Sickness","raid"..i) and UnitName("raid"..i)~=VBM_YOU and not UnitIsDeadOrGhost("raid"..i)) then
							lol[#lol+1] = {n=UnitName("raid"..i),d=math.sqrt(((x-px)^2)+((y-py)^2))};
						end
					end
					table.sort(lol,function(a,b)return a.d<b.d; end);
					for i=1,#lol do
						--vbm_print(lol[i].d.." => "..lol[i].n);
						VBM_BossArrow(lol[i].n,20);
						if(i>=3) then
							break;
						end
					end
				end);
			end,false,function()
				VBM_DelayRemove("PLAGUECHECK");
				VBM_RemoveAllArrows();
			end},
			--notmal mode only stuff
			["Tear Gas"] = {nil,function()
				VBM_PHASE = VBM_PHASE + 1;
				VBM_BossTimer(16,"Tear Gas",VBM_ICONS.."spell_holiday_tow_spicecloud");
				VBM_RemoveTimer("Unstable Experiment");
				VBM_RemoveTimer("Malleable Goo");
				VBM_RemoveTimer("Choking Gas Bomb");
				if(VBM_PHASE==2) then
					vbm_bigwarn("* * * Phase 2 * * *"); -- 80%
				elseif(VBM_PHASE==3) then
					vbm_bigwarn("* * * Phase 3 * * *"); -- 35%
				end
			end,false,function()
				local extra = 0;
				local extra2 = 0;
				if(VBM_PHASE==3) then
					extra = 1;
					extra2 = -3;
				end
				VBM_BossTimer(6+extra,"Malleable Goo",VBM_ICONS.."inv_misc_herb_evergreenmoss");
				VBM_BossTimer(16+extra2,"Choking Gas Bomb",VBM_ICONS.."spell_shadow_mindbomb");
			end},
		},
		emotes = {
			["Hrm, I don%'t feel a thing%. Wha%?! Where%'d those come from%?"] = {nil,false,function()
				VBM_BossTimer(25,"Unstable Experiment",VBM_ICONS.."spell_shadow_unstableaffliction_1");
			end},
		}
	};
	
	--[[
	***************************************************************
	[The Crimson Hall]
	* Blood Prince Council
    * Blood-Queen Lana'thel
	***************************************************************
	]]--
	
	VBM_BOSS_DATA["Prince Valanar"] = {
		realname = "Blood Prince Council",
		deadcheck = {"Prince Valanar","Prince Keleseth","Prince Taldaram"},
		start = function()
			VBM_BossTimer(45,"Possible Blood Jump",VBM_ICONS.."spell_deathknight_bloodboil");
		end,
		spells = { 
			["Kinetic Bomb"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Kinetic Bomb",
				pvpflag1sound = true,
				func = function()
					vbm_debuffwarn(vbm_c_y.."* * * "..vbm_c_w.."Kinetic Bomb "..vbm_c_y.."Explode * * *");
				end,
			},
			["Shock Vortex"] = {
				event = "SPELL_CAST_START",
				spell = "Shock Vortex",
				lowersound = true,
				func = function()
					vbm_smallwarn("* * * Shock Vortex * * *",5,1,0,1);
					VBM_Delay(VBM_BOSSTARGETYOUDELAY,VBM_BossTargetYouWarning,"Prince Valanar","","Shock Vortex - "..VBM_YOU,"Shock Vortex");
				end,
			},
			["Empowered Shock Vortex"] = {
				event = "SPELL_CAST_START",
				spell = "Empowered Shock Vortex",
				boatsound = true,
				mess = "* * * Empowered Shock Vortex * * *",
				color = "grey",
				func = function()
					VBM_Delay(0.5,VBM_WarnTextCountdown,4,"Empowered Shock Vortex",vbm_c_grey);
				end,
			},
			["Conjure Empowered Flame"] = {
				event = "SPELL_CAST_START",
				spell = "Conjure Empowered Flame",
				mess = VBM_WarnTextIcon("Empowered Flame","spell_fire_sealoffire"),
				color = "orange",
				pvpflag2sound = true,
			},
			--hard mode
			["Shadow Prison"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				spell = "Shadow Prison",
				amount = 3,
				logic = ">",
				dest = VBM_YOU,
				func = function(s,d,a)
					vbm_debuffwarn(VBM_WarnTextIcon("Shadow Prison ("..vbm_c_w..a..vbm_c..")","ability_druid_typhoon"),8,1,0,1);
				end,
			},
		},
		emotes = {
			["Invocation of Blood jumps"] = {nil,false,function(text)
				local boss;
				if(string.find(text,"Valanar")) then
					boss = "Valanar";
				elseif(string.find(text,"Keleseth")) then
					boss = "Keleseth";
				else
					boss = "Taldaram";
				end
				VBM_PlaySoundFile(VBM_SIMON_SOUND);
				vbm_infowarn("Blood Jumped >>"..vbm_c_w..boss..vbm_c.."<<");
				VBM_BossTimer(45,"Possible Blood Jump",VBM_ICONS.."spell_deathknight_bloodboil");
			end},
			["Flames speed toward"] = {nil,false,function(text)
				local t,p
				t,_,p = string.find(text,"speed toward (.+)%!");
				if(t) then
					VBM_WarnTextCountdownClear();
					VBM_SetMarkOnName(p,8,10);
					if(p==VBM_YOU) then
						vbm_bigwarn("* * * Chasing YOU! * * *");
						VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
						vbm_infowarn("* * * Chasing YOU! * * *",5,1,0,0);
					else
						vbm_bigwarn("* * * Chasing >>"..vbm_c_w..p..vbm_c.."<< * * *",5,1,0.5,0);
					end
				end
			end},
		}
	};

	VBM_BOSS_DATA["Blood-Queen Lana'thel"] = {
		start = function()
			if(VBM_DUNGEON_SIZE==25) then
				VBM_BossTimer(120+10,"Air Phase",VBM_ICONS.."spell_shadow_bloodboil");
			else
				VBM_BossTimer(120,"Air Phase",VBM_ICONS.."spell_shadow_bloodboil");
			end
			VBM_BossTimer(15,"Vampiric Bite",VBM_ICONS.."inv_misc_monsterfang_01");
			VBM_BossTimer(20,"Pact",VBM_ICONS.."spell_shadow_destructivesoul");
		end,
		spells = { 
			["Pact of the Darkfallen Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Pact of the Darkfallen",
				func = function(s,d)
					VBM_Multi_Debuff_TrackThose(d,"Pact","info",false,true,10);
					VBM_BossTimer(30,"Pact",VBM_ICONS.."spell_shadow_destructivesoul");
				end,
			},
			["Swarming Shadows Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Swarming Shadows",
				func = function(s,d)
					VBM_SetMarkOnName(d,8,10);
				end,
			},
			["Uncontrollable Frenzy Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Uncontrollable Frenzy",
				func = function(s,d)
					vbm_printc("Uncontrollable Frenzy >> "..vbm_c_w..d);
					vbm_bigwarn("Uncontrollable Frenzy >>"..vbm_c_w..d..vbm_c_w.."<<");
				end,
			},
			["Swarming Shadows Damage"] = {
				event = "SPELL_DAMAGE",
				spell = "Swarming Shadows",
				dest = VBM_YOU,
				func = function() vbm_bigwarn("* * * Swarming Shadows Damage * * *",0.3,1,0,1); VBM_Flash(1,0.5,0.4,1,0,1); end,
				lowersound = true,
			},
			["Bloodbolt Whirl"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Bloodbolt Whirl",
				func = function()
					VBM_BossTimer(25-7,"Pact",VBM_ICONS.."spell_shadow_destructivesoul");
					if(VBM_DUNGEON_SIZE==25) then
						VBM_BossTimer(120-27,"Air Phase",VBM_ICONS.."spell_shadow_bloodboil");
					else
						VBM_BossTimer(120-7,"Air Phase",VBM_ICONS.."spell_shadow_bloodboil");
					end
					VBM_BossTimer(10,"Landing",VBM_ICONS.."ability_rogue_shadowdance");
				end,
			},
		},
		debuffs = {
			["Pact of the Darkfallen"] = {vbm_c_bronze..VBM_WarnTextIcon("Pact of the Darkfallen","spell_shadow_destructivesoul"),function() 
				VBM_Delay(1,VBM_PlaySoundFile,VBM_STANDARD_DONG_SOUND); 
			end,false,function()
				vbm_cleardebuffwarn();
				vbm_infowarn(vbm_c_g.."* * Done * *");
			end},
			["Swarming Shadows"] = {vbm_c_purple..VBM_WarnTextIcon("Swarming Shadows","spell_shadow_painspike")},
			["Frenzied Bloodthirst"] = {"* * * Frenzied Bloodthirst * * *",function()
				VBM_BossTimer(10,"Frenzied Bloodthirst",VBM_ICONS.."ability_warrior_rampage");
			end,false,function()
				VBM_RemoveTimer("Frenzied Bloodthirst");
			end},
			["Essence of the Blood Queen"] = {nil,function()
				if(VBM_DUNGEON_SIZE==25) then
					VBM_BossTimer(60,"Essence of the Blood Queen",VBM_ICONS.."ability_warlock_improvedsoulleech");
				else
					VBM_BossTimer(60+15,"Essence of the Blood Queen",VBM_ICONS.."ability_warlock_improvedsoulleech");
				end
			end},
		},
		emotes = {
			["Shadows amass and swarm around "..VBM_YOU.."%!"] = {nil,false,function(text)
				vbm_debuffwarn(vbm_c_purple.."* * * Swarming Shadows Inc * * *");
				VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
			end},
		},
	};	
	
	--[[
	***************************************************************
	[The Frostwing Halls]
	* Valithiria Dreamwalker
    * Sindragosa
	***************************************************************
	]]--
	
	VBM_BOSS_DATA["Valithiria Dreamwalker"] = {
		realname = "Heal Valithiria",
		start = function()
			if(VBM_DUNGEON_DIFFICULTY==1) then
				VBM_BossTimer(45,"Dream Portals",VBM_ICONS.."spell_nature_wispsplodegreen");
			else
				--hard mode
				VBM_LoopTimer_Setup(46.7+15,"Dream Portals Open",46.7,"spell_nature_wispsplodegreen");
			end
		end,
		spells = {
			["Dreamwalker's Rage"] = {
				event = "SPELL_CAST_START",
				spell = "Dreamwalker's Rage",
				mess = "* * * Well Done * * *",
				color = "green",
				duration = 8;
				func = function()
					vbm_debuffwarn("Valithiria Dreamwalker Saved",8,0,1,0);
					VBM_BossDead("Valithiria Dreamwalker");
				end,
			},
			["Mana Void"] = {
				event = "SPELL_DAMAGE",
				spell = "Mana Void",
				dest = VBM_YOU,
				func = function() vbm_debuffwarn("* * * Mana Void * * *",0.3,1,0,1); VBM_Flash(1,0.5,0.4,1,0,1); end,
				sound = true,
			},
		},
		debuffs = {
			["Mana Void"] = {"* * * Mana Void * * *"},
			["Dream State"] = {nil,function()
				VBM_BossTimer(20,"Dream State",VBM_ICONS.."spell_arcane_portalshattrath");
			end},
		},
		emotes = {
			["I have opened a portal into the Dream."] = {nil,false,function(text)
				VBM_BossTimer(45,"Dream Portals",VBM_ICONS.."spell_nature_wispsplodegreen");
				VBM_BossTimer(15,"Portals Opening",VBM_ICONS.."spell_arcane_portalshattrath");
			end},
		},
	};
	VBM_BOSS_DATA["Sindragosa Dummy"] = {
		realname = "Sindragosa",
		start = function()
			VBM_BossTimer(10,"Landing",VBM_ICONS.."achievement_boss_sindragosa");
			VBM_BossTimer(41,"Grip",VBM_ICONS.."spell_frost_arcticwinds");
			VBM_BossTimer(60,"Air phase",VBM_ICONS.."ability_suffocate");
			VBM_PHASE = 1;
			VBM_FAILED = false;
			VBM_BLOCK = {};
		end,
		spells = { 
			["Blistering Cold"] = {
				event = "SPELL_CAST_START",
				spell = "Blistering Cold",
				boatsound = true,
				func = function()
					VBM_WarnTextCountdown(5,"Blistering Cold",vbm_c_b,"big");
					if(VBM_PHASE == 3) then
						VBM_BossTimer(66,"Grip",VBM_ICONS.."spell_frost_arcticwinds");
					end
				end,
			},
			["Unchained Magic"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Unchained Magic",
				mess = VBM_WarnTextIcon("Unchained Magic","spell_arcane_arcanetorrent"),
				simonsound = true,
				dest = VBM_YOU,
				color = "purple",
			},
			["Frost Beacon Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Frost Beacon",
				func = function(s,d)
					if(VBM_PHASE == 3) then
						VBM_BossTimer(16,"Ice Tomb",VBM_ICONS.."spell_frost_frozencore");
						VBM_SetMarkOnName(d,2,10);
					elseif(VBM_DUNGEON_SIZE==25) then
						VBM_BLOCK[#VBM_BLOCK+1] = d;
						VBM_DelayByName("SINDRAGOSA",0.5,function()
							table.sort(VBM_BLOCK);
							vbm_printc("Order: "..vbm_c_w..table.concat(VBM_BLOCK,", "));
							local text = "";
							local send = false;
							local i;
							for i=1,#VBM_BLOCK do
								if(VBM_BLOCK[i]==VBM_YOU) then
									text = text..">>"..vbm_c_w..i..vbm_c.."<<    ";
									send = true;
								else
									text = text..i.."    ";
								end
							end
							if(send) then
								VBM_RC_Auto_Show(10, 1);
								VBM_Delay(20,VBM_RC_Auto_Hide);
								vbm_bigwarn(text,10);
							end
							VBM_BLOCK = {};
						end);
					end
				end,
			},
			["Sindragosa Died"] = {
				event = "UNIT_DIED",
				dest = "Sindragosa",
				func = function()
					VBM_BossDead("Sindragosa Dummy");
				end,
			},
		},
		debuffs = {
			["Frost Beacon"] = {VBM_WarnTextIcon("Frost Beacon","ability_hunter_markedfordeath"),function() vbm_say("Frost Beacon - "..VBM_YOU); end},
		},
		emotes = {
			["Your incursion ends here%! None shall survive%!"] = {nil,false,function()
				VBM_BossTimer(45,"Landing",VBM_ICONS.."achievement_boss_sindragosa");
				vbm_infowarn("* * * Air Phase * * *");
				VBM_Delay(50,function()
					VBM_BossTimer(60,"Air phase",VBM_ICONS.."ability_suffocate");
					VBM_BossTimer(30,"Grip",VBM_ICONS.."spell_frost_arcticwinds");
				end);
			end},
			["Now%, feel my master%'s limitless power and despair"] = {nil,false,function()
				vbm_infowarn("* * * Phase 3 * * *");
				VBM_PlaySoundFile(VBM_LOWER_DONG_SOUND);
				VBM_Delay(0.5,VBM_PlaySoundFile,VBM_LOWER_DONG_SOUND);
				VBM_RemoveTimer("Air phase");
				VBM_PHASE = 3;
				VBM_BossTimer(35,"Grip",VBM_ICONS.."spell_frost_arcticwinds");
			end},
			
		},
		during = function()
			-- Mystic Buffet
			local mess = "";
			local totalcount = 0;
			local name, rank, icon, count = UnitDebuff("player","Mystic Buffet");
			if(name and count) then
				if(count > 2) then
					mess = mess..vbm_c_pink.."Mystic("..vbm_c_w..count..vbm_c_pink..")  ";
				end
				totalcount = totalcount + count*3;
			end
			-- Instability
			name, rank, icon, count = UnitDebuff("player","Instability");
			if(name and count) then
				if(count > 2) then
					mess = mess..vbm_c_grey.."Instab("..vbm_c_w..count..vbm_c_grey..")  ";
				end
				totalcount = totalcount + count*3;
			end
			-- Chilled to the Bone
			name, rank, icon, count = UnitDebuff("player","Chilled to the Bone");
			if(name and count) then
				if(count > 3) then
					mess = mess..vbm_c_t.."Chill("..vbm_c_w..count..vbm_c_t..")  ";
				end
				totalcount = totalcount + count*2;
			end
			--Show Msg on screen
			if(string.len(mess)>1) then
				--if you have to many warn more
				if(totalcount > 11) then
					vbm_infowarn(mess,0.1);
					if(not VBM_SANITY or VBM_SANITY + 3 < GetTime()) then
						VBM_PlaySoundFile(VBM_LOWER_DONG_SOUND);
						VBM_SANITY = GetTime();
					end
				else
					--just add message
					vbm_infowarn(mess,1);
				end
			end
			--fail achievement warning
			local i;
			for i=1,GetNumGroupMembers() do
				local name, rank, icon, count = UnitDebuff("raid"..i,"Mystic Buffet");
				if(name and count > 5 and not VBM_FAILED) then
					VBM_FAILED = true;
					--vbm_infowarn(vbm_c_w..UnitName("raid"..i)..vbm_c_bronze.." failed All You Can Eat");
					vbm_printc(vbm_c_w..UnitName("raid"..i)..vbm_c_p.." failed All You Can Eat");
				end
			end
		end,
	};
	
	--[[
	***************************************************************
	[The Frozen Throne]
	* Lich King
	***************************************************************
	]]--
	VBM_BOSS_DATA["The Lich King"] = {
		start = function()
			VBM_BossTimer(20,"Shambling Horror",VBM_ICONS.."spell_deathknight_gnaw_ghoul");
			VBM_PHASE = 1;
			VBM_PLAGUE = {};
			VBM_VALKYR = {};
			VBM_SPIRITCHECK = true;
		end,
		spells = {
			--achievement check
			["Spirit Burst"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Spirit Burst",
				func = function()
					if(VBM_SPIRITCHECK) then
						vbm_printc("Spirit Burst casted, you have failed "..vbm_c_w.."Neck-Deep in Vile");
						VBM_SPIRITCHECK = false;
					end
				end,
			},
			--hard mode, phase 1
			["Summon Shadow Trap"] = {
				event = "SPELL_CAST_START",
				spell = "Summon Shadow Trap",
				timer = 16,
				texture = "spell_shadow_gathershadow",
				mess = "* * * Shadow Trap * * *",
				color = "grey",
				func = function()
					VBM_Delay(VBM_BOSSTARGETYOUDELAY,VBM_BossTargetNearYou,10,"The Lich King","Shadow Trap","big",true,true,false,true);
					VBM_BossTargetFirstNoneTank_DebuggCheck("The Lich King",VBM_BOSSTARGETYOUDELAY,1);
				end,
			},
			--victory 
			["Fury of Frostmourne"] = {
				event = "SPELL_CAST_START",
				spell = "Fury of Frostmourne",
				timername = "Ress",
				timer = 2*60+37,
				texture = "spell_holy_resurrection",
				mess = "* * * Well Done * * *",
				color = "green",
				duration = 10,
				func = function()
					vbm_debuffwarn("entering Phase 6",10,0,1,0);
				end,
			},
			--spells
			["Infest"] = {
				event = "SPELL_CAST_START",
				spell = "Infest",
				timer = 22,
				texture = "ability_rogue_envelopingshadows",
				func = function()
					vbm_smallwarn("* * * Infest * * *",2,1,0,1);
				end,
			},
			["Defile"] = {
				event = "SPELL_CAST_START",
				spell = "Defile",
				timer = 32,
				texture = "spell_shadow_gathershadows",
				mess = "* * * Defile * * *",
				pvpflag2sound = true,
				color = "grey",
				func = function()
					VBM_Delay(VBM_BOSSTARGETYOUDELAY,VBM_BossTargetYouWarning,"The Lich King","* * * Defile on YOU * * *","Defile - "..VBM_YOU,"Defile");
					VBM_Delay(VBM_BOSSTARGETYOUDELAY,VBM_BossTargetYouMoreAlerts,"The Lich King","Defile",true,1,0.5,1,0,0);
				end,
			},
			["Defile Damage"] = {
				event = "SPELL_DAMAGE",
				spell = "Defile",
				dest = VBM_YOU,
				func = function() vbm_debuffwarn("* * * Defile Damage * * *",0.3,1,0,1); VBM_Flash(1,0.5,0.4,1,0,1); end,
				sound = true,
			},
			--phase 1
			["Shambling Horror"] = {
				event = "SPELL_CAST_START",
				spell = "Summon Shambling Horror",
				timer = 61,
				texture = "spell_deathknight_gnaw_ghoul",
				mess = "* * * Shambling Horror Spawned * * *",
				simonsound = true,
			},
			--phase 2
			["Soul Reaper"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Soul Reaper",
				func = function(s,d)
					if(d==VBM_YOU) then
						vbm_debuffwarn(VBM_WarnTextIcon("Soul Reaper","ability_rogue_shadowdance"));
						VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
					end
					if(not VBM_GetS("LichKingSoulReaper")) then
						VBM_WarnTextCountdown(5,"Soul Reaper >>"..vbm_c_w..d..vbm_c_t.."<<",vbm_c_t,"info");
					else
						vbm_infowarn("Soul Reaper >>"..vbm_c_w..d..vbm_c_t.."<<");
					end
					if(not VBM_GetS("LichKingSoulReaperTimer")) then
						VBM_BossTimer(30,"Soul Reaper",VBM_ICONS.."ability_rogue_shadowdance");
					end
				end,
			},
			["Summon Val'kyr"] = {
				event = "SPELL_SUMMON",
				spell = "Summon Val'kyr",
				func = function(s,d,duid)
					VBM_VALKYR[#VBM_VALKYR+1] = duid;
					table.sort(VBM_VALKYR);
					VBM_DelayByName("VALKYR",20,function() VBM_VALKYR = {}; end);
				end,
			},
			--phase 3
			["Vile Spirits"] = {
				event = "SPELL_CAST_START",
				spell = "Vile Spirits",
				timer = 36,
				texture = "inv_jewelcrafting_shadowspirit_02",
				mess = "* * * Vile Spirits Spawned * * *",
				simonsound = true,
			},
			--normal mode
			["Harvest Soul Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Harvest Soul",
				func = function(s,d)
					if(VBM_DUNGEON_DIFFICULTY==1 and VBM_LoopLimitRun(1,20)) then
						VBM_PlaySoundFile(VBM_PVPFLAG_SOUND);
						VBM_SetMarkOnName(d,8,10);
						VBM_BossTimer(6,"Harvesting "..VBM_GetTextClassColor(VBM_GetClass(d))..d,VBM_ICONS.."ability_warlock_improvedsoulleech");
						VBM_Delay(6+10,VBM_BossTimer,60,"Harvest Soul",VBM_ICONS.."spell_deathknight_strangulate");
						if(d==VBM_YOU) then
							vbm_bigwarn("* * * Harvest Soul on "..vbm_c_w.."You"..vbm_c.." * * *");
						else
							vbm_bigwarn("Harvest Soul >>"..vbm_c_w..d..vbm_c.."<<");
						end
					end
				end,
			},
			--hard mode
			["Harvest Souls Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Harvest Souls",
				func = function(s,d)
					if(VBM_LoopLimitRun(1,20)) then
						VBM_RemoveTimer("Vile Spirits"); VBM_RemoveTimer("Defile");
						VBM_Delay(6+40,VBM_BossTimer,60,"Harvest Soul",VBM_ICONS.."spell_deathknight_strangulate");
						VBM_Delay(6,VBM_BossTimer,42,"Inside",VBM_ICONS.."ability_warlock_improvedsoulleech");
						VBM_BossTimer(6,"Harvesting",VBM_ICONS.."ability_warlock_improvedsoulleech");
					end
				end,
			},
			--phase switch
			["Remorseless Winter"] = {
				event = "SPELL_CAST_START",
				spell = "Remorseless Winter",
				timer = 63,
				texture = "spell_frost_arcticwinds",
				mess = VBM_WarnTextIcon("Remorseless Winter","spell_frost_arcticwinds"),
				boatsound = true,
				color = "teal",
				func = function()
					--remove old timers
					VBM_RemoveTimer("Val'kyr"); VBM_RemoveTimer("Shambling Horror");
					--up phase
					VBM_PHASE = VBM_PHASE + 1;
					vbm_infowarn("* * * Phase "..vbm_c_w..VBM_PHASE..vbm_c.." * * *");
					VBM_PHASE = VBM_PHASE + 1;
					--make default warnings
					VBM_Delay(63,VBM_BossTimer,38,"Defile",VBM_ICONS.."spell_shadow_gathershadows");
					VBM_Delay(63,vbm_infowarn,"* * * Phase "..vbm_c_w..VBM_PHASE..vbm_c.." * * *");
					--phase specific
					if(VBM_PHASE==3) then
						VBM_Delay(63,VBM_BossTimer,20,"Val'kyr",VBM_ICONS.."achievement_boss_svalasorrowgrave");
					end
					if(VBM_PHASE==5) then
						VBM_Delay(63,VBM_BossTimer,20,"Vile Spirits",VBM_ICONS.."inv_jewelcrafting_shadowspirit_02");
						VBM_Delay(63,VBM_BossTimer,13,"Harvest Soul",VBM_ICONS.."spell_deathknight_strangulate");
					end
				end,
			},
			["Raging Spirit Spawn"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Raging Spirit",
				simonsound = true,
				func = function(s,d)
					if(d==VBM_YOU) then
						vbm_say("Raging Spirit - "..VBM_YOU);
						VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
						vbm_debuffwarn("* * * Raging Spirit * * *");
					end
					VBM_SetMarkOnName(d,8,8);
					vbm_bigwarn("Raging Spirit >>"..vbm_c_w..d..vbm_c.."<<");
				end,
			},
		},
		emotes = {
			--phase 2
			["Val%'kyr%, your master calls"] = {"* * * Val'kyr Spawned * * *",false,function()
				VBM_PlaySoundFile(VBM_SIMON_SOUND); 
				VBM_BossTimer(47,"Val'kyr",VBM_ICONS.."achievement_boss_svalasorrowgrave");
			end},
		},
		during = function()
			local i;
			for i=1,GetNumGroupMembers() do
				--fix plague
				local name, rank, icon, count = UnitDebuff("raid"..i,"Necrotic Plague");
				local d = UnitName("raid"..i);
				if(name) then
					if(not count) then count = 1; end
					if(not VBM_PLAGUE[d]) then
						VBM_SetMarkOnName(d,8,10);
						if(d==VBM_YOU) then
							vbm_debuffwarn("* * * Necrotic Plague * * *",5,0,0.5,0);
							VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
							VBM_WarnTextCountdown(5,"Necrotic Plague >>"..vbm_c_w.."You"..vbm_c_dg.."<<",vbm_c_dg,"info");
						else
							VBM_WarnTextCountdown(5,"Necrotic Plague "..vbm_c_w..count..vbm_c_t.." >>"..vbm_c_w..d..vbm_c_t.."<<",vbm_c_t,"info");
						end
					end
					VBM_PLAGUE[d] = true;
				else
					if(VBM_PLAGUE[d]) then
						VBM_WarnTextCountdownClear();
						vbm_infowarn(vbm_c_g.."* * * Dispelled * * *",0.1);
					end
					VBM_PLAGUE[d] = false;
				end
				--mark Val'kyr Shadowguard
				if(UnitExists("raid"..i.."target") and UnitName("raid"..i.."target")=="Val'kyr Shadowguard") then
					local t = "raid"..i.."target";
					local guid = UnitGUID(t);
					if(not GetRaidTargetIndex(t)) then
						local j;
						for j=1,3 do
							if(VBM_VALKYR[j] and VBM_VALKYR[j]==guid) then
								if(j==1) then
									VBM_SetMarkOn(t,7);
								elseif(j==2) then
									VBM_SetMarkOn(t,2);
								else
									VBM_SetMarkOn(t,4);
								end
							end
						end
					end
				end
			end
		end,
	};

	--[[
	***************************************************************
	* TRASH
	***************************************************************
	]]--
	VBM_BOSS_DATA["Trash"] = {
		spells = {
			--Trash
			["Disrupting Shout"] = {
				event = "SPELL_CAST_START",
				spell = "Disrupting Shout",
				mess = "* * * Disrupting Shout * * *",
				lowersound = true,
			},
			["Blight Bomb"] = {
				event = "SPELL_CAST_START",
				spell = "Blight Bomb",
				mess = "* * * Blight Bomb * * *",
				sound = true,
			},
			--Gunship Battle
			["Below Zero Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Below Zero",
				mess = "* * * Sorcerer Spawned * * *",
				func = function(s,d)
					if(VBM_LoopLimitRun(1,5)) then
						VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
					end
				end,
			},
			["Below Zero Tracker Removed"] = {
				event = "SPELL_AURA_REMOVED",
				spell = "Below Zero",
				timer = 38,
				timername = "Sorcerer spawn",
				texture = "spell_frost_frost",
			},
		},
		debuffs = {
			["Dark Reckoning"] = {"* * * Dark Reckoning * * *",function() vbm_say("Dark Reckoning - "..VBM_YOU); end},
		},
		emotes = {
			--Gunship Battle
			--horde
			["Rise up, sons and daughters of the Horde%! Today we battle a hated enemy"] = {nil,false,function()
				if(VBM_DUNGEON_SIZE==25) then
					VBM_BossTimer(45,"Fight Start",VBM_ICONS.."achievement_dungeon_hordeairship");
					VBM_Delay(45,VBM_BossTimer,32,"~Sorcerer can spawn~",VBM_ICONS.."spell_frost_frost");
				else
					VBM_BossTimer(48,"Fight Start",VBM_ICONS.."achievement_dungeon_hordeairship");
					VBM_Delay(48,VBM_BossTimer,32,"~Sorcerer can spawn~",VBM_ICONS.."spell_frost_frost");
				end
			end},
			--alliance
			["Fire up the engines! We got a meetin' with destiny, lads!"] = {nil,false,function()
				if(VBM_DUNGEON_SIZE==25) then

				else

				end
			end},
			--Deathbringer Saurfang
			--horde
			["Kor%'kron, move out%! Champions, watch your backs%. The Scourge have been"] = {nil,false,function()
				VBM_BossTimer(98,"Deathbringer Saurfang",VBM_ICONS.."achievement_boss_saurfang");
			end},
			--alliance
			["For every Horde soldier that you killed, for every Alliance dog that fell, the"] = {nil,false,function()
				--VBM_BossTimer(98,"Deathbringer Saurfang",VBM_ICONS.."inv_sword_04");
			end},
			--Valithiria Dreamwalker
			["Intruders have breached the inner sanctum%. Hasten the destruction of the green dragon%!"] = {nil,false,function()
				VBM_BossReset("Valithiria Dreamwalker");
				VBM_BossStart("Valithiria Dreamwalker");
			end},
			--Sindragosa
			["The icy winds of Northrend will consume your souls"] = {nil,false,function()
				VBM_BossReset("Sindragosa Dummy");
				VBM_SF_Reset();
				VBM_BossStart("Sindragosa Dummy");
			end},
			--The Lich King
			["Shall I lay down Frostmourne and throw myself at your mercy"] = {nil,false,function()
				VBM_BossTimer(53,"Fight Start",VBM_ICONS.."achievement_boss_lichking");
			end},
		},
	};

end

