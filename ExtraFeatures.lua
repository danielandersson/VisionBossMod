--[[
	********************************************************************
	********************************************************************
	Extra Features:
	
	Officers chat commands
	Auto Repair
	Remote Logout
	AutoAccept Ress --comging soon
	'Invite' Keyword, with an allready grouped mess
	Leader Roll
	Battleground Honor report
	Auto Roll Loot Select
	Group Loot Warning
	Master Loot Reminder
	Badge Loot Reminder
	SoloAutoLootBoP
	LFG/BG Handle Sound in Background
	
	
	LFD Timer
	Brewfest stuff
	
	********************************************************************
	********************************************************************
	
	Extra Extra Features:
	VBM_StormEarthFire
	VBM_LamentoftheHighborne
	VBM_WowMain
	VBM_BcMain
	VBM_Sound_Majordomo
	VBM_Sound_Ragnaros
	VBM_Sound_Vaelastrasz
	VBM_Sound_Nefarius
	VBM_Sound_Nefarian
	VBM_Sound_Gothik
	VBM_Sound_HighlordMograine
	VBM_Sound_FourHorsemen
]]--

--local setting func
local VBM_GetS = VBM_GetS;

VBM_BADGE_REMINDER = {
	"Badge of Justice", "Emblem of Valor", "Emblem of Heroism", "Emblem of Conquest", "Emblem of Triumph"
};

VBM_AUTOLOOT_EXCEPTIONS = {
	"Design", "Formula", "Manual", "Pattern", "Plans", "Recipe", "Schematic",
	"Frozen Orb", "Sack of Gems",
};

function VBM_ExtraFeatures_OnLoad(self)
	self:RegisterEvent("MERCHANT_SHOW");
	self:RegisterEvent("CHAT_MSG_OFFICER");
	self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
	self:RegisterEvent("LFG_UPDATE");
	self:RegisterEvent("RESURRECT_REQUEST");
	self:RegisterEvent("CHAT_MSG_WHISPER");
	self:RegisterEvent("CHAT_MSG_BN_WHISPER");
	self:RegisterEvent("CHAT_MSG_SYSTEM");
	
	--combat log
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	--chat
	self:RegisterEvent("CHAT_MSG_RAID");
	self:RegisterEvent("CHAT_MSG_RAID_LEADER");
	self:RegisterEvent("CHAT_MSG_PARTY");
	--loot
	self:RegisterEvent("START_LOOT_ROLL");
	self:RegisterEvent("CHAT_MSG_LOOT");
	self:RegisterEvent("LOOT_SLOT_CLEARED");
	self:RegisterEvent("LOOT_BIND_CONFIRM");
	self:RegisterEvent("LOOT_OPENED");
	--LFD
	self:RegisterEvent("LFG_PROPOSAL_SHOW");
	self:RegisterEvent("LFG_PROPOSAL_SUCCEEDED");
	self:RegisterEvent("LFG_PROPOSAL_FAILED");
	--pet tank
	self:RegisterEvent("UNIT_TARGET");
end

