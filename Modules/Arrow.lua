--[[
	********************************************************************
	********************************************************************
	VBM Arrow
	********************************************************************
	********************************************************************

Arrow texture borrowed form TomTom
	
	Usage: 
	For boss mods: --expire default to 30, if set to 0 it won't be used
	VBM_BossArrow(name,expire)
	
	Set a new arrow: --expire default to 30, if set to 0 it won't be used
	VBM_SetArrowByName(name,expire) 
	calls=>
	VBM_SetFreeArrow(uid,expire)
	calls=>
	VBM_Set_Arrow(id,uid,expire)
	
	Remove arrow:
	VBM_RemoveArrowByName(name)
	calls=>
	VBM_RemoveArrowByUid(uid)
	calls=>
	VBM_Remove_Arrow(id)
	
	VBM_RemoveAllArrows()
]]--

local arrow_point = "Interface\\AddOns\\VisionBossMod\\Data\\Arrow";
local arrow_down = "Interface\\AddOns\\VisionBossMod\\Data\\Arrow_down";
local num_arrows = 5;
local full = math.pi*2;
local color = {
	[40] = {1,0,0},
	[28] = {1,0.5,0},
	[20] = {1,1,0},
	[10] = {0,1,0},
	[0] = {1,1,1},
};
local dropdownhelp;

--[[***************************
		API
***************************]]--

function VBM_BossArrow(name,expire)
	if(VBM_GetS("AcceptArrows")) then
		VBM_SetArrowByName(name,expire);
	end
end

function VBM_SetArrowByName(name,expire)
	local i;
	if(GetNumRaidMembers()>0) then
		for i=1,GetNumRaidMembers() do
			if(UnitName("raid"..i)==name) then
				VBM_SetFreeArrow("raid"..i,expire);
			end
		end
	elseif(GetNumPartyMembers()>0) then
		for i=1,GetNumPartyMembers() do
			if(UnitName("party"..i)==name) then
				VBM_SetFreeArrow("party"..i,expire);
			end
		end
	end
end

function VBM_RemoveArrowByName(name)
	local i;
	if(GetNumRaidMembers()>0) then
		for i=1,GetNumRaidMembers() do
			if(UnitName("raid"..i)==name) then
				VBM_RemoveArrowByUid("raid"..i);
			end
		end
	elseif(GetNumPartyMembers()>0) then
		for i=1,GetNumPartyMembers() do
			if(UnitName("party"..i)==name) then
				VBM_RemoveArrowByUid("party"..i);
			end
		end
	end
end

function VBM_SetFreeArrow(uid,expire)
	local i;
	for i=1,num_arrows do
		if(not _G["VBMArrow"..i].uid) then
			VBM_Set_Arrow(i,uid,expire);
			break; --only set 1
		end
	end	
end

function VBM_Set_Arrow(id,uid,expire)
	_G["VBMArrow"..id].uid = uid;
	if(not expire) then
		_G["VBMArrow"..id].expire = GetTime()+30;
	else
		if(expire > 0) then
			_G["VBMArrow"..id].expire = GetTime()+expire;
		end
	end
	_G["VBMArrow"..id]:Show();
	if(VBM_ARROW.disablemouse==1) then
		_G["VBMArrow"..id]:EnableMouse(0);
	end
end

function VBM_RemoveAllArrows()
	local i;
	for i=1,num_arrows do
		VBM_Remove_Arrow(i);
	end
end

function VBM_RemoveArrowByUid(uid)
	local i;
	for i=1,num_arrows do
		if(_G["VBMArrow"..i].uid and _G["VBMArrow"..i].uid == uid) then
			VBM_Remove_Arrow(i);
		end
	end	
end

function VBM_Remove_Arrow(id)
	VBM_Hide_Arrow(_G["VBMArrow"..id]);
end

--[[***************************
    ***************************
		Frame Handling
***************************
***************************]]--

function VBM_Arrow_Init()
	if(VBM_ARROW and not VBM_ARROW.hideoor) then
		VBM_ARROW = nil;
	end
	
	if(not VBM_ARROW) then
		VBM_ARROW = {
			['locked'] = 0,
			['scale'] = 1,
			['extraspace'] = 40,
			['align'] = 0,
			['aligntext'] = 0,
			['textvert'] = 0,
			['textmerge'] = 0,
			['hideoor'] = 0,
		};
	end
	if(not VBM_ARROW.disablemouse) then VBM_ARROW.disablemouse = 0; end
	
	--setup dropdownlist
	UIDropDownMenu_Initialize(VBMArrowDropDownMenu, VBM_Arrow_DropDownMenu, "MENU");	
	
	VBM_Arrow_Setup();
