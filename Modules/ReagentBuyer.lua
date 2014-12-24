--[[
	********************************************************************
	********************************************************************
	Reagent Buyer
	
	********************************************************************
	********************************************************************

]]--

VBM_RB_ReagentTree = {
--[[ class skills no longer have reagents
    ["Gift of the Wild"] = {
		[0] = "NONE",
		[1] = "Wild Berries",
		[2] = "Wild Thornroot",
		[3] = "Wild Quillvine",
		[4] = "Wild Spineleaf",
	};
	["Rebirth"] = {
		[0] = "NONE",
		[1] = "Maple Seed",
		[2] = "Stranglethorn Seed",
		[3] = "Ashwood Seed",
		[4] = "Hornbeam Seed",
		[5] = "Ironwood Seed",
		[6] = "Flintweed Seed",
		[7] = "Starleaf Seed",
	};
	["Arcane Brilliance"] = {
		[0] = "Arcane Powder",
	};
	["Teleport"] = {
		[0] = "Rune of Teleportation",
	};
	["Portal"] = {
		[0] = "Rune of Portals",
	};
	["Prayer of Fortitude"] = {
		[0] = "NONE",
		[1] = "Holy Candle",
		[2] = "Sacred Candle",
		[3] = "Sacred Candle",
		[4] = "Devout Candle",
	};
	["Reincarnation"] = {
		[0] = "Ankh",
	};
	["Inferno"] = {
		[0] = "Infernal Stone",
	};
	["Ritual of Doom"] = {
		[0] = "Demonic Figurine",
	};
	["Greater Blessing of Might"] = {
		[0] = "Symbol of Kings",
	};
	["Divine Intervention"] = {
		[0] = "Symbol of Divinity",
	};
	["Rogue1"] = {
		[0] = "Deadly Poison IX",
	};
	["Rogue2"] = {
		[0] = "Instant Poison IX",
	};
	["Rogue3"] = {
		[0] = "Wound Poison VII",
	};
	["Raise Dead"] = {
		[0] = "Corpse Dust",
	};
]]--
    ["Vanishing Powder"] = {
        [0] = "Vanishing Powder",
    };
    ["Dust of Disappearance"] = {
        [0] = "Dust of Disappearance",
    };
    ["Tome of the Clear Mind"] = {
        [0] = "Tome of the Clear Mind",
    };
};

VBM_RB_skill = 0;
VBM_RB_rank = 0;
VBM_RB_reagents = {};

function VBM_ReagentBuyer_OnLoad(self)
	self:RegisterEvent("MERCHANT_SHOW");
	self:RegisterEvent("MERCHANT_CLOSED");
	self:RegisterEvent("PLAYER_LOGIN");
	self:RegisterEvent("BAG_UPDATE");
end

function VBM_ReagentBuyer_OnEvent(event)
	if(event=="PLAYER_LOGIN") then
		--set saved varible
		if(not VBMRB) then VBMRB = {}; end
		
		VBM_RB_GetSkills();
	end
	
	if(event=="MERCHANT_SHOW") then
		if(VBM_GetS("AutoSellGreyItems")) then
			VBM_SellGrey();
		end
		if(VBM_GetS("ReagentBuyer") and VBM_RB_HaveReagents()) then
			VBMReagentBuyerFrame:Show();
			VBM_RB_UpdateFrame();
			if(VBM_GetS("ReagentBuyerAuto")) then
				VBM_RB_Buy();
			end
		end
	end
	
	if(event=="MERCHANT_CLOSED") then
		VBMReagentBuyerFrame:Hide();
	end
	
	if(event=="BAG_UPDATE") then
		if(VBMReagentBuyerFrame:IsVisible()) then
			VBM_RB_UpdateFrame();
		end
	end
end

function VBM_RB_UpdateFrame()
	local text,bag,slot,count;
	for i=1,#VBM_RB_skill do
		--get reagent
		text = VBM_RB_GetReagent(VBM_RB_skill[i]);
		--scan inventory
		VBM_RB_reagents[text] = 0;
		for bag=0,NUM_BAG_SLOTS do
			for slot=1,GetContainerNumSlots(bag) do
				if (GetContainerItemLink(bag,slot) and string.find(GetContainerItemLink(bag,slot), text)) then
					_,count = GetContainerItemInfo(bag, slot);
					VBM_RB_reagents[text] = VBM_RB_reagents[text] + count;
				end
			end
		end
		--add text
		getglobal("VBMReagentBuyerFrameReagent"..i.."Text"):SetText(text.." ("..VBM_RB_reagents[text]..")");
		--get saved nr to buy
		if(not VBMRB[i]) then
			VBMRB[i] = 0;
		else
			if(VBMRB[i] < 0) then
				VBMRB[i] = 0;
			end
		end
		getglobal("VBMReagentBuyerFrameReagent"..i):SetText(VBMRB[i]);
		getglobal("VBMReagentBuyerFrameReagent"..i):Show();
	end
	--update the total text
	local have,of = 0,0;
	for i=1,#VBM_RB_skill do
		have = have + math.max(VBMRB[i]-VBM_RB_reagents[VBM_RB_GetReagent(VBM_RB_skill[i])],0); 
		of = of + VBMRB[i];
	end
	VBMReagentBuyerFrameBuyButtonExtraText:SetText("Total Missing "..have.."/"..of);