function VBM_ExtraFeatures_OnEvent(self,event,...)
	if(event == "COMBAT_LOG_EVENT_UNFILTERED") then
		--always detect and sync
		VBM_Rebirth_Tracking(...); --statusframe.lua
		--only go if selected
		if(VBM_WHISPERCAST_ON) then 
			VBM_WhisperCastParse(...);--extraslashcommands.lua
		end
		if(VBM_RAIDCAST_ON) then
			VBM_RaidCastParse(...);--extraslashcommands.lua
		end
		return;
	end
	
	--[[
	if(event~="WORLD_MAP_UPDATE") then
		if(event) then vbm_print("event = "..event); end
		if(arg1) then vbm_print("arg1 = "..arg1); end
		if(arg2) then vbm_print("arg2 = "..arg2); end
	end]]--
	
	if(event == "UNIT_TARGET") then
		local arg1 = ...;
		if(arg1=="pet") then
			VBM_PetTargetEvent(arg1);
		end
	end
	
	if(event == "MERCHANT_SHOW") then
		VisionBossMod_Auto_Repair();
		return;
	end

	if(event == "CHAT_MSG_OFFICER") then
		local arg1,arg2 = ...;
		VBM_Officers_chat_commands(arg1,arg2);
		return;
	end
	
	if(event == "UPDATE_BATTLEFIELD_STATUS") then
		VBM_BGHonorRemport();
		VBM_LFG_HandleSoundinBackground();
		return;
	end
	
	if(event == "LFG_UPDATE") then
		VBM_LFG_HandleSoundinBackground();
		return;
	end
	
	if(event == "RESURRECT_REQUEST") then
		VBM_AutoAcceptRess();
		return;
	end
    
    if(event == "CHAT_MSG_WHISPER") then
		local arg1,arg2 = ...;
		if(VBM_GetS("InviteKeyword") and arg1) then
			 if(string.lower(arg1)=="invite" or (VBM_GetS("ShortInviteKeyword") and string.lower(arg1)=="inv") ) then
			 	InviteUnit(arg2);
			 end
		end
		if(VBM_VOTE_RUNNING) then
			VBM_VoteReciveWhisper(arg1,arg2);
		end
		return;
	end
	
	if(event == "CHAT_MSG_BN_WHISPER") then
		local arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13 = ...;
		if(VBM_GetS("InviteKeyword") and arg1) then
			 if(string.lower(arg1)=="invite" or (VBM_GetS("ShortInviteKeyword") and string.lower(arg1)=="inv") ) then
			 	local presenceID, givenName, surname, toonName = BNGetFriendInfoByID(arg13);
			 	if(CanCooperateWithToon(presenceID)) then
			 		InviteUnit(toonName);
			 	end
			 end
		end
		
	end
	
	if(event == "CHAT_MSG_SYSTEM") then
		VBM_LeaderRollResult(...);
		VBM_AllreadyGrouped(...);
		return;
	end
	
	if(event == "START_LOOT_ROLL") then
		VBM_AutoRollLootSelect(...);
		return;
	end
	
	if(event == "CHAT_MSG_RAID" or
		event == "CHAT_MSG_RAID_LEADER" or
		event == "CHAT_MSG_PARTY") then
		VBM_AbortPullCD(...);
		VBM_EasterEggs(...);
		return;
	end
	
	if(event == "CHAT_MSG_LOOT") then
		VBM_BadgeLootReminder(...);
		VBM_Brewfest(...);
		return;
	end
	
	if(event == "LOOT_BIND_CONFIRM") then
		SoloAutoLootBoPConfirm(...);
		return;
	end
	if(event == "LOOT_SLOT_CLEARED") then
		SoloAutoLootBoPCleared(...);
		return;
	end
	if(event == "LOOT_OPENED") then
		SoloAutoLootBoPOpen(...);
		return;
	end
	
	if(event == "LFG_PROPOSAL_SHOW") then
		VBM_BossTimer(40,"LFG",VBM_ICONS.."inv_misc_pocketwatch_01");
		return;
	end
	if(event == "LFG_PROPOSAL_SUCCEEDED" or event == "LFG_PROPOSAL_FAILED") then
		VBM_RemoveTimer("LFG");
		return;
	end
end

function VBM_Officers_chat_commands(arg1,arg2)
	if(arg1 == "!a") then
		if(UnitIsGroupLeader("player")) then
			PromoteToAssistant(arg2);
		end
		return;
	end
	local found,f2,p1,p2;
	-- kick
	found,_,p1 = string.find(arg1,"!kick (.+)");
	if(found) then
		if(UnitIsGroupLeader("player")) then
			UninviteUnit(p1);
		end
		return;
	end
	found,_,p1 = string.find(arg1,"!k (.+)");
	if(found) then
		if(UnitIsGroupLeader("player")) then
			UninviteUnit(p1);
		end
		return;
	end
	-- promote
	found,_,p1 = string.find(arg1,"!promote (.+)");
	if(found) then
		if(UnitIsGroupLeader("player")) then
			PromoteToAssistant(p1);
		end
		return;
	end
	found,_,p1 = string.find(arg1,"!p (.+)");
	if(found) then
		if(UnitIsGroupLeader("player")) then
			PromoteToAssistant(p1);
		end
		return;
	end
end

function VisionBossMod_Auto_Repair()
	if(VBM_GetS("AutoRepair") and CanMerchantRepair() and GetRepairAllCost() > 0) then
		local money = GetMoney();
		local rc = GetRepairAllCost();
		local gbank = false;
		
		if(VBM_GetS("AutoRepairUseGBank")) then
			if(CanGuildBankRepair()) then
				RepairAllItems(1);
				vbm_print("|cFF8888CC<VisionBossMod> AutoRepair (Guild Bank) cost: "..VBM_FormatMoney(rc));
				gbank = true;
			end
		end

		-- if rc + 5g is more then the money you got abort
		if(rc + 50000 > money and VBM_GetS("AutoRepairSave5g")) then
			vbm_print("|cFF8888CC<VisionBossMod> Aborting AutoRepair, Your total Gold will be under|cFFFFFFFF 5 |cFF8888CCafter a repair");
		else
			RepairAllItems();
			if(not gbank) then
				vbm_print("|cFF8888CC<VisionBossMod> AutoRepair cost: "..VBM_FormatMoney(rc));
			end
		end

        -- hide the repair dialog
        StaticPopup_Hide("USE_GUILDBANK_REPAIR");
	end
