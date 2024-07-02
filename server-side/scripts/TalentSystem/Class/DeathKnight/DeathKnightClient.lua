local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local DeathknightHandlers = AIO.AddHandlers("TalentDeathknightspell", {})

function DeathknightHandlers.ShowTalentDeathknight(player)
    frameTalentDeathknight:Show()
end

local MAX_TALENTS = 44

local OPEN_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_final_trait_unlocked.ogg"
local CLOSE_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_trait_refund_end.ogg"
local SPELL_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_80_azeritearmor_rotationends_02.ogg"

local frameTalentDeathknight = CreateFrame("Frame", "frameTalentDeathknight", UIParent)
frameTalentDeathknight:SetSize(1200, 650)
frameTalentDeathknight:SetMovable(true)
frameTalentDeathknight:EnableMouse(true)
frameTalentDeathknight:RegisterForDrag("LeftButton")
frameTalentDeathknight:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
frameTalentDeathknight:SetBackdrop(
{
    bgFile = "interface/TalentFrame/Template/Class/Deathknight/talentsclassbackgrounddeathknight2",
    edgeFile = "interface/tooltips/ui-tooltip-border-corrupteddeathknight",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

local deathknightIcon = frameTalentDeathknight:CreateTexture("DeathknightIcon", "OVERLAY")
deathknightIcon:SetTexture("Interface\\TalentFrame\\Template\\Class\\Deathknight\\IconeDeathknight.blp")
deathknightIcon:SetSize(60, 60)
deathknightIcon:SetPoint("TOPLEFT", frameTalentDeathknight, "TOPLEFT", -10, 10)


local textureone = frameTalentDeathknight:CreateTexture("TemplateTalentFrame", "OVERLAY")
textureone:SetTexture("Interface\\TalentFrame\\Template\\Class\\Deathknight\\TalentFrameTemplate.blp")
textureone:SetSize(928, 928)
textureone:SetPoint("TOPLEFT", frameTalentDeathknight, "TOPLEFT", -170, 140)

frameTalentDeathknight:SetFrameLevel(100)

local texturetwo = frameTalentDeathknight:CreateTexture("TemplateTalentFrame", "OVERLAY")
texturetwo:SetTexture("Interface\\TalentFrame\\Template\\Class\\Deathknight\\TalentFrameTemplateOriginal.blp")
texturetwo:SetSize(928, 928)
texturetwo:SetPoint("TOPRIGHT", frameTalentDeathknight, "TOPRIGHT", 170, 140)

frameTalentDeathknight:SetFrameLevel(100)

frameTalentDeathknight:SetScript("OnDragStart", frameTalentDeathknight.StartMoving)
frameTalentDeathknight:SetScript("OnHide", frameTalentDeathknight.StopMovingOrSizing)
frameTalentDeathknight:SetScript("OnDragStop", frameTalentDeathknight.StopMovingOrSizing)
frameTalentDeathknight:Hide()

frameTalentDeathknight:SetBackdropBorderColor(197, 31, 35)

local buttonTalentDeathknightClose = CreateFrame("Button", "buttonTalentDeathknightClose", frameTalentDeathknight, "UIPanelCloseButton")
buttonTalentDeathknightClose:SetPoint("TOPRIGHT", -12, -12)
buttonTalentDeathknightClose:EnableMouse(true)
buttonTalentDeathknightClose:SetSize(32, 32)

local function CloseTalentWindow()
    frameTalentDeathknight:Hide()
    PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
end

buttonTalentDeathknightClose:SetScript("OnClick", CloseTalentWindow)

local frameTalentDeathknightTitleBar = CreateFrame("Frame", "frameTalentDeathknightTitleBar", frameTalentDeathknight, nil)
frameTalentDeathknightTitleBar:SetSize(135, 25)
frameTalentDeathknightTitleBar:SetBackdrop(
{
    bgFile = "interface/corrupteditems/corruptedtooltipbackground",
    edgeFile = "interface/tooltips/ui-tooltip-border-corrupteddeathknight",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameTalentDeathknightTitleBar:SetPoint("TOP", 0, 20)

local fontTalentDeathknightTitleText = frameTalentDeathknightTitleBar:CreateFontString("fontTalentDeathknightTitleText")
fontTalentDeathknightTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontTalentDeathknightTitleText:SetSize(190, 5)
fontTalentDeathknightTitleText:SetPoint("CENTER", 0, 0)
fontTalentDeathknightTitleText:SetText("|cffFFC125Talents|r")

local fontTalentDeathknightFrameText = frameTalentDeathknightTitleBar:CreateFontString("fontTalentDeathknightFrameText")
fontTalentDeathknightFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentDeathknightFrameText:SetSize(200, 5)
fontTalentDeathknightFrameText:SetPoint("TOPLEFT", frameTalentDeathknightTitleBar, "BOTTOMLEFT", -30, -35)
fontTalentDeathknightFrameText:SetText("|cffFFC125Chevalier de la mort|r")

local fontTalentDeathknightFrameText = frameTalentDeathknightTitleBar:CreateFontString("fontTalentDeathknightFrameText")
fontTalentDeathknightFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentDeathknightFrameText:SetSize(200, 5)
fontTalentDeathknightFrameText:SetPoint("TOPLEFT", frameTalentDeathknightTitleBar, "BOTTOMLEFT", -30, -60)
fontTalentDeathknightFrameText:SetText("0 / " .. MAX_TALENTS)



local function CreateSpellButton(name, texturePath, tooltipText, talentHandler, positionX, positionY)
    local buttonClicked = false
    local talentLearned = false

    local button = CreateFrame("Button", name, frameTalentDeathknight, nil)
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
                AIO.Handle("TalentDeathknightspell", talentHandler, 1)
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






CreateSpellButton("buttonSpellButchery", "Interface/icons/inv_axe_68", "|cffffffffBoucherie|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Chaque fois que vous tuez un ennemi qui rapporte de l'expérience ou de l'honneur,\nvous générez jusqu'à 20 points de puissance runique.\nDe plus, vous générez 2 points de puissance runique toutes les 5 sec.\npendant que vous êtes en combat.|r", "spellbutchery", 100, -80)
CreateSpellButton("buttonSpellSubversion", "Interface/icons/spell_deathknight_subversion", "|cffffffffSubversion|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente les chances de coup critique de Frappe de sang, Frappe du Fléau, Frappe au coeur et Anéantissement de 9%, et réduit la menace générée lorsque vous êtes en Présence de sang ou impie de 25%.|r", "spellbubversion", 205, -75)
CreateSpellButton("buttonSpellBladeBarrier", "Interface/icons/ability_upgrademoonglaive", "|cffffffffBarrière de lames|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Chaque fois que vos runes de sang sont en cours de recharge, vous bénéficiez de l'effet Barrière de lames, qui réduit les dégâts subis de 5% pendant 10 seconds.|r", "spellbladebarrier", 315, -75)
CreateSpellButton("buttonSpellBladedArmor", "Interface/icons/inv_shoulder_36", "|cffffffffArmure tranchante|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente votre puissance d'attaque de 5 pour chaque tranche de 180 points de votre valeur d'armure.|r", "spellbladedarmor", 418, -80)
CreateSpellButton("buttonSpellScentofBlood", "Interface/icons/ability_rogue_bloodyeye", "|cffffffffOdeur du sang|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vous avez 15% de chances après avoir esquivé, paré ou subi des dégâts directs de bénéficier de l'effet Odeur du sang, qui fait générer à vos 3 prochains coups en mêlée 10 points de puissance runique.|r", "spellscentofblood", 45, -130)
CreateSpellButton("buttonSpellTwoHandedWeaponSpecialization", "Interface/icons/inv_sword_68", "|cffffffffSpécialisation Arme 2M|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente les points de dégâts que vous infligez avec les armes de mêlée à deux mains de 4%.|r", "spelltwohandedweaponspecialization", 150, -130)
CreateSpellButton("buttonSpellRuneTap", "Interface/icons/spell_deathknight_runetap", "|cffffffffConnexion runique|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Convertit 1 Rune de sang en 10% de vos points de vie maximum.|r", "spellrunetap", 260, -130)
CreateSpellButton("buttonSpellDarkConviction", "Interface/icons/spell_deathknight_darkconviction", "|cffffffffSombre conviction|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente de 5% vos chances d'infliger un coup critique avec les armes, les sorts et les techniques.|r", "spelldarkconviction", 370, -130)
CreateSpellButton("buttonSpellDeathRuneMastery", "Interface/icons/inv_sword_62", "|cffffffffMaîtrise des runes de la mort|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Chaque fois que vous touchez avec Frappe de mort ou Anéantissement, il y a 100% de chances que les runes de givre et impie deviennent des runes de la mort lors de leur activation.\nLes runes de la mort comptent comme une rune de sang, de givre ou impie.|r", "spelldeathrunemastery", 475, -133)
CreateSpellButton("buttonSpellImprovedRuneTap", "Interface/icons/spell_deathknight_runetap", "|cffffffffConnexion runique améliorée|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente de 100% les points de vie prodigués par Connexion runique et réduit son temps de recharge de 30 sec.|r", "spellimprovedrunetap", 96, -185)
CreateSpellButton("buttonSpellSpellDeflection", "Interface/icons/spell_deathknight_spelldeflection", "|cffffffffDéviation de sort|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vous avez une chance égale à votre chance de parer que les sorts de dégâts directs vous infligent 45% de dégâts en moins.|r", "spellspelldeflection", 205, -185)
CreateSpellButton("buttonSpellVendetta", "Interface/icons/spell_deathknight_vendetta", "|cffffffffVendetta|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Chaque fois que vous tuez une cible qui rapporte de l'expérience ou de l'honneur, vous êtes soigné pour un montant égal à 6% au plus de votre maximum de points de vie.|r", "spellvendetta", 315, -185)
CreateSpellButton("buttonSpellBloodyStrikes", "Interface/icons/spell_deathknight_deathstrike", "|cffffffffFrappes sanglantes|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente les dégâts de Frappe de sang de 15% et de Frappe au coeur de 45%, en plus d'augmenter les dégâts de Furoncle sanglant de 30%.|r", "spellbloodystrikes", 422, -185)
CreateSpellButton("buttonSpellVeteran of the Third War", "Interface/icons/spell_misc_warsongfocus", "|cffffffffVétéran de la Troisième guerre|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente votre total de Force de 6%, votre Endurance de 3% et votre expertise de 6.|r", "spellveteranofthethirdwar", 527, -190)
CreateSpellButton("buttonSpellMarkofBlood", "Interface/icons/ability_hunter_rapidkilling", "|cffffffffMarque de sang|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Place une Marque de sang sur un ennemi.\nChaque fois que l'ennemi marqué inflige des dégâts à une cible, cette cible reçoit 4% de ses points de vie maximum.\nDure 20 seconds ou jusqu'à 20 coups.|r", "spellmarkofblood", 43, -240)
CreateSpellButton("buttonSpellBloodyVengeance", "Interface/icons/ability_backstab", "|cffffffffVengeance sanglante|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Confère un bonus de 3% aux dégâts physiques que vous infligez pendant 30 seconds après avoir réussi un coup critique avec une arme, un sort ou une technique.\nL'effet est cumulable jusqu'à 3 fois.|r", "spellbloodyvengeance", 150, -240)
CreateSpellButton("buttonSpellAbominationsMight", "Interface/icons/ability_warrior_intensifyrage", "|cffffffffPuissance de l'abomination|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente de 10% la puissance d'attaque des membres du groupe ou du raid se trouvant à moins de 100 mètres.\nAugmente également votre total de Force de 2%.|r", "spellabominationsmight", 260, -240)
CreateSpellButton("buttonSpellBloodworms", "Interface/icons/spell_shadow_soulleech", "|cffffffffVers de sang|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vos coups portés avec des armes ont 9% de chances de faire produire à la cible de 2 à 4 vers de sang.\nLes vers de sang attaquent vos ennemis et vous rendent un montant de points de vie égal aux dégâts qu'ils infligent pendant 20 sec.\nou jusqu'à ce qu'ils soient tués.|r", "spellbloodworms", 368, -240)
CreateSpellButton("buttonSpellUnholyFrenzy", "Interface/icons/spell_deathknight_bladedarmor", "|cffffffffHystérie|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Plonge une unité alliée dans une frénésie meurtrière pendant 30 seconds.\nLa cible est enragée, ce qui augmente les dégâts physiques qu'elle inflige de 20%, mais elle subit aussi toutes les secondes un montant de dégâts égal à 1% de ses points de vie maximum.|r", "spellunholyfrenzy", 478, -240)
CreateSpellButton("buttonSpellImprovedBloodPresence", "Interface/icons/spell_deathknight_bloodpresence", "|cffffffffPrésence de sang améliorée|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Quand vous êtes en Présence de givre ou impie, vous conservez 4% des soins de Présence de sang, et les soins qui vous sont prodigués sont augmentés de 10% en Présence de sang.|r", "spellimprovedbloodpresence", 98, -293)
CreateSpellButton("buttonSpellImprovedDeathStrike", "Interface/icons/spell_deathknight_butcher2", "|cffffffffFrappe de mort améliorée|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente de 30% les dégâts de votre Frappe de mort, de 6% ses chances de coup critique et de 50% les soins prodigués.|r", "spellimproveddeathstrike", 205, -293)
CreateSpellButton("buttonSpellSuddenDoom", "Interface/icons/spell_shadow_painspike", "|cffffffffMalédiction soudaine|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vos Frappes de sang et Frappes au coeur ont 15% de chances de lancer un Voile mortel gratuit sur votre cible.|r", "spellsuddendoom", 315, -293)
CreateSpellButton("buttonSpellVampiricBlood", "Interface/icons/spell_shadow_lifedrain", "|cffffffffSang vampirique|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Confère temporairement au chevalier de la mort 15% de son maximum de points de vie et augmente le montant de points de vie généré par les sorts et effets de 35% pendant 10 seconds.\nQuand l'effet se termine, ces points de vie sont perdus.|r", "spellvampiricblood", 422, -293)
CreateSpellButton("buttonSpellWilloftheNecropolis", "Interface/icons/ability_creature_cursed_02", "|cffffffffVolonté de la nécropole|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Les dégâts qui vous feraient descendre à moins de 35% de vos points de vie ou que vous subissez alors que vous ne disposez que de 35% de vos points de vie sont réduits de 15%.|r", "spellwillofthenecropolis", 527, -295)
CreateSpellButton("buttonSpellHeartStrike", "Interface/icons/inv_weapon_shortblade_40", "|cffffffffFrappe au coeur|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Frappe instantanément la cible et son allié le plus proche, infligeant 72% des dégâts de l'arme plus 247 à la cible principale et 36% des dégâts de l'arme plus 123 à la cible secondaire.\nChaque cible subit 10% de dégâts supplémentaires pour chacune de vos maladies actives sur elle, et la vitesse de déplacement est réduite de 50% pendant 10 seconds.|r", "spellheartstriks", 43, -350)
CreateSpellButton("buttonSpellMightofMograine", "Interface/icons/spell_deathknight_classicon", "|cffffffffPuissance de Mograine|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente de 45% le bonus aux dégâts des coups critiques infligés avec vos techniques Furoncle sanglant, Frappe de sang, Frappe de mort et Frappe au cœur.|r", "spellmightofmograine", 260, -350)
CreateSpellButton("buttonSpellBloodGorged", "Interface/icons/spell_nature_reincarnation", "|cffffffffGorgé de sang|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Quand vous disposez de plus de 75% de vos points de vie, vous infligez 10% de dégâts supplémentaires.\nDe plus, vos attaques ignorent jusqu'à 10% de l'armure de votre adversaire à tout moment.|r", "spellbloodgorged", 150, -350)
CreateSpellButton("buttonSpellDancingRuneWeapon", "Interface/icons/inv_sword_07", "|cffffffffArme runique dansante|r\n|cffffffffTalent|r |cffd20000Sang|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Invoque une seconde arme runique qui combat toute seule pendant 12 seconds., en effectuant les mêmes attaques que le chevalier de la mort mais en infligeant 50% de dégâts de moins que lui.|r", "spelldancingruneweapon", 368, -350)


CreateSpellButton("buttonSpellImprovedIcyTouch", "Interface/icons/spell_deathknight_icetouch", "|cffffffffToucher de glace amélioré|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Votre Toucher de glace inflige 15% de dégâts supplémentaires, et votre Fièvre de givre réduit les vitesses d'attaque en mêlée et à distance de 6% supplémentaires.|r", "spellimprovedicytouch", 527, -402)
CreateSpellButton("buttonSpellRunicPowerMastery", "Interface/icons/spell_arcane_arcane01", "|cffffffffMaîtrise de la puissance runique|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente votre puissance runique maximale de 30.|r", "spellrunicpowermastery", 478, -350)
CreateSpellButton("buttonSpellToughness", "Interface/icons/spell_holy_devotion", "|cffffffffRésistance|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente la valeur d'armure des objets de 10% et réduit la durée de tous les effets affectant le déplacement de 30%.|r", "spelltoughness", 98, -405)
CreateSpellButton("buttonSpellIcyReach", "Interface/icons/spell_frost_manarecharge", "|cffffffffAllonge glaciale|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente la portée de vos sorts Toucher de glace, Chaînes de glace et Rafale hurlante de 10 mètres.|r", "spellicyreach", 205, -405)
CreateSpellButton("buttonSpellBlackIce", "Interface/icons/spell_shadow_darkritual", "|cffffffffGlace noire|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente vos dégâts de Givre et d'Ombre de 10%.|r", "spellblackice", 315, -405)
CreateSpellButton("buttonSpellNervesofColdSteel", "Interface/icons/ability_dualwield", "|cffffffffNerfs d'acier glacé|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente de 3% vos chances de toucher avec les armes de mêlée à une main, et augmente de 25% les dégâts infligés par l'arme que vous utilisez en main gauche.\net augmente votre total d'Endurance de 4%.|r", "spellnervesofcoldsteel", 422, -405)
CreateSpellButton("buttonSpellIcyTalons", "Interface/icons/spell_deathknight_icytalons", "|cffffffffSerres de glace|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vous volez la chaleur des victimes de votre Fièvre de givre, de sorte que lorsque leur vitesse d'attaque en mêlée est réduite, la vôtre augmente de 20% pendant les 20 prochaines sec.|r", "spellicytalons", 43, -458)
CreateSpellButton("buttonSpellLichborne", "Interface/icons/spell_shadow_raisedead", "|cffffffffChangeliche|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Utilise de l'énergie impie pour devenir mort-vivant pendant 10 seconds.\nTant que vous êtes mort-vivant, vous êtes insensible aux effets de charme, de peur et de sommeil.|r", "spelllichborne", 150, -458)
CreateSpellButton("buttonSpellAnnihilation", "Interface/icons/inv_weapon_hand_18", "|cffffffffAnnihilation|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente vos chances de réaliser un coup critique avec vos techniques spéciales de mêlée de 3%.\nDe plus, il y a 100% de chances que votre Anéantissement inflige ses dégâts sans consommer de maladie.|r", "spellannihilation", 260, -458)
CreateSpellButton("buttonSpellKillingMachine", "Interface/icons/inv_sword_122", "|cffffffffMachine à tuer|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vos attaques en mêlée ont une chance de conférer un coup critique à votre prochain sort Toucher de glace, Rafale hurlante, ou Frappe de givre.|r", "spellkillingmachine", 368, -458)
CreateSpellButton("buttonSpellChilloftheGrave", "Interface/icons/spell_frost_frostshock", "|cffffffffFroid de la tombe|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vos sorts Chaînes de glace, Rafale hurlante, Toucher de glace et Anéantissement génèrent 5 points de puissance runique supplémentaires.|r", "spellchillofthegrave", 478, -458)
CreateSpellButton("buttonSpellEndlessWinter", "Interface/icons/spell_shadow_twilight", "|cffffffffHiver sans fin|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Votre Force est augmentée de 4% et votre Gel de l'esprit ne coûte plus de puissance runique.|r", "spellendlesswinter", 98, -510)
CreateSpellButton("buttonSpellFrigid Dreadplate", "Interface/icons/inv_chest_mail_04", "|cffffffffPlaques d'effroi algides|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Réduit les chances de vous toucher en mêlée de 3%.|r", "spellfrigiddreadplate", 205, -510)
CreateSpellButton("buttonSpellGlacierRot", "Interface/icons/spell_nature_removedisease", "|cffffffffPourriture des glaciers|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vos sorts Toucher de glace, Rafale hurlante et Frappe de givre infligent 20% de dégâts supplémentaires aux cibles malades.\nDure 15 seconds.|r", "spellglacierrot", 315, -510)
CreateSpellButton("buttonSpellDeathchill", "Interface/icons/spell_shadow_soulleech_2", "|cffffffffFroid de la mort|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Quand il est activé, il fait de votre prochain sort Toucher de glace, Rafale hurlante, Frappe de givre ou Anéantissement un coup critique si utilisé en 30 seconds maximum.|r", "spelldeathchill", 422, -510)


CreateSpellButton("buttonSpellImprovedIcyTalons", "Interface/icons/spell_deathknight_icytalons", "|cffffffffSerres de glace améliorées|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente la hâte en mêlée de tous les membres de votre groupe ou raid à moins de 100 mètres de 20% et votre hâte de 5% supplémentaires.|r", "spellimprovedicytalons", 663, -75)
CreateSpellButton("buttonSpellMercilessCombat", "Interface/icons/inv_sword_112", "|cffffffffCombat impitoyable|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Toucher de glace, Rafale hurlante, Anéantissement et Frappe de givre infligent 12% de dégâts supplémentaires aux cibles qui disposent de moins de 35% de leurs points de vie.|r", "spellmercilesscombat", 770, -75)
CreateSpellButton("buttonSpellRime", "Interface/icons/spell_frost_freezingbreath", "|cffffffffFrimas|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente les chances de coup critique de vos sorts Toucher de glace\net Anéantissement de 15% et l'incantation d'Anéantissement a 15% de chances de réinitialiser le temps de recharge de Rafale hurlante\nen plus de permettre à votre prochaine Rafale hurlante de ne pas consommer de runes.|r", "spellrime", 880, -75)
CreateSpellButton("buttonSpellChilblains", "Interface/icons/spell_frost_wisp", "|cffffffffEngelures|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Les victimes de votre Fièvre de givre sont transies, ce qui réduit leur vitesse de déplacement de 50% pendant 10 seconds.|r", "spellchilblains", 990, -75)
CreateSpellButton("buttonSpellHungeringCold", "Interface/icons/inv_staff_15", "|cffffffffFroid dévorant|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Eradique toute chaleur de la terre autour du chevalier de la mort.\nLes ennemis se trouvant à moins de 10 mètres sont pris dans la glace, ce qui les empêche de réaliser toute action pendant 10 seconds et leur fait contracter la Fièvre de givre.\nLes ennemis sont considérés comme gelés, mais tous les dégâts autres que les maladies brisent la glace.|r", "spellhungeringcold", 1100, -75)
CreateSpellButton("buttonSpellImprovedFrostPresence", "Interface/icons/spell_deathknight_frostpresence", "|cffffffffPrésence de givre améliorée|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Quand vous êtes en Présence de sang ou impie, vous conservez 8% de l'Endurance de Présence de givre, et les dégâts qui vous sont infligés sont réduits de 2% supplémentaires en Présence de givre.|r", "spellimprovedfrostpresence", 718, -130)
CreateSpellButton("buttonSpellThreatofThassarian", "Interface/icons/ability_dualwieldspecialization", "|cffffffffMenace de Thassarian|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Lorsque vous utilisez deux armes en même temps, vos Frappes de mort,\nAnéantissements, Frappes de peste, Frappes runiques, Frappes de sang et Frappes de givre\nont 100% de chances d'également infliger des dégâts avec votre arme tenue en main gauche.|r", "spellthreatofthassarian", 825, -130)
CreateSpellButton("buttonSpellBloodoftheNorth", "Interface/icons/inv_weapon_shortblade_79", "|cffffffffSang du Nord|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente les dégâts de Frappe de sang et Frappe de givre de 10%.\nDe plus, chaque fois que vous touchez avec Frappe de sang ou Pestilence, il y a 100% de chances que la rune de sang devienne une rune de la mort à son activation.\nLes runes de la mort comptent comme une rune de sang, de givre ou impie.|r", "spellbloodofthenorth", 935, -130)
CreateSpellButton("buttonSpellUnbreakableArmor", "Interface/icons/inv_armor_helm_plate_naxxramas_raidwarrior_c_01", "|cffffffffArmure incassable|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Renforce votre armure d'une épaisse couche de glace qui augmente votre armure de 25% et votre Force de 20% pendant 20 seconds.|r", "spellunbreakablearmor", 1045, -130)
CreateSpellButton("buttonSpellAcclimation", "Interface/icons/spell_fire_elementaldevastation", "|cffffffffAcclimatation|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Quand vous êtes touché par un sort, vous avez 30% de chances d'améliorer votre résistance à ce type de magie pendant 18 sec.\nCumulable jusqu'à 3 fois.|r", "spellacclimation", 663, -184)
CreateSpellButton("buttonSpellFrostStrike", "Interface/icons/spell_deathknight_empowerruneblade2", "|cffffffffFrappe de givre|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Frappe instantanément l'ennemi et lui inflige 60 à 61% des dégâts de l'arme plus 57 sous forme de dégâts de Givre.|r", "spellfroststrike", 770, -184)
CreateSpellButton("buttonSpellGuileofGorefiend", "Interface/icons/inv-sword_53", "|cffffffffRuse de Fielsang|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente de 45% le bonus aux dégâts des coups critiques réussis avec vos techniques Frappe de sang, Frappe de givre, Rafale hurlante et Anéantissement en plus d'augmenter de 6 sec.\nla durée de votre Robustesse glaciale.|r", "spellguileofgorefiend", 880, -184)
CreateSpellButton("buttonSpellTundraStalker", "Interface/icons/spell_nature_tranquility", "|cffffffffTraqueur de la toundra|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vos sorts et techniques infligent 15% de dégâts supplémentaires aux cibles souffrant de la Fièvre de givre.\nAugmente également votre expertise de 5.|r", "spelltundrastalker", 990, -184)
CreateSpellButton("buttonSpellHowlingBlast", "Interface/icons/spell_frost_arcticwinds", "|cffffffffRafale hurlante|r\n|cffffffffTalent|r |cff00acffGivre|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Un vent glacial frappe la cible et inflige 198 à 214 points de dégâts de Givre à tous les ennemis se trouvant à moins de 10 mètres.|r", "spellhowlingblast", 1100, -184)



CreateSpellButton("buttonSpellViciousStrikes", "Interface/icons/spell_deathknight_plaguestrike", "|cffffffffAttaques vicieuses|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente de 6% les chances de coup critique et de 30% le bonus de dégâts des coups critiques de vos sorts Frappe de peste et Frappe du Fléau.|r", "spellviciousstrikes", 718, -240)
CreateSpellButton("buttonSpellVirulence", "Interface/icons/spell_shadow_burningspirit", "|cffffffffVirulence|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente vos chances de toucher avec vos sorts de 3% et réduit de 30% la probabilité que vos maladies de dégâts sur la durée puissent être soignées.|r", "spellvirulence", 825, -240)
CreateSpellButton("buttonSpellAnticipation", "Interface/icons/spell_nature_mirrorimage", "|cffffffffAnticipation|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente vos chances d'esquiver une attaque de 5%.|r", "spellanticipation", 935, -240)
CreateSpellButton("buttonSpellEpidemic", "Interface/icons/spell_shadow_shadowwordpain", "|cffffffffEpidémie|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente la durée de Peste de sang et Fièvre de givre de 6 sec.|r", "spellepidemic", 1045, -240)
CreateSpellButton("buttonSpellMorbidity", "Interface/icons/spell_shadow_deathanddecay", "|cffffffffMorbidité|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente de 15% les dégâts et les soins de votre sort Voile mortel et réduit le temps de recharge de votre sort Mort et décomposition de 15 sec.|r", "spellmorbidity", 663, -293)
CreateSpellButton("buttonSpellUnholyCommand", "Interface/icons/spell_deathknight_strangulate", "|cffffffffAutorité impie|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Réduit le temps de recharge de votre technique Poigne de la mort de 10 sec.|r", "spellunholycommand", 770, -293)
CreateSpellButton("buttonSpellRavenousDead", "Interface/icons/spell_deathknight_gnaw_ghoul", "|cffffffffMorts voraces|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente votre total de Force de 3% et la part de votre Force et de votre Endurance que reçoivent vos goules de 60%.|r", "spellravenousdead", 880, -293)
CreateSpellButton("buttonSpellOutbreak", "Interface/icons/spell_shadow_plaguecloud", "|cffffffffPoussée de fièvre|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Augmente les dégâts de Frappe de peste de 30% et de Frappe du Fléau de 20%.|r", "spelloutbreak", 990, -293)
CreateSpellButton("buttonSpellNecrosis", "Interface/icons/inv_weapon_shortblade_60", "|cffffffffNécrose|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vos attaques automatiques infligent 20% de dégâts d'Ombre supplémentaires.|r", "spellnecrosis", 1100, -293)
CreateSpellButton("buttonSpellCorpseExplosion", "Interface/icons/ability_creature_disease_02", "|cffffffffExplosion morbide|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Fait exploser un cadavre et inflige 166 points de dégâts d'Ombre à tous les ennemis se trouvant à moins de 10 mètres.\nUtilise un cadavre proche si la cible n'en est pas un.\nN'affecte pas les cadavres mécaniques ou d'élémentaires.|r", "spellcorpseexplosion", 718, -348)
CreateSpellButton("buttonSpellOnaPaleHorse", "Interface/icons/spell_deathknight_summondeathcharger", "|cffffffffSur un cheval pâle|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vous devenez aussi difficile à arrêter que la mort elle-même.\nLa durée de tous les effets d'étourdissement et de peur contre vous est réduite de 20%, et la vitesse de votre monture est augmentée de 20%.\nNe s'additionne pas avec les autres effets qui augmentent la vitesse de déplacement.|r", "spellonapalehorse", 825, -348)
CreateSpellButton("buttonSpellBloodCakedBlade", "Interface/icons/ability_criticalstrike", "|cffffffffLame incrustée de sang|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vos attaques automatiques ont 30% de chances de causer une Frappe incrustée de sang, qui inflige 25% des dégâts de l'arme plus 12.5% pour chacune de vos maladies sur la cible.|r", "spellbloodcakedblade", 935, -348)
CreateSpellButton("buttonSpellNightoftheDead", "Interface/icons/spell_deathknight_armyofthedead", "|cffffffffNuit des morts|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Réduit le temps de recharge de Réanimation morbide de 90 sec.\net celui d'Armée des morts de 4 min.\nRéduit également les dégâts infligés à votre familier par les attaques à zone d'effet des créatures de 90%.|r", "spellnightofthedead", 1045, -348)
CreateSpellButton("buttonSpellMasterofGhouls", "Interface/icons/spell_shadow_animatedead", "|cffffffffMaître des goules|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Réduit le temps de recharge de Réanimation morbide de 60 sec.\net la goule invoquée par votre sort Réanimation morbide est considérée comme un familier sous votre contrôle.\nContrairement aux goules normales de chevalier de la mort, votre familier n'a pas de durée limitée.|r", "spellmasterofghouls", 663, -402)
CreateSpellButton("buttonSpellGhoulFrenzy", "Interface/icons/ability_ghoulfrenzy", "|cffffffffFrénésie de la goule|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Confère à votre familier un bonus de 25% à la hâte pendant 30 seconds et lui rend 60% de ses points de vie pendant la durée de l'effet.|r", "spellghoulfrenzy", 770, -402)
CreateSpellButton("buttonSpellUnholyBlight", "Interface/icons/spell_shadow_contagion", "|cffffffffChancre impie|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Un essaim infect d'insectes impies s'abat sur les victimes de votre Voile mortel\net leur inflige un montant de dégâts égal à 10% des dégâts infligés par Voile mortel en 10 seconds,\nen plus d'empêcher toutes les maladies présentes sur ces victimes d'être dissipées.|r", "spellunholyblight", 880, -402)
CreateSpellButton("buttonSpellImpurity", "Interface/icons/spell_shadow_shadowandflame", "|cffffffffImpureté|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vos sorts reçoivent un bénéfice supplémentaire de 20% de votre puissance d'attaque.|r", "spellimpurity", 990, -402)
CreateSpellButton("buttonSpellDirge", "Interface/icons/spell_shadow_shadesofdarkness", "|cffffffffComplainte|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vos sorts Frappe de mort, Frappe de peste et Frappe du Fléau génèrent 5 points de puissance runique supplémentaires.|r", "spelldirge", 1100, -402)
CreateSpellButton("buttonSpellDesecration", "Interface/icons/spell_shadow_shadowfiend", "|cffffffffViolation|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vos Frappes de peste et Frappes du Fléau provoquent l'effet Terre profanée.\nLes cibles dans la zone sont ralenties de 50% par les bras avides des morts tant que vous restez sur la terre impie.\nDure 20 seconds.|r", "spelldesecration", 718, -456)
CreateSpellButton("buttonSpellMagicSuppression", "Interface/icons/spell_shadow_antimagicshell", "|cffffffffSuppression de la magie|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Toutes les formes de magie vous infligent 6% de dégâts en moins.\nDe plus, votre Carapace anti-magie absorbe 25% de dégâts des sorts supplémentaires.|r", "spellmagicsuppression", 825, -456)
CreateSpellButton("buttonSpellAntiMagicZone", "Interface/icons/spell_deathknight_antimagiczone", "|cffffffffZone anti-magie|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Place une grande Zone anti-magie stationnaire qui réduit de 75% les dégâts des sorts infligés aux membres du groupe ou du raid se trouvant à l'intérieur.\nLa Zone anti-magie dure 10 seconds.\nou jusqu'à ce que 12768 points de dégâts des sorts aient été absorbés.|r", "spellantimagiczone", 935, -456)
CreateSpellButton("buttonSpellReaping", "Interface/icons/spell_shadow_shadetruesight", "|cffffffffMoisson|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Chaque fois que vous touchez avec Frappe de sang ou Pestilence, il y a 100% de chances que la rune de sang devienne une rune de la mort lors de son activation.\nLes runes de la mort comptent comme une rune de sang, de givre ou impie.|r", "spellreaping", 1045, -456)
CreateSpellButton("buttonSpellDesolation", "Interface/icons/spell_shadow_unholyfrenzy", "|cffffffffDésolation|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vos Frappes de sang vous font infliger 5% de dégâts supplémentaires avec toutes les attaques pendant 20 seconds.|r", "spelldesolation", 663, -510)
CreateSpellButton("buttonSpellImprovedUnholyPresence", "Interface/icons/spell_deathknight_unholypresence", "|cffffffffPrésence impie améliorée|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Quand vous êtes en Présence de sang ou de givre, vous conservez l'augmentation de la vitesse de déplacement de 15% de Présence impie,\net le temps de recharge de vos runes est 10% plus rapide en Présence impie.|r", "spellimprovedunholypresence", 770, -510)
CreateSpellButton("buttonSpellCryptFever", "Interface/icons/spell_nature_nullifydisease", "|cffffffffFièvre de la crypte|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vos maladies entraînent également la Fièvre de la crypte, qui augmente de 30% les dégâts infligés par les maladies à la cible.|r", "spellcryptfever", 880, -510)
CreateSpellButton("buttonSpellBoneShield", "Interface/icons/inv_chest_leather_13", "|cffffffffBouclier d'os|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Le chevalier de la mort est entouré de 3 os tourbillonnants.\nTant qu'il reste au moins un os, toutes les attaques contre le chevalier infligent 20% de dégâts en moins et les attaques, techniques et sorts du chevalier infligent 2% de dégâts en plus.\nChaque attaque infligeant des dégâts consomme un os.\nDure 5 min.|r", "spellboneshield", 990, -510)
CreateSpellButton("buttonSpellWanderingPlague", "Interface/icons/spell_shadow_callofbone", "|cffffffffPeste galopante|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Quand vos maladies infligent des dégâts à un ennemi,\nvous avez une chance égale à vos chances de coup critique en mêlée qu'elles infligent 100% de dégâts supplémentaires à la cible et à tous les ennemis se trouvant à moins de 8 mètres.\nIgnore les cibles porteuses d'un effet de sort annulé lorsque des dégâts sont subis.|r", "spellwanderingplague", 1100, -510)
CreateSpellButton("buttonSpellEbonPlaguebringer", "Interface/icons/ability_creature_cursed_03", "|cffffffffPorte-peste d'ébène|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Votre Fièvre de la crypte devient une Peste d'ébène, qui augmente les dégâts magiques subis de 13% en plus d'augmenter les dégâts infligés par les maladies.\nAugmente en permanence vos chances de coup critique avec les armes et les sorts de 3%.|r", "spellebonplaguebringer", 716, -564)
CreateSpellButton("buttonSpellScourgeStrike", "Interface/icons/spell_deathknight_scourgestrike", "|cffffffffFrappe du Fléau|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Une frappe impie qui inflige 84% des dégâts de l'arme sous forme de dégâts physiques plus 343.\nDe plus, pour chacune de vos maladies sur la cible, vous infligez un montant supplémentaire de dégâts d'Ombre égal à 12% des dégâts physiques infligés.|r", "spellscourgestrike", 824, -564)
CreateSpellButton("buttonSpellRageofRivendare", "Interface/icons/inv_weapon_halberd14", "|cffffffffRage de Vaillefendre|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Vos sorts et techniques infligent 10% de dégâts supplémentaires aux cibles atteintes de la Peste de sang.\nAugmente également votre expertise de 5.|r", "spellrageofrivendare", 934, -564)
CreateSpellButton("buttonSpellSummonGargoyle", "Interface/icons/ability_hunter_pet_bat", "|cffffffffInvocation d'une gargouille|r\n|cffffffffTalent|r |cff00b700Impie|r\n|cffffffffRequiert|r |cffc51f23Chevalier de la mort|r\n|cffffd100Une gargouille bombarde la cible et lui inflige des dégâts de Nature modifiés par la puissance d'attaque du chevalier de la mort.\nPersiste pendant 30 seconds.|r", "spellsummongargoyle", 1045, -564)




local resetButtonClicked = false

local buttonReset = CreateFrame("Button", "buttonReset", frameTalentDeathknight, "UIPanelButtonTemplate")
buttonReset:SetSize(85, 25)
buttonReset:SetPoint("BOTTOMRIGHT", buttonTalentDeathknightClose, "BOTTOMLEFT", -95, 5)
buttonReset:SetText("Réinitialiser")

local function ResetTalents()
    AIO.Handle("TalentDeathknightspell", "ResetTalents")
    resetButtonClicked = true
end

buttonReset:SetScript("OnClick", ResetTalents)

local buttonReload = CreateFrame("Button", "buttonReload", frameTalentDeathknight, "UIPanelButtonTemplate")
buttonReload:SetSize(85, 25)
buttonReload:SetPoint("BOTTOMRIGHT", buttonTalentDeathknightClose, "BOTTOMLEFT", -5, 5)
buttonReload:SetText("Actualiser")

local function ReloadClient()
    if resetButtonClicked then
        ReloadUI()
    else
        print("|cff00ffffVous ne pouvez <Actualiser> que lorsque vous <Réinitialiser> vos talents.")
    end
end

buttonReload:SetScript("OnClick", ReloadClient)

local function OuvrirInterfaceTalents()
    frameTalentDeathknight:Show()
    buttonReload:Show()
    PlaySoundFile(OPEN_TALENT_WINDOW_SOUND)
end

local playerClass = select(2, UnitClass("player"))
if playerClass == "DEATHKNIGHT" then
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
        GameTooltip:SetText("|cffffffffTalents|r |cffc51f23(Chevalier de la mort)|r\n\nL'éventail des talents disponibles\npour améliorer et spécialiser\nvotre personnage.")
        GameTooltip:Show()
    end)

    buttonOuvrirTalents:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    buttonOuvrirTalents:SetScript("OnClick", OuvrirInterfaceTalents)
    TalentMicroButton:Hide()
end

DeathknightHandlers.UpdateTalentCount = function(player, talentsAppris)
    if fontTalentDeathknightFrameText then
        fontTalentDeathknightFrameText:SetText(talentsAppris .. " / " .. MAX_TALENTS)
    end
end

DeathknightHandlers.UpdateTalentPointsUsed = function(player, pointsUsed, pointsBeforeReset)
    print("|cff00ffffVous avez utilisés " .. pointsBeforeReset .. " points avant la réinitialisation des talents|r")
end