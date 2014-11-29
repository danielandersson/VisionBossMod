--[[
		RangeChecker
		Part of VBM by Vislike @ EU Stormscale
		
		
]]--

local rc_slidetime = 0.2;
local rc_scaletime = 0.3;

function VBM_RangeCheck_Off()
	vbm_print("|cFF8888CC<VisionBossMod> RangeChecker Disabled (/rcon)");
	VBMRangeCheckFrame:Hide();
end

function VBM_RangeCheck_On()
	vbm_print("|cFF8888CC<VisionBossMod> RangeChecker Enabled (/rcoff) (/rcmouse)");
	VBMRangeCheckFrame:Show();
end

function VBM_RC_Auto_Hide()
	if(VBMRangeCheckFrame.autoshowed) then
		VBMRangeCheckFrame.autoshowed = nil;
		VBMRangeCheckFrame:Hide();
	end
end

function VBM_RC_Auto_Show(distance,count)
	if(not VBMRangeCheckFrame:IsShown() and VBM_GetS("AutoRangeCheck")) then
		VBMRangeCheckFrame.autoshowed = true;
		VBMRangeCheckFrame:Show();
		VBM_RC_Settings['distance'] = distance;
		VBM_RC_Settings['count'] = count;
	end
end

function VBM_RangeCheck_Toggle()
	if(VBMRangeCheckFrame:IsShown()) then
		VBMRangeCheckFrame:Hide();
	else
		VBMRangeCheckFrame:Show();
	end
end

function VBM_RangeCheck_Init()
	SlashCmdList["VisionBossMod_RangeCheckon"] = VBM_RangeCheck_On;
	SLASH_VisionBossMod_RangeCheckon1 = "/rcon";
	SlashCmdList["VisionBossMod_RangeCheckoff"] = VBM_RangeCheck_Off;
	SLASH_VisionBossMod_RangeCheckoff1 = "/rcoff";
	SlashCmdList["VisionBossMod_RangeCheckmouse"] = VBM_RC_ToggleIgnoreMouse;
	SLASH_VisionBossMod_RangeCheckmouse1 = "/rcmouse";
	
	if(VBM_RC_Settings and VBM_RC_Settings.dock) then
		VBM_RC_Settings = nil;
		vbm_printc("RangeChecker: Settings Cleared for new Version");
	end
	
	if(not VBM_RC_Settings) then
		VBM_RC_Settings = {
			['locked'] = 0,
			['move'] = 1,
			['pets'] = 0,
			['distance'] = 10,
			['count'] = 1,
			['imouse'] = 0,
			['scalegreen'] = 0.6,
			['scalered'] = 1.2,
		};
	end
	--setup ignore mouse
	VBM_RangeCheck_UpdateSettings();
	
	UIDropDownMenu_Initialize(VBMRangeCheckDropDownMenu, VBM_RC_DropDownMenuOnLoad, "MENU");
end

local function RC_DoCheck(unitid)
	if(VBM_RC_Settings['distance']==10) then
		return CheckInteractDistance(unitid,3);
	elseif(VBM_RC_Settings['distance']==11) then
		return CheckInteractDistance(unitid,2);
	elseif(VBM_RC_Settings['distance']==20) then
		if(IsItemInRange(VBM_CURRENT_BANDAGE,unitid) == 1) then
			return true;
		else
			return false;
		end
	elseif(VBM_RC_Settings['distance']==28) then
		return CheckInteractDistance(unitid,1);
	elseif(VBM_RC_Settings['distance']==40) then
		return UnitInRange(unitid);
	else
		VBM_RC_ERROR = true;
		return false;
	end
end

local function RC_AddToTable(t, unitid, unitidpet)
	if(UnitExists(unitid) and RC_DoCheck(unitid) and not UnitIsDeadOrGhost(unitid)) then
		table.insert(t, ""..UnitName(unitid));
	end
	if(VBM_RC_GetS("pets") and UnitExists(unitidpet) and RC_DoCheck(unitidpet) and not UnitIsDeadOrGhost(unitidpet)) then
		table.insert(t, ""..UnitName(unitidpet));
	end
end

