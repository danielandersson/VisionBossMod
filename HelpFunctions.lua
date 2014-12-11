--[[
	********************************************************************
	********************************************************************
	Help Constants at top
	
	Help functions:
	VBM_GetGroupNr(name)
	VBM_GetRaidId(name)
	VBM_GetClass(name)
	VBM_GetRank(name)
	VBM_GetSmoothColor(percent)
	VBM_GetTextClassColor(class)
	VBM_GetColorText(r,g,b)
	VBM_StringIcon(icon)
	VBM_StringTexture(texture)
	VBM_GetTextReactionColor(reaction)
	VBM_GetRealBossName(boss)
	VBM_GetMarkNameFromNumber(marknr)
	VBM_round(tal)
	VBM_UnitInRange(unitid,range)
	VBM_GetUnitReferens(bossname)
	VBM_UnitHealthPercent(unitid,CountOneHpAsZero = false)
	VBM_UnitPowerPercent(unitid)
	VBM_PlaySoundFile(file)
	VBM_UnitClassification(uid)
	VBM_BoostPlaySound(file,boost,duration);
	VBM_CheckForBuff(buffname, unit)
	VBM_CheckForDebuff(buffname, unit)
	VBM_GetBuffText(buffindex, unit)
	VBM_GetDeBuffText(buffindex, unit)
	VBM_band(mask,...) bitands all args with mask and return true or false
	VBM_bor(b1,...) bitors all args
	VBM_linebreakStr(str,b,tryspace) tryspace if try to break the line at spaces isntead
	VBM_SetTrue(varname)
	VBM_SetFalse(varname)
	VBM_SearchBags(itemname)
	VBM_SplitItemToEmptySlots(bag,item,stacksize)
	VBM_FormatMoney(money)
	VBM_FlagsColor(flags)
	VBM_NoneEnglish()
	VBM_CPUWarning()
	VBM_CPUPOff()
	
	Sync functions:
	VBM_GetPlayerMapPosition(uid)

	********************************************************************
	********************************************************************
]]--

vbm_c_w = "|cFFFFFFFF";
vbm_c_r = "|cFFFF0000";
vbm_c_g = "|cFF00FF00";
vbm_c_dg = "|cFF007F00";
vbm_c_b = "|cFF0000FF";
vbm_c_lb = "|cFF66AAFF";
vbm_c_t = "|cFF00FFFF";
vbm_c_y = "|cFFFFFF00";
vbm_c_purple = "|cFFFF00FF";
vbm_c_p = "|cFF8888CC";
vbm_c_v = "|cFF4444CC";
vbm_c_tt = "|cFFFED100";
vbm_c_bronze = "|cFFFF8800";
vbm_c_black = "|cFF000000";
vbm_c_grey = "|cFFB4B4B4";
vbm_c_pink = "|cFFFFA3B1";
vbm_c_ = "|r"; vbm_c = "|r";
VBM_YOU = UnitName("player");
VBM_CURRENT_BANDAGE = "Heavy Windwool Bandage";
VBM_STANDARD_DONG_SOUND = "Sound\\Doodad\\BellTollAlliance.wav";
VBM_LOWER_DONG_SOUND = "Sound\\Doodad\\BellTollHorde.wav";
VBM_RUNE_SOUND = "Sound\\Doodad\\PVP_Rune_speedCustom0.wav";
VBM_SIMON_SOUND = "Sound\\Doodad\\SimonGame_SmallBlueTree.wav";
VBM_BOAT_SOUND = "Sound\\Doodad\\BoatDockedWarning.wav";
VBM_PVPFLAG_SOUND = "Sound\\Spells\\PVPFlagTaken.wav";
VBM_PVPFLAG2_SOUND = "Sound\\Spells\\PVPFlagTakenHorde.wav";
VBM_TANKHP = 45000;
VBM_TANKSTA = 2500;
VBM_BOSSTARGETYOUDELAY = 0.20; --will be changed depending on your ping setting
VBM_ICONS = "Interface\\Icons\\";
VBM_FONT_TVCENMT = "Interface\\AddOns\\VisionBossMod\\Data\\PT_Sans_Narrow.ttf";
VBM_FONT_ABF = "Interface\\AddOns\\VisionBossMod\\Data\\PT_Sans_Narrow.ttf";
VBM_TEXTURE_BANTOBAR = "Interface\\AddOns\\VisionBossMod\\Data\\Armory";

