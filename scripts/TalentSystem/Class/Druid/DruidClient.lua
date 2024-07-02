local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local DruidHandlers = AIO.AddHandlers("TalentDruidspell", {})

function DruidHandlers.ShowTalentDruid(player)
    frameTalentDruid:Show()
end

local MAX_TALENTS = 44

local OPEN_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_final_trait_unlocked.ogg"
local CLOSE_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_trait_refund_end.ogg"
local SPELL_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_80_azeritearmor_rotationends_02.ogg"

local frameTalentDruid = CreateFrame("Frame", "frameTalentDruid", UIParent)
frameTalentDruid:SetSize(1200, 650)
frameTalentDruid:SetMovable(true)
frameTalentDruid:EnableMouse(true)
frameTalentDruid:RegisterForDrag("LeftButton")
frameTalentDruid:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
frameTalentDruid:SetBackdrop(
{
    bgFile = "interface/TalentFrame/Template/Class/Druid/talentsclassbackgrounddruid",
    edgeFile = "interface/tooltips/ui-tooltip-border-corrupteddruid",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

local druidIcon = frameTalentDruid:CreateTexture("DruidIcon", "OVERLAY")
druidIcon:SetTexture("Interface\\TalentFrame\\Template\\Class\\Druid\\IconeDruid.blp")
druidIcon:SetSize(60, 60)
druidIcon:SetPoint("TOPLEFT", frameTalentDruid, "TOPLEFT", -10, 10)


local textureone = frameTalentDruid:CreateTexture("TemplateTalentFrame", "OVERLAY")
textureone:SetTexture("Interface\\TalentFrame\\Template\\Class\\Druid\\TalentFrameTemplate.blp")
textureone:SetSize(928, 928)
textureone:SetPoint("TOPLEFT", frameTalentDruid, "TOPLEFT", -170, 140)

frameTalentDruid:SetFrameLevel(100)

local texturetwo = frameTalentDruid:CreateTexture("TemplateTalentFrame", "OVERLAY")
texturetwo:SetTexture("Interface\\TalentFrame\\Template\\Class\\Druid\\TalentFrameTemplateOriginal.blp")
texturetwo:SetSize(928, 928)
texturetwo:SetPoint("TOPRIGHT", frameTalentDruid, "TOPRIGHT", 170, 140)

frameTalentDruid:SetFrameLevel(100)

frameTalentDruid:SetScript("OnDragStart", frameTalentDruid.StartMoving)
frameTalentDruid:SetScript("OnHide", frameTalentDruid.StopMovingOrSizing)
frameTalentDruid:SetScript("OnDragStop", frameTalentDruid.StopMovingOrSizing)
frameTalentDruid:Hide()

frameTalentDruid:SetBackdropBorderColor(135, 135, 237)


local buttonTalentDruidClose = CreateFrame("Button", "buttonTalentDruidClose", frameTalentDruid, "UIPanelCloseButton")
buttonTalentDruidClose:SetPoint("TOPRIGHT", -12, -12)
buttonTalentDruidClose:EnableMouse(true)
buttonTalentDruidClose:SetSize(32, 32)

local function CloseTalentWindow()
    frameTalentDruid:Hide()
    PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
end

buttonTalentDruidClose:SetScript("OnClick", CloseTalentWindow)

local frameTalentDruidTitleBar = CreateFrame("Frame", "frameTalentDruidTitleBar", frameTalentDruid, nil)
frameTalentDruidTitleBar:SetSize(135, 25)
frameTalentDruidTitleBar:SetBackdrop(
{
    bgFile = "interface/corrupteditems/corruptedtooltipbackground",
    edgeFile = "interface/tooltips/ui-tooltip-border-corrupteddruid",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameTalentDruidTitleBar:SetPoint("TOP", 0, 20)

local fontTalentDruidTitleText = frameTalentDruidTitleBar:CreateFontString("fontTalentDruidTitleText")
fontTalentDruidTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontTalentDruidTitleText:SetSize(190, 5)
fontTalentDruidTitleText:SetPoint("CENTER", 0, 0)
fontTalentDruidTitleText:SetText("|cffFFC125Talents|r")

local fontTalentDruidFrameText = frameTalentDruidTitleBar:CreateFontString("fontTalentDruidFrameText")
fontTalentDruidFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentDruidFrameText:SetSize(200, 5)
fontTalentDruidFrameText:SetPoint("TOPLEFT", frameTalentDruidTitleBar, "BOTTOMLEFT", -30, -35)
fontTalentDruidFrameText:SetText("|cffFFC125Druide|r")

local fontTalentDruidFrameText = frameTalentDruidTitleBar:CreateFontString("fontTalentDruidFrameText")
fontTalentDruidFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentDruidFrameText:SetSize(200, 5)
fontTalentDruidFrameText:SetPoint("TOPLEFT", frameTalentDruidTitleBar, "BOTTOMLEFT", -30, -60)
fontTalentDruidFrameText:SetText("0 / " .. MAX_TALENTS)



local function CreateSpellButton(name, texturePath, tooltipText, talentHandler, positionX, positionY)
    local buttonClicked = false
    local talentLearned = false

    local button = CreateFrame("Button", name, frameTalentDruid, nil)
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
                AIO.Handle("TalentDruidspell", talentHandler, 1)
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






CreateSpellButton("buttonSpellStarlightWrath", "Interface/icons/spell_nature_abolishmagic", "|cffffffffColère stellaire|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Réduit le temps d'incantation de vos sorts Colère et Feu Stellaire de 0.5 sec.|r", "spellstarlightwrath", 100, -80)
CreateSpellButton("buttonSpellGenesis", "Interface/icons/spell_arcane_arcane03", "|cffffffffGenèse|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente les dégâts et les soins produits par les effets de dégâts et de soins de vos sorts périodiques de 5%.|r", "spellgenesis", 205, -75)
CreateSpellButton("buttonSpellMoonglow", "Interface/icons/spell_nature_sentinal", "|cffffffffLueur de la lune|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Réduit de 9% le coût en mana de vos sorts Eclat lunaire, Feu stellaire, Météores, Colère, Toucher guérisseur, Nourrir, Rétablissement et Récupération.|r", "spellarcanestability", 315, -75)
CreateSpellButton("buttonSpellNaturesMajesty", "Interface/icons/inv_staff_01", "|cffffffffMajesté de la nature|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente de 4% les chances d'infliger un coup critique avec vos sorts Colère, Feu stellaire, Météores, Nourrir et Toucher guérisseur.|r", "spellnaturesmajesty", 418, -80)
CreateSpellButton("buttonSpellImprovedMoonfire", "Interface/icons/spell_nature_starfall", "|cffffffffEclat lunaire amélioré|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente les points de dégâts et les chances de porter un coup critique avec votre sort Eclat lunaire de 10%.|r", "spellimprovedmoonfire", 150, -130)
CreateSpellButton("buttonSpellBrambles", "Interface/icons/spell_nature_thorns", "|cffffffffRonces|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Les dégâts infligés par vos Epines et Sarments sont augmentés de 75% et les attaques de vos Tréants sont augmentées de 15%.\nDe plus, les dégâts infligés par vos Tréants et les attaques avec Ecorce activé ont 15% de chances d'hébéter la cible pendant 3 sec.|r", "spellbrambles", 260, -130)
CreateSpellButton("buttonSpellNaturesGrace", "Interface/icons/spell_nature_naturesblessing", "|cffffffffGrâce de la nature|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Tous les coups critiques non périodiques des sorts ont 100% de chances de vous octroyer une Bénédiction de la nature.\nCette dernière augmente de 20% votre vitesse d'incantation des sorts pendant 3 seconds.|r", "spellnaturesgrace", 370, -130)
CreateSpellButton("buttonSpellNaturesSplendor", "Interface/icons/spell_nature_natureguardian", "|cffffffffSplendeur de la nature|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente la durée de vos sorts Eclat lunaire et Récupération de 3 sec., Rétablissement de 6 sec.\nainsi qu'Essaim d'insectes et Fleur de vie de 2 sec.|r", "spellnaturessplendor", 475, -133)
CreateSpellButton("buttonSpellNaturesReach", "Interface/icons/spell_nature_naturetouchgrow", "|cffffffffAllonge de la Nature|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente la portée de vos sorts d'Équilibre et de la technique Lucioles (farouche) de 20%, et réduit la menace générée par vos sorts d'Equilibre de 30%.|r", "spellnaturesreach", 96, -185)
CreateSpellButton("buttonSpellVengeance", "Interface/icons/spell_nature_purge", "|cffffffffVengeance|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente de 100% le bonus de dégâts supplémentaires infligés par les coups critiques avec vos sorts Feu stellaire, Météores, Eclat lunaire et Colère.|r", "spellvengeance", 205, -185)
CreateSpellButton("buttonSpellCelestialFocus", "Interface/icons/spell_arcane_starfire", "|cffffffffFocalisation céleste|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Réduit de 70% l'interruption causée par les attaques infligeant des dégâts pendant que vous incantez Feu stellaire, Hibernation et Ouragan, en plus d'augmenter votre total de hâte des sorts de 3%.|r", "spellcelestialfocus", 315, -185)
CreateSpellButton("buttonSpellLunarGuidance", "Interface/icons/ability_druid_lunarguidance", "|cffffffffSoutien lunaire|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente la puissance de vos sorts de 12% de votre total d'Intelligence.|r", "spelllunarguidance", 422, -185)
CreateSpellButton("buttonSpellInsectSwarm", "Interface/icons/spell_nature_insectswarm", "|cffffffffEssaim d'insectes|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100La cible ennemie est assaillie par des insectes. Ses chances de toucher sont réduites de 3% et elle subit 144 points de dégâts de Nature en 12 seconds.|r", "spellinsectswarm", 527, -190)
CreateSpellButton("buttonSpellImprovedInsectSwarm", "Interface/icons/spell_nature_insectswarm", "|cffffffffEssaim d'insectes amélioré|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente les dégâts infligés par votre sort Colère aux cibles affectées par votre sort Essaim d'insectes de 3%,\net augmente les chances de coup critique de votre sort Feu stellaire de 3% sur les cibles affectées par votre sort Eclat lunaire.|r", "spellimprovedinsectswarm", 43, -240)
CreateSpellButton("buttonSpellDreamstate", "Interface/icons/ability_druid_dreamstate", "|cffffffffEtat de rêve|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Régénère une quantité de mana égale à 10% de votre Intelligence toutes les 5 sec., même pendant l'incantation.|r", "spelldreamstate", 150, -240)
CreateSpellButton("buttonSpellMoonfury", "Interface/icons/spell_nature_moonglow", "|cffffffffFureur lunaire|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente de 10% les dégâts infligés par vos sorts Feu stellaire,\nEclat lunaire et Colère.|r", "spellmoonfury", 368, -240)
CreateSpellButton("buttonSpellBalanceofPower", "Interface/icons/ability_druid_balanceofpower", "|cffffffffEquilibre de la puissance|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente vos chances de toucher avec tous les sorts de 4% et réduit les dégâts que vous infligent tous les sorts de 6%.|r", "spellbalanceofpower", 478, -240)
CreateSpellButton("buttonSpellMoonkinForm", "Interface/icons/spell_nature_forceofnature", "|cffffffffForme de sélénien|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Le druide adopte sa forme de sélénien. Tant qu'il est sous cette forme, la valeur d'armure apportée par les objets est augmentée de 370%,\nles dégâts qu'il subit alors qu'il est étourdi sont réduits de 15% et tous les membres du groupe\net du raid se trouvant à moins de 100 mètres voient leurs chances d'obtenir un coup critique avec les sorts augmenter de 5%.\nLes critiques réussis avec les sorts monocibles sous cette forme ont une chance de régénérer instantanément 2% de votre total de mana.\nLe sélénien ne peut pas lancer de sorts de soins ou de résurrection tant qu'il est transformé.\n\nLa transformation libère le lanceur de sorts des métamorphoses et des effets qui affectent le déplacement.|r", "spellmoonkinform", 98, -293)
CreateSpellButton("buttonSpellImprovedMoonkinForm", "Interface/icons/ability_druid_improvedmoonkinform", "|cffffffffForme de sélénien améliorée|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Votre Aura de sélénien permet aussi aux cibles affectées de voir leur hâte augmenter de 3%,\net vous bénéficiez d'un montant de dégâts des sorts supplémentaire égal à 30% de votre Esprit.|r", "spellimprovedmoonkinform", 205, -293)
CreateSpellButton("buttonSpellImprovedFaerieFire", "Interface/icons/spell_nature_faeriefire", "|cffffffffLucioles améliorées|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Votre sort Lucioles augmente aussi les chances que la cible soit touchée par les attaques avec les sorts de 3%\nainsi que vos chances de coup critique avec les sorts infligeant des dégâts sur les cibles affectées par Lucioles de 3%.|r", "spellimprovedfaeriefire", 315, -293)
CreateSpellButton("buttonSpellOwlkinFrenzy", "Interface/icons/ability_druid_owlkinfrenzy", "|cffffffffFrénésie du chouettide|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Les attaques que vous subissez lorsque vous êtes en forme de sélénien ont 15% de chances de vous faire entrer dans un état de frénésie,\nqui augmente vos dégâts de 10%, vous rend insensible aux interruptions pendant l'incantation de sorts d'Equilibre et vous donne 2% de votre mana de base toutes les 2 sec.\nDure 10 seconds.|r", "spellowlkinfrenzy", 422, -293)
CreateSpellButton("buttonSpellWrathofCenarius", "Interface/icons/ability_druid_twilightswrath", "|cffffffffColère de Cénarius|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Votre sort Feu stellaire bénéficie de 20% supplémentaires et votre Colère de 10% supplémentaires des effets du bonus aux dégâts.|r", "spellwrathofcenarius", 260, -240)
CreateSpellButton("buttonSpellEclipse", "Interface/icons/ability_druid_eclipse", "|cffffffffEclipse|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Quand vous réussissez un coup critique avec Feu stellaire, vous avez 100% de chances d'augmenter de 40% les dégâts infligés par Colère.\nQuand vous réussissez un coup critique avec Colère, vous avez 60% de chances d'augmenter vos chances de coup critique avec Feu stellaire de 40%.\nChaque effet dure 15 seconds. et a un temps de recharge distinct de 30 sec.\nLes deux effets ne peuvent se produire simultanément.|r", "spelleclipse", 43, -350)
CreateSpellButton("buttonSpellTyphoon", "Interface/icons/ability_druid_typhoon", "|cffffffffTyphon|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Vous invoquez un violent Typhon qui inflige 400 points de dégâts de Nature quand il entre en contact avec des cibles hostiles.\nIl les fait tomber à la renverse et les hébète pendant 6 seconds.|r", "spelltyphoon", 150, -350)
CreateSpellButton("buttonSpellForceofNature", "Interface/icons/ability_druid_forceofnature", "|cffffffffForce de la nature|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Invoque 3 tréants qui attaquent les cibles ennemies pendant 30 seconds.|r", "spellforceofnature", 260, -350)
CreateSpellButton("buttonSpellGaleWinds", "Interface/icons/ability_druid_galewinds", "|cffffffffGrands vents|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente de 30% les dégâts infligés par vos sorts Ouragan et Typhon, et augmente la portée de votre sort Cyclone de 4 mètres.|r", "spellgalewinds", 368, -350)
CreateSpellButton("buttonSpellEarthandMoon", "Interface/icons/ability_druid_earthandsky", "|cffffffffTerre et lune|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Vos sorts Colère et Feu stellaire ont 100% de chances d'appliquer l'effet Terre et lune sur la cible.\nCelui-ci augmente les dégâts des sorts infligés à la cible de 13% pendant 12 seconds.\nAugmente également vos dégâts des sorts de 6%.|r", "spellearthandmoon", 478, -350)
CreateSpellButton("buttonSpellStarfall", "Interface/icons/ability_druid_starfall", "|cffffffffMétéores|r\n|cffffffffTalent|r |cff65ca00Equilibre|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Un déluge de météores tombe du ciel sur toutes les cibles se trouvant à moins de a mètres du lanceur de sorts et chacun inflige 145 à 167 points de dégâts des Arcanes.\nInflige également 26 points de dégâts des Arcanes à tous les autres ennemis se trouvant à moins de 5 mètres de la cible ennemie.\n20 météores au maximum. Dure 10 seconds. Si vous changez de forme ou utilisez une monture, l'effet est annulé.\nTout effet qui vous fait perdre le contrôle de votre personnage l'annule également.|r", "spellstarfall", 98, -405)


CreateSpellButton("buttonSpellFerocity", "Interface/icons/ability_hunter_pet_hyena", "|cffffffffFérocité|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Réduit le coût en rage ou en énergie de vos techniques Mutiler, Balayage, Griffe, Griffure et Mutilation de 5.|r", "spellferocity", 205, -405)
CreateSpellButton("buttonSpellFeralAggression", "Interface/icons/ability_druid_demoralizingroar", "|cffffffffAgressivité farouche|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente les effets de réduction de la puissance d'attaque de votre Rugissement démoralisant de 40% et les dégâts infligés par votre Morsure féroce de 15%.|r", "spellferalaggression", 315, -405)
CreateSpellButton("buttonSpellFeralInstinct", "Interface/icons/ability_ambush", "|cffffffffInstinct farouche|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente de 30% les dégâts infligés par votre technique Balayage et réduit les chances de vous détecter de vos ennemis lorsque vous rôdez.|r", "spellferalinstinct", 422, -405)
CreateSpellButton("buttonSpellSavageFury", "Interface/icons/ability_druid_ravage", "|cffffffffFurie sauvage|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente les dégâts infligés par vos techniques Griffe, Griffure, Mutilation (félin), Mutilation (ours) et Mutiler de 20%.|r", "spellsavagefury", 43, -458)
CreateSpellButton("buttonSpellThickHide", "Interface/icons/inv_misc_pelt_bear_03", "|cffffffffPeau épaisse|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente de 10% la valeur d'armure apportée par les objets en tissu et en cuir.|r", "spellthickhide", 150, -458)
CreateSpellButton("buttonSpellFeralSwiftness", "Interface/icons/spell_nature_spiritwolf", "|cffffffffCélérité farouche|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente votre vitesse de déplacement de 30% avec votre forme de félin\net augmente vos chances d'esquiver lorsque vous êtes en forme de félin, d'ours et d'ours redoutable de 4%.|r", "spellferalswiftness", 260, -458)
CreateSpellButton("buttonSpellSurvivalInstincts", "Interface/icons/ability_druid_tigersroar", "|cffffffffInstincts de survie|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Activée, cette technique vous confère temporairement 30% de votre maximum de points de vie\nen plus pendant 20 seconds lorsque vous êtes en forme d'ours, de félin ou d'ours redoutable.\nLorsque l'effet expire, les points de vie sont perdus.|r", "spellsurvivalinstincts", 368, -458)
CreateSpellButton("buttonSpellSharpenedClaws", "Interface/icons/inv_misc_monsterclaw_04", "|cffffffffGriffes aiguisées|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente de 6% vos chances d'infliger un coup critique lorsque vous êtes transformé en ours, en ours redoutable ou en félin.|r", "spellsharpenedclaws", 478, -458)
CreateSpellButton("buttonSpellShreddingAttacks", "Interface/icons/spell_shadow_vampiricaura", "|cffffffffAttaques lacérantes|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Réduit de 18 le coût en énergie de votre technique Lambeau et de 2 le coût en rage de votre technique Lacérer.|r", "spellshreddingattacks", 98, -510)
CreateSpellButton("buttonSpellPredatoryStrikes", "Interface/icons/ability_hunter_pet_cat", "|cffffffffFrappes de prédateur|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente votre puissance d'attaque en mêlée en forme de félin, d'ours et d'ours redoutable de 150% de votre niveau et de 20% la puissance d'attaque de votre arme équipée.\nDe plus, vos coups de grâce ont 20% de chances par point de combo de faire de votre prochain sort de Nature au temps d'incantation de base inférieur à 10 sec.\nun sort instantané.|r", "spellpredatorystrikes", 205, -510)
CreateSpellButton("buttonSpellPrimalFury", "Interface/icons/ability_racial_cannibalize", "|cffffffffFureur primitive|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Vous confère 100% de chances de générer 5 points de rage supplémentaires chaque fois que vous réussissez un coup critique en forme d'ours et d'ours redoutable\net vos coups critiques obtenus avec les techniques de la forme de félin qui ajoutent des points de combo ont 100% de chances d'ajouter un point de combo supplémentaire.|r", "spellprimalfury", 315, -510)
CreateSpellButton("buttonSpellPrimalPrecision", "Interface/icons/ability_druid_primalprecision", "|cffffffffPrécision primale|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente votre expertise de 10,\net vous êtes remboursé de 80% du coût en énergie d'un coup de grâce si celui-ci échoue.|r", "spellprimalprecision", 422, -510)


CreateSpellButton("buttonSpellImpactbrutal", "Interface/icons/ability_druid_bash", "|cffffffffImpact brutal|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente la durée d'étourdissement de vos techniques Sonner\net Traquenard de 1 sec. et réduit le temps de recharge de Sonner de 30 sec.|r", "spellimpactbrutal", 663, -75)
CreateSpellButton("buttonSpellFeralCharge", "Interface/icons/ability_hunter_pet_bear", "|cffffffffCharge farouche|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Apprend Charge farouche (ours) et Charge farouche (félin).\n\nCharge farouche (ours) - Vous chargez un ennemi, l'immobilisez et interrompez le sort qu'il incantait pendant 4 secondes.\nCette technique ne peut être utilisée qu'en forme d'ours et d'ours redoutable.\nTemps de recharge de 15 secondes.\n\nCharge farouche (félin) - Vous bondissez derrière un ennemi et l'hébétez pendant 3 secondes.\nTemps de recharge de 30 secondes.|r", "spellferalcharge", 770, -75)
CreateSpellButton("buttonSpellNurturingInstinct", "Interface/icons/ability_druid_healinginstincts", "|cffffffffInstinct nourricier|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente vos sorts de soins d'un montant égal à 70% au maximum de votre Agilité,\net augmente les soins qui vous sont prodigués de 20% quand vous êtes en forme de félin.|r", "spellnurturinginstinct", 880, -75)
CreateSpellButton("buttonSpellNaturalReaction", "Interface/icons/ability_bullrush", "|cffffffffRéaction naturelle|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente votre score d'esquive en forme d'ours ou d'ours redoutable de 6%,\net vous régénérez 3 points de rage chaque fois que vous esquivez en forme d'ours ou d'ours redoutable.|r", "spellnaturalreaction", 990, -75)
CreateSpellButton("buttonSpellHeartoftheWild", "Interface/icons/spell_holy_blessingofagility", "|cffffffffCœur de fauve|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente votre Intelligence de 20%.\nDe plus, votre Endurance est augmentée de 10% lorsque vous êtes en forme d'ours ou d'ours redoutable\net votre puissance d'attaque est augmentée de 10% lorsque vous êtes en forme de félin.|r", "spellheartofthewild", 1100, -75)
CreateSpellButton("buttonSpellSurvivaloftheFittest", "Interface/icons/ability_druid_enrage", "|cffffffffSurvie du plus apte|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente toutes les caractéristiques de 6%, réduit la probabilité que vous soyez touché par un coup critique infligé par une attaque en mêlée de 6%\net augmente de 33% la valeur d'armure apportée par les objets en tissu et en cuir quand vous êtes en forme d'ours et d'ours redoutable.|r", "spellsurvivalofthefittest", 718, -130)
CreateSpellButton("buttonSpellLeaderofthePack", "Interface/icons/spell_nature_unyeildingstamina", "|cffffffffChef de la meute|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Pendant qu'il est en forme de félin, d'ours ou d'ours redoutable, le Chef de la meute augmente de 5% les chances\nde tous les membres du groupe se trouvant à moins de 100 mètres d'obtenir un coup critique avec les attaques à distance et en mêlée.|r", "spellleaderofthepack", 825, -130)
CreateSpellButton("buttonSpellImprovedLeaderofthePack", "Interface/icons/spell_nature_unyeildingstamina", "|cffffffffChef de la meute amélioré|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Votre technique Chef de la meute permet aussi aux cibles affectées d'être soignées pour un montant égal à\n4% de leur total de points de vie lorsqu'elles réussissent un coup critique avec une attaque en mêlée ou à distance.\nL'effet de soins ne peut se produire plus d'une fois toutes les 6 sec.\nDe plus, vous recevez 8% de votre maximum de mana quand vous bénéficiez de ce soin.|r", "spellimprovedleaderofthepack", 935, -130)
CreateSpellButton("buttonSpellPrimalTenacity", "Interface/icons/ability_druid_primaltenacity", "|cffffffffTénacité primordiale|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Réduit de 30% la durée des effets de Peur\net de 30% tous les dégâts subis quand vous êtes en forme de félin alors que vous êtes étourdi.|r", "spelprimaltenacity", 1045, -130)
CreateSpellButton("buttonSpellProtectorofthePack", "Interface/icons/ability_druid_challangingroar", "|cffffffffProtecteur de la meute|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente votre puissance d'attaque de 6%\net réduit les dégâts que vous subissez de 12% tant que vous êtes en forme d'ours ou d'ours redoutable.|r", "spellprotectorofthepack", 663, -184)
CreateSpellButton("buttonSpellMangle", "Interface/icons/ability_druid_mangle2", "|cffffffffMutilation|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Mutile la cible, lui inflige des dégâts\net fait augmenter les dégâts infligés par les effets de saignement pendant 60 seconds.\nCette technique peut être utilisée en forme de félin ou d'ours redoutable.|r", "spellmangle", 770, -184)
CreateSpellButton("buttonSpellImprovedMangle", "Interface/icons/ability_druid_mangle2", "|cffffffffMutilation améliorée|r\n|cffffffffTalent|r |cffa07db5Mutilation améliorée|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Réduit le temps de recharge de votre technique Mutilation (ours) de 1.5 sec.,\net réduit le coût en énergie de votre technique Mutilation (félin) de 6.|r", "spellimprovedmangle", 880, -184)
CreateSpellButton("buttonSpellRendandTear", "Interface/icons/ability_druid_primalagression", "|cffffffffPourfendre et déchirer|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente les dégâts infligés par les attaques Mutiler et Lambeau sur les cibles qui saignent de 20%,\net augmente les chances de coup critique de votre technique Morsure féroce sur les cibles qui saignent de 25%.|r", "spellrendandtear", 990, -184)
CreateSpellButton("buttonSpellPrimalGore", "Interface/icons/ability_druid_rake", "|cffffffffLacération primitive|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Les dégâts périodiques de vos techniques Lacérer et Déchirure peuvent être critiques.", "spellprimalgore", 1100, -184)
CreateSpellButton("buttonSpellBerserk", "Interface/icons/ability_druid_berserk", "|cffffffffBerserk|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Activée, cette technique permet à votre technique Mutilation (ours) d'atteindre un maximum de 3 cibles\nen plus de fonctionner sans temps de recharge, et réduit le coût en énergie de toutes vos techniques en forme de félin de 50%.\nDure 15 seconds. Vous ne pouvez pas utiliser Fureur du tigre quand Berserk est actif.\n\nAnnule l'effet de Peur et vous rend insensible à Peur pendant toute sa durée.|r", "spellberserk", 718, -240)
CreateSpellButton("buttonSpellPredatoryInstincts", "Interface/icons/ability_druid_predatoryinstincts", "|cffffffffInstincts de prédateur|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Lorsque vous êtes en forme de félin, augmente les dégâts de vos coups critiques en mêlée de 10% et réduit les dégâts que vous infligent les attaques à zone d'effet de 30%.|r", "spellpredatoryinstincts", 825, -240)
CreateSpellButton("buttonSpellInfectedWounds", "Interface/icons/ability_druid_infectedwound", "|cffffffffBlessures infectées|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Vos attaques Lambeau, Mutiler et Mutilation infligent une blessure infectée à la cible.\nLa Blessure infectée réduit la vitesse de déplacement de la cible de 50% et sa vitesse d'attaque de 20%.\nDure 12 seconds.|r", "spellinfectedwounds", 935, -240)
CreateSpellButton("buttonSpellKingoftheJungle", "Interface/icons/ability_druid_kingofthejungle", "|cffffffffRoi de la jungle|r\n|cffffffffTalent|r |cffa07db5Combat Farouche|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Lorsque vous utilisez votre technique Enragé en forme d'ours ou d'ours redoutable, vos dégâts sont augmentés de 15%,\net votre technique Fureur du tigre vous rend aussi immédiatement 60 points d'énergie.\nDe plus, le coût en mana des formes d'ours, de félin et d'ours redoutable est réduit de 60%.", "spellkingofthejungle", 1045, -240)



CreateSpellButton("buttonSpellImprovedMarkoftheWild", "Interface/icons/spell_nature_regeneration", "|cffffffffMarque du fauve améliorée|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente les effets de vos sorts Marque du fauve et Don du fauve de 40%,\net augmente l'ensemble de vos totaux de caractéristiques de 2%.|r", "spellimprovedmarkofthewild", 663, -293)
CreateSpellButton("buttonSpellNaturesFocus", "Interface/icons/spell_nature_healingwavegreater", "|cffffffffFocalisation de la nature|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Réduit de 70% l'interruption causée par les attaques infligeant des dégâts pendant que vous incantez\nToucher guérisseur, Colère, Sarments, Cyclone, Nourrir, Rétablissement et Tranquillité.|r", "spellnaturesfocus", 770, -293)
CreateSpellButton("buttonSpellFuror", "Interface/icons/spell_holy_blessingofstamina", "|cffffffffFureur|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Vous confère 100% de chances de gagner 10 points de rage lorsque vous vous transformez en ours et ours redoutable.\nVous conservez jusqu'à 100 de vos points d'énergie lorsque vous vous transformez en félin.\nAugmente de 10% votre total d'Intelligence lorsque vous êtes en forme de sélénien.|r", "spellfuror", 990, -293)
CreateSpellButton("buttonSpellNaturalist", "Interface/icons/spell_nature_healingtouch", "|cffffffffNaturaliste|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Réduit le temps d'incantation de votre sort Toucher guérisseur de 0.5 sec.\net augmente les dégâts que vous infligez avec les attaques physiques sous toutes les formes de 10%.|r", "spellnaturalist", 880, -293)
CreateSpellButton("buttonSpellSubtlety", "Interface/icons/ability_eyeoftheowl", "|cffffffffDiscrétion|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Réduit de 30% la menace générée par vos sorts de restauration\net réduit de 30% la probabilité que vos sorts bénéfiques, Eclat lunaire et Essaim d'insectes soient dissipés.|r", "spellsubtlety", 1100, -293)
CreateSpellButton("buttonSpellNaturalShapeshifter", "Interface/icons/spell_nature_wispsplode", "|cffffffffChangeforme naturel|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Réduit le coût en mana de tous les changements de forme de 30%.|r", "spellnaturalshapeshifter", 718, -348)
CreateSpellButton("buttonSpellIntensity", "Interface/icons/spell_frost_windwalkon", "|cffffffffIntensité|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Vous confère 50% de votre vitesse de récupération du mana normale pendant l'incantation.\nVotre technique Enrager génère instantanément 10 points de rage.|r", "spellintensity", 825, -348)
CreateSpellButton("buttonSpellOmenofClarity", "Interface/icons/spell_nature_crystalball", "|cffffffffAugure de clarté|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Tous les dégâts, sorts de soins et attaques automatiques du druide ont une chance de faire entrer le lanceur de sorts dans un état d'Idées claires.\nCet état réduit le coût en mana, en rage ou en énergie de votre prochain sort de dégât ou de soins ou de votre prochaine technique offensive de 100%.|r", "spellomenofclarity", 935, -348)
CreateSpellButton("buttonSpellMasterShapeshifter", "Interface/icons/ability_druid_mastershapeshifter", "|cffffffffMaître changeforme|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Le druide bénéficie d'un effet tant qu'il conserve la forme concernée.\n\nForme d'ours - Augmente les dégâts physiques de 4%.\n\nForme de félin - Augmente les chances de coup critique de 4%.\n\nForme de sélénien - Augmente les dégâts des sorts de 4%.\n\nForme d'arbre de vie - Augmente les soins de 4%.|r", "spellmastershapeshifter", 1045, -348)
CreateSpellButton("buttonSpellTranquilSpirit", "Interface/icons/spell_holy_elunesgrace", "|cffffffffTranquillité de l'esprit|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Réduit le coût en mana de vos sorts\nToucher guérisseur, Nourrir et Tranquillité de 10%.|r", "spelltranquilspirit", 663, -402)
CreateSpellButton("buttonSpellImprovedRejuvenation", "Interface/icons/spell_nature_rejuvenation", "|cffffffffRécupération améliorée|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente les effets de votre sort Récupération de 15%.|r", "spellimprovedrejuvenation", 770, -402)
CreateSpellButton("buttonSpellNaturesSwiftness", "Interface/icons/spell_nature_ravenform", "|cffffffffRapidité de la nature|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Lorsque cette technique est activée, votre prochain sort de Nature dont le temps d'incantation de base est inférieur à 10 sec. devient un sort instantané.|r", "spellnaturesswiftness", 880, -402)
CreateSpellButton("buttonSpellGiftofNature", "Interface/icons/spell_nature_protectionformnature", "|cffffffffDon de la Nature|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente les effets de tous les sorts de soins de 10%.|r", "spellgiftofnature", 990, -402)
CreateSpellButton("buttonSpellImprovedTranquility", "Interface/icons/spell_nature_tranquility", "|cffffffffTranquillité améliorée|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Diminue le niveau de menace généré par Tranquillité de 100%,\net réduit le temps de recharge de 60%.|r", "spellimprovedtranquility", 1100, -402)
CreateSpellButton("buttonSpellEmpoweredTouch", "Interface/icons/ability_druid_empoweredtouch", "|cffffffffToucher surpuissant|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Votre sort Toucher guérisseur bénéficie de 40% supplémentaires\net votre sort Nourrir de 20% des effets du bonus relatif aux soins.|r", "spellempoweredtouch", 718, -456)
CreateSpellButton("buttonSpellNaturesBounty", "Interface/icons/spell_nature_resistnature", "|cffffffffBonté de la nature|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente les chances d'obtenir un effet critique avec vos sorts Rétablissement et Nourrir de 25%.|r", "spellnaturesbounty", 825, -456)
CreateSpellButton("buttonSpellLivingSpirit", "Interface/icons/spell_nature_giftofthewaterspirit", "|cffffffffEsprit vif|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente votre total d'Esprit de 15%.|r", "spelllivingspirit", 935, -456)
CreateSpellButton("buttonSpellSwiftmend", "Interface/icons/inv_relics_idolofrejuvenation", "|cffffffffPrompte guérison|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Consume un effet de Récupération ou de Rétablissement sur une cible alliée\npour lui rendre instantanément le montant de points de vie équivalent à 12 sec. de Récupération ou 18 sec. de Rétablissement.|r", "spellswiftmend", 1045, -456)
CreateSpellButton("buttonSpellNaturalPerfection", "Interface/icons/ability_druid_naturalperfection", "|cffffffffPerfection naturelle|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Vos chances d'obtenir un coup critique avec tous les sorts sont augmentées de 3%\net les coups critiques contre vous vous font bénéficier de l'effet de Perfection naturelle qui réduit tous les dégâts que vous subissez de 4%.\nCumulable jusqu'à 3 fois\nDure 8 seconds.|r", "spellnaturalperfection", 663, -510)
CreateSpellButton("buttonSpellEmpoweredRejuvenation", "Interface/icons/ability_druid_empoweredrejuvination", "|cffffffffRécupération surpuissante|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Les effets du bonus relatif aux soins de vos sorts de soins sur la durée sont augmentés de 20%.|r", "spellempoweredrejuvenation", 770, -510)
CreateSpellButton("buttonLivingSeed", "Interface/icons/ability_druid_giftoftheearthmother", "|cffffffffGraine de vie|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Quand vous réussissez des soins critiques avec vos sorts Prompte guérison, Rétablissement, Nourrir ou Toucher guérisseur,\nvous avez 100% de chances de planter une Graine de vie sur la cible pour un montant égal à 30% des points de vie rendus.\nLa Graine de vie fleurira lors de la prochaine attaque sur la cible.\nDure 15 seconds.|r", "spelllivingseed", 880, -510)
CreateSpellButton("buttonSpellRevitalize", "Interface/icons/ability_druid_replenish", "|cffffffffRevitaliser|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Vos sorts Récupération et Croissance sauvage ont 15% de chances de rendre 8 points d'énergie,\n4 points de rage, 1% du mana ou 16 points de puissance runique par itération.|r", "spellrevitalize", 990, -510)
CreateSpellButton("buttonSpellTreeofLife", "Interface/icons/ability_druid_treeoflife", "|cffffffffArbre de vie|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Réduit le coût en mana de vos sorts de soins sur la durée de 20% et permet d'adopter la forme de l'Arbre de vie.\nTant que vous êtes sous cette forme,\nles soins reçus sont augmentés de 6% pour tous les membres du groupe et du raid se trouvant à moins de 100 mètres,\net vous ne pouvez lancer que des sorts de Restauration en plus d'Innervation, Ecorce, Emprise de la nature et Epines.\nLa transformation libère le lanceur de sorts des effets qui le ralentissent et des métamorphoses.|r", "spelltreeoflife", 1100, -510)
CreateSpellButton("buttonSpellImprovedTreeofLife", "Interface/icons/ability_druid_improvedtreeform", "|cffffffffArbre de vie amélioré|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente de 200% la valeur d'armure apportée par les objets lorsque vous êtes en forme d'Arbre de vie,\net augmente votre puissance des sorts de 15% de votre Esprit lorsque vous êtes en forme d'Arbre de vie.|r", "spellimprovedtreeoflife", 716, -564)
CreateSpellButton("buttonSpellImprovedBarkskin", "Interface/icons/spell_nature_stoneclawtotem", "|cffffffffEcorce améliorée|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente de 160% la valeur d’armure apportée par les objets en tissu et en cuir lorsque vous êtes en forme de voyage ou que vous n'avez pas changé de forme,\naugmente la réduction de dégâts conférée par votre sort Ecorce de 10% et réduit la probabilité que votre Ecorce soit dissipée de 70%.|r", "spellimprovedbarkskin", 824, -564)
CreateSpellButton("buttonSpellGiftoftheEarthmother", "Interface/icons/ability_druid_manatree", "|cffffffffDon de la Terre-mère|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Augmente votre total de hâte des sorts de 10%\net réduit le temps de recharge de base de votre sort Fleur de vie de 10%.|r", "spellgiftoftheearthmother", 934, -564)
CreateSpellButton("buttonSpellWildGrowth", "Interface/icons/ability_druid_flourish", "|cffffffffCroissance sauvage|r\n|cffffffffTalent|r |cff9cef03Restauration|r\n|cffffffffRequiert|r |cffff7d0aDruide|r\n|cffffd100Rend à 5 membres au maximum du groupe ou du raid alliés se trouvant à moins de 15 mètres de la cible 686 points de vie en 7 seconds.\nLes soins sont prodigués rapidement au début, et ralentissent au fur et à mesure que Croissance sauvage atteint la fin de sa durée.|r", "spellwildgrowth", 1045, -564)



local resetButtonClicked = false

local buttonReset = CreateFrame("Button", "buttonReset", frameTalentDruid, "UIPanelButtonTemplate")
buttonReset:SetSize(85, 25)
buttonReset:SetPoint("BOTTOMRIGHT", buttonTalentDruidClose, "BOTTOMLEFT", -95, 5)
buttonReset:SetText("Réinitialiser")

local function ResetTalents()
    AIO.Handle("TalentDruidspell", "ResetTalents")
    resetButtonClicked = true
end

buttonReset:SetScript("OnClick", ResetTalents)

local buttonReload = CreateFrame("Button", "buttonReload", frameTalentDruid, "UIPanelButtonTemplate")
buttonReload:SetSize(85, 25)
buttonReload:SetPoint("BOTTOMRIGHT", buttonTalentDruidClose, "BOTTOMLEFT", -5, 5)
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
        frameTalentDruid:Hide()
        buttonReload:Hide()
        PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
    else
        frameTalentDruid:Show()
        buttonReload:Show()
        PlaySoundFile(OPEN_TALENT_WINDOW_SOUND)
    end

    talentsWindowOpen = not talentsWindowOpen
end

local playerClass = select(2, UnitClass("player"))
if playerClass == "DRUID" then
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
        GameTooltip:SetText("|cffffffffTalents|r |cffff7d0a(Druide)|r\n\nL'éventail des talents disponibles\npour améliorer et spécialiser\nvotre personnage.")
        GameTooltip:Show()
    end)

    buttonOuvrirTalents:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    buttonOuvrirTalents:SetScript("OnClick", OuvrirFermerInterfaceTalents)
    TalentMicroButton:Hide()
end

DruidHandlers.UpdateTalentCount = function(player, talentsAppris)
    if fontTalentDruidFrameText then
        fontTalentDruidFrameText:SetText(talentsAppris .. " / " .. MAX_TALENTS)
    end
end

DruidHandlers.UpdateTalentPointsUsed = function(player, pointsUsed, pointsBeforeReset)
    print("|cff00ffffVous avez utilisés " .. pointsBeforeReset .. " points avant la réinitialisation des talents|r")
end