local AIO = AIO or require("AIO")
local PriestHandlers = AIO.AddHandlers("TalentPriestspell", {})
local TalentPriestPointsSpend = {}

local MAX_TALENTS = 42

local talents = {

	
	["spellunbreakablewill"] = {spellID = 14791, itemID = 338404},
	["spelltwindisciplines"] = {spellID = 52803, itemID = 338404},
	["spellsilentresolve"] = {spellID = 14785, itemID = 338404},
	["spellimprovedinnerfire"] = {spellID = 14771, itemID = 338404},
	["spellimprovedpowerwordfortitude"] = {spellID = 14767, itemID = 338404},
	["spellmartyrdom"] = {spellID = 14774, itemID = 338404},
	["spellmeditation"] = {spellID = 14777, itemID = 338404},
	["spellinnerfocus"] = {spellID = 14751, itemID = 338404},
	["spellimprovedpowerwordshield"] = {spellID = 14769, itemID = 338404},
	["spellabsolution"] = {spellID = 33172, itemID = 338404},
	["spellmentalagility"] = {spellID = 14781, itemID = 338404},
	["spellimprovedmanaburn"] = {spellID = 14772, itemID = 338404},
	["spellreflectiveshield"] = {spellID = 33202, itemID = 338404},
	["spellmentalstrength"] = {spellID = 18555, itemID = 338404},
	["spellsoulwarding"] = {spellID = 63574, itemID = 338404},
	["spellfocusedpower"] = {spellID = 33190, itemID = 338404},
	["spellenlightenment"] = {spellID = 34910, itemID = 338404},
	["spellfocusedwill"] = {spellID = 45244, itemID = 338404},
	["spellpowerinfusion"] = {spellID = 10060, itemID = 338404},
	["spellimprovedflashheal"] = {spellID = 63506, itemID = 338404},
	["spellrenewedhope"] = {spellID = 57472, itemID = 338404},
	["spellrapture"] = {spellID = 47537, itemID = 338404},
	["spellaspiration"] = {spellID = 47508, itemID = 338404},
	["spelldivineaegis"] = {spellID = 47515, itemID = 338404},
	["spellpainsuppression"] = {spellID = 33206, itemID = 338404},
	["spellgrace"] = {spellID = 47517, itemID = 338404},
	["spellborrowedtime"] = {spellID = 52800, itemID = 338404},
	["spellpenance"] = {spellID = 47540, itemID = 338404},
	
	
	["spellhealingfocus"] = {spellID = 15012, itemID = 338404},
	["spellimprovedrenew"] = {spellID = 17191, itemID = 338404},
	["spellholyspecialization"] = {spellID = 15011, itemID = 338404},
	["spellspellwarding"] = {spellID = 27904, itemID = 338404},
	["spelldivinefury"] = {spellID = 18535, itemID = 338404},
	["spelldesperateprayer"] = {spellID = 19236, itemID = 338404},
	["spellblessedrecovery"] = {spellID = 27816, itemID = 338404},
	["spellinspiration"] = {spellID = 15363, itemID = 338404},
	["spellholyreach"] = {spellID = 27790, itemID = 338404},
	["spellimprovedhealing"] = {spellID = 15014, itemID = 338404},
	["spellsearinglight"] = {spellID = 15017, itemID = 338404},
	["spellhealingprayers"] = {spellID = 15018, itemID = 338404},
	["spellspiritofredemption"] = {spellID = 20711, itemID = 338404},
	
	
	["spellspiritualguidance"] = {spellID = 15031, itemID = 338404},
	["spellsurgeoflight"] = {spellID = 33154, itemID = 338404},
	["spellspiritualsealing"] = {spellID = 15356, itemID = 338404},
	["spellholyconcentration"] = {spellID = 34860, itemID = 338404},
	["spelllightwell"] = {spellID = 724, itemID = 338404},
	["spellblessedresilience"] = {spellID = 33146, itemID = 338404},
	["spellbodyandsoul"] = {spellID = 64129, itemID = 338404},
	["spellempoweredhealing"] = {spellID = 33162, itemID = 338404},
	["spellserendipity"] = {spellID = 63737, itemID = 338404},
	["spellempoweredrenew"] = {spellID = 63543, itemID = 338404},
	["spellcircleofhealing"] = {spellID = 34861, itemID = 338404},
	["spelltestoffaith"] = {spellID = 47560, itemID = 338404},
	["spelldivineprovidence"] = {spellID = 47567, itemID = 338404},
	["spellguardianspirit"] = {spellID = 47788, itemID = 338404},
	
	
	["spellspirittap"] = {spellID = 15336, itemID = 338404},
	["spellimprovedspirittap"] = {spellID = 15338, itemID = 338404},
	["spelldarkness"] = {spellID = 15310, itemID = 338404},
	["spellshadowaffinity"] = {spellID = 15320, itemID = 338404},
	["spellimprovedshadowwordpain"] = {spellID = 15317, itemID = 338404},
	["spellshadowfocus"] = {spellID = 15328, itemID = 338404},
	["spellimprovedpsychicscream"] = {spellID = 15448, itemID = 338404},
	["spellimprovedmindblast"] = {spellID = 15316, itemID = 338404},
	["spellmindflay"] = {spellID = 15407, itemID = 338404},
	["spellveiledshadows"] = {spellID = 15311, itemID = 338404},
	["spellshadowreacht"] = {spellID = 17323, itemID = 338404},
	["spellshadowweaving"] = {spellID = 15332, itemID = 338404},
	["spellsilence"] = {spellID = 15487, itemID = 338404},
	["spellvampiricembrace"] = {spellID = 15286, itemID = 338404},
	["spellimprovedvampiricembrace"] = {spellID = 27840, itemID = 338404},
	["spellfocusedmind"] = {spellID = 33215, itemID = 338404},
	["spellmindmelt"] = {spellID = 33371, itemID = 338404},
	["spellimproveddevouringplague"] = {spellID = 63627, itemID = 338404},
	["spellshadowform"] = {spellID = 15473, itemID = 338404},
	["spellshadowpower"] = {spellID = 33225, itemID = 338404},
	["spellimprovedshadowform"] = {spellID = 47570, itemID = 338404},
	["spellmisery"] = {spellID = 33193, itemID = 338404},
	["spellpsychichorror"] = {spellID = 64044, itemID = 338404},
	["spellvampirictouch"] = {spellID = 34914, itemID = 338404},
	["spellpainandsufferings"] = {spellID = 47582, itemID = 338404},
	["spelltwistedfaith"] = {spellID = 51167, itemID = 338404},
	["spelldispersion"] = {spellID = 47585, itemID = 338404},
	
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
                if #TalentPriestPointsSpend >= MAX_TALENTS then
                    player:SendAreaTriggerMessage("|cffff0000Vous avez atteint la limite de talents !|r")
                else
                    player:RemoveItem(itemID, 1)
                    player:SendAreaTriggerMessage("|cff00ff00Vous avez appris un nouveau talent !|r")
                    player:LearnSpell(spellID)
                    table.insert(TalentPriestPointsSpend, spellID)
                    AIO.Handle(player, "TalentPriestspell", "UpdateTalentCount", #TalentPriestPointsSpend, MAX_TALENTS)

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
    PriestHandlers[talentName] = function(player, item)
        LearnTalent(player, talentData)
    end
end

local function LoadTalentProgression(player)
    TalentPriestPointsSpend = {}

    local query = CharDBQuery("SELECT spell FROM character_talentspell WHERE guid = " .. player:GetGUIDLow() .. " AND active = 1;")
    if query then
        repeat
            local spellID = query:GetUInt32(0)
            table.insert(TalentPriestPointsSpend, spellID)
        until not query:NextRow()
    end

    AIO.Handle(player, "TalentPriestspell", "UpdateTalentCount", #TalentPriestPointsSpend, MAX_TALENTS)
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

PriestHandlers.ResetTalents = function(player)
    local pointsBeforeReset = #TalentPriestPointsSpend

    for talentName, talentData in pairs(talents) do
        local spellID = talentData.spellID
        player:RemoveSpell(spellID)
    end

    TalentPriestPointsSpend = {}
    ResetTalentProgression(player)
    AIO.Handle(player, "TalentPriestspell", "UpdateTalentCount", 0, MAX_TALENTS)

    local pointsAfterReset = 0
    AIO.Handle(player, "TalentPriestspell", "UpdateTalentPointsUsed", pointsAfterReset, pointsBeforeReset)

    local talentItemID = 338404
    local itemCount = pointsBeforeReset
    local addedItem = player:AddItem(talentItemID, itemCount)

    if addedItem then
    end
end

local function TalentPriestOnCommand(event, player, command)
    if (command == "talentPriest") then
        AIO.Handle(player, "TalentPriestspell", "ShowTalentPriest")
        return false
    end
end
RegisterPlayerEvent(42, TalentPriestOnCommand)