function VBM_GetGroupNr(name)
	local i,n,g;
	for i=1,GetNumGroupMembers() do
		n,_,g = GetRaidRosterInfo(i);
		if(n==name) then
			return g;
		end
	end
	return false;
end

function VBM_GetRaidId(name)
	local i,n;
	for i=1,GetNumGroupMembers() do
		n = GetRaidRosterInfo(i);
		if(string.lower(n)==string.lower(name)) then
			return i;
		end
	end
	return false;
end

function VBM_GetClass(name)
	local i,n,c;
	for i=1,GetNumGroupMembers() do
		n,_,_,_,c = GetRaidRosterInfo(i);
		if(n==name) then
			return c;
		end
	end
	return "";
end

function VBM_GetRank(name)
	local i,n,c;
	for i=1,GetNumGroupMembers() do
		n,c = GetRaidRosterInfo(i);
		if(n==name) then
			return c;
		end
	end
	return false;
end

function VBM_GetSmoothColor(percent)
	local r, g, b;
	if(percent > 0.5) then
		r = (1.0 - percent) * 2;
		g = 1.0;
	else
		r = 1.0;
		g = percent * 2;
	end
	b = 0.0;
	return r,g,b;
end

function VBM_GetTextClassColor(class)
	local color = RAID_CLASS_COLORS[string.gsub(string.upper(class)," ","")];
	if(color) then
		local colorText = ("|cff%.2x%.2x%.2x"):format(color.r*255,color.g*255,color.b*255);
		return colorText;
	end
	return "|cFFFFFFFF";
end

function VBM_GetColorText(r,g,b)
	local colorText = ("|cff%.2x%.2x%.2x"):format(r*255,g*255,b*255);
	return colorText;
end

function VBM_StringIcon(icon)
	return VBM_StringTexture(VBM_ICONS..icon)
end

function VBM_StringTexture(texture)
	return "|T"..texture..":0|t";
end

function VBM_GetTextReactionColor(reaction)
	if(reaction<4) then
		return vbm_c_r;
	elseif(reaction==4) then
		return vbm_c_y;
	else
		return vbm_c_g;
	end
end

function VBM_GetRealBossName(boss)
	local n;
	if(VBM_BOSS_DATA[boss].realname) then
		n = VBM_BOSS_DATA[boss].realname;
	else
		n = boss;
	end
	return n;
end

function VBM_GetMarkNameFromNumber(marknr)
	if(marknr==1) then
		return "star";
	elseif(marknr==2) then
		return "circle";
	elseif(marknr==3) then
		return "diamond";
	elseif(marknr==4) then
		return "triangle";
	elseif(marknr==5) then
		return "moon";
	elseif(marknr==6) then
		return "square";
	elseif(marknr==7) then
		return "cross";
	elseif(marknr==8) then
		return "skull";
	end
end

function VBM_round(tal)
	if (tal < 0) then
		return math.ceil(tal-0.5)
	else
		return math.floor(tal+0.5)
	end
end

function VBM_UnitInRange(unitid,range)
	if(range==10) then
		return CheckInteractDistance(unitid,3);
	elseif(range==11) then
		return CheckInteractDistance(unitid,2);
	elseif(range==28) then
		return CheckInteractDistance(unitid,1);
	elseif(range==40) then
		return UnitInRange(unitid);
	end
	vbm_printc("VBM_UnitInRange ERROR: Unsuported range selected.");
	return false;
end

