--[[
	********************************************************************
	********************************************************************
	Instance Specific
	********************************************************************
	********************************************************************
]]--

--vars
local VBM_TEARSCHECK = {};
local VBM_TEARSCHECKSTARTED = false;

function VBM_InstanceSpecific_OnLoad(self)
	--tears of the goddes check
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");

	self:RegisterEvent("CHAT_MSG_RAID");
	self:RegisterEvent("CHAT_MSG_RAID_LEADER");
	self:RegisterEvent("CHAT_MSG_PARTY");
	
	self:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
	self:RegisterEvent("BATTLEFIELDS_SHOW");
end

function VBM_InstanceSpecific_OnEvent(self,event,...)
	if(event == "COMBAT_LOG_EVENT_UNFILTERED") then
		if(VBM_TEARSCHECKSTARTED) then
			VBM_TearsOfTheGoddessCheck(...);
		end
		return;
	end
	
	if(event == "CHAT_MSG_RAID" or
		event == "CHAT_MSG_RAID_LEADER" or
		event == "CHAT_MSG_PARTY") then
		VBM_AVEvent(...);
	end
	
	if(event == "UPDATE_BATTLEFIELD_STATUS") then
		VBM_AVBGUpdate();
	end
	
	if(event == "BATTLEFIELDS_SHOW") then
		VBM_AVFrameShown();
	end
end




--[[
	********************************************************************
		General:
	
	AutoZoneingOptions
	********************************************************************
]]--

function VBM_AutoZoneIn()
	if(VBM_GetS("AutoDetailedLoot")) then
		VBM_SetCVar("showLootSpam","0",1);
	end
	if(VBM_GetS("AutoPlayerNames")) then
		VBM_SetCVar("UnitNamePlayer","0",1);
	end
	if(VBM_GetS("AutoPlayerGuildNames")) then
		VBM_SetCVar("UnitNamePlayerGuild","0",1);
	end
	if(VBM_GetS("AutoPlayerTitles")) then
		VBM_SetCVar("UnitNamePlayerPVPTitle","0",1);
	end
	
	VBM_AutoZoneInGearCheck();
end

function VBM_AutoZoneOut()
	if(VBM_GetS("AutoDetailedLoot")) then
		VBM_SetCVar("showLootSpam","1",1);
	end
	if(VBM_GetS("AutoPlayerNames")) then
		VBM_SetCVar("UnitNamePlayer","1",1);
	end
	if(VBM_GetS("AutoPlayerGuildNames")) then
		VBM_SetCVar("UnitNamePlayerGuild","1",1);
	end
	if(VBM_GetS("AutoPlayerTitles")) then
		VBM_SetCVar("UnitNamePlayerPVPTitle","1",1);
	end
	
	if(VBM_GetS("AutoMalygosUI")) then
		VBMMalygosFrame:Hide();
	end
end

function VBM_AutoZoneInGearCheck()
	local name,link;
	link = GetInventoryItemLink("player", GetInventorySlotInfo("NeckSlot"));
	if(not link) then return; end
	name = GetItemInfo(link);
	if(name == "Blessed Medallion of Karabor") then
		vbm_printc("You are wearing: "..link);
		vbm_infowarn("You are wearing [Blessed Medallion of Karabor]",10);
	end	
end

--[[
	********************************************************************
		Alterac Valley:
	

	********************************************************************
]]--

VBM_AVCOUNTDOWNID = 0;
VBM_AVSETBG = 0;

function VBM_AVCountDownStart()
	if(IsRaidLeader()) then
		vbm_sendchat("Alterac Valley countdown started, open the Join Battle frame and leave current queue");
		VBM_Delay(1,vbm_sendchat,"9");
		VBM_Delay(2,vbm_sendchat,"8");
		VBM_Delay(3,vbm_sendchat,"7");
		VBM_Delay(4,vbm_sendchat,"6");
		VBM_Delay(5,vbm_sendchat,"5");
		VBM_Delay(6,vbm_sendchat,"4");
		VBM_Delay(7,vbm_sendchat,"3");
		VBM_Delay(8,vbm_sendchat,"2");
		VBM_Delay(9,vbm_sendchat,"1");
		VBM_Delay(10,vbm_sendchat,"Join Alterac Valley, random id "..random(1111,9999));
	else
		vbm_printc("ERROR: You are not raid leader");
	end
