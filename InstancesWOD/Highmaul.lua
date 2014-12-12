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
            VBM_LoopTimerSetup(20,"Flame Pillar Spawn",VBM_ICONS.."ability_mage_firestarter");
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
                    VBM_BossTimer(60,"Berserker Rush",VBM_ICONS.."ability_fixated_state_red");
                end,
            },
        },
        emotes = {
        },
    };
    --[[ ** The Butcher ** ]]--
    VBM_BOSS_DATA["The Butcher"] = {
		start = function()
            VBM_BossTimer(5*60,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy");
        end,
        debuffs = {
            ["The Tenderizer"] = {VBM_WarnTextIcon("The Tenderizer","inv_mace_52"),function()
                vbm_say("The Tenderizer - "..VBM_YOU);
            end},
        },
        spells = {
			--tank stacks
            ["The Cleaver"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				spell = "The Cleaver",
				amount = 3,
				logic = ">",
				dest = VBM_YOU,
                simonsound = true,
				func = function(s,d,a)
					vbm_debuffwarn(vbm_c_r.."* * * The Cleaver - "..a.." Stacks * * *");
                    vbm_say("The Cleaver - "..a.." Stacks - "..VBM_YOU);
				end,
			},
			--warning dps if too many stacks
			["Gushing Wounds"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				spell = "Gushing Wounds",
				amount = 3,
				logic = ">",
				dest = VBM_YOU,
                simonsound = true,
				func = function(s,d,a)
					vbm_debuffwarn(vbm_c_r.."* * * Gushing Wounds - "..a.." Stacks * * *");
				end,
			},
        },
        during = function()
            --display The Butcher's power
            local target = VBM_GetUnitReferens("The Butcher");
            if(target) then
                if(UnitPower(target) > 74) then
                    vbm_infowarn("Energy ("..vbm_c_w..UnitPower(target)..vbm_c.."%)",0.1);
                    VBM_PlayRepeatWarnSound(VBM_LOWER_DONG_SOUND,4);
                end
            end
        end,
    };
    --[[ ** Brackenspore ** ]]--
    VBM_BOSS_DATA["Brackenspore"] = {
		start = function()
            VBM_BossTimer(32,"Necrotic Breath",VBM_ICONS.."ability_mage_worldinflamesgreen");
            VBM_BossTimer(45,"Infesting Spores",VBM_ICONS.."ability_creature_disease_01");
            VBM_BossTimer(10*60,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy");
            VBM_BoopTimer(18,"Living Mushroom",VBM_ICONS.."inv_misc_starspecklemushroom");
            VBM_BoopTimer(82,"Rejuvenating Mushroom",VBM_ICONS.."inv_elemental_primal_mana");
        end,
        debuffs = {
            ["Creeping Moss"] = {vbm_c_g.."* * * Creeping Moss * * *"},
        },
        spells = {
			--tank stacks
            ["Rot"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				spell = "Rot",
				amount = 3,
				logic = ">",
				dest = VBM_YOU,
                simonsound = true,
				func = function(s,d,a)
					vbm_debuffwarn(vbm_c_r.."* * * Rot - "..a.." Stacks * * *");
                    vbm_say("Rot - "..a.." Stacks - "..VBM_YOU);
				end,
			},
            ["Necrotic Breath Tracker"] = {
                event = "SPELL_CAST_START",
                spell = "Necrotic Breath",
                texture = "ability_mage_worldinflamesgreen",
                func = function()
                    VBM_RemoveTimer("Necrotic Breath");
                    VBM_BossTimer(32,"Necrotic Breath",VBM_ICONS.."ability_mage_worldinflamesgreen");
                end,
            },
            ["Necrotic Breath"] = {
                event = "SPELL_DAMAGE",
                spell = "Necrotic Breath",
                simonsound = true,
                texture = "ability_mage_worldinflamesgreen",
                func = function()
                    vbm_infowarn(vbm_c_bronze.."* * * Necrotic Breath * * *");
                end,
            },
            ["Infesting Spores Tracker"] = {
                event = "SPELL_CAST_START",
                spell = "Infesting Spores",
                texture = "ability_creature_disease_01",
                timer = 10,
                mess = "* * * Infesting Spores * * *",
                pvpflag2sound = true,
                func = function()
                    VBM_RemoveTimer("Infesting Spores");
                    VBM_BossTimer(65,"Infesting Spores",VBM_ICONS.."ability_creature_disease_01");
                end,
            },
            ["Decay Cast"] = {
                event = "SPELL_CAST_START",
                src = "Fungal Flesh-Eater",
                spell = "Decay",
                mess = "* * * Kick Decay * * *",
                color = "purple",
                duration = 1.5;
                lowersound = true,
            },
            ["Decay Kick"] = {
                event = "SPELL_INTERRUPT",
                src = "Fungal Flesh-Eater",
                interrupted = "Decay",
                mess = "* * * Interrupted * * *",
                color = "green",
                duration = 0.1,
            },
            ["Living Mushroom Tracker"] = {
                event = "SPELL_CAST_SUCCESS",
                spell = "Living Mushroom",
                sound = true,
                mess = "* * Living Mushroom * *",
                func = function()
                    VBM_RemoveTimer("Living Mushroom");
                    VBM_BossTimer(58,"Living Mushroom",VBM_ICONS.."inv_misc_starspecklemushroom");
                end,
            },
            ["Rejuvenating Mushroom Tracker"] = {
                event = "SPELL_CAST_SUCCESS",
                spell = "Rejuvenating Mushroom",
                sound = true,
                mess = "* * Rejuvenating Mushroom * *",
                func = function()
                    VBM_RemoveTimer("Rejuvenating Mushroom");
                    VBM_BossTimer(135,"Rejuvenating Mushroom",VBM_ICONS.."inv_elemental_primal_mana");
                end,
            },
            --[[
            ["Spore Shooter Tracker"] = {
                event = "SPELL_CAST_SUCCESS",
                spell = "Spore Shooter",
                sound = true,
                mess = "* * Spore Shooter Spawn * *",
                func = function()
                    VBM_RemoveTimer("Spore Shooter");
                    VBM_BossTimer(60,"Spore Shooter",VBM_ICONS.."inv_elemental_primal_mana");
                end,
            },
            ["Mind Fungus Tracker"] = {
                event = "SPELL_CAST_SUCCESS",
                spell = "Mind Fungus",
                sound = true,
                mess = "* * Mind Fungus Spawn * *",
                func = function()
                    VBM_RemoveTimer("Mind Fungus");
                    VBM_BossTimer(51,"Mind Fungus",VBM_ICONS.."inv_elemental_primal_mana");
                end,
            },
            ["Fungal Flesh-Eater Tracker"] = {
                event = "SPELL_CAST_SUCCESS",
                spell = "Fungal Flesh-Eater",
                sound = true,
                mess = "* * * Fungal Flesh-Eater Spawn * * *",
                func = function()
                    VBM_RemoveTimer("Fungal Flesh-Eater");
                    VBM_BossTimer(120,"Fungal Flesh-Eater",VBM_ICONS.."inv_elemental_primal_mana");
                end,
            },
            ]]--
        },
    };
    --[[ ** Trash ** ]]--
    VBM_BOSS_DATA["Trash"] = {
        spells = {
            ["Boar's Rush"] = {
                event = "SPELL_CAST_SUCCESS",
                src = "Krush",
                spell = "Boar's Rush",
                func = function(s,d)
                    vbm_bigwarn(vbm_c_t.."Boar's Rush on >>"..vbm_c_w..d..vbm_c_t.."<<");
                    if(d==VBM_YOU) then
                        vbm_say("Boar's Rush - "..VBM_YOU);
                    end
                end,
            },
        },
    };
end
