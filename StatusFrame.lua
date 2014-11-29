--[[
******************
VARS 
******************
]]--
local VBM_BATTLE_ELIXIR = {
	["Major Agility"] = 1,
	["Mighty Agility"] = 1,
	["Deadly Strikes"] = 1,
	["Lightning Speed"] = 1,
	["Armor Piercing"] = 1,
	["Impossible Accuracy"] = 1,
	["Elixir of the Master"] = 1,
};

local VBM_GUARDIAN_ELIXIR = {
	["Mighty Thoughts"] = 1,
	["Mighty Defense"] = 1,
};

local VBM_BOTH_ELIXIR = {
	["Distilled Wisdom"] = 1,
};

local VBM_ELIXIR_EXCEPTIONS = {
	["Flask of the North"] = "North",
	["Enhanced Agility"] = "Enhancement",
	["Enhanced Strength"] = "Enhancement",
	["Enhanced Intellect"] = "Enhancement",
};

--[[
******************
Core Frame
******************
]]--

function VBM_StatusFrame_Init()
	SlashCmdList["VisionBossMod_Statustoggle"] = VBM_SF_Toggle;
	SLASH_VisionBossMod_Statustoggle1 = "/vbm";
	
	VBMStatusFrameHeaderText:SetText("VisionBossMod v"..VBM_VERSION);
	VBM_SF_SetBorder();
	
	UIDropDownMenu_Initialize(VBMStatusFrameDropDownMenu, VBM_Settings_Menuofdoom, "MENU");
end

function VBM_SF_Toggle()
	if(VBMStatusFrame:IsShown()) then
		VBMStatusFrame:Hide();
	else
		VBMStatusFrame:Show();
	end
end

function VBM_SF_SetBorder()
	if(VBM_GetS("SFHideBorder")) then
		VBMStatusFrame:SetBackdrop( { 
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
			tile = true,
			tileSize = 16,
			insets = { left = 4, right = 4, top = 3, bottom = 3 }
		});
	else
		VBMStatusFrame:SetBackdrop( { 
			bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", 
			edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
			tile = true,
			tileSize = 16,
			edgeSize = 16, 
			insets = { left = 5, right = 5, top = 5, bottom = 5 }
		});
	end
	VBMStatusFrame:SetBackdropColor(0.1,0.1,0.1,0.8);
end

local VBM_SF_TitleTime = false;
local VBM_SF_TITLE_UPDATE = 0;
function VBM_SF_UpdateTitle()
	--only run if active
	if(not VBM_GetS("DisplayTimeElapsed")) then return; end
	--dont update to fast
	if(VBM_SF_TITLE_UPDATE + 1 > GetTime()) then
		return;
	end
	VBM_SF_TITLE_UPDATE = GetTime();	

	if(VBM_ZONE) then
		if(VBM_IsCurrentBossActive()) then
			if(VBM_SF_TitleTime) then
				local tid = math.floor(GetTime()) - VBM_SF_TitleTime;
				local m = math.floor(tid/60);
				local s = math.fmod(tid,60);
				if(s<10) then
					s = "0"..s;
				end
				VBMStatusFrameHeaderText:SetText(m..":"..s.." - "..VBM_GetRealBossName(VBM_BOSS));
				if(VBM_GetS("AutoShowSF")) then
					VBMStatusFrame:Show();
				end
			else
				VBM_SF_TitleTime = math.floor(GetTime());
			end
		else
			--reset var
			VBM_SF_TitleTime = false;
		end
	else
		if(VBM_SF_TitleTime) then
			VBM_SF_TitleTime = false;
			VBMStatusFrameHeaderText:SetText("VisionBossMod v"..VBM_VERSION);
		end
	end	
end

function VBM_SF_Reset()
	VBM_SF_TitleTime = false;
end

--[[
******************
Buff checking
******************
]]--