end

function VBM_RB_Buy()
	--if button is diabled dont run buy function
	if(VBMReagentBuyerFrameBuyButton:IsEnabled()==0) then
		return;
	end
	VBMReagentBuyerFrameBuyButton:Disable();
	--scan alla merchants item
	for i=1,GetMerchantNumItems() do
		--read item info
		local name, texture, price, quantity, numAvailable, isUsable, extendedCost = GetMerchantItemInfo(i);
		local maxStack = GetMerchantItemMaxStack(i);
		--loop all our ragents
		for j=1,#VBM_RB_skill do
			--get reagent
			local r = VBM_RB_GetReagent(VBM_RB_skill[j]);
			if(name==r) then
				--get how many we have to buy
				local buy = math.max(VBMRB[j]-VBM_RB_reagents[r],0);
				--divide by quantity so we get how many times we have to click the item
				buy = math.floor(buy/quantity);
				if(buy > 0) then
					vbm_printc("ReagentBuyer: Buying "..buy.." "..r);
				end
				--save clicks by buing maxStack
				while(buy > 0) do
					if(buy > maxStack) then
						BuyMerchantItem(i,maxStack);
						buy = buy - maxStack;
					else
						BuyMerchantItem(i,buy);
						buy = buy - buy;
					end					
				end
			end
		end
	end
	
	VBM_Delay(5,VBM_RB_Buy_delay);
end

function VBM_RB_Buy_delay()
	VBMReagentBuyerFrameBuyButton:Enable();
end

function VBM_RB_SaveValues()
	for i=1,#VBM_RB_skill do
		VBMRB[i] = tonumber(getglobal("VBMReagentBuyerFrameReagent"..i):GetText());
	end
	VBM_RB_UpdateFrame();
end

function VBM_RB_HaveReagents()
	if(VBM_RB_skill==0) then return false; end
	
	for i=1,GetMerchantNumItems() do
		for j=1,#VBM_RB_skill do
			if(GetMerchantItemInfo(i) == VBM_RB_GetReagent(VBM_RB_skill[j])) then
				return true;
			end
		end
	end
		
	return false;
end

function VBM_RB_GetReagent(skill)
	if(VBM_RB_ReagentTree[skill][0] ~= "NONE") then
		return VBM_RB_ReagentTree[skill][0];
	elseif(VBM_RB_ReagentTree[skill][VBM_RB_rank[skill]]) then
		return VBM_RB_ReagentTree[skill][VBM_RB_rank[skill]];
	end
	
	return false;
end

function VBM_RB_GetSkills()
	local skill = {};
	local rank = {};
	local class = UnitClass("player");
    local level = UnitLevel("player");

	--get skills
    --[[ class skills no longer have reagents
	if(class == "Druid") then
		skill[1] = "Gift of the Wild";
		skill[2] = "Rebirth";
	elseif(class == "Mage") then
		skill[1] = "Arcane Brilliance";
		skill[2] = "Teleport";
		skill[3] = "Portal";
	elseif(class == "Priest") then
		skill[1] = "Prayer of Fortitude";
	elseif(class == "Shaman") then
		skill[1] = "Reincarnation";
	elseif(class == "Paladin") then
		skill[1] = "Greater Blessing of Might";
		skill[2] = "Divine Intervention";
	elseif(class == "Warlock") then
		skill[1] = "Inferno";
		skill[2] = "Ritual of Doom";
	elseif(class == "Rogue") then
		skill[1] = "Rogue1";
		skill[2] = "Rogue2";
		skill[3] = "Rogue3";
	elseif(class == "Death Knight") then
		skill[1] = "Raise Dead";
	else
		return;
	end
    ]]--
    --
    if(level < 81) then
        skill[1] = "Vanishing Powder";
    elseif(level > 80 and level < 86) then
        skill[1] = "Dust of Disappearance";
    elseif(level > 85) then
        skill[1] = "Tome of the Clear Mind";
    else
        return;
    end
	--set rank to 0
	for i=1,#skill do
		rank[skill[i]] = 0;
	end
	--scan for your highest rank
	local spellName, spellRank, f, srank;
	i = 1;
	while true do
		spellName, spellRank = GetSpellBookItemName(i, BOOKTYPE_SPELL)
		if(not spellName) then
			do break; end
		end
		for j=1,#skill do
			if(skill[j]==spellName) then
				--parse rank
				f,_,srank = string.find(spellRank,"Rank (%d+)");
				if(f and rank[spellName] < tonumber(srank)) then
					rank[spellName] = tonumber(srank);
				end
			end
		end
		i = i + 1;
	end
	--print out the info
	for i=1,#skill do
		vbm_verbosec("ReagentBuyer: "..skill[i].." (Rank "..rank[skill[i]]..")");
	end
	
	VBM_RB_skill = skill;
	VBM_RB_rank = rank;
end