local function rc_animate_green(self, fraction)
	local x,y = VBMRangeCheckAnchorGreen:GetCenter();
	local x2,y2 = VBMRangeCheckAnchorRed:GetCenter();
	return "CENTER", VBMRangeCheckAnchorGreen, "CENTER", (sin(fraction*90)*(x2-x))/self:GetScale(), (sin(fraction*90)*(y2-y))/self:GetScale();
end

local function rc_animate_red(self, fraction)
	local x,y = VBMRangeCheckAnchorRed:GetCenter();
	local x2,y2 = VBMRangeCheckAnchorGreen:GetCenter();
	return "CENTER", VBMRangeCheckAnchorRed, "CENTER", (sin(fraction*90)*(x2-x))/self:GetScale(), (sin(fraction*90)*(y2-y))/self:GetScale();
end

local function rc_animate_scale(self, fraction)
	self:GetParent():SetScale((sin(fraction*90)*(VBM_RC_Settings.scalered-VBM_RC_Settings.scalegreen))+VBM_RC_Settings.scalegreen);
	return 1;
end

local function rc_animate_complete_green(self)
	self:SetPoint(rc_animate_red(self,0));
	self.MovedTo = "red";
	--self.animating = nil;
end

local function rc_animate_complete_red(self)
	self:SetPoint(rc_animate_green(self,0));
	self.MovedTo = "green";
	--self.animating = nil;
end

local function rc_scale_complete_green(self)
	--self:SetScale(rc_animate_scale(self,1));
	self:GetParent().ScaleTo = "red";
	--self.isscaling = nil;
end

local function rc_scale_complete_red(self)
	--self:SetScale(rc_animate_scale(self,0));
	self:GetParent().ScaleTo = "green";
	--self.isscaling = nil;
end

local AnimDataTable = {
	Green_Slide = {
		totalTime = rc_slidetime,
		updateFunc = "SetPoint",
		getPosFunc = rc_animate_green,
	},
	Red_Slide = {
		totalTime = rc_slidetime,
		updateFunc = "SetPoint",
		getPosFunc = rc_animate_red,
	},
	Scale_Slide = {
		totalTime = rc_scaletime,
		updateFunc = "SetScale",
		getPosFunc = rc_animate_scale,
	},
}

