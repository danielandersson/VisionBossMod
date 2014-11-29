--[[
	********************************************************************
	********************************************************************
	And dev stuff
	
	Class Extra Features:
	
	Feign Death Resist Warning
	Feign Death Success Message
	TranqShot Report
	Aspect of the Viper Warning
	Warlock /hs to request trade then place hs
	Warlock Soulshard counter
	Taunt/Growl Fail Announce
	Soulshatter Resist
	Maelstrom Weapon Counter
	
	********************************************************************
	********************************************************************
]]--
--local setting func
local VBM_GetS = VBM_GetS;

VBM_TauntAnnounce_Spells = {
	["Taunt"] = 1,
	["Growl"] = 1,
	["Mocking Blow"] = 1,
	["Righteous Defense"] = 1,
	["Distracting Shot"] = 1,
	["Hand of Reckoning"] = 1,
	["Dark Command"] = 1,
	
};

local VBM_SOULSHARDBAGS = {
	["Small Soul Pouch"] = true,
	["Box of Souls"] = true,
	["Soul Pouch"] = true,
	["Felcloth Bag"] = true,
	["Core Felcloth Bag"] = true,
	["Ebon Shadowbag"] = true,
};

function VBM_ClassExtra_OnLoad(self)
	self:RegisterEvent("UI_ERROR_MESSAGE");
	self:RegisterEvent("UNIT_AURA");
	self:RegisterEvent("TRADE_SHOW");
	self:RegisterEvent("BAG_UPDATE");
	
	--combat log readings
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	--test spellcasting
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");
	
	--debugg
	--self:RegisterEvent("CHAT_MSG_SYSTEM");
	--self:RegisterEvent("CHAT_MSG_BN_WHISPER");
	--self:RegisterAllEvents();
end

function VBM_ClassExtra_Init()
	--init Maelstrom Weapon
	UIDropDownMenu_Initialize(VBM_ShamanMaelstromDropDownMenu, VBM_ShamanMaelstrom_DropDownMenuFunc, "MENU");
	VBM_ShamanMealstrom_SetScale();
end

function VBM_ClassExtra_OnEvent(self,event,...)
	if(event == "COMBAT_LOG_EVENT_UNFILTERED") then
		--vbm_test_combatlog(...);
		if(VBM_GetS("SoulshatterResist")) then
			VBM_SoulshatterResist(...);
		end
		if(VBM_GetS("TauntFail")) then
			VBM_TauntAnnounce(...);
		end
		if(VBM_GetS("TranqShotReport")) then
			VBM_TranqshotReport(...);
		end
		if(VBM_GetS("ViperActiveNotice")) then
			VBM_AspectViperNotice(...);
		end
		if(VBM_GetS("MaelstromWeaponTracker")) then
			VBM_MaelstromWeaponTracker(...);
		end
		return;
	end
	
	--debugg
	--if(vbm_test_all_events(event,...)) then return; end
	if(event == "UNIT_SPELLCAST_SUCCEEDED") then
		vbm_test_spell_casting(...);
	end
	
	if(event == "UI_ERROR_MESSAGE")then
		VBM_FeignDeathResistWarn(...);
	end
	
	if(event == "UNIT_AURA") then
		local arg1 = ...;
		if(arg1 and arg1=="player" and VBM_GetS("FeignDeathSuccess")) then
			VBM_FeignDeathSuccess();
		end
	end
	
	if(event == "TRADE_SHOW") then
		VBM_AutoHSPlaceTrade();
	end
	
	if(event == "BAG_UPDATE") then
		VBM_WarlockSoulShardUpdate(...);
	end
	
end

--[[
	********************************************************************
	Dev Stuff
	********************************************************************
]]--

function vbm_test_start() --this needs an update for hideCaster, and the new event functions
	local tid = GetTime();
	local i
	for i=1,100000 do
		event = "COMBAT_LOG_EVENT_UNFILTERED";
		arg4 = "Big Bad Boss";
		arg5 = 0;
		arg7 = "Trollrugge";
		arg8 = 0;
		arg10 = "Infest";
		arg12 = "DEBUFF";
		if(math.fmod(i,5)==0) then
			arg2 = "SWING_DAMAGE";
		elseif(math.fmod(i,5)==1) then
			arg2 = "SWING_DAMAGE";
		elseif(math.fmod(i,5)==2) then
			arg2 = "SWING_DAMAGE";
		elseif(math.fmod(i,5)==3) then
			arg2 = "SWING_DAMAGE";
		else
			arg2 = "SWING_DAMAGE";
		end
		VBM_SpellWarner_OnEvent(event);
		VBM_ExtraFeatures_OnEvent();
		VBM_ClassExtra_OnEvent();
		VBM_Debuff_OnEvent(event);
		VBM_InstanceSpecific_OnEvent();
		VBMTV_OnEvent(event);
		VisionBossMod_OnEvent(event);
	end	
	vbm_print("Klart: "..GetTime()-tid);
