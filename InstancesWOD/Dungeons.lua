--[[
Warlords of Draenor - Dungeons
-- Bloodmaul Slag Mines [0%]
-- Iron Docks [0%]
-- Auchindoun [0%]
-- Skyreach [25%]
-- Grimrail Depot [0%]
-- Shadowmoon Burial Grounds [0%]
-- The Everbloom [0%]
-- Upper Blackrock Spire [0%]
]]--

--[[
VBM_LoadInstance["Zone"] = function()
    VBM_BOSS_DATA["Boss Name"] = {
    };
end
]]--
    
VBM_LoadInstance["Bloodmaul Slag Mines"] = function()
    VBM_BOSS_DATA["Roltall"] = {
    };

    VBM_BOSS_DATA["Slave Watcher Crushto"] = {
    };

    VBM_BOSS_DATA["Gug'rokk"] = {
    };

    VBM_BOSS_DATA["Magmolatus"] = {
    };
end

VBM_LoadInstance["Iron Docks"] = function()
    VBM_BOSS_DATA["Fleshrender Nok'gar"] = {
    };

    VBM_BOSS_DATA["Ahri'ok Dugru"] = {
        realname = "Grimrail Enforcers",
    };

    VBM_BOSS_DATA["Oshir"] = {
    };

    VBM_BOSS_DATA["Skulloc"] = {
    };
end

VBM_LoadInstance["Auchindoun"] = function()
    VBM_BOSS_DATA["Vigilant Kaathar"] = {
    };

    VBM_BOSS_DATA["Soulbinder Nyami"] = {
    };

    VBM_BOSS_DATA["Azzakel"] = {
    };

    VBM_BOSS_DATA["Teron'gor"] = {
    };
end

VBM_LoadInstance["Skyreach"] = function()
    VBM_BOSS_DATA["Ranjit"] = {
        debuffs = {
            ["Lens Flare"] = {"* * Lens Flare * *"},
            ["Four Winds"] = {"* * Four Winds * *"},
        },
        spells = {
            ["Windwall"] = {
                event = "SPELL_CAST_SUCCESS",
                dest = VBM_YOU,
                spell = "Windwall",
                func = function() vbm_say("Windwall - "..VBM_YOU); end,
            },
            ["Piercing Rush"] = {
                event = "SPELL_CAST_SUCCESS",
                dest = VBM_YOU,
                spell = "Piercing Rush",
                func = function() vbm_say("Piercing Rush - "..VBM_YOU); end,
            },
        },
    };

    VBM_BOSS_DATA["Araknath"] = {
        debuffs = {
            ["Smash"] = {"* * Smash * *"},
        },
    };

    VBM_BOSS_DATA["Rukhran"] = {
        debuffs = {
            ["Pierced Armor"] = {nil,function()
                vbm_say("Pierced Armor - "..VBM_YOU);
            end},
        },
        spells = {
            ["Quills"] = {
                event = "SPELL_CAST_START",
                spell = "Quills",
                mess = "* * * Quills * * *",
                boatsound = true,
                func = function()
                    VBM_BossTimer(15,"Quills End",VBM_ICONS.."inv_feather_14");
                end
            },
        },
    };

    VBM_BOSS_DATA["High Sage Viryx"] = {
        debuffs = {
            ["Lens Flare"] = {"* * Lens Flare * *"},
        },
        spells = {
            ["Cast Down Tracker"] = {
                event = "SPELL_AURA_APPLIED",
                spell = "Cast Down",
                func = function(s,d)
                    VBM_MARK = VBM_MARK + 1;
                    vbm_infowarn("Cast Down "..vbm_c_bronze..VBM_MARK..vbm_c.." >>"..vbm_c_w..d..vbm_c_t.."<<");
                    if(UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
                        VBM_SetMarkOnName(d,8,10)
                    end
                end,
            },
        },
        emotes = {
            ["Servants, protect your master!"] = {nil,false,function(text)
                vbm_infowarn(vbm_c_bronze.."* * * Shielding Construct Spawned * * *");
                VBM_PlaySoundFile(VBM_LOWER_DONG_SOUND);
                VBM_Delay(0.5,VBM_PlaySoundFile,VBM_LOWER_DONG_SOUND);
            end},
        },
    };
end
