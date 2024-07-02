local AIO = AIO or require("AIO")
if AIO.AddAddon() then
    return
end

local HerosHandlers = AIO.AddHandlers("TalentHerosspell", {})

function HerosHandlers.ShowTalentHeros(player)
    frameTalentHeros:Show()
end

local MAX_TALENTS = 6

local OPEN_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_final_trait_unlocked.ogg"
local CLOSE_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_72_artifact_forge_trait_refund_end.ogg"
local SPELL_TALENT_WINDOW_SOUND = "Sound\\TalentsSystem\\ui_80_azeritearmor_rotationends_02.ogg"

local frameTalentHeros = CreateFrame("Frame", "frameTalentHeros", UIParent)
frameTalentHeros:SetSize(1200, 650)
frameTalentHeros:SetMovable(true)
frameTalentHeros:EnableMouse(true)
frameTalentHeros:RegisterForDrag("LeftButton")
frameTalentHeros:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 50, -50)
frameTalentHeros:SetBackdrop(
{
    bgFile = "interface/TalentFrame/Template/Class/Heros/talentsclassbackgroundheros2",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedheros",
    edgeSize = 20,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})

local heroIcon = frameTalentHeros:CreateTexture("HerosIcon", "OVERLAY")
heroIcon:SetTexture("Interface\\TalentFrame\\Template\\Class\\Heros\\IconeHeros.blp")
heroIcon:SetSize(60, 60)
heroIcon:SetPoint("TOPLEFT", frameTalentHeros, "TOPLEFT", -10, 10)


local textureone = frameTalentHeros:CreateTexture("TemplateTalentFrame", "OVERLAY")
textureone:SetTexture("Interface\\TalentFrame\\Template\\Class\\Heros\\TalentFrameTemplate.blp")
textureone:SetSize(928, 928)
textureone:SetPoint("TOPLEFT", frameTalentHeros, "TOPLEFT", -150, 220)

frameTalentHeros:SetFrameLevel(100)

local texturetwo = frameTalentHeros:CreateTexture("TemplateTalentFrame", "OVERLAY")
texturetwo:SetTexture("Interface\\TalentFrame\\Template\\Class\\Heros\\TalentFrameTemplateOriginal.blp")
texturetwo:SetSize(928, 928)
texturetwo:SetPoint("TOPRIGHT", frameTalentHeros, "TOPRIGHT", 150, 110)

frameTalentHeros:SetBackdropBorderColor(253, 197, 184)

frameTalentHeros:SetScript("OnDragStart", frameTalentHeros.StartMoving)
frameTalentHeros:SetScript("OnHide", frameTalentHeros.StopMovingOrSizing)
frameTalentHeros:SetScript("OnDragStop", frameTalentHeros.StopMovingOrSizing)
frameTalentHeros:Hide()

frameTalentHeros:SetBackdropBorderColor(135, 135, 237)

local buttonTalentHerosClose = CreateFrame("Button", "buttonTalentHerosClose", frameTalentHeros, "UIPanelCloseButton")
buttonTalentHerosClose:SetPoint("TOPRIGHT", -12, -12)
buttonTalentHerosClose:EnableMouse(true)
buttonTalentHerosClose:SetSize(32, 32)

local function CloseTalentWindow()
    frameTalentHeros:Hide()
    PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
end

buttonTalentHerosClose:SetScript("OnClick", CloseTalentWindow)

local frameTalentHerosTitleBar = CreateFrame("Frame", "frameTalentHerosTitleBar", frameTalentHeros, nil)
frameTalentHerosTitleBar:SetSize(135, 25)
frameTalentHerosTitleBar:SetBackdrop(
{
    bgFile = "interface/corrupteditems/corruptedtooltipbackground",
    edgeFile = "interface/tooltips/ui-tooltip-border-corruptedheros",
    tile = true,
    edgeSize = 16,
    tileSize = 16,
    insets = { left = 5, right = 5, top = 5, bottom = 5 }
})
frameTalentHerosTitleBar:SetPoint("TOP", 0, 20)

