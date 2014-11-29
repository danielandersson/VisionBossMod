--[[
	********************************************************************
	********************************************************************
	Timers
	
	********************************************************************
	********************************************************************

	Use BossMods:
	VBM_BossTimer(time,name,texture,nooveride)
	VBM_RemoveTimer(name)
	VBM_AddMoreTime(name,sec)
	VBM_ChangeTimerName(oldname,newname)
	
	Force start timer:
	VBM_StartTimer(time,name,texture,nooveride)
]]--

function VBM_BossTimer(time,name,texture,nooveride)
	if(VBM_GetS("AcceptTimers")) then
		VBM_StartTimer(time,name,texture,nooveride);
	end
end

local VBM_TIMERS = {};
local VBM_TIMER_MAXSCALE = 1.8;
local VBM_TIMER_SCALE = 1;
local VBM_TIMER_BACKDROPALPHA = 0.8;

local VBM_Timers_Settings; --for options
local animate_time = 0.5;

local function FlyingToggle()
	if(VBM_Timers_GetS("flyingtimers")) then
		if(VBMTimersAchorFrame:IsShown()) then
			VBMTimersFlyingAchorFrame:Show();
		else
			VBMTimersFlyingAchorFrame:Hide();
		end
	else
		VBMTimersFlyingAchorFrame:Hide();
	end
end

function VBM_Timers_Toggle()
	if(VBMTimersAchorFrame:IsShown()) then
		VBMTimersAchorFrame:Hide();
	else
		VBMTimersAchorFrame:Show();
	end
	
	FlyingToggle();
end

function VBM_Timers_Init()
	if(not _G["VBM_Timers_Settings"]) then
		_G["VBM_Timers_Settings"] = {
			["locked"] = 0,
			['acceptbroadcast'] = 1,
			['scale'] = 1,
			['maxscale'] = 1.8,
		};
	end
	
	VBM_Timers_Settings = _G["VBM_Timers_Settings"];
	
	if(not VBM_Timers_Settings.disablemouse) then VBM_Timers_Settings.disablemouse=0; end
	if(not VBM_Timers_Settings.flyingtimers) then VBM_Timers_Settings.flyingtimers=0; end
	if(not VBM_Timers_Settings.flyingflipsmal) then VBM_Timers_Settings.flyingflipsmal=0; end
	if(not VBM_Timers_Settings.flyingflipbig) then VBM_Timers_Settings.flyingflipbig=0; end
	if(not VBM_Timers_Settings.barfillup) then VBM_Timers_Settings.barfillup=0; end
	
	UIDropDownMenu_Initialize(VBMTimersDropDownMenu, VBM_Timers_DropDownMenu, "MENU");
	VBM_Timers_SetScale();
	--VBM_Timers_Toggle(); --show anchor at start
end

function VBM_Test_Timers()
	VBM_StartTimer(120,"Long Timer"..random(1,100),"Interface\\Icons\\ability_druid_challangingroar")
	VBM_StartTimer(5,"Quicken"..random(1,100))
	VBM_StartTimer(30,"Mount Drop"..random(1,100),"Interface\\Icons\\inv_misc_qirajicrystal_05")
	VBM_StartTimer(15,"Sprint"..random(1,100),"Interface\\Icons\\ability_rogue_sprint")
end

--[[***************************
		Handle Timers
***************************]]--

function VBM_RemoveTimer(name)
	local i;
	for i=1,#VBM_TIMERS do
		if(VBM_TIMERS[i].name == name) then
			VBM_TIMERS[i].frame:Hide();
			VBM_TIMERS[i].frame.lastpos = nil;
			table.remove(VBM_TIMERS,i);
			VBM_UpdateTimerPositions();
			break;
		end
	end
end

function VBM_ChangeTimerName(oldname,newname)
	local i;
	for i=1,#VBM_TIMERS do
		if(VBM_TIMERS[i].name == oldname) then
			VBM_TIMERS[i].name = newname;
			VBM_TIMERS[i].frame.timername = newname;
			VBM_TIMERS[i].frame.bartext:SetText(newname);
			break;
		end
	end
end

