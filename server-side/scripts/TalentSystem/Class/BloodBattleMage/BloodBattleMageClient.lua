local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local BloodbattlemageHandlers = AIO.AddHandlers("TalentBloodbattlemagespell", {})

function BloodbattlemageHandlers.ShowTalentBloodbattlemage(player)
    frameTalentBloodbattlemage:Show()
end

local MAX_TALENTS = 31

local OPEN_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_final_trait_unlocked.ogg"
local CLOSE_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_trait_refund_end.ogg"
local SPELL_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_80_azeritearmor_rotationends_02.ogg"

local frameTalentBloodbattlemage = CreateFrame("Frame", "frameTalentBloodbattlemage", UIParent)
frameTalentBloodbattlemage:SetSize(1200, 650)
frameTalentBloodbattlemage:SetMovable(true)
frameTalentBloodbattlemage:EnableMouse(true)
frameTalentBloodbattlemage:RegisterForDrag("LeftButton")
frameTalentBloodbattlemage:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
frameTalentBloodbattlemage:SetBackdrop(
{
    bgFile = "interface/TalentFrame/Template/Class/BloodBattleMage/talentsclassbackgroundbloodbattlemage2",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedbbm",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

local bloodbattlemageIcon = frameTalentBloodbattlemage:CreateTexture("BloodbattlemageIcon", "OVERLAY")
bloodbattlemageIcon:SetTexture("Interface\\TalentFrame\\Template\\Class\\BloodBattleMage\\IconeBloodbattlemage.blp")
bloodbattlemageIcon:SetSize(60, 60)
bloodbattlemageIcon:SetPoint("TOPLEFT", frameTalentBloodbattlemage, "TOPLEFT", -10, 10)


local textureone = frameTalentBloodbattlemage:CreateTexture("TemplateTalentFrame", "OVERLAY")
textureone:SetTexture("Interface\\TalentFrame\\Template\\Class\\Bloodbattlemage\\TalentFrameTemplate.blp")
textureone:SetSize(928, 928)
textureone:SetPoint("TOPLEFT", frameTalentBloodbattlemage, "TOPLEFT", -150, 120)

frameTalentBloodbattlemage:SetFrameLevel(100)

local texturetwo = frameTalentBloodbattlemage:CreateTexture("TemplateTalentFrame", "OVERLAY")
texturetwo:SetTexture("Interface\\TalentFrame\\Template\\Class\\BloodBattleMage\\TalentFrameTemplateOriginal.blp")
texturetwo:SetSize(928, 928)
texturetwo:SetPoint("TOPRIGHT", frameTalentBloodbattlemage, "TOPRIGHT", 150, 160)

frameTalentBloodbattlemage:SetFrameLevel(100)

frameTalentBloodbattlemage:SetScript("OnDragStart", frameTalentBloodbattlemage.StartMoving)
frameTalentBloodbattlemage:SetScript("OnHide", frameTalentBloodbattlemage.StopMovingOrSizing)
frameTalentBloodbattlemage:SetScript("OnDragStop", frameTalentBloodbattlemage.StopMovingOrSizing)
frameTalentBloodbattlemage:Hide()

frameTalentBloodbattlemage:SetBackdropBorderColor(0.5, 0, 0)

local buttonTalentBloodbattlemageClose = CreateFrame("Button", "buttonTalentBloodbattlemageClose", frameTalentBloodbattlemage, "UIPanelCloseButton")
buttonTalentBloodbattlemageClose:SetPoint("TOPRIGHT", -12, -12)
buttonTalentBloodbattlemageClose:EnableMouse(true)
buttonTalentBloodbattlemageClose:SetSize(32, 32)

local function CloseTalentWindow()
    frameTalentBloodbattlemage:Hide()
    PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
end

buttonTalentBloodbattlemageClose:SetScript("OnClick", CloseTalentWindow)

local frameTalentBloodbattlemageTitleBar = CreateFrame("Frame", "frameTalentBloodbattlemageTitleBar", frameTalentBloodbattlemage, nil)
frameTalentBloodbattlemageTitleBar:SetSize(135, 25)
frameTalentBloodbattlemageTitleBar:SetBackdrop(
{
    bgFile = "interface/corrupteditems/corruptedtooltipbackground",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedbbm",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameTalentBloodbattlemageTitleBar:SetPoint("TOP", 0, 20)

local fontTalentBloodbattlemageTitleText = frameTalentBloodbattlemageTitleBar:CreateFontString("fontTalentBloodbattlemageTitleText")
fontTalentBloodbattlemageTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontTalentBloodbattlemageTitleText:SetSize(190, 5)
fontTalentBloodbattlemageTitleText:SetPoint("CENTER", 0, 0)
fontTalentBloodbattlemageTitleText:SetText("|cffFFC125Talents|r")

local fontTalentBloodbattlemageFrameText = frameTalentBloodbattlemageTitleBar:CreateFontString("fontTalentBloodbattlemageFrameText")
fontTalentBloodbattlemageFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentBloodbattlemageFrameText:SetSize(200, 5)
fontTalentBloodbattlemageFrameText:SetPoint("TOPLEFT", frameTalentBloodbattlemageTitleBar, "BOTTOMLEFT", -30, -35)
fontTalentBloodbattlemageFrameText:SetText("|cffFFC125Mage de combat|r")

local fontTalentBloodbattlemageFrameText = frameTalentBloodbattlemageTitleBar:CreateFontString("fontTalentBloodbattlemageFrameText")
fontTalentBloodbattlemageFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentBloodbattlemageFrameText:SetSize(200, 5)
fontTalentBloodbattlemageFrameText:SetPoint("TOPLEFT", frameTalentBloodbattlemageTitleBar, "BOTTOMLEFT", -30, -60)
fontTalentBloodbattlemageFrameText:SetText("0 / " .. MAX_TALENTS)



local function CreateSpellButton(name, texturePath, tooltipText, talentHandler, positionX, positionY)
    local buttonClicked = false
    local talentLearned = false

    local button = CreateFrame("Button", name, frameTalentBloodbattlemage, nil)
    button:SetSize(40, 40)
    button:EnableMouse(true)
    button:SetNormalTexture(texturePath)
    button:SetPushedTexture("Interface/Buttons/checkbuttonhilight")
    button:SetHighlightTexture("Interface/Buttons/checkbuttonhilight")
    button:SetPoint("TOPLEFT", positionX, positionY)

    local learnIndicator = button:CreateTexture(nil, "OVERLAY")
    learnIndicator:SetTexture("Interface/Buttons/UI-CheckBox-Check")
    learnIndicator:SetSize(30, 30)
    learnIndicator:SetPoint("BOTTOMRIGHT", -2, 2)
    learnIndicator:Hide()

    local buttonText = button:CreateFontString("buttonText", "OVERLAY", "GameFontHighlight")
    buttonText:SetPoint("BOTTOMRIGHT", button, "BOTTOMRIGHT", -2, 2)

    local function UpdateButtonState()
        if talentLearned then
            button:SetAlpha(1)
            learnIndicator:Show()
            buttonText:SetText("|cffffda2b1|r")
        else
            button:SetAlpha(1)
            learnIndicator:Hide()
            buttonText:SetText("|cff1aff1a0|r")
        end
    end

    button:SetScript("OnMouseUp", function()
        if not buttonClicked and not talentLearned then
            local talentItemID = 338404
            local hasTalentPoints = GetItemCount(talentItemID, false, true) > 0

            if hasTalentPoints then
                AIO.Handle("TalentBloodbattlemagespell", talentHandler, 1)
                PlaySoundFile(SPELL_TALENT_WINDOW_SOUND)
                buttonClicked = true
                talentLearned = true
                UpdateButtonState()
            else
                print("|cff00ffffVous n'avez plus de points de talent !|r")
            end
        end
    end)

    button:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "TOPLEFT")
        GameTooltip:ClearLines()
        GameTooltip:SetText(tooltipText)
        GameTooltip:Show()
    end)

    button:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    UpdateButtonState()
end






CreateSpellButton("buttonSpellImprovedBlood", "Interface/icons/ability_skeer_bloodletting", "|cffffffffSanguinaire améliorée|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100A chacune de vos compétence de Sanguinaire, vous récupérer 5 point de sang.|r", "spellimprovedblood", 225, -95)
CreateSpellButton("buttonSpellSeedGrowth", "Interface/icons/spell_animarevendreth_orb", "|cffffffffCroissance de graine|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Votre graine de sang croît de manière efficace, lui permettant d'augmenter la durée de son effet de 5 secondes.|r", "spellseedgrowth", 335, -95)
CreateSpellButton("buttonSpellOppressiveRay", "Interface/icons/ability_warlock_burningembers", "|cffffffffRayon oppressant|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Les dégats de rayon de sang sont augmenté de 75%.|r", "spelloppressiveray", 390, -150)
CreateSpellButton("buttonSpellBloodBundle", "Interface/icons/ability_revendreth_shaman", "|cffffffffFaisceau de sang|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Votre rayon de Sang augmente son nombre de cible potentiel de 5.|r", "spellbloodbundle", 280, -150)
CreateSpellButton("buttonSpellBloody", "Interface/icons/ability_revendreth_rogue", "|cffffffffSanguinolent|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Augmente de 15% les dégâts de votre sanguinaire.|r", "spellbloody", 169, -150)
CreateSpellButton("buttonSpellHomeothermal", "Interface/icons/ability_revendreth_demonhunter", "|cffffffffHoméotherme|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Votre sang se chauff et inflige 11 dégâts par seconde aux ennemis proches.\nGénère 5 point de sang.|r", "spellhomeothermal", 115, -205)
CreateSpellButton("buttonSpellTargeted", "Interface/icons/Ability_Marksmanship", "|cffffffffCiblage|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Augmente vos chances de toucher de vos sorts de 5%.|r", "spelltargeted", 335, -205)
CreateSpellButton("buttonSpellEffusion", "Interface/icons/ability_skeer_bloodletting", "|cffffffffEffusion|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100À chaque attaque infligé par vos coups de mêlées vous rendent 5 points de sang.|r", "spelleffusion", 225, -205)
CreateSpellButton("buttonSpellSeedPreparation", "Interface/icons/Spell_Nature_EnchantArmor", "|cffffffffPréparation de graine|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Vous avez 20% de chance avec vos compétences de mêlée de provoquer Préparation de graine, mettant votre graine de sang instantanée.|r", "spellseedpreparation", 444, -205)
CreateSpellButton("buttonSpellBloodTransfusion", "Interface/icons/spell_animarevendreth_nova", "|cffffffffTransfusion Sanguine|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Transfusion l'entièreté de votre être 5 mètre plus loin.|r", "spellbloodtransfusion", 170, -260)
CreateSpellButton("buttonSpellBloodTransfusionImprove", "Interface/icons/spell_animarevendreth_nova", "|cffffffffTransfusion amélioré|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Votre transfusion vous transportes 30 mètres plus loin.|r", "spellbloodtransfusionimprove", 115, -315)
CreateSpellButton("buttonSpellSangThe", "Interface/icons/INV_Drink_22", "|cffffffffSang-Thé|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Votre puissance de sort reçoit un bénéfice supplémentaire de 150% de votre force.|r", "spellsangthe", 390, -260)
CreateSpellButton("buttonSpellParasyteSeed", "Interface/icons/ability_felarakkoa_feldetonation_red", "|cffffffffGraine parasyte|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Les dégâts périodiques de votre graine de sang peuvent à présent être des coups critiques.|r", "spellparasyteseed", 444, -315)
CreateSpellButton("buttonSpellMentalConditioning", "Interface/icons/inv_alchemy_80_alchemiststone02", "|cffffffffConditionnement mental|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Augmente de 10% votre hâte des sorts.|r", "spellmentalconditioning", 170, -370)
CreateSpellButton("buttonSpellWarmup", "Interface/icons/sha_spell_fire_felfire_nightmare", "|cffffffffEchauffement|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Augmente le temps ou vous conservez votre chaleur corporelle élever de 10 secondes.|r", "spellwarmup", 390, -370)
CreateSpellButton("buttonSpellBloodCirculation", "Interface/icons/inv_glove_cloth_revendreth_d_01", "|cffffffffCirculation sanguine|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Vos capacitées physiques ainsi que vos attaques automatique ont 20% de chance d'augmente de 101% votre hâte des sorts.|r", "spellbloodcirculation", 497, -370)
CreateSpellButton("buttonSpellBloodEssence", "Interface/icons/spell_animarevendreth_buff", "|cffffffffEssence de sang|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Dégâts augmentés de 15%.|r", "spellbloodessence", 442, -422)
CreateSpellButton("buttonSpellBloodyApparation", "Interface/icons/ability_revendreth_deathknight", "|cffffffffApparation sanglante|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Vous apparaissez dans le dos de votre adversaire, possédant un bonus de 5% aux dégâts de votre prochaine attaque dans les prochaines 3 seconds.|r", "spellbloodyapparation", 60, -370)
CreateSpellButton("buttonSpellHotBlood", "Interface/icons/inv_misc_boilingblood", "|cffffffffSang chaud|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Chaque dégâts infligés par votre rayon de sang offre une réduction du coût de votre prochaine compétence sanguinaire de 20% (cumulable 5 fois).|r", "spellhotblood", 115, -422)
CreateSpellButton("buttonSpellNoBlood", "Interface/icons/inv_ misc_herb_marrowroot_leaf", "|cffffffffManque de sang|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Augmente les dégâts de votre Prise de sang de 15%.|r", "spellnoblood", 225, -422)
CreateSpellButton("buttonSpellBloodSample", "Interface/icons/spell_animarevendreth_missile", "|cffffffffPrise de sang|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Extrait le sang sur une zone ciblée. Infligeant 1 dégâts par 0.5 secondes, pendant 5 seconds.|r", "spellbloodsample", 170, -478)
CreateSpellButton("buttonSpellCollectiveDonation", "Interface/icons/ability_revendreth_paladin", "|cffffffffDon collectif|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Donne 100 de chance de réduire le temsp de recharge de votre Prise de sang de 0 seconde à chaque attaque automatique.|r", "spellcollectivedonation", 225, -530)
CreateSpellButton("buttonSpellBloodFlow", "Interface/icons/inv_artifact_corruptedbloodofzakajz", "|cffffffffFlôt de sang|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Vos attaques au corps ont 99% de chance de provoquer votre Sanguinaire ou Sanguinaire Pure ne couteront aucun sang.|r", "spellbloodflow", 335, -422)
CreateSpellButton("buttonSpellBloodStorm", "Interface/icons/spell_sandstorm", "|cffffffffTempête de sang|r\n|cffffffffTalent|r |cfffc6703Magie du Sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Votre tempête de sang inflige des dégâts imparable de 115% des dégâts de l'arme en main droite et 115% dégâts de l'arme en main gauche à tout les ennemis proches.|r", "spellbloodstorm", 390, -478)
CreateSpellButton("buttonSpellReinforcedBlood", "Interface/icons/ability_malkorok_blightofyshaarj_red", "|cffffffffSang renforcé|r\n|cffffffffTalent|r |cfff2f200Sacrifice de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Renforce votre sang augmentant votre endurance de 5%.|r", "spellreinforcedblood", 335, -530)



CreateSpellButton("buttonSpellAbilityMotivation", "Interface/icons/spell_halo_purple", "|cffffffffAptitude : Motivation|r\n|cffffffffTalent|r |cfff2f200Sacrifice de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Canalise un puissant terrain de soutien, augmentant la vitesse de déplacement de 30% pour tout les alliés dans la zone.|r", "spellabilitymotivation", 805, -110)
CreateSpellButton("buttonSpellAbilityBloodFlow", "Interface/icons/sha_spell_shadow_shadesofdarkness_nightmare", "|cffffffffAptitude : Afflux de sang|r\n|cffffffffTalent|r |cfff2f200Sacrifice de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Provoque un afflux de sang soudain à la tête aux ennemis proche de vous. Etourdisant les cibles dans une portée de 8 mètres pendand 1 seconds.|r", "spellabilitybloodflow", 915, -110)
CreateSpellButton("buttonSpellAbilityCare", "Interface/icons/spell_halo_blue", "|cffffffffAptitude : Soins|r\n|cffffffffTalent|r |cfff2f200Sacrifice de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Canalise un puissant terrain de soutien, augmentant les soins reçus de 25% pour tout les alliés dans la zone.|r", "spellabilitycare", 750, -165)
CreateSpellButton("buttonSpellAbilityProtection", "Interface/icons/spell_halo_yellow", "|cffffffffAptitude : Protection|r\n|cffffffffTalent|r |cfff2f200Sacrifice de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Canalise un puissant terrain de soutien, réduisant les dégâts subit de 25% pour tout les alliés dans la zone.|r", "spellabilityprotection", 807, -218)
CreateSpellButton("buttonSpellAbilitySword", "Interface/icons/spell_halo_red", "|cffffffffAptitude : Epée|r\n|cffffffffTalent|r |cfff2f200Sacrifice de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Canalise un puissant terrain de soutien, augmentant les dégâts infligés de 25% pour tout les alliés dans la zone.|r", "spellabilitysword", 860, -165)
CreateSpellButton("buttonSpellAbilityProtector", "Interface/icons/spell_halo_green", "|cffffffffAptitude : Protecteur|r\n|cffffffffTalent|r |cfff2f200Sacrifice de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Canalise un puissant terrain de soutien, recevant l'équivalant de 30% des dégâts subit par les alliés dans la zone.|r", "spellabilityprotector", 914, -218)
CreateSpellButton("buttonSpellAbilityPureBlood", "Interface/icons/spell_animarevendreth_beam", "|cffffffffAptitude : Pure sang|r\n|cffffffffTalent|r |cfff2f200Sacrifice de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Canalise un puissant lien procurant à la cible 125% de dégâts prodigués.|r", "spellabilitypureblood", 970, -165)
CreateSpellButton("buttonSpellHarvestingSuffering", "Interface/icons/inv_misc_volatilelife", "|cffffffffRécolte de souffrance|r\n|cffffffffTalent|r |cfff2f200Sacrifice de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Vous sentez la douleur que subisse vos alliés vous avez 10% de chance de recevoir 3 sang à chaque fois qu'un allié reçoit un dégâts corps à corps.|r", "spellharvestingsuffering", 699, -218)
CreateSpellButton("buttonSpellBloodBarrier", "Interface/icons/achievement_emeraldnightmare", "|cffffffffBarrière de sang|r\n|cffffffffTalent|r |cfff2f200Sacrifice de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Vous éparpiller votre sang afin de protéger vos alliés leurs donnant un bouclier absorbant 2400 points de dégâts.|r", "spellbloodbarrier", 1024, -218)
CreateSpellButton("buttonSpellAbilityImprovement", "Interface/icons/inv_misc_clothscrap_02", "|cffffffffAptitude : Amélioration|r\n|cffffffffTalent|r |cfff2f200Sacrifice de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Vous donnez de la force à vos alliés à moins de 40 mètres, leurs procurant de la puissance d'attaque à hauteur de 10% de votre force.|r", "spellabilityimprovement", 750, -273)
CreateSpellButton("buttonSpellAbilityPotential", "Interface/icons/inv_misc_clothscrap_03", "|cffffffffAptitude :  Potentiel|r\n|cffffffffTalent|r |cfff2f200Sacrifice de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Vous donnez du pouvoir à vos alliés à moins de 40 mètres, leurs procurant de la puissance de sort à hauteur de 10% de votre force.|r", "spellabilitypotential", 970, -273)


CreateSpellButton("buttonSpellBloodProvocation", "Interface/icons/ability_revendreth_monk", "|cffffffffProvocation sanguine|r\n|cffffffffTalent|r |cff00bfffBlessure de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Provoque la cible et la force à vous attaquer. Aucun effet si la cible est déjà en train de vous attaquer.|r", "spellbloodprovocation", 699, -325)
CreateSpellButton("buttonSpellMartialKnowledge", "Interface/icons/spell_misc_warsongfocus", "|cffffffffConnaissance martial|r\n|cffffffffTalent|r |cff00bfffBlessure de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Augmente les chances de coups critiques de 100%.|r", "spellmartialknowledge", 805, -325)
CreateSpellButton("buttonSpellMicroBalance", "Interface/icons/spell_nzinsanity_desynchronized", "|cffffffffMicro-balance|r\n|cffffffffTalent|r |cff00bfffBlessure de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Vous compactez votre sang réduisant votre endurance de 10% compensant cette perte par une réduction de dégâts subit de 10%.|r", "spellmicrobalance", 915, -325)
CreateSpellButton("buttonSpellMortalBloodOrb", "Interface/icons/ability_deathwing_bloodcorruption_earth", "|cffffffffMortel : Orbe de sang|r\n|cffffffffTalent|r |cff00bfffBlessure de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Invoque une orbe de sang qui absorbe le sang des cibles dans une distance de 10 mètre de l'orbe, augmentant ainsi les saignements prodigués aux cibles de 45%.|r", "spellmortalbloodorb", 1025, -325)
CreateSpellButton("buttonSpellMortalMultipleContusion", "Interface/icons/inv_offhand_1h_revendreth_d_01", "|cffffffffMortel : Contusion multiple|r\n|cffffffffTalent|r |cff00bfffBlessure de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Frappe une cible avec une force considérable infligeant à la cible des contusions, lui infligeant 400 dégâts par seconde pendant 5 seconds.|r", "spellmortalmultiplecontusion", 970, -380)
CreateSpellButton("buttonSpellMortalSurgicalStrike", "Interface/icons/Ability_Warrior_BloodBath", "|cffffffffMortel : Frappe chirurgicale|r\n|cffffffffTalent|r |cff00bfffBlessure de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Frappe une cible avec une précision et une puissance hors-normes sur les points vitaux de l'ennemi,\ncette technique demande une concentration phénoménale et consomme par conséquent votre santé pour être effectuée.\nInfligeant 400 par seconde pendant 5 seconds.|r", "spellmortalsurgicalstrike", 1025, -434)
CreateSpellButton("buttonSpellMortalDestruction", "Interface/icons/ability_rogue_ruthlessness", "|cffffffffMortel : Destruction|r\n|cffffffffTalent|r |cff00bfffBlessure de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Inflige 500% des dégâts de l'arme ainsi que 400 point de dégâts. Utilisable uniquement si la cible se trouve en dessous de 20% de vie.|r", "spellmortaldestruction", 970, -490)
CreateSpellButton("buttonSpellCollectingBlood", "Interface/icons/_SpellCasting_Red", "|cffffffffRécolte de sang|r\n|cffffffffTalent|r |cff00bfffBlessure de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Lorsque vous tappez votre cible vous avez 99% de chance de récolter 5000 point de sang.|r", "spellcollectingblood", 915, -434)
CreateSpellButton("buttonSpellBloodyBlood", "Interface/icons/spell_holy_dizzy", "|cffffffffSanguinolent|r\n|cffffffffTalent|r |cff00bfffBlessure de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Augmente les chances de coups critique de 100% pour la compétence Sanguinaire.|r", "spellbloodyblood", 860, -490)
CreateSpellButton("buttonSpellBloodshed", "Interface/icons/inv_misc_food_legion_gooamber_drop", "|cffffffffEffusion de sang|r\n|cffffffffTalent|r |cff00bfffBlessure de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Augmente les dégâts prodigué par votre saignement Mortel : Coup multiple de 100%.|r", "spellbloodshed", 750, -380)
CreateSpellButton("buttonSpellLethalPowerfulImpulse", "Interface/icons/inv_thrown_1h_deathwingraid_d_01", "|cffffffffMortel : Impulsion puissante|r\n|cffffffffTalent|r |cff00bfffBlessure de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Lancer votre bâton d'une telle puissance que votre cible en restera cloué au sol.\nInfligeant 4501 to 5000 dégâts ainsi que renversant la cible pendant 2.5 seconds.|r", "spelllethalpowerfulimpulse", 699, -434)
CreateSpellButton("buttonSpellInternalHemorrhage", "Interface/icons/inv_misc_food_legion_gooamber_multi", "|cffffffffHémorragie interne|r\n|cffffffffTalent|r |cff00bfffBlessure de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Augmente les dégâts produits par votre saignement Mortel : Frappe chirurgical de 100%.|r", "spellinternalhemorrhage", 805, -434)
CreateSpellButton("buttonSpellAnticipatedDestruction", "Interface/icons/ability_butcher_exsanguination", "|cffffffffDestruction anticipé|r\n|cffffffffTalent|r |cff00bfffBlessure de sang|r\n|cffffffffRequiert|r |cffeb0000Mage de combat sanglant|r\n|cffffd100Vous avez un taux de chance (avec vos saignements) de 15% de pouvoir éxécuter votre Mortel : Destruction peu importe la santé de votre ennemi, et ne vous couteras pas de point de vie.|r", "spellanticipateddestruction", 750, -490)



local resetButtonClicked = false

local buttonReset = CreateFrame("Button", "buttonReset", frameTalentBloodbattlemage, "UIPanelButtonTemplate")
buttonReset:SetSize(85, 25)
buttonReset:SetPoint("BOTTOMRIGHT", buttonTalentBloodbattlemageClose, "BOTTOMLEFT", -95, 5)
buttonReset:SetText("Réinitialiser")

local function ResetTalents()
    AIO.Handle("TalentBloodbattlemagespell", "ResetTalents")
    resetButtonClicked = true
end

buttonReset:SetScript("OnClick", ResetTalents)

local buttonReload = CreateFrame("Button", "buttonReload", frameTalentBloodbattlemage, "UIPanelButtonTemplate")
buttonReload:SetSize(85, 25)
buttonReload:SetPoint("BOTTOMRIGHT", buttonTalentBloodbattlemageClose, "BOTTOMLEFT", -5, 5)
buttonReload:SetText("Actualiser")

local function ReloadClient()
    if resetButtonClicked then
        ReloadUI()
    else
        print("|cff00ffffVous ne pouvez <Actualiser> que lorsque vous <Réinitialiser> vos talents.")
    end
end

buttonReload:SetScript("OnClick", ReloadClient)

local talentsWindowOpen = false

local function OuvrirFermerInterfaceTalents()
    if talentsWindowOpen then
        frameTalentBloodbattlemage:Hide()
        buttonReload:Hide()
        PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
    else
        frameTalentBloodbattlemage:Show()
        buttonReload:Show()
        PlaySoundFile(OPEN_TALENT_WINDOW_SOUND)
    end

    talentsWindowOpen = not talentsWindowOpen
end

local playerClass = select(2, UnitClass("player"))
if playerClass == "BLOODMAGE" then
    local buttonOuvrirTalents = CreateFrame("Button", "buttonOuvrirTalents", UIParent)
    buttonOuvrirTalents:SetSize(32, 33)
    buttonOuvrirTalents:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -171, 8)

    buttonOuvrirTalents:SetNormalTexture("Interface\\TalentFrame\\Template\\MicroButton\\ButtonSystemTalent.blp")

    local highlightTexture = buttonOuvrirTalents:CreateTexture(nil, "HIGHLIGHT")
    highlightTexture:SetAllPoints(buttonOuvrirTalents)
    highlightTexture:SetTexture("Interface\\TalentFrame\\Template\\MicroButton\\ButtonSystemTalentLight.blp")
    buttonOuvrirTalents:SetHighlightTexture(highlightTexture)

    buttonOuvrirTalents:SetText("")

    buttonOuvrirTalents:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
        GameTooltip:SetText("|cffffffffTalents|r |cffeb0000(Mage de combat sanglant)|r\n\nL'éventail des talents disponibles\npour améliorer et spécialiser\nvotre personnage.")
        GameTooltip:Show()
    end)

    buttonOuvrirTalents:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    buttonOuvrirTalents:SetScript("OnClick", OuvrirFermerInterfaceTalents)
    TalentMicroButton:Hide()
end

BloodbattlemageHandlers.UpdateTalentCount = function(player, talentsAppris)
    if fontTalentBloodbattlemageFrameText then
        fontTalentBloodbattlemageFrameText:SetText(talentsAppris .. " / " .. MAX_TALENTS)
    end
end

BloodbattlemageHandlers.UpdateTalentPointsUsed = function(player, pointsUsed, pointsBeforeReset)
    print("|cff00ffffVous avez utilisés " .. pointsBeforeReset .. " points avant la réinitialisation des talents|r")
end