local AIO = AIO or require("AIO")
local DruidHandlers = AIO.AddHandlers("TalentDruidspell", {})
local TalentDruidPointsSpend = {}

local MAX_TALENTS = 44

local talents = {

	
	["spellstarlightwrath"] = {spellID = 16818, itemID = 338404},
	["spellgenesis"] = {spellID = 57814, itemID = 338404},
	["spellmoonglow"] = {spellID = 16847, itemID = 338404},
	["spellnaturesmajesty"] = {spellID = 35364, itemID = 338404},
	["spellimprovedmoonfire"] = {spellID = 16822, itemID = 338404},
	["spellbrambles"] = {spellID = 16840, itemID = 338404},
	["spellnaturesgrace"] = {spellID = 61346, itemID = 338404},
	["spellnaturessplendor"] = {spellID = 57865, itemID = 338404},
	["spellnaturesreach"] = {spellID = 16820, itemID = 338404},
	["spellvengeance"] = {spellID = 16913, itemID = 338404},
	["spellcelestialfocus"] = {spellID = 16924, itemID = 338404},
	["spelllunarguidance"] = {spellID = 33591, itemID = 338404},
	["spellinsectswarm"] = {spellID = 5570, itemID = 338404},
	["spellimprovedinsectswarm"] = {spellID = 57851, itemID = 338404},
	["spelldreamstate"] = {spellID = 33956, itemID = 338404},
	["spellmoonfury"] = {spellID = 16899, itemID = 338404},
	["spellbalanceofpower"] = {spellID = 33596, itemID = 338404},
	["spellmoonkinform"] = {spellID = 24858, itemID = 338404},
	["spellimprovedmoonkinform"] = {spellID = 48396, itemID = 338404},
	["spellimprovedfaeriefire"] = {spellID = 33602, itemID = 338404},
	["spellowlkinfrenzy"] = {spellID = 48393, itemID = 338404},
	["spellwrathofcenarius"] = {spellID = 33607, itemID = 338404},
	["spelleclipse"] = {spellID = 48525, itemID = 338404},
	["spelltyphoon"] = {spellID = 50516, itemID = 338404},
	["spellforceofnature"] = {spellID = 33831, itemID = 338404},
	["spellgalewinds"] = {spellID = 48514, itemID = 338404},
	["spellearthandmoon"] = {spellID = 48511, itemID = 338404},
	["spellstarfall"] = {spellID = 48505, itemID = 338404},
	
	
	["spellferocity"] = {spellID = 16938, itemID = 338404},
	["spellferalaggression"] = {spellID = 16862, itemID = 338404},
	["spellferalinstinct"] = {spellID = 16949, itemID = 338404},
	["spellsavagefury"] = {spellID = 16999, itemID = 338404},
	["spellthickhide"] = {spellID = 16931, itemID = 338404},
	["spellferalswiftness"] = {spellID = 24866, itemID = 338404},
	["spellsurvivalinstincts"] = {spellID = 61336, itemID = 338404},
	["spellsharpenedclaws"] = {spellID = 16944, itemID = 338404},
	["spellshreddingattacks"] = {spellID = 16968, itemID = 338404},
	["spellpredatorystrikes"] = {spellID = 16975, itemID = 338404},
	["spellprimalfury"] = {spellID = 37117, itemID = 338404},
	["spellprimalprecision"] = {spellID = 48410, itemID = 338404},
	
	
	["spellimpactbrutal"] = {spellID = 16941, itemID = 338404},
	["spellferalcharge"] = {spellID = 49377, itemID = 338404},
	["spellnurturinginstinct"] = {spellID = 33873, itemID = 338404},
	["spellnaturalreaction"] = {spellID = 57881, itemID = 338404},
	["spellheartofthewild"] = {spellID = 24894, itemID = 338404},
	["spellsurvivalofthefittest"] = {spellID = 33856, itemID = 338404},
	["spellleaderofthepack"] = {spellID = 17007, itemID = 338404},
	["spellimprovedleaderofthepack"] = {spellID = 34300, itemID = 338404},
	["spelprimaltenacity"] = {spellID = 33957, itemID = 338404},
	["spellprotectorofthepack"] = {spellID = 57877, itemID = 338404},
	["spellmangle"] = {spellID = 33917, itemID = 338404},
	["spellimprovedmangle"] = {spellID = 48491, itemID = 338404},
	["spellrendandtear"] = {spellID = 51269, itemID = 338404},
	["spellprimalgore"] = {spellID = 63503, itemID = 338404},
	["spellberserk"] = {spellID = 50334, itemID = 338404},
	["spellpredatoryinstincts"] = {spellID = 33867, itemID = 338404},
	["spellinfectedwounds"] = {spellID = 48485, itemID = 338404},
	["spellkingofthejungle"] = {spellID = 48495, itemID = 338404},
	
	
	["spellimprovedmarkofthewild"] = {spellID = 17051, itemID = 338404},
	["spellnaturesfocus"] = {spellID = 17066, itemID = 338404},
	["spellfuror"] = {spellID = 17061, itemID = 338404},
	["spellnaturalist"] = {spellID = 17073, itemID = 338404},
	["spellsubtlety"] = {spellID = 17120, itemID = 338404},
	["spellnaturalshapeshifter"] = {spellID = 16835, itemID = 338404},
	["spellintensity"] = {spellID = 17108, itemID = 338404},
	["spellomenofclarity"] = {spellID = 16864, itemID = 338404},
	["spellmastershapeshifter"] = {spellID = 48412, itemID = 338404},
	["spelltranquilspirit"] = {spellID = 24972, itemID = 338404},
	["spellimprovedrejuvenation"] = {spellID = 17113, itemID = 338404},
	["spellnaturesswiftness"] = {spellID = 17116, itemID = 338404},
	["spellgiftofnature"] = {spellID = 24946, itemID = 338404},
	["spellimprovedtranquility"] = {spellID = 17124, itemID = 338404},
	["spellempoweredtouch"] = {spellID = 33880, itemID = 338404},
	["spellnaturesbounty"] = {spellID = 17078, itemID = 338404},
	["spelllivingspirit"] = {spellID = 34153, itemID = 338404},
	["spellswiftmend"] = {spellID = 18562, itemID = 338404},
	["spellnaturalperfection"] = {spellID = 33883, itemID = 338404},
	["spellempoweredrejuvenation"] = {spellID = 33890, itemID = 338404},
	["spelllivingseed"] = {spellID = 48500, itemID = 338404},
	["spellrevitalize"] = {spellID = 48545, itemID = 338404},
	["spelltreeoflife"] = {spellID = 65139, itemID = 338404},
	["spellimprovedtreeoflife"] = {spellID = 48537, itemID = 338404},
	["spellimprovedbarkskin"] = {spellID = 63411, itemID = 338404},
	["spellgiftoftheearthmother"] = {spellID = 51183, itemID = 338404},
	["spellwildgrowth"] = {spellID = 48438, itemID = 338404},
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
                if #TalentDruidPointsSpend >= MAX_TALENTS then
                    player:SendAreaTriggerMessage("|cffff0000Vous avez atteint la limite de talents !|r")
                else
                    player:RemoveItem(itemID, 1)
                    player:SendAreaTriggerMessage("|cff00ff00Vous avez appris un nouveau talent !|r")
                    player:LearnSpell(spellID)
                    table.insert(TalentDruidPointsSpend, spellID)
                    AIO.Handle(player, "TalentDruidspell", "UpdateTalentCount", #TalentDruidPointsSpend, MAX_TALENTS)

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
    DruidHandlers[talentName] = function(player, item)
        LearnTalent(player, talentData)
    end
end

local function LoadTalentProgression(player)
    TalentDruidPointsSpend = {}

    local query = CharDBQuery("SELECT spell FROM character_talentspell WHERE guid = " .. player:GetGUIDLow() .. " AND active = 1;")
    if query then
        repeat
            local spellID = query:GetUInt32(0)
            table.insert(TalentDruidPointsSpend, spellID)
        until not query:NextRow()
    end

    AIO.Handle(player, "TalentDruidspell", "UpdateTalentCount", #TalentDruidPointsSpend, MAX_TALENTS)
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

DruidHandlers.ResetTalents = function(player)
    local pointsBeforeReset = #TalentDruidPointsSpend

    for talentName, talentData in pairs(talents) do
        local spellID = talentData.spellID
        player:RemoveSpell(spellID)
    end

    TalentDruidPointsSpend = {}
    ResetTalentProgression(player)
    AIO.Handle(player, "TalentDruidspell", "UpdateTalentCount", 0, MAX_TALENTS)

    local pointsAfterReset = 0
    AIO.Handle(player, "TalentDruidspell", "UpdateTalentPointsUsed", pointsAfterReset, pointsBeforeReset)

    local talentItemID = 338404
    local itemCount = pointsBeforeReset
    local addedItem = player:AddItem(talentItemID, itemCount)

    if addedItem then
    end
end

local function TalentDruidOnCommand(event, player, command)
    if (command == "talentDruid") then
        AIO.Handle(player, "TalentDruidspell", "ShowTalentDruid")
        return false
    end
end
RegisterPlayerEvent(42, TalentDruidOnCommand)