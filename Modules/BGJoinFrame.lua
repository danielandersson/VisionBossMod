--[[
	********************************************************************
	********************************************************************
	BG Join Frame
	
	********************************************************************
	********************************************************************

]]--

function VBM_BGJoinFrame_Init()
	if(not VBM_BGJ_S) then
		VBM_BGJ_S = {
			["locked"] = false,
			['collapse'] = false,
			['autojoin'] = false,
			['release'] = false,
			['hide'] = false,
			['autojointime'] = 10,
			['extrasound'] = false,
		};
	end
	VBM_BGJ_S['autojoin'] = false;
end

function VBM_BGJoinFrame_OnLoad(self)
	self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
	self:RegisterEvent("PLAYER_DEAD");
	
	UIDropDownMenu_Initialize(VBMBGJoinDropDownMenu, VBM_BGJoin_HideMenu, "MENU");
end

function VBM_BGJoinFrame_OnEvent(event)
	if(not VBM_GetS("BGJoinReplacement")) then return; end
	
	if(event == "UPDATE_BATTLEFIELD_STATUS") then
		VBM_BGJoinFrame_Update();
	end
	
	if(event == "PLAYER_DEAD") then
		if(VBM_BGJ_S['release']) then
			for i=1, MAX_BATTLEFIELD_QUEUES do
				local status, mapName, instanceID = GetBattlefieldStatus(i);
				if(status == "active") then
					local isArena, isRegistered = IsActiveBattlefieldArena();
					if(not isArena) then
						RepopMe();
					end
				end
			end
		end
	end
end

function VBM_BGJoinFrame_ForceShow()
	VBMBGJoinFrame.forced = true;
	VBMBGJoinFrame:Show();
	VBMBGJoinFrameHideButton:Show();
end

function VBM_BGJoinFrame_ForceHide()
	VBMBGJoinFrame.forced = nil;
	VBMBGJoinFrameHideButton:Hide();
	VBMBGJoinFrame:Hide();
end

VBM_BGJoin_BgMenu = 1;
VBM_BGJoin_State = {"","",""};
VBM_BGJoin_LastStatus = {"","",""};
VBM_BGJoin_Status = {"","",""};
VBM_BGJoin_AutoJoin = {};

function VBM_BGJoinFrame_Update()
	local bgsready = 0;
	local bgshown = 0;
	local highestbg = 0;
	
	for i=1, MAX_BATTLEFIELD_QUEUES do
		--start by hiding popups
		StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY",i);
		--now populate frame
		local status, mapName, instanceID = GetBattlefieldStatus(i);
		
		if(status == "confirm") then
			--count up
			bgsready = bgsready + 1;
			--setup autojoin
			if(VBM_BGJ_S['autojoin'] and VBM_BGJoin_LastStatus[i] == "queued") then
				VBM_BGJoin_AutoJoin[i] = math.ceil(GetTime()+VBM_BGJ_S['autojointime']);
				VBM_BGJoin_State[i] = "autojoin";
			end
			--play extra sound
			if(VBM_BGJ_S['extrasound'] and VBM_BGJoin_LastStatus[i] == "queued") then
				VBM_PlaySoundFile("Sound\\Event Sounds\\Event_wardrum_ogre.wav");
			end
			--show frame
			local frame = getglobal("VBMBGJoinFrameBG"..i);
			if(VBM_BGJoin_State[i] == "hide") then
				if(VBM_BGJ_S['collapse']) then
					frame:SetHeight(1);
				else
					frame:SetHeight(16);
				end
				frame:Hide();
			else
				highestbg = i;
				bgshown = bgshown + 1;
				frame:Show();
				frame:SetHeight(16);
				VBM_BGJoin_UpdateText(i)
			end	
		else
			local frame = getglobal("VBMBGJoinFrameBG"..i);
			if(VBM_BGJ_S['collapse']) then
				frame:SetHeight(1);
			else
				frame:SetHeight(16);
			end
			frame:Hide();
			--reset vars
			VBM_BGJoin_Status[i] = "";
			VBM_BGJoin_State[i] = "";
		end
		--track last status
		VBM_BGJoin_LastStatus[i] = status;
	end
	--auto show
	local showvalue = 0;
	if(VBM_BGJ_S['hide']) then showvalue = bgshown;	else showvalue = bgsready; end
	
	if(showvalue > 0) then
		VBMBGJoinFrame:Show();
	else
		if(not VBMBGJoinFrame.forced) then
			VBMBGJoinFrame:Hide();
		end
	end
	--auto set height
	if(VBM_BGJ_S['collapse']) then
		VBMBGJoinFrame:SetHeight(24+bgshown*16);
	else
		VBMBGJoinFrame:SetHeight(24+highestbg*16);
	end
end

function VBM_BGJoin_UpdateText(id)
	--get vars
	local status, mapName, instanceID = GetBattlefieldStatus(id);
	local time = math.floor(GetBattlefieldPortExpiration(id));
	local textframe = getglobal("VBMBGJoinFrameBG"..id.."Text");
	if(time > 59) then
		local sek = math.fmod(time,60);
		if(sek < 10) then
			time = math.floor(time/60)..":0"..sek;
		else
			time = math.floor(time/60)..":"..sek;
		end
	else
		time = time.."s";
	end
	--handle autojoin
	if(VBM_BGJoin_State[id] == "autojoin") then
		local left = VBM_BGJoin_AutoJoin[id] - math.floor(GetTime());
		VBM_BGJoin_Status[id] = "Auto ("..left..")";
		getglobal("VBMBGJoinFrameBG"..id.."Join"):SetText("Stop");
		if(left <= 0) then
			VBM_BGJoin_State[id] = "";
			VBM_BGJoin_AcceptJoin(id);
		end
	else
		getglobal("VBMBGJoinFrameBG"..id.."Join"):SetText("Join");
	end
	--show text
	textframe:SetText(mapName.." "..instanceID.." ("..time..") "..VBM_BGJoin_Status[id]);
	--play sound then 15 sec left
	