function VBM_AddMoreTime(name,sec)
	local i;
	for i=1,#VBM_TIMERS do
		if(VBM_TIMERS[i].name == name) then
			local stop = VBM_TIMERS[i].stop;
			local texture = false;
			if(VBM_TIMERS[i].texture) then
				texture = VBM_TIMERS[i].texture;
			end
			VBM_RemoveTimer(name);
			VBM_StartTimer(stop+sec-GetTime(),name,texture);
			break;
		end
	end
end

function VBM_StartTimer(time,name,texture,nooveride)
	local i;
	if(not name) then name = "Unnamed"; end
	if(nooveride) then
		--if a timer with name allready exists then return
		for i=1,#VBM_TIMERS do
			if(VBM_TIMERS[i].name == name) then
				return;
			end
		end
	end
	--******** GATHER DATA *********
	local data = {};
	data.start = GetTime();
	data.stop = time+GetTime();
	data.name = name;
	--remove a timer with name if it exists
	VBM_RemoveTimer(name);
	if(texture) then
		data.texture = texture;
	end
	--find first ready timer
	local frames = {};
	for i=1,#VBM_TIMERS do
		frames[VBM_TIMERS[i].framenr] = true;
	end
	local framenr = false;
	for i=1,10 do
		if(not frames[i]) then
			framenr = i;
			break;
		end
	end
	if(not framenr) then
		vbm_verbosec("ERROR: No ready Timer avablie");
		return;
	end
	data.framenr = framenr;
	data.frame = getglobal("VBMTimer"..framenr);
	
	--******** ADD TO LIST *********
	-- timer list is a heap, add new
	i = #VBM_TIMERS+1
	while(i > 1) do
		if(data.stop < VBM_TIMERS[i-1].stop) then
			i = i - 1;
		else
			break
		end
	end
	table.insert(VBM_TIMERS, i, data);
	
	--******** START TIMER *********
	--start actucal timer frame
	data.frame.start = data.start;
	data.frame.stop = data.stop;
	data.frame.timername = data.name;
	data.frame.bartext:SetText(data.name);
	if(data.texture) then
		data.frame.texture:SetTexture(data.texture);
		data.frame.texture:Show();
	else
		data.frame.texture:Hide();
	end
	data.frame:Show();
	VBM_UpdateTimerPositions();
end

function VBM_Timer_Click(self)
	if(IsShiftKeyDown()) then
		vbm_sendchat("Timer: "..self:GetParent().bartext:GetText().." ("..self:GetParent().bartime:GetText()..")");
		local name = self:GetParent().timername;
		local tl = math.ceil(self:GetParent().stop-GetTime());
		vbm_send_synced("VBMTIMER "..tl.." "..name);
	end
	if(IsControlKeyDown()) then
		VBM_RemoveTimer(self:GetParent().timername);
	end
end

function VBM_Timers_Recive_Broadcast(text)
	if(not VBM_Timers_GetS("acceptbroadcast")) then return; end
	
	local found,p1,p2;
	found,_,p1,p2 = string.find(text,"(%d+) (.+)");
	if(found) then
		VBM_StartTimer(tonumber(p1),p2,nil,true);
	end
end


--[[***************************
		Graphical
***************************]]--


