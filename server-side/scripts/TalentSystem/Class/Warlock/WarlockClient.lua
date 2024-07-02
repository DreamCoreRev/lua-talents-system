local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local WarlockHandlers = AIO.AddHandlers("TalentWarlockspell", {})

function WarlockHandlers.ShowTalentWarlock(player)
    frameTalentWarlock:Show()
end

local MAX_TALENTS = 41

local OPEN_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_final_trait_unlocked.ogg"
local CLOSE_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_trait_refund_end.ogg"
local SPELL_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_80_azeritearmor_rotationends_02.ogg"

local frameTalentWarlock = CreateFrame("Frame", "frameTalentWarlock", UIParent)
frameTalentWarlock:SetSize(1200, 650)
frameTalentWarlock:SetMovable(true)
frameTalentWarlock:EnableMouse(true)
frameTalentWarlock:RegisterForDrag("LeftButton")
frameTalentWarlock:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
frameTalentWarlock:SetBackdrop(
{
    bgFile = "interface/TalentFrame/Template/Class/Warlock/talentsclassbackgroundwarlock",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedwarlock",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

local warlockIcon = frameTalentWarlock:CreateTexture("WarlockIcon", "OVERLAY")
warlockIcon:SetTexture("Interface\\TalentFrame\\Template\\Class\\Warlock\\IconeWarlock.blp")
warlockIcon:SetSize(60, 60)
warlockIcon:SetPoint("TOPLEFT", frameTalentWarlock, "TOPLEFT", -10, 10)


local textureone = frameTalentWarlock:CreateTexture("TemplateTalentFrame", "OVERLAY")
textureone:SetTexture("Interface\\TalentFrame\\Template\\Class\\Warlock\\TalentFrameTemplate.blp")
textureone:SetSize(928, 928)
textureone:SetPoint("TOPLEFT", frameTalentWarlock, "TOPLEFT", -170, 140)

frameTalentWarlock:SetFrameLevel(100)

local texturetwo = frameTalentWarlock:CreateTexture("TemplateTalentFrame", "OVERLAY")
texturetwo:SetTexture("Interface\\TalentFrame\\Template\\Class\\Warlock\\TalentFrameTemplateOriginal.blp")
texturetwo:SetSize(928, 928)
texturetwo:SetPoint("TOPRIGHT", frameTalentWarlock, "TOPRIGHT", 170, 140)

frameTalentWarlock:SetFrameLevel(100)

frameTalentWarlock:SetScript("OnDragStart", frameTalentWarlock.StartMoving)
frameTalentWarlock:SetScript("OnHide", frameTalentWarlock.StopMovingOrSizing)
frameTalentWarlock:SetScript("OnDragStop", frameTalentWarlock.StopMovingOrSizing)
frameTalentWarlock:Hide()

frameTalentWarlock:SetBackdropBorderColor(135, 135, 237)

local buttonTalentWarlockClose = CreateFrame("Button", "buttonTalentWarlockClose", frameTalentWarlock, "UIPanelCloseButton")
buttonTalentWarlockClose:SetPoint("TOPRIGHT", -12, -12)
buttonTalentWarlockClose:EnableMouse(true)
buttonTalentWarlockClose:SetSize(32, 32)

local function CloseTalentWindow()
    frameTalentWarlock:Hide()
    PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
end

buttonTalentWarlockClose:SetScript("OnClick", CloseTalentWindow)

local frameTalentWarlockTitleBar = CreateFrame("Frame", "frameTalentWarlockTitleBar", frameTalentWarlock, nil)
frameTalentWarlockTitleBar:SetSize(135, 25)
frameTalentWarlockTitleBar:SetBackdrop(
{
    bgFile = "interface/corrupteditems/corruptedtooltipbackground",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedwarlock",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameTalentWarlockTitleBar:SetPoint("TOP", 0, 20)

local fontTalentWarlockTitleText = frameTalentWarlockTitleBar:CreateFontString("fontTalentWarlockTitleText")
fontTalentWarlockTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontTalentWarlockTitleText:SetSize(190, 5)
fontTalentWarlockTitleText:SetPoint("CENTER", 0, 0)
fontTalentWarlockTitleText:SetText("|cffFFC125Talents|r")

local fontTalentWarlockFrameText = frameTalentWarlockTitleBar:CreateFontString("fontTalentWarlockFrameText")
fontTalentWarlockFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentWarlockFrameText:SetSize(200, 5)
fontTalentWarlockFrameText:SetPoint("TOPLEFT", frameTalentWarlockTitleBar, "BOTTOMLEFT", -30, -35)
fontTalentWarlockFrameText:SetText("|cffFFC125Démoniste|r")

local fontTalentWarlockFrameText = frameTalentWarlockTitleBar:CreateFontString("fontTalentWarlockFrameText")
fontTalentWarlockFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentWarlockFrameText:SetSize(200, 5)
fontTalentWarlockFrameText:SetPoint("TOPLEFT", frameTalentWarlockTitleBar, "BOTTOMLEFT", -30, -60)
fontTalentWarlockFrameText:SetText("0 / " .. MAX_TALENTS)



local function CreateSpellButton(name, texturePath, tooltipText, talentHandler, positionX, positionY)
    local buttonClicked = false
    local talentLearned = false

    local button = CreateFrame("Button", name, frameTalentWarlock, nil)
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
                AIO.Handle("TalentWarlockspell", talentHandler, 1)
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






CreateSpellButton("buttonSpellImprovedCurseofAgony", "Interface/icons/spell_shadow_curseofsargeras", "|cffffffffMalédiction d'agonie améliorée|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente les dégâts infligés par votre sort Malédiction d'agonie de 10%.|r", "spellimprovedcurseofagony", 100, -80)
CreateSpellButton("buttonSpellSuppression", "Interface/icons/spell_shadow_unsummonbuilding", "|cffffffffSuppression|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente de 3% vos chances de toucher avec les sorts, et réduit de 6% le coût en mana de vos sorts d'Affliction.|r", "spellsuppression", 205, -75)
CreateSpellButton("buttonSpellImprovedCorruption", "Interface/icons/spell_shadow_abominationexplosion", "|cffffffffCorruption améliorée|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente les dégâts infligés par votre Corruption de 10% et augmente les chances de coup critique de votre Graine de Corruption de 5%.|r", "spellimprovedcorruption", 315, -75)
CreateSpellButton("buttonSpellImprovedCurseofWeakness", "Interface/icons/spell_shadow_curseofmannoroth", "|cffffffffMalédiction de faiblesse améliorée|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente de 20% le montant de puissance d'attaque réduit par votre Malédiction de faiblesse.|r", "spellimprovedcurseofweakness", 418, -80)
CreateSpellButton("buttonSpellImprovedDrainSoul", "Interface/icons/spell_shadow_haunting", "|cffffffffDrain d'âme amélioré|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Vous rend 15% de votre maximum de points de mana si vous tuez la cible pendant que vous drainez son âme.\nDe plus, vos sorts d'Affliction génèrent 20% de menace en moins.|r", "spellimproveddrainsoul", 45, -130)
CreateSpellButton("buttonSpellImprovedLifeTap", "Interface/icons/spell_shadow_burningspirit", "|cffffffffConnexion améliorée|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente de 20% le montant de mana octroyé par votre sort Connexion.|r", "spellimprovedlifetap", 150, -130)
CreateSpellButton("buttonSpellSoulSiphon", "Interface/icons/spell_shadow_lifedrain02", "|cffffffffSiphon d'âme|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente le montant de points drainé par vos sorts Drain de vie et Drain d'âme de 6% supplémentaires pour chaque effet d'Affliction sur la cible, jusqu'à un maximum de 18% d'effet supplémentaire.|r", "spellsoulsiphon", 260, -130)
CreateSpellButton("buttonSpellImprovedFear", "Interface/icons/spell_shadow_possession", "|cffffffffPeur améliorée|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Votre sort Peur inflige un Cauchemar à la cible lorsque l'effet de peur prend fin.\nCauchemar réduit la vitesse de déplacement de la cible de 30% pendant 5 seconds.|r", "spellimprovedfear", 370, -130)
CreateSpellButton("buttonSpellFelConcentration", "Interface/icons/spell_shadow_fingerofdeath", "|cffffffffConcentration corrompue|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Réduit de 70% l'interruption causée par les attaques infligeant des dégâts pendant que vous incantez Drain de vie, Drain de mana, Drain d'âme, Affliction instable et Hanter.|r", "spelllfelconcentration", 475, -133)
CreateSpellButton("buttonSpellAmplifyCurse", "Interface/icons/spell_shadow_contagion", "|cffffffffMalédiction amplifiée|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Réduit le temps de recharge global de vos Malédictions de 0.5 sec.|r", "spellamplifycurse", 96, -185)
CreateSpellButton("buttonSpellGrimReach", "Interface/icons/spell_shadow_callofbone", "|cffffffffAllonge sinistre|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente la portée de vos sorts d'Affliction de 20%.|r", "spellgrimreach", 205, -185)
CreateSpellButton("buttonSpellNightfall", "Interface/icons/spell_shadow_twilight", "|cffffffffCrépuscule|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Confère à vos sorts Corruption et Drain de vie 4% de chances de vous plonger dans un état de Transe de l'ombre après avoir infligé des dégâts à un adversaire.\nCet état réduit le temps d'incantation de votre prochain sort Trait de l'ombre de 100%.|r", "spellnightfall", 315, -185)
CreateSpellButton("buttonSpellEmpoweredCorruption", "Interface/icons/spell_shadow_abominationexplosion", "|cffffffffCorruption surpuissante|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente les dégâts de votre sort Corruption d'un montant égal à 36% de votre puissance des sorts.|r", "spellempoweredcorruption", 422, -185)
CreateSpellButton("buttonSpellShadowEmbrace", "Interface/icons/spell_shadow_shadowembrace", "|cffffffffEtreinte de l'ombre|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Vos sorts Trait de l'ombre et Hanter provoquent aussi l'effet Etreinte de l'ombre,\nqui augmente tous les dégâts d'Ombre périodiques que vous infligez à la cible de 5%,\net réduit tous les soins périodiques prodigués à la cible de 10%.\nDure 12 seconds.\nCumulable jusqu'à 3 fois.|r", "spellshadowembrace", 527, -190)
CreateSpellButton("buttonSpellSiphonLife", "Interface/icons/spell_shadow_requiem", "|cffffffffSiphon de vie|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Quand vous infligez des dégâts avec votre sort Corruption, vous recevez instantanément un montant de points de vie égal à 40% des dégâts infligés.\nDe plus, les dégâts infligés par les effets sur la durée de votre Corruption, votre Graine de Corruption et votre Affliction instable sont augmentés de 5%.|r", "spellsiphonlife", 43, -240)
CreateSpellButton("buttonSpellCurseofExhaustion", "Interface/icons/spell_shadow_grimward", "|cffffffffMalédiction d'épuisement|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Réduit la vitesse de la cible de 30% pendant 12 seconds.\nLa cible ne peut être victime que d'une malédiction par démoniste présent à la fois.|r", "spellcurseofexhaustion", 150, -240)
CreateSpellButton("buttonSpellImprovedFelhunter", "Interface/icons/spell_shadow_summonfelhunter", "|cffffffffChasseur corrompu amélioré|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Votre chasseur corrompu reçoit 8% de son maximum de mana chaque fois qu'il touche avec sa technique Morsure de l'ombre et le temps de recharge de cette technique est réduit de 4 sec.\nAugmente également l'effet de l'Intelligence gangrenée de votre chasseur corrompu de 10%.|r", "spellimprovedfelhunter", 368, -240)
CreateSpellButton("buttonSpellShadowMastery", "Interface/icons/spell_shadow_shadetruesight", "|cffffffffMaîtrise de l'ombre|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente de 15% les points de dégâts infligés ou les points de vie drainés par vos sorts d'Ombre et la technique Morsure de l'ombre de votre chasseur corrompu.|r", "spellshadowmastery", 478, -240)
CreateSpellButton("buttonSpellEradication", "Interface/icons/ability_warlock_eradication", "|cffffffffEradication|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Quand vous infligez des dégâts avec Corruption, vous avez 6% de chances d'augmenter votre vitesse d'incantation des sorts de 20% pendant 10 seconds.|r", "spelleradication", 98, -293)
CreateSpellButton("buttonSpellContagion", "Interface/icons/spell_shadow_painfulafflictions", "|cffffffffContagion|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente les points de dégâts infligés par Malédiction d'agonie,\nCorruption et Graine de Corruption de 5% et réduit la probabilité que vos sorts d'Affliction et vos effets de dégâts sur la durée soient dissipés de 30% supplémentaires.|r", "spellcontagion", 205, -293)
CreateSpellButton("buttonSpellDarkPact", "Interface/icons/spell_shadow_darkritual", "|cffffffffPacte noir|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Draine 305 points de mana à votre démon invoqué et vous rend 100% du montant.|r", "spelldarkpact", 315, -293)
CreateSpellButton("buttonSpellImprovedHowlofTerror", "Interface/icons/spell_shadow_deathscream", "|cffffffffHurlement de terreur amélioré|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Réduit le temps d'incantation de votre sort Hurlement de terreur de 1.5 sec.|r", "spellimprovedhowlofterror", 422, -293)
CreateSpellButton("buttonSpellMalediction", "Interface/icons/spell_shadow_curseofachimonde", "|cffffffffImprécation|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente vos dégâts des sorts de 3% et augmente les chances de coup critique périodique de vos sorts Corruption et Affliction instable de 9%.|r", "spellmalediction", 527, -295)
CreateSpellButton("buttonSpellDeathsEmbrace", "Interface/icons/spell_shadow_deathsembrace", "|cffffffffCaresse de la mort|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente le montant de points de vie drainés par votre Drain de vie de 30% quand vous disposez de 20% ou moins de vos points de vie,\net augmente les dégâts infligés par vos sorts d'Ombre de 12% quand votre cible dispose de 35% ou moins de ses points de vie.|r", "spelldeathsembrace", 43, -350)
CreateSpellButton("buttonSpellUnstableAffliction", "Interface/icons/spell_shadow_unstableaffliction_3", "|cffffffffAffliction instable|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100L’énergie de l’Ombre détruit lentement la cible, infligeant 660 points de dégâts en 15 seconds.\nDe plus, si l'Affliction instable est dissipée, celui qui la dissipe subit 1188 points de dégâts et est réduit au silence pendant 5 seconds.\nUne cible ne peut être victime que d'une seule Affliction instable ou Immolation par démoniste.|r", "spellunstableaffliction", 150, -350)
CreateSpellButton("buttonSpellPandemic", "Interface/icons/spell_shadow_unstableaffliction_2", "|cffffffffPandémie|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Les dégâts périodiques de vos sorts Corruption et Affliction instable peuvent être critiques et infliger 100% de dégâts supplémentaires.\nAugmente également le bonus aux dégâts des coups critiques réussis avec votre sort Hanter de 100%.|r", "spellpandemic", 260, -350)
CreateSpellButton("buttonSpellEverlastingAffliction", "Interface/icons/ability_warlock_everlastingaffliction", "|cffffffffAffliction éternelle|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Vos sorts Corruption et Affliction instable bénéficient de 5% supplémentaires de votre bonus aux dégâts des sorts,\net vos sorts Drain de vie, Drain d'âme, Trait de l'ombre et Hanter ont 100% de chances de réinitialiser la durée de votre sort Corruption sur la cible.|r", "spelleverlastingaffliction", 368, -350)
CreateSpellButton("buttonSpellHaunt", "Interface/icons/ability_warlock_haunt", "|cffffffffHanter|r\n|cffffffffTalent|r |cff008080Affliction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Vous envoyez une âme fantomatique à l'intérieur de la cible, ce qui lui inflige 465 à 544 points de dégâts d'Ombre\net augmente tous les dégâts infligés par vos effets de dégâts d'Ombre sur la durée de 20% pendant 12 seconds.\nQuand le sort Hanter prend fin ou est dissipé, l'âme vous revient et vous soigne pour un montant\nde points de vie égal à 100% des dégâts qu'elle a infligés à la cible.|r", "spellhaunt", 478, -350)


CreateSpellButton("buttonSpellImprovedHealthstone", "Interface/icons/inv_stone_04", "|cffffffffPierre de soins améliorée|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente le montant de points de vie restaurés par votre Pierre de soin de 20%.|r", "spellimprovedhealthstone", 98, -405)
CreateSpellButton("buttonSpellImprovedImp", "Interface/icons/spell_shadow_summonimp", "|cffffffffDiablotin amélioré|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente les effets des sorts Eclair de feu, Bouclier de feu et Pacte de sang de votre diablotin de 30%.|r", "spellimprovedimp", 205, -405)
CreateSpellButton("buttonSpellDemonicEmbrace", "Interface/icons/spell_shadow_metamorphosis", "|cffffffffBaiser démoniaque|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente votre total d'Endurance de 10%.|r", "spelldemonicembrace", 315, -405)
CreateSpellButton("buttonSpellFelSynergy", "Interface/icons/spell_shadow_felmending", "|cffffffffSynergie gangrenée|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Vous avez 100% de chances de rendre à votre familier un montant de points de vie égal à 15% du montant de dégâts que vous infligez avec des sorts.|r", "spellfelsynergy", 422, -405)
CreateSpellButton("buttonSpellImprovedHealthFunnel", "Interface/icons/spell_shadow_lifedrain", "|cffffffffCaptation de vie améliorée|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente le montant de points de vie transférés par votre sort Captation de vie de 20% et réduit le coût initial en points de vie de 20%.\nDe plus, votre démon invoqué subit 30% de dégâts en moins pendant qu'il est sous l'effet de votre Captation de vie.|r", "spellimprovedhealthfunnel", 43, -458)
CreateSpellButton("buttonSpellDemonicBrutality", "Interface/icons/spell_shadow_summonvoidwalker", "|cffffffffBrutalité démoniaque|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente de 30% l'efficacité des sorts Tourment, Consumer les ombres, Sacrifice et Souffrance de votre marcheur du Vide,\net augmente de 3% le bonus à la puissance d'attaque de l'effet Frénésie démoniaque de votre gangregarde.|r", "spelldemonicbrutality", 150, -458)
CreateSpellButton("buttonSpellFelVitality", "Interface/icons/spell_holy_magicalsentry", "|cffffffffVitalité gangrenée|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente de 15% l'Endurance et l'Intelligence de votre diablotin, marcheur du Vide, succube, chasseur corrompu et gangregarde et de 3% votre maximum de points de vie et de mana.|r", "spellfelvitality", 260, -458)
CreateSpellButton("buttonSpellImprovedSayaad", "Interface/icons/spell_shadow_summonsuccubus", "|cffffffffSuccube améliorée|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Réduit le temps d'incantation de la Séduction de votre succube de 66% et augmente la durée de ses sorts Séduction et Invisibilité inférieure de 30%.|r", "spellimprovedsayaad", 368, -458)
CreateSpellButton("buttonSpellSoulLink", "Interface/icons/spell_shadow_gathershadows", "|cffffffffLien spirituel|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Une fois activé, 20% de tous les points de dégâts infligés au lanceur de sorts sont subis à sa place par son diablotin,\nson marcheur du Vide, sa succube, son chasseur corrompu, son gangregarde ou son démon asservi.\nCes dégâts ne peuvent être évités.\nDure aussi longtemps que le démon est actif et sous contrôle.|r", "spellsoullink", 478, -458)
CreateSpellButton("buttonSpellFelDomination", "Interface/icons/spell_nature_removecurse", "|cffffffffDomination corrompue|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Le temps d'incantation de votre prochain sort d'invocation de diablotin, de marcheur du Vide, de succube,\nde chasseur corrompu ou de gangregarde est réduit de S1 sec.\net son coût en mana est réduit de 50%.|r", "spellfeldomination", 98, -510)
CreateSpellButton("buttonSpellDemonicAegis", "Interface/icons/spell_shadow_ragingscream", "|cffffffffEgide démoniaque|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente de 30% l'efficacité de votre Armure démoniaque et de votre Gangrarmure.|r", "spelldemonicaegis", 205, -510)
CreateSpellButton("buttonSpellUnholyPower", "Interface/icons/spell_shadow_shadowworddominate", "|cffffffffPuissance impie|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente de 20% les dégâts infligés par les attaques de mêlée du marcheur du Vide, de la succube,\ndu chasseur corrompu et du gangregarde et par l'Eclair de feu du diablotin.|r", "spellunholypower", 315, -510)
CreateSpellButton("buttonSpellMasterSummoner", "Interface/icons/spell_shadow_impphaseshift", "|cffffffffMaître invocateur|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Réduit le temps d'incantation de vos sorts d'invocations de diablotin, de succube,\nde marcheur du Vide, de chasseur corrompu et de gangregarde de 4 sec. et leur coût en mana de 40%.|r", "spellmastersummoner", 422, -510)


CreateSpellButton("buttonSpellManaFeed", "Interface/icons/spell_shadow_manafeed", "|cffffffffFestin de mana|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Lorsque vous recevez du mana grâce aux sorts Drain de mana ou Connexion,\nvotre démon invoqué reçoit lui aussi 100% de ce montant de mana.|r", "spellmanafeed", 663, -75)
CreateSpellButton("buttonSpellMasterConjuror", "Interface/icons/inv_ammo_firetar", "|cffffffffMaître conjurateur|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente de 300% les scores de combat conférés par vos Pierres de feu et Pierres de sort invoquées.|r", "spellmasterconjuror", 770, -75)
CreateSpellButton("buttonSpellMasterDemonologist", "Interface/icons/spell_shadow_shadowpact", "|cffffffffMaître démonologue|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Fait bénéficier le démoniste et le démon invoqué d'un effet aussi longtemps que le démon est actif.\n\n Diablotin - Augmente vos dégâts de Feu de 5%, et augmente les chances d'effet critique de vos sorts de Feu de 5%.\n\n Marcheur du Vide - Réduit les dégâts physiques subis de 10%.\n\n Succube - Augmente vos dégâts d'Ombre de 5%, et augmente les chances d'effet critique de vos sorts d'Ombre de 5%.\n\n Chasseur corrompu - Réduit tous les dégâts des sorts subis de 10%.\n\n Gangregarde - Augmente tous les dégâts infligés de 5%, et réduit tous les dégâts subis de 5%.|r", "spellmasterdemonologist", 880, -75)
CreateSpellButton("buttonSpellMoltenCore", "Interface/icons/ability_warlock_moltencore", "|cffffffffCoeur de la fournaise|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente la durée de votre Immolation de 9 sec., et vous avez 12% de chances de bénéficier de l'effet Coeur de la fournaise quand votre Corruption inflige des dégâts.\nL'effet Coeur de la fournaise rend plus puissants vos 3 prochains sorts Incinérer ou Feu de l'âme lancés dans les 15 seconds.\n\n Incinérer - Augmente les dégâts infligés de 18% et réduit le temps d'incantation de 30%.\n\n Feu de l'âme - Augmente les dégâts infligés de 18% et augmente les chances de coup critique de 15%.|r", "spellmoltencore", 990, -75)
CreateSpellButton("buttonSpellDemonicResilience", "Interface/icons/spell_shadow_demonicfortitude", "|cffffffffRésilience démoniaque|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Réduit de 3% la probabilité que vous soyez touché par un coup critique infligé en mêlée ou par un sort et réduit de 15% tous les dégâts que subit votre démon invoqué.|r", "spelldemonicresilience", 1100, -75)
CreateSpellButton("buttonSpellDemonicEmpowerment", "Interface/icons/ability_warlock_demonicempowerment", "|cffffffffRenforcement démoniaque|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Confère un renforcement au démon invoqué du démoniste.\n\n Diablotin - Augmente ses chances de critique avec les sorts de 20% pendant 30 seconds.\n\n Marcheur du Vide - Augmente ses points de vie de 20% et augmente la menace générée par ses sorts et attaques de 20% pendant 20 seconds.\n\n Succube - Disparition immédiate qui la fait entrer dans un état d'invisibilité améliorée. L'effet de disparition annule tous les étourdissements, ralentissements et effets affectant le déplacement sur la succube.\n\n Chasseur corrompu - Dissipe tous les effets magiques sur le chasseur corrompu.\n\n Gangregarde - Augmente sa vitesse d'attaque de 20%, annule tous les étourdissements, ralentissements et effets affectant le déplacement et rend le gangregarde insensible à ces effets pendant 15 seconds.|r", "spelldemonicempowerment", 718, -130)
CreateSpellButton("buttonSpellDemonicKnowledge", "Interface/icons/spell_shadow_improvedvampiricembrace", "|cffffffffConnaissance démoniaque|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente les dégâts de vos sorts d'un montant égal à 12% du total de l'Endurance plus l'Intelligence de votre démon actif.|r", "spelldemonicknowledge", 825, -130)
CreateSpellButton("buttonSpellDemonicTactics", "Interface/icons/spell_shadow_demonictactics", "|cffffffffTactique démoniaque|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente vos chances de coup critique en mêlée et avec les sorts ainsi que celles de votre démon invoqué de 10%.|r", "spelldemonictactics", 935, -130)
CreateSpellButton("buttonSpellDecimation", "Interface/icons/spell_fire_fireball02", "|cffffffffDécimation|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Lorsque vous touchez avec Trait de l'ombre, Incinérer ou Feu de l'âme une cible qui dispose de 35% ou moins de ses points de vie,\nle temps d'incantation de votre sort Feu de l'âme est réduit de 40% pendant 10 seconds.\nLes Feux de l'âme lancés sous l'effet de Décimation ne coûtent pas de fragment.|r", "spelldecimation", 1045, -130)
CreateSpellButton("buttonSpellImprovedDemonicTactics", "Interface/icons/ability_warlock_improveddemonictactics", "|cffffffffTactique démoniaque améliorée|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente les chances de coup critique de votre démon invoqué,\nles rendant égales à 30% de vos propres chances.|r", "spellimproveddemonictactics", 663, -184)
CreateSpellButton("buttonSpellSummonFelguard", "Interface/icons/spell_shadow_summonfelguard", "|cffffffffInvocation d'un gangregarde|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Invoque un gangregarde qui exécute les ordres du démoniste.|r", "spellsummonfelguard", 770, -184)
CreateSpellButton("buttonSpellNemesis", "Interface/icons/spell_shadow_demonicempathy", "|cffffffffInstrument de vengeance|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Réduit le temps de recharge de vos sorts Renforcement démoniaque, Métamorphe et Domination corrompue de 30%.|r", "spellnemesis", 880, -184)
CreateSpellButton("buttonSpellDemonicPact", "Interface/icons/spell_shadow_demonicpact", "|cffffffffPacte démoniaque|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente vos dégâts des sorts de 10%, et les critiques de votre familier appliquent l'effet Pacte démoniaque sur les membres de votre groupe ou raid.\nLe Pacte démoniaque augmente la puissance des sorts de 10% de vos dégâts des sorts pendant 45 seconds.\nCet effet a un temps de recharge de 20 sec.\nNe fonctionne pas sur les démons asservis.|r", "spelldemonicpact", 990, -184)
CreateSpellButton("buttonSpellMetamorphosis", "Interface/icons/spell_shadow_demonform", "|cffffffffMétamorphe|r\n|cffffffffTalent|r |cff80ff00Démonologie|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Vous vous transformez en démon pendant 30 seconds.\nCette forme augmente votre armure de 600% et vos dégâts de 20%,\nréduit la probabilité que vous soyez touché par des coups critiques en mêlée de 6%\net réduit la durée des effets d'étourdissement et de ralentissement qui vous affectent de 50%.\nVous bénéficiez de techniques démoniaques spécifiques en plus de vos techniques normales.\nTemps de recharge de 3 minutes.|r", "spellmetamorphosis", 1100, -184)



CreateSpellButton("buttonSpellImprovedShadowBolt", "Interface/icons/spell_shadow_shadowbolt", "|cffffffffTrait de l'ombre amélioré|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente les dégâts infligés par votre sort Trait de l'ombre de 10%,\net votre Trait de l'ombre a également 100% de chances de rendre votre cible vulnérable aux dégâts des sorts,\nce qui augmente les chances de coup critique des sorts contre cette cible de 5%.\nL'effet dure 30 seconds.|r", "spellimprovedshadowbolt", 718, -240)
CreateSpellButton("buttonSpellBane", "Interface/icons/spell_shadow_deathpact", "|cffffffffFléau|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Réduit le temps d'incantation de vos sorts Trait de l'ombre, Trait du chaos et Immolation de 0.5 sec. et Feu de l'âme de 2 sec.|r", "spellbane", 825, -240)
CreateSpellButton("buttonSpellAftermath", "Interface/icons/spell_fire_fire", "|cffffffffConséquences|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente les dégâts périodiques infligés par votre Immolation de 6%, et votre Conflagration a 100% de chances d'hébéter la cible pendant 5 seconds.|r", "spellaftermath", 935, -240)
CreateSpellButton("buttonSpellMoltenSkin", "Interface/icons/ability_mage_moltenarmor", "|cffffffffPeau de la fournaise|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Réduit tous les dégâts subis de 6%.|r", "spellmoltenskin", 1045, -240)
CreateSpellButton("buttonSpellCataclysm", "Interface/icons/spell_fire_windsofwoe", "|cffffffffCataclysme|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Réduit le coût en mana de vos sorts de Destruction de 10%.|r", "spellcataclysm", 663, -293)
CreateSpellButton("buttonSpellDemonicPower", "Interface/icons/spell_fire_firebolt", "|cffffffffPuissance démoniaque|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Réduit le temps de recharge du sort Fouet de la douleur de votre succube de 6 sec. et le temps d'incantation du sort Eclair de feu de votre Diablotin de 0.50 sec.|r", "spelldemonicpower", 770, -293)
CreateSpellButton("buttonSpellShadowburn", "Interface/icons/spell_shadow_scourgebuild", "|cffffffffBrûlure de l'ombre|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Frappe instantanément la cible et lui inflige 91 à 104 points de dégâts d'Ombre.\nSi la cible meurt dans les 5 seconds sous l'effet du sort Brûlure de l'ombre et rapporte de l'expérience ou de l'honneur,\nle lanceur gagne un Fragment d'âme.|r", "spellshadowburn", 990, -293)
CreateSpellButton("buttonSpellRuin", "Interface/icons/spell_shadow_shadowwordpain", "|cffffffffRuine|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente de 100% les points de dégâts supplémentaires infligés par les coups critiques de vos sorts de Destruction et le sort Eclair de feu de votre diablotin.|r", "spellruin", 1100, -293)
CreateSpellButton("buttonSpellIntensity", "Interface/icons/spell_fire_lavaspawn", "|cffffffffIntensité|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Réduit de 70% l'interruption causée par les attaques infligeant des dégâts pendant que vous incantez ou canalisez tout sort de Destruction.|r", "spellintensity", 718, -348)
CreateSpellButton("buttonSpellDestructiveReach", "Interface/icons/spell_shadow_corpseexplode", "|cffffffffAllonge de destruction|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente de 20% la portée de vos sorts de Destruction et réduit de 20% la menace générée par les sorts de Destruction.|r", "spelldestructivereach", 825, -348)
CreateSpellButton("buttonSpellImprovedSearingPain", "Interface/icons/spell_fire_soulburn", "|cffffffffDouleur brûlante améliorée|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente de 10% les chances d'infliger un coup critique avec votre sort Douleur brûlante.|r", "spellimprovedsearingpain", 935, -348)
CreateSpellButton("buttonSpellBacklash", "Interface/icons/spell_fire_playingwithfire", "|cffffffffContrecoup|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente vos chances d'infliger un coup critique avec les sorts de 3% supplémentaires et vous confère 25%\nde chances lorsque vous êtes touché par une attaque physique de réduire le temps d'incantation de votre prochain sort Trait de l'ombre ou Incinérer de 100%.\nCet effet dure 8 seconds et ne peut se produire plus d'une fois toutes les 8 secondes.|r", "spellbacklash", 1045, -348)
CreateSpellButton("buttonSpellImprovedImmolate", "Interface/icons/spell_fire_immolation", "|cffffffffImmolation améliorée|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente les dégâts infligés par votre sort Immolation de 30%.|r", "spellimprovedimmolate", 663, -402)
CreateSpellButton("buttonSpellDevastation", "Interface/icons/spell_fire_flameshock", "|cffffffffDévastation|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente de 5% vos chances d'infliger un coup critique avec vos sorts de Destruction.|r", "spelldevastation", 770, -402)
CreateSpellButton("buttonSpellNetherProtection", "Interface/icons/spell_shadow_netherprotection", "|cffffffffProtection du Néant|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Après avoir été touché par un sort, vous avez 30% de chances de recevoir la Protection du Néant, qui réduit tous les dégâts de la même école de 30% pendant 8 seconds.|r", "spellnetherprotection", 880, -402)
CreateSpellButton("buttonSpellEmberstorm", "Interface/icons/spell_fire_selfdestruct", "|cffffffffTempête ardente|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente les dégâts infligés par vos sorts de Feu de 15% et réduit le temps d'incantation de votre sort Incinérer de 0.25 sec.|r", "spellemberstorm", 990, -402)
CreateSpellButton("buttonSpellConflagrate", "Interface/icons/spell_fire_fireball", "|cffffffffConflagration|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Cause un effet d'Immolation ou d'Ombreflamme sur la cible ennemie pour lui infliger instantanément un montant de dégâts égal à\n69% de votre Immolation ou votre Ombreflamme et inflige 40% de dégâts supplémentaires en 6 seconds.|r", "spellconflagrate", 1100, -402)
CreateSpellButton("buttonSpellSoulLeech", "Interface/icons/spell_shadow_soulleech_3", "|cffffffffSuceur d'âme|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Confère à vos sorts Trait de l'ombre, Brûlure de l'ombre,\nTrait du chaos, Feu de l'âme, Incinérer, Douleur brûlante et Conflagration 30% de chances de vous rendre un montant de points de vie égal à 20% des dégâts infligés.|r", "spellsoulleech", 718, -456)
CreateSpellButton("buttonSpellPyroclasm", "Interface/icons/spell_fire_volcano", "|cffffffffPyroclasme|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Quand vous réussissez un coup critique avec Douleur brûlante ou Conflagration, les dégâts de vos sorts de Feu et d'Ombre sont augmentés de 6% pendant 10 seconds.|r", "spellpyroclasm", 825, -456)
CreateSpellButton("buttonSpellShadowandFlame", "Interface/icons/spell_shadow_shadowandflame", "|cffffffffOmbre et flammes|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Vos sorts Trait de l'ombre, Brûlure de l'ombre, Trait du chaos et Incinérer bénéficient\nde 20% supplémentaires des effets du bonus relatif aux dégâts des sorts.|r", "spellshadowandflame", 935, -456)
CreateSpellButton("buttonSpellImprovedSoulLeech", "Interface/icons/ability_warlock_improvedsoulleech", "|cffffffffSuceur d'âme amélioré|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100L'effet de votre Suceur d'âme rend également à vous-même et à votre démon invoqué un montant de mana égal à 2% du maximum de mana,\net il a 100% de chances de faire bénéficier jusqu'à 10 membres du groupe ou raid d'une régénération\nde mana égale à 1% du maximum de mana toutes les 5 sec. Dure 15 seconds.|r", "spellimprovedsoulleech", 1045, -456)
CreateSpellButton("buttonSpellBackdraft", "Interface/icons/ability_warlock_backdraft", "|cffffffffExplosion de fumées|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Quand vous lancez Conflagration, le temps d'incantation et le temps de recharge\nglobal de vos trois prochains sorts de Destruction est réduit de 30%.\nDure 15 seconds.|r", "spellbackdraft", 663, -510)
CreateSpellButton("buttonSpellShadowfury", "Interface/icons/spell_shadow_shadowfury", "|cffffffffFurie de l'ombre|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100La furie de l'ombre est libérée. Elle inflige 343 to 407 points de dégâts d'Ombre et étourdit tous les ennemis dans un rayon de 8 mètres pendant 3 seconds.|r", "spellshadowfury", 770, -510)
CreateSpellButton("buttonSpellEmpoweredImp", "Interface/icons/ability_warlock_empoweredimp", "|cffffffffDiablotin surpuissant|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente les dégâts infligés par votre diablotin de 30%, et tous les coups critiques qu'il réussit ont 100%\nde chances d'augmenter les chances de coup critique de votre prochain sort de 100%.\nCet effet dure 8 seconds.|r", "spellempoweredimp", 880, -510)
CreateSpellButton("buttonSpellFireandBrimstone", "Interface/icons/ability_warlock_fireandbrimstone", "|cffffffffFeu et soufre|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Augmente les dégâts infligés par vos sorts Incinérer et Trait du chaos aux cibles affectées par votre Immolation de 10%,\net les chances de coup critique de votre sort Conflagration sont augmentées de 25%.|r", "spellfireandbrimstone", 990, -510)
CreateSpellButton("buttonSpellChaosBolt", "Interface/icons/ability_warlock_chaosbolt", "|cffffffffTrait du chaos|r\n|cffffffffTalent|r |cffff8000Destruction|r\n|cffffffffRequiert|r |cff8787edDémoniste|r\n|cffffd100Lance un éclair de feu chaotique sur l'ennemi et lui inflige 942 à 1187 points de dégâts de Feu.\nOn ne peut pas résister à Trait du chaos, et il traverse tous les effets d'absorption.|r", "spellchaosbolt", 1100, -510)




local resetButtonClicked = false

local buttonReset = CreateFrame("Button", "buttonReset", frameTalentWarlock, "UIPanelButtonTemplate")
buttonReset:SetSize(85, 25)
buttonReset:SetPoint("BOTTOMRIGHT", buttonTalentWarlockClose, "BOTTOMLEFT", -95, 5)
buttonReset:SetText("Réinitialiser")

local function ResetTalents()
    AIO.Handle("TalentWarlockspell", "ResetTalents")
    resetButtonClicked = true
end

buttonReset:SetScript("OnClick", ResetTalents)

local buttonReload = CreateFrame("Button", "buttonReload", frameTalentWarlock, "UIPanelButtonTemplate")
buttonReload:SetSize(85, 25)
buttonReload:SetPoint("BOTTOMRIGHT", buttonTalentWarlockClose, "BOTTOMLEFT", -5, 5)
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
        frameTalentWarlock:Hide()
        buttonReload:Hide()
        PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
    else
        frameTalentWarlock:Show()
        buttonReload:Show()
        PlaySoundFile(OPEN_TALENT_WINDOW_SOUND)
    end

    talentsWindowOpen = not talentsWindowOpen
end

local playerClass = select(2, UnitClass("player"))
if playerClass == "WARLOCK" then
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
        GameTooltip:SetText("|cffffffffTalents|r |cff8787ed(Démoniste)|r\n\nL'éventail des talents disponibles\npour améliorer et spécialiser\nvotre personnage.")
        GameTooltip:Show()
    end)

    buttonOuvrirTalents:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    buttonOuvrirTalents:SetScript("OnClick", OuvrirFermerInterfaceTalents)
    TalentMicroButton:Hide()
end

WarlockHandlers.UpdateTalentCount = function(player, talentsAppris)
    if fontTalentWarlockFrameText then
        fontTalentWarlockFrameText:SetText(talentsAppris .. " / " .. MAX_TALENTS)
    end
end

WarlockHandlers.UpdateTalentPointsUsed = function(player, pointsUsed, pointsBeforeReset)
    print("|cff00ffffVous avez utilisés " .. pointsBeforeReset .. " points avant la réinitialisation des talents|r")
end