function VBM_PopulateWellFedTooltip(self)
	local well,dead = VBM_ScanForWellFed();
	local n,d,name,class;
	local text = "Missing Well Fed:";
	local texttochat = "Missing Well Fed: ";
	--add missing wellfed
	local count = 0;
	for n,d in pairs(well) do
		text = text.."\n"..vbm_c_grey..n..": ";
		for name,class in pairs(d) do
			text = text..VBM_GetTextClassColor(class)..name.." ";
			texttochat = texttochat..name.." ";
			count = count + 1;
		end
	end
	--add total or all have
	if(count==0) then
		text = text.."\n"..vbm_c_g.."All Have";
		texttochat = texttochat.."All Have";
	else
		text = text.."\n"..vbm_c_grey.."Total: "..vbm_c_w..count;
	end
	--print out dead or out of range
	local first = true;
	for name,class in pairs(dead) do
		if(first) then
			text = text.."\n"..vbm_c_tt.."Dead or Out of Range:\n";
			first = false;
		end
		text = text..VBM_GetTextClassColor(class)..name.." ";
	end
	--add extra info
	text = text.."\n"..vbm_c_grey.."(Shift+Click): Paste to chat.";
	self.texttochat = texttochat;
	GameTooltip:SetOwner(self);
	GameTooltip:SetText(text);
	GameTooltip:Show();
end

function VBM_ScanForWellFed()
	local missing_well = {};
	local oor_dead = {};
	local i;
	
	if(GetNumGroupMembers()>0) then
		--check raid
		for i=1,GetNumGroupMembers() do
			--dont check dead or out of range
			if((not UnitIsDeadOrGhost("raid"..i)) and UnitIsVisible("raid"..i)) then
				local w = VBM_CheckForBuff("Well Fed","raid"..i);
				if(not w) then
					local _,_,group = GetRaidRosterInfo(i);
					local _,class = UnitClass("raid"..i);
					if(not missing_well[group]) then missing_well[group] = {}; end
					missing_well[group][UnitName("raid"..i)] = class;
				end
			else
                if (not UnitClass("raid"..i) == nil) then
                    local _,class = UnitClass("raid"..i);
				    oor_dead[UnitName("raid"..i)] = class;
                end
			end
		end
	elseif(GetNumGroupMembers()>0) then
		--check player
		local w = VBM_CheckForBuff("Well Fed","player");
		if(not w) then
			local _,class = UnitClass("player");
			if(not missing_well[1]) then missing_well[1] = {}; end
			missing_well[1][UnitName("player")] = class;
		end
		--check party
		for i=1,GetNumGroupMembers() do
			--dont check dead or out of range
			if((not UnitIsDeadOrGhost("party"..i)) and UnitIsVisible("party"..i)) then
				local w = VBM_CheckForBuff("Well Fed","party"..i);
				if(not w) then
					local _,class = UnitClass("party"..i);
					if(not missing_well[1]) then missing_well[1] = {}; end
					missing_well[1][UnitName("party"..i)] = class;
				end
			else
				local _,class = UnitClass("party"..i);
				oor_dead[UnitName("party"..i)] = class;
			end
		end
	end
	return missing_well,oor_dead;
end