end

function VisionBossMod_TellLogoutName(name)
	StaticPopupDialogs["VBM_CONFIRM_RLOGOUT"] = {
	  text = "Are you sure you want to remote logout "..name.."?",
	  button1 = "Yes",
	  button2 = "No",
	  OnAccept = function()
		vbm_print("|cFF8888CC<VisionBossMod> Remote logout on: |cFFFFFFFF"..name);
		vbm_send_mess("RLOGOUT "..name);
	  end,
	  timeout = 0,
	  whileDead = 1,
	  hideOnEscape = 1,
	};
	StaticPopup_Show("VBM_CONFIRM_RLOGOUT");
end

function VisionBossMod_ReciveLogout(who,from)
	if(string.lower(who) == string.lower(UnitName("player")) and VBM_GetRank(from) > 0) then
		vbm_print("|cFF8888CC<VisionBossMod> Recived remote logout from: |cFFFFFFFF"..from);
		VBM_DelayByName("RLReplay", 1, VisionBossMod_ReciveLogoutReply,from);
		if(not IsResting()) then
			Logout();
		end
	end
end

function VisionBossMod_ReciveLogoutReply(from) 
	if(VBM_GLOBAL_ERROR_MESS) then
		SendChatMessage("<VBM> Error logging out","WHISPER",nil,from);
	else
		if(IsResting()) then
			SendChatMessage("<VBM> I am in a resting area and will not logout","WHISPER",nil,from);
		else
			SendChatMessage("<VBM> Will logout in 20 sec","WHISPER",nil,from);
		end
	end
end

function VBM_AutoAcceptRess()
	if(ResurrectHasSickness()) then return; end -- do not autotake ress sickness
	
	if(ResurrectHasTimer()) then
	
	else
	
	end
end

function VBM_AllreadyGrouped(arg1)
	if(VBM_GetS("InviteKeyword")) then
		if(VBM_GetS("NoWhisperInviteKeyword")) then return; end
		local found,p1;
		found, _, p1 = string.find(arg1,"(.+) is already in a group%.");
		if(found) then
			SendChatMessage("<VBM> You are already in a group, leave it and resend 'invite'","WHISPER",nil,p1);
		end
	end
end


