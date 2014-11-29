--[[
	
]]--

VBM_LoadInstance["Sunwell Plateau"] = function()
	VBM_BOSS_DATA["Kalecgos"] = {
		deadcheck = {"Sathrovarr the Corruptor"},
		spells = {
			["Spectral Blast"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Spectral Realm",
				func = VBM_Kalecgos_PortalSend,
			},
		},
		debuffs = {
			["Spectral Realm"] = {nil,VBM_Kalecgos_delay},
			["Spectral Exhaustion"] = {nil,VBM_Kalecgos_delay2},
		},
		loadandreset = VBM_Kalecgos_Reset,
		start = VBM_Kalecgos_Start,
		bossevent = VBM_Kalecgos_Recive,
		during = VBM_Kalecgos_During,
		rangecheck = 10,
	};
	
	VBM_BOSS_DATA["Brutallus"] = {
		debuffs = {
			["Burn"] = {"* * Burn * *",function() SendChatMessage("BURN COMING THROUGH","SAY"); end},
		},
		spells = {
			["Stomp"] = {
				event = "SPELL_CAST_SUCCESS",
				src = "Brutallus",
				spell = "Stomp",
				func = function(s,d) vbm_bigwarn("* * Stomp >>"..vbm_c_w..d..vbm_c_r.."<< * *"); end,
			},
		},
	};
	
	VBM_BOSS_DATA["Felmyst"] = {
		spells = {
			["Gas Nova"] = {
				event = "SPELL_CAST_START",
				src = "Felmyst",
				spell = "Gas Nova",
				mess = "* * * Casting Gas Nova * * *",
				sound = true,
			},
			["Demonic Vapor"] = {
				event = "SPELL_SUMMON",
				src = VBM_YOU,
				spell = "Summon Demonic Vapor",
				mess = "* * * Demonic Vapor on You * * *",
				sound = true,
				func = function() SendChatMessage("Demonic Vapor - "..VBM_YOU,"SAY"); end,
			},
		},
		debuffs = {
			["Demonic Vapor"] = {"* * * Demonic Vapor * * *"},
		},
		during = VBM_Felmyst_OnUpdate,
	};
	
	VBM_BOSS_DATA["Lady Sacrolash"] = {
		realname = "Eredar Twins",
		deadcheck = {"Lady Sacrolash","Grand Warlock Alythess"},
		spells = {
			--[[
			["Flame Touched"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				dest = VBM_YOU,
				spell = "Flame Touched",
				amount = 8,
				logic = ">",
				mess = "* * * More then 8 Flame Touched * * *",
			},]]--
			["Dark Touched"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				dest = VBM_YOU,
				spell = "Dark Touched",
				amount = 8,
				logic = ">",
				func = VBM_EredarTwins_DarkTouched,
			},
			["Pyrogenics"] = {
				event = "SPELL_AURA_APPLIED",
				dest = "Grand Warlock Alythess",
				spell = "Pyrogenics",
				func = function() vbm_smallwarn("* * * Dispel Pyrogenics * * *"); end,
			},
			["Pyrogenics2"] = {
				event = "SPELL_AURA_REMOVED",
				dest = "Grand Warlock Alythess",
				spell = "Pyrogenics",
				func = function() vbm_smallwarn("* * * Dispel Success * * *",0.1,0,1,0); end,
			},
		},
		emotes = {
			["directs"] = {nil,false,VBM_EredarTwins_Emote},
		},
		during = VBM_EredarTwins_TankTracking,
	};
	
	VBM_BOSS_DATA["M'uru"] = {
		deadcheck = {"Entropius"},
		debuffs = {
			["Darkness"] = {"* * * Darkness * * *"},
		},
		spells = {
			["Void Zone"] = {
				event = "SPELL_DAMAGE",
				spell = "Void Zone Effect",
				dest = VBM_YOU,
				mess = "* * * Standing in Void Zone * * *",
				sound = true,
			},
		},
	};
	
	VBM_BOSS_DATA["Kil'jaeden"] = {
		spells = {
			["Sinister Reflection"] = {
				event = "SPELL_CAST_SUCCESS",
				src = "Kil'jaeden",
				spell = "Sinister Reflection",
				mess = "* * * Sinister Reflections Up * * *",
				lowersound = true,
				color = "orange",
				timer = 76,
				timername = "Darkness of a Thousand Souls",
				texture = "Spell_Shadow_BlackPlague",
			},
			["Darkness of a Thousand Souls"] = {
				event = "SPELL_CAST_START",
				src = "Kil'jaeden",
				spell = "Darkness of a Thousand Souls",
				mess = "* * Darkness of a Thousand Souls * *",
				sound = true,
				func = VBM_Kiljaeden_darkness,
			},
			["Shield Orb"] = {
				event = "SPELL_DAMAGE",
				src = "Shield Orb",
				spell = "Shadow Bolt",
				func = function() vbm_debuffwarn("* * * Shield Orb Up * * *",0.3); end,

			},
			
		},
		debuffs = {
			["Fire Bloom"] = {"* * Fire Bloom * *",function() SendChatMessage("Fire Bloom - "..VBM_YOU,"SAY"); end},
		},
		emotes = {
			["The powers of the Sunwell... turn... against me!"] = {nil,false,function() 
				VBM_KilJaeden_enrage = true;
				VBM_BossTimer(25,"Darkness of a Thousand Souls",VBM_ICONS.."Spell_Shadow_BlackPlague");
			end},
		},
		rangecheck = 10,
		rccount = 2,
		loadandreset = function() VBM_KilJaeden_enrage = false; end,
	};