function VBM_PopulateFlaskTooltip(self)
	local text = "Flask Check:";
	local texttochat = "Missing Elixir: ";
	if(GetNumGroupMembers()>0) then
		local both,battle,guard,except = VBM_ScanForElixirs();
		local n,d,name,class;
		--text = text.."\n"..vbm_c_y.."(Under dev, need help with buff names)";
		local totalcount = 0;
		--go both
		local count = 0;
		local temptext = "\n"..vbm_c_w.."Missing Both:";
		for n,d in pairs(both) do
			temptext = temptext.."\n"..vbm_c_grey..n..": ";
			for name,class in pairs(d) do
				temptext = temptext..VBM_GetTextClassColor(class)..name.." ";
				texttochat = texttochat..name.."(Both) ";
				count = count + 1;
				totalcount = totalcount + 1;
			end
		end
		if(count>0) then
			text = text..temptext;
			text = text.."\n"..vbm_c_grey.."Total: "..vbm_c_w..count;
		end
		--go battle
		local count = 0;
		local temptext = "\n"..vbm_c_w.."Missing Battle:";
		for n,d in pairs(battle) do
			temptext = temptext.."\n"..vbm_c_grey..n..": ";
			for name,class in pairs(d) do
				temptext = temptext..VBM_GetTextClassColor(class)..name.." ";
				texttochat = texttochat..name.."(Battle) ";
				count = count + 1;
				totalcount = totalcount + 1;
			end
		end
		if(count>0) then
			text = text..temptext;
			text = text.."\n"..vbm_c_grey.."Total: "..vbm_c_w..count;
		end
		--go guardian
		local count = 0;
		local temptext = "\n"..vbm_c_w.."Missing Guardian:";
		for n,d in pairs(guard) do
			temptext = temptext.."\n"..vbm_c_grey..n..": ";
			for name,class in pairs(d) do
				temptext = temptext..VBM_GetTextClassColor(class)..name.." ";
				texttochat = texttochat..name.."(Guardian) ";
				count = count + 1;
				totalcount = totalcount + 1;
			end
		end
		if(count>0) then
			text = text..temptext;
			text = text.."\n"..vbm_c_grey.."Total: "..vbm_c_w..count;
		end
		--go exceptions
		local count = 0;
		local temptext = "\n"..vbm_c_w.."Exceptions:";
		for n,d in pairs(except) do
			temptext = temptext.."\n"..vbm_c_grey..n..": ";
			for name,class in pairs(d) do
				temptext = temptext..VBM_GetTextClassColor(class[1])..name..vbm_c_w.." ("..class[2]..") ";
				texttochat = texttochat..name.."("..class[2]..") ";
				count = count + 1;
				totalcount = totalcount + 1;
			end
		end
		if(count>0) then
			text = text..temptext;
			text = text.."\n"..vbm_c_grey.."Total: "..vbm_c_w..count;
		end
		--sumarize
		if(totalcount==0) then
			text = text.."\n"..vbm_c_g.."All Have";
			texttochat = texttochat.."All Have";
		end
	else
		text = text.."\n"..vbm_c_r.."Not in Raid";
		texttochat = texttochat.."Not in Raid";
	end
	--add extra info
	text = text.."\n"..vbm_c_grey.."(Shift+Click): Paste to chat.";
	self.texttochat = texttochat;
	GameTooltip:SetOwner(self);
	GameTooltip:SetText(text);
	GameTooltip:Show();
end

function VBM_ScanForElixirs(msg,_,announce)
	local missing_both,missing_battle,missing_guardian,exceptions = {},{},{},{};
	local i;
	if(GetNumGroupMembers()>0) then
		for i=1,GetNumGroupMembers() do
			--dont check dead or out of range
			if((not UnitIsDeadOrGhost("raid"..i)) and UnitIsVisible("raid"..i)) then
				local b,g,except = VBM_ScanUnitForElixirs("raid"..i);
				local _,_,group = GetRaidRosterInfo(i);
				local _,class = UnitClass("raid"..i);
				if((not b) and (not g)) then
					if(not missing_both[group]) then missing_both[group] = {}; end
					missing_both[group][UnitName("raid"..i)] = class;
				elseif(not b) then
					if(not missing_battle[group]) then missing_battle[group] = {}; end
					missing_battle[group][UnitName("raid"..i)] = class;
				elseif(not g) then
					if(not missing_guardian[group]) then missing_guardian[group] = {}; end
					missing_guardian[group][UnitName("raid"..i)] = class;
				end
				if(except) then
					if(not exceptions[group]) then exceptions[group] = {}; end
					exceptions[group][UnitName("raid"..i)] = {class,except};
				end
			end
		end
	end
	return missing_both,missing_battle,missing_guardian,exceptions;
