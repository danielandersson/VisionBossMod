--[[
	********************************************************************
	********************************************************************
	Interact with other addons functions
	********************************************************************
	********************************************************************
]]--


--[[
	/////////////////////////////
	Minimap Button Hider
	/////////////////////////////
]]--

function VBM_HideMinimapButtons(showagain)
	-- Main Buttons
	if(VBM_GetS("WorldMapButton")) then
		MiniMapWorldMapButton:Hide();
	else
		if(showagain=="set") then
			MiniMapWorldMapButton:Show();
		end
	end
	if(VBM_GetS("TrackingButton")) then
		MiniMapTracking:Hide();
	else
		if(showagain=="set") then
			MiniMapTracking:Show();
		end
	end
	if(VBM_GetS("CalendarButton")) then
		GameTimeFrame:Hide();
	else
		if(showagain=="set") then
			GameTimeFrame:Show();
		end
	end
	if(VBM_GetS("ZoomInButton")) then
		MinimapZoomIn:Hide();
	else
		if(showagain=="set") then
			MinimapZoomIn:Show();
		end
	end
	if(VBM_GetS("ZoomOutButton")) then
		MinimapZoomOut:Hide();
	else
		if(showagain=="set") then
			MinimapZoomOut:Show();
		end
	end
	if(VBM_GetS("ClockButton")) then
		if(TimeManagerClockButton) then
			TimeManagerClockButton:Hide();
		end
	else
		if(showagain=="set") then
			if(TimeManagerClockButton) then
				TimeManagerClockButton:Show();
			end
		end
	end
	
	-- Decoratives
	if(VBM_GetS("MinimapTopBorder")) then
		MinimapBorderTop:Hide();
	else
		if(showagain=="set2") then
			MinimapBorderTop:Show();
		end
	end
	if(VBM_GetS("MinimapBorder")) then
		MinimapBackdrop:Hide();
	else
		if(showagain=="set2") then
			MinimapBackdrop:Show();
		end
	end
	--[[if(VBM_GetS("MinimapToggleButton")) then
		MinimapToggleButton:Hide();
	else
		if(showagain=="set2") then
			MinimapToggleButton:Show();
		end
	end]]--
	if(VBM_GetS("MinimapZoneText")) then
		MinimapZoneTextButton:Hide();
	else
		if(showagain=="set2") then
			MinimapZoneTextButton:Show();
		end
	end
	
	-- Never Show
	if(VBM_GetS("MeetingStoneButton")) then
		MiniMapLFGFrame:Hide();
		MiniMapLFGFrame:SetScript("OnShow",function() self:Hide(); end);
	else
		if(showagain=="set3") then
			MiniMapLFGFrame:SetScript("OnShow",nil);
		end
	end
	if(VBM_GetS("InstanceDiffButton")) then
		MiniMapInstanceDifficulty:Hide();
		MiniMapInstanceDifficulty:SetScript("OnShow",function() MiniMapInstanceDifficulty:Hide(); end);
	else
		if(showagain=="set3") then
			MiniMapInstanceDifficulty:SetScript("OnShow",nil);
		end
	end
	if(VBM_GetS("MailButton")) then
		MiniMapMailFrame:Hide();
		MiniMapMailFrame:SetScript("OnShow",function() MiniMapMailFram:Hide(); end);
	else
		if(showagain=="set3") then
			MiniMapMailFrame:SetScript("OnShow",nil);
		end
	end
	if(VBM_GetS("BattlefieldButton")) then
		MiniMapBattlefieldFrame:Hide();
		MiniMapBattlefieldFrame:SetScript("OnShow",function() MiniMapBattlefieldFrame:Hide(); end);
	else
		if(showagain=="set3") then
			MiniMapBattlefieldFrame:SetScript("OnShow",nil);
		end
	end

end

--[[
	/////////////////////////////
	Remove Some Error Messages
	/////////////////////////////
	
	-- Another action is in progress
]]--

function VBM_HookErrorMessageDisabler()
	if(VBM_GetS("ErrorMessageDisabler")) then
		if(not VBM_oldUIErrorsFrame_AddMessage) then
			VBM_oldUIErrorsFrame_AddMessage = UIErrorsFrame.AddMessage;
			UIErrorsFrame.AddMessage = VBM_UIErrorsFrame_AddMessage;
		end
	end
end

function VBM_UIErrorsFrame_AddMessage(self,...)
	local arg1 = ...;
	if(VBM_GetS("ErrorMessAbilityNotReady") and arg1 == ERR_ABILITY_COOLDOWN) then
		return;
	end	
	
	if(VBM_GetS("ErrorMessAnotherAction") and arg1 == SPELL_FAILED_SPELL_IN_PROGRESS) then
		return;
	end	
	
	if(VBM_GetS("ErrorMessItemNotReady") and arg1 == ERR_ITEM_COOLDOWN) then
		return;
	end	
	
	if(VBM_GetS("ErrorMessNotEnergy") and arg1 == ERR_OUT_OF_ENERGY) then
		return;
	end	
	
	if(VBM_GetS("ErrorMessNotRage") and arg1 == ERR_OUT_OF_RAGE) then
		return;
	end	
	
	if(VBM_GetS("ErrorMessSpellNotReady") and arg1 == ERR_SPELL_COOLDOWN) then
		return;
	end	

	return VBM_oldUIErrorsFrame_AddMessage(self,...);
