local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local PaladinHandlers = AIO.AddHandlers("TalentPaladinspell", {})

function PaladinHandlers.ShowTalentPaladin(player)
    frameTalentPaladin:Show()
end

local MAX_TALENTS = 41

local OPEN_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_final_trait_unlocked.ogg"
local CLOSE_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_trait_refund_end.ogg"
local SPELL_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_80_azeritearmor_rotationends_02.ogg"

local frameTalentPaladin = CreateFrame("Frame", "frameTalentPaladin", UIParent)
frameTalentPaladin:SetSize(1200, 650)
frameTalentPaladin:SetMovable(true)
frameTalentPaladin:EnableMouse(true)
frameTalentPaladin:RegisterForDrag("LeftButton")
frameTalentPaladin:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
frameTalentPaladin:SetBackdrop(
{
    bgFile = "interface/TalentFrame/Template/Class/Paladin/talentsclassbackgroundpaladin3",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedpaladin",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

local paladinIcon = frameTalentPaladin:CreateTexture("PaladinIcon", "OVERLAY")
paladinIcon:SetTexture("Interface\\TalentFrame\\Template\\Class\\Paladin\\IconePaladin.blp")
paladinIcon:SetSize(60, 60)
paladinIcon:SetPoint("TOPLEFT", frameTalentPaladin, "TOPLEFT", -10, 10)


local textureone = frameTalentPaladin:CreateTexture("TemplateTalentFrame", "OVERLAY")
textureone:SetTexture("Interface\\TalentFrame\\Template\\Class\\Paladin\\TalentFrameTemplate.blp")
textureone:SetSize(928, 928)
textureone:SetPoint("TOPLEFT", frameTalentPaladin, "TOPLEFT", -170, 140)

frameTalentPaladin:SetFrameLevel(100)

local texturetwo = frameTalentPaladin:CreateTexture("TemplateTalentFrame", "OVERLAY")
texturetwo:SetTexture("Interface\\TalentFrame\\Template\\Class\\Paladin\\TalentFrameTemplateOriginal.blp")
texturetwo:SetSize(928, 928)
texturetwo:SetPoint("TOPRIGHT", frameTalentPaladin, "TOPRIGHT", 170, 140)

frameTalentPaladin:SetFrameLevel(100)

frameTalentPaladin:SetScript("OnDragStart", frameTalentPaladin.StartMoving)
frameTalentPaladin:SetScript("OnHide", frameTalentPaladin.StopMovingOrSizing)
frameTalentPaladin:SetScript("OnDragStop", frameTalentPaladin.StopMovingOrSizing)
frameTalentPaladin:Hide()

frameTalentPaladin:SetBackdropBorderColor(135, 135, 237)

local buttonTalentPaladinClose = CreateFrame("Button", "buttonTalentPaladinClose", frameTalentPaladin, "UIPanelCloseButton")
buttonTalentPaladinClose:SetPoint("TOPRIGHT", -12, -12)
buttonTalentPaladinClose:EnableMouse(true)
buttonTalentPaladinClose:SetSize(32, 32)

local function CloseTalentWindow()
    frameTalentPaladin:Hide()
    PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
end

buttonTalentPaladinClose:SetScript("OnClick", CloseTalentWindow)

local frameTalentPaladinTitleBar = CreateFrame("Frame", "frameTalentPaladinTitleBar", frameTalentPaladin, nil)
frameTalentPaladinTitleBar:SetSize(135, 25)
frameTalentPaladinTitleBar:SetBackdrop(
{
    bgFile = "interface/corrupteditems/corruptedtooltipbackground",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedpaladin",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameTalentPaladinTitleBar:SetPoint("TOP", 0, 20)

local fontTalentPaladinTitleText = frameTalentPaladinTitleBar:CreateFontString("fontTalentPaladinTitleText")
fontTalentPaladinTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontTalentPaladinTitleText:SetSize(190, 5)
fontTalentPaladinTitleText:SetPoint("CENTER", 0, 0)
fontTalentPaladinTitleText:SetText("|cffFFC125Talents|r")

local fontTalentPaladinFrameText = frameTalentPaladinTitleBar:CreateFontString("fontTalentPaladinFrameText")
fontTalentPaladinFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentPaladinFrameText:SetSize(200, 5)
fontTalentPaladinFrameText:SetPoint("TOPLEFT", frameTalentPaladinTitleBar, "BOTTOMLEFT", -30, -35)
fontTalentPaladinFrameText:SetText("|cffFFC125Paladin|r")

local fontTalentPaladinFrameText = frameTalentPaladinTitleBar:CreateFontString("fontTalentPaladinFrameText")
fontTalentPaladinFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentPaladinFrameText:SetSize(200, 5)
fontTalentPaladinFrameText:SetPoint("TOPLEFT", frameTalentPaladinTitleBar, "BOTTOMLEFT", -30, -60)
fontTalentPaladinFrameText:SetText("0 / " .. MAX_TALENTS)



local function CreateSpellButton(name, texturePath, tooltipText, talentHandler, positionX, positionY)
    local buttonClicked = false
    local talentLearned = false

    local button = CreateFrame("Button", name, frameTalentPaladin, nil)
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
                AIO.Handle("TalentPaladinspell", talentHandler, 1)
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






CreateSpellButton("buttonSpellSpiritualFocus", "Interface/icons/spell_arcane_blink", "|cffffffffFocalisation spirituelle|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit de 70% l'interruption causée par les attaques infligeant des dégâts pendant que vous incantez Lumière sacrée et Eclair lumineux.|r", "spellspiritualfocus", 100, -80)
CreateSpellButton("buttonSpellSealsofthePure", "Interface/icons/ability_thunderbolt", "|cffffffffSceaux des purs|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente de 15% les dégâts infligés par vos Sceaux de piété, de vengeance et de corruption ainsi que les effets de leurs Jugements.|r", "spellsealsofthepure", 205, -75)
CreateSpellButton("buttonSpellHealingLight", "Interface/icons/spell_holy_holybolt", "|cffffffffLumière guérisseuse|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente le montant de points de vie rendus par vos sorts Lumière sacrée et Eclair lumineux ainsi que l'efficacité des sorts Horion sacré de 12%.|r", "spellhealinglight", 315, -75)
CreateSpellButton("buttonSpellDivineIntellect", "Interface/icons/spell_nature_sleep", "|cffffffffIntelligence divine|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente votre total d'Intelligence de 10%.|r", "spelldivineintellect", 418, -80)
CreateSpellButton("buttonSpellUnyieldingFaith", "Interface/icons/spell_holy_unyieldingfaith", "|cffffffffFoi inflexible|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit de 30% la durée de tous les effets de Peur et de Désorientation.|r", "spellunyieldingfaith", 45, -130)
CreateSpellButton("buttonSpellAuraMastery", "Interface/icons/spell_holy_auramastery", "|cffffffffMaîtrise des auras|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Permet à votre Aura de concentration de rendre toutes les cibles affectées insensibles aux effets de silence et d'interruption ainsi que d'améliorer les effets de toutes les autres auras de 100%.\nDure 6 secondes.|r", "spellauramastery", 150, -130)
CreateSpellButton("buttonSpellIllumination", "Interface/icons/spell_holy_greaterheal", "|cffffffffIllumination|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Lorsque vous obtenez un effet critique avec Eclair lumineux, Lumière sacrée, ou le sort de soins Horion sacré, vous avez 100% de chances de recevoir un montant de mana égal à 30% du coût de base du sort.|r", "spellillumination", 260, -130)
CreateSpellButton("buttonSpellImprovedLayonHands", "Interface/icons/spell_holy_layonhands", "|cffffffffImposition des mains améliorée|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100La cible de votre sort Imposition des mains bénéficie d'une réduction de 20% des dégâts physiques qu'elle subit pendant 15 secondes.\nDe plus, le temps de recharge de votre sort Imposition des mains est réduit de 4 min.|r", "spellimprovedlayonhands", 370, -130)
CreateSpellButton("buttonSpellImprovedConcentrationAura", "Interface/icons/spell_holy_mindsooth", "|cffffffffAura de concentration améliorée|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente de 15% supplémentaires l'effet de votre Aura de concentration, et tant que n'importe quelle Aura est active, réduit de 30% la durée de tout effet de silence ou d'interruption utilisé contre un membre du groupe affecté.\nLa réduction de durée ne se cumule avec aucun autre effet.|r", "spellimprovedconcentrationaura", 475, -133)
CreateSpellButton("buttonSpellImprovedBlessingofWisdom", "Interface/icons/spell_holy_sealofwisdom", "|cffffffffBénédiction de sagesse améliorée|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente l'effet de votre sort Bénédiction de sagesse de 20%.|r", "spellimprovedblessingofwisdom", 96, -185)
CreateSpellButton("buttonSpellBlessedHands", "Interface/icons/ability_paladin_blessedhands", "|cffffffffMains bénies|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit le coût en mana de Main de liberté, Main de sacrifice et Main de salut de 30% en plus d'augmenter l'efficacité de Main de salut de 100% et celle de Main de sacrifice de 10% supplémentaires.|r", "spellblessedhands", 205, -185)
CreateSpellButton("buttonSpellPureofHeart", "Interface/icons/spell_holy_pureofheart", "|cffffffffPur de coeur|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit de 30% la durée des effets de malédiction, de maladie et de poison.|r", "spellpureofheart", 315, -185)
CreateSpellButton("buttonSpellDivineFavor", "Interface/icons/spell_holy_heal", "|cffffffffFaveur divine|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Une fois activé, confère 100% de chances à votre prochain sort Eclair lumineux, Lumière sacrée ou Horion sacré d'avoir un effet critique.|r", "spelldivinefavor", 422, -185)
CreateSpellButton("buttonSpellSanctifiedLight", "Interface/icons/spell_holy_healingaura", "|cffffffffLumière sanctifiée|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente de 6% vos chances de réaliser un effet critique avec vos sorts Lumière sacrée et Horion sacré.|r", "spellsanctifiedlight", 527, -190)
CreateSpellButton("buttonSpellPurifyingPower", "Interface/icons/spell_holy_purifyingpower", "|cffffffffPuissance purifiante|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit de 10% le coût en mana de vos sorts Epuration, Purification et Consécration et réduit de 33% le temps de recharge de vos sorts Exorcisme et Colère divine.|r", "spellpurifyingpower", 43, -240)
CreateSpellButton("buttonSpellHolyPower", "Interface/icons/spell_holy_power", "|cffffffffPuissance sacrée|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente les chances d'obtenir un effet critique avec vos sorts du Sacré de 5%.|r", "spellholypower", 150, -240)
CreateSpellButton("buttonSpellLightsGrace", "Interface/icons/spell_holy_lightsgrace", "|cffffffffPuissance purifiante|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit de 10% le coût en mana de vos sorts Epuration, Purification et Consécration et réduit de 33% le temps de recharge de vos sorts Exorcisme et Colère divine.|r", "spelllightsgrace", 368, -240)
CreateSpellButton("buttonSpellHolyShock", "Interface/icons/spell_holy_searinglight", "|cffffffffHorion sacré|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100L'énergie sacrée frappe la cible et inflige 314 à 340 points de dégâts du Sacré à un ennemi, ou bien rend à un allié 481 à 519 points de vie.|r", "spellholyshock", 478, -240)
CreateSpellButton("buttonSpellBlessedLife", "Interface/icons/spell_holy_blessedlife", "|cffffffffVie bénie|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Vous confère 10% de chances que les attaques contre vous n'infligent que la moitié des dégâts.|r", "spellblessedlife", 98, -293)
CreateSpellButton("buttonSpellSacredCleansing", "Interface/icons/ability_paladin_sacredcleansing", "|cffffffffPurification sacrée|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Votre sort Epuration a 30% de chances d'augmenter la résistance de la cible aux maladies, à la magie et au poison de 30% pendant 10 secondes.|r", "spellsacredcleansing", 205, -293)
CreateSpellButton("buttonSpellHolyGuidance", "Interface/icons/spell_holy_holyguidance", "|cffffffffSoutien sacré|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente la puissance de vos sorts de 20% de votre total d'Intelligence.|r", "spellholyguidance", 315, -293)
CreateSpellButton("buttonSpellDivineIllumination", "Interface/icons/spell_holy_divineillumination", "|cffffffffIllumination divine|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit le coût en mana de tous les sorts de 50% pendant 15 secondes.|r", "spelldivineillumination", 422, -293)
CreateSpellButton("buttonSpellJudgementsofthePure", "Interface/icons/ability_paladin_judgementofthepure", "|cffffffffJugements des purs|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente les dégâts infligés par vos sorts de Sceau et de Jugement de 25%, et vos sorts de Jugement augmentent votre vitesse d'incantation et votre hâte en mêlée de 15% pendant 60 secondes.|r", "spelljudgementsofthepure", 527, -295)
CreateSpellButton("buttonSpellInfusionofLight", "Interface/icons/ability_paladin_infusionoflight", "|cffffffffImprégnation de lumière|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Vos coups critiques avec Horion sacré réduisent le temps d'incantation de votre prochain sort Eclair lumineux de 1,5 sec.\nou augmentent les chances de critique de votre prochaine Lumière sacrée de 20%.\nDe plus, votre Eclair lumineux rend aux cibles affectées par Bouclier saint 100% de points de vie supplémentaires en 12 secondes.|r", "spellinfusionoflight", 43, -350)
CreateSpellButton("buttonSpellEnlightenedJudgements", "Interface/icons/ability_paladin_enlightenedjudgements", "|cffffffffJugements éclairés|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente de 30 mètres la portée de votre Jugement de Lumière et de votre Jugement de sagesse en plus d'augmenter de 4% vos chances de toucher.", "spellenlightenedjudgements", 150, -350)
CreateSpellButton("buttonSpellBeaconofLight", "Interface/icons/ability_paladin_beaconoflight", "|cffffffffGuide de lumière|r\n|cffffffffTalent|r |cffffff80Sacré|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100La cible devient un guide de lumière pour tous les membres de votre groupe ou raid se trouvant dans un rayon de 60 mètres.\nTous les soins que vous lancez sur ces cibles soignent également le Guide pour un montant de points de vie égal à 100% des soins prodigués.\nUne seule cible à la fois peut être le Guide de lumière.\nDure 60 secondes.|r", "spellbeaconoflight", 260, -350)
CreateSpellButton("buttonSpellDivinity", "Interface/icons/spell_holy_blindingheal", "|cffffffffDivinité|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente tous les soins que vous prodiguez et tous les effets de soins sur vous de 5%.|r", "spelldivinity", 368, -350)
CreateSpellButton("buttonDivineStrength", "Interface/icons/ability_golemthunderclap", "|cffffffffForce divine|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente votre total de Force de 15%.|r", "spelldivinestrength", 478, -350)


CreateSpellButton("buttonSpellStoicism", "Interface/icons/spell_holy_stoicism", "|cffffffffStoïcisme|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit la durée de tous les effets d'étourdissement de 30% supplémentaires, et réduit la probabilité que vos sorts utiles et vos effets de dégâts sur la durée soient dissipés de 30% supplémentaires.|r", "spellstoicism", 98, -405)
CreateSpellButton("buttonSpellGuardiansFavor", "Interface/icons/spell_holy_sealofprotection", "|cffffffffFaveur du Gardien|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit le temps de recharge de votre Main de protection de 2 min.\net augmente la durée de votre Main de liberté de 4 sec.|r", "spellguardiansfavor", 205, -405)
CreateSpellButton("buttonSpellAnticipation", "Interface/icons/spell_magic_lesserinvisibilty", "|cffffffffAnticipation|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente vos chances d'esquiver de 5%..|r", "spellanticipation", 315, -405)
CreateSpellButton("buttonSpellDivineSacrifice", "Interface/icons/spell_holy_powerwordbarrier", "|cffffffffSacrifice divin|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd10030% de tous les dégâts subis par les membres du groupe se trouvant à moins de 30 mètres sont redirigés vers le paladin (jusqu'à un maximum de 40% des points de vie du paladin multiplié par le nombre de membres du groupe).\nLes dégâts qui font passer le paladin sous les 20% de points de vie interrompent l'effet.\nDure 10 seconds.|r", "spelldivinesacrifice", 422, -405)
CreateSpellButton("buttonSpellImprovedRighteousFury", "Interface/icons/spell_holy_sealoffury", "|cffffffffFureur vertueuse améliorée|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Tant que la Fureur vertueuse est active, tous les dégâts subis sont réduits de 6%.|r", "spellimprovedrighteousfury", 43, -458)
CreateSpellButton("buttonSpellToughness", "Interface/icons/spell_holy_devotion", "|cffffffffRésistance|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente la valeur d'armure des objets de 10% et réduit la durée de tous les effets affectant le déplacement de 30%.|r", "spelltoughness", 150, -458)
CreateSpellButton("buttonSpellDivineGuardian", "Interface/icons/spell_holy_powerwordbarrier", "|cffffffffGardien divin|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Lorsque Sacrifice divin est actif, les membres de votre groupe ou raid dans un rayon de 30 mètres subissent 20% de dégâts en moins pendant 6 secondes.\nDe plus, augmente la durée de votre Bouclier saint de 100% et le montant absorbé de 20%.|r", "spelldivineguardian", 260, -458)
CreateSpellButton("buttonSpellImprovedHammerofJustice", "Interface/icons/spell_holy_sealofmight", "|cffffffffMarteau de la justice amélioré|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit le temps de recharge de votre sort Marteau de la justice de 20 sec.|r", "spellimprovedhammerofjustice", 368, -458)
CreateSpellButton("buttonSpellImprovedDevotionAura", "Interface/icons/spell_holy_devotionaura", "|cffffffffAura de dévotion améliorée|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente de 50% le bonus d'armure que confère votre Aura de dévotion et augmente de 6% le montant de points de vie rendus à toute cible affectée par une de vos Auras.|r", "spellimproveddevotionaura", 478, -458)
CreateSpellButton("buttonSpellBlessingofSanctuary", "Interface/icons/spell_nature_lightningshield", "|cffffffffBénédiction du sanctuaire|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Place une Bénédiction sur la cible alliée qui réduit les dégâts infligés par toutes les sources de 3% pendant 10 mn et augmente la Force et l'Endurance de 10%.\nDe plus, quand la cible bloque, pare ou esquive une attaque de mêlée, la cible reçoit 2% de son mana maximum affiché.\nLes personnages ne peuvent bénéficier que des effets d'une seule Bénédiction par paladin à la fois.|r", "spellblessingofsanctuary", 98, -510)
CreateSpellButton("buttonSpellReckoning", "Interface/icons/spell_holy_blessingofstrength", "|cffffffffRétribution|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Confère 10% de chances lorsque vous êtes victime d'une attaque qui vous inflige des dégâts ou que vous l'avez bloquée de bénéficier d'une attaque supplémentaire avec les 4 frappes suivantes dans les 8 seconds.|r", "spellreckoning", 205, -510)
CreateSpellButton("buttonSpellSacredDuty", "Interface/icons/spell_holy_divineintervention", "|cffffffffDevoir sacré|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente votre total d'Endurance de 4% et réduit le temps de recharge de vos sorts Bouclier divin et Protection divine de 60 sec..|r", "spellsacredduty", 315, -510)
CreateSpellButton("buttonSpellOneHandedWeaponSpecialization", "Interface/icons/inv_sword_20", "|cffffffffSpécialisation Arme 1M|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente tous les dégâts que vous infligez de 10% quand une arme de mêlée à une main est équipée.|r", "spellonehandedweaponspecialization", 422, -510)


CreateSpellButton("buttonSpiritualAttunement", "Interface/icons/spell_holy_revivechampion", "|cffffffffHarmonisation spirituelle|r\n|cffffffffTalent|r |cff0080ffProtectionProtectionProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Une technique passive qui donne des points de mana au paladin lorsqu'il est soigné par les sorts d'autres cibles alliées.\nLa quantité de mana reçue est égale à 10% des points de vie rendus.|r", "spellimprovedscorch", 663, -75)
CreateSpellButton("buttonSpellHolyShield", "Interface/icons/spell_holy_blessingofprotection", "|cffffffffBouclier sacré|r\n|cffffffffTalent|r |cff0080ffProtectionProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente les chances de bloquer de 30% pendant 10 secondes et inflige 79 points de dégâts du Sacré pour chaque attaque bloquée pendant qu'il est actif.\nChaque blocage dépense une charge.\n8 charges.|r", "spellholyshield", 770, -75)
CreateSpellButton("buttonSpellArdentDefender", "Interface/icons/spell_holy_ardentdefender", "|cffffffffArdent défenseur|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Les dégâts qui vous font descendre sous les 35% de points de vie sont réduits de 20%.\nDe plus, les attaques qui normalement vous tueraient vous rendent jusqu'à 30% de votre maximum de points de vie (en fonction de votre défense).\nCet effet de soins ne peut se produire plus d'une fois toutes les 120 seconds.|r", "spellardentdefender", 880, -75)
CreateSpellButton("buttonSpellRedoubt", "Interface/icons/ability_defend", "|cffffffffRedoute|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente votre valeur de blocage de 30% et les attaques en mêlée et à distance contre vous qui infligent des dégâts ont 10% de chances d’augmenter vos chances de blocage de 30%.\nDure 10 secondes ou bloque 5 attaques.|r", "spellredoubt", 990, -75)
CreateSpellButton("buttonSpellCombatExpertise", "Interface/icons/spell_holy_weaponmastery", "|cffffffffExpertise en combat|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente votre expertise de 6, ainsi que votre total d'Endurance et vos chances de coup critique de 6%.|r", "spellcombatexpertise", 1100, -75)
CreateSpellButton("buttonSpellTouchedbytheLight", "Interface/icons/ability_paladin_touchedbylight", "|cffffffffTouché par la Lumière|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente votre puissance des sorts d'un montant égal à 60% de votre Force et augmente les points de vie rendus par vos soins critiques de 30%.|r", "spelltouchedbythelight", 718, -130)
CreateSpellButton("buttonSpellAvengersShield", "Interface/icons/spell_holy_avengersshield", "|cffffffffBouclier du vengeur|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Lance sur un ennemi un bouclier sacré qui inflige de 501 à 597 points de dégâts du Sacré, l'hébète et rebondit ensuite sur des ennemis proches.\nLe sort frappe 3 cibles au total.\nDure 10 secondes.|r", "spellavengersshield", 825, -130)
CreateSpellButton("buttonSpellGuardedbytheLight", "Interface/icons/ability_paladin_gaurdedbythelight", "|cffffffffGardé par la Lumière|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit les dégâts des sorts subis de 6% et confère 100% de chances de réinitialiser la durée de votre Supplique divine lorsque vous touchez un ennemi.\nDe plus, le risque que votre Supplique divine soit dissipée est réduit de 100%.|r", "spellguardedbythelight", 935, -130)
CreateSpellButton("buttonSpellShieldoftheTemplar", "Interface/icons/ability_paladin_shieldofthetemplar", "|cffffffffBouclier du templier|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit tous les dégâts subis de 3% et confère à votre Bouclier du vengeur 100% de chances de réduire vos cibles au silence pendant 3 secondes.|r", "spellthieldofthetemplar", 1045, -130)
CreateSpellButton("buttonSpellJudgementsoftheJust", "Interface/icons/ability_paladin_judgementsofthejust", "|cffffffffJugements des justes|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit le temps de recharge de votre Marteau de la justice de 10 sec., augmente la durée de l'effet de votre Sceau de justice de 1 sec.\net vos sorts de Jugement réduisent également la vitesse d'attaque en mêlée de la cible de 20%.|r", "spelljudgementsofthejust", 663, -184)
CreateSpellButton("buttonSpellHammeroftheRighteous", "Interface/icons/ability_paladin_hammeroftherighteous", "|cffffffffMarteau du vertueux|r\n|cffffffffTalent|r |cff0080ffProtection|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Frappe avec un marteau la cible actuelle ainsi que 2 cibles proches supplémentaires au plus, infligeant 4 fois par seconde les dégâts de votre arme en main droite sous forme de dégâts du Sacré.|r", "spellhammeroftherighteous", 770, -184)
CreateSpellButton("buttonSpellDeflection", "Interface/icons/ability_parry", "|cffffffffDéviation|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente vos chances de Parer de 5%.|r", "spelldeflection", 880, -184)
CreateSpellButton("buttonSpellBenediction", "Interface/icons/spell_frost_windwalkon", "|cffffffffBénédiction|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit le coût en mana de tous les sorts à l'incantation instantanée de 10%.|r", "spellbenediction", 990, -184)
CreateSpellButton("buttonSpellImprovedJudgements", "Interface/icons/spell_holy_righteousfury", "|cffffffffJugements améliorés|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit le temps de recharge de vos sorts de Jugement de 2 sec.", "spellimprovedjudgements", 1100, -184)



CreateSpellButton("buttonSpellHeartoftheCrusader", "Interface/icons/spell_holy_holysmite", "|cffffffffCoeur du Croisé|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100En plus des effets normaux, vos sorts de Jugement augmentent de 3% supplémentaires les chances de coup critique de toutes les attaques effectuées contre cette cible.|r", "spellheartofthecrusader", 718, -240)
CreateSpellButton("buttonSpellImprovedBlessingofMight", "Interface/icons/spell_holy_fistofjustice", "|cffffffffBénédiction de puissance améliorée|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente le bonus à la puissance d'attaque conféré par votre Bénédiction de puissance de 25%.|r", "spellimprovedblessingofmight", 825, -240)
CreateSpellButton("buttonSpellVindication", "Interface/icons/spell_holy_vindication", "|cffffffffJustification|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Confère aux attaques du paladin qui infligent des dégâts une chance de réduire la puissance d'attaque de la cible de 46 pendant 10 secondes.|r", "spellindication", 935, -240)
CreateSpellButton("buttonSpellConviction", "Interface/icons/spell_holy_retributionaura", "|cffffffffConviction|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente vos chances d'infliger un coup critique avec tous les sorts et les attaques de 5%.|r", "spellconviction", 1045, -240)
CreateSpellButton("buttonSpellSealofCommand", "Interface/icons/ability_warrior_innerrage", "|cffffffffSceau d'autorité|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Toutes les attaques en mêlée infligent de 53 à 54 points de dégâts du Sacré supplémentaires.\nQuand il est utilisé avec des attaques ou techniques qui frappent une cible unique, ces dégâts du Sacré supplémentaires s'abattent sur un maximum de 2 cibles supplémentaires.\nDure 30 mn.\nLibérez l'énergie de ce Sceau pour juger un ennemi et lui infliger instantanément de 107 à 108 points de dégâts du Sacré.|r", "spellsealofcommand", 663, -293)
CreateSpellButton("buttonSpellPursuitofJustice", "Interface/icons/spell_holy_persuitofjustice", "|cffffffffPoursuite de la justice|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit la durée de tous les effets de désarmement de 50% et augmente votre vitesse de déplacement et la vitesse de déplacement de votre monture de 15%.\nNe s'additionne pas avec les autres effets qui augmentent la vitesse de déplacement.|r", "spellpursuitofjustice", 770, -293)
CreateSpellButton("buttonSpellEyeforanEye", "Interface/icons/spell_holy_eyeforaneye", "|cffffffffOeil pour oeil|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Tous les coups critiques contre vous infligent également 10% des dégâts que vous subissez à l'attaquant.\nLes points de dégâts causés par Oeil pour oeil ne peuvent excéder 50% du total des points de vie du paladin.|r", "spelleyeforaneye", 990, -293)
CreateSpellButton("buttonSpellSanctityofBattle", "Interface/icons/spell_holy_holysmite", "|cffffffffBataille sainte|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente vos chances de réussir des coups critiques avec tous les sorts et attaques de 3% et augmente les dégâts infligés par Exorcisme et Inquisition de 15%.|r", "spellsanctityofbattle", 1100, -293)
CreateSpellButton("buttonSpellCrusade", "Interface/icons/spell_holy_crusade", "|cffffffffCroisade|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente tous les dégâts infligés de 3% et tous les dégâts infligés aux humanoïdes, démons, morts-vivants et élémentaires de 3% supplémentaires.|r", "spellcrusade", 718, -348)
CreateSpellButton("buttonSpellTwoHandedWeaponSpecialization", "Interface/icons/inv_hammer_04", "|cffffffffSpécialisation Arme 2M|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente les points de dégâts que vous infligez avec les armes de mêlée à deux mains de 6%.|r", "spelltwohandedweaponspecialization", 825, -348)
CreateSpellButton("buttonSpellSanctifiedRetribution", "Interface/icons/spell_holy_mindvision", "|cffffffffVindicte sanctifiée|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente les dégâts infligés par Aura de vindicte de 50%, et tous les dégâts infligés par les cibles alliées affectées par l'une de vos Auras sont augmentés de 3%.|r", "spellsanctifiedretribution", 935, -348)
CreateSpellButton("buttonSpellVengeance", "Interface/icons/ability_racial_avatar", "|cffffffffVengeance|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Après un coup critique obtenu en frappant avec une arme, ou avec un sort ou une technique, vous infligez 3% de points de dégâts physiques et du Sacré supplémentaires pendant 30 secondes.\nCet effet est cumulable jusqu'à 3 fois.|r", "spellvengeance", 1045, -348)
CreateSpellButton("buttonSpellDivinePurpose", "Interface/icons/spell_holy_divinepurpose", "|cffffffffDessein divin|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Réduit la probabilité que vous soyez touché par les sorts et les attaques à distance de 4% et confère à votre sort Main de liberté 100% de chances d'annuler tous les effets d'étourdissement sur la cible.|r", "spelldivinepurpose", 663, -402)
CreateSpellButton("buttonSpellTheArtofWar", "Interface/icons/ability_paladin_artofwar", "|cffffffffL'art de la guerre|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente les dégâts de vos techniques de Jugement, Inquisition et Tempête divine de 10%, et quand vous réussissez un coup critique avec vos attaques de mêlée, votre prochain sort Eclair lumineux ou Exorcisme est instantané.|r", "spelltheartofwar", 770, -402)
CreateSpellButton("buttonSpellRepentance", "Interface/icons/spell_holy_prayerofhealing", "|cffffffffRepentir|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Plonge la cible ennemie dans une transe méditative qui la stupéfie pendant 60 secondes.\nau maximum et annule l'effet de Vengeance vertueuse.\nSi la cible subit des dégâts, elle se réveille.\nNe fonctionne que sur les démons, les draconiens, les géants, les humanoïdes et les morts-vivants.|r", "spellrepentance", 880, -402)
CreateSpellButton("buttonSpellJudgementsoftheWise", "Interface/icons/ability_paladin_judgementofthewise", "|cffffffffJugements des sages|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Vos sorts de Jugement infligeant des dégâts ont 100% de chances de conférer à jusqu'à 10 membres du groupe ou raid l'effet Requinquage,\nqui les fait bénéficier d'une régénération de mana égale à 1% de leur maximum de mana toutes les 5 sec.\npendant 15 secondes., ainsi que de vous rendre instantanément 25% de votre mana de base.|r", "spelljudgementsofthewise", 990, -402)
CreateSpellButton("buttonSpellFanaticism", "Interface/icons/spell_holy_fanaticism", "|cffffffffFanatisme|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente de 18% les chances d'obtenir un coup critique avec tous les Jugements qui peuvent en infliger et réduit la menace de toutes les actions de 30%, sauf sous l'effet de Fureur vertueuse.|r", "spellfanaticism", 1100, -402)
CreateSpellButton("buttonSpellSanctifiedWrath", "Interface/icons/ability_paladin_sanctifiedwrath", "|cffffffffCourroux sanctifié|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente les chances de coup critique de Marteau de courroux de 50%, réduit le temps de recharge de Courroux vengeur de 60 sec.\net tant que vous êtes affecté par Courroux vengeur 50% de tous les dégâts infligés évitent les effets de réduction des dégâts.|r", "spellsanctifiedwrath", 718, -456)
CreateSpellButton("buttonSpellSwiftRetribution", "Interface/icons/ability_paladin_swiftretribution", "|cffffffffVindicte rapide|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Vos Auras augmentent également les vitesses d'incantation et d'attaque en mêlée et à distance de 3%.|r", "spellswiftretribution", 825, -456)
CreateSpellButton("buttonSpellCrusaderStrike", "Interface/icons/spell_holy_crusaderstrike", "|cffffffffInquisition|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Une attaque instantanée qui inflige 93% des dégâts de l'arme.|r", "spellcrusaderstrike", 935, -456)
CreateSpellButton("buttonSpellSheathofLight", "Interface/icons/ability_paladin_sheathoflight", "|cffffffffFourreau de lumière|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Augmente votre puissance des sorts d'un montant égal à 30% de votre puissance d'attaque et vos sorts de soins critiques rendent à la cible un montant de points de vie égal à 60% des points de vie rendus en 12 secondes.|r", "spellsheathoflight", 1045, -456)
CreateSpellButton("buttonSpellRighteousVengeance", "Interface/icons/ability_paladin_righteousvengeance", "|cffffffffVengeance vertueuse|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Quand vos sorts de Jugement, Inquisition ou Tempête divine infligent un coup critique, votre cible subira 30% de dégâts supplémentaires en 8 secondes.|r", "spellrighteousvengeance", 771, -510)
CreateSpellButton("buttonSpellDivineStorm", "Interface/icons/ability_paladin_divinestorm", "|cffffffffTempête divine|r\n|cffffffffTalent|r |cffff8040Vindicte|r\n|cffffffffRequiert|r |cfff58cbaPaladin|r\n|cffffd100Une attaque instantanée avec une arme qui inflige 110% des dégâts de l'arme à un maximum de 4 ennemis se trouvant à moins de 8 mètres.\nLa Tempête divine soigne jusqu'à 3 membres du groupe ou du raid pour un total de 25% des dégâts infligés.|r", "spelldivinestorm", 988, -510)




local resetButtonClicked = false

local buttonReset = CreateFrame("Button", "buttonReset", frameTalentPaladin, "UIPanelButtonTemplate")
buttonReset:SetSize(85, 25)
buttonReset:SetPoint("BOTTOMRIGHT", buttonTalentPaladinClose, "BOTTOMLEFT", -95, 5)
buttonReset:SetText("Réinitialiser")

local function ResetTalents()
    AIO.Handle("TalentPaladinspell", "ResetTalents")
    resetButtonClicked = true
end

buttonReset:SetScript("OnClick", ResetTalents)

local buttonReload = CreateFrame("Button", "buttonReload", frameTalentPaladin, "UIPanelButtonTemplate")
buttonReload:SetSize(85, 25)
buttonReload:SetPoint("BOTTOMRIGHT", buttonTalentPaladinClose, "BOTTOMLEFT", -5, 5)
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
        frameTalentPaladin:Hide()
        buttonReload:Hide()
        PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
    else
        frameTalentPaladin:Show()
        buttonReload:Show()
        PlaySoundFile(OPEN_TALENT_WINDOW_SOUND)
    end

    talentsWindowOpen = not talentsWindowOpen
end

local playerClass = select(2, UnitClass("player"))
if playerClass == "PALADIN" then
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
        GameTooltip:SetText("|cffffffffTalents|r |cfff58cba(Paladin)|r\n\nL'éventail des talents disponibles\npour améliorer et spécialiser\nvotre personnage.")
        GameTooltip:Show()
    end)

    buttonOuvrirTalents:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    buttonOuvrirTalents:SetScript("OnClick", OuvrirFermerInterfaceTalents)
    TalentMicroButton:Hide()
end

PaladinHandlers.UpdateTalentCount = function(player, talentsAppris)
    if fontTalentPaladinFrameText then
        fontTalentPaladinFrameText:SetText(talentsAppris .. " / " .. MAX_TALENTS)
    end
end

PaladinHandlers.UpdateTalentPointsUsed = function(player, pointsUsed, pointsBeforeReset)
    print("|cff00ffffVous avez utilisés " .. pointsBeforeReset .. " points avant la réinitialisation des talents|r")
end