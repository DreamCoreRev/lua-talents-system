local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local HunterHandlers = AIO.AddHandlers("TalentHunterspell", {})

function HunterHandlers.ShowTalentHunter(player)
    frameTalentHunter:Show()
end

local MAX_TALENTS = 41

local OPEN_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_final_trait_unlocked.ogg"
local CLOSE_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_trait_refund_end.ogg"
local SPELL_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_80_azeritearmor_rotationends_02.ogg"

local frameTalentHunter = CreateFrame("Frame", "frameTalentHunter", UIParent)
frameTalentHunter:SetSize(1200, 650)
frameTalentHunter:SetMovable(true)
frameTalentHunter:EnableMouse(true)
frameTalentHunter:RegisterForDrag("LeftButton")
frameTalentHunter:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
frameTalentHunter:SetBackdrop(
{
    bgFile = "interface/TalentFrame/talentsclassbackgroundhunter",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedhunter",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

local hunterIcon = frameTalentHunter:CreateTexture("HunterIcon", "OVERLAY")
hunterIcon:SetTexture("Interface\\TalentFrame\\Template\\Class\\Hunter\\IconeHunter.blp")
hunterIcon:SetSize(60, 60)
hunterIcon:SetPoint("TOPLEFT", frameTalentHunter, "TOPLEFT", -10, 10)


local textureone = frameTalentHunter:CreateTexture("TemplateTalentFrame", "OVERLAY")
textureone:SetTexture("Interface\\TalentFrame\\Template\\Class\\Hunter\\TalentFrameTemplate.blp")
textureone:SetSize(928, 928)
textureone:SetPoint("TOPLEFT", frameTalentHunter, "TOPLEFT", -170, 140)

frameTalentHunter:SetFrameLevel(100)

local texturetwo = frameTalentHunter:CreateTexture("TemplateTalentFrame", "OVERLAY")
texturetwo:SetTexture("Interface\\TalentFrame\\Template\\Class\\Hunter\\TalentFrameTemplateOriginal.blp")
texturetwo:SetSize(928, 928)
texturetwo:SetPoint("TOPRIGHT", frameTalentHunter, "TOPRIGHT", 170, 140)

frameTalentHunter:SetFrameLevel(100)

frameTalentHunter:SetScript("OnDragStart", frameTalentHunter.StartMoving)
frameTalentHunter:SetScript("OnHide", frameTalentHunter.StopMovingOrSizing)
frameTalentHunter:SetScript("OnDragStop", frameTalentHunter.StopMovingOrSizing)
frameTalentHunter:Hide()

frameTalentHunter:SetBackdropBorderColor(169, 210, 113)

local buttonTalentHunterClose = CreateFrame("Button", "buttonTalentHunterClose", frameTalentHunter, "UIPanelCloseButton")
buttonTalentHunterClose:SetPoint("TOPRIGHT", -12, -12)
buttonTalentHunterClose:EnableMouse(true)
buttonTalentHunterClose:SetSize(32, 32)

local function CloseTalentWindow()
    frameTalentHunter:Hide()
    PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
end

buttonTalentHunterClose:SetScript("OnClick", CloseTalentWindow)

local frameTalentHunterTitleBar = CreateFrame("Frame", "frameTalentHunterTitleBar", frameTalentHunter, nil)
frameTalentHunterTitleBar:SetSize(135, 25)
frameTalentHunterTitleBar:SetBackdrop(
{
    bgFile = "interface/corrupteditems/corruptedtooltipbackground",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedHunter",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameTalentHunterTitleBar:SetPoint("TOP", 0, 20)

local fontTalentHunterTitleText = frameTalentHunterTitleBar:CreateFontString("fontTalentHunterTitleText")
fontTalentHunterTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontTalentHunterTitleText:SetSize(190, 5)
fontTalentHunterTitleText:SetPoint("CENTER", 0, 0)
fontTalentHunterTitleText:SetText("|cffFFC125Talents|r")

local fontTalentHunterFrameText = frameTalentHunterTitleBar:CreateFontString("fontTalentHunterFrameText")
fontTalentHunterFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentHunterFrameText:SetSize(200, 5)
fontTalentHunterFrameText:SetPoint("TOPLEFT", frameTalentHunterTitleBar, "BOTTOMLEFT", -30, -35)
fontTalentHunterFrameText:SetText("|cffFFC125Chasseur|r")

local fontTalentHunterFrameText = frameTalentHunterTitleBar:CreateFontString("fontTalentHunterFrameText")
fontTalentHunterFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentHunterFrameText:SetSize(200, 5)
fontTalentHunterFrameText:SetPoint("TOPLEFT", frameTalentHunterTitleBar, "BOTTOMLEFT", -30, -60)
fontTalentHunterFrameText:SetText("0 / " .. MAX_TALENTS)



local function CreateSpellButton(name, texturePath, tooltipText, talentHandler, positionX, positionY)
    local buttonClicked = false
    local talentLearned = false

    local button = CreateFrame("Button", name, frameTalentHunter, nil)
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
                AIO.Handle("TalentHunterspell", talentHandler, 1)
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






CreateSpellButton("buttonSpellImprovedAspectoftheHawk", "Interface/icons/spell_nature_ravenform", "|cffffffffAspect du faucon amélioré|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Pendant qu'Aspect du faucon ou Aspect du faucon-dragon est activé, toutes les attaques à distance normales ont 10% de chances d'augmenter la vitesse d'attaque à distance de 15% pendant 12 secondes.|r", "spellimprovedaspectofthehawk", 100, -80)
CreateSpellButton("buttonSpellEnduranceTraining", "Interface/icons/spell_nature_reincarnation", "|cffffffffEntraînement à l'Endurance|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente les points de vie de votre familier de 10% et votre total de points de vie de 5%.|r", "spellendurancetraining", 205, -75)
CreateSpellButton("buttonSpellFocusedFire", "Interface/icons/ability_hunter_silenthunter", "|cffffffffSurvie focalisé|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Tous les dégâts que vous infligez sont augmentés de 2% tant que votre familier est actif et les chances de coup critique des techniques spéciales de votre familier sont augmentées de 20% tant qu'Ordre de tuer est actif.|r", "spellfocusedfire", 315, -75)
CreateSpellButton("buttonSpellImprovedAspectoftheMonkey", "Interface/icons/ability_hunter_aspectofthemonkey", "|cffffffffAspect du singe amélioré|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente le bonus d'Esquive conféré par Aspect du singe ou votre Aspect du faucon-dragon de 6%.|r", "spellimprovedaspectofthemonkey", 418, -80)
CreateSpellButton("buttonSpellThickHide", "Interface/icons/inv_misc_pelt_bear_03", "|cffffffffPeau épaisse|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente le score d'armure de vos familiers de 20% et la valeur d'armure que vous apportent les objets de 10%.|r", "spellthickhide", 45, -130)
CreateSpellButton("buttonSpellImprovedRevivePet", "Interface/icons/ability_hunter_beastsoothe", "|cffffffffRessusciter le familier amélioré|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Le temps d'incantation du sort Ressusciter le familier est réduit de 6 sec., son coût en mana est diminué de 40% et le familier revient avec 30% de points de vie supplémentaires.|r", "spellimprovedrevivepet", 150, -130)
CreateSpellButton("buttonSpellPathfinding", "Interface/icons/ability_mount_jungletiger", "|cffffffffScience des chemins|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente le bonus de vitesse de vos Aspects de la meute et du guépard de 8% et augmente la vitesse de votre monture de 10%.\nNe se cumule pas avec les autres effets d'augmentation de vitesse de la monture.|r", "spellpathfinding", 260, -130)
CreateSpellButton("buttonSpellAspectMastery", "Interface/icons/ability_hunter_aspectmastery", "|cffffffffMaîtrise des aspects|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Aspect de la vipère - Réduit la pénalité aux dégâts de 10%.\nAspect du singe - Réduit les dégâts que vous subissez pendant qu'il est actif de 5%.\nAspect du faucon - Augmente le bonus à la puissance d'attaque de 30%.\nAspect du faucon-dragon - Combine les bonus des aspects du singe et du faucon.|r", "spellaspectmastery", 370, -130)
CreateSpellButton("buttonSpellUnleashedFury", "Interface/icons/ability_bullrush", "|cffffffffFureur libérée|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente les dégâts infligés par vos familiers de 15%.|r", "spellunleashedfury", 475, -133)
CreateSpellButton("buttonSpellImprovedMendPet", "Interface/icons/ability_hunter_mendpet", "|cffffffffGuérison du familier améliorée|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Réduit le coût en mana de votre sort Guérison du familier de 20% et lui donne 50% de chances de faire disparaître 1 effet de malédiction, maladie, magie ou poison du familier à chaque itération.|r", "spellimprovedmendpet", 96, -185)
CreateSpellButton("buttonSpellFerocity", "Interface/icons/inv_misc_monsterclaw_04", "|cffffffffFerocité|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente de 10% les chances de votre familier d'infliger un coup critique.|r", "spellferocity", 205, -185)
CreateSpellButton("buttonSpellSpiritBond", "Interface/icons/ability_druid_demoralizingroar", "|cffffffffEngagement spirituel|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Tant que votre familier est actif, vous et votre familier retrouvez 2% du total de vos points de vie toutes les 10 sec., et les soins prodigués à vous-même et à votre familier sont augmentés de 10%.|r", "spellspiritbond", 315, -185)
CreateSpellButton("buttonSpellIntimidation", "Interface/icons/ability_devour", "|cffffffffIntimidation|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Ordonne à votre familier d'intimider la cible, générant un niveau élevé de menace et étourdissant la cible pendant 3 seconds.\nDure 15 seconds.|r", "spellintimidation", 422, -185)
CreateSpellButton("buttonSpellBestialDisciplinet", "Interface/icons/spell_nature_abolishmagic", "|cffffffffDiscipline bestiale|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente de 100% la régénération de focalisation de vos Familiers.|r", "spellbestialdiscipline", 527, -190)
CreateSpellButton("buttonSpellAnimalHandler", "Interface/icons/ability_hunter_animalhandler", "|cffffffffDresseur|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente de 10% la puissance d'attaque de votre familier et augmente la durée de l'effet d'Appel du maître de 6 sec.", "spellanimalhandler", 43, -240)
CreateSpellButton("buttonSpellFrenzy", "Interface/icons/inv_misc_monsterclaw_03", "|cffffffffFrénésie|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Confère à votre familier 100% de chances de bénéficier d'un bonus de 30% à la vitesse d'attaque pendant 8 seconds après qu'il a infligé un coup critique.|r", "spellfrenzy", 150, -240)
CreateSpellButton("buttonSpellFerociousInspiration", "Interface/icons/ability_hunter_ferociousinspiration", "|cffffffffInspiration féroce|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Tous les membres du groupe ou du raid voient tous leurs dégâts augmenter de 3% quand ils sont à moins de 100 mètres de votre familier.\nDe plus, augmente les dégâts infligés par Tir des arcanes et Tir assuré de 9%.|r", "spellferociousinspiration", 368, -240)
CreateSpellButton("buttonSpellBestialWrath", "Interface/icons/ability_druid_ferociousbite", "|cffffffffCourroux bestial|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Votre familier, fou de rage, inflige 50% de points de dégâts supplémentaires pendant 10 seconds.\nLorsqu’il est dans cet état, il n'éprouve ni pitié, ni remords, ni peur et ne peut plus être arrêté à moins d'être tué.|r", "spellbestialwrath", 478, -240)
CreateSpellButton("buttonSpellCatlikeReflexes", "Interface/icons/ability_hunter_catlikereflexes", "|cffffffffRéflexes félins|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente vos chances d'esquiver de 3% et celles de votre familier de 9% supplémentaires.\nDe plus, réduit le temps de recharge de votre technique Ordre de tuer de 30 sec.|r", "spellcatlikereflexes", 98, -293)
CreateSpellButton("buttonSpellInvigoration", "Interface/icons/ability_hunter_invigeration", "|cffffffffRevigoration|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Quand votre familier réussit un coup critique avec une technique spéciale, vous avez 100% de chances de récupérer instantanément 1% de votre mana.|r", "spellinvigoration", 205, -293)
CreateSpellButton("buttonSpellSerpentsSwiftness", "Interface/icons/ability_hunter_serpentswiftness", "|cffffffffRapidité du serpent|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente votre vitesse d'attaque en combat à distance de 20% et la vitesse d'attaque en mêlée de votre familier de 20%.|r", "spellserpensswiftness", 315, -293)
CreateSpellButton("buttonSpellLongevity", "Interface/icons/ability_hunter_longevity", "|cffffffffLongévité|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Réduit le temps de recharge de Courroux bestial, Intimidation et des techniques spéciales de familier de 30%.|r", "spelllongevity", 422, -293)
CreateSpellButton("buttonSpellTheBeastWithin", "Interface/icons/ability_hunter_beastwithin", "|cffffffffLa bête intérieure|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente tous les dégâts que vous infligez de 10% et lorsque votre familier est sous l'effet de Courroux bestial, vous aussi devenez fou de rage.\nVous infligez 10% de points de dégâts supplémentaires et le coût en mana de tous vos sorts est réduit de 50% pendant 10 seconds.\nTant que vous êtes dans cet état, vous n'éprouvez ni pitié, ni remords, ni peur, et vous ne pouvez plus être arrêté à moins d'être tué.|r", "spellthebeastwithin", 527, -295)
CreateSpellButton("buttonSpellCobraStrikes", "Interface/icons/ability_hunter_cobrastrikes", "|cffffffffFrappes de cobra|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Lorsque vous réussissez un coup critique avec Tir des arcanes, Tir assuré ou Tir mortel, vous avez 60% de chances de permettre aux 2 prochaines attaques spéciales de votre familier d'être des coups critiques.|r", "spellcobrastrikes", 43, -350)
CreateSpellButton("buttonSpellKindredSpirits", "Interface/icons/ability_hunter_separationanxiety", "|cffffffffAmes soeurs|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente les dégâts infligés par votre familier de 20% et la vitesse de déplacement de votre familier ainsi que la vôtre de 10% tant que votre familier est actif.\nNe se cumule pas avec les autres effets qui augmentent la vitesse de déplacement.|r", "spellkindredspirits", 150, -350)
CreateSpellButton("buttonSpellBeastMastery|r", "Interface/icons/ability_hunter_beastmastery", "|cffffffffMaîtrise des bêtes|r\n|cffffffffTalent|r |cff0067ceMaitrise des Bêtes|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Vous maîtrisez l'art de la maîtrise des bêtes, ce qui vous permet de dompter les familiers exotiques et augmente votre montant total de points en compétence de familiers de 4.|r", "spellbeastmastery", 260, -350)
CreateSpellButton("buttonSpellImprovedConcussiveShot", "Interface/icons/spell_frost_stun", "|cffffffffTrait de choc amélioré|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente la durée de l'effet d'hébétement de votre Trait de choc de 2 sec.|r", "spellimprovedconcussiveshot", 368, -350)
CreateSpellButton("buttonSpellFocusedAim", "Interface/icons/ability_hunter_focusedaim", "|cffffffffVisée focalisée|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Réduit de 70% l'interruption causée par les attaques infligeant des dégâts pendant que vous lancez Tir assuré et augmente de 3% les chances de toucher.|r", "spellfocusedaim", 478, -350)


CreateSpellButton("buttonSpellLethalShots", "Interface/icons/ability_searingarrow", "|cffffffffCoups fatals|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente vos chances d'infliger un coup critique avec vos armes à distance de 5%.|r", "spelllethalshots", 98, -405)
CreateSpellButton("buttonSpellCarefulAim", "Interface/icons/ability_hunter_zenarchery", "|cffffffffVisée minutieuse|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente votre puissance d'attaque à distance d'un montant égal à 100% de votre total d'Intelligence.|r", "spellcarefulaim", 205, -405)
CreateSpellButton("buttonSpellImprovedHuntersMark", "Interface/icons/ability_hunter_snipershot", "|cffffffffMarque du chasseur améliorée|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente le bonus à la puissance d'attaque conféré par votre technique Marque du chasseur de 30% et réduit le coût en mana de votre technique Marque du chasseur de 100%.|r", "spellimprovedhuntersmark", 315, -405)
CreateSpellButton("buttonSpellMortalShots", "Interface/icons/ability_piercedamage", "|cffffffffCoups mortels|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente le bonus de dégâts de vos coups critiques avec vos techniques à distance de 30%.|r", "spellmortalshots", 422, -405)
CreateSpellButton("buttonSpellGofortheThroat", "Interface/icons/ability_hunter_goforthethroat", "|cffffffffA la gorge|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Vos coups critiques à distance font générer à votre familier 50 points de focalisation.|r", "spellgoforthethroat", 43, -458)
CreateSpellButton("buttonSpellImprovedArcaneShot", "Interface/icons/ability_impalingbolt", "|cffffffffTir des arcanes amélioré|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente les dégâts infligés par votre Tir des arcanes de 15%.|r", "spellimprovedarcaneshot", 150, -458)
CreateSpellButton("buttonSpellAimedShot", "Interface/icons/inv_spear_07", "|cffffffffVisée|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Un tir précis qui augmente les points de dégâts infligés par votre attaque à distance de 5 et réduit les soins prodigués à cette cible de 50%.\nDure 10 secondes.|r", "spellaimedshot", 260, -458)
CreateSpellButton("buttonSpellRapidKilling", "Interface/icons/ability_hunter_rapidkilling", "|cffffffffTueur rapide|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Réduit le temps de recharge de votre technique Tir rapide de 2 min.\nDe plus, lorsque vous tuez un adversaire qui vous rapporte de l'expérience ou de l'honneur, votre prochaine utilisation de Visée, Tir des arcanes ou Tir de la chimère inflige 20% de dégâts supplémentaires.\nDure 20 secondes.|r", "spellrapidkilling", 368, -458)
CreateSpellButton("buttonSpellImprovedStings", "Interface/icons/ability_hunter_quickshot", "|cffffffffMorsures et piqûres améliorées|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente les points de dégâts infligés par Morsure de serpent et Piqûre de wyverne de 30% et les points de mana drainés par votre Morsure de vipère de 30%.\nDe plus, réduit la probabilité que les effets de dégâts sur la durée de vos morsures et piqûres soient dissipés de 30%.|r", "spellimprovedstings", 478, -458)
CreateSpellButton("buttonSpellEfficiency", "Interface/icons/spell_frost_wizardmark", "|cffffffffEfficacité|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Réduit le coût en mana de vos Tirs, Morsures et Piqûres de 15%.|r", "spellefficiency", 98, -510)
CreateSpellButton("buttonSpellConcussiveBarrage", "Interface/icons/spell_arcane_starfire", "|cffffffffBarrage commotionnant|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Vos attaques réussies avec Tir de la chimère et Flèches multiples vous confèrent 100% de chances d'hébéter la cible pendant 4 secondes.|r", "spellconcussivebarrage", 205, -510)
CreateSpellButton("buttonSpellReadiness", "Interface/icons/ability_hunter_readiness", "|cffffffffPromptitude|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Quand elle est activée, cette technique met immédiatement fin au temps de recharge de vos autres techniques de chasseur, sauf Courroux bestial.|r", "spellreadiness", 315, -510)
CreateSpellButton("buttonSpellBarrage", "Interface/icons/ability_upgrademoonglaive", "|cffffffffBarrage|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente les dégâts infligés par vos sorts Flèches multiples, Visée et Salve de 12%.|r", "spellbarrage", 422, -510)


CreateSpellButton("buttonSpellCombatExperience", "Interface/icons/ability_hunter_combatexperience", "|cffffffffExpérience du combat|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente votre total d'Agilité et votre total d'Intelligence de 4%.|r", "spellcombatexperience", 663, -75)
CreateSpellButton("buttonSpellRangedWeaponSpecialization", "Interface/icons/inv_weapon_rifle_06", "|cffffffffSpécialisation Armes à distance|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente les points de dégâts que vous infligez avec les armes à distance de 5%.|r", "spellrangedweaponspecialization", 770, -75)
CreateSpellButton("buttonSpellPiercingShots", "Interface/icons/ability_hunter_piercingshots", "|cffffffffTirs perforants|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Vos critiques réussis avec Visée, Tir assuré et Tir de la chimère font saigner la cible, qui perd un montant de points de vie égal à 30% des dégâts infligés en 8 seconds.|r", "spellpiercingshots", 880, -75)
CreateSpellButton("buttonSpellTrueshotAura", "Interface/icons/ability_trueshot", "|cffffffffAura de précision|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente de 10% la puissance d'attaque des membres du groupe ou du raid qui se trouvent dans un rayon de 100 mètres.\nDure jusqu'à annulation.|r", "spelltrueshotaura", 990, -75)
CreateSpellButton("buttonSpellImprovedBarrage", "Interface/icons/ability_upgrademoonglaive", "|cffffffffBarrage amélioré|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente vos chances de réaliser un coup critique avec vos techniques Flèches multiples et Visée de 12% et réduit de 100% les interruptions causées par les attaques infligeant des dégâts pendant que vous canalisez Salve.|r", "spellimprovedbarrage", 1100, -75)
CreateSpellButton("buttonSpellMasterMarksman", "Interface/icons/ability_hunter_mastermarksman", "|cffffffffMaître tireur|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente vos chances de coup critique de 5% et réduit le coût en mana de votre Tir assuré, Visée et Tir de la chimère de 25%.|r", "spellmastermarksman", 718, -130)
CreateSpellButton("buttonSpellRapidRecuperation", "Interface/icons/ability_hunter_rapidregeneration", "|cffffffffRecouvrement rapide|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Vous recevez 4% de votre mana toutes les 3 sec.\nquand vous êtes sous l'effet de Tir rapide, et vous recevez 2% de votre mana toutes les 2 sec.\npendant 6 secondes quand vous bénéficiez de Tueur rapide.|r", "spellrapidrecuperation", 825, -130)
CreateSpellButton("buttonSpellWildQuiver", "Interface/icons/ability_hunter_wildquiver", "|cffffffffCarquois sauvage|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Vous avez 12% de chances de réaliser un tir supplémentaire lorsque vous infligez des dégâts avec votre tir automatique, infligeant 80% des dégâts de l'arme sous forme de dégâts de Nature.\nCarquois sauvage ne consomme pas de munitions.|r", "spellwildquiver", 935, -130)
CreateSpellButton("buttonSpellSilencingShot", "Interface/icons/ability_theblackarrow", "|cffffffffFlèche-bâillon|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Un tir qui inflige 50% des dégâts de l'arme et réduit la cible au silence pendant 3 secondes.\nLes incantations de sorts des victimes personnages non joueurs sont également interrompues pendant 3 secondes.|r", "spellsilencingshot", 1045, -130)
CreateSpellButton("buttonSpellImprovedSteadyShot", "Interface/icons/ability_hunter_improvedsteadyshot", "|cffffffffTir assuré amélioré|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Vos Tirs assurés réussis ont 15% de chances d'augmenter les dégâts infligés par votre prochaine utilisation de Visée,\nTir des arcanes ou Tir de la chimère de 15%, ainsi que de réduire le coût en mana de votre prochaine utilisation de Visée, Tir des arcanes ou Tir de la chimère de 20%.|r", "spellimprovedsteadyshot", 663, -184)
CreateSpellButton("buttonSpellMarkedforDeath", "Interface/icons/ability_hunter_assassinate", "|cffffffffDésigné pour mourir|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente de 5% les dégâts infligés par vos tirs et par les techniques spéciales de votre familier sur les cibles marquées\net augmente de 10% le bonus aux dégâts des coups critiques de Visée, Tir des arcanes, Tir assuré, Tir mortel et Tir de la chimère.|r", "spellmarkedfordeath", 770, -184)
CreateSpellButton("buttonSpellChimeraShot", "Interface/icons/ability_hunter_chimerashot2", "|cffffffffTir de la chimère|r\n|cffffffffTalent|r |cffff8040Précision|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Vous infligez 125% des dégâts de l'arme, réinitialisez la piqûre ou morsure actuelle sur votre cible et déclenchez un effet : Morsure de serpent - Inflige instantanément 40% des dégâts de votre Morsure de serpent.|r", "spellchimerashot", 880, -184)
CreateSpellButton("buttonSpellImprovedTracking", "Interface/icons/ability_hunter_improvedtracking", "|cffffffffPistage amélioré|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Lorsque le chasseur piste les bêtes, les démons, les draconiens, les élémentaires, les géants, les humanoïdes ou les morts-vivants, tous les dégâts infligés à ce type de créatures sont augmentés de 5%.|r", "spellimprovedtracking", 990, -184)
CreateSpellButton("buttonSpellHawkEye", "Interface/icons/ability_townwatch", "|cffffffffOeil de faucon|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente la portée de vos armes à distance de 6 mètres.|r", "spellhawkeye", 1100, -184)



CreateSpellButton("buttonSpellSavageStrikes", "Interface/icons/ability_racial_bloodrage", "|cffffffffFrappes sauvages|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente de 20% les chances d'infliger un coup critique avec Attaque du raptor, Morsure de la mangouste et Contre-attaque.|r", "spellsavagestrikes", 718, -240)
CreateSpellButton("buttonSpellSurefooted", "Interface/icons/ability_kick", "|cffffffffPied sûr|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Diminue la durée des effets affectant le mouvement de 30%.|r", "spellsurefooted", 825, -240)
CreateSpellButton("buttonSpellEntrapment", "Interface/icons/spell_nature_stranglevines", "|cffffffffPiège|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Lorsque votre Piège de givre ou Piège à serpent est déclenché, vous emprisonnez toutes les cibles affectées, les empêchant de se déplacer pendant 4 secondes.|r", "spellentrapment", 935, -240)
CreateSpellButton("buttonSpellTrapMastery", "Interface/icons/ability_ensnare", "|cffffffffMaîtrise des pièges|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Piège de givre et Piège givrant - Augmente la durée de 30%.\nPiège d'immolation, Piège explosif et Flèche noire - Augmente les dégâts périodiques infligés de 30%.\nPiège à serpent - Augmente le nombre de serpents.|r", "spelltrapmastery", 1045, -240)
CreateSpellButton("buttonSpellSurvivalInstincts", "Interface/icons/ability_hunter_survivalinstincts", "|cffffffffInstincts de survie|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Réduit tous les dégâts subis de 4% et augmente les chances de coup critique de vos Tirs des arcanes, Tirs assurés et Tirs explosifs de 4%.|r", "spellsurvivalinstincts", 663, -293)
CreateSpellButton("buttonSpellSurvivalist", "Interface/icons/spell_shadow_twilight", "|cffffffffSurvivant|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente votre Endurance de 10%.|r", "spellsurvivalist", 770, -293)
CreateSpellButton("buttonSpellScatterShot", "Interface/icons/ability_golemstormbolt", "|cffffffffFlèche de dispersion|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Un tir à courte distance qui inflige 50% des dégâts de l'arme et désoriente la cible pendant 4 secondes.\nSi la cible subit des dégâts, l'effet est annulé.\nInterrompt l'attaque lors de son utilisation.|r", "spellscattershot", 990, -293)
CreateSpellButton("buttonSpellDeflection", "Interface/icons/ability_parry", "|cffffffffDéviation|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente vos chances de Parer de 3% et réduit la durée de tous les effets de désarmement sur vous de 50%.\nNon cumulable avec les autres effets qui réduisent la durée du désarmement.|r", "spelldeflection", 1100, -293)
CreateSpellButton("buttonSpellSurvivalTactics", "Interface/icons/ability_rogue_feigndeath", "|cffffffffTactique de survie|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Réduit la probabilité que l'on résiste à votre technique Feindre la mort et à tous vos sorts de pièges de 4% et réduit le temps de recharge de votre technique Désengagement de 4 sec.|r", "spellsurvivaltactics", 718, -348)
CreateSpellButton("buttonSpellTNT", "Interface/icons/inv_misc_bomb_05", "|cffffffffT.N.T.|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente les dégâts infligés par votre Tir explosif, votre Piège explosif, votre Flèche noire et votre Piège d'immolation de 6%.|r", "spelltnt", 825, -348)
CreateSpellButton("buttonSpellLockandLoad", "Interface/icons/ability_hunter_lockandload", "|cffffffffPrêt à tirer|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Vous avez 100% de chances lorsque vous piégez une cible avec Piège givrant, Flèche givrante ou Piège de givre et 6% de chances lorsque vous infligez des dégâts périodiques avec Piège d'immolation,\nPiège explosif ou Flèche noire que vos 2 prochains sorts Tir des arcanes ou Tir explosif ne déclenchent pas de temps de recharge, ne coûtent pas de mana et ne consomment pas de munitions.\nCet effet a un temps de recharge de 22 sec.|r", "spelllockandload", 935, -348)
CreateSpellButton("buttonSpellHuntervsWild", "Interface/icons/ability_hunter_huntervswild", "|cffffffffFace à la nature|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente votre puissance d'attaque et votre puissance d'attaque à distance, ainsi que celles de votre familier, d'un montant égal à 30% de votre total d'Endurance.|r", "spellhuntervswild", 1045, -348)
CreateSpellButton("buttonSpellKillerInstinct", "Interface/icons/spell_holy_blessingofstamina", "|cffffffffInstinct du tueur|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente vos chances d'infliger un coup critique avec toutes vos attaques de 3%.|r", "spellkillerinstinct", 663, -402)
CreateSpellButton("buttonSpellImprovedBlizzard", "Interface/icons/spell_frost_icestorm", "|cffffffffBlizzard amélioré|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Ajoute un effet d'engourdissement à votre sort Blizzard.\nIl réduit la vitesse de déplacement de la cible de 50%.\nDure 1.5 seconds.|r", "spellimprovedblizzard", 770, -402)
CreateSpellButton("buttonSpellCounterattack", "Interface/icons/ability_warrior_challange", "|cffffffffContre-attaque|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Une attaque disponible après avoir paré une attaque de l'adversaire.\nElle inflige 1 points de dégâts et immobilise la cible pendant 5 seconds.\nContre-attaque ne peut pas être bloquée, esquivée ou parée.|r", "spellcounterattack", 880, -402)
CreateSpellButton("buttonSpellLightningReflexes", "Interface/icons/spell_nature_invisibilty", "|cffffffffRéflexes éclairs|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente votre Agilité de 15%.|r", "spelllightningreflexes", 990, -402)
CreateSpellButton("buttonSpellResourcefulness", "Interface/icons/ability_hunter_resourcefulness", "|cffffffffRessource|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Réduit le coût en mana de tous les pièges et techniques de mêlée ainsi que de Flèche noire de 60% et réduit le temps de recharge de tous les pièges et de Flèche noire de 6 sec.|r", "spellresourcefulness", 1100, -402)
CreateSpellButton("buttonSpellExposeWeakness", "Interface/icons/ability_rogue_findweakness", "|cffffffffPerce-faille|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Vos coups critiques à distance ont 100% de chances de vous faire bénéficier de Perce-faille.\nPerce-faille augmente votre puissance d'attaque de 25% de votre Agilité pendant 7 secondes.|r", "spellexposeweakness", 718, -456)
CreateSpellButton("buttonSpellWyvernSting", "Interface/icons/inv_spear_02", "|cffffffffPiqûre de wyverne|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Une piqûre qui endort la cible pendant 30 secondes.\nTout point de dégâts subi par la cible annule l'effet.\nQuand la cible se réveille, la Piqûre inflige 300 points de dégâts de Nature en 6 secondes.\nUne seule technique de Morsure ou de Piqûre par chasseur peut être active sur la cible en même temps.|r", "spellwyvernsting", 825, -456)
CreateSpellButton("buttonSpellThrilloftheHunt", "Interface/icons/ability_hunter_thrillofthehunt", "|cffffffffFrisson de la chasse|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Vous confère 100% de chances de récupérer 40% du coût en mana de n'importe quel tir lorsqu'il inflige un coup critique.|r", "spellthrillofthehunt", 935, -456)
CreateSpellButton("buttonSpellMasterTactician", "Interface/icons/ability_hunter_mastertactitian", "|cffffffffMaître tacticien|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Vos attaques à distance réussies ont 10% de chances d'augmenter vos chances de coup critique avec toutes les attaques de 10% pendant 8 secondes.|r", "spellmastertactician", 1045, -456)
CreateSpellButton("buttonSpellNoxiousStings", "Interface/icons/ability_hunter_potentvenom", "|cffffffffPiqûres nocives|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Si Piqûre de wyverne est dissipée, celui qui la dissipe est également affecté par Piqûre de wyverne pour une durée de 50% du temps restant.\nAugmente également tous les dégâts que vous infligez aux cibles affectées par votre Morsure de serpent de 3%.|r", "spellnoxiousstings", 663, -510)
CreateSpellButton("buttonSpellPointofNoEscape", "Interface/icons/ability_hunter_pointofnoescape", "|cffffffffPlus d'échappatoire|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente de 6% les chances de réussir un coup critique avec toutes vos attaques sur les cibles affectées par vos Pièges de givre, Pièges givrants et Flèches givrantes.|r", "spellpointofnoescape", 770, -510)
CreateSpellButton("buttonSpellBlackArrow", "Interface/icons/spell_shadow_painspike", "|cffffffffFlèche noire|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Tire une Flèche noire sur la cible, ce qui augmente tous les dégâts que vous infligez à la cible de 6% et inflige 1116 points de dégâts d'Ombre en 15 secondes.\nFlèche noire partage le temps de recharge de vos sorts de piège.|r", "spellblackarrow", 880, -510)
CreateSpellButton("buttonSpellSniperTraining", "Interface/icons/ability_hunter_longshots", "|cffffffffEntraînement de sniper|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente les chances de coup critique de votre technique Tir mortel de 15%, et si vous restez immobile pendant 6 sec.,\nvous bénéficiez d'Entraînement de sniper qui augmente les dégâts infligés avec Tir assuré, Visée, Flèche noire et Tir explosif de 6% pendant 15 secondes.|r", "spellsnipertraining", 990, -510)
CreateSpellButton("buttonSpellHuntingParty", "Interface/icons/ability_hunter_huntingparty", "|cffffffffPartie de chasse|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Augmente votre total d'Agilité de 3% supplémentaires, et vos coups critiques réussis avec Tir des arcanes,\nTir explosif et Tir assuré ont 100% de chances de faire bénéficier jusqu'à 10 membres du groupe ou raid d'une régénération de mana égale à 1% du maximum de mana toutes les 5 sec.\nDure 15 secondes.|r", "spellhuntingparty", 1100, -510)
CreateSpellButton("buttonSpellExplosiveShot", "Interface/icons/ability_hunter_explosiveshot", "|cffffffffTir explosif|r\n|cffffffffTalent|r |cff00ea00Survie|r\n|cffffffffRequiert|r |cffa9d271Chasseur|r\n|cffffd100Vous lancez une charge explosive sur la cible, infligeant 216-244 points de dégâts de Feu.\nLa charge explose ensuite sur la cible toutes les secondes pendant 2 secondes.\nsupplémentaires.|r", "spellexplosiveshot", 1100, -510)




local resetButtonClicked = false

local buttonReset = CreateFrame("Button", "buttonReset", frameTalentHunter, "UIPanelButtonTemplate")
buttonReset:SetSize(85, 25)
buttonReset:SetPoint("BOTTOMRIGHT", buttonTalentHunterClose, "BOTTOMLEFT", -95, 5)
buttonReset:SetText("Réinitialiser")

local function ResetTalents()
    AIO.Handle("TalentHunterspell", "ResetTalents")
    resetButtonClicked = true
end

buttonReset:SetScript("OnClick", ResetTalents)

local buttonReload = CreateFrame("Button", "buttonReload", frameTalentHunter, "UIPanelButtonTemplate")
buttonReload:SetSize(85, 25)
buttonReload:SetPoint("BOTTOMRIGHT", buttonTalentHunterClose, "BOTTOMLEFT", -5, 5)
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
        frameTalentHunter:Hide()
        buttonReload:Hide()
        PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
    else
        frameTalentHunter:Show()
        buttonReload:Show()
        PlaySoundFile(OPEN_TALENT_WINDOW_SOUND)
    end

    talentsWindowOpen = not talentsWindowOpen
end

local playerClass = select(2, UnitClass("player"))
if playerClass == "HUNTER" then
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
        GameTooltip:SetText("|cffffffffTalents|r |cffa9d271(Chasseur)|r\n\nL'éventail des talents disponibles\npour améliorer et spécialiser\nvotre personnage.")
        GameTooltip:Show()
    end)

    buttonOuvrirTalents:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    buttonOuvrirTalents:SetScript("OnClick", OuvrirFermerInterfaceTalents)
    TalentMicroButton:Hide()
end

HunterHandlers.UpdateTalentCount = function(player, talentsAppris)
    if fontTalentHunterFrameText then
        fontTalentHunterFrameText:SetText(talentsAppris .. " / " .. MAX_TALENTS)
    end
end

HunterHandlers.UpdateTalentPointsUsed = function(player, pointsUsed, pointsBeforeReset)
    print("|cff00ffffVous avez utilisés " .. pointsBeforeReset .. " points avant la réinitialisation des talents|r")
end