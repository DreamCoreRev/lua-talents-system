local AIO = AIO or require("AIO")
local PaladinHandlers = AIO.AddHandlers("TalentPaladinspell", {})
local TalentPaladinPointsSpend = {}

local MAX_TALENTS = 41

local talents = {

	
	["spellspiritualfocus"] = {spellID = 20208, itemID = 338404},
	["spellsealsofthepure"] = {spellID = 20332, itemID = 338404},
	["spellhealinglight"] = {spellID = 20239, itemID = 338404},
	["spelldivineintellect"] = {spellID = 20261, itemID = 338404},
	["spellunyieldingfaith"] = {spellID = 25836, itemID = 338404},
	["spellauramastery"] = {spellID = 31821, itemID = 338404},
	["spellillumination"] = {spellID = 20215, itemID = 338404},
	["spellimprovedlayonhands"] = {spellID = 20235, itemID = 338404},
	["spellimprovedconcentrationaura"] = {spellID = 20256, itemID = 338404},
	["spellimprovedblessingofwisdom"] = {spellID = 20245, itemID = 338404},
	["spellblessedhands"] = {spellID = 53661, itemID = 338404},
	["spellpureofheart"] = {spellID = 31823, itemID = 338404},
	["spelldivinefavor"] = {spellID = 20216, itemID = 338404},
	["spellsanctifiedlight"] = {spellID = 20361, itemID = 338404},
	["spellpurifyingpower"] = {spellID = 31826, itemID = 338404},
	["spellholypower"] = {spellID = 25829, itemID = 338404},
	["spelllightsgrace"] = {spellID = 31826, itemID = 338404},
	["spellholyshock"] = {spellID = 20473, itemID = 338404},
	["spellblessedlife"] = {spellID = 31830, itemID = 338404},
	["spellsacredcleansing"] = {spellID = 53553, itemID = 338404},
	["spellholyguidance"] = {spellID = 31841, itemID = 338404},
	["spelldivineillumination"] = {spellID = 31842, itemID = 338404},
	["spelljudgementsofthepure"] = {spellID = 54155, itemID = 338404},
	["spellinfusionoflight"] = {spellID = 53576, itemID = 338404},
	["spellenlightenedjudgements"] = {spellID = 53557, itemID = 338404},
	["spellbeaconoflight"] = {spellID = 53563, itemID = 338404},
	["spelldivinity"] = {spellID = 63650, itemID = 338404},
	["spelldivinestrength"] = {spellID = 20266, itemID = 338404},
	
	
	["spellstoicism"] = {spellID = 53519, itemID = 338404},
	["spellguardiansfavor"] = {spellID = 20175, itemID = 338404},
	["spellanticipation"] = {spellID = 20100, itemID = 338404},
	["spelldivinesacrifice"] = {spellID = 64205, itemID = 338404},
	["spellimprovedrighteousfury"] = {spellID = 20470, itemID = 338404},
	["spelltoughness"] = {spellID = 20147, itemID = 338404},
	["spelldivineguardian"] = {spellID = 53530, itemID = 338404},
	["spellimprovedhammerofjustice"] = {spellID = 20488, itemID = 338404},
	["spellimproveddevotionaura"] = {spellID = 20140, itemID = 338404},
	["spellblessingofsanctuary"] = {spellID = 20911, itemID = 338404},
	["spellreckoning"] = {spellID = 20182, itemID = 338404},
	["spellsacredduty"] = {spellID = 31849, itemID = 338404},
	["spellonehandedweaponspecialization"] = {spellID = 20198, itemID = 338404},
	
	
	["spellspiritualattunement"] = {spellID = 33776, itemID = 338404},
	["spellholyshield"] = {spellID = 20925, itemID = 338404},
	["spellardentdefender"] = {spellID = 31852, itemID = 338404},
	["spellredoubt"] = {spellID = 20135, itemID = 338404},
	["spellcombatexpertise"] = {spellID = 31860, itemID = 338404},
	["spelltouchedbythelight"] = {spellID = 53592, itemID = 338404},
	["spellavengersshield"] = {spellID = 31935, itemID = 338404},
	["spellguardedbythelight"] = {spellID = 53585, itemID = 338404},
	["spellthieldofthetemplar"] = {spellID = 53711, itemID = 338404},
	["spelljudgementsofthejust"] = {spellID = 53696, itemID = 338404},
	["spellhammeroftherighteous"] = {spellID = 53595, itemID = 338404},
	["spelldeflection"] = {spellID = 20064, itemID = 338404},
	["spellbenediction"] = {spellID = 20105, itemID = 338404},
	["spellimprovedjudgements"] = {spellID = 25957, itemID = 338404},
	
	
	["spellheartofthecrusader"] = {spellID = 20337, itemID = 338404},
	["spellimprovedblessingofmight"] = {spellID = 20045, itemID = 338404},
	["spellindication"] = {spellID = 26016, itemID = 338404},
	["spellconviction"] = {spellID = 20121, itemID = 338404},
	["spellsealofcommand"] = {spellID = 20375, itemID = 338404},
	["spellpursuitofjustice"] = {spellID = 26023, itemID = 338404},
	["spelleyeforaneye"] = {spellID = 25988, itemID = 338404},
	["spellsanctityofbattle"] = {spellID = 35397, itemID = 338404},
	["spellcrusade"] = {spellID = 31868, itemID = 338404},
	["spelltwohandedweaponspecialization"] = {spellID = 20113, itemID = 338404},
	["spellsanctifiedretribution"] = {spellID = 31869, itemID = 338404},
	["spellvengeance"] = {spellID = 20057, itemID = 338404},
	["spelldivinepurpose"] = {spellID = 31872, itemID = 338404},
	["spelltheartofwar"] = {spellID = 53488, itemID = 338404},
	["spellrepentance"] = {spellID = 20066, itemID = 338404},
	["spelljudgementsofthewise"] = {spellID = 31878, itemID = 338404},
	["spellfanaticism"] = {spellID = 31881, itemID = 338404},
	["spellsanctifiedwrath"] = {spellID = 53376, itemID = 338404},
	["spellswiftretribution"] = {spellID = 53648, itemID = 338404},
	["spellcrusaderstrike"] = {spellID = 35395, itemID = 338404},
	["spellsheathoflight"] = {spellID = 53503, itemID = 338404},
	["spellrighteousvengeance"] = {spellID = 53382, itemID = 338404},
	["spelldivinestorm"] = {spellID = 53385, itemID = 338404},
}

