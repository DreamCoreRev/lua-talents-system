local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local WarriorHandlers = AIO.AddHandlers("TalentWarriorspell", {})

function WarriorHandlers.ShowTalentWarrior(player)
    frameTalentWarrior:Show()
end

local MAX_TALENTS = 44

local OPEN_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_final_trait_unlocked.ogg"
local CLOSE_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_trait_refund_end.ogg"
local SPELL_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_80_azeritearmor_rotationends_02.ogg"

local frameTalentWarrior = CreateFrame("Frame", "frameTalentWarrior", UIParent)
frameTalentWarrior:SetSize(1200, 650)
frameTalentWarrior:SetMovable(true)
frameTalentWarrior:EnableMouse(true)
frameTalentWarrior:RegisterForDrag("LeftButton")
frameTalentWarrior:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
frameTalentWarrior:SetBackdrop(
{
    bgFile = "interface/TalentFrame/Template/Class/Warrior/talentsclassbackgroundwarrior",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedwarrior",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

local warriorIcon = frameTalentWarrior:CreateTexture("WarriorIcon", "OVERLAY")
warriorIcon:SetTexture("Interface\\TalentFrame\\Template\\Class\\Warrior\\IconeWarrior.blp")
warriorIcon:SetSize(60, 60)
warriorIcon:SetPoint("TOPLEFT", frameTalentWarrior, "TOPLEFT", -10, 10)


local textureone = frameTalentWarrior:CreateTexture("TemplateTalentFrame", "OVERLAY")
textureone:SetTexture("Interface\\TalentFrame\\Template\\Class\\Warrior\\TalentFrameTemplate.blp")
textureone:SetSize(928, 928)
textureone:SetPoint("TOPLEFT", frameTalentWarrior, "TOPLEFT", -170, 140)

frameTalentWarrior:SetFrameLevel(100)

local texturetwo = frameTalentWarrior:CreateTexture("TemplateTalentFrame", "OVERLAY")
texturetwo:SetTexture("Interface\\TalentFrame\\Template\\Class\\Warrior\\TalentFrameTemplateOriginal.blp")
texturetwo:SetSize(928, 928)
texturetwo:SetPoint("TOPRIGHT", frameTalentWarrior, "TOPRIGHT", 170, 140)

frameTalentWarrior:SetFrameLevel(100)

frameTalentWarrior:SetScript("OnDragStart", frameTalentWarrior.StartMoving)
frameTalentWarrior:SetScript("OnHide", frameTalentWarrior.StopMovingOrSizing)
frameTalentWarrior:SetScript("OnDragStop", frameTalentWarrior.StopMovingOrSizing)
frameTalentWarrior:Hide()

frameTalentWarrior:SetBackdropBorderColor(199, 156, 110)

local buttonTalentWarriorClose = CreateFrame("Button", "buttonTalentWarriorClose", frameTalentWarrior, "UIPanelCloseButton")
buttonTalentWarriorClose:SetPoint("TOPRIGHT", -12, -12)
buttonTalentWarriorClose:EnableMouse(true)
buttonTalentWarriorClose:SetSize(32, 32)

local function CloseTalentWindow()
    frameTalentWarrior:Hide()
    PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
end

buttonTalentWarriorClose:SetScript("OnClick", CloseTalentWindow)

local frameTalentWarriorTitleBar = CreateFrame("Frame", "frameTalentWarriorTitleBar", frameTalentWarrior, nil)
frameTalentWarriorTitleBar:SetSize(135, 25)
frameTalentWarriorTitleBar:SetBackdrop(
{
    bgFile = "interface/corrupteditems/corruptedtooltipbackground",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedwarrior",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameTalentWarriorTitleBar:SetPoint("TOP", 0, 20)

local fontTalentWarriorTitleText = frameTalentWarriorTitleBar:CreateFontString("fontTalentWarriorTitleText")
fontTalentWarriorTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontTalentWarriorTitleText:SetSize(190, 5)
fontTalentWarriorTitleText:SetPoint("CENTER", 0, 0)
fontTalentWarriorTitleText:SetText("|cffFFC125Talents|r")

local fontTalentWarriorFrameText = frameTalentWarriorTitleBar:CreateFontString("fontTalentWarriorFrameText")
fontTalentWarriorFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentWarriorFrameText:SetSize(200, 5)
fontTalentWarriorFrameText:SetPoint("TOPLEFT", frameTalentWarriorTitleBar, "BOTTOMLEFT", -30, -35)
fontTalentWarriorFrameText:SetText("|cffFFC125Guerrier|r")

local fontTalentWarriorFrameText = frameTalentWarriorTitleBar:CreateFontString("fontTalentWarriorFrameText")
fontTalentWarriorFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentWarriorFrameText:SetSize(200, 5)
fontTalentWarriorFrameText:SetPoint("TOPLEFT", frameTalentWarriorTitleBar, "BOTTOMLEFT", -30, -60)
fontTalentWarriorFrameText:SetText("0 / " .. MAX_TALENTS)



local function CreateSpellButton(name, texturePath, tooltipText, talentHandler, positionX, positionY)
    local buttonClicked = false
    local talentLearned = false

    local button = CreateFrame("Button", name, frameTalentWarrior, nil)
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
                AIO.Handle("TalentWarriorspell", talentHandler, 1)
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






CreateSpellButton("buttonSpellImprovedHeroicStrike", "Interface/icons/spell_magic_magearmor", "|cffffffffFrappe héroïque améliorée|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit le coût en rage de votre technique Frappe héroïque de 3 points.|r", "spellimprovedheroicstrike", 100, -80)
CreateSpellButton("buttonSpellDeflection", "Interface/icons/ability_parry", "|cffffffffDéviation|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente vos chances de Parer de 5%.|r", "spelldeflection", 205, -75)
CreateSpellButton("buttonSpellImprovedRend", "Interface/icons/ability_gouge", "|cffffffffPourfendre amélioré|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente de 20% les dégâts de saignement infligés par votre technique Pourfendre.|r", "spellimprovedrend", 315, -75)
CreateSpellButton("buttonSpellImproved harge", "Interface/icons/ability_warrior_charge", "|cffffffffCharge améliorée|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente la quantité de Rage générée par votre technique Charge de 10.|r", "spellimprovedcharge", 418, -80)
CreateSpellButton("buttonSpellIronWill", "Interface/icons/spell_magic_magearmor", "|cffffffffVolonté de fer|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit de 20% la durée de tous les effets d'étourdissement et de charme utilisés contre vous.|r", "spellironwill", 45, -130)
CreateSpellButton("buttonSpellTacticalMastery", "Interface/icons/spell_nature_enchantarmor", "|cffffffffMaîtrise tactique|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vous conservez jusqu'à 15 points de rage supplémentaires lorsque vous changez de posture.\nAugmente aussi considérablement la menace générée par vos techniques Sanguinaire et Frappe mortelle quand vous êtes en posture défensive (Plus efficace que le Rang 2).|r", "spelltacticalmastery", 150, -130)
CreateSpellButton("buttonSpellImprovedOverpower", "Interface/icons/inv_sword_05", "|cffffffffFulgurance améliorée|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente de 50% vos chances d'infliger un coup critique avec la technique Fulgurance.|r", "spellimprovedoverpower", 260, -130)
CreateSpellButton("buttonSpellAngerManagement", "Interface/icons/spell_holy_blessingofstamina", "|cffffffffMaîtrise de la Rage|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Génère 1 point de rage toutes les 3 secondes.|r", "spellangermanagement", 370, -130)
CreateSpellButton("buttonSpellImpale", "Interface/icons/ability_searingarrow", "|cffffffffEmpaler|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente de 20% le bonus aux dégâts des coups critiques réussis avec vos techniques.|r", "spellimpale", 475, -133)
CreateSpellButton("buttonSpellDeepWounds", "Interface/icons/ability_backstab", "|cffffffffBlessures profondes|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vos coups critiques font saigner l'adversaire et lui infligent 48% des points de dégâts moyens de votre arme de mêlée en 6 secondes.|r", "spelldeepwounds", 96, -185)
CreateSpellButton("buttonSpellTwoHandedWeaponSpecialization", "Interface/icons/inv_axe_09", "|cffffffffSpécialisation Arme 2M|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente les points de dégâts que vous infligez avec les armes de mêlée à deux mains de 6%.|r", "spelltwohandedweaponspecialization", 205, -185)
CreateSpellButton("buttonSpellTasteforBlood", "Interface/icons/ability_rogue_hungerforblood", "|cffffffffGoût du sang|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Chaque fois que votre technique Pourfendre inflige des dégâts, vous avez 100% de chances de permettre l'utilisation de votre technique Fulgurance pendant 9 secondes.\n1 charge.\nCet effet ne peut se produire plus d'une fois toutes les 6 sec.|r", "spelltasteforblood", 315, -185)
CreateSpellButton("buttonSpellPoleaxeSpecialization", "Interface/icons/inv_axe_06", "|cffffffffSpécialisation Hache d'hast|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente de 5% vos chances d'infliger un coup critique avec les haches et les armes d'hast ainsi que les dégâts de ces critiques.|r", "spellpoleaxespecialization", 422, -185)
CreateSpellButton("buttonSpellSweepingStrikes", "Interface/icons/ability_rogue_slicedice", "|cffffffffAttaques circulaires|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vos 5 prochaines attaques de mêlée frappent un adversaire proche supplémentaire.|r", "spellsweepingstrikes", 527, -190)
CreateSpellButton("buttonSpellMaceSpecialization", "Interface/icons/inv_mace_01", "|cffffffffSpécialisation Masse|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vos attaques avec les masses ignorent jusqu'à 15% de l'armure de votre adversaire.", "spellmacespecialization", 43, -240)
CreateSpellButton("buttonSpellSwordSpecialization", "Interface/icons/inv_sword_27", "|cffffffffSpécialisation Epée|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vous confère 10% de chances de bénéficier d'une attaque supplémentaire sur la même cible après avoir infligé des dégâts avec votre épée.\nCet effet ne survient pas plus d'une fois toutes les 6 secondes.|r", "spellswordspecialization", 150, -240)
CreateSpellButton("buttonSpellWeaponMastery", "Interface/icons/ability_warrior_weaponmastery", "|cffffffffMaîtrise des armes|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit la probabilité que vos attaques soient esquivées de 2% et réduit la durée de tous les effets de désarmement utilisés contre vous de 50%.\nNon cumulable avec les autres effets qui réduisent la durée du désarmement.|r", "spellweaponmastery", 368, -240)
CreateSpellButton("buttonSpellImprovedHamstring", "Interface/icons/ability_shockwave", "|cffffffffBrise-genou amélioré|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Confère à votre technique Brise-genou 15% de chances d'immobiliser votre cible pendant 5 secondes.|r", "spellimprovedhamstring", 478, -240)
CreateSpellButton("buttonSpellTrauma", "Interface/icons/ability_warrior_bloodnova", "|cffffffffTraumatisme|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vos coups critiques normaux en mêlée augmentent l'efficacité des effets de saignement sur la cible de 30% pendant 1 mn.|r", "spelltrauma", 98, -293)
CreateSpellButton("buttonSpellSecondWind", "Interface/icons/ability_hunter_harass", "|cffffffffSecond souffle|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Chaque fois que vous êtes atteint par un effet d'étourdissement ou d'immobilisation, vous gagnez 20 points de rage et 10% de votre total de points de vie en 10 secondes.|r", "spellsecondwind", 205, -293)
CreateSpellButton("buttonSpellMortalStrike", "Interface/icons/ability_warrior_savageblow", "|cffffffffFrappe mortelle|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Une attaque vicieuse qui inflige les dégâts de l'arme plus 85 et blesse la cible.\nL'effet des sorts de soins dont elle est la cible est réduit de 50% pendant 10 secondes.|r", "spellmortalstrike", 315, -293)
CreateSpellButton("buttonSpellStrengthofArms", "Interface/icons/ability_warrior_offensivestance", "|cffffffffForce des armes|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente votre total de Force et d'Endurance de 4% et votre expertise de 4.|r", "spellstrengthofarms", 422, -293)
CreateSpellButton("buttonSpellImprovedSlam", "Interface/icons/ability_warrior_decisivestrike", "|cffffffffHeurtoir amélioré|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit le temps de frappe de votre technique Heurtoir de 1 sec.|r", "spellimprovedslam", 527, -295)
CreateSpellButton("buttonSpellJuggernaut", "Interface/icons/ability_warrior_bullrush", "|cffffffffMastodonte|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Votre technique Charge est à présent utilisable en combat, mais son temps de recharge est augmenté de 5 sec.\nAprès une Charge, votre prochaine technique Heurtoir ou Frappe mortelle bénéficie de 25% de chances supplémentaires d'être critique si elle est utilisée dans les 10 secondes.|r", "spellunrelentingassault", 43, -350)
CreateSpellButton("buttonSpellImprovedMortalStrike", "Interface/icons/ability_warrior_savageblow", "|cffffffffFrappe mortelle améliorée|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente les dégâts infligés par votre technique Frappe mortelle de 10% et réduit le temps de recharge de 1 sec.|r", "spellimprovedmortalstrike", 150, -350)
CreateSpellButton("buttonSpellUnrelentingAssault|r", "Interface/icons/ability_warrior_unrelentingassault", "|cffffffffAssaut continuel|r\n|cffffffffTalent|r |cffc0c0c0Armes|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit le temps de recharge de vos techniques Fulgurance et Vengeance de 4 secondes et augmente les dégâts infligés par ces deux techniques de 20%.\nDe plus, si vous frappez un personnage-joueur avec Fulgurance alors qu'il est en train d'incanter un sort, ses dégâts et soins magiques sont réduits de 50% pendant 6 secondes.|r", "spellgrace", 260, -350)
CreateSpellButton("buttonSpellSuddenDeath", "Interface/icons/ability_warrior_improveddisciplines", "|cffffffffMort soudaine|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vos coups en mêlée ont 9% de chances de permettre l'utilisation d'Exécution quel que soit le montant de points de vie restant à la cible.\nDe plus, vous conservez 10 points de rage après avoir utilisé Exécution.|r", "spellsuddendeath", 368, -350)
CreateSpellButton("buttonSpellEndlessRage", "Interface/icons/ability_warrior_endlessrage", "|cffffffffRage infinie|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vous générez 25% de rage supplémentaires lorsque vous infligez des dégâts.|r", "spellendlessrage", 478, -350)


CreateSpellButton("buttonSpellBloodFrenzy", "Interface/icons/ability_warrior_bloodfrenzy", "|cffffffffFrénésie sanglante|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente votre vitesse d'attaque en mêlée de 10%.\nDe plus, vos techniques Pourfendre et Blessures profondes augmentent aussi tous les dégâts physiques infligés à cette cible de 4%.|r", "spellbloodfrenzy", 98, -405)
CreateSpellButton("buttonSpellWreckingCrew", "Interface/icons/ability_warrior_trauma", "|cffffffffDémolisseurs|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vos coups critiques en mêlée vous font Enrager, ce qui augmente tous les dégâts infligés de 10% pendant 12 secondes.\nCet effet ne se cumule pas avec Enrager.|r", "spellwreckingcrew", 205, -405)
CreateSpellButton("buttonSpellBladestorm", "Interface/icons/ability_warrior_bladestorm", "|cffffffffTempête de lames|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Exécute instantanément une attaque Tourbillon sur un maximum de 4 cibles et pendant les prochaines 6 seconds, vous exécuterez une attaque Tourbillon toutes les 1 sec.\nTant que vous êtes sous l'effet de Tempête de lames, vous pouvez vous déplacer mais vous ne pouvez pas exécuter d'autres techniques.\nCependant, vous ne ressentez ni pitié, ni remords, ni peur et vous ne pouvez être arrêté à moins d'être tué.|r", "spellbladestorm", 315, -405)
CreateSpellButton("buttonSpellArmoredtotheTeeth", "Interface/icons/inv_shoulder_22", "|cffffffffArmé jusqu'aux dents|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente votre puissance d'attaque de 3 pour chaque tranche de 108 points de votre valeur d'armure.|r", "spellarmoredtotheteeth", 422, -405)
CreateSpellButton("buttonSpellBoomingVoice", "Interface/icons/spell_nature_purge", "|cffffffffVoix tonitruante|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente de 50% la zone d'effet et la durée de vos techniques Cri de guerre, Cri démoralisant et Cri de commandement.|r", "spellboomingvoice", 43, -458)
CreateSpellButton("buttonSpellCruelty", "Interface/icons/ability_rogue_eviscerate", "|cffffffffCruauté|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente vos chances d'infliger un coup critique avec les armes de mêlée de 5%.|r", "spellcruelty", 150, -458)
CreateSpellButton("buttonSpellImprovedDemoralizingShout", "Interface/icons/ability_warrior_warcry", "|cffffffffCri démoralisant amélioré|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente la réduction de puissance d'attaque en mêlée de votre Cri démoralisant de 40%.|r", "spellimproveddemoralizingshout", 260, -458)
CreateSpellButton("buttonSpellUnbridledWrath", "Interface/icons/spell_nature_stoneclawtotem", "|cffffffffColère déchaînée|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vous confère une chance de gagner un point de rage supplémentaire quand vous infligez des dégâts en mêlée avec une arme.\nL'effet se produit plus souvent qu'avec Colère déchaînée (Rang 4).|r", "spellunbridledwrath", 368, -458)
CreateSpellButton("buttonSpellImprovedCleave", "Interface/icons/ability_warrior_cleave", "|cffffffffEnchaînement amélioré|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente le bonus de dégâts infligé par votre technique Enchaînement de 120%.|r", "spellimprovedcleave", 478, -458)
CreateSpellButton("buttonSpellPiercingHowl", "Interface/icons/spell_holy_heal02", "|cffffffffHurlement perçant|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Tous les ennemis se trouvant à moins de 10 mètres du guerrier sont hébétés, et leur vitesse de déplacement est réduite de 50% pendant 6 secondes.|r", "spellpiercinghowl", 98, -510)
CreateSpellButton("buttonSpellBloodCraze", "Interface/icons/spell_shadow_summonimp", "|cffffffffFolie sanguinaire|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Régénère 6% de votre nombre total de points de vie sur 6 secondes après avoir reçu un coup critique.|r", "spellbloodcraze", 205, -510)
CreateSpellButton("buttonSpellCommandingPresence", "Interface/icons/spell_nature_focusedmind", "|cffffffffPrésence impérieuse|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente de 25% le bonus à la puissance d'attaque en mêlée de votre Cri de guerre et le bonus aux points de vie de votre Cri de commandement.|r", "spellcommandingpresence", 315, -510)
CreateSpellButton("buttonSpellDualWieldSpecialization", "Interface/icons/ability_dualwield", "|cffffffffSpécialisation Ambidextrie|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente de 25% les points de dégâts infligés par l'arme que vous utilisez en main gauche.|r", "spelldualwieldspecialization", 422, -510)


CreateSpellButton("buttonSpellImprovedExecute", "Interface/icons/inv_sword_48", "|cffffffffExécution améliorée|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit le coût en rage de votre technique Exécution de 5.|r", "spellimprovedexecute", 663, -75)
CreateSpellButton("buttonSpellEnrage", "Interface/icons/spell_holy_surgeoflight", "|cffffffffEnrager|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vous confère 30% de chances de bénéficier d'un bonus aux dégâts en mêlée de 10% pendant 12 secondes lorsque vous êtes victime d'une attaque qui vous inflige des dégâts.\nCet effet ne se cumule pas avec Démolisseurs.|r", "spellenrage", 770, -75)
CreateSpellButton("buttonSpellPrecision", "Interface/icons/ability_marksmanship", "|cffffffffPrécision|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente vos chances de toucher l'ennemi avec vos armes de mêlée de 3%.|r", "spellprecision", 880, -75)
CreateSpellButton("buttonSpellDeathWish", "Interface/icons/spell_shadow_deathpact", "|cffffffffSouhait mortel|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Lorsque cette technique est activée, vous enragez et vos dégâts physiques sont augmentés de 20%, mais tous les dégâts subis sont augmentés de 5%.\nDure 30 secondes.|r", "spelldeathwish", 990, -75)
CreateSpellButton("buttonSpellImprovedIntercept", "Interface/icons/ability_rogue_sprint", "|cffffffffInterception améliorée|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit le temps de recharge de votre technique Interception de 10 sec.|r", "spellimprovedintercept", 1100, -75)
CreateSpellButton("buttonSpellImprovedBerserkerRage", "Interface/icons/spell_nature_ancestralguardian", "|cffffffffRage berserker améliorée|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100La technique Rage berserker génère 20 points de rage quand elle est utilisée.|r", "spellimprovedberserkerrage", 718, -130)
CreateSpellButton("buttonSpellFlurry", "Interface/icons/ability_ghoulfrenzy", "|cffffffffRafale|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Lorsque vous infligez un coup critique en mêlée, augmente votre vitesse d'attaque de 25% pour les 3 prochains coups.|r", "spellflurry", 825, -130)
CreateSpellButton("buttonSpellIntensifyRage", "Interface/icons/ability_warrior_endlessrage", "|cffffffffIntensifier la rage|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit le temps de recharge de vos techniques Rage sanguinaire, Rage berserker, Témérité et Souhait mortel de 33%.|r", "spellintensifyrage", 935, -130)
CreateSpellButton("buttonSpellBloodthirst", "Interface/icons/spell_nature_bloodlust", "|cffffffffSanguinaire|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Attaque instantanément la cible et lui inflige 577 points de dégâts.\nDe plus, les 3 prochaines attaques de mêlée réussies rendent 1% du maximum de points de vie.\nCet effet dure 8 seconds.\nLes dégâts sont proportionnels à votre puissance d'attaque.|r", "spellbloodthirst", 1045, -130)
CreateSpellButton("buttonSpellImprovedWhirlwind", "Interface/icons/ability_whirlwind", "|cffffffffTourbillon amélioré|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente les dégâts de votre technique Tourbillon de 20%.|r", "spellimprovedwhirlwind", 663, -184)
CreateSpellButton("buttonSpellFuriousAttacks", "Interface/icons/ability_warrior_furiousresolve", "|cffffffffAttaques furieuses|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vos attaques de mêlée normales ont une chance de réduire tous les soins prodigués à la cible de 25% pendant 10 secondes.\nCet effet est cumulable jusqu'à 2 fois.\nSe produit plus souvent qu'Attaques furieuses (Rang 1).|r", "spellfuriousattacks", 770, -184)
CreateSpellButton("buttonSpellImprovedBerserkerStance", "Interface/icons/ability_racial_avatar", "|cffffffffPosture berserker améliorée|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente la Force de 20% et réduit la menace générée de 10% lorsque vous êtes en posture berserker.|r", "spellimprovedberserkerstance", 880, -184)
CreateSpellButton("buttonSpellHeroicFury", "Interface/icons/ability_heroicleap", "|cffffffffFureur héroïque|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Dissipe tous les effets d'immobilisation et met fin au temps de recharge de votre technique Interception.|r", "spellheroicfury", 990, -184)
CreateSpellButton("buttonSpellRampage", "Interface/icons/ability_warrior_rampage", "|cffffffffSaccager|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente de 5% les chances de coup critique en mêlée et à distance de tous les membres du groupe ou raid se trouvant à moins de 100 mètres.", "spellrampage", 1100, -184)



CreateSpellButton("buttonSpellBloodsurge", "Interface/icons/ability_warrior_bloodsurge", "|cffffffffAfflux sanguin|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vos coups réussis avec Frappe héroïque, Sanguinaire et Tourbillon ont 20% de chances de rendre votre prochain Heurtoir instantané pendant 5 secondes.|r", "spellbloodsurge", 718, -240)
CreateSpellButton("buttonSpellUnendingFury", "Interface/icons/ability_warrior_intensifyrage", "|cffffffffFureur sans fin|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente les dégâts infligés par vos techniques Heurtoir, Tourbillon et Sanguinaire de 10%.|r", "spellunendingfury", 825, -240)
CreateSpellButton("buttonSpellTitansGrip", "Interface/icons/ability_warrior_titansgrip", "|cffffffffPoigne du titan|r\n|cffffffffTalent|r |cff9e604eFureur|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vous permet de manier les haches, les masses et les épées à deux mains d’une seule main.\nLorsque vous portez une arme à deux mains d'une seule main, les dégâts physiques que vous infligez sont réduits de 10%.|r", "spelltitansgrip", 935, -240)
CreateSpellButton("buttonSpellImprovedBloodrage", "Interface/icons/ability_racial_bloodrage", "|cffffffffRage sanguinaire améliorée|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente la rage instantanée générée par votre technique Rage sanguinaire de 50%.|r", "spellimprovedbloodrage", 1045, -240)
CreateSpellButton("buttonSpellShieldSpecialization", "Interface/icons/inv_shield_06", "|cffffffffSpécialisation Bouclier|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente de 5% vos chances de bloquer les attaques avec un bouclier, avec 100% de chances de générer 5 points de Rage quand vous bloquez, esquivez ou parez.|r", "spellshieldspecialization", 663, -293)
CreateSpellButton("buttonSpellImprovedThunderClap", "Interface/icons/ability_thunderclap", "|cffffffffCoup de tonnerre amélioré|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit le coût de votre technique Coup de tonnerre de 4 points de rage et augmente les dégâts de 30% et l'effet de ralentissement de 10% supplémentaires.|r", "spellimprovedthunderclap", 770, -293)
CreateSpellButton("buttonSpellIncite", "Interface/icons/ability_warrior_incite", "|cffffffffEmulation|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente de 15% vos chances de réaliser un coup critique avec les techniques Frappe héroïque, Coup de tonnerre et Enchaînement.|r", "spellincite", 990, -293)
CreateSpellButton("buttonSpellAnticipation", "Interface/icons/spell_nature_mirrorimage", "|cffffffffAnticipation|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente vos chances d'esquiver une attaque de 5%.|r", "spellanticipation", 1100, -293)
CreateSpellButton("buttonSpellLastStand", "Interface/icons/spell_holy_ashestoashes", "|cffffffffDernier rempart|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Activée, cette technique vous confère temporairement 30% de votre maximum de points de vie en plus pendant 20 secondes.\nLorsque l'effet expire, les points de vie sont perdus.|r", "spelllaststand", 718, -348)
CreateSpellButton("buttonSpellImprovedRevenge", "Interface/icons/ability_warrior_revenge", "|cffffffffVengeance améliorée|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente les dégâts de votre technique Vengeance de 60% et permet à Vengeance de frapper une cible supplémentaire.|r", "spellimprovedrevenge", 825, -348)
CreateSpellButton("buttonSpellShieldMastery", "Interface/icons/ability_warrior_shieldmastery", "|cffffffffMaîtrise du bouclier|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente de 30% votre valeur de blocage et réduit de 20 sec.\nle temps de recharge de votre technique Maîtrise du blocage.|r", "spellshieldmastery", 935, -348)
CreateSpellButton("buttonSpellToughness", "Interface/icons/spell_holy_devotion", "|cffffffffRésistance|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente la valeur d'armure des objets de 10% et réduit la durée de tous les effets affectant le déplacement de 30%.|r", "spelltoughness", 1045, -348)
CreateSpellButton("buttonSpellImprovedSpellReflection", "Interface/icons/ability_warrior_shieldreflection", "|cffffffffRenvoi de sort amélioré|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit la probabilité que vous soyez touché par les sorts de 4%,\net quand la technique est utilisée, elle renvoie le premier sort lancé contre les 4 membres du groupe les plus proches se trouvant à moins de 20 mètres.|r", "spellimprovedspellreflection", 663, -402)
CreateSpellButton("buttonSpellImprovedDisarm", "Interface/icons/ability_warrior_disarm", "|cffffffffDésarmement amélioré|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit le temps de recharge de votre technique Désarmement de 20 secondes et fait subir à la cible 10% de dégâts supplémentaires quand elle est désarmée.|r", "spellimproveddisarm", 770, -402)
CreateSpellButton("buttonSpellPuncture", "Interface/icons/ability_warrior_sunder", "|cffffffffPercer|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit le coût en rage de vos techniques Fracasser armure et Dévaster de 3.|r", "spellpuncture", 880, -402)
CreateSpellButton("buttonSpellImprovedDisciplines", "Interface/icons/ability_warrior_shieldwall", "|cffffffffDisciplines améliorées|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit le temps de recharge de vos techniques Mur protecteur, Représailles et Témérité de 60 sec.|r", "spellimproveddisciplines", 990, -402)
CreateSpellButton("buttonSpellConcussionBlow", "Interface/icons/ability_thunderbolt", "|cffffffffCoup traumatisant|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Etourdit l'adversaire pendant 5 seconds et lui inflige 435 points de dégâts (en fonction de la puissance d'attaque).|r", "spellconcussionblow", 1100, -402)
CreateSpellButton("buttonSpellGagOrder", "Interface/icons/ability_warrior_shieldbash", "|cffffffffImposition du silence|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Confère à vos techniques Coup de bouclier et Lancer héroïque 100% de chances de réduire la cible au silence pendant 3 seconds et augmente les dégâts de votre technique Heurt de bouclier de 10%.|r", "spellgagorder", 718, -456)
CreateSpellButton("buttonSpellFear", "Interface/icons/spell_shadow_possession", "|cffffffffPeur|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Effraie un ennemi et l'oblige à fuir pendant 4 seconds.\nVous ne pouvez effrayer qu'une seule cible à la fois.|r", "spellfear", 825, -456)
CreateSpellButton("buttonSpellImprovedDefensiveStance", "Interface/icons/ability_warrior_defensivestance", "|cffffffffPosture défensive améliorée|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Lorsque vous êtes en posture défensive, tous les dégâts des sorts sont réduits de 6% et lorsque vous parez, bloquez ou esquivez une attaque,\nvous avez 100% de chances d'enrager, ce qui augmente les dégâts physiques infligés de 10% pendant 12 secondes.|r", "spellimproveddefensivestance", 935, -456)
CreateSpellButton("buttonSpellVigilance", "Interface/icons/ability_warrior_vigilance", "|cffffffffVigilance|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Focalise votre regard protecteur sur une cible appartenant au groupe ou raid, ce qui réduit les dégâts qu'elle subit de 3% et vous transfère -10% de la menace qu'elle génère.\nDe plus, chaque fois qu'elle est touchée par une attaque, le temps de recharge de votre Provocation prend fin.\nDure 30 mn.\nUne seule cible à la fois peut bénéficier de cet effet.|r", "spellvigilance", 1045, -456)
CreateSpellButton("buttonSpellFocusedRage", "Interface/icons/ability_warrior_focusedrage", "|cffffffffRage focalisée|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit le coût en rage de vos techniques offensives de 3.|r", "spellfocusedrage", 663, -510)
CreateSpellButton("buttonSpellVitality", "Interface/icons/inv_helmet_21", "|cffffffffVitalité|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente votre total de Force de 6%, d'Endurance de 9% et votre expertise de 6.|r", "spellvitality", 770, -510)
CreateSpellButton("buttonSpellSafeguard", "Interface/icons/ability_warrior_safeguard", "|cffffffffProtéger|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Réduit les dégâts subis par la cible de votre technique Intervention de 30% pendant 6 seconds.|r", "spellsafeguard", 880, -510)
CreateSpellButton("buttonSpellWarbringer", "Interface/icons/ability_warrior_warbringer", "|cffffffffPorteguerre|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vos techniques Charge, Interception et Intervention sont à présent utilisables en combat et avec n'importe quelle posture.\nDe plus, Intervention dissipe tous les effets affectant le déplacement.|r", "spellwarbringer", 990, -510)
CreateSpellButton("buttonSpellDevastate", "Interface/icons/inv_sword_11", "|cffffffffDévaster|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Fracasse l'armure de la cible, provoquant l'effet Fracasser armure.\nDe plus, inflige 120% des dégâts de l'arme plus 58 pour chaque Fracasser armure sur la cible.\nL'effet de fracassement d'armure peut être cumulé jusqu'à 5 fois.|r", "spelldevastate", 1100, -510)
CreateSpellButton("buttonSpellCriticalBlock", "Interface/icons/ability_warrior_criticalblock", "|cffffffffBlocage critique|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Vos blocages réussis ont 60% de chances de bloquer le double du montant normal.\nAugmente vos chances d'infliger un coup critique avec votre technique Heurt de bouclier de 15% supplémentaires.|r", "spellcriticalblock", 716, -564)
CreateSpellButton("buttonSpellSwordandBoard", "Interface/icons/ability_warrior_swordandboard", "|cffffffffEpée et bouclier|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Augmente les chances de coup critique de votre technique Dévaster de 15%, et quand votre technique Dévaster ou Vengeance inflige des dégâts,\nelle a 30% de chances de mettre fin au temps de recharge de votre technique Heurt de bouclier et de réduire son coût de 100% pendant 5 secondes.|r", "spellswordandboard", 824, -564)
CreateSpellButton("buttonSpellDamageShield", "Interface/icons/inv_shield_31", "|cffffffffBouclier de dégâts|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Chaque fois qu'une attaque en mêlée vous inflige des dégâts ou que vous la bloquez, vous infligez un montant de dégâts égal à 20% de votre valeur de blocage.|r", "spelldamageshield", 934, -564)
CreateSpellButton("buttonSpellShockwave", "Interface/icons/ability_warrior_shockwave", "|cffffffffOnde de choc|r\n|cffffffffTalent|r |cff03c0cfProtection|r\n|cffffffffRequiert|r |cffc79c6eGuerrier|r\n|cffffd100Projette une onde de force devant le guerrier, qui inflige 879 points de dégâts (en fonction de la puissance d'attaque)\net étourdit toutes les cibles ennemies se trouvant à moins de 10 mètres dans un cône devant lui pendant 4 secondes.|r", "spellshockwave", 1045, -564)



local resetButtonClicked = false

local buttonReset = CreateFrame("Button", "buttonReset", frameTalentWarrior, "UIPanelButtonTemplate")
buttonReset:SetSize(85, 25)
buttonReset:SetPoint("BOTTOMRIGHT", buttonTalentWarriorClose, "BOTTOMLEFT", -95, 5)
buttonReset:SetText("Réinitialiser")

local function ResetTalents()
    AIO.Handle("TalentWarriorspell", "ResetTalents")
    resetButtonClicked = true
end

buttonReset:SetScript("OnClick", ResetTalents)

local buttonReload = CreateFrame("Button", "buttonReload", frameTalentWarrior, "UIPanelButtonTemplate")
buttonReload:SetSize(85, 25)
buttonReload:SetPoint("BOTTOMRIGHT", buttonTalentWarriorClose, "BOTTOMLEFT", -5, 5)
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
        frameTalentWarrior:Hide()
        buttonReload:Hide()
        PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
    else
        frameTalentWarrior:Show()
        buttonReload:Show()
        PlaySoundFile(OPEN_TALENT_WINDOW_SOUND)
    end

    talentsWindowOpen = not talentsWindowOpen
end

local playerClass = select(2, UnitClass("player"))
if playerClass == "WARRIOR" then
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
        GameTooltip:SetText("|cffffffffTalents|r |cffc79c6e(Guerrier)|r\n\nL'éventail des talents disponibles\npour améliorer et spécialiser\nvotre personnage.")
        GameTooltip:Show()
    end)

    buttonOuvrirTalents:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    buttonOuvrirTalents:SetScript("OnClick", OuvrirFermerInterfaceTalents)
    TalentMicroButton:Hide()
end

WarriorHandlers.UpdateTalentCount = function(player, talentsAppris)
    if fontTalentWarriorFrameText then
        fontTalentWarriorFrameText:SetText(talentsAppris .. " / " .. MAX_TALENTS)
    end
end

WarriorHandlers.UpdateTalentPointsUsed = function(player, pointsUsed, pointsBeforeReset)
    print("|cff00ffffVous avez utilisés " .. pointsBeforeReset .. " points avant la réinitialisation des talents|r")
end