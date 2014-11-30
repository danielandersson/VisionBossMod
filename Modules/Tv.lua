--[[
	********************************************************************
	********************************************************************
	Tv
	********************************************************************
	********************************************************************

	
]]--

--[[
VBMTV_Data = {
	["Boss"] = {
		hp = 100,
		lastupdated = GetTime(),
		players = nr,
		pets = nr,
		reaction = nr,
		dead = nr,
		nrraid = nr,
		leader = name,
		class = text,
		
		start = GetTime(),
		stop = GetTime(),
	},
};
]]
local SEND_EXTRA_PLAYERS = {};

local vbmtv_update_time = 10;
local visible_update_data = 0;
local visible_update_time = 0.5;
local bars_visible;
local VBMTV_Loaded = false;
local VBMTV_Data = {

};

local banlist = {};
VBM_TV_BANINFO = "";

local RAID_LEADER = "";

local vbmtv_recive;
local vbmtv_send;
local vbmtv_update;

function VBMTV_OnLoad(self)
	self.lastupdate = 0;
	self:RegisterEvent("VARIABLES_LOADED");
	self:RegisterEvent("CHAT_MSG_ADDON");
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	self:RegisterEvent("CHAT_MSG_SYSTEM");
	self:RegisterEvent("CHAT_MSG_WHISPER");
end

function VBMTV_OnEvent(self,event,arg1,arg2,arg3,arg4,arg5,arg6,arg7,arg8,arg9,arg10,arg11,arg12)
	if(event == "COMBAT_LOG_EVENT_UNFILTERED") then
		if(not VBM_ZONE) then return; end --if not in an raid instance exit
		local combatEvent, destName = arg2,arg8;
		if(combatEvent=="UNIT_DIED" and destName) then
			local get = RAID_LEADER..destName;
			if(VBMTV_Data[get]) then
				if(VBMTV_Data[get].hp ~= 0) then
					--set hp to dead
					vbmtv_update(destName,0,VBMTV_Data[get].players,VBMTV_Data[get].pets,VBMTV_Data[get].reaction,VBMTV_Data[get].dead,VBMTV_Data[get].nrraid,RAID_LEADER,VBMTV_Data[get].class)
					--sync
					vbmtv_send(destName,RAID_LEADER);
				end
			end
		end
		return;
	end	
	if(event == "CHAT_MSG_ADDON") then
		if(arg1 == "VBMTV" and (arg3 == "GUILD" or arg3 == "WHISPER") and arg4 ~= VBM_YOU) then
			vbmtv_recive(arg2,arg4,arg3);
		end
		if(arg1 == "VBMTVOK" and arg3 == "WHISPER") then
			vbm_printc("<TV> "..vbm_c_w..arg4..vbm_c_p.." will send you tv data!");
		end
		return;
	end
	if(event == "CHAT_MSG_WHISPER") then
		if(arg1 == "!tv") then
			SEND_EXTRA_PLAYERS[arg2] = true;
			vbm_verbosec("<TV> "..vbm_c_w..arg2..vbm_c_v.." registered for tv data queue.");
			SendAddonMessage("VBMTVOK","OK","WHISPER",arg2);
		end
		return;
	end
	if(event == "CHAT_MSG_SYSTEM") then
		local a,b,c;
		a,b,c = string.find(arg1,"No player named %'(.+)%' is currently playing");
		if(a) then
			if(SEND_EXTRA_PLAYERS[c]) then
				SEND_EXTRA_PLAYERS[c] = nil;
				vbm_verbosec("<TV> "..vbm_c_w..c..vbm_c_v.." removed from tv data queue.");
			end
		end
		return;
	end
	if(event == "VARIABLES_LOADED") then
		--setup save vars
		if(not VBM_TV) then
			VBM_TV = {
				scale = 1,
			};
		end
		--setup slash command
		SlashCmdList["VisionBossMod_vbmtv"] = VBMTV_Toggle;
		SLASH_VisionBossMod_vbmtv1 = "/vbmtv";
		SLASH_VisionBossMod_vbmtv2 = "/tv";
		
		--setup scrollbar color
		local c = {
			r = 0.5,
			g = 0,
			b = 1,
		};
		VisionBossModTVFrameScrollBarScrollBarThumbTexture:SetVertexColor(c.r,c.g,c.b);
		VisionBossModTVFrameScrollBarScrollBarScrollUpButton:GetNormalTexture():SetVertexColor(c.r,c.g,c.b);
		VisionBossModTVFrameScrollBarScrollBarScrollUpButton:GetPushedTexture():SetVertexColor(c.r,c.g,c.b);
		VisionBossModTVFrameScrollBarScrollBarScrollUpButton:GetDisabledTexture():SetVertexColor(c.r,c.g,c.b);
		VisionBossModTVFrameScrollBarScrollBarScrollDownButton:GetNormalTexture():SetVertexColor(c.r,c.g,c.b);
		VisionBossModTVFrameScrollBarScrollBarScrollDownButton:GetPushedTexture():SetVertexColor(c.r,c.g,c.b);
		VisionBossModTVFrameScrollBarScrollBarScrollDownButton:GetDisabledTexture():SetVertexColor(c.r,c.g,c.b);
		--setup dropdownlist
		UIDropDownMenu_Initialize(VBMTVDropDownMenu, VBM_TV_DropDownMenu, "MENU");
		UIDropDownMenu_Initialize(VBMTVDropDownMenuBan, VBM_TV_DropDownBanMenu, "MENU");		
		--set loaded var
		VBMTV_Loaded = true;
		--set scale
		VBMTV_SetScale(VBM_TV.scale)
		--calc shown bars
		VBMTV_CalcMaxBars(VisionBossModTVFrame);
		return;
	end