function VBM_Timers_OnTimerUpdate(self)
	local now = GetTime();
	local timeleft = self.stop - now;
	--*****FADING*****
	if(now < self.start+0.5) then
		--fade up
		local alpha = (now-self.start)/((self.start+0.5)-self.start);
		self:SetAlpha(alpha);
	else
		self:SetAlpha(1);
	end
	if(timeleft < -2) then
		--fade out
		local alpha = ((-2)-timeleft)/((-2)-(-2.5));
		self:SetAlpha(1-alpha);
		if(timeleft < -2.5) then
			--timer has ended hide it
			VBM_RemoveTimer(self.timername);
		end
		return;
	end
	--*****SCALE*****
	if(timeleft > 10.1) then
		if(self:GetScale()~=VBM_TIMER_SCALE) then
			self:SetScale(VBM_TIMER_SCALE);
		end
	elseif(timeleft < 9.5) then
		if(self:GetScale()~=VBM_TIMER_MAXSCALE*VBM_TIMER_SCALE) then
			self:SetScale(VBM_TIMER_MAXSCALE*VBM_TIMER_SCALE);
		end
	else
		--make smooth scaleup
		local scale = (10.1-timeleft)/(10.1-9.5);
		self:SetScale( ((VBM_TIMER_MAXSCALE-1)*scale+1)*VBM_TIMER_SCALE );
	end
	--******FLYING TIMER TELL TO MOVE******
	if(VBM_Timers_GetS("flyingtimers") and timeleft < 10.1 and self.lastpos and self.lastpos >= 11) then
		VBM_UpdateTimerPositions();
	end
	--*****COLOR*****
	--update smooth color between 20 and 8
	local r,g,b = 0,0,0;
	if(timeleft > 20) then
		g = 1;
	elseif(timeleft < 8) then
		r = 1;
	else
		local colorperc = (20-timeleft)/(20-8);
		r,g,b = VBM_GetSmoothColor(1-colorperc);
	end
	--*****BACKDROP FLASH*****
	if(timeleft < 10) then
		local flashspeed = 1.5;
		local flashmax = 0.7;
		local bdc = math.fmod(10-timeleft,flashspeed);
		if(bdc >= flashspeed/2) then
			--flash back
			self:SetBackdropColor(flashmax-(flashmax*(bdc-(flashspeed/2))),0,0,VBM_TIMER_BACKDROPALPHA);
		else
			--flash to red
			self:SetBackdropColor(flashmax*bdc,0,0,VBM_TIMER_BACKDROPALPHA);
		end
	else
		self:SetBackdropColor(0,0,0,VBM_TIMER_BACKDROPALPHA);
	end
	--*****TIME*****
	local tl;
	if(timeleft < 0) then
		--blink text
		local blinkspeed = 0.8;
		local blink = math.fmod((-1)*timeleft,blinkspeed);
		if(blink < blinkspeed/2) then
			tl = "0.0";
		else
			tl = " ";
		end
	elseif(timeleft > 59) then
		tl = string.format("%d:%.2d",math.ceil(timeleft)/60,math.fmod(math.ceil(timeleft),60));
	elseif(timeleft <= 9.5) then
		tl = string.format("%.1f",timeleft);
	else
		tl = string.format("%d",math.ceil(timeleft));
	end
	--*******SET MOUSE STATUS*******
	if(VBM_Timers_GetS("disablemouse")) then
		self.bar:EnableMouse(0);
	else
		self.bar:EnableMouse(1);
	end
	--*****UPDATE BAR*****
	--calculate the % of the bar
	--if(now > self.stop) then now = self.stop; end
	local perc = math.floor((now-self.start)/(self.stop-self.start)*1000)/1000;
	self.bartime:SetText(tl);
	if(VBM_Timers_GetS("barfillup")) then
		self.bar:SetValue(perc*100);
	else
		self.bar:SetValue(100-perc*100);
	end
	self.bar:SetStatusBarColor(r,g,b);
end

function VBM_Timers_Move_Spark(self)
	local v = self:GetValue();
	local w = self:GetWidth();
	self.spark:ClearAllPoints();
	self.spark:SetPoint("CENTER",self,"LEFT",(w*v/100),0);
end

--[[***************************
		Animation
***************************]]--

local function VBM_Timer_Animate(self, fraction)
	self:ClearAllPoints();
	
	local x,y;
	
	if(self.lastpos and self.lastpos >= 11) then
		x,y = VBMTimersAchorFrame:GetCenter();
		if(VBM_Timers_GetS("flyingflipsmal")) then
			y = VBMTimersAchorFrame:GetTop();
			local offset = (self.lastpos-11)*13*self:GetScale();
			local offX,offY = self.oldX-x, self.oldY-(y+offset);
			return "BOTTOM",VBMTimersAchorFrame,"TOP",(sin(fraction*90)*offX)/self:GetScale(), ((sin(fraction*90)*offY+offset)/self:GetScale());
		else
			y = VBMTimersAchorFrame:GetBottom();
			local offset = (self.lastpos-11)*-13*self:GetScale();
			local offX,offY = self.oldX-x, self.oldY-(y+offset);
			return "TOP",VBMTimersAchorFrame,"BOTTOM",(sin(fraction*90)*offX)/self:GetScale(), ((sin(fraction*90)*offY+offset)/self:GetScale());
		end
	elseif(self.lastpos) then
		x,y = VBMTimersFlyingAchorFrame:GetCenter();
		if(VBM_Timers_GetS("flyingflipbig")) then
			y = VBMTimersFlyingAchorFrame:GetTop();
			local offset = (self.lastpos-1)*13*self:GetScale();
			local offX,offY = self.oldX-x, self.oldY-(y+offset);
			return "BOTTOM",VBMTimersFlyingAchorFrame,"TOP",(sin(fraction*90)*offX)/self:GetScale(), ((sin(fraction*90)*offY+offset)/self:GetScale());
		else
			y = VBMTimersFlyingAchorFrame:GetBottom();
			local offset = (self.lastpos-1)*-13*self:GetScale();
			local offX,offY = self.oldX-x, self.oldY-(y+offset);
			return "TOP",VBMTimersFlyingAchorFrame,"BOTTOM",(sin(fraction*90)*offX)/self:GetScale(), ((sin(fraction*90)*offY+offset)/self:GetScale());
		end
	end
	--for failsafe return center
	return "CENTER";
