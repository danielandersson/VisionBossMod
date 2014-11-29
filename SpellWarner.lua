--[[
	********************************************************************
	********************************************************************
	Global mob spellcast warner	
	********************************************************************
	********************************************************************
]]--

VBM_ALLTIME_SPELLS = {
		--[[ Format:
		Events Supported:
		SPELL_DAMAGE, SPELL_MISSED, SPELL_CAST_START, SPELL_CAST_SUCCESS, SPELL_HEAL
		SPELL_PERIODIC_DAMAGE
		SPELL_SUMMON SPELL_CREATE
		SPELL_AURA_APPLIED, SPELL_AURA_REMOVED, SPELL_AURA_APPLIED_DOSE, SPELL_AURA_REMOVED_DOSE
		SPELL_INTERRUPT
		SWING_DAMAGE, SWING_MISSED
		UNIT_DIED
		ENVIRONMENTAL_DAMAGE
		Specoal Events: (Must specify special = true)
		UNIT_SPELLCAST_SUCCEEDED
		
		
		["Name"] = {
			-- must exist
			event = "SPELL_DAMAGE",
			or
			special = true, -- if you want it loaded as a special event instead of a regular
			-- below stuff apply to a normal "event" not a special
			-- checks all vars and only go if all is true
			spell = "Void Zone",
			interrupted = "Frostbolt",
			dest = VBM_YOU,
			src = VBM_YOU,
			amount = 5, --used for dose auras
			logic = ">", --logic to use for dose auras, current supported: > ==
			selfsrc = true,  --only go if you are src
			selfdest = true, --only go if you are dest
			overkilled = true, --if the overkilled arg in spell damage is set
			-- data to show
			mess = "* * Void Zone Damage * *",
			color = "", -- color off mess, Red Default, can be: green, orange, purple, yellow, teal, white, grey
			duration = 0.3, --if not set defaults to 5
			sound = true, -- plays dong if set
			lowersound = true, -- playes lower sound
			simonsound = true, --blades edge simon game sound
			boatsound = true, --alliance boat docking sound
			runesound = true, --bg rune spawn
			pvpflag1sound = true, -- alliance flag taken
			pvpflag2sound = true, -- horde flag taken
			--function ro run
			func = func_to_run, --will be called with func_to_run(sourceName, destName, sendextra)
			--timers
			timer = 50, --in seconds
			timername = "Name", -- overide the event name
			texture = "name_of_texture", --vbm will look in: Interface\Icons\*
		},

		Example:
		["Void Zone"] = {
			event = "SPELL_DAMAGE",
			src = "Void Zone",
			dest = VBM_YOU,
			mess = "* * Void Zone Damage * *",
			duration = 0.3,
		},]]--
	};
--optimize
local VBM_spells;
local spell_events;
local VBM_GetS = VBM_GetS;
--local VBM_SpellWarner_Spell;
--local VBM_SpellWarner_SpecialSpell;

function VBM_SpellWarner_On()
	VBM_ResetSpells();
	
	VBMSpellWarnFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	VBMSpellWarnFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED");

	vbm_verbosec("Spell Warner loaded!");
end

function VBM_SpellWarner_Off()
	VBMSpellWarnFrame:UnregisterAllEvents();
	vbm_verbosec("Spell Warner unloaded!");
end

function VBM_SpellWarner_OnEvent(self,event,...)
	if(event == "COMBAT_LOG_EVENT_UNFILTERED") then
		local arg1,arg2 = ...;
		if(VBM_GetS("SpellcastWarner") and spell_events[arg2]) then
			VBM_SpellWarner_Spell(...);
		end
		return;
	end
	if(event == "UNIT_SPELLCAST_SUCCEEDED") then
		if(VBM_GetS("SpellcastWarner")) then
			local arg1,arg2,arg3 = ...;
			VBM_SpellWarner_SpecialSpell(event,arg1,arg2,arg3);
		end
		return;
	end
end

