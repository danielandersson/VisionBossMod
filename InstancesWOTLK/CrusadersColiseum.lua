--[[

]]--
VBM_LoadInstance["Trial of the Crusader"] = function()
	VBM_BOSS_DATA["Gormok the Impaler"] = {
		realname = "Northrend Beasts",
		deadcheck = {"Icehowl"}, --Gormok the Impaler            Acidmaw and Dreadscale               Icehowl               
		start = function() 
			VBM_BossStart("Icehowl");
			VBM_SNOBOLLED = 0;
		end,
		
		spells = {
			["Fire Bomb"] = {
				event = "SPELL_DAMAGE",
				spell = "Fire Bomb",
				dest = VBM_YOU,
				func = function() VBM_Flash(1,0.5,0.4); end,
				sound = true,
			},
			["Burning Bile Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Burning Bile",
				func = function(s,d)
					if(VBM_CheckForDebuff("Paralytic Toxin", "player")) then
						VBM_BossArrow(d,20);
						vbm_infowarn("Burning Bile >>"..vbm_c_w..d..vbm_c_t.."<<");
					end
				end,
			},
			["Burning Bile Tracker2"] = {
				event = "SPELL_AURA_REMOVED",
				spell = "Burning Bile",
				func = function(s,d)
					VBM_RemoveArrowByName(d);
				end,
			},
			["Paralytic Toxin Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Paralytic Toxin",
				func = function(s,d)
					if(VBM_CheckForDebuff("Burning Bile", "player")) then
						VBM_BossArrow(d,20);
						vbm_infowarn("Paralytic Toxin >>"..vbm_c_w..d..vbm_c_t.."<<");
					end
				end,
			},
			["Paralytic Toxin Tracker2"] = {
				event = "SPELL_AURA_REMOVED",
				spell = "Paralytic Toxin",
				func = function(s,d)
					VBM_RemoveArrowByName(d);
				end,
			},
		},
		emotes = {
			["glares at "..VBM_YOU.." and lets out a bellowing roar"] = {"* * * Charge on You! * * *",true,function() 
				vbm_yell("Charge - "..VBM_YOU);
			end},
			["and lets out a bellowing roar"] = {nil,false,function(text) 
				local f,p;
				f,_,p = string.find(text,"glares at (.+) and lets");
				if(f) then
					VBM_SetMarkOnName(p,8,10);
					if(p~=VBM_YOU) then
						vbm_infowarn("Charge >>"..vbm_c_w..p..vbm_c_t.."<<");
						VBM_BossArrow(p,10);
						local rid = VBM_GetRaidId(p);
						if(CheckInteractDistance("raid"..rid,1)) then
							vbm_bigwarn("You are within 30 yrd of "..vbm_c_w..p);
							VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
						end
					end
				end
			end},
		},
		debuffs = {
			["Snobolled!"] = {vbm_c_w.."* * * Snobolled! * * *",function() 
				vbm_say("Snobolled! - "..VBM_YOU); 
			end},
			
			["Paralytic Toxin"] = {vbm_c_g.."* * * Paralytic Toxin * * *",function()
				local i;
				for i=1,GetNumRaidMembers() do
					if(VBM_CheckForDebuff("Burning Bile", "raid"..i)) then
						VBM_BossArrow(UnitName("raid"..i),20);
					end
				end
			end,false,VBM_RemoveAllArrows},
			["Burning Bile"] = {"* * * Burning Bile * * *",function()
				local i;
				for i=1,GetNumRaidMembers() do
					if(VBM_CheckForDebuff("Paralytic Toxin", "raid"..i)) then
						VBM_BossArrow(UnitName("raid"..i),20);
					end
				end
			end,false,VBM_RemoveAllArrows},
		},
		during = function()
			local i;
			local p = {};
			for i=1,GetNumRaidMembers() do
				if(VBM_CheckForDebuff("Snobolled!", "raid"..i)) then
					p[#p+1] = UnitName("raid"..i);
					if(UnitName("raid"..i)==VBM_YOU) then
						vbm_debuffwarn("* * * Snobolled! * * *",1);
					end
				end
			end
			table.sort(p);
			if(#p ~= VBM_SNOBOLLED) then
				if(#p==0) then
					vbm_debuffwarn(vbm_c_g.."All Snobolls dead!",1);
				else
					vbm_debuffwarn(vbm_c_t.."Snobolled >>"..vbm_c_w..table.concat(p,", ")..vbm_c_t.."<<",8);
				end				
				VBM_SNOBOLLED = #p;
			end
		end,
	};
	
	VBM_BOSS_DATA["Lord Jaraxxus"] = {
		spells = {
			["Legion Flame"] = {
				event = "SPELL_DAMAGE",
				spell = "Legion Flame",
				dest = VBM_YOU,
				func = function() VBM_Flash(1,0.5,0.4); end,
				sound = true,
			},
			["Incinerate Flesh Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Incinerate Flesh",
				func = function(s,d)
					vbm_infowarn("Spam Heal >>"..vbm_c_w..d..vbm_c_t.."<<");
					VBM_SetMarkOnName(d,8,12);
				end,
			},
		},
		debuffs = {
			["Legion Flame"] = {"* * * Legion Flame Debuff * * *"},
			["Mistress' Kiss"] = {"* * * Mistress' Kiss * * *"},
		},
		emotes = {
			["Nether Portal"] = {vbm_c_purple.."* * * Nether Portal * * *",false,function() 
				VBM_PlaySoundFile(VBM_BOAT_SOUND);
				VBM_BossTimer(60,"Infernal Volcano",VBM_ICONS.."spell_fire_felcano");
			end},
			["Infernal Volcano"] = {vbm_c_y.."* * * Infernal Volcano * * *",false,function() 
				VBM_PlaySoundFile(VBM_BOAT_SOUND);
				VBM_BossTimer(60,"Nether Portal",VBM_ICONS.."ability_rogue_envelopingshadows");
			end},
		},
		start = function()
			VBM_BossTimer(20,"Nether Portal",VBM_ICONS.."ability_rogue_envelopingshadows");
		end,
	};
	
	VBM_BOSS_DATA["Eydis Darkbane"] = {
		realname = "Twin Val'kyr",
		--Fjola Lightbane                 Eydis Darkbane
		start = function()
			VBM_BossTimer(45,"Next Spell",VBM_ICONS.."spell_arcane_arcanetorrent");
		end,
		spells = {
			["Shield of Darkness"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Shield of Darkness",
				timer = 15,
				timername = "Twin's Pact",
				texture = "spell_shadow_darkritual",
				func = function()
					VBM_BossTimer(45,"Next Spell",VBM_ICONS.."spell_arcane_arcanetorrent");
					if(UnitExists("target") and UnitName("target")=="Fjola Lightbane") then
						vbm_bigwarn("* * * Switch and Dps the Dark one * * *");
						VBM_PlaySoundFile(VBM_SIMON_SOUND);
						VBM_Delay(0.5,VBM_PlaySoundFile,VBM_SIMON_SOUND);
					end
				end,
			},
			["Shield of Lights"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Shield of Lights",
				timer = 15,
				timername = "Twin's Pact",
				texture = "spell_shadow_darkritual",
				func = function()
					VBM_BossTimer(45,"Next Spell",VBM_ICONS.."spell_arcane_arcanetorrent");
					if(UnitExists("target") and UnitName("target")=="Eydis Darkbane") then
						vbm_bigwarn("* * * Switch and Dps the Light one * * *");
						VBM_PlaySoundFile(VBM_SIMON_SOUND);
						VBM_Delay(0.5,VBM_PlaySoundFile,VBM_SIMON_SOUND);
					end
				end,
			},
			["Twin's Pact Kick"] = {
				event = "SPELL_INTERRUPT",
				interrupted = "Twin's Pact",
				mess = "* * * Twin's Pact Interrupted * * *",
				color = "green",
				duration = 0.1,
				func = function()
					VBM_RemoveTimer("Twin's Pact");
				end,
			},
			["Light Vortex"] = {
				event = "SPELL_CAST_START",
				spell = "Light Vortex",
				func = function()
					VBM_TwinValkyr_DoLightDark("LIGHT");
					VBM_BossTimer(45,"Next Spell",VBM_ICONS.."spell_arcane_arcanetorrent");
				end,
			},
			["Dark Vortex"] = {
				event = "SPELL_CAST_START",
				spell = "Dark Vortex",
				func = function()
					VBM_TwinValkyr_DoLightDark("DARK");
					VBM_BossTimer(45,"Next Spell",VBM_ICONS.."spell_arcane_arcanetorrent");
				end,
			},
		},
		
	};
	VBM_BOSS_DATA["Anub'arak"] = {
		spells = {
			["Leeching Swarm"] = {
				event = "SPELL_CAST_START",
				spell = "Leeching Swarm",
				mess = "* * * Phase 3 * * *",
				simonsound = true,
				func = function()
					VBM_RemoveTimer("Submerge");
					VBM_PHASE = 3;
				end,
			},
			["Shadow Strike"] = {
				event = "SPELL_CAST_START",
				spell = "Shadow Strike",
				src = "Nerubian Burrower",
				mess = "* * * Shadow Strike * * *",
				func = function()
					if(VBM_ANUB_SOUND) then
						VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
						VBM_ANUB_SOUND = false;
						VBM_Delay(4,VBM_SetTrue,"VBM_ANUB_SOUND");
						--reset SS timer
						if(not VBM_GetS("DisableAnubAddsTimers")) then
							VBM_LoopTimer_Setup(30.5,"Shadow Strike",30.5,"ability_rogue_shadowstep");
						end
					end
				end
			},
		},
		debuffs = {
			["Penetrating Cold"] = {"* * * Penetrating Cold * * *",function()
				if(VBM_PHASE == 3) then
					VBM_PlaySoundFile(VBM_SIMON_SOUND);
					VBM_Delay(0.5,VBM_PlaySoundFile,VBM_SIMON_SOUND);
				end
			end,true},
		},
		emotes = {
			["spikes pursue "..VBM_YOU] = {"* * * Spikes follow You! * * *",true},
			["spikes pursue"] = {nil,false,function(text)
				local who,f;
				f,_,who = string.find(text,"spikes pursue (.+)%!");
				if(f) then
					VBM_SetMarkOnName(who,8,20);
				end
			end},
			["burrows into the ground"] = {nil,false,function()
				VBM_BossTimer(65,"Emerge",VBM_ICONS.."spell_nature_earthquake");
				VBM_PHASE = 2;
				--remove SS timer
				VBM_LoopTimer_Remove("Nerubian Burrower");
				VBM_LoopTimer_Remove("Shadow Strike");
			end},
			["emerges from the ground"] = {nil,false,function()
				VBM_BossTimer(80-3,"Submerge",VBM_ICONS.."ability_vanish");
				VBM_PHASE = 1;
				-- delay add SS timer
				if(not VBM_GetS("DisableAnubAddsTimers")) then
					VBM_LoopTimer_Setup(5,"Nerubian Burrower",46,"ability_creature_poison_04");
					VBM_LoopTimer_Setup(5+30.5,"Shadow Strike",30.5,"ability_rogue_shadowstep");
				end
			end},
		},
		start = function()
			VBM_ANUB_SOUND = true;
			VBM_PHASE = 1;
			VBM_BossTimer(80,"Submerge",VBM_ICONS.."ability_vanish");

			-- add SS timer
			if(not VBM_GetS("DisableAnubAddsTimers")) then
				VBM_LoopTimer_Setup(10,"Nerubian Burrower",46,"ability_creature_poison_04");
				VBM_LoopTimer_Setup(30.5,"Shadow Strike",30.5,"ability_rogue_shadowstep");
			end
		end,
	};
end

function VBM_TwinValkyr_DoLightDark(db)
	if(db=="LIGHT") then
		if(not VBM_CheckForDebuff("Light Essence","player")) then
			vbm_bigwarn(vbm_c_w.."* * * Switch To Light Essence * * *");
			VBM_PlaySoundFile(VBM_BOAT_SOUND);
		end
	else
		if(not VBM_CheckForDebuff("Dark Essence","player")) then
			vbm_bigwarn(vbm_c_purple.."* * * Switch To Dark Essence * * *");
			VBM_PlaySoundFile(VBM_BOAT_SOUND);
		end
	end
end