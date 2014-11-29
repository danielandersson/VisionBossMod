--[[
	********************************************************************
	********************************************************************
	Combat Log Parsing
	
	Features:
	Buff Alerter
	SS/DI/Feast/Jeeves Alert
	Misdirection Watcher
	Tricks of the Trade Watcher
	Toy Train Set Watcher
	CC Big Brother
	Interrupt Watcher
	Announce Interrupts
	
	********************************************************************
	********************************************************************
]]--

VBM_BUFF_ALERTER_DATA = {
	["Shadow Trance"] = 0,
	["Pain Suppression"] = 1,
	["Hand of Protection"] = 1,
	["Guardian Spirit"] = 1,
	["Lock and Load"] = 0,
	["Lightwell Renew"] = 0,
};

--local setting func
local VBM_GetS = VBM_GetS;

function VBM_CombatLogParsing_OnLoad(self)
	--need combat log
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED");
	--feast alert
	self:RegisterEvent("CHAT_MSG_MONSTER_EMOTE");
end

function VBM_CombatLogParsing_OnEvent(self,event,...)
	if(event == "COMBAT_LOG_EVENT_UNFILTERED") then
		if(VBM_GetS("BuffAlerter")) then
			VBM_BuffAlerter(...);
		end
		if(VBM_GetS("SSDIAlert")) then
			VBM_SSDI_Alert(...);
		end
		if(VBM_GetS("MisdirectionAlert")) then
			VBM_MisdirectionWatcher(...);
		end
		if(VBM_GetS("TricksoftheTradeAlert")) then
			VBM_TricksoftheTradeWatcher(...);
		end
		if(VBM_GetS("ToyTrainSet")) then
			VBM_ToyTrainSet(...);
		end
		if(VBM_GetS("CCBigBrother")) then
			VBM_CCBigBrother(...);
		end
		if(VBM_GetS("InterruptWatcher")) then
			VBM_InterruptWatcher(...);
		end
		if(VBM_GetS("InterruptWatcherAnnounce")) then
			VBM_AnnounceInterrupts(...);
		end
		return;
	end
	
	if(event == "CHAT_MSG_MONSTER_EMOTE") then
		if(VBM_GetS("SSDIAlert")) then
			VBM_Feast_Check(...);
		end
		return;
	end
end

--[[
	********************
	Buff Alerter
	********************
]]--

