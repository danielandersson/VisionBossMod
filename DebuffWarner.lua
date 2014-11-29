--[[
	********************************************************************
	********************************************************************
	Global debuff warner	
	********************************************************************
	********************************************************************
]]--

VBM_ALLTIME_DEBUFFS = {
		-- Format: debuff_to_look_for = {text_to_show, optional_func_to_run, optional mute = false, optional_func_to_run_on_debuff_off}
		["Rain of Fire"] = {"Rain of Fire"},
		["Blizzard"] = {"* * Blizzard * *"},
		["Rain of Chaos"] = {"Rain of Chaos"},
		["Death & Decay"] = {"Death & Decay"},
		["Death and Decay"] = {"Death and Decay"},
		["Consecration"] = {"* * Consecration * *"},
		
		["Burning Adrenaline"] = {"Burning Adrenaline"}, --Vaelastrasz
		["Living Bomb"] = {"Living Bomb"}, -- Baron Geddon
	};
	
--optimize
local VBM_DEBUFFSET = false;
local VBM_DEBUFFFUNC = false; --used to run function when debuff goes off
local VBM_debuffs;
local VBM_GetS = VBM_GetS;
--local VBM_DebuffWarner_GainDebuff;
--local VBM_DebuffWarner_LooseDebuff;

function VBM_DebuffWarner_On()
	VBM_ResetDebuffs();
	VBM_DEBUFFSET = false;
	
	--combatlog readings
	VBMDebuffFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	
	VBMDebuffFrame:RegisterEvent("PLAYER_DEAD");
	vbm_verbosec("Debuff Warner loaded!");
end

function VBM_DebuffWarner_Off()
	VBMDebuffFrame:UnregisterAllEvents();
	vbm_verbosec("Debuff Warner unloaded!");
end

function VBM_Debuff_OnEvent(self,event,...)
	if(event == "COMBAT_LOG_EVENT_UNFILTERED") then
       	local timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20 = ...;
       	
       	--if debuffwarner is on
		if(VBM_GetS("DebuffWarner")) then
			--if you gain a debuff
			if( (combatEvent == "SPELL_AURA_APPLIED" or combatEvent == "SPELL_AURA_APPLIED_DOSE") and destName and destName == UnitName("player")) then
				if(arg12 == "DEBUFF") then
					VBM_DebuffWarner_GainDebuff(spellName);
				end
			end
			--you take periodic damage REMOVED in CATA
			--if(combatEvent == "SPELL_PERIODIC_DAMAGE" and destName and destName == UnitName("player")) then
			--	VBM_DebuffWarner_GainDebuff(spellName);
			--end
		end
		
       	--if you lose a debuff
       	if(combatEvent == "SPELL_AURA_REMOVED" and destName and destName == UnitName("player")) then
       		if(arg12 == "DEBUFF") then
       			VBM_DebuffWarner_LooseDebuff(spellName);
       		end
       	end
       	
       	return;
    end
    
    --if the player dies always clear big warning text
	if(event == "PLAYER_DEAD") then
    	if(VBM_DEBUFFSET) then
    		vbm_cleardebuffwarn();
    		VBM_DEBUFFSET = false;
    	end
    end
end

--[[ /////////////////////////////
 Debuff warner
///////////////////////////// ]]--

local function VBM_AddDebuff(buff,text)
	VBM_debuffs[buff] = text;
end

function VBM_ResetDebuffs()
	VBM_debuffs = {};
	local k,v;
	for k,v in pairs(VBM_ALLTIME_DEBUFFS) do
		VBM_AddDebuff(k,v);
	end
	--vbm_verbosec("Debuffs reseted to standard");
end

function VBM_DebuffWarner_LoadSet(set)
	local k,v;
	for k,v in pairs(set) do
		VBM_AddDebuff(k,v);
	end
	if(VBM_BOSS) then
		vbm_verbosec("Debuff Warner loaded set: "..VBM_BOSS);
	end
end

VBM_DebuffWarner_GainDebuff = function(text)
	local k,v;
	for k,v in pairs(VBM_debuffs) do
		if(string.find(text,k)) then
			if(VBM_DEBUFFSET ~= k) then
				VBM_DEBUFFSET = k;
				if(v[1]) then
					if(not v[3]) then
						VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
					end
					vbm_debuffwarn(v[1],30);
				end
				if(v[2]) then
					v[2]();
				end
				if(v[4]) then
					VBM_DEBUFFFUNC = v[4];
				end
			end
			return;
		end
	end
end

VBM_DebuffWarner_LooseDebuff = function(text)
	if(VBM_DEBUFFSET and text and string.find(text,VBM_DEBUFFSET)) then
		vbm_cleardebuffwarn();
		VBM_DEBUFFSET = false;
		if(VBM_DEBUFFFUNC) then
			VBM_DEBUFFFUNC();
			VBM_DEBUFFFUNC = false;
		end
	end
end