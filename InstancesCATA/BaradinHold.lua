--[[ *********************************************************
--   **      Baradin Hold                                   **
--   **                                                     **
--   **           - Argaloth -                              **
--   *******************************************************]]

VBM_LoadInstance["Baradin Hold"] = function()
	VBM_BOSS_DATA["Argaloth"] = {
		start = function()
			VBM_BossTimer(90,"Fel Firestorm",VBM_ICONS.."spell_fire_felrainoffire");
		end,
		spells = {
			["Fel Firestorm"] = {
				event = "SPELL_CAST_START",
				spell = "Fel Firestorm",
				mess = "* * * Fel Firestorm * * *",
				sound = true,
				timer = 93,
				texture = "spell_fire_felrainoffire",
				func = function()
					VBM_BossTimer(18,"Rain of Fire",VBM_ICONS.."spell_shadow_rainoffire");
				end,
			},
		},
	};
end