local fontTalentHerosTitleText = frameTalentHerosTitleBar:CreateFontString("fontTalentHerosTitleText")
fontTalentHerosTitleText:SetFont("Fonts\\FRIZQT__.TTF", 13)
fontTalentHerosTitleText:SetSize(190, 5)
fontTalentHerosTitleText:SetPoint("CENTER", 0, 0)
fontTalentHerosTitleText:SetText("|cffFFC125Talents|r")

local fontTalentHerosFrameText = frameTalentHerosTitleBar:CreateFontString("fontTalentHerosFrameText")
fontTalentHerosFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentHerosFrameText:SetSize(200, 5)
fontTalentHerosFrameText:SetPoint("TOPLEFT", frameTalentHerosTitleBar, "BOTTOMLEFT", -30, -35)
fontTalentHerosFrameText:SetText("|cffFFC125Héros|r")

local fontTalentHerosFrameText = frameTalentHerosTitleBar:CreateFontString("fontTalentHerosFrameText")
fontTalentHerosFrameText:SetFont("Fonts\\FRIZQT__.TTF", 18)
fontTalentHerosFrameText:SetSize(200, 5)
fontTalentHerosFrameText:SetPoint("TOPLEFT", frameTalentHerosTitleBar, "BOTTOMLEFT", -30, -60)
fontTalentHerosFrameText:SetText("0 / " .. MAX_TALENTS)



local function CreateSpellButton(name, texturePath, tooltipText, talentHandler, positionX, positionY)
    local buttonClicked = false
    local talentLearned = false

    local button = CreateFrame("Button", name, frameTalentHeros, nil)
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
                AIO.Handle("TalentHerosspell", talentHandler, 1)
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





CreateSpellButton("buttonSpellBerserker", "Interface/icons/ability_warrior_intensifyrage", "|cffffffffBerserker\n|cffffffffTalent |cffe26a5dForce\n|cffffffffRequiert |cfffdc5b8Heros\n|cffffff00Augmente tous les dégâts infligés de 25%\n|cffffff00et tous les dégâts subis de 10%.", "spellbeserker", 170, -270)
CreateSpellButton("buttonSpellRallyingCry", "Interface/icons/Ability_Warrior_RallyingCry", "|cffffffffCri de ralliement\n|cffffffffTalent |cffe26a5dForce\n|cffffffffRequiert |cfffdc5b8Heros\n|cffffff00Le héros crie et augmente de 130 la puissance d'attaque de tous les membres du groupe\n|cffffff00et du raid dans un rayon de 30 mètres. Dure 2 min.", "spellrallyingcry", 280, -270)
CreateSpellButton("buttonSpellSpeed", "Interface/icons/warrior_talent_icon_blitz", "|cffffffffVitesse\n|cffffffffTalent |cffe7e384Adresse\n|cffffffffRequiert |cfffdc5b8Heros\n|cffffff00Augmente la vitesse de déplacement du héros de 40% pendant 15 secondes.\n|cffffff00N'interrompt pas le camouflage.", "spellspeed", 390, -270)
CreateSpellButton("buttonSpellRuse", "Interface/icons/ability_rogue_vigor", "|cffffffffRuse\n|cffffffffTalent |cffe7e384Adresse\n|cffffffffRequiert |cfffdc5b8Heros\n|cffffff00Camouflé pendant 15 secondes.", "spellruse", 225, -323)
CreateSpellButton("buttonSpellDisengage", "Interface/icons/ability_racial_rocketjump", "|cffffffffDésengagement\n|cffffffffTalent |cffe7e384Adresse\n|cffffffffRequiert |cfffdc5b8Heros\n|cffffff00Retirez tous les pièges et partez en voûte.\n|cffffff00Les ennemis proches subissent 13.13% de la puissance d'attaque de dégâts physiques\n|cffffff00et voient leur vitesse de déplacement réduite de 70% pendant 3 sec.", "spelldisengage", 335, -323)


