local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local PriestHandlers = AIO.AddHandlers("TalentPriestspell", {})

function PriestHandlers.ShowTalentPriest(player)
    frameTalentPriest:Show()
end

local MAX_TALENTS = 42

local OPEN_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_final_trait_unlocked.ogg"
local CLOSE_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_trait_refund_end.ogg"
local SPELL_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_80_azeritearmor_rotationends_02.ogg"

local frameTalentPriest = CreateFrame("Frame", "frameTalentPriest", UIParent)
frameTalentPriest:SetSize(1200, 650)
frameTalentPriest:SetMovable(true)
frameTalentPriest:EnableMouse(true)
frameTalentPriest:RegisterForDrag("LeftButton")
frameTalentPriest:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
frameTalentPriest:SetBackdrop(
{
    bgFile = "interface/TalentFrame/Template/Class/Priest/talentsclassbackgroundpriest",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedpriest",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

local priestIcon = frameTalentPriest:CreateTexture("PriestIcon", "OVERLAY")
priestIcon:SetTexture("Interface\\TalentFrame\\Template\\Class\\Priest\\IconePriest.blp")
priestIcon:SetSize(60, 60)
priestIcon:SetPoint("TOPLEFT", frameTalentPriest, "TOPLEFT", -10, 10)


local textureone = frameTalentPriest:CreateTexture("TemplateTalentFrame", "OVERLAY")
textureone:SetTexture("Interface\\TalentFrame\\Template\\Class\\Priest\\TalentFrameTemplate.blp")
textureone:SetSize(928, 928)
textureone:SetPoint("TOPLEFT", frameTalentPriest, "TOPLEFT", -170, 140)

frameTalentPriest:SetFrameLevel(100)

local texturetwo = frameTalentPriest:CreateTexture("TemplateTalentFrame", "OVERLAY")
texturetwo:SetTexture("Interface\\TalentFrame\\Template\\Class\\Priest\\TalentFrameTemplateOriginal.blp")
texturetwo:SetSize(928, 928)
texturetwo:SetPoint("TOPRIGHT", frameTalentPriest, "TOPRIGHT", 170, 140)

frameTalentPriest:SetFrameLevel(100)

frameTalentPriest:SetScript("OnDragStart", frameTalentPriest.StartMoving)
frameTalentPriest:SetScript("OnHide", frameTalentPriest.StopMovingOrSizing)
frameTalentPriest:SetScript("OnDragStop", frameTalentPriest.StopMovingOrSizing)
frameTalentPriest:Hide()

frameTalentPriest:SetBackdropBorderColor(255, 255, 255)

local buttonTalentPriestClose = CreateFrame("Button", "buttonTalentPriestClose", frameTalentPriest, "UIPanelCloseButton")
buttonTalentPriestClose:SetPoint("TOPRIGHT", -12, -12)
buttonTalentPriestClose:EnableMouse(true)
buttonTalentPriestClose:SetSize(32, 32)

local function CloseTalentWindow()
    frameTalentPriest:Hide()
    PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
end

buttonTalentPriestClose:SetScript("OnClick", CloseTalentWindow)

local frameTalentPriestTitleBar = CreateFrame("Frame", "frameTalentPriestTitleBar", frameTalentPriest, nil)
frameTalentPriestTitleBar:SetSize(135, 25)
frameTalentPriestTitleBar:SetBackdrop(
{
    bgFile = "interface/corrupteditems/corruptedtooltipbackground",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedpriest",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameTalentPriestTitleBar:SetPoint("TOP", 0, 20)

local fontTalentPriestTitleText = frameTalentPriestTitleBar:CreateFontString("fontTalentPriestTitleText")
fontTalentPriestTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontTalentPriestTitleText:SetSize(190, 5)
fontTalentPriestTitleText:SetPoint("CENTER", 0, 0)
fontTalentPriestTitleText:SetText("|cffFFC125Talents|r")

local fontTalentPriestFrameText = frameTalentPriestTitleBar:CreateFontString("fontTalentPriestFrameText")
fontTalentPriestFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentPriestFrameText:SetSize(200, 5)
fontTalentPriestFrameText:SetPoint("TOPLEFT", frameTalentPriestTitleBar, "BOTTOMLEFT", -30, -35)
fontTalentPriestFrameText:SetText("|cffFFC125Prêtre|r")

local fontTalentPriestFrameText = frameTalentPriestTitleBar:CreateFontString("fontTalentPriestFrameText")
fontTalentPriestFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentPriestFrameText:SetSize(200, 5)
fontTalentPriestFrameText:SetPoint("TOPLEFT", frameTalentPriestTitleBar, "BOTTOMLEFT", -30, -60)
fontTalentPriestFrameText:SetText("0 / " .. MAX_TALENTS)



local function CreateSpellButton(name, texturePath, tooltipText, talentHandler, positionX, positionY)
    local buttonClicked = false
    local talentLearned = false

    local button = CreateFrame("Button", name, frameTalentPriest, nil)
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
                AIO.Handle("TalentPriestspell", talentHandler, 1)
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






CreateSpellButton("buttonSpellUnbreakableWill", "Interface/icons/spell_magic_magearmor", "|cffffffffVolonté inflexible|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit la durée des effets d'étourdissement, de peur et de silence contre vous de 30% supplémentaires.|r", "spellunbreakablewill", 100, -80)
CreateSpellButton("buttonSpellTwinDisciplines", "Interface/icons/spell_holy_sealofvengeance", "|cffffffffDisciplines jumelles|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente de 5% les dégâts et les soins produits par vos sorts instantanés.|r", "spelltwindisciplines", 205, -75)
CreateSpellButton("buttonSpellSilentResolve", "Interface/icons/spell_nature_manaregentotem", "|cffffffffRésolution silencieuse|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Diminue la menace générée par vos sorts du Sacré et de Discipline de 20% et réduit la probabilité que vos sorts bénéfiques et effets de dégâts sur la durée soient dissipés de 30%.|r", "spellsilentresolve", 315, -75)
CreateSpellButton("buttonSpellImprovedInnerFire", "Interface/icons/spell_holy_innerfire", "|cffffffffFeu intérieur amélioré|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente l'effet de votre sort Feu intérieur de 45% et augmente son nombre total de charges de 12.|r", "spellimprovedinnerfire", 418, -80)
CreateSpellButton("buttonSpellImprovedPowerWordFortitude", "Interface/icons/spell_holy_wordfortitude", "|cffffffffMot de pouvoir : Robustesse amélioré|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente les effets de vos sorts Mot de pouvoir : Robustesse et Prière de robustesse de 30%, en plus d'augmenter votre total d'Endurance de 4%.|r", "spellimprovedpowerwordfortitude", 45, -130)
CreateSpellButton("buttonSpellMartyrdom", "Interface/icons/spell_nature_tranquility", "|cffffffffMartyre|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Vous confère 100% de chances de bénéficier de l'effet Incantation focalisée pendant 6 seconds après avoir été victime d'un coup critique en mêlée ou à distance.\nCet effet réduit les interruptions causées par les attaques infligeant des dégâts pendant l'incantation de sorts de prêtre et réduit la durée des effets d'interruption de 20%.|r", "spellmartyrdom", 150, -130)
CreateSpellButton("buttonSpellMeditation", "Interface/icons/spell_nature_sleep", "|cffffffffMéditation|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Vous confère 50% de votre vitesse de récupération du mana normale pendant l'incantation.|r", "spellmeditation", 260, -130)
CreateSpellButton("buttonSpellInnerFocus", "Interface/icons/spell_frost_windwalkon", "|cffffffffFocalisation améliorée|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Lorsqu'elle est activée, cette technique réduit de 100% le coût en mana de votre prochain sort et augmente ses chances d'infliger un effet critique de 25%, si ce sort peut avoir un effet critique.|r", "spellinnerfocus", 370, -130)
CreateSpellButton("buttonSpellImprovedPowerWordShield", "Interface/icons/spell_holy_powerwordshield", "|cffffffffMot de pouvoir : Bouclier amélioré|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente les dégâts absorbés par votre Mot de pouvoir : Bouclier de 15%.|r", "spellimprovedpowerwordshield", 475, -133)
CreateSpellButton("buttonSpellAbsolution", "Interface/icons/spell_holy_absolution", "|cffffffffAbsolution|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit le coût en mana de vos sorts Dissipation de la magie, Guérison des maladies, Abolir maladie et Dissipation de masse de 15%.|r", "spellabsolution", 96, -185)
CreateSpellButton("buttonSpellMentalAgility", "Interface/icons/ability_hibernation", "|cffffffffSagacité|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit le coût en mana de vos sorts instantanés de 10%.|r", "spellmentalagility", 205, -185)
CreateSpellButton("buttonSpellImprovedManaBurn", "Interface/icons/spell_shadow_manaburn", "|cffffffffBrûlure de mana améliorée|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit le temps d'incantation du sort Brûlure de mana de 1 seconde.|r", "spellimprovedmanaburn", 315, -185)
CreateSpellButton("buttonSpellReflectiveShield", "Interface/icons/spell_holy_powerwordshield", "|cffffffffBouclier réflecteur|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Renvoie 45% des dégâts que vous absorbez avec votre Mot de pouvoir : Bouclier à l'attaquant.\nCes dégâts ne génèrent pas de menace.|r", "spellreflectiveshield", 422, -185)
CreateSpellButton("buttonSpellMentalStrength", "Interface/icons/spell_nature_enchantarmor", "|cffffffffForce mentale|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente votre total d'Intelligence de 15%.|r", "spellmentalstrength", 527, -190)
CreateSpellButton("buttonSpellSoulWarding", "Interface/icons/spell_holy_pureofheart", "|cffffffffProtection de l'âme|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit le temps de recharge de votre technique Mot de pouvoir : Bouclier de 4 sec.\net réduit son coût en mana de 15%.", "spellsoulwarding", 43, -240)
CreateSpellButton("buttonSpellFocusedPower", "Interface/icons/spell_shadow_focusedpower", "|cffffffffPuissance focalisée|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente les dégâts et les soins produits par vos sorts de 4%.\nDe plus, le temps d'incantation de Dissipation de masse est réduit de 1 seconde.|r", "spellfocusedpower", 150, -240)
CreateSpellButton("buttonSpellEnlightenment", "Interface/icons/spell_arcane_mindmastery", "|cffffffffIllumination|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente votre total d'Esprit de 6% et augmente votre hâte des sorts de 6%.|r", "spellenlightenment", 368, -240)
CreateSpellButton("buttonSpellFocusedWill", "Interface/icons/spell_arcane_focusedpower", "|cffffffffVolonté focalisée|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente les chances d'effet critique de vos sorts de 3%, et après avoir subi un coup critique, vous bénéficiez de l'effet Volonté focalisée,\nqui réduit tous les dégâts subis de 4% et augmente les effets des soins sur vous de 5%.\nCumulable jusqu'à 3 fois.\nDure 8 secondes.|r", "spellfocusedwill", 478, -240)
CreateSpellButton("buttonSpellPowerInfusion", "Interface/icons/spell_holy_powerinfusion", "|cffffffffInfusion de puissance|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Imprègne la cible de puissance, ce qui augmente la vitesse d'incantation des sorts de 20% et réduit le coût en mana de tous les sorts de 20%.\nDure 15 secondes.|r", "spellpowerinfusion", 98, -293)
CreateSpellButton("buttonSpellImprovedFlashHeal", "Interface/icons/spell_holy_chastise", "|cffffffffSoins rapides améliorés|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit le coût en mana de vos Soins rapides de 15% et augmente leurs chances d'effet critique de 10% sur les cibles alliées ne disposant que de 50% ou moins de leurs points de vie.|r", "spellimprovedflashheal", 205, -293)
CreateSpellButton("buttonSpellRenewedHope", "Interface/icons/spell_holy_holyprotection", "|cffffffffRegain d'espoir|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente les chances d'effet critique de vos sorts Soins rapides, Soins supérieurs et Pénitence (soins) de 4% sur les cibles affectées par l'effet Ame affaiblie,\net vous avez 100% de chances de réduire tous les dégâts subis par tous les membres alliés du groupe et du raid de 3% pendant 60 secondes quand vous lancez Mot de pouvoir : Bouclier.\nCet effet a un temps de recharge de 15 sec.|r", "spellrenewedhope", 315, -293)
CreateSpellButton("buttonSpellRapture", "Interface/icons/spell_holy_rapture", "|cffffffffExtase|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Quand votre Mot de pouvoir : Bouclier est complètement absorbé ou dissipé, vous recevez instantanément 2,5% de votre total de mana,\net vous avez 100% de chances de donner à la cible protégée 2% de son total de mana, 8 points de rage, 16 points d'énergie ou 32 points de puissance runique.\nCet effet ne peut se produire plus d'une fois toutes les 12 secondes.|r", "spellrapture", 422, -293)
CreateSpellButton("buttonSpellAspiration", "Interface/icons/spell_holy_aspiration", "|cffffffffAspiration|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit le temps de recharge de vos sorts Focalisation améliorée, Infusion de puissance, Suppression de la douleur et Pénitence de 20%.|r", "spellaspiration", 527, -295)
CreateSpellButton("buttonSpellDivineAegis", "Interface/icons/spell_holy_devineaegis", "|cffffffffEgide divine|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Les soins critiques créent un bouclier de protection autour de la cible, qui absorbe un montant de dégâts égal à 30% des soins reçus.\nDure 12 secondes.|r", "spelldivineaegis", 43, -350)
CreateSpellButton("buttonSpellPainSuppression", "Interface/icons/spell_holy_painsupression", "|cffffffffSuppression de la douleur|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit instantanément la menace d'une cible alliée de 5%, réduit tous les dégâts subis de 40% et augmente la résistance aux mécanismes de Dissipation de 65% pendant 8 secondes.|r", "spellpainsuppression", 150, -350)
CreateSpellButton("buttonSpellGrace|r", "Interface/icons/spell_holy_hopeandgrace", "|cffffffffGrâce|r\n|cffffffffTalent|r |cffffffbfDiscipline|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Vos sorts Soins rapides, Soins supérieurs et Pénitence ont 100% de chances de donner la Grâce à la cible, ce qui augmente tous les soins que lui prodigue le prêtre de 3%.\nCet effet est cumulable jusqu'à 3 fois et dure 15 secondes.\nGrâce ne peut être active que sur une cible à la fois.|r", "spellgrace", 260, -350)
CreateSpellButton("buttonSpellBorrowedTime", "Interface/icons/spell_holy_borrowedtime", "|cffffffffSursis|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Fait bénéficier votre prochain sort de 25% de hâte des sorts supplémentaire après avoir lancé Mot de pouvoir : Bouclier,\net augmente les dégâts absorbés par votre Mot de pouvoir : Bouclier d'un montant égal à 40% de votre puissance des sorts.|r", "spellborrowedtime", 368, -350)
CreateSpellButton("buttonSpellPenance", "Interface/icons/spell_holy_penance", "|cffffffffPénitence|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Lance une salve de lumière sacrée sur la cible et inflige 240 points de dégâts du Sacré à un ennemi ou rend 670 à 756 points de vie à un allié instantanément et toutes les 1 sec.\npendant 2 secondes.|r", "spellpenance", 478, -350)


CreateSpellButton("buttonSpellHealingFocus", "Interface/icons/spell_holy_healingfocus", "|cffffffffFocalisation des soins|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit de 70% l'interruption causée par les attaques infligeant des dégâts pendant que vous incantez tout sort de soins.|r", "spellhealingfocus", 98, -405)
CreateSpellButton("buttonSpellImprovedRenew", "Interface/icons/spell_holy_renew", "|cffffffffRénovation améliorée|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente de 15% le montant de points de vie rendus par votre sort Rénovation.|r", "spellimprovedrenew", 205, -405)
CreateSpellButton("buttonSpellHolySpecialization", "Interface/icons/spell_holy_sealofsalvation", "|cffffffffSpécialisation (Sacré)|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente les chances d'obtenir un effet critique avec vos sorts du Sacré de 5%.|r", "spellholyspecialization", 315, -405)
CreateSpellButton("buttonSpellSpellWarding", "Interface/icons/spell_holy_spellwarding", "|cffffffffProtection contre les sorts|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit tous les dégâts des sorts subis de 10%.|r", "spellspellwarding", 422, -405)
CreateSpellButton("buttonSpellDivineFury", "Interface/icons/spell_holy_sealofwrath", "|cffffffffFureur divine|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit le temps d'incantation de vos sorts Châtiment, Flammes sacrées, Soins et Soins supérieurs de 0,5 sec.|r", "spelldivinefury", 43, -458)
CreateSpellButton("buttonSpellDesperatePrayer", "Interface/icons/spell_holy_restoration", "|cffffffffPrière du désespoir|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Rend instantanément 263 à 325 points de vie au lanceur de sorts.|r", "spelldesperateprayer", 150, -458)
CreateSpellButton("buttonSpellBlessedRecovery", "Interface/icons/spell_holy_blessedrecovery", "|cffffffffRétablissement béni|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Lorsque vous avez été frappé par un coup critique en mêlée ou à distance, Rétablissement béni vous rend 15% des points de dégâts subis en 6 seconds.\nLes coups critiques supplémentaires subis pendant l'effet augmentent les soins reçus.|r", "spellblessedrecovery", 260, -458)
CreateSpellButton("buttonSpellInspiration", "Interface/icons/spell_holy_layonhands", "|cffffffffInspiration|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit de 10% les dégâts physiques subis par votre cible pendant 15 secondes.\naprès avoir reçu un effet critique de l'un des sorts suivants : Soins rapides, Soins, Soins supérieurs, Soins de lien, Pénitence, Prière de guérison, Prière de soins ou Cercle de soins.|r", "spellinspiration", 368, -458)
CreateSpellButton("buttonSpellHolyReach", "Interface/icons/spell_holy_purify", "|cffffffffAllonge du Sacré|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente de 20% la portée de vos sorts Châtiment et Flammes sacrées et le rayon d'effet de vos sorts Prière de soins, Nova sacrée, Hymne divin et Cercle de soins.|r", "spellholyreach", 478, -458)
CreateSpellButton("buttonSpellImprovedHealing", "Interface/icons/spell_holy_heal02", "|cffffffffSoin amélioré|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit le coût en mana de vos sorts Soins inférieurs, Soins, Soins supérieurs, Hymne divin et Pénitence de 15%.|r", "spellimprovedhealing", 98, -510)
CreateSpellButton("buttonSpellSearingLight", "Interface/icons/spell_holy_searinglightpriest", "|cffffffffLumière incendiaire|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente de 10% les dégâts infligés par vos sorts Châtiment, Flammes sacrées, Nova sacrée et Pénitence.|r", "spellsearinglight", 205, -510)
CreateSpellButton("buttonSpellHealingPrayers", "Interface/icons/spell_holy_prayerofhealing02", "|cffffffffPrières guérisseuses|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit le coût en mana de vos sorts Prière de soins et Prière de guérison de 20%.|r", "spellhealingprayers", 315, -510)
CreateSpellButton("buttonSpellSpiritofRedemption", "Interface/icons/inv_enchant_essenceeternallarge", "|cffffffffEsprit de rédemption|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente le total d'Esprit de 5%, et au moment de sa mort, le prêtre devient l'Esprit de rédemption pendant 15 secondes.\nL'Esprit de rédemption ne peut pas se déplacer ou attaquer, ni être attaqué ou ciblé par aucun sort ou effet.\nTant qu'il est sous cette forme, le prêtre peut lancer tout sort de soins sans le moindre coût.\nÀ la fin de l'effet, le prêtre meurt.|r", "spellspiritofredemption", 422, -510)


CreateSpellButton("buttonSpellSpiritualGuidance", "Interface/icons/spell_holy_spiritualguidence", "|cffffffffDirection spirituelle|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente la puissance des sorts d'un montant égal à 25% de votre Esprit total.|r", "spellspiritualguidance", 663, -75)
CreateSpellButton("buttonSpellSurgeofLight", "Interface/icons/spell_holy_surgeoflight", "|cffffffffVague de Lumière|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Vos coups critiques avec les sorts confèrent 50% de chances à votre prochain sort Châtiment ou Soins rapides d'être instantané et de ne pas coûter de mana, mais sans pouvoir être un coup critique.\nCet effet dure 10 secondes.|r", "spellsurgeoflight", 770, -75)
CreateSpellButton("buttonSpellSpiritualHealing", "Interface/icons/spell_nature_moonglow", "|cffffffffSoins spirituels|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente le montant de points de vie rendus par vos sorts de soins de 10%.|r", "spellspiritualsealing", 880, -75)
CreateSpellButton("buttonSpellHolyConcentration", "Interface/icons/spell_holy_fanaticism", "|cffffffffConcentration sacrée|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Votre régénération de mana due à l'Esprit est augmentée de 50% pendant 8 seconds.\naprès avoir réussi des soins critiques avec Soins rapides, Soins supérieurs, Soins de lien ou Rénovation surpuissante.|r", "spellholyconcentration", 990, -75)
CreateSpellButton("buttonSpellLightwell", "Interface/icons/spell_holy_summonlightwell", "|cffffffffPuits de lumière|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Crée un Puits de lumière sacré.\nLes joueurs alliés peuvent cliquer sur le Puits de lumière pour recevoir 801 points de vie en 6 secondes.\nL'effet est annulé si vous subissez des dégâts égaux à 30% de votre total de points de vie.\nLa durée du Puits de lumière est de 3 mn ou bien 10 utilisations.|r", "spelllightwell", 1100, -75)
CreateSpellButton("buttonSpellBlessedResilience", "Interface/icons/spell_holy_blessedresillience", "|cffffffffRésilience bénie|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente l'efficacité de vos sorts de soins de 3%, et les coups critiques contre vous ont 60% de chances de vous empêcher d'être à nouveau frappé par un coup critique pendant 6 secondes.|r", "spellblessedresilience", 718, -130)
CreateSpellButton("buttonSpellBodyandSoul", "Interface/icons/spell_holy_symbolofhope", "|cffffffffCorps et âme|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Quand vous lancez Mot de pouvoir : Bouclier, vous augmentez la vitesse de déplacement de la cible de 60% pendant 4 secondes.,\net vous avez 100% de chances lorsque vous lancez Abolir maladie sur vous-même d'également dissiper 1 effet de poison en plus des maladies.|r", "spellbodyandsoul", 825, -130)
CreateSpellButton("buttonSpellEmpoweredHealing", "Interface/icons/spell_holy_greaterheal", "|cffffffffSoins surpuissants|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Votre sort Soins supérieurs bénéficie de 40% supplémentaires, tandis que vos Soins rapides et Soins de lien bénéficient de 20% supplémentaires des effets du bonus relatif aux soins.|r", "spellempoweredhealing", 935, -130)
CreateSpellButton("buttonSpellSerendipity", "Interface/icons/spell_holy_serendipity", "|cffffffffHeureux hasard|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Quand vous soignez avec Soins de lien ou Soins rapides, le temps d'incantation de votre prochain sort Soins supérieurs ou Prière de soins est réduit de 12%.\nCumulable jusqu'à 3 fois.\nDure 20 secondes.|r", "spellserendipity", 1045, -130)
CreateSpellButton("buttonSpellEmpoweredRenew", "Interface/icons/ability_paladin_infusionoflight", "|cffffffffRénovation surpuissante|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Votre sort Rénovation bénéficie de 15% supplémentaires de votre bonus aux soins, et votre Rénovation rend instantanément à la cible 15% de l'effet périodique total.|r", "spellempoweredrenew", 663, -184)
CreateSpellButton("buttonSpellCircleofHealing", "Interface/icons/spell_holy_circleofrenewal", "|cffffffffCercle de soins|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Rend à 6 membres au maximum du groupe ou du raid alliés se trouvant à moins de 15 mètres de la cible 343 à 379 points de vie.|r", "spellcircleofhealing", 770, -184)
CreateSpellButton("buttonSpellTestofFaith", "Interface/icons/spell_holy_testoffaith", "|cffffffffEpreuve de la Foi|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente les soins de 12% sur les cibles alliées qui ne disposent plus que de 50% ou moins de leurs points de vie.|r", "spelltestoffaith", 880, -184)
CreateSpellButton("buttonSpellDivineProvidence", "Interface/icons/spell_holy_divineprovidence", "|cffffffffProvidence divine|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente de 10% le montant de points de vie rendus par Cercle de soins, Soins de lien, Nova sacrée,\nPrière de soins, Hymne divin et Prière de guérison, et réduit de 30% le temps de recharge de votre Prière de guérison.|r", "spelldivineprovidence", 990, -184)
CreateSpellButton("buttonSpellGuardianSpirit", "Interface/icons/spell_holy_guardianspirit", "|cffffffffEsprit gardien|r\n|cffffffffTalent|r |cffffffffSacré|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Fait appel à un esprit gardien pour veiller sur la cible alliée.\nL'esprit augmente les soins prodigués à la cible de 40% et l'empêche également de mourir en se sacrifiant pour elle.\nCe sacrifice met fin à l'effet mais rend à la cible 50% de ses points de vie maximum.\nDure 10 secondes.", "spellguardianspirit", 1100, -184)



CreateSpellButton("buttonSpellSpiritTap", "Interface/icons/spell_shadow_requiem", "|cffffffffConnexion spirituelle|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Vous donne 100% de chances de gagner un bonus de 100% à l'Esprit après avoir tué une cible qui rapporte de l'expérience ou de l'honneur.\nVotre mana se régénère à 83% de la vitesse de récupération normale pendant l'incantation de sorts.\nDure 15 secondes.|r", "spellspirittap", 718, -240)
CreateSpellButton("buttonSpellImprovedSpiritTap", "Interface/icons/spell_shadow_requiem", "|cffffffffConnexion spirituelle améliorée|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Vos coups critiques réussis avec Attaque mentale et Mot de l'ombre : Mort ont 100% de chances vos coups critiques avec Fouet mental ont 50% de chances d'augmenter votre total d'Esprit de 10%.\nPendant ce temps, votre mana se régénèrera à un taux de 33% lors des incantations.\nDure 8 secondes.|r", "spellimprovedspirittap", 825, -240)
CreateSpellButton("buttonSpellDarkness", "Interface/icons/spell_shadow_twilight", "|cffffffffTénèbres|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente les dégâts de vos sorts d'Ombre de 10%.|r", "spelldarkness", 935, -240)
CreateSpellButton("buttonSpellShadowAffinity", "Interface/icons/spell_shadow_shadowward", "|cffffffffAffinité avec l'Ombre|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit la menace générée par vos sorts d'Ombre de 25%, et vous recevez 15% de votre mana de base quand vos sorts Mot de l'ombre : Douleur ou Toucher vampirique sont dissipés.|r", "spellshadowaffinity", 1045, -240)
CreateSpellButton("buttonSpellImprovedShadowWordPain", "Interface/icons/spell_shadow_shadowwordpain", "|cffffffffMot de l'ombre : Douleur amélioré|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente les dégâts infligés par votre sort Mot de l'ombre : Douleur de 6%.|r", "spellimprovedshadowwordpain", 663, -293)
CreateSpellButton("buttonSpellShadowFocus", "Interface/icons/spell_shadow_burningspirit", "|cffffffffFocalisation de l'ombre|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente vos chances de toucher avec vos sorts d'Ombre de 3%, et réduit le coût en mana de vos sorts d'Ombre de 6%.|r", "spellshadowfocus", 770, -293)
CreateSpellButton("buttonSpellImprovedPsychicScream", "Interface/icons/spell_shadow_psychicscream", "|cffffffffCri psychique amélioré|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit le temps de recharge de votre sort Cri psychique de 4 sec.|r", "spellimprovedpsychicscream", 990, -293)
CreateSpellButton("buttonSpellImprovedMindBlast", "Interface/icons/spell_shadow_unholyfrenzy", "|cffffffffAttaque mentale améliorée|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit le temps de recharge de votre sort Attaque mentale de 2.5 sec.,\net tant que vous êtes en forme d'Ombre il a également 100% de chances de réduire tous les soins prodigués à la cible de 20% pendant 10 secondes.|r", "spellimprovedmindblast", 1100, -293)
CreateSpellButton("buttonSpellMindFlay", "Interface/icons/spell_shadow_siphonmana", "|cffffffffFouet mental|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Attaque l'esprit de la cible avec l'énergie de l'Ombre.\nInflige 45 points de dégâts d'Ombre en 3 secondes.\net réduit la vitesse de la cible de 50%.|r", "spellmindflay", 718, -348)
CreateSpellButton("buttonSpellVeiledShadows", "Interface/icons/spell_magic_lesserinvisibilty", "|cffffffffOmbres voilées|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit le temps de recharge de votre technique Oubli de 6 sec.\net celui de votre technique Ombrefiel de 2 minutes.|r", "spellveiledshadows", 825, -348)
CreateSpellButton("buttonSpellShadowReach", "Interface/icons/spell_shadow_chilltouch", "|cffffffffAllonge de l'Ombre|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente de 20% la portée de vos sorts offensifs d'Ombre.|r", "spellshadowreacht", 935, -348)
CreateSpellButton("buttonSpellShadowWeaving", "Interface/icons/spell_shadow_blackplague", "|cffffffffTissage de l'ombre|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Vos sorts d'Ombre infligeant des dégâts ont 100% de chances d'augmenter les dégâts d'Ombre que vous infligez de 2% pendant 15 seconds.\nCumulable jusqu'à 5 fois.|r", "spellshadowweaving", 1045, -348)
CreateSpellButton("buttonSpellSilence", "Interface/icons/spell_shadow_impphaseshift", "|cffffffffSilence|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Rend la cible silencieuse, l'empêchant de lancer des sorts pendant 5 secondes.\nLes incantations de sorts des victimes personnages non joueurs sont également interrompues pendant 3 secondes.|r", "spellsilence", 663, -402)
CreateSpellButton("buttonSpellVampiricEmbrace", "Interface/icons/spell_shadow_unsummonbuilding", "|cffffffffEtreinte vampirique|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Vous emplit de l'énergie de l'étreinte de l'Ombre, qui vous soigne pour 15% et les autres membres du groupe pour 3% de tous les dégâts d'Ombre que vous infligez avec des sorts monocibles pendant 30 mn.|r", "spellvampiricembrace", 770, -402)
CreateSpellButton("buttonSpellImprovedVampiricEmbrace", "Interface/icons/spell_shadow_improvedvampiricembrace", "|cffffffffEtreinte vampirique améliorée|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente de 67% les soins prodigués par Etreinte vampirique.|r", "spellimprovedvampiricembrace", 880, -402)
CreateSpellButton("buttonSpellFocusedMind", "Interface/icons/spell_nature_focusedmind", "|cffffffffEsprit focalisé|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Réduit le coût en mana de vos sorts Attaque mentale, Contrôle mental, Fouet mental et Incandescence mentale de 15%.|r", "spellfocusedmind", 990, -402)
CreateSpellButton("buttonSpellMindMelt", "Interface/icons/spell_shadow_skull", "|cffffffffFonte de l'esprit|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente les chances de coup critique de vos sorts Attaque mentale, Fouet mental et Incandescence mentale de 4%,\net augmente les chances de coup critique périodique de vos sorts Toucher vampirique, Peste dévorante et Mot de l'ombre : Douleur de 6%.|r", "spellmindmelt", 1100, -402)
CreateSpellButton("buttonSpellImprovedDevouringPlague", "Interface/icons/spell_shadow_devouringplague", "|cffffffffPeste dévorante améliorée|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente les dégâts périodiques infligés par votre Peste dévorante de 15%,\net quand vous la lancez vous infligez instantanément un montant de dégâts égal à 30% du total de son effet périodique.|r", "spellimproveddevouringplague", 718, -456)
CreateSpellButton("buttonSpellShadowform", "Interface/icons/spell_shadow_shadowform", "|cffffffffForme d'Ombre|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Adopte une Forme d'Ombre qui augmente de 15% les dégâts d'Ombre que vous infligez en plus de réduire de 15% tous les dégâts que vous subissez et de 30% la menace générée.\nCependant, vous ne pouvez pas lancer de sorts du Sacré lorsque vous êtes sous cette forme, à part Guérison des maladies et Abolir maladie.\nLes dégâts périodiques de vos sorts Mot de l'ombre : Douleur, Peste dévorante et Toucher vampirique sont augmentés de 100% quand ils sont critiques,\nPeste dévorante et Toucher vampirique bénéficient également du bonus de hâte.|r", "spellshadowform", 825, -456)
CreateSpellButton("buttonSpellShadowPower", "Interface/icons/spell_shadow_shadowpower", "|cffffffffPuissance de l'ombre|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente le bonus de dégâts des coups critiques de vos sorts Attaque mentale, Fouet mental et Mot de l'ombre : Mort de 100%.|r", "spellshadowpower", 935, -456)
CreateSpellButton("buttonSpellImprovedShadowform", "Interface/icons/spell_shadow_summonvoidwalker", "|cffffffffForme d'Ombre améliorée|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Votre technique Oubli a maintenant 100% de chances d'annuler tous les effets affectant le déplacement lorsque vous êtes en forme d'Ombre.\nRéduit de 70% le temps d'incantation ou de canalisation perdu provoqué par les dégâts pendant l'incantation des sorts d'Ombre lorsque vous êtes en forme d'Ombre.|r", "spellimprovedshadowform", 1045, -456)
CreateSpellButton("buttonSpellMisery", "Interface/icons/spell_shadow_misery", "|cffffffffMisère|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Vos sorts Mot de l'ombre : Douleur, Fouet mental et Toucher vampirique augmentent aussi les chances de toucher des sorts néfastes de 3% pendant 24 secondes.\nAugmente également de 15% l'avantage octroyé par votre puissance des sorts dont bénéficient Attaque mentale, Fouet mental et Incandescence mentale.|r", "spellmisery", 663, -510)
CreateSpellButton("buttonSpellPsychicHorror", "Interface/icons/spell_shadow_psychichorrors", "|cffffffffHorreur psychique|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Vous terrifiez la cible, qui tremble, horrifiée, pendant 3 secondes et laisse tomber son arme tenue en main droite et ses armes à distance pendant 10 secondes.|r", "spellpsychichorror", 770, -510)
CreateSpellButton("buttonSpellVampiricTouch", "Interface/icons/spell_holy_stoicism", "|cffffffffToucher vampirique|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Inflige 450 points de dégâts d'Ombre en 15 seconds.\nà votre cible et fait recevoir à un maximum de 10 membres du groupe ou du raid un montant de mana égal à 1% de leur maximum de mana toutes les 5 sec.\nquand vous infligez des dégâts avec Attaque mentale.\nDe plus, si le Toucher vampirique est dissipé, il inflige 720 points de dégâts à la cible affectée.|r", "spellvampirictouch", 880, -510)
CreateSpellButton("buttonSpellPainandSuffering", "Interface/icons/spell_shadow_painandsuffering", "|cffffffffDouleur et souffrance|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Votre Fouet mental a 100% de chances de réinitialiser la durée de Mot de l'ombre : Douleur sur la cible et il réduit les dégâts que vous inflige votre propre Mot de l'ombre : Mort de 30%.|r", "spellpainandsufferings", 990, -510)
CreateSpellButton("buttonSpellTwistedFaith", "Interface/icons/spell_shadow_mindtwisting", "|cffffffffFoi distordue|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Augmente la puissance de vos sorts de 20% de votre total d'Esprit,\net les dégâts que vous infligez avec Fouet mental et Attaque mentale sont augmentés de 10% si votre cible est affectée par Mot de l'ombre : Douleur.|r", "spelltwistedfaith", 1100, -510)
CreateSpellButton("buttonSpellDispersion", "Interface/icons/spell_shadow_dispersion", "|cffffffffDispersion|r\n|cffffffffTalent|r |cff919191Ombre|r\n|cffffffffRequiert|r |cffffffffPrêtre|r\n|cffffd100Votre corps devient de l'énergie d'ombre pure, ce qui réduit tous les dégâts subis de 90%.\nVous ne pouvez pas attaquer ni lancer de sorts, mais vous régénérez 6% de votre mana toutes les 1 sec.\npendant 6 seconds.\nDispersion peut être lancé lorsque vous êtes étourdi, apeuré ou réduit au silence,\ndissipe tous les effets affectant le déplacement à son lancement et vous rend insensible à eux tant que vous êtes de l'énergie pure.|r", "spelldispersion", 880, -293)



local resetButtonClicked = false

local buttonReset = CreateFrame("Button", "buttonReset", frameTalentPriest, "UIPanelButtonTemplate")
buttonReset:SetSize(85, 25)
buttonReset:SetPoint("BOTTOMRIGHT", buttonTalentPriestClose, "BOTTOMLEFT", -95, 5)
buttonReset:SetText("Réinitialiser")

local function ResetTalents()
    AIO.Handle("TalentPriestspell", "ResetTalents")
    resetButtonClicked = true
end

buttonReset:SetScript("OnClick", ResetTalents)

local buttonReload = CreateFrame("Button", "buttonReload", frameTalentPriest, "UIPanelButtonTemplate")
buttonReload:SetSize(85, 25)
buttonReload:SetPoint("BOTTOMRIGHT", buttonTalentPriestClose, "BOTTOMLEFT", -5, 5)
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
        frameTalentPriest:Hide()
        buttonReload:Hide()
        PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
    else
        frameTalentPriest:Show()
        buttonReload:Show()
        PlaySoundFile(OPEN_TALENT_WINDOW_SOUND)
    end

    talentsWindowOpen = not talentsWindowOpen
end

local playerClass = select(2, UnitClass("player"))
if playerClass == "PRIEST" then
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
        GameTooltip:SetText("|cffffffffTalents|r |cffffffff(Prêtre)|r\n\nL'éventail des talents disponibles\npour améliorer et spécialiser\nvotre personnage.")
        GameTooltip:Show()
    end)

    buttonOuvrirTalents:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    buttonOuvrirTalents:SetScript("OnClick", OuvrirFermerInterfaceTalents)
    TalentMicroButton:Hide()
end

PriestHandlers.UpdateTalentCount = function(player, talentsAppris)
    if fontTalentPriestFrameText then
        fontTalentPriestFrameText:SetText(talentsAppris .. " / " .. MAX_TALENTS)
    end
end

PriestHandlers.UpdateTalentPointsUsed = function(player, pointsUsed, pointsBeforeReset)
    print("|cff00ffffVous avez utilisés " .. pointsBeforeReset .. " points avant la réinitialisation des talents|r")
end