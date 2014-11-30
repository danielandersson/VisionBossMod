--[[

]]--

VBM_LoadInstance["Skyreach"] = function()
    VBM_BOSS_DATA["Ranjit"] = {
        debuffs = {
            ["Lens Flare"] = {"* * Lens Flare * *"},
        },
        spells = {
            ["Windwall"] = {
                event = "SPELL_CAST_SUCCESS",
                dest = VBM_YOU,
                spell = "Windwall",
                func = function() vbm_say("Windwall - "..VBM_YOU); end,
            },
        },
    };
end