end

function VBM_Arrow_ToggleAll()
	local i;
	for i=1,num_arrows do
		if(not _G["VBMArrow"..i].uid) then
			if(_G["VBMArrow"..i]:IsShown()) then
				VBM_Hide_Arrow(_G["VBMArrow"..i]);
			else
				_G["VBMArrow"..i]:Show();
			end
		end
	end
end

function VBM_Arrow_OnClick(self,button)
	if(button == "LeftButton" and not self.uid and UnitExists("target")) then
		local i;
		if(GetNumRaidMembers()>0) then
			for i=1,GetNumRaidMembers() do
				if(UnitIsUnit("raid"..i,"target")) then
					vbm_printc("Locking Arrow "..vbm_c_w..self:GetID()..vbm_c_p.." to "..vbm_c_w.."raid"..i);
					VBM_Set_Arrow(self:GetID(),"raid"..i,0);
				end
			end
		elseif(GetNumPartyMembers()>0) then
			for i=1,GetNumPartyMembers() do
				if(UnitIsUnit("party"..i,"target")) then
					vbm_printc("Locking Arrow "..vbm_c_w..self:GetID()..vbm_c_p.." to "..vbm_c_w.."party"..i);
					VBM_Set_Arrow(self:GetID(),"party"..i,0);
				end
			end
		end
	end
	
	if(button == "RightButton") then
		dropdownhelp = self:GetID();
		ToggleDropDownMenu(1, nil, VBMArrowDropDownMenu, self, 0, 0);
	end
end

function VBM_Arrow_HideAll()
	local i;
	for i=1,num_arrows do
		VBM_Hide_Arrow(_G["VBMArrow"..i]);
	end
end

function VBM_Hide_Arrow(self)
	self:EnableMouse(1);
	self.uid = nil;
	self.expire = nil;
	self:Hide();
end

function VBM_Arrow_Setup()
	--set text
	local i;
	for i=1,num_arrows do
		if(VBM_ARROW['aligntext']==0 and VBM_ARROW['textvert']==0) then
			_G["VBMArrow"..i].dist:ClearAllPoints();
			_G["VBMArrow"..i].dist:SetPoint("TOP","$parent","BOTTOM");
			_G["VBMArrow"..i].player:ClearAllPoints();
			_G["VBMArrow"..i].player:SetPoint("BOTTOM","$parent","TOP");
		elseif(VBM_ARROW['aligntext']==1 and VBM_ARROW['textvert']==0) then
			_G["VBMArrow"..i].dist:ClearAllPoints();
			_G["VBMArrow"..i].dist:SetPoint("BOTTOM","$parent","TOP");
			_G["VBMArrow"..i].player:ClearAllPoints();
			_G["VBMArrow"..i].player:SetPoint("TOP","$parent","BOTTOM");
		elseif(VBM_ARROW['aligntext']==0 and VBM_ARROW['textvert']==1) then
			_G["VBMArrow"..i].dist:ClearAllPoints();
			_G["VBMArrow"..i].dist:SetPoint("LEFT","$parent","RIGHT");
			_G["VBMArrow"..i].player:ClearAllPoints();
			_G["VBMArrow"..i].player:SetPoint("RIGHT","$parent","LEFT");
		else
			_G["VBMArrow"..i].dist:ClearAllPoints();
			_G["VBMArrow"..i].dist:SetPoint("RIGHT","$parent","LEFT");
			_G["VBMArrow"..i].player:ClearAllPoints();
			_G["VBMArrow"..i].player:SetPoint("LEFT","$parent","RIGHT");
		end
		
		--set scale
		_G["VBMArrow"..i]:SetScale(VBM_ARROW['scale']);
	end

	--setup anchors
	VBMArrow2:ClearAllPoints();
	if(VBM_ARROW['align']==0) then
		VBMArrow2:SetPoint("RIGHT","VBMArrow1","LEFT",0-VBM_ARROW['extraspace'],0);
	else
		VBMArrow2:SetPoint("BOTTOM","VBMArrow1","TOP",0,0+VBM_ARROW['extraspace']);
	end
	for i=4,num_arrows,2 do
		_G["VBMArrow"..i]:ClearAllPoints();
		if(VBM_ARROW['align']==0) then
			_G["VBMArrow"..i]:SetPoint("RIGHT","VBMArrow"..(i-2),"LEFT",0-VBM_ARROW['extraspace'],0);
		else
			_G["VBMArrow"..i]:SetPoint("BOTTOM","VBMArrow"..(i-2),"TOP",0,0+VBM_ARROW['extraspace']);
		end
	end
	for i=3,num_arrows,2 do
		_G["VBMArrow"..i]:ClearAllPoints();
		if(VBM_ARROW['align']==0) then
			_G["VBMArrow"..i]:SetPoint("LEFT","VBMArrow"..(i-2),"RIGHT",0+VBM_ARROW['extraspace'],0);
		else
			_G["VBMArrow"..i]:SetPoint("TOP","VBMArrow"..(i-2),"BOTTOM",0,0-VBM_ARROW['extraspace']);
		end
	end
