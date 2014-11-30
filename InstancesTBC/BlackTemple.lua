--[[
	
]]--
VBM_LoadInstance["Black Temple"] = function()
	VBM_BOSS_DATA["High Warlord Naj'entus"] = {
		debuffs = {
			["Impaling Spine"] = {"Impaling Spine",function() SendChatMessage("Impaling Spine on me! Take it fast!","SAY"); end},
		},
		--rangecheck = 8500,
	};
	
	VBM_BOSS_DATA["Supremus"] = {
		debuffs = {
			["Molten Flame"] = {"* * Molten Flame * *"};
		},
		spells = {
			["Volcanic Geyser"] = {
				spell = "Volcanic Geyser",
				event = "SPELL_DAMAGE",
				dest = VBM_YOU,
				mess = "* * Volcanic Geyser Damage * *",
				duration = 0.3
			},
		},
		emotes = {
			["The ground begins to crack open!"] = {nil,false,VBM_Supremus_delay},
		},
	};
	
	VBM_BOSS_DATA["Teron Gorefiend"] = {
		debuffs = {
			["Shadow of Death"] = {"Shadow of Death, Ghost after 55 sec",VBM_Teron_delay};
		},
	};
	
	VBM_BOSS_DATA["Gurtogg Bloodboil"] = {
		spells = {
			["Fel Rage"] = {
				event = "SPELL_AURA_APPLIED",
				dest = "Gurtogg Bloodboil",
				spell = "Fel Rage",
				func = VBM_Bloodboil_Reset,
			},
			["Fel Rage remove"] = {
				event = "SPELL_AURA_REMOVED",
				dest = "Gurtogg Bloodboil",
				spell = "Fel Rage",
				func = VBM_Bloodboil_Warn,
			},
			["Bloodboil"] = {
				event = "SPELL_CAST_SUCCESS",
				src = "Gurtogg Bloodboil",
				spell = "Bloodboil",
				func = VBM_Bloodboil_Cast,
			},
		},
		loadandreset = VBM_Bloodboil_Reset,
		start = VBM_Bloodboil_Warn,
	};

	VBM_BOSS_DATA["Essence of Desire"] = {
		spells = {
			["Spirit Shock"] = {
				event = "SPELL_CAST_START",
				src = "Essence of Desire",
				spell = "Spirit Shock",
				mess = "Kick Now",
				duration = 0.3,
			},
		},
	};
	
	VBM_BOSS_DATA["Essence of Anger"] = {
		debuffs = {
			["Spite"] = {"* * * Spite * * *"},
		},
	};

	VBM_BOSS_DATA["Mother Shahraz"] = {
		debuffs = {
			["Fatal Attraction"] = {"* RUN * Fatal Attraction * RUN *",VBM_Mother_Fatal},
		},
	};
	
	VBM_BOSS_DATA["Gathios the Shatterer"] = {
		realname = "Illidari Council",
		debuffs = {
			["Flamestrike"] = {"* * Flamestrike * *"},
			["Deadly Poison"] = {"* * Deadly Poison * *",function() SendChatMessage("Deadly Poison on me!","SAY"); end},
		},
		spells = {
			["Flamestrike"] = {
				event = "SPELL_DAMAGE",
				spell = "Flamestrike",
				dest = VBM_YOU,
				mess = "* * Flamestrike Damage * *",
				duration = 0.3,
			},
		},
	};
	
	VBM_BOSS_DATA["Illidan Stormrage"] = {
		debuffs = {
			["Parasitic Shadowfiend"] = {"* * Parasitic Shadowfiend * *"},
			["Flame Crash"] = {"* * Flame Crash * *"},
			["Agonizing Flames"] = {"* * Agonizing Flames * *"},
			["Dark Barrage"] = {"* * Dark Barrage * *",function() SendChatMessage("Dark Barrage on me!","SAY"); end},
		},
		spells = {
			["Blaze"] = {
				event = "SPELL_DAMAGE",
				spell = "Blaze",
				dest = VBM_YOU,
				mess = "Standing in Blaze",
				duration = 0.3,
			},
		},
		emotes = {
			["of the demon within"] = {"* * * Stop Attack * * *",false},
			["Stare into the eyes of the Betrayer"] = {nil,false,function() vbm_debuffwarn("* * * Eye Blast * * *"); end},
		},
	};
	
	VBM_BOSS_DATA["Trash"] = {
		spells = {
			["L5 Arcane Charge"] = {
				event = "SPELL_CAST_START",
				src = "Promenade Sentinel",
				spell = "L5 Arcane Charge",
				func = function() VBM_Delay(VBM_BOSSTARGETYOUDELAY,VBM_BossTargetYouWarning,"Promenade Sentinel","L5 charge incomming on You!"); end,
			},
		},
	};
end

function VBM_Supremus_delay()
	-- 60 sec whole phase
	VBM_Delay(55,vbm_bigwarn,"* * * Stop Attack * * *");
	VBM_Delay(55,VBM_PlaySoundFile,VBM_STANDARD_DONG_SOUND);
end

function VBM_Teron_delay()
	-- 55 sec debuff
	VBM_Delay(42,vbm_debuffwarn,"* * * Time to run * * *");
	VBM_Delay(42,VBM_PlaySoundFile,VBM_STANDARD_DONG_SOUND);
end

function VBM_Mother_Fatal()
	local fatals = {};
	
	for i=1,GetNumGroupMembers() do
		if(VBM_CheckForDebuff("Fatal Attraction","raid"..i)) then
			table.insert(fatals,""..UnitName("raid"..i));
		end
	end
	
	if(#fatals==3) then
		table.sort(fatals);
		if(fatals[1]==UnitName("player")) then
			vbm_debuffwarn("<- <- <- LEFT <- <- <-",10,1,1,0);
		elseif(fatals[2]==UnitName("player")) then
			vbm_debuffwarn("* RUN * FORWARD * RUN *",10,0,1,0);
		elseif(fatals[3]==UnitName("player")) then
			vbm_debuffwarn("-> -> -> RIGHT -> -> ->",10,0,1,1);
		end
		return;
	end
	
	if(#fatals==2) then
		table.sort(fatals);
		if(fatals[1]==UnitName("player")) then
			vbm_debuffwarn("* BACK * BACKWARD * BACK *",10,1,0,0);
		elseif(fatals[2]==UnitName("player")) then
			vbm_debuffwarn("* RUN * FORWARD * RUN *",10,0,1,0);
		end
	end
	
	--loop until 3 have
	if(#fatals>0) then
		VBM_Delay(0.1,VBM_Mother_Fatal);
	end
end

function VBM_Bloodboil_Reset()
	VBM_Bloodboil_counter = 0;
end

function VBM_Bloodboil_Cast()
	VBM_Bloodboil_counter = VBM_Bloodboil_counter + 1;
	VBM_Bloodboil_Warn();
end

function VBM_Bloodboil_Warn()
	local grp;
	
	if(mod(VBM_Bloodboil_counter,3)==0) then
		grp = 3;
	elseif(mod(VBM_Bloodboil_counter,3)==1) then
		grp = 4;
	elseif(mod(VBM_Bloodboil_counter,3)==2) then
		grp = 5;
	end
	
	if(VBM_GetGroupSpecial(VBM_YOU)==grp) then
		vbm_bigwarn("* * * Your Group Back * * *"); 
		VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
	else
		vbm_bigwarn("* * * Group "..grp.." back * * *",5,0,1,1); 
	end
end
