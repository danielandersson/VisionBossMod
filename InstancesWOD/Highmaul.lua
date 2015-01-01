--[[

]]--
VBM_LoadInstance["Highmaul"] = function()
    --[[ ** Kargath Bladefist ** ]]--
    VBM_BOSS_DATA["Kargath Bladefist"] = {
        rangecheck = 10,
        rccount = 1,
        start = function()
            VBM_BossTimer(37,"Impale",VBM_ICONS.."ability_rogue_hungerforblood");
            VBM_BossTimer(48,"Berserker Rush",VBM_ICONS.."ability_fixated_state_red");
            VBM_BossTimer(90,"Chain Hurl",VBM_ICONS.."inv_misc_steelweaponchain");
            VBM_LoopTimer_Setup(20,"Flame Pillar Spawn",VBM_ICONS.."ability_mage_firestarter");
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
            --enrage timer for normal/heroic/mythic
            if(VBM_RAID_MYTHIC) then
                VBM_BossTimer(4*60,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy");
            elseif(VBM_RAID_HEROIC or VBM_RAID_NORMAL) then
                VBM_BossTimer(5*60,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy");
            end
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
            VBM_BossTimer(45,"Infesting Spores",VBM_ICONS.."ability_creature_disease_01");
            VBM_BossTimer(10*60,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy");
            --VBM_BossTimer(18,"Living Mushroom",VBM_ICONS.."inv_misc_starspecklemushroom");
            --VBM_BossTimer(82,"Rejuvenating Mushroom",VBM_ICONS.."inv_elemental_primal_mana");
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
--[[            ["Necrotic Breath"] = {
                event = "SPELL_DAMAGE",
                spell = "Necrotic Breath",
                simonsound = true,
                texture = "ability_mage_worldinflamesgreen",
                func = function()
                    vbm_infowarn(vbm_c_bronze.."* * * Necrotic Breath * * *");
                end,
            },]]--
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
                color = "teal",
                duration = 1.5,
                lowersound = true,
            },
            ["Decay Kick"] = {
                event = "SPELL_INTERRUPT",
                dest = "Fungal Flesh-Eater",
                interrupted = "Decay",
                mess = "* * * Interrupted! * * *",
                color = "green",
                duration = 0.1,
            },
            ["Living Mushroom Tracker"] = {
                event = "SPELL_CAST_SUCCESS",
                spell = "Living Mushroom",
                sound = true,
                mess = "* * Living Mushroom * *",
                --[[func = function()
                    VBM_RemoveTimer("Living Mushroom");
                    VBM_BossTimer(58,"Living Mushroom",VBM_ICONS.."inv_misc_starspecklemushroom");
                end,]]--
            },
            ["Rejuvenating Mushroom Tracker"] = {
                event = "SPELL_CAST_SUCCESS",
                spell = "Rejuvenating Mushroom",
                sound = true,
                mess = "* * Rejuvenating Mushroom * *",
                --[[func = function()
                    VBM_RemoveTimer("Rejuvenating Mushroom");
                    VBM_BossTimer(135,"Rejuvenating Mushroom",VBM_ICONS.."inv_elemental_primal_mana");
                end,]]--
            },
            ["Mind Fungus Tracker"] = {
                event = "SPELL_CAST_SUCCESS",
                spell = "Mind Fungus",
                sound = true,
                mess = "* * Mind Fungus Spawn * *",
            },
        },
    };

    --[[ ** Tectus ** ]]--
    VBM_BOSS_DATA["Tectus"] = {
        deadcheck = {"Mote of Tectus", "Mote of Tectus", "Mote of Tectus", "Mote of Tectus", "Mote of Tectus", "Mote of Tectus", "Mote of Tectus", "Mote of Tectus"}, --all 8 motes must die to win
		start = function()
            --enrage timer for normal/heroic/mythic
            if(VBM_RAID_MYTHIC) then
                VBM_BossTimer(8*60,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy");
            elseif(VBM_RAID_HEROIC or VBM_RAID_NORMAL) then
                VBM_BossTimer(10*60,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy");
            end
        end,
        debuffs = {
            ["Petrification"] = {VBM_WarnTextIcon("Petrification","ability_earthenfury_giftofearth"),function()
                if(UnitGroupRolesAssigned("player") == "TANK") then vbm_say("Petrification - "..VBM_YOU); end
            end},
            ["Crystalline Barrage"] = {VBM_WarnTextIcon("Crystalline Barrage","achievement_boss_highmaul_earthenfury"),function()
                vbm_say("Crystalline Barrage - "..VBM_YOU);
            end},
        },
        spells = {
            ["Gift of Earth Cast"] = {
                event = "SPELL_CAST_START",
                src = "Night-Twisted Earthwarper",
                spell = "Decay",
                mess = "* * * Stun! Night-Twisted Earthwarper * * *",
                color = "purple",
                duration = 1.5,
                lowersound = true,
            },
            ["Tectonic Upheaval Tracker"] = {
                event = "SPELL_CAST_START",
                spell = "Tectonic Upheaval",
                mess = "* * * Tectonic Upheaval Incoming * * *",
                color = "purple",
                duration = 1.8,
                sound = true,
            },
            ["Tectonic Upheaval"] = {
                event = "SPELL_CAST_SUCCESS",
                spell = "Tectonic Upheaval",
                texture = "ability_tectonic_upheaval",
                timer = 10,
                mess = "* * * Tectonic Upheaval * * *",
                pvpflag2sound = true,
            },
        },
    };

    --[[ ** Twin Ogron ** ]]--
    VBM_BOSS_DATA["Pol"] = {
        realname = "Twin Ogron",
		start = function()
            VBM_COUNT = 1;
            polInterval = VBM_RAID_MYTHIC and 23 or VBM_RAID_HEROIC and 26 or 28;
            phemosInterval = VBM_RAID_MYTHIC and 28 or VBM_RAID_HEROIC and 31 or 33;
            quakeCount = 0;
            --enrage timer for lfr/normal/heroic/mythic
            if(VBM_RAID_MYTHIC) then
                VBM_BossTimer(7*60,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy");
            elseif(VBM_RAID_HEROIC or VBM_RAID_NORMAL) then
                VBM_BossTimer(8*60,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy");
            elseif(VBM_RAID_LFR) then
                VBM_BossTimer(10*60,"Berserk",VBM_ICONS.."spell_shadow_unholyfrenzy");
            end
            VBM_BossTimer(12,"Quake",VBM_ICONS.."spell_shaman_earthquake");
            VBM_BossTimer(polInterval+10,"Shield Charge",VBM_ICONS.."ability_warrior_shieldguard");
            VBM_BossTimer(phemosInterval+10,"Whirlwind",VBM_ICONS.."ability_whirlwind");
        end,
        spells = {
            ["Shield Charge"] = {
                event = "SPELL_CAST_SUCCESS",
                src = "Pol",
                spell = "Shield Charge",
                func = function(s,d)
                    if(d==VBM_YOU) then vbm_say("Shield Charge - "..VBM_YOU); end
                    VBM_BossTimer(polInterval,"Interrupting Shout",VBM_ICONS.."warrior_disruptingshout");
                end,
            },
            ["Interrupting Shout"] = {
                event = "SPELL_CAST_START",
                src = "Pol",
                spell = "Interrupting Shout",
                mess = "* * * Interrupting Shout * * *",
                color = "green",
                duration = 1.5,
                lowersound = true,
                func = function(s,d)
                    VBM_BossTimer(polInterval,"Pulverize",VBM_ICONS.."inv_stone_16");
                end,
            },
            ["Pulverize"] = {
                event = "SPELL_CAST_START",
                src = "Pol",
                spell = "Pulverize",
                boatsound = true,
                func = function(s,d)
                    vbm_bigwarn("* * * Pulverize ("..VBM_COUNT..")",2);
                    if(VBM_COUNT==1) then VBM_BossTimer(polInterval,"Shield Charge",VBM_ICONS.."ability_warrior_shieldguard"); end
                    if(VBM_COUNT==3) then 
                        VBM_COUNT = 1;
                        VBM_RC_Auto_Hide();
                    else VBM_COUNT = VBM_COUNT + 1; end
                end,
            },
            ["Enfeebling Roar"] = {
                event = "SPELL_CAST_START",
                src = "Phemos",
                spell = "Enfeebling Roar",
                mess = "* * * Enfeebling Roar * * *",
                duration = 1.5,
                boatsound = true,
                func = function(s,d)
                    local tmpCount = quakeCount + 1;
                    VBM_BossTimer(phemosInterval,"Quake ("..tmpCount..")",VBM_ICONS.."spell_shaman_earthquake");
                end,
            },
            ["Blaze Tracker"] = {
				event = "SPELL_AURA_APPLIED_DOSE",
				spell = "Blaze",
				amount = 3,
				logic = ">",
				dest = VBM_YOU,
                simonsound = true,
				func = function(s,d,a)
					vbm_debuffwarn(vbm_c_r.."* * * Blaze - "..a.." Stacks * * *");
                    vbm_say("Blaze - "..a.." Stacks - "..VBM_YOU);
				end,
			},
            ["Whirlwind"] = {
                event = "SPELL_CAST_START",
                src = "Phemos",
                spell = "Whirlwind",
                mess = "* * * Whirlwind * * *",
                runesound = true,
                func = function(s,d)
                    VBM_BossTimer(phemosInterval,"Enfeebling Roar",VBM_ICONS.."ability_warrior_battleshout");
                end,
            },
            ["Quake"] = {
                event = "SPELL_CAST_START",
                src = "Phemos",
                spell = "Quake",
                sound = true,
                func = function(s,d)
                    quakeCount = quakeCount + 1;
                    vbm_bigwarn("* * * Quake ("..quakeCount..")",0.5);
                    VBM_BossTimer(phemosInterval,"Whirlwind",VBM_ICONS.."ability_whirlwind");
                end,
            },
        },
        during = function()
            local target = VBM_GetUnitReferens("Pol");
            if(target) then
                if(UnitPower(target) >= 98) then
                    VBM_RC_Auto_Show(10,1);
                else
                    VBM_RC_Auto_Hide();
                end
            end
        end,
--[[ might not need all of this, probabaly too much spam
        during = function()
            --display power warnings
            local target1 = VBM_GetUnitReferens("Pol");
            local target2 = VBM_GetUnitReferens("Phemos");
            if(target1) then
                if(UnitPower(target1) >= 64) then
                    vbm_infowarn("* Interrupting Shout Incoming! *",0.1);
                    VBM_PlayRepeatWarnSound(VBM_LOWER_DONG_SOUND,4);
                elseif(UnitPower(target1) >= 98) then
                    vbm_infowarn("* Pulverize Incoming! *",0.1);
                    VBM_PlayRepeatWarnSound(VBM_BOAT_SOUND,4);
                    VBM_RC_Auto_Show(3, 1);
                    VBM_Delay(10,VBM_RC_Auto_Hide);
                end
            end
            if(target2) then
                if(UnitPower(target2) >= 31) then
                    vbm_infowarn("* Whirlwind Incoming! *",0.1);
                    VBM_PlayRepeatWarnSound(VBM_RUNE_SOUND,4);
                elseif(UnitPower(target2) >= 98) then
                    vbm_infowarn("* Gather for Enfeebling Roar! *",0.1);
                    VBM_PlayRepeatWarnSound(VBM_BOAT_SOUND,4);
                end
            end
        end,
]]--
    };

    --[[ ** Ko'ragh ** ]]--
    VBM_BOSS_DATA["Ko'ragh"] = {
        start = function()
        end,
        debuffs = {
            ["Expel Magic: Arcane"] = {VBM_WarnTextIcon("Expel Magic: Arcane","spell_arcane_blast"),function()
                if(UnitGroupRolesAssigned("player") == "TANK") then vbm_say("Expel Magic: Arcane - "..VBM_YOU); end
            end},
            ["Supression Field"] = {VBM_WarnTextIcon("Suppression Field","spell_fire_felflamestrike"),function()
                vbm_say("Supression Field - "..VBM_YOU);
            end},
            ["Expel Magic: Fire"] = {VBM_WarnTextIcon("Expel Magic: Fire","inv_elemental_primal_fire"),function()
                VBM_RC_Auto_Show(10, 1);
                --VBM_Delay(11,VBM_RC_Auto_Hide);
            end,false,function()
                VBM_RC_Auto_Hide();
            end},
            ["Expel Magic: Frost"] = {VBM_WarnTextIcon("Expel Magic: Frost","spell_frost_frozenorb")},
        },
        spells = {
            ["Expel Magic: Fire"] = {
                event = "SPELL_CAST_START",
                spell = "Expel Magic: Fire",
                mess = "* * * Expel Magic: Fire * * *",
                boatsound = true,
                func = function(s,d)
                    VBM_BossTimer(10,"Fire Bomb!",VBM_ICONS.."inv_elemental_primal_fire");
                end,
            },
            ["Expel Magic: Shadow"] = {
                event = "SPELL_CAST_START",
                spell = "Expel Magic: Shadow",
                mess = "* * * Expel Magic: Shadow * * *",
                pvpflag2sound = true,
                duration = 1.5,
            },
            ["Expel Magic: Frost"] = {
                event = "SPELL_DAMAGE",
                src = "Expel Magic: Frost",
                dest = VBM_YOU,
                mess = "* * Expel Magic: Frost Damage * *",
                duration = 0.3,
            },
            ["Supression Field"] = {
                event = "SPELL_DAMAGE",
                src = "Supression Field",
                dest = VBM_YOU,
                mess = "* * Supression Field Damage * *",
                duration = 0.3,
            },
            ["Vulnerability"] = {
                event = "SPELL_CAST_START",
                spell = "Vulnerability",
                mess = "* * * Vulnerability * * *",
                color = "purple",
                pvpflagsound = true,
                duration = 20,
            },
        },
        during = function()
            local target = VBM_GetUnitReferens("Ko'ragh");
            if(target) then
                if(UnitPower(target,10) < 25) then
                    vbm_smallwarn("* * Vulnerability Incoming! * *");
                end
            end
        end,
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