end

--[[***************************
    ***************************
		OnUpdate
***************************
***************************]]--

local function arrow_calc(x,y)
	local pf = GetPlayerFacing();
	local px,py = VBM_GetPlayerMapPosition("player");
	
	local dx,dy = x-px,y-py;
	
	if(dx==0 and dy==0) then
		return -1;
	end
	local h = (dx^2+dy^2)^0.5
	local v = math.asin(dx/h);
	if(dy < 0) then
		v = math.pi-v;
	end
	--vbm_prints(px,py,pf,dx,dy,v,(math.pi-(pf-v))%full);
	return ((math.pi-(pf-v))%full)/full
end

local function VBM_SetArrowDirection(self,s,down) -- 0 - 107
	local x,y = math.floor(s%9),math.floor(s/9);
	local cx,cy;
	if(down) then
		cx,cy = 53/512,70/512;
	else
		cx,cy = 56/512,42/512;
	end
	self.arrow:SetTexCoord(x*cx,(x+1)*cx, y*cy, (y+1)*cy);
end

local function VBM_SetArrowText(self,uid,err)
	if(UnitExists(uid) and UnitIsVisible(uid)) then
		local r1,r2,r3,r4 = UnitInRange(uid),CheckInteractDistance(uid,1),IsItemInRange(VBM_CURRENT_BANDAGE,uid),CheckInteractDistance(uid,3);
		local g = (UnitPlayerOrPetInParty(uid) or UnitPlayerOrPetInRaid(uid) or UnitIsUnit(uid,"pet"));
		
		if(g and not r1) then
			self.dist:SetText("> 40");
			self.dist:SetTextColor(unpack(color[40]));
		elseif(not g and not r2) then
			self.dist:SetText("> 28");
			self.dist:SetTextColor(unpack(color[40]));
		elseif(g and not r2) then
			self.dist:SetText("28 - 40");
			self.dist:SetTextColor(unpack(color[28]));
		elseif(r3 and r3==0) then
			self.dist:SetText("20 - 28");
			self.dist:SetTextColor(unpack(color[20]));
		elseif(not r3 and not r4) then
			self.dist:SetText("10 - 28");
			self.dist:SetTextColor(unpack(color[20]));
		elseif(r3 and r3==1 and not r4) then
			self.dist:SetText("10 - 20");
			self.dist:SetTextColor(unpack(color[10]));
		elseif(UnitIsUnit("player",uid)) then
			self.dist:SetText("You");
			self.dist:SetTextColor(unpack(color[0]));
		elseif(r4) then
			self.dist:SetText("< 10");
			self.dist:SetTextColor(unpack(color[10]));
		else
			self.dist:SetText("RangeError2");
			self.dist:SetTextColor(unpack(color[0]));
		end
	elseif(UnitExists(uid) and (not UnitIsVisible(uid)) and (VBM_ARROW.hideoor==1)) then
		--auto hide
		VBM_Hide_Arrow(self);
	elseif(uid=="test") then
		self.dist:SetText("Test Mode");
		self.dist:SetTextColor(unpack(color[0]));
	elseif(UnitExists(uid)) then
		self.dist:SetText("RangeError");
		self.dist:SetTextColor(unpack(color[0]));
	else
		self.dist:SetText("-");
		self.dist:SetTextColor(unpack(color[0]));
	end
	--match color if not an range error
	if(err) then
		self.arrow:SetVertexColor(unpack(color[0]));
	else
		self.arrow:SetVertexColor(self.dist:GetTextColor());
	end
	--set class text
	local text = "";
	local color = VBM_GetColorText(self.dist:GetTextColor());
	--check if its target or mouseover
	if(uid=="target") then text = text..color.."T ("; end
	if(uid=="mouseover") then text = text..color.."M ("; end
	if(UnitExists(uid)) then
		local _,class = UnitClass(uid);
		text = text..VBM_GetTextClassColor(class)..UnitName(uid);
	else
		text = text..vbm_c_w.."-";
	end
	if(uid=="mouseover" or uid=="target") then text = text..color..")"; end
	--print text
	if(VBM_ARROW.textmerge==1) then
		self.dist:SetText(self.dist:GetText().."\n"..text);
		self.player:SetText(nil);
	else
		self.player:SetText(text);
	end
