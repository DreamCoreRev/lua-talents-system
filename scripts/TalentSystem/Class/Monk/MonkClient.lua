local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local MonkHandlers = AIO.AddHandlers("TalentMonkspell", {})

function MonkHandlers.ShowTalentMonk(player)
    frameTalentMonk:Show()
end

local MAX_TALENTS = 44

local OPEN_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_final_trait_unlocked.ogg"
local CLOSE_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_trait_refund_end.ogg"
local SPELL_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_80_azeritearmor_rotationends_02.ogg"

local frameTalentMonk = CreateFrame("Frame", "frameTalentMonk", UIParent)
frameTalentMonk:SetSize(1200, 650)
frameTalentMonk:SetMovable(true)
frameTalentMonk:EnableMouse(true)
frameTalentMonk:RegisterForDrag("LeftButton")
frameTalentMonk:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
frameTalentMonk:SetBackdrop(
{
    bgFile = "interface/TalentFrame/Template/Class/Monk/talentsclassbackgroundmonk2",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedmonk",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

local monkIcon = frameTalentMonk:CreateTexture("MonkIcon", "OVERLAY")
monkIcon:SetTexture("Interface\\TalentFrame\\Template\\Class\\Monk\\IconeMonk.blp")
monkIcon:SetSize(60, 60)
monkIcon:SetPoint("TOPLEFT", frameTalentMonk, "TOPLEFT", -10, 10)


local textureone = frameTalentMonk:CreateTexture("TemplateTalentFrame", "OVERLAY")
textureone:SetTexture("Interface\\TalentFrame\\Template\\Class\\Monk\\TalentFrameTemplate.blp")
textureone:SetSize(928, 928)
textureone:SetPoint("TOPLEFT", frameTalentMonk, "TOPLEFT", -150, 130)

frameTalentMonk:SetFrameLevel(100)

local texturetwo = frameTalentMonk:CreateTexture("TemplateTalentFrame", "OVERLAY")
texturetwo:SetTexture("Interface\\TalentFrame\\Template\\Class\\Monk\\TalentFrameTemplateOriginal.blp")
texturetwo:SetSize(928, 928)
texturetwo:SetPoint("TOPRIGHT", frameTalentMonk, "TOPRIGHT", 150, 130)

frameTalentMonk:SetFrameLevel(100)

frameTalentMonk:SetScript("OnDragStart", frameTalentMonk.StartMoving)
frameTalentMonk:SetScript("OnHide", frameTalentMonk.StopMovingOrSizing)
frameTalentMonk:SetScript("OnDragStop", frameTalentMonk.StopMovingOrSizing)
frameTalentMonk:Hide()

frameTalentMonk:SetBackdropBorderColor(0, 255, 150)

local buttonTalentMonkClose = CreateFrame("Button", "buttonTalentMonkClose", frameTalentMonk, "UIPanelCloseButton")
buttonTalentMonkClose:SetPoint("TOPRIGHT", -12, -12)
buttonTalentMonkClose:EnableMouse(true)
buttonTalentMonkClose:SetSize(32, 32)

local function CloseTalentWindow()
    frameTalentMonk:Hide()
    PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
end

buttonTalentMonkClose:SetScript("OnClick", CloseTalentWindow)

local frameTalentMonkTitleBar = CreateFrame("Frame", "frameTalentMonkTitleBar", frameTalentMonk, nil)
frameTalentMonkTitleBar:SetSize(135, 25)
frameTalentMonkTitleBar:SetBackdrop(
{
    bgFile = "interface/corrupteditems/corruptedtooltipbackground",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedmonk",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameTalentMonkTitleBar:SetPoint("TOP", 0, 20)

local fontTalentMonkTitleText = frameTalentMonkTitleBar:CreateFontString("fontTalentMonkTitleText")
fontTalentMonkTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontTalentMonkTitleText:SetSize(190, 5)
fontTalentMonkTitleText:SetPoint("CENTER", 0, 0)
fontTalentMonkTitleText:SetText("|cffFFC125Talents|r")

local fontTalentMonkFrameText = frameTalentMonkTitleBar:CreateFontString("fontTalentMonkFrameText")
fontTalentMonkFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentMonkFrameText:SetSize(200, 5)
fontTalentMonkFrameText:SetPoint("TOPLEFT", frameTalentMonkTitleBar, "BOTTOMLEFT", -30, -35)
fontTalentMonkFrameText:SetText("|cffFFC125Moine|r")

local fontTalentMonkFrameText = frameTalentMonkTitleBar:CreateFontString("fontTalentMonkFrameText")
fontTalentMonkFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentMonkFrameText:SetSize(200, 5)
fontTalentMonkFrameText:SetPoint("TOPLEFT", frameTalentMonkTitleBar, "BOTTOMLEFT", -30, -60)
fontTalentMonkFrameText:SetText("0 / " .. MAX_TALENTS)



local function CreateSpellButton(name, texturePath, tooltipText, talentHandler, positionX, positionY)
    local buttonClicked = false
    local talentLearned = false

    local button = CreateFrame("Button", name, frameTalentMonk, nil)
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
                AIO.Handle("TalentMonkspell", talentHandler, 1)
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


CreateSpellButton("buttonSpellPurifyingBrew", "Interface/icons/inv_misc_beer_06", "|cffffffffInfusion purificatrice|r\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Purifie instantanément tous les dégâts reportés.|r", "spellpurifyingbrew", 225, -85)
CreateSpellButton("buttonSpellKegSmash", "Interface/icons/achievement_brewery_2", "|cffffffffFracasse-tonneau\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous frappez la cible avec un tonneau de bière, infligeant entre 389 à 763 points de dégâts à tous les ennemis se trouvant à moins de 8 mètres.|r", "spellkegsmash", 335, -85)
CreateSpellButton("buttonSpellAscension", "Interface/icons/ability_monk_ascension", "|cffffffffAscension\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Augmente votre maximum de votre régénération d’énergie de 30%.|r", "spellascension", 280, -140)
CreateSpellButton("buttonSpellGiftOx", "Interface/icons/ability_druid_giftoftheearthmother", "|cffffffffDon du buffle\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Lorsque vous infligez des dégâts de mêlée,\nvous avez une chance d’invoquer à vos côtés une Sphère de soins visible de vous seul.\n\nQuand vous traversez cette Sphère de soins invoquée grâce au Don du buffle,\nvous récupérez 2581 à 7740 points de vie.|r", "spellgiftox", 170, -140)
CreateSpellButton("buttonSpellPhysicsSphere", "Interface/icons/ability_monk_healthsphere", "|cffffffffSphère de dégâts\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous façonnez une sphère de dégâts à l'emplacement cible pendant 60 seconds.\nSi des ennemis sont proche de la sphère, ils l'absorbent et inflige 355 à 1112 point de dégâts.|r", "spellphysicssphere", 389, -140)
CreateSpellButton("buttonSpellFlyingMonk", "Interface/icons/ability_monk_roll", "|cffffffffRoulade\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Effectuez une roulade sur une courte distance.|r", "spellflyingmonk", 115, -195)
CreateSpellButton("buttonSpellTigerHits", "Interface/icons/ability_monk_tigerpalm", "|cffffffffCoup du tigre\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Une attaque avec la paume de la main qui inflige de 100% points de dégâts.\nVous confère aussi Puissance du tigre, qui permet à vos attaques d’ignorer 30% de l’armure des ennemis pendant 20 seconds.|r", "spelltigerhits", 225, -195)
CreateSpellButton("buttonSpellDampenHarm", "Interface/icons/ability_monk_dampenharm", "|cffffffffAtténuation du mal\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous atténuez les dégâts des attaques les plus violentes contre vous.\nLes dégâts infligés par les 3 prochaines attaques dans les 45 seconds d’un montant égal ou supérieur à 20% de votre total de points de vie sont réduits de moitié.\n\nAtténuation du mal peut être lancé alors que vous êtes étourdi.|r", "spelldampenharm", 335, -195)
CreateSpellButton("buttonSpellDizzyingHaze", "Interface/icons/ability_monk_drunkenhaze", "|cffffffffBrume vertigineuse\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous jetez un tonneau de votre meilleure bière, réduisant la vitesse de déplacement de tous les ennemis se trouvant à moins de 8 mètres de 50% pendant 15 seconds.\nGénère un haut niveau de menace.\n\nLes cibles affectées ont 3% de chances de voir leurs attaques en mêlée rater complètement et les toucher elles-mêmes en infligeant 1367 points de dégâts.|r", "spelldizzyinghaze", 442, -195)
CreateSpellButton("buttonSpellFortifyingBrew", "Interface/icons/ability_monk_fortifyingale_new", "|cffffffffBoisson fortifiante\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Rend votre peau dure comme la pierre,\nce qui augmente vos points de vie de 20% et réduit les dégâts que vous subissez de 20%.\nDure 20 seconds.|r", "spellfortifyingbrew", 388, -248)
CreateSpellButton("buttonSpellLegSweep", "Interface/icons/ability_monk_legsweep", "|cffffffffBalayement de jambe\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Renverse tous les ennemis à moins de 6 mètres et les étourdit pendant 5 seconds.|r", "spelllegsweep", 495, -250)
CreateSpellButton("buttonSpellGuard", "Interface/icons/ability_monk_guard", "|cffffffffGarde\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous êtes en garde contre les prochaines attaques.\nAbsorbe 15180 points de dégâts pendant 30 seconds.\n\nLes soins que vous vous prodiguez sont augmentés de 30%.|r", "spellguard", 280, -250)
CreateSpellButton("buttonSpellLegacyEmperor", "Interface/icons/ability_monk_legacyoftheemperor", "|cffffffffHéritage de l'empereur\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous scandez les mots du dernier empereur, ce qui augmente la Force, l’Agilité et l’Intelligence de 5%.\n\nSi la cible est dans votre groupe ou raid, tous les membres du groupe ou raid sont affectés.|r", "spelllegacyemperor", 170, -250)
CreateSpellButton("buttonSpellDetox", "Interface/icons/ability_rogue_imrovedrecuperate", "|cffffffffDétoxification\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Dissipe les maladies sur la cible alliée et supprime tous les effets néfastes de magie, de poison et de maladie.|r", "spelldetox", 60, -250)
CreateSpellButton("buttonSpellProvoke", "Interface/icons/ability_monk_provoke", "|cffffffffPersiflage\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous raillez la cible,\nqui se précipite alors vers vous à une vitesse de déplacement augmentée de 50%.\n\nSi vous ciblez votre statue du buffle noir,\nce sont tous les ennemis qui s’en trouvent à moins de 8 mètres qui sont persiflés.|r", "spellprovoke", 115, -305)
CreateSpellButton("buttonSpellSummonBlackOxStatue", "Interface/icons/monk_ability_summonoxstatue", "|cffffffffInvocation d’une statue du Buffle noir\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Invoque une statue du Buffle noir à l'emplacement ciblé.\nDure 15 min.\nUne seule statue peut être invoquée à la fois.|r", "spellsummonblackoxstatue", 225, -305)
CreateSpellButton("buttonSpellEvilPrevention", "Interface/icons/monk_ability_avertharm", "|cffffffffPrévention du mal\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous redirigez vers vous 20% de tous les dégâts subis par les membres du groupe ou raid à moins de 10 mètres. Dure 6 seconds.\n\nLes dégâts que vous subissez ainsi peuvent être échelonnés.\nPrévention du mal est annulé si vos points de vie descendent à 10% ou moins.|r", "spellevilprevention", 335, -305)
CreateSpellButton("buttonSpellBreathFire", "Interface/icons/ability_monk_breathoffire", "|cffffffffSouffle de feu\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Souffle du feu et inflige 1784 points de dégâts à toutes les cibles devant vous à moins de 8 mètres.|r", "spellbreathfire", 442, -305)
CreateSpellButton("buttonSpellParry", "Interface/icons/ability_parry", "|cffffffffParade\n|cffffffffTalent Général|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Donne une chance de parer les attaques de mêlée des ennemis.|r", "spellparry", 60, -358)
CreateSpellButton("buttonSpellThunderFocusTea", "Interface/icons/ability_monk_thunderfocustea", "|cffffffffThé de concentration foudroyante\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous recevez une décharge d’énergie qui double les soins prodigués par votre prochaine Déferlante de brume\nou qui fait que votre prochaine Elévation réinitialise la durée de Brumes de rénovation sur toutes les cibles.\nDure 30 seconds.|r", "spellthunderfocustea", 170, -358)
CreateSpellButton("buttonSpellStealWeapon", "Interface/icons/ability_warrior_disarm", "|cffffffffVol d'arme\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous projetez une lance à corde et récupérez les armes et le bouclier de la cible pendant 8 seconds.|r", "spellstealweapon", 280, -358)
CreateSpellButton("buttonSpellFermentationElusiveInfusion", "Interface/icons/ability_monk_elusiveale", "|cffffffffFermentation : Infusion insaisissable\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Les coups critiques des attaques automatiques vous permettent d'accumuler jusqu'à 3 charges Décoction d'insaisissabilité.\nLe nombre de charges dépend de la vitesse de l'arme.\nL'effet s'empile jusqu'à 15 fois pour épuiser les charges.|r", "spellfermentationelusiveinfusion", 388, -358)
CreateSpellButton("buttonSpellIronskinBrew", "Interface/icons/ability_monk_ironskinbrew", "|cffffffffInfusion peau-de-fer\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Augmente vos chances d’esquiver les attaques en mêlée et à distance de 30% pendant 1 seconds\npar charge d’Infusion insaisissable active, en annulant toutes les charges.|r", "spellironskinbrew", 495, -358)
CreateSpellButton("buttonSpellClash", "Interface/icons/ability_monk_clashingoxcharge", "|cffffffffFracas\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Votre cible et vous-même vous précipitez l’un vers l’autre,\nvous heurtant à mi-chemin en étourdissant toutes les cibles à moins de 6 mètres pendant 4 seconds.|r", "spellclash", 115, -413)
CreateSpellButton("buttonSpellMasterBrewerTraining", "Interface/icons/spell_monk_brewmastertraining", "|cffffffffFormation de maître brasseur\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous devenez un maître brasseur accompli, ce qui amplifie trois de vos techniques.|r", "spellmasterbrewertraining", 225, -413)
CreateSpellButton("buttonSpellMasteryElusiveBrawler", "Interface/icons/INV_Drink_05", "|cffffffffMaîtrise : Combattant insaisissable\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Augmente le montant de votre Report de 5% supplémentaires.|r", "spellmasteryelusivebrawler", 335, -413)
CreateSpellButton("buttonSpellSwiftReflexes", "Interface/icons/Ability_Hunter_Displacement", "|cffffffffRéflexes fulgurants\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Augmente vos chances de parer de 5%.|r", "spellswiftreflexes", 442, -413)
CreateSpellButton("buttonSpellDesperateMeasures", "Interface/icons/Spell_Nature_ShamanRage", "|cffffffffMesures désespérées\n|cffffffffTalent |cfff49a01Maître brasseur|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Quand vous disposez de 35% de vos points de vie ou moins, votre Extraction du mal n’a pas de temps de recharge.|r", "spelldesperatemeasures", 60, -465)
CreateSpellButton("buttonSpellStandOff", "Interface/icons/ability_monk_sparring", "|cffffffffAffrontement\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Quand vous êtes attaqué en mêlée par un ennemi qui vous fait face,\nvous vous mettez à repousser ses attaques,\nce qui augmente vos chances de parer de 5% pendant 10 seconds.\nCet effet a un temps de recharge de 30 seconds.|r", "spellstandoff", 170, -465)
CreateSpellButton("buttonSpellMasteryComboStrikes", "Interface/icons/trade_alchemy_potionb3", "|cffffffffMaîtrise : Fureur en bouteille\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Quand vous générez des charges d’Infusion Œil-du-tigre,\nvous avez 20% de chances de générer une charge supplémentaire.|r", "spellmasterycombostrikes", 280, -465)
CreateSpellButton("buttonSpellMuscleMemory", "Interface/icons/Spell_Arcane_MindMastery", "|cffffffffMémoire musculaire\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Lorsque vous réussissez un Coup direct ou que vous infligez des dégâts à au moins 3 ennemis avec Coup tournoyant de la grue,\nvous bénéficiez de Mémoire musculaire, qui augmente les dégâts de votre prochaine Paume du tigre ou Frappe du voile noir de 4% et vous rend 150% de votre mana.|r", "spellmusclememory", 388, -465)
CreateSpellButton("buttonSpellInternalMedicine", "Interface/icons/inv_emberweavebandage2", "|cffffffffMédecine interne\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Votre sort Détoxification dissipe aussi tous les effets magiques lors de son utilisation.|r", "spellinternalmedicine", 495, -465)
CreateSpellButton("buttonSpellManaMeditation", "Interface/icons/Spell_Nature_Sleep", "|cffffffffMéditation de mana\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Permet à 50% de votre régénération de mana due à l'Esprit de se poursuivre pendant le combat.|r", "spellmanameditation", 115, -520)
CreateSpellButton("buttonSpellManaTea", "Interface/icons/monk_ability_cherrymanatea", "|cffffffffThé de mana\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Rend 4% de votre maximum de mana par cumul de thé de mana actif.\nLe thé de mana doit être canalisé, et dure 0.5 s par cumul.\nAnnuler la canalisation n’annule pas les cumuls.|r", "spellmanatea", 225, -520)
CreateSpellButton("buttonSpellTeachingsMonastery", "Interface/icons/passive_monk_teachingsofmonastery", "|cffffffffEnseignements du monastère\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100La voie du tisse-brume n’a plus de secrets pour vous, ce qui amplifie quatre de vos techniques.|r", "spellteachingsmonastery", 335, -520)
CreateSpellButton("buttonSpellMasteryGiftSerpent", "Interface/icons/tradeskill_inscription_jadeserpent", "|cffffffffMaîtrise : Don du serpent\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Lorsque vous prodiguez des soins, vous avez 10% de chances d’invoquer une Sphère de soins près d’un allié blessé pendant 30 s.\nLes alliés qui traversent la sphère reçoivent 10103 points de vie.|r", "spellmasterygiftserpent", 442, -520)

CreateSpellButton("buttonSpellAdaptation", "Interface/icons/Ability_Rogue_CheatDeath", "|cffffffffAdaptation\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Quand vous êtes désarmé, vos chances d’esquiver sont augmentées de 25% pendant 5 seconds.|r", "spelladaptation", 645, -85)
CreateSpellButton("buttonSpellChiBarrage", "Interface/icons/ability_monk_forcesphere", "|cffffffffBarrage de chi\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Déchaîne contre l’ennemi un barrage de chi qui inflige 1165 à 3436 points de dégâts de\nNature aux ennemis se trouvant à moins de 3 mètres de l’impact.|r", "spellchibarrage", 750, -85)
CreateSpellButton("buttonSpellMonksLeap", "Interface/icons/ability_monk_dpsstance", "|cffffffffBond du moine\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Bondit pour attaquer la cible ennemie.|r", "spellmonksleap", 860, -85)
CreateSpellButton("buttonSpellNimbleBrew", "Interface/icons/spell_monk_nimblebrew", "|cffffffffBreuvage de vivacité\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous débarrasse de tous les effets d’immobilisation,\nd’étourdissement, de peur et d'horreur et réduit la durée de futurs effets de ce type sur vous de 60% pendant 6 seconds.|r", "spellnimblebrew", 970, -85)
CreateSpellButton("buttonSpellPunch", "Interface/icons/ability_monk_jab", "|cffffffffCoup de poing\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous frappez la cible d’un coup direct et lui infligez 155 à 416 points de dégâts.|r", "spellpunch", 1077, -85)
CreateSpellButton("buttonSpellBlackoutKick", "Interface/icons/ability_monk_roundhousekick", "|cffffffffFrappe du voile noir\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Assène un coup de pied chargé d'énergie sha infligeant 246 à 511 points de dégâts physiques à une cible ennemie.|r", "spellblackoutkick", 1023, -140)
CreateSpellButton("buttonSpellRisingSunKick", "Interface/icons/ability_monk_risingsunkick", "|cffffffffCoup de pied du soleil levant\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous lancez un coup de pied vers le haut, ce qui inflige 1440 à 2917 points de dégâts à la cible et lui applique Blessures mortelles.|r", "spellrisingsunkick", 915, -140)
CreateSpellButton("buttonSpellExpelHarm", "Interface/icons/ability_monk_expelharm", "|cffffffffExtraction du mal\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous rend instantanément de 297 à 609 points de vie et inflige instantanément\ndes dégâts de Nature égaux à 50% de ce montant à un ennemi se trouvant à moins de 10 mètres.|r", "spellexpelharm", 805, -140)
CreateSpellButton("buttonSpellCracklingJadeThunderstorm", "Interface/icons/ability_monk_cracklingjadelightning", "|cffffffffOrage de jade crépitant\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Canalise un orage de jade pendant 5 seconds, envoyant des éclairs sur les ennemis toutes les 0.2 s.|r", "spellcracklingjadethunderstorm", 697, -140)
CreateSpellButton("buttonSpellDisable", "Interface/icons/ability_shockwave", "|cffffffffHandicap\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous entravez la cible, ce qui réduit sa vitesse de déplacement de 50%.\nLa durée de Handicap est réinitialisée si la cible reste à moins de 10 mètres du moine.\n\nL’utilisation de Handicap sur une cible déjà ralentie l’immobilise pendant 8 seconds.|r", "spelldisable", 645, -195)
CreateSpellButton("buttonSpellRingPeace", "Interface/icons/spell_monk_ringofpeace", "|cffffffffAnneau de paix\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Forme un sanctuaire autour d’une cible alliée, réduisant au silence et désarmant instantanément tous les ennemis pendant 4 seconds.\nDe plus, les ennemis qui attaquent ou lancent des sorts néfastes sur des alliés dans l’anneau de paix sont désarmés et réduits au silence pendant 4 seconds de plus.\nAnneau de paix dure 8 seconds.|r", "spellringpeace", 750, -195)
CreateSpellButton("buttonSpellLifeCocoon", "Interface/icons/ability_monk_chicocoon", "|cffffffffCocon de vie\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Enveloppe la cible dans un cocon d’énergie chi, qui absorbe 81742 des dégâts\net augmente tous les soins périodiques reçus de 50%.\nDure 12 seconds.\nUtilisable quand vous êtes étourdi.|r", "spelllifecocoon", 860, -195)
CreateSpellButton("buttonSpellSpinningCraneKick", "Interface/icons/ability_monk_cranekick_new", "|cffffffffCoup tournoyant de la grue\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Tournoie rapidement, inflige des dégâts physiques autour de soi et\ndevient insensible aux enracinements et ralentissements pendant 5 seconds.|r", "spellspinningcranekick", 970, -195)
CreateSpellButton("buttonSpellWhiteTigerLegacy", "Interface/icons/ability_monk_prideofthetiger", "|cffffffffHéritage du tigre blanc\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous honorez l’héritage du Tigre blanc, ce qui augmente vos chances de coup critique de 5%.\n\nSi la cible est dans votre groupe ou raid, tous les membres du groupe ou raid sont affectés.|r", "spellwhitetigerlegacy", 1077, -195)
CreateSpellButton("buttonSpellSpearHandStrike", "Interface/icons/ability_monk_spearhand", "|cffffffffPique de main\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous frappez la cible d’un coup direct à la gorge,\nce qui interrompt son incantation de sort et l’empêche de lancer un sort de la même école pendant 4 seconds.\n\nSi l’ennemi vous fait face, il est aussi réduit au silence pendant 2 seconds.|r", "spellspearhandstrike", 697, -248)
CreateSpellButton("buttonSpellDiffuseMagic", "Interface/icons/spell_monk_diffusemagic", "|cffffffffDiffusion de la magie\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Réduit tous les dégâts des sorts subis de 90% et\nsupprime les effets magiques qui vous affectent en les renvoyant\nsi possible à leur auteur s’il se trouve dans un rayon de 40 mètres.\nDure 6 seconds.|r", "spelldiffusemagic", 805, -248)
CreateSpellButton("buttonSpellFlyingSerpentKick", "Interface/icons/ability_monk_flyingdragonkick", "|cffffffffCoup du serpent volant\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous effectuez un Coup du serpent volant sur une courte distance.|r", "spellflyingserpentkick", 915, -248)
CreateSpellButton("buttonSpellZenMeditation", "Interface/icons/ability_monk_zenmeditation", "|cffffffffMéditation zen\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Réduit tous les dégâts subis de 90% et redirige vers vous un maximum de 5 sorts de dégâts\nlancés contre des membres de votre groupe ou raid se trouvant à moins de 30 mètres.\nDure 8 seconds.\n\nSi vous êtes victime d’une attaque de mêlée,\nvotre méditation sera rompue et l'effet annulé.", "spellzenmeditation", 1023, -248)
CreateSpellButton("buttonSpellSoothingMist", "Interface/icons/ability_monk_soothingmists", "|cffffffffBrume apaisante\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Rend à la cible 25752 points de vie en 8 seconds.", "spellsoothingmist", 643, -302)
CreateSpellButton("buttonSpellEnvelopingMist", "Interface/icons/spell_monk_envelopingmist", "|cffffffffBrume enveloppante\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Rend 44898 points de vie à la cible en 6 seconds et\naugmente les soins de Brume apaisante reçus par la cible de 30%.", "spellenvelopingmist", 750, -302)
CreateSpellButton("buttonSpellRenewingMist", "Interface/icons/ability_monk_renewingmists", "|cffffffffBrume de rénovation\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100La cible est enveloppée de brumes qui la soignent.\nLes brumes rendent 2739 points de vie toutes les 2 s pendant 18 seconds.", "spellrenewingmist", 860, -302)
CreateSpellButton("buttonSpellSurgingMist", "Interface/icons/ability_monk_surgingmist", "|cffffffffDéferlante de brume\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Canalise et rend 17540 points de vie à la cible.", "spellsurgingmist", 970, -302)
CreateSpellButton("buttonSpellChiWave", "Interface/icons/ability_monk_chiwave", "|cffffffffOnde de chi\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous émettez une Onde de chi qui se propage à travers vos alliés comme vos ennemis\net qui inflige 672 points de dégâts de Nature ou rend 4739 points de vie.\nL’onde rebondit jusqu’à 7 fois vers les cibles proches à moins de 25 mètres.", "spellchiwave", 1077, -302)
CreateSpellButton("buttonSpellSpinningFireBlossom", "Interface/icons/ability_monk_explodingjadeblossom", "|cffffffffFloraison de feu tournoyante\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Inflige de 153 à 310 points de dégâts de Feu\nà la première cible ennemie devant vous et à moins de 50 mètres.", "spellspinningfireblossom", 697, -358)
CreateSpellButton("buttonSpellUplift", "Interface/icons/ability_monk_uplift", "|cffffffffElévation\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Rend 7907 points de vie à toutes les cibles sur lesquelles votre Brume de rénovation est active.", "spelluplift", 805, -358)
CreateSpellButton("buttonSpellSummonJadeSerpentStatue", "Interface/icons/ability_monk_summonserpentstatue", "|cffffffffInvocation d’une statue du Serpent de jade\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Invoque une statue du Serpent de jade à l'emplacement ciblé.\nDure 15 min.\nUne seule statue peut être invoquée à la fois.", "spellsummonjadeserpentstatue", 915, -358)
CreateSpellButton("buttonSpellTouchKarma", "Interface/icons/ability_monk_touchofkarma", "|cffffffffToucher du karma\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Tous les dégâts contre vous sont redirigés à la place vers la cible ennemie sous forme de dégâts de Nature en 6 seconds.\nLe montant redirigé ne peut pas dépasser votre total de points de vie. Dure 10 seconds.", "spelltouchkarma", 1023, -358)
CreateSpellButton("buttonSpellTouchDeath", "Interface/icons/ability_monk_touchofdeath", "|cffffffffToucher mortel\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous exploitez le point faible de la cible ennemie, ce qui la tue instantanément.", "spelltouchdeath", 643, -410)
CreateSpellButton("buttonSpellTranscendance", "Interface/icons/monk_ability_transcendence", "|cffffffffTranscendance\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffffffRequiert|r |cffff0000Transcendance : Transfert|r\n|cffffd100Vous séparez votre corps et votre esprit, et vous abandonnez ce dernier pendant 15min.", "spelltranscendance", 750, -410)
CreateSpellButton("buttonSpellTranscendanceBack", "Interface/icons/spell_shaman_spectraltransformation", "|cffffffffTranscendance : Transfert\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffffffRequiert|r |cffff0000Transcendance|r\n|cffffd100Votre corps et votre esprit échangent de place.", "spelltranscendanceback", 860, -410)
CreateSpellButton("buttonSpellHealingSphere", "Interface/icons/ability_monk_healthsphere", "|cffffffffSphère de soins\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous façonnez une sphère de soins à partir de brumes guérisseuses à l’emplacement ciblé pendant 60 seconds.\nSi des alliés la traversent, ils l’absorbent et regagnent 1355 à 5122 points de vie.", "spellhealingsphere", 970, -410)
CreateSpellButton("buttonSpellResuscitate", "Interface/icons/ability_druid_lunarguidance", "|cffffffffRanimer\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Renvoie l'esprit du personnage ciblé dans son corps et le rappelle à la vie avec 65% de son maximum de points de vie et de mana.\nCe sort ne peut être lancé lorsque vous êtes en combat.", "spellresuscitate", 1077, -410)
CreateSpellButton("buttonSpellParalysis", "Interface/icons/ability_monk_paralysis", "|cffffffffParalysie\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Vous faites se tétaniser les muscles de la cible, ce qui la stupéfie pendant 40 seconds.\nSi l’attaque est portée de derrière la cible, la durée augmente de 50%.\nSeule une cible à la fois peut être victime de Paralysie.\n\nTout dégât reçu annule l’effet.", "spellparalysis", 697, -465)
CreateSpellButton("buttonSpellZenPilgrimage", "Interface/icons/spell_monk_zenpilgrimage", "|cffffffffPèlerinage zen\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Votre esprit abandonne votre corps et voyage jusqu'au continent de Azeroth Universe.", "spellzenpilgrimage", 805, -465)
CreateSpellButton("buttonSpellFistsFury", "Interface/icons/monk_ability_fistoffury", "|cffffffffPoings de fureur\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Donne de violents coups de poing à la cible ennemie,\nlui infligeant des dégâts physiques toutes les 1 pendant 4 seconds.", "spellfistsfury", 915, -465)
CreateSpellButton("buttonSpellEnergizingElixir", "Interface/icons/ability_monk_energizingwine", "|cffffffffInfusion énergisante\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Régénère 60 points d’énergie en 6 seconds.\n\nNe peut être utilisé qu’en combat.", "spellenergizingelixir", 1023, -465)
CreateSpellButton("buttonSpellTigersLust", "Interface/icons/ability_monk_tigerslust", "|cffffffffSoif du tigre\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Augmente la vitesse de déplacement d’une cible alliée de 70% pendant 6 sec et annule les effets de ralentissement et d’immobilisation subis.", "spelltigerslust", 643, -520)
CreateSpellButton("buttonSpellInvokeXuenWhiteTiger", "Interface/icons/ability_monk_summontigerstatue", "|cffffffffInvocation de Xuen, le Tigre blanc\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Invoque Xuen, le Tigre blanc auprès de vous.", "spellinvokexuenwhitetiger", 750, -520)
CreateSpellButton("buttonSpellTigereyeBrew", "Interface/icons/ability_monk_tigereyebrandy", "|cffffffffInfusion œil-du-tigre\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Augmente les dégâts infligés et les soins prodigués de 6% par charge d’Infusion œil-du-tigre active, en consommant jusqu’à 10 charges.\nDure 15 seconds.", "spelltigereyebrew", 860, -520)
CreateSpellButton("buttonSpellCombatConditioning", "Interface/icons/spell_misc_hellifrepvpcombatmorale", "|cffffffffConditionnement au combat\n|cffffffffTalent |cff80fbfcMarche-vent|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Votre Frappe du voile noir inflige 20% de points de dégâts supplémentaires en 4 seconds si vous vous trouvez derrière la cible,\nou elle vous rend un montant de points de vie égal à 20% des dégâts infligés si vous êtes devant la cible.", "spellcombatconditioning", 970, -520)
CreateSpellButton("buttonSpellRevival", "Interface/icons/spell_shaman_blessingofeternals", "|cffffffffRegain\n|cffffffffTalent |cff70f37dTisse-brume|r\n|cffffffffRequiert|r |cff00ff96Moine|r\n|cffffd100Rend instantanément 1355 à 5122 points de vie à tous les membres du groupe ou du raid\nse trouvant à moins de 100 mètres et les purifie de tout effet néfaste de magie, de poison, ou de maladie.", "spellrevival", 1077, -520)



local resetButtonClicked = false

local buttonReset = CreateFrame("Button", "buttonReset", frameTalentMonk, "UIPanelButtonTemplate")
buttonReset:SetSize(85, 25)
buttonReset:SetPoint("BOTTOMRIGHT", buttonTalentMonkClose, "BOTTOMLEFT", -95, 5)
buttonReset:SetText("Réinitialiser")

local function ResetTalents()
    AIO.Handle("TalentMonkspell", "ResetTalents")
    resetButtonClicked = true
end

buttonReset:SetScript("OnClick", ResetTalents)

local buttonReload = CreateFrame("Button", "buttonReload", frameTalentMonk, "UIPanelButtonTemplate")
buttonReload:SetSize(85, 25)
buttonReload:SetPoint("BOTTOMRIGHT", buttonTalentMonkClose, "BOTTOMLEFT", -5, 5)
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
        frameTalentMonk:Hide()
        buttonReload:Hide()
        PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
    else
        frameTalentMonk:Show()
        buttonReload:Show()
        PlaySoundFile(OPEN_TALENT_WINDOW_SOUND)
    end

    talentsWindowOpen = not talentsWindowOpen
end

local playerClass = select(2, UnitClass("player"))
if playerClass == "MONK" then
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
        GameTooltip:SetText("|cffffffffTalents|r |cff00ff96(Moine)|r\n\nL'éventail des talents disponibles\npour améliorer et spécialiser\nvotre personnage.")
        GameTooltip:Show()
    end)

    buttonOuvrirTalents:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    buttonOuvrirTalents:SetScript("OnClick", OuvrirFermerInterfaceTalents)
    TalentMicroButton:Hide()
end

MonkHandlers.UpdateTalentCount = function(player, talentsAppris)
    if fontTalentMonkFrameText then
        fontTalentMonkFrameText:SetText(talentsAppris .. " / " .. MAX_TALENTS)
    end
end

MonkHandlers.UpdateTalentPointsUsed = function(player, pointsUsed, pointsBeforeReset)
    print("|cff00ffffVous avez utilisés " .. pointsBeforeReset .. " points avant la réinitialisation des talents|r")
end