end

local function vbm_update_animation_poistion(frame,p1,a,p2,x,y)
	frame:SetPoint(p1,a,p2,x,y);
end

local AnimDataTable = {
	timer = {
		totalTime = animate_time,
		updateFunc = vbm_update_animation_poistion,
		getPosFunc = VBM_Timer_Animate,
	},
}

local function set_big_pos(self,pos)
	if(VBM_Timers_GetS("flyingflipbig")) then
		self:ClearAllPoints();
		self:SetPoint("BOTTOM",VBMTimersFlyingAchorFrame,"TOP",0,(pos-1)*13);
	else
		self:ClearAllPoints();
		self:SetPoint("TOP",VBMTimersFlyingAchorFrame,"BOTTOM",0,(pos-1)*-13);
	end
end

local function set_smal_pos(self,pos)
	if(VBM_Timers_GetS("flyingflipsmal")) then
		self:ClearAllPoints();
		self:SetPoint("BOTTOM",VBMTimersAchorFrame,"TOP",0,(pos-11)*13);
	else
		self:ClearAllPoints();
		self:SetPoint("TOP",VBMTimersAchorFrame,"BOTTOM",0,(pos-11)*-13);
	end
end

local function setup_xy(self)
	local x,y = self:GetCenter();
	if(self.lastpos >=11) then
		if(VBM_Timers_GetS("flyingflipsmal")) then
			y = self:GetBottom();
		else
			y = self:GetTop();
		end
	else
		if(VBM_Timers_GetS("flyingflipbig")) then
			y = self:GetBottom();
		else
			y = self:GetTop();
		end
	end
	self.oldX = x*self:GetScale();
	self.oldY = y*self:GetScale();
end

function VBM_UpdateTimerPositions()
	if(VBM_Timers_GetS("flyingtimers")) then
		--setup for animating timers
		local big,smal = 1,11;
		local i;
		for i=1,#VBM_TIMERS do
			if(VBM_TIMERS[i].frame.stop - GetTime() < 10.1) then
				--this should be setup to flying anchor
				if(VBM_TIMERS[i].frame.lastpos) then
					--it has a lastpos check if its been changed
					if(VBM_TIMERS[i].frame.lastpos ~= big) then
						--setup animate to correct spot
						VBM_TIMERS[i].frame.lastpos = big;
						setup_xy(VBM_TIMERS[i].frame);
						--vbm_print("Telling "..VBM_TIMERS[i].name.." to animate to "..VBM_TIMERS[i].frame.lastpos);
						VBM_SetUpAnimation(VBM_TIMERS[i].frame,AnimDataTable.timer,nil,true);
					end
				else
					--first time after its showed so just set it to correct spot
					set_big_pos(VBM_TIMERS[i].frame,big)
					VBM_TIMERS[i].frame.lastpos = big;
				end
				big = big + 1;
			else
				--this should be setup to normal anchor
				if(VBM_TIMERS[i].frame.lastpos) then
					--it has a lastpos check if its been changed
					if(VBM_TIMERS[i].frame.lastpos ~= smal) then
						--setup animate to correct spot
						VBM_TIMERS[i].frame.lastpos = smal;
						setup_xy(VBM_TIMERS[i].frame);
						--vbm_print("Telling "..VBM_TIMERS[i].name.." to animate to "..VBM_TIMERS[i].frame.lastpos);
						VBM_SetUpAnimation(VBM_TIMERS[i].frame,AnimDataTable.timer,nil,true);
					end
				else
					--first time after its showed so just set it to correct spot
					set_smal_pos(VBM_TIMERS[i].frame,smal)
					VBM_TIMERS[i].frame.lastpos = smal;
				end
				smal = smal + 1;
			end
		end
	else
		--do normal frame setup on 1 anchor
		local lastframe = VBMTimersAchorFrame;
		local i;
		for i=1,#VBM_TIMERS do
			VBM_TIMERS[i].frame:ClearAllPoints();
			VBM_TIMERS[i].frame:SetPoint("TOP",lastframe,"BOTTOM");
			lastframe = VBM_TIMERS[i].frame;
		end
	end
