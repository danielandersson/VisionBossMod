--[[
	Adds Usefull extra slash commands to VBM and WoW
	
	Allso contains the Info functions
]]--
function VBM_ExtraSlash_Init()
	
	VBM_UnbindBlizzardStuff();
	--vbm dev stuff
	SlashCmdList["VisionBossMod_ShowSpellCast"] = VBM_ToggleShowSpellCast; --in ClassExtra.lua
	SLASH_VisionBossMod_ShowSpellCast1 = "/spellcast";
	SLASH_VisionBossMod_ShowSpellCast2 = "/vbmspellcast";
	--vbm stuff
	SlashCmdList["VisionBossMod_versionlist"] = VBM_PrintVersions;
	SLASH_VisionBossMod_versionlist1 = "/vbmversion";
	SlashCmdList["VisionBossMod_versionlista"] = VBM_PrintVersionsAnnounce;
	SLASH_VisionBossMod_versionlista1 = "/vbmversiona";
	SlashCmdList["VisionBossMod_SS"] = VBM_Slash_SS;  
	SLASH_VisionBossMod_SS1 = "/ss";
	SlashCmdList["VisionBossMod_SSa"] = VBM_Slash_SSa;  
	SLASH_VisionBossMod_SSa1 = "/ssa";
	SlashCmdList["VisionBossMod_ReloadUI"] = ReloadUI;
	SLASH_VisionBossMod_ReloadUI1 = "/rl";
	SLASH_VisionBossMod_ReloadUI2 = "/reloadui";
	SLASH_VisionBossMod_ReloadUI3 = "/reload";
	SLASH_VisionBossMod_ReloadUI4 = "/rui";
	SLASH_VisionBossMod_ReloadUI5 = "/rlui";
	SlashCmdList["VisionBossMod_RestartGX"] = RestartGx;
	SLASH_VisionBossMod_RestartGX1 = "/rgx";
	SLASH_VisionBossMod_RestartGX2 = "/rgfx";
	SLASH_VisionBossMod_RestartGX3 = "/restartgx";
	SLASH_VisionBossMod_RestartGX4 = "/restartgfx";
	SlashCmdList["VisionBossMod_LeaveParty"] = LeaveParty;  
	SLASH_VisionBossMod_LeaveParty1 = "/lp";
	SLASH_VisionBossMod_LeaveParty2 = "/lg";
	SlashCmdList["VisionBossMod_ResetInstance"] = VisionBossMod_ResetInstance;
	SLASH_VisionBossMod_ResetInstance1 = "/ri";
	SLASH_VisionBossMod_ResetInstance2 = "/ir";
	SLASH_VisionBossMod_ResetInstance3 = "/reseti";
	SLASH_VisionBossMod_ResetInstance4 = "/ireset";
	SlashCmdList["VisionBossMod_GroupLoot"] = VisionBossMod_setgrouploot; 
	SLASH_VisionBossMod_GroupLoot1 = "/gl";
	SLASH_VisionBossMod_GroupLoot2 = "/group"; 
	SLASH_VisionBossMod_GroupLoot3 = "/groupl"; 
	SLASH_VisionBossMod_GroupLoot4 = "/grouploot"; 
	SLASH_VisionBossMod_GroupLoot5 = "/gloot";
	SlashCmdList["VisionBossMod_MasterLoot"] = VisionBossMod_setmasterloot; 
	SLASH_VisionBossMod_MasterLoot1 = "/ml";
	SlashCmdList["VisionBossMod_AcceptRess"] = AcceptResurrect;
	SLASH_VisionBossMod_AcceptRess1 = "/ress";
	SlashCmdList["VisionBossMod_ConfirmSummon"] = ConfirmSummon;
	SLASH_VisionBossMod_ConfirmSummon1 = "/sum";
	SLASH_VisionBossMod_ConfirmSummon2 = "/summ";
	SLASH_VisionBossMod_ConfirmSummon3 = "/summon";
	SlashCmdList["VisionBossMod_RepopMe"] = RepopMe;
	SLASH_VisionBossMod_RepopMe1 = "/rel";
	SLASH_VisionBossMod_RepopMe2 = "/release";
	SlashCmdList["VisionBossMod_NormalToggle"] = VBM_Set_Normal;
	SLASH_VisionBossMod_NormalToggle1 = "/normal";
	SLASH_VisionBossMod_NormalToggle2 = "/n";
	SlashCmdList["VisionBossMod_HeroicToggle"] = VBM_Set_Heroic;
	SLASH_VisionBossMod_HeroicToggle1 = "/h";
	SLASH_VisionBossMod_HeroicToggle2 = "/heroic";
	SlashCmdList["VisionBossMod_Heroic5Toggle"] = VBM_Set_Heroic5;
	SLASH_VisionBossMod_Heroic5Toggle1 = "/h5";
	SLASH_VisionBossMod_Heroic5Toggle2 = "/5h";
	SlashCmdList["VisionBossMod_Normal5Toggle"] = VBM_Set_Normal5;
	SLASH_VisionBossMod_Normal5Toggle1 = "/n5";
	SLASH_VisionBossMod_Normal5Toggle2 = "/5n";
	SlashCmdList["VisionBossMod_Normal10Toggle"] = VBM_Set_Normal10;
	SLASH_VisionBossMod_Normal10Toggle1 = "/n10";
	SLASH_VisionBossMod_Normal10Toggle2 = "/10n";
	SlashCmdList["VisionBossMod_Heroic10Toggle"] = VBM_Set_Heroic10;
	SLASH_VisionBossMod_Heroic10Toggle1 = "/h10";
	SLASH_VisionBossMod_Heroic10Toggle2 = "/10h";
	SlashCmdList["VisionBossMod_Normal25Toggle"] = VBM_Set_Normal25;
	SLASH_VisionBossMod_Normal25Toggle1 = "/n25";
	SLASH_VisionBossMod_Normal25Toggle2 = "/25n";
	SlashCmdList["VisionBossMod_Heroic25Toggle"] = VBM_Set_Heroic25;
	SLASH_VisionBossMod_Heroic25Toggle1 = "/h25";
	SLASH_VisionBossMod_Heroic25Toggle2 = "/25h";
	SlashCmdList["VisionBossMod_NotNearMe"] = VBM_NotNearMe;
	SLASH_VisionBossMod_NotNearMe1 = "/nm";
	SlashCmdList["VisionBossMod_NotNearMea"] = VBM_NotNearMea;
	SLASH_VisionBossMod_NotNearMea1 = "/nma";
	SlashCmdList["VisionBossMod_CallRandomPet"] = VBM_CallRandomPet;
	SLASH_VisionBossMod_CallRandomPet1 = "/rp";
	SLASH_VisionBossMod_CallRandomPet2 = "/randompet";
	SlashCmdList["VisionBossMod_LeaveVehicle"] = VehicleExit;
	SLASH_VisionBossMod_LeaveVehicle1 = "/lv";
	SLASH_VisionBossMod_LeaveVehicle2 = "/lm";
	SLASH_VisionBossMod_LeaveVehicle3 = "/leavem";
	SLASH_VisionBossMod_LeaveVehicle4 = "/leavev";
	SLASH_VisionBossMod_LeaveVehicle5 = "/leavemount";
	SLASH_VisionBossMod_LeaveVehicle6 = "/leavevehicle";
	SlashCmdList["VisionBossMod_SellGrey"] = VBM_SellGrey;
	SLASH_VisionBossMod_SellGrey1 = "/sellgrey";
	SlashCmdList["VisionBossMod_AddTimer"] = VBM_SlashAddTimer;
	SLASH_VisionBossMod_AddTimer1 = "/addtimer";
	SLASH_VisionBossMod_AddTimer2 = "/at";
	SlashCmdList["VisionBossMod_PetTank"] = VBM_PetTankToggle;
	SLASH_VisionBossMod_PetTank1 = "/pettank";
	--macro commands
	SlashCmdList["VisionBossMod_SellAllStuff"] = VBM_SellAllStuff;
	SLASH_VisionBossMod_SellAllStuff1 = "/sellall";
	SlashCmdList["VisionBossMod_CraftAllStuff"] = VBM_CraftAllStuff;
	SLASH_VisionBossMod_CraftAllStuff1 = "/craftall";
	SlashCmdList["VisionBossMod_ErrorAllOn"] = VBM_TurnAllErrorOn;
	SLASH_VisionBossMod_ErrorAllOn1 = "/erron";
	SLASH_VisionBossMod_ErrorAllOn2 = "/erroron";
	SlashCmdList["VisionBossMod_ErrorAllOff"] = VBM_TurnAllErrorOff;
	SLASH_VisionBossMod_ErrorAllOff1 = "/erroff";
	SLASH_VisionBossMod_ErrorAllOff2 = "/erroroff";
	SlashCmdList["VisionBossMod_ErrorTextOn"] = VBM_TurnTextErrorOn;
	SLASH_VisionBossMod_ErrorTextOn1 = "/errton";
	SLASH_VisionBossMod_ErrorTextOn2 = "/errortexton";
	SlashCmdList["VisionBossMod_ErrorTextOff"] = VBM_TurnTextErrorOff;
	SLASH_VisionBossMod_ErrorTextOff1 = "/errtoff";
	SLASH_VisionBossMod_ErrorTextOff2 = "/errorttextoff";
	SlashCmdList["VisionBossMod_ErrorSoundOn"] = VBM_TurnSoundErrorOn;
	SLASH_VisionBossMod_ErrorSoundOn1 = "/errson";
	SLASH_VisionBossMod_ErrorSoundOn2 = "/errorsoundon";
	SlashCmdList["VisionBossMod_ErrorSoundOff"] = VBM_TurnSoundErrorOff;
	SLASH_VisionBossMod_ErrorSoundOff1 = "/errsoff";
	SLASH_VisionBossMod_ErrorSoundOff2 = "/errorsoundoff";
	SlashCmdList["VisionBossMod_WhisperCast"] = VBM_WhisperCastSetup;
	SLASH_VisionBossMod_WhisperCast1 = "/whispercast";
	SLASH_VisionBossMod_WhisperCast2 = "/wc";
	SlashCmdList["VisionBossMod_RaidCast"] = VBM_RaidCastSetup;
	SLASH_VisionBossMod_RaidCast1 = "/raidcast";
	SLASH_VisionBossMod_RaidCast2 = "/rc";
	SlashCmdList["VisionBossMod_MoveAltBar"] = VBM_HookMoveAltBar;
	SLASH_VisionBossMod_MoveAltBar1 = "/movealtbar";
	SLASH_VisionBossMod_MoveAltBar2 = "/movebossbar";
	SlashCmdList["VisionBossMod_MoveAltBarLock"] = VBM_HookLockAltBar;
	SLASH_VisionBossMod_MoveAltBarLock1 = "/lockbossbar";
	--used by a vbm warlock setting
	SlashCmdList["VisionBossMod_AutoTradeHS"] = VBM_AutoHSOpenTrade;
	SLASH_VisionBossMod_AutoTradeHS1 = "/hs";
	--raidleader
	SlashCmdList["VisionBossMod_LeaderRoll"] = VBM_MakeLeaderRoll;
	SLASH_VisionBossMod_LeaderRoll1 = "/lr";
	SlashCmdList["VisionBossMod_LeaderRollList"] = VBM_MakeLeaderRollList;
	SLASH_VisionBossMod_LeaderRollList1 = "/lrlist";
	SlashCmdList["VisionBossMod_DisbandRaid"] = VBM_DisbandRaid;
	SLASH_VisionBossMod_DisbandRaid1 = "/vbmdisband";
	SlashCmdList["VisionBossMod_Pull"] = VBM_SetUpPull;
	SLASH_VisionBossMod_Pull1 = "/pull";
	SlashCmdList["VisionBossMod_SetRaidTarget"] = VBM_SlashSetMark;
	SLASH_VisionBossMod_SetRaidTarget1 = "/mark";
	SlashCmdList["VisionBossMod_ConvertRaid"] = VBM_ConvertRaid;
	SLASH_VisionBossMod_ConvertRaid1 = "/cr";
	SLASH_VisionBossMod_ConvertRaid2 = "/convert";
	SlashCmdList["VisionBossMod_PromoteAllRaid"] = VBM_PromoteAllRaid;
	SLASH_VisionBossMod_PromoteAllRaid1 = "/aaa";
	SlashCmdList["VisionBossMod_CallVote"] = VBM_CallVote;
	SLASH_VisionBossMod_CallVote1 = "/vote";
	SLASH_VisionBossMod_CallVote2 = "/vbmvote";
	SlashCmdList["VisionBossMod_CallAnonymousVote"] = VBM_CallAnonymousVote;
	SLASH_VisionBossMod_CallAnonymousVote1 = "/votea";
	SLASH_VisionBossMod_CallAnonymousVote2 = "/vbmvotea";
