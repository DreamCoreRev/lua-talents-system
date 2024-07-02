local AIO = AIO or require("AIO")
local HerosHandlers = AIO.AddHandlers("TalentHerosspell", {})
local TalentHerosPointsSpend = {}

local MAX_TALENTS = 6

local talents = {

	
	["spellbeserker"] = {spellID = 381804, itemID = 338404},
    ["spellrallyingcry"] = {spellID = 382034, itemID = 338404},
    ["spellspeed"] = {spellID = 381712, itemID = 338404},
    ["spellruse"] = {spellID = 381972, itemID = 338404},
    ["spelldisengage"] = {spellID = 382000, itemID = 338404},
	
	["spelllightningstrike"] = {spellID = 381740, itemID = 338404},
    ["spellfireball"] = {spellID = 381689, itemID = 338404},
    ["spellfrostball"] = {spellID = 381790, itemID = 338404},
    ["spelldivinefury"] = {spellID = 381838, itemID = 338404},
    ["spellignition"] = {spellID = 381904, itemID = 338404}
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
                if #TalentHerosPointsSpend >= MAX_TALENTS then
                    player:SendAreaTriggerMessage("|cffff0000Vous avez atteint la limite de talents !|r")
                else
                    player:RemoveItem(itemID, 1)
                    player:SendAreaTriggerMessage("|cff00ff00Vous avez appris un nouveau talent !|r")
                    player:LearnSpell(spellID)
                    table.insert(TalentHerosPointsSpend, spellID)
                    AIO.Handle(player, "TalentHerosspell", "UpdateTalentCount", #TalentHerosPointsSpend, MAX_TALENTS)

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
    HerosHandlers[talentName] = function(player, item)
        LearnTalent(player, talentData)
    end
end

local function LoadTalentProgression(player)
    TalentHerosPointsSpend = {}

    local query = CharDBQuery("SELECT spell FROM character_talentspell WHERE guid = " .. player:GetGUIDLow() .. " AND active = 1;")
    if query then
        repeat
            local spellID = query:GetUInt32(0)
            table.insert(TalentHerosPointsSpend, spellID)
        until not query:NextRow()
    end

    AIO.Handle(player, "TalentHerosspell", "UpdateTalentCount", #TalentHerosPointsSpend, MAX_TALENTS)
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

HerosHandlers.ResetTalents = function(player)
    local pointsBeforeReset = #TalentHerosPointsSpend

    for talentName, talentData in pairs(talents) do
        local spellID = talentData.spellID
        player:RemoveSpell(spellID)
    end

    TalentHerosPointsSpend = {}
    ResetTalentProgression(player)
    AIO.Handle(player, "TalentHerosspell", "UpdateTalentCount", 0, MAX_TALENTS)

    local pointsAfterReset = 0
    AIO.Handle(player, "TalentHerosspell", "UpdateTalentPointsUsed", pointsAfterReset, pointsBeforeReset)

    local talentItemID = 338404
    local itemCount = pointsBeforeReset
    local addedItem = player:AddItem(talentItemID, itemCount)

    if addedItem then
    end
end

local function TalentHerosOnCommand(event, player, command)
    if (command == "talentHeros") then
        AIO.Handle(player, "TalentHerosspell", "ShowTalentHeros")
        return false
    end
end
RegisterPlayerEvent(42, TalentHerosOnCommand)