function VBM_RangeCheck_OnUpdate(self,elapsed)
	--dont update to fast
	self.lastupdate = self.lastupdate + elapsed;
	if(self.lastupdate > 0.1) then
		self.lastupdate = 0;
	else
		return
	end
	--Update title text
	VBMRangeCheckFrameHeaderText:SetText("RangeChecker ("..VBM_RC_Settings['distance']..","..VBM_RC_Settings['count']..")");
	--core range check function here
	local unitid, unitidpet, i;
	local player_table = {};
	VBM_RC_ERROR = false;
	--first for raid, else for party
	if(GetNumGroupMembers()>0) then
		for i = 1, GetNumGroupMembers() do
			unitid = "raid"..i; unitidpet = "raidpet"..i;
			--for ranges dont include player
			if(not UnitIsUnit(unitid, "player")) then
				 RC_AddToTable(player_table, unitid, unitidpet);
			end
		end	
	elseif(GetNumGroupMembers()>0) then
		for i = 1, GetNumGroupMembers() do
			unitid = "party"..i; unitidpet = "partypet"..i;
			RC_AddToTable(player_table, unitid, unitidpet);
		end	
	end
	RC_AddToTable(player_table,nil,"pet");

	--clear tooltip
	VBMRangeCheckFrameMessage1.tooltip = nil;
	
	if(VBM_RC_ERROR) then
		VBMRangeCheckFrameMessage1Text:SetText("Distance Error");
		VBMRangeCheckFrame:SetBackdropColor(1,0,0);
	else
		--check if close to setted players
		local color;
		if(#player_table < VBM_RC_Settings.count) then
			VBMRangeCheckFrame:SetBackdropColor(0,1,0);
			color = "green";
		else
			VBMRangeCheckFrame:SetBackdropColor(1,0,0);
			color = "red";
		end
		
		--animate move frame
		if(VBM_RC_GetS("move")) then
			if(color ~= self.MovedTo and not self.animating and not self.isMoving) then
				--self.animating = true;
				if(self.MovedTo == "green") then
					VBM_SetUpAnimation(self,AnimDataTable.Green_Slide,rc_animate_complete_green);
				else
					VBM_SetUpAnimation(self,AnimDataTable.Red_Slide,rc_animate_complete_red);
				end
			end
		else --if not moving allowed make sure its in correct place
			if(self.MovedTo ~= "green") then
				self:SetPoint(rc_animate_green(self,0));
				self.MovedTo = "green";
				self.animating = nil;
			end
		end
		
		--scale frame
		local scaleframe = VBMRangeCheckFrameScaleAni;
		if(color ~= self.ScaleTo and not scaleframe.animating) then
			if(self.ScaleTo == "green") then
				VBM_SetUpAnimation(scaleframe,AnimDataTable.Scale_Slide,rc_scale_complete_green);
			else
				VBM_SetUpAnimation(scaleframe,AnimDataTable.Scale_Slide,rc_scale_complete_red,1);
			end
		end
		
		--setup text
		if(#player_table == 0) then
			VBMRangeCheckFrameMessage1Text:SetText("OK");
		elseif(#player_table < 5) then
			table.sort(player_table);
			VBMRangeCheckFrameMessage1Text:SetText(table.concat(player_table,", "));
		else
			local names = table.concat(player_table,"\n");
			VBMRangeCheckFrameMessage1Text:SetText("Close to "..#player_table.."!");
			--update tooltip
			VBMRangeCheckFrameMessage1.tooltip = names;
			--live update if tooltip is shown
			if(GameTooltip:GetOwner()==VBMRangeCheckFrameMessage1) then
				GameTooltip:SetText(VBMRangeCheckFrameMessage1.tooltip);
			end
		end
	end
end


--[[ ********************************
			SETTINGS
	 ********************************
]]--

function VBM_RangeCheck_UpdateSettings()
	--set if we can interact with mouse
	if(VBM_RC_Settings['imouse']==1) then
		VBMRangeCheckFrame:EnableMouse(0);
		VBMRangeCheckFrameMessage1:EnableMouse(0);
	else
		VBMRangeCheckFrame:EnableMouse(1);
		VBMRangeCheckFrameMessage1:EnableMouse(1);
	end
	
	if(VBMRangeCheckFrame.ScaleTo == "green") then
		VBMRangeCheckFrame:SetScale(VBM_RC_Settings['scalegreen']);
	end
	
	if(VBMRangeCheckFrame.ScaleTo == "red") then
		VBMRangeCheckFrame:SetScale(VBM_RC_Settings['scalered']);
	end
end

function VBM_RC_GetS(s)
	if(VBM_RC_Settings[s] == 1) then
		return true;
	elseif(VBM_RC_Settings[s] == 0) then
		return false;
	else
		return VBM_RC_Settings[s];
	end
end

function VBM_RC_Toggle(self)
	local s = self.value;
	if(VBM_RC_Settings[s]==1) then
		VBM_RC_Settings[s] = 0;
		if(VBM_GetS("EchoSettingsChanged")) then
			vbm_printc("RangeChecker: Setting |cFFFFFFFF"..s.."|cFF8888CC set to |cFFFFFFFFoff");
		end
	else
		VBM_RC_Settings[s] = 1;
		if(VBM_GetS("EchoSettingsChanged")) then
			vbm_printc("RangeChecker: Setting |cFFFFFFFF"..s.."|cFF8888CC set to |cFFFFFFFFon");
		end
	end
end

function VBM_RC_ToggleIgnoreMouse()
	if(VBM_RC_Settings['imouse']==1) then
		VBM_RC_Settings['imouse'] = 0;
		vbm_printc("RangeChecker: Mouse enabled again");
	else
		VBM_RC_Settings['imouse'] = 1;
		vbm_printc("RangeChecker: Mouse disabled, /rcmouse to enable again");
	end
	VBM_RangeCheck_UpdateSettings();
end

function VBM_RC_SetDistance(self)
	if(self.value) then
		VBM_RC_Settings['distance'] = self.value;
	end
end

function VBM_RC_SetCount(self)
	if(self.value) then
		VBM_RC_Settings['count'] = self.value;
	end
end

function VBM_RC_SetGreenScale(self)
	if(self.value) then
		VBM_RC_Settings['scalegreen'] = self.value;
	end
	if(VBMRangeCheckFrame.ScaleTo == "green") then
		VBMRangeCheckFrame:SetScale(self.value);
	end
end

function VBM_RC_SetRedScale(self)
	if(self.value) then
		VBM_RC_Settings['scalered'] = self.value;
	end
	if(VBMRangeCheckFrame.ScaleTo == "red") then
		VBMRangeCheckFrame:SetScale(self.value);
	end
end

function VBM_RangeCheck_ToggleAnchors()
	if(VBMRangeCheckAnchorGreen:IsShown()) then
		VBMRangeCheckAnchorGreen:Hide();
		VBMRangeCheckAnchorRed:Hide();
	else
		VBMRangeCheckAnchorGreen:Show();
		VBMRangeCheckAnchorRed:Show();
	end
end

function VBM_RC_DropDownMenuOnLoad()
	local info = {};
	
	if(UIDROPDOWNMENU_MENU_LEVEL==1) then
		info = {};
		info.text = "Toggle Anchors";
		info.notCheckable = 1;
		info.func = VBM_RangeCheck_ToggleAnchors;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Lock Dragging";
		info.keepShownOnClick = 1;
		info.checked = VBM_RC_GetS("locked");
		info.value = "locked";
		info.func = VBM_RC_Toggle;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Include Pets";
		info.tooltipTitle = info.text;
		info.tooltipText = "Include pets in RangeCheck";
		info.keepShownOnClick = 1;
		info.checked = VBM_RC_GetS("pets");
		info.value = "pets";
		info.func = VBM_RC_Toggle;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Distance";
		info.notCheckable = 1;
		info.hasArrow = 1;
		info.value = "DistanceMenu";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Near Me";
		info.tooltipTitle = info.text;
		info.tooltipText = "How many should be near you before it turns red.";
		info.notCheckable = 1;
		info.hasArrow = 1;
		info.value = "CountMenu";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Green Scale";
		info.notCheckable = 1;
		info.hasArrow = 1;
		info.value = "GreenScaleMenu";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Red Scale";
		info.notCheckable = 1;
		info.hasArrow = 1;
		info.value = "RedScaleMenu";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Move Red/Green";
		info.tooltipTitle = info.text;
		info.tooltipText = "Use 2 anchors instead of 1, move frame to Red anchor then it turns Red and back to green anchor then it turns Green.";
		info.checked = VBM_RC_GetS("move");
		info.value = "move";
		info.func = VBM_RC_Toggle;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Ignore Mouse";
		info.tooltipTitle = info.text;
		info.tooltipText = "Make so you can click straight through this frame";
		info.keepShownOnClick = 1;
		info.checked = VBM_RC_GetS("imouse");
		info.func = VBM_RC_ToggleIgnoreMouse;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Auto RangeChecker";
		info.tooltipTitle = info.text;
		info.tooltipText = "Auto show RangeChecker on bosses its used on, and auto hides it after";
		info.keepShownOnClick = 1;
		info.checked = VBM_GetS("AutoRangeCheck");
		info.func = VBM_Toggle_Setting;
		info.value = "AutoRangeCheck";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Hide RangeChecker";
		info.tooltipTitle = info.text;
		info.tooltipText = "Hide this frame, same as /rcoff";
		info.notCheckable = 1;
		info.func = VBM_RangeCheck_Off;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
	end
			if(UIDROPDOWNMENU_MENU_VALUE == "DistanceMenu") then
				info = {};
				info.text = "Distance";
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "10 yrd";
				info.checked = (VBM_RC_Settings['distance']==10);
				info.value = 10;
				info.func = VBM_RC_SetDistance;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "11 yrd";
				info.checked = (VBM_RC_Settings['distance']==11);
				info.value = 11;
				info.func = VBM_RC_SetDistance;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "20 yrd";
				info.checked = (VBM_RC_Settings['distance']==20);
				info.tooltipTitle = info.text;
				info.tooltipText = "Require you to have atleast 1 ["..VBM_CURRENT_BANDAGE.."] in inventory";
				info.value = 20;
				info.func = VBM_RC_SetDistance;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "28 yrd";
				info.checked = (VBM_RC_Settings['distance']==28);
				info.tooltipTitle = nil;
				info.tooltipText = nil;
				info.value = 28;
				info.func = VBM_RC_SetDistance;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "40 yrd";
				info.checked = (VBM_RC_Settings['distance']==40);
				info.value = 40;
				info.func = VBM_RC_SetDistance;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
			
			if(UIDROPDOWNMENU_MENU_VALUE == "CountMenu") then
				info = {};
				info.text = "Count";
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "1";
				info.checked = (VBM_RC_Settings['count']==1);
				info.value = 1;
				info.func = VBM_RC_SetCount;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "2";
				info.checked = (VBM_RC_Settings['count']==2);
				info.value = 2;
				info.func = VBM_RC_SetCount;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "3";
				info.checked = (VBM_RC_Settings['count']==3);
				info.value = 3;
				info.func = VBM_RC_SetCount;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "4";
				info.checked = (VBM_RC_Settings['count']==4);
				info.value = 4;
				info.func = VBM_RC_SetCount;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "5";
				info.checked = (VBM_RC_Settings['count']==5);
				info.value = 5;
				info.func = VBM_RC_SetCount;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
			
			if(UIDROPDOWNMENU_MENU_VALUE == "RedScaleMenu") then
				info = {};
				info.text = "Red Scale";
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.func = VBM_RC_SetRedScale;
				info.text = "0.5";
				info.checked = (VBM_RC_Settings['scalered']==0.5);
				info.value = 0.5;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.6";
				info.checked = (VBM_RC_Settings['scalered']==0.6);
				info.value = 0.6;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.7";
				info.checked = (VBM_RC_Settings['scalered']==0.7);
				info.value = 0.7;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.8";
				info.checked = (VBM_RC_Settings['scalered']==0.8);
				info.value = 0.8;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.9";
				info.checked = (VBM_RC_Settings['scalered']==0.9);
				info.value = 0.9;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.0";
				info.checked = (VBM_RC_Settings['scalered']==1.0);
				info.value = 1.0;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.1";
				info.checked = (VBM_RC_Settings['scalered']==1.1);
				info.value = 1.1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.2";
				info.checked = (VBM_RC_Settings['scalered']==1.2);
				info.value = 1.2;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.3";
				info.checked = (VBM_RC_Settings['scalered']==1.3);
				info.value = 1.3;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.4";
				info.checked = (VBM_RC_Settings['scalered']==1.4);
				info.value = 1.4;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.5";
				info.checked = (VBM_RC_Settings['scalered']==1.5);
				info.value = 1.5;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.6";
				info.checked = (VBM_RC_Settings['scalered']==1.6);
				info.value = 1.6;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.7";
				info.checked = (VBM_RC_Settings['scalered']==1.7);
				info.value = 1.7;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
			end
			if(UIDROPDOWNMENU_MENU_VALUE == "GreenScaleMenu") then
				info = {};
				info.text = "Green Scale";
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.func = VBM_RC_SetGreenScale;
				info.text = "0.3";
				info.checked = (VBM_RC_Settings['scalegreen']==0.3);
				info.value = 0.3;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.4";
				info.checked = (VBM_RC_Settings['scalegreen']==0.4);
				info.value = 0.4;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.5";
				info.checked = (VBM_RC_Settings['scalegreen']==0.5);
				info.value = 0.5;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.6";
				info.checked = (VBM_RC_Settings['scalegreen']==0.6);
				info.value = 0.6;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.7";
				info.checked = (VBM_RC_Settings['scalegreen']==0.7);
				info.value = 0.7;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.8";
				info.checked = (VBM_RC_Settings['scalegreen']==0.8);
				info.value = 0.8;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.9";
				info.checked = (VBM_RC_Settings['scalegreen']==0.9);
				info.value = 0.9;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.0";
				info.checked = (VBM_RC_Settings['scalegreen']==1.0);
				info.value = 1.0;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.1";
				info.checked = (VBM_RC_Settings['scalegreen']==1.1);
				info.value = 1.1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.2";
				info.checked = (VBM_RC_Settings['scalegreen']==1.2);
				info.value = 1.2;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.3";
				info.checked = (VBM_RC_Settings['scalegreen']==1.3);
				info.value = 1.3;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.4";
				info.checked = (VBM_RC_Settings['scalegreen']==1.4);
				info.value = 1.4;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.5";
				info.checked = (VBM_RC_Settings['scalegreen']==1.5);
				info.value = 1.5;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
			
end
