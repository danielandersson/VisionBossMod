--[[
arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20,arg21
timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,arg10,arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20,arg21
timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20,arg21
timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,environmentalType

local timestamp, combatEvent, hideCaster, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags = arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9;
local combatEvent, sourceName, sourceFlags, destName, destFlags = arg2,arg5,arg6,arg8,arg9;
local combatEvent, sourceName, destName = arg2,arg5,arg8;

"SPELL_AURA_APPLIED"
"SPELL_AURA_REMOVED"
local spellId, spellName, spellSchool, auraType = arg9,arg10,arg11,arg12;
local spellName, auraType = arg10,arg12;
"SPELL_AURA_APPLIED_DOSE"
"SPELL_AURA_REMOVED_DOSE"
local spellName, auraType, amount = arg10,arg12,arg13;
"SPELL_MISSED"
local spellId, spellName, spellSchool, missType = arg9,arg10,arg11,arg12;
local spellName, missType = arg10,arg12;
"SPELL_DISPEL_FAILED"
local spellId, spellName, spellSchool, extraSpellID, extraSpellName, extraSpellSchool = arg9,arg10,arg11,arg12,arg13,arg14;
local spellName, extraSpellName = arg10,arg13;
"SPELL_AURA_DISPELLED"
local spellId, spellName, spellSchool, extraSpellID, extraSpellName, extraSpellSchool, auraType = arg9,arg10,arg11,arg12,arg13,arg14,arg15;
local spellName, extraSpellName, auraType = arg10,arg13,arg15;

"SWING_DAMAGE"
"SWING_MISSED"
missType = arg9;

Klick ljud
VBM_PlaySoundFile("Sound\\Doodad\\BellTollNightElf.wav");
fet gånggång
VBM_PlaySoundFile("Sound\\Doodad\\BellTollAlliance.wav");
dovare gånggång
VBM_PlaySoundFile("Sound\\Doodad\\BellTollHorde.wav");
raidwarning
VBM_PlaySoundFile("Sound\\Interface\\RaidWarning.wav");
Pvp runa spawnar
VBM_PlaySoundFile("Sound\\Doodad\\PVP_Rune_speedCustom0.wav");
Simon spelet i Blades edge
VBM_PlaySoundFile("Sound\\Doodad\\SimonGame_SmallBlueTree.wav");
Boat dock
VBM_PlaySoundFile("Sound\\Doodad\\BoatDockedWarning.wav");
testing
VBM_PlaySoundFile("Sound\\Interface\\AlarmClockWarning2.wav");
VBM_PlaySoundFile("Sound\\Interface\\AuctionWindowClose.wav");
VBM_PlaySoundFile("Sound\\Interface\\PvpFlagTakenMono.wav");

vbm_verbose("|cFF4444CC<VisionBossMod> Verbose color");
vbm_print("|cFF8888CC<VisionBossMod> Print color");

COMBATLOG_MESSAGE_LIMIT = 300;
CONTAINER_SCALE = 0.75;

/script t = UIParent:CreateTexture(); t:SetAllPoints(); t:SetTexture(1,1,1); vbm_say("TEAM FLASH");
/run VBM_SimZone("Icecrown Citadel"); VBM_SetBoss("The Lich King"); VBM_BossStart("The Lich King");
/fp f ^[vV][bB][mM]

--new cata cool boss bars
UnitPower("player", ALTERNATE_POWER_INDEX)

--get frame name
/script DEFAULT_CHAT_FRAME:AddMessage( GetMouseFocus():GetName() );

]]--

--[[	
	******************
	Settings and global vars
	******************
]]--

VBM_VERSION = 3.03;
VBM_NEW_VERSION_OUT = false; -- will be set to true if a new version is out
VBM_VERSION_LIST = {}; -- intern data struct, used by /vbmversion function

VBM_LOAD_LAG_TIME = 10; --used for some delay print operations so the text wont be spammed away by other chat messeages during loading screen

VBM_IN_RAID = false; --used by vbm to auto request versions and raidmodes
VBM_HAS_INIT = false; -- this gets true then vbm is fully loaded
VBM_SETTINGS_LOADED = false; --gets set to true when vbm has run settings function

VBM_MSG_FROM = nil; -- will contain name of last recived addon message

VBM_GLOBAL_ERROR_MESS = nil; -- used to catch wow error messages, for remote Logout

local gmotd_only_once = true;

--boss handling vars
VBM_DUNGEON_DIFFICULTY = 1; -- will be 1 for normal or 2 for heroic
VBM_DUNGEON_SIZE = 10; -- will be 10 or 25
VBM_ZONE = false;
VBM_BOSS = false;
VBM_BOSSSTART = {};

--[[
************************************************
               FRAME FUNCTIONS
************************************************
]]--

function VisionBossMod_OnLoad(self)
	self.lastupdate = 0;
	
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("ADDON_LOADED"); -- used to hide minimap clock

	self:RegisterEvent("PLAYER_ENTERING_WORLD");
	self:RegisterEvent("ZONE_CHANGED_NEW_AREA");
	self:RegisterEvent("RAID_ROSTER_UPDATE");
	
	self:RegisterEvent("CHAT_MSG_ADDON");
	
	-- Used for remote logout
	self:RegisterEvent("UI_ERROR_MESSAGE");
	
	self:RegisterEvent("UNIT_COMBAT"); -- used to detect then encounter starts
	self:RegisterEvent("UNIT_TARGET"); -- used to detect then encounter starts
	self:RegisterEvent("PLAYER_TARGET_CHANGED"); --used to detect bosses
	
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED"); --used to detect then bosses die
	
	self:RegisterEvent("GUILD_ROSTER_UPDATE"); -- shows then motd is loaded
	self:RegisterEvent("GUILD_MOTD");
	
	--instance difficulty tracking
	self:RegisterEvent("PLAYER_DIFFICULTY_CHANGED");
	self:RegisterEvent("UPDATE_INSTANCE_INFO");
end


