local AIO = AIO or require("AIO")
local HunterHandlers = AIO.AddHandlers("TalentHunterspell", {})
local TalentHunterPointsSpend = {}

local MAX_TALENTS = 41

local talents = {

	
	["spellimprovedaspectofthehawk"] = {spellID = 19556, itemID = 338404},
	["spellendurancetraining"] = {spellID = 19587, itemID = 338404},
	["spellfocusedfire"] = {spellID = 35030, itemID = 338404},
	["spellimprovedaspectofthemonkey"] = {spellID = 19551, itemID = 338404},
	["spellthickhide"] = {spellID = 19612, itemID = 338404},
	["spellimprovedrevivepet"] = {spellID = 19575, itemID = 338404},
	["spellpathfinding"] = {spellID = 19560, itemID = 338404},
	["spellaspectmastery"] = {spellID = 53265, itemID = 338404},
	["spellunleashedfury"] = {spellID = 19620, itemID = 338404},
	["spellimprovedmendpet"] = {spellID = 19573, itemID = 338404},
	["spellferocity"] = {spellID = 19602, itemID = 338404},
	["spellspiritbond"] = {spellID = 20895, itemID = 338404},
	["spellintimidation"] = {spellID = 19577, itemID = 338404},
	["spellbestialdiscipline"] = {spellID = 19592, itemID = 338404},
	["spellanimalhandler"] = {spellID = 34454, itemID = 338404},
	["spellfrenzy"] = {spellID = 19625, itemID = 338404},
	["spellferociousinspiration"] = {spellID = 34460, itemID = 338404},
	["spellbestialwrath"] = {spellID = 19574, itemID = 338404},
	["spellcatlikereflexes"] = {spellID = 34465, itemID = 338404},
	["spellinvigoration"] = {spellID = 53253, itemID = 338404},
	["spellserpensswiftness"] = {spellID = 34470, itemID = 338404},
	["spelllongevity"] = {spellID = 53264, itemID = 338404},
	["spellthebeastwithin"] = {spellID = 34692, itemID = 338404},
	["spellcobrastrikes"] = {spellID = 53260, itemID = 338404},
	["spellkindredspirits"] = {spellID = 56318, itemID = 338404},
	["spellbeastmastery"] = {spellID = 53270, itemID = 338404},
	["spellimprovedconcussiveshot"] = {spellID = 19412, itemID = 338404},
	["spellfocusedaim"] = {spellID = 53622, itemID = 338404},
	
	
	["spelllethalshots"] = {spellID = 19431, itemID = 338404},
	["spellcarefulaim"] = {spellID = 34484, itemID = 338404},
	["spellimprovedhuntersmark"] = {spellID = 19423, itemID = 338404},
	["spellmortalshots"] = {spellID = 19490, itemID = 338404},
	["spellgoforthethroat"] = {spellID = 34954, itemID = 338404},
	["spellimprovedarcaneshot"] = {spellID = 19456, itemID = 338404},
	["spellaimedshot"] = {spellID = 19434, itemID = 338404},
	["spellrapidkilling"] = {spellID = 34949, itemID = 338404},
	["spellimprovedstings"] = {spellID = 19466, itemID = 338404},
	["spellefficiency"] = {spellID = 19420, itemID = 338404},
	["spellconcussivebarrage"] = {spellID = 35102, itemID = 338404},
	["spellreadiness"] = {spellID = 23989, itemID = 338404},
	["spellbarrage"] = {spellID = 24691, itemID = 338404},
	
	
	["spellcombatexperience"] = {spellID = 34476, itemID = 338404},
	["spellrangedweaponspecialization"] = {spellID = 19509, itemID = 338404},
	["spellpiercingshots"] = {spellID = 53238, itemID = 338404},
	["spelltrueshotaura"] = {spellID = 19506, itemID = 338404},
	["spellimprovedbarrage"] = {spellID = 35111, itemID = 338404},
	["spellmastermarksman"] = {spellID = 34489, itemID = 338404},
	["spellrapidrecuperation"] = {spellID = 53232, itemID = 338404},
	["spellwildquiver"] = {spellID = 53217, itemID = 338404},
	["spellsilencingshot"] = {spellID = 34490, itemID = 338404},
	["spellimprovedsteadyshot"] = {spellID = 53224, itemID = 338404},
	["spellmarkedfordeath"] = {spellID = 53246, itemID = 338404},
	["spellchimerashot"] = {spellID = 53209, itemID = 338404},
	["spellimprovedtracking"] = {spellID = 52788, itemID = 338404},
	["spellhawkeye"] = {spellID = 19500, itemID = 338404},
	
	
	["spellsavagestrikes"] = {spellID = 19160, itemID = 338404},
	["spellsurefooted"] = {spellID = 24283, itemID = 338404},
	["spellentrapment"] = {spellID = 19388, itemID = 338404},
	["spelltrapmastery"] = {spellID = 63468, itemID = 338404},
	["spellsurvivalinstincts"] = {spellID = 34496, itemID = 338404},
	["spellsurvivalist"] = {spellID = 19259, itemID = 338404},
	["spellscattershot"] = {spellID = 19503, itemID = 338404},
	["spelldeflection"] = {spellID = 19298, itemID = 338404},
	["spellsurvivaltactics"] = {spellID = 19287, itemID = 338404},
	["spelltnt"] = {spellID = 56337, itemID = 338404},
	["spelllockandload"] = {spellID = 56344, itemID = 338404},
	["spellhuntervswild"] = {spellID = 56341, itemID = 338404},
	["spellkillerinstinct"] = {spellID = 19373, itemID = 338404},
	["spellcounterattack"] = {spellID = 19306, itemID = 338404},
	["spelllightningreflexes"] = {spellID = 24297, itemID = 338404},
	["spellresourcefulness"] = {spellID = 34493, itemID = 338404},
	["spellexposeweakness"] = {spellID = 34503, itemID = 338404},
	["spellwyvernsting"] = {spellID = 19386, itemID = 338404},
	["spellthrillofthehunt"] = {spellID = 34499, itemID = 338404},
	["spellmastertactician"] = {spellID = 34839, itemID = 338404},
	["spellnoxiousstings"] = {spellID = 53297, itemID = 338404},
	["spellpointofnoescape"] = {spellID = 53299, itemID = 338404},
	["spellblackarrow"] = {spellID = 3674, itemID = 338404},
	["spellsnipertraining"] = {spellID = 53304, itemID = 338404},
	["spellhuntingparty"] = {spellID = 53292, itemID = 338404},
	["spellexplosiveshot"] = {spellID = 53301, itemID = 338404},
	
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
                if #TalentHunterPointsSpend >= MAX_TALENTS then
                    player:SendAreaTriggerMessage("|cffff0000Vous avez atteint la limite de talents !|r")
                else
                    player:RemoveItem(itemID, 1)
                    player:SendAreaTriggerMessage("|cff00ff00Vous avez appris un nouveau talent !|r")
                    player:LearnSpell(spellID)
                    table.insert(TalentHunterPointsSpend, spellID)
                    AIO.Handle(player, "TalentHunterspell", "UpdateTalentCount", #TalentHunterPointsSpend, MAX_TALENTS)

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
    HunterHandlers[talentName] = function(player, item)
        LearnTalent(player, talentData)
    end
end

local function LoadTalentProgression(player)
    TalentHunterPointsSpend = {}

    local query = CharDBQuery("SELECT spell FROM character_talentspell WHERE guid = " .. player:GetGUIDLow() .. " AND active = 1;")
    if query then
        repeat
            local spellID = query:GetUInt32(0)
            table.insert(TalentHunterPointsSpend, spellID)
        until not query:NextRow()
    end

    AIO.Handle(player, "TalentHunterspell", "UpdateTalentCount", #TalentHunterPointsSpend, MAX_TALENTS)
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

HunterHandlers.ResetTalents = function(player)
    local pointsBeforeReset = #TalentHunterPointsSpend

    for talentName, talentData in pairs(talents) do
        local spellID = talentData.spellID
        player:RemoveSpell(spellID)
    end

    TalentHunterPointsSpend = {}
    ResetTalentProgression(player)
    AIO.Handle(player, "TalentHunterspell", "UpdateTalentCount", 0, MAX_TALENTS)

    local pointsAfterReset = 0
    AIO.Handle(player, "TalentHunterspell", "UpdateTalentPointsUsed", pointsAfterReset, pointsBeforeReset)

    local talentItemID = 338404
    local itemCount = pointsBeforeReset
    local addedItem = player:AddItem(talentItemID, itemCount)

    if addedItem then
    end
end

local function TalentHunterOnCommand(event, player, command)
    if (command == "talentHunter") then
        AIO.Handle(player, "TalentHunterspell", "ShowTalentHunter")
        return false
    end
end
RegisterPlayerEvent(42, TalentHunterOnCommand)