end

function VBMTV_Toggle()
	if(VisionBossModTVFrame:IsShown()) then
		VisionBossModTVFrame:Hide();
	else
		VisionBossModTVFrame:Show();
	end
end

function VBMTV_SetScale(scale)
	VBM_TV.scale = scale;
	VisionBossModTVFrame:SetScale(scale);
end

local function clear_all_old()
	--clear old
	local b,d;
	for b,d in pairs(VBMTV_Data) do
		if(d.hp < 100 and d.hp > 0 and d.lastupdated + 60*4 < GetTime()) then
			VBMTV_Data[b] = nil;
		elseif(d.hp <= 0 and d.lastupdated + 90 < GetTime()) then
			VBMTV_Data[b] = nil;
		elseif(d.hp >= 100 and d.lastupdated + 15 < GetTime()) then
			VBMTV_Data[b] = nil;
		end
	end
end

function VBMTV_CalcMaxBars(self)
	if(not VBMTV_Loaded) then return; end
	local numbars = math.floor(self:GetHeight()/25);
	bars_visible = numbars;
	local i;
	for i=1,20 do
		if(i <= bars_visible) then
			
			getglobal("VisionBossModTVFrameBar"..i):Show();
		else
			getglobal("VisionBossModTVFrameBar"..i):Hide();
		end
	end
	VBMTV_UpdateVisible();
end

