local AIO = AIO or require("AIO")
local BloodbattlemageHandlers = AIO.AddHandlers("TalentBloodbattlemagespell", {})
local TalentBloodbattlemagePointsSpend = {}

local MAX_TALENTS = 31

local talents = {

	
	
	["spellimprovedblood"] = {spellID = 300021, itemID = 338404},
	["spellseedgrowth"] = {spellID = 300113, itemID = 338404},
	["spelloppressiveray"] = {spellID = 300034, itemID = 338404},
	["spellbloodbundle"] = {spellID = 300039, itemID = 338404},
	["spellbloody"] = {spellID = 300229, itemID = 338404},
	["spellhomeothermal"] = {spellID = 300043, itemID = 338404},
	["spelltargeted"] = {spellID = 300209, itemID = 338404},
	["spelleffusion"] = {spellID = 300217, itemID = 338404},
	["spellseedpreparation"] = {spellID = 300089, itemID = 338404},
	["spellbloodtransfusion"] = {spellID = 300045, itemID = 338404},
	["spellbloodtransfusionimprove"] = {spellID = 300084, itemID = 338404},
	["spellsangthe"] = {spellID = 300064, itemID = 338404},
	["spellparasyteseed"] = {spellID = 300040, itemID = 338404},
	["spellmentalconditioning"] = {spellID = 300226, itemID = 338404},
	["spellwarmup"] = {spellID = 300026, itemID = 338404},
	["spellbloodcirculation"] = {spellID = 300224, itemID = 338404},
	["spellbloodessence"] = {spellID = 300050, itemID = 338404},
	["spellbloodyapparation"] = {spellID = 300052, itemID = 338404},
	["spellhotblood"] = {spellID = 300029, itemID = 338404},
	["spellnoblood"] = {spellID = 300116, itemID = 338404},
	["spellbloodsample"] = {spellID = 300100, itemID = 338404},
	["spellcollectivedonation"] = {spellID = 300119, itemID = 338404},
	["spellbloodflow"] = {spellID = 300170, itemID = 338404},
	["spellbloodstorm"] = {spellID = 300099, itemID = 338404},
	["spellreinforcedblood"] = {spellID = 300125, itemID = 338404},
	
	
	
	["spellabilitymotivation"] = {spellID = 300095, itemID = 338404},
	["spellabilitybloodflow"] = {spellID = 300101, itemID = 338404},
	["spellabilitycare"] = {spellID = 300093, itemID = 338404},
	["spellabilityprotection"] = {spellID = 300091, itemID = 338404},
	["spellabilitysword"] = {spellID = 300092, itemID = 338404},
	["spellabilityprotector"] = {spellID = 300094, itemID = 338404},
	["spellabilitypureblood"] = {spellID = 300096, itemID = 338404},
	["spellharvestingsuffering"] = {spellID = 300149, itemID = 338404},
	["spellbloodbarrier"] = {spellID = 300109, itemID = 338404},
	["spellabilityimprovement"] = {spellID = 300180, itemID = 338404},
	["spellabilitypotential"] = {spellID = 300175, itemID = 338404},
	
	
	["spellbloodprovocation"] = {spellID = 1502003, itemID = 338404},
	["spellmartialknowledge"] = {spellID = 300135, itemID = 338404},
	["spellmicrobalance"] = {spellID = 300130, itemID = 338404},
	["spellmortalbloodorb"] = {spellID = 300102, itemID = 338404},
	["spellmortalmultiplecontusion"] = {spellID = 300104, itemID = 338404},
	["spellmortalsurgicalstrike"] = {spellID = 300105, itemID = 338404},
	["spellmortaldestruction"] = {spellID = 300106, itemID = 338404},
	["spellcollectingblood"] = {spellID = 300140, itemID = 338404},
	["spellbloodyblood"] = {spellID = 300155, itemID = 338404},
	["spellbloodshed"] = {spellID = 300160, itemID = 338404},
	["spelllethalpowerfulimpulse"] = {spellID = 300110, itemID = 338404},
	["spellinternalhemorrhage"] = {spellID = 300165, itemID = 338404},
	["spellanticipateddestruction"] = {spellID = 300145, itemID = 338404},

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
                if #TalentBloodbattlemagePointsSpend >= MAX_TALENTS then
                    player:SendAreaTriggerMessage("|cffff0000Vous avez atteint la limite de talents !|r")
                else
                    player:RemoveItem(itemID, 1)
                    player:SendAreaTriggerMessage("|cff00ff00Vous avez appris un nouveau talent !|r")
                    player:LearnSpell(spellID)
                    table.insert(TalentBloodbattlemagePointsSpend, spellID)
                    AIO.Handle(player, "TalentBloodbattlemagespell", "UpdateTalentCount", #TalentBloodbattlemagePointsSpend, MAX_TALENTS)

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
    BloodbattlemageHandlers[talentName] = function(player, item)
        LearnTalent(player, talentData)
    end
end

local function LoadTalentProgression(player)
    TalentBloodbattlemagePointsSpend = {}

    local query = CharDBQuery("SELECT spell FROM character_talentspell WHERE guid = " .. player:GetGUIDLow() .. " AND active = 1;")
    if query then
        repeat
            local spellID = query:GetUInt32(0)
            table.insert(TalentBloodbattlemagePointsSpend, spellID)
        until not query:NextRow()
    end

    AIO.Handle(player, "TalentBloodbattlemagespell", "UpdateTalentCount", #TalentBloodbattlemagePointsSpend, MAX_TALENTS)
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

BloodbattlemageHandlers.ResetTalents = function(player)
    local pointsBeforeReset = #TalentBloodbattlemagePointsSpend

    for talentName, talentData in pairs(talents) do
        local spellID = talentData.spellID
        player:RemoveSpell(spellID)
    end

    TalentBloodbattlemagePointsSpend = {}
    ResetTalentProgression(player)
    AIO.Handle(player, "TalentBloodbattlemagespell", "UpdateTalentCount", 0, MAX_TALENTS)

    local pointsAfterReset = 0
    AIO.Handle(player, "TalentBloodbattlemagespell", "UpdateTalentPointsUsed", pointsAfterReset, pointsBeforeReset)

    local talentItemID = 338404
    local itemCount = pointsBeforeReset
    local addedItem = player:AddItem(talentItemID, itemCount)

    if addedItem then
    end
end

local function TalentBloodbattlemageOnCommand(event, player, command)
    if (command == "talentBloodbattlemage") then
        AIO.Handle(player, "TalentBloodbattlemagespell", "ShowTalentBloodbattlemage")
        return false
    end
end
RegisterPlayerEvent(42, TalentBloodbattlemageOnCommand)