end

--[[***************************
		Settings Menu
***************************]]--

function VBM_Timers_DropDownMenu()
	local info = {};
	
	if(UIDROPDOWNMENU_MENU_LEVEL==1) then
		info = {};
		info.text = "Add Timer";
		info.notCheckable = 1;
		info.func = function() VBMTimersAddNew:Show() end;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Lock Dragging";
		info.keepShownOnClick = 1;
		info.checked = VBM_Timers_GetS("locked");
		info.func = VBM_Timers_Toggle_Setting;
		info.value = "locked";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Disable Mouse";
		info.tooltipTitle = info.text;
		info.tooltipText = "This makes it so the timers ignores the mouse and you can't broadcast or remove them with clicks.";
		info.keepShownOnClick = 1;
		info.checked = VBM_Timers_GetS("disablemouse");
		info.func = VBM_Timers_Toggle_Setting;
		info.value = "disablemouse";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);

		info = {};
		info.text = "Accept Broadcasts";
		info.tooltipTitle = info.text;
		info.tooltipText = "Catch timers pasted in chat (with shift clicks)";
		info.keepShownOnClick = 1;
		info.checked = VBM_Timers_GetS("acceptbroadcast");
		info.func = VBM_Timers_Toggle_Setting;
		info.value = "acceptbroadcast";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Scale";
		info.notCheckable = 1;
		info.hasArrow = 1;
		info.value = "ScaleMenu";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Short time left scale";
		info.notCheckable = 1;
		info.hasArrow = 1;
		info.value = "ShortScaleMenu";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Flying Timers";
		info.tooltipTitle = info.text;
		info.tooltipText = "Enable two anchors and flying timers.";
		info.keepShownOnClick = 1;
		info.checked = VBM_Timers_GetS("flyingtimers");
		info.hasArrow = 1;
		info.func = function() if(VBM_Timers_Settings.flyingtimers==1) then VBM_Timers_Settings.flyingtimers=0; else VBM_Timers_Settings.flyingtimers=1; end
							FlyingToggle(); VBM_UpdateTimerPositions(); end;
		info.value = "FlyingTimerMenu";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Fill bars up";
		info.tooltipTitle = info.text;
		info.tooltipText = "Fill bars up when time elapses instead of decaying them.";
		info.keepShownOnClick = 1;
		info.checked = VBM_Timers_GetS("barfillup");
		info.func = VBM_Timers_Toggle_Setting;
		info.value = "barfillup";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Info/Help/Test Bars";
		info.tooltipTitle = info.text;
		info.tooltipText = "To show test timers click this.\n(Shift+Click): Broadcast timer to chat\n(Ctrl+Click): Remove the timer";
		info.notCheckable = 1;
		info.func = VBM_Test_Timers;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
	end
			if(UIDROPDOWNMENU_MENU_VALUE == "FlyingTimerMenu") then
				info = {};
				info.text = "Flying Timers";
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "Flip Long Time Left";
				info.tooltipTitle = info.text;
				info.tooltipText = "This will take affect on new timers added.";
				info.keepShownOnClick = 1;
				info.checked = VBM_Timers_GetS("flyingflipsmal");
				info.func = VBM_Timers_Toggle_Setting;
				info.value = "flyingflipsmal";
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "Flip Short Time Left";
				info.tooltipTitle = info.text;
				info.tooltipText = "This will take affect on new timers added.";
				info.keepShownOnClick = 1;
				info.checked = VBM_Timers_GetS("flyingflipbig");
				info.func = VBM_Timers_Toggle_Setting;
				info.value = "flyingflipbig";
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
			if(UIDROPDOWNMENU_MENU_VALUE == "ScaleMenu") then
				info = {};
				info.text = "Scale";
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "0.7";
				info.checked = (VBM_Timers_Settings["scale"]==0.7);
				info.func = function() VBM_Timers_SetS("scale",0.7) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "0.8";
				info.checked = (VBM_Timers_Settings["scale"]==0.8);
				info.func = function() VBM_Timers_SetS("scale",0.8) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "0.9";
				info.checked = (VBM_Timers_Settings["scale"]==0.9);
				info.func = function() VBM_Timers_SetS("scale",0.9) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.0";
				info.checked = (VBM_Timers_Settings["scale"]==1.0);
				info.func = function() VBM_Timers_SetS("scale",1.0) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.1";
				info.checked = (VBM_Timers_Settings["scale"]==1.1);
				info.func = function() VBM_Timers_SetS("scale",1.1) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.2";
				info.checked = (VBM_Timers_Settings["scale"]==1.2);
				info.func = function() VBM_Timers_SetS("scale",1.2) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.4";
				info.checked = (VBM_Timers_Settings["scale"]==1.4);
				info.func = function() VBM_Timers_SetS("scale",1.4) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.6";
				info.checked = (VBM_Timers_Settings["scale"]==1.6);
				info.func = function() VBM_Timers_SetS("scale",1.6) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.8";
				info.checked = (VBM_Timers_Settings["scale"]==1.8);
				info.func = function() VBM_Timers_SetS("scale",1.8) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "2.0";
				info.checked = (VBM_Timers_Settings["scale"]==2.0);
				info.func = function() VBM_Timers_SetS("scale",2.0) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
			if(UIDROPDOWNMENU_MENU_VALUE == "ShortScaleMenu") then
				info = {};
				info.text = "Short time left scale";
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "1.0";
				info.checked = (VBM_Timers_Settings["maxscale"]==1.0);
				info.func = function() VBM_Timers_SetS("maxscale",1.0) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.2";
				info.checked = (VBM_Timers_Settings["maxscale"]==1.2);
				info.func = function() VBM_Timers_SetS("maxscale",1.2) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.4";
				info.checked = (VBM_Timers_Settings["maxscale"]==1.4);
				info.func = function() VBM_Timers_SetS("maxscale",1.4) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.6";
				info.checked = (VBM_Timers_Settings["maxscale"]==1.6);
				info.func = function() VBM_Timers_SetS("maxscale",1.6) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.8";
				info.checked = (VBM_Timers_Settings["maxscale"]==1.8);
				info.func = function() VBM_Timers_SetS("maxscale",1.8) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "2.0";
				info.checked = (VBM_Timers_Settings["maxscale"]==2.0);
				info.func = function() VBM_Timers_SetS("maxscale",2.0) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "2.5";
				info.checked = (VBM_Timers_Settings["maxscale"]==2.5);
				info.func = function() VBM_Timers_SetS("maxscale",2.5) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "3.0";
				info.checked = (VBM_Timers_Settings["maxscale"]==3.0);
				info.func = function() VBM_Timers_SetS("maxscale",3.0) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