function VBM_GetUnitReferens(bossname)
	--local loop var
	local i,uid,pet;
	--search boss ids
	for i=1,9 do
		if(UnitExists("boss"..i) and UnitName("boss"..i)==bossname) then
			return "boss"..i;
		end
	end
	--search all raid members
	if(IsInRaid()) then
		for i=1,GetNumGroupMembers() do
			uid = "raid"..i.."target";
			pet = "raid"..i.."pettarget";
			if(UnitExists(uid) and UnitName(uid)==bossname) then
				return uid;
			end
			if(UnitExists(pet) and UnitName(pet)==bossname) then
				return pet;
			end
		end
	--not in raid search party and self
	else
		--check self
		uid = "target";
		pet = "pettarget";
		if(UnitExists(uid) and UnitName(uid)==bossname) then
			return uid;
		end
		if(UnitExists(pet) and UnitName(pet)==bossname) then
			return pet;
		end
		--check party
		for i=1,GetNumGroupMembers() do
			uid = "party"..i.."target";
			pet = "party"..i.."pettarget";
			if(UnitExists(uid) and UnitName(uid)==bossname) then
				return uid;
			end
			if(UnitExists(pet) and UnitName(pet)==bossname) then
				return pet;
			end
		end
	end
	return nil;
end

function VBM_UnitHealthPercent(unit,CountOneHpAsZero)
	if(UnitExists(unit)) then
		local hp = UnitHealth(unit) / UnitHealthMax(unit) * 100;
		if(CountOneHpAsZero and UnitHealth(unit)==1) then
			return 0;
		elseif(hp == 0) then
			return 0;
		elseif(hp < 1) then
			return 1;
		else
			return math.floor(hp);
		end
	else
		return 0;
	end
end

function VBM_UnitPowerPercent(unitid)
	if(UnitExists(unitid)) then
		return math.floor(UnitPower(unitid) / UnitPowerMax(unitid) * 100);
	else
		return 0;
	end
end

function VBM_PlaySoundFile(file)
	if(VBM_GetS("Sound")) then
		if(VBM_GetS("SoundMuteWow")) then
			if(VBM_GetCVar("Sound_EnableSFX","0")) then
				--vbm_print("Sound_EnableSFX");
				VBM_SetCVar("Sound_EnableSFX",1,true);
				VBM_DelayByName("HANDLESOUND",3,VBM_SetCVar,"Sound_EnableSFX",0,true);
			end
			if(VBM_GetCVar("Sound_EnableAllSound","0")) then
				--vbm_print("Sound_EnableAllSound");
				VBM_SetCVar("Sound_EnableAllSound",1,true);
				VBM_DelayByName("HANDLESOUND2",3,VBM_SetCVar,"Sound_EnableAllSound",0,true);
			end
		end
		PlaySoundFile(file);
	end
end

function VBM_UnitClassification(uid)
	local c = UnitClassification(uid);
	if(VBM_ZONE and c=="elite" and UnitLevel(uid)==-1) then
		return "worldboss";
	end
	return c;
end

function VBM_BoostPlaySound(file,boost,duration)
	local savemaster = GetCVar("Sound_MasterVolume");

	vbm_debug("Boosting Master Volume to: "..savemaster + boost);
	SetCVar("Sound_MasterVolume",savemaster + boost);
	
	VBM_PlaySoundFile(file);

	VBM_Delay(duration,function()
		vbm_debug("Restoring Master to: "..savemaster);
		SetCVar("Sound_MasterVolume",savemaster);
	end);
end

function VBM_CheckForBuff(buffname, unit)
	if (not unit) then unit = "player"; end if (not UnitExists(unit)) then return nil; end
	local name = UnitBuff(unit,buffname);
	if(name) then
		return true;
	end
	return false;
end

function VBM_CheckForDebuff(buffname, unit)
	if (not unit) then unit = "player"; end if (not UnitExists(unit)) then return nil; end
	local name = UnitDebuff(unit,buffname);
	if(name) then
		return true;
	end
	return false;
end

