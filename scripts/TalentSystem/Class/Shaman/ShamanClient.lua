local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local ShamanHandlers = AIO.AddHandlers("TalentShamanspell", {})

function ShamanHandlers.ShowTalentShaman(player)
    frameTalentShaman:Show()
end

local MAX_TALENTS = 41

local OPEN_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_final_trait_unlocked.ogg"
local CLOSE_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_trait_refund_end.ogg"
local SPELL_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_80_azeritearmor_rotationends_02.ogg"

local frameTalentShaman = CreateFrame("Frame", "frameTalentShaman", UIParent)
frameTalentShaman:SetSize(1200, 650)
frameTalentShaman:SetMovable(true)
frameTalentShaman:EnableMouse(true)
frameTalentShaman:RegisterForDrag("LeftButton")
frameTalentShaman:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
frameTalentShaman:SetBackdrop(
{
    bgFile = "interface/TalentFrame/Template/Class/Shaman/talentsclassbackgroundShaman",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedshaman",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

local shamanIcon = frameTalentShaman:CreateTexture("ShamanIcon", "OVERLAY")
shamanIcon:SetTexture("Interface\\TalentFrame\\Template\\Class\\Shaman\\IconeShaman.blp")
shamanIcon:SetSize(60, 60)
shamanIcon:SetPoint("TOPLEFT", frameTalentShaman, "TOPLEFT", -10, 10)


local textureone = frameTalentShaman:CreateTexture("TemplateTalentFrame", "OVERLAY")
textureone:SetTexture("Interface\\TalentFrame\\Template\\Class\\Shaman\\TalentFrameTemplate.blp")
textureone:SetSize(928, 928)
textureone:SetPoint("TOPLEFT", frameTalentShaman, "TOPLEFT", -170, 140)

frameTalentShaman:SetFrameLevel(100)

local texturetwo = frameTalentShaman:CreateTexture("TemplateTalentFrame", "OVERLAY")
texturetwo:SetTexture("Interface\\TalentFrame\\Template\\Class\\Shaman\\TalentFrameTemplateOriginal.blp")
texturetwo:SetSize(928, 928)
texturetwo:SetPoint("TOPRIGHT", frameTalentShaman, "TOPRIGHT", 170, 140)

frameTalentShaman:SetFrameLevel(100)

frameTalentShaman:SetScript("OnDragStart", frameTalentShaman.StartMoving)
frameTalentShaman:SetScript("OnHide", frameTalentShaman.StopMovingOrSizing)
frameTalentShaman:SetScript("OnDragStop", frameTalentShaman.StopMovingOrSizing)
frameTalentShaman:Hide()

frameTalentShaman:SetBackdropBorderColor(0, 112, 222)

local buttonTalentShamanClose = CreateFrame("Button", "buttonTalentShamanClose", frameTalentShaman, "UIPanelCloseButton")
buttonTalentShamanClose:SetPoint("TOPRIGHT", -12, -12)
buttonTalentShamanClose:EnableMouse(true)
buttonTalentShamanClose:SetSize(32, 32)

local function CloseTalentWindow()
    frameTalentShaman:Hide()
    PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
end

buttonTalentShamanClose:SetScript("OnClick", CloseTalentWindow)

local frameTalentShamanTitleBar = CreateFrame("Frame", "frameTalentShamanTitleBar", frameTalentShaman, nil)
frameTalentShamanTitleBar:SetSize(135, 25)
frameTalentShamanTitleBar:SetBackdrop(
{
    bgFile = "interface/corrupteditems/corruptedtooltipbackground",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedshaman",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameTalentShamanTitleBar:SetPoint("TOP", 0, 20)

local fontTalentShamanTitleText = frameTalentShamanTitleBar:CreateFontString("fontTalentShamanTitleText")
fontTalentShamanTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontTalentShamanTitleText:SetSize(190, 5)
fontTalentShamanTitleText:SetPoint("CENTER", 0, 0)
fontTalentShamanTitleText:SetText("|cffFFC125Talents|r")

local fontTalentShamanFrameText = frameTalentShamanTitleBar:CreateFontString("fontTalentShamanFrameText")
fontTalentShamanFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentShamanFrameText:SetSize(200, 5)
fontTalentShamanFrameText:SetPoint("TOPLEFT", frameTalentShamanTitleBar, "BOTTOMLEFT", -30, -35)
fontTalentShamanFrameText:SetText("|cffFFC125Chaman|r")

local fontTalentShamanFrameText = frameTalentShamanTitleBar:CreateFontString("fontTalentShamanFrameText")
fontTalentShamanFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentShamanFrameText:SetSize(200, 5)
fontTalentShamanFrameText:SetPoint("TOPLEFT", frameTalentShamanTitleBar, "BOTTOMLEFT", -30, -60)
fontTalentShamanFrameText:SetText("0 / " .. MAX_TALENTS)



local function CreateSpellButton(name, texturePath, tooltipText, talentHandler, positionX, positionY)
    local buttonClicked = false
    local talentLearned = false

    local button = CreateFrame("Button", name, frameTalentShaman, nil)
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
                AIO.Handle("TalentShamanspell", talentHandler, 1)
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






CreateSpellButton("buttonSpellConvection", "Interface/icons/spell_nature_wispsplode", "|cffffffffConvection|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit le coût en mana de vos Horions ainsi que de vos sorts Eclair, Chaîne d'éclairs, Explosion de lave et Cisaille de vent de 10%.|r", "spellconvection", 100, -80)
CreateSpellButton("buttonSpellConcussion", "Interface/icons/spell_fire_fireball", "|cffffffffCommotion|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente les dégâts infligés par vos sorts Eclair, Chaîne d'éclairs, Orage et Explosion de lave ainsi que vos Horions de 5%.|r", "spellconcussion", 205, -75)
CreateSpellButton("buttonSpellCallofFlame", "Interface/icons/spell_fire_immolation", "|cffffffffAppel des flammes|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 15% les dégâts infligés par vos Totems de feu et votre Nova de feu, et de 6% les dégâts infligés par votre sort Explosion de lave.|r", "spellcallofflame", 315, -75)
CreateSpellButton("buttonSpellElementalWarding", "Interface/icons/spell_nature_spiritarmor", "|cffffffffProtection contre les éléments|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit tous les dégâts subis de 6%.|r", "spellelementalwarding", 418, -80)
CreateSpellButton("buttonSpellElementalDevastation", "Interface/icons/spell_fire_elementaldevastation", "|cffffffffDévastation élémentaire|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Vos coups critiques non périodiques obtenus avec des sorts offensifs augmentent de 9% vos chances d'obtenir un coup critique avec les attaques de mêlée pendant 10 secondes.|r", "spellelementaldevastation", 45, -130)
CreateSpellButton("buttonSpellReverberation", "Interface/icons/spell_frost_frostward", "|cffffffffRéverbération|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit le temps de recharge de vos Horions et de Cisaille de vent de 1 seconde.|r", "spellreverberation", 150, -130)
CreateSpellButton("buttonSpellElementalFocus", "Interface/icons/spell_shadow_manaburn", "|cffffffffFocalisation élémentaire|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Après avoir réussi un coup critique non périodique avec un sort de dégâts de Feu, de Givre ou de Nature, vous entrez dans un état d'Idées claires.\nIdées claires réduit le coût en mana de vos 2 prochains sorts de dégâts ou de soins de 40%.|r", "spellelementalfocus", 260, -130)
CreateSpellButton("buttonSpellElementalFury", "Interface/icons/spell_fire_volcano", "|cffffffffFureur élémentaire|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 100% le bonus aux dégâts des coups critiques obtenus avec vos Totems incendiaires et de magma ainsi qu'avec les sorts de Feu, de Givre et de Nature.|r", "spellelementalfury", 370, -130)
CreateSpellButton("buttonSpellImprovedFireNova", "Interface/icons/spell_fire_sealoffire", "|cffffffffNova de feu améliorée|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente les dégâts infligés par votre Nova de feu de 20% et réduit le temps de recharge de 4 sec.|r", "spellimprovedfirenova", 475, -133)
CreateSpellButton("buttonSpellEyeoftheStorm", "Interface/icons/spell_shadow_soulleech_2", "|cffffffffOeil du cyclone|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit de 70% l'interruption causée par les attaques infligeant des dégâts pendant que vous incantez les sorts Eclair, Chaîne d'éclairs, Explosion de lave ou Maléfice.|r", "spelleyeofthestorm", 96, -185)
CreateSpellButton("buttonSpellElementalReach", "Interface/icons/spell_nature_stormreach", "|cffffffffAllonge élémentaire|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente la portée de vos sorts Eclair, Chaîne d'éclairs, Nova de feu et Explosion de lave de 6 mètres,\naugmente le rayon de votre sort Orage de 20% et augmente la portée de votre Horion de flammes de 15 mètres.|r", "spellelementalreach", 205, -185)
CreateSpellButton("buttonSpellCallofThunder", "Interface/icons/spell_nature_callstorm", "|cffffffffAppel de la foudre|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente vos chances de réaliser un coup critique avec vos sorts Eclair, Chaîne d'éclairs et Orage de 5% supplémentaires.|r", "spellcallofthunder", 315, -185)
CreateSpellButton("buttonSpellUnrelentingStorm", "Interface/icons/spell_nature_unrelentingstorm", "|cffffffffTempête continuelle|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Régénère une quantité de mana égale à 12% de votre Intelligence toutes les 5 sec., même pendant l'incantation.|r", "spellunrelentingstorm", 422, -185)
CreateSpellButton("buttonSpellElementalPrecision", "Interface/icons/spell_nature_elementalprecision_1", "|cffffffffPrécision élémentaire|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 3% vos chances de toucher avec les sorts de Feu, de Givre et de Nature, et réduit de 30% la menace générée par les sorts de Feu, Givre et Nature.|r", "spellelementalprecision", 527, -190)
CreateSpellButton("buttonSpellLightningMastery", "Interface/icons/spell_lightning_lightningbolt01", "|cffffffffMaîtrise de la foudre|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit le temps d'incantation de vos sorts Eclair, Chaîne d'éclairs et Explosion de lave de 0.5 sec.", "spelllightningmastery", 43, -240)
CreateSpellButton("buttonSpellElementalMastery", "Interface/icons/spell_nature_wispheal", "|cffffffffMaîtrise élémentaire|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Lorsqu'elle est activée, votre prochain sort Eclair, Chaîne d'éclairs ou Explosion de lave bénéficie d'une incantation instantanée.\nDe plus, vous bénéficiez d'un bonus à la hâte des sorts de 15% pendant 15 secondes.\nMaîtrise élémentaire partage le temps de recharge de Rapidité de la nature.|r", "spellelementalmastery", 150, -240)
CreateSpellButton("buttonSpellStormEarthandFire", "Interface/icons/spell_shaman_stormearthfire", "|cffffffffTempête, terre et feu|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit le temps de recharge de votre sort Chaîne d'éclairs de 2,5 sec.,\nvotre Totem de lien terrestre a 100% de chances d'enraciner les cibles pendant 5 seconds\nà son lancement et les dégâts périodiques infligés par votre Horion de flammes sont augmentés de 60%.|r", "spellstormearthandfire", 368, -240)
CreateSpellButton("buttonSpellBoomingEchoes", "Interface/icons/spell_fire_blueflamering", "|cffffffffEchos tonitruants|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit le temps de recharge de vos sorts Horion de flammes et Horion de givre de 2 secondes.\nsupplémentaires, en plus d'augmenter les dégâts directs qu'ils infligent de 20% supplémentaires.|r", "spellboomingechoes", 478, -240)
CreateSpellButton("buttonSpellElementalOath", "Interface/icons/spell_shaman_elementaloath", "|cffffffffSerment des éléments|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Quand vous êtes sous l'effet d'Idées claires alors que Focalisation élémentaire est active, vous infligez 10% de dégâts supplémentaires avec les sorts.\nDe plus, les membres du groupe ou raid se trouvant à moins de 100 mètres bénéficient d'un bonus de 5% à leurs chances de coup critique avec les sorts.|r", "spellelementaloath", 98, -293)
CreateSpellButton("buttonSpellLightningOverload", "Interface/icons/spell_nature_lightningoverload", "|cffffffffSurcharge de foudre|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Donne à vos sorts Eclair et Chaîne d'éclairs 33% de chances de lancer un second sort semblable sur la même cible sans coût supplémentaire.\nCe sort inflige la moitié des dégâts et ne génère pas de menace.|r", "spelllightningoverload", 205, -293)
CreateSpellButton("buttonSpellAstralShift", "Interface/icons/spell_shaman_astralshift", "|cffffffffTransfert astral|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Quand vous êtes étourdi, apeuré ou réduit au silence, vous entrez dans le Plan astral afin de réduire tous les dégâts subis de 30% pendant la durée de l'effet d'étourdissement, de peur ou de silence.|r", "spellastralshift", 315, -293)
CreateSpellButton("buttonSpellTotemofWrath", "Interface/icons/spell_fire_totemofwrath", "|cffffffffTotem de courroux|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100nvoque un Totem de courroux qui dispose de 5 points de vie aux pieds du lanceur de sorts.\nIl augmente de 100 la puissance des sorts de tous les membres du groupe et du raid, et augmente de 3%\nles chances de coup critique de toutes les attaques contre les ennemis se trouvant à moins de 40 mètres.\nDure 5 mn.|r", "spelltotemofwrath", 422, -293)
CreateSpellButton("buttonSpellLavaFlows", "Interface/icons/spell_shaman_lavaflow", "|cffffffffFlots de lave|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente le bonus aux dégâts des coups critiques de votre sort Explosion de lave de 24% supplémentaires,\net lorsque votre Horion de flammes est dissipé,\nvotre vitesse d'incantation des sorts est augmentée de 30% pendant 6 secondes.|r", "spelllavaflows", 527, -295)
CreateSpellButton("buttonSpellShamanism", "Interface/icons/spell_unused2", "|cffffffffChamanisme|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Vos sorts Éclair et Chaîne d'éclairs bénéficient de 20% supplémentaires et votre Explosion de lave de 25% supplémentaires des effets de vos bonus aux dégâts.|r", "spellshamanism", 43, -350)
CreateSpellButton("buttonSpellThunderstorm", "Interface/icons/spell_shaman_thunderstorm", "|cffffffffOrage|r\n|cffffffffTalent|r |cffca95ffElémentaire|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Vous appelez la foudre, qui vous charge d'énergie et inflige des dégâts aux ennemis se trouvant à moins de 10 mètres.\nVous rend 8% de mana et inflige 551 à 629 points de dégâts de Nature à tous les ennemis proches, les faisant tomber à la renverse 20 mètres plus loin.\nCe sort est utilisable quand vous êtes étourdi.|r", "spellthunderstorm", 150, -350)
CreateSpellButton("buttonSpellEnhancingTotems", "Interface/icons/spell_nature_earthbindtotem", "|cffffffffTotems renforcés|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 15% l'effet de vos Totems de Force de la Terre et Langue de feu.|r", "spellenhancingtotems", 260, -350)
CreateSpellButton("buttonSpellEarthsGrasp", "Interface/icons/spell_nature_stoneclawtotem", "|cffffffffEmprise de la terre|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente les points de vie de votre Totem de griffes de pierre de 50% et le rayon de votre Totem de lien terrestre de 20%, en plus de réduire le temps de recharge des deux totems de 30%.|r", "spellearthsgrasp", 368, -350)
CreateSpellButton("buttonSpellAncestralKnowledge", "Interface/icons/spell_shadow_grimward", "|cffffffffConnaissance ancestrale|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente votre Intelligence de 10%.|r", "spellancestralknowledge", 478, -350)


CreateSpellButton("buttonSpellGuardianTotems", "Interface/icons/spell_nature_stoneskintotem", "|cffffffffTotems gardiens|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 20% le montant de points d'armure augmentés par votre Totem Peau de pierre et réduit le temps de recharge de votre Totem de glèbe de 2 sec.|r", "spellguardiantotems", 98, -405)
CreateSpellButton("buttonSpellThunderingStrikes", "Interface/icons/ability_thunderbolt", "|cffffffffFrappe foudroyante|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 5% vos chances d'infliger un coup critique avec tous les sorts et attaques.|r", "spellthunderingstrikes", 205, -405)
CreateSpellButton("buttonSpellImprovedGhostWolf", "Interface/icons/spell_nature_spiritwolf", "|cffffffffLoup fantôme amélioré|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit le temps d'incantation de votre sort Loup fantôme de 2 secondes.|r", "spellimprovedghostwolf", 315, -405)
CreateSpellButton("buttonSpellImprovedShields", "Interface/icons/spell_nature_lightningshield", "|cffffffffBoucliers améliorés|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 15% les dégâts infligés par les orbes de votre Bouclier de foudre,\nde 15% la quantité de mana obtenue grâce aux orbes de votre Bouclier d'eau et de 15% la quantité de soins obtenus avec vos orbes de Bouclier de terre.|r", "spellimprovedshields", 422, -405)
CreateSpellButton("buttonSpellElementalWeapons", "Interface/icons/spell_fire_flametounge", "|cffffffffArmes élémentaires|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 40% les dégâts infligés par l'effet de votre Arme Furie-des-vents, de 30% les dégâts des sorts de votre Arme Langue de feu et de 30% le bonus aux soins de votre Arme Viveterre.|r", "spellelementalweapons", 43, -458)
CreateSpellButton("buttonSpellShamanisticFocus", "Interface/icons/spell_nature_elementalabsorption", "|cffffffffFocalisation chamanique|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit le coût en mana de vos Horions de 45%.|r", "spellshamanisticfocus", 150, -458)
CreateSpellButton("buttonSpellAnticipation", "Interface/icons/spell_nature_mirrorimage", "|cffffffffAnticipation|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 3% vos chances d'esquiver et réduit de 50% la durée de tous les effets de désarmement utilisés contre vous.\nNon cumulable avec les autres effets qui réduisent la durée du désarmement.|r", "spellanticipation", 260, -458)
CreateSpellButton("buttonSpellFlurry", "Interface/icons/ability_ghoulfrenzy", "|cffffffffRafale|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Lorsque vous infligez un coup critique, augmente votre vitesse d'attaque de 30% pour les 3 prochaines attaques.|r", "spellflurry", 368, -458)
CreateSpellButton("buttonSpellToughness", "Interface/icons/spell_holy_devotion", "|cffffffffRésistance|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente votre Endurance de 10% et réduit sur vous la durée des effets ralentissant le mouvement de 30%.|r", "spelltoughness", 478, -458)
CreateSpellButton("buttonSpellImprovedWindfuryTotem", "Interface/icons/spell_nature_windfury", "|cffffffffTotems Furie-des-vents améliorés|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente la hâte en mêlée de votre totem Furie-des-vents de 4%.|r", "spellimprovedwindfurytotem", 98, -510)
CreateSpellButton("buttonSpellSpiritWeapons", "Interface/icons/ability_parry", "|cffffffffArmes spirituelles|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Donne une chance de parer les attaques de mêlée des ennemis et réduit toute la menace générée de 30%.|r", "spellspiritweapons", 205, -510)
CreateSpellButton("buttonSpellMentalDexterity", "Interface/icons/spell_nature_bloodlust", "|cffffffffDextérité mentale|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente votre puissance d'attaque de 100% de votre Intelligence.|r", "spellmentaldexterity", 315, -510)
CreateSpellButton("buttonSpellUnleashedRage", "Interface/icons/spell_nature_unleashedrage", "|cffffffffRage libérée|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente votre expertise de 9, et augmente de 10% la puissance d'attaque de tous les membres du groupe ou du raid s'ils se trouvent à moins de 100 mètres du chaman.|r", "spellunleashedrage", 422, -510)


CreateSpellButton("buttonSpellWeaponMastery", "Interface/icons/ability_hunter_swiftstrike", "|cffffffffMaîtrise des armes|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 10% les dégâts que vous infligez avec toutes les armes.|r", "spellweaponmastery", 663, -75)
CreateSpellButton("buttonSpellFrozenPower", "Interface/icons/spell_fire_bluecano", "|cffffffffPuissance gelée|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 10% les dégâts infligés par vos sorts Eclair, Chaîne d'éclairs, Fouet de lave et Horion sur les cibles affectées par l'effet de votre Attaque Arme de givre,\net votre Horion de givre a 100% de chances d'immobiliser la cible dans la glace pendant 5 seconds.\nlorsqu'il est utilisé sur des cibles se trouvant à 15 mètres ou plus de vous.|r", "spellfrozenpower", 770, -75)
CreateSpellButton("buttonSpellDualWieldSpecialization", "Interface/icons/ability_dualwieldspecialization", "|cffffffffSpécialisation Ambidextrie|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 6% supplémentaires vos chances de toucher lorsque vous portez deux armes.|r", "spelldualwieldspecialization", 880, -75)
CreateSpellButton("buttonSpellDualWield", "Interface/icons/ability_dualwield", "|cffffffffAmbidextrie|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Permet d'équiper les armes à une main dans la main gauche.|r", "spelldualwield", 990, -75)
CreateSpellButton("buttonSpellStormstrike", "Interface/icons/ability_shaman_stormstrike", "|cffffffffFrappe-tempête|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Attaque instantanément avec les deux armes.\nDe plus, les 4 prochaines sources de dégâts de Nature infligés à la cible par le chaman sont augmentées de 20%.\nDure 12 secondes.|r", "spellstormstrike", 1100, -75)
CreateSpellButton("buttonSpellStaticShock", "Interface/icons/spell_shaman_staticshock", "|cffffffffHorion statique|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Vous avez 6% de chances de toucher votre cible avec une charge d'orbe de Bouclier de foudre quand vous infligez des dégâts avec des attaques et techniques de mêlée,\net votre Bouclier de foudre gagne 6 charges supplémentaires.|r", "spellstaticshock", 718, -130)
CreateSpellButton("buttonSpellLavaLash", "Interface/icons/ability_shaman_lavalash", "|cffffffffFouet de lave|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Vous chargez votre arme en main gauche de lave, infligeant instantanément 100% des dégâts de l'arme en main gauche.\nLes dégâts sont augmentés de 25% si votre arme en main gauche est enchantée avec Langue de feu.|r", "spelllavalash", 825, -130)
CreateSpellButton("buttonSpellImprovedStormstrike", "Interface/icons/spell_shaman_improvedstormstrike", "|cffffffffFrappe-tempête amélioré|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Quand vous utilisez Frappe-tempête, vous avez 100% de chances de recevoir immédiatement 20% de votre mana de base.|r", "spellimprovedstormstrike", 935, -130)
CreateSpellButton("buttonSpellMentalQuickness", "Interface/icons/spell_nature_mentalquickness", "|cffffffffRapidité mentale|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit le coût en mana de vos sorts instantanés de chaman de 6% et augmente la puissance de vos sorts d'un montant égal à 30% de votre puissance d'attaque.|r", "spellmentalquickness", 1045, -130)
CreateSpellButton("buttonSpellShamanisticRage", "Interface/icons/spell_nature_shamanrage", "|cffffffffRage du chaman|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit tous les dégâts subis de 30% et donne à vos attaques en mêlée réussies une chance de régénérer un montant de mana égal à 15% de votre puissance d'attaque.\nCe sort peut être utilisé alors que vous êtes étourdi.\nDure 15 secondes.|r", "spellshamanisticrage", 663, -184)
CreateSpellButton("buttonSpellEarthenPower", "Interface/icons/spell_nature_earthelemental_totem", "|cffffffffPuissance terrestre|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Votre Totem de lien terrestre a 100% de chances à chacune de ses pulsations d'enlever tous les effets de ralentissement sur vous ainsi que sur les cibles alliées proches,\net votre Horion de terre réduit la vitesse d'attaque des ennemis de 10% supplémentaires.|r", "spellearthenpower", 770, -184)
CreateSpellButton("buttonSpellMaelstromWeapon", "Interface/icons/spell_shaman_maelstromweapon", "|cffffffffArme du Maelström|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Quand vous infligez des dégâts avec une arme de mêlée, vous avez une chance (plus élevée qu'au rang 4) de réduire le temps d'incantation de votre prochain sort\nEclair, Chaîne d'éclairs, Vague de soins inférieurs, Salve de guérison, Vague de soins ou Maléfice de 20%.\nCumulable jusqu'à 5 fois.\nDure 30 secondes.|r", "spellmaelstromweapon", 880, -184)
CreateSpellButton("buttonSpellFeralSpirit", "Interface/icons/spell_shaman_feralspirit", "|cffffffffEsprit farouche|r\n|cffffffffTalent|r |cffff8c1aAmélioration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Invoque deux Esprits du loup qui obéissent au chaman.\nDure 45 secondes.|r", "spellferalspirit", 990, -184)
CreateSpellButton("buttonSpellImprovedHealingWave", "Interface/icons/spell_nature_magicimmunity", "|cffffffffVague de soins améliorée|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit le temps d'incantation de votre sort Vague de soins de 0,5 secondes.", "spellimprovedhealingwave", 1100, -184)



CreateSpellButton("buttonSpellTotemicFocus", "Interface/icons/spell_nature_moonglow", "|cffffffffFocalisation totémique|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit le coût en mana de vos totems de 25%.|r", "spelltotemicfocus", 718, -240)
CreateSpellButton("buttonSpellImprovedReincarnation", "Interface/icons/spell_nature_reincarnation", "|cffffffffRéincarnation améliorée|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit le temps de recharge de votre sort Réincarnation de 15 min.\net augmente les montants de points de vie et de mana avec lesquels vous vous réincarnez de 20% supplémentaires.|r", "spellimprovedreincarnation", 825, -240)
CreateSpellButton("buttonSpellHealingGrace", "Interface/icons/spell_nature_healingtouch", "|cffffffffGrâce guérisseuse|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Diminue le niveau de menace généré par vos sorts de soins de 15% et réduit la probabilité que vos sorts utiles et vos effets de dégâts sur la durée soient dissipés de 30%.|r", "spellhealinggrace", 935, -240)
CreateSpellButton("buttonSpellTidalFocus", "Interface/icons/spell_frost_manarecharge", "|cffffffffFocalisation des flots|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit de 5% le coût en mana de vos sorts de soins.|r", "spelltidalfocus", 1045, -240)
CreateSpellButton("buttonSpellImprovedWaterShield", "Interface/icons/ability_shaman_watershield", "|cffffffffBouclier d'eau amélioré|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Vous avez 100% de chances de recevoir instantanément du mana comme si vous consommiez un orbe de Bouclier d'eau quand vous obtenez un effet critique avec vos sorts Vague de soins ou Remous,\n0.6% de chances quand vous obtenez un effet critique avec votre sort Vague de soins inférieurs, et 0.3% de chances quand vous obtenez un effet critique avec votre sort Salve de guérison.|r", "spellimprovedwatershield", 663, -293)
CreateSpellButton("buttonSpellHealingFocus", "Interface/icons/spell_nature_healingwavelesser", "|cffffffffFocalisation des soins|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit de 70% l'interruption causée par les attaques infligeant des dégâts pendant que vous incantez tout sort de soins de chaman.|r", "spellhealingfocus", 770, -293)
CreateSpellButton("buttonSpellTidalForce", "Interface/icons/spell_frost_frostbolt", "|cffffffffForce des flots|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente les chances d'obtenir un effet critique avec vos sorts Vague de soins, Vague de soins inférieurs et Salve de guérison de 60%.\nChaque soin critique réduit les chances de 20%.\nDure 20 secondes.|r", "spelltidalforce", 990, -293)
CreateSpellButton("buttonSpellAncestralHealing", "Interface/icons/spell_nature_undyingstrength", "|cffffffffGuérison des anciens|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit de 10% les dégâts physiques subis par votre cible pendant 15 secondes.\naprès avoir reçu un effet critique de l'un de vos sorts de soins.|r", "spellancestralhealing", 1100, -293)
CreateSpellButton("buttonSpellRestorativeTotems", "Interface/icons/spell_nature_manaregentotem", "|cffffffffTotems de restauration|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 20% les effets de votre Totem Fontaine de mana et augmente de 45% le montant de points de vie rendus par votre Totem guérisseur.|r", "spellrestorativetotems", 718, -348)
CreateSpellButton("buttonSpellTidalMastery", "Interface/icons/spell_nature_tranquility", "|cffffffffMaîtrise des flots|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente les chances d'obtenir un effet critique avec vos sorts de soins et d'éclair de 5%.|r", "spelltidalmastery", 825, -348)
CreateSpellButton("buttonSpellHealingWay", "Interface/icons/spell_nature_healingway", "|cffffffffFlots de soins|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente le montant de points de vie rendus par votre sort Vague de soins de 25%.|r", "spellhealingway", 935, -348)
CreateSpellButton("buttonSpellNaturesSwiftness", "Interface/icons/spell_nature_ravenform", "|cffffffffRapidité de la nature|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Lorsque cette technique est activée, votre prochain sort de Nature dont le temps d'incantation de base est inférieur à 10 sec.\ndevient un sort instantané.\nRapidité de la nature partage le temps de recharge de Maîtrise élémentaire.|r", "spellnaturesswiftness", 1045, -348)
CreateSpellButton("buttonSpellFocusedMind", "Interface/icons/spell_nature_focusedmind", "|cffffffffEsprit focalisé|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Réduit de 30% la durée de tous les effets de silence ou d'interruption utilisés contre le chaman.\nCet effet ne se cumule pas avec d'autres effets similaires.|r", "spellfocusedmind", 663, -402)
CreateSpellButton("buttonSpellPurification", "Interface/icons/spell_frost_wizardmark", "|cffffffffPurification|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 10% l'efficacité de vos sorts de soins.|r", "spellpurificatione", 770, -402)
CreateSpellButton("buttonSpellNaturesGuardian", "Interface/icons/spell_nature_natureguardian", "|cffffffffGardien de la nature|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Chaque fois qu'une attaque vous inflige des dégâts qui vous font passer sous les 30% de points de vie, votre maximum de points de vie augmente de 15% pendant 10 secondes.\net votre niveau de menace envers cette cible est réduit.\nTemps de recharge de 30 secondes.|r", "spellnaturesguardian", 880, -402)
CreateSpellButton("buttonSpellManaTideTotem", "Interface/icons/spell_frost_summonwaterelemental", "|cffffffffTotem de vague de mana|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Invoque aux pieds du lanceur de sorts un Totem de vague de mana pendant 21 sec.\nIl dispose d'un montant de points de vie égal à 10% de ceux du lanceur et rend 6% du total de mana toutes les 3 secondes aux membres du groupe qui se trouvent à moins de 30 mètres.|r", "spellmanatidetotem", 990, -402)
CreateSpellButton("buttonSpellCleanseSpirit", "Interface/icons/ability_shaman_cleansespirit", "|cffffffffPurifier l'esprit|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Purifie l'esprit d'une cible alliée en annulant 1 effet de poison, 1 effet de maladie et 1 effet de malédiction.|r", "spellcleansespirit", 1100, -402)
CreateSpellButton("buttonSpellBlessingoftheEternals", "Interface/icons/spell_shaman_blessingofeternals", "|cffffffffBénédiction des Eternels|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente les chances d'effet critique de vos sorts de 4% et augmente les chances d'appliquer l'effet de soins sur la durée de Viveterre de 80% quand la cible dispose de 35% ou moins de ses points de vie.|r", "spellblessingoftheeternals", 718, -456)
CreateSpellButton("buttonSpellImprovedChainHeal", "Interface/icons/spell_nature_healingwavegreater", "|cffffffffSalve de guérison améliorée|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente de 20% le montant de points de vie rendus par votre sort Salve de guérison.|r", "spellimprovedchainheal", 825, -456)
CreateSpellButton("buttonSpellNaturesBlessing", "Interface/icons/spell_nature_natureblessing", "|cffffffffBénédiction de la nature|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente vos soins d'un montant égal à 15% de votre Intelligence.|r", "spellnaturesblessing", 935, -456)
CreateSpellButton("buttonSpellAncestralAwakening", "Interface/icons/spell_shaman_ancestralawakening", "|cffffffffEveil ancestral|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Quand vous réussissez des soins critiques avec Vague de soins, Vague de soins inférieurs ou Remous, vous invoquez un Esprit ancestral à votre aide.\nIl rend instantanément à la cible alliée membre du groupe ou raid dans un rayon de 40 mètres dont le pourcentage de points de vie est le plus bas 30% du montant soigné.|r", "spellancestralawakening", 1045, -456)
CreateSpellButton("buttonSpellEarthShield", "Interface/icons/spell_nature_skinofearth", "|cffffffffBouclier de terre|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Protège la cible avec un bouclier de terre, qui réduit de 30% le temps d'incantation ou de canalisation de sort perdu quand elle subit des dégâts.\nLes attaques rendent 150 points de vie à la cible protégée.\nCet effet ne peut se produire qu’une fois toutes les quelques secondes.\n6 charges.\nDure 10 mn.\nBouclier de terre ne peut être placé que sur une cible à la fois et un seul Bouclier élémentaire peut être actif sur une cible à la fois.|r", "spellearthshield", 663, -510)
CreateSpellButton("buttonSpellImprovedEarthShield", "Interface/icons/spell_nature_skinofearth", "|cffffffffBouclier de terre amélioré|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Augmente le nombre de charges de votre Bouclier de terre de 2, et augmente les soins prodigués par votre Bouclier de terre de 10%.|r", "spellimprovedearthshield", 770, -510)
CreateSpellButton("buttonSpellTidalWaves", "Interface/icons/spell_shaman_tidalwaves", "|cffffffffRaz-de-marée|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Vous avez 100% de chances après avoir lancé Salve de guérison ou Remous de réduire le temps d'incantation de votre sort Vague de soins de 30% et d'augmenter les chances d'effet critique de votre sort\nVague de soins inférieurs de 25% jusqu'à ce que deux de ces sorts aient été lancés.\nDe plus, votre Vague de soins bénéficie de 20% supplémentaires des effets du bonus relatif aux soins et votre Vague de soins inférieurs de 10% supplémentaires des effets du bonus relatif aux soins.|r", "spelltidalwaves", 880, -510)
CreateSpellButton("buttonSpellRiptide", "Interface/icons/spell_nature_riptide", "|cffffffffRemous|r\n|cffffffffTalent|r |cff0cf200Restauration|r\n|cffffffffRequiert|r |cff0070deChaman|r\n|cffffd100Rend à une cible alliée 639 à 691 points de vie plus 665 points de vie en 15 seconds.\nVotre prochaine Salve de guérison lancée sur cette cible primaire dans les 15 seconds consommera l'effet de soins sur la durée et augmentera le montant de soins de votre Salve de guérison de 25%.|r", "spellriptide", 990, -510)



local resetButtonClicked = false

local buttonReset = CreateFrame("Button", "buttonReset", frameTalentShaman, "UIPanelButtonTemplate")
buttonReset:SetSize(85, 25)
buttonReset:SetPoint("BOTTOMRIGHT", buttonTalentShamanClose, "BOTTOMLEFT", -95, 5)
buttonReset:SetText("Réinitialiser")

local function ResetTalents()
    AIO.Handle("TalentShamanspell", "ResetTalents")
    resetButtonClicked = true
end

buttonReset:SetScript("OnClick", ResetTalents)

local buttonReload = CreateFrame("Button", "buttonReload", frameTalentShaman, "UIPanelButtonTemplate")
buttonReload:SetSize(85, 25)
buttonReload:SetPoint("BOTTOMRIGHT", buttonTalentShamanClose, "BOTTOMLEFT", -5, 5)
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
        frameTalentShaman:Hide()
        buttonReload:Hide()
        PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
    else
        frameTalentShaman:Show()
        buttonReload:Show()
        PlaySoundFile(OPEN_TALENT_WINDOW_SOUND)
    end

    talentsWindowOpen = not talentsWindowOpen
end

local playerClass = select(2, UnitClass("player"))
if playerClass == "SHAMAN" then
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
        GameTooltip:SetText("|cffffffffTalents|r |cff0070de(Chaman)|r\n\nL'éventail des talents disponibles\npour améliorer et spécialiser\nvotre personnage.")
        GameTooltip:Show()
    end)

    buttonOuvrirTalents:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    buttonOuvrirTalents:SetScript("OnClick", OuvrirFermerInterfaceTalents)
    TalentMicroButton:Hide()
end

ShamanHandlers.UpdateTalentCount = function(player, talentsAppris)
    if fontTalentShamanFrameText then
        fontTalentShamanFrameText:SetText(talentsAppris .. " / " .. MAX_TALENTS)
    end
end

ShamanHandlers.UpdateTalentPointsUsed = function(player, pointsUsed, pointsBeforeReset)
    print("|cff00ffffVous avez utilisés " .. pointsBeforeReset .. " points avant la réinitialisation des talents|r")
end