function VBMTV_UpdateVisible()
	--dont update to fast
	if(visible_update_data + visible_update_time > GetTime()) then
		return;
	end
	visible_update_data = GetTime();
	--don't update if frame is not visible
	if(not VisionBossModTVFrame:IsVisible()) then return; end
	--clear old
	clear_all_old();
	--for sort data
	local bosses = {};
	local b,d,i;
	for b,d in pairs(VBMTV_Data) do
		if(not banlist[d.leader]) then
			bosses[#bosses+1] = b;
		end
	end
	table.sort(bosses);
	--update scroll frame
	FauxScrollFrame_Update(VisionBossModTVFrameScrollBar,#bosses,bars_visible,25);
	local offset = FauxScrollFrame_GetOffset(VisionBossModTVFrameScrollBar);
	--update visible
	for i=1,bars_visible do
		boss = bosses[i+offset];
		if(i+offset > #bosses) then
			getglobal("VisionBossModTVFrameBar"..i):Hide();
		else
			local text = "";
			--setup first text
			--if we got some time info add it
			if(VBMTV_Data[boss].start) then
				local tid = VBMTV_Data[boss].start;
				if(VBMTV_Data[boss].stop) then
					tid = VBMTV_Data[boss].stop - tid;
					text = text..vbm_c_bronze;
				else
					tid = GetTime() - tid;
					text = text..vbm_c_y;
				end
				tid = VBM_round(tid);
				text = text..string.format("%d:%.2d ",tid/60,math.fmod(tid,60));
			end
			text = text..vbm_c_w.."Alive: "..vbm_c_g..VBMTV_Data[boss].nrraid-VBMTV_Data[boss].dead;
			text = text..vbm_c_w.." Dead: "..vbm_c_r..VBMTV_Data[boss].dead;
			text = text..vbm_c_w.." Raid: "..VBM_GetTextClassColor(VBMTV_Data[boss].class)..VBMTV_Data[boss].leader;
			--if lastupdate time > 30 sec show timer
			if(VBMTV_Data[boss].lastupdated + 30 < GetTime()) then
				local tid = GetTime()-VBMTV_Data[boss].lastupdated;
				text = text..vbm_c_r.." "..string.format("%d:%.2d ",tid/60,math.fmod(tid,60));
			end
			getglobal("VisionBossModTVFrameBar"..i.."Name"):SetText(text);
			--setup extra text
			text = ""..VBMTV_Data[boss].players;
			text = text.."/"..VBMTV_Data[boss].pets;
			getglobal("VisionBossModTVFrameBar"..i.."BarExtra"):SetText(text);
			--setup bar
			local r,g,b = VBM_GetSmoothColor(VBMTV_Data[boss].hp/100);
			getglobal("VisionBossModTVFrameBar"..i.."Bar"):SetValue(VBMTV_Data[boss].hp);
			getglobal("VisionBossModTVFrameBar"..i.."Bar"):SetStatusBarColor(r,g,b);
			getglobal("VisionBossModTVFrameBar"..i.."BarBg"):SetVertexColor(r,g,b,0.25);
			--bar text
			text = VBM_GetTextReactionColor(VBMTV_Data[boss].reaction)..VBMTV_Data[boss].boss;
			getglobal("VisionBossModTVFrameBar"..i.."BarName"):SetText(text);
			if(VBMTV_Data[boss].hp>0) then
				getglobal("VisionBossModTVFrameBar"..i.."BarTotal"):SetText(VBMTV_Data[boss].hp.."%");
			else
				getglobal("VisionBossModTVFrameBar"..i.."BarTotal"):SetText("Dead");
			end
			--baninfo
				getglobal("VisionBossModTVFrameBar"..i).baninfo = VBMTV_Data[boss].leader;
			--show
			getglobal("VisionBossModTVFrameBar"..i):Show();
		end
	end
end

--[[
	********************************************************************
	SEND RECIVE AND UPDATE
	********************************************************************
]]--

vbmtv_update = function(boss,hp,players,pets,reaction,dead,nrraid,leader,class)
	local get = leader..boss;
	if(not VBMTV_Data[get]) then
		VBMTV_Data[get] = {};
	end
	VBMTV_Data[get].boss = boss;
	VBMTV_Data[get].hp = hp;
	VBMTV_Data[get].players = players;
	VBMTV_Data[get].pets = pets;
	VBMTV_Data[get].reaction = reaction;
	VBMTV_Data[get].dead = dead;
	VBMTV_Data[get].nrraid = nrraid;
	VBMTV_Data[get].leader = leader;
	VBMTV_Data[get].class = class;
	VBMTV_Data[get].lastupdated = GetTime();
	--vbm_debug("|cFFFFFF55<VBMTV> Updated "..vbm_c_w..boss..","..hp..","..players..","..pets..","..reaction..","..dead..","..nrraid..","..leader..","..class);
	--check start and stop
	if(not VBMTV_Data[get].start and VBMTV_Data[get].hp < 100) then
		VBMTV_Data[get].start = GetTime();
	end
	if(not VBMTV_Data[get].stop and VBMTV_Data[get].hp == 0) then
		VBMTV_Data[get].stop = GetTime();
	end
	
	--sync to people on whisper list
	local extra_n,extra_d;
	local msg = VBMTV_Data[get].boss.."@"..VBMTV_Data[get].hp.."@"..VBMTV_Data[get].players.."@"..VBMTV_Data[get].pets.."@"..
				VBMTV_Data[get].reaction.."@"..VBMTV_Data[get].dead.."@"..VBMTV_Data[get].nrraid.."@"..VBMTV_Data[get].leader..
				"@"..VBMTV_Data[get].class;
	for extra_n,extra_d in pairs(SEND_EXTRA_PLAYERS) do
		SendAddonMessage("VBMTV",msg,"WHISPER",extra_n);
	end
	--update visible tv stuff
	VBMTV_UpdateVisible();
end

local function vbmtv_checkfornewvalues(leader,boss,hp,nrraid,dead)
	local get = leader..boss;
	if(VBMTV_Data[get]) then
		--update for hp nrinraid and deadinraid
		if(hp ~= VBMTV_Data[get].hp) then
			return true;
		elseif(nrraid ~= VBMTV_Data[get].nrraid) then
			return true;
		elseif(dead ~= VBMTV_Data[get].dead) then
			return true;
		end
	else
		return true;
	end
	return false;
end

vbmtv_send = function(boss,leader)
	--dont send if you are not in a guild
	if(not GetGuildInfo("player")) then return; end
	
	local get = leader..boss;
	local msg = VBMTV_Data[get].boss.."@"..VBMTV_Data[get].hp.."@"..VBMTV_Data[get].players.."@"..VBMTV_Data[get].pets.."@"..
				VBMTV_Data[get].reaction.."@"..VBMTV_Data[get].dead.."@"..VBMTV_Data[get].nrraid.."@"..VBMTV_Data[get].leader..
				"@"..VBMTV_Data[get].class;

	SendAddonMessage("VBMTV",msg,"GUILD");
	vbm_debug("|cFFFFAA55<VBMTV> Send "..vbm_c_w..msg);
end

vbmtv_recive = function(msg,from,channel)
	local found,_,boss,hp,players,pets,reaction,dead,nrraid,leader,class = string.find(msg,"(.+)@(.+)@(.+)@(.+)@(.+)@(.+)@(.+)@(.+)@(.+)");
	if(found) then
		--convert all numbers to numbers
		hp = tonumber(hp);
		players = tonumber(players);
		pets = tonumber(pets);
		reaction = tonumber(reaction);
		dead = tonumber(dead);
		nrraid = tonumber(nrraid);
		
		--only update if values will be changed protect from cross send
		if(vbmtv_checkfornewvalues(leader,boss,hp,nrraid,dead)) then
			vbmtv_update(boss,hp,players,pets,reaction,dead,nrraid,leader,class);
			vbm_debug("|cFFAAFF55<VBMTV> "..from.." ("..channel..") Recive "..vbm_c_w..msg);
		else
			vbm_debug("|cFFAAFF55<VBMTV> "..from.." ("..channel..") Recive "..vbm_c_r.."FAILED NO NEW DATA "..vbm_c_w..msg);
		end
	else
		vbm_debug("|cFFAAFF55<VBMTV> "..from.." ("..channel..") Recive "..vbm_c_r.."FAILED MSG ERROR "..vbm_c_w..msg);
	end
end

--every 10 second check if there are any updates and then send them to the guild addon chanel
function VBMTV_OnUpdate(self,elapsed)
	--update visible bars
	VBMTV_UpdateVisible();
	--dont update to fast
	self.lastupdate = self.lastupdate + elapsed;
	if(self.lastupdate > vbmtv_update_time) then
		self.lastupdate = 0;
	else
		return
	end
	
	--if not in an raid instance exit
	if(not VBM_ZONE) then return; end
	
	--clear old
	clear_all_old();
	--go through raid members and pet and check their targets for bosses
	local data = {};
	local i,target,pet;
	local deadinraid,nrinraid = 0,0;
	local leader,class = "Unknown", "Unknown";

	for i=1,GetNumGroupMembers() do
		--first check if we have a boss in target
		target = "raid"..i.."target";
		pet = "raid"..i.."pettarget";
		if(UnitExists(target) and VBM_UnitClassification(target)=="worldboss") then
			--increase player targeting or setup data
			if(data[UnitName(target)]) then
				data[UnitName(target)].players = data[UnitName(target)].players + 1;
			else
				data[UnitName(target)] = {
					hp = VBM_UnitHealthPercent(target,"yes"),
					players = 1,
					pets = 0,
					reaction = UnitReaction("player",target),
				};
			end
		end
		if(UnitExists(pet) and VBM_UnitClassification(pet)=="worldboss") then
			--icrease pets targeting or setup data
			if(data[UnitName(pet)]) then
				data[UnitName(pet)].pets = data[UnitName(pet)].pets + 1;
			else
				data[UnitName(pet)] = {
					hp = VBM_UnitHealthPercent(pet,"yes"),
					players = 0,
					pets = 1,
					reaction = UnitReaction("player",pet),
				};
			end
		end
		--now check if this player is dead
		if(UnitIsDeadOrGhost("raid"..i)) then
			deadinraid = deadinraid + 1;
		end
		if(UnitIsConnected("raid"..i)) then
			nrinraid = nrinraid + 1;
		end
		--now check if this is the leader
		if(UnitIsPartyLeader("raid"..i)) then
			leader = UnitName("raid"..i);
			_,class = UnitClass("raid"..i);
			--store raid leader
			RAID_LEADER = leader
		end
	end
	
	--now go thorugh data array and if hp is diffrent from VBMTV_Data then update it and sync
	local b,d;
	for b,d in pairs(data) do
		if(vbmtv_checkfornewvalues(leader,b,d.hp,nrinraid,deadinraid)) then
			vbmtv_update(b,d.hp,d.players,d.pets,d.reaction,deadinraid,nrinraid,leader,class);
			vbmtv_send(b,leader);
		end
	end
end

--[[***************************
		Settings Menu
***************************]]--

function VBM_BanFromView(self)
	banlist[self.value] = true;
end

function VBM_UnBanFromView(self)
	banlist[self.value] = nil;
end

function VBM_TV_DropDownBanMenu(name)
	local info = {};
	if(UIDROPDOWNMENU_MENU_LEVEL==1) then
		info = {};
		info.text = "Ban "..VBM_TV_BANINFO;
		info.notCheckable = 1;
		info.func = VBM_BanFromView;
		info.value = VBM_TV_BANINFO;
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
	end
end

function VBM_TV_DropDownMenu()
	local info = {};
	
	if(UIDROPDOWNMENU_MENU_LEVEL==1) then
		info = {};
		info.text = "Scale";
		info.notCheckable = 1;
		info.hasArrow = 1;
		info.value = "ScaleMenu";
		UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
		
		info.text = "UnBan";
		info.notCheckable = 1;
		info.hasArrow = 1;
		info.value = "UnBanMenu";
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
				info.checked = (VBM_TV.scale==0.7);
				info.func = function() VBMTV_SetScale(0.7) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "0.8";
				info.checked = (VBM_TV.scale==0.8);
				info.func = function() VBMTV_SetScale(0.8) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "0.9";
				info.checked = (VBM_TV.scale==0.9);
				info.func = function() VBMTV_SetScale(0.9) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.0";
				info.checked = (VBM_TV.scale==1.0);
				info.func = function() VBMTV_SetScale(1.0) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.1";
				info.checked = (VBM_TV.scale==1.1);
				info.func = function() VBMTV_SetScale(1.1) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.2";
				info.checked = (VBM_TV.scale==1.2);
				info.func = function() VBMTV_SetScale(1.2) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.4";
				info.checked = (VBM_TV.scale==1.4);
				info.func = function() VBMTV_SetScale(1.4) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.6";
				info.checked = (VBM_TV.scale==1.6);
				info.func = function() VBMTV_SetScale(1.6) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "1.8";
				info.checked = (VBM_TV.scale==1.8);
				info.func = function() VBMTV_SetScale(1.8) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				info = {};
				info.text = "2.0";
				info.checked = (VBM_TV.scale==2.0);
				info.func = function() VBMTV_SetScale(2.0) end;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
			end
			if(UIDROPDOWNMENU_MENU_VALUE == "UnBanMenu") then
				info = {};
				info.text = "UnBan";
				info.notCheckable = 1;
				info.disabled = 1;
				UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				
				info = {};
				local n,v;
				for n,v in pairs(banlist) do
					info.text = n;
					info.notCheckable = 1;
					info.func = VBM_UnBanFromView;
					info.value = n;
					UIDropDownMenu_AddButton(info,UIDROPDOWNMENU_MENU_LEVEL);
				end
			end
end