end

--[[
	/////////////////////////////
	AutoSet MaxDistance Camera
	/////////////////////////////
]]--

function VBM_AutoSetCameraDistance()
	if(VBM_GetS("AutoSetCameraDistance")) then
		SetCVar("cameraDistanceMaxFactor","5");
	end
end

--[[
	/////////////////////////////
	AltInvite
	/////////////////////////////
]]--

function VBM_HookAltInvite()
	if(VBM_GetS("AltInvite")) then
		if(not VisionBossMod_oldSetItemRef) then
			VisionBossMod_oldSetItemRef = SetItemRef;
			SetItemRef = VisionBossMod_SetItemRef;
		end
	end
end


function VisionBossMod_SetItemRef(link, text, button)
	if ( strsub(link, 1, 6) == "player" ) then
		local namelink = strsub(link, 8);
		local name, lineid = strsplit(":", namelink);
		if ( name and (strlen(name) > 0) ) then
			local begin = string.find(name, "%s[^%s]+$");
			if ( begin ) then
				name = strsub(name, begin+1);
			end
			if ( IsAltKeyDown() ) then
				InviteUnit(name);
				return false;
			end
		end
	end
	
	VisionBossMod_oldSetItemRef(link, text, button);
end


--[[
	/////////////////////////////
	Remove AutoDecline Then you close ress window
	/////////////////////////////
]]--

function VBM_RemoveAutoDeclineRess()
	if(VBM_GetS("RemoveDeclineRess")) then
		StaticPopupDialogs["RESURRECT"].OnCancel = function()
			if ( UnitIsDead("player") ) then
				StaticPopup_Show("DEATH");
			end
			vbm_printc("Ress has not been declined /ress to ress");
		end
		StaticPopupDialogs["RESURRECT_NO_SICKNESS"].OnCancel = function()
			if ( UnitIsDead("player") ) then
				StaticPopup_Show("DEATH");
			end
			vbm_printc("Ress has not been declined /ress to ress");
		end
		StaticPopupDialogs["RESURRECT_NO_TIMER"].OnCancel = function()
			if ( UnitIsDead("player") ) then
				StaticPopup_Show("DEATH");
			end
			vbm_printc("Ress has not been declined /ress to ress");
		end
	end
end

--[[
	/////////////////////////////
	World State Frame Strata fix
	/////////////////////////////
]]--

function VBM_WorldStateFrameFix()
	if(VBM_GetS("BackgroundWorldState")) then
		WorldStateAlwaysUpFrame:SetFrameStrata("BACKGROUND")
	end
end

--[[
	/////////////////////////////
	Disable Blizzard RaidWarning
	/////////////////////////////
]]--

function VBM_DisableBlizzardRaidWarnings()
	if(VBM_GetS("DisableBlizzardWarnText")) then
		RaidBossEmoteFrame:UnregisterAllEvents();
		--[[if(not VBMold_RaidBossEmoteFrame_OnEvent) then
			VBMold_RaidBossEmoteFrame_OnEvent = RaidBossEmoteFrame_OnEvent;
			function RaidBossEmoteFrame_OnEvent(self, event, ...)
				if ( strsub(event,10,18) == "RAID_BOSS" ) then
					return;
				end
				return VBMold_RaidBossEmoteFrame_OnEvent(self, event, ...);
			end
		end]]
	end
end

--[[
	/////////////////////////////
	Kill Blizzard BG Popup
	/////////////////////////////
]]--

function VBM_KillBlizzardBGJoin()
	if(VBM_GetS("KillBlizzardJoinPopup")) then
		StaticPopupDialogs["CONFIRM_BATTLEFIELD_ENTRY"] = nil;
	end
end

--[[
	/////////////////////////////
	Move Alt Power Bar
	/////////////////////////////
]]--

function VBM_HookMoveAltBar()
	local self = PlayerPowerBarAlt;
	self:EnableMouse(1);
	self:SetMovable(1);
	self:RegisterForDrag("LeftButton");
	self:SetScript("OnDragStart",function(self) if(IsAltKeyDown()) then self:StartMoving(); end end);
	self:SetScript("OnDragStop",function(self) self:StopMovingOrSizing(); end);
	vbm_printc("Hooked BossAltPowerBar, you can now drag it with alt key down");
	vbm_printc("To lock it again use: /lockbossbar");
end

function VBM_HookLockAltBar()
	local self = PlayerPowerBarAlt;
	self:EnableMouse(0);
end



--[[
	/////////////////////////////
	Autorun all hooks att startup
	/////////////////////////////
]]--
--run during varibles loaded
function VBM_AutoRunHookFunctions()
	VBM_HookAltInvite();
	VBM_RemoveAutoDeclineRess();
	VBM_WorldStateFrameFix();
	VBM_DisableBlizzardRaidWarnings();
	VBM_KillBlizzardBGJoin();
	VBM_HideMinimapButtons();
	VBM_HookErrorMessageDisabler();
end
--run during EnterWorld
function VBM_AutoRunEnterWorldHookFunctions()
	VBM_AutoSetCameraDistance();
end