function VBM_MakeLeaderRollList()
	local i;
	local c=0;
	local l = {};
	for i=1,GetNumGroupMembers() do
		c = c+1;
		l[#l+1] = i.." = "..UnitName("raid"..i);
		if(c>4) then
			c = 0;
			vbm_sendchat(table.concat(l,", "));
			l = {};
		end
		
	end
	if(c>0) then
		vbm_sendchat(table.concat(l,", "));
	end
end

function VBM_MakeLeaderRoll()
	if(IsInRaid()) then
		if (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
			RandomRoll(1,GetNumGroupMembers());
		else
			vbm_printc("LeaderRoll: You are not Leader or promoted");
		end
	else
		RandomRoll(1,1);
	end
end

function VBM_LeaderRollResult(arg1)
	--get nr of players
	local nr;
	if(IsInRaid()) then
		if (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
			nr = GetNumGroupMembers();
		else
			return;
		end
	else
		nr = 1;
	end
	--parse roll string
	local found;
	local rnd_value;
	found, _, rnd_value = string.find(arg1,UnitName("player").." rolls (%d*) %(1%-"..nr.."%)");
	--disp result
	if(found) then
		if(IsInRaid()) then
			vbm_sendchat("Leader Roll: (1-"..nr.."): "..rnd_value.." = "..UnitName("raid"..rnd_value).." ("..VBM_GetGroupNr(UnitName("raid"..rnd_value))..")");
		else
			local char_name;
			if(rnd_value == "1") then
				char_name = UnitName("player");
			else
				char_name = UnitName("party"..rnd_value-1);
			end
			
			vbm_sendchat("Leader Roll: (1-"..nr.."): "..rnd_value.." = "..char_name);
		end
	end
end

local VBM_BGHONORREPORT = {
	active = false,
	honor = 0,
	map = "";
};
function VBM_BGHonorRemport()
	if(not VBM_GetS("BGHonorReport")) then return; end
	
	--dont count if honor today is 0
	local _,honor = GetPVPSessionStats();
	if(honor == 0) then
		return;
	end
	
	if(VBM_BGHONORREPORT.active) then
		local status, mapName, instanceID = GetBattlefieldStatus(VBM_BGHONORREPORT.active);
		if(status ~= "active") then
			VBM_BGHONORREPORT.active = false;
			local _,honor = GetPVPSessionStats();
			VBM_Delay(VBM_LOAD_LAG_TIME,vbm_printc,"Honor gained in "..VBM_BGHONORREPORT.map..": |cFFFFFFFF"..(honor-VBM_BGHONORREPORT.honor).." |cFF8888CCTotal today: |cFFFFFFFF"..honor);
		end
	end
	
	local i;
	for i=1, MAX_BATTLEFIELD_QUEUES do
		local status, mapName, instanceID = GetBattlefieldStatus(i);
		if(status == "active" and not VBM_BGHONORREPORT.active) then
			VBM_BGHONORREPORT.active = i;
			VBM_BGHONORREPORT.map = mapName;
			_,VBM_BGHONORREPORT.honor = GetPVPSessionStats(); --first is HKS
		end
	end
end

function VBM_AutoRollLootSelect(arg1)
	if(VBM_GetS("AutoLootSelect")) then
		local texture, name, count, quality, bindOnPickUp, canNeed, canGreed, canDisenchant = GetLootRollItemInfo(arg1);
		
		if(not bindOnPickUp) then
			local i;
			for i=1,#VBM_AUTOLOOT_EXCEPTIONS do
				if(string.find(name,VBM_AUTOLOOT_EXCEPTIONS[i],1,true)) then
					--if the item is in exceptions list just return and dont auto select
					return;
				end
			end

			if(VBM_GetS("LootSelectNoEpic") and quality > 3) then
				--q3 = rare q4=epic return if we shall not auto on epics
				return;
			end
			
			vbm_printc("Auto"..VBMSettings['LootSelectOption'].."ed |cFFFFFFFF"..GetLootRollItemLink(arg1));
			if(VBMSettings['LootSelectOption']=="Pass") then
				RollOnLoot(arg1,0);
			elseif(VBMSettings['LootSelectOption']=="Need") then
				RollOnLoot(arg1,1);
			elseif(VBMSettings['LootSelectOption']=="Greed") then
				RollOnLoot(arg1,2);
			elseif(VBMSettings['LootSelectOption']=="Diss") then
				if(canDisenchant) then
					RollOnLoot(arg1,3);
				else
					RollOnLoot(arg1,2);
				end
			end
		end
	end
end

function VBM_GroupLootWarn()
	if(VBM_GetS("GroupLootWarn")) then
		if(GetLootMethod()=="group") then
			vbm_printc("LootMethod is |cFFFFFFFFGroupLoot");
			vbm_infowarn("LootMethod is GroupLoot",10);
		end
	end
end

function VBM_MasterLootReminder(status)
	--if master loot reminder is on and raid members is over 20 and no vbm_boss is set then
	if(VBM_GetS("MasterLootReminder") and GetNumGroupMembers() > 15) then
		if(status=="start") then
			if(GetLootMethod()~="master") then
				vbm_infowarn("Boss detected Turn on Master Loot",0.1,1,0,0);
				VBM_DelayByName("MasterLootReminder",4,VBM_MasterLootReminder,"start");
			end
		elseif(status=="dead" and not VBM_BOSS) then
			if(GetLootMethod()=="master") then
				vbm_infowarn("Master Loot is on (will remind 5 more times)",4);
				VBM_Delay(10,VBM_MasterLootReminder,"repeatdead");
				VBM_Delay(20,VBM_MasterLootReminder,"repeatdead");
				VBM_Delay(30,VBM_MasterLootReminder,"repeatdead");
				VBM_Delay(40,VBM_MasterLootReminder,"repeatdead");
				VBM_Delay(50,VBM_MasterLootReminder,"repeatdead");
			end
		elseif(status=="repeatdead") then
			if(GetLootMethod()=="master") then
				vbm_infowarn("Master Loot is on",4);
			end
		end
	end
end

local VBM_BADGE_LOOTED = {};
function VBM_BadgeLootReminder(msg)
	if(not VBM_GetS("BadgeReminder")) then return; end

	local f,who,loot;
	f,_,who,loot = string.find(msg,"(.+) receive[s]* loot: (.+)");
	if(f) then
		local i;
		for i=1,#VBM_BADGE_REMINDER do
			if(string.find(loot,VBM_BADGE_REMINDER[i])) then
				VBM_BADGE_LOOTED[who] = true;
				VBM_DelayByName("BadgeLootReminder",60,VBM_BadgeLootReminderCheck);
			end
		end
	end
end

function VBM_BadgeLootReminderCheck()
	--get nr of group members
	local nr = 0;
	if(GetNumGroupMembers()>0) then
		nr = GetNumGroupMembers();
	end
	nr = math.floor(nr*0.45);
	--count table
	local a,b;
	local count = 0;
	for a,b in pairs(VBM_BADGE_LOOTED) do
		count = count + 1;
	end
	--go if count is bigger then nr
	if(count > nr) then
		--check if you have not looted
		if(not VBM_BADGE_LOOTED["You"]) then
			vbm_infowarn("No Badge Token Looted",10);
			vbm_printc("Detected that you have missed to loot a "..vbm_c_w.."Badge Token"..vbm_c_p..", please check manually");
		end
	end
	--reset table
	VBM_BADGE_LOOTED = {};
end

function SoloAutoLootBoPConfirm(slot)
	if(not VBM_GetS("AutoSoloBoPLoot")) then return; end
	
	if(GetNumGroupMembers()==0) then
		vbm_printc("Trying to auto loot BoP item: "..GetLootSlotLink(slot));
		--during 1 second try to confirm it 10 times
		ConfirmLootSlot(slot);
		VBM_Delay(0.1,ConfirmLootSlot,slot);
		VBM_Delay(0.2,ConfirmLootSlot,slot);
		VBM_Delay(0.3,ConfirmLootSlot,slot);
		VBM_Delay(0.4,ConfirmLootSlot,slot);
		VBM_Delay(0.5,ConfirmLootSlot,slot);
		VBM_Delay(0.6,ConfirmLootSlot,slot);
		VBM_Delay(0.7,ConfirmLootSlot,slot);
		VBM_Delay(0.8,ConfirmLootSlot,slot);
		VBM_Delay(0.9,ConfirmLootSlot,slot);
	end
end

function SoloAutoLootBoPCleared(slot)
	if(not VBM_GetS("AutoSoloBoPLoot")) then return; end
	
	if(GetNumGroupMembers()==0) then
		--if is auto looting auto click on next BoP
		if(VBM_AUTO_LOOTING) then
			local i;
			for i=1,GetNumLootItems() do
				VisionBossMod_TTTextLeft2:SetText();
				VisionBossMod_TT:SetLootItem(i);
				if(VisionBossMod_TTTextLeft2:GetText() and VisionBossMod_TTTextLeft2:GetText()=="Binds when picked up") then
					LootSlot(i);
					return;
				end
			end
		end
	end
end

function SoloAutoLootBoPOpen(autoloot)
	if(autoloot==1) then
		VBM_AUTO_LOOTING = true;
	else
		VBM_AUTO_LOOTING = false;
	end
end

function VBM_Brewfest(l)
	if(string.find(l,"Brewfest Prize Token")) then
		vbm_infowarn(vbm_c_g.."[Brewfest Prize Token]");
	end
	
	if(string.find(l,"Portable Brewfest Keg")) then
		vbm_infowarn(vbm_c_w.."[Portable Brewfest Keg]");
	end
end

function VBM_LFG_HandleSoundinBackground()
	if(not VBM_GetS("LFGBGSoundHandling")) then return; end
	
	--check if bg is active
	local nr_active = 0;
	local i;
	for i=1, MAX_BATTLEFIELD_QUEUES do
		local status, mapName, instanceID = GetBattlefieldStatus(i);
		--track nr of "active bgs"
		if(status == "queued" or status == "confirm" or status == "active") then
			nr_active = nr_active + 1;
		end
	end
	
	--check if lfg queue is active
	local lfg = GetLFGMode();
	
	if(nr_active > 0 or lfg) then
		--remove our 5 min turn off timer
		VBM_DelayRemove("AUTOBGSOUND");
		--if not on then turn on
		if(GetCVar("Sound_EnableSoundWhenGameIsInBG")=="0") then
			VBM_SetCVar("Sound_EnableSoundWhenGameIsInBG","1",true);
			vbm_printc("Auto Handle "..vbm_c_w.."Sound in Background "..vbm_c_g.."on");
		end
	else
		--no bgs active, turn off
		VBM_DelayByName("AUTOBGSOUND",2*60,function()
			if(GetCVar("Sound_EnableSoundWhenGameIsInBG")=="1") then
				VBM_SetCVar("Sound_EnableSoundWhenGameIsInBG","0",true);
				vbm_printc("Auto Handle "..vbm_c_w.."Sound in Background "..vbm_c_r.."off "..vbm_c_p.."(no activity for 2min)");
			end
		end);
	end
end

--[[
	********************************************************************
	********************************************************************
					Extra Extra Features	
	********************************************************************
	********************************************************************
]]--


function VBM_StormEarthFire()
	PlayMusic("Sound\\Music\\ZoneMusic\\DMF_L70ETC01.mp3");
end

function VBM_LamentoftheHighborne()
	PlayMusic("Sound\\Music\\GlueScreenMusic\\BCCredits_Lament_of_the_Highborne.mp3")
end

function VBM_WowMain()
	PlayMusic("Sound\\Music\\GlueScreenMusic\\wow_main_theme.mp3")
end

function VBM_BcMain()
	PlayMusic("Sound\\Music\\GlueScreenMusic\\BC_main_theme.mp3")
end

function VBM_WotlkMain()
	PlayMusic("Sound\\Music\\GlueScreenMusic\\WotLK_main_title.mp3")
end

function VBM_Mgt_KT_Theme()
	PlayMusic("Sound\\Music\\ZoneMusic\\Sunwell\\SW_MagistersAsylumWalkUni01.mp3")
end

--[[ *********************
		WoW Classic
     *********************]]--


function VBM_Sound_Majordomo(_,_,nr)
	if(not nr) then nr=1; end
	if(nr==1) then
		VBM_PlaySoundFile("Sound\\Creature\\Executus\\ExecutusSpawn01.wav");
		VBM_Delay(9,VBM_Sound_Majordomo,"","",nr+1);
	elseif(nr==2) then
		VBM_PlaySoundFile("Sound\\Creature\\Executus\\ExecutusDefeat01.wav");
	end
end

function VBM_Sound_Ragnaros(_,_,nr)
	if(not nr) then nr=1; end
	if(nr==1) then
		VBM_PlaySoundFile("Sound\\Creature\\Executus\\ExecutusSummon01.wav");
		VBM_Delay(14,VBM_Sound_Ragnaros,"","",nr+1);
	elseif(nr==2) then
		VBM_PlaySoundFile("Sound\\Creature\\Ragnaros\\RagnarosArrival01.wav");
		VBM_Delay(13,VBM_Sound_Ragnaros,"","",nr+1);
	elseif(nr==3) then
		VBM_PlaySoundFile("Sound\\Creature\\Executus\\ExecutusArrival02.wav");
		VBM_Delay(8,VBM_Sound_Ragnaros,"","",nr+1);
	elseif(nr==4) then
		VBM_PlaySoundFile("Sound\\Creature\\Ragnaros\\RagnarosArrival03.wav");
		VBM_Delay(20,VBM_Sound_Ragnaros,"","",nr+1);
	elseif(nr==5) then
		VBM_PlaySoundFile("Sound\\Creature\\Ragnaros\\RagnarosArrival05.wav");
	end	
end

function VBM_Sound_Vaelastrasz(_,_,nr)
	if(not nr) then nr=1; end
	if(nr==1) then
		VBM_PlaySoundFile("Sound\\Creature\\Vaelastrasz\\VaelastraszLine1.wav");
		VBM_Delay(9,VBM_Sound_Vaelastrasz,"","",nr+1);
	elseif(nr==2) then
		VBM_PlaySoundFile("Sound\\Creature\\Vaelastrasz\\VaelastraszLine2.wav");
		VBM_Delay(12,VBM_Sound_Vaelastrasz,"","",nr+1);
	elseif(nr==3) then
		VBM_PlaySoundFile("Sound\\Creature\\Vaelastrasz\\VaelastraszLine3.wav");
		VBM_Delay(18,VBM_Sound_Vaelastrasz,"","",nr+1);
	elseif(nr==4) then
		VBM_PlaySoundFile("Sound\\Creature\\Vaelastrasz\\Vaelastrasz50Health.wav");
	end
	
	
end

function VBM_Sound_Nefarius(_,_,nr)
	if(not nr) then nr=1; end
	if(nr==1) then
		VBM_PlaySoundFile("Sound\\Creature\\LordVictorNefarius\\LordVictorNefariusStart.wav");
		VBM_Delay(21,VBM_Sound_Nefarius,"","",nr+1);
	elseif(nr==2) then
		VBM_PlaySoundFile("Sound\\Creature\\LordVictorNefarius\\LordVictorNefariusGames.wav");
	end
end

function VBM_Sound_Nefarian(_,_,nr)
	if(not nr) then nr=1; end
	if(nr==1) then
		VBM_PlaySoundFile("Sound\\Creature\\Nefarian\\NefarianAggro.wav");
		VBM_Delay(10,VBM_Sound_Nefarian,"","",nr+1);
	elseif(nr==2) then
		VBM_PlaySoundFile("Sound\\Creature\\Nefarian\\NefarianNapalmStrike.wav");
		VBM_Delay(4,VBM_Sound_Nefarian,"","",nr+1);
	elseif(nr==3) then
		VBM_PlaySoundFile("Sound\\Creature\\Nefarian\\NefarianRaiseSkeleton.wav");
		VBM_Delay(7,VBM_Sound_Nefarian,"","",nr+1);
	elseif(nr==4) then
		VBM_PlaySoundFile("Sound\\Creature\\Nefarian\\NefarianDeath.wav");
	end	
end

function VBM_Sound_Gothik(_,_,nr)
	if(not nr) then nr=1; end
	if(nr==1) then
		VBM_PlaySoundFile("Sound\\Creature\\Gothik\\GOT_NAXX_SPCH.wav");
		VBM_Delay(25,VBM_Sound_Gothik,"","",nr+1);
	elseif(nr==2) then
		VBM_PlaySoundFile("Sound\\Creature\\Gothik\\GOT_NAXX_TLPRT.wav");
	end
end

function VBM_Sound_HighlordMograine(_,_,nr)
	VBM_PlaySoundFile("Sound\\Creature\\HighlordMograine\\MOG_NAXX_TAUNT03.wav");
end

function VBM_Sound_HeiganDance(_,_,nr)
	VBM_PlaySoundFile("Sound\\Creature\\Loathstare\\LOA_NAXX_TAUNT04.wav");
end

function VBM_Sound_Hakkar(_,_,nr)
	VBM_PlaySoundFile("Sound\\Creature\\Patch1.7_VO_Lines\\HakkarAggro.wav");
end

function VBM_Sound_FourHorsemen(_,_,nr)
	if(not nr) then nr=1; end
	if(nr==1) then
		VBM_PlaySoundFile("Sound\\Creature\\ThaneKorthazz\\KOR_NAXX_TAUNT01.wav");
		VBM_Delay(4,VBM_Sound_FourHorsemen,"","",nr+1);
	elseif(nr==2) then
		VBM_PlaySoundFile("Sound\\Creature\\SirZeliek\\ZEL_NAXX_TAUNT01.wav");
		VBM_Delay(6,VBM_Sound_FourHorsemen,"","",nr+1);
	elseif(nr==3) then
		VBM_PlaySoundFile("Sound\\Creature\\DameBlaumeux\\BLA_NAXX_TAUNT01.wav");
		VBM_Delay(6,VBM_Sound_FourHorsemen,"","",nr+1);
	elseif(nr==4) then
		VBM_PlaySoundFile("Sound\\Creature\\HighlordMograine\\MOG_NAXX_TAUNT01.wav");
		VBM_Delay(6.5,VBM_Sound_FourHorsemen,"","",nr+1);
	elseif(nr==5) then
		VBM_PlaySoundFile("Sound\\Creature\\DameBlaumeux\\BLA_NAXX_TAUNT02.wav");
		VBM_Delay(6,VBM_Sound_FourHorsemen,"","",nr+1);
	elseif(nr==6) then
		VBM_PlaySoundFile("Sound\\Creature\\SirZeliek\\ZEL_NAXX_TAUNT02.wav");
		VBM_Delay(4.5,VBM_Sound_FourHorsemen,"","",nr+1);
	elseif(nr==7) then
		VBM_PlaySoundFile("Sound\\Creature\\ThaneKorthazz\\KOR_NAXX_TAUNT02.wav");
		VBM_Delay(6,VBM_Sound_FourHorsemen,"","",nr+1);
	elseif(nr==8) then
		VBM_PlaySoundFile("Sound\\Creature\\HighlordMograine\\MOG_NAXX_TAUNT02.wav");
	end	
end

--[[ *********************
		Burning Crusade
     *********************]]--
     
function VBM_Sound_WrathScryerAndDalliah(_,_,nr)
	VBM_PlaySoundFile("Sound\\Creature\\WrathScryerAndDalliah\\TEMPEST_WrthDalliah_Argue01.wav");
end

function VBM_Sound_EredarTwins(_,_,nr)
	VBM_PlaySoundFile("Sound\\Creature\\LadySacrolash\\SACROLASHINTRO.wav");
end

function VBM_Sound_AssaultBT(_,_,nr)
	if(not nr) then nr=1; end
	if(nr==1) then
		VBM_PlaySoundFile("Sound\\Creature\\Akama\\BLCKTMPLE_Akama_01.wav");
		VBM_Delay(7,VBM_Sound_AssaultBT,"","",nr+1);
	elseif(nr==2) then
		VBM_PlaySoundFile("Sound\\Creature\\Akama\\BLCKTMPLE_Akama_02.wav");
		VBM_Delay(5,VBM_Sound_AssaultBT,"","",nr+1);
	elseif(nr==3) then
		VBM_PlaySoundFile("Sound\\Creature\\Maiev\\BLACK_Maiev_09.wav");
	end
end

function VBM_Sound_AkamaWarn(_,_,nr)
	VBM_PlaySoundFile("Sound\\Creature\\Akama\\BLCKTMPLE_Akama_PreFight01.wav");
end

function VBM_Sound_IllidanStormrage(_,_,nr)
	if(not nr) then nr=1; end
	if(nr==1) then
		VBM_PlaySoundFile("Sound\\Creature\\Illidan\\BLACK_Illidan_01.wav");
		VBM_Delay(13,VBM_Sound_IllidanStormrage,"","",nr+1);
	elseif(nr==2) then
		VBM_PlaySoundFile("Sound\\Creature\\Akama\\BLCKTMPLE_Akama_FightBgn01.wav");
		VBM_Delay(10,VBM_Sound_IllidanStormrage,"","",nr+1);
	elseif(nr==3) then
		VBM_PlaySoundFile("Sound\\Creature\\Illidan\\BLACK_Illidan_02.wav");
		VBM_Delay(6.5,VBM_Sound_IllidanStormrage,"","",nr+1);
	elseif(nr==4) then
		VBM_PlaySoundFile("Sound\\Creature\\Akama\\BLCKTMPLE_Akama_Freed01.wav");
		VBM_Delay(4,VBM_Sound_IllidanStormrage,"","",nr+1);
	elseif(nr==5) then
		VBM_PlaySoundFile("Sound\\Creature\\Illidan\\BLACK_Illidan_04.wav");
	end
end

function VBM_Sound_MaievvsIllidan(_,_,nr)
	if(not nr) then nr=1; end
	if(nr==1) then
		VBM_PlaySoundFile("Sound\\Creature\\Illidan\\BLACK_Illidan_14.wav");
		VBM_Delay(9,VBM_Sound_MaievvsIllidan,"","",nr+1);
	elseif(nr==2) then
		VBM_PlaySoundFile("Sound\\Creature\\Maiev\\BLACK_Maiev_01.wav");
		VBM_Delay(7,VBM_Sound_MaievvsIllidan,"","",nr+1);
	elseif(nr==3) then
		VBM_PlaySoundFile("Sound\\Creature\\Illidan\\BLACK_Illidan_15.wav");
		VBM_Delay(5.5,VBM_Sound_MaievvsIllidan,"","",nr+1);
	elseif(nr==4) then
		VBM_PlaySoundFile("Sound\\Creature\\Maiev\\BLACK_Maiev_02.wav");
	end
end

function VBM_Sound_DemonIllidan(_,_,nr)
	if(not nr) then nr=1; end
	if(nr==1) then
		VBM_PlaySoundFile("Sound\\Creature\\Illidan\\BLACK_Illidan_13.wav");
		VBM_Delay(8,VBM_Sound_DemonIllidan,"","",nr+1);
	elseif(nr==2) then
		VBM_PlaySoundFile("Sound\\Creature\\Illidan\\BLACK_Illidan_08.wav");
	end
end

function VBM_Sound_IllidanDefeated(_,_,nr)
	if(not nr) then nr=1; end
	if(nr==1) then
		VBM_PlaySoundFile("Sound\\Creature\\Maiev\\BLACK_Maiev_06.wav");
		VBM_Delay(5,VBM_Sound_IllidanDefeated,"","",nr+1);
	elseif(nr==2) then
		VBM_PlaySoundFile("Sound\\Creature\\Illidan\\BLACK_Illidan_16.wav");
		VBM_Delay(23,VBM_Sound_IllidanDefeated,"","",nr+1);
	elseif(nr==3) then
		VBM_PlaySoundFile("Sound\\Creature\\Maiev\\BLACK_Maiev_07.wav");
		VBM_Delay(9,VBM_Sound_IllidanDefeated,"","",nr+1);
	elseif(nr==4) then
		VBM_PlaySoundFile("Sound\\Creature\\Maiev\\BLACK_Maiev_08.wav");
		VBM_Delay(4.5,VBM_Sound_IllidanDefeated,"","",nr+1);
	elseif(nr==5) then
		VBM_PlaySoundFile("Sound\\Creature\\Akama\\BLCKTMPLE_Akama_FinalWin01.wav");
	end
end

--[[ *********************
	  Wrath of the Lich King
     *********************]]--
     
function VBM_Sound_YoggSaraTransform(_,_,nr)
	VBM_PlaySoundFile("Sound\\Creature\\YoggSaron\\UR_YoggSaron_PhaseTwo01.wav");
end
