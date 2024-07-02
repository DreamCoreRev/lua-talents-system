local AIO = AIO or require("AIO")
local DeathknightHandlers = AIO.AddHandlers("TalentDeathknightspell", {})
local TalentDeathknightPointsSpend = {}

local MAX_TALENTS = 44

local talents = {

	
	["spellbutchery"] = {spellID = 49483, itemID = 338404},
	["spellsubversion"] = {spellID = 49491, itemID = 338404},
	["spellbladebarrier"] = {spellID = 55226, itemID = 338404},
	["spellbladedarmor"] = {spellID = 49393, itemID = 338404},
	["spellscentofblood"] = {spellID = 49509, itemID = 338404},
	["spelltwohandedweaponspecialization"] = {spellID = 55108, itemID = 338404},
	["spellrunetap"] = {spellID = 48982, itemID = 338404},
	["spelldarkconviction"] = {spellID = 49480, itemID = 338404},
	["spelldeathrunemastery"] = {spellID = 50034, itemID = 338404},
	["spellimprovedrunetap"] = {spellID = 49489, itemID = 338404},
	["spellspelldeflection"] = {spellID = 49497, itemID = 338404},
	["spellvendetta"] = {spellID = 55136, itemID = 338404},
	["spellbloodystrikes"] = {spellID = 49395, itemID = 338404},
	["spellveteranofthethirdwar"] = {spellID = 50029, itemID = 338404},
	["spellmarkofblood"] = {spellID = 49005, itemID = 338404},
	["spellbloodyvengeance"] = {spellID = 49504, itemID = 338404},
	["spellabominationsmight"] = {spellID = 53138, itemID = 338404},
	["spellbloodworms"] = {spellID = 49543, itemID = 338404},
	["spellunholyfrenzy"] = {spellID = 49016, itemID = 338404},
	["spellimprovedbloodpresence"] = {spellID = 50371, itemID = 338404},
	["spellimproveddeathstrike"] = {spellID = 62908, itemID = 338404},
	["spellsuddendoom"] = {spellID = 49530, itemID = 338404},
	["spellvampiricblood"] = {spellID = 55233, itemID = 338404},
	["spellwillofthenecropolis"] = {spellID = 50150, itemID = 338404},
	["spellheartstrike"] = {spellID = 55050, itemID = 338404},
	["spellmightofmograine"] = {spellID = 49534, itemID = 338404},
	["spellbloodgorged"] = {spellID = 61158, itemID = 338404},
	["spelldancingruneweapon"] = {spellID = 49028, itemID = 338404},
	
	
	["spellimprovedicytouch"] = {spellID = 51456, itemID = 338404},
	["spellrunicpowermastery"] = {spellID = 50147, itemID = 338404},
	["spelltoughness"] = {spellID = 49789, itemID = 338404},
	["spellicyreach"] = {spellID = 55062, itemID = 338404},
	["spellblackice"] = {spellID = 49664, itemID = 338404},
	["spellnervesofcoldsteel"] = {spellID = 50138, itemID = 338404},
	["spellicytalons"] = {spellID = 50887, itemID = 338404},
	["spelllichborne"] = {spellID = 49039, itemID = 338404},
	["spellannihilation"] = {spellID = 51473, itemID = 338404},
	["spellkillingmachine"] = {spellID = 51130, itemID = 338404},
	["spellchillofthegrave"] = {spellID = 50115, itemID = 338404},
	["spellendlesswinter"] = {spellID = 49657, itemID = 338404},
	["spellfrigiddreadplate"] = {spellID = 51109, itemID = 338404},
	["spellglacierrot"] = {spellID = 49791, itemID = 338404},
	["spelldeathchill"] = {spellID = 49796, itemID = 338404},
	["spellimprovedicytalons"] = {spellID = 55610, itemID = 338404},
	
	
	["spellmercilesscombat"] = {spellID = 49538, itemID = 338404},
	["spellrime"] = {spellID = 59057, itemID = 338404},
	["spellchilblains"] = {spellID = 50043, itemID = 338404},
	["spellhungeringcold"] = {spellID = 49203, itemID = 338404},
	["spellimprovedfrostpresence"] = {spellID = 50385, itemID = 338404},
	["spellthreatofthassarian"] = {spellID = 66192, itemID = 338404},
	["spellbloodofthenorth"] = {spellID = 54637, itemID = 338404},
	["spellunbreakablearmor"] = {spellID = 51271, itemID = 338404},
	["spellacclimation"] = {spellID = 50152, itemID = 338404},
	["spellfroststrike"] = {spellID = 49143, itemID = 338404},
	["spellguileofgorefiend"] = {spellID = 50191, itemID = 338404},
	["spelltundrastalker"] = {spellID = 50130, itemID = 338404},
	["spellhowlingblast"] = {spellID = 49184, itemID = 338404},
	
	
	["spellviciousstrikes"] = {spellID = 51746, itemID = 338404},
	["spellvirulence"] = {spellID = 49568, itemID = 338404},
	["spellanticipation"] = {spellID = 55133, itemID = 338404},
	["spellepidemics"] = {spellID = 49562, itemID = 338404},
	["spellmorbidity"] = {spellID = 49565, itemID = 338404},
	["spellunholycommand"] = {spellID = 49589, itemID = 338404},
	["spellravenousdead"] = {spellID = 49572, itemID = 338404},
	["spelloutbreak"] = {spellID = 55237, itemID = 338404},
	["spellnecrosis"] = {spellID = 51465, itemID = 338404},
	["spellcorpseexplosion"] = {spellID = 49158, itemID = 338404},
	["spellonapalehorse"] = {spellID = 51267, itemID = 338404},
	["spellbloodcakedblade"] = {spellID = 49628, itemID = 338404},
	["spellnightofthedead"] = {spellID = 55623, itemID = 338404},
	["spellmasterofghouls"] = {spellID = 52143, itemID = 338404},
	["spellghoulfrenzy"] = {spellID = 63560, itemID = 338404},
	["spellunholyblight"] = {spellID = 49194, itemID = 338404},
	["spellimpurity"] = {spellID = 49638, itemID = 338404},
	["spelldirge"] = {spellID = 49599, itemID = 338404},
	["spelldesecration"] = {spellID = 55667, itemID = 338404},
	["spellmagicsuppression"] = {spellID = 49611, itemID = 338404},
	["spellantimagiczone"] = {spellID = 51052, itemID = 338404},
	["spellreaping"] = {spellID = 56835, itemID = 338404},
	["spelldesolation"] = {spellID = 66817, itemID = 338404},
	["spellimprovedunholypresence"] = {spellID = 50392, itemID = 338404},
	["spellcryptfever"] = {spellID = 49632, itemID = 338404},
	["spellboneshield"] = {spellID = 49222, itemID = 338404},
	["spellwanderingplague"] = {spellID = 49655, itemID = 338404},
	["spellebonplaguebringer"] = {spellID = 51161, itemID = 338404},
	["spellscourgestrike"] = {spellID = 55090, itemID = 338404},
	["spellrageofrivendare"] = {spellID = 50121, itemID = 338404},
	["spellsummongargoyle"] = {spellID = 49206, itemID = 338404},
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
                if #TalentDeathknightPointsSpend >= MAX_TALENTS then
                    player:SendAreaTriggerMessage("|cffff0000Vous avez atteint la limite de talents !|r")
                else
                    player:RemoveItem(itemID, 1)
                    player:SendAreaTriggerMessage("|cff00ff00Vous avez appris un nouveau talent !|r")
                    player:LearnSpell(spellID)
                    table.insert(TalentDeathknightPointsSpend, spellID)
                    AIO.Handle(player, "TalentDeathknightspell", "UpdateTalentCount", #TalentDeathknightPointsSpend, MAX_TALENTS)

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
    DeathknightHandlers[talentName] = function(player, item)
        LearnTalent(player, talentData)
    end
end

local function LoadTalentProgression(player)
    TalentDeathknightPointsSpend = {}

    local query = CharDBQuery("SELECT spell FROM character_talentspell WHERE guid = " .. player:GetGUIDLow() .. " AND active = 1;")
    if query then
        repeat
            local spellID = query:GetUInt32(0)
            table.insert(TalentDeathknightPointsSpend, spellID)
        until not query:NextRow()
    end

    AIO.Handle(player, "TalentDeathknightspell", "UpdateTalentCount", #TalentDeathknightPointsSpend, MAX_TALENTS)
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

DeathknightHandlers.ResetTalents = function(player)
    local pointsBeforeReset = #TalentDeathknightPointsSpend

    for talentName, talentData in pairs(talents) do
        local spellID = talentData.spellID
        player:RemoveSpell(spellID)
    end

    TalentDeathknightPointsSpend = {}
    ResetTalentProgression(player)
    AIO.Handle(player, "TalentDeathknightspell", "UpdateTalentCount", 0, MAX_TALENTS)

    local pointsAfterReset = 0
    AIO.Handle(player, "TalentDeathknightspell", "UpdateTalentPointsUsed", pointsAfterReset, pointsBeforeReset)

    local talentItemID = 338404
    local itemCount = pointsBeforeReset
    local addedItem = player:AddItem(talentItemID, itemCount)

    if addedItem then
    end
end

local function TalentDeathknightOnCommand(event, player, command)
    if (command == "talentDeathknight") then
        AIO.Handle(player, "TalentDeathknightspell", "ShowTalentDeathknight")
        return false
    end
end
RegisterPlayerEvent(42, TalentDeathknightOnCommand)