end

function VBM_PrintAboutInfo()
	vbm_print(vbm_c_p.."You are running: "..vbm_c_g.."VisionBossMod v"..vbm_c_w..VBM_VERSION);
	vbm_print(vbm_c_w.."by Kyau @ US Cenarius");
	vbm_print(vbm_c_p.."Website: "..vbm_c_lb.."http://kyau.net/vbm/");
	vbm_print(vbm_c_p.."Get latest VBM: "..vbm_c_lb.."http://kyau.net/VisionBossMod.7z");
end

function VBM_Slashcommandinfo()
	local text = "\n"..
	"|cFF00FF00ReloadUI: |cFFFFFFFF/rl, /reloadui, /reload, /rui, /rlui\n"..
	"|cFF00FF00RestartGFX: |cFFFFFFFF/rgx, /restartgx, /rgfx, /restartgfx\n"..
	"|cFF00FF00VBMExtra: |cFFFFFFFF/vbmupdate |cFFFFFF00(Request manual update/reset), |cFFFFFFFF/vbmcpuoff |cFFFFFF00(Turn off cpu profileing)\n"..
	"|cFF00FF00VersionInfo: |cFFFFFFFF/vbmversion |cFFFFFF00(show), |cFFFFFFFF/vbmversiona |cFFFFFF00(announce)\n"..
	"|cFF00FF00StatusFrame: |cFFFFFFFF/vbm |cFFFFFF00(toggle vbm frame)\n"..
	"|cFF00FF00Timer: |cFFFFFFFF/addtimer, /at |cFFFFFF00(add a vbm timer)\n"..
	"|cFF00FF00VBMTV: |cFFFFFFFF/vbmtv, /tv |cFFFFFF00(toggle VBM TV frame)\n"..
	"|cFF00FF00RangeCheck: |cFFFFFFFF/rcon, /rcoff, /rcmouse\n"..
	"|cFF00FF00Soulstone: |cFFFFFFFF/ss |cFFFFFF00(check), |cFFFFFFFF/ssa |cFFFFFF00(announce)\n"..
	"|cFF00FF00Near me check: |cFFFFFFFF/nm |cFFFFFF00(check), |cFFFFFFFF/nma |cFFFFFF00(announce)\n"..
	"|cFF00FF00LeaveParty: |cFFFFFFFF/lp, /lg\n"..
	"|cFF00FF00LeaveVehicle: |cFFFFFFFF/lv, /lm, /leavevehicle, /leavemount\n"..
	"|cFF00FF00AcceptResurrect: |cFFFFFFFF/ress |cFFFFFF00(May work if you don't get a Accept Popup)\n"..
	"|cFF00FF00AcceptSummon: |cFFFFFFFF/sum, /summ, /summon\n"..
	"|cFF00FF00ReleaseSpirit: |cFFFFFFFF/rel, /release\n"..
	"|cFF00FF00Cast a random pet: |cFFFFFFFF/rp, /randompet |cFFFFFF00(/rp *nr* or /rp *name* to call specific pets)\n"..
	"|cFF00FF00SellGrey: |cFFFFFFFF/sellgrey |cFFFFFF00(Sell all grey items in inventory)\n"..
	"|cFF00FF00PetTank: |cFFFFFFFF/pettank |cFFFFFF00(Auto mark your pets target with a skull)\n"..
	"|cFF00FF00MoveBossAltPowerBar: |cFFFFFFFF/movebossbar, /movealtbar |cFFFFFF00(Hook the boss special Alt Power Bar)\n"..
	"";
	ShowUIPanel(VisionBossMod_TextBoxTT);
	if ( not VisionBossMod_TextBoxTT:IsVisible() ) then
		VisionBossMod_TextBoxTT:SetOwner(UIParent, "ANCHOR_PRESERVE");
	end
	
	VisionBossMod_TextBoxTT:SetText("VisionBossMod Extra slash commands");
	VisionBossMod_TextBoxTT:AddLine(text, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
	
	VisionBossMod_TextBoxTT:SetWidth(570);
	VisionBossMod_TextBoxTT:SetHeight(285);
end

function VBM_Macrocommandinfo()
	local text = "\n"..
	"|cFF00FF00AutoRun Macro:|cFFFFFF00 If a macro called |cFFFFFFFFAutoRunAsLUA|cFFFFFF00 exists VBM will do a /run command\non the text in the macro while loading.\n"..
	vbm_c_t.."These commands are best used in macros but can of course \nbe used like ordinary commands.\n"..
	"|cFF00FF00SellAll: |cFFFFFFFF/sellall *itemname* |cFFFFFF00(Sell all items of *itemname* to vendor)\n"..
	"|cFF00FF00CraftAll: |cFFFFFFFF/craftall *craftname* |cFFFFFF00(Start to craft all avaible items of choosen name)\n"..
	"|cFF00FF00HideAllError: |cFFFFFFFF/erroff, /erroroff |cFFFFFF00(Disable all Sound Effects, and mid Red Error text)\n"..
	"|cFF00FF00ShowAllError: |cFFFFFFFF/erron, /erroron |cFFFFFF00(Remember to enable them again)\n"..
	"|cFF00FF00HideTextError: |cFFFFFFFF/errtoff, /errortextoff |cFFFFFF00(Disables the Blizzard mid screen Red Error text)\n"..
	"|cFF00FF00ShowTextError: |cFFFFFFFF/errton, /errortexton |cFFFFFF00(Remember to enable again)\n"..
	"|cFF00FF00HideSoundError: |cFFFFFFFF/errsoff, /errorsoundoff |cFFFFFF00(Only disables Error Speech Sound Effect)\n"..
	"|cFF00FF00ShowSoundError: |cFFFFFFFF/errson, /errorsoundon |cFFFFFF00(Enable Error Speech Sound Effect)\n"..
	"|cFF00FF00WhisperCast: |cFFFFFFFF/whispercast, /wc BuffName;TextToWhsiper\n                          |cFFFFFF00(Whisper to a player when you successfully casts a buff on them)\n"..
	"|cFF00FF00RaidCast: |cFFFFFFFF/raidcast, /rc BuffName;TextToSend%t |cFFFFFF00(Will replace %t with spelltarget)\n"..
	"";
	ShowUIPanel(VisionBossMod_TextBoxTT);
	if ( not VisionBossMod_TextBoxTT:IsVisible() ) then
		VisionBossMod_TextBoxTT:SetOwner(UIParent, "ANCHOR_PRESERVE");
	end
	
	VisionBossMod_TextBoxTT:SetText("VisionBossMod Macro commands");
	VisionBossMod_TextBoxTT:AddLine(text, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
	
	VisionBossMod_TextBoxTT:SetWidth(550);
	VisionBossMod_TextBoxTT:SetHeight(240);
end	

function VisionBossMod_PrintOfficerInfo()
	local text = "\n"..
	vbm_c_t.."Officer chat commands\n"..
	"|cFFFFFFFF!a |cFFFFFF00(Request raidassist)\n"..
	"|cFFFFFFFF!promote *name* or !p *name* |cFFFFFF00(Raidpromote name)\n"..
	"|cFFFFFFFF!kick *name* or !k *name* |cFFFFFF00(Raidkick name)\n"..
	vbm_c_t.."Raidleader and Raidofficer info:\n"..
	"|cFF00FF00Call Vote: |cFFFFFFFF/vote, /vbmvote *subject* |cFFFFFF00(Calls for a raid vote)\n"..
	"|cFF00FF00Call Anonymous Vote: |cFFFFFFFF/votea, /vbmvotea *subject* |cFFFFFF00(Calls for a anonymous raid vote)\n"..
	"|cFF00FF00Remote Logout: |cFFFFFFFF/vbmrl *name* |cFFFFFF00(sends a remote logout request)\n"..
	"|cFF00FF00LeaderRoll: |cFFFFFFFF/lr |cFFFFFF00(Raid/Leader roll) |cFFFFFFFF/lrlist |cFFFFFF00(Show assigned numbers in chat)\n"..
	"|cFF00FF00Pull Countdown: |cFFFFFFFF/pull *time* |cFFFFFF00(in raidwarning, if you skip time it will use last)\n"..
	"|cFF00FF00Disband Raid: |cFFFFFFFF/vbmdisband |cFFFFFF00(Shows Confirm Dialog)\n"..
	"|cFF00FF00Convert to Raid: |cFFFFFFFF/cr, /convert\n"..
	"|cFF00FF00Promote everyone to assist: |cFFFFFFFF/aaa\n"..
	"|cFF00FF00GroupLoot: |cFFFFFFFF/gl, /group, /groupl, /grouploot, /gloot\n"..
	"|cFF00FF00MasterLoot: |cFFFFFFFF/ml\n"..
	"|cFF00FF00ResetInstance: |cFFFFFFFF/ri, /ir, /reseti, /ireset\n"..
	"|cFF00FF00SetHeroic: |cFFFFFFFF/h(nr), /(nr)h |cFFFFFF00(Nr can be 5, 10, 25 or skipped to autodetect)\n"..
	"|cFF00FF00SetNormal: |cFFFFFFFF/n(nr), /(nr)n |cFFFFFF00(Nr can be 5, 10, 25 or skipped to autodetect)\n"..
	"|cFF00FF00Set Raid Mark: |cFFFFFFFF/mark *nr* |cFFFFFF00(On your target, marks 0-8 (defualt 8)(0 removes))\n"..
	"";
	ShowUIPanel(VisionBossMod_TextBoxTT);
	if ( not VisionBossMod_TextBoxTT:IsVisible() ) then
		VisionBossMod_TextBoxTT:SetOwner(UIParent, "ANCHOR_PRESERVE");
	end
	VisionBossMod_TextBoxTT:SetText("VisionBossMod Groupleader/Officer extras");
	VisionBossMod_TextBoxTT:AddLine(text, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
	
	VisionBossMod_TextBoxTT:SetWidth(550);
	VisionBossMod_TextBoxTT:SetHeight(290);
end

function VisionBossMod_PrintRaidModesInfo()
	local text = "\n"..
	vbm_c_g.."Local RaidMode commands\n"..
	vbm_c_w.."/rmlist "..vbm_c_y.."(List active raidmodes)\n"..
	vbm_c_w.."/rmcmd "..vbm_c_y.."(Enter a raidmode command (Only works outside raidgroups))\n"..
	vbm_c_g.."Raid commands\n"..
	vbm_c_y.."Enter commands in raidchat with + or - as prefix, you need to be raidleader or raidofficer.\n"..
	vbm_c_y.."If you leave out a player name it will be defaulted to yourself\n"..
	vbm_c_w.."-all "..vbm_c_y.."(Removes all active raidmodes)\n"..
	vbm_c_w.."+mark *playername* (optional)mark (optional)mode\n"..
		vbm_c_y.."Enables auto raidmark targets for playername (name can be all if used with -mark):\n"..
		vbm_c_y.."  mark:"..vbm_c_w.." star/circle/diamond/triangle/moon/square/cross/skull "..vbm_c_y.."or "..vbm_c_w.."1-8 "..vbm_c_y.."(Default=highest unused)\n"..
		vbm_c_y.."  mode:"..vbm_c_w.." ol (Default)"..vbm_c_y.."(Overide lesser mark numbers)\n"..
		vbm_c_w.."        oa "..vbm_c_y.."(Overide all marks)\n"..
		vbm_c_w.."        no "..vbm_c_y.."(No overide)\n"..
	vbm_c_w.."+group *playername* *groupnr*\n"..
		vbm_c_y.."Assign a player to a specific group, this is used by some boss functions where\n"..
		vbm_c_y.."group number matters. Example: Bloodboil and Kalecgos\n"..
	"";
	ShowUIPanel(VisionBossMod_TextBoxTT);
	if ( not VisionBossMod_TextBoxTT:IsVisible() ) then
		VisionBossMod_TextBoxTT:SetOwner(UIParent, "ANCHOR_PRESERVE");
	end
	VisionBossMod_TextBoxTT:SetText("VisionBossMod RaidModes Info");
	VisionBossMod_TextBoxTT:AddLine(text, NORMAL_FONT_COLOR.r, NORMAL_FONT_COLOR.g, NORMAL_FONT_COLOR.b, 1);
	
	VisionBossMod_TextBoxTT:SetWidth(600);
	VisionBossMod_TextBoxTT:SetHeight(300);
end

function VBM_UnbindBlizzardStuff()
	--unbind /h so we can use it for /heroic
	SLASH_HELP1 = "/?"; -- Help
	SLASH_HELP2 = "/help"; -- Help
	SLASH_HELP3 = "/?"; -- Help
	SLASH_HELP4 = "/?"; -- Help
	SLASH_HELP5 = "/?"; -- Help
	SLASH_HELP6 = "/help"; -- Help
end

--[[
	Functions
]]--

function VBM_PromoteAllRaid()
	if(UnitIsGroupLeader("player")) then
		local i;
		for i=1,GetNumGroupMembers() do
			PromoteToAssistant("raid"..i);
		end
	else
		vbm_printc("ERROR: You are not raid leader.");
	end
end

function VBM_SlashSetMark(msg)
	local mark = 8;
	local num = tonumber(msg);
	if(num and num >= 0 and num < 8) then
		mark = num;
	end
	SetRaidTarget("target",mark);
end

function VBM_ConvertRaid()
	ConvertToRaid();
end

function VBM_Set_Normal()
	--check if we are inside a dungeon
	if(VBM_ZONE) then
		if(VBM_DUNGEON_SIZE==10) then
			VBM_Set_Normal10();
		elseif(VBM_DUNGEON_SIZE==25) then
			VBM_Set_Normal25();
		end
	else
		--check size of raid
		if(GetNumGroupMembers()>15) then
			VBM_Set_Normal25();
		elseif(GetNumGroupMembers()>0) then
			VBM_Set_Normal10();
			VBM_Set_Normal5();
		else
			VBM_Set_Normal5();
		end
	end
end

function VBM_Set_Heroic()
	--check if we are inside a dungeon
	if(VBM_ZONE) then
		if(VBM_DUNGEON_SIZE==10) then
			 VBM_Set_Heroic10();
		elseif(VBM_DUNGEON_SIZE==25) then
			 VBM_Set_Heroic25();
		end
	else
		--check size of raid
		if(GetNumGroupMembers()>15) then
			VBM_Set_Heroic25();
		elseif(GetNumGroupMembers()>0) then
			VBM_Set_Heroic10();
			VBM_Set_Heroic5();
		else
			VBM_Set_Heroic5();
		end
	end
end

function VBM_Set_Normal5()
	SetDungeonDifficulty(1);
end

function VBM_Set_Heroic5()
	SetDungeonDifficulty(2);
end

function VBM_Set_Normal10()
	SetRaidDifficulty(1);
end

function VBM_Set_Normal25()
	SetRaidDifficulty(2);
end

function VBM_Set_Heroic10()
	SetRaidDifficulty(3);
end

function VBM_Set_Heroic25()
	SetRaidDifficulty(4);
end

function VisionBossMod_setmasterloot()
	SetLootMethod("master",UnitName("player"));
end

function VisionBossMod_setgrouploot(msg)
	SetLootMethod("group");
end

function VBM_TurnAllErrorOn()
	UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE");
	SetCVar("Sound_EnableSFX", "1");
end

function VBM_TurnAllErrorOff()
	UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE");
	SetCVar("Sound_EnableSFX", "0");
end

function VBM_TurnTextErrorOn()
	UIErrorsFrame:RegisterEvent("UI_ERROR_MESSAGE");
end

function VBM_TurnTextErrorOff()
	UIErrorsFrame:UnregisterEvent("UI_ERROR_MESSAGE");
end

function VBM_TurnSoundErrorOn()
	SetCVar("Sound_EnableErrorSpeech", "1");
end

function VBM_TurnSoundErrorOff()
	SetCVar("Sound_EnableErrorSpeech", "0");
end

function VBM_PrintVersions(msg,_,announce)
	local name,nr_v,version,vl,vl_names,sub_vl,i,text;
	vl = {};
	vl_names = {};
	--building list
	local i;
	for i=1,GetNumGroupMembers() do
		name = GetRaidRosterInfo(i); --get name
		--if raid member doesnt have a version add version 0
		if(VBM_VERSION_LIST[name]==nil) then VBM_VERSION_LIST[name] = 0; end
		--check if we found another version and add them to list		
		if(vl_names[VBM_VERSION_LIST[name]]==nil) then 
			vl_names[VBM_VERSION_LIST[name]] = {}; --add a new table to name list
			table.insert(vl,VBM_VERSION_LIST[name]); --and the new version to version list
		end
		-- add the name to the correct version table
		table.insert(vl_names[VBM_VERSION_LIST[name]],name);
	end
	table.sort(vl); --sorting
	--keep track how many diffrent versions we have
	nr_v = table.getn(vl);
	i = 1;
	--loop through diffrent versions list
	for _,version in pairs(vl) do
		sub_vl = vl_names[version]; --get name list for this version
		table.sort(sub_vl); --sort namelist
		--and correct prefix to textstring and if we are in announce mode dont add colors
		if(version==0) then
			if(announce) then text = "Dont have VBM: "; else text = vbm_c_r.."Dont have VBM: "..vbm_c_w; end
		elseif(i == nr_v) then
			if(announce) then text = "Using latest version ("..version.."): "; else text = vbm_c_g.."Using latest version ("..version.."): "..vbm_c_w; end
		else
			if(announce) then text = "("..version.."): "; else text = "|cFF7F7F00("..version.."): "..vbm_c_w; end
		end
		--add all names
		for _,name in pairs(sub_vl) do
			text = text..name.." ";
		end
		--print out text
		if(announce) then
			vbm_sendchat(text);
		else
			vbm_print(text);
		end
		--count up counter
		i = i + 1;
	end
	
	--if you are not in raid
	if(GetNumGroupMembers()<=0) then
		vbm_printc("You are running: "..vbm_c_g.."VisionBossMod v"..vbm_c_w..VBM_VERSION);
		if(VBMSettings.newestversion > VBM_VERSION) then
			vbm_printc("There is a "..vbm_c_g.."newer version "..vbm_c_p.."out: "..vbm_c_w..VBMSettings.newestversion);
		else
			vbm_printc("You have not seen anyone use any newer version.");
		end
	end
end

function VBM_PrintVersionsAnnounce(msg)
	VBM_PrintVersions(msg,nil,true);
end

function VBM_Slash_SS(msg,_,...)
	local arg = {...};
	
	local ss = false;
	local i;
	--check raid
	
	for i=1,GetNumGroupMembers() do
		if(VBM_CheckForBuff("Soulstone Resurrection","raid"..i)) then
			if(ss==false) then
				ss = GetRaidRosterInfo(i);
			else
				ss = ss..", "..GetRaidRosterInfo(i);
			end
		end
	end
	
	--if not found check party
	if(not ss) then
		--check party members
		for i=1,GetNumPartyMembers() do
			if(VBM_CheckForBuff("Soulstone Resurrection","party"..i)) then
				if(ss==false) then
					ss = UnitName("party"..i);
				else
					ss = ss..", "..UnitName("party"..i);
				end
			end
		end
		--check player
		if(VBM_CheckForBuff("Soulstone Resurrection","player")) then
			if(ss==false) then
				ss = UnitName("player");
			else
				ss = ss..", "..UnitName("player");
			end
		end
	end
	
	--print out result
	if(ss) then
		if(arg[1]) then
			vbm_sendchat("Soulstone found on: "..ss);
		else
			vbm_print("|cFF8888CC<VisionBossMod> Soulstone found on: |cFFFFFFFF"..ss);
		end
	else
		if(arg[1]) then
			vbm_sendchat("No Soulstone found");
		else
			vbm_print("|cFF8888CC<VisionBossMod> No Soulstone found");
		end
	end
end

function VBM_Slash_SSa(msg)
	VBM_Slash_SS(msg,nil,true);
end

function VisionBossMod_ResetInstance()
	ResetInstances();
end

function VBM_NotNearMea(msg)
	VBM_NotNearMe(msg,nil,true);
end

function VBM_NotNearMe(msg,_,...)
	local arg = {...};
	local annaounce = false;
	if(arg[1]) then
		annaounce = true;
	end
	
	local not_in_raid = "";
	local not_visible = "";
	local c_vis,c_near = 0,0;
	for r_m=1,GetNumGroupMembers() do
		if(not UnitIsVisible("raid"..r_m)) then
			not_visible = not_visible..UnitName("raid"..r_m).." ";
			c_vis = c_vis+1;
		elseif(not UnitInRange("raid"..r_m)) then
			not_in_raid = not_in_raid..UnitName("raid"..r_m).." ";
			c_near = c_near +1;
		end
	end
	if(annaounce) then
		if(c_vis==0) then
			vbm_sendchat("Everyone within visible range");
		else
			vbm_sendchat("Not within visible range: "..not_visible);
		end
		if(c_near==0) then
			vbm_sendchat("Everyone within 40yrd");
		else
			vbm_sendchat("Not within 40yrd: "..not_in_raid);
		end
	else
		if(c_vis==0) then
			vbm_printc("Everyone within visible range");
		else
			vbm_printc("Not within visible range: "..vbm_c_w..not_visible);
		end
		if(c_near==0) then
			vbm_printc("Everyone within 40yrd");
		else
			vbm_printc("Not within 40yrd: "..vbm_c_w..not_in_raid);
		end
	end
end

function VBM_CallRandomPet(text)
	local np = GetNumCompanions("CRITTER");
	local tonr = tonumber(text);
	if(np>0) then
		local creatureName, petid, ran_max;
		if(type(text)=="nil" or text=="") then
			--Call a random pet
			local ran = math.random(1,np);
			ran_max = np;
			_, creatureName = GetCompanionInfo("CRITTER", ran);
			petid = ran;
			CallCompanion("CRITTER",ran);
		elseif(type(tonr)=="number") then
			--call specific pet
			if(tonr==0) then
				return VBM_CallRandomPet();
			end
			_, creatureName = GetCompanionInfo("CRITTER", tonr);
			petid = tonr;
			CallCompanion("CRITTER",tonr);
		else
			--search for all pets with search string
			local pets = {};
			local i;
			for i=1,np do
				_, creatureName = GetCompanionInfo("CRITTER", i);
				if(string.find(string.lower(creatureName), string.lower(text), 1, true)) then
					pets[#pets+1] = i;
				end
			end
			if(#pets>0) then
				local ran = pets[math.random(1,#pets)];
				ran_max = #pets;
				_, creatureName = GetCompanionInfo("CRITTER", ran);
				petid = ran;
				CallCompanion("CRITTER",ran);
			else
				vbm_printc("Error no pets found: "..vbm_c_r..text);
				return;
			end
		end
		if(creatureName) then
			vbm_printc("Calling pet "..vbm_c_w..creatureName..vbm_c_p.." ("..vbm_c_g..petid..vbm_c_p..")"..((ran_max and ran_max>1 and " ("..vbm_c_w..ran_max..vbm_c_p.." matches)") or ""));
		elseif(petid) then
			vbm_printc("Error pet ("..vbm_c_r..petid..vbm_c_p..") not found.");
		end
	end
end

function VBM_DisbandRaid()
	if(UnitIsGroupLeader("player")) then
		StaticPopupDialogs["VBM_CONFIRM_RAIDDISBAND"] = {
		  text = "Are you sure you want to disband raid?",
		  button1 = "Yes",
		  button2 = "No",
		  OnAccept = function()
			vbm_sendchat("* * * Disbanding Raid * * *");
			for i=GetNumGroupMembers()-1,1,-1 do
				UninviteUnit("raid"..i);
			end
			vbm_printc("RaidDisband: complete");
		  end,
		  timeout = 0,
		  whileDead = 1,
		  hideOnEscape = 1,
		};
		StaticPopup_Show("VBM_CONFIRM_RAIDDISBAND");
	else
		vbm_printc("RaidDisband Error: You are not RaidLeader");
	end
end

function VBM_SetUpPull(time)
	if(UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) then
		if(time=="") then
			--do last pull
			vbm_raidwarn("* * Pull in "..VBMSettings['PullCD'].." seconds * *");
			vbm_sendchat("Pull countdown started type (A)bort or (S)top to cancel.");
			VBM_PULLRUNNING = nil;
			VBM_PerformPullCD(VBMSettings['PullCD']);
		else
			--do new pull
			local nr = tonumber(time);
			if(nr) then
				if(nr<1 or nr>1200) then
					vbm_printc("Pull error: Enter a number between 1-1200");
				else
					VBMSettings['PullCD'] = nr;
					vbm_raidwarn("* * Pull in "..VBMSettings['PullCD'].." seconds * *");
					vbm_sendchat("Pull countdown started type (A)bort or (S)top to cancel.");
					VBM_PULLRUNNING = nil;
					VBM_PerformPullCD(VBMSettings['PullCD']);
				end
			else
				vbm_printc("Pull error: Enter a number between 1-1200");
			end
		end
	else
		vbm_printc("Pull error: You are not Leader or Promoted");
	end
end

function VBM_PerformPullCD(time)
	if(time>15) then
		local next = math.fmod(time,15);
		if(next==0) then next = 15; end
		VBM_DelayByName("Pull",next,VBM_PerformPullCD,time-next);
		if(VBM_PULLRUNNING) then
			vbm_raidwarn(">> "..time.." seconds <<");
		end
	elseif(time>10) then
		local next = time-10;
		VBM_DelayByName("Pull",next,VBM_PerformPullCD,time-next);
		if(VBM_PULLRUNNING) then
			vbm_raidwarn(">> "..time.." seconds <<");
		end
	elseif(time>0) then
		VBM_DelayByName("Pull",1,VBM_PerformPullCD,time-1);
		if(VBM_PULLRUNNING) then
			vbm_raidwarn(">> "..time.." <<");
		end
	else
		if(VBM_PULLRUNNING) then
			vbm_raidwarn("Pull!");
		end
		VBM_PULLRUNNING = nil;
		return;
	end
	VBM_PULLRUNNING = true;
end

function VBM_AbortPullCD(msg) --will get chat data from extrafeatures.lua
	if(VBM_PULLRUNNING) then
		local t = string.lower(msg);
		if(t=="!abort" or t=="abort" or t=="!a" or t=="a" or t=="!stop" or t=="stop" or t=="!s" or t=="s") then
			vbm_raidwarn("Abort! Abort!");
			VBM_PULLRUNNING = nil;
			VBM_DelayRemove("Pull");
		end
	end
end

function VBM_SellGrey()
	if(not MerchantFrame:IsShown()) then
		vbm_printc("Error: Visit a vendor first");
		return;
	end
	local bag,slot,item;
	local nr_selled,price_selled = 0,0;
	for bag=0,NUM_BAG_SLOTS do
		for slot=1,GetContainerNumSlots(bag) do
			item = GetContainerItemLink(bag,slot);
			local _, itemCount = GetContainerItemInfo(bag,slot);
			if(item) then
				local itemName, _, itemRarity, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(item);
				if(itemRarity==0) then
					vbm_printc("Auto Selling: "..item);
					nr_selled = nr_selled + itemCount;
					price_selled = price_selled + itemSellPrice*itemCount;
					UseContainerItem(bag,slot);
				end
			end
		end
	end
	if(nr_selled>0) then
		local text = "items";
		if(nr_selled==1) then
			text = "item";
		end
		vbm_printc("Auto Sold "..vbm_c_w..nr_selled..vbm_c_p.." "..text.." for "..VBM_FormatMoney(price_selled));
	end
end

function VBM_SellAllStuff(text)
	if(not MerchantFrame:IsShown()) then
		vbm_printc("Error: Visit a vendor first");
		return;
	end
	if(not text or string.len(text)<2) then
		vbm_printc("Usage: /sellall *itemname*");
		return;
	end
	local bag,slot,item;
	local nr_selled,price_selled = 0,0;
	local echo = true;
	
	--check if we got a link instead of a name
	local iname = GetItemInfo(text);
	if(iname) then
		text = iname;
	end
	
	for bag=0,NUM_BAG_SLOTS do
		for slot=1,GetContainerNumSlots(bag) do
			item = GetContainerItemLink(bag,slot);
			local _, itemCount = GetContainerItemInfo(bag,slot);
			if(item) then
				local itemName, _, _, _, _, _, _, _, _, _, itemSellPrice = GetItemInfo(item);
				if(itemName==text) then
					if(echo) then
						vbm_printc("Auto Selling All: "..item);
						echo = false;
					end
					nr_selled = nr_selled + itemCount;
					price_selled = price_selled + itemSellPrice*itemCount;
					UseContainerItem(bag,slot);
				end
			end
		end
	end
	if(nr_selled>0) then
		local text = "items";
		if(nr_selled==1) then
			text = "item";
		end
		vbm_printc("Auto Sold "..vbm_c_w..nr_selled..vbm_c_p.." "..text.." for "..VBM_FormatMoney(price_selled));
	end
end

function VBM_CraftAllStuff(text)
	if(not TradeSkillFrame or not TradeSkillFrame:IsShown()) then
		vbm_printc("Error: Open a tradeskill window");
		return;
	end
	if(not text or string.len(text)<2) then
		vbm_printc("Usage: /craftall *craftname*");
		return;
	end
	local i;
	for i=1,GetNumTradeSkills() do
		local skillName, skillType, numAvailable, isExpanded, altVerb = GetTradeSkillInfo(i);
		if(skillName==text) then
			DoTradeSkill(i,numAvailable);
		end
	end
end

function VBM_SlashAddTimer(msg)
	local f,a,b;
	f,_,a,b = string.find(msg,"(%d+) (.+)");
	if(not f) then
		f,_,b,a = string.find(msg,"(.+) (%d+)");
	end
	
	if(f) then
		VBM_StartTimer(tonumber(a),b);
	else
		vbm_printc("Syntax Error: Use /at *time* *name*");
	end
end


VBM_WHISPERCAST_ON = false;
local wc_buff,wc_message;
function VBM_WhisperCastSetup(msg)
	local f,_,buff,say = string.find(msg,"(.+),(.+)");
	if(not f) then
		f,_,buff,say = string.find(msg,"(.+);(.+)");
	end
	if(f) then
		VBM_WHISPERCAST_ON = true;
		VBM_DelayByName("WHISPERCAST",3,function() VBM_WHISPERCAST_ON = false; end);
		wc_buff,wc_message = buff,say;
	end
end
--will get combat log data from extrafeatures.lua
function VBM_WhisperCastParse(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	if(combatEvent == "SPELL_AURA_APPLIED" and sourceName and sourceName == VBM_YOU and destName) then
		if(spellName==wc_buff) then
			vbm_whisper(wc_message,destName);
		end
	end
end

VBM_RAIDCAST_ON = false;
local rc_buff,rc_message;
function VBM_RaidCastSetup(msg)
	local f,_,buff,say = string.find(msg,"(.+),(.+)");
	if(not f) then
		f,_,buff,say = string.find(msg,"(.+);(.+)");
	end
	if(f) then
		VBM_RAIDCAST_ON = true;
		VBM_DelayByName("RAIDCAST",3,function() VBM_RAIDCAST_ON = false; end);
		rc_buff,rc_message = buff,say;
	end
end
 --will get combat log data from extrafeatures.lua
function VBM_RaidCastParse(timestamp,combatEvent,hideCaster,sourceGUID,sourceName,sourceFlags,destGUID,destName,destFlags,spellId,spellName,spellSchool,arg12,arg13,arg14,arg15,arg16,arg17,arg18,arg19,arg20)
	if(combatEvent == "SPELL_AURA_APPLIED" and sourceName and sourceName == VBM_YOU and destName) then
		if(spellName==rc_buff) then
			vbm_sendchatnovbm(string.gsub(rc_message,"%%t",destName));
		end
	end
end


local pettank = false;
function VBM_PetTankToggle()
	if(pettank) then
		pettank = false;
		vbm_printc("PetTank mode "..vbm_c_w.."off");
	else
		pettank = true;
		vbm_printc("PetTank mode "..vbm_c_w.."on");
	end
end
function VBM_PetTargetEvent(u)
	if(pettank and UnitExists("pettarget") and not UnitIsPlayer("pettarget")) then
		local t = GetRaidTargetIndex("pettarget");
		if(t==nil or t~=8) then
			SetRaidTarget("pettarget", 8)
		end
	end
end

-- *********************
-- VBM START A VOTE
-- *********************

VBM_VOTE_RUNNING = false;
local running_vote = {};

local function dovotesetupcheck(r)
	if(VBM_VOTE_RUNNING) then
		vbm_printc("Error: A vote is allready pending");
		return false;
	end
	if(string.len(r)<2) then
		vbm_printc("Usage: /vote(a) *subject*");
		return;
	end
	if(InCombatLockdown()) then
		vbm_printc("Error: You are in combat");
		return false;
	end
	if(GetNumGroupMembers()>0 and not (UnitIsGroupLeader("player") or UnitIsGroupAssistant("player")) ) then
		vbm_printc("Error: You are not RaidLeader or RaidOfficer");
		return false;
	end
	return true;
end

local function votestart(r)
	vbm_sendchatnovbm("Subject: "..r);
	VBM_Delay(15,vbm_sendchatnovbm,"Vote ends in 15 sec");
	VBM_Delay(25,vbm_sendchatnovbm,"Vote ends in 5 sec");
	--setup vote list for valid players
	local i;
	for i=1,GetNumGroupMembers() do
		running_vote[UnitName("raid"..i)] = 0;
	end
end

local function voteendregular()
	--gather data
	local p,v;
	local yes,no,none = {},{},{};
	for p,v in pairs(running_vote) do
		if(v==0) then
			none[#none+1] = p;
		elseif(v==1) then
			yes[#yes+1] = p;
		else
			no[#no+1] = p;
		end
	end
	--present data
	vbm_sendchatnovbm("Vote ended, Results:")
	local t = #yes + #no + #none;
	if(t>0) then
		vbm_sendchatnovbm("Yes ("..#yes.."): "..table.concat(yes,", "));
		vbm_sendchatnovbm("No ("..#no.."): "..table.concat(no,", "));
		vbm_sendchatnovbm("Didn't vote ("..#none.."): "..table.concat(none,", "));
		vbm_sendchatnovbm(("Yes (%.1f%%)    No (%.1f%%)    Novote (%.1f%%)"):format(#yes/t*100,#no/t*100,#none/t*100));
	else
		vbm_sendchatnovbm("No vote data.")
	end
	running_vote = {};
end

local function voteendanonymous()
	--gather data
	local p,v;
	local yes,no,none = 0,0,0;
	for p,v in pairs(running_vote) do
		if(v==0) then
			none = none+1;
		elseif(v==1) then
			yes = yes+1;
		else
			no = no+1;
		end
	end
	--present data
	vbm_sendchatnovbm("Vote ended, Results:")
	local t = yes + no + none;
	if(t>0) then
		vbm_sendchatnovbm(("Yes:%d (%.1f%%)    No:%d (%.1f%%)    Novote:%d (%.1f%%)"):format(yes,yes/t*100,no,no/t*100,none,none/t*100));
	else
		vbm_sendchatnovbm("No vote data.")
	end
	running_vote = {};
end

function VBM_CallVote(reason)
	if(dovotesetupcheck(reason)) then
		vbm_send_synced("VOTESTART "..reason);
		vbm_sendchat("Starting an Open Vote for 30 sec");
		vbm_sendchatnovbm("(if you don't have VBM you can whisper me \"yes\" or \"no\" to vote)");
		votestart(reason);
		VBM_Delay(30,voteendregular);
	end
end

function VBM_CallAnonymousVote(reason)
	if(dovotesetupcheck(reason)) then
		vbm_send_synced("VOTEANOMSTART "..reason);
		vbm_sendchat("Starting an Anonymous Vote for 30 sec");
		vbm_sendchatnovbm("(if you don't have VBM you can whisper me \"yes\" or \"no\" to vote)");
		vbm_sendchatnovbm("(but i can see your whispers then so it won't be anonymous to me)");
		votestart(reason);
		VBM_Delay(30,voteendanonymous);
	end
end

-- *********************
-- VBM RECIVE A VOTE
-- *********************

local function resetvoterunning()
	VBM_VOTE_RUNNING = false;
	--hide vote UI
	VBMVoteFrame:Hide();
end

function VBM_VoteSend(to,vote)
	SendAddonMessage("VBMVOTE",vote,"WHISPER",to);
	VBMVoteFrame:Hide();
end

function VBM_VoteRecive(reason,from)
	VBM_VOTE_RUNNING = true;
	VBM_Delay(30,resetvoterunning);
	--show vote UI
	VBM_PlaySoundFile("Interface\\AddOns\\VisionBossMod\\Data\\choose.wav");
	VBMVoteFrameText:SetText(from.." has called for an "..vbm_c_g.."Open"..vbm_c.." vote:");
	VBMVoteFrameSubject:SetText(reason);
	VBMVoteFrame.voteto = from;
	VBMVoteFrame:Show();
end

function VBM_VoteReciveAnonymous(reason,from)
	VBM_VOTE_RUNNING = true;
	VBM_Delay(30,resetvoterunning);
	--show voteUI
	VBM_PlaySoundFile("Interface\\AddOns\\VisionBossMod\\Data\\choose.wav");
	VBMVoteFrameText:SetText(from.." has called for an "..vbm_c_r.."Anonymous"..vbm_c.." vote:");
	VBMVoteFrameSubject:SetText(reason);
	VBMVoteFrame.voteto = from;
	VBMVoteFrame:Show();
end

function VBM_VoteReciveWhisper(text,from) --event in extrafeatures.lua
	local s = string.lower(text);
	if(s=="yes" and running_vote[from]) then
		running_vote[from] = 1;
	end
	if(s=="no" and running_vote[from]) then
		running_vote[from] = 2;
	end
end

-- *********************
-- END VOTE
-- *********************

function VBM_EasterEggs(msg)
	local text = string.lower(msg);
	if(text == "!fisker") then
		--vbm_sendchatnovbm("Hej jag heter Christer Eriksson, och jag är proffs på datorspel.");
		--vbm_sendchatnovbm("Kom igen nudå! Håll tanksen! Näe..");
	end
end
