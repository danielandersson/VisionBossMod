--[[
	********************************************************************
	********************************************************************
	RaidModes
	********************************************************************
	********************************************************************
]]--

function VBM_RaidModes_OnLoad(self)
	self:RegisterEvent("CHAT_MSG_RAID");
	self:RegisterEvent("CHAT_MSG_RAID_LEADER");
	
	self:RegisterEvent("RAID_TARGET_UPDATE");
	self:RegisterEvent("PLAYER_TARGET_CHANGED");
end

function VBM_RaidModes_OnEvent(self,event,arg1,arg2,arg3,arg4,arg5,arg6)
	if(event == "CHAT_MSG_RAID" or
		event == "CHAT_MSG_RAID_LEADER") then
			VBM_RM_Commands(arg1,arg2,true);
	end
	if(event == "RAID_TARGET_UPDATE") then
		VBM_RM_UpdateRaidMark(true);
	end
	if(event == "PLAYER_TARGET_CHANGED") then
		VBM_RM_UpdateRaidMark();
	end
end

function VBM_RaidModes_Init()
	SlashCmdList["VisionBossMod_RaidModes_cmd"] = VBM_RM_LocalCommand;
	SLASH_VisionBossMod_RaidModes_cmd1 = "/rmcmd";
	SlashCmdList["VisionBossMod_RaidModes_list"] = VBM_RM_List;
	SLASH_VisionBossMod_RaidModes_list1 = "/rmlist";
	
	VBM_RM_ClearAll();
end

--[[
VBM_MODES = {
	["mark"] = {
		["Nightfog"] = {
			mode = "ol",
			mark = 8,
		},
		["Test"] = {
			mode = "ol",
			mark = 7,
		},
	},
	["group"] = {
		["Nightfog"] = 3,
	}
	
};
]]--

--[[
	********************************************************************
	Local
	********************************************************************
]]--

function VBM_RM_List()
	vbm_printc("Listing raidmodes:");
	local m,d,p,d2;
	for m,d in pairs(VBM_MODES) do
		vbm_print(vbm_c_y..m..":");
		for p,d2 in pairs(d) do
			if(m=="mark") then
				vbm_print(vbm_c_w..p..vbm_c_g.." mode: "..vbm_c_w..d2.mode..vbm_c_g.." mark: "..vbm_c_w..d2.mark);
			elseif(m=="group") then
				vbm_print(vbm_c_w..p..vbm_c_g.." = "..vbm_c_w..d2);
			end
		end
	end
end

function VBM_RM_ClearAll()
	VBM_MODES = {
		mark = {},
		group = {},
	};
end

function VBM_RaidModes_RequestSend()
	if(IsRaidLeader() or IsRaidOfficer()) then
		local m,d,p,d2;
		for m,d in pairs(VBM_MODES) do
			for p,d2 in pairs(d) do
				if(m=="mark") then
					vbm_send_mess("RAIDMODE +mark "..p.." "..d2.mark.." "..d2.mode);
				elseif(m=="group") then
					vbm_send_mess("RAIDMODE +group "..p.." "..d2);
				end
			end
		end
	end
end

function VBM_RM_LocalCommand(cmd)
	if(VBM_IN_RAID) then
		vbm_printc("You are currently in a raidgroup and that disables /rmcmd");
	else
		VBM_RM_Commands(cmd,VBM_YOU,false);
	end
end