end

local VBM_TEST_ALL_SPELLCASTING = false;
local VBM_TEST_ENEMY_SPELLCASTING = false;
function VBM_ToggleShowSpellCast()
	if(not VBM_TEST_ENEMY_SPELLCASTING and not VBM_TEST_ALL_SPELLCASTING) then
		VBM_TEST_ENEMY_SPELLCASTING = true;
		vbm_print("Enemy Spellcasting enabled");
	elseif(VBM_TEST_ENEMY_SPELLCASTING) then
		VBM_TEST_ENEMY_SPELLCASTING = false;
		VBM_TEST_ALL_SPELLCASTING = true;
		vbm_print("All Spellcasting enabled");
	elseif(VBM_TEST_ALL_SPELLCASTING) then
		VBM_TEST_ENEMY_SPELLCASTING = false;
		VBM_TEST_ALL_SPELLCASTING = false;
		vbm_print("Spellcasting disabled");
	end
end
function vbm_test_spell_casting(arg1,arg2,arg3,arg4,arg5,arg6)
	if(VBM_TEST_ALL_SPELLCASTING) then
		if(not UnitInRaid(arg1) and not string.find(arg1,"pet",1,true)) then
			vbm_print("Spell casted: "..arg2.." ("..arg3..") by "..arg1);
		end
	end
	if(VBM_TEST_ENEMY_SPELLCASTING) then
		if(not UnitIsFriend("player",arg1)) then
			vbm_print("Spell casted: "..arg2.." ("..arg3..") by "..arg1);
		end
	end
end

function vbm_test_all_events(event,...)
	local arg = {...};
	local str = "event = \""..event.."\"";
	local i=1;
	local enter = "";
	for i=1,20 do
		if(type(arg[i])~="nil") then
			if(type(arg[i])=="boolean") then
				if(arg[i]) then enter = "true"; else enter = "false"; end
			else
				enter = arg[i];
			end
			str = str..", arg"..i.." = \""..enter.."\"";
		end
	end
	vbm_print(str);
	return 1;
end

function vbm_test_combatlog(...)
	local timestamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, destGUID, destName, destFlags, arg10,arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20,arg21  = ...;
	local str = "";
	--if(sourceName~="Omnì") then return end
	if(event) then str = str.." event="..event; end
	if(sourceGUID) then str = str.." sourceGUID="..sourceGUID; end
	if(sourceName) then str = str.." sourceName="..sourceName; end
	if(destGUID) then str = str.." destGUID="..destGUID; end
	if(destName) then str = str.." destName="..destName; end
	if(arg10) then str = str.." arg10="..arg10; end
	if(arg11) then str = str.." arg11="..arg11; end
	if(arg12) then str = str.." arg12="..arg12; end
	if(arg13) then str = str.." arg13="..arg13; end
	if(arg14) then str = str.." arg14="..arg14; end
	if(arg15) then str = str.." arg15="..arg15; end
	if(arg16) then str = str.." arg16="..arg16; end
	if(arg17) then str = str.." arg17="..arg17; end
	if(arg18) then str = str.." arg18="..arg18; end
	if(arg19) then str = str.." arg19="..arg19; end
	if(arg20) then str = str.." arg20="..arg20; end
	if(arg21) then str = str.." arg21="..arg21; end
	
	vbm_print(str);
	
	if(VBM_band(destFlags,COMBATLOG_OBJECT_TYPE_NPC,VBM_bor(COMBATLOG_OBJECT_REACTION_HOSTILE,COMBATLOG_OBJECT_REACTION_NEUTRAL))) then
		--vbm_print("ON NPC");
	end
end