end

function VBM_Arrow_OnUpdate(self,elapsed)
	--check if we hav expired
	if(self.expire and self.expire < GetTime()) then
		VBM_Hide_Arrow(self);
	end
	
	local perc,unit;
	local err = false;
	
	if(not self.uid) then
		--enter test mode
		unit = "test";
		perc = (GetTime()%5)/5;
		self.error:Hide();
		err = true;
	else
		local tx,ty = VBM_GetPlayerMapPosition(self.uid);
		unit = self.uid;
		if(tx+ty > 0) then
			perc = arrow_calc(tx,ty);
			self.error:Hide();
		else
			--N/A
			perc = (GetTime()%5)/5;
			self.error:Show();
			err = true;
		end		
	end
	
	--fix if its on same spot as you
	if(perc==-1) then
		perc = (GetTime()%1)/1;
		local s = math.floor(perc*55);
		self.arrow:SetTexture(arrow_down);
		VBM_SetArrowDirection(self,s,true);
	else
		--else display normal arrow
		self.arrow:SetTexture(arrow_point);
		local s = math.floor(perc*108);
		VBM_SetArrowDirection(self,s);
	end

	--dont update range to often 5x sec is enough
	if(self.elapsed + 0.2 < GetTime()) then
		VBM_SetArrowText(self,unit,err);
		self.elapsed = GetTime();
	end
end

--[[***************************
    ***************************
		Settings Menu
***************************
***************************]]--