CreateSpellButton("buttonSpellLightningStrike", "Interface/icons/ability_thunderking_lightningwhip", "|cffffffffFoudre\n|cffffffffTalent |cff00bfffVolonté\n|cffffffffRequiert |cfffdc5b8Heros\n|cffffff00Inflige 6657 points de dégâts et rebondit jusqu'à 10 cibles.", "spelllightningstrike", 805, -268)
CreateSpellButton("buttonSpellFireball", "Interface/icons/Spell_Fire_FireBolt", "|cffffffffBoule de feu\n|cffffffffTalent |cff00bfffVolonté\n|cffffffffRequiert |cfffdc5b8Heros\n|cffffff00Projette une boule ardente qui inflige 6657 à 6791 points de dégâts de Feu et 60 points de dégâts de Feu supplémentaires en 8 seconds.", "spellfireball", 915, -268)
CreateSpellButton("buttonSpellFrostball", "Interface/icons/Spell_Fire_BlueFlameBolt", "|cffffffffBoule de givre\n|cffffffffTalent |cff00bfffVolonté\n|cffffffffRequiert |cfffdc5b8Heros\n|cffffff00Lance un boule de givre sur l'ennemi, lui inflige de 6889 à 6923 points de dégâts de Givre et réduit sa vitesse de déplacement de 40% pendant 9 seconds.", "spellfrostball", 750, -323)
CreateSpellButton("buttonSpellDivinefury", "Interface/icons/Spell_DeathKnight_IceBoundFortitude", "|cffffffffFureur divine\n|cffffffffTalent |cff00bfffVolonté\n|cffffffffRequiert |cfffdc5b8Heros\n|cffffff00Des éclats de givre s'abattent sur la zone ciblée et infligent 3792 points de dégâts de Givre en 8 seconds.", "spelldivinefury", 860, -323)
CreateSpellButton("buttonSpellIgnition", "Interface/icons/Ability_Mage_FireStarter", "|cffffffffEmbrasement\n|cffffffffTalent |cff00bfffVolonté\n|cffffffffRequiert |cfffdc5b8Heros\n|cffffff00Projette la cible de 100m et inflige 3985 points de dégâts de Feu toutes les 3 sec.", "spellignition", 970, -323)



local resetButtonClicked = false

local buttonReset = CreateFrame("Button", "buttonReset", frameTalentHeros, "UIPanelButtonTemplate")
buttonReset:SetSize(85, 25)
buttonReset:SetPoint("BOTTOMRIGHT", buttonTalentHerosClose, "BOTTOMLEFT", -95, 5)
buttonReset:SetText("Réinitialiser")

local function ResetTalents()
    AIO.Handle("TalentHerosspell", "ResetTalents")
    resetButtonClicked = true
end

buttonReset:SetScript("OnClick", ResetTalents)

local buttonReload = CreateFrame("Button", "buttonReload", frameTalentHeros, "UIPanelButtonTemplate")
buttonReload:SetSize(85, 25)
buttonReload:SetPoint("BOTTOMRIGHT", buttonTalentHerosClose, "BOTTOMLEFT", -5, 5)
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
        frameTalentHeros:Hide()
        buttonReload:Hide()
        PlaySoundFile(CLOSE_TALENT_WINDOW_SOUND)
    else
        frameTalentHeros:Show()
        buttonReload:Show()
        PlaySoundFile(OPEN_TALENT_WINDOW_SOUND)
    end

    talentsWindowOpen = not talentsWindowOpen
end

local playerClass = select(2, UnitClass("player"))
if playerClass == "HERO" then
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
        GameTooltip:SetText("|cffffffffTalents|r |cfffdc5b8(Héros)|r\n\nL'éventail des talents disponibles\npour améliorer et spécialiser\nvotre personnage.")
        GameTooltip:Show()
    end)

    buttonOuvrirTalents:SetScript("OnLeave", function(self)
        GameTooltip:Hide()
    end)

    buttonOuvrirTalents:SetScript("OnClick", OuvrirFermerInterfaceTalents)
    TalentMicroButton:Hide()
end

HerosHandlers.UpdateTalentCount = function(player, talentsAppris)
    if fontTalentHerosFrameText then
        fontTalentHerosFrameText:SetText(talentsAppris .. " / " .. MAX_TALENTS)
    end
end

HerosHandlers.UpdateTalentPointsUsed = function(player, pointsUsed, pointsBeforeReset)
    print("|cff00ffffVous avez utilisés " .. pointsBeforeReset .. " points avant la réinitialisation des talents|r")
end