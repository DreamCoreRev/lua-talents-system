local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local DemonhunterHandlers = AIO.AddHandlers("TalentDemonhunterspell", {})

function DemonhunterHandlers.ShowTalentDemonhunter(player)
    frameTalentDemonhunter:Show()
end

local MAX_TALENTS = 21

local OPEN_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_final_trait_unlocked.ogg"
local CLOSE_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_trait_refund_end.ogg"
local SPELL_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_80_azeritearmor_rotationends_02.ogg"

local frameTalentDemonhunter = CreateFrame("Frame", "frameTalentDemonhunter", UIParent)
frameTalentDemonhunter:SetSize(1200, 650)
frameTalentDemonhunter:SetMovable(true)
frameTalentDemonhunter:EnableMouse(true)
frameTalentDemonhunter:RegisterForDrag("LeftButton")
frameTalentDemonhunter:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
frameTalentDemonhunter:SetBackdrop(
{
    bgFile = "interface/TalentFrame/Template/Class/DemonHunter/talentsclassbackgrounddemonhunter2",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedwarlock",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

local demonhunterIcon = frameTalentDemonhunter:CreateTexture("DemonhunterIcon", "OVERLAY")
demonhunterIcon:SetTexture("Interface\\TalentFrame\\Template\\Class\\DemonHunter\\IconeDemonHunter.blp")
demonhunterIcon:SetSize(60, 60)
demonhunterIcon:SetPoint("TOPLEFT", frameTalentDemonhunter, "TOPLEFT", -10, 10)


local textureone = frameTalentDemonhunter:CreateTexture("TemplateTalentFrame", "OVERLAY")
textureone:SetTexture("Interface\\TalentFrame\\Template\\Class\\Demonhunter\\TalentFrameTemplate.blp")
textureone:SetSize(928, 928)
textureone:SetPoint("TOPLEFT", frameTalentDemonhunter, "TOPLEFT", -150, 90)

frameTalentDemonhunter:SetFrameLevel(100)

local texturetwo = frameTalentDemonhunter:CreateTexture("TemplateTalentFrame", "OVERLAY")
texturetwo:SetTexture("Interface\\TalentFrame\\Template\\Class\\Demonhunter\\TalentFrameTemplateOriginal.blp")
texturetwo:SetSize(928, 928)
texturetwo:SetPoint("TOPRIGHT", frameTalentDemonhunter, "TOPRIGHT", 150, 35)

frameTalentDemonhunter:SetFrameLevel(100)

frameTalentDemonhunter:SetScript("OnDragStart", frameTalentDemonhunter.StartMoving)
frameTalentDemonhunter:SetScript("OnHide", frameTalentDemonhunter.StopMovingOrSizing)
frameTalentDemonhunter:SetScript("OnDragStop", frameTalentDemonhunter.StopMovingOrSizing)
frameTalentDemonhunter:Hide()

frameTalentDemonhunter:SetBackdropBorderColor(135, 135, 237)

local buttonTalentDemonhunterClose = CreateFrame("Button", "buttonTalentDemonhunterClose", frameTalentDemonhunter, "UIPanelCloseButton")
buttonTalentDemonhunterClose:SetPoint("TOPRIGHT", -12, -12)
buttonTalentDemonhunterClose:EnableMouse(true)
buttonTalentDemonhunterClose:SetSize(32, 32)

local function CloseTalentWindow()
    frameTalentDemonhunter:Hide()
    PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
end

buttonTalentDemonhunterClose:SetScript("OnClick", CloseTalentWindow)

local frameTalentDemonhunterTitleBar = CreateFrame("Frame", "frameTalentDemonhunterTitleBar", frameTalentDemonhunter, nil)
frameTalentDemonhunterTitleBar:SetSize(135, 25)
frameTalentDemonhunterTitleBar:SetBackdrop(
{
    bgFile = "interface/corrupteditems/corruptedtooltipbackground",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedwarlock",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameTalentDemonhunterTitleBar:SetPoint("TOP", 0, 20)

local fontTalentDemonhunterTitleText = frameTalentDemonhunterTitleBar:CreateFontString("fontTalentDemonhunterTitleText")
fontTalentDemonhunterTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontTalentDemonhunterTitleText:SetSize(190, 5)
fontTalentDemonhunterTitleText:SetPoint("CENTER", 0, 0)
fontTalentDemonhunterTitleText:SetText("|cffFFC125Talents|r")

local fontTalentDemonhunterFrameText = frameTalentDemonhunterTitleBar:CreateFontString("fontTalentDemonhunterFrameText")
fontTalentDemonhunterFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentDemonhunterFrameText:SetSize(200, 5)
fontTalentDemonhunterFrameText:SetPoint("TOPLEFT", frameTalentDemonhunterTitleBar, "BOTTOMLEFT", -30, -35)
fontTalentDemonhunterFrameText:SetText("|cffFFC125Chasseur de démons|r")

local fontTalentDemonhunterFrameText = frameTalentDemonhunterTitleBar:CreateFontString("fontTalentDemonhunterFrameText")
fontTalentDemonhunterFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentDemonhunterFrameText:SetSize(200, 5)
fontTalentDemonhunterFrameText:SetPoint("TOPLEFT", frameTalentDemonhunterTitleBar, "BOTTOMLEFT", -30, -60)
fontTalentDemonhunterFrameText:SetText("0 / " .. MAX_TALENTS)



local function CreateSpellButton(name, texturePath, tooltipText, talentHandler, positionX, positionY)
    local buttonClicked = false
    local talentLearned = false

    local button = CreateFrame("Button", name, frameTalentDemonhunter, nil)
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
                AIO.Handle("TalentDemonhunterspell", talentHandler, 1)
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






CreateSpellButton("buttonSpellWarglaivesChaos", "Interface/icons/inv_glaive_1h_artifactazgalor_d_03", "|cffffffffGlaives de guerre du chaos|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Augmente les dégâts des coups critiques infligés par Frappe du chaos de 21%.|r", "spellwarglaiveschaos", 170, -180)
CreateSpellButton("buttonSpellDemonSpeed", "Interface/icons/ability_demonhunter_doublejump", "|cffffffffVitesse démoniaque|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Voile corrompu octroie maintenant un bonus de 30% à la vitesse de déplacement.|r", "spelldemonspeed", 280, -180)
CreateSpellButton("buttonSpellUnboundChaos", "Interface/icons/artifactability_vengeancedemonhunter_painbringer", "|cffffffffChaos délié|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100L'activation d'Aura d'immolation augmente les dégâts de votre prochaine Ruée vers le félin de 80%. Dure 20 sec.|r", "spellunboundchaos", 390, -180)
CreateSpellButton("buttonSpellChaosVision", "Interface/icons/ability_demonhunter_eyebeam", "|cffffffffVision du chaos|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Augmente les dégâts de Rayon accablant de 15%.|r", "spellchaosvision", 445, -235)
CreateSpellButton("buttonSpellDevastatingChaos", "Interface/icons/ability_demonhunter_demonictrample", "|cffffffffDévastateur du Chaos|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Réduit le temps de recharge de votre capacité Rayon accablant de 10 secondes.|r", "spelldevastatingchaos", 335, -235)
CreateSpellButton("buttonSpellDesperateInstincts", "Interface/icons/Spell_Shadow_ManaFeed", "|cffffffffInstinct désespéré|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Voile corrompu réduit désormais les dégâts subis de 10% supplémentaires.|r", "spelldesperateinstincts", 225, -235)
CreateSpellButton("buttonSpellImprovedDemonsBite", "Interface/icons/INV_Weapon_Glave_01", "|cffffffffMorsure du démon Amélioré|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Augmente de 10% les dégâts des coups critiques infligés par la morsure des démons\net augmente de 50% les chances de remboursement de la furie.|r", "spellimproveddemonsbite", 115, -235)
CreateSpellButton("buttonSpellNetherwalk", "Interface/icons/spell_warlock_demonsoul", "|cffffffffMarche du Néant|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Glissez-vous dans le néant, augmentant votre vitesse de déplacement de 100%, supprimant tous les effets qui entravent le mouvement\net devenant immunisé aux dégâts, mais incapable d'attaquer. Dure 5 secondes.|r", "spellnetherwalk", 170, -290)
CreateSpellButton("buttonSpellAnguishDeceiver", "Interface/icons/artifactability_havocdemonhunter_anguishofthedeceiver", "|cffffffffAngoisse du Trompeur|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Chaque fois que le rayon des yeux inflige des dégâts à une cible, il applique également Angoisse.\nLorsque Angoisse expire, il inflige [ 85% de la puissance d'attaque ] de dégâts de Chaos à la victime par application.|r", "spellanguishdeceiver", 280, -290)
CreateSpellButton("buttonSpellChaoticOnslaught", "Interface/icons/ability_demonhunter_chaosstrike", "|cffffffffAssaut chaotique|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Frappe du chaos a 15% de chances de trancher une fois de plus.|r", "spellchaoticonslaught", 60, -290)
CreateSpellButton("buttonSpellIllidariKnowledge", "Interface/icons/spell_mage_overpowered", "|cffffffffConnaissance illidari|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Réduit les dégâts magiques que vous subissez de 8%.|r", "spellillidariknowledge", 390, -290)
CreateSpellButton("buttonSpellUnleashedPower", "Interface/icons/ability_demonhunter_chaosnova", "|cffffffffPuissance déchaînée|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Supprime le coût en furie de Chaos Nova et réduit son temps de recharge de 33%.|r", "spellunleashedpower", 495, -290)
CreateSpellButton("buttonSpellChaosBlade", "Interface/icons/inv_glaive_1h_artifactaldrochi_d_03dual", "|cffffffffLame du Chaos|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Les dégâts infligés ont augmenté de 30%.\nAugmentation de la vitesse d'attaque automatique de 15%.|r", "spellchaosblade", 115, -345)
CreateSpellButton("buttonSpellImprovedMetamorphosis", "Interface/icons/ability_demonhunter_metamorphasistank", "|cffffffffMétamorphose améliorée|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Augmente les dégâts de l'explosion féline de Métamorphose de 20% et augmente sa durée à 45 sec.|r", "spellimprovedmetamorphosis", 225, -345)
CreateSpellButton("buttonSpellUnleashedDemons", "Interface/icons/ability_demonhunter_metamorphasistank", "|cffffffffDémons déchaînés|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Réduit le temps de recharge de Métamorphose de 30 secondes.|r", "spellunleasheddemons", 280, -398)
CreateSpellButton("buttonSpellBalancedBlades", "Interface/icons/ability_demonhunter_bladedance", "|cffffffffLames équilibrées|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Augmente les dégâts infligés par Danse des lames de 45%.|r", "spellbalancedblades", 445, -345)
CreateSpellButton("buttonSpellDemonic", "Interface/icons/Spell_Shadow_DemonForm", "|cffffffffDémoniaque|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Rayon accablant vous transforme en démon pendant 8 s après qu’il a fini d’infliger des dégâts.|r", "spelldemonic", 335, -345)
CreateSpellButton("buttonSpellFelWounds", "Interface/icons/Spell_Fire_FelHellfire", "|cffffffffBlessures gangrenées|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100La Danse des lames fait saigner tous les ennemis à 8 mètres de distance pour 150% des dégâts infligés sur 10 sec.|r", "spellfelwounds", 495, -398)
CreateSpellButton("buttonSpellFelBarrage", "Interface/icons/inv_felbarrage", "|cffffffffBarrage gangrené|r\n|cffffffffTalent|r |cff00bb00Dévastation|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Lance un torrent d'énergie Fel sur 3 sec, infligeant [ 314,6% de la puissance d'attaque ] des dégâts de feu à tous les ennemis dans un rayon de 8 m.|r", "spellfelbarrage", 60, -398)



CreateSpellButton("buttonSpellThickSkin", "Interface/icons/sha_spell_warlock_demonsoul", "|cffffffffPeau dure|r\n|cffffffffTalent|r |cff0000d5Vengeance|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Une énergie gangrenée épaissit votre peau dans des proportions démoniaques, ce qui augmente votre Endurance de 65% et votre Armure de 130%.|r", "spellthickskin", 645, -290)
CreateSpellButton("buttonSpellDemonicWards", "Interface/icons/inv_belt_leather_demonhunter_a_01", "|cffffffffProtections démoniaques|r\n|cffffffffTalent|r |cff0000d5Vengeance|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Vos tatouages réduisent [les dégâts magiques subis de 10% et les dégâts physiques subis de 10%.][les dégâts subis de 10%.]|r", "spelldemonicwards", 1075, -290)


CreateSpellButton("buttonSpellSharpenedGlaives", "Interface/icons/ability_demonhunter_throwglaive", "|cffffffffGlaives aiguisées|r\n|cffffffffTalent|r |cffc7690cMaître du glaive|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Augmente les dégâts de Lancer de glaive de 50%.|r", "spellsharpenedglaives", 805, -235)
CreateSpellButton("buttonSpellDisorientGlaives", "Interface/icons/inv_glaive_1h_demonhunter_a_01", "|cffffffffGlaives désorientées|r\n|cffffffffTalent|r |cffc7690cMaître du glaive|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Lancer de glaive piège tous les ennemis touchés de 30% pendant 5 sec.|r", "spelldisorientglaives", 860, -180)
CreateSpellButton("buttonSpellFireGlaives", "Interface/icons/inv_glaive_1h_artifactazgalor_d_04", "|cffffffffGlaive de feu|r\n|cffffffffTalent|r |cffc7690cMaître du glaive|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Lancer de glaive provoque une brûlure dans vos cibles, infligeant des dégâts de feu sur 5 sec.|r", "spellfireglaives", 915, -235)
CreateSpellButton("buttonSpellMasterGlaive", "Interface/icons/inv_glaive_1h_npc_c_02", "|cffffffffMaître du Glaive|r\n|cffffffffTalent|r |cffc7690cMaître du glaive|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Réduit le temps de recharge de Glaive de jet de 3 secondes.|r", "spellmasterglaive", 750, -290)
CreateSpellButton("buttonSpellMasterySpeed", "Interface/icons/ability_demonhunter_doublejump", "|cffffffffMaîtrise de la vitesse|r\n|cffffffffTalent|r |cffc7690cMaître du glaive|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Lancer de glaive augmente votre vitesse de déplacement de 5% en s'empilant 3 fois, dure 4 secondes.|r", "spellmasteryspeed", 700, -345)
CreateSpellButton("buttonSpellImprovedFireGlaives", "Interface/icons/inv_glaive_1h_artifactazgalor_d_04dual", "|cffffffffGlaives de feu améliorées|r\n|cffffffffTalent|r |cffc7690cMaître du glaive|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Augmente l'efficacité de Burning, en augmentant ses dégâts de 12% et en augmentant sa durée de 55%.|r", "spellimprovedfireglaives", 860, -290)
CreateSpellButton("buttonSpellCauterize", "Interface/icons/spell_burningbladeshaman_blazing_radiance", "|cffffffffCautérisation|r\n|cffffffffTalent|r |cffc7690cMaître du glaive|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Lancer de glaive réduit la résistance au feu de vos ennemis de 10000 pendant 10 sec.|r", "spellcauterize", 915, -345)
CreateSpellButton("buttonSpellDualBladeDance", "Interface/icons/inv_glaive_1h_artifactazgalor_d_01", "|cffffffffLa danse des doubles lames|r\n|cffffffffTalent|r |cffc7690cMaître du glaive|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Lance 2 de vos glaives démoniaques dans un tourbillon d'énergie,\ncausant 38% des dégâts de l'arme en dégâts de chaos sur 3 sec à tous les ennemis proches.|r", "spelldualbladedance", 970, -290)
CreateSpellButton("buttonSpellImprovedDualBlades", "Interface/icons/ability_demonhunter_bladedance", "|cffffffffLames doubles améliorées|r\n|cffffffffTalent|r |cffc7690cMaître du glaive|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Augmente la durée de Dual Blade Dance de 65%.|r", "spellimproveddualblades", 1025, -345)
CreateSpellButton("buttonSpellBloodlet", "Interface/icons/ability_demonhunter_bloodlet", "|cffffffffBloodlet|r\n|cffffffffTalent|r |cffc7690cMaître du glaive|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Lancer de glaive fait saigner vos ennemis pour 30% des dégâts infligés, cumulable 3 fois sur 15 sec.|r", "spellbloodlet", 645, -398)
CreateSpellButton("buttonSpellRapidGlaives", "Interface/icons/inv_glaive_1h_npc_c_02", "|cffffffffGlaives rapides|r\n|cffffffffTalent|r |cffc7690cMaître du glaive|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Lance simultanément vos Glaives, infligeant des dégâts à un maximum de 3 cibles toutes les 0.5 sec, dure 3 seconds.|r", "spellrapidglaives", 805, -345)
CreateSpellButton("buttonSpellVenomlet", "Interface/icons/inv_glaive_1h_artifactazgalor_d_02dual", "|cffffffffVenomlet|r\n|cffffffffTalent|r |cffc7690cMaître du glaive|r\n|cffffffffRequiert|r |cffa330c9Chasseur de démons|r\n|cffffd100Lancer de glaive empoisonne vos ennemis en leur infligeant 15% des dégâts infligés\net réduit leur résistance à la nature de 2000, cumulable 3 fois sur 15 sec.|r", "spellvenomlet", 1075, -398)



local resetButtonClicked = false

local buttonReset = CreateFrame("Button", "buttonReset", frameTalentDemonhunter, "UIPanelButtonTemplate")
buttonReset:SetSize(85, 25)
buttonReset:SetPoint("BOTTOMRIGHT", buttonTalentDemonhunterClose, "BOTTOMLEFT", -95, 5)
buttonReset:SetText("Réinitialiser")

local function ResetTalents()
    AIO.Handle("TalentDemonhunterspell", "ResetTalents")
    resetButtonClicked = true
end

buttonReset:SetScript("OnClick", ResetTalents)

local buttonReload = CreateFrame("Button", "buttonReload", frameTalentDemonhunter, "UIPanelButtonTemplate")
buttonReload:SetSize(85, 25)
buttonReload:SetPoint("BOTTOMRIGHT", buttonTalentDemonhunterClose, "BOTTOMLEFT", -5, 5)
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
        frameTalentDemonhunter:Hide()
        buttonReload:Hide()
        PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
    else
        frameTalentDemonhunter:Show()
        buttonReload:Show()
        PlaySoundFile(OPEN_TALENT_WINDOW_SOUND)
    end

    talentsWindowOpen = not talentsWindowOpen
end

local playerClass = select(2, UnitClass("player"))
if playerClass == "DEMONHUNTER" then
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
        GameTooltip:SetText("|cffffffffTalents|r |cffa330c9(Chasseur de démons)|r\n\nL'éventail des talents disponibles\npour améliorer et spécialiser\nvotre personnage.")
        GameTooltip:Show()
    end)

    buttonOuvrirTalents:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    buttonOuvrirTalents:SetScript("OnClick", OuvrirFermerInterfaceTalents)
    TalentMicroButton:Hide()
end

DemonhunterHandlers.UpdateTalentCount = function(player, talentsAppris)
    if fontTalentDemonhunterFrameText then
        fontTalentDemonhunterFrameText:SetText(talentsAppris .. " / " .. MAX_TALENTS)
    end
end

DemonhunterHandlers.UpdateTalentPointsUsed = function(player, pointsUsed, pointsBeforeReset)
    print("|cff00ffffVous avez utilisés " .. pointsBeforeReset .. " points avant la réinitialisation des talents|r")
end