function VisionBossMod_OnEvent(self,event,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8)
	if(event=="COMBAT_LOG_EVENT_UNFILTERED") then
		if(VBM_ZONE and arg2 == "UNIT_DIED") then
			VBM_DetectBossDeath(arg8);
		end
		return;
	end
	
	if (event == "VARIABLES_LOADED") then 
		VisionBossMod_Init();
		VBM_RangeCheck_Init();
		VBM_StatusFrame_Init();
		VBM_ExtraSlash_Init();
		VBM_BGJoinFrame_Init();
		VBM_RaidModes_Init();
		VBM_Timers_Init();
		VBM_Arrow_Init();
		VBM_ClassExtra_Init();

		VBM_AutoRunHookFunctions(); --found in hooks.lua
		--gmotd
		if(VBM_GetS("ShowGMOTD") and gmotd_only_once and GetGuildRosterMOTD()~="") then
			vbm_infowarn("GMOTD: "..vbm_c_w..VBM_linebreakStr(GetGuildRosterMOTD(),45,true),20,0,1,0);
			gmotd_only_once = false;
		end
		return;
	end
	if(event == "ADDON_LOADED") then
		if(arg1 == "Blizzard_TimeManager") then
			VBM_HideMinimapButtons();
		end
		return;
	end
	if (event == "PLAYER_ENTERING_WORLD") then
		if(not VBM_HAS_INIT) then
			VBM_DoZoneDetect();
			VBM_DetectRaid();
			
			VBM_AutoRunEnterWorldHookFunctions(); --found in hooks.lua
			
			--AutoRunLUA Macro
			local arm = GetMacroBody("AutoRunAsLUA");
			if(arm) then
				vbm_printc("Found AutoRunAsLUA Macro, Running...");
				RunScript(arm);
			end
			
			VBM_HAS_INIT = true;
		end
		return;
	end
	
	if(event == "GUILD_ROSTER_UPDATE" or event == "GUILD_MOTD") then
		if(VBM_SETTINGS_LOADED and VBM_GetS("ShowGMOTD") and gmotd_only_once and GetGuildRosterMOTD()~="") then
			vbm_infowarn("GMOTD: "..vbm_c_w..VBM_linebreakStr(GetGuildRosterMOTD(),45,true),20,0,1,0);
			gmotd_only_once = false;
		end
		return;
	end
	
	--if not fully inited then just return
	if(not VBM_HAS_INIT) then return; end
	
	if (event == "RAID_ROSTER_UPDATE") then 
		VBM_DetectRaid();
		return;
	end
	
	-- turn on or off the addon depending on zone
	if (event == "ZONE_CHANGED_NEW_AREA") then 
		VBM_DoZoneDetect();
		return;
	end
	
	if(event == "PLAYER_DIFFICULTY_CHANGED" or event == "UPDATE_INSTANCE_INFO") then
		VBM_UpdateRaidSizeDifficulty();
		return;
	end
	
	if (event == "CHAT_MSG_ADDON") then 
		--recived valigt mess?
		if(arg1 == "VBM" and arg3 == "RAID") then
			VBM_MSG_FROM = arg4;
			vbm_recive_mess(arg2,VBM_MSG_FROM);
		end
		--sync mess recived?
		local found,_,p1 = string.find(arg1,"VBMSYNC (.+)");
		if(found and arg3 == "RAID") then
			VBM_MSG_FROM = arg4;
			--dont run if it is our own message because it has allready been run
			if(VBM_MSG_FROM ~= UnitName("player")) then
				vbm_recive_synced(tonumber(p1),arg2,VBM_MSG_FROM);
			end
		end
		--a vote whisper?
		if(arg1 == "VBMVOTE" and arg3 == "WHISPER") then
			VBM_VoteReciveWhisper(arg2,arg4);
		end
		return;
	end
	
	-- detect if remote logout failed
    if(event == "UI_ERROR_MESSAGE") then
    	if(arg1 == ERR_LOGOUT_FAILED) then
    		VBM_GLOBAL_ERROR_MESS = ERR_LOGOUT_FAILED;
    		VBM_DelayByName("ClearGlobalError", 4, function () VBM_GLOBAL_ERROR_MESS = nil; end);
    	end
    	return;
    end
    
	-- From here on we should check if we are in a raid instace, else it is not nessecary to run
	-- the functions below
	if(not VBM_ZONE) then return; end
	
    if(event=="UNIT_TARGET") then
		if(arg1=="target") then
			VBM_DetectBossStart(arg1);
		else
			VBM_DetectBossStart(arg1.."target");
		end
		return;
	end
	
    if(event=="UNIT_COMBAT") then
		if(arg1 and arg1=="target") then
			VBM_DetectBossStart(arg1);
		end
		return;
	end
	
	if(event=="PLAYER_TARGET_CHANGED") then
		VBM_DetectBossStart("target");
		return;
	end
end

function VisionBossMod_OnUpdate(self,elapsed)
	--dont update to fast
	self.lastupdate = self.lastupdate + elapsed;
	if(self.lastupdate > 0.05) then
		self.lastupdate = 0;
	else
		return
	end

	VBM_SF_UpdateTitle();
	VBM_Boss_OnUpdate();
	VBM_Delay_OnUpdate();
	VBM_PositionSync_OnUpdate();
end