end

function VBM_Timers_SetScale()
	VBM_TIMER_MAXSCALE = VBM_Timers_Settings["maxscale"];
	VBM_TIMER_SCALE = VBM_Timers_Settings["scale"];
end

function VBM_Timers_GetS(s)
	if(VBM_Timers_Settings[s] == 1) then
		return true;
	elseif(VBM_Timers_Settings[s] == 0) then
		return false;
	else
		return VBM_Timers_Settings[s];
	end
end

function VBM_Timers_SetS(s,value)
	VBM_Timers_Settings[s] = value;
	if(VBM_GetS("EchoSettingsChanged")) then
		vbm_printc("Setting |cFFFFFFFF"..s.."|cFF8888CC set to |cFFFFFFFF"..value);
	end
	VBM_Timers_SetScale();
end

function VBM_Timers_Toggle_Setting(self)
	local s = self.value;
	if(VBM_Timers_Settings[s]==1) then
		VBM_Timers_Settings[s] = 0;
		if(VBM_GetS("EchoSettingsChanged")) then
			vbm_printc("Setting |cFFFFFFFF"..s.."|cFF8888CC set to |cFFFFFFFFoff");
		end
	else
		VBM_Timers_Settings[s] = 1;
		if(VBM_GetS("EchoSettingsChanged")) then
			vbm_printc("Setting |cFFFFFFFF"..s.."|cFF8888CC set to |cFFFFFFFFon");
		end
	end
end