--[[
	********************************************************************
	********************************************************************
	Handles Slash commands and settings menu	
	********************************************************************
	********************************************************************
]]--
local VBMSettings;
local VBM_CHAR_SAVE;
function VBM_Settings_SetDefaults()
	--use local vars to access settings
	if(not _G["VBMSettings"]) then _G["VBMSettings"] = {}; end
	VBMSettings = _G["VBMSettings"];
	if(not _G["VBM_CHAR_SAVE"]) then _G["VBM_CHAR_SAVE"] = {}; end
	VBM_CHAR_SAVE = _G["VBM_CHAR_SAVE"];
	-- VARS
	if(VBMSettings['PullCD'] == nil) then VBMSettings['PullCD'] = 10; end
	--update newest version
	if(not VBMSettings.newestversion or VBMSettings.newestversion < VBM_VERSION) then
		VBMSettings.newestversion = VBM_VERSION;
	end
	
	--In first menu
	if(VBMSettings['DebuffWarner'] == nil) then VBMSettings['DebuffWarner'] = 1; end
	if(VBMSettings['SpellcastWarner'] == nil) then VBMSettings['SpellcastWarner'] = 1; end
	if(VBMSettings['EmoteWarner'] == nil) then VBMSettings['EmoteWarner'] = 1; end
	if(VBMSettings['AutoRangeCheck'] == nil) then VBMSettings['AutoRangeCheck'] = 1; end
	if(VBMSettings['AcceptTimers'] == nil) then VBMSettings['AcceptTimers'] = 1; end
	if(VBMSettings['AcceptArrows'] == nil) then VBMSettings['AcceptArrows'] = 1; end
	--VBM SETTINGS
	if(VBMSettings['QuickAccess'] == nil) then VBMSettings['QuickAccess'] = 0; end
	if(VBMSettings['EchoSettingsChanged'] == nil) then VBMSettings['EchoSettingsChanged'] = 1; end
	if(VBMSettings['Sound'] == nil) then VBMSettings['Sound'] = 1; end
	if(VBMSettings['SoundMuteWow'] == nil) then VBMSettings['SoundMuteWow'] = 0; end
	if(VBMSettings['HighPingMode'] == nil) then VBMSettings['HighPingMode'] = 0; end
	if(VBMSettings['ShowGMOTD'] == nil) then VBMSettings['ShowGMOTD'] = 1; end
	if(VBMSettings['ScreenFlash'] == nil) then VBMSettings['ScreenFlash'] = 1; end
	if(VBMSettings['ScreenFlashFull'] == nil) then VBMSettings['ScreenFlashFull'] = 1; end
	if(VBMSettings['GroupLootWarn'] == nil) then VBMSettings['GroupLootWarn'] = 0; end
	if(VBMSettings['MasterLootReminder'] == nil) then VBMSettings['MasterLootReminder'] = 0; end
	if(VBMSettings['Respons'] == nil) then VBMSettings['Respons'] = "Normal"; end
	if(VBMSettings['WarningTextScale'] == nil) then VBMSettings['WarningTextScale'] = 1; end
	if(VBMSettings['WarningTextFont'] == nil) then VBMSettings['WarningTextFont'] = "Fonts\\FRIZQT__.TTF"; end
	if(VBMSettings['WarningTextExtraSpace'] == nil) then VBMSettings['WarningTextExtraSpace'] = 0; end
	if(VBMSettings['WarningTextAnchor'] == nil) then VBMSettings['WarningTextAnchor'] = 0; end
	--StatusFrame Settings
	if(VBMSettings['SFLocked'] == nil) then VBMSettings['SFLocked'] = 0; end
	if(VBMSettings['SFHideBorder'] == nil) then VBMSettings['SFHideBorder'] = 0; end
	if(VBMSettings['DisplayTimeElapsed'] == nil) then VBMSettings['DisplayTimeElapsed'] = 0; end
	if(VBMSettings['AutoShowSF'] == nil) then VBMSettings['AutoShowSF'] = 0; end
	--Blizzard UI enhancements
	if(VBMSettings['AltInvite'] == nil) then VBMSettings['AltInvite'] = 0; end
	if(VBMSettings['BackgroundWorldState'] == nil) then VBMSettings['BackgroundWorldState'] = 0; end
	if(VBMSettings['RemoveDeclineRess'] == nil) then VBMSettings['RemoveDeclineRess'] = 0; end
	if(VBMSettings['AutoSetCameraDistance'] == nil) then VBMSettings['AutoSetCameraDistance'] = 0; end
	if(VBMSettings['DisableBlizzardWarnText'] == nil) then VBMSettings['DisableBlizzardWarnText'] = 0; end
	if(VBMSettings['ErrorMessageDisabler'] == nil) then VBMSettings['ErrorMessageDisabler'] = 0; end
		--Error Message Disabler
		if(VBMSettings['ErrorMessAbilityNotReady'] == nil) then VBMSettings['ErrorMessAbilityNotReady'] = 0; end 
		if(VBMSettings['ErrorMessAnotherAction'] == nil) then VBMSettings['ErrorMessAnotherAction'] = 0; end
		if(VBMSettings['ErrorMessItemNotReady'] == nil) then VBMSettings['ErrorMessItemNotReady'] = 0; end
		if(VBMSettings['ErrorMessNotEnergy'] == nil) then VBMSettings['ErrorMessNotEnergy'] = 0; end
		if(VBMSettings['ErrorMessNotRage'] == nil) then VBMSettings['ErrorMessNotRage'] = 0; end
		if(VBMSettings['ErrorMessSpellNotReady'] == nil) then VBMSettings['ErrorMessSpellNotReady'] = 0; end
		--Minimap Button Hider
		if(VBMSettings['WorldMapButton'] == nil) then VBMSettings['WorldMapButton'] = 0; end
		if(VBMSettings['TrackingButton'] == nil) then VBMSettings['TrackingButton'] = 0; end
		if(VBMSettings['CalendarButton'] == nil) then VBMSettings['CalendarButton'] = 0; end
		if(VBMSettings['ZoomInButton'] == nil) then VBMSettings['ZoomInButton'] = 0; end
		if(VBMSettings['ZoomOutButton'] == nil) then VBMSettings['ZoomOutButton'] = 0; end
		if(VBMSettings['ClockButton'] == nil) then VBMSettings['ClockButton'] = 0; end
		if(VBMSettings['MinimapTopBorder'] == nil) then VBMSettings['MinimapTopBorder'] = 0; end
		if(VBMSettings['MinimapBorder'] == nil) then VBMSettings['MinimapBorder'] = 0; end
		if(VBMSettings['MinimapToggleButton'] == nil) then VBMSettings['MinimapToggleButton'] = 0; end
		if(VBMSettings['MinimapZoneText'] == nil) then VBMSettings['MinimapZoneText'] = 0; end
		if(VBMSettings['LFGButton'] == nil) then VBMSettings['LFGButton'] = 0; end
		if(VBMSettings['InstanceDiffButton'] == nil) then VBMSettings['InstanceDiffButton'] = 0; end
		if(VBMSettings['MailButton'] == nil) then VBMSettings['MailButton'] = 0; end
		if(VBMSettings['BattlefieldButton'] == nil) then VBMSettings['BattlefieldButton'] = 0; end
	--Combat log parsing
	if(VBMSettings['BuffAlerter'] == nil) then VBMSettings['BuffAlerter'] = 0; end
	if(VBMSettings['SSDIAlert'] == nil) then VBMSettings['SSDIAlert'] = 0; end
	if(VBMSettings['CCBigBrother'] == nil) then VBMSettings['CCBigBrother'] = 0; end
	if(VBMSettings['CCBigBrotherHS'] == nil) then VBMSettings['CCBigBrotherHS'] = 0; end
	if(VBMSettings['CCBigBrotherFT'] == nil) then VBMSettings['CCBigBrotherFT'] = 0; end
	if(VBMSettings['CCBigBrotherPT'] == nil) then VBMSettings['CCBigBrotherPT'] = 0; end
	if(VBMSettings['InterruptWatcher'] == nil) then VBMSettings['InterruptWatcher'] = 0; end
	if(VBMSettings['InterruptWatcherHS'] == nil) then VBMSettings['InterruptWatcherHS'] = 0; end
	if(VBMSettings['InterruptWatcherFT'] == nil) then VBMSettings['InterruptWatcherFT'] = 0; end
	if(VBMSettings['InterruptWatcherPT'] == nil) then VBMSettings['InterruptWatcherPT'] = 0; end
	if(VBMSettings['InterruptWatcherAnnounce'] == nil) then VBMSettings['InterruptWatcherAnnounce'] = 0; end
	if(VBMSettings['InterruptWatcherAnnounceOnlyRaid'] == nil) then VBMSettings['InterruptWatcherAnnounceOnlyRaid'] = 0; end
	if(VBMSettings['MisdirectionAlert'] == nil) then VBMSettings['MisdirectionAlert'] = 0; end
	if(VBMSettings['TricksoftheTradeAlert'] == nil) then VBMSettings['TricksoftheTradeAlert'] = 0; end
	if(VBMSettings['ToyTrainSet'] == nil) then VBMSettings['ToyTrainSet'] = 0; end
	--Auto Popups
	--Interface Addons
	if(VBMSettings['AutoRepair'] == nil) then VBMSettings['AutoRepair'] = 0; end
	if(VBMSettings['AutoRepairSave5g'] == nil) then VBMSettings['AutoRepairSave5g'] = 0; end
	if(VBMSettings['AutoRepairUseGBank'] == nil) then VBMSettings['AutoRepairUseGBank'] = 0; end
	if(VBMSettings['AutoSoloBoPLoot'] == nil) then VBMSettings['AutoSoloBoPLoot'] = 0; end
	if(VBMSettings['BGJoinReplacement'] == nil) then VBMSettings['BGJoinReplacement'] = 0; end
	if(VBMSettings['KillBlizzardJoinPopup'] == nil) then VBMSettings['KillBlizzardJoinPopup'] = 0; end
	if(VBMSettings['AutoLootSelect'] == nil) then VBMSettings['AutoLootSelect'] = 0; end
	if(VBMSettings['LootSelectOption'] == nil) then VBMSettings['LootSelectOption'] = "Pass"; end 
	if(VBMSettings['LootSelectNoEpic'] == nil) then VBMSettings['LootSelectNoEpic'] = 0; end
	if(VBMSettings['LootSelectAutoGreed'] == nil) then VBMSettings['LootSelectAutoGreed'] = 0; end
	if(VBMSettings['LootSelectAutoDiss'] == nil) then VBMSettings['LootSelectAutoDiss'] = 0; end
	if(VBMSettings['LootSelectAutoPass'] == nil) then VBMSettings['LootSelectAutoPass'] = 0; end 
	if(VBMSettings['BadgeReminder'] == nil) then VBMSettings['BadgeReminder'] = 0; end
	if(VBMSettings['LFGBGSoundHandling'] == nil) then VBMSettings['LFGBGSoundHandling'] = 0; end
	if(VBMSettings['BGHonorReport'] == nil) then VBMSettings['BGHonorReport'] = 0; end
	if(VBMSettings['InviteKeyword'] == nil) then VBMSettings['InviteKeyword'] = 0; end
		if(VBMSettings['ShortInviteKeyword'] == nil) then VBMSettings['ShortInviteKeyword'] = 0; end
		if(VBMSettings['NoWhisperInviteKeyword'] == nil) then VBMSettings['NoWhisperInviteKeyword'] = 0; end
	if(VBMSettings['ReagentBuyer'] == nil) then VBMSettings['ReagentBuyer'] = 0; end
		if(VBMSettings['ReagentBuyerAuto'] == nil) then VBMSettings['ReagentBuyerAuto'] = 0; end
		if(VBMSettings['AutoSellGreyItems'] == nil) then VBMSettings['AutoSellGreyItems'] = 0; end
	--Class Specific
	if(VBMSettings['TauntFail'] == nil) then VBMSettings['TauntFail'] = 0; end
		--Hunter
		if(VBMSettings['FeignDeathResist'] == nil) then VBMSettings['FeignDeathResist'] = 0; end
		if(VBMSettings['FeignDeathSuccess'] == nil) then VBMSettings['FeignDeathSuccess'] = 0; end
		if(VBMSettings['TranqShotReport'] == nil) then VBMSettings['TranqShotReport'] = 0; end
		if(VBMSettings['ViperActiveNotice'] == nil) then VBMSettings['ViperActiveNotice'] = 0; end
		--Warlock
		if(VBMSettings['AutoTradeHS'] == nil) then VBMSettings['AutoTradeHS'] = 0; end
		if(VBMSettings['SoulShardCounter'] == nil) then VBMSettings['SoulShardCounter'] = 0; end
		if(VBMSettings['SoulshatterResist'] == nil) then VBMSettings['SoulshatterResist'] = 0; end
		--Shaman
		
		if(VBMSettings['MaelstromWeaponTracker'] == nil) then VBMSettings['MaelstromWeaponTracker'] = 0; end
	--Instance Specific
	if(VBMSettings['AVAutoJoin'] == nil) then VBMSettings['AVAutoJoin'] = 0; end
	if(VBMSettings['AutoDetailedLoot'] == nil) then VBMSettings['AutoDetailedLoot'] = 0; end
	if(VBMSettings['AutoPlayerNames'] == nil) then VBMSettings['AutoPlayerNames'] = 0; end
	if(VBMSettings['AutoPlayerGuildNames'] == nil) then VBMSettings['AutoPlayerGuildNames'] = 0; end
	if(VBMSettings['AutoPlayerTitles'] == nil) then VBMSettings['AutoPlayerTitles'] = 0; end
	if(VBMSettings['EredarTwinsTankWarning'] == nil) then VBMSettings['EredarTwinsTankWarning'] = 0; end
	if(VBMSettings['AutoMalygosUI'] == nil) then VBMSettings['AutoMalygosUI'] = 0; end
	if(VBMSettings['DisableAnubAddsTimers'] == nil) then VBMSettings['DisableAnubAddsTimers'] = 0; end
		if(VBMSettings['DeathwhisperMC'] == nil) then VBMSettings['DeathwhisperMC'] = 0; end
		if(VBMSettings['LichKingSoulReaper'] == nil) then VBMSettings['LichKingSoulReaper'] = 0; end
		if(VBMSettings['LichKingSoulReaperTimer'] == nil) then VBMSettings['LichKingSoulReaperTimer'] = 0; end
	
	--CHARACTER SPECIFIC SAVE
	if(not VBM_CHAR_SAVE.shaman) then VBM_CHAR_SAVE.shaman = {}; end
	if(not VBM_CHAR_SAVE.shaman.maelstromframe) then
		VBM_CHAR_SAVE.shaman.maelstromframe = {
			['locked'] = false,
			['scale'] = 1,
		};
	end
	
	VBM_SETTINGS_LOADED = true;