end

function VBM_ScanUnitForElixirs(unit)
	local i = 1;
	local text,name;
	local battle, guardian, exception = false,false,false;
	while(UnitBuff(unit,i) ~= nil) do
		name = UnitBuff(unit,i);
		if(name) then
			if(VBM_ELIXIR_EXCEPTIONS[name]) then
				exception = VBM_ELIXIR_EXCEPTIONS[name];
				battle = true; guardian = true;
				break;
			end
			if(VBM_BATTLE_ELIXIR[name]) then
				battle = true;
			end
			if(VBM_GUARDIAN_ELIXIR[name]) then
				guardian = true;
			end
			if(VBM_BOTH_ELIXIR[name]) then
				battle = true; guardian = true;
				break;
			end
			if(string.find(name,"Flask of",1,true)) then
				battle = true; guardian = true;
				break;
			end
		end
		text = VBM_GetBuffText(i,unit);
		if(text) then
			text = string.lower(text);
			if(string.find(text,"battle and guardian elixir",1,true)) then
				battle, guardian = true,true;
			elseif(string.find(text,"guardian and battle elixir",1,true)) then
				battle, guardian = true,true;
			elseif(string.find(text,"battle elixir",1,true)) then
				battle = true;
			elseif(string.find(text,"guardian elixir",1,true)) then
				guardian = true;
			end
		end
		text = "";	
		i = i + 1;
	end
	return battle, guardian, exception;
end

--[[
****************************************************************************
Rebirth Tracking
****************************************************************************
]]--

local rebirth = {
	druid = {},
	shaman = {},
	warlock = {},
	priestheal = {},
	druidheal = {},
};

function VBM_Rebirth_TrackingTest()
	--rebirth.druid["Vislike"] = {O = time()+60*20};
	--rebirth.warlock["Vislike"] = {O = time()+60*30};
	--rebirth.shaman["Vislike"] = {O = time()+10*60};
	vbm_print_table(rebirth);