end

--[[
	Kalecgos
]]--

function VBM_Kalecgos_delay()
	-- 60 sec whole phase
	VBM_Delay(50,vbm_debuffwarn,"* * * Porting back in 10 sec * *",2);
	VBM_Delay(55,vbm_debuffwarn,"* * Porting back in 5 sec * *");
end

function VBM_Kalecgos_delay2()
	-- 60 sec whole phase
	VBM_Delay(50,vbm_debuffwarn,"* * Spectral Exhaustion ends in 10 sec * *",5);
	VBM_Delay(60,vbm_debuffwarn,"* * Spread out and get ready to take portal * *",2);
end

function VBM_Kalecgos_Start()
	--also start extra dude
	VBM_BossStart("Sathrovarr the Corruptor");
end

function VBM_Kalecgos_Reset()
	--also reset extra dude
	VBM_BossReset("Sathrovarr the Corruptor");

	VBM_KALECGOS_TELEPORT_DETECT = true;
	VBM_KALECGOS_HP = 100;
	VBM_SATHROVARR_HP = 100;
end

function VBM_Kalecgos_During()
	--find a boss
	for i = 1, GetNumRaidMembers() do
		if(UnitExists("raid"..i.."target") and UnitIsEnemy("raid"..i.."target","player") and UnitName("raid"..i.."target") == "Kalecgos") then
			local hp = VBM_UnitHealthPercent("raid"..i.."target");
			if(hp ~= VBM_KALECGOS_HP) then
				VBM_BossSend("KALE "..hp);
			end
			break;
		elseif(UnitExists("raid"..i.."target") and UnitIsEnemy("raid"..i.."target","player") and UnitName("raid"..i.."target") == "Sathrovarr the Corruptor") then
			local hp = VBM_UnitHealthPercent("raid"..i.."target");
			if(hp ~= VBM_SATHROVARR_HP) then
				VBM_BossSend("SATH "..hp);
			end
			break;
		end
	end
end

