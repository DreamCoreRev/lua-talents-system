local AIO = AIO or require("AIO")
local DemonhunterHandlers = AIO.AddHandlers("TalentDemonhunterspell", {})
local TalentDemonhunterPointsSpend = {}

local MAX_TALENTS = 21

local talents = {

	
    ["spellwarglaiveschaos"] = {spellID = 98981, itemID = 338404},
	["spelldemonspeed"] = {spellID = 98980, itemID = 338404},
	["spellunboundchaos"] = {spellID = 98897, itemID = 338404},
	["spellchaosvision"] = {spellID = 98891, itemID = 338404},
	["spelldevastatingchaos"] = {spellID = 98890, itemID = 338404},
	["spelldesperateinstincts"] = {spellID = 98885, itemID = 338404},
	["spellimproveddemonsbite"] = {spellID = 98886, itemID = 338404},
	["spellnetherwalk"] = {spellID = 98884, itemID = 338404},
	["spellanguishdeceiver"] = {spellID = 98889, itemID = 338404},
	["spellchaoticonslaught"] = {spellID = 98878, itemID = 338404},
	["spellillidariknowledge"] = {spellID = 98879, itemID = 338404},
	["spellunleashedpower"] = {spellID = 98876, itemID = 338404},
	["spellchaosblade"] = {spellID = 98859, itemID = 338404},
	["spellimprovedmetamorphosis"] = {spellID = 98875, itemID = 338404},
	["spellunleasheddemons"] = {spellID = 98872, itemID = 338404},
	["spellbalancedblades"] = {spellID = 98862, itemID = 338404},
	["spelldemonic"] = {spellID = 98870, itemID = 338404},
	["spellfelwounds"] = {spellID = 98860, itemID = 338404},
	["spellfelbarrage"] = {spellID = 98868, itemID = 338404},
	

	
	["spellthickskin"] = {spellID = 320384, itemID = 338404},
	["spelldemonicwards"] = {spellID = 203514, itemID = 338404},
	
	
	["spellsharpenedglaives"] = {spellID = 98854, itemID = 338404},
	["spelldisorientglaives"] = {spellID = 98851, itemID = 338404},
	["spellfireglaives"] = {spellID = 98845, itemID = 338404},
	["spellmasterglaive"] = {spellID = 98832, itemID = 338404},
	["spellmasteryspeed"] = {spellID = 98831, itemID = 338404},
	["spellimprovedfireglaives"] = {spellID = 98842, itemID = 338404},
	["spellcauterize"] = {spellID = 98850, itemID = 338404},
	["spelldualbladedance"] = {spellID = 98829, itemID = 338404},
	["spellimproveddualblades"] = {spellID = 98827, itemID = 338404},
	["spellbloodlet"] = {spellID = 98839, itemID = 338404},
	["spellrapidglaives"] = {spellID = 98835, itemID = 338404},
	["spellvenomlet"] = {spellID = 98838, itemID = 338404},
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
                if #TalentDemonhunterPointsSpend >= MAX_TALENTS then
                    player:SendAreaTriggerMessage("|cffff0000Vous avez atteint la limite de talents !|r")
                else
                    player:RemoveItem(itemID, 1)
                    player:SendAreaTriggerMessage("|cff00ff00Vous avez appris un nouveau talent !|r")
                    player:LearnSpell(spellID)
                    table.insert(TalentDemonhunterPointsSpend, spellID)
                    AIO.Handle(player, "TalentDemonhunterspell", "UpdateTalentCount", #TalentDemonhunterPointsSpend, MAX_TALENTS)

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
    DemonhunterHandlers[talentName] = function(player, item)
        LearnTalent(player, talentData)
    end
end

local function LoadTalentProgression(player)
    TalentDemonhunterPointsSpend = {}

    local query = CharDBQuery("SELECT spell FROM character_talentspell WHERE guid = " .. player:GetGUIDLow() .. " AND active = 1;")
    if query then
        repeat
            local spellID = query:GetUInt32(0)
            table.insert(TalentDemonhunterPointsSpend, spellID)
        until not query:NextRow()
    end

    AIO.Handle(player, "TalentDemonhunterspell", "UpdateTalentCount", #TalentDemonhunterPointsSpend, MAX_TALENTS)
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

DemonhunterHandlers.ResetTalents = function(player)
    local pointsBeforeReset = #TalentDemonhunterPointsSpend

    for talentName, talentData in pairs(talents) do
        local spellID = talentData.spellID
        player:RemoveSpell(spellID)
    end

    TalentDemonhunterPointsSpend = {}
    ResetTalentProgression(player)
    AIO.Handle(player, "TalentDemonhunterspell", "UpdateTalentCount", 0, MAX_TALENTS)

    local pointsAfterReset = 0
    AIO.Handle(player, "TalentDemonhunterspell", "UpdateTalentPointsUsed", pointsAfterReset, pointsBeforeReset)

    local talentItemID = 338404
    local itemCount = pointsBeforeReset
    local addedItem = player:AddItem(talentItemID, itemCount)

    if addedItem then
    end
end

local function TalentDemonhunterOnCommand(event, player, command)
    if (command == "talentDemonhunter") then
        AIO.Handle(player, "TalentDemonhunterspell", "ShowTalentDemonhunter")
        return false
    end
end
RegisterPlayerEvent(42, TalentDemonhunterOnCommand)