end

function VBM_AVEvent(arg1)
	if(VBM_GetS("AVAutoJoin")) then
		local found,p1,i;
		found,_,p1 = string.find(arg1,"<VBM> Join Alterac Valley, random id (.+)");
		if(found) then
			--check if frame is shown
			if(BattlefieldFrame:IsShown()) then
				if(GetBattlefieldInfo()=="Alterac Valley") then
					--check to see that AV is not allready queued so we can destroy the sim queue
					local queue = true;
					for i=1, MAX_BATTLEFIELD_QUEUES do
						local status, mapName, instanceID = GetBattlefieldStatus(i);
						if(status == "queued" and mapName == "Alterac Valley") then
							queue = false;
						end
					end
					if(queue) then
						vbm_printc("Alterac Valley frame open Attemting to join queue, saving random id |cFFFFFFFF"..p1);
						VBM_AVCOUNTDOWNID = tonumber(p1);
						JoinBattlefield(0);
						CloseBattlefield();
					else
						vbm_printc("ERROR: You allready have an entry for Alterac Valley");
					end
				end
			end
		end
		
		found,_,p1 = string.find(arg1,"<VBM> Got Alterac Valley (.+) random id "..VBM_AVCOUNTDOWNID);
		if(found) then
			VBM_AVCOUNTDOWNID = 0;
			VBM_AVREQUEUE = 0;
			VBM_AVAutoSetBG(tonumber(p1));
		end		
	end
end

function VBM_AVAutoSetBG(bgid)
	--if we are queued then try to join the requested bg
	if(VBM_GetS("AVAutoJoin")) then
		local i;
		for i=1, MAX_BATTLEFIELD_QUEUES do
			local status, mapName, instanceID = GetBattlefieldStatus(i);
			if(status == "queued" and mapName == "Alterac Valley") then
				--make 3 trys
				VBM_AVREQUEUE = VBM_AVREQUEUE + 1;
				if(VBM_AVREQUEUE < 4) then
					vbm_printc("Attemt "..VBM_AVREQUEUE.." to requeue to Alterac Valley "..bgid);
					if(BattlefieldFrame:IsShown() and GetBattlefieldInfo()=="Alterac Valley") then
						VBM_AVSelectBG(bgid);
					else
						VBM_AVSETBG = bgid;
						ShowBattlefieldList(i);
					end
				else
					vbm_printc("FAILED: to requeue to Alterac Valley "..bgid);
				end
			end
		end
	end
end

function VBM_AVFrameShown()
	if(VBM_AVSETBG>0) then
		VBM_AVSelectBG(VBM_AVSETBG);
		VBM_AVSETBG = 0;
	end
end

function VBM_AVSelectBG(bgid)
	local nr = GetNumBattlefields();
	local i;
	for i=1,nr do
		if(GetBattlefieldInstanceInfo(i)==bgid) then
			JoinBattlefield(i);
			CloseBattlefield();
		end
	end
	VBM_Delay(2,VBM_AVRecheck,bgid);
end

function VBM_AVRecheck(bgid)
	local i;
	for i=1, MAX_BATTLEFIELD_QUEUES do
		local status, mapName, instanceID = GetBattlefieldStatus(i);
		if(status == "queued" and mapName == "Alterac Valley") then
			if(bgid == instanceID) then
				vbm_printc("SUCCESS: You are now successfully queued to Alterac Valley "..bgid);
			else
				VBM_AVAutoSetBG(bgid);
			end
		end
	end
end

function VBM_AVBGUpdate()
	local i;
	for i=1, GetMaxBattlefieldID() do
		local status, mapName = GetBattlefieldStatus(i);
		if(status == "confirm" and mapName == "Alterac Valley") then
			if(VBM_AVCOUNTDOWNID>0) then
				vbm_sendchat("Got "..mapName.." random id "..VBM_AVCOUNTDOWNID);
				VBM_AVCOUNTDOWNID = 0;
			end
		end
	end
end

--[[
	********************************************************************
		Hyjal Summit:
	
	TearsOfTheGoddesCheck
	********************************************************************
]]--

