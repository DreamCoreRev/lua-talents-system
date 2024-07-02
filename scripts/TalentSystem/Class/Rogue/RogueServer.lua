local AIO = AIO or require("AIO")
local RogueHandlers = AIO.AddHandlers("TalentRoguespell", {})
local TalentRoguePointsSpend = {}

local MAX_TALENTS = 42

local talents = {

	
	["spellimprovedeviscerate"] = {spellID = 14164, itemID = 338404},
	["spellremorselessattacks"] = {spellID = 14148, itemID = 338404},
	["spellmalice"] = {spellID = 14142, itemID = 338404},
	["spellruthlessness"] = {spellID = 14161, itemID = 338404},
	["spellbloodspatter"] = {spellID = 51633, itemID = 338404},
	["spellpuncturingwounds"] = {spellID = 13866, itemID = 338404},
	["spellvigor"] = {spellID = 14983, itemID = 338404},
	["spellimprovedexposearmor"] = {spellID = 14169, itemID = 338404},
	["spelllethality"] = {spellID = 14137, itemID = 338404},
	["spellvilepoisons"] = {spellID = 16515, itemID = 338404},
	["spellimprovedpoisons"] = {spellID = 14117, itemID = 338404},
	["spellfleetfooted"] = {spellID = 31209, itemID = 338404},
	["spellcoldblood"] = {spellID = 14177, itemID = 338404},
	["spellimprovedkidneyshot"] = {spellID = 14176, itemID = 338404},
	["spellquickrecovery"] = {spellID = 31245, itemID = 338404},
	["spellsealfate"] = {spellID = 14195, itemID = 338404},
	["spellmurder"] = {spellID = 14159, itemID = 338404},
	["spelldeadlybrew"] = {spellID = 51626, itemID = 338404},
	["spelloverkill"] = {spellID = 58426, itemID = 338404},
	["spelldeadenednerves"] = {spellID = 31383, itemID = 338404},
	["spellfocusedattacks"] = {spellID = 51636, itemID = 338404},
	["spellfindweakness"] = {spellID = 31236, itemID = 338404},
	["spellmasterpoisoner"] = {spellID = 58410, itemID = 338404},
	["spellmutilate"] = {spellID = 1329, itemID = 338404},
	["spellturnthetables"] = {spellID = 51629, itemID = 338404},
	["spellcuttothechase"] = {spellID = 51669, itemID = 338404},
	["spellhungerforblood"] = {spellID = 51662, itemID = 338404},
	
	
	["spellimprovedgouge"] = {spellID = 13792, itemID = 338404},
	["spellimprovedsinisterstrike"] = {spellID = 13863, itemID = 338404},
	["spelldualwieldspecialization"] = {spellID = 13852, itemID = 338404},
	["spelldualcrimsonvial"] = {spellID = 248777, itemID = 338404},
	["spellimprovedsliceanddice"] = {spellID = 14166, itemID = 338404},
	["spelldeflection"] = {spellID = 13854, itemID = 338404},
	["spellprecision"] = {spellID = 13845, itemID = 338404},
	["spellendurance"] = {spellID = 13872, itemID = 338404},
	["spellriposte"] = {spellID = 14251, itemID = 338404},
	["spellclosequarterscombat"] = {spellID = 13807, itemID = 338404},
	["spellimprovedkick"] = {spellID = 13867, itemID = 338404},
	["spellimprovedsprint"] = {spellID = 13875, itemID = 338404},
	["spelllightningreflexes"] = {spellID = 13789, itemID = 338404},
	["spellaggression"] = {spellID = 61331, itemID = 338404},
	["spellmacespecialization"] = {spellID = 13803, itemID = 338404},
	["spellbladeflurry"] = {spellID = 13877, itemID = 338404},
	["spellhackandslash"] = {spellID = 13964, itemID = 338404},
	
	
	["spellweaponexpertise"] = {spellID = 30920, itemID = 338404},
	["spellbladetwisting"] = {spellID = 31126, itemID = 338404},
	["spellvitality"] = {spellID = 61329, itemID = 338404},
	["spelladrenalinerush"] = {spellID = 13750, itemID = 338404},
	["spellnervesofsteel"] = {spellID = 31131, itemID = 338404},
	["spellthrowingspecialization"] = {spellID = 51679, itemID = 338404},
	["spellcombatpotency"] = {spellID = 35553, itemID = 338404},
	["spellunfairadvantage"] = {spellID = 51674, itemID = 338404},
	["spellsurpriseattacks"] = {spellID = 32601, itemID = 338404},
	["spellsavagecombat"] = {spellID = 58413, itemID = 338404},
	["spellpreyontheweak"] = {spellID = 51689, itemID = 338404},
	["spellkillingspree"] = {spellID = 51690, itemID = 338404},
	
	
	["spellrelentlessstrikes"] = {spellID = 58425, itemID = 338404},
	["spellmasterofdeception"] = {spellID = 13971, itemID = 338404},
	["spellopportunity"] = {spellID = 14072, itemID = 338404},
	["spellsleightofhand"] = {spellID = 30893, itemID = 338404},
	["spelldirtytricks"] = {spellID = 14094, itemID = 338404},
	["spellcamouflage"] = {spellID = 14063, itemID = 338404},
	["spellelusiveness"] = {spellID = 14066, itemID = 338404},
	["spellghostlystrike"] = {spellID = 14278, itemID = 338404},
	["spellserratedblades"] = {spellID = 14173, itemID = 338404},
	["spellsetup"] = {spellID = 14071, itemID = 338404},
	["spellinitiative"] = {spellID = 13980, itemID = 338404},
	["spellimprovedambush"] = {spellID = 14080, itemID = 338404},
	["spellheightenedsenses"] = {spellID = 30895, itemID = 338404},
	["spellpreparation"] = {spellID = 14185, itemID = 338404},
	["spelldirtydeeds"] = {spellID = 14083, itemID = 338404},
	["spellhemorrhage"] = {spellID = 16511, itemID = 338404},
	["spellmasterofsubtlety"] = {spellID = 31223, itemID = 338404},
	["spelldeadliness"] = {spellID = 30906, itemID = 338404},
	["spellenvelopingshadows"] = {spellID = 31213, itemID = 338404},
	["spellpremeditation"] = {spellID = 14183, itemID = 338404},
	["spellcheatdeath"] = {spellID = 31230, itemID = 338404},
	["spellsinistercalling"] = {spellID = 31220, itemID = 338404},
	["spellwaylay"] = {spellID = 51696, itemID = 338404},
	["spellhonoramongthieves"] = {spellID = 51701, itemID = 338404},
	["spellshadowstep"] = {spellID = 36554, itemID = 338404},
	["spellfilthytricks"] = {spellID = 58415, itemID = 338404},
	["spellslaughterfromtheshadows"] = {spellID = 51712, itemID = 338404},
	["spellshadowdance"] = {spellID = 51713, itemID = 338404},
	
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
                if #TalentRoguePointsSpend >= MAX_TALENTS then
                    player:SendAreaTriggerMessage("|cffff0000Vous avez atteint la limite de talents !|r")
                else
                    player:RemoveItem(itemID, 1)
                    player:SendAreaTriggerMessage("|cff00ff00Vous avez appris un nouveau talent !|r")
                    player:LearnSpell(spellID)
                    table.insert(TalentRoguePointsSpend, spellID)
                    AIO.Handle(player, "TalentRoguespell", "UpdateTalentCount", #TalentRoguePointsSpend, MAX_TALENTS)

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
    RogueHandlers[talentName] = function(player, item)
        LearnTalent(player, talentData)
    end
end

local function LoadTalentProgression(player)
    TalentRoguePointsSpend = {}

    local query = CharDBQuery("SELECT spell FROM character_talentspell WHERE guid = " .. player:GetGUIDLow() .. " AND active = 1;")
    if query then
        repeat
            local spellID = query:GetUInt32(0)
            table.insert(TalentRoguePointsSpend, spellID)
        until not query:NextRow()
    end

    AIO.Handle(player, "TalentRoguespell", "UpdateTalentCount", #TalentRoguePointsSpend, MAX_TALENTS)
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

RogueHandlers.ResetTalents = function(player)
    local pointsBeforeReset = #TalentRoguePointsSpend

    for talentName, talentData in pairs(talents) do
        local spellID = talentData.spellID
        player:RemoveSpell(spellID)
    end

    TalentRoguePointsSpend = {}
    ResetTalentProgression(player)
    AIO.Handle(player, "TalentRoguespell", "UpdateTalentCount", 0, MAX_TALENTS)

    local pointsAfterReset = 0
    AIO.Handle(player, "TalentRoguespell", "UpdateTalentPointsUsed", pointsAfterReset, pointsBeforeReset)

    local talentItemID = 338404
    local itemCount = pointsBeforeReset
    local addedItem = player:AddItem(talentItemID, itemCount)

    if addedItem then
    end
end

local function TalentRogueOnCommand(event, player, command)
    if (command == "talentRogue") then
        AIO.Handle(player, "TalentRoguespell", "ShowTalentRogue")
        return false
    end
end
RegisterPlayerEvent(42, TalentRogueOnCommand)