function VBM_Kalecgos_HPUpdate(boss,hp)
	if(boss == "KALE") then
		if(hp ~= VBM_KALECGOS_HP) then
			VBM_KALECGOS_HP = hp;
		end
	elseif(boss == "SATH") then
		if(hp ~= VBM_SATHROVARR_HP) then
			VBM_SATHROVARR_HP = hp;
		end
	end

	if(hp < 21 or hp == 40 or hp == 60 or hp == 80) then
		vbm_print(vbm_c_p.."["..vbm_c_grey.."Sathrovarr the Corruptor"..vbm_c_p.."] "..vbm_c_w..VBM_SATHROVARR_HP.."%"..vbm_c_p.." <===> "..
			vbm_c_p.."["..vbm_c_grey.."Kalecgos"..vbm_c_p.."] "..vbm_c_w..VBM_KALECGOS_HP.."%");
	end
end

function VBM_Kalecgos_PortalSend(s,d)
	VBM_BossSend("PORTAL "..d);
end

function VBM_Kalecgos_Recive(msg)
	local found,p1,p2,p3;
	
	found,_,p1 = string.find(msg,"PORTAL (.+)");
	if(found) then
		VBM_Kalecgos_Blast(p1);
	end
	
	found,_,p1 = string.find(msg,"SATH (.+)");
	if(found) then
		VBM_Kalecgos_HPUpdate("SATH",tonumber(p1));
	end
	
	found,_,p1 = string.find(msg,"KALE (.+)");
	if(found) then
		VBM_Kalecgos_HPUpdate("KALE",tonumber(p1));
	end
end


function VBM_Kalecgos_Blast(d)
	--only detect first port
	if(VBM_KALECGOS_TELEPORT_DETECT) then
		VBM_KALECGOS_TELEPORT_DETECT = false;
		VBM_Delay(20,VBM_Kalecgos_NextPortal);
		--run rotation
		local grp = VBM_GetGroupSpecial(d);
		VBM_Kalecgos_Blast_Warn(grp,d);
	end
end

function VBM_Kalecgos_Blast_Warn(grp,d)
		if(grp==VBM_GetGroupSpecial(VBM_YOU)) then
			VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
			vbm_bigwarn("* * Portal on YOUR group * *",5);
		else
			vbm_bigwarn("* * Portal on group "..grp.." ("..d..") * *",5,0,1,1);
		end
end

function VBM_Kalecgos_NextPortal()
	VBM_KALECGOS_TELEPORT_DETECT = true;
end

--[[
	Felmyst
]]--


function VBM_Felmyst_OnUpdate()
	--find felmyst
	local target = false;
	
	for i = 1, GetNumRaidMembers() do
		--Encapsulate updater
		if(VBM_CheckForDebuff("Encapsulate","raid"..i)) then
			VBM_Felmyst_Encapsulate("raid"..i);
		end
		--find a valid unit for felmyst
		if(UnitExists("raid"..i.."target") and UnitName("raid"..i.."target") == "Felmyst") then
			target = "raid"..i.."target";
		end
	end
	
	if(target) then
		if(UnitExists(target.."target")) then
			if(UnitHealthMax(target.."target") > VBM_TANKHP) then
				--tank is targeted
				VBM_FELMYST_LAST_TARGET = true;
			else
				--none tank is targetd
				if(VBM_FELMYST_LAST_TARGET) then
					--Encapsulate on target.."target"
					VBM_Felmyst_Encapsulate(target.."target",true);
				end
				VBM_FELMYST_LAST_TARGET = false;
			end
		else
			--none is targeted
			VBM_FELMYST_LAST_TARGET = false;
		end
	end
end

function VBM_Felmyst_Encapsulate(uid,predetect)
	if(IsItemInRange(VBM_CURRENT_BANDAGE,uid) == 1) then
		vbm_bigwarn("* * Move Away From >>"..vbm_c_w..UnitName(uid)..vbm_c_r.."<< * *",1);
		if(predetect) then
			VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
		end
	elseif(IsItemInRange(VBM_CURRENT_BANDAGE,uid) == 0) then
		vbm_bigwarn("* * Safe Distance to >>"..vbm_c_w..UnitName(uid)..vbm_c_g.."<< * *",1,0,1,0);
	else
		vbm_bigwarn("* * Error Reading * *",1,0,1,1);
	end
	
	if(predetect) then
		if(UnitName(uid) == VBM_YOU) then
			SendChatMessage("ENCAPSULATE ON ME, WATCH OUT","SAY");
		end
	end