function VBM_RM_Commands(cmd,from,send_data)
	--only parse your own commands
	if(from~=VBM_YOU) then
		return;
	end
	
	local found,p1,p2,p3;
	--lowercase string
	cmd = string.lower(cmd);
	local you = string.lower(VBM_YOU);
	local send = false;
	
	found,_,p1,p2 = string.find(cmd,"([%+%-])(.+)");
	if(found==1) then
		--check then it comes from raidchat if you are officer och leader
		if(send_data) then
			if(VBM_GetRank(VBM_YOU)<1) then
				vbm_printc("ERROR: You are not raidleader or raidofficer");
				return;
			end
		end
		--get args
		local i=1;
		local args ={};
		for p3 in string.gmatch (p2,"([^%s]+)") do
			args[i] = p3;
			i = i + 1;
		end
		--Process commands
		if(p1=="+") then
			if(args[1]=="mark") then
				--mark commands
				if(args[2]) then
					if(args[3]) then
						if(args[4]) then
							if(VBM_RM_Mark_modelist[args[4]]) then
								VBM_MODES["mark"][args[2]] = {mode = args[4],mark = VBM_RM_GetMark(args[3])}; send = true;
							else
								vbm_print(vbm_c_y.."RaidMode ERROR mode does not exist: "..vbm_c_w..args[4]);
							end
						else
							VBM_MODES["mark"][args[2]] = {mode = "ol",mark = VBM_RM_GetMark(args[3])}; send = true;
						end
					else
						VBM_RM_Commands("+mark "..args[2].." "..VBM_RM_GetMarkU(),from,send_data);
					end
				else
					VBM_RM_Commands("+mark "..you.." "..VBM_RM_GetMarkU(),from,send_data);
				end
			elseif(args[1]=="group") then
				if(args[2] and args[3]) then
					VBM_MODES["group"][args[2]] = VBM_RM_Group_nr(args[3]); send = true;
				else
					vbm_print(vbm_c_y.."RaidMode ERROR syntax: "..cmd);
				end
			else
				vbm_print(vbm_c_y.."RaidMode ERROR command does not exist: "..vbm_c_w..args[1]);
			end
		elseif(p1=="-") then
			if(args[1]=="all") then
				VBM_RM_ClearAll(); send = true;
			elseif(args[1]=="mark") then
				--mark commands
				if(args[2]) then
					if(args[2]=="all") then
						VBM_MODES["mark"] = {}; send = true;
					else
						VBM_MODES["mark"][args[2]] = nil; send = true;
					end
				else
					VBM_RM_Commands("-mark "..you,from,send_data);
				end
			elseif(args[1]=="group") then
				--group commands
				if(args[2]) then
					if(args[2]=="all") then
						VBM_MODES["group"] = {}; send = true;
					else
						VBM_MODES["group"][args[2]] = nil; send = true;
					end
				else
					VBM_RM_Commands("-group "..you,from,send_data);
				end
			else
				vbm_print(vbm_c_y.."RaidMode ERROR command does not exist: "..vbm_c_w..args[1]);
			end
		end
	end
	
	--sends the data if its correct
	if(send_data and send) then
		vbm_send_mess("RAIDMODE "..cmd);
		vbm_verbosec("Data sent: "..cmd);
	end
end

--[[
	********************************************************************
	Commands
	********************************************************************
]]--

VBM_RM_Mark_modelist = {
	ol = true,
	oa = true,
	no = true,
};

function VBM_RM_GetMark(m)
	
	if(string.len(m)==1) then
		m = tonumber(m);
		if(m > 0 and m < 9) then
			return m;
		end
	else
		if(m=="star") then
			return 1;
		elseif(m=="circle") then
			return 2;
		elseif(m=="diamond") then
			return 3;
		elseif(m=="triangle") then
			return 4;
		elseif(m=="moon") then
			return 5;
		elseif(m=="square") then
			return 6;
		elseif(m=="cross") then
			return 7;
		elseif(m=="skull") then
			return 8;
		end
	end
	return VBM_RM_GetMarkU();
end

function VBM_RM_GetMarkU()
	--get highest unused mark
	local p,d2,i;
	local mlist = {};
	for p,d2 in pairs(VBM_MODES.mark) do
		mlist[d2.mark] = true;
	end
	for i=8,1,-1 do
		if(not mlist[i]) then
			return i;
		end
	end
	return 0;
end

function VBM_RM_Group_nr(nr)
	nr = tonumber(nr);
	if(nr and nr>0 and nr<9) then
		return nr;
	end
	return 0;
end


--[[
	********************************************************************
	Functions
	********************************************************************
]]--

local function VBM_RM_DoRaidMarkUpdate()
	if(UnitExists("target") and not UnitIsPlayer("target")) then
		local d = VBM_MODES.mark[string.lower(VBM_YOU)];
		local t = GetRaidTargetIndex("target");
		if(t==nil or (d.mode == "oa" and t ~= d.mark) or (d.mode=="ol" and t < d.mark)) then
			SetRaidTarget("target", d.mark)
		end
	end
end

function VBM_RM_UpdateRaidMark(delay)
	if(VBM_MODES.mark[string.lower(VBM_YOU)]) then
		if(delay) then
			VBM_Delay(0.1,VBM_RM_DoRaidMarkUpdate);
		else
			VBM_RM_DoRaidMarkUpdate()
		end

	end
end

function VBM_GetGroupSpecial(unid)
	if(VBM_MODES.group[string.lower(unid)]) then
		return VBM_MODES.group[string.lower(unid)];
	end
	return VBM_GetGroupNr(unid);
end