--[[
	********************************************************************
	Class Stuff
	********************************************************************
]]--
local VBM_FD_STATUS = 0;
function VBM_FeignDeathResistWarn(arg1)
	if(arg1 == ERR_FEIGN_DEATH_RESISTED) then
		if(VBM_GetS("FeignDeathResist")) then
			vbm_infowarn("Feign Death Resisted",5,1,0,0);
			vbm_printc("|cFFFFFFFFFeign Death |cFF8888CCResisted",5,1,0,0);
		end
		VBM_FD_STATUS = 2;
	end
end
function VBM_FeignDeathSuccess()
	if(VBM_CheckForBuff("Feign Death")) then
		if(VBM_FD_STATUS == 0) then
			VBM_FD_STATUS = 1;
			VBM_Delay(0.8,VBM_FeignDeathSuccessMsg);
		end
	else
		VBM_FD_STATUS = 0;
	end
end
function VBM_FeignDeathSuccessMsg()
	if(VBM_CheckForBuff("Feign Death") and VBM_FD_STATUS == 1) then
		VBM_FD_STATUS = 2;
		vbm_infowarn("Feign Death Success",1,0,1,0);
	end
end

local VBM_AUTOHS_STATUS = 0;
function VBM_AutoHSOpenTrade()
	if(VBM_GetS("AutoTradeHS")) then
		VBM_AutoAcceptTradeConfirm();
		if(TradeFrame:IsVisible()) then --run place function
			VBM_DelayByName("AutoHS",8,function() VBM_AUTOHS_STATUS = 0; end);
			VBM_AUTOHS_STATUS = 1;
			VBM_AutoHSPlaceTrade();
		elseif(VBM_SearchBags("Healthstone") and not CursorHasItem() and UnitExists("target") and CheckInteractDistance("target", 2) and UnitIsFriend("player", "target") and UnitIsPlayer("target") ) then
			VBM_DelayByName("AutoHS",8,function() VBM_AUTOHS_STATUS = 0; end);
			VBM_AUTOHS_STATUS = 1;
			InitiateTrade("target");
		end
	end
end

function VBM_AutoHSPlaceTrade()
	if(VBM_GetS("AutoTradeHS") and VBM_AUTOHS_STATUS == 1) then
		if(not CursorHasItem() and VBM_SearchBags("Healthstone")) then
			local i;
			for i = 1, 6, 1 do
				if ( not GetTradePlayerItemLink(i)) then
					PickupContainerItem(VBM_SearchBags("Healthstone"));
					ClickTradeButton(i);
					return;
				end
			end
		end
	end
end

function VBM_AutoAcceptTradeConfirm()
		if(GetPlayerTradeMoney() ~= 0) then 
			vbm_printc("Money found in trade window");
			return;
		end
		local i;
		for i=1,7 do
			if(GetTradePlayerItemLink(i)) then
				if(not string.find(GetTradePlayerItemInfo(i),"Healthstone") ) then
					vbm_printc("None Healthstone item found: "..GetTradePlayerItemInfo(i));
					return;
				end
			end 
		end
		-- all set accept trade
		AcceptTrade();
end

local VBM_NUMSHARDS = 0;
local VBM_SOULBAG = 0;

function VBM_WarlockSoulShardUpdate(bag)
	if(not VBM_GetS("SoulShardCounter")) then return; end
	local i;
	--quick scan bags
	for i=1,4 do
		if(VBM_SOULSHARDBAGS[GetBagName(i)]) then
			if(VBM_SOULBAG~=i) then
				vbm_printc("Found Soul Shard Bag: |cFFFFFFFF"..GetBagName(i).."|cFF8888CC at slot: |cFFFFFFFF"..i);
				VBM_SOULBAG = i;
				VBM_NUMSHARDS = 0;
			end
			break;
		end
	end
	
	--only count if soul shard bag updates
	if(bag==VBM_SOULBAG) then
		--first check to see if its still a soul bag
		if(VBM_SOULSHARDBAGS[GetBagName(bag)]) then
			local slot;
			local shards = 0;
			local maxshards = GetContainerNumSlots(bag);
			--count shards
			for slot=1,maxshards do
				if(GetContainerItemLink(bag,slot)) then
					shards = shards + 1;
				end
			end
			--if its a new number display
			if(shards ~= VBM_NUMSHARDS) then
				VBM_NUMSHARDS = shards;
				if(shards==maxshards) then
					vbm_infowarn("Soul Shard Bag Full",1,0,1,0);
				else
					local r,g,b = VBM_GetSmoothColor(shards/maxshards);
					vbm_infowarn(shards.."/"..maxshards.." Soul Shards",1,r,g,b);
				end
			end
		end
	end