end

function VBM_BGJoin_AcceptJoin(bg)
	if(VBM_BGJoin_State[bg] == "autojoin") then
		VBM_BGJoin_State[bg] = "";
		VBM_BGJoin_Status[bg] = "";
	else
		VBM_BGJoin_Status[bg] = "Joining";
		AcceptBattlefieldPort(bg,1);
	end
end

function VBM_BGJoin_HideMenu()
	local info = {};
	if(UIDROPDOWNMENU_MENU_LEVEL==1) then
		info = {};
		_,info.text,_ = GetBattlefieldStatus(VBM_BGJoin_BgMenu);
		info.isTitle = 1;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Leave Queue";
		info.notCheckable = 1;
		info.func = function() VBM_BGJoin_Status[VBM_BGJoin_BgMenu] = "Leaving"; AcceptBattlefieldPort(VBM_BGJoin_BgMenu,0); end;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
	end
end

--[[
	********************************************************************
	********************************************************************
	Option Frame
	********************************************************************
	********************************************************************
]]--

function VBM_BGJoin_Option_OnShow()
	VBMBGJoinFrameOptionsInfoText:SetText("RightClick Hide button\nfor option to leave queue");
	VBMBGJoinFrameOptionsCheckLockedText:SetText("Lock Frame");
	VBMBGJoinFrameOptionsCheckCollapseText:SetText("Auto Collapse");
	VBMBGJoinFrameOptionsCheckAutoJoinText:SetText("Auto Join");
	VBMBGJoinFrameOptionsCheckAutoReleaseText:SetText("Auto Release");
	VBMBGJoinFrameOptionsCheckHideText:SetText("Hide if all BGs are hidden");
	VBMBGJoinFrameOptionsCheckBGSoundText:SetText("Handle Sound in Background");
	VBMBGJoinFrameOptionsCheckExtraSoundText:SetText("Extra Wardrum Sound");
	if(VBM_BGJ_S['locked']) then
		VBMBGJoinFrameOptionsCheckLocked:SetChecked(1);
	end
	if(VBM_BGJ_S['collapse']) then
		VBMBGJoinFrameOptionsCheckCollapse:SetChecked(1);
	end
	if(VBM_BGJ_S['autojoin']) then
		VBMBGJoinFrameOptionsCheckAutoJoin:SetChecked(1);
	end
	if(VBM_BGJ_S['release']) then
		VBMBGJoinFrameOptionsCheckAutoRelease:SetChecked(1);
	end
	if(VBM_BGJ_S['hide']) then
		VBMBGJoinFrameOptionsCheckHide:SetChecked(1);
	end
	if(VBM_GetS("LFGBGSoundHandling")) then
		VBMBGJoinFrameOptionsCheckBGSound:SetChecked(1);
	end
	if(VBM_BGJ_S['extrasound']) then
		VBMBGJoinFrameOptionsCheckExtraSound:SetChecked(1);
	end
	VBMBGJoinFrameOptionsAutoJoinTime:SetText(VBM_BGJ_S['autojointime']);
end

function VBM_BGJoin_Option_Update()
	if(VBMBGJoinFrameOptionsCheckLocked:GetChecked()) then
		VBM_BGJ_S['locked'] = true;
	else
		VBM_BGJ_S['locked'] = false;
	end
	if(VBMBGJoinFrameOptionsCheckCollapse:GetChecked()) then
		VBM_BGJ_S['collapse'] = true;
	else
		VBM_BGJ_S['collapse'] = false;
	end
	if(VBMBGJoinFrameOptionsCheckAutoJoin:GetChecked()) then
		VBM_BGJ_S['autojoin'] = true;
	else
		VBM_BGJ_S['autojoin'] = false;
	end
	if(VBMBGJoinFrameOptionsCheckAutoRelease:GetChecked()) then
		VBM_BGJ_S['release'] = true;
	else
		VBM_BGJ_S['release'] = false;
	end
	if(VBMBGJoinFrameOptionsCheckHide:GetChecked()) then
		VBM_BGJ_S['hide'] = true;
	else
		VBM_BGJ_S['hide'] = false;
	end
	if(VBMBGJoinFrameOptionsCheckBGSound:GetChecked()) then
		VBMSettings['LFGBGSoundHandling'] = 1;
	else
		VBMSettings['LFGBGSoundHandling'] = 0;
	end
	if(VBMBGJoinFrameOptionsCheckExtraSound:GetChecked()) then
		VBM_BGJ_S['extrasound'] = true;
	else
		VBM_BGJ_S['extrasound'] = false;
	end
	--auto join time
	local nr = tonumber(VBMBGJoinFrameOptionsAutoJoinTime:GetText());
	if(nr and nr < 1) then nr = 1; end
	if(nr and nr > 60) then nr = 60; end
	if(nr) then VBM_BGJ_S['autojointime'] = nr end
	
end