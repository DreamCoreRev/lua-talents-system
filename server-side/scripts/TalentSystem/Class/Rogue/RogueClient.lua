local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local RogueHandlers = AIO.AddHandlers("TalentRoguespell", {})

function RogueHandlers.ShowTalentRogue(player)
    frameTalentRogue:Show()
end

local MAX_TALENTS = 42

local OPEN_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_final_trait_unlocked.ogg"
local CLOSE_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_trait_refund_end.ogg"
local SPELL_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_80_azeritearmor_rotationends_02.ogg"

local frameTalentRogue = CreateFrame("Frame", "frameTalentRogue", UIParent)
frameTalentRogue:SetSize(1200, 650)
frameTalentRogue:SetMovable(true)
frameTalentRogue:EnableMouse(true)
frameTalentRogue:RegisterForDrag("LeftButton")
frameTalentRogue:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
frameTalentRogue:SetBackdrop(
{
    bgFile = "interface/TalentFrame/Template/Class/Rogue/talentsclassbackgroundrogue2",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedrogue",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

local rogueIcon = frameTalentRogue:CreateTexture("RogueIcon", "OVERLAY")
rogueIcon:SetTexture("Interface\\TalentFrame\\Template\\Class\\Rogue\\IconeRogue.blp")
rogueIcon:SetSize(60, 60)
rogueIcon:SetPoint("TOPLEFT", frameTalentRogue, "TOPLEFT", -10, 10)


local textureone = frameTalentRogue:CreateTexture("TemplateTalentFrame", "OVERLAY")
textureone:SetTexture("Interface\\TalentFrame\\Template\\Class\\Rogue\\TalentFrameTemplate.blp")
textureone:SetSize(928, 928)
textureone:SetPoint("TOPLEFT", frameTalentRogue, "TOPLEFT", -170, 140)

frameTalentRogue:SetFrameLevel(100)

local texturetwo = frameTalentRogue:CreateTexture("TemplateTalentFrame", "OVERLAY")
texturetwo:SetTexture("Interface\\TalentFrame\\Template\\Class\\Rogue\\TalentFrameTemplateOriginal.blp")
texturetwo:SetSize(928, 928)
texturetwo:SetPoint("TOPRIGHT", frameTalentRogue, "TOPRIGHT", 170, 140)

frameTalentRogue:SetFrameLevel(100)

frameTalentRogue:SetScript("OnDragStart", frameTalentRogue.StartMoving)
frameTalentRogue:SetScript("OnHide", frameTalentRogue.StopMovingOrSizing)
frameTalentRogue:SetScript("OnDragStop", frameTalentRogue.StopMovingOrSizing)
frameTalentRogue:Hide()

frameTalentRogue:SetBackdropBorderColor(1, 1, 0.5)

local buttonTalentRogueClose = CreateFrame("Button", "buttonTalentRogueClose", frameTalentRogue, "UIPanelCloseButton")
buttonTalentRogueClose:SetPoint("TOPRIGHT", -12, -12)
buttonTalentRogueClose:EnableMouse(true)
buttonTalentRogueClose:SetSize(32, 32)

local function CloseTalentWindow()
    frameTalentRogue:Hide()
    PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
end

buttonTalentRogueClose:SetScript("OnClick", CloseTalentWindow)

local frameTalentRogueTitleBar = CreateFrame("Frame", "frameTalentRogueTitleBar", frameTalentRogue, nil)
frameTalentRogueTitleBar:SetSize(135, 25)
frameTalentRogueTitleBar:SetBackdrop(
{
    bgFile = "interface/corrupteditems/corruptedtooltipbackground",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedrogue",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameTalentRogueTitleBar:SetPoint("TOP", 0, 20)

local fontTalentRogueTitleText = frameTalentRogueTitleBar:CreateFontString("fontTalentRogueTitleText")
fontTalentRogueTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontTalentRogueTitleText:SetSize(190, 5)
fontTalentRogueTitleText:SetPoint("CENTER", 0, 0)
fontTalentRogueTitleText:SetText("|cffFFC125Talents|r")

local fontTalentRogueFrameText = frameTalentRogueTitleBar:CreateFontString("fontTalentRogueFrameText")
fontTalentRogueFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentRogueFrameText:SetSize(200, 5)
fontTalentRogueFrameText:SetPoint("TOPLEFT", frameTalentRogueTitleBar, "BOTTOMLEFT", -30, -35)
fontTalentRogueFrameText:SetText("|cffFFC125Voleur|r")

local fontTalentRogueFrameText = frameTalentRogueTitleBar:CreateFontString("fontTalentRogueFrameText")
fontTalentRogueFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentRogueFrameText:SetSize(200, 5)
fontTalentRogueFrameText:SetPoint("TOPLEFT", frameTalentRogueTitleBar, "BOTTOMLEFT", -30, -60)
fontTalentRogueFrameText:SetText("0 / " .. MAX_TALENTS)



local function CreateSpellButton(name, texturePath, tooltipText, talentHandler, positionX, positionY)
    local buttonClicked = false
    local talentLearned = false

    local button = CreateFrame("Button", name, frameTalentRogue, nil)
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
                AIO.Handle("TalentRoguespell", talentHandler, 1)
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






CreateSpellButton("buttonSpellImprovedEviscerate", "Interface/icons/ability_rogue_eviscerate", "|cffffffffEviscération améliorée|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente les dégâts infligés par votre technique Eviscération de 20%.|r", "spellimprovedeviscerate", 100, -80)
CreateSpellButton("buttonSpellRemorselessAttacks", "Interface/icons/ability_fiegndead", "|cffffffffAttaques impitoyables|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Lorsque vous tuez un adversaire qui vous fait gagner de l'expérience ou de l'honneur,\nvous avez 40% de chances d'infliger un coup critique lors de votre prochaine attaque avec\nAttaque pernicieuse, Hémorragie, Attaque sournoise, Estropier, Embuscade ou Frappe fantomatique.\nDure 20 seconds.|r", "spellremorselessattacks", 205, -75)
CreateSpellButton("buttonSpellMalice", "Interface/icons/ability_racial_bloodrage", "|cffffffffMalice|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente vos chances d'infliger un coup critique de 5%.|r", "spellmalice", 315, -75)
CreateSpellButton("buttonSpellRuthlessness", "Interface/icons/ability_druid_disembowel", "|cffffffffNémésis|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Confère à vos coups de grâce en mêlée 60% de chances d'ajouter un point de combo à votre cible.|r", "spellruthlessness", 418, -80)
CreateSpellButton("buttonSpellBloodSpatter", "Interface/icons/ability_rogue_bloodsplatter", "|cffffffffEclaboussure de sang|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente les points de dégâts infligés par vos techniques Garrot et Rupture de 30%.|r", "spellbloodspatter", 45, -130)
CreateSpellButton("buttonSpellPuncturingWounds", "Interface/icons/ability_backstab", "|cffffffffBlessures transperçantes|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente vos chances d'infliger un coup critique avec la technique Attaque sournoise de 30%\net vos chances d'infliger un coup critique avec la technique Estropier de 15%.|r", "spellpuncturingwounds", 150, -130)
CreateSpellButton("buttonSpellVigor", "Interface/icons/spell_nature_earthbindtotem", "|cffffffffVigueur|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente votre maximum d'Energie de 10.|r", "spellvigor", 260, -130)
CreateSpellButton("buttonSpellImprovedExposeArmor", "Interface/icons/ability_warrior_riposte", "|cffffffffExposer l'armure amélioré|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Réduit le coût en énergie de votre technique Exposer l'armure de 10.|r", "spellimprovedexposearmor", 370, -130)
CreateSpellButton("buttonSpellLethality", "Interface/icons/ability_criticalstrike", "|cffffffffMortalité|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente de 30% le bonus aux dégâts des coups critiques de toutes\nvos techniques de combo générant des points et ne nécessitant pas d'être camouflé.|r", "spelllethality", 475, -133)
CreateSpellButton("buttonSpellVilePoisons", "Interface/icons/ability_rogue_feigndeath", "|cffffffffPoisons abominables|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente de 20% les points de dégâts infligés par vos poisons et votre technique Envenimer\net donne à vos poisons de dégâts sur la durée 30% de chances supplémentaires de résister aux effets de dissipation.|r", "spellvilepoisons", 96, -185)
CreateSpellButton("buttonSpellImprovedPoisons", "Interface/icons/ability_poisons", "|cffffffffPoisons améliorés|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente vos chances d'appliquer Poison mortel sur votre cible de 20%\net la fréquence à laquelle vous appliquez Poison instantané sur votre cible de 50%.|r", "spellimprovedpoisons", 205, -185)
CreateSpellButton("buttonSpellFleetFooted", "Interface/icons/ability_rogue_fleetfooted", "|cffffffffPied léger|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Réduit de 30% la durée de tous les effets affectant le mouvement et augmente de 15% votre vitesse de déplacement.\nNe se cumule pas avec les autres effets qui augmentent la vitesse de déplacement.|r", "spellfleetfooted", 315, -185)
CreateSpellButton("buttonSpellColdBlood", "Interface/icons/spell_ice_lament", "|cffffffffSang froid|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Lorsque vous déclenchez ce talent, vos chances d'infliger un coup critique avec votre prochaine technique offensive augmentent de 100%.|r", "spellcoldblood", 422, -185)
CreateSpellButton("buttonSpellImprovedKidneyShot", "Interface/icons/ability_rogue_kidneyshot", "|cffffffffAiguillon perfide amélioré|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Lorsqu'elle est affectée par votre technique Aiguillon perfide,\nla cible subit 9% de points de dégâts supplémentaires de toutes les sources.|r", "spellimprovedkidneyshot", 527, -190)
CreateSpellButton("buttonSpellQuickRecovery", "Interface/icons/ability_rogue_quickrecovery", "|cffffffffRétablissement rapide|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente tous les effets de soins utilisés sur vous de 20%.\nDe plus, vous êtes remboursé de 80% du coût en énergie de vos coups de grâce s’ils ne touchent pas la cible.|r", "spellquickrecovery", 43, -240)
CreateSpellButton("buttonSpellSealFate", "Interface/icons/spell_shadow_chilltouch", "|cffffffffScelle le destin|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Les coups critiques infligés par les techniques qui ajoutent un point de combo ont 100% de chances de\nvous faire gagner un point de combo supplémentaire.|r", "spellsealfate", 150, -240)
CreateSpellButton("buttonSpellMurder", "Interface/icons/spell_shadow_deathscream", "|cffffffffMeurtre|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente tous les dégâts infligés de 4%.|r", "spellmurder", 260, -240)
CreateSpellButton("buttonSpellDeadlyBrew", "Interface/icons/ability_rogue_deadlybrew", "|cffffffffBreuvage mortel|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Quand vous appliquez Poison instantané, douloureux ou de distraction mentale à une cible,\nvous avez 100% de chances d'appliquer Poison affaiblissant.|r", "spelldeadlybrew", 368, -240)
CreateSpellButton("buttonSpellOverkill", "Interface/icons/ability_hunter_rapidkilling", "|cffffffffOutrance meurtrière|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Lorsque vous êtes camouflé et pendant 20 secondes après la fin du camouflage, vous régénérez 30% d'énergie supplémentaire.|r", "spelloverkill", 478, -240)
CreateSpellButton("buttonSpellDeadenedNerves", "Interface/icons/ability_rogue_deadenednerves", "|cffffffffAnesthésie nerveuse|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Réduit tous les dégâts subis de 6%.|r", "spelldeadenednerves", 98, -293)
CreateSpellButton("buttonSpellFocusedAttacks", "Interface/icons/ability_rogue_focusedattacks", "|cffffffffAttaques focalisées|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Vos frappes critiques en mêlée ont 100% de chances de vous donner 2 points d'énergie.|r", "spellfocusedattacks", 205, -293)
CreateSpellButton("buttonSpellFindWeakness", "Interface/icons/ability_rogue_findweakness", "|cffffffffDécouverte des faiblesses|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Dégâts des techniques offensives augmentés de 6%.|r", "spellfindweakness", 315, -293)
CreateSpellButton("buttonSpellMasterPoisoner", "Interface/icons/ability_creature_poison_06", "|cffffffffMaître empoisonneur|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente de 3% les chances de coup critique de toutes les attaques contre une cible que vous avez empoisonnée,\nréduit de 50% la durée de tous les effets de poison appliqués sur vous et confère à Envenimer 100% de chances de ne pas consommer Poison mortel.|r", "spellmasterpoisoner", 422, -293)
CreateSpellButton("buttonSpellMutilate", "Interface/icons/ability_rogue_shadowstrikes", "|cffffffffEstropier|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Attaque instantanément avec les deux armes et inflige 100% des dégâts des armes plus 44 points de dégâts avec chacune d'elles.\nLes dégâts sont augmentés de 20% contre les cibles empoisonnées.\nVous gagnez 2 points de combo.|r", "spellmutilate", 527, -295)
CreateSpellButton("buttonSpellTurntheTables", "Interface/icons/ability_rogue_turnthetables", "|cffffffffRetour à l'envoyeur|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Chaque fois qu'un membre de votre groupe ou raid bloque, esquive ou pare une attaque,\nvos chances de critique avec les actions de combo sont augmentées de 6% pendant 8 seconds.|r", "spellturnthetables", 43, -350)
CreateSpellButton("buttonSpellCuttotheChase", "Interface/icons/ability_rogue_cuttothechase", "|cffffffffTailler dans le vif|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Vos techniques Eviscération et Envenimer ont 100% de chances de réinitialiser la durée de Débiter à son maximum de 5 points de combo.|r", "spellcuttothechase", 260, -350)
CreateSpellButton("buttonSpellHungerForBlood", "Interface/icons/ability_rogue_hungerforblood", "|cffffffffSoif de sang|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Vous fait enrager, ce qui augmente tous les dégâts causés de 5%.\nNécessite qu'un effet de saignement soit actif sur la cible.\nDure 60 seconds.|r", "spellhungerforblood", 150, -350)


CreateSpellButton("buttonSpellImprovedSinisterStrike", "Interface/icons/spell_shadow_ritualofsacrifice", "|cffffffffAttaque pernicieuse améliorée|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Réduit de 5 le coût en énergie de votre technique Attaque pernicieuse.|r", "spellimprovedsinisterstrike", 368, -350)
CreateSpellButton("buttonSpellDualWieldSpecialization", "Interface/icons/ability_dualwield", "|cffffffffSpécialisation Ambidextrie|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente les points de dégâts infligés par l'arme que vous utilisez en main gauche de 50%.|r", "spelldualwieldspecialization", 527, -402)
CreateSpellButton("buttonSpellCrimsonVial", "Interface/icons/ability_rogue_crimsonvial", "|cffffffffFiole cramoisie|r\n|cffffffffTalent|r |cffea0000Assassinat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Vous buvez une décoction alchimique qui vous rend 400% de votre maximum de points de vie en 4 sec.|r", "spelldualcrimsonvial", 478, -350)
CreateSpellButton("buttonSpellImprovedSliceandDice", "Interface/icons/ability_rogue_slicedice", "|cffffffffDébiter amélioré|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente la durée de votre technique Débiter de 50%.|r", "spellimprovedsliceanddice", 98, -405)
CreateSpellButton("buttonSpellDeflection", "Interface/icons/ability_parry", "|cffffffffDéviation|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente vos chances de Parer de 6%.|r", "spelldeflection", 205, -405)
CreateSpellButton("buttonSpellPrecision", "Interface/icons/ability_marksmanship", "|cffffffffPrécision|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente vos chances de toucher avec les armes et les attaques empoisonnées de 5%.|r", "spellprecision", 315, -405)
CreateSpellButton("buttonSpellEndurance", "Interface/icons/spell_shadow_shadowward", "|cffffffffEndurcissement|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Réduit le temps de recharge de vos techniques Sprint et Evasion de 60 sec.\net augmente votre total d'Endurance de 4%.|r", "spellendurance", 422, -405)
CreateSpellButton("buttonSpellRiposte", "Interface/icons/ability_warrior_challange", "|cffffffffRiposte|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Une attaque disponible après avoir paré une attaque de l'adversaire.\nElle inflige 150% des dégâts de l'arme et réduit la vitesse d'attaque en mêlée de la cible de 20% pendant 30 seconds.\nVous gagnez 1 points de combo.|r", "spellriposte", 43, -458)
CreateSpellButton("buttonSpellCloseQuartersCombat", "Interface/icons/inv_weapon_shortblade_05", "|cffffffffCombat rapproché|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente vos chances d'infliger un coup critique avec les Dagues et les Armes de pugilat de 5%.|r", "spellclosequarterscombat", 150, -458)
CreateSpellButton("buttonSpellImprovedKick", "Interface/icons/ability_kick", "|cffffffffCoup de pied amélioré|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Confère à votre technique Coup de pied 100% de chances de rendre la cible muette pendant 2 seconds.|r", "spellimprovedkick", 260, -458)
CreateSpellButton("buttonSpellImprovedSprint", "Interface/icons/ability_rogue_sprint", "|cffffffffSprint amélioré|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Confère 100% de chances d'annuler tous les effets affectant le mouvement lorsque vous activez votre technique Sprint.|r", "spellimprovedsprint", 368, -458)
CreateSpellButton("buttonSpellLightningReflexes", "Interface/icons/spell_nature_invisibilty", "|cffffffffRéflexes éclairs|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente vos chances d'esquiver de 6% et vous octroie un bonus de 10 à la hâte en mêlée.|r", "spelllightningreflexes", 478, -458)
CreateSpellButton("buttonSpellAggression", "Interface/icons/ability_racial_avatar", "|cffffffffAgressivité|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente de 15% les points de dégâts infligés par vos techniques Attaque pernicieuse, Attaque sournoise et Eviscération.|r", "spellaggression", 98, -510)
CreateSpellButton("buttonSpellMaceSpecialization", "Interface/icons/inv_mace_01", "|cffffffffSpécialisation Masse|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Vos attaques avec les masses ignorent jusqu'à 15% de l'armure de votre adversaire.|r", "spellmacespecialization", 205, -510)
CreateSpellButton("buttonSpellBladeFlurry", "Interface/icons/ability_warrior_punishingblow", "|cffffffffDéluge de lames|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente votre vitesse d'attaque de 20%.\nDe plus, vos attaques frappent un adversaire proche supplémentaire.\nDure 15 seconds.|r", "spellbladeflurry", 315, -510)
CreateSpellButton("buttonSpellHackandSlash", "Interface/icons/inv_sword_27", "|cffffffffTaillader et trancher|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Vous confère 5% de chances de bénéficier d'une attaque supplémentaire sur la même cible après avoir frappé votre cible avec votre épée ou votre hache.|r", "spellhackandslash", 422, -510)


CreateSpellButton("buttonSpellWeaponExpertise", "Interface/icons/spell_holy_blessingofstrength", "|cffffffffExpertise en armes|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente votre expertise de 10.|r", "spellweaponexpertise", 663, -75)
CreateSpellButton("buttonSpellBladeTwisting", "Interface/icons/ability_rogue_bladetwisting", "|cffffffffTournoiement de lames|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente de 10% les dégâts infligés par Attaque pernicieuse et Attaque sournoise.\nDe plus, vos attaques en mêlée qui infligent des dégâts ont 10% de chances d'hébéter la cible pendant 8 seconds.|r", "spellbladetwisting", 770, -75)
CreateSpellButton("buttonSpellVitality", "Interface/icons/ability_warrior_revenge", "|cffffffffVitalité|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente votre taux de régénération d'énergie de 25%.|r", "spellvitality", 880, -75)
CreateSpellButton("buttonSpellAdrenalineRush", "Interface/icons/spell_shadow_shadowworddominate", "|cffffffffPoussée d'adrénaline|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente la vitesse de régénération de votre Energie de 100% pendant 15 seconds.|r", "spelladrenalinerush", 990, -75)
CreateSpellButton("buttonSpellNervesofSteel", "Interface/icons/ability_rogue_nervesofsteel", "|cffffffffNerfs d'acier|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Réduit de 30% les dégâts subis lorsque vous êtes affecté par des effets d'étourdissement et de peur.|r", "spellnervesofsteel", 1100, -75)
CreateSpellButton("buttonSpellThrowingSpecialization", "Interface/icons/ability_rogue_throwingspecialization", "|cffffffffSpécialisation Armes de jet|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente la portée de Lancer et Lancer mortel de 4 mètres et confère à votre Lancer mortel 100% de chances d'interrompre la cible pendant 3 seconds.|r", "spellthrowingspecialization", 718, -130)
CreateSpellButton("buttonSpellCombatPotency", "Interface/icons/inv_weapon_shortblade_38", "|cffffffffToute-puissance de combat|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Confère à vos attaques de mêlée avec la main gauche réussies 20% de chances de générer 15 points d'énergie.|r", "spellcombatpotency", 825, -130)
CreateSpellButton("buttonSpellUnfairAdvantage", "Interface/icons/ability_rogue_unfairadvantage", "|cffffffffAvantage déloyal|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Chaque fois que vous esquivez une attaque, vous bénéficiez d'un Avantage déloyal,\nqui vous permet de contre-attaquer en infligeant 100% des dégâts de votre arme en main droite.\nCela ne peut se produire plus d'une fois par seconde.|r", "spellunfairadvantage", 935, -130)
CreateSpellButton("buttonSpellSurpriseAttacks", "Interface/icons/ability_rogue_surpriseattack", "|cffffffffAttaques surprises|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Vos coups de grâce ne peuvent plus être esquivés et les dégâts de vos techniques Attaque pernicieuse, Attaque sournoise,\nKriss, Hémorragie et Suriner sont augmentés de 10%.|r", "spellsurpriseattacks", 1045, -130)
CreateSpellButton("buttonSpellImprovedGouge", "Interface/icons/ability_gouge", "|cffffffffSuriner amélioré|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente la durée de l'effet de votre technique Suriner de 1.5 sec.|r", "spellimprovedgouge", 663, -184)
CreateSpellButton("buttonSpellSavageCombat", "Interface/icons/ability_creature_disease_03", "|cffffffffCombat sauvage|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente votre total de puissance d'attaque de 4% et tous les dégâts physiques infligés aux ennemis que vous avez empoisonnés sont augmentés de 4%.|r", "spellsavagecombat", 770, -184)
CreateSpellButton("buttonSpellPreyontheWeak", "Interface/icons/ability_rogue_preyontheweak", "|cffffffffAttaquer les faibles|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Les dégâts de vos coups critiques sont augmentés de 20% quand la cible a moins de points de vie que vous (en pourcentage du total de points de vie).|r", "spellpreyontheweak", 880, -184)
CreateSpellButton("buttonSpellKillingSpree", "Interface/icons/ability_rogue_murderspree", "|cffffffffSérie meurtrière|r\n|cffffffffTalent|r |cfffd7e00Combat|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Marche à travers les ombres d'ennemi en ennemi se trouvant à moins de 10 mètres et attaque un ennemi toutes les 0,5 sec.\navec les deux armes jusqu'à ce que 5 assauts aient été effectués.\nAugmente tous les dégâts de 20% pendant ce temps.\nPeut toucher la même cible plusieurs fois.\nNe peut pas toucher les cibles invisibles ou camouflées.|r", "spellkillingspree", 990, -184)



CreateSpellButton("buttonSpellRelentlessStrikes", "Interface/icons/ability_warrior_decisivestrike", "|cffffffffFrappes implacables|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Vos coups de grâce ont 20% de chances par point de combo de vous rendre 25 points d'énergie.|r", "spellrelentlessstrikes", 1100, -184)
CreateSpellButton("buttonSpellMasterofDeception", "Interface/icons/spell_shadow_charm", "|cffffffffMaître des illusions|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Réduit les chances de vos ennemis de vous détecter lorsque vous êtes en camouflage.\nPlus efficace que Maître des illusions (Rang 2).|r", "spellmasterofdeception", 718, -240)
CreateSpellButton("buttonSpellOpportunity", "Interface/icons/ability_warrior_warcry", "|cffffffffOpportunité|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente de 20% les dégâts infligés avec vos techniques Attaque sournoise, Estropier, Garrot et Embuscade.|r", "spellopportunity", 825, -240)
CreateSpellButton("buttonSpellSleightofHand", "Interface/icons/ability_rogue_feint", "|cffffffffPasse-passe|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Réduit de 2% la probabilité que vous soyez touché par un coup critique infligé par une attaque en mêlée ou à distance,\net augmente la réduction du niveau de menace de votre technique Feinte de 20%.|r", "spellsleightofhand", 935, -240)
CreateSpellButton("buttonSpellDirtyTricks", "Interface/icons/ability_sap", "|cffffffffCoup tordu|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente la portée de vos techniques Cécité et Assommer de 5 mètres et réduit leur coût en énergie de 50%.|r", "spelldirtytricks", 1045, -240)
CreateSpellButton("buttonSpellCamouflage", "Interface/icons/ability_stealth", "|cffffffffDissimulation|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente de 15% votre vitesse de déplacement lorsque vous êtes camouflé et réduit de 6 sec.\nLe temps de recharge de votre technique Camouflage.|r", "spellcamouflage", 663, -293)
CreateSpellButton("buttonSpellElusiveness", "Interface/icons/spell_magic_lesserinvisibilty", "|cffffffffInsaisissable|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Réduit le temps de recharge de vos techniques Disparition et Cécité de 60 sec.\net de votre technique Cape d'ombre de 30 sec.|r", "spellelusiveness", 770, -293)
CreateSpellButton("buttonSpellGhostlyStrike", "Interface/icons/spell_shadow_curse", "|cffffffffFrappe fantomatique|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Une attaque qui inflige 125% des dégâts de l'arme (1.44% si une dague est équipée) et qui augmente vos chances d'esquiver de 15% pendant 7 seconds.\nVous gagnez 1 point de combo.|r", "spellghostlystrike", 880, -293)
CreateSpellButton("buttonSpellSerratedBlades", "Interface/icons/inv_sword_17", "|cffffffffLames dentelées|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Vos attaques ignorent jusqu'à 9% de l'Armure de votre cible.\nAugmente les dégâts infligés par votre technique Rupture de 30%.|r", "spellserratedblades", 990, -293)
CreateSpellButton("buttonSpellSetup", "Interface/icons/spell_nature_mirrorimage", "|cffffffffPréparatifs|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Vous confère 100% de chances d'ajouter un point de combo à votre cible après avoir esquivé son attaque ou entièrement résisté à un de ses sorts.\nNe peut pas se produire plus d'une fois par seconde.|r", "spellsetup", 1100, -293)
CreateSpellButton("buttonSpellInitiative", "Interface/icons/spell_shadow_fumble", "|cffffffffInitiative|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Vous confère 100% de chances de gagner un point de combo supplémentaire lorsque vous utilisez les techniques Embuscade, Garrot et Coup bas.|r", "spellinitiative", 718, -348)
CreateSpellButton("buttonSpellImprovedAmbush", "Interface/icons/ability_rogue_ambush", "|cffffffffEmbuscade améliorée|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente les chances d'infliger un coup critique avec votre technique Embuscade de 50%.|r", "spellimprovedambush", 825, -348)
CreateSpellButton("buttonSpellHeightenedSenses", "Interface/icons/ability_ambush", "|cffffffffSens amplifiés|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente votre détection du camouflage et réduit de 4% la probabilité que vous soyez touché par les sorts et les attaques à distance.\nPlus efficace que Sens amplifiés (Rang 1).|r", "spellheightenedsenses", 935, -348)
CreateSpellButton("buttonSpellPreparation", "Interface/icons/spell_shadow_antishadow", "|cffffffffPréparation|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Lorsque vous la déclenchez, cette technique met immédiatement fin au temps de recharge de vos techniques Evasion, Sprint, Disparition, Sang froid et Pas de l'ombre.|r", "spellpreparation", 1045, -348)
CreateSpellButton("buttonSpellDirtyDeeds", "Interface/icons/spell_shadow_summonsuccubus", "|cffffffffCoups fourrés|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Réduit de 20 le coût en énergie de vos techniques Coup bas et Garrot.\nDe plus, vos techniques spéciales infligent 20% de dégâts supplémentaires aux cibles qui possèdent moins de 35% de leurs points de vie.|r", "spelldirtydeeds", 663, -402)
CreateSpellButton("buttonSpellHemorrhage", "Interface/icons/spell_shadow_lifedrain", "|cffffffffHémorragie|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Une frappe instantanée qui inflige 110% des dégâts de l'arme (160% si une dague est équipée) à l'adversaire et provoque une hémorragie.\nAugmente tous les dégâts physiques infligés à la cible de 13 au maximum.\nUtilisable 10 fois ou pendant 15 seconds.\nVous gagnez 1 point de combo.|r", "spellhemorrhage", 770, -402)
CreateSpellButton("buttonSpellMasterofSubtlety", "Interface/icons/ability_rogue_masterofsubtlety", "|cffffffffMaître de la discrétion|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Les attaques effectuées alors que vous êtes camouflé et pendant les 6 secondes suivant l'annulation du camouflage infligent 10% de dégâts supplémentaires.|r", "spellmasterofsubtlety", 880, -402)
CreateSpellButton("buttonSpellDeadliness", "Interface/icons/inv_weapon_crossbow_11", "|cffffffffMeurtrier|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente votre puissance d'attaque de 10%.|r", "spelldeadliness", 990, -402)
CreateSpellButton("buttonSpellEnvelopingShadows", "Interface/icons/ability_rogue_envelopingshadows", "|cffffffffLinceul d'ombres|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Réduit les dégâts que vous infligent les attaques à zone d'effet de 30%.|r", "spellenvelopingshadows", 1100, -402)
CreateSpellButton("buttonSpellPremeditation", "Interface/icons/spell_shadow_possession", "|cffffffffPréméditation|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Lorsqu'elle est utilisée, cette technique ajoute 2 points de combo à la cible.\nVous devez ajouter à ces points de combo ou les utiliser avant 20 seconds sinon les points de combo sont perdus.|r", "spellpremeditation", 718, -456)
CreateSpellButton("buttonSpellCheatDeath", "Interface/icons/ability_rogue_cheatdeath", "|cffffffffTrompe-la-mort|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Vous avez 100% de chances qu'une attaque infligeant des dégâts qui devrait normalement vous tuer réduise à 10% votre vie maximale.\nDe plus, réduit tous les dégâts subis jusqu'à 90% pendant 3 seconds (modifié par résilience).\nCet effet ne peut se produire plus d'une fois par minute.|r", "spellcheatdeath", 825, -456)
CreateSpellButton("buttonSpellSinisterCalling", "Interface/icons/ability_rogue_sinistercalling", "|cffffffffVocation pernicieuse|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Augmente votre total d'Agilité de 15% et augmente de 10% supplémentaires le bonus aux dégâts d'Attaque sournoise et Hémorragie.|r", "spellsinistercalling", 935, -456)
CreateSpellButton("buttonSpellWaylay", "Interface/icons/ability_rogue_waylay", "|cffffffffAssaillir|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Vos coups avec Embuscade et Attaque sournoise ont 100% de chances de déséquilibrer la cible,\nce qui augmente le temps entre ses attaques en mêlée et à distance de 20% et réduit sa vitesse de déplacement de 50% pendant 8 seconds.|r", "spellwaylay", 1045, -456)
CreateSpellButton("buttonSpellHonorAmongThieves", "Interface/icons/ability_rogue_honoramongstthieves", "|cffffffffHonneur des voleurs|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Chaque fois qu'un membre de votre groupe réussit un coup critique avec un sort de dégâts ou de soins ou une technique, vous avez 100% de chances de gagner un point de combo sur votre cible actuelle.\nCet effet ne peut se produire plus d'une fois toutes les secondes.|r", "spellhonoramongthieves", 663, -510)
CreateSpellButton("buttonSpellShadowstep", "Interface/icons/ability_rogue_shadowstep", "|cffffffffPas de l'ombre|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Vous tentez de marcher à travers les ombres et de réapparaître derrière votre ennemi.\nVotre vitesse de déplacement est augmentée de 70% pendant 3 seconds.\nLes dégâts de votre prochaine technique sont augmentés de 20% et la menace générée est réduite de 50%.\nDure 10 seconds.|r", "spellshadowstep", 770, -510)
CreateSpellButton("buttonSpellFilthyTricks", "Interface/icons/ability_rogue_wrongfullyaccused", "|cffffffffTours pendables|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Réduit le temps de recharge de 10 sec. et le coût en énergie de 10 de vos techniques Ficelles du métier,\nDistraction et Pas de l'ombre, et le temps de recharge de votre Préparation de 3 min.|r", "spellfilthytricks", 880, -510)
CreateSpellButton("buttonSpellSlaughterfromtheShadows", "Interface/icons/ability_rogue_slaughterfromtheshadows", "|cffffffffOmbres meurtrières|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Réduit de 20 le coût en énergie de vos techniques Attaque sournoise et Embuscade et de 5 le coût en énergie d'Hémorragie.\nAugmente tous les dégâts infligés de 5%.|r", "spellslaughterfromtheshadows", 990, -510)
CreateSpellButton("buttonSpellShadowDance", "Interface/icons/ability_rogue_shadowdance", "|cffffffffDanse de l'ombre|r\n|cffffffffTalent|r |cffffff00Finesse|r\n|cffffffffRequiert|r |cfffff569Voleur|r\n|cffffd100Entame la Danse de l'ombre, qui dure 6 seconds. et permet l'utilisation d'Assommer, Garrot, Embuscade, Coup bas,\nPréméditation, Vol à la tire et Désarmement de piège même sans être camouflé.|r", "spellshadowdance", 1100, -510)




local resetButtonClicked = false

local buttonReset = CreateFrame("Button", "buttonReset", frameTalentRogue, "UIPanelButtonTemplate")
buttonReset:SetSize(85, 25)
buttonReset:SetPoint("BOTTOMRIGHT", buttonTalentRogueClose, "BOTTOMLEFT", -95, 5)
buttonReset:SetText("Réinitialiser")

local function ResetTalents()
    AIO.Handle("TalentRoguespell", "ResetTalents")
    resetButtonClicked = true
end

buttonReset:SetScript("OnClick", ResetTalents)

local buttonReload = CreateFrame("Button", "buttonReload", frameTalentRogue, "UIPanelButtonTemplate")
buttonReload:SetSize(85, 25)
buttonReload:SetPoint("BOTTOMRIGHT", buttonTalentRogueClose, "BOTTOMLEFT", -5, 5)
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
        frameTalentRogue:Hide()
        buttonReload:Hide()
        PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
    else
        frameTalentRogue:Show()
        buttonReload:Show()
        PlaySoundFile(OPEN_TALENT_WINDOW_SOUND)
    end

    talentsWindowOpen = not talentsWindowOpen
end

local playerClass = select(2, UnitClass("player"))
if playerClass == "ROGUE" then
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
        GameTooltip:SetText("|cffffffffTalents|r |cfffff569(Voleur)|r\n\nL'éventail des talents disponibles\npour améliorer et spécialiser\nvotre personnage.")
        GameTooltip:Show()
    end)

    buttonOuvrirTalents:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    buttonOuvrirTalents:SetScript("OnClick", OuvrirFermerInterfaceTalents)
    TalentMicroButton:Hide()
end

RogueHandlers.UpdateTalentCount = function(player, talentsAppris)
    if fontTalentRogueFrameText then
        fontTalentRogueFrameText:SetText(talentsAppris .. " / " .. MAX_TALENTS)
    end
end

RogueHandlers.UpdateTalentPointsUsed = function(player, pointsUsed, pointsBeforeReset)
    print("|cff00ffffVous avez utilisés " .. pointsBeforeReset .. " points avant la réinitialisation des talents|r")
end