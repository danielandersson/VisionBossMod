--[[

	Först instanserna

all sub tables is Optional

VBM_BOSS_DATA["BOSS"] = {
	debuffs = {
	-- Format: debuff_to_look_for = {text_to_show, optional_func_to_run, optional mute = false}
		["Raid of Doom"] = {"Text",function() SendChatMessage("Heal Me!","SAY"); end},
		["Raid of Doom2"] = {"Text2"},
	},
	emotes = {
	Format: emote_to_look_for = {text_to_show, bool_sound = true, func_to_run}
		["you die now"] = {"Text",bool sound=true,function() SendChatMessage("Heal Me!","SAY"); end},
	},
	spells = {
	Format: SEE SpellWarner.lua
	},
	realname = "Real boss name to show in print funcations",
	deadcheck = {"A list of all bosses","who must be dead for this encounter to finnish"},
	bossevent = func_to_run,
	start = func_to_run, --will run then encounter starts
	loadandreset = func_to_run, --will run then the boss is set or then a reset is detected
	during = func_to_run, -- function that gets called during onupdate while the encounter is in progress
	rangecheck = distance, -- if we want a rangechecker on this boss
	rccount = count = 1, --count of players before it turns red defaults to 1
};

]]--

function VBM_CheckAllInstacesDataExists()
	local n,a;
	vbm_print("Instance Check!");
	for n,a in pairs(VBM_Instaces) do
		if(not VBM_LoadInstance[n]) then
			vbm_print(n.." MISSING");
		end
	end
	vbm_print("Done!");
end

VBM_Instaces = {
	--vanila wow
	["Onyxia's Lair"] = 1,
	["Molten Core"] = 1,
	
	["Blackwing Lair"] = 1,
	["Zul'Gurub"] = 1,
	
	["Ruins of Ahn'Qiraj"] = 1,
	["Ahn'Qiraj"] = 1,
	--["Naxxramas"] = 1,
	--tbc
	["Gruul's Lair"] = 1,
	["Magtheridon's Lair"] = 1,
	["Karazhan"] = 1,
	["Serpentshrine Cavern"] = 1,
	["Tempest Keep"] = 1,
	
	["Black Temple"] = 1,
	["Hyjal Summit"] = 1,
	
	["Zul'Aman"] = 1,
	
	["Sunwell Plateau"] = 1,
	--wotlk
	["Naxxramas"] = 1,
	["The Obsidian Sanctum"] = 1,
	["The Eye of Eternity"] = 1,
	["Vault of Archavon"] = 1,
	
	["Ulduar"] = 1,
	["Trial of the Crusader"] = 1,
	["Icecrown Citadel"] = 1,
	["The Ruby Sanctum"] = 1,
	--cata
	["Baradin Hold"] = 1,
	["The Bastion of Twilight"] = 1,
	["Blackwing Descent"] = 1,
	["Throne of the Four Winds"] = 1,
};

VBM_LoadInstance = {};
--bossdata reloaded and unloaded during zoneing
VBM_BOSS_DATA = {};
VBM_FRIENDLY_BOSSTAGGED = {};

--[[

Molten Core Rag Timer




]]--
VBM_LoadInstance["Molten Core"] = function()
	VBM_BOSS_DATA["Ragnaros"] = {
		emotes = {
			["TASTE THE FLAMES OF SULFURON"] = {nil,false,function() VBM_BossTimer(27,"KnockBack",VBM_ICONS.."spell_shadow_contagion"); end},
		},
		start = function() VBM_BossTimer(27,"KnockBack",VBM_ICONS.."spell_shadow_contagion"); end,
	};
end

VBM_LoadInstance["Blackwing Lair"] = function()
	VBM_BOSS_DATA["Trash"] = {
		emotes = {
			["Let the games begin!"] = {nil,false,function() VBM_BossTimer(60*3-35,"Nefarian Landing Yell",VBM_ICONS.."spell_shadow_shadowfury"); end},
		},
	};
end

VBM_LoadInstance["Ahn'Qiraj"] = function()
	VBM_BOSS_DATA["Emperor Vek'lor"] = {
		realname = "Twin Emperors",
		spells = {
			["Twin Teleport"] = {
				event = "SPELL_AURA_APPLIED",
				spell = "Twin Teleport",
				timer = 27,
				mess = "* * * Twin Teleport * * *",
				texture = "spell_shadow_contagion",
			},
		},
		start = function() VBM_BossTimer(27,"Twin Teleport",VBM_ICONS.."spell_shadow_contagion"); end,
	};
end

--[[
VBM_Instaces["Azjol-Nerub"] = 1;

VBM_LoadInstance["Azjol-Nerub"] = function()
		VBM_BOSS_DATA["Trash"] = {
		spells = {
			["Pound"] = {
				event = "SPELL_CAST_START",
				spell = "Pound",
				timer = 20,
				sound = true,
				mess = "* * * Pound * * *",
				texture = "spell_nature_earthquake",
			},
			["Locust Swarm"] = {
				event = "SPELL_CAST_START",
				spell = "Locust Swarm",
				timer = 30,
				sound = true,
				mess = "* * * Swarm * * *",
				texture = "spell_shadow_contagion",
			},
			
		},
		emotes = {
			--["Eternal agony in undeath awaits you"] = {nil,false,function () VBM_BossTimer(17,"Locust Swarm",VBM_ICONS.."spell_shadow_contagion"); end},
		},
		
	};
end
]]--
function vbmtest()
	VBM_BossTimer(10,"Pound",VBM_ICONS.."spell_nature_earthquake");
	local rnd = random(0,40)/10;
	VBM_Delay(10+rnd,function()
		VBM_BossTimer(5.12+3,"GOGO");
		vbm_bigwarn("GOGOGOGOGOGOG");
		VBM_PlaySoundFile(VBM_STANDARD_DONG_SOUND);
		VBM_Delay(5.12+3,VBM_PlaySoundFile,VBM_STANDARD_DONG_SOUND);
	end);
end

