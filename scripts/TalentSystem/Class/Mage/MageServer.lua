local AIO = AIO or require("AIO")
local MageHandlers = AIO.AddHandlers("TalentMagespell", {})
local TalentMagePointsSpend = {}

local MAX_TALENTS = 43

local talents = {

	
	["spellarcanesubtlety"] = {spellID = 12592, itemID = 338404},
	["spellarcanefocus"] = {spellID = 12840, itemID = 338404},
	["spellarcanestability"] = {spellID = 16770, itemID = 338404},
	["spellarcanefortitude"] = {spellID = 54659, itemID = 338404},
	["spellmagicabsorption"] = {spellID = 29444, itemID = 338404},
	["spellarcaneconcentration"] = {spellID = 12577, itemID = 338404},
	["spellmagicattunement"] = {spellID = 12606, itemID = 338404},
	["spellspellimpact"] = {spellID = 12469, itemID = 338404},
	["spellstudentofthemind"] = {spellID = 44399, itemID = 338404},
	["spellfocusmagic"] = {spellID = 54646, itemID = 338404},
	["spellarcaneshielding"] = {spellID = 12605, itemID = 338404},
	["spellimprovedcounterspell"] = {spellID = 12598, itemID = 338404},
	["spellarcanemeditation"] = {spellID = 18464, itemID = 338404},
	["spelltormentheweak"] = {spellID = 55340, itemID = 338404},
	["spellimprovedblink"] = {spellID = 31570, itemID = 338404},
	["spellpresenceofmind"] = {spellID = 12043, itemID = 338404},
	["spellarcanemind"] = {spellID = 12503, itemID = 338404},
	["spellprismaticcloak"] = {spellID = 54354, itemID = 338404},
	["spellarcaneinstability"] = {spellID = 15060, itemID = 338404},
	["spellarcanepotency"] = {spellID = 31572, itemID = 338404},
	["spellarcaneempowerment"] = {spellID = 31583, itemID = 338404},
	["spellarcanepower"] = {spellID = 12042, itemID = 338404},
	["spellincantersabsorption"] = {spellID = 44396, itemID = 338404},
	["spellarcaneflows"] = {spellID = 44379, itemID = 338404},
	["spellmindmastery"] = {spellID = 31588, itemID = 338404},
	["spellslow"] = {spellID = 31589, itemID = 338404},
	["spellmissilebarrage"] = {spellID = 54490, itemID = 338404},
	
	
	["spellnetherwindpresence"] = {spellID = 44403, itemID = 338404},
	["spellspellpower"] = {spellID = 35581, itemID = 338404},
	["spellarcanebarrage"] = {spellID = 44425, itemID = 338404},
	["spellimprovedfireblast"] = {spellID = 11080, itemID = 338404},
	["spellincineration"] = {spellID = 54734, itemID = 338404},
	["spellimprovedfireball"] = {spellID = 12341, itemID = 338404},
	["spellignite"] = {spellID = 12848, itemID = 338404},
	["spellburningdetermination"] = {spellID = 54749, itemID = 338404},
	["spellworlinflames"] = {spellID = 12350, itemID = 338404},
	["spellflamethrowing"] = {spellID = 12353, itemID = 338404},
	["spellimpact"] = {spellID = 12358, itemID = 338404},
	["spellpyroblast"] = {spellID = 11366, itemID = 338404},
	["spellburningsoul"] = {spellID = 12351, itemID = 338404},
	
	
	["spellimprovedscorch"] = {spellID = 12873, itemID = 338404},
	["spellmoltenshields"] = {spellID = 13043, itemID = 338404},
	["spellmasterofelements"] = {spellID = 29076, itemID = 338404},
	["spellplayingwithfire"] = {spellID = 31640, itemID = 338404},
	["spellcriticalmass"] = {spellID = 11368, itemID = 338404},
	["spellblastwave"] = {spellID = 11113, itemID = 338404},
	["spellblazingspeed"] = {spellID = 31642, itemID = 338404},
	["spellfirepower"] = {spellID = 12400, itemID = 338404},
	["spellyromaniac"] = {spellID = 34296, itemID = 338404},
	["spellcombustion"] = {spellID = 11129, itemID = 338404},
	["spellmoltenfury"] = {spellID = 31680, itemID = 338404},
	["spellfierypayback"] = {spellID = 64357, itemID = 338404},
	["spellempoweredfire"] = {spellID = 31658, itemID = 338404},
	["spellfirestarter"] = {spellID = 44443, itemID = 338404},
	
	
	["spelldragonsbreath"] = {spellID = 31661, itemID = 338404},
	["spellhotstreak"] = {spellID = 44448, itemID = 338404},
	["spellburnout"] = {spellID = 44472, itemID = 338404},
	["spelllivingbomb"] = {spellID = 44457, itemID = 338404},
	["spellfrostbite"] = {spellID = 12497, itemID = 338404},
	["spellimprovedfrostbolt"] = {spellID = 16766, itemID = 338404},
	["spellicefloes"] = {spellID = 55094, itemID = 338404},
	["spelliceshards"] = {spellID = 15047, itemID = 338404},
	["spellfrostwarding"] = {spellID = 28332, itemID = 338404},
	["spellprecision"] = {spellID = 29440, itemID = 338404},
	["spellpermafrost"] = {spellID = 12571, itemID = 338404},
	["spellpiercingice"] = {spellID = 12953, itemID = 338404},
	["spellicyveins"] = {spellID = 12472, itemID = 338404},
	["spellimprovedblizzard"] = {spellID = 12488, itemID = 338404},
	["spellarcticreach"] = {spellID = 16758, itemID = 338404},
	["spellfrostchanneling"] = {spellID = 12519, itemID = 338404},
	["spellshatter"] = {spellID = 12983, itemID = 338404},
	["spellcoldsnap"] = {spellID = 11958, itemID = 338404},
	["spellimprovedconeofcold"] = {spellID = 12490, itemID = 338404},
	["spellfrozencore"] = {spellID = 31669, itemID = 338404},
	["spellcoldasice"] = {spellID = 55092, itemID = 338404},
	["spellwinterschill"] = {spellID = 28593, itemID = 338404},
	["spellshatteredbarrier"] = {spellID = 54787, itemID = 338404},
	["spellicebarrier"] = {spellID = 11426, itemID = 338404},
	["spellarcticwinds"] = {spellID = 31678, itemID = 338404},
	["spellempoweredfrostboltt"] = {spellID = 31683, itemID = 338404},
	["spellfingersoffrost"] = {spellID = 44545, itemID = 338404},
	["spellbrainfreeze"] = {spellID = 44549, itemID = 338404},
	["spellsummonwaterelemental"] = {spellID = 31687, itemID = 338404},
	["spellenduringwinter"] = {spellID = 44561, itemID = 338404},
	["spellchilledtothebone"] = {spellID = 44571, itemID = 338404},
	["spelldeepfreeze"] = {spellID = 44572, itemID = 338404},
	
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
                if #TalentMagePointsSpend >= MAX_TALENTS then
                    player:SendAreaTriggerMessage("|cffff0000Vous avez atteint la limite de talents !|r")
                else
                    player:RemoveItem(itemID, 1)
                    player:SendAreaTriggerMessage("|cff00ff00Vous avez appris un nouveau talent !|r")
                    player:LearnSpell(spellID)
                    table.insert(TalentMagePointsSpend, spellID)
                    AIO.Handle(player, "TalentMagespell", "UpdateTalentCount", #TalentMagePointsSpend, MAX_TALENTS)

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
    MageHandlers[talentName] = function(player, item)
        LearnTalent(player, talentData)
    end
end

local function LoadTalentProgression(player)
    TalentMagePointsSpend = {}

    local query = CharDBQuery("SELECT spell FROM character_talentspell WHERE guid = " .. player:GetGUIDLow() .. " AND active = 1;")
    if query then
        repeat
            local spellID = query:GetUInt32(0)
            table.insert(TalentMagePointsSpend, spellID)
        until not query:NextRow()
    end

    AIO.Handle(player, "TalentMagespell", "UpdateTalentCount", #TalentMagePointsSpend, MAX_TALENTS)
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

MageHandlers.ResetTalents = function(player)
    local pointsBeforeReset = #TalentMagePointsSpend

    for talentName, talentData in pairs(talents) do
        local spellID = talentData.spellID
        player:RemoveSpell(spellID)
    end

    TalentMagePointsSpend = {}
    ResetTalentProgression(player)
    AIO.Handle(player, "TalentMagespell", "UpdateTalentCount", 0, MAX_TALENTS)

    local pointsAfterReset = 0
    AIO.Handle(player, "TalentMagespell", "UpdateTalentPointsUsed", pointsAfterReset, pointsBeforeReset)

    local talentItemID = 338404
    local itemCount = pointsBeforeReset
    local addedItem = player:AddItem(talentItemID, itemCount)

    if addedItem then
    end
end

local function TalentMageOnCommand(event, player, command)
    if (command == "talentMage") then
        AIO.Handle(player, "TalentMagespell", "ShowTalentMage")
        return false
    end
end
RegisterPlayerEvent(42, TalentMageOnCommand)