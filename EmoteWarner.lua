--[[
	********************************************************************
	********************************************************************
	Global mob emote warner	
	********************************************************************
	********************************************************************
]]--

VBM_ALLTIME_EMOTES = {
		-- Format: emote_to_look_for = {text_to_show, bool_sound = true, func_to_run(arg1)}
		["deep breath"] = {"* * Deep Breath * *"},
	};
	
local ban_from_emote = {
	["Onyxian Whelpling"] = true,
};
--optimize
local VBM_emotes;
local VBM_GetS = VBM_GetS;
--local VBM_EmoteWarner_Emote;
	
function VBM_EmoteWarner_On()
	VBM_ResetEmotes();
	
	VBMEmoteWarnFrame:RegisterEvent("CHAT_MSG_MONSTER_EMOTE");
	VBMEmoteWarnFrame:RegisterEvent("CHAT_MSG_MONSTER_YELL");
	VBMEmoteWarnFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_EMOTE");
	VBMEmoteWarnFrame:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER");

	vbm_verbosec("Emote Warner loaded!");
end

function VBM_EmoteWarner_Off()
	VBMEmoteWarnFrame:UnregisterAllEvents();
	vbm_verbosec("Emote Warner unloaded!");
end

function VBM_EmoteWarner_OnEvent(self,event,arg1,arg2,arg3,arg4,arg5,arg6)
	if(VBM_GetS("EmoteWarner")) then
		vbm_debug("|cFFFFAA55<Emote debug> event = "..vbm_c_w..event.." |cFFFFAA55arg1 = "..vbm_c_w..arg1.." |cFFFFAA55arg2 = "..vbm_c_w..arg2);
		--filter out some mobs
		if(not ban_from_emote[arg2]) then
			VBM_EmoteWarner_Emote(arg1,arg2);
		end
	end
end

--[[ /////////////////////////////
 Emote warner
///////////////////////////// ]]--

local function VBM_AddEmote(buff,text)
	VBM_emotes[buff] = text;
end

function VBM_ResetEmotes()
	VBM_emotes = {};
	local k,v;
	for k,v in pairs(VBM_ALLTIME_EMOTES) do
		VBM_AddEmote(k,v);
	end
	--vbm_verbosec("Emote Warner reseted to standard");
end

function VBM_EmoteWarner_LoadSet(set)
	local k,v;
	for k,v in pairs(set) do
		VBM_AddEmote(k,v);
	end
	if(VBM_BOSS) then
		vbm_verbosec("Emote Warner loaded set: "..VBM_BOSS);
	end
end

VBM_EmoteWarner_Emote = function(text,who)
	local k,v;
	for k,v in pairs(VBM_emotes) do
		if(string.find(text,k)) then
			--text
			if(v[1]) then
				vbm_bigwarn(v[1],5);
			end
			--sound
			local s = true;
			if(type(v[2]) == "boolean" and v[2]==false) then
				s = false;
			end
			if(s) then
				VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
			end
			--func
			if(v[3]) then
				v[3](text,who);
			end
		end
	end
end