function VBM_TearsOfTheGoddessCheck(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	--anyone gains a buff
	if(combatEvent == "SPELL_AURA_APPLIED" and destName) then
		local auraType = arg12;
		if(spellName == "Elune's Embrace") then
			if(VBM_TEARSCHECK[destName]) then
				VBM_TEARSCHECK[destName] = nil;
				VBM_TearsOfTheGoddessCheckAllHave();
			end
		end
	end
end

function VBM_TearsOfTheGoddessCheckAllHave()
	local k,v,i;
	i = 0;
	for k,v in pairs(VBM_TEARSCHECK) do
		i = i + 1;
	end
	if(i==0) then
		vbm_sendchat("All have [Tears of the Goddess]");
	end
end

function VBM_TearsOfTheGoddessCheckStart()
	if(IsRaidLeader() or IsRaidOfficer()) then
		VBM_TEARSCHECK = {};
		for i=1,GetNumRaidMembers() do
			VBM_TEARSCHECK[UnitName("raid"..i)] = true;
		end
		vbm_sendchat("Starting [Tears of the Goddess] check, please click on it to verfy");
		VBM_DelayByName("tears1",10,VBM_TearsOfTheGoddessCheckEnd,1);
		VBM_DelayByName("tears2",20,VBM_TearsOfTheGoddessCheckEnd,2);
		VBM_DelayByName("tears3",30,VBM_TearsOfTheGoddessCheckEnd,3);
		VBM_TEARSCHECKSTARTED = true;
	else
		vbm_printc("You are not a Raidleader or Raidofficer");
	end
end

function VBM_TearsOfTheGoddessCheckEnd(n)
	local names = "";
	local k,v,i;
	i = 0;
	for k,v in pairs(VBM_TEARSCHECK) do
		names = k..", "..names;
		i = i + 1;
	end
	if(i>0) then
		if(n==1) then
			vbm_sendchat("Check ends in 20 sec missing: "..names);
		elseif(n==2) then
			vbm_sendchat("Check ends in 10 sec missing: "..names);
		elseif(n==3) then
			vbm_sendchat("Check ended missing: "..names);
			VBM_TEARSCHECKSTARTED = false;
		end
	end
end

--[[
	********************************************************************
		Eye of Eternity:
	
	frame toggle
	********************************************************************
]]--

function VBM_Toggle_MalygosUI()
	if(VBMMalygosFrame:IsShown()) then
		VBMMalygosFrame:Hide();
	else
		VBMMalygosFrame:Show();
	end
end
function VBM_MalygosUI_LockMouse()
	VBMMalygosFrame.locked = true;
	VBMMalygosFrame:EnableMouse(0);
end
function VBM_MalygosUI_UnLockMouse()
	VBMMalygosFrame.locked = nil;
	VBMMalygosFrame:EnableMouse(1);
end

--[[
	********************************************************************
		Ulduar :
	
	Vehicle Setup
	Item level checker
	********************************************************************
]]--

function VBM_Ulduar_Vehicle_Setup()
	if(IsRaidLeader() or IsRaidOfficer()) then
		local mark=1;
		local demo,chop,sige,none,demotur,sigetur = {},{},{},{},{},{};
		local i;
		for i=1,GetNumRaidMembers() do
			if(UnitName("raid"..i.."pet")=="Salvaged Demolisher") then
				demo[#demo+1] = UnitName("raid"..i).."{"..VBM_GetMarkNameFromNumber(mark).."}";
				--also mark them
				SetRaidTarget("raid"..i.."pet",mark);
				mark=mark+1;
			elseif(UnitName("raid"..i.."pet")=="Salvaged Demolisher Mechanic Seat") then	
				demotur[#demotur+1] = UnitName("raid"..i);
			elseif(UnitName("raid"..i.."pet")=="Salvaged Siege Engine") then
				sige[#sige+1] = UnitName("raid"..i);
			elseif(UnitName("raid"..i.."pet")=="Salvaged Siege Turret") then
				sigetur[#sigetur+1] = UnitName("raid"..i);
			elseif(UnitName("raid"..i.."pet")=="Salvaged Chopper") then
				chop[#chop+1] = UnitName("raid"..i);
			else
				none[#none+1] = UnitName("raid"..i);
			end
		end
		
		vbm_sendchat("Vehicle Setup:");
		vbm_sendchat("Demolisher ("..#demo.."): "..table.concat(demo,", "));
		vbm_sendchat("Demo Turret ("..#demotur.."): "..table.concat(demotur,", "));
		vbm_sendchat("Siege Engine ("..#sige.."): "..table.concat(sige,", "));
		vbm_sendchat("Siege Turret ("..#sigetur.."): "..table.concat(sigetur,", "));
		vbm_sendchat("Chopper ("..#chop.."): "..table.concat(chop,", "));
		vbm_sendchat("None ("..#none.."): "..table.concat(none,", "));
	else
		vbm_printc("Error: You are not RaidLeader or RaidOfficer");
	end
end

function VBM_DoiLvlInspect(uid,ilvl)
	if(CanInspect(uid)) then
		InspectUnit(uid);
		local i,ilink;
		local items = {};
		for i=0,19 do
			ilink = GetInventoryItemLink(uid,i);
			if(ilink) then
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(ilink);
				if(itemLevel) then
					if(itemLevel > ilvl) then
						vbm_debug(vbm_c_bronze.."<VBM Inspect> "..vbm_c_w..UnitName(uid)..vbm_c_v.." => "..ilink..vbm_c_v.." => "..vbm_c_w..itemLevel);
						items[#items+1] = ilink.."("..itemLevel..")";
					end
				else
					vbm_print(vbm_c_bronze.."<VBM Inspect> "..vbm_c_r.."ERROR: "..vbm_c_w..UnitName(uid)..vbm_c_p.." failed to get ilvl for slot "..vbm_c_w..i.." "..ilink);
				end
			else
				--check for important armor slots
				if( (i>=1 and i<=3) or (i>=5 and i<=16) or (i==18) ) then
					vbm_print(vbm_c_bronze.."<VBM Inspect> "..vbm_c_r.."ERROR: "..vbm_c_w..UnitName(uid)..vbm_c_p.." failed to get item in slot "..vbm_c_w..i);
				end
			end
		end
		if(#items>0) then
			return ""..UnitName(uid)..": "..table.concat(items,", ");
		end
	else
		if(UnitExists(uid)) then
			--vbm_print(vbm_c_bronze.."<VBM Inspect> "..vbm_c_r.."ERROR: "..vbm_c_w..UnitName(uid)..vbm_c_p.." out of range.");
			return ""..UnitName(uid)..": Out of range.";
		else
			vbm_print(vbm_c_bronze.."<VBM Inspect> "..vbm_c_r.."ERROR: "..vbm_c_w..uid..vbm_c_p.." does not exists.");
		end		
	end
	return false;
end

function VBM_CheckRaidForMaxItemLevel(ilvl,chat)
	local res,i;
	if(GetNumRaidMembers()==0) then
		--if not in a raid inspect player and target
		vbm_print(vbm_c_g.."<VBM Inspect "..ilvl.."> "..vbm_c_r.."not in raid,"..vbm_c_p.." inspecting "..vbm_c_w.."Player");
		res = VBM_DoiLvlInspect("player",ilvl);
		if(res) then
			if(chat) then
				vbm_sendchat(res);
			else
				vbm_print(res);
			end
		end
		vbm_print(vbm_c_g.."<VBM Inspect "..ilvl.."> "..vbm_c_r.."not in raid,"..vbm_c_p.." inspecting "..vbm_c_w.."Target");
		res = VBM_DoiLvlInspect("target",ilvl);
		if(res) then
			if(chat) then
				vbm_sendchat(res);
			else
				vbm_print(res);
			end
		end
	else
		--but if in a raid inspect it
		if(chat) then
			vbm_sendchat("Doing an Item Level "..ilvl.." inspect check.");
		else
			vbm_print(vbm_c_g.."<VBM Inspect "..ilvl.."> "..vbm_c_p.."inspecting "..vbm_c_w.."Raid");
		end
		for i=1,GetNumRaidMembers() do
			res = VBM_DoiLvlInspect("raid"..i,ilvl);
			if(res) then
				if(chat) then
					vbm_sendchat(res);
				else
					vbm_print(res);
				end
			end
		end
	end
	
	--queue close inspect window
	VBM_Delay(1,function()
		if(InspectFrame) then InspectFrame:Hide(); end
		if(Examiner) then Examiner:Hide(); end
	end);
end

function VBM_UlduarAlgalonIlvlCheck()
	VBM_CheckRaidForMaxItemLevel(226);
end

function VBM_UlduarAlgalonIlvlCheckChat()
	VBM_CheckRaidForMaxItemLevel(226,"chat");
end