function VBM_BuffAlerter(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	--if you gain a buff
	if(combatEvent == "SPELL_AURA_APPLIED" and destName and destName == VBM_YOU) then
		if(arg12 == "BUFF") then
			local text;
			--check for spell in list
			if(VBM_BUFF_ALERTER_DATA[spellName]) then
				if(VBM_BUFF_ALERTER_DATA[spellName]==1) then
					text = string.upper(spellName);
				else
					text = spellName;
				end
			end
			--if found print out info
			if(text) then
				vbm_infowarn("* * * "..text.." * * *",5,0,1,1);
			end
		end
	end
end

--[[
	********************
	SS / DI / Feast / Jeeves Alert
	********************
]]--

function VBM_SSDI_Alert(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	--anyone gains a buff
	if((combatEvent == "SPELL_AURA_APPLIED" or combatEvent == "SPELL_AURA_REFRESH") and destName) then
		--check for di or ss
		if(spellName == "Soulstone Resurrection") then
			vbm_infowarn(vbm_c_w..destName..vbm_c.." gains "..vbm_c_g.."Soulstone Resurrection",5);
			vbm_printc(CombatLog_String_GetIcon(destFlags, "dest")..vbm_c_w..destName..vbm_c_p.." gains "..vbm_c_g.."Soulstone Resurrection");
		elseif(spellName == "Divine Intervention") then
			vbm_infowarn(vbm_c_w..destName..vbm_c.." gains Divine Intervention",5,0,1,0);
			vbm_printc("|cFFFFFFFF"..destName.." |cFF8888CCgains |cFFFFFFFFDivine Intervention");
		end
	end
	--check for a summon of jeeves
	if(combatEvent == "SPELL_SUMMON" and sourceName) then
		if(spellName == "Jeeves") then
			vbm_infowarn(vbm_c_w..sourceName..vbm_c.." summoned "..vbm_c_g.."Jeeves",12);
			vbm_printc(CombatLog_String_GetIcon(sourceFlags, "source")..vbm_c_w..sourceName..vbm_c_p.." summoned "..vbm_c_g.."Jeeves");
		end
	end
	--check for a cast of MOLL-E
	if(combatEvent == "SPELL_CAST_SUCCESS" and sourceName) then
		if(spellName == "MOLL-E") then
			vbm_infowarn(vbm_c_w..sourceName..vbm_c.." cast "..vbm_c_g.."MOLL-E",12);
			vbm_printc(CombatLog_String_GetIcon(sourceFlags, "source")..vbm_c_w..sourceName..vbm_c_p.." cast "..vbm_c_g.."MOLL-E");
		end
	end
end

function VBM_Feast_Check(msg,from)
	if(string.find(msg,"prepares a")) then
		local pos = string.find(msg,"prepares a");
		vbm_infowarn(vbm_c_w..from..vbm_c_t.." "..string.sub(msg,pos),12);
	end
	if(string.find(msg,"Goblin Barbecue")) then
		vbm_infowarn(vbm_c_w..from..vbm_c_t.." ".."Goblin Barbecue",12);
	end
end

--[[
	********************
	Misdirection Watcher
	********************
]]--

function VBM_MisdirectionWatcher(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	if(combatEvent == "SPELL_CAST_SUCCESS" and destName) then
		if(spellName == "Misdirection") then
			vbm_print(vbm_c_p.."["..CombatLog_String_GetIcon(sourceFlags, "source")..vbm_c_grey..sourceName..vbm_c_p.."] "..vbm_c_lb.."-Misdirects->"..vbm_c_p.." ["..CombatLog_String_GetIcon(destFlags, "dest")..vbm_c_grey..destName..vbm_c_p.."]");
		end
	end
end

--[[
	********************
	Tricks of the Trade Watcher
	********************
]]--

function VBM_TricksoftheTradeWatcher(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	if(combatEvent == "SPELL_CAST_SUCCESS" and destName) then
		if(spellName == "Tricks of the Trade") then
			vbm_print(vbm_c_p.."["..CombatLog_String_GetIcon(sourceFlags, "source")..vbm_c_grey..sourceName..vbm_c_p.."] "..vbm_c_t.."-Tricks of the Trade->"..vbm_c_p.." ["..CombatLog_String_GetIcon(destFlags, "dest")..vbm_c_grey..destName..vbm_c_p.."]");
		end
	end
end

--[[
	********************
	Toy Train Set Watcher
	********************
]]--

function VBM_ToyTrainSet(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	if(combatEvent == "SPELL_CREATE") then
		if(spellName == "Toy Train Set") then
			vbm_print(vbm_c_p.."["..CombatLog_String_GetIcon(sourceFlags, "source")..vbm_c_grey..sourceName..vbm_c_p.."] "..vbm_c_w.."CREATE |cFF0077DD[Toy Train Set]");
		end
	end
end

--[[
	********************
	CC Big Brother
	********************
]]--

function VBM_CCBigBrother(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,arg9,arg10,arg11,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	-- if aura is dispelled on an npc
	-- combatEvent == "SPELL_AURA_BROKEN" dose't exist ingame, noway to detect broken auras by melee attacks
	if( (combatEvent == "SPELL_AURA_BROKEN_SPELL" or combatEvent == "SPELL_AURA_BROKEN") and destName) then
		if(not sourceName) then
			sourceName = "Unknown";
		else
			--if Only Friendly Source
			if(not VBM_GetS("CCBigBrotherHS")) then
				--if Source is not friendly
				if(not VBM_band(sourceFlags,COMBATLOG_OBJECT_REACTION_FRIENDLY)) then
					return;
				end
			end
		end
		
		--if Only Hostile Targets
		if(not VBM_GetS("CCBigBrotherFT")) then
			--if Target is something else then hostile or neutral
			if(not VBM_band(destFlags,VBM_bor(COMBATLOG_OBJECT_REACTION_HOSTILE,COMBATLOG_OBJECT_REACTION_NEUTRAL)) ) then
				return;
			end
		end
		
		--if Only NPC Targets
		if(not VBM_GetS("CCBigBrotherPT")) then
			--if Target is something else then NPC
			if(not VBM_band(destFlags,COMBATLOG_OBJECT_CONTROL_NPC) ) then
				return;
			end
		end
	
		--local extraSpellName, spellName = arg10,arg13;
		vbm_print(vbm_c_p..">>>"..vbm_c_w..arg10..vbm_c_p.."<<< ["..CombatLog_String_GetIcon(destFlags, "dest")..vbm_c_grey..destName..vbm_c_p.."]"..
			VBM_FlagsColor(destFlags).." removed by "..CombatLog_String_GetIcon(sourceFlags, "source")..vbm_c_grey..sourceName..vbm_c_p.."'s "..vbm_c_w..arg13);
	end
end

--[[
	********************
	Interrupt Watcher
	********************
]]--

function VBM_InterruptWatcher(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	if(combatEvent == "SPELL_INTERRUPT" and destName) then
		if(not sourceName) then
			sourceName = "Unknown";
		else
			--if Only Friendly Source
			if(not VBM_GetS("InterruptWatcherHS")) then
				--if Source is not friendly
				if(not VBM_band(sourceFlags,COMBATLOG_OBJECT_REACTION_FRIENDLY)) then
					return;
				end
			end
		end
		
		--if Only Hostile Targets
		if(not VBM_GetS("InterruptWatcherFT")) then
			--if Target is something else then hostile or neutral
			if(not VBM_band(destFlags,VBM_bor(COMBATLOG_OBJECT_REACTION_HOSTILE,COMBATLOG_OBJECT_REACTION_NEUTRAL)) ) then
				return;
			end
		end
		
		--if Only NPC Targets
		if(not VBM_GetS("InterruptWatcherPT")) then
			--if Target is something else then NPC
			if(not VBM_band(destFlags,COMBATLOG_OBJECT_CONTROL_NPC) ) then
				return;
			end
		end
		
		--local extraSpellName = arg13;
		vbm_print(vbm_c_p.."["..CombatLog_String_GetIcon(sourceFlags, "source")..vbm_c_grey..sourceName..vbm_c_p.."] "..vbm_c_w..spellName..
			VBM_FlagsColor(sourceFlags).." INTERRUPT "..vbm_c_p.."["..CombatLog_String_GetIcon(destFlags, "dest")..vbm_c_grey..destName..vbm_c_p.."] "..vbm_c_w..arg13);
	end	
end

--[[
	********************
	Announce Interrupts
	********************
]]--

function VBM_AnnounceInterrupts(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	if(combatEvent == "SPELL_INTERRUPT" and sourceName and sourceName == VBM_YOU) then
		--if you only whant to announce in a raid, and VBM_ZONE is not set, return
		if(VBM_GetS("InterruptWatcherAnnounceOnlyRaid") and not VBM_ZONE) then
			return;
		end
		vbm_say(""..spellName.." - >>"..arg13.."<<");
	end
end