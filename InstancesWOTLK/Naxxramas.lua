--[[
	
]]--
VBM_LoadInstance["Naxxramas"] = function()
	--[[ **********************
			Spider Wing
		*********************]]--
	VBM_BOSS_DATA["Anub'Rekhan"] = {
		spells = {
			["Locust Swarm"] = {
				event = "SPELL_CAST_START",
				src = "Anub'Rekhan",
				spell = "Locust Swarm",
				mess = "* * * Locust Swarm * * *",
				sound = true,
				timer = 20,
				timername = "Swarm Up",
				texture = "ability_hibernation",
				func = function() VBM_Delay(3,VBM_BossTimer,90,"Locust Swarm",VBM_ICONS.."spell_nature_insectswarm"); end,
			},
		},
		start = function() VBM_BossTimer(90,"Locust Swarm",VBM_ICONS.."spell_nature_insectswarm"); end,
	};
	VBM_BOSS_DATA["Grand Widow Faerlina"] = {
		spells = {
			["Frenzy gain"] = {
				event = "SPELL_AURA_APPLIED",
				dest = "Grand Widow Faerlina",
				spell = "Frenzy",
				mess = "* * * Frenzy * * *",
				sound = true,
			},
			["Frenzy lose"] = {
				event = "SPELL_AURA_REMOVED",
				dest = "Grand Widow Faerlina",
				spell = "Frenzy",
				timer = 60,
				timername = "Frenzy",
				texture = "spell_shadow_unholyfrenzy",
			},
			["Widow's Embrace"] = {
				event = "SPELL_AURA_APPLIED",
				dest = "Grand Widow Faerlina",
				spell = "Widow's Embrace",
				timer = 30,
				timername = "Silence",
				texture = "spell_arcane_blink",
			},
		},
		start = function() VBM_BossTimer(60,"Frenzy",VBM_ICONS.."spell_shadow_unholyfrenzy"); end,
	};
	VBM_BOSS_DATA["Maexxna"] = {
		spells = {
			["Web Spray"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Web Spray",
				timer = 40,
				texture = "spell_nature_web",
			},
		},
		start = function() VBM_BossTimer(40,"Web Spray",VBM_ICONS.."spell_nature_web"); end,
	};
	--[[ **********************
			Plague Wing
		*********************]]--
	
	VBM_BOSS_DATA["Noth the Plaguebringer"] = {
		start = function() 
			VBM_BossTimer(60+30,"Port Up 1",VBM_ICONS.."spell_arcane_blink");
			VBM_BossTimer(60*4+30,"Port Up 2",VBM_ICONS.."spell_arcane_blink");
			VBM_BossTimer(60*2+40,"Port Down 1",VBM_ICONS.."spell_arcane_blink");
			VBM_BossTimer(60*6+5,"Port Down 2",VBM_ICONS.."spell_arcane_blink");
		end,
	};
	
	VBM_BOSS_DATA["Heigan the Unclean"] = {
		emotes = {
			["The end is upon you"] = {"* * * Dance * * *",true,function() 
				VBM_BossTimer(45,"Dance end",VBM_ICONS.."inv_rosebouquet01");
				VBM_Delay(45,VBM_BossTimer,90,"Dance",VBM_ICONS.."ability_hibernation");
			end},
		},
		
		start = function() VBM_BossTimer(90,"Dance",VBM_ICONS.."ability_hibernation"); end,
	};
	
	
	VBM_BOSS_DATA["Loatheb"] = {
		spells = {
			["Summon Spore"] = {
				event = "SPELL_CAST_SUCCESS",
				src = "Loatheb",
				spell = "Summon Spore",
				mess = "* * * Spore Spawned * * *";
			},
			["Inevitable Doom"] = {
				event = "SPELL_CAST_SUCCESS",
				src = "Loatheb",
				spell = "Inevitable Doom",
				func = function()
					VBM_Loatheb_cc = VBM_Loatheb_cc+1;
					if(VBM_Loatheb_cc >= 7) then
						if(VBM_Loatheb_cc % 2==0) then
							VBM_BossTimer(17,"Inevitable Doom",VBM_ICONS.."spell_shadow_nightofthedead");
						else
							VBM_BossTimer(13,"Inevitable Doom",VBM_ICONS.."spell_shadow_nightofthedead");
						end
					else
						VBM_BossTimer(30,"Inevitable Doom",VBM_ICONS.."spell_shadow_nightofthedead");
					end
				end
			},
			
		},
		debuffs = {
			["Necrotic Aura"] = {nil,function() VBM_BossTimer(17,"Heal Again",VBM_ICONS.."ability_creature_disease_05"); end,true},
		},
		
		start = function() VBM_BossTimer(120,"Inevitable Doom",VBM_ICONS.."spell_shadow_nightofthedead"); VBM_Loatheb_cc = 0; end,
	};
	--[[ **********************
			Abonation Wing
		*********************]]--
	VBM_BOSS_DATA["Patchwerk"] = {
		--start = function() VBM_BossTimer(7*60,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy"); end,
	};
	VBM_BOSS_DATA["Grobbulus"] = {
		debuffs = {
			["Mutating Injection"] = {"* * * Mutating Injection * * *"},
		},
		spells = {
			["Slime Spray"] = {
				event = "SPELL_CAST_SUCCESS",
				src = "Grobbulus",
				spell = "Slime Spray",
				mess = "* * * Adds Spawned * * *",
			},
			["Mutating Explosion"] = {
				event = "SPELL_CAST_SUCCESS",
				src = "Grobbulus",
				spell = "Mutating Injection",
				func = function(src,dest) VBM_SetMarkOnName(dest,8,10); VBM_BossTimer(10,VBM_GetTextClassColor(VBM_GetClass(dest))..dest..vbm_c_w.." Explode",VBM_ICONS.."spell_shadow_callofbone"); end,
			},
		},
	};
	VBM_BOSS_DATA["Gluth"] = {
		emotes = {
			["decimate"] = {"* * * Decimate * * *",true,function() 
				VBM_BossTimer(110,"Decimate",VBM_ICONS.."spell_nature_purge");
			end},
		},
		start = function() 
			VBM_BossTimer(110,"Decimate",VBM_ICONS.."spell_nature_purge"); 
			--VBM_BossTimer(60*7,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy");
		end,
		
	};
	
	
	VBM_BOSS_DATA["Thaddius"] = {
		spells = {
			["Polarity Shift"] = {
				event = "SPELL_CAST_START",
				spell = "Polarity Shift",
				timer = 30,
				texture = "spell_nature_lightning",
			},
		},
		during = function()
			local i = 1;
			
			while(UnitDebuff("player",i) ~= nil) do
				local name, rank, iconTexture, count, debuffType, duration, timeLeft  =  UnitDebuff("player",i);
				local thadd = "";
				if(name=="Positive Charge" and count == 0) then
					if(VBM_Thaddius~="pos") then
						vbm_bigwarn("-> -> -> RIGHT -> -> ->",5,0,0,1);
						VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
						VBM_Delay(0.25,VBM_PlaySoundFile,VBM_STANDARD_DONG_SOUND);
					end
					VBM_Thaddius = "pos";
					break;
				elseif(name=="Negative Charge" and count == 0) then
					if(VBM_Thaddius~="neg") then
						vbm_bigwarn("<- <- <- LEFT <- <- <-",5);
						VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
						VBM_Delay(0.25,VBM_PlaySoundFile,VBM_STANDARD_DONG_SOUND);
					end
					VBM_Thaddius = "neg";
					break;
				end
				i = i + 1;
			end
		end,
		loadandreset = function() VBM_Thaddius = "neg"; end,
		start = function() 
			--VBM_BossTimer(60*6,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy"); 
			vbm_bigwarn("<- <- <- START LEFT <- <- <-",10);
		end,
	};
		
	--[[ **********************
			Death Knight Wing
		*********************]]--
	VBM_BOSS_DATA["Instructor Razuvious"] = {
		spells = {
			["Disrupting Shout"] = {
				event = "SPELL_DAMAGE",
				spell = "Disrupting Shout",
				func = VBM_RazuviousTimerUpdate,
			},
			["Bone Barrier"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Bone Barrier",
				timer = 20,
				texture = "spell_shadow_unholystrength",
			},
		},
		start = function() VBM_BossTimer(16,"Disrupting Shout",VBM_ICONS.."ability_warrior_rampage"); VBM_DelayByName("InstructorRaz",16,VBM_RazuviousTimerUpdate); end,
		debuffs = {
			["Jagged Knife"] = {nil,function() SendChatMessage("Jagged Knife - "..VBM_YOU,"SAY"); end,true},
		},
		
	};
	VBM_BOSS_DATA["Gothik the Harvester"] = {
		start = function() VBM_BossTimer(4*60+30,"Enter room",VBM_ICONS.."inv_sword_04"); end,
	};
	
	VBM_BOSS_DATA["Thane Korth'azz"] = {
		realname = "The Four Horsemen",
		deadcheck = {"Thane Korth'azz", "Lady Blaumeux", "Baron Rivendare", "Sir Zeliek"},
		spells = {
			["Mark 1"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				dest = VBM_YOU,
				spell = "Mark of Blaumeux",
				amount = 3,
				logic = ">",
				sound = true,
				mess = "* * * More then 3 Marks * * *",
			},
			["Mark 2"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				dest = VBM_YOU,
				spell = "Mark of Korth'azz",
				amount = 3,
				logic = ">",
				sound = true,
				mess = "* * * More then 3 Marks * * *",
			},
			["Mark 3"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				dest = VBM_YOU,
				spell = "Mark of Zeliek",
				amount = 3,
				logic = ">",
				sound = true,
				mess = "* * * More then 3 Marks * * *",
			},
			["Mark 4"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				dest = VBM_YOU,
				spell = "Mark of Rivendare",
				amount = 3,
				logic = ">",
				sound = true,
				mess = "* * * More then 3 Marks * * *",
			},
			["Void Zone"] = {
				event = "SPELL_DAMAGE",
				src = "Void Zone",
				dest = VBM_YOU,
				mess = "* * Void Zone Damage * *",
				duration = 0.3,
			},
		},
	};
		
	--[[ **********************
			Frostwyrm Lair
		*********************]]--
	
	VBM_BOSS_DATA["Sapphiron"] = {
		emotes = {
			["lifts off into the"] = {nil,false,function() 
				if(VBM_DUNGEON_SIZE==10) then
					VBM_BossTimer(20,"Ice Bomb",VBM_ICONS.."spell_frost_arcticwinds");
				else
					VBM_BossTimer(25,"Ice Bomb",VBM_ICONS.."spell_frost_arcticwinds");
				end
			end},
		},
		debuffs = {
			["Chill"] = {"* * Blizzard * *"},
			["Icebolt"] = {nil,function() SendChatMessage("Ice Bolt - "..VBM_YOU,"YELL"); end,true},
		},
		rangecheck = 10,
		rccount = 2,
	};
	
	VBM_BOSS_DATA["Kel'Thuzad"] = {
		spells = {
			["Detonate Mana"] = {
				event = "SPELL_CAST_SUCCESS",
				src = "Kel'Thuzad",
				spell = "Detonate Mana",
				func = function()
					if(VBM_DUNGEON_SIZE==10) then
						VBM_BossTimer(30,"Detonate Mana Cooldown",VBM_ICONS.."spell_nature_wispsplode");
					else
						VBM_BossTimer(20,"Detonate Mana Cooldown",VBM_ICONS.."spell_nature_wispsplode");
					end
				end,
			},
			["Frost Blast"] = {
				event = "SPELL_CAST_SUCCESS",
				src = "Kel'Thuzad",
				spell = "Frost Blast",
				mess = "* * * Frost Blast * * *",
				sound = true,
				timer = 30,
				timername = "Frost Blast Cooldown",
				texture = "spell_frost_freezingbreath",
			},
			["Chains of Kel'Thuzad"] = {
				event = "SPELL_CAST_SUCCESS",
				src = "Kel'Thuzad",
				spell = "Chains of Kel'Thuzad",
				mess = "* * * Mind Control * * *",
				simonsound = true,
			},
			["Shadow Fissure"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Shadow Fissure",
				lowersound = true,
				func = function() vbm_smallwarn("* * * Void Zone Spawned * * *"); end,
			},
		},
		debuffs = {
			["Detonate Mana"] = {"* * * Detonate Mana * * *",function() SendChatMessage("Detonate Mana - "..VBM_YOU,"SAY"); end},
		},
		rangecheck = 10,
		start = function()
			VBM_BossTimer(30,"Detonate Mana Cooldown",VBM_ICONS.."spell_nature_wispsplode");
			VBM_BossTimer(30,"Frost Blast Cooldown",VBM_ICONS.."spell_frost_freezingbreath");
		end,
	};
	
	VBM_BOSS_DATA["Trash"] = {
		spells = {
			["Lightning Totem"] = {
				event = "SPELL_CAST_START",
				src = "Living Monstrosity",
				spell = "Lightning Totem",
				mess = "* * * Lightning Totem * * *",
			},
			["Magnetic Pull"] = {
				event = "SPELL_CAST_SUCCESS",
				spell = "Magnetic Pull",
				mess = "* * * Tank Swap * * *",
				timer = 20,
				texture = "spell_nature_groundingtotem",
			},
		},
		emotes = {
			["Obey the call of Kel'Thuzad"] = {nil,false,function() 
				VBM_BossTimer(3*60+45,"Kel'Thuzad Attacks",VBM_ICONS.."inv_sword_04");
			end},
		},
		
	};
end


function VBM_RazuviousTimerUpdate()
	if(InCombatLockdown()) then
		VBM_BossTimer(16,"Disrupting Shout",VBM_ICONS.."ability_warrior_rampage");
		VBM_DelayByName("InstructorRaz",16,VBM_RazuviousTimerUpdate);
	end
end