end

function VBM_Toggle_Bool(var)
	if(var) then
		return false;
	else
		return true;
	end
end

function VBM_Toggle_Options(setting,...)
	local arg = {...};
	local num = #arg;
	local i;
	for i=1,num do
		if(VBMSettings[setting] == arg[i]) then
			if(i==num) then
				VBMSettings[setting] = arg[1];
				break;
			else
				VBMSettings[setting] = arg[i+1];
				break;
			end
		end
	end
	vbm_printc("Setting |cFFFFFFFF"..setting.."|cFF8888CC set to |cFFFFFFFF"..VBMSettings[setting]);
end

function VBM_Toggle_Setting(self,s)
	if(not s) then s = self.value end
	if(VBMSettings[s]==1) then
		VBMSettings[s] = 0;
		if(VBM_GetS("EchoSettingsChanged")) then
			vbm_printc("Setting |cFFFFFFFF"..s.."|cFF8888CC set to |cFFFFFFFFoff");
		end
	else
		VBMSettings[s] = 1;
		if(VBM_GetS("EchoSettingsChanged")) then
			vbm_printc("Setting |cFFFFFFFF"..s.."|cFF8888CC set to |cFFFFFFFFon");
		end
	end
end

function VBM_GetCVar(var,value)
	if(GetCVar(var)==value) then
		return true;
	else
		return false;
	end
end

function VBM_ToggleCVar(var)
	if(GetCVar(var)=="1") then
		SetCVar(var,"0");
	else
		SetCVar(var,"1");
	end
	vbm_printc("Setting WoWCVar |cFFFFFFFF"..var.."|cFF8888CC to |cFFFFFFFF"..GetCVar(var));
end

function VBM_SetCVar(var,value,quiet)
	SetCVar(var,value);
	if(not quiet) then
		vbm_printc("Setting WoWCVar |cFFFFFFFF"..var.."|cFF8888CC to |cFFFFFFFF"..value);
	end
end

function VBM_SetS(self,s,value)
	VBMSettings[s] = value;
	if(VBM_GetS("EchoSettingsChanged")) then
		vbm_printc("Setting |cFFFFFFFF"..s.."|cFF8888CC set to |cFFFFFFFF"..value);
	end
end

function VBM_GetS(s)
	if(VBMSettings[s] == 1) then
		return true;
	elseif(VBMSettings[s] == 0) then
		return false;
	else
		return VBMSettings[s];
	end
end

function VBM_PrintVaribelInfo()
	vbm_printc("InRaid Detected: "..vbm_c_w..((VBM_IN_RAID and "true") or "false"));
	vbm_printc("Zone Detected: "..vbm_c_w..((VBM_ZONE) or "false"));
	vbm_printc("RaidSize Detected: "..vbm_c_w..VBM_DUNGEON_SIZE);
	vbm_printc("RaidDifficulty Detected: "..vbm_c_w..VBM_DUNGEON_DIFFICULTY);
end
--[[
List of button attributes
======================================================
info.text = [STRING]  --  The text of the button
info.value = [ANYTHING]  --  The value that UIDROPDOWNMENU_MENU_VALUE is set to when the button is clicked
info.func = [function()]  --  The function that is called when you click the button
info.checked = [nil, true, function]  --  Check the button if true or function returns true
info.isNotRadial = [nil, true]  --  Check the button uses radial image if false check box image if true
info.isTitle = [nil, true]  --  If it's a title the button is disabled and the font color is set to yellow
info.disabled = [nil, true]  --  Disable the button and show an invisible button that still traps the mouseover event so menu doesn't time out
info.tooltipWhileDisabled = [nil, 1] -- Show the tooltip, even when the button is disabled.
info.hasArrow = [nil, true]  --  Show the expand arrow for multilevel menus
info.hasColorSwatch = [nil, true]  --  Show color swatch or not, for color selection
info.r = [1 - 255]  --  Red color value of the color swatch
info.g = [1 - 255]  --  Green color value of the color swatch
info.b = [1 - 255]  --  Blue color value of the color swatch
info.colorCode = [STRING] -- "|cAARRGGBB" embedded hex value of the button text color. Only used when button is enabled
info.swatchFunc = [function()]  --  Function called by the color picker on color change
info.hasOpacity = [nil, 1]  --  Show the opacity slider on the colorpicker frame
info.opacity = [0.0 - 1.0]  --  Percentatge of the opacity, 1.0 is fully shown, 0 is transparent
info.opacityFunc = [function()]  --  Function called by the opacity slider when you change its value
info.cancelFunc = [function(previousValues)] -- Function called by the colorpicker when you click the cancel button (it takes the previous values as its argument)
info.notClickable = [nil, 1]  --  Disable the button and color the font white
info.notCheckable = [nil, 1]  --  Shrink the size of the buttons and don't display a check box
info.owner = [Frame]  --  Dropdown frame that "owns" the current dropdownlist
info.keepShownOnClick = [nil, 1]  --  Don't hide the dropdownlist after a button is clicked
info.tooltipTitle = [nil, STRING] -- Title of the tooltip shown on mouseover
info.tooltipText = [nil, STRING] -- Text of the tooltip shown on mouseover
info.tooltipOnButton = [nil, 1] -- Show the tooltip attached to the button instead of as a Newbie tooltip.
info.justifyH = [nil, "CENTER"] -- Justify button text
info.arg1 = [ANYTHING] -- This is the first argument used by info.func
info.arg2 = [ANYTHING] -- This is the second argument used by info.func
info.fontObject = [FONT] -- font object replacement for Normal and Highlight
info.menuTable = [TABLE] -- This contains an array of info tables to be displayed as a child menu
info.noClickSound = [nil, 1]  --  Set to 1 to suppress the sound when clicking the button. The sound only plays if .func is set.
info.padding = [nil, NUMBER] -- Number of pixels to pad the text on the right side

func is called like func(self,arg1,arg2,checked);

CONSTANTS;
==========================================
UIDROPDOWNMENU_MENU_LEVEL
UIDROPDOWNMENU_MENU_VALUE
]]--