function VBM_GetBuffText(buffindex, unit)
	if (not unit) then unit = "player"; end if (not UnitExists(unit)) then return nil; end
	VisionBossMod_TTTextLeft2:SetText();
	VisionBossMod_TT:SetUnitBuff(unit, buffindex);
	return VisionBossMod_TTTextLeft2:GetText();
end

function VBM_GetDeBuffText(buffindex, unit)
	if (not unit) then unit = "player"; end if (not UnitExists(unit)) then return nil; end
	VisionBossMod_TTTextLeft2:SetText();
	VisionBossMod_TT:SetUnitDeBuff(unit, buffindex);
	return VisionBossMod_TTTextLeft2:GetText();
end


function VBM_band(mask,...)
	args = {...};
	local i;
	for i=1,#args do
		if(bit.band(mask,args[i]) == 0) then
			return false;
		end
	end
	return true;
end
function VBM_bor(b1,...)
	args = {...};
	local i;
	for i=1,#args do
		b1 = bit.bor(b1,args[i]);
	end
	return b1;
end

function VBM_linebreakStr(str,b,tryspace)
	local l = {};
	local t;
	while(string.len(str) > 0) do
		if(tryspace) then
			if(string.len(str) <= b) then
				--if the full line fits, just take it all
				l[#l+1] = str;
				break;
			end
			t = string.find(string.reverse(string.sub(str,1,b+1))," ",1,true);
			if(not t) then
				--just break the line
				l[#l+1] = string.sub(str,1,b);
				str = string.sub(str,b+1);
			else
				--break the line and remove the space
				l[#l+1] = string.sub(str,1,b-(t-1));
				str = string.sub(str,b+2-(t-1));
			end
		else
			l[#l+1] = string.sub(str,1,b);
			str = string.sub(str,b+1);
		end
	end
	return table.concat(l,"\n");
end

function VBM_SetTrue(varname)
	_G[varname] = true;
end

function VBM_SetFalse(varname)
	_G[varname] = false;
end

function VBM_SearchBags(itemname)
	local bag,slot;
	for bag=0,NUM_BAG_SLOTS do
		for slot=1,GetContainerNumSlots(bag) do
			if (GetContainerItemLink(bag,slot) and string.find(GetContainerItemLink(bag,slot), itemname)) then
				return bag,slot;
			end
		end
	end
	
	return false,false;
end

function VBM_SplitItemToEmptySlots(bag,item,stacksize)
	local valid = GetContainerItemLink(bag,item);
	if(valid and stacksize > 0) then
		local _,itemcount,locked = GetContainerItemInfo(bag,item);
		--it not locked searchbags for free slots
		if(not locked) then
			local sbag,sslot;
			for sbag=0,NUM_BAG_SLOTS do
				for sslot=1,GetContainerNumSlots(sbag) do
					if(GetContainerItemLink(sbag,sslot)==nil) then
						--free slot found split stack into this slot
						if(itemcount > stacksize) then
							SplitContainerItem(bag,item,stacksize);
							itemcount = itemcount - stacksize;
							--find correct bag to click
							for i=1, NUM_CONTAINER_FRAMES do
								local bagframe = getglobal("ContainerFrame"..i);
								if ( bagframe:IsShown() and bagframe:GetID() == sbag ) then
									--bag found, now find slot
									for j=1, GetContainerNumSlots(sbag) do
										local slotframe = getglobal(bagframe:GetName().."Item"..j);
										if(slotframe:GetID()==sslot) then
											--found correct slot, click it
											slotframe:Click();
											VBM_Delay(0.6,VBM_SplitItemToEmptySlots,bag,item,stacksize);
											return;
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

function VBM_FormatMoney(money)
	local SILVER = "|cFFC0C0C0";
	local COPPER = "|cFFCC9900";
	local GOLD = "|cFFFFFF66";
	local WHITE = "|cFFFFFFFF";
	local c,s,g;
	local retstr = "";
	g = floor(money/10000);
	s = mod(floor(money/100),100);
	c = mod(money,100);
	
	if(g>0) then
		retstr = retstr..WHITE..g..GOLD.." Gold";
	end
	if(s>0) then
		if ( retstr ~= "" ) then retstr = retstr .. " " end;
		retstr = retstr..WHITE..s..SILVER.." Silver";
	end
	if(c>0) then
		if ( retstr ~= "" ) then retstr = retstr .. " " end;
		retstr = retstr..WHITE..c..COPPER.." Copper";
	end
	return retstr;
end

function VBM_FlagsColor(flags)
	if(VBM_band(flags,COMBATLOG_OBJECT_REACTION_HOSTILE) ) then
		return "|cFFFF0000";
	elseif(VBM_band(flags,COMBATLOG_OBJECT_REACTION_NEUTRAL) ) then
		return "|cFFFFFF00";
	elseif(VBM_band(flags,COMBATLOG_OBJECT_REACTION_FRIENDLY) ) then
		return "|cFF00FF00";
	end
	return "";
end

function VBM_NoneEnglish()
	if(GetLocale() ~= "enUS") then
		vbm_printc("VisionBossMods text parsing is made for the english client only, so some features may not work for you.");
	end
end

function VBM_CPUWarning()
	if(GetCVar("scriptProfile")=="1") then
		vbm_printc("|cFFFFFFFFWarning|cFF8888CC CPU Profileing is on, this may have a huge performance impact on gameplay");
		vbm_printc("If this is unintentional you can disable it by typing /vbmcpuoff");
	end
end

function VBM_CPUPOff()
	if(GetCVar("scriptProfile")~="0") then
		SetCVar("scriptProfile", "0");
		ReloadUI();
	end
end

--[[
	********************************************************************
	********************************************************************
	Sync Functions
	********************************************************************
	********************************************************************
]]--

--[[ ********************************
		Position Sync
	 ********************************]]--

local pos_sync_table = {};
local pos_last_asked_sync = {};
local pos_send_my_until = 0;
local pos_dont_send_to_fast = 0;

local function send_position_sync()
	SetMapToCurrentZone();
	local x,y = GetPlayerMapPosition("player");
	local zone = GetRealZoneText();
	vbm_send_mess("MYPOS "..x.."@"..y.."@"..zone);
end

function VBM_PositionSync_OnUpdate()
	--runs 20 times each second
	if(pos_send_my_until > GetTime()) then
		--dont send to fast
		if(pos_dont_send_to_fast + 1 > GetTime()) then
			return;
		end
		pos_dont_send_to_fast = GetTime();
		--send
		send_position_sync();
	end
end

function VBM_PositionSyncRequest_Recive(msg,from)
	if(msg==VBM_YOU) then
		pos_send_my_until = GetTime()+8;
	end
end

function VBM_PositionSync_Recive(msg,from)
	local found,_,x,y,zone = string.find(msg,"(.+)@(.+)@(.+)");
	if(found) then
		pos_sync_table[from] = {
			x = tonumber(x),
			y = tonumber(y),
			zone = zone,
		};
	end
end

function VBM_GetPlayerMapPosition(uid)
	if(UnitExists(uid)) then
		--fix your own coords
		SetMapToCurrentZone();
		--get coords
		local x,y = GetPlayerMapPosition(uid);
		--if we got coords from blizz UI just pass them
		if(x+y > 0) then
			return x,y;
		end
		--get coords from sync
		local name = UnitName(uid);
		--check if we should ask for new sync
		if(not pos_last_asked_sync[name]) then pos_last_asked_sync[name] = 0; end --to be failsafe
		if(pos_last_asked_sync[name]+5 < GetTime()) then
			pos_last_asked_sync[name] = GetTime();
			vbm_send_mess("REQUESTPOS "..name);
		end
		--okay now fetch from table
		if(not pos_sync_table[name]) then
			--not updated yet or no vbm
			return 0,0;
		end
		--check if we are in same zone
		if(GetRealZoneText()==pos_sync_table[name].zone) then
			return pos_sync_table[name].x,pos_sync_table[name].y;
		else
			return 0,0;
		end
	end
	return GetPlayerMapPosition(uid);
end