end
--getting from extrafeatures.lua
function VBM_Rebirth_Tracking(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	
	--anyone gains a buff
	if( (combatEvent == "SPELL_CAST_SUCCESS" or combatEvent == "SPELL_RESURRECT"
		 or combatEvent == "SPELL_AURA_APPLIED" or combatEvent == "SPELL_AURA_REFRESH") and sourceName) then
		--check for spell casts
		if(spellName == "Rebirth") then
			rebirth.druid[sourceName] = {O = time()+60*10};
		elseif(spellName == "Soulstone Resurrection") then
			rebirth.warlock[sourceName] = {O = time()+60*15};
		elseif(spellName == "Reincarnation") then
			rebirth.shaman[sourceName] = {O = time()+60*30};
		end
	end
	if(combatEvent == "SPELL_CAST_SUCCESS") then
		if(spellName == "Tranquility") then
			rebirth.druidheal[sourceName] = {O = time()+60*8};
		elseif(spellName == "Divine Hymn") then
			rebirth.priestheal[sourceName] = {O = time()+60*8};
		end
	end
end

function VBM_PopulateRebirthTooltip(self)
	local text = "RaidRess Tracking:";
	local texttochat = "RaidRess: ";
	local texttochat2 = "AOE Healing: ";
	local i;
	--scan party or raid for druids shamans and locks
	local druids,warlocks,shamans,priests = {},{},{},{};
	local c;
	if(GetNumGroupMembers()>0) then
		for i=1,GetNumGroupMembers() do
			_,c = UnitClass("raid"..i);
			if(c=="DRUID") then
				druids[#druids+1] = UnitName("raid"..i);
			elseif(c=="WARLOCK") then
				warlocks[#warlocks+1] = UnitName("raid"..i);
			elseif(c=="SHAMAN") then
				shamans[#shamans+1] = UnitName("raid"..i);
			elseif(c=="PRIEST") then
				priests[#priests+1] = UnitName("raid"..i);
			end
		end
	elseif(GetNumGroupMembers()>0) then
		for i=1,GetNumGroupMembers() do
			_,c = UnitClass("party"..i);
			if(c=="DRUID") then
				druids[#druids+1] = UnitName("party"..i);
			elseif(c=="WARLOCK") then
				warlocks[#warlocks+1] = UnitName("party"..i);
			elseif(c=="SHAMAN") then
				shamans[#shamans+1] = UnitName("party"..i);
			elseif(c=="PRIEST") then
				priests[#priests+1] = UnitName("party"..i);
			end
		end
	end
	-- RESS SPELLS **************************************************************
	--Rebirth
	text = text.."\n"..vbm_c_w.."Rebirth:";
	if(#druids > 0) then
		table.sort(druids);
		texttochat = texttochat.."Rebirth: ";
		local tid,tidtext;
		for i=1,#druids do
			--get data
			if(rebirth.druid[druids[i]]) then
				--found rebirth data
				tid = rebirth.druid[druids[i]].O - time();
				if(tid > 0) then
					tidtext = string.format("%d:%.2d",tid/60,math.fmod(tid,60));
					texttochat = texttochat..druids[i].." ("..tidtext..") ";
					tidtext = vbm_c_w..tidtext;
				else
					texttochat = texttochat..druids[i].." (Ready) ";
					tidtext = vbm_c_g.."Ready";
				end
			else
				--nodata found
				texttochat = texttochat..druids[i].." (Ready*) ";
				tidtext = vbm_c_g.."Ready"..vbm_c_w.."*";
			end
			text = text.."\n"..VBM_GetTextClassColor("DRUID")..druids[i].." "..vbm_c_grey.."("..tidtext..vbm_c_grey..")";
		end
	else
		text = text.."\n"..vbm_c_grey.."No Druids in Group";
	end
	--Soulstone
	text = text.."\n"..vbm_c_w.."Soulstone:";
	if(#warlocks > 0) then
		table.sort(warlocks);
		texttochat = texttochat.."Soulstone: ";
		local tid,tidtext;
		for i=1,#warlocks do
			--get data
			if(rebirth.warlock[warlocks[i]]) then
				--found rebirth data
				tid = rebirth.warlock[warlocks[i]].O - time();
				if(tid > 0) then
					tidtext = string.format("%d:%.2d",tid/60,math.fmod(tid,60));
					texttochat = texttochat..warlocks[i].." ("..tidtext..") ";
					tidtext = vbm_c_w..tidtext;
				else
					texttochat = texttochat..warlocks[i].." (Ready) ";
					tidtext = vbm_c_g.."Ready";
				end
			else
				texttochat = texttochat..warlocks[i].." (Ready*) ";
				tidtext = vbm_c_g.."Ready"..vbm_c_w.."*";
			end

			text = text.."\n"..VBM_GetTextClassColor("WARLOCK")..warlocks[i].." "..vbm_c_grey.."("..tidtext..vbm_c_grey..")";
		end
	else
		text = text.."\n"..vbm_c_grey.."No Warlocks in Group";
	end
	--Reincarnation
--	text = text.."\n"..vbm_c_w.."Reincarnation:";
--	if(#shamans > 0) then
--		table.sort(shamans);
--		local tid,tidtext;
--		for i=1,#shamans do
--			--get data
--			if(rebirth.shaman[shamans[i]]) then
--				--found rebirth data
--				tid = rebirth.shaman[shamans[i]].O - time();
--			else
--				tid = 0;
--			end
--			if(tid > 0) then
--				tidtext = vbm_c_w..string.format("%d:%.2d",tid/60,math.fmod(tid,60));
--				tidtext = tidtext..vbm_c_grey.." W1T ";
--				if(tid - 10*60 > 0) then
--					tidtext = tidtext..vbm_c_w..string.format("%d:%.2d",(tid-10*60)/60,math.fmod((tid-10*60),60));
--					tidtext = tidtext..vbm_c_grey.." W2T ";
--					if(tid - 20*60 > 0) then
--						tidtext = tidtext..vbm_c_w..string.format("%d:%.2d",(tid-20*60)/60,math.fmod((tid-20*60),60));
--					else
--						tidtext = tidtext..vbm_c_g.."Ready";
--					end
--				else
--					tidtext = tidtext..vbm_c_g.."Ready";
--				end
--			else
--				tidtext = vbm_c_g.."Ready";
--			end
--			text = text.."\n"..VBM_GetTextClassColor("SHAMAN")..shamans[i].." "..vbm_c_grey.."("..tidtext..vbm_c_grey..")";
--		end
--	else
--		text = text.."\n"..vbm_c_grey.."No Shamans in Group";
--	end

	-- HEALING SPELLS **************************************************************
	text = text.."\n"..vbm_c.."AOE Healing Tracking:";
	--Divine Hymn
	text = text.."\n"..vbm_c_w.."Divine Hymn:";
	if(#priests > 0) then
		table.sort(priests);
		texttochat2 = texttochat2.."Divine Hymn: ";
		local tid,tidtext;
		for i=1,#priests do
			--get data
			if(rebirth.priestheal[priests[i]]) then
				--found Tranquility data
				tid = rebirth.priestheal[priests[i]].O - time();
				if(tid > 0) then
					tidtext = string.format("%d:%.2d",tid/60,math.fmod(tid,60));
					texttochat2 = texttochat2..priests[i].." ("..tidtext..") ";
					tidtext = vbm_c_w..tidtext;
				else
					texttochat2 = texttochat2..priests[i].." (Ready) ";
					tidtext = vbm_c_g.."Ready";
				end
			else
				--nodata found
				texttochat2 = texttochat2..priests[i].." (Ready*) ";
				tidtext = vbm_c_g.."Ready"..vbm_c_w.."*";
			end
			text = text.."\n"..vbm_c_grey..priests[i].." "..vbm_c_grey.."("..tidtext..vbm_c_grey..")";
		end
	else
		text = text.."\n"..vbm_c_grey.."No Priests in Group";
	end
	--Tranquility
	text = text.."\n"..vbm_c_w.."Tranquility:";
	if(#druids > 0) then
		table.sort(druids);
		texttochat2 = texttochat2.."Tranquility: ";
		local tid,tidtext;
		for i=1,#druids do
			--get data
			if(rebirth.druidheal[druids[i]]) then
				--found Tranquility data
				tid = rebirth.druidheal[druids[i]].O - time();
				if(tid > 0) then
					tidtext = string.format("%d:%.2d",tid/60,math.fmod(tid,60));
					texttochat2 = texttochat2..druids[i].." ("..tidtext..") ";
					tidtext = vbm_c_w..tidtext;
				else
					texttochat2 = texttochat2..druids[i].." (Ready) ";
					tidtext = vbm_c_g.."Ready";
				end
			else
				--nodata found
				texttochat2 = texttochat2..druids[i].." (Ready*) ";
				tidtext = vbm_c_g.."Ready"..vbm_c_w.."*";
			end
			text = text.."\n"..VBM_GetTextClassColor("DRUID")..druids[i].." "..vbm_c_grey.."("..tidtext..vbm_c_grey..")";
		end
	else
		text = text.."\n"..vbm_c_grey.."No Druids in Group";
	end
	
	-- SAVE **************************************************************
	text = text.."\n"..vbm_c_grey.."(Shift+Click): Paste to chat.";
	text = text.."\n"..vbm_c_w.."*"..vbm_c_grey.." = Not seen the spell casted, so assuming ready.";
	self.texttochat = texttochat;
	self.texttochat2 = texttochat2;
	GameTooltip:SetOwner(self);
	GameTooltip:SetText(text);
	GameTooltip:Show();
end