function VBM_Settings_Menuofdoom(self, level)
	local info = {};
	if(level==1) then
		--[[ ***************************************
		     /////// FIRST MENU \\\\\\\\
		     ***************************************]]--
		info.text = "SettingsMenuOfDoom";
		info.isTitle = 1;
		info.notCheckable = 1;
		UIDropDownMenu_AddButton(info,level);
		
		info = {};
		info.hasArrow = 1;
		info.notCheckable = 1;
		info.text = "VBM Settings";
		info.value = "VBMSettingsMenu";
		UIDropDownMenu_AddButton(info,level);
		info.text = "StatusFrame Settings";
		info.value = "StatusSettingsMenu";
		UIDropDownMenu_AddButton(info,level);
		info.text = "Blizzard UI enhancements";
		info.value = "BlizzardUIenhancements";
		UIDropDownMenu_AddButton(info,level);
		info.text = "Combat Log parsing";
		info.value = "CombatLogParsing";
		UIDropDownMenu_AddButton(info,level);
		info.text = "Interface Addons";
		info.value = "InterfaceAddons";
		UIDropDownMenu_AddButton(info,level);
		info.text = "Class Specific";
		info.value = "ClassSpecific";
		UIDropDownMenu_AddButton(info,level);
		info.text = "Instance Specific";
		info.value = "Instancespecific";
		UIDropDownMenu_AddButton(info,level);
		info.text = "Print info";
		info.value = "Printinfo";
		UIDropDownMenu_AddButton(info,level);
		info.text = "Extra Features";
		info.value = "ExtraFeatures";
		UIDropDownMenu_AddButton(info,level);
		
		info = {};
		info.text = "Warning Modules";
		info.notCheckable = 1;
		info.disabled = 1;
		UIDropDownMenu_AddButton(info,level);
		
		info = {};
		info.tooltipOnButton = 1;
		info.keepShownOnClick = 1;
		info.func = VBM_Toggle_Setting;
		info.text = "Spellcast Warner";
		info.tooltipTitle = info.text;
		info.tooltipText = "Main Boss Warning module, used to detect most spells to warn for.";
		info.checked = VBM_GetS("SpellcastWarner");
		info.arg1 = "SpellcastWarner";
		UIDropDownMenu_AddButton(info,level);
		info.text = "Debuff Warner";
		info.tooltipTitle = info.text;
		info.tooltipText = "Special DEBUFF warner, warn for some events triggered by SPELL_AURA_APPLIED.";
		info.checked = VBM_GetS("DebuffWarner");
		info.arg1 = "DebuffWarner";
		UIDropDownMenu_AddButton(info,level);
		info.text = "Emote Warner";
		info.tooltipTitle = info.text;
		info.tooltipText = "Special EMOTE warner, used to detect events that only have a boss emote or yell.";
		info.checked = VBM_GetS("EmoteWarner");
		info.arg1 = "EmoteWarner";
		UIDropDownMenu_AddButton(info,level);
		info.text = "Auto RangeChecker";
		info.tooltipTitle = info.text;
		info.tooltipText = "Auto show RangeChecker on bosses its used on, and auto hides it after.";
		info.checked = VBM_GetS("AutoRangeCheck");
		info.arg1 = "AutoRangeCheck";
		UIDropDownMenu_AddButton(info,level);
		info.text = "Display Timers";
		info.tooltipTitle = info.text;
		info.tooltipText = "Display timers during boss fights.";
		info.checked = VBM_GetS("AcceptTimers");
		info.arg1 = "AcceptTimers";
		UIDropDownMenu_AddButton(info,level);
		info.text = "Display Arrows";
		info.tooltipTitle = info.text;
		info.tooltipText = "Allow VBM to auto display the arrows on some fights.";
		info.checked = VBM_GetS("AcceptArrows");
		info.arg1 = "AcceptArrows";
		UIDropDownMenu_AddButton(info,level);
		
		if(VBM_GetS("QuickAccess")) then
				info = {};
				info.text = "Quick Access";
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,level);
				
				info = {};
				info.keepShownOnClick = 1;
				info.func = VBM_Toggle_Setting;
				info.text = "'Invite' Keyword";
				info.checked = VBM_GetS("InviteKeyword");
				info.arg1 = "InviteKeyword";
				UIDropDownMenu_AddButton(info,level);
				info.text = "Auto Roll Loot Select ("..VBM_GetS('LootSelectOption')..")";
				info.checked = VBM_GetS("AutoLootSelect");
				info.arg1 = "AutoLootSelect";
				UIDropDownMenu_AddButton(info,level);
				info.text = "Master Loot Reminder";
				info.checked = VBM_GetS("MasterLootReminder");
				info.arg1 = "MasterLootReminder";
				UIDropDownMenu_AddButton(info,level);
		end
	end
		--[[ ***************************************
		     /////// VBM SETTINGS MENU \\\\\\\\
		     ***************************************]]--
		if(UIDROPDOWNMENU_MENU_VALUE == "VBMSettingsMenu") then
			info.text = "VBM Settings";
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.tooltipOnButton = 1;
			info.keepShownOnClick = 1;
			info.func = VBM_Toggle_Setting;
			info.text = "Quick Access";
			info.tooltipTitle = info.text;
			info.tooltipText = "Enables quick access to some settings under the first menu.";
			info.checked = VBM_GetS("QuickAccess");
			info.arg1 = "QuickAccess";
			UIDropDownMenu_AddButton(info,level);
			
			info.text = "Echo Changes";
			info.tooltipTitle = info.text;
			info.tooltipText = "Confirm when you change a setting in the chatbox.";
			info.checked = VBM_GetS("EchoSettingsChanged");
			info.arg1 = "EchoSettingsChanged";
			UIDropDownMenu_AddButton(info,level);
			
			info.text = "Sound";
			info.tooltipTitle = info.text;
			info.tooltipText = "Allows VBM to play sound.";
			info.checked = VBM_GetS("Sound");
			info.arg1 = "Sound";
			UIDropDownMenu_AddButton(info,level);
			
			info.text = "Temp UnMute WoW Sound";
			info.tooltipTitle = info.text;
			info.tooltipText = "If you play Wow without sound use this option to\nenable it temporarly when VBM plays a sound.";
			info.checked = VBM_GetS("SoundMuteWow");
			info.arg1 = "SoundMuteWow";
			UIDropDownMenu_AddButton(info,level);
			
			info.text = "High Ping Mode";
			info.tooltipTitle = info.text;
			info.tooltipText = "This controls how fast vbm will do target checks.\nNowdays most players internet connections with ping fix (google it) "..
								"installed will give you under 100ms.\nVBMs orginal design before this option was added, was to assume 200ms.\n"..
								"But from now VBM will assume 100ms and this option can be used if anyone have trouble with\nVBM detecting "..
								"wrong targets for abilities casted by bosses.\n\nDefault off = Low ping mode, 100ms.\nOn = High ping mode, 200ms.";
			info.checked = VBM_GetS("HighPingMode");
			info.func = function(self,arg) VBM_Toggle_Setting(self,arg); VBM_SetPingLevel(); end;
			info.arg1 = "HighPingMode";
			UIDropDownMenu_AddButton(info,level);
			
			info.text = "Login GMOTD";
			info.tooltipTitle = info.text;
			info.tooltipText = "Show GMOTD in the middle of the screen upon login.";
			info.checked = VBM_GetS("ShowGMOTD");
			info.func = VBM_Toggle_Setting;
			info.arg1 = "ShowGMOTD";
			UIDropDownMenu_AddButton(info,level);
			
			info.text = "Group Loot Warning";
			info.tooltipTitle = info.text;
			info.tooltipText = "Warns if Loot Method is Group Loot when you engage a boss.";
			info.checked = VBM_GetS("GroupLootWarn");
			info.arg1 = "GroupLootWarn";
			UIDropDownMenu_AddButton(info,level);
			
			info.text = "Master Loot Reminder";
			info.tooltipTitle = info.text;
			info.tooltipText = "Make sure with an annoying warning that you turn on Master Loot when engaging a boss\nand reminds you a few times to turn it off again after the boss is defeated\n\nOnly active in 25 man raids";
			info.checked = VBM_GetS("MasterLootReminder");
			info.arg1 = "MasterLootReminder";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Flash Screen";
			info.tooltipTitle = info.text;
			info.tooltipOnButton = 1;
			info.tooltipText = "Allow VBM to flash the screen in some warnings.";
			info.keepShownOnClick = 1;
			info.hasArrow = 1;
			info.checked = VBM_GetS("ScreenFlash");
			info.func = VBM_Toggle_Setting;
			info.value = "ScreenFlash";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Warning Text Setup";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "WarningTextSetup";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.tooltipOnButton = 1;
			info.notCheckable = 1;
			info.keepShownOnClick = 1;
			info.text = "Text Respons ("..VBMSettings['Respons']..")";
			info.tooltipTitle = info.text;
			info.tooltipText = "Controls how many events vbm should report in chat:\nNormal: Only standard info\nVerbose: Gives some more info about certain events\nDebug: Also Displays debug output";
			info.func = function() VBM_Toggle_Options("Respons","Normal","Verbose","Debug"); end;
			UIDropDownMenu_AddButton(info,level);			
			info.text = "Manual Update/Reset";
			info.tooltipTitle = info.text;
			info.tooltipText = "Request/Resets: Version info, Raidmodes info, Sync info, Current Boss info.";
			info.keepShownOnClick = nil;
			info.func = VBM_RequestUpdate;
			UIDropDownMenu_AddButton(info,level);
		end
				if(UIDROPDOWNMENU_MENU_VALUE == "ScreenFlash") then
					info.func = VBM_SetS;
					info.arg1 = "ScreenFlashFull";
					info.tooltipOnButton = 1;
					info.text = "Only Edges";
					info.tooltipTitle = info.text;
					info.tooltipText = "Only supports red color and no custom alpha.";
					info.checked = (VBM_GetS("ScreenFlashFull")==false);
					info.arg2 = 0;
					UIDropDownMenu_AddButton(info,level);
					info.text = "Full Screen";
					info.tooltipTitle = info.text;
					info.tooltipText = "Supports all colors and alpha channel.";
					info.checked = (VBM_GetS("ScreenFlashFull")==true);
					info.arg2 = 1;
					UIDropDownMenu_AddButton(info,level);
					info.text = "Full Screen/Three Quarter Effect";
					info.tooltipTitle = info.text;
					info.tooltipText = "Uses the full screen flash but cuts its effect into 3/4.";
					info.checked = (VBM_GetS("ScreenFlashFull")==2);
					info.arg2 = 2;
					UIDropDownMenu_AddButton(info,level);
					info.text = "Full Screen/Half Effect";
					info.tooltipTitle = info.text;
					info.tooltipText = "Uses the full screen flash but cuts its effect into 1/2.";
					info.checked = (VBM_GetS("ScreenFlashFull")==3);
					info.arg2 = 3;
					UIDropDownMenu_AddButton(info,level);
					info.text = "Full Screen/One Quarter Effect";
					info.tooltipTitle = info.text;
					info.tooltipText = "Uses the full screen flash but cuts its effect into 1/4.";
					info.checked = (VBM_GetS("ScreenFlashFull")==4);
					info.arg2 = 4;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Flash Test";
					info.keepShownOnClick = 1;
					info.notCheckable = 1;
					info.func = VBM_FlashTest;
					UIDropDownMenu_AddButton(info,level);
				end
				if(UIDROPDOWNMENU_MENU_VALUE == "WarningTextSetup") then
					info.hasArrow = 1;
					info.notCheckable = 1;
					info.text = "Scale";
					info.value = "WarningTextScaleMenu";
					UIDropDownMenu_AddButton(info,level);
					info.text = "Font";
					info.value = "WarningTextFontMenu";
					UIDropDownMenu_AddButton(info,level);
					info.text = "Extra space between";
					info.value = "WarningTextExtraSpace";
					UIDropDownMenu_AddButton(info,level);
					info.text = "Adjust Anchor";
					info.value = "WarningTextAdjustanchor";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Warning Text Test";
					info.tooltipTitle = info.text;
					info.tooltipOnButton = 1;
					info.tooltipText = "Shows warning text for 15 sec.";
					info.keepShownOnClick = 1;
					info.notCheckable = 1;
					info.func = VBM_WarningTest;
					UIDropDownMenu_AddButton(info,level);
				end
						if(UIDROPDOWNMENU_MENU_VALUE == "WarningTextFontMenu") then
							info = {};
							info.text = "Font";
							info.notCheckable = 1;
							info.disabled = 1;
							UIDropDownMenu_AddButton(info,level);
							
							info = {};
							info.text = "Friz Quadrata TT";
							info.checked = (VBMSettings['WarningTextFont'] == "Fonts\\FRIZQT__.TTF");
							info.func = function() VBMSettings['WarningTextFont'] = "Fonts\\FRIZQT__.TTF"; VBM_Setup_Warning_Text(); end;
							UIDropDownMenu_AddButton(info,level);
							info.text = "Morpheus";
							info.checked = (VBMSettings['WarningTextFont'] == "Fonts\\MORPHEUS.TTF");
							info.func = function() VBMSettings['WarningTextFont'] = "Fonts\\MORPHEUS.TTF"; VBM_Setup_Warning_Text(); end;
							UIDropDownMenu_AddButton(info,level);
							info.text = "Arial Narrow";
							info.checked = (VBMSettings['WarningTextFont'] == "Fonts\\ARIALN.TTF");
							info.func = function() VBMSettings['WarningTextFont'] = "Fonts\\ARIALN.TTF"; VBM_Setup_Warning_Text(); end;
							UIDropDownMenu_AddButton(info,level);
							info.text = "Skurri";
							info.checked = (VBMSettings['WarningTextFont'] == "Fonts\\SKURRI.TTF");
							info.func = function() VBMSettings['WarningTextFont'] = "Fonts\\SKURRI.TTF"; VBM_Setup_Warning_Text(); end;
							UIDropDownMenu_AddButton(info,level);
							info.text = "Tw Cen MT Bold";
							info.checked = (VBMSettings['WarningTextFont'] == VBM_FONT_TVCENMT);
							info.func = function() VBMSettings['WarningTextFont'] = VBM_FONT_TVCENMT; VBM_Setup_Warning_Text(); end;
							UIDropDownMenu_AddButton(info,level);
							info.text = "Myriad Condensed Web (ABF)";
							info.checked = (VBMSettings['WarningTextFont'] == VBM_FONT_ABF);
							info.func = function() VBMSettings['WarningTextFont'] = VBM_FONT_ABF; VBM_Setup_Warning_Text(); end;
							UIDropDownMenu_AddButton(info,level);
							
						end
						
						if(UIDROPDOWNMENU_MENU_VALUE == "WarningTextScaleMenu") then
							info = {};
							info.text = "Scale";
							info.notCheckable = 1;
							info.disabled = 1;
							UIDropDownMenu_AddButton(info,level);
							
							info = {};
							info.func = function(self,s,v) VBM_SetS(self,s,v); VBM_Setup_Warning_Text(); end;
							info.arg1 = "WarningTextScale";
							for i=1,0.4,-0.1 do
								info.text = string.format("%.1f",i);
								info.checked = (VBMSettings['WarningTextScale'] == i);
								info.arg2 = i;
								UIDropDownMenu_AddButton(info,level);
							end
						end
						
						if(UIDROPDOWNMENU_MENU_VALUE == "WarningTextExtraSpace") then
							info = {};
							info.text = "Extra Space";
							info.notCheckable = 1;
							info.disabled = 1;
							UIDropDownMenu_AddButton(info,level);
							
							info = {};
							info.func = function(self,s,v) VBM_SetS(self,s,v); VBM_Setup_Warning_Text(); end;
							info.arg1 = "WarningTextExtraSpace";
							for i=-3,14,1 do
								info.text = i*10;
								info.checked = (VBMSettings['WarningTextExtraSpace'] == i);
								info.arg2 = i;
								UIDropDownMenu_AddButton(info,level);
							end
						end
						if(UIDROPDOWNMENU_MENU_VALUE == "WarningTextAdjustanchor") then
							info = {};
							info.text = "Adjust Anchor";
							info.notCheckable = 1;
							info.disabled = 1;
							UIDropDownMenu_AddButton(info,level);
							
							info = {};
							info.func = function(self,s,v) VBM_SetS(self,s,v); VBM_Setup_Warning_Text(); end;
							info.arg1 = "WarningTextAnchor";
							for i=-20,12,2 do
								info.text = i*10;
								info.checked = (VBMSettings['WarningTextAnchor'] == i);
								info.arg2 = i;
								UIDropDownMenu_AddButton(info,level);
							end
						end
				
		--[[ ***************************************
		     /////// STATUSFRAME SETTINGS MENU \\\\\\\\
		     ***************************************]]--
		if(UIDROPDOWNMENU_MENU_VALUE == "StatusSettingsMenu") then
			info = {};
			info.text = "StatusFrame Settings";
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Lock dragging";
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("SFLocked");
			info.func = VBM_Toggle_Setting;
			info.value = "SFLocked";
			UIDropDownMenu_AddButton(info,level);

			info = {};
			info.text = "Hide Border";
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("SFHideBorder");
			info.func = function(v) VBM_Toggle_Setting(v) VBM_SF_SetBorder() end;
			info.value = "SFHideBorder";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Auto Show";
			info.tooltipTitle = info.text;
			info.tooltipText = "Auto show statusframe when some content on it is changed (Time Elapsed, or BuffTracker)";
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("AutoShowSF");
			info.func = VBM_Toggle_Setting;
			info.value = "AutoShowSF";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Display Elapsed Time";
			info.tooltipTitle = info.text;
			info.tooltipText = "On boss encunters displays elapsed time instead of the vbm version text on statusframe title";
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("DisplayTimeElapsed");
			info.func = VBM_Toggle_Setting;
			info.value = "DisplayTimeElapsed";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Manual Reset Elapsed Time";
			info.tooltipTitle = info.text;
			info.tooltipText = "Click here on the bosses auto reset don't work on. Can only be used out of combat.";
			info.notCheckable = 1;
			info.func = function() if(not InCombatLockdown()) then VBM_BOSSSTART = {}; end end;
			UIDropDownMenu_AddButton(info,level);
		end
		--[[ ***************************************
		     /////// BLIZZARD UI ENHANCEMENTS \\\\\\\\
		     ***************************************]]--
		if(UIDROPDOWNMENU_MENU_VALUE == "BlizzardUIenhancements") then
			info = {};
			info.text = "Blizzard UI enhancements";
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,level);
		
			info = {};
			info.text = "AltInvite";
			info.tooltipTitle = info.text;
			info.tooltipText = "Alt+click a player link in chat to invite them to group\n\n(Requires reloadui to be disabled again)";
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("AltInvite");
			info.func = function(v) VBM_Toggle_Setting(v); VBM_HookAltInvite(); end;
			info.value = "AltInvite";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Background WorldState";
			info.tooltipTitle = info.text;
			info.tooltipText = "Sets the WorldStateFrame (frame that displays towers captured and stuff) to background strata instead of the default: medium.\n\n(Requires reloadui to be disabled again)";
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("BackgroundWorldState");
			info.func = function(v) VBM_Toggle_Setting(v); VBM_WorldStateFrameFix(); end;
			info.value = "BackgroundWorldState";
			UIDropDownMenu_AddButton(info,level);

			info = {};
			info.text = "Disable Blizzard Raid Warnings";
			info.tooltipTitle = info.text;
			info.tooltipText = "Disables the blizzard default raid warning text on the middle of the screen.\n\n(Requires reloadui to be disabled again)";
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("DisableBlizzardWarnText");
			info.func = function(v) VBM_Toggle_Setting(v); VBM_DisableBlizzardRaidWarnings(); end;
			info.value = "DisableBlizzardWarnText";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Remove Decline of Ress";
			info.tooltipTitle = info.text;
			info.tooltipText = "Blizzards UI Auto Declines ress then the ress window cant be opened, this may fix ress bugs use /ress if you dont get a ress window\n\n(Requires reloadui to be disabled again)";
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("RemoveDeclineRess");
			info.func = function(v) VBM_Toggle_Setting(v); VBM_RemoveAutoDeclineRess(); end;
			info.value = "RemoveDeclineRess";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Error Message Disabler";
			info.tooltipTitle = info.text;
			info.tooltipText = "Hooks the Error Frame to disable some error messages.\nTo disable hook uncheck this and reloadui.";
			info.keepShownOnClick = 1;
			info.hasArrow = 1;
			info.checked = VBM_GetS("ErrorMessageDisabler");
			info.func = function(v) VBM_Toggle_Setting(v); VBM_HookErrorMessageDisabler(); end;
			info.value = "ErrorMessageDisabler";
			UIDropDownMenu_AddButton(info,level);

			info = {};
			info.text = "Screenshot Settings";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "ScreenshotSettings";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Hidden interface settings";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "HiddenInterfaceSettings";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Minimap Button Hider";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "MinimapButtonHider";
			UIDropDownMenu_AddButton(info,level);
		end
				if(UIDROPDOWNMENU_MENU_VALUE == "ErrorMessageDisabler") then
					info = {};
					info.text = "Message";
					info.notCheckable = 1;
					info.disabled = 1;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Ability is not ready yet";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("ErrorMessAbilityNotReady");
					info.func = VBM_Toggle_Setting;
					info.value = "ErrorMessAbilityNotReady";
					UIDropDownMenu_AddButton(info,level);
					
					info.text = "Another action is in progress";
					info.checked = VBM_GetS("ErrorMessAnotherAction");
					info.value = "ErrorMessAnotherAction";
					UIDropDownMenu_AddButton(info,level);
					
					info.text = "Item is not ready yet";
					info.checked = VBM_GetS("ErrorMessItemNotReady");
					info.value = "ErrorMessItemNotReady";
					UIDropDownMenu_AddButton(info,level);
					
					info.text = "Not enough energy";
					info.checked = VBM_GetS("ErrorMessNotEnergy");
					info.value = "ErrorMessNotEnergy";
					UIDropDownMenu_AddButton(info,level);
					
					info.text = "Not enough rage";
					info.checked = VBM_GetS("ErrorMessNotRage");
					info.value = "ErrorMessNotRage";
					UIDropDownMenu_AddButton(info,level);
					
					info.text = "Spell is not ready yet";
					info.checked = VBM_GetS("ErrorMessSpellNotReady");
					info.value = "ErrorMessSpellNotReady";
					UIDropDownMenu_AddButton(info,level);
				end
				if(UIDROPDOWNMENU_MENU_VALUE == "ScreenshotSettings") then
					info = {};
					info.text = "Format";
					info.notCheckable = 1;
					info.disabled = 1;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "TGA (Best Quality)";
					info.checked = VBM_GetCVar("screenshotFormat","tga");
					info.func = function() VBM_SetCVar("screenshotFormat","tga") end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "PNG (Mac Client Only)";
					info.checked = VBM_GetCVar("screenshotFormat","png");
					info.func = function() VBM_SetCVar("screenshotFormat","png") end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "JPEG (Default)";
					info.checked = VBM_GetCVar("screenshotFormat","jpeg");
					info.func = function() VBM_SetCVar("screenshotFormat","jpeg") end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Quality";
					info.notCheckable = 1;
					info.disabled = 1;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "1 (Lowest Quality)";
					info.checked = VBM_GetCVar("screenshotQuality","1");
					info.func = function() VBM_SetCVar("screenshotQuality","1") end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "2";
					info.checked = VBM_GetCVar("screenshotQuality","2");
					info.func = function() VBM_SetCVar("screenshotQuality","2") end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "3 (Default)";
					info.checked = VBM_GetCVar("screenshotQuality","3");
					info.func = function() VBM_SetCVar("screenshotQuality","3") end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "4";
					info.checked = VBM_GetCVar("screenshotQuality","4");
					info.func = function() VBM_SetCVar("screenshotQuality","4") end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "5";
					info.checked = VBM_GetCVar("screenshotQuality","5");
					info.func = function() VBM_SetCVar("screenshotQuality","5") end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "6";
					info.checked = VBM_GetCVar("screenshotQuality","6");
					info.func = function() VBM_SetCVar("screenshotQuality","6") end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "7";
					info.checked = VBM_GetCVar("screenshotQuality","7");
					info.func = function() VBM_SetCVar("screenshotQuality","7") end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "8";
					info.checked = VBM_GetCVar("screenshotQuality","8");
					info.func = function() VBM_SetCVar("screenshotQuality","8") end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "9";
					info.checked = VBM_GetCVar("screenshotQuality","9");
					info.func = function() VBM_SetCVar("screenshotQuality","9") end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "10 (Best Quality)";
					info.checked = VBM_GetCVar("screenshotQuality","10");
					info.func = function() VBM_SetCVar("screenshotQuality","10") end;
					UIDropDownMenu_AddButton(info,level);
				end
				
				if(UIDROPDOWNMENU_MENU_VALUE == "HiddenInterfaceSettings") then
					info = {};
					info.text = "invertMouseYAxis";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetCVar("mouseInvertPitch","1");
					info.func = function() VBM_ToggleCVar("mouseInvertPitch"); end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "invertMouseXAxis";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetCVar("mouseInvertYaw","1");
					info.func = function() VBM_ToggleCVar("mouseInvertYaw"); end;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "autoDismount";
					info.tooltipTitle = info.text;
					info.tooltipText = "Auto Dismount Ground Mount when casting a spell.";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetCVar("autoDismount","1");
					info.func = function() VBM_ToggleCVar("autoDismount"); end;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "autoDismountFlying";
					info.tooltipTitle = info.text;
					info.tooltipText = "Auto Dismount Flying Mount when casting a spell.";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetCVar("autoDismountFlying","1");
					info.func = function() VBM_ToggleCVar("autoDismountFlying"); end;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "autoStand";
					info.tooltipTitle = info.text;
					info.tooltipText = "Auto Standup then casting a spell.";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetCVar("autoStand","1");
					info.func = function() VBM_ToggleCVar("autoStand"); end;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "autoUnshift";
					info.tooltipTitle = info.text;
					info.tooltipText = "Auto Shift out then casting a spell that can't be cast while shapeshifted. (This works for Druids Froms, Priests Shadowform, Rogues Stealth and maybe more)";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetCVar("autoUnshift","1");
					info.func = function() VBM_ToggleCVar("autoUnshift"); end;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "MaxCameraDistance ("..GetCVar("cameraDistanceMaxFactor")..")";
					info.tooltipTitle = info.text;
					info.tooltipText = "'/console cameraDistanceMaxFactor (0-5)'\nSets max camera distance.\n0 = FP only\n5 = Max\nDefault interface slider goes 1-2\nIf this is enabled VBM will auto set it to 5 each time the UI is loaded.";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("AutoSetCameraDistance");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_AutoSetCameraDistance(); end;
					info.value = "AutoSetCameraDistance";
					UIDropDownMenu_AddButton(info,level);
					--[[
					info = {};
					info.text = "MaxTabDistance ("..GetCVar("targetNearestDistance")..")";
					info.tooltipTitle = info.text;
					info.tooltipText = "'/console targetNearestDistance (1-50)'\nSets max tab distance.\nDefault: "..GetCVarDefault("targetNearestDistance").."\nClick to set to 50";
					info.keepShownOnClick = 1;
					info.notCheckable = 1;
					info.func = function() VBM_SetCVar("targetNearestDistance","50") end;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "TabSearchRadius ("..GetCVar("targetNearestDistanceRadius")..")";
					info.tooltipTitle = info.text;
					info.tooltipText = "'/console targetNearestDistanceRadius (1-50)'\nSets how wide tab serach distance should be.\n1 = Only a stripe in the middle of screen\n50 = You can tab target stuff behind you\nDefault: "..GetCVarDefault("targetNearestDistanceRadius").."\nClick to set to Default";
					info.keepShownOnClick = 1;
					info.notCheckable = 1;
					info.func = function() VBM_SetCVar("targetNearestDistanceRadius",GetCVarDefault("targetNearestDistanceRadius")) end;
					UIDropDownMenu_AddButton(info,level);]]--
					
					info = {};
					info.text = "pitchLimit info";
					info.tooltipTitle = info.text;
					info.tooltipText = "'/console pitchLimit (0-9999?)'\nControls how mush you can pitch with your mouse while flying.\n0 = Can't pitch at all\n360 = Can pitch 360 degrees\nDefault: 90\nClick to set to 360\nThis is not saved by wow";
					info.keepShownOnClick = 1;
					info.notCheckable = 1;
					info.func = function() ConsoleExec("pitchLimit 360"); vbm_printc("Running console command: |cFFFFFFFFpitchLimit 360"); end;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Show Currency Bag";
					info.tooltipTitle = info.text;
					info.tooltipText = "Shows the Currency Bag if you want to delete som emblems or something.";
					info.keepShownOnClick = 1;
					info.notCheckable = 1;
					info.func = function() ToggleBag(-4); end;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Show Secret Bag";
					info.tooltipTitle = info.text;
					info.tooltipText = "Currently unused by blizzard.";
					info.keepShownOnClick = 1;
					info.notCheckable = 1;
					info.func = function() ToggleBag(-1); end;
					UIDropDownMenu_AddButton(info,level);
				end
				if(UIDROPDOWNMENU_MENU_VALUE == "MinimapButtonHider") then
					info = {};
					info.text = "Main Buttons";
					info.notCheckable = 1;
					info.disabled = 1;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "World Map Button";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("WorldMapButton");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_HideMinimapButtons("set"); end;
					info.value = "WorldMapButton";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Tracking Button";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("TrackingButton");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_HideMinimapButtons("set"); end;
					info.value = "TrackingButton";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Calendar Button";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("CalendarButton");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_HideMinimapButtons("set"); end;
					info.value = "CalendarButton";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Zoom In Button";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("ZoomInButton");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_HideMinimapButtons("set"); end;
					info.value = "ZoomInButton";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Zoom Out Button";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("ZoomOutButton");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_HideMinimapButtons("set"); end;
					info.value = "ZoomOutButton";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Minimap Clock";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("ClockButton");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_HideMinimapButtons("set"); end;
					info.value = "ClockButton";
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Decoratives";
					info.notCheckable = 1;
					info.disabled = 1;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Top Border";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("MinimapTopBorder");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_HideMinimapButtons("set2"); end;
					info.value = "MinimapTopBorder";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Toggle Button";
					info.keepShownOnClick = 1;
					info.disabled = 1;
					info.checked = VBM_GetS("MinimapToggleButton");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_HideMinimapButtons("set2"); end;
					info.value = "MinimapToggleButton";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Zone text";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("MinimapZoneText");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_HideMinimapButtons("set2"); end;
					info.value = "MinimapZoneText";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Whole Minimap Border";
					info.tooltipTitle = info.text;
					info.tooltipText = "Will also hide everything attached to it.";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("MinimapBorder");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_HideMinimapButtons("set2"); end;
					info.value = "MinimapBorder";
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Never Show";
					info.notCheckable = 1;
					info.disabled = 1;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "LFG Button";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("LFGButton");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_HideMinimapButtons("set3"); end;
					info.value = "LFGButton";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Instance Difficulty";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("InstanceDiffButton");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_HideMinimapButtons("set3"); end;
					info.value = "InstanceDiffButton";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Mail Button";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("MailButton");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_HideMinimapButtons("set3"); end;
					info.value = "MailButton";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Battlefield Button";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("BattlefieldButton");
					info.func = function(v) VBM_Toggle_Setting(v) VBM_HideMinimapButtons("set3"); end;
					info.value = "BattlefieldButton";
					UIDropDownMenu_AddButton(info,level);
				end
		if(UIDROPDOWNMENU_MENU_VALUE == "BlizzardUIenhancements") then
			info = {};
			info.text = "Restart GFX";
			info.tooltipTitle = info.text;
			info.tooltipText = "Click to Restart GFX engine (to fix possible graphics errors)";
			info.notCheckable = 1;
			info.func = RestartGx;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Reload UI";
			info.tooltipTitle = info.text;
			info.tooltipText = "Click to Reload the User Interface";
			info.notCheckable = 1;
			info.func = ReloadUI;
			UIDropDownMenu_AddButton(info,level);
		end
		
		--[[ ***************************************
		     /////// COMBAT LOG PARSING \\\\\\\\
		     ***************************************]]--
		if(UIDROPDOWNMENU_MENU_VALUE == "CombatLogParsing") then
			info = {};
			info.text = "Combat Log parsing";
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.tooltipOnButton = 1;
			info.keepShownOnClick = 1;
			info.func = VBM_Toggle_Setting;
			info.text = "Buff Alerter";
			info.tooltipTitle = info.text;
			local text = "";
			for temp,_ in pairs (VBM_BUFF_ALERTER_DATA) do
				text = text.."\n"..temp;
			end
			info.tooltipText = "Alerts you with Info Warn text whenever you gain one of these buffs:"..text;
			info.checked = VBM_GetS("BuffAlerter");
			info.arg1 = "BuffAlerter";
			UIDropDownMenu_AddButton(info,level);
			
			info.text = "SS/Feast/Jeeves Alert";
			info.tooltipTitle = info.text;
			info.tooltipText = "Displays a mid screen message when someone:\ngains Soulstone Resurrection\nprepares a Feast\ncast Jeeves or Mailbox";
			info.checked = VBM_GetS("SSDIAlert");
			info.arg1 = "SSDIAlert";
			UIDropDownMenu_AddButton(info,level);
			
			info.text = "Misdirection Watcher";
			info.tooltipTitle = info.text;
			info.tooltipText = "Reports Misdirects in the chat.";
			info.checked = VBM_GetS("MisdirectionAlert");
			info.arg1 = "MisdirectionAlert";
			UIDropDownMenu_AddButton(info,level);
			
			info.text = "Tricks of the Trade Watcher";
			info.tooltipTitle = info.text;
			info.tooltipText = "Reports Tricks of the Trades in the chat.";
			info.checked = VBM_GetS("TricksoftheTradeAlert");
			info.arg1 = "TricksoftheTradeAlert";
			UIDropDownMenu_AddButton(info,level);
			
			info.text = "Toy Train Set Watcher";
			info.tooltipTitle = info.text;
			info.tooltipText = "Reports who cast Toy Train Set in chat.";
			info.checked = VBM_GetS("ToyTrainSet");
			info.arg1 = "ToyTrainSet";
			UIDropDownMenu_AddButton(info,level);
			
			info.hasArrow = 1;
			info.arg1 = nil;
			info.text = "CC Big Brother";
			info.tooltipTitle = info.text;
			--local text = "";
			--for temp,_ in pairs (VBM_CCBBSpells) do
			--	text = text.."\n"..temp;
			--end
			info.tooltipText = "Reports broken Crowd Contols in chat.\nBy Default CC Big Brothers shows then a Friendly Source breaks a cc on an enemy NPC.";
			info.checked = VBM_GetS("CCBigBrother");
			info.value = "CCBigBrother";
			UIDropDownMenu_AddButton(info,level);
			
			info.text = "Interrupt Watcher";
			info.tooltipTitle = info.text;
			info.tooltipText = "Reports Interrupts in chat.\nBy Default Interrupt Watcher shows when a Friendly Source interrupts a spell from an enemy NPC.";
			info.checked = VBM_GetS("InterruptWatcher");
			info.value = "InterruptWatcher";
			UIDropDownMenu_AddButton(info,level);
			
			info.text = "Announce Interrupts in Say";
			info.tooltipTitle = info.text;
			info.tooltipText = "Announce your own interrupts in say.";
			info.checked = VBM_GetS("InterruptWatcherAnnounce");
			info.value = "InterruptWatcherAnnounce";
			UIDropDownMenu_AddButton(info,level);
		end
				if(UIDROPDOWNMENU_MENU_VALUE == "CCBigBrother" or UIDROPDOWNMENU_MENU_VALUE == "InterruptWatcher") then
					info = {};
					info.text = UIDROPDOWNMENU_MENU_VALUE.." Extra Config";
					info.notCheckable = 1;
					info.disabled = 1;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.tooltipOnButton = 1;
					info.keepShownOnClick = 1;
					info.func = VBM_Toggle_Setting;
					info.text = "Hostile Source";
					info.tooltipTitle = info.text;
					info.tooltipText = "Checked: Also show messages from a hostile source (Opposite faction player or mob)\nUnchecked: Only show message when source is friendly.";
					info.checked = VBM_GetS(UIDROPDOWNMENU_MENU_VALUE.."HS");
					info.arg1 = UIDROPDOWNMENU_MENU_VALUE.."HS";
					UIDropDownMenu_AddButton(info,level);
					
					info.text = "Friendly Target";
					info.tooltipTitle = info.text;
					info.tooltipText = "Checked: Also show messages then target/dest is friendly (Same faction)\nUnchecked: Only show message when target/dest is hostile.";
					info.checked = VBM_GetS(UIDROPDOWNMENU_MENU_VALUE.."FT");
					info.arg1 = UIDROPDOWNMENU_MENU_VALUE.."FT";
					UIDropDownMenu_AddButton(info,level);
					
					info.text = "Player Target";
					info.tooltipTitle = info.text;
					info.tooltipText = "Checked: Also show messages then target/dest is a player.\nUnchecked: Only show message when target/dest is a mob.";
					info.checked = VBM_GetS(UIDROPDOWNMENU_MENU_VALUE.."PT");
					info.arg1 = UIDROPDOWNMENU_MENU_VALUE.."PT";
					UIDropDownMenu_AddButton(info,level);
				end
				if(UIDROPDOWNMENU_MENU_VALUE == "InterruptWatcherAnnounce") then
					info = {};
					info.text = "Announce Interrupts";
					info.notCheckable = 1;
					info.disabled = 1;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.tooltipOnButton = 1;
					info.keepShownOnClick = 1;
					info.func = VBM_Toggle_Setting;
					info.text = "Only in Raid Instance";
					info.tooltipTitle = info.text;
					info.tooltipText = "Only announce in say if you are in a Raid Instance (That VBM Supports).";
					info.checked = VBM_GetS("InterruptWatcherAnnounceOnlyRaid");
					info.arg1 = "InterruptWatcherAnnounceOnlyRaid";
					UIDropDownMenu_AddButton(info,level);
				end
		
		--[[ ***************************************
		     /////// INTERFACE ADDONS \\\\\\\\
		     ***************************************]]--
		if(UIDROPDOWNMENU_MENU_VALUE == "InterfaceAddons") then
			info = {};
			info.text = "Interface Addons";
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Auto Popups";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "AutoPopups";
			--UIDropDownMenu_AddButton(info,level);

			info = {};
			info.text = "AutoRepair";
			info.hasArrow = 1;
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("AutoRepair");
			info.func = VBM_Toggle_Setting;
			info.value = "AutoRepair";
			UIDropDownMenu_AddButton(info,level);
		end
				if(UIDROPDOWNMENU_MENU_VALUE == "AutoRepair") then
					info = {};
					info.text = "Save atleast 5g";
					info.tooltipTitle = info.text;
					info.tooltipText = "Don't autorepair if you will go under 5g";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("AutoRepairSave5g");
					info.func = VBM_Toggle_Setting;
					info.value = "AutoRepairSave5g";
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Use Guild Bank";
					info.tooltipTitle = info.text;
					info.tooltipText = "First try to use guild bank and if it fails use your own";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("AutoRepairUseGBank");
					info.func = VBM_Toggle_Setting;
					info.value = "AutoRepairUseGBank";
					UIDropDownMenu_AddButton(info,level);
				end
		if(UIDROPDOWNMENU_MENU_VALUE == "InterfaceAddons") then
			info = {};
			info.text = "Auto Roll Loot Select";
			info.tooltipTitle = info.text;
			local text = "";
			for i=1,#VBM_AUTOLOOT_EXCEPTIONS do
				text = text.."\n"..VBM_AUTOLOOT_EXCEPTIONS[i];
			end
			info.tooltipText = "Auto Select the choosen options then a non BoP loot roll apear. Exceptions:"..text;
			info.keepShownOnClick = 1;
			info.hasArrow = 1;
			info.checked = VBM_GetS("AutoLootSelect");
			info.func = VBM_Toggle_Setting;
			info.value = "AutoLootSelect";
			UIDropDownMenu_AddButton(info,level);
		end
				if(UIDROPDOWNMENU_MENU_VALUE == "AutoLootSelect") then
					info = {};
					info.text = "Need";
					info.checked = (VBM_GetS("LootSelectOption")=="Need");
					info.func = function() VBM_SetS(nil,"LootSelectOption","Need"); end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Greed";
					info.checked = (VBM_GetS("LootSelectOption")=="Greed");
					info.func = function() VBM_SetS(nil,"LootSelectOption","Greed"); end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Pass";
					info.checked = (VBM_GetS("LootSelectOption")=="Pass");
					info.func = function() VBM_SetS(nil,"LootSelectOption","Pass"); end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Disenchant > Greed";
					info.checked = (VBM_GetS("LootSelectOption")=="Diss");
					info.func = function() VBM_SetS(nil,"LootSelectOption","Diss"); end;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "--Extra Options--";
					info.notCheckable = 1;
					info.disabled = 1;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Ignore Epics";
					info.tooltipTitle = info.text;
					info.tooltipText = "Auto roll loot select will only roll on greens and blues and ignore epics and higher.";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("LootSelectNoEpic");
					info.func = VBM_Toggle_Setting;
					info.value = "LootSelectNoEpic";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Auto set Greed";
					info.tooltipTitle = info.text;
					info.tooltipText = "When you leave a raid group, auto set to greed";
					info.checked = VBM_GetS("LootSelectAutoGreed");
					info.func = function(v) VBM_Toggle_Setting(v); VBMSettings["LootSelectAutoDiss"] = 0; end;
					info.value = "LootSelectAutoGreed";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Auto set Disenchant";
					info.tooltipTitle = info.text;
					info.tooltipText = "When you leave a raid group, auto set to disenchnat";
					info.checked = VBM_GetS("LootSelectAutoDiss");
					info.func = function(v) VBM_Toggle_Setting(v); VBMSettings["LootSelectAutoGreed"] = 0; end;
					info.value = "LootSelectAutoDiss";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Auto set Pass";
					info.tooltipTitle = info.text;
					info.tooltipText = "Set to pass when your raidgroup has more then 20 members";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("LootSelectAutoPass");
					info.func = VBM_Toggle_Setting;
					info.value = "LootSelectAutoPass";
					UIDropDownMenu_AddButton(info,level);
				end
		if(UIDROPDOWNMENU_MENU_VALUE == "InterfaceAddons") then
			info = {};
			info.text = "Auto Solo BoP Loot";
			info.tooltipTitle = info.text;
			info.tooltipText = "Auto loot BoP items when you are solo (not in a group)";
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("AutoSoloBoPLoot");
			info.func = VBM_Toggle_Setting;
			info.value = "AutoSoloBoPLoot";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Battleground join replacement";
			info.tooltipTitle = info.text;
			info.tooltipText = "Replaces your old popups with a BG Join UI";
			info.keepShownOnClick = 1;
			info.hasArrow = 1;
			info.checked = VBM_GetS("BGJoinReplacement");
			info.func = VBM_Toggle_Setting;
			info.value = "BGJoinReplacement";
			UIDropDownMenu_AddButton(info,level);
		end
				if(UIDROPDOWNMENU_MENU_VALUE == "BGJoinReplacement") then
					info = {};
					info.notCheckable = 1;
					info.text = "Show Frame Now";
					info.func = VBM_BGJoinFrame_ForceShow;
					UIDropDownMenu_AddButton(info,level);

					info = {};
					info.text = "Kill Blizzard Join Popup";
					info.tooltipTitle = info.text;
					info.tooltipText = "Normally the bg join replacement hides blizzards join bg popup, But here is an option to hide it even if you don't use the bg replacment.\n\n(Requires reloadui to be disabled again)";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("KillBlizzardJoinPopup");
					info.func = function(v) VBM_Toggle_Setting(v); VBM_KillBlizzardBGJoin(); end;
					info.value = "KillBlizzardJoinPopup";
					UIDropDownMenu_AddButton(info,level);
					
				end
		if(UIDROPDOWNMENU_MENU_VALUE == "InterfaceAddons") then
			info = {};
			info.text = "Badge Loot Reminder";
			info.tooltipTitle = info.text;
			local text = "";
			for i=1,#VBM_BADGE_REMINDER do
				text = text.."\n"..VBM_BADGE_REMINDER[i];
			end
			info.tooltipText = "If more then 45% of your group loots a Emblem or Badge token within 1 min and you don't, it will remind you of that. Current badges:"..text;
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("BadgeReminder");
			info.func = VBM_Toggle_Setting;
			info.value = "BadgeReminder";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "LFG/BG Sound in Background";
			info.tooltipTitle = info.text;
			info.tooltipText = "If this is checked VBM will enable Sound in Background then bg or lfg\n"..
											"activity is detected. (so you can hear the join sound if tabbed)\n"..
											"And disable Sound in Background after 2 min then activity stops.\n";
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("LFGBGSoundHandling");
			info.func = VBM_Toggle_Setting;
			info.value = "LFGBGSoundHandling";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Honor Report";
			info.tooltipTitle = info.text;
			info.tooltipText = "Reports gained honor in the chatbox each time a battleground is complete";
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("BGHonorReport");
			info.func = VBM_Toggle_Setting;
			info.value = "BGHonorReport";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "'Invite' Keyword";
			info.tooltipTitle = info.text;
			info.tooltipText = "Invite people who whispers you 'invite'";
			info.hasArrow = 1;
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("InviteKeyword");
			info.func = VBM_Toggle_Setting;
			info.value = "InviteKeyword";
			UIDropDownMenu_AddButton(info,level);
		end
				if(UIDROPDOWNMENU_MENU_VALUE == "InviteKeyword") then
					info = {};
					info.text = "Enable short 'inv'";
					info.tooltipTitle = info.text;
					info.tooltipText = "Also invites people who whisper you 'inv'";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("ShortInviteKeyword");
					info.func = VBM_Toggle_Setting;
					info.value = "ShortInviteKeyword";
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "No whisper";
					info.tooltipTitle = info.text;
					info.tooltipText = "Do not replay with 'You are already in a group' message.";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("NoWhisperInviteKeyword");
					info.func = VBM_Toggle_Setting;
					info.value = "NoWhisperInviteKeyword";
					UIDropDownMenu_AddButton(info,level);
				end
		if(UIDROPDOWNMENU_MENU_VALUE == "InterfaceAddons") then
			info = {};
			info.text = "Reagent Buyer";
			info.tooltipTitle = info.text;
			info.tooltipText = "Show Reagent Buyer then you visit a Reagent Vendor";
			info.hasArrow = 1;
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("ReagentBuyer");
			info.func = VBM_Toggle_Setting;
			info.value = "ReagentBuyer";
			UIDropDownMenu_AddButton(info,level);
		end
				if(UIDROPDOWNMENU_MENU_VALUE == "ReagentBuyer") then
					info = {};
					info.text = "Auto Buy Reagents";
					info.tooltipTitle = info.text;
					info.tooltipText = "Auto buys the configed amount of reagent then you visit a vendor";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("ReagentBuyerAuto");
					info.func = VBM_Toggle_Setting;
					info.value = "ReagentBuyerAuto";
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Auto Sell Grey Items";
					info.tooltipTitle = info.text;
					info.tooltipText = "Does a /sellgrey when you visit a vendor.";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("AutoSellGreyItems");
					info.func = VBM_Toggle_Setting;
					info.value = "AutoSellGreyItems";
					UIDropDownMenu_AddButton(info,level);
				end
		--[[ ***************************************
		     /////// CLASS SPECIFIC \\\\\\\\
		     ***************************************]]--
		if(UIDROPDOWNMENU_MENU_VALUE == "ClassSpecific") then
			info = {};
			info.text = "Class Specific";
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Taunt Fail Warning";
			info.tooltipTitle = info.text;
			local text = "";
			for temp,_ in pairs (VBM_TauntAnnounce_Spells) do
				text = text.."\n"..temp;
			end
			info.tooltipText = "Announce in chat then your one of these spells fail:"..text;
			info.keepShownOnClick = 1;
			info.checked = VBM_GetS("TauntFail");
			info.func = VBM_Toggle_Setting;
			info.value = "TauntFail";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Hunter";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "ClassHunter";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Warlock";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "ClassWarlock";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Shaman";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "ClassShaman";
			UIDropDownMenu_AddButton(info,level);
		end
				if(UIDROPDOWNMENU_MENU_VALUE == "ClassHunter") then
					info = {};
					info.text = "Feign Death Resist";
					info.tooltipTitle = info.text;
					info.tooltipText = "Feign Death Resist Warning";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("FeignDeathResist");
					info.func = VBM_Toggle_Setting;
					info.value = "FeignDeathResist";
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Feign Death Success";
					info.tooltipTitle = info.text;
					info.tooltipText = "Display a success message 0.8 sec after you Feign Death";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("FeignDeathSuccess");
					info.func = VBM_Toggle_Setting;
					info.value = "FeignDeathSuccess";
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "TranqShot Report";
					info.tooltipTitle = info.text;
					info.tooltipText = "Reports Hits/Miss on Tranquilizing Shot for all Hunters";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("TranqShotReport");
					info.func = VBM_Toggle_Setting;
					info.value = "TranqShotReport";
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Aspect of the Viper Warning";
					info.tooltipTitle = info.text;
					info.tooltipText = "Will warn you with infowarn if you have more then 90% mana and are shoting with viper active.";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("ViperActiveNotice");
					info.func = VBM_Toggle_Setting;
					info.value = "ViperActiveNotice";
					UIDropDownMenu_AddButton(info,level);
				end
				if(UIDROPDOWNMENU_MENU_VALUE == "ClassWarlock") then
					info = {};
					info.text = "Easy Healthstone Trade";
					info.tooltipTitle = info.text;
					info.tooltipText = "Enables the command /hs that autotrades a healthstone to your target";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("AutoTradeHS");
					info.func = VBM_Toggle_Setting;
					info.value = "AutoTradeHS";
					UIDropDownMenu_AddButton(info,level);	
					
					info = {};
					info.text = "Soul Shard Counter";
					info.tooltipTitle = info.text;
					info.tooltipText = "Count Soul Shards in a Soul Shard Bag and display it in Info Warn text";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("SoulShardCounter");
					info.func = VBM_Toggle_Setting;
					info.value = "SoulShardCounter";
					UIDropDownMenu_AddButton(info,level);	
					
					info = {};
					info.text = "Soulshatter Resist";
					info.tooltipTitle = info.text;
					info.tooltipText = "Displays a infowarn text then your Soulshatter Resists";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("SoulshatterResist");
					info.func = VBM_Toggle_Setting;
					info.value = "SoulshatterResist";
					UIDropDownMenu_AddButton(info,level);
				end
				if(UIDROPDOWNMENU_MENU_VALUE == "ClassShaman") then
					info = {};
					info.text = "Maelstrom Weapon Tracker";
					info.tooltipTitle = info.text;
					info.tooltipText = "Displays an icon with the number of Maelstrom Weapon charges on.";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("MaelstromWeaponTracker");
					info.func = VBM_Toggle_Setting;
					info.value = "MaelstromWeaponTracker";
					UIDropDownMenu_AddButton(info,level);
				end
				
		--[[ ***************************************
		     /////// INSTANCE SPECIFIC \\\\\\\\
		     ***************************************]]--
		if(UIDROPDOWNMENU_MENU_VALUE == "Instancespecific") then
			info = {};
			info.text = "Instance Specific";
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Disband Raid";
			info.tooltipTitle = info.text;
			info.tooltipText = "Show disband raid Confirm Dialog";
			info.notCheckable = 1;
			info.func = VBM_DisbandRaid;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Alterac Valley";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "AlteracValley";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Auto Zoneing Options";
			info.tooltipTitle = info.text;
			info.tooltipText = "Checking one of these means that when you zone to a raid instance the option will be:\nDisabled when you zone in\nEnbaled again when you zone out.";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "AutoZoneingOptions";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Instances";
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Hyjal Summit";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "HyjalSummit";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Sunwell Plateau";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "SunwellPlateau";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Eye of Eternity";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "EyeofEternity";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Ulduar";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "Ulduar";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Trial of the Crusader";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "CrusadersColiseum";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Icecrown Citadel";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "IcecrownCitadel";
			UIDropDownMenu_AddButton(info,level);
		end
				if(UIDROPDOWNMENU_MENU_VALUE == "AlteracValley") then
					info = {};
					info.text = "Start AV countdown";
					info.tooltipTitle = info.text;
					info.tooltipText = "You must be group leader.";
					info.notCheckable = 1;
					info.func = VBM_AVCountDownStart;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Auto accept join commands";
					info.tooltipTitle = info.text;
					info.tooltipText = "Accept the commands sent by Start AV countdown";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("AVAutoJoin");
					info.func = VBM_Toggle_Setting;
					info.value = "AVAutoJoin";
					UIDropDownMenu_AddButton(info,level);
				end
				
				if(UIDROPDOWNMENU_MENU_VALUE == "AutoZoneingOptions") then
					info = {};
					info.text = "Detailed Loot Information";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("AutoDetailedLoot");
					info.func = VBM_Toggle_Setting;
					info.value = "AutoDetailedLoot";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Player Names";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("AutoPlayerNames");
					info.func = VBM_Toggle_Setting;
					info.value = "AutoPlayerNames";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Player Guild Names";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("AutoPlayerGuildNames");
					info.func = VBM_Toggle_Setting;
					info.value = "AutoPlayerGuildNames";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Player Titles";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("AutoPlayerTitles");
					info.func = VBM_Toggle_Setting;
					info.value = "AutoPlayerTitles";
					UIDropDownMenu_AddButton(info,level);
				end
		
				if(UIDROPDOWNMENU_MENU_VALUE == "HyjalSummit") then
					info = {};
					info.text = "Tears of the Goddess Check";
					info.tooltipTitle = info.text;
					info.tooltipText = "Raidleader or Raidofficer may Click to start a Tears of the Goddess Check";
					info.notCheckable = 1;
					info.func = VBM_TearsOfTheGoddessCheckStart;
					UIDropDownMenu_AddButton(info,level);	
				end
				
				if(UIDROPDOWNMENU_MENU_VALUE == "SunwellPlateau") then
					info = {};
					info.text = "EredarTwins Tank Switch";
					info.tooltipTitle = info.text;
					info.tooltipText = "Displays a Info Warn Mess then melee tanks are switched on Eredar Twins";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("EredarTwinsTankWarning");
					info.func = VBM_Toggle_Setting;
					info.value = "EredarTwinsTankWarning";
					UIDropDownMenu_AddButton(info,level);
				end
				if(UIDROPDOWNMENU_MENU_VALUE == "EyeofEternity") then
					info = {};
					info.text = "Toggle Malygos UI";
					info.tooltipTitle = info.text;
					info.tooltipText = "Ctrl+Click the Frame to lock it";
					info.notCheckable = 1;
					info.func = VBM_Toggle_MalygosUI;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Lock Malygos UI";
					info.tooltipTitle = info.text;
					info.tooltipText = "Ctrl+Click the Frame does Also Lock It";
					info.notCheckable = 1;
					info.func = VBM_MalygosUI_LockMouse;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Unlock Malygos UI";
					info.notCheckable = 1;
					info.func = VBM_MalygosUI_UnLockMouse;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Auto Show/Hide Malygos UI";
					info.tooltipTitle = info.text;
					info.tooltipText = "Auto show UI then Malygos is detected. And auto hide it then you zone out of a raid instance.";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("AutoMalygosUI");
					info.func = VBM_Toggle_Setting;
					info.value = "AutoMalygosUI";
					UIDropDownMenu_AddButton(info,level);
					
				end
				if(UIDROPDOWNMENU_MENU_VALUE == "Ulduar") then
					info = {};
					info.text = "Vehicle Check";
					info.tooltipTitle = info.text;
					info.tooltipText = "Print Flame Leviathan Vehicle info into chat.";
					info.notCheckable = 1;
					info.func = VBM_Ulduar_Vehicle_Setup;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Algalon ilvl 226 check";
					info.tooltipTitle = info.text;
					info.tooltipText = "Show result to self.";
					info.notCheckable = 1;
					info.func = VBM_UlduarAlgalonIlvlCheck;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Print Chat Algalon ilvl 226";
					info.tooltipTitle = info.text;
					info.tooltipText = "Prints result from check to chat.";
					info.notCheckable = 1;
					info.func = VBM_UlduarAlgalonIlvlCheckChat;
					UIDropDownMenu_AddButton(info,level);
				end
				if(UIDROPDOWNMENU_MENU_VALUE == "CrusadersColiseum") then
					info = {};
					info.text = "Disable Anub'arak adds timers";
					info.tooltipTitle = info.text;
					info.tooltipText = "This disables Shadow Strike and Nerubian Burrower spawn timers.";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("DisableAnubAddsTimers");
					info.func = VBM_Toggle_Setting;
					info.value = "DisableAnubAddsTimers";
					UIDropDownMenu_AddButton(info,level);
				end
				if(UIDROPDOWNMENU_MENU_VALUE == "IcecrownCitadel") then
					info = {};
					info.text = "Lady Deathwhisper";
					info.notCheckable = 1;
					info.disabled = 1;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Smaller Mind Control Warning";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("DeathwhisperMC");
					info.func = VBM_Toggle_Setting;
					info.value = "DeathwhisperMC";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "The Lich King";
					info.notCheckable = 1;
					info.disabled = 1;
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Disable Soul Reaper Timer";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("LichKingSoulReaperTimer");
					info.func = VBM_Toggle_Setting;
					info.value = "LichKingSoulReaperTimer";
					UIDropDownMenu_AddButton(info,level);
					info = {};
					info.text = "Disable Soul Reaper MidScreenCountDown";
					info.keepShownOnClick = 1;
					info.checked = VBM_GetS("LichKingSoulReaper");
					info.func = VBM_Toggle_Setting;
					info.value = "LichKingSoulReaper";
					UIDropDownMenu_AddButton(info,level);
				end
		--[[ ***************************************
		     /////// PRINT INFO MENU \\\\\\\\
		     ***************************************]]--
		if(UIDROPDOWNMENU_MENU_VALUE == "Printinfo") then
			info = {};
			info.text = "Print info";
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "VBM Version Info";
			info.notCheckable = 1;
			info.func = VBM_PrintVersions;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "";
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Extra slash commands";
			info.func = VBM_Slashcommandinfo;
			info.notCheckable = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Macro commands";
			info.func = VBM_Macrocommandinfo;
			info.notCheckable = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Groupleader/Officer extras";
			info.func = VisionBossMod_PrintOfficerInfo;
			info.notCheckable = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "RaidModes info";
			info.func = VisionBossMod_PrintRaidModesInfo;
			info.notCheckable = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "";
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "VBM Varibel Info (Debug info)";
			info.notCheckable = 1;
			info.func = VBM_PrintVaribelInfo;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "About VBM";
			info.notCheckable = 1;
			info.func = VBM_PrintAboutInfo;
			UIDropDownMenu_AddButton(info,level);
		end
		--[[ ***************************************
		     /////// EXTRA FEATURES \\\\\\\\
		     ***************************************]]--
		if(UIDROPDOWNMENU_MENU_VALUE == "ExtraFeatures") then
			info = {};
			info.text = "Extra Features";
			info.notCheckable = 1;
			info.disabled = 1;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Storm Earth Fire";
			info.notCheckable = 1;
			info.func = VBM_StormEarthFire;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Lament of the Highborne";
			info.notCheckable = 1;
			info.func = VBM_LamentoftheHighborne;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Magisters' Terrace - Grand Magister's Asylum";
			info.notCheckable = 1;
			info.func = VBM_Mgt_KT_Theme;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "World of Warcraft Main";
			info.notCheckable = 1;
			info.func = VBM_WowMain;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Burning Crusade Main";
			info.notCheckable = 1;
			info.func = VBM_BcMain;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Wrath of the Lich King Main";
			info.notCheckable = 1;
			info.func = VBM_WotlkMain;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Stop Music";
			info.notCheckable = 1;
			info.func = StopMusic;
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "World of Warcraft classic Sounds";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "SoundMenu";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Burning Crusade Sounds";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "BCSoundMenu";
			UIDropDownMenu_AddButton(info,level);
			
			info = {};
			info.text = "Wrath of the Lich King Sounds";
			info.hasArrow = 1;
			info.notCheckable = 1;
			info.value = "WOTLKSoundMenu";
			UIDropDownMenu_AddButton(info,level);
			
		end
				if(UIDROPDOWNMENU_MENU_VALUE == "SoundMenu") then
					info = {};
					info.text = "Majordomo Executus";
					info.notCheckable = 1;
					info.func = VBM_Sound_Majordomo;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Ragnaros";
					info.notCheckable = 1;
					info.func = VBM_Sound_Ragnaros;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Vaelastrasz";
					info.notCheckable = 1;
					info.func = VBM_Sound_Vaelastrasz;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Nefarius";
					info.notCheckable = 1;
					info.func = VBM_Sound_Nefarius;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Nefarian";
					info.notCheckable = 1;
					info.func = VBM_Sound_Nefarian;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Hakkar the Soulflayer";
					info.notCheckable = 1;
					info.func = VBM_Sound_Hakkar;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Gothik the Harvester";
					info.notCheckable = 1;
					info.func = VBM_Sound_Gothik;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Heigan the Unclean (Dance Start)";
					info.notCheckable = 1;
					info.func = VBM_Sound_HeiganDance;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Highlord Mograine";
					info.notCheckable = 1;
					info.func = VBM_Sound_HighlordMograine;
					UIDropDownMenu_AddButton(info,level);

					info = {};
					info.text = "Four Horsemen";
					info.notCheckable = 1;
					info.func = VBM_Sound_FourHorsemen;
					UIDropDownMenu_AddButton(info,level);
				end
				if(UIDROPDOWNMENU_MENU_VALUE == "BCSoundMenu") then
					info = {};
					info.text = "Dalliah vs Soccothrates";
					info.notCheckable = 1;
					info.func = VBM_Sound_WrathScryerAndDalliah;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Akama & Maiev Assault Black Temple";
					info.notCheckable = 1;
					info.func = VBM_Sound_AssaultBT;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Akama warning";
					info.notCheckable = 1;
					info.func = VBM_Sound_AkamaWarn;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Illidan Stormrage";
					info.notCheckable = 1;
					info.func = VBM_Sound_IllidanStormrage;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Maiev vs Illidan";
					info.notCheckable = 1;
					info.func = VBM_Sound_MaievvsIllidan;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Demon Within";
					info.notCheckable = 1;
					info.func = VBM_Sound_DemonIllidan;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Illidan Defeated";
					info.notCheckable = 1;
					info.func = VBM_Sound_IllidanDefeated;
					UIDropDownMenu_AddButton(info,level);
					
					info = {};
					info.text = "Eredar Twins";
					info.notCheckable = 1;
					info.func = VBM_Sound_EredarTwins;
					UIDropDownMenu_AddButton(info,level);
				end
				if(UIDROPDOWNMENU_MENU_VALUE == "WOTLKSoundMenu") then
					info = {};
					info.text = "Yogg-saron (Sara transforms)";
					info.notCheckable = 1;
					info.func = VBM_Sound_YoggSaraTransform;
					UIDropDownMenu_AddButton(info,level);
				end
end