local function LearnTalent(player, talent)
    local spellID = talent.spellID
    local itemID = talent.itemID

    if player:IsInCombat() then
        player:SendAreaTriggerMessage("|cffff0000Vous ne pouvez pas faire cela en combattant !|r")
    else
        if player:HasSpell(spellID) then
            player:SendAreaTriggerMessage("|cff00ffffVous connaissez déjà ce talent !|r")
        else
            if player:HasItem(itemID) then
                if #TalentPaladinPointsSpend >= MAX_TALENTS then
                    player:SendAreaTriggerMessage("|cffff0000Vous avez atteint la limite de talents !|r")
                else
                    player:RemoveItem(itemID, 1)
                    player:SendAreaTriggerMessage("|cff00ff00Vous avez appris un nouveau talent !|r")
                    player:LearnSpell(spellID)
                    table.insert(TalentPaladinPointsSpend, spellID)
                    AIO.Handle(player, "TalentPaladinspell", "UpdateTalentCount", #TalentPaladinPointsSpend, MAX_TALENTS)

                    local query = CharDBQuery("REPLACE INTO character_talentspell (guid, spell, active) VALUES (" .. player:GetGUIDLow() .. ", " .. spellID .. ", 1);")
                    if not query then
                    end
                end
            else
                player:SendAreaTriggerMessage("|cffff0000Vous n'avez pas de point de talent !|r")
            end
        end
    end
end

for talentName, talentData in pairs(talents) do
    PaladinHandlers[talentName] = function(player, item)
        LearnTalent(player, talentData)
    end
end

local function LoadTalentProgression(player)
    TalentPaladinPointsSpend = {}

    local query = CharDBQuery("SELECT spell FROM character_talentspell WHERE guid = " .. player:GetGUIDLow() .. " AND active = 1;")
    if query then
        repeat
            local spellID = query:GetUInt32(0)
            table.insert(TalentPaladinPointsSpend, spellID)
        until not query:NextRow()
    end

    AIO.Handle(player, "TalentPaladinspell", "UpdateTalentCount", #TalentPaladinPointsSpend, MAX_TALENTS)
end

local function OnPlayerLogin(event, player)
    LoadTalentProgression(player)
end
RegisterPlayerEvent(3, OnPlayerLogin)

local function ResetTalentProgression(player)
    local deleteQuery = CharDBQuery("DELETE FROM character_talentspell WHERE guid = " .. player:GetGUIDLow() .. ";")
    if not deleteQuery then
    end
end

PaladinHandlers.ResetTalents = function(player)
    local pointsBeforeReset = #TalentPaladinPointsSpend

    for talentName, talentData in pairs(talents) do
        local spellID = talentData.spellID
        player:RemoveSpell(spellID)
    end

    TalentPaladinPointsSpend = {}
    ResetTalentProgression(player)
    AIO.Handle(player, "TalentPaladinspell", "UpdateTalentCount", 0, MAX_TALENTS)

    local pointsAfterReset = 0
    AIO.Handle(player, "TalentPaladinspell", "UpdateTalentPointsUsed", pointsAfterReset, pointsBeforeReset)

    local talentItemID = 338404
    local itemCount = pointsBeforeReset
    local addedItem = player:AddItem(talentItemID, itemCount)

    if addedItem then
    end
end

local function TalentPaladinOnCommand(event, player, command)
    if (command == "talentPaladin") then
        AIO.Handle(player, "TalentPaladinspell", "ShowTalentPaladin")
        return false
    end
end
RegisterPlayerEvent(42, TalentPaladinOnCommand)