local AIO = AIO or require("AIO")
local WarlockHandlers = AIO.AddHandlers("TalentWarlockspell", {})
local TalentWarlockPointsSpend = {}

local MAX_TALENTS = 41

local talents = {

	
	["spellimprovedcurseofagony"] = {spellID = 18829, itemID = 338404},
	["spellsuppression"] = {spellID = 18176, itemID = 338404},
	["spellimprovedcorruption"] = {spellID = 17814, itemID = 338404},
	["spellimprovedcurseofweakness"] = {spellID = 18180, itemID = 338404},
	["spellimproveddrainsoul"] = {spellID = 18372, itemID = 338404},
	["spellimprovedlifetap"] = {spellID = 18183, itemID = 338404},
	["spellsoulsiphon"] = {spellID = 17805, itemID = 338404},
	["spellimprovedfear"] = {spellID = 53759, itemID = 338404},
	["spelllfelconcentration"] = {spellID = 17785, itemID = 338404},
	["spellamplifycurse"] = {spellID = 18288, itemID = 338404},
	["spellgrimreach"] = {spellID = 18219, itemID = 338404},
	["spellnightfall"] = {spellID = 18095, itemID = 338404},
	["spellempoweredcorruption"] = {spellID = 32383, itemID = 338404},
	["spellshadowembrace"] = {spellID = 32394, itemID = 338404},
	["spellsiphonlife"] = {spellID = 63108, itemID = 338404},
	["spellcurseofexhaustion"] = {spellID = 18223, itemID = 338404},
	["spellimprovedfelhunter"] = {spellID = 54038, itemID = 338404},
	["spellshadowmastery"] = {spellID = 18275, itemID = 338404},
	["spelleradication"] = {spellID = 47197, itemID = 338404},
	["spellcontagion"] = {spellID = 30064, itemID = 338404},
	["spelldarkpact"] = {spellID = 18220, itemID = 338404},
	["spellimprovedhowlofterror"] = {spellID = 30057, itemID = 338404},
	["spellmalediction"] = {spellID = 32484, itemID = 338404},
	["spelldeathsembrace"] = {spellID = 47200, itemID = 338404},
	["spellunstableaffliction"] = {spellID = 30108, itemID = 338404},
	["spellpandemic"] = {spellID = 58435, itemID = 338404},
	["spelleverlastingaffliction"] = {spellID = 47205, itemID = 338404},
	["spellhaunt"] = {spellID = 48181, itemID = 338404},
	
	
	["spellimprovedhealthstone"] = {spellID = 18693, itemID = 338404},
	["spellimprovedimp"] = {spellID = 18696, itemID = 338404},
	["spelldemonicembrace"] = {spellID = 18699, itemID = 338404},
	["spellfelsynergy"] = {spellID = 47231, itemID = 338404},
	["spellimprovedhealthfunnel"] = {spellID = 18704, itemID = 338404},
	["spelldemonicbrutality"] = {spellID = 18707, itemID = 338404},
	["spellfelvitality"] = {spellID = 18744, itemID = 338404},
	["spellimprovedsayaad"] = {spellID = 18756, itemID = 338404},
	["spellsoullink"] = {spellID = 19028, itemID = 338404},
	["spellfeldomination"] = {spellID = 18708, itemID = 338404},
	["spelldemonicaegis"] = {spellID = 30145, itemID = 338404},
	["spellunholypower"] = {spellID = 18773, itemID = 338404},
	["spellmastersummoner"] = {spellID = 18710, itemID = 338404},
	
	
	["spellmanafeed"] = {spellID = 30326, itemID = 338404},
	["spellmasterconjuror"] = {spellID = 18768, itemID = 338404},
	["spellmasterdemonologist"] = {spellID = 23825, itemID = 338404},
	["spellmoltencore"] = {spellID = 47247, itemID = 338404},
	["spelldemonicresilience"] = {spellID = 30321, itemID = 338404},
	["spelldemonicempowerment"] = {spellID = 47193, itemID = 338404},
	["spelldemonicknowledge"] = {spellID = 35693, itemID = 338404},
	["spelldemonictactics"] = {spellID = 30248, itemID = 338404},
	["spelldecimation"] = {spellID = 63158, itemID = 338404},
	["spellimproveddemonictactics"] = {spellID = 54349, itemID = 338404},
	["spellsummonfelguard"] = {spellID = 30146, itemID = 338404},
	["spellnemesis"] = {spellID = 63123, itemID = 338404},
	["spelldemonicpact"] = {spellID = 47240, itemID = 338404},
	["spellmetamorphosis"] = {spellID = 59672, itemID = 338404},
	
	
	["spellimprovedshadowbolt"] = {spellID = 17803, itemID = 338404},
	["spellbane"] = {spellID = 17792, itemID = 338404},
	["spellaftermath"] = {spellID = 18120, itemID = 338404},
	["spellmoltenskin"] = {spellID = 63351, itemID = 338404},
	["spellcataclysm"] = {spellID = 17780, itemID = 338404},
	["spelldemonicpower"] = {spellID = 18127, itemID = 338404},
	["spellshadowburn"] = {spellID = 17877, itemID = 338404},
	["spellruin"] = {spellID = 59741, itemID = 338404},
	["spellintensity"] = {spellID = 18136, itemID = 338404},
	["spelldestructivereach"] = {spellID = 17918, itemID = 338404},
	["spellimprovedsearingpain"] = {spellID = 17930, itemID = 338404},
	["spellbacklash"] = {spellID = 34939, itemID = 338404},
	["spellimprovedimmolate"] = {spellID = 17834, itemID = 338404},
	["spelldevastation"] = {spellID = 18130, itemID = 338404},
	["spellnetherprotection"] = {spellID = 30302, itemID = 338404},
	["spellemberstorm"] = {spellID = 17958, itemID = 338404},
	["spellconflagrate"] = {spellID = 17962, itemID = 338404},
	["spellsoulleech"] = {spellID = 30296, itemID = 338404},
	["spellpyroclasm"] = {spellID = 63245, itemID = 338404},
	["spellshadowandflame"] = {spellID = 30292, itemID = 338404},
	["spellimprovedsoulleech"] = {spellID = 54118, itemID = 338404},
	["spellbackdraft"] = {spellID = 47260, itemID = 338404},
	["spellshadowfury"] = {spellID = 30283, itemID = 338404},
	["spellempoweredimp"] = {spellID = 47223, itemID = 338404},
	["spellfireandbrimstone"] = {spellID = 47270, itemID = 338404},
	["spellchaosbolt"] = {spellID = 50796, itemID = 338404},
	
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
                if #TalentWarlockPointsSpend >= MAX_TALENTS then
                    player:SendAreaTriggerMessage("|cffff0000Vous avez atteint la limite de talents !|r")
                else
                    player:RemoveItem(itemID, 1)
                    player:SendAreaTriggerMessage("|cff00ff00Vous avez appris un nouveau talent !|r")
                    player:LearnSpell(spellID)
                    table.insert(TalentWarlockPointsSpend, spellID)
                    AIO.Handle(player, "TalentWarlockspell", "UpdateTalentCount", #TalentWarlockPointsSpend, MAX_TALENTS)

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
    WarlockHandlers[talentName] = function(player, item)
        LearnTalent(player, talentData)
    end
end

local function LoadTalentProgression(player)
    TalentWarlockPointsSpend = {}

    local query = CharDBQuery("SELECT spell FROM character_talentspell WHERE guid = " .. player:GetGUIDLow() .. " AND active = 1;")
    if query then
        repeat
            local spellID = query:GetUInt32(0)
            table.insert(TalentWarlockPointsSpend, spellID)
        until not query:NextRow()
    end

    AIO.Handle(player, "TalentWarlockspell", "UpdateTalentCount", #TalentWarlockPointsSpend, MAX_TALENTS)
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

WarlockHandlers.ResetTalents = function(player)
    local pointsBeforeReset = #TalentWarlockPointsSpend

    for talentName, talentData in pairs(talents) do
        local spellID = talentData.spellID
        player:RemoveSpell(spellID)
    end

    TalentWarlockPointsSpend = {}
    ResetTalentProgression(player)
    AIO.Handle(player, "TalentWarlockspell", "UpdateTalentCount", 0, MAX_TALENTS)

    local pointsAfterReset = 0
    AIO.Handle(player, "TalentWarlockspell", "UpdateTalentPointsUsed", pointsAfterReset, pointsBeforeReset)

    local talentItemID = 338404
    local itemCount = pointsBeforeReset
    local addedItem = player:AddItem(talentItemID, itemCount)

    if addedItem then
    end
end

local function TalentWarlockOnCommand(event, player, command)
    if (command == "talentWarlock") then
        AIO.Handle(player, "TalentWarlockspell", "ShowTalentWarlock")
        return false
    end
end
RegisterPlayerEvent(42, TalentWarlockOnCommand)