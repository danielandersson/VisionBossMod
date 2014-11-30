--[[
	
]]--
VBM_LoadInstance["Ulduar"] = function()
	--[[
	***************************************************************
	[The Siege of Ulduar]
	* Flame Leviathan
    * XT-002 Deconstructor
    * Razorscale
    * Ignis the Furnace Master
	***************************************************************
	]]--
	
	VBM_BOSS_DATA["Flame Leviathan"] = {
		spells = {
			["Flame Vents"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Flame Vents",
				src = "Flame Leviathan",
				mess = "* * * Interrupt Now * * *",
			},
			["Flame Vents Interrupted"] = {
				event = "SPELL_INTERRUPT",
				interrupted = "Flame Vents",
				dest = "Flame Leviathan",
				mess = "* * * Success * * *",
				color = "green",
				duration = 0.1,
			},
			["Lash"] = {
				event = "SPELL_CAST_SUCCESS",
				selfdest = true,
				spell = "Lash",
				func = function()
					if(not VBM_FLOWER_TRACKER or VBM_FLOWER_TRACKER + 5 < GetTime()) then
						if(UnitExists("pet")) then
							vbm_say("Gaint Flower beating on our "..UnitName("pet"));
						end
						VBM_FLOWER_TRACKER = GetTime();
					end
				end,
			},
		},
		emotes = {
			["pursues"] = {nil,false,function(text)
				local who,f;
				f,_,who = string.find(text,"pursues (.+)%.");
				if(f) then
					VBM_BossTimer(30,"Chasing - "..who,VBM_ICONS.."spell_nature_purge");
					if(who == VBM_YOU) then
						vbm_debuffwarn("* * * Chasing You * * *");
						VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
					else
						vbm_debuffwarn(vbm_c_t.."Chasing >>"..vbm_c_w..who..vbm_c_t.."<<");
					end
				end
			end},
			["circuits overloaded"] = {nil,false,function()
				vbm_bigwarn(vbm_c_y.."* * * Stunned * * *");
				VBM_BossTimer(20,"Stunned",VBM_ICONS.."ability_rogue_kidneyshot");
				--search for all raid members who are within visible range and are not dead and point arrows to them if they are not in a Vehicle
				local i,u,p;
				for i=1,GetNumGroupMembers() do
					u = "raid"..i; p = "raid"..i.."pet";
					if(UnitExists(u) and UnitIsVisible(u) and not UnitIsDeadOrGhost(u)) then
						--now filter out all Vehicles
						if(not (UnitExists(p) and string.find(UnitName(p),"Salvaged")) ) then
							VBM_BossArrow(UnitName(u),25);
						end
					end
				end
			end},
		},
	};
	
	VBM_BOSS_DATA["XT-002 Deconstructor"] = {
		spells = {
			["Gravity Bomb Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Gravity Bomb",
				func = function(s,d)
					VBM_SetMarkOnName(d,8,9);
				end,
			},
			["Light Bomb Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Searing Light",
				func = function(s,d)
					VBM_SetMarkOnName(d,6,9);
					VBM_BossTimer(9,VBM_GetTextClassColor(VBM_GetClass(d))..d..vbm_c_w.." Searing Light",VBM_ICONS.."ability_paladin_infusionoflight");
				end,
			},
			["Tympanic Tantrum"] = {
				event = "SPELL_CAST_START",
				spell = "Tympanic Tantrum",
				texture = "spell_nature_earthquake",
				timer = 10,
				mess = "* * * Tympanic Tantrum * * *",
				pvpflag2sound = true,
			},
		},	
		emotes = {
			["heart is exposed"] = {"* * * Exposed Heart * * *",false,function()
				VBM_PlaySoundFile(VBM_SIMON_SOUND);
				VBM_BossTimer(30,"Exposed Heart",VBM_ICONS.."spell_brokenheart");
			end},
		},
		debuffs = {
			["Gravity Bomb"] = {vbm_c_purple.."* * * Gravity Bomb * * *",function() vbm_say("Gravity Bomb - "..VBM_YOU); end},
			["Searing Light"] = {vbm_c_w.."* * * Searing Light * * *",function() vbm_say("Searing Light - "..VBM_YOU); end},
		},
	};

	VBM_BOSS_DATA["Razorscale"] = {
		spells = {
			["Flame Breath"] = {
				event = "SPELL_CAST_START",
				spell = "Flame Breath",
				texture = "spell_fire_flamebolt",
				timer = 20,
			},
			["Devouring Flame"] = {
				event = "SPELL_DAMAGE",
				spell = "Devouring Flame",
				dest = VBM_YOU,
				mess = "* * Devouring Flame Damage * *",
				duration = 0.3,
				sound = true,
			},
			["Fuse Armor"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				spell = "Fuse Armor",
				amount = 2,
				logic = ">",
				dest = VBM_YOU,
				func = function(s,d,a)
					vbm_say("Fuse Armor - "..a.." Stacks");
				end,
			},
		},
		debuffs = {
			["Devouring Flame"] = {"* * Devouring Flame * *"},
		},
		emotes = {
			["Harpoon Turret is ready for use"] = {nil,false,function()
				VBM_HARPOON_C = VBM_HARPOON_C + 1;
				if(VBM_DUNGEON_SIZE==10) then
					if(VBM_HARPOON_C <= 1) then
						VBM_BossTimer(20,"Harpoon "..(VBM_HARPOON_C+1),VBM_ICONS.."inv_spear_06");
					end
				else
					if(VBM_HARPOON_C <= 3) then
						VBM_BossTimer(20,"Harpoon "..(VBM_HARPOON_C+1),VBM_ICONS.."inv_spear_06");
					end
				end
			end},
			["She won't remain grounded for long"] = {nil,false,function()
				VBM_HARPOON_C = 0;
				VBM_BossTimer(40,"Knock Back",VBM_ICONS.."inv_qiraj_carapaceoldgod");
				VBM_BossTimer(40+57,"Harpoon 1",VBM_ICONS.."inv_spear_06");
			end},
			["grounded permanently!"] = {nil,false,function()
				VBM_RemoveTimer("Knock Back");
				VBM_RemoveTimer("Harpoon 1");
			end},
			
		},
		start = function()
			VBM_HARPOON_C = 0;
		end,
	};
	
	VBM_BOSS_DATA["Ignis the Furnace Master"] = {
		spells = {
			["Scorch"] = {
				event = "SPELL_DAMAGE",
				spell = "Scorch",
				src = "Scorch",
				dest = VBM_YOU,
				mess = "* * Scorch Damage * *",
				duration = 0.3,
				sound = true,
			},
			["Flame Jets"] = {
				event = "SPELL_CAST_START",
				spell = "Flame Jets",
				texture = "spell_fire_selfdestruct",
				--timer = 20,
				sound = true,
				mess = "* * * Flame Jets ("..vbm_c_w.."3"..vbm_c_r..") * * *",
				func = function() 
					VBM_Delay(1,vbm_bigwarn,"* * * Flame Jets ("..vbm_c_w.."2"..vbm_c_r..") * * *");
					VBM_Delay(2,vbm_bigwarn,"* * * Flame Jets ("..vbm_c_w.."1"..vbm_c_r..") * * *");
					VBM_Delay(3,vbm_bigwarn,"* * * Flame Jets ("..vbm_c_w.."0"..vbm_c_r..") * * *",0.1);
				end,
			},
			["Activate Construct"] = {
				event = "SPELL_CAST_START",
				spell = "Activate Construct",
				texture = "spell_fire_burnout",
				timer = 9,
				timername = "Add Inc",
				lowersound = true,
				runesound = true,
				func = function()
					VBM_ADD_C = VBM_ADD_C + 1; 
					vbm_bigwarn(vbm_c_bronze.."* * * Add "..vbm_c_w..VBM_ADD_C..vbm_c_bronze.." Inc * * *");
				end,
			},
			["Slag Pot"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Slag Pot",
				texture = "inv_gauntlets_66",
				--timer = 20,
				simonsound = true,
				func = function(s,d)
					vbm_debuffwarn("Slag Pot >>"..vbm_c_w..d..vbm_c_r.."<<");
					VBM_BossTimer(10,VBM_GetTextClassColor(VBM_GetClass(d))..d..vbm_c_w.." Slag Pot",VBM_ICONS.."inv_gauntlets_66");
				end,
			},
			["Brittle"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Brittle",
				texture = "spell_frostresistancetotem_01",
				timer = 10,
				boatsound = true,
				func = function(s,d)
					vbm_infowarn("Brittle >>"..vbm_c_w..d..vbm_c_t.."<<");
				end,
			},
		},
		start = function()
			VBM_ADD_C = 0;
		end,
	};

	--[[
	***************************************************************
	[The Antechamber of Ulduar]
	* Iron Council
    * Auriaya
    * Kologarn
	***************************************************************
	]]--
	
	VBM_BOSS_DATA["Steelbreaker"] = {
		realname = "Iron Council",
		deadcheck = {"Steelbreaker","Runemaster Molgeim","Stormcaller Brundir"},
		spells = {
			["Rune of Summoning"] = {
				event = "SPELL_CAST_START",
				spell = "Rune of Summoning",
				mess = "* * * Rune of Summoning * * *",
				simonsound = true,
				timer = 15,
				timername = "Rune UP",
				texture = "inv_misc_rune_03",
			},
			["Rune of Power"] = {
				event = "SPELL_CAST_START",
				spell = "Rune of Power",
				pvpflag2sound = true,
				func = function()
					vbm_infowarn("* * Rune of Power inc * *");
					VBM_Delay(0.8,VBM_Iron_Council);
				end,
			},
			["Fusion Punch"] = {
				event = "SPELL_CAST_START",
				spell = "Fusion Punch",
				mess = "* * * Fusion Punch ("..vbm_c_w.."3"..vbm_c_r..") * * *",
				sound = true,
				func = function() 
					VBM_Delay(1,vbm_bigwarn,"* * * Fusion Punch ("..vbm_c_w.."2"..vbm_c_r..") * * *");
					VBM_Delay(2,vbm_bigwarn,"* * * Fusion Punch ("..vbm_c_w.."1"..vbm_c_r..") * * *");
					VBM_Delay(3,vbm_bigwarn,"* * * Fusion Punch ("..vbm_c_w.."0"..vbm_c_r..") * * *",0.1);
				end,
			},
			["Overload"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Overload",
				boatsound = true,
				texture = "spell_nature_wispsplode",
				timer = 6,
				func = function()
					vbm_debuffwarn("Stormcaller Brundir >>"..vbm_c_w.."Overload"..vbm_c_r.."<<");
				end,
			},
			["Static Disruption Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Static Disruption",
				func = function(s,d)
					VBM_SetMarkOnName(d,8,20);
					VBM_BossTimer(20,"Static Disruption",VBM_ICONS.."spell_nature_lightningoverload");
				end,
			},
		},
		debuffs = {
			["Rune of Death"] = {"* * * Rune of Death * * *"},
		},
	};
	
	VBM_BOSS_DATA["Auriaya"] = {
		spells = {
			["Terrifying Screech"] = {
				event = "SPELL_CAST_START",
				spell = "Terrifying Screech",
				mess = "* * * Fear Inc * * *",
				sound = true,
				timer = 38,
				texture = "spell_shadow_psychicscream",
			},
			["Sentinel Blast"] = {
				event = "SPELL_CAST_START",
				spell = "Sentinel Blast",
				mess = "* * * Sentinel Blast Inc * * *",
				color = "purple",
				func = function() 
					--[[
					VBM_Delay(3,vbm_bigwarn,vbm_c_y.."* * * Sentinel Blast ("..vbm_c_w.."2"..vbm_c_y..") * * *");
					VBM_Delay(4,vbm_bigwarn,vbm_c_y.."* * * Sentinel Blast ("..vbm_c_w.."1"..vbm_c_y..") * * *");
					VBM_Delay(5,vbm_bigwarn,vbm_c_y.."* * * Sentinel Blast ("..vbm_c_w.."0"..vbm_c_y..") * * *",0.1);
					]]--
				end,
			},
			["Sentinel Blast Kick"] = {
				event = "SPELL_INTERRUPT",
				interrupted = "Sentinel Blast",
				dest = "Auriaya",
				mess = "* * * Interrupted * * *",
				color = "green",
				duration = 0.1,
			},
			["Sonic Screech"] = {
				event = "SPELL_CAST_START",
				spell = "Sonic Screech",
				lowersound = true,
				mess = "* * * Sonic Screech ("..vbm_c_w.."2"..vbm_c_t..") * * *",
				texture = "ability_vehicle_sonicshockwave",
				color = "teal",
				timer = 38,
				func = function() 
					VBM_Delay(1,vbm_bigwarn,vbm_c_t.."* * * Sonic Screech ("..vbm_c_w.."1"..vbm_c_t..") * * *");
					VBM_Delay(2,vbm_bigwarn,vbm_c_t.."* * * Sonic Screech ("..vbm_c_w.."0"..vbm_c_t..") * * *",0.1);
				end,
			},
			["Guardian Swarm"] = {
				event = "SPELL_CAST_START",
				spell = "Guardian Swarm",
				simonsound = true,
				texture = "inv_jewelcrafting_blackpearlpanther",
				timer = 38,
				func = function() vbm_debuffwarn("* * * Adds Incomming * * *"); end,
			},
			["Guardian Swarm Debuff"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Guardian Swarm",
				func = function(s,d) 
					vbm_debuffwarn("* * * Adds on >>"..vbm_c_w..d..vbm_c_r.."<< * * *");
					VBM_SetMarkOnName(d,8,10);
				end,
			},
			["Seeping Feral Essence"] = {
				event = "SPELL_DAMAGE",
				spell = "Seeping Feral Essence",
				dest = VBM_YOU,
				mess = "* * Void Zone Damage * *",
				duration = 0.3,
				sound = true,
			},
			
		},
		start = function()
			VBM_BossTimer(38,"Terrifying Screech",VBM_ICONS.."spell_shadow_psychicscream");
		end
	};
	
	VBM_BOSS_DATA["Kologarn"] = {
		spells = {
			["Focused Eyebeam cast"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Focused Eyebeam",
				mess = "* * * Eyebeam * * *",
				sound = true;
			},
			["Focused Eyebeam"] = {
				event = "SPELL_DAMAGE",
				spell = "Focused Eyebeam",
				dest = VBM_YOU,
				mess = "* * Focused Eyebeam Damage * *",
				duration = 0.3,
				sound = true,
			},
			["Crunch Armor"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				spell = "Crunch Armor",
				dest = VBM_YOU,
				func = function(s,d,a)
					vbm_say("Crunch Armor - "..a.." Stacks");
				end,
			},
			["Stone Grip Cast"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Stone Grip",
				func = function() VBM_BossSend("GRIP"); end,
			},
			["Stone Grip Track"] = {
				event = "SPELL_AURA_APPLIED";
				spell = "Stone Grip",
				func = function(s,d)
					VBM_GRIP[#VBM_GRIP+1] = d;
					VBM_DelayByName("Kologarn",0.3,VBM_Kologarn_GripTracker);
				end,
			}
		},
		emotes = {
			["OBLIVION"] = {nil,false,function() 
				vbm_bigwarn("* * * Shockwave * * *");
				VBM_PlaySoundFile(VBM_SIMON_SOUND);
				VBM_BossTimer(20,"Shockwave",VBM_ICONS.."ability_warrior_shockwave");
			end},
			["focuses his eyes on you!"] = {nil,false,function() 
				vbm_say("Focused Eyebeam - "..VBM_YOU);
				VBM_PlaySoundFile(VBM_PVPFLAG_SOUND);
				vbm_debuffwarn(vbm_c_bronze.."* * * Focused Eyebeam * * *");
			end},
			
		},
		bossevent = function(msg)
			if(msg=="GRIP") then
				vbm_debuffwarn("* * * Stone Grip * * *");
				VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
			end
		end,
		start = function()
			VBM_GRIP = {};
		end,
	};
	
	--[[
	***************************************************************
	[The Keepers of Ulduar]
	* Hodir
    * Freya 
    * Thorim 
    * Mimiron 
	***************************************************************
	]]--
	
	VBM_BOSS_DATA["Hodir"] = {
		spells = {
			["Flash Freeze"] = {
				event = "SPELL_CAST_START",
				spell = "Flash Freeze",
				mess = "* * * Flash Freeze * * *",
				boatsound = true,
				texture = "ability_mage_deepfreeze",
				timer = 9;
			},
			["Storm Cloud Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Storm Cloud",
				simonsound = true,
				func = function(s,d)
					VBM_SetMarkOnName(d,2);
					vbm_debuffwarn(vbm_c_t.."Storm Cloud >>"..vbm_c_w..d..vbm_c_t.."<<");
					if(d==VBM_YOU) then
						vbm_say("Storm Cloud - "..VBM_YOU);
					end
				end,
			},
		},
		emotes = {
			["Frozen Blows"] = {nil,false,function() 
				vbm_bigwarn("* * * Frozen Blows * * *");
				VBM_PlaySoundFile(VBM_PVPFLAG2_SOUND);
				VBM_BossTimer(20,"Frozen Blows",VBM_ICONS.."spell_frost_frostbrand");
			end},
			["I am released from his grasp... at last"] = {nil,false,function() 
				VBM_Delay(5,VBM_BossDead,"Hodir");
			end},
			
			["You will suffer for this trespass!"] = {nil,false,function() 
				VBM_BossTimer(180,"Hard Mode",VBM_ICONS.."spell_shadow_unholyfrenzy");
				VBM_FAILED = false;
			end},
			
		},
		during = function()
			local i;
			for i=1,GetNumGroupMembers() do
				local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable  =  UnitDebuff("raid"..i,"Biting Cold");
				if(name and count > 2 and not VBM_FAILED) then
					VBM_FAILED = true;
					vbm_infowarn(vbm_c_w..UnitName("raid"..i)..vbm_c_bronze.." failed Getting Cold in Here");
					vbm_printc(vbm_c_w..UnitName("raid"..i)..vbm_c_p.." failed Getting Cold in Here");
				end
				if(UnitIsUnit("raid"..i,"player")) then
					if(name and count) then
						if(count > 0) then
							vbm_debuffwarn("Biting Cold ("..vbm_c_w..count..vbm_c_r..")",0.1);
							if(count > 1 and (not VBM_BITING_COLD or VBM_BITING_COLD + 3 < GetTime()) ) then
								VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
								VBM_BITING_COLD = GetTime();
							end
						end
					end
				end
			end
		end,
	};
	
	VBM_BOSS_DATA["Freya"] = {
		loadandreset = function()
			VBM_ROOTS = {};
			VBM_ROOTC = 0;
		end,
		spells = {
			["Iron Roots Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Iron Roots",
				func = function(s,d)
					VBM_ROOTS[d] = 1;
					VBM_BossArrow(d);
					VBM_Freya_RootsTracker();
				end,
			},
			["Iron Roots Tracker Removed"] = {
				event = "SPELL_AURA_REMOVED",
				spell = "Iron Roots",
				func = function(s,d)
					VBM_ROOTS[d] = nil;
					VBM_RemoveArrowByName(d);
					VBM_Freya_RootsTracker();
				end,
			},
			["Nature's Fury Tracker"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Nature's Fury",
				func = function(s,d)
					VBM_SetMarkOnName(d,8,10);
				end,
			},
			["Eonar's Gift Tracker"] = {
				event = "UNIT_DIED",
				dest = "Eonar's Gift",
				func = function()
					VBM_RemoveTimer("Eonar's Gift");
				end,
			},
			["Ground Tremor"] = {
				event = "SPELL_CAST_START",
				spell = "Ground Tremor",
				--timer = 30,
				texture = "spell_nature_earthquake",
				boatsound = true,
				func = function()
					vbm_bigwarn("* * * Ground Tremor ("..vbm_c_w.."2"..vbm_c_r..") * * *"); 
					VBM_Delay(1,vbm_bigwarn,"* * * Ground Tremor ("..vbm_c_w.."1"..vbm_c_r..") * * *");
					VBM_Delay(2,vbm_bigwarn,"* * * Ground Tremor ("..vbm_c_w.."0"..vbm_c_r..") * * *",0.1);
					VBM_Delay(3,VBM_Freya_RootsTracker);
				end,
			},
			--[[ ["Sunbeam"] = {
				event = "SPELL_CAST_START",
				spell = "Sunbeam",
				func = function() 
					VBM_Delay(0.2,VBM_BossTargetYouWarning,"Freya",vbm_c_purple.."* * * Sunbeam * * *","Sunbeam - "..VBM_YOU,nil,"info");
				end,
			}, ]]
			--easy mode add 
			["Impale"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Impale",
				func = function(s,d) vbm_debuffwarn("Impale - "..vbm_c_w..d); end,
			},
		},		
		emotes = {
			["Allies of Nature have appeared"] = {nil,false,function() 
				VBM_BossTimer(60,"Next Adds Wave",VBM_ICONS.."inv_sword_04");
			end},
			["begins to grow"] = {nil,false,function()
				vbm_infowarn(vbm_c_bronze.."* * * Tree Up * * *");
				VBM_PlaySoundFile(VBM_RUNE_SOUND);
				VBM_BossTimer(20,"Eonar's Gift",VBM_ICONS.."inv_misc_plant_03");
			end},
			["His hold on me dissipates."] = {nil,false,function() 
				VBM_Delay(15,VBM_BossDead,"Freya");
			end},
		},
		debuffs = {
			["Nature's Fury"] = {"* * * Nature's Fury * * *",function()
				VBM_Flash(3,2,0.5,0.2,0,1);
				vbm_say("Nature's Fury - "..VBM_YOU);
				VBM_Delay(3,vbm_say,"Nature's Fury - "..VBM_YOU);
				VBM_Delay(6,vbm_say,"Nature's Fury - "..VBM_YOU);
			end},
			["Unstable Energy"] = {"* * * Unstable Energy * * *",function()
				VBM_Flash(3,1.2,0.4);
			end},
			
		},
	};
	
	VBM_BOSS_DATA["Thorim"] = {
		rangecheck = 10,
		rccount = 3,
		spells = {
			["Lightning Shock"] = {
				event = "SPELL_DAMAGE",
				spell = "Lightning Shock",
				dest = VBM_YOU,
				mess = "* * Lightning Shock Damage * *",
				duration = 0.3,
				sound = true,
			},-- Lightning Charge    
			["Lightning Charge"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Lightning Charge",
				dest = "Thunder Orb",
				func = function()
					VBM_COUNT_U = VBM_COUNT_U + 1;
					VBM_BossTimer(16,"Charge "..VBM_COUNT_U,VBM_ICONS.."spell_lightning_lightningbolt01");
				end,
			},
			["Unbalancing Strike"] = {
				event = "SPELL_DAMAGE",
				spell = "Unbalancing Strike",
				timer = 25,
				simonsound = true,
				texture = "ability_warrior_decisivestrike",
				func = function(s,d) vbm_debuffwarn("Unbalancing Strike - "..vbm_c_w..d); end,
			},
			["Unbalancing Strike Miss"] = {
				event = "SPELL_MISSED",
				spell = "Unbalancing Strike",
				timer = 25,
				--simonsound = true,
				timername = "Unbalancing Strike",
				texture = "ability_warrior_decisivestrike",
				func = function(s,d,a) vbm_debuffwarn(vbm_c_w.."Unbalancing Strike "..a); end,
			},
			--hard mode
			["Frost Nova"] = {
				event = "SPELL_CAST_START",
				spell = "Frost Nova",
				src = "Sif",
				pvpflag1sound = true,
				--timer = 21,
				texture = "spell_frost_frostnova",
				func = function() 
					vbm_infowarn(vbm_c_t.."* * * Frost Nova ("..vbm_c_w.."2.5"..vbm_c_t..") * * *");
					VBM_Delay(0.5,vbm_infowarn,vbm_c_t.."* * * Frost Nova ("..vbm_c_w.."2"..vbm_c_t..") * * *");
					VBM_Delay(1.5,vbm_infowarn,vbm_c_t.."* * * Frost Nova ("..vbm_c_w.."1"..vbm_c_t..") * * *");
					VBM_Delay(2.5,vbm_infowarn,vbm_c_t.."* * * Frost Nova ("..vbm_c_w.."0"..vbm_c_t..") * * *",0.1);
				end,
			},
		},
		emotes = {
			["Stay your arms! I yield!"] = {nil,false,function() 
				VBM_Delay(15,VBM_BossDead,"Thorim");
			end},
		},
		start = function()
			VBM_COUNT_U = 0;
		end,
	};
	
	VBM_BOSS_DATA["Leviathan Mk II"] = {
		realname = "Mimiron",
		deadcheck = {"Aerial Command Unit"}, --Leviathan Mk II            VX-001                Aerial Command Unit               
		start = function() 
			VBM_BossStart("Aerial Command Unit");
			VBM_PHASE = 1;
			VBM_LEVI = 100;
			VBM_VX = 100;
			VBM_ACU = 100;
		end,
		during = function()
			if(VBM_PHASE == 4) then
				--find a boss
				local i,hp;
				for i = 1, GetNumGroupMembers() do
					if(UnitExists("raid"..i.."target") and UnitName("raid"..i.."target") == "Leviathan Mk II") then
						hp = VBM_UnitHealthPercent("raid"..i.."target",true);
						if(hp ~= VBM_LEVI) then
							VBM_LEVI = hp;
							VBM_Mimiron_Update(hp,"LEVI");
						end
					elseif(UnitExists("raid"..i.."target") and UnitName("raid"..i.."target") == "VX-001") then
						hp = VBM_UnitHealthPercent("raid"..i.."target",true);
						if(hp ~= VBM_VX) then
							VBM_VX = hp;
							VBM_Mimiron_Update(hp,"VX");
						end
					elseif(UnitExists("raid"..i.."target") and UnitName("raid"..i.."target") == "Aerial Command Unit") then
						hp = VBM_UnitHealthPercent("raid"..i.."target",true);
						if(hp ~= VBM_ACU) then
							VBM_ACU = hp;
							VBM_Mimiron_Update(hp,"ACU");
						end
					end
				end
			end
		end,
		spells = {
			--hard mode
			["Flames"] = {
				event = "SPELL_DAMAGE",
				spell = "Flames",
				dest = VBM_YOU,
				func = function() VBM_Flash(1,0.5,0.4); end,
				sound = true,
			},
			-- FAS 1
			["Napalm Shell"] = {
				event = "SPELL_CAST_START",
				spell = "Napalm Shell",
				lowersound = true,
				func = function() 
					vbm_debuffwarn("* * * Napalm Shell ("..vbm_c_w.."3"..vbm_c_r..") * * *");
					VBM_DelayByName("mir4",1,vbm_debuffwarn,"* * * Napalm Shell ("..vbm_c_w.."2"..vbm_c_r..") * * *");
					VBM_DelayByName("mir5",2,vbm_debuffwarn,"* * * Napalm Shell ("..vbm_c_w.."1"..vbm_c_r..") * * *");
					VBM_DelayByName("mir6",3,vbm_debuffwarn,"* * * Napalm Shell ("..vbm_c_w.."0"..vbm_c_r..") * * *",0.1);
				end,
			},
			["Plasma Blast"] = {
				event = "SPELL_CAST_START",
				spell = "Plasma Blast",
				simonsound = true,
				timer = 30,
				texture = "spell_fire_incinerate",
				func = function() 
					vbm_bigwarn(vbm_c_t.."* * * Plasma Blast ("..vbm_c_w.."3"..vbm_c_t..") * * *");
					VBM_DelayByName("mir1",1,vbm_bigwarn,vbm_c_t.."* * * Plasma Blast ("..vbm_c_w.."2"..vbm_c_t..") * * *");
					VBM_DelayByName("mir2",2,vbm_bigwarn,vbm_c_t.."* * * Plasma Blast ("..vbm_c_w.."1"..vbm_c_t..") * * *");
					VBM_DelayByName("mir3",3,vbm_bigwarn,vbm_c_t.."* * * Plasma Blast ("..vbm_c_w.."0"..vbm_c_t..") * * *",0.1);
				end,
			},
			["Shock Blast"] = {
				event = "SPELL_CAST_START",
				spell = "Shock Blast",
				texture = "spell_nature_groundingtotem",
				timer = 4,
				boatsound = true,
				func = function()
					vbm_cleardebuffwarn();
					vbm_infowarn(vbm_c_y.."* * * Shock Blast Move Out * * *");
					VBM_DelayRemove("mir1");VBM_DelayRemove("mir2");VBM_DelayRemove("mir3");
					VBM_DelayRemove("mir4");VBM_DelayRemove("mir5");VBM_DelayRemove("mir6");
				end,
			},
			["Second Boss Inc"] = {
				event = "UNIT_DIED",
				dest = "Leviathan Mk II",
				timer = 49,
				mess = "* * * WATCH OUT FOR THE MINES * * *",
				duration = 20,
				texture = "inv_sword_04",
			},
			["Proximity Mines"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Proximity Mines",
				func = function() vbm_smallwarn("* * * PROXIMITY MINES * * *") end,
			},
			
			-- FAS 2
			["Spinning Up"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Spinning Up",
				mess = "* * * Spinning Up * * *",
				color = "teal",
				texture = "spell_arcane_arcanetorrent",
				timer = 14,
				simonsound = true,
			},
			["Rocket Strike"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Rocket Strike",
				mess = "* * * Rocket Strike * * *",
				sound = true,
			},
			-- FAS 3
			["Magnetic Field"] = {
				event = "SPELL_AURA_APPLIED";
				spell = "Magnetic Field",
				simonsound = true,
				func = function(s,d)
					vbm_debuffwarn(vbm_c_y.."Magnetic Field >>"..vbm_c_w..d..vbm_c_y.."<<");
					VBM_SetMarkOnName(d,8,10);
				end,
			},
			["Bomb Bot"] = {
				event = "SPELL_SUMMON",
				src = "Aerial Command Unit",
				spell = "Bomb Bot",
				mess = "* * * Bomb Bot Spawned * * *",
				sound = true,
			},
			
		},
		debuffs = {
			["Napalm Shell"] = {"* * * Napalm Shell * * *",function() vbm_say("Napalm Shell - "..VBM_YOU); end},
		},
		emotes = {
			["Your efforts have yielded some fantastic data"] = {nil,false,function() 
				VBM_BossTimer(23,"Third Boss Inc",VBM_ICONS.."inv_sword_04");
			end},
			["Preliminary testing phase complete"] = {nil,false,function() 
				VBM_BossTimer(25,"Fourth Boss Inc",VBM_ICONS.."inv_sword_04");
				VBM_PHASE = 4;
			end},
		},
		
	};

	--[[
	***************************************************************
	[The Descent into Madness]
	* General Vezax 
    * Yogg-Saron 
    * Algalon the Observer
	***************************************************************
	]]--
	VBM_BOSS_DATA["General Vezax"] = {
		spells = {
			["Searing Flames"] = {
				event = "SPELL_CAST_START",
				spell = "Searing Flames",
				mess = "* * * Kick Now * * *",
				lowersound = true,
			},
			["Searing Flames Interrupted"] = {
				event = "SPELL_INTERRUPT",
				interrupted = "Searing Flames",
				dest = "General Vezax",
				mess = "* * * Success * * *",
				color = "green",
				duration = 0.1,
			},
			["Surge of Darkness"] = {
				event = "SPELL_CAST_START",
				spell = "Surge of Darkness",
				mess = "* * * Kite Phase * * *",
				simonsound = true,
				timer = 13,
				timername = "Tank Phase",
				simonsound = true,
				texture = "spell_shadow_shadowpower",
			},
			["Surge of Darkness Removed"] = {
				event = "SPELL_AURA_REMOVED",
				spell = "Surge of Darkness",
				color = "green",
				mess = "* * * Tank Phase * * *",
				timername = "Kite Phase",
				timer = 50,
				texture = "spell_shadow_shadowpower",
			},
			["Mark of the Faceless"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Mark of the Faceless",
				func = function(s,d)
					VBM_SetMarkOnName(d,6,10);
				end,
			},
			["Shadow Crash"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Shadow Crash",
				src = "General Vezax",
				func = function()
					VBM_General_Vezax_Crash = true;
					VBM_Delay(1.5,function() VBM_General_Vezax_Crash = false; end);
				end,
			},
			["Saronite Vapors"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				spell = "Saronite Vapors",
				dest = VBM_YOU,
				func = function(s,d,a)
					vbm_infowarn("Saronite Vapors ("..vbm_c_w..a..vbm_c_t..")");
				end,
			},
		},
		emotes = {
			["A cloud of saronite vapors"] = {nil,false,function() 
				VBM_CLOUD_COUNTER = VBM_CLOUD_COUNTER + 1;
				VBM_BossTimer(30,"Cloud "..VBM_CLOUD_COUNTER+1,VBM_ICONS.."inv_ore_saronite_01");
				vbm_infowarn("* * Cloud "..vbm_c_w..VBM_CLOUD_COUNTER..vbm_c_t.." Spawned * *");
			end},
		},
		loadandreset = function()
			VBM_GENERAL_VEZAX_LAST_TARGET = "none";
		end,
		start = function()
			VBM_CLOUD_COUNTER = 0;
			VBM_BossTimer(30,"Cloud "..VBM_CLOUD_COUNTER+1,VBM_ICONS.."inv_ore_saronite_01");
			VBM_BossTimer(60,"Kite Phase",VBM_ICONS.."spell_shadow_shadowpower");
		end,
		debuffs = {
			["Mark of the Faceless"] = {"* * * Mark of the Faceless * * *",function()
				vbm_say("Mark of the Faceless - "..VBM_YOU);
				VBM_Flash(3,1.2,0.4);
			end},
		},
		during = function()
			--find boss
			local target = false;
			local i;
			for i = 1, GetNumGroupMembers() do
				--find a valid unit for boss
				if(UnitExists("raid"..i.."target") and UnitName("raid"..i.."target") == "General Vezax") then
					target = "raid"..i.."target";
					break;
				end
				if(UnitExists("raid"..i.."pettarget") and UnitName("raid"..i.."pettarget") == "General Vezax") then
					target = "raid"..i.."pettarget";
					break;
				end
			end
			if(target) then
				if(UnitExists(target.."target")) then
					if(UnitHealthMax(target.."target") > VBM_TANKHP) then
						--tank is targeted no warning
					else
						--none tank is targetd
						if(VBM_GENERAL_VEZAX_LAST_TARGET ~= UnitName(target.."target") and VBM_General_Vezax_Crash) then
							--if its you warn
							if(UnitName(target.."target") == VBM_YOU) then
								vbm_say("Shadow Crash - "..VBM_YOU);
								VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
								vbm_bigwarn("* * * Shadow Crash * * *",5,1,0,1);
							end
							--set raid mark
							VBM_SetMarkOn(target.."target",8,8);
						end
					end
					VBM_GENERAL_VEZAX_LAST_TARGET = UnitName(target.."target");
				else
					--none is targeted
					VBM_GENERAL_VEZAX_LAST_TARGET = "none";
				end
			end
		end,
	};
	
	VBM_BOSS_DATA["Yogg-Saron Dummy"] = {
		realname = "Yogg-Saron",
		spells = {
			["Yogg Died"] = {
				event = "UNIT_DIED",
				dest = "Yogg-Saron",
				func = function()
					VBM_BossDead("Yogg-Saron Dummy");
				end,
			},
			["Lunatic Gaze"] = {
				event = "SPELL_CAST_SUCCESS",
				src = "Yogg-Saron",
				spell = "Lunatic Gaze",
				boatsound = true,
				timer = 4,
				texture = "spell_shadow_devouringplague",
				mess = "* * * Turn away * * *",
				func = function() VBM_BossTimer(13,"Gaze Cooldown",VBM_ICONS.."spell_shadow_devouringplague"); end,
			},
			["Brain Link Track"] = {
				event = "SPELL_AURA_APPLIED";
				spell = "Brain Link",
				func = function(s,d)
					VBM_BRAIN[#VBM_BRAIN+1] = d;
					VBM_DelayByName("Yogg1",0.3,VBM_YoggSaron_BrainLink);
				end,
			},
			["Sara Dead Tracker"] = {
				event = "SPELL_DAMAGE";
				spell = "Shadow Nova",
				dest = "Sara",
				overkilled = true,
				mess = "* * * Sara Dead * * *",
				sound = true,
			},
			["Squeeze Tracker"] = {
				event = "SPELL_AURA_APPLIED";
				spell = "Squeeze",
				simonsound = true,
				func = function(s,d)
					vbm_infowarn("Squeeze >>"..vbm_c_w..d..vbm_c_t.."<<");
					VBM_BossArrow(d);
					VBM_SetMarkOnName(d,2,20);
				end,
			},
			["Squeeze Removed Tracker"] = {
				event = "SPELL_AURA_REMOVED";
				spell = "Squeeze",
				func = function(s,d)
					VBM_RemoveArrowByName(d);
				end,
			},
			["Sara HP Tracker"] = {
				event = "SPELL_DAMAGE";
				spell = "Shadow Nova",
				dest = "Sara",
				func = function(s,d,a)
					VBM_SARA = VBM_SARA - a;
					if(VBM_SARA < 0) then VBM_SARA = 0; end
					vbm_infowarn("Sara HIT "..vbm_c_w..VBM_round((VBM_SARA/VBM_SARAMAX)*100).."%"..vbm_c_t.." left");
				end,
			},
			["Influence Tentacle"] = {
				event = "UNIT_DIED";
				dest = "Influence Tentacle",
				func = function(s,d,a)
					VBM_TENT_C = VBM_TENT_C + 1;
					vbm_infowarn(vbm_c_w..VBM_TENT_C..vbm_c_t.." killed");
				end,
			},
			
		},
		emotes = {
			["Portal"] = {"* * * Portal Up * * *",false,function()
				VBM_TENT_C = 0;
				VBM_BossTimer(90,"Portal",VBM_ICONS.."spell_shadow_twilight");
				VBM_PORTAL = true;
				VBM_PlaySoundFile(VBM_RUNE_SOUND);
			end},
			["I am the lucid dream."] = {"* * * Yogg-Saron Inc * * *",true,function()
				VBM_BossTimer(16,"Yogg-Saron",VBM_ICONS.."inv_sword_04");
				VBM_Delay(16,VBM_BossTimer,60,"Portal",VBM_ICONS.."spell_shadow_twilight");
			end},
			
		},
		during = function()
			--timer
			if(UnitExists("target") and VBM_PORTAL) then
				local spell, rank, displayName, icon, startTime, endTime, isTradeSkill = UnitCastingInfo("target")
				if(spell == "Induce Madness") then
					VBM_PORTAL = false;
					VBM_BossSend("PORT "..(endTime/1000)-GetTime());
				end
			end
			--sanity count
			local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable  =  UnitDebuff("player","Sanity");
			
			if(name and count) then
				if(count < 41) then
					vbm_bigwarn("> > > Sanity ("..vbm_c_w..count..vbm_c_r..") < < <",0.1);
					if(count < 31) then
						if(not VBM_SANITY or VBM_SANITY + 3 < GetTime()) then
							VBM_PlaySoundFile(VBM_LOWER_DONG_SOUND);
							VBM_SANITY = GetTime();
						end
					end
				end
			end
		end,
		start = function()
			VBM_PORTAL = false;
			VBM_BRAIN = {};
			VBM_SARA = 200000;
			VBM_SARAMAX = 200000;
		end,
		bossevent = function(msg)
			local found,p1;
			found,_,p1 = string.find(msg,"PORT (.+)");
			if(found) then
				local timer = tonumber(p1);
				VBM_BossTimer(timer-0.5,"Induce Madness",VBM_ICONS.."spell_shadow_devouringplague",true);
			end
		end,
	};
	
	VBM_BOSS_DATA["Algalon the Observer"] = {
		spells = {
			["Cosmic Smash"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Cosmic Smash",
				texture = "spell_fire_burnout",
				timer = 25,
				sound = true,
				func = function()
					vbm_bigwarn("* * * Cosmic Smash ("..vbm_c_w.."5"..vbm_c_r..") * * *");
					VBM_BossTimer(5,"Cosmic Smash Landing",VBM_ICONS.."spell_fire_flamebolt");
					VBM_Delay(1,vbm_bigwarn,"* * * Cosmic Smash ("..vbm_c_w.."4"..vbm_c_r..") * * *");
					VBM_Delay(2,vbm_bigwarn,"* * * Cosmic Smash ("..vbm_c_w.."3"..vbm_c_r..") * * *");
					VBM_Delay(3,vbm_bigwarn,"* * * Cosmic Smash ("..vbm_c_w.."2"..vbm_c_r..") * * *");
					VBM_Delay(4,vbm_bigwarn,"* * * Cosmic Smash ("..vbm_c_w.."1"..vbm_c_r..") * * *");
					VBM_Delay(5,vbm_bigwarn,"* * * Cosmic Smash ("..vbm_c_w.."0"..vbm_c_r..") * * *",0.1);
				end,
			},
			["Big Bang"] = {
				event = "SPELL_CAST_START",
				spell = "Big Bang",
				mess = "* * * Big Bang * * *",
				boatsound = true,
				texture = "spell_holy_surgeoflight",
				timer = 90,
				func = function() VBM_BossTimer(8,"Big Bang Casting",VBM_ICONS.."spell_holy_surgeoflight"); end,
			},
			["Ascend to the Heavens"] = {
				event = "SPELL_CAST_START",
				spell = "Ascend to the Heavens",
				mess = "* * * Ascend to the Heavens * * *",
				color = "teal",
				pvpflag2sound = true,
			},
			["Ascend to the Heavens Interrupted"] = {
				event = "SPELL_INTERRUPT",
				interrupted = "Ascend to the Heavens",
				dest = "Algalon the Observer",
				mess = "* * * Interrupted * * *",
				color = "green",
				duration = 0.1,
			},
			["Phase Punch"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Phase Punch",
				texture = "spell_shadow_twistedfaith",
				timer = 16,
				func = function() vbm_smallwarn("* * * PHASE PUNCH * * *") end,
			},
		},
		debuffs = {
			["Black Hole"] = {nil,function()
				VBM_BossTimer(10,"Black Hole",VBM_ICONS.."spell_shadow_twilight");
			end,nil,function()
				VBM_RemoveTimer("Black Hole");
			end},
		},
		emotes = {
			--["Summon Collapsing Stars"] = {nil,false,function()
			--	VBM_BossTimer(60,"Collapsing Star",VBM_ICONS.."inv_jewelry_necklace_11");
			--end},
			["Your actions are illogical. All possible results for this encounter have been calculated"] = {nil,false,function()
				VBM_DelayByName("ALGALONGO",8,function()
					VBM_BossTimer(15,"Collapsing Star",VBM_ICONS.."inv_jewelry_necklace_11");
					VBM_BossTimer(16,"Phase Punch",VBM_ICONS.."spell_shadow_twistedfaith");
					VBM_BossTimer(25,"Cosmic Smash",VBM_ICONS.."spell_fire_burnout");
					VBM_BossTimer(90,"Big Bang",VBM_ICONS.."spell_holy_surgeoflight");
				end);
			end},
			["See your world through my eyes"] = {nil,false,function()
				VBM_DelayByName("ALGALONGO",8,function()
					VBM_BossTimer(15,"Collapsing Star",VBM_ICONS.."inv_jewelry_necklace_11");
					VBM_BossTimer(16,"Phase Punch",VBM_ICONS.."spell_shadow_twistedfaith");
					VBM_BossTimer(25,"Cosmic Smash",VBM_ICONS.."spell_fire_burnout");
					VBM_BossTimer(90,"Big Bang",VBM_ICONS.."spell_holy_surgeoflight");
				end);
			end},
		},
	};
	
	--[[
	***************************************************************
	TRASH
	***************************************************************
	]]--
	VBM_BOSS_DATA["Trash"] = {
		spells = {
			["Shadow Crash TRASH"] = {
				event = "SPELL_CAST_START",
				spell = "Shadow Crash",
				func = function()
					VBM_Delay(VBM_BOSSTARGETYOUDELAY,VBM_BossTargetYouWarning,"Faceless Horror","* * Shadow Crash on You * *","Shadow Crash - "..VBM_YOU);
				end,
			},
			["Summon Charged Sphere"] = {
				event = "SPELL_CAST_START",
				spell = "Summon Charged Sphere",
				mess = "* * * Casting Sphere * * *",
				simonsound = true,
			},
			--Flaming Rune     Rune Etched Sentry
		},
		debuffs = {
			["Flaming Rune"] = {"* * * Flaming Rune * * *"},
			["Hurricane"] = {"* * * Hurricane * * *"},
			["Runic Etched Flame"] = {"* * * Runic Etched Flame * * *",function() vbm_say("Runic Etched Flame - "..VBM_YOU); end},
			["Fuse Lightning"] = {"* * * Fuse Lightning * * *",function() vbm_say("Fuse Lightning - "..VBM_YOU); end},
		},
		emotes = {
			--mirmiron
			["test out my latest and greatest creation"] = {nil,false,function() --Mimiron
				VBM_BossTimer(8,"First Boss Inc (Easy Mode)",VBM_ICONS.."inv_sword_04");
			end},
			["Self%-destruct sequence initiated"] = {nil,false,function() --Mimiron
				VBM_BossTimer(10,"First Boss Inc (Hard Mode)",VBM_ICONS.."inv_sword_04");
			end},
			--yogg-saron
			["The time to strike at the head of the beast will soon be upon us! Focus your anger and hatred on his minions!"] = {nil,false,function()
				VBM_BossReset("Yogg-Saron Dummy");
				VBM_BossStart("Yogg-Saron Dummy");
			end},
			--saftey start of razorscale
			["Be on the lookout! Mole machines will be surfacing soon with those nasty Iron dwarves aboard!"] = {nil,false,function()
				VBM_BossStart("Razorscale");
				VBM_BossTimer(52,"Harpoon 1",VBM_ICONS.."inv_spear_06");
			end},
			--thorim start
			["Why else would these invaders have come into your sanctum but to slay you"] = {nil,false,function() 
				VBM_BossTimer(157,"Hard Mode",VBM_ICONS.."spell_shadow_unholyfrenzy");
				VBM_BossReset("Thorim");
				VBM_COUNT_U = 1;
			end},
		},
		
		
	};
end

function VBM_Iron_Council()
	--find boss
	local target = false;
	local i;
	for i = 1, GetNumGroupMembers() do
		--find a valid unit for boss
		if(UnitExists("raid"..i.."target") and UnitName("raid"..i.."target") == "Runemaster Molgeim") then
			target = "raid"..i.."target";
			break;
		end
	end
	if(target) then
		if(UnitExists(target.."target")) then
			vbm_infowarn("Rune of Power >>"..vbm_c_w..UnitName(target.."target")..vbm_c_t.."<<");
		end
	end
end

function VBM_Kologarn_GripTracker()
	table.sort(VBM_GRIP);
	vbm_debuffwarn("Stone Grip >>"..vbm_c_w..table.concat(VBM_GRIP,", ")..vbm_c_r.."<<");
	VBM_BossTimer(15,"Stone Grip Kills",VBM_ICONS.."ability_warrior_secondwind");
	for i=1,#VBM_GRIP do
		VBM_SetMarkOnName(VBM_GRIP[i],i,15);
	end
	VBM_GRIP = {};
end

function VBM_Freya_RootsTracker()
	local d = {};
	local a,b;
	for a,b in pairs(VBM_ROOTS) do
		d[#d+1] = a;
	end
	table.sort(d);
	if(VBM_ROOTC==0 and #d > 0) then
		VBM_PlaySoundFile(VBM_SIMON_SOUND);
	end
	if(#d > 0) then
		vbm_bigwarn(vbm_c_t.."Iron Roots >>"..vbm_c_w..table.concat(d,", ")..vbm_c_t.."<<",10);
	else
		vbm_clearbigwarn();
	end
	--VBM_BossTimer(30,"Iron Roots",VBM_ICONS.."spell_nature_stranglevines");
	
	for i=1,#d do
		VBM_SetMarkOnName(d[i],8-i,10);
	end
	VBM_ROOTC = #d;
end

function VBM_YoggSaron_BrainLink()
	table.sort(VBM_BRAIN);
	--if you have brainlink
	if(VBM_BRAIN[1] == VBM_YOU or VBM_BRAIN[2] == VBM_YOU) then
		vbm_debuffwarn("Brain Link >>"..vbm_c_w..table.concat(VBM_BRAIN,", ")..vbm_c_r.."<<");
		VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
	end
	--set mark on all
	for i=1,#VBM_BRAIN do
		if(i==1) then
			VBM_SetMarkOnName(VBM_BRAIN[i],3,15);
		else
			VBM_SetMarkOnName(VBM_BRAIN[i],5,15);
		end
	end
	VBM_BRAIN = {};
end

function VBM_Mimiron_Update(hp,b)
	local head,body,foot = vbm_c_w,vbm_c_w,vbm_c_w;
	
	local s = {VBM_ACU,VBM_VX,VBM_LEVI};
	
	table.sort(s);
	
	if(VBM_ACU == s[1]) then
		head = vbm_c_g;
	end
	if(VBM_VX == s[1]) then
		body = vbm_c_g;
	end
	if(VBM_LEVI == s[1]) then
		foot = vbm_c_g;
	end

	if(hp < 11 or hp == 15 or hp == 20 or hp == 30 or hp == 40) then
		vbm_print(vbm_c_p.."["..vbm_c_grey.."Head"..vbm_c_p.."] "..head..VBM_ACU.."%"..vbm_c_p.." <===> "..
			"["..vbm_c_grey.."Body"..vbm_c_p.."] "..body..VBM_VX.."%"..vbm_c_p.." <===> "..
			"["..vbm_c_grey.."Foot"..vbm_c_p.."] "..foot..VBM_LEVI.."%");
	end
end
