--[[

]]--
VBM_LoadInstance["Highmaul"] = function()
    --[[ ** Kargath Bladefist ** ]]--
    VBM_BOSS_DATA["Kargath Bladefist"] = {
        rangecheck = 7,
        rccount = 1,
        start = function()
            VBM_BossTimer(37,"Impale",VBM_ICONS.."ability_rogue_hungerforblood");
            VBM_BossTimer(48,"Berserker Rush",VBM_ICONS.."ability_fixated_state_red");
            VBM_BossTimer(90,"Chain Hurl",VBM_ICONS.."inv_misc_steelweaponchain");
            VBM_LoopTimerSetup(2-,"Flame Pillar Spawn",VBM_ICONS.."ability_mage_firestarter");
        end,
        debuffs = {
            ["Mauling Brew"] = {vbm_c_g.."* * * Mauling Brew * * *"},
        },
        spells = {
            ["Impale"] = {
                event = "SPELL_AURA_APPLIED_DOSE",
                spell = "Open Wounds",
                amount = 1,
                logic = ">",
                dest = VBM_YOU,
                func = function(s,d,a)
                    vbm_say("Impale - "..a.." Stacks");
                    VBM_RemoveTimer("Impale");
                    VBM_BossTimer(37,"Impale",VBM_ICONS.."ability_rogue_hungerforblood");
                end,
            },
            ["Flame Jet"] = {
                event = "SPELL_DAMAGE",
                src = "Flame Jet",
                dest = VBM_YOU,
                mess = "* * Flame Jet Damage * *",
                duration = 0.3,
            },
            ["Berserker Rush Tracker"] = {
                event = "SPELL_AURA_APPLIED",
                spell = "Berserker Rush",
                simonsound = true,
                func = function(s,d)
                    VBM_SetMarkOnName(d,8,9);
                    VBM_BossArrow(d,8);
                    vbm_bigwarn(vbm_c_t.."Berserker Rush on >>"..vbm_c_w..d..vbm_c_t.."<<");
                    if(d==VBM_YOU) then
                        vbm_say("Berserker Rush - "..VBM_YOU);
                    end
                    VBM_RemoveTimer("Berserker Rush");
                    VBM_BossTimer(6-,"Berserker Rush",VBM_ICONS.."ability_fixated_state_red");
                end,
            },
        },
        emotes = {
        },
    };
end