end

--[[
	EredarTwins
]]--

function VBM_EredarTwins_Emote(text)
	if(text == "Sacrolash directs Shadow Nova at "..VBM_YOU..".") then
		SendChatMessage("Shadow Nova - "..VBM_YOU,"SAY");
		vbm_bigwarn("* * Shadow Nova on You * *",5,0.5,0.5,1);
		VBM_PlaySoundFile("Sound\\Doodad\\BellTollHorde.wav");
		VBM_Delay(0.5,VBM_PlaySoundFile,"Sound\\Doodad\\BellTollHorde.wav");
		VBM_Delay(0.25,VBM_PlaySoundFile,"Sound\\Doodad\\BellTollHorde.wav");
	elseif(text == "Alythess directs Conflagration at "..VBM_YOU..".") then
		SendChatMessage("CONFLAG - "..string.upper(VBM_YOU),"SAY");
		vbm_bigwarn("* * * CONFLAGRATION ON YOU * * *",5);
		VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
		VBM_Delay(0.5,VBM_PlaySoundFile,VBM_STANDARD_DONG_SOUND);
		VBM_Delay(0.25,VBM_PlaySoundFile,VBM_STANDARD_DONG_SOUND);
	end
end

VBM_EREDARTWINS_LAST_TARGET = "";
function VBM_EredarTwins_TankTracking()
	if(not VBM_GetS("EredarTwinsTankWarning")) then return; end

	--find Lady Sacrolash
	local target = false;
	for i = 1, GetNumRaidMembers() do
		--find a valid unit for Lady Sacrolash
		if(UnitExists("raid"..i.."target") and UnitName("raid"..i.."target") == "Lady Sacrolash") then
			target = "raid"..i.."target";
			break;
		end
	end
	
	if(target) then
		--check for ladys target
		if(UnitExists(target.."target")) then
			--check if its a tank
			if(UnitHealthMax(target.."target") > VBM_TANKHP) then
				--tank is targeted check if its a new
				if(UnitName(target.."target") ~= VBM_EREDARTWINS_LAST_TARGET) then
					--new tank gogo
					VBM_EREDARTWINS_LAST_TARGET = UnitName(target.."target");
					vbm_infowarn("* * New Tank >>"..vbm_c_w..VBM_EREDARTWINS_LAST_TARGET..vbm_c_t.."<< * *");
				end
			end
		end
	end	
end

function VBM_EredarTwins_DarkTouched()
	vbm_debuffwarn("* * * More then 8 Dark Touched * * *",0.3);
end

function VBM_Kiljaeden_darkness()
		VBM_Delay(1.5,vbm_bigwarn,"* * * * * * 7 * * * * * *");
		VBM_Delay(2.5,vbm_bigwarn,"* * * * * 6 * * * * *");
		VBM_Delay(3.5,vbm_bigwarn,"* * * * 5 * * * *");
		VBM_Delay(4.5,vbm_bigwarn,"* * * 4 * * *");
		VBM_Delay(5.5,vbm_bigwarn,"* * 3 * *");
		VBM_Delay(6.5,vbm_bigwarn,"* 2 *");
		VBM_Delay(7.5,vbm_bigwarn,"1");
		VBM_Delay(8.5,vbm_bigwarn,"BOOM",1);
		
		VBM_BossTimer(8.5,"EXPLOSION",VBM_ICONS.."Spell_Fire_SelfDestruct");
		
		if(VBM_KilJaeden_enrage) then
			VBM_BossTimer(25,"Darkness of a Thousand Souls",VBM_ICONS.."Spell_Shadow_BlackPlague");
		else
			VBM_BossTimer(45,"Darkness of a Thousand Souls",VBM_ICONS.."Spell_Shadow_BlackPlague");
		end
end