local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local MageHandlers = AIO.AddHandlers("TalentMagespell", {})

function MageHandlers.ShowTalentMage(player)
    frameTalentMage:Show()
end

local MAX_TALENTS = 43

local OPEN_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_final_trait_unlocked.ogg"
local CLOSE_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_trait_refund_end.ogg"
local SPELL_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_80_azeritearmor_rotationends_02.ogg"

local frameTalentMage = CreateFrame("Frame", "frameTalentMage", UIParent)
frameTalentMage:SetSize(1200, 650)
frameTalentMage:SetMovable(true)
frameTalentMage:EnableMouse(true)
frameTalentMage:RegisterForDrag("LeftButton")
frameTalentMage:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
frameTalentMage:SetBackdrop(
{
    bgFile = "interface/TalentFrame/Template/Class/Mage/talentsclassbackgroundmage2",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedmage",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

local mageIcon = frameTalentMage:CreateTexture("MageIcon", "OVERLAY")
mageIcon:SetTexture("Interface\\TalentFrame\\Template\\Class\\Mage\\IconeMage.blp")
mageIcon:SetSize(60, 60)
mageIcon:SetPoint("TOPLEFT", frameTalentMage, "TOPLEFT", -10, 10)


local textureone = frameTalentMage:CreateTexture("TemplateTalentFrame", "OVERLAY")
textureone:SetTexture("Interface\\TalentFrame\\Template\\Class\\Mage\\TalentFrameTemplate.blp")
textureone:SetSize(928, 928)
textureone:SetPoint("TOPLEFT", frameTalentMage, "TOPLEFT", -170, 140)

frameTalentMage:SetFrameLevel(100)

local texturetwo = frameTalentMage:CreateTexture("TemplateTalentFrame", "OVERLAY")
texturetwo:SetTexture("Interface\\TalentFrame\\Template\\Class\\Mage\\TalentFrameTemplateOriginal.blp")
texturetwo:SetSize(928, 928)
texturetwo:SetPoint("TOPRIGHT", frameTalentMage, "TOPRIGHT", 170, 140)

frameTalentMage:SetFrameLevel(100)

frameTalentMage:SetScript("OnDragStart", frameTalentMage.StartMoving)
frameTalentMage:SetScript("OnHide", frameTalentMage.StopMovingOrSizing)
frameTalentMage:SetScript("OnDragStop", frameTalentMage.StopMovingOrSizing)
frameTalentMage:Hide()

frameTalentMage:SetBackdropBorderColor(0.5, 0.7, 1)


local buttonTalentMageClose = CreateFrame("Button", "buttonTalentMageClose", frameTalentMage, "UIPanelCloseButton")
buttonTalentMageClose:SetPoint("TOPRIGHT", -12, -12)
buttonTalentMageClose:EnableMouse(true)
buttonTalentMageClose:SetSize(32, 32)

local function CloseTalentWindow()
    frameTalentMage:Hide()
    PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
end

buttonTalentMageClose:SetScript("OnClick", CloseTalentWindow)

local frameTalentMageTitleBar = CreateFrame("Frame", "frameTalentMageTitleBar", frameTalentMage, nil)
frameTalentMageTitleBar:SetSize(135, 25)
frameTalentMageTitleBar:SetBackdrop(
{
    bgFile = "interface/corrupteditems/corruptedtooltipbackground",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedmage",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameTalentMageTitleBar:SetPoint("TOP", 0, 20)

local fontTalentMageTitleText = frameTalentMageTitleBar:CreateFontString("fontTalentMageTitleText")
fontTalentMageTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontTalentMageTitleText:SetSize(190, 5)
fontTalentMageTitleText:SetPoint("CENTER", 0, 0)
fontTalentMageTitleText:SetText("|cffFFC125Talents|r")

local fontTalentMageFrameText = frameTalentMageTitleBar:CreateFontString("fontTalentMageFrameText")
fontTalentMageFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentMageFrameText:SetSize(200, 5)
fontTalentMageFrameText:SetPoint("TOPLEFT", frameTalentMageTitleBar, "BOTTOMLEFT", -30, -35)
fontTalentMageFrameText:SetText("|cffFFC125Mage|r")

local fontTalentMageFrameText = frameTalentMageTitleBar:CreateFontString("fontTalentMageFrameText")
fontTalentMageFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentMageFrameText:SetSize(200, 5)
fontTalentMageFrameText:SetPoint("TOPLEFT", frameTalentMageTitleBar, "BOTTOMLEFT", -30, -60)
fontTalentMageFrameText:SetText("0 / " .. MAX_TALENTS)



local function CreateSpellButton(name, texturePath, tooltipText, talentHandler, positionX, positionY)
    local buttonClicked = false
    local talentLearned = false

    local button = CreateFrame("Button", name, frameTalentMage, nil)
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
                AIO.Handle("TalentMagespell", talentHandler, 1)
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






CreateSpellButton("buttonSpellArcaneSubtlety", "Interface/icons/spell_holy_dispelmagic", "|cffffffffSubtilité des arcanes|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit de 30% les chances que vos sorts bénéfiques soient dissipés et réduit de 40% la menace générée par vos sorts des Arcanes.|r", "spellarcanesubtlety", 100, -80)
CreateSpellButton("buttonSpellArcaneFocus", "Interface/icons/spell_holy_devotion", "|cffffffffFocalisation des arcanes|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente les chances de toucher et réduit le coût en mana de vos sorts des Arcanes de 3%.|r", "spellarcanefocus", 205, -75)
CreateSpellButton("buttonSpellArcaneStability", "Interface/icons/spell_nature_starfall", "|cffffffffStabilité arcanique|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit de 100% l'interruption causée par les attaques infligeant des dégâts pendant que vous incantez Projectiles des arcanes et Déflagration des arcanes.|r", "spellarcanestability", 315, -75)
CreateSpellButton("buttonSpellArcaneFortitude", "Interface/icons/spell_arcane_arcaneresilience", "|cffffffffRobustesse des arcanes|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente votre Armure d'un montant égal à 150% de votre Intelligence.|r", "spellarcanefortitude", 418, -80)
CreateSpellButton("buttonSpellMagicAbsorption", "Interface/icons/spell_nature_astralrecalgroup", "|cffffffffAbsorption de magie|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente toutes les résistances d'1 par niveau.\nTous les sorts auxquels vous résistez entièrement restaurent 2% de votre total de mana.\nTemps de recharge d'1 sec.|r", "spellmagicabsorption", 150, -130)
CreateSpellButton("buttonSpellArcaneConcentration", "Interface/icons/spell_shadow_manaburn", "|cffffffffConcentration des arcanes|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Vous confère 10% de chances d'entrer dans un état d'Idées claires après avoir infligé des dégâts avec un sort à la cible.\nCet état réduit le coût en mana de votre prochain sort de 100%.|r", "spellarcaneconcentration", 260, -130)
CreateSpellButton("buttonSpellMagicAttunement", "Interface/icons/spell_nature_abolishmagic", "|cffffffffHarmonisation de la magie|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 6 mètres la portée de vos sorts des Arcanes et de 50% les effets de vos sorts Amplification de la magie et Atténuation de la magie.|r", "spellmagicattunement", 370, -130)
CreateSpellButton("buttonSpellImpact", "Interface/icons/spell_nature_wispsplode", "|cffffffffImpact des sorts|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 6% supplémentaires les dégâts de vos sorts Explosion des arcanes, Déflagration des arcanes, Vague explosive, Trait de feu, Brûlure, Boule de feu, Javelot de glace et Cône de froid.|r", "spellspellimpact", 475, -133)
CreateSpellButton("buttonSpellFocusMagic", "Interface/icons/ability_mage_studentofthemind", "|cffffffffEtudiant de la raison|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente votre total d'Esprit de 10%.|r", "spellstudentofthemind", 96, -185)
CreateSpellButton("buttonSpellGrimReach", "Interface/icons/spell_arcane_studentofmagic", "|cffffffffFocalisation de la magie|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 3% les chances de coup critique de la cible avec les sorts.\nQuand la cible réussit un coup critique, les chances de coup critique avec les sorts du lanceur sont augmentées de 3% pendant 10 seconds.\nNe peut être lancé sur soi-même.|r", "spellfocusmagic", 205, -185)
CreateSpellButton("buttonSpellArcaneShielding", "Interface/icons/spell_shadow_detectlesserinvisibility", "|cffffffffSauvegarde des arcanes|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit de 33% le mana perdu par point de dégâts reçu lorsque Bouclier de mana est actif et augmente de 50% les résistances conférées par Armure du mage.|r", "spellarcaneshielding", 315, -185)
CreateSpellButton("buttonSpellImprovedCounterspell", "Interface/icons/spell_frost_iceshock", "|cffffffffContresort amélioré|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Votre Contresort réduit également la cible au silence pendant 4 seconds.|r", "spellimprovedcounterspell", 422, -185)
CreateSpellButton("buttonSpellArcaneMeditation", "Interface/icons/spell_shadow_siphonmana", "|cffffffffMéditation des arcanes|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Vous confère 50% de votre vitesse de récupération du mana normale pendant l'incantation.|r", "spellarcanemeditation", 527, -190)
CreateSpellButton("buttonSpellTormenttheWeak", "Interface/icons/ability_mage_tormentoftheweak", "|cffffffffTourmenter les faibles|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Vos techniques Eclair de givre, Boule de feu, Eclair de givrefeu, Explosion pyrotechnique, Projectiles des arcanes,\nDéflagration des arcanes et Barrage des arcanes infligent 12% de dégâts supplémentaires aux cibles piégées ou ralenties.|r", "spelltormentheweak", 43, -240)
CreateSpellButton("buttonSpellImprovedBlink", "Interface/icons/spell_arcane_blink", "|cffffffffTransfert amélioré|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit le coût en mana de Transfert de 50% et pendant 4 seconds après l'avoir lancé, la probabilité que vous soyez touché par tous les sorts et attaques est réduite de 30%.|r", "spellimprovedblink", 150, -240)
CreateSpellButton("buttonSpellPresenceofMind", "Interface/icons/spell_nature_enchantarmor", "|cffffffffPrésence spirituelle|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Lorsque cette technique est activée, votre prochain sort de mage dont le temps d'incantation est inférieur à 10 sec.\ndevient un sort instantané.|r", "spellpresenceofmind", 368, -240)
CreateSpellButton("buttonSpellArcaneMind", "Interface/icons/spell_shadow_charm", "|cffffffffEsprit des arcanes|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente votre total d'Intelligence de 15%.|r", "spellarcanemind", 478, -240)
CreateSpellButton("buttonSpellPrismaticCloak", "Interface/icons/spell_arcane_prismaticcloak", "|cffffffffCape prismatique|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit tous les dégâts subis de 6% et réduit le temps de disparition de votre sort Invisibilité de 3 sec.|r", "spellprismaticcloak", 98, -293)
CreateSpellButton("buttonSpellArcaneInstability", "Interface/icons/spell_shadow_teleport", "|cffffffffInstabilité des arcanes|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 3% les dégâts infligés par vos sorts et vos chances de coup critique.|r", "spellarcaneinstability", 205, -293)
CreateSpellButton("buttonSpellArcanePotency", "Interface/icons/spell_arcane_arcanepotency", "|cffffffffToute-puissance des arcanes|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 30% les chances de coup critique de tous les sorts infligeant des dégâts lancés sous l'effet d'Idées claires ou Présence spirituelle.|r", "spellarcanepotency", 315, -293)
CreateSpellButton("buttonSpellArcaneEmpowerment", "Interface/icons/spell_nature_starfall", "|cffffffffRenforcement arcanique|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente les dégâts de votre sort Projectiles des arcanes d'un montant égal à 45% de votre puissance des sorts et les dégâts de Déflagration des arcanes de 9% de votre puissance des sorts.\nDe plus, augmente les dégâts de tous les membres du groupe et du raid se trouvant à moins de 100 mètres de 3%.|r", "spellarcaneempowerment", 422, -293)
CreateSpellButton("buttonSpellArcanePower", "Interface/icons/spell_nature_lightning", "|cffffffffPouvoir des arcanes|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Lorsqu'il est activé, vos sorts infligent 20% de points de dégâts supplémentaires et ils vous coûtent 20% de points de mana supplémentaires.\nCet effet dure 15 sec.|r", "spellarcanepower", 527, -295)
CreateSpellButton("buttonSpellIncantersAbsorption", "Interface/icons/ability_mage_incantersabsorbtion", "|cffffffffAbsorption de l'incantateur|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Lorsque votre Bouclier de mana, Gardien de givre, Gardien de feu ou Barrière de glace absorbe des dégâts, les dégâts infligés par vos sorts sont augmentés de 15% du montant absorbé pendant 10 seconds.|r", "spellincantersabsorption", 43, -350)
CreateSpellButton("buttonSpellArcaneFlows", "Interface/icons/ability_mage_potentspirit", "|cffffffffFlux arcaniques|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit le temps de recharge de vos sorts Présence spirituelle, Pouvoir des arcanes et Invisibilité de 30% et le temps de recharge de votre sort Evocation de 2 min.|r", "spellarcaneflows", 150, -350)
CreateSpellButton("buttonSpellMindMastery", "Interface/icons/spell_arcane_mindmastery", "|cffffffffMaîtrise mentale|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente la puissance des sorts d'un montant égal à 15% de votre Intelligence totale.|r", "spellmindmastery", 260, -350)
CreateSpellButton("buttonSpellSlow", "Interface/icons/spell_nature_slow", "|cffffffffLenteur|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit la vitesse de déplacement de la cible de 60%, augmente le temps entre les attaques à distance de 60% et augmente le temps d'incantation de 30%.\nDure 15 seconds.\nLenteur ne peut affecter qu'une seule cible à la fois.|r", "spellslow", 368, -350)
CreateSpellButton("buttonSpellMissileBarrage", "Interface/icons/ability_mage_missilebarrage", "|cffffffffBarrage de projectiles|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Confère à votre Déflagration des arcanes 40% de chances et à vos sorts Barrage des arcanes, Boule de feu, Eclair de givre\net Eclair de givrefeu 20% de chances de réduire la durée de canalisation du prochain sort Projectiles des arcanes de 2.5 sec.\net réduit le coût en mana de 100%.\nDes projectiles sont tirés toutes les 0,5 sec.|r", "spellmissilebarrage", 478, -350)


CreateSpellButton("buttonSpellNetherwindPresence", "Interface/icons/ability_mage_netherwindpresence", "|cffffffffPrésence de vent du Néant|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 6% votre hâte des sorts.|r", "spellnetherwindpresence", 98, -405)
CreateSpellButton("buttonSpellSpellPower", "Interface/icons/spell_arcane_arcanetorrent", "|cffffffffPuissance des sorts|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente les points de dégâts supplémentaires infligés par les coups critiques de tous vos sorts de 50%.|r", "spellspellpower", 205, -405)
CreateSpellButton("buttonSpellArcaneBarrage", "Interface/icons/ability_mage_arcanebarrage", "|cffffffffBarrage des arcanes|r\n|cffffffffTalent|r |cff7755fdArcanes|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Lance plusieurs projectiles sur la cible ennemie et lui inflige 401 à 485 points de dégâts des Arcanes.|r", "spellarcanebarrage", 315, -405)
CreateSpellButton("buttonSpellImprovedFireBlast", "Interface/icons/spell_fire_fireball", "|cffffffffTrait de feu amélioré|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit le temps de recharge de votre sort Trait de feu de 2 secondes.|r", "spellimprovedfireblast", 422, -405)
CreateSpellButton("buttonSpellIncineration", "Interface/icons/spell_fire_flameshock", "|cffffffffIncinération|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 6% les chances d'infliger un coup critique avec vos sorts Trait de feu, Brûlure, Déflagration des arcanes et Cône de froid.|r", "spellincineration", 43, -458)
CreateSpellButton("buttonSpellImprovedFireball", "Interface/icons/spell_fire_flamebolt", "|cffffffffBoule de feu améliorée|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit le temps d'incantation de votre sort Boule de feu de 0.5 secondes.|r", "spellimprovedfireball", 150, -458)
CreateSpellButton("buttonSpellIgnite", "Interface/icons/spell_fire_incinerate", "|cffffffffEnflammer|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Les coups critiques causés par vos sorts de Feu enflamment la cible, ce qui lui inflige un montant de dégâts supplémentaire égal à 40% des dégâts de votre sort en 4 seconds.|r", "spellignite", 260, -458)
CreateSpellButton("buttonSpellBurningDetermination", "Interface/icons/spell_fire_totemofwrath", "|cffffffffDétermination brûlante|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Quand vous êtes interrompu ou réduit au silence, vous avez 100% de chances de devenir insensible au prochain mécanisme d'interruption ou de silence.\nDure 20 seconds.|r", "spellburningdetermination", 368, -458)
CreateSpellButton("buttonSpellWorldinFlames", "Interface/icons/ability_mage_worldinflames", "|cffffffffMonde en flammes|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 6% vos chances de réaliser un coup critique avec vos sorts Choc de flammes, Explosion pyrotechnique, Vague explosive, Souffle du dragon, Bombe vivante, Blizzard et Explosion des arcanes.|r", "spellworlinflames", 478, -458)
CreateSpellButton("buttonSpellFlameThrowing", "Interface/icons/spell_fire_flare", "|cffffffffJet de flammes|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente la portée de tous les sorts de Feu excepté Eclair de givrefeu de 6 mètres.|r", "spellflamethrowing", 98, -510)
CreateSpellButton("buttonSpellImpact", "Interface/icons/spell_fire_meteorstorm", "|cffffffffImpact|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Confère 10% de chances à vos sorts de dégâts de permettre à votre prochain Trait de feu d'étourdir la cible pendant 2 seconds.|r", "spellimpact", 205, -510)
CreateSpellButton("buttonSpellPyroblast", "Interface/icons/spell_fire_fireball02", "|cffffffffExplosion pyrotechnique|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Lance un immense rocher enflammé qui inflige 163 à 215 points de dégâts de Feu et 60 à 64 points de dégâts de Feu supplémentaires en 12 seconds.|r", "spellpyroblast", 315, -510)
CreateSpellButton("buttonSpellBurningSoul", "Interface/icons/spell_fire_fire", "|cffffffffAme ardente|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit l'interruption causée par les attaques infligeant des dégâts pendant que vous incantez des sorts de Feu de 70% et réduit la menace générée par vos sorts de Feu de 20%.|r", "spellburningsoul", 422, -510)


CreateSpellButton("buttonSpellImprovedScorch", "Interface/icons/spell_fire_soulburn", "|cffffffffBrûlure améliorée|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente vos chances de coup critique avec Brûlure, Boule de feu et Eclair de givrefeu de 3% supplémentaires\net vos sorts de Brûlure infligeant des dégâts ont 100% de chances de rendre votre cible vulnérable aux dégâts de sorts.\nCette vulnérabilité augmente les chances de coup critique avec les sorts contre cette cible de 5% et dure 30 seconds.|r", "spellimprovedscorch", 663, -75)
CreateSpellButton("buttonSpellMolteShields", "Interface/icons/spell_fire_firearmor", "|cffffffffBoucliers de la fournaise|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Confère à vos sorts Gardien de feu et Gardien de givre 30% de chances de renvoyer les sorts tant qu'ils sont actifs.\nDe plus, votre Armure de la fournaise a 100% de chances d'affecter les attaques à distance et les sorts.|r", "spellmoltenshields", 770, -75)
CreateSpellButton("buttonSpellMasterofElements", "Interface/icons/spell_fire_masterofelements", "|cffffffffMaître des éléments|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Les coups critiques obtenus avec les sorts vous rendront 30% de leur coût en mana de base.|r", "spellmasterofelements", 880, -75)
CreateSpellButton("buttonSpellPlayingwithFire", "Interface/icons/spell_fire_playingwithfire", "|cffffffffJouer avec le feu|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente tous les dégâts des sorts causés de 3% et tous les dégâts des sorts subis de 3%.|r", "spellplayingwithfire", 990, -75)
CreateSpellButton("buttonSpellCriticalMass", "Interface/icons/spell_nature_wispheal", "|cffffffffMasse critique|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 6% vos chances d'infliger un coup critique avec vos sorts de Feu.|r", "spellcriticalmass", 1100, -75)
CreateSpellButton("buttonSpellBlastWave", "Interface/icons/spell_holy_excorcism_02", "|cffffffffVague explosive|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Une vague de flammes rayonne autour du lanceur et inflige à tous les ennemis pris dans l'explosion 185 à 223 points de dégâts de Feu,\nen plus de les faire tomber à la renverse et de les hébéter pendant 6 seconds.|r", "spellblastwave", 718, -130)
CreateSpellButton("buttonSpellBlazingSpeed", "Interface/icons/spell_fire_burningspeed", "|cffffffffVitesse flamboyante|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Vous confère 10% de chances, lorsque vous êtes touché par une attaque en mêlée ou à distance, de voir votre vitesse de déplacement augmenter de 50% et de dissiper tous les effets affectant le mouvement.\nCet effet dure 8 seconds.|r", "spellblazingspeed", 825, -130)
CreateSpellButton("buttonSpellFirePower", "Interface/icons/spell_fire_immolation", "|cffffffffPuissance du feu|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 10% les dégâts infligés par vos sorts de Feu.|r", "spellfirepower", 935, -130)
CreateSpellButton("buttonSpellPyromaniac", "Interface/icons/spell_fire_burnout", "|cffffffffPyromane|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente les chances de réussir un coup critique de 3% et permet à 50% de votre régénération de mana de se poursuivre pendant les incantations.|r", "spellyromaniac", 1045, -130)
CreateSpellButton("buttonSpellCombustion", "Interface/icons/spell_fire_sealoffire", "|cffffffffCombustion|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Lorsqu'il est activé, ce sort augmente votre bonus aux dégâts des coups critiques avec les sorts de dégâts de Feu de 50%,\net chaque fois que vous touchez avec un sort de ce type vous augmentez vos chances de coup critique avec les sorts de dégâts de Feu de 10%.\nCet effet dure jusqu'à ce que vous ayez infligé 3 coups critiques non périodiques avec des sorts de Feu.|r", "spellcombustion", 663, -184)
CreateSpellButton("buttonSpellMoltenFury", "Interface/icons/spell_fire_moltenblood", "|cffffffffFureur de lave|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente les dégâts de tous les sorts contre les cibles disposant de moins de 35% de leurs points de vie de 12%.|r", "spellmoltenfury", 770, -184)
CreateSpellButton("buttonSpellFieryPayback", "Interface/icons/ability_mage_fierypayback", "|cffffffffRevanche ardente|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Lorsque vous avez moins de 35% de vie, tous les dégâts subis sont réduits de 20%, le temps d'incantation de votre sort Explosion pyrotechnique est réduit de 3.5 sec.\net son temps de recharge est augmenté de 5 sec.\nDe plus, les attaques en mêlée et à distance contre vous ont 10% de chances de faire tomber l'arme en main droite et les armes à distance de l'attaquant.|r", "spellfierypayback", 880, -184)
CreateSpellButton("buttonSpellEmpoweredFire", "Interface/icons/spell_fire_flamebolt", "|cffffffffFeu surpuissant|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente les dégâts de vos sorts Boule de feu, Eclair de givrefeu et Explosion pyrotechnique d'un montant égal à 15% de votre puissance des sorts.\nDe plus, chaque fois que votre talent Enflammer inflige des dégâts, vous avez 100% de chances de récupérer 2% de votre mana de base.|r", "spellempoweredfire", 990, -184)
CreateSpellButton("buttonSpellFirestarter", "Interface/icons/ability_mage_firestarter", "|cffffffffBoute-flammes|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Lorsqu'ils infligent des dégâts, vos sorts Vague explosive et Souffle du dragon ont 100% de chances de rendre l'incantation de votre prochain sort Choc de flammes instantanée et sans coût en mana.\nDure 10 seconds.", "spellfirestarter", 1100, -184)



CreateSpellButton("buttonSpellDragonsBreath", "Interface/icons/inv_misc_head_dragon_01", "|cffffffffSouffle du dragon|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Les cibles qui se trouvent dans une zone en forme de cône en face du lanceur de sorts subissent 420 à 487 points de dégâts de Feu et sont désorientées pendant 5 seconds.\nToute attaque directe qui inflige des dégâts réveille la cible.\nInterrompt l'attaque lors de son utilisation.|r", "spelldragonsbreath", 718, -240)
CreateSpellButton("buttonSpellHotStreak", "Interface/icons/ability_mage_hotstreak", "|cffffffffChaleur continue|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Chaque fois que vous obtenez 2 coups critiques non périodiques de suite avec Boule de feu, Trait de feu, Brûlure, Bombe vivante ou Eclair de givrefeu,\nvous avez 100% de chances que votre prochain sort Explosion pyrotechnique lancé dans les 10 seconds soit instantané.|r", "spellhotstreak", 825, -240)
CreateSpellButton("buttonSpellBurnout", "Interface/icons/ability_mage_burnout", "|cffffffffArdeur épuisante|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 50% votre bonus de dégâts des critiques réussis avec tous les sorts, mais vos critiques non périodiques avec les sorts coûtent 5% du coût du sort en plus.|r", "spellburnout", 935, -240)
CreateSpellButton("buttonSpellLivingBomb", "Interface/icons/ability_mage_livingbomb", "|cffffffffBombe vivante|r\n|cffffffffTalent|r |cffff8000Feu|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100La cible devient une bombe vivante qui inflige 672 à 676 points de dégâts de Feu en 12 seconds.\nAu bout de 12 sec. ou quand le sort est dissipé, la cible explose en infligeant 336 à 337 points de dégâts de Feu à tous les ennemis se trouvant à moins de 10 mètres.", "spelllivingbomb", 1045, -240)
CreateSpellButton("buttonSpellFrostbite", "Interface/icons/spell_frost_frostarmor", "|cffffffffMorsure de givre|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Donne à vos effets d'engourdissement 15% de chances de geler la cible pendant 5 seconds.|r", "spellfrostbite", 663, -293)
CreateSpellButton("buttonSpellImprovedFrostbolt", "Interface/icons/spell_frost_frostbolt02", "|cffffffffEclair de givre amélioré|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit le temps d'incantation de votre sort Eclair de givre de 0.5 sec.|r", "spellimprovedfrostbolt", 770, -293)
CreateSpellButton("buttonSpellIceFloes", "Interface/icons/spell_frost_icefloes", "|cffffffffIceberg|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit de 20% le temps de recharge de vos sorts Nova de givre, Cône de froid, Bloc de glace et Veines glaciales.|r", "spellicefloes", 990, -293)
CreateSpellButton("buttonSpellIceShards", "Interface/icons/spell_frost_iceshard", "|cffffffffEclats de glace|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 100% les points de dégâts supplémentaires infligés par les coups critiques de vos sorts de Givre.|r", "spelliceshards", 1100, -293)
CreateSpellButton("buttonSpellFrostWarding", "Interface/icons/spell_frost_frostward", "|cffffffffProtection contre le Givre|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 50% l'armure et les résistances octroyées par vos sorts Armure de givre et Armure de glace.\nDe plus, donne à vos sorts Gardien de givre et Gardien de feu 30% de chances d'absorber les dégâts des sorts et de rendre un montant de mana égal aux dégâts absorbés.|r", "spellfrostwarding", 718, -348)
CreateSpellButton("buttonSpellPrecision", "Interface/icons/spell_ice_magicdamage", "|cffffffffPrécision|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit le coût en mana et augmente vos chances de toucher avec les sorts de 3%.|r", "spellprecision", 825, -348)
CreateSpellButton("buttonSpellPermafrost", "Interface/icons/spell_frost_wisp", "|cffffffffGel prolongé|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente la durée de vos effets d'engourdissement de 3 secondes, réduit la vitesse de la cible de 10% supplémentaires et réduit les soins qu'elle reçoit de 20%.|r", "spellpermafrost", 935, -348)
CreateSpellButton("buttonSpellPiercingIce", "Interface/icons/spell_frost_frostbolt", "|cffffffffGlace perçante|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente les points de dégâts infligés par vos sorts de Givre de 6%.|r", "spellpiercingice", 1045, -348)
CreateSpellButton("buttonSpellIcyVeins", "Interface/icons/spell_frost_coldhearted", "|cffffffffVeines glaciales|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Accélère vos lancers de sorts en augmentant la vitesse d'incantation des sorts de 20% et réduit de 100% les interruptions causées par les attaques infligeant des dégâts pendant les incantations.\nDure 20 seconds.|r", "spellicyveins", 663, -402)
CreateSpellButton("buttonSpellImprovedBlizzard", "Interface/icons/spell_frost_icestorm", "|cffffffffBlizzard amélioré|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Ajoute un effet d'engourdissement à votre sort Blizzard.\nIl réduit la vitesse de déplacement de la cible de 70%.\nDure 4.5 seconds.|r", "spellimprovedblizzard", 770, -402)
CreateSpellButton("buttonSpellArcticReach", "Interface/icons/spell_shadow_darkritual", "|cffffffffAllonge arctique|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente la portée de vos sorts Eclair de givre, Javelot de glace, Congélation et Blizzard et les rayons d'effet de vos sorts Nova de givre et Cône de froid de 20%.|r", "spellarcticreach", 880, -402)
CreateSpellButton("buttonSpellFrostChanneling", "Interface/icons/spell_frost_stun", "|cffffffffCanalisation du givre|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit de 10% le coût en mana de tous vos sorts et réduit de 10% la menace que génèrent vos sorts de Givre.|r", "spellfrostchanneling", 990, -402)
CreateSpellButton("buttonSpellShatter", "Interface/icons/spell_frost_frostshock", "|cffffffffFracasser|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 50% vos chances d'infliger un coup critique avec tous les sorts lorsque vous attaquez des cibles gelées.|r", "spellshatter", 1100, -402)
CreateSpellButton("buttonSpellColdSnap", "Interface/icons/spell_frost_wizardmark", "|cffffffffMorsure du froid|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Lorsqu'il est activé, ce sort met fin à tous les temps de recharge des sorts de Givre que vous avez lancés récemment.|r", "spellcoldsnap", 718, -456)
CreateSpellButton("buttonSpellImprovedConeofCold", "Interface/icons/spell_frost_glacier", "|cffffffffCône de froid amélioré|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 35% les points de dégâts infligés par votre sort Cône de froid.|r", "spellimprovedconeofcold", 825, -456)
CreateSpellButton("buttonSpellFrozenCore", "Interface/icons/spell_frost_frozencore", "|cffffffffCoeur de gel|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit les dégâts que vous infligent tous les sorts de 6%.|r", "spellfrozencore", 935, -456)
CreateSpellButton("buttonSpellColdasIce", "Interface/icons/ability_mage_coldasice", "|cffffffffFroid comme la glace|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Réduit de 20% le temps de recharge de vos sorts Morsure du froid, Barrière de glace et Invocation d'un élémentaire d'eau.|r", "spellcoldasice", 1045, -456)
CreateSpellButton("buttonSpellWintersChill", "Interface/icons/spell_frost_chillingblast", "|cffffffffFroid hivernal|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente de 3% vos chances de réussir un coup critique avec Eclair de givre\net vos sorts de Givre infligeant des dégâts ont 100% de chances de déclencher l’effet de Froid hivernal,\nqui augmente les chances de critique des sorts de 1% pendant 15 seconds.\nCumulable jusqu’à 5 fois.|r", "spellwinterschill", 663, -510)
CreateSpellButton("buttonSpellShatteredBarrier", "Interface/icons/ability_mage_shattershield", "|cffffffffBarrière brisée|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Confère à votre sort Barrière de glace 100% de chances de geler tous les ennemis se trouvant à moins de 10 mètres pendant 8 seconds quand la barrière est détruite.|r", "spellshatteredbarrier", 770, -510)
CreateSpellButton("buttonSpellIceBarrier", "Interface/icons/spell_ice_lament", "|cffffffffBarrière de glace|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Vous protège instantanément en absorbant 454 points de dégâts.\nDure 1 min.\n Tant que le bouclier tient, l'incantation de sorts n'est pas retardée par les dégâts.|r", "spellicebarrier", 880, -510)
CreateSpellButton("buttonSpellArcticWinds", "Interface/icons/spell_frost_arcticwinds", "|cffffffffVents arctiques|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente tous les dégâts de Givre que vous causez de 5% et réduit la probabilité que les attaques en mêlée et à distance vous touchent de 5%.|r", "spellarcticwinds", 990, -510)
CreateSpellButton("buttonSpellEmpoweredFrostbolt", "Interface/icons/spell_frost_frostbolt02", "|cffffffffEclair de givre surpuissant|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente les dégâts de votre sort Eclair de givre d'un montant égal à 10% de votre puissance des sorts et réduit son temps d'incantation de 0.2 sec.|r", "spellempoweredfrostboltt", 1100, -510)
CreateSpellButton("buttonSpellFingersofFrost", "Interface/icons/ability_mage_wintersgrasp", "|cffffffffDoigts de givre|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Donne à vos effets d'engourdissement 15% de chances de déclencher l’effet Doigts de givre, qui permet à vos 2 prochains sorts d'agir comme si la cible était Gelée.\nDure 15 sec.|r", "spellfingersoffrost", 880, -293)
CreateSpellButton("buttonSpellBrainFreeze", "Interface/icons/ability_mage_brainfreeze", "|cffffffffGel mental|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Vos sorts de Givre infligeant des dégâts et pouvant transir ont 15% de chances de supprimer le temps d'incantation et le coût en mana de votre prochain sort Boule de feu ou Eclair de givrefeu.|r", "spellbrainfreeze", 609, -564)
CreateSpellButton("buttonSpellSummonWaterElemental", "Interface/icons/spell_frost_summonwaterelemental_2", "|cffffffffInvocation d'un élémentaire d'eau|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Invoque un élémentaire d'eau qui se bat pour le lanceur de sorts pendant 1 min.|r", "spellsummonwaterelemental", 716, -564)
CreateSpellButton("buttonSpellEnduringWinter", "Interface/icons/spell_frost_summonwaterelemental_2", "|cffffffffHiver persistant|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente la durée de votre sort Invocation d'un élémentaire d'eau de 15 sec.\net votre sort Eclair de givre a 100% de chances de conférer l'effet de Requinquage à un maximum de 10 membres du groupe ou raid\navec une régénération de mana égale à 1% de leur maximum de mana toutes les 5 secondes pendant 15 sec.\nCet effet ne peut se produire plus d'une fois toutes les 6 sec.|r", "spellenduringwinter", 824, -564)
CreateSpellButton("buttonSpellChilledtotheBone", "Interface/icons/ability_mage_chilledtothebone", "|cffffffffTransi jusqu'aux os|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Augmente les points de dégâts infligés par vos sorts Eclair de givre, Eclair de givrefeu et Javelot de glace de 5% et réduit la vitesse de déplacement de toutes les cibles transies de 10% supplémentaires.|r", "spellchilledtothebone", 934, -564)
CreateSpellButton("buttonSpellDeepFreeze", "Interface/icons/ability_mage_deepfreeze", "|cffffffffCongélation|r\n|cffffffffTalent|r |cff2492ffGivre|r\n|cffffffffRequiert|r |cff40c7ebMage|r\n|cffffd100Etourdit la cible pendant 5 seconds. Utilisable uniquement sur les cibles gelées.\nInflige de 3138 à 3440 points de dégâts aux cibles insensibles de manière permanente aux étourdissements.|r", "spelldeepfreeze", 1045, -564)



local resetButtonClicked = false

local buttonReset = CreateFrame("Button", "buttonReset", frameTalentMage, "UIPanelButtonTemplate")
buttonReset:SetSize(85, 25)
buttonReset:SetPoint("BOTTOMRIGHT", buttonTalentMageClose, "BOTTOMLEFT", -95, 5)
buttonReset:SetText("Réinitialiser")

local function ResetTalents()
    AIO.Handle("TalentMagespell", "ResetTalents")
    resetButtonClicked = true
end

buttonReset:SetScript("OnClick", ResetTalents)

local buttonReload = CreateFrame("Button", "buttonReload", frameTalentMage, "UIPanelButtonTemplate")
buttonReload:SetSize(85, 25)
buttonReload:SetPoint("BOTTOMRIGHT", buttonTalentMageClose, "BOTTOMLEFT", -5, 5)
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
        frameTalentMage:Hide()
        buttonReload:Hide()
        PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
    else
        frameTalentMage:Show()
        buttonReload:Show()
        PlaySoundFile(OPEN_TALENT_WINDOW_SOUND)
    end

    talentsWindowOpen = not talentsWindowOpen
end

local playerClass = select(2, UnitClass("player"))
if playerClass == "MAGE" then
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
        GameTooltip:SetText("|cffffffffTalents|r |cff40c7eb(Mage)|r\n\nL'éventail des talents disponibles\npour améliorer et spécialiser\nvotre personnage.")
        GameTooltip:Show()
    end)

    buttonOuvrirTalents:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    buttonOuvrirTalents:SetScript("OnClick", OuvrirFermerInterfaceTalents)
    TalentMicroButton:Hide()
end

MageHandlers.UpdateTalentCount = function(player, talentsAppris)
    if fontTalentMageFrameText then
        fontTalentMageFrameText:SetText(talentsAppris .. " / " .. MAX_TALENTS)
    end
end

MageHandlers.UpdateTalentPointsUsed = function(player, pointsUsed, pointsBeforeReset)
    print("|cff00ffffVous avez utilisés " .. pointsBeforeReset .. " points avant la réinitialisation des talents|r")
end