function VBM_Arrow_DropDownMenu(self)
	local info = {};
	
	if(UIDROPDOWNMENU_MENU_LEVEL==1) then
		info = {};
		info.text = "Set to follow: target";
		info.notCheckable = 1;
		info.func = function(self) 
			vbm_printc("Locking Arrow "..vbm_c_w..dropdownhelp..vbm_c_p.." to "..vbm_c_w.."target");
			VBM_Set_Arrow(dropdownhelp,"target",0);
		end;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Set to follow: mouseover";
		info.notCheckable = 1;
		info.func = function(self) 
			vbm_printc("Locking Arrow "..vbm_c_w..dropdownhelp..vbm_c_p.." to "..vbm_c_w.."mouseover");
			VBM_Set_Arrow(dropdownhelp,"mouseover",0);
		end;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Lock Dragging";
		info.checked = (VBM_ARROW['locked']==1);
		info.keepShownOnClick = 1;
		info.func = function() if(VBM_ARROW['locked']==1) then VBM_ARROW['locked']=0; else VBM_ARROW['locked']=1; end end;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info.text = "Disable Mouse on Locked";
		info.tooltipTitle = info.text;
		info.tooltipText = "An arrow is locked if it points to someone. This options does so you can click straight through those arrows.";
		info.checked = (VBM_ARROW.disablemouse==1);
		info.keepShownOnClick = 1;
		info.func = function() if(VBM_ARROW.disablemouse==1) then VBM_ARROW.disablemouse=0; else VBM_ARROW.disablemouse=1; end end;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info.text = "Auto Hide Not Visible";
		info.tooltipTitle = info.text;
		info.tooltipText = "Auto Hide Arrows pointing to someone who are not within visible range";
		info.checked = (VBM_ARROW['hideoor']==1);
		info.keepShownOnClick = 1;
		info.func = function() if(VBM_ARROW['hideoor']==1) then VBM_ARROW['hideoor']=0; else VBM_ARROW['hideoor']=1; end end;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info = {};
		info.text = "Scale";
		info.notCheckable = 1;
		info.hasArrow = 1;
		info.value = "ScaleMenu";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		info.text = "Extra Space";
		info.notCheckable = 1;
		info.hasArrow = 1;
		info.value = "ExtraSpaceMenu";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		info.text = "Align";
		info.notCheckable = 1;
		info.hasArrow = 1;
		info.value = "AlignMenu";
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
				info.checked = (VBM_ARROW.scale==0.5);
				info.func = function() VBM_ARROW.scale=0.5; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.6";
				info.checked = (VBM_ARROW.scale==0.6);
				info.func = function() VBM_ARROW.scale=0.6; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.7";
				info.checked = (VBM_ARROW.scale==0.7);
				info.func = function() VBM_ARROW.scale=0.7; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.8";
				info.checked = (VBM_ARROW.scale==0.8);
				info.func = function() VBM_ARROW.scale=0.8; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "0.9";
				info.checked = (VBM_ARROW.scale==0.9);
				info.func = function() VBM_ARROW.scale=0.9; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.0";
				info.checked = (VBM_ARROW.scale==1.0);
				info.func = function() VBM_ARROW.scale=1.0; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.1";
				info.checked = (VBM_ARROW.scale==1.1);
				info.func = function() VBM_ARROW.scale=1.1; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.2";
				info.checked = (VBM_ARROW.scale==1.2);
				info.func = function() VBM_ARROW.scale=1.2; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.4";
				info.checked = (VBM_ARROW.scale==1.4);
				info.func = function() VBM_ARROW.scale=1.4; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.6";
				info.checked = (VBM_ARROW.scale==1.6);
				info.func = function() VBM_ARROW.scale=1.6; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "1.8";
				info.checked = (VBM_ARROW.scale==1.8);
				info.func = function() VBM_ARROW.scale=1.8; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "2.0";
				info.checked = (VBM_ARROW.scale==2.0);
				info.func = function() VBM_ARROW.scale=2.0; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
			if(UIDROPDOWNMENU_MENU_VALUE == "ExtraSpaceMenu") then
				info = {};
				info.text = "Extra Space";
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "0";
				info.checked = (VBM_ARROW.extraspace==0);
				info.func = function() VBM_ARROW.extraspace=0; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "20";
				info.checked = (VBM_ARROW.extraspace==20);
				info.func = function() VBM_ARROW.extraspace=20; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "40";
				info.checked = (VBM_ARROW.extraspace==40);
				info.func = function() VBM_ARROW.extraspace=40; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "60";
				info.checked = (VBM_ARROW.extraspace==60);
				info.func = function() VBM_ARROW.extraspace=60; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "80";
				info.checked = (VBM_ARROW.extraspace==80);
				info.func = function() VBM_ARROW.extraspace=80; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "100";
				info.checked = (VBM_ARROW.extraspace==100);
				info.func = function() VBM_ARROW.extraspace=100; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "120";
				info.checked = (VBM_ARROW.extraspace==120);
				info.func = function() VBM_ARROW.extraspace=120; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "140";
				info.checked = (VBM_ARROW.extraspace==140);
				info.func = function() VBM_ARROW.extraspace=140; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "160";
				info.checked = (VBM_ARROW.extraspace==160);
				info.func = function() VBM_ARROW.extraspace=160; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "180";
				info.checked = (VBM_ARROW.extraspace==180);
				info.func = function() VBM_ARROW.extraspace=180; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "200";
				info.checked = (VBM_ARROW.extraspace==200);
				info.func = function() VBM_ARROW.extraspace=200; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
			if(UIDROPDOWNMENU_MENU_VALUE == "AlignMenu") then
				info = {};
				info.text = "Align";
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "Arrows Horizontal";
				info.checked = (VBM_ARROW.align==0);
				info.func = function() VBM_ARROW.align=0; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "Arrows Vertical";
				info.checked = (VBM_ARROW.align==1);
				info.func = function() VBM_ARROW.align=1; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "Range Text Above";
				info.checked = (VBM_ARROW.aligntext==1);
				info.func = function() VBM_ARROW.aligntext=1; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "Range Text Below";
				info.checked = (VBM_ARROW.aligntext==0);
				info.func = function() VBM_ARROW.aligntext=0; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "Text Horizontal";
				info.checked = (VBM_ARROW.textvert==1);
				info.func = function() VBM_ARROW.textvert=1; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info.text = "Text Vertical";
				info.checked = (VBM_ARROW.textvert==0);
				info.func = function() VBM_ARROW.textvert=0; VBM_Arrow_Setup(); end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				info.text = "Merge Target and Range";
				info.checked = (VBM_ARROW['textmerge']==1);
				info.keepShownOnClick = 1;
				info.func = function() if(VBM_ARROW['textmerge']==1) then VBM_ARROW['textmerge']=0; else VBM_ARROW['textmerge']=1; end end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
end