end

function VBM_TauntAnnounce(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	--if your spell has missed
	if(combatEvent == "SPELL_MISSED" and sourceName and sourceName==VBM_YOU) then
		local missType = arg12;
		--check if it was one of these spells
		if(VBM_TauntAnnounce_Spells[spellName]) then
			vbm_sendchat("*** "..destName.." "..missType.." "..spellName.." ***");
		end
	end
end


function VBM_SoulshatterResist(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	--if your spell has missed
	if(combatEvent == "SPELL_MISSED" and sourceName and sourceName==VBM_YOU) then
		local missType = arg12;
		--and spell is soulshatter and it was a resist
		if(spellName=="Soulshatter" and missType=="RESIST") then
			vbm_infowarn("Soulshatter resisted by "..destName,5,1,0,0);
			vbm_printc("|cFFFFFFFFSoulshatter |cFF8888CCwas resisted by |cFFFFFFFF"..destName);
		end
	end
end

function VBM_TranqshotReport(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	if(combatEvent == "SPELL_MISSED" and sourceName and destName) then
		local spellName, missType = arg10,arg12;
		if(spellName=="Tranquilizing Shot") then
			vbm_printc(vbm_c_w.."- - - "..vbm_c_p..sourceName.."'s Tranquilizing Shot "..vbm_c_w..missType.." "..vbm_c_p..destName);
		end
	elseif(combatEvent == "SPELL_DISPEL_FAILED" and sourceName and destName) then
		local spellName, extraSpellName = arg10,arg13;
		if(spellName=="Tranquilizing Shot") then
			vbm_printc(vbm_c_w.."- - - "..vbm_c_p..sourceName.."'s Tranquilizing Shot "..vbm_c_w.."FAILED "..vbm_c_p.."to dispel "..destName.."'s "..extraSpellName);
		end
	elseif(combatEvent == "SPELL_AURA_DISPELLED" and sourceName and destName) then
		local spellName, extraSpellName, auraType = arg10,arg13,arg15;
		if(spellName=="Tranquilizing Shot") then
			vbm_printc(vbm_c_w.."+ + + "..vbm_c_p..sourceName.."'s Tranquilizing Shot dispelled "..destName.."'s "..vbm_c_w..extraSpellName);
		end
	end
end

function VBM_AspectViperNotice(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	--SPELL_ENERGIZE is then you shot and get mana and SPELL_PERIODIC_ENERGIZE is then perodic regen with viper
	if(combatEvent == "SPELL_ENERGIZE" and sourceName and destName and sourceName==VBM_YOU and destName==VBM_YOU) then
		if(spellName == "Aspect of the Viper") then
			if(VBM_UnitPowerPercent("player")>=90) then
				vbm_infowarn("* * * Aspect of the Viper * * *",0.1,0,0.5,1)
			end
		end
	end	
end

--[[
	********************************************************************
	SHAMAN 
	********************************************************************
]]--

function VBM_MaelstromWeaponTracker(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	if(destName and destName==VBM_YOU and (combatEvent == "SPELL_AURA_APPLIED" or combatEvent == "SPELL_AURA_APPLIED_DOSE" or
					combatEvent == "SPELL_AURA_REMOVED" or combatEvent == "SPELL_AURA_REMOVED_DOSE")) then
		local amount = arg13;
		if(spellName == "Maelstrom Weapon") then
			if(amount) then
				VBM_ShamanMealstrom_Set(amount);
			elseif(combatEvent == "SPELL_AURA_APPLIED") then
				VBM_ShamanMealstrom_Set(1);
			else
				VBM_ShamanMealstrom_Set(0);
			end
		end
	end
end
function VBM_ShamanMealstrom_Set(nr)
	if(nr==0) then
		VBM_ShamanMaelstrom:Hide();
	else
		VBM_ShamanMaelstrom:Show();
		VBM_ShamanMaelstromText:SetText(nr);
		if(nr==5) then
			VBM_ShamanMaelstromText:SetVertexColor(0,1,0);
		elseif(nr<5 and nr >2) then
			VBM_ShamanMaelstromText:SetVertexColor(1,1,0);
		else
			VBM_ShamanMaelstromText:SetVertexColor(1,0,0);
		end
	end
end

function VBM_ShamanMealstrom_SetScale()
	VBM_ShamanMaelstrom:SetScale(VBM_CHAR_SAVE.shaman.maelstromframe.scale);
end

function VBM_ShamanMaelstrom_DropDownMenuFunc()
	local info = {};
	
	if(UIDROPDOWNMENU_MENU_LEVEL==1) then
		info = {};
		info.text = "Lock Dragging";
		info.checked = VBM_CHAR_SAVE.shaman.maelstromframe.locked;
		info.keepShownOnClick = 1;
		info.func = function() VBM_CHAR_SAVE.shaman.maelstromframe.locked = VBM_Toggle_Bool(VBM_CHAR_SAVE.shaman.maelstromframe.locked) end;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);

		info = {};
		info.text = "Scale";
		info.notCheckable = 1;
		info.hasArrow = 1;
		info.value = "ScaleMenu";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
	end
			if(UIDROPDOWNMENU_MENU_VALUE == "ScaleMenu") then
				info = {};
				info.text = "Scale";
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "0.5";
				info.checked = (VBM_CHAR_SAVE.shaman.maelstromframe.scale==0.5);
				info.func = function() VBM_CHAR_SAVE.shaman.maelstromframe.scale=0.5; VBM_ShamanMealstrom_SetScale(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.6";
				info.checked = (VBM_CHAR_SAVE.shaman.maelstromframe.scale==0.6);
				info.func = function() VBM_CHAR_SAVE.shaman.maelstromframe.scale=0.6; VBM_ShamanMealstrom_SetScale(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.7";
				info.checked = (VBM_CHAR_SAVE.shaman.maelstromframe.scale==0.7);
				info.func = function() VBM_CHAR_SAVE.shaman.maelstromframe.scale=0.7; VBM_ShamanMealstrom_SetScale(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.8";
				info.checked = (VBM_CHAR_SAVE.shaman.maelstromframe.scale==0.8);
				info.func = function() VBM_CHAR_SAVE.shaman.maelstromframe.scale=0.8; VBM_ShamanMealstrom_SetScale(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.9";
				info.checked = (VBM_CHAR_SAVE.shaman.maelstromframe.scale==0.9);
				info.func = function() VBM_CHAR_SAVE.shaman.maelstromframe.scale=0.9; VBM_ShamanMealstrom_SetScale(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.0";
				info.checked = (VBM_CHAR_SAVE.shaman.maelstromframe.scale==1.0);
				info.func = function() VBM_CHAR_SAVE.shaman.maelstromframe.scale=1.0; VBM_ShamanMealstrom_SetScale(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.1";
				info.checked = (VBM_CHAR_SAVE.shaman.maelstromframe.scale==1.1);
				info.func = function() VBM_CHAR_SAVE.shaman.maelstromframe.scale=1.1; VBM_ShamanMealstrom_SetScale(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.2";
				info.checked = (VBM_CHAR_SAVE.shaman.maelstromframe.scale==1.2);
				info.func = function() VBM_CHAR_SAVE.shaman.maelstromframe.scale=1.2; VBM_ShamanMealstrom_SetScale(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.4";
				info.checked = (VBM_CHAR_SAVE.shaman.maelstromframe.scale==1.4);
				info.func = function() VBM_CHAR_SAVE.shaman.maelstromframe.scale=1.4; VBM_ShamanMealstrom_SetScale(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.6";
				info.checked = (VBM_CHAR_SAVE.shaman.maelstromframe.scale==1.6);
				info.func = function() VBM_CHAR_SAVE.shaman.maelstromframe.scale=1.6; VBM_ShamanMealstrom_SetScale(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.8";
				info.checked = (VBM_CHAR_SAVE.shaman.maelstromframe.scale==1.8);
				info.func = function() VBM_CHAR_SAVE.shaman.maelstromframe.scale=1.8; VBM_ShamanMealstrom_SetScale(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "2.0";
				info.checked = (VBM_CHAR_SAVE.shaman.maelstromframe.scale==2.0);
				info.func = function() VBM_CHAR_SAVE.shaman.maelstromframe.scale=2.0; VBM_ShamanMealstrom_SetScale(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
end