function VisionBossMod_Init()
    --setup vbm comms
    if not RegisterAddonMessagePrefix then
        return
    end
    RegisterAddonMessagePrefix("VBM")
    if not IsAddonMessagePrefixRegistered("VBM") then
        vbm_debug("|cFFFF9922<VisionBossMod> Register(): |cFFFF0000failed!|r");
    else
        vbm_debug("|cFFFF9922<VisionBossMod> Register(): |cFF00FF00succeeded!|r");
    end
    --setup slash cmd  (/vbm in Status Frame file)
	SlashCmdList["VBM_update"] = VBM_RequestUpdate;  
	SLASH_VBM_update1 = "/vbmupdate";
	--SlashCmdList["VBM_helplist"] = VBM_Slashcommandinfo;  
	--SLASH_VBM_helplist1 = "/vbmhelp";
	SlashCmdList["VBM_remotelogout"] = VisionBossMod_TellLogoutName;   --extrafeatures.lua
	SLASH_VBM_remotelogout1 = "/vbmrl";
	SlashCmdList["VBM_CPUPoff"] = VBM_CPUPOff;  
	SLASH_VBM_CPUPoff1 = "/vbmcpuoff";
	
	--print load message 
	vbm_printc("VisionBossMod v"..vbm_c_w..VBM_VERSION..vbm_c_p.." loaded! Type /vbm to show main frame");
	
	--Set default settings
	VBM_Settings_SetDefaults();
	
	--Auto run som hooks and stuff
	VBM_Delay(VBM_LOAD_LAG_TIME,VBM_CPUWarning); --cpu profileing warning found in helpfunctions.lua
	VBM_Delay(VBM_LOAD_LAG_TIME,VBM_NoneEnglish); -- found in helpfunctions.lua
	VBM_Delay(VBM_LOAD_LAG_TIME,VBM_ExtraAutoGreedCheck);
	VBM_Delay(60,function() gmotd_only_once = false; end); --to make sure gmotd are only displayed during first minute of login
	
	--warning texts
	VBM_Setup_Warning_Text();
	
	--auto handle bg sound (found in extrafeatures.lua
	if(VBM_GetS("LFGBGSoundHandling")) then
		--during login turn off
		VBM_SetCVar("Sound_EnableSoundWhenGameIsInBG","0",true);
	end
	
	--Set ping level
	VBM_SetPingLevel();
end

function VBM_SetPingLevel()
	if(VBM_GetS("HighPingMode")) then
		VBM_BOSSTARGETYOUDELAY = 0.20;
	else
		VBM_BOSSTARGETYOUDELAY = 0.10;
	end
end

function VBM_Setup_Warning_Text()
	--setup font
	VBM_ZoneTextFont:SetFont(VBMSettings['WarningTextFont'],52,"THICKOUTLINE");
	--setup scale
	VBM_InfoWarningFrame:SetScale(VBMSettings['WarningTextScale']);
	VBM_DebuffWarningFrame:SetScale(VBMSettings['WarningTextScale']);
	VBM_WarningFrame:SetScale(VBMSettings['WarningTextScale']);
	--setup extra space
	VBM_DebuffWarningFrame:SetPoint("BOTTOM","VBM_InfoWarningFrame","TOP",0,12+VBMSettings['WarningTextExtraSpace']*10);
	VBM_WarningFrame:SetPoint("BOTTOM","VBM_DebuffWarningFrame","TOP",0,12+VBMSettings['WarningTextExtraSpace']*10);
	--setup anchor
	VBM_InfoWarningFrame:SetPoint("CENTER","UIParent","CENTER",0,26+VBMSettings['WarningTextAnchor']*10);
end

--[[
	********************************************************************
	********************************************************************
	Comunication Functions
	********************************************************************
	********************************************************************
]]--

function VBM_ExtraAutoGreedCheck()
	-- extra autogreed check
	if(VBM_GetS("LootSelectAutoGreed") and GetNumGroupMembers()==0) then
		if(VBMSettings['LootSelectOption'] ~= "Greed") then
			VBMSettings['LootSelectOption'] = "Greed";
			vbm_printc("You are not in a raid group, Setting AutoLoot to |cFFFFFFFFGreed");
		end
	end
	if(VBM_GetS("LootSelectAutoDiss") and GetNumGroupMembers()==0) then
		if(VBMSettings['LootSelectOption'] ~= "Diss") then
			VBMSettings['LootSelectOption'] = "Diss";
			vbm_printc("You are not in a raid group, Setting AutoLoot to |cFFFFFFFFDiss");
		end
	end
end

function VBM_DetectRaid()
	--Check if we have joined a raid group and if so request version
	if(GetNumGroupMembers()>0 and VBM_IN_RAID == false) then
		VBM_IN_RAID = true;
		vbm_verbosec("You have joined a raid group");
		--ask for new version
		vbm_send_mess("GET VERSION");
		vbm_send_mess("GET MODES"); -- get raid modes
		vbm_send_mess("GET SYNC");
	end
	
	if(GetNumGroupMembers()==0 and VBM_IN_RAID == true) then
		VBM_IN_RAID = false;
		vbm_verbosec("Not in a raid group anymore");
		--turn on autogreed if set to on
		if(VBM_GetS("LootSelectAutoGreed")) then
			if(VBMSettings['LootSelectOption'] ~= "Greed") then
				VBMSettings['LootSelectOption'] = "Greed";
				vbm_printc("Leaving Raid Group, Setting AutoLoot to |cFFFFFFFFGreed");
			end
		end
		if(VBM_GetS("LootSelectAutoDiss")) then
			if(VBMSettings['LootSelectOption'] ~= "Diss") then
				VBMSettings['LootSelectOption'] = "Diss";
				vbm_printc("Leaving Raid Group, Setting AutoLoot to |cFFFFFFFFDiss");
			end
		end
	end
	
	if(GetNumGroupMembers()>20 and VBM_GetS("LootSelectAutoPass")) then
		if(VBMSettings['LootSelectOption'] ~= "Pass") then
			VBMSettings['LootSelectOption'] = "Pass";
			vbm_printc("Your raid group now has more then 20 members, Setting AutoLoot to |cFFFFFFFFPass");
		end
	end
end

function VBM_RequestUpdate()
		--reset all boss help functions
		VBM_BossHelp_ResetAll();
		-- ask for new versions
		VBM_VERSION_LIST = {};
		vbm_send_mess("GET VERSION");
		-- ask for new raid modes
		VBM_RM_ClearAll();
		vbm_send_mess("GET MODES");
		--request new sync
		VBM_MSG_SYNC = 0;
		vbm_send_mess("GET SYNC");
		--reset bossloading vars
		VBM_BOSS = false;
		VBM_BOSSSTART = {};
		vbm_send_mess("GETBOSS");
		--print msg
		vbm_print("|cFF8888CC<VisionBossMod> Manual update/reset complete.");
end

function vbm_send_mess(msg)
	SendAddonMessage("VBM",msg,"RAID");
	vbm_debug("|cFFFF9922<VisionBossMod> Sent Message: |cFFFFFFFF"..msg);
end

function vbm_recive_mess(msg,from)
	vbm_debug("|cFF999922<VisionBossMod> Recived Message: |cFFFFFFFF"..msg.." |cFF999922from: |cFFFFFFFF"..from);
	
	local found,p1,p2,p3;
	
	-- someone has requsted your version
	if(msg == "GET VERSION") then
		vbm_send_mess("MY VERSION "..VBM_VERSION);
		return;
	end
	
	-- ppl are sendding there versions check if someone got a newer
	found,_,p1 = string.find(msg,"MY VERSION (.+)");
	if(found) then
		local v = tonumber(p1);
		--update version list
		VBM_VERSION_LIST[from] = v;
		--check for new version
		if(v > VBM_VERSION and VBM_NEW_VERSION_OUT == false) then
			VBM_NEW_VERSION_OUT = true;
			vbm_print("|cFF8888CC<VisionBossMod> New Version out!!! |cFFFFFFFF"..p1.." |cFF8888CCYour Version is: |cFFFFFFFF"..VBM_VERSION);
			vbm_infowarn("New Version out of VBM!",10);
		end
		--update the newestversion setting
		if(v > VBMSettings.newestversion) then
			VBMSettings.newestversion = v;
		end
		return;
	end
	
	if(msg == "GET MODES") then
		VBM_RaidModes_RequestSend();
		return;
	end
	
	if(msg == "GET SYNC") then
		vbm_send_synced("UPDATING");
		return;
	end
	
	-- Raid modes
	found,_,p1 = string.find(msg,"RAIDMODE (.+)");
	if(found) then
		VBM_RM_Commands(p1,VBM_YOU,false);
		return;
	end
	
	-- Remote logout
    found,_,p1 = string.find(msg,"RLOGOUT (.+)");
	if(found) then
		VisionBossMod_ReciveLogout(p1,from);
		return;
	end
	
	--GetBoss
	if(msg=="GETBOSS") then
		if(VBM_BOSS) then
			vbm_send_synced("BOSSSYNC "..VBM_BOSS);
		end
		return;
	end
	
	--Reqest Position Sync
	found,_,p1 = string.find(msg,"REQUESTPOS (.+)");
	if(found) then
		VBM_PositionSyncRequest_Recive(p1,from);
		return;
	end
	--Position Sync
	found,_,p1 = string.find(msg,"MYPOS (.+)");
	if(found) then
		VBM_PositionSync_Recive(p1,from);
		return;
	end
end

local VBM_MSG_SYNC = 0;
local VBM_SYNC_REPEAT_PROTECTION = {};

function vbm_send_synced(msg,raidsim)
	if(not VBM_IN_RAID and raidsim) then
		--simmulate raid
		vbm_debug("|cFFFF9922<VBM RaidSim "..(VBM_MSG_SYNC+1).."> Sent Message: |cFFFFFFFF"..msg);
		VBM_MSG_FROM = UnitName("player");
		vbm_recive_synced(VBM_MSG_SYNC+1,msg,VBM_MSG_FROM);
	else
		--we are in raid so we will get our own message
		vbm_debug("|cFFFF9922<VBM Sync "..(VBM_MSG_SYNC+1).."> Sent Message: |cFFFFFFFF"..msg);
		SendAddonMessage("VBMSYNC "..(VBM_MSG_SYNC+1),msg,"RAID");
		--speed upp reciveing of our own message
		VBM_MSG_FROM = UnitName("player");
		vbm_recive_synced(VBM_MSG_SYNC+1,msg,VBM_MSG_FROM);
	end
end

function vbm_sendsynced_repeatprot(msg)
	VBM_SYNC_REPEAT_PROTECTION[msg] = true;
	VBM_Delay(8,function() VBM_SYNC_REPEAT_PROTECTION[msg] = nil; end);
end

function vbm_recive_synced(sync,msg,from)
	if(sync <= VBM_MSG_SYNC) then
		vbm_debug("|cFFFF5555<VBM Sync "..sync.."> Declined (SYNC): |cFFFFFFFF"..msg.." |cFF999922from: |cFFFFFFFF"..from);
		return;
	end
	--set our current sync
	VBM_MSG_SYNC = sync;
	
	if(VBM_SYNC_REPEAT_PROTECTION[msg]) then
		vbm_debug("|cFFFF5555<VBM Sync "..sync.."> Declined (REPEATING): |cFFFFFFFF"..msg.." |cFF999922from: |cFFFFFFFF"..from);
		return;
	end
	--add repeat protection
	vbm_sendsynced_repeatprot(msg);
	
	--view debug info
	vbm_debug("|cFF999922<VBM Sync "..sync.."> Recived Message: |cFFFFFFFF"..msg.." |cFF999922from: |cFFFFFFFF"..from);
	
	local found,p1,p2,p3;
	
	--timers
	found,_,p1 = string.find(msg,"VBMTIMER (.+)");
	if(found) then
		VBM_Timers_Recive_Broadcast(p1);
		return;
	end
	
	-- vbmvote
	found,_,p1 = string.find(msg,"VOTESTART (.+)");
	if(found) then
		VBM_VoteRecive(p1,from);
		return;
	end
	found,_,p1 = string.find(msg,"VOTEANOMSTART (.+)");
	if(found) then
		VBM_VoteReciveAnonymous(p1,from);
		return;
	end
	
	--BOSSSYNC
	found,_,p1 = string.find(msg,"BOSSSYNC (.+)");
    if(found) then
		VBM_SetBoss(p1);
		return;
	end
	--BOSSDEAD
	found,_,p1 = string.find(msg,"BOSSDEAD (.+)");
    if(found) then
		VBM_BossDead(p1);
		return;
	end
	--BOSSSTART
	found,_,p1 = string.find(msg,"BOSSSTART (.+)");
    if(found) then
		VBM_BossStart(p1);
		return;
	end
	--BOSSRESET
	found,_,p1 = string.find(msg,"BOSSRESET (.+)");
    if(found) then
		VBM_BossReset(p1);
		return;
	end
	
	--BOSS event text synced
	found,_,p1 = string.find(msg,"BOSSEVENT (.+)");
    if(found) then
		VBM_BossRecive(p1);
		return;
	end

end

--[[
	********************************************************************
	********************************************************************
	Flash Frame
	********************************************************************
	********************************************************************
]]--

function VBM_FlashTest()
	local nr,time,a,r,g,b = random(2,4),random(1,2),random(1,3)/4,1,random(0,1),random(0,1);
	vbm_infowarn(vbm_c_w..nr..vbm_c_t.." flashes of "..vbm_c_r..r.." "..vbm_c_g..g.." "..vbm_c_b..b.." "..vbm_c_grey..a.." "..vbm_c_t.." over "..vbm_c_w..time..vbm_c_t.." sec");
	VBM_Flash(nr,time,a,r,g,b);
end

function VBM_FullScreenFlash(nr,time,a,r,g,b)
	local self = VBM_FullFlashFrame;
	self.numblink = nr;
	self.blinktime = time;
	self.blinkintensity = a;
	VBM_FullFlashFrameT:SetVertexColor(r,g,b,1);
	self:Show();
end

function VBM_EdgeFlash(nr,time,a)
	local self = VBM_EdgeFlashFrame;
	self.numblink = nr;
	self.blinktime = time;
	--if(a > 0.8) then a = 0.8; end
	self.blinkintensity = a;
	--VBM_EdgeFlashFrameT:SetVertexColor(r,g,b,1);
	self:Show();
end

function VBM_FlashFrame_OnUpdate(self,elapsed)
	self.elapsed = self.elapsed + elapsed;
	local bt = (self.blinktime/self.numblink);
	local c = (self.elapsed % bt)/bt;
	if(c < 0.5) then
		self:SetAlpha( ((c)/0.5) * self.blinkintensity );
	else
		self:SetAlpha( (1-((c-0.5)/0.5)) * self.blinkintensity);
	end
	if(self.elapsed > self.blinktime) then
		self:Hide();
	end
end

--[[
	********************************************************************
	********************************************************************
	Warning functions
	********************************************************************
	********************************************************************
]]--

function vbm_clearbigwarn()
	VBM_WarningFrame:Clear();
end

function vbm_bigwarn(msg, ...)
	local arg = {...};
	local ttl,r,g,b,a = 5,1,0,0,1;
	if(arg[1]) then ttl = arg[1]; end
	if(arg[2]) then r = arg[2]; end
	if(arg[3]) then g = arg[3]; end
	if(arg[4]) then b = arg[4]; end
	if(arg[5]) then a = arg[5]; end
	VBM_WarningFrame:SetTimeVisible(ttl);
	VBM_WarningFrame:AddMessage(msg, r, g, b, a, ttl);
end

function vbm_cleardebuffwarn()
	VBM_DebuffWarningFrame:Clear();
end

function vbm_debuffwarn(msg, ...)
	local arg = {...};
	local ttl,r,g,b,a = 5,1,0,0,1;
	if(arg[1]) then ttl = arg[1]; end
	if(arg[2]) then r = arg[2]; end
	if(arg[3]) then g = arg[3]; end
	if(arg[4]) then b = arg[4]; end
	if(arg[5]) then a = arg[5]; end
	VBM_DebuffWarningFrame:SetTimeVisible(ttl);
	VBM_DebuffWarningFrame:AddMessage(msg, r, g, b, a, ttl);
end

function vbm_clearinfowarn()
	VBM_InfoWarningFrame:Clear();
end

function vbm_infowarn(msg, ...)
	local arg = {...};
	local ttl,r,g,b,a = 5,0,1,1,1;
	if(arg[1]) then ttl = arg[1]; end
	if(arg[2]) then r = arg[2]; end
	if(arg[3]) then g = arg[3]; end
	if(arg[4]) then b = arg[4]; end
	if(arg[5]) then a = arg[5]; end
	VBM_InfoWarningFrame:SetTimeVisible(ttl);
	VBM_InfoWarningFrame:AddMessage(msg, r, g, b, a, ttl);
end

function vbm_smallwarn(msg, ...)
	local arg = {...};
	local ttl,r,g,b,a = 5,1,0,0,1;
	if(arg[1]) then ttl = arg[1]; end
	if(arg[2]) then r = arg[2]; end
	if(arg[3]) then g = arg[3]; end
	if(arg[4]) then b = arg[4]; end
	if(arg[5]) then a = arg[5]; end
	VBM_SmallWarningFrame:SetTimeVisible(ttl);
	VBM_SmallWarningFrame:AddMessage(string.upper(msg), r, g, b, a, ttl);
end

function VBM_WarningTest()
	vbm_bigwarn("[ - - - - - - - - - - - - Big Warning Text - - - - - - - - - - - - ]",15);
	vbm_infowarn("[ - - - - - - - - - - - - Info Warning Text - - - - - - - - - - - - ]",15);
	vbm_debuffwarn("[ - - - - - - - - - - - Debuff Warning Text - - - - - - - - - - - ]",15);
	vbm_smallwarn("[ - - - - - - - - - - - - Small Warning Text - - - - - - - - - - - - ]",15);
end

--[[
	********************************************************************
	********************************************************************
	Boss Loading Functions
	********************************************************************
	********************************************************************
]]--

function VBM_UpdateRaidSizeDifficulty()
	local _, _, difficulty, _, _, playerDifficulty, isDynamicInstance, _, instanceGroupSize = GetInstanceInfo();
	--set size
	if(difficulty==1 or difficulty==3) then
		VBM_DUNGEON_SIZE = 10;
	elseif(difficulty==2 or difficulty==4) then
		VBM_DUNGEON_SIZE = 25;
    else
        VBM_DUNGEON_SIZE = instanceGroupSize;
	end
	--set difficulty
	if(isDynamicInstance) then
		local selectedRaidDifficulty = difficulty;
		if ( playerDifficulty == 1 ) then
			if ( selectedRaidDifficulty <= 2 ) then
				selectedRaidDifficulty = selectedRaidDifficulty + 2;
			end
		end
		if(selectedRaidDifficulty==3 or selectedRaidDifficulty==4) then
			VBM_DUNGEON_DIFFICULTY = 2;
		else
			VBM_DUNGEON_DIFFICULTY = 1;
		end
	else
		if(difficulty==3 or difficulty==4 or difficulty==7 or difficulty==14) then
			VBM_DUNGEON_DIFFICULTY = 2;
		else
			VBM_DUNGEON_DIFFICULTY = 1;
		end
	end
end

function VBM_DoZoneDetect()
	local zone = GetRealZoneText();
	
	if(VBM_Instaces[zone]) then
		VBM_ZONE = zone;
		local extratext = "";
		if(GetRaidDifficultyID()==1 or GetRaidDifficultyID()==3) then
			extratext  = " (10)";
		elseif(GetRaidDifficultyID()==2 or GetRaidDifficultyID()==4) then
			extratext  = " (25)";
        else
            extratext  = " ("..instanceGroupSize..")";
		end
		
		vbm_printc("Now in a supported zone: |cFFFFFFFF"..VBM_ZONE..extratext.."|cFF8888CC VBM has been turned on");
		VBM_AutoZoneIn();
		--load boss data
		if(VBM_LoadInstance[VBM_ZONE]) then
			VBM_LoadInstance[VBM_ZONE]();
			vbm_verbosec("Found boss data for this zone");
		end
		--update size and difficulty
		--VBM_UpdateRaidSizeDifficulty(); handled by event instead
		--load in extramodules
		VBM_DebuffWarner_On();
		VBM_SpellWarner_On();
		VBM_EmoteWarner_On();
		VBM_LoadTrash();
		--Ask for current boss
		vbm_send_mess("GETBOSS");
	else
		if(VBM_ZONE) then
			vbm_printc("You are no longer in |cFFFFFFFF"..VBM_ZONE.."|cFF8888CC VBM is turning off");
			VBM_AutoZoneOut();
			VBM_ZONE = false;
			--VBM_DUNGEON_DIFFICULTY = nil; handled by event instead
			--VBM_DUNGEON_SIZE = nil; handled by event instead
			--reset bossloading vars
			VBM_BOSS = false;
			VBM_BOSSSTART = {};
			--Unload Extra Modules
			VBM_DebuffWarner_Off();
			VBM_SpellWarner_Off();
			VBM_EmoteWarner_Off();
			--RangeChecker
			VBM_RC_Auto_Hide();
			--Unload boss data
			VBM_BOSS_DATA = {};
			VBM_FRIENDLY_BOSSTAGGED = {};
			--
			VBM_BossHelp_ResetAll();
		end
	end
end

--for DEBUGING
function VBM_SimZone(zone)
	if(VBM_Instaces[zone]) then
		VBM_ZONE = zone;
		local extratext = "";
		local _, _, difficulty, _, _, playerDifficulty, isDynamicInstance, _, instanceGroupSize = GetInstanceInfo();
        if(GetRaidDifficultyID()==1 or GetRaidDifficultyID()==3) then
			extratext  = " (10)";
		elseif(GetRaidDifficultyID()==2 or GetRaidDifficultyID()==4) then
			extratext  = " (25)";
        else
            extratext  = " ("..instanceGroupSize..")";
		end
		
		vbm_printc("Now in a supported zone: |cFFFFFFFF"..VBM_ZONE..extratext.."|cFF8888CC VBM has been turned on");
		VBM_AutoZoneIn();
		--load boss data
		if(VBM_LoadInstance[VBM_ZONE]) then
			VBM_LoadInstance[VBM_ZONE]();
			vbm_verbosec("Found boss data for this zone");
		end
		--update size and difficulty
		--VBM_UpdateRaidSizeDifficulty(); handled by event instead
		--load in extramodules
		VBM_DebuffWarner_On();
		VBM_SpellWarner_On();
		VBM_EmoteWarner_On();
		VBM_LoadTrash();
		--Ask for current boss
		vbm_send_mess("GETBOSS");
	else
		if(VBM_ZONE) then
			vbm_printc("You are no longer in |cFFFFFFFF"..VBM_ZONE.."|cFF8888CC VBM is turning off");
			VBM_AutoZoneOut();
			VBM_ZONE = false;
			--VBM_DUNGEON_DIFFICULTY = nil; handled by event instead
			--VBM_DUNGEON_SIZE = nil; handled by event instead
			--reset bossloading vars
			VBM_BOSS = false;
			VBM_BOSSSTART = {};
			--Unload Extra Modules
			VBM_DebuffWarner_Off();
			VBM_SpellWarner_Off();
			VBM_EmoteWarner_Off();
			--RangeChecker
			VBM_RC_Auto_Hide();
			--Unload boss data
			VBM_BOSS_DATA = {};
			VBM_FRIENDLY_BOSSTAGGED = {};
			--
			VBM_BossHelp_ResetAll();
		end
	end
end
--end for DEBUGING

function VBM_LoadTrash()
	if(not VBM_BOSS_DATA["Trash"]) then return; end
	
	vbm_verbosec("Loading Trash data.");
	
	if(VBM_BOSS_DATA["Trash"].debuffs) then
		VBM_DebuffWarner_LoadSet(VBM_BOSS_DATA["Trash"].debuffs);
	end
	if(VBM_BOSS_DATA["Trash"].spells) then
		VBM_SpellWarner_LoadSet(VBM_BOSS_DATA["Trash"].spells);
	end
	if(VBM_BOSS_DATA["Trash"].emotes) then
		VBM_EmoteWarner_LoadSet(VBM_BOSS_DATA["Trash"].emotes);
	end
end

--[[
	***************
	Boss handling
	***************
]]--
local VBM_Boss_update_time = 0;
function VBM_Boss_OnUpdate()
	--dont update to fast
	if(VBM_Boss_update_time + 0.3 > GetTime()) then
		return;
	end
	VBM_Boss_update_time = GetTime();
	--only go if a boss is set
	if(VBM_BOSS) then
		if(VBM_BOSS_DATA[VBM_BOSS].during) then
			if(VBM_IsCurrentBossActive()) then
				--call during function if boss start is set
				VBM_BOSS_DATA[VBM_BOSS].during();
			end
		end
	end
end

function VBM_SetBoss(boss)
	--if outside VBM_ZONE then we dont have any modules or boss data loaded
	if(not VBM_ZONE) then return; end
	
	--check if there are an active boss, then do not allow setting a new
	if(VBM_IsCurrentBossActive()) then
		return;
	end
	
	if(VBM_BOSS ~= boss) then
		if(VBM_BOSS_DATA[boss]) then
			VBM_BOSS = boss;
			vbm_printc("Setting current boss to: |cFFFFFFFF"..VBM_GetRealBossName(VBM_BOSS));
			vbm_send_synced("BOSSSYNC "..boss);
			--Load Extra Modules
			if(VBM_BOSS_DATA[boss].debuffs) then
				VBM_DebuffWarner_LoadSet(VBM_BOSS_DATA[boss].debuffs);
			end
			if(VBM_BOSS_DATA[boss].spells) then
				VBM_SpellWarner_LoadSet(VBM_BOSS_DATA[boss].spells);
			end
			if(VBM_BOSS_DATA[boss].emotes) then
				VBM_EmoteWarner_LoadSet(VBM_BOSS_DATA[boss].emotes);
			end
			--Run LoadAndReset
			if(VBM_BOSS_DATA[boss].loadandreset) then
				VBM_BOSS_DATA[boss].loadandreset()
			end
		end
	end
end

function VBM_BossDead(boss)
	--Remport to the VBM_BOSSSTART[boss] table
	if(VBM_BOSSSTART[boss]) then
		VBM_BOSSSTART[boss] = nil;
		vbm_verbosec("BossDead Detected: |cFFFFFFFF"..boss);
		vbm_send_synced("BOSSDEAD "..boss);
		VBM_DelayByName("MasterLootReminder",10,VBM_MasterLootReminder,"dead");
		--[[Run LoadAndReset
		i see no reason to run load and reset here hmm maybe i forgot something
		
		if(VBM_BOSS and VBM_BOSS == boss) then
			if(VBM_BOSS_DATA[boss].loadandreset) then
				VBM_BOSS_DATA[boss].loadandreset()
			end
		end]]--
		
		--a boss has died its verified, now check if current vbm boss is not active, if its not then assume he just died
		if(VBM_BOSS) then
			if(not VBM_IsCurrentBossActive()) then
				vbm_printc("You have defeated: |cFFFFFFFF"..VBM_GetRealBossName(VBM_BOSS));
				VBM_BOSS = false;
				--Unload Extra Modules
				VBM_ResetDebuffs();
				VBM_ResetSpells();
				VBM_ResetEmotes();
				--RangeChecker
				VBM_RC_Auto_Hide();
				--reload trash
				VBM_LoadTrash();
			end
		end
	end
end

function VBM_BossStart(boss)
	if(not VBM_FRIENDLY_BOSSTAGGED[boss]) then
		if(not VBM_BOSSSTART[boss]) then
			--first check if its a boss we can set
			VBM_SetBoss(boss);
			--now add to bosstart
			VBM_BOSSSTART[boss] = true;
			vbm_verbosec("BossStart Detected: |cFFFFFFFF"..boss);
			vbm_send_synced("BOSSSTART "..boss);
			VBM_GroupLootWarn(); -- found in extrafeatures.lua
			VBM_DelayByName("MasterLootReminder",10,VBM_MasterLootReminder,"start"); --found in extrafeatures.lua
			if(VBM_BOSS and VBM_BOSS == boss) then
				--First check difficulty
				VBM_UpdateRaidSizeDifficulty();
				--Run start
				if(VBM_BOSS_DATA[boss].start) then
					VBM_BOSS_DATA[boss].start()
				end
				--RangeChecker
				if(VBM_BOSS_DATA[boss].rangecheck) then
					--if not rccount default to 1
					VBM_RC_Auto_Show(VBM_BOSS_DATA[boss].rangecheck, (VBM_BOSS_DATA[boss].rccount or 1));
				end
			end
		end
	end
end

function VBM_BossReset(boss)
	if(VBM_BOSSSTART[boss]) then
		VBM_BOSSSTART[boss] = nil;
		vbm_verbosec("BossReset Detected: |cFFFFFFFF"..boss);
		vbm_send_synced("BOSSRESET "..boss);
		--Run LoadAndReset
		if(VBM_BOSS and VBM_BOSS == boss) then
			if(VBM_BOSS_DATA[boss].loadandreset) then
				VBM_BOSS_DATA[boss].loadandreset()
			end
			--RangeChecker
			VBM_RC_Auto_Hide();
		end
	end
end

function VBM_IsCurrentBossActive()
	if(VBM_BOSS) then
		if(VBM_BOSS_DATA[VBM_BOSS].deadcheck) then
			local t = VBM_BOSS_DATA[VBM_BOSS].deadcheck;
			local i;
			for i=1,#t do
				if(VBM_BOSSSTART[t[i]]) then
					return true;
				end
			end
		else
			if(VBM_BOSSSTART[VBM_BOSS]) then
				return true;
			end
		end
	end
	return false;
end

--[[
	***************
	Detect boss events
	***************
]]--

function VBM_DetectBossDeath(arg7)
	--arg7 = destName
	if(arg7) then
		VBM_BossDead(arg7);
	end
end

function VBM_DetectBossStart(uid)
	if(UnitExists(uid) and VBM_UnitClassification(uid)=="worldboss") then
		if(UnitIsDeadOrGhost(uid)) then
			VBM_BossDead(UnitName(uid));
		else
			if(UnitReaction("player",uid) < 5) then
				--Only Set boss if its not friendly
				VBM_SetBoss(UnitName(uid));
			end
			
			if(UnitAffectingCombat(uid)) then
				if(UnitReaction("player",uid) < 5) then
					--Only call start if its not friendly
					VBM_BossStart(UnitName(uid));
				end
			else
				VBM_BossReset(UnitName(uid));
			end
		end
	end
end

--[[
	***************
	Synced boss events
	***************
]]--


function VBM_BossRecive(text)
	if(VBM_BOSS_DATA[VBM_BOSS] and VBM_BOSS_DATA[VBM_BOSS].bossevent) then
		VBM_BOSS_DATA[VBM_BOSS].bossevent(text);
	end
end

function VBM_BossSend(text)
	vbm_send_synced("BOSSEVENT "..text);
end

--[[
	********************************************************************
	********************************************************************
	Delay Exec Functions
	********************************************************************
	********************************************************************
]]--

local VBM_Delay_data = {};
local VBM_Delay_dataname = {};

function VBM_Delay(when, func, ...)
	if (not func) then
		return;
	end

	local data = {};
	data.time = when + GetTime();
	data.func = func;
	data.args = {...};

	-- task list is a heap, add new
	local i = #VBM_Delay_data+1
	while(i > 1) do
		if(data.time < VBM_Delay_data[i-1].time) then
			i = i - 1;
		else
			break
		end
	end
	tinsert(VBM_Delay_data, i, data)
end

function VBM_DelayRemove(name)
	if(name and VBM_Delay_dataname[name]) then
		VBM_Delay_dataname[name] = nil;
	end
end

function VBM_DelayByName(name, when, func, ...)
	if (not name) then 
		return;
	end
	if (not func) then
		return;
	end
	VBM_Delay_dataname[name] = {};
	VBM_Delay_dataname[name].time = when+GetTime();
	VBM_Delay_dataname[name].func = func;
	VBM_Delay_dataname[name].args = {...};
end

function VBM_Delay_run(func,args)
	if(func) then
		if(args) then
			func(unpack(args));
		else
			func();
		end
	end
end
-- /script VBM_DelayByName("test",20,function() vbm_print("hej"); end);
-- /script vbm_print_table(VBM_Delay_dataname)
function VBM_Delay_OnUpdate()
	-- Execute scheduled tasks that are ready, pulling them off the front of the list queue.
	local now = GetTime();
	local i;
	local task;
	while(#VBM_Delay_data > 0) do
		if (not VBM_Delay_data[1].time) then
			tremove(VBM_Delay_data, 1);
		elseif(VBM_Delay_data[1].time <= now) then
			task = tremove(VBM_Delay_data, 1);
			VBM_Delay_run(task.func, task.args);
		else
			break;
		end
	end
	-- Execute named scheduled tasks that are ready.
	local n,d;
	local exectable = {};
	for n,d in pairs(VBM_Delay_dataname) do
		if(not d.time) then
			VBM_Delay_dataname[n] = nil;
		elseif(d.time <= now) then
			exectable[#exectable+1] = {func = d.func,args = d.args};
			VBM_Delay_dataname[n] = nil;
		end
	end
	local i;
	for i=1,#exectable do
		VBM_Delay_run(exectable[i].func, exectable[i].args);
	end
end

--[[
*****************************
    DEBUG and TEXT OUTPUT
*****************************
]]--

function vbm_print(msg)
	DEFAULT_CHAT_FRAME:AddMessage(msg);
end

function vbm_prints(...)
	local arg = {...};
	local i;
	for i=1,#arg do
		DEFAULT_CHAT_FRAME:AddMessage(arg[i]);
	end
end

function vbm_print_table(d,l)
	if(not l) then
		l=1;
	end
		if(l>20) then
			vbm_print("l to big");
			return;
		end
	local a,b,i;
	local space = "";
	for i=1,l do
		space = space.."    ";
		if(i>20) then
			vbm_print("i to big");
			return;
		end
	end
	for a,b in pairs(d) do
		if(type(b)=="table") then
			vbm_print(space..a.." => ");
			vbm_print_table(b,l+1);
		else
			if(type(b)=="nil") then
				b = "nil";
			elseif(type(b)=="userdata") then
				b = "userdata";
			elseif(type(b)=="boolean") then
				if(b) then b = "true"; else b = "false"; end
			elseif(type(b)=="function") then
				b = "function()";
			end
			vbm_print(space..a.." => "..b);
		end
	end
end

function vbm_printc(msg)
	vbm_print("|cFF8888CC<VisionBossMod> "..msg);
end

function vbm_verbose(msg) -- vbm_verbose("|cFF4444CC<VisionBossMod> MSG");
	if(VBMSettings['Respons']=="Verbose" or VBMSettings['Respons']=="Debug") then
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end
end

function vbm_verbosec(msg)
	vbm_verbose("|cFF4444CC<VisionBossMod> "..msg);
end

function vbm_debug(msg)
	if(VBMSettings['Respons']=="Debug") then
		DEFAULT_CHAT_FRAME:AddMessage(msg);
	end
end

function vbm_sendchat(msg)
	if(GetNumGroupMembers()>0) then
		SendChatMessage("<VBM> "..msg,"RAID");
	elseif(GetNumPartyMembers()>0) then
		SendChatMessage("<VBM> "..msg,"PARTY");
	else
		vbm_printc(msg);
	end
end

function vbm_sendchatnovbm(msg)
	if(GetNumGroupMembers()>0) then
		SendChatMessage(""..msg,"RAID");
	elseif(GetNumPartyMembers()>0) then
		SendChatMessage(""..msg,"PARTY");
	else
		vbm_print(vbm_c_p..msg);
	end
end

function vbm_sendsilentwhisper(msg,to)
	local m = DEFAULT_CHAT_FRAME:IsEventRegistered("CHAT_MSG_WHISPER_INFORM");
	if(m) then DEFAULT_CHAT_FRAME:UnregisterEvent("CHAT_MSG_WHISPER_INFORM"); end
	SendChatMessage(msg,"WHISPER",nil,to);
	if(m) then VBM_Delay(1,function() DEFAULT_CHAT_FRAME:RegisterEvent("CHAT_MSG_WHISPER_INFORM"); end); end
end

function vbm_say(msg)
	SendChatMessage(msg,"SAY");
end

function vbm_yell(msg)
	SendChatMessage(msg,"YELL");
end

function vbm_whisper(msg,to)
	SendChatMessage(msg,"WHISPER",nil,to);
end

function vbm_raidwarn(msg)
	SendChatMessage(msg,"RAID_WARNING",nil);
end
