local function GrantTalentPointsOnLevelUp(event, player, oldLevel)
    local level = oldLevel + 1  -- FIX : GetLevel() retourne l'ancien niveau au moment de l'event

    local pointsToGrant = 0

    -- Points de talent dès le niveau 10
    if level >= 10 and level <= 80 then
        local talentLevels = {
            10, 11, 12, 13, 14, 15, 16, 17, 18, 19,  -- niv 10-19 : 10 points
            20, 21, 22, 23, 24, 25, 26, 27, 28, 29,  -- niv 20-29 : 10 points
            30, 31, 32, 33, 34, 35, 36, 37, 38, 39,  -- niv 30-39 : 10 points
            40, 41, 42, 43, 44, 45, 46, 47, 48, 49,  -- niv 40-49 : 10 points
            50, 51, 52, 53, 54, 55, 56, 57, 58, 59,  -- niv 50-59 : 10 points
            60, 62, 64, 66, 68, 70, 72, 74, 76, 80   -- niv 60-80 : 10 points
        }

        if table.contains(talentLevels, level) then
            pointsToGrant = 1
        end
    end

    -- Si des points doivent être accordés
    if pointsToGrant > 0 then
        for i = 1, pointsToGrant do
            player:AddItem(338404, 1)
        end
        player:SendAreaTriggerMessage("|cff00ff00Vous avez gagné " .. pointsToGrant .. " point" .. (pointsToGrant > 1 and "s" or "") .. " de talent pour avoir atteint le niveau " .. level .. "!|r")
    end
end

-- Fonction pour vérifier si un tableau contient un élément
function table.contains(tbl, val)
    for i = 1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

RegisterPlayerEvent(13, GrantTalentPointsOnLevelUp)
