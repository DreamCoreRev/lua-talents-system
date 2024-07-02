local AIO = AIO or require("AIO")
local MonkHandlers = AIO.AddHandlers("TalentMonkspell", {})
local TalentMonkPointsSpend = {}

local MAX_TALENTS = 44

local talents = {
    ["spellpurifyingbrew"] = {spellID = 119582, itemID = 338404},
    ["spellkegsmash"] = {spellID = 121253, itemID = 338404},
    ["spellascension"] = {spellID = 115396, itemID = 338404},
	["spellgiftox"] = {spellID = 124502, itemID = 338404},
	["spellphysicssphere"] = {spellID = 1115460, itemID = 338404},
	["spellflyingmonk"] = {spellID = 11007428, itemID = 338404},
	["spelltigerhits"] = {spellID = 1100787, itemID = 338404},
	["spelldampenharm"] = {spellID = 1122278, itemID = 338404},
	["spelldizzyinghaze"] = {spellID = 115180, itemID = 338404},
	["spellfortifyingbrew"] = {spellID = 1126456, itemID = 338404},
	["spelllegsweep"] = {spellID = 1119381, itemID = 338404},
	["spellguard"] = {spellID = 115295, itemID = 338404},
	["spelllegacyemperor"] = {spellID = 1117666, itemID = 338404},
	["spelldetox"] = {spellID = 1215450, itemID = 338404},
	["spelladaptation"] = {spellID = 126046, itemID = 338404},
	["spellchibarrage"] = {spellID = 144644, itemID = 338404},
	["spellmonksleap"] = {spellID = 124008, itemID = 338404},
	["spellnimblebrew"] = {spellID = 137562, itemID = 338404},
	["spellpunch"] = {spellID = 109079, itemID = 338404},
	["spellblackoutkick"] = {spellID = 109080, itemID = 338404},
	["spellrisingsunkick"] = {spellID = 107428, itemID = 338404},
	["spellexpelharm"] = {spellID = 115072, itemID = 338404},
	["spellcracklingjadethunderstorm"] = {spellID = 144076, itemID = 338404},
	["spelldisable"] = {spellID = 116095, itemID = 338404},
	["spellringpeace"] = {spellID = 116844, itemID = 338404},
	["spelllifecocoon"] = {spellID = 1216849, itemID = 338404},
	["spellspinningcranekick"] = {spellID = 130767, itemID = 338404},
	["spellwhitetigerlegacy"] = {spellID = 116781, itemID = 338404},
	["spellspearhandstrike"] = {spellID = 116705, itemID = 338404},
	["spelldiffusemagic"] = {spellID = 122783, itemID = 338404},
	["spellflyingserpentkick"] = {spellID = 107427, itemID = 338404},
	["spellzenmeditation"] = {spellID = 115176, itemID = 338404},
	["spellsoothingmist"] = {spellID = 115175, itemID = 338404},
	["spellenvelopingmist"] = {spellID = 124682, itemID = 338404},
	["spellrenewingmist"] = {spellID = 115151, itemID = 338404},
	["spellsurgingmist"] = {spellID = 116694, itemID = 338404},
	["spellchiwave"] = {spellID = 1215098, itemID = 338404},
	["spellspinningfireblossom"] = {spellID = 115073, itemID = 338404},
	["spelluplift"] = {spellID = 116670, itemID = 338404},
	["spellsummonjadeserpentstatue"] = {spellID = 115313, itemID = 338404},
	["spelltouchkarma"] = {spellID = 122470, itemID = 338404},
	["spelltouchdeath"] = {spellID = 115080, itemID = 338404},
	["spelltranscendance"] = {spellID = 480190, itemID = 338404},
	["spelltranscendanceback"] = {spellID = 480030, itemID = 338404},
	["spellhealingsphere"] = {spellID = 115460, itemID = 338404},
	["spellresuscitate"] = {spellID = 1215178, itemID = 338404},
	["spellparalysis"] = {spellID = 115078, itemID = 338404},
	["spellzenpilgrimage"] = {spellID = 126897, itemID = 338404},
	["spellfistsfury"] = {spellID = 119014, itemID = 338404},
	["spellenergizingelixir"] = {spellID = 115288, itemID = 338404},
	["spelltigerslust"] = {spellID = 116841, itemID = 338404},
	["spellinvokexuenwhitetiger"] = {spellID = 68888, itemID = 338404},
	["spelltigereyebrew"] = {spellID = 116740, itemID = 338404},
	["spellcombatconditioning"] = {spellID = 128595, itemID = 338404},
	["spellrevival"] = {spellID = 115310, itemID = 338404},
	["spellprovoke"] = {spellID = 1116189, itemID = 338404},
	["spellsummonblackoxstatue"] = {spellID = 115315, itemID = 338404},
	["spellevilprevention"] = {spellID = 115213, itemID = 338404},
	["spellbreathfire"] = {spellID = 115181, itemID = 338404},
	["spellparry"] = {spellID = 116812, itemID = 338404},
	["spellthunderfocustea"] = {spellID = 116680, itemID = 338404},
	["spellstealweapon"] = {spellID = 117368, itemID = 338404},
	["spellfermentationelusiveinfusion"] = {spellID = 128938, itemID = 338404},
	["spellironskinbrew"] = {spellID = 115308, itemID = 338404},
	["spellclash"] = {spellID = 122057, itemID = 338404},
	["spellmasterbrewertraining"] = {spellID = 117967, itemID = 338404},
	["spellmasteryelusivebrawler"] = {spellID = 117906, itemID = 338404},
	["spellswiftreflexes"] = {spellID = 124334, itemID = 338404},
	["spelldesperatemeasures"] = {spellID = 126060, itemID = 338404},
	["spellstandoff"] = {spellID = 116023, itemID = 338404},
	["spellmasterycombostrikes"] = {spellID = 115636, itemID = 338404},
	["spellmusclememory"] = {spellID = 139598, itemID = 338404},
	["spellinternalmedicine"] = {spellID = 115451, itemID = 338404},
	["spellmanameditation"] = {spellID = 121278, itemID = 338404},
	["spellmanatea"] = {spellID = 115294, itemID = 338404},
	["spellteachingsmonastery"] = {spellID = 116645, itemID = 338404},
	["spellmasterygiftserpent"] = {spellID = 117907, itemID = 338404},
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
                if #TalentMonkPointsSpend >= MAX_TALENTS then
                    player:SendAreaTriggerMessage("|cffff0000Vous avez atteint la limite de talents !|r")
                else
                    player:RemoveItem(itemID, 1)
                    player:SendAreaTriggerMessage("|cff00ff00Vous avez appris un nouveau talent !|r")
                    player:LearnSpell(spellID)
                    table.insert(TalentMonkPointsSpend, spellID)
                    AIO.Handle(player, "TalentMonkspell", "UpdateTalentCount", #TalentMonkPointsSpend, MAX_TALENTS)

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
    MonkHandlers[talentName] = function(player, item)
        LearnTalent(player, talentData)
    end
end

local function LoadTalentProgression(player)
    TalentMonkPointsSpend = {}

    local query = CharDBQuery("SELECT spell FROM character_talentspell WHERE guid = " .. player:GetGUIDLow() .. " AND active = 1;")
    if query then
        repeat
            local spellID = query:GetUInt32(0)
            table.insert(TalentMonkPointsSpend, spellID)
        until not query:NextRow()
    end

    AIO.Handle(player, "TalentMonkspell", "UpdateTalentCount", #TalentMonkPointsSpend, MAX_TALENTS)
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

MonkHandlers.ResetTalents = function(player)
    local pointsBeforeReset = #TalentMonkPointsSpend

    for talentName, talentData in pairs(talents) do
        local spellID = talentData.spellID
        player:RemoveSpell(spellID)
    end

    TalentMonkPointsSpend = {}
    ResetTalentProgression(player)
    AIO.Handle(player, "TalentMonkspell", "UpdateTalentCount", 0, MAX_TALENTS)

    local pointsAfterReset = 0
    AIO.Handle(player, "TalentMonkspell", "UpdateTalentPointsUsed", pointsAfterReset, pointsBeforeReset)

    local talentItemID = 338404
    local itemCount = pointsBeforeReset
    local addedItem = player:AddItem(talentItemID, itemCount)

    if addedItem then
    end
end

local function TalentMonkOnCommand(event, player, command)
    if (command == "talentMonk") then
        AIO.Handle(player, "TalentMonkspell", "ShowTalentMonk")
        return false
    end
end
RegisterPlayerEvent(42, TalentMonkOnCommand)