--[[ /////////////////////////////
 Spell warner
///////////////////////////// ]]--

local function VBM_AddSpell(buff,text)
	VBM_spells[buff] = text;
	if(text.event) then
		spell_events[text.event] = true;
	end
end

function VBM_ResetSpells()
	VBM_spells = {};
	VBM_specialcasted = {};
	spell_events = {};
	local k,v;
	for k,v in pairs(VBM_ALLTIME_SPELLS) do
		VBM_AddSpell(k,v);
	end
	--vbm_verbosec("Spell Warner reseted to standard");
end

function VBM_SpellWarner_LoadSet(set)
	local k,v;
	for k,v in pairs(set) do
		if(v.special) then
			VBM_specialcasted[k] = v;
		else
			VBM_AddSpell(k,v);
		end
	end
	if(VBM_BOSS) then
		vbm_verbosec("Spell Warner loaded a set!: "..VBM_BOSS);
	end
end

VBM_SpellWarner_SpecialSpell = function(event,...)
	local k,v;
	for k,v in pairs(VBM_specialcasted) do
		if(v.event == event) then
			if(v.func) then
				v.func(...);
			end
		end
	end
end

VBM_SpellWarner_Spell = function(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	local k,v,go,sendextra;
	for k,v in pairs(VBM_spells) do
		if(combatEvent == v.event) then
			go = true;
			sendextra = false;
			
			if(combatEvent == "SPELL_CAST_START" or combatEvent == "SPELL_CAST_SUCCESS" or 
				combatEvent == "SPELL_SUMMON" or combatEvent == "SPELL_HEAL" or combatEvent == "SPELL_CREATE") then
				local spellName = arg10;
				if(v.spell and not (v.spell == spellName) ) then
					go = false;
				end
			end
			
			if(combatEvent == "SPELL_SUMMON") then
				sendextra = destGUID;
			end
			
			if(combatEvent == "SPELL_MISSED") then
				local spellName,missType = arg10,arg12;
				sendextra = missType;
				if(v.spell and not (v.spell == spellName) ) then
					go = false;
				end
			end
			
			if(combatEvent == "SPELL_DAMAGE" or combatEvent == "SPELL_PERIODIC_DAMAGE") then
				local spellName,amount,overkill = arg10,arg12,arg13;
				sendextra = amount;
				if(v.spell and not (v.spell == spellName) ) then
					go = false;
				end
				if(v.overkilled and not (overkill > 0)) then
					go = false;
				end
			end
			
			if(combatEvent == "ENVIRONMENTAL_DAMAGE") then
				local spellName,amount = arg9,arg10;
				sendextra = amount;
				if(v.spell and not (string.upper(v.spell) == spellName) ) then
					go = false;
				end
			end
			
			if(combatEvent == "SPELL_AURA_APPLIED" or combatEvent == "SPELL_AURA_REMOVED") then
				local spellName, auraType = arg10,arg12;
				if(v.spell and not (v.spell == spellName) ) then
					go = false;
				end
			end
			
			if(combatEvent == "SPELL_INTERRUPT") then
				local spellName, interruptSpell = arg10,arg13;
				sendextra = interruptSpell;
				if(v.spell and not (v.spell == spellName) ) then
					go = false;
				end
				if(v.interrupted and not (v.interrupted == interruptSpell) ) then
					go = false;
				end
			end
			
			if(combatEvent == "SPELL_AURA_APPLIED_DOSE" or combatEvent == "SPELL_AURA_REMOVED_DOSE") then
				local spellName, auraType, amount = arg10,arg12,arg13;
				sendextra = amount;
				if(v.spell and not (v.spell == spellName) ) then
					go = false;
				end
				
				if(v.amount and v.logic) then
					if(v.logic == ">") then
						if(not (amount > v.amount)) then
							go = false;
						end
					elseif(v.logic == "==") then
						if(not (amount == v.amount)) then
							go = false;
						end
					end
				end
			end
			
			-- source
			if(v.src and not (v.src == sourceName) ) then
				go = false;
			end
			-- destination
			if(v.dest and not (v.dest == destName) ) then
				go = false;
			end
			
			if(v.selfsrc and not VBM_band(sourceFlags,COMBATLOG_OBJECT_AFFILIATION_MINE)) then
				go = false;
			end

			if(v.selfdest and not VBM_band(destFlags,COMBATLOG_OBJECT_AFFILIATION_MINE)) then
				go = false;
			end

			-- All set run data
			if(go) then
				if(v.mess) then
					local dur = 5;
					if(v.duration) then
						dur = v.duration;
					end
					local r,g,b = 1,0,0;
					if(v.color) then
						if(v.color == "green") then
							g = 1; r = 0;
						elseif(v.color == "orange") then
							g = 0.5;
						elseif(v.color == "purple") then
							b = 1;
						elseif(v.color == "yellow") then
							g = 1;
						elseif(v.color == "teal") then
							r = 0; g = 1; b = 1;
						elseif(v.color == "white") then
							g = 1; b = 1;
						elseif(v.color == "grey") then
							r = 0.7; g = 0.7; b = 0.7;
						end
					end
					vbm_bigwarn(v.mess,dur,r,g,b);
				end
				if(v.sound) then
					VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
				end
				if(v.lowersound) then
					VBM_PlaySoundFile(VBM_LOWER_DONG_SOUND);
				end
				if(v.simonsound) then
					VBM_PlaySoundFile(VBM_SIMON_SOUND);
				end
				if(v.boatsound) then
					VBM_PlaySoundFile(VBM_BOAT_SOUND);
				end
				if(v.runesound) then
					VBM_PlaySoundFile(VBM_RUNE_SOUND);
				end
				if(v.pvpflag1sound) then
					VBM_PlaySoundFile(VBM_PVPFLAG_SOUND);
				end
				if(v.pvpflag2sound) then
					VBM_PlaySoundFile(VBM_PVPFLAG2_SOUND);
				end
				if(v.func) then
					v.func(sourceName, destName, sendextra);
				end
				if(v.timer) then
					local timername = k;
					if(v.timername) then
						timername = v.timername;
					end
					local texture = nil;
					if(v.texture) then
						texture = VBM_ICONS..v.texture;
					end
					VBM_BossTimer(v.timer,timername,texture);
				end
			end
		end
	end
end


