--============================================================
-- DEEP DUELS - INTRO + SCRIPT PRINCIPAL
--============================================================

--============================================================
-- DEEP DUELS - SOMENTE STEAL A BRAINROT
-- Universe ID: 7709344486 | Place ID principal: 109983668079237
--============================================================
repeat task.wait() until game:IsLoaded()
if game.GameId ~= 7709344486 and game.PlaceId ~= 109983668079237 then
    warn("[DEEP DUELS] Este script só funciona no Steal a Brainrot.")
    return
end

--============================================================
-- DEEP HUB MR - INTRO CINEMATIC B&W
--============================================================

local function runDeepDuelsIntro()
    local skipped=false
    local cleaned=false

    local Players       = game:GetService("Players")
    local SoundService  = game:GetService("SoundService")
    local TweenService  = game:GetService("TweenService")
    local Lighting      = game:GetService("Lighting")

    local player    = Players.LocalPlayer
    local playerGui = player:WaitForChild("PlayerGui")

    -- ===== CLEANUP =====
    for _, v in ipairs(playerGui:GetChildren()) do
        if v.Name == "DeepHubMrIntroGui" then v:Destroy() end
    end
    for _, v in ipairs(SoundService:GetChildren()) do
        if v.Name == "DeepHubMrIntroMusic" then v:Destroy() end
    end

    -- ===== MUSIC =====
    local music = Instance.new("Sound")
    music.Name          = "DeepHubMrIntroMusic"
    music.SoundId       = "rbxassetid://108626632719375"
    music.Volume        = 3
    music.Looped        = false
    music.PlaybackSpeed = 1
    music.Parent        = SoundService
    music:Play()

    -- ===== GUI =====
    local gui = Instance.new("ScreenGui")
    gui.Name           = "DeepHubMrIntroGui"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn   = false
    gui.DisplayOrder   = 999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent         = playerGui

    local function cleanupIntro()
        if cleaned then return end
        cleaned=true

        pcall(function()
            if gui and gui.Parent then gui:Destroy() end
        end)

        pcall(function()
            if music then
                music:Stop()
                music:Destroy()
            end
        end)
    end

    local function introWait(seconds)
        local started=os.clock()
        while (os.clock()-started)<seconds do
            if skipped then return false end
            task.wait(0.03)
        end
        return not skipped
    end

    local skipButton=Instance.new("TextButton")
    skipButton.Name="SkipIntro"
    skipButton.AnchorPoint=Vector2.new(1,0)
    skipButton.Size=UDim2.new(0,138,0,36)
    skipButton.Position=UDim2.new(1,-24,0,24)
    skipButton.BackgroundColor3=Color3.fromRGB(0,0,0)
    skipButton.BackgroundTransparency=0.15
    skipButton.BorderSizePixel=0
    skipButton.Text="PULAR INTRO"
    skipButton.TextColor3=Color3.fromRGB(255,255,255)
    skipButton.TextSize=13
    skipButton.Font=Enum.Font.GothamBold
    skipButton.ZIndex=100
    skipButton.Parent=gui

    local skipCorner=Instance.new("UICorner")
    skipCorner.CornerRadius=UDim.new(0,8)
    skipCorner.Parent=skipButton

    local skipStroke=Instance.new("UIStroke")
    skipStroke.Color=Color3.fromRGB(255,255,255)
    skipStroke.Thickness=1.5
    skipStroke.Transparency=0.25
    skipStroke.Parent=skipButton

    skipButton.Activated:Connect(function()
        if skipped then return end
        skipped=true
        cleanupIntro()
    end)

    -- ===== BACKGROUND LAYERS =====

    -- Base black bg
    local bg = Instance.new("Frame")
    bg.Size                   = UDim2.new(1, 0, 1, 0)
    bg.BackgroundColor3       = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 1
    bg.BorderSizePixel        = 0
    bg.Parent                 = gui

    -- Radial gradient overlay (vignette)
    local vignette = Instance.new("Frame")
    vignette.Size                   = UDim2.new(1, 0, 1, 0)
    vignette.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
    vignette.BackgroundTransparency = 1
    vignette.BorderSizePixel        = 0
    vignette.ZIndex                 = 2
    vignette.Parent                 = bg

    local vignetteGradient = Instance.new("UIGradient")
    vignetteGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
    })
    vignetteGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.85),
        NumberSequenceKeypoint.new(1, 1),
    })
    vignetteGradient.Rotation = 0
    vignetteGradient.Parent = vignette

    -- Diagonal light sweep
    local sweep = Instance.new("Frame")
    sweep.Size                   = UDim2.new(0, 400, 2, 0)
    sweep.Position               = UDim2.new(-0.5, 0, -0.5, 0)
    sweep.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
    sweep.BackgroundTransparency = 1
    sweep.BorderSizePixel        = 0
    sweep.Rotation               = 25
    sweep.ZIndex                 = 3
    sweep.Parent                 = bg

    local sweepGradient = Instance.new("UIGradient")
    sweepGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.85),
        NumberSequenceKeypoint.new(1, 1),
    })
    sweepGradient.Parent = sweep

    -- Scanlines overlay (CRT)
    local scanlines = Instance.new("Frame")
    scanlines.Size                   = UDim2.new(1, 0, 1, 0)
    scanlines.BackgroundTransparency = 1
    scanlines.BorderSizePixel        = 0
    scanlines.ZIndex                 = 4
    scanlines.Parent                 = bg

    local scanGradient = Instance.new("UIGradient")
    scanGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.92),
        NumberSequenceKeypoint.new(1, 1),
    })
    scanGradient.Parent = scanlines

    -- Moving scanline bar
    local scanBar = Instance.new("Frame")
    scanBar.Size                   = UDim2.new(1, 0, 0, 3)
    scanBar.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
    scanBar.BackgroundTransparency = 0.7
    scanBar.BorderSizePixel        = 0
    scanBar.Position               = UDim2.new(0, 0, 0, 0)
    scanBar.ZIndex                 = 5
    scanBar.Parent                 = bg

    -- White border
    local border = Instance.new("Frame")
    border.Size                   = UDim2.new(1, 0, 1, 0)
    border.BackgroundTransparency = 1
    border.BorderSizePixel        = 0
    border.ZIndex                 = 6
    border.Parent                 = bg

    local borderStroke = Instance.new("UIStroke")
    borderStroke.Color           = Color3.fromRGB(255, 255, 255)
    borderStroke.Thickness       = 0
    borderStroke.Transparency    = 1
    borderStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    borderStroke.Parent          = border

    -- Top tag
    local tag = Instance.new("TextLabel")
    tag.Size                   = UDim2.new(0, 500, 0, 40)
    tag.Position               = UDim2.new(0, 40, 0, 30)
    tag.BackgroundTransparency = 1
    tag.Font                   = Enum.Font.GothamBold
    tag.TextSize               = 20
    tag.TextXAlignment         = Enum.TextXAlignment.Left
    tag.Text                   = "// DEEP HUB MR"
    tag.TextColor3             = Color3.fromRGB(255, 255, 255)
    tag.TextTransparency       = 1
    tag.ZIndex                 = 7
    tag.Parent                 = bg

    local tagDot = Instance.new("Frame")
    tagDot.Size                   = UDim2.new(0, 8, 0, 8)
    tagDot.Position               = UDim2.new(0, 20, 0, 46)
    tagDot.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
    tagDot.BorderSizePixel        = 0
    tagDot.BackgroundTransparency = 1
    tagDot.ZIndex                 = 7
    tagDot.Parent                 = bg

    local tagDotCorner = Instance.new("UICorner")
    tagDotCorner.CornerRadius = UDim.new(1, 0)
    tagDotCorner.Parent       = tagDot

    -- Bottom tag
    local btmTag = Instance.new("TextLabel")
    btmTag.Size                   = UDim2.new(0, 500, 0, 30)
    btmTag.Position               = UDim2.new(1, -540, 1, -60)
    btmTag.BackgroundTransparency = 1
    btmTag.Font                   = Enum.Font.GothamBold
    btmTag.TextSize               = 16
    btmTag.TextXAlignment         = Enum.TextXAlignment.Right
    btmTag.Text                   = "DEEP HUB — MR"
    btmTag.TextColor3             = Color3.fromRGB(255, 255, 255)
    btmTag.TextTransparency       = 1
    btmTag.ZIndex                 = 7
    btmTag.Parent                 = bg

    -- ===== WORD HOLDER =====
    local holder = Instance.new("Frame")
    holder.Size                   = UDim2.new(1, 0, 0, 180)
    holder.Position               = UDim2.new(0, 0, 0.5, -90)
    holder.BackgroundTransparency = 1
    holder.ZIndex                 = 8
    holder.Parent                 = bg

    -- Horizontal rule lines around the word
    local topLine = Instance.new("Frame")
    topLine.Size                   = UDim2.new(0, 0, 0, 1)
    topLine.Position               = UDim2.new(0.5, 0, 0.5, -70)
    topLine.AnchorPoint            = Vector2.new(0.5, 0.5)
    topLine.BackgroundColor3       = Color3.fromRGB(255, 255, 255)
    topLine.BackgroundTransparency = 1
    topLine.BorderSizePixel        = 0
    topLine.ZIndex                 = 8
    topLine.Parent                 = bg

    local btmLine = topLine:Clone()
    btmLine.Position = UDim2.new(0.5, 0, 0.5, 70)
    btmLine.Parent   = bg

    -- Main word label
    local wordLabel = Instance.new("TextLabel")
    wordLabel.Size                   = UDim2.new(1, 0, 1, 0)
    wordLabel.BackgroundTransparency = 1
    wordLabel.Font                   = Enum.Font.GothamBlack
    wordLabel.TextScaled             = true
    wordLabel.Text                   = ""
    wordLabel.TextColor3             = Color3.fromRGB(255, 255, 255)
    wordLabel.TextTransparency       = 1
    wordLabel.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    wordLabel.TextStrokeTransparency = 0
    wordLabel.ZIndex                 = 9
    wordLabel.Parent                 = holder

    -- Echo layer (offset behind)
    local echoLabel                   = wordLabel:Clone()
    echoLabel.TextColor3              = Color3.fromRGB(0, 0, 0)
    echoLabel.TextStrokeColor3        = Color3.fromRGB(255, 255, 255)
    echoLabel.TextTransparency        = 1
    echoLabel.TextStrokeTransparency  = 1
    echoLabel.ZIndex                  = 8
    echoLabel.Parent                  = holder

    -- Ghost layer (bigger, subtle behind)
    local ghostLabel                  = wordLabel:Clone()
    ghostLabel.TextColor3             = Color3.fromRGB(255, 255, 255)
    ghostLabel.TextStrokeTransparency = 1
    ghostLabel.TextTransparency       = 1
    ghostLabel.ZIndex                 = 7
    ghostLabel.Parent                 = holder

    -- ===== HELPERS =====
    local function flash(label, duration)
        local original = label.TextColor3
        local flashColor = (original == Color3.fromRGB(255, 255, 255))
            and Color3.fromRGB(0, 0, 0)
            or  Color3.fromRGB(255, 255, 255)

        TweenService:Create(
            label,
            TweenInfo.new(duration / 2, Enum.EasingStyle.Quad),
            {TextColor3 = flashColor}
        ):Play()

        task.delay(duration / 2, function()
            if label and label.Parent then
                TweenService:Create(
                    label,
                    TweenInfo.new(duration / 2, Enum.EasingStyle.Quad),
                    {TextColor3 = original}
                ):Play()
            end
        end)
    end

    local function expandLines(width)
        TweenService:Create(topLine, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, width, 0, 1),
            BackgroundTransparency = 0.3,
        }):Play()
        TweenService:Create(btmLine, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, width, 0, 1),
            BackgroundTransparency = 0.3,
        }):Play()
    end

    local function retractLines()
        TweenService:Create(topLine, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 1),
            BackgroundTransparency = 1,
        }):Play()
        TweenService:Create(btmLine, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 1),
            BackgroundTransparency = 1,
        }):Play()
    end

    local function showWord(word, isWhite, holdTime)
        holdTime = holdTime or 0.35

        local fg     = isWhite and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
        local stroke = isWhite and Color3.fromRGB(0, 0, 0) or Color3.fromRGB(255, 255, 255)

        -- Set main
        wordLabel.Text                   = word
        wordLabel.TextColor3             = fg
        wordLabel.TextStrokeColor3       = stroke
        wordLabel.TextTransparency       = 1
        wordLabel.TextStrokeTransparency = 1

        -- Echo
        echoLabel.Text             = word
        echoLabel.TextColor3       = stroke
        echoLabel.TextStrokeColor3 = fg

        -- Ghost
        ghostLabel.Text       = word
        ghostLabel.Position   = UDim2.new(0, 0, 0, 0)

        -- Lines expand
        expandLines(320)

        -- Pop in main
        local sizeInfo = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(wordLabel, sizeInfo, {
            TextTransparency       = 0,
            TextStrokeTransparency = 0,
        }):Play()

        -- Echo punch offset
        echoLabel.Position = UDim2.new(0, 8, 0, 8)
        TweenService:Create(echoLabel, TweenInfo.new(0.22, Enum.EasingStyle.Quad), {
            Position               = UDim2.new(0, 0, 0, 0),
            TextTransparency       = 0.7,
            TextStrokeTransparency = 0.7,
        }):Play()

        -- Ghost blur sweep (grow + fade)
        ghostLabel.TextTransparency = 0.85
        TweenService:Create(ghostLabel, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
            TextTransparency = 1,
        }):Play()

        -- Color flip flash
        flash(wordLabel, 0.18)

        if not introWait(holdTime) then return false end

        -- Fade out
        local outInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenService:Create(wordLabel, outInfo, {
            TextTransparency       = 1,
            TextStrokeTransparency = 1,
        }):Play()
        TweenService:Create(echoLabel, outInfo, {
            TextTransparency       = 1,
            TextStrokeTransparency = 1,
        }):Play()

        retractLines()

        if not introWait(0.18) then return false end
        return true
    end

    -- ===== INTRO SEQUENCE =====

    -- Fade in bg
    TweenService:Create(bg, TweenInfo.new(0.7, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0,
    }):Play()

    TweenService:Create(vignette, TweenInfo.new(1, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0.55,
    }):Play()

    TweenService:Create(scanlines, TweenInfo.new(1, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0.6,
    }):Play()

    TweenService:Create(borderStroke, TweenInfo.new(0.9, Enum.EasingStyle.Quad), {
        Thickness = 3, Transparency = 0.25,
    }):Play()

    -- Tag + dot fade in
    if not introWait(0.4) then return end
    TweenService:Create(tag, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
    TweenService:Create(tagDot, TweenInfo.new(0.6), {BackgroundTransparency = 0}):Play()
    TweenService:Create(btmTag, TweenInfo.new(0.8), {TextTransparency = 0.4}):Play()

    -- Light sweep animation (repeats during intro)
    task.spawn(function()
        while gui.Parent and not skipped do
            sweep.Position = UDim2.new(-0.5, 0, -0.5, 0)
            sweep.BackgroundTransparency = 1
            local t = TweenService:Create(
                sweep,
                TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
                {Position = UDim2.new(0.8, 0, -0.5, 0), BackgroundTransparency = 0.85}
            )
            t:Play()
            t.Completed:Wait()
            TweenService:Create(sweep, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            if not introWait(1.2) then return end
        end
    end)

    -- Scan bar loop
    task.spawn(function()
        while gui.Parent and not skipped do
            scanBar.Position = UDim2.new(0, 0, 0, -0.01)
            local t = TweenService:Create(
                scanBar,
                TweenInfo.new(2.4, Enum.EasingStyle.Linear),
                {Position = UDim2.new(0, 0, 1, 0)}
            )
            t:Play()
            t.Completed:Wait()
            if not introWait(0.1) then return end
        end
    end)

    -- Pulsing dot
    task.spawn(function()
        while gui.Parent and not skipped do
            TweenService:Create(tagDot, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
                BackgroundTransparency = 0.6,
            }):Play()
            if not introWait(0.6) then return end
            TweenService:Create(tagDot, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
                BackgroundTransparency = 0,
            }):Play()
            if not introWait(0.6) then return end
        end
    end)

    if not introWait(0.6) then return end

    -- ===== MAIN WORDS =====
    local words = {
        "DEEP",
        "HUB",
        "MR",
        "DEEP",
        "HUB",
        "MR",
    }

    for i, w in ipairs(words) do
        local isWhite = (i % 2 == 1)
        if not showWord(w, isWhite, 0.35) then return end
    end

    if not introWait(0.3) then return end

    -- ===== FINAL LINE =====
    local finalLine = {
        "DEEP",
        "HUB",
        "MR",
    }

    for i, w in ipairs(finalLine) do
        local isWhite = (i % 2 == 1)
        if not showWord(w, isWhite, 0.28) then return end
    end

    if not introWait(0.4) then return end

    -- ===== PUNCHLINE TAG =====
    -- Expand lines fully
    TweenService:Create(topLine, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 500, 0, 1),
        BackgroundTransparency = 0,
    }):Play()
    TweenService:Create(btmLine, TweenInfo.new(0.4, Enum.EasingStyle.Quad), {
        Size = UDim2.new(0, 500, 0, 1),
        BackgroundTransparency = 0,
    }):Play()

    wordLabel.Text                   = "// DEEP HUB MR"
    wordLabel.TextColor3             = Color3.fromRGB(255, 255, 255)
    wordLabel.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    wordLabel.TextTransparency       = 1
    wordLabel.TextStrokeTransparency = 1

    echoLabel.Text             = "// DEEP HUB MR"
    echoLabel.TextColor3       = Color3.fromRGB(0, 0, 0)
    echoLabel.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

    TweenService:Create(wordLabel, TweenInfo.new(0.3), {
        TextTransparency = 0, TextStrokeTransparency = 0,
    }):Play()
    TweenService:Create(echoLabel, TweenInfo.new(0.3), {
        TextTransparency = 0.7, TextStrokeTransparency = 0.7,
    }):Play()

    if not introWait(1.6) then return end

    -- Fade everything out
    TweenService:Create(wordLabel, TweenInfo.new(0.5), {
        TextTransparency = 1, TextStrokeTransparency = 1,
    }):Play()
    TweenService:Create(echoLabel, TweenInfo.new(0.5), {
        TextTransparency = 1, TextStrokeTransparency = 1,
    }):Play()
    TweenService:Create(tag, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(tagDot, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
    TweenService:Create(btmTag, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
    TweenService:Create(topLine, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(btmLine, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    TweenService:Create(borderStroke, TweenInfo.new(0.7), {Transparency = 1}):Play()
    TweenService:Create(vignette, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()
    TweenService:Create(scanlines, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()
    TweenService:Create(scanBar, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()

    if not introWait(0.3) then return end

    TweenService:Create(bg, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()
    TweenService:Create(music, TweenInfo.new(1.5), {Volume = 0}):Play()

    if not introWait(1.6) then return end

    -- Cleanup
    cleanupIntro()

    print("[DEEP HUB MR INTRO] Done.")
end

runDeepDuelsIntro()

--============================================================
-- SCRIPT PRINCIPAL
--============================================================

repeat task.wait() until game:IsLoaded() 
local Players,RunService,UIS,TS,Lighting,HS = game:GetService("Players"),game:GetService("RunService"),game:GetService("UserInputService"),game:GetService("TweenService"),game:GetService("Lighting"),game:GetService("HttpService") 
local LP = Players.LocalPlayer 
local NS,CS = 60,29 
local LAGGER_SPEED = 15 
local LAGGER_CARRY_SPEED = 24.5 
local speedMode,antiRagdollEnabled,infJumpEnabled = false,false,false 
local laggerToggled = false 
local laggerPhase = 0 
local medusaCounterEnabled = false 
local batCounterEnabled = false 
local unwalkEnabled = false 
local medusaDebounce,medusaLastUsed,dropActive = false,0,false 
local autoLeftEnabled,autoRightEnabled = false,false 
local autoLeftSetVisual,autoRightSetVisual = nil,nil 
local speedLabel = nil 
local autoBatEnabled = false 
local autoSwingEnabled = true 
local autoBatSetVisual = nil 
local _autoBatTarget = nil 
local resetAutoBatMotion = nil 
local queueAutoBatStart = nil 
local _batSwingCooldown = 0 
local BAT_SWING_INTERVAL = 0.08 
local AUTO_BAT_SPEED = 60 
local setBatCounterVisual = nil 
local startBatCounter,stopBatCounter


local antiLagEnabled = false 
local removeAccessoriesEnabled = false 
local antiLagDescConn = nil 
local stretchRezEnabled = false 
local stretchRezConn = nil 
local setStretchRezVisual = nil 
local unwalkSavedAnimate = nil 
local _anyKeyListening = false 
local autoTPConn = nil 
local setAutoTPVisual = nil 

-- ============================================================
-- DEEP BYPASS - Power / Auto Brainrot
-- ============================================================
do
    if _G.ExeBypass and type(_G.ExeBypass.destroy)=="function" then
        pcall(_G.ExeBypass.destroy)
    end

    local B={
        enabled=false,
        autoBrainrot=false,
        power=72000,
        depth=296,
        delay=0.12,
        bomb=nil,
        spamThread=nil,
        monitorThread=nil,
        alive=true,
    }
    _G.ExeBypass=B

    local NetworkClient=nil
    pcall(function() NetworkClient=game:GetService("NetworkClient") end)

    local function safeCancel(thread)
        if thread then pcall(function() task.cancel(thread) end) end
    end

    local function getRemote()
        local container=game:FindFirstChild("RobloxReplicatedStorage")
        if not container then
            pcall(function() container=game:GetService("RobloxReplicatedStorage") end)
        end
        return container and container:FindFirstChild("SetPlayerBlockList") or nil
    end

    local function buildBomb(power)
        local main={}
        local spammed={{}}
        local node=spammed[1]
        for _=1,B.depth do
            local child={}
            node[1]=child
            node=child
        end
        local reps=math.max(1,math.floor((tonumber(power) or B.power)/(B.depth+2)))
        for i=1,reps do main[i]=spammed end
        return main
    end

    local function rebuildBomb()
        local ok,res=pcall(buildBomb,B.power)
        B.bomb=ok and res or nil
    end

    local function stopSpam()
        safeCancel(B.spamThread)
        B.spamThread=nil
        B.bomb=nil
    end

    local function startSpam()
        stopSpam()
        if not B.enabled then return end
        rebuildBomb()
        B.spamThread=task.spawn(function()
            while B.alive and B.enabled do
                local remote=getRemote()
                if B.bomb and remote and remote:IsA("RemoteEvent") then
                    pcall(function() remote:FireServer(B.bomb) end)
                end
                task.wait(B.delay)
            end
        end)
    end

    local function holdingBrainrot()
        local ok,v=pcall(function() return LP:GetAttribute("Stealing") end)
        if ok and v==true then return true end

        local ok2,v2=pcall(function() return LP:GetAttribute("AntiKick") end)
        if ok2 and v2==true then return true end

        local char=LP.Character
        if not char then return false end

        local ok3,v3=pcall(function() return char:GetAttribute("Stealing") end)
        if ok3 and v3==true then return true end

        for _,name in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab","CarryingBrainrot"}) do
            local obj=char:FindFirstChild(name,true)
            if obj then
                if obj:IsA("BoolValue") and obj.Value then return true end
                if obj:IsA("ObjectValue") and obj.Value then return true end
                if obj:IsA("StringValue") and obj.Value~="" then return true end
            end
        end

        for _,child in ipairs(char:GetDescendants()) do
            if child:IsA("Tool") or child:IsA("Model") then
                local name=tostring(child.Name or ""):lower()
                if name:find("brainrot",1,true)
                    or name:find("animal",1,true)
                    or name:find("carry",1,true)
                    or name:find("grab",1,true)
                    or name:find("steal",1,true)
                    or name:find("hold",1,true) then
                    return true
                end
            end
        end
        return false
    end

    function _G.ExeSetBypass(on,skipSave)
        on=(on==true)
        if B.enabled==on then
            if _G.ExeBypassVisual then pcall(_G.ExeBypassVisual,on) end
            if mobBtnRefs and mobBtnRefs.bypass then pcall(mobBtnRefs.bypass,on) end
            return B.enabled
        end

        B.enabled=on
        if on then
            if NetworkClient then
                pcall(function() NetworkClient:SetOutgoingKBPSLimit(math.huge) end)
            end
            startSpam()
        else
            stopSpam()
        end

        if _G.ExeBypassVisual then pcall(_G.ExeBypassVisual,B.enabled) end
        if mobBtnRefs and mobBtnRefs.bypass then pcall(mobBtnRefs.bypass,B.enabled) end
        if not skipSave and type(saveConfig)=="function" then pcall(saveConfig) end
        return B.enabled
    end

    function _G.ExeSetBypassPower(value,skipSave)
        value=math.clamp(math.floor(tonumber(value) or B.power),10000,150000)
        if B.power~=value then
            B.power=value
            if B.enabled then startSpam() end
        end
        if _G.ExeBypassPowerBox then _G.ExeBypassPowerBox.Text=tostring(B.power) end
        if not skipSave and type(saveConfig)=="function" then pcall(saveConfig) end
        return B.power
    end

    function _G.ExeSetAutoBrainrot(on,skipSave)
        B.autoBrainrot=(on==true)
        if _G.ExeAutoBrainrotVisual then pcall(_G.ExeAutoBrainrotVisual,B.autoBrainrot) end
        if B.autoBrainrot then
            local carrying=holdingBrainrot()
            _G.ExeSetBypass(carrying,true)
        end
        if not skipSave and type(saveConfig)=="function" then pcall(saveConfig) end
        return B.autoBrainrot
    end

    B.monitorThread=task.spawn(function()
        while B.alive do
            if B.autoBrainrot then
                local carrying=holdingBrainrot()
                if B.enabled~=carrying then
                    _G.ExeSetBypass(carrying,true)
                end
            end
            task.wait(0.15)
        end
    end)

    function B.destroy()
        B.alive=false
        B.enabled=false
        safeCancel(B.monitorThread)
        B.monitorThread=nil
        stopSpam()
    end
end

local KB = { 
    DropBrainrot={kb=Enum.KeyCode.X}, 
    AutoLeft ={kb=Enum.KeyCode.Z}, 
    AutoRight ={kb=Enum.KeyCode.C}, 
    AutoBat ={kb=Enum.KeyCode.E}, 
    TPFloor ={kb=Enum.KeyCode.F}, 
    GuiHide ={kb=Enum.KeyCode.LeftControl}, 
    SpeedToggle ={kb=Enum.KeyCode.Q}, 
    LaggerToggle={kb=Enum.KeyCode.R}, 
    Aimbot2={kb=Enum.KeyCode.V}, 
    AntiDesyncAimbot={kb=Enum.KeyCode.B} 
} 
local AP_L1,AP_L2 = Vector3.new(-476.47,-6.28,92.73),Vector3.new(-483.12,-4.95,94.81) 
local AP_R1,AP_R2 = Vector3.new(-476.16,-6.52,25.62),Vector3.new(-483.06,-5.03,25.48) 
local Steal = { 
    AutoStealEnabled=false,
    StealRadius=20,
    StealDuration=1.3,
    StealDelay=0.25,
    DelayRadius=8,
    StopPercent=75,
    Data={} 
}  
local isStealing = false 
local stealStartTime = nil 
local Conns = {autoSteal=nil,antiRag=nil,batCounter=nil,anchor={},progress=nil} 
local MEDUSA_COOLDOWN = 25 
local batCounterDebounce = false 
local modeValLbl 
local uiScale = 1 
uiLocked=false 
setLockVisual=nil 
exeLaggerPanelKey=Enum.KeyCode.M 
exeMainFrame=nil 
exeMiniButton=nil 
exeGrabBar=nil 
local lastMoveDir = Vector3.new(0,0,0) 
local MOVE_KEYS={[Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,[Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true, 
    [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,[Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true} 
local function getActiveMoveSpeed() 
    return laggerToggled and (laggerPhase==2 and LAGGER_CARRY_SPEED or LAGGER_SPEED) or (speedMode and CS or NS) 
end 
local function getAutoPathSpeed() 
    return laggerToggled and LAGGER_SPEED or NS 
end 
--============================================================
-- DEEP ESP - lightweight (uses one global state table to avoid Luau local limit)
-- ESP = master | LINE/SQUARE = saved sub-options
--============================================================
pcall(function()
    if _G.DeepESP and _G.DeepESP.conn then _G.DeepESP.conn:Disconnect() end
    if _G.DeepESP and _G.DeepESP.removeConn then _G.DeepESP.removeConn:Disconnect() end
    if _G.DeepESP and _G.DeepESP.gui then _G.DeepESP.gui:Destroy() end
end)
_G.DeepESP={enabled=false,line=false,square=false,expanded=false,entries={}}

function _G.DeepESP.getGui()
    if _G.DeepESP.gui and _G.DeepESP.gui.Parent then return _G.DeepESP.gui end
    local g=Instance.new("ScreenGui")
    g.Name="DeepDuelsESP"
    g.IgnoreGuiInset=true
    g.ResetOnSpawn=false
    g.DisplayOrder=8
    g.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
    local ok=pcall(function() g.Parent=game:GetService("CoreGui") end)
    if not ok or not g.Parent then g.Parent=LP:WaitForChild("PlayerGui") end
    _G.DeepESP.gui=g
    return g
end

function _G.DeepESP.entry(plr)
    local e=_G.DeepESP.entries[plr]
    if e and e.line and e.line.Parent then return e end
    local g=_G.DeepESP.getGui()
    e={}

    e.line=Instance.new("Frame")
    e.line.Name="Line_"..plr.Name
    e.line.AnchorPoint=Vector2.new(0.5,0.5)
    e.line.BackgroundColor3=Color3.new(1,1,1)
    e.line.BorderSizePixel=0
    e.line.Size=UDim2.fromOffset(1,2)
    e.line.Visible=false
    e.line.ZIndex=2
    e.line.Parent=g

    e.box=Instance.new("Frame")
    e.box.Name="Square_"..plr.Name
    e.box.BackgroundTransparency=1
    e.box.BorderSizePixel=0
    e.box.Visible=false
    e.box.ZIndex=3
    e.box.Parent=g
    local st=Instance.new("UIStroke")
    st.Color=Color3.new(1,1,1)
    st.Thickness=1.5
    st.Parent=e.box

    e.name=Instance.new("TextLabel")
    e.name.Name="Name_"..plr.Name
    e.name.AnchorPoint=Vector2.new(0.5,1)
    e.name.BackgroundTransparency=1
    e.name.Size=UDim2.fromOffset(180,20)
    e.name.Text=plr.Name
    e.name.TextColor3=Color3.new(1,1,1)
    e.name.TextStrokeTransparency=0.35
    e.name.Font=Enum.Font.SciFi
    e.name.TextSize=13
    e.name.Visible=false
    e.name.ZIndex=4
    e.name.Parent=g

    _G.DeepESP.entries[plr]=e
    return e
end

function _G.DeepESP.hide()
    for _,e in pairs(_G.DeepESP.entries) do
        if e.line then e.line.Visible=false end
        if e.box then e.box.Visible=false end
        if e.name then e.name.Visible=false end
    end
end

function _G.DeepESP.alive(plr)
    local c=plr and plr.Character
    local h=c and c:FindFirstChildOfClass("Humanoid")
    local r=c and c:FindFirstChild("HumanoidRootPart")
    if not c or not h or h.Health<=0 or not r then return nil,nil,nil end
    return c,h,r
end

function _G.DeepESP.step()
    if not _G.DeepESP.enabled then _G.DeepESP.hide();return end
    local cam=workspace.CurrentCamera
    local _,_,myRoot=_G.DeepESP.alive(LP)
    if not cam or not myRoot then _G.DeepESP.hide();return end

    _G.DeepESP.hide()
    local mine,mineOn=cam:WorldToViewportPoint(myRoot.Position)
    local mine2=Vector2.new(mine.X,mine.Y)
    local closest=nil
    local closestDist=math.huge

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP then
            local _,_,root=_G.DeepESP.alive(plr)
            if root then
                local d=(root.Position-myRoot.Position).Magnitude
                if d<closestDist then closestDist=d;closest=plr end
                if _G.DeepESP.line then
                    local p,on=cam:WorldToViewportPoint(root.Position)
                    if mineOn and on and mine.Z>0 and p.Z>0 then
                        local e=_G.DeepESP.entry(plr)
                        local a=mine2
                        local b=Vector2.new(p.X,p.Y)
                        local delta=b-a
                        local len=delta.Magnitude
                        if len>1 then
                            local mid=(a+b)/2
                            e.line.Position=UDim2.fromOffset(mid.X,mid.Y)
                            e.line.Size=UDim2.fromOffset(len,2)
                            e.line.Rotation=math.deg(math.atan2(delta.Y,delta.X))
                            e.line.Visible=true
                        end
                    end
                end
            end
        end
    end

    if _G.DeepESP.square and closest then
        local char,_,root=_G.DeepESP.alive(closest)
        if char and root then
            local e=_G.DeepESP.entry(closest)
            local cf,size=char:GetBoundingBox()
            local top=cam:WorldToViewportPoint(cf.Position+Vector3.new(0,size.Y/2,0))
            local bottom=cam:WorldToViewportPoint(cf.Position-Vector3.new(0,size.Y/2,0))
            local center,on=cam:WorldToViewportPoint(root.Position)
            if on and center.Z>0 and top.Z>0 and bottom.Z>0 then
                local h=math.max(24,math.abs(bottom.Y-top.Y))
                local w=math.max(16,h*0.58)
                local cy=(top.Y+bottom.Y)/2
                e.box.Size=UDim2.fromOffset(w,h)
                e.box.Position=UDim2.fromOffset(center.X-w/2,cy-h/2)
                e.box.Visible=true
                e.name.Text=closest.Name
                e.name.Position=UDim2.fromOffset(center.X,top.Y-3)
                e.name.Visible=true
            end
        end
    end
end

function _G.DeepESP.setEnabled(v)
    _G.DeepESP.enabled=(v==true)
    if _G.DeepESP.conn then _G.DeepESP.conn:Disconnect();_G.DeepESP.conn=nil end
    if _G.DeepESP.enabled then
        _G.DeepESP.getGui()
        _G.DeepESP.conn=RunService.RenderStepped:Connect(_G.DeepESP.step)
    else
        _G.DeepESP.hide()
    end
    if _G.DeepESP.masterVisual then _G.DeepESP.masterVisual(_G.DeepESP.enabled) end
end

_G.DeepESP.removeConn=Players.PlayerRemoving:Connect(function(plr)
    local e=_G.DeepESP.entries[plr]
    if e then
        pcall(function() e.line:Destroy() end)
        pcall(function() e.box:Destroy() end)
        pcall(function() e.name:Destroy() end)
        _G.DeepESP.entries[plr]=nil
    end
end)

local function isRagdollState(hum) 
    if not hum then return true end 
    local st=hum:GetState() 
    return hum.PlatformStand or st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown 
end 
local function isMyPlotByName(plotName) 
    local plots=workspace:FindFirstChild("Plots") 
    if not plots then return false end 
    local plot=plots:FindFirstChild(plotName) 
    if not plot then return false end 
    local sign=plot:FindFirstChild("PlotSign") 
    if sign then 
        local yb=sign:FindFirstChild("YourBase") 
        if yb and yb:IsA("BillboardGui") then 
            return yb.Enabled==true 
        end 
    end 
    return false 
end 
local function findNearestPrompt()
    local char=LP.Character
    if not char then return nil,nil,nil end

    local root=char:FindFirstChild("HumanoidRootPart")
    if not root then return nil,nil,nil end

    local plots=workspace:FindFirstChild("Plots")
    if not plots then return nil,nil,nil end

    local nearestPrompt,nearestDist,nearestName=nil,math.huge,nil

    for _,plot in ipairs(plots:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end

        local pods=plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end

        for _,pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base=pod:FindFirstChild("Base")
                local spawn=base and base:FindFirstChild("Spawn")
                if spawn then
                    local dist=(spawn.Position-root.Position).Magnitude
                    if dist<nearestDist and dist<=Steal.StealRadius then
                        local att=spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _,child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt")
                                    and child.ActionText
                                    and child.ActionText:find("Steal") then
                                    nearestPrompt,nearestDist,nearestName=child,dist,pod.Name
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end

    return nearestPrompt,nearestDist,nearestName
end

-- ============================================================
-- REALSCAM AUTO GRAB
-- Pre-carrega ate Stop %, espera entrar no Delay Radius,
-- completa a barra e dispara o prompt.
-- ============================================================
_G.DeepMayStealProgress=0

local function setRealScamBar(p)
    p=math.clamp(tonumber(p) or 0,0,1)
    _G.DeepMayStealProgress=p
end

local lastStealResult=0

local function executeSteal(prompt,podName)
    if isStealing or not prompt or not prompt.Parent then return end
    if tick()-lastStealResult<0.05 then return end

    if not Steal.Data[prompt] then
        local d={hold={},trigger={},ready=true}
        pcall(function()
            if getconnections then
                for _,c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if type(c.Function)=="function" then
                        table.insert(d.hold,c.Function)
                    end
                end
                for _,c in ipairs(getconnections(prompt.Triggered)) do
                    if type(c.Function)=="function" then
                        table.insert(d.trigger,c.Function)
                    end
                end
            end
        end)
        Steal.Data[prompt]=d
    end

    local data=Steal.Data[prompt]
    if not data.ready then return end

    data.ready=false
    isStealing=true
    stealStartTime=tick()
    setRealScamBar(0)

    task.spawn(function()
        local function root()
            local c=LP.Character
            return c and c:FindFirstChild("HumanoidRootPart")
        end

        local startTime=tick()
        stealStartTime=startTime

        local duration=math.max(tonumber(Steal.StealDuration) or 1.3,0.05)
        local pct=math.clamp(tonumber(Steal.StopPercent) or 75,1,100)
        local stopTime=duration*(pct/100)
        local cancelled=false

        for _,fn in ipairs(data.hold) do
            task.spawn(function()
                pcall(fn)
            end)
        end

        -- Fase 1: carrega ate Stop %
        while Steal.AutoStealEnabled do
            local elapsed=tick()-startTime
            if elapsed>=stopTime then break end

            setRealScamBar(elapsed/duration)

            local r=root()
            if not r or not prompt.Parent or not prompt.Parent.Parent then
                cancelled=true
                break
            end

            if (r.Position-prompt.Parent.Parent.Position).Magnitude>Steal.StealRadius then
                cancelled=true
                break
            end

            task.wait()
        end

        if not Steal.AutoStealEnabled then
            cancelled=true
        end

        local stopProgress=math.clamp(stopTime/duration,0,1)
        if not cancelled then
            setRealScamBar(stopProgress)
        end

        local phase2Timeout=math.max(
            2.99-stopTime-math.max(duration-stopTime,0),
            0.05
        )
        local phase2Start=tick()

        -- Fase 2: espera entrar no Delay Radius
        while not cancelled and Steal.AutoStealEnabled do
            if tick()-phase2Start>=phase2Timeout then
                cancelled=true
                break
            end

            if not prompt.Parent or not prompt.Parent.Parent then
                cancelled=true
                break
            end

            local r=root()
            if r then
                local dist=(r.Position-prompt.Parent.Parent.Position).Magnitude
                if dist<=(tonumber(Steal.DelayRadius) or 8) then
                    break
                elseif dist>Steal.StealRadius then
                    cancelled=true
                    break
                end
            end

            task.wait()
        end

        -- Fase 3: completa a barra e dispara
        if not cancelled and Steal.AutoStealEnabled then
            local fillDuration=math.max(duration-stopTime,0)
            local barLead=math.min(0.05,fillDuration)
            local fillRamp=fillDuration-barLead
            local fillStart=tick()

            while true do
                local fp=fillRamp>0
                    and math.clamp((tick()-fillStart)/fillRamp,0,1)
                    or 1

                setRealScamBar(stopProgress+fp*(1-stopProgress))

                if fp>=1 then break end
                task.wait()
            end

            setRealScamBar(1)

            if barLead>0 then
                task.wait(barLead)
            end

            local fired=false

            for _,fn in ipairs(data.trigger) do
                fired=true
                task.spawn(function()
                    pcall(fn)
                end)
            end

            if not fired then
                pcall(function()
                    if fireproximityprompt then
                        fireproximityprompt(prompt,0)
                    else
                        prompt:InputHoldBegin()
                        task.wait()
                        prompt:InputHoldEnd()
                    end
                end)
            end
        end

        task.wait(0.05)
        setRealScamBar(0)

        lastStealResult=tick()
        data.ready=true
        isStealing=false
        stealStartTime=nil
    end)
end

local function startAutoSteal()
    if Conns.autoSteal then return end

    Steal.AutoStealEnabled=true

    Conns.autoSteal=RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end

        local prompt,_,name=findNearestPrompt()
        if prompt then
            executeSteal(prompt,name)
        end
    end)
end

local function stopAutoSteal()
    Steal.AutoStealEnabled=false

    if Conns.autoSteal then
        Conns.autoSteal:Disconnect()
        Conns.autoSteal=nil
    end

    isStealing=false
    stealStartTime=nil
    setRealScamBar(0)
end

RunService.Stepped:Connect(function() 
    for _,p in ipairs(Players:GetPlayers()) do 
        if p~=LP and p.Character then 
            for _,part in ipairs(p.Character:GetDescendants()) do 
                if part:IsA("BasePart") then part.CanCollide=false end 
            end 
        end 
    end 
end) 
RunService.RenderStepped:Connect(function() 
    local char=LP.Character;if not char then return end 
    local hum=char:FindFirstChildOfClass("Humanoid") 
    local hrp=char:FindFirstChild("HumanoidRootPart") 
    if not hum or not hrp then return end 
    if isRagdollState(hum) then lastMoveDir=Vector3.new(0,0,0);return end 
    -- Quando BAT V2 está ligado, ele controla o movimento sozinho.
    -- O analógico não sobrescreve a perseguição do alvo.
    if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled and not aimbot2Enabled then 
        local md=hum.MoveDirection 
        local spd=getActiveMoveSpeed() 
        if md.Magnitude>0 then 
            lastMoveDir=md 
            hrp.Velocity=Vector3.new(md.X*spd,hrp.Velocity.Y,md.Z*spd) 
        elseif antiRagdollEnabled and lastMoveDir.Magnitude>0 then 
            local anyHeld=false 
            for key in pairs(MOVE_KEYS) do 
                if UIS:IsKeyDown(key) then anyHeld=true;break end 
            end 
            if anyHeld then 
                hrp.Velocity=Vector3.new(lastMoveDir.X*spd,hrp.Velocity.Y,lastMoveDir.Z*spd) 
            end 
        end 
    end 
    if speedLabel then speedLabel.Text=string.format("Speed: %.1f",Vector3.new(hrp.Velocity.X,0,hrp.Velocity.Z).Magnitude) end 
end) 
local alConn,arConn=nil,nil 
local alPhase,arPhase=1,1 
local function stopAutoLeft() 
    autoLeftEnabled=false if alConn then alConn:Disconnect();alConn=nil end;alPhase=1 
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false);h.PlatformStand=false;pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end);workspace.CurrentCamera.CameraSubject=h end end 
    if autoLeftSetVisual then autoLeftSetVisual(false) end 
    if mobBtnRefs and mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end 
end 
local function stopAutoRight() 
    autoRightEnabled=false if arConn then arConn:Disconnect();arConn=nil end;arPhase=1 
    local char=LP.Character;if char then local h=char:FindFirstChildOfClass("Humanoid");if h then h:Move(Vector3.zero,false);h.PlatformStand=false;pcall(function() h:ChangeState(Enum.HumanoidStateType.Running) end);workspace.CurrentCamera.CameraSubject=h end end 
    if autoRightSetVisual then autoRightSetVisual(false) end 
    if mobBtnRefs and mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end 
end 
local function startAutoLeft() 
    if alConn then alConn:Disconnect() end;alPhase=1 
    alConn=RunService.Heartbeat:Connect(function() 
        if not autoLeftEnabled then return end 
        local char=LP.Character;if not char then return end 
        local hrp=char:FindFirstChild("HumanoidRootPart") 
        local hum=char:FindFirstChildOfClass("Humanoid") 
        if not hrp or not hum then return end 
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end 
        local spd=getAutoPathSpeed() 
        if alPhase==1 then 
            local tgt=Vector3.new(AP_L1.X,hrp.Position.Y,AP_L1.Z) 
            if (tgt-hrp.Position).Magnitude<1 then 
                alPhase=2 
                local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit 
                hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) 
                return 
            end 
            local d=AP_L1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit 
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) 
        elseif alPhase==2 then 
            local tgt=Vector3.new(AP_L2.X,hrp.Position.Y,AP_L2.Z) 
            if (tgt-hrp.Position).Magnitude<1 then 
                hum:Move(Vector3.zero,false);hum.PlatformStand=false;pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end);workspace.CurrentCamera.CameraSubject=hum;hrp.AssemblyLinearVelocity=Vector3.zero 
                autoLeftEnabled=false;if alConn then alConn:Disconnect();alConn=nil end 
                alPhase=1;if autoLeftSetVisual then autoLeftSetVisual(false) end;if mobBtnRefs and mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(false) end;saveConfig();return 
            end 
            local d=AP_L2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit 
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) 
        end 
    end) 
end 
local function startAutoRight() 
    if arConn then arConn:Disconnect() end;arPhase=1 
    arConn=RunService.Heartbeat:Connect(function() 
        if not autoRightEnabled then return end 
        local char=LP.Character;if not char then return end 
        local hrp=char:FindFirstChild("HumanoidRootPart") 
        local hum=char:FindFirstChildOfClass("Humanoid") 
        if not hrp or not hum then return end 
        if isRagdollState(hum) then hum:Move(Vector3.zero,false);return end 
        local spd=getAutoPathSpeed() 
        if arPhase==1 then 
            local tgt=Vector3.new(AP_R1.X,hrp.Position.Y,AP_R1.Z) 
            if (tgt-hrp.Position).Magnitude<1 then 
                arPhase=2 
                local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit 
                hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) 
                return 
            end 
            local d=AP_R1-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit 
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) 
        elseif arPhase==2 then 
            local tgt=Vector3.new(AP_R2.X,hrp.Position.Y,AP_R2.Z) 
            if (tgt-hrp.Position).Magnitude<1 then 
                hum:Move(Vector3.zero,false);hum.PlatformStand=false;pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end);workspace.CurrentCamera.CameraSubject=hum;hrp.AssemblyLinearVelocity=Vector3.zero 
                autoRightEnabled=false;if arConn then arConn:Disconnect();arConn=nil end 
                arPhase=1;if autoRightSetVisual then autoRightSetVisual(false) end;if mobBtnRefs and mobBtnRefs.autoRight then mobBtnRefs.autoRight(false) end;saveConfig();return 
            end 
            local d=AP_R2-hrp.Position;local mv=Vector3.new(d.X,0,d.Z).Unit 
            hum:Move(mv,false);hrp.AssemblyLinearVelocity=Vector3.new(mv.X*spd,hrp.AssemblyLinearVelocity.Y,mv.Z*spd) 
        end 
    end) 
end 
local function setupSpeedIndicator(char)
    local head=char:WaitForChild("Head",5);if not head then return end
    local old=head:FindFirstChild("DeepDuelsBB");if old then old:Destroy() end
    local bb=Instance.new("BillboardGui",head)
    bb.Name="DeepDuelsBB"
    bb.Size=UDim2.new(0,220,0,104);bb.StudsOffset=Vector3.new(0,3,0);bb.AlwaysOnTop=true

    speedLabel=Instance.new("TextLabel",bb)
    speedLabel.Name="SpeedLbl"
    speedLabel.Size=UDim2.new(1,0,0,24);speedLabel.Position=UDim2.new(0,0,0,0);speedLabel.BackgroundTransparency=1
    speedLabel.Text="Speed: 0";speedLabel.TextColor3=Color3.fromRGB(255,255,255)
    speedLabel.Font=Enum.Font.SciFi;speedLabel.TextScaled=true
    speedLabel.TextStrokeTransparency=0;speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)

    local antiDropLabel=Instance.new("TextLabel",bb)
    antiDropLabel.Name="AntiDropLbl"
    antiDropLabel.Size=UDim2.new(1,0,0,22);antiDropLabel.Position=UDim2.new(0,0,0,24);antiDropLabel.BackgroundTransparency=1
    antiDropLabel.Text="Best anti drop Deep duels"
    antiDropLabel.Visible=antiDrop404Enabled==true
    antiDropLabel.TextColor3=Color3.fromRGB(255,255,255)
    antiDropLabel.Font=Enum.Font.GothamBold
    antiDropLabel.TextScaled=true
    antiDropLabel.TextStrokeTransparency=0
    antiDropLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)

    local discordLabel=Instance.new("TextLabel",bb)
    discordLabel.Name="DiscordLbl"
    discordLabel.Size=UDim2.new(1,0,0,22);discordLabel.Position=UDim2.new(0,0,0,46);discordLabel.BackgroundTransparency=1
    discordLabel.Text="https://discord.gg/z8fTGqjZnG";discordLabel.TextColor3=Color3.fromRGB(255,255,255)
    discordLabel.Font=Enum.Font.SciFi;discordLabel.TextScaled=true
    discordLabel.TextStrokeTransparency=0;discordLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)

    local ragTimerLabel=Instance.new("TextLabel",bb)
    ragTimerLabel.Name="RagdollTimerLbl"
    ragTimerLabel.Size=UDim2.new(1,0,0,28);ragTimerLabel.Position=UDim2.new(0,0,0,68)
    ragTimerLabel.BackgroundTransparency=1
    ragTimerLabel.Visible=false
    ragTimerLabel.Text=""
    ragTimerLabel.TextColor3=Color3.fromRGB(255,255,255)
    ragTimerLabel.Font=Enum.Font.GothamBold
    ragTimerLabel.TextScaled=true
    ragTimerLabel.TextStrokeTransparency=0.1
    ragTimerLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
end

-- ============================================================
-- MAY DUELS - RAGDOLL TIMER PORTADO PARA O DEEP DUELS
-- Morcego: 2.8s | Medusa's Head: 5.7s
-- ============================================================
_G.DeepRagdollTimerEnabled = _G.DeepRagdollTimerEnabled or false
_G.DeepRagTimerState = _G.DeepRagTimerState or {
    conn=nil,
    token=0,
    active=false,
    wasRagdolled=false,
    lastTrigger=0,
    clearSince=0,
    lockUntil=0,
    hitKind=nil,
    hitAt=0,
    selfMedusaUntil=0,
    selfMedusaConns={}
}
_G.DeepRagTimerCfg = {
    bat={timer=2.8},
    medusa={timer=5.7}
}

function _G.DeepRagServerNow()
    local ok,v=pcall(function()
        return workspace:GetServerTimeNow()
    end)
    return (ok and type(v)=="number") and v or tick()
end

function _G.DeepRagTimerLabel()
    local char=LP.Character
    local head=char and char:FindFirstChild("Head")
    if not head then return nil end

    local bb=head:FindFirstChild("DeepDuelsBB")
    if not bb then
        bb=Instance.new("BillboardGui")
        bb.Name="DeepDuelsBB"
        bb.Size=UDim2.new(0,180,0,78)
        bb.StudsOffset=Vector3.new(0,3,0)
        bb.AlwaysOnTop=true
        bb.Parent=head
    end

    local lbl=bb:FindFirstChild("RagdollTimerLbl")
    if not lbl then
        lbl=Instance.new("TextLabel")
        lbl.Name="RagdollTimerLbl"
        lbl.Size=UDim2.new(1,0,0,28)
        lbl.Position=UDim2.new(0,0,1,-28)
        lbl.BackgroundTransparency=1
        lbl.Text=""
        lbl.Visible=false
        lbl.TextColor3=Color3.fromRGB(255,255,255)
        lbl.Font=Enum.Font.GothamBold
        lbl.TextScaled=true
        lbl.TextStrokeTransparency=0.1
        lbl.TextStrokeColor3=Color3.fromRGB(0,0,0)
        lbl.ZIndex=10
        lbl.Parent=bb
    end
    return lbl
end

function _G.DeepClearRagdollTimer()
    local S=_G.DeepRagTimerState
    S.active=false
    S.token=(S.token or 0)+1
    local lbl=_G.DeepRagTimerLabel()
    if lbl then
        lbl.Text=""
        lbl.Visible=false
    end
end

function _G.DeepRagStrHasMedusa(n)
    if type(n)~="string" then return false end
    n=n:lower()
    return (n:find("medusa") or n:find("petrif") or n:find("stone") or n:find("statue")) and true or false
end

function _G.DeepRagStrHasBat(n)
    if type(n)~="string" then return false end
    n=n:lower()
    return (n:find("bat") or n:find("morcego") or n:find("slap")) and true or false
end

function _G.DeepRagIsRagdolled(hum)
    if not hum then return false end

    local st=hum:GetState()
    if st==Enum.HumanoidStateType.Physics
        or st==Enum.HumanoidStateType.Ragdoll
        or st==Enum.HumanoidStateType.FallingDown then
        return true
    end

    local et=LP:GetAttribute("RagdollEndTime")
    if type(et)=="number" and (et-_G.DeepRagServerNow())>0 then
        return true
    end

    return false
end

function _G.DeepRagRemaining()
    local now=_G.DeepRagServerNow()
    local best=0

    local et=LP:GetAttribute("RagdollEndTime")
    if type(et)=="number" then
        local rem=et-now
        if rem>best then best=rem end
    end

    for _,obj in ipairs({LP,LP.Character}) do
        if obj then
            local ok,attrs=pcall(function()
                return obj:GetAttributes()
            end)
            if ok and attrs then
                for k,v in pairs(attrs) do
                    local n=tostring(k):lower()
                    if type(v)=="number"
                        and (n:find("ragdoll") or n:find("stun")
                        or n:find("petrif") or n:find("stone") or n:find("medusa")) then

                        local rem=v-now
                        if rem>0 and rem<60 and rem>best then best=rem end
                        if v>0 and v<60 and v>best then best=v end
                    end
                end
            end
        end
    end

    return best
end

function _G.DeepRagIHoldMedusa()
    local char=LP.Character
    if not char then return false end

    for _,tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and _G.DeepRagStrHasMedusa(tool.Name) then
            return true
        end
    end
    return false
end

function _G.DeepRagInsideTool(obj)
    local p=obj
    while p and p~=LP.Character do
        if p:IsA("Tool") then return true end
        p=p.Parent
    end
    return false
end

function _G.DeepRagMedusaMarker()
    local char=LP.Character
    if not char then return false end

    for _,obj in ipairs({LP,char}) do
        local ok,attrs=pcall(function()
            return obj:GetAttributes()
        end)
        if ok and attrs then
            for k,v in pairs(attrs) do
                if _G.DeepRagStrHasMedusa(k) then
                    if v==true then return true end
                    if type(v)=="number" and v>_G.DeepRagServerNow() then return true end
                    if type(v)=="string" and v~="" then return true end
                end
            end
        end
    end

    for _,d in ipairs(char:GetDescendants()) do
        if not d:IsA("Tool")
            and not _G.DeepRagInsideTool(d)
            and _G.DeepRagStrHasMedusa(d.Name) then
            return true
        end
    end

    return false
end

function _G.DeepRagToolNearby(matcher)
    local myChar=LP.Character
    local myRoot=myChar and myChar:FindFirstChild("HumanoidRootPart")

    for _,plr in ipairs(Players:GetPlayers()) do
        if plr~=LP and plr.Character then
            local root=plr.Character:FindFirstChild("HumanoidRootPart")
            local near=(not myRoot) or (not root) or ((root.Position-myRoot.Position).Magnitude<=20)

            if near then
                for _,tool in ipairs(plr.Character:GetChildren()) do
                    if tool:IsA("Tool") and matcher(tool.Name) then
                        return true
                    end
                end
            end
        end
    end

    return false
end

function _G.DeepRagWatchSelfMedusa(char)
    local S=_G.DeepRagTimerState

    for _,conn in ipairs(S.selfMedusaConns or {}) do
        pcall(function()
            conn:Disconnect()
        end)
    end

    S.selfMedusaConns={}
    S.selfMedusaUntil=0

    if not char then return end

    local function hook(tool)
        if not tool or not tool:IsA("Tool") or not _G.DeepRagStrHasMedusa(tool.Name) then
            return
        end

        table.insert(S.selfMedusaConns,tool.Activated:Connect(function()
            S.selfMedusaUntil=os.clock()+8
        end))
    end

    for _,tool in ipairs(char:GetChildren()) do
        hook(tool)
    end

    table.insert(S.selfMedusaConns,char.ChildAdded:Connect(hook))
end

function _G.DeepRagSelfMedusaActive()
    return os.clock()<(_G.DeepRagTimerState.selfMedusaUntil or 0)
end

function _G.DeepRagIsMedusad()
    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if not hum or not _G.DeepRagIsRagdolled(hum) then return false end

    if _G.DeepRagSelfMedusaActive() then return false end
    if _G.DeepRagIHoldMedusa() then return false end

    if not _G.DeepRagToolNearby(_G.DeepRagStrHasMedusa) then
        return false
    end

    if _G.DeepRagMedusaMarker() then return true end
    if _G.DeepRagRemaining()>=4.0 then return true end

    return false
end

function _G.DeepRagHitDetected(hum)
    if not _G.DeepRagIsRagdolled(hum) then return false end
    if _G.DeepRagSelfMedusaActive() then return false end

    local batNear=_G.DeepRagToolNearby(_G.DeepRagStrHasBat)
    local medNear=(not _G.DeepRagIHoldMedusa()) and _G.DeepRagToolNearby(_G.DeepRagStrHasMedusa)

    if not (batNear or medNear) then
        return false
    end

    if _G.DeepRagRemaining()>0 then
        return true
    end

    local st=hum:GetState()
    return st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll
end

function _G.DeepRagClassifyHit()
    local rem=_G.DeepRagRemaining()
    local medNear=(not _G.DeepRagIHoldMedusa())
        and (not _G.DeepRagSelfMedusaActive())
        and _G.DeepRagToolNearby(_G.DeepRagStrHasMedusa)

    if medNear and (rem>=4.0 or _G.DeepRagMedusaMarker()) then
        return "medusa"
    end

    if medNear and not _G.DeepRagToolNearby(_G.DeepRagStrHasBat) then
        return "medusa"
    end

    return "bat"
end

function _G.DeepStartRagdollTimerGui(duration,force)
    local S=_G.DeepRagTimerState

    if S.active and not force then return end

    S.token=(S.token or 0)+1
    local myToken=S.token
    S.active=true

    task.spawn(function()
        local t0=os.clock()

        while S.token==myToken and S.active do
            local left=duration-(os.clock()-t0)
            if left<=0 then break end

            local lbl=_G.DeepRagTimerLabel()
            if lbl then
                lbl.Visible=true
                lbl.Text=string.format("%.1f",left)
                lbl.TextColor3=Color3.fromRGB(255,255,255)
            end

            task.wait(0.05)
        end

        if S.token~=myToken then return end

        if S.active then
            local lbl=_G.DeepRagTimerLabel()
            if lbl then
                lbl.Visible=true
                lbl.Text="STEAL!"
                lbl.TextColor3=Color3.fromRGB(255,255,255)
            end

            local waited=0
            repeat
                task.wait(0.1)
                waited=waited+0.1

                if S.token~=myToken then return end

                local char=LP.Character
                local hum=char and char:FindFirstChildOfClass("Humanoid")
                if not hum or not _G.DeepRagIsRagdolled(hum) then
                    break
                end
            until waited>=3
        end

        if S.token~=myToken then return end

        local lbl=_G.DeepRagTimerLabel()
        if lbl then
            lbl.Text=""
            lbl.Visible=false
        end

        S.active=false
    end)
end

function _G.DeepStartRagdollTimerSystem(char)
    local S=_G.DeepRagTimerState

    if S.conn then
        pcall(function()
            S.conn:Disconnect()
        end)
        S.conn=nil
    end

    pcall(function()
        _G.DeepRagWatchSelfMedusa(char)
    end)

    S.wasRagdolled=false
    S.lastTrigger=0
    S.clearSince=0
    S.lockUntil=0
    S.hitKind=nil
    S.hitAt=0

    S.conn=RunService.Heartbeat:Connect(function()
        if not _G.DeepRagdollTimerEnabled then
            S.wasRagdolled=false
            S.lockUntil=0
            return
        end

        local hum=char and char.Parent and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end

        local med=_G.DeepRagIsMedusad()
        local rag=med or _G.DeepRagHitDetected(hum)
        local nowc=os.clock()

        if rag then
            S.clearSince=0
        else
            if S.clearSince==0 then
                S.clearSince=nowc
            end

            if (nowc-S.clearSince)<0.6 then
                rag=S.wasRagdolled
            end
        end

        if nowc<(S.lockUntil or 0) then
            rag=true
        elseif not rag then
            S.lockUntil=0
        end

        if rag
            and not S.wasRagdolled
            and nowc>=(S.lockUntil or 0)
            and (nowc-(S.lastTrigger or 0))>=1.2 then

            S.lastTrigger=nowc

            local kind=med and "medusa" or _G.DeepRagClassifyHit()
            local cfg=_G.DeepRagTimerCfg[kind] or _G.DeepRagTimerCfg.bat

            S.lockUntil=nowc+(cfg.timer or 2.8)+0.5
            S.hitKind=kind
            S.hitAt=nowc

            _G.DeepStartRagdollTimerGui(cfg.timer or 2.8,true)

        elseif rag
            and S.hitKind=="bat"
            and med
            and (nowc-(S.hitAt or 0))<1.2 then

            local elapsed=nowc-(S.hitAt or nowc)
            S.hitKind="medusa"

            _G.DeepStartRagdollTimerGui(
                math.max(0.1,(_G.DeepRagTimerCfg.medusa.timer or 5.7)-elapsed),
                true
            )
        end

        S.wasRagdolled=rag
    end)
end

local function startAntiRagdoll() 
    if Conns.antiRag then return end 
    Conns.antiRag=RunService.Heartbeat:Connect(function() 
        if not antiRagdollEnabled then return end 
        local char=LP.Character 
        if not char then return end 
        local hum=char:FindFirstChildOfClass("Humanoid") 
        if not hum or hum.Health <= 0 then return end 
        local state=hum:GetState() 
        local isRagdolled = state==Enum.HumanoidStateType.Physics or state==Enum.HumanoidStateType.Ragdoll or state==Enum.HumanoidStateType.FallingDown 
        if isRagdolled then 
            pcall(function() 
                hum:ChangeState(Enum.HumanoidStateType.GettingUp) 
                local root=char:FindFirstChild("HumanoidRootPart") 
                if root then 
                    root.Velocity=Vector3.zero 
                    root.RotVelocity=Vector3.zero 
                    root.AssemblyLinearVelocity=Vector3.zero 
                    root.AssemblyAngularVelocity=Vector3.zero 
                end 
                for _,obj in ipairs(char:GetDescendants()) do 
                    if obj:IsA("Motor6D") then obj.Enabled=true end 
                    if obj:IsA("Constraint") then obj.Enabled=true end 
                end 
                workspace.CurrentCamera.CameraSubject=hum 
                local PM=LP.PlayerScripts:FindFirstChild("PlayerModule") 
                if PM then 
                    local CM=require(PM:FindFirstChild("ControlModule")) 
                    if CM then CM:Enable() end 
                end 
                hum.AutoRotate=true 
                hum.PlatformStand=false 
                hum.Sit=false 
            end) 
        end 
    end) 
end 
local function stopAntiRagdoll() 
    if Conns.antiRag then Conns.antiRag:Disconnect();Conns.antiRag=nil end 
end 
local InfJumpPlatform = nil 
local function CreateIJP() 
    if InfJumpPlatform then return end 
    InfJumpPlatform = Instance.new("Part") 
    InfJumpPlatform.Name = "InfJumpPlatform" 
    InfJumpPlatform.Size = Vector3.new(8, 0.5, 8) 
    InfJumpPlatform.Anchored = true 
    InfJumpPlatform.CanCollide = true 
    InfJumpPlatform.Transparency = 1 
    InfJumpPlatform.Material = Enum.Material.ForceField 
    InfJumpPlatform.Parent = workspace 
end 
CreateIJP() 
RunService.Heartbeat:Connect(function() 
    if not infJumpEnabled then 
        if InfJumpPlatform then InfJumpPlatform.Position = Vector3.new(0, -1000, 0) end 
        return 
    end 
    local char = LP.Character 
    local root = char and char:FindFirstChild("HumanoidRootPart") 
    local hum = char and char:FindFirstChildOfClass("Humanoid") 
    if not (char and root and hum) then 
        if InfJumpPlatform then InfJumpPlatform.Position = Vector3.new(0, -1000, 0) end 
        return 
    end 
    local isJumping = UIS:IsKeyDown(Enum.KeyCode.Space) or hum:GetState() == Enum.HumanoidStateType.Jumping or hum.Jump 
    if isJumping then 
        if not InfJumpPlatform then CreateIJP() end 
        InfJumpPlatform.Position = root.Position - Vector3.new(0, 3.5, 0) 
        if root.Velocity.Y < 50 then 
            root.Velocity = Vector3.new(root.Velocity.X, 50, root.Velocity.Z) 
        end 
    else 
        if InfJumpPlatform then InfJumpPlatform.Position = Vector3.new(0, -1000, 0) end 
    end 
end) 
local function startUnwalk() 
    local c=LP.Character;if not c then return end 
    local hum=c:FindFirstChildOfClass("Humanoid") 
    if hum then 
        for _,t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end 
    end 
    local anim=c:FindFirstChild("Animate") 
    if anim then unwalkSavedAnimate=anim:Clone();anim:Destroy() end 
end 
local function stopUnwalk() 
    local c=LP.Character 
    if c and unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent=c;unwalkSavedAnimate=nil end 
end 

-- ============================================================
-- MAY ANIMATION PACKS - portados para o MAIN do Deep
-- ============================================================
_G.DeepAnimPack = _G.DeepAnimPack or {}
_G.DeepAnimPack.selected = "OFF"
_G.DeepAnimPack.index = 1
_G.DeepAnimPack.file = "DeepDuels_AnimPack.txt"
_G.DeepAnimPack.list = {
    "OFF","Unwalk","Hit Harder","Zombie","Ninja","Knight","Elder",
    "Levitate","Astronaut","Pirate","Toy","Vampire","Werewolf","Rthro","Stylish"
}
_G.DeepAnimPack.packs = {
    ["Zombie"]    = {idle={{"rbxassetid://616158929",1},{"rbxassetid://616158929",1}},walk="rbxassetid://616168032",run="rbxassetid://616163682",jump="rbxassetid://616161997",fall="rbxassetid://616157476",climb="rbxassetid://616156119"},
    ["Ninja"]     = {idle={{"rbxassetid://656117400",1},{"rbxassetid://656117400",1}},walk="rbxassetid://656121766",run="rbxassetid://656118852",jump="rbxassetid://656117878",fall="rbxassetid://656115606",climb="rbxassetid://656114359"},
    ["Knight"]    = {idle={{"rbxassetid://657595757",1},{"rbxassetid://657595757",1}},walk="rbxassetid://657552124",run="rbxassetid://657564596",jump="rbxassetid://658409194",fall="rbxassetid://657600338",climb="rbxassetid://658360781"},
    ["Elder"]     = {idle={{"rbxassetid://845397899",1},{"rbxassetid://845397899",1}},walk="rbxassetid://845403856",run="rbxassetid://845386501",jump="rbxassetid://845398858",fall="rbxassetid://845397673",climb="rbxassetid://845392038"},
    ["Levitate"]  = {idle={{"rbxassetid://616006778",1},{"rbxassetid://616006778",1}},walk="rbxassetid://616013216",run="rbxassetid://616013216",jump="rbxassetid://616008936",fall="rbxassetid://616005863",climb="rbxassetid://616003713"},
    ["Astronaut"] = {idle={{"rbxassetid://891621366",1},{"rbxassetid://891621366",1}},walk="rbxassetid://891636393",run="rbxassetid://891636393",jump="rbxassetid://891627522",fall="rbxassetid://891617961",climb="rbxassetid://891609353"},
    ["Pirate"]    = {idle={{"rbxassetid://750781874",1},{"rbxassetid://750781874",1}},walk="rbxassetid://750785693",run="rbxassetid://750783738",jump="rbxassetid://750782230",fall="rbxassetid://750780242",climb="rbxassetid://750779899"},
    ["Toy"]       = {idle={{"rbxassetid://782841498",1},{"rbxassetid://782841498",1}},walk="rbxassetid://782843345",run="rbxassetid://782842708",jump="rbxassetid://782847020",fall="rbxassetid://782846423",climb="rbxassetid://782843869"},
    ["Vampire"]   = {idle={{"rbxassetid://1083445855",1},{"rbxassetid://1083445855",1}},walk="rbxassetid://1083473930",run="rbxassetid://1083462077",jump="rbxassetid://1083455352",fall="rbxassetid://1083443587",climb="rbxassetid://1083439238"},
    ["Werewolf"]  = {idle={{"rbxassetid://1083195517",1},{"rbxassetid://1083195517",1}},walk="rbxassetid://1083178339",run="rbxassetid://1083216690",jump="rbxassetid://1083218792",fall="rbxassetid://1083189019",climb="rbxassetid://1083182000"},
    ["Rthro"]     = {idle={{"rbxassetid://2510196951",1},{"rbxassetid://2510196951",1}},walk="rbxassetid://2510202577",run="rbxassetid://2510198475",jump="rbxassetid://2510197830",fall="rbxassetid://2510195892",climb="rbxassetid://2510192778"},
    ["Stylish"]   = {idle={{"rbxassetid://616136790",1},{"rbxassetid://616136790",1}},walk="rbxassetid://616146177",run="rbxassetid://616140816",jump="rbxassetid://616139451",fall="rbxassetid://616134815",climb="rbxassetid://616133594"},
}
_G.DeepAnimPack.hitHarder = {
    idle1="rbxassetid://133806214992291",
    idle2="rbxassetid://94970088341563",
    walk="rbxassetid://707897309",
    run="rbxassetid://707861613",
    jump="rbxassetid://116936326516985",
    fall="rbxassetid://116936326516985",
}
_G.DeepAnimPack.original = {}

function _G.DeepAnimPack.getAnimate(char)
    char=char or LP.Character
    return char and char:FindFirstChild("Animate") or nil
end

function _G.DeepAnimPack.stopTracks(char)
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    for _,track in ipairs(hum:GetPlayingAnimationTracks()) do
        pcall(function() track:Stop(0) end)
    end
end

function _G.DeepAnimPack.setId(obj,id)
    if obj and id then pcall(function() obj.AnimationId=id end) end
end

function _G.DeepAnimPack.reload(animate)
    if not animate then return end
    pcall(function()
        animate.Disabled=true
        task.wait()
        animate.Disabled=false
    end)
end

function _G.DeepAnimPack.backup(char)
    local animate=_G.DeepAnimPack.getAnimate(char)
    if not animate or next(_G.DeepAnimPack.original)~=nil then return end
    local function gid(obj) return obj and obj.AnimationId or nil end
    _G.DeepAnimPack.original={
        idle1=gid(animate.idle and animate.idle:FindFirstChild("Animation1")),
        idle2=gid(animate.idle and animate.idle:FindFirstChild("Animation2")),
        walk=gid(animate.walk and animate.walk:FindFirstChild("WalkAnim")),
        run=gid(animate.run and animate.run:FindFirstChild("RunAnim")),
        jump=gid(animate.jump and animate.jump:FindFirstChild("JumpAnim")),
        fall=gid(animate.fall and animate.fall:FindFirstChild("FallAnim")),
        climb=gid(animate.climb and animate.climb:FindFirstChild("ClimbAnim")),
    }
end

function _G.DeepAnimPack.reset()
    local char=LP.Character
    local animate=_G.DeepAnimPack.getAnimate(char)
    if not animate or next(_G.DeepAnimPack.original)==nil then return end
    _G.DeepAnimPack.stopTracks(char)
    local o=_G.DeepAnimPack.original
    _G.DeepAnimPack.setId(animate.idle and animate.idle:FindFirstChild("Animation1"),o.idle1)
    _G.DeepAnimPack.setId(animate.idle and animate.idle:FindFirstChild("Animation2"),o.idle2)
    _G.DeepAnimPack.setId(animate.walk and animate.walk:FindFirstChild("WalkAnim"),o.walk)
    _G.DeepAnimPack.setId(animate.run and animate.run:FindFirstChild("RunAnim"),o.run)
    _G.DeepAnimPack.setId(animate.jump and animate.jump:FindFirstChild("JumpAnim"),o.jump)
    _G.DeepAnimPack.setId(animate.fall and animate.fall:FindFirstChild("FallAnim"),o.fall)
    _G.DeepAnimPack.setId(animate.climb and animate.climb:FindFirstChild("ClimbAnim"),o.climb)
    _G.DeepAnimPack.reload(animate)
end

function _G.DeepAnimPack.save(pack)
    pcall(function()
        if writefile then writefile(_G.DeepAnimPack.file,tostring(pack or "OFF")) end
    end)
end

function _G.DeepAnimPack.valid(pack)
    for _,name in ipairs(_G.DeepAnimPack.list) do
        if name==pack then return true end
    end
    return false
end

function _G.DeepAnimPack.load()
    local pack=nil
    pcall(function()
        if isfile and readfile and isfile(_G.DeepAnimPack.file) then
            pack=tostring(readfile(_G.DeepAnimPack.file) or "")
            pack=pack:gsub("^%s+",""):gsub("%s+$","")
        end
    end)
    if not _G.DeepAnimPack.valid(pack) then pack="OFF" end
    _G.DeepAnimPack.selected=pack
    for i,name in ipairs(_G.DeepAnimPack.list) do
        if name==pack then _G.DeepAnimPack.index=i break end
    end
    return pack
end

function _G.DeepAnimPack.apply(packName)
    if not _G.DeepAnimPack.valid(packName) then packName="OFF" end

    local previous=_G.DeepAnimPack.selected
    _G.DeepAnimPack.selected=packName
    _G.DeepAnimPack.save(packName)

    -- Sai do Unwalk antes de aplicar qualquer outro pack.
    if packName~="Unwalk" and (unwalkEnabled or previous=="Unwalk") then
        unwalkEnabled=false
        pcall(stopUnwalk)
    end

    local char=LP.Character
    if not char then return false end

    local animate=_G.DeepAnimPack.getAnimate(char)
    if not animate then
        animate=char:FindFirstChild("Animate") or char:WaitForChild("Animate",3)
    end

    if packName=="Unwalk" then
        if animate then
            _G.DeepAnimPack.backup(char)
            _G.DeepAnimPack.reset()
        end
        unwalkEnabled=true
        pcall(startUnwalk)
        return true
    end

    if not animate then return false end
    _G.DeepAnimPack.backup(char)

    if packName=="OFF" then
        _G.DeepAnimPack.reset()
        return true
    end

    _G.DeepAnimPack.stopTracks(char)

    if packName=="Hit Harder" then
        local h=_G.DeepAnimPack.hitHarder
        _G.DeepAnimPack.setId(animate.idle and animate.idle:FindFirstChild("Animation1"),h.idle1)
        _G.DeepAnimPack.setId(animate.idle and animate.idle:FindFirstChild("Animation2"),h.idle2)
        _G.DeepAnimPack.setId(animate.walk and animate.walk:FindFirstChild("WalkAnim"),h.walk)
        _G.DeepAnimPack.setId(animate.run and animate.run:FindFirstChild("RunAnim"),h.run)
        _G.DeepAnimPack.setId(animate.jump and animate.jump:FindFirstChild("JumpAnim"),h.jump)
        _G.DeepAnimPack.setId(animate.fall and animate.fall:FindFirstChild("FallAnim"),h.fall)
        _G.DeepAnimPack.reload(animate)
        return true
    end

    local pack=_G.DeepAnimPack.packs[packName]
    if not pack then return false end
    _G.DeepAnimPack.setId(animate.idle and animate.idle:FindFirstChild("Animation1"),pack.idle[1][1])
    _G.DeepAnimPack.setId(animate.idle and animate.idle:FindFirstChild("Animation2"),pack.idle[2][1])
    _G.DeepAnimPack.setId(animate.walk and animate.walk:FindFirstChild("WalkAnim"),pack.walk)
    _G.DeepAnimPack.setId(animate.run and animate.run:FindFirstChild("RunAnim"),pack.run)
    _G.DeepAnimPack.setId(animate.jump and animate.jump:FindFirstChild("JumpAnim"),pack.jump)
    _G.DeepAnimPack.setId(animate.fall and animate.fall:FindFirstChild("FallAnim"),pack.fall)
    _G.DeepAnimPack.setId(animate.climb and animate.climb:FindFirstChild("ClimbAnim"),pack.climb)
    _G.DeepAnimPack.reload(animate)
    return true
end

function _G.DeepAnimPack.setIndex(idx)
    if idx<1 then idx=#_G.DeepAnimPack.list end
    if idx>#_G.DeepAnimPack.list then idx=1 end
    _G.DeepAnimPack.index=idx
    local pack=_G.DeepAnimPack.list[idx]
    _G.DeepAnimPack.apply(pack)
    if _G.DeepAnimPack.refresh then pcall(_G.DeepAnimPack.refresh) end
    return pack
end

_G.DeepAnimPack.load()

LP.CharacterAdded:Connect(function(char)
    task.defer(function()
        task.wait(0.35)
        if LP.Character~=char then return end
        _G.DeepAnimPack.original={}
        unwalkSavedAnimate=nil
        local pack=_G.DeepAnimPack.selected or "OFF"
        if pack~="OFF" then pcall(function() _G.DeepAnimPack.apply(pack) end) end
    end)
end)

task.spawn(function()
    task.wait(0.5)
    local pack=_G.DeepAnimPack.selected or "OFF"
    if pack~="OFF" then pcall(function() _G.DeepAnimPack.apply(pack) end) end
end)

local DROP_ASCEND_DURATION = 0.22
local DROP_ASCEND_SPEED = 160
local _dropConn = nil
local jumpDropActive = false
local dropVersion = "JUMP"
local lastDropTime = 0
local dropConnections = {}

local function setDropMobileState(on)
    if mobBtnRefs and mobBtnRefs.drop then
        pcall(mobBtnRefs.drop,on==true)
    end
end

local function refreshDropMobileLabel()
    local ref=mobBtnTextRefs and mobBtnTextRefs.drop
    if ref then
        if ref.top then ref.top.Text="DROP" end
        if ref.bot then ref.bot.Text=(dropVersion=="FLIGHT") and "FLIGHT" or "JUMP" end
    end
end

local function setDropVersion(version)
    version=tostring(version or "JUMP"):upper()
    if version~="FLIGHT" and version~="JUMP" then version="JUMP" end
    dropVersion=version
    refreshDropMobileLabel()
    if _G.DeepRefreshDropVersionUI then pcall(_G.DeepRefreshDropVersionUI) end
    pcall(saveConfig)
end

local function runJumpDrop()
    if jumpDropActive or dropActive then return end
    local char=LP.Character
    if not char then return end
    local root=char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    jumpDropActive=true
    setDropMobileState(true)

    local t0=tick()
    if _dropConn then _dropConn:Disconnect() end

    _dropConn=RunService.Heartbeat:Connect(function()
        local c=LP.Character
        local r=c and c:FindFirstChild("HumanoidRootPart")
        if not r then
            if _dropConn then _dropConn:Disconnect();_dropConn=nil end
            jumpDropActive=false
            setDropMobileState(false)
            return
        end

        if not jumpDropActive then
            if _dropConn then _dropConn:Disconnect();_dropConn=nil end
            setDropMobileState(false)
            return
        end

        if tick()-t0>=DROP_ASCEND_DURATION then
            if _dropConn then _dropConn:Disconnect();_dropConn=nil end
            pcall(function()
                local rp=RaycastParams.new()
                rp.FilterDescendantsInstances={c}
                rp.FilterType=Enum.RaycastFilterType.Exclude
                local rr=workspace:Raycast(r.Position,Vector3.new(0,-3000,0),rp)
                if rr then
                    local hum=c:FindFirstChildOfClass("Humanoid")
                    local off=((hum and hum.HipHeight) or 2)+(r.Size.Y/2)
                    r.CFrame=CFrame.new(r.Position.X,rr.Position.Y+off,r.Position.Z)
                    r.AssemblyLinearVelocity=Vector3.zero
                    r.AssemblyAngularVelocity=Vector3.zero
                end
            end)
            jumpDropActive=false
            setDropMobileState(false)
            return
        end

        local lv=r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity=Vector3.new(lv.X,DROP_ASCEND_SPEED,lv.Z)
    end)
end

local function stopFlightDrop()
    dropActive=false
    for i=#dropConnections,1,-1 do
        local item=dropConnections[i]
        if typeof(item)=="RBXScriptConnection" then
            pcall(function() item:Disconnect() end)
        elseif type(item)=="thread" then
            pcall(task.cancel,item)
        end
        table.remove(dropConnections,i)
    end
    setDropMobileState(false)
end

local function runFlightDrop()
    if dropActive or jumpDropActive then return end

    local char=LP.Character
    local root=char and char:FindFirstChild("HumanoidRootPart")
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end

    local velNow=root.AssemblyLinearVelocity
    local speedH=Vector3.new(velNow.X,0,velNow.Z).Magnitude
    local cooldown=(speedH>5) and 0.6 or 0.25
    if tick()-lastDropTime<cooldown then return end
    lastDropTime=tick()

    dropActive=true
    setDropMobileState(true)

    local wasAutoBat=autoBatEnabled==true
    if wasAutoBat then
        autoBatEnabled=false
        if resetAutoBatMotion then pcall(resetAutoBatMotion) end
        if autoBatSetVisual then pcall(autoBatSetVisual,false) end
        if mobBtnRefs and mobBtnRefs.autoBat then pcall(mobBtnRefs.autoBat,false) end
    end

    local finished=false
    local function finishDrop(threadRef)
        if finished then return end
        finished=true

        if threadRef then
            for i=#dropConnections,1,-1 do
                if dropConnections[i]==threadRef then
                    table.remove(dropConnections,i)
                    break
                end
            end
        end

        dropActive=false

        local c=LP.Character
        if c then
            local r=c:FindFirstChild("HumanoidRootPart")
            local h=c:FindFirstChildOfClass("Humanoid")
            if r then
                r.AssemblyLinearVelocity=Vector3.zero
                r.AssemblyAngularVelocity=Vector3.zero

                if r.Position.Y < -100 then
                    r.CFrame=CFrame.new(r.Position.X,5,r.Position.Z)
                end

                local rp=RaycastParams.new()
                rp.FilterDescendantsInstances={c}
                rp.FilterType=Enum.RaycastFilterType.Exclude
                local rr=workspace:Raycast(r.Position,Vector3.new(0,-2000,0),rp)
                if rr then
                    local off=((h and h.HipHeight) or 2)+(r.Size.Y/2)
                    r.CFrame=CFrame.new(r.Position.X,rr.Position.Y+off,r.Position.Z)
                end

                if h and h.Health>0 then
                    h:ChangeState(Enum.HumanoidStateType.Running)
                end
            end
        end

        if wasAutoBat then
            autoBatEnabled=true
            if queueAutoBatStart then pcall(queueAutoBatStart) end
            if autoBatSetVisual then pcall(autoBatSetVisual,true) end
            if mobBtnRefs and mobBtnRefs.autoBat then pcall(mobBtnRefs.autoBat,true) end
        end

        setDropMobileState(false)
    end

    local flightThread
    flightThread=task.spawn(function()
        local startTime=tick()
        while dropActive and (tick()-startTime)<0.25 do
            RunService.Heartbeat:Wait()
            local c=LP.Character
            local r=c and c:FindFirstChild("HumanoidRootPart")
            if not r then break end

            local vel=r.AssemblyLinearVelocity
            vel=Vector3.new(0,vel.Y,0)
            r.AssemblyLinearVelocity=vel*10000+Vector3.new(0,10000,0)

            RunService.RenderStepped:Wait()
            if r and r.Parent then
                r.AssemblyLinearVelocity=vel
            end

            RunService.Stepped:Wait()
            if r and r.Parent then
                r.AssemblyLinearVelocity=vel+Vector3.new(0,0.1,0)
            end
        end
        finishDrop(flightThread)
    end)

    table.insert(dropConnections,flightThread)

    task.delay(0.35,function()
        if dropActive then
            finishDrop(flightThread)
        end
    end)
end

local function runSelectedDrop()
    if dropVersion=="FLIGHT" then
        runFlightDrop()
    else
        runJumpDrop()
    end
end

function runDropKeybindBurst()
    runSelectedDrop()
end

local function doTPDown(force) 
    local char=LP.Character;if not char then return end 
    local hrp=char:FindFirstChild("HumanoidRootPart");if not hrp then return end 
    local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end 
    if not force then 
        if hum2.FloorMaterial~=Enum.Material.Air then return end 
        if hrp.Position.Y<autoTPHeight then return end 
    end 
    hrp.CFrame=CFrame.new(hrp.Position.X,-7.00,hrp.Position.Z) *CFrame.Angles(0,select(2,hrp.CFrame:ToEulerAnglesYXZ()),0) 
    hrp.AssemblyLinearVelocity=Vector3.zero 
    hrp.Velocity=Vector3.zero 
end 
local function runTPFloor() 
    pcall(function() doTPDown(true) end) 
end 
local defLightBrightness,defLightClock,defLightAmbient 
pcall(function() 
    if not getgenv().Resolution then getgenv().Resolution = { [".gg/scripters"] = 0.65 } end 
end) 
local enableStretchRez, disableStretchRez 
do 
    local stretchRezOriginalCFrame=nil 
    function enableStretchRez() 
        stretchRezEnabled=true 
        local camera=workspace.CurrentCamera 
        if stretchRezConn then stretchRezConn:Disconnect() end 
        stretchRezOriginalCFrame=camera.CFrame 
        stretchRezConn=RunService.RenderStepped:Connect(function() 
            if not stretchRezEnabled then stretchRezConn:Disconnect(); stretchRezConn=nil; return end 
            local cam=workspace.CurrentCamera 
            local scaleY=(getgenv().Resolution and getgenv().Resolution[".gg/scripters"]) or 0.65 
            if cam then 
                cam.CFrame=cam.CFrame*CFrame.new(0,0,0,1,0,0,0,scaleY,0,0,0,1) 
            end 
        end) 
    end 
    function disableStretchRez() 
        stretchRezEnabled=false 
        if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn=nil end 
        if stretchRezOriginalCFrame then 
            local cam=workspace.CurrentCamera; if cam then cam.CFrame=stretchRezOriginalCFrame end 
        end 
    end 
end 
local function applyAntiLagDerender(obj) 
    pcall(function() 
        if obj:IsA("Accessory") or obj:IsA("Hat") then obj:Destroy() 
        elseif obj:IsA("BasePart") then obj.Material=Enum.Material.Plastic;obj.Reflectance=0;obj.CastShadow=false 
        elseif obj:IsA("Decal") or obj:IsA("Texture") then obj.Transparency=1 
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then obj.Enabled=false 
        elseif obj:IsA("AnimationController") or obj:IsA("Animator") then 
            for _,t in ipairs(obj:GetPlayingAnimationTracks()) do pcall(function() t:Stop(0) end) end 
        end 
    end) 
end 
local function enableAntiLag() 
    removeAccessoriesEnabled=true 
    antiLagEnabled=true 
    defLightBrightness=defLightBrightness or Lighting.Brightness 
    defLightClock=defLightClock or Lighting.ClockTime 
    defLightAmbient=defLightAmbient or Lighting.OutdoorAmbient 
    Lighting.GlobalShadows=false;Lighting.FogEnd=1e10;Lighting.Brightness=1 
    Lighting.EnvironmentDiffuseScale=0;Lighting.EnvironmentSpecularScale=0 
    for _,e in pairs(Lighting:GetChildren()) do 
        pcall(function() 
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then 
                e.Enabled=false 
            end 
        end) 
    end 
    for _,obj in ipairs(workspace:GetDescendants()) do applyAntiLagDerender(obj) end 
    if antiLagDescConn then antiLagDescConn:Disconnect() end 
    antiLagDescConn=workspace.DescendantAdded:Connect(function(obj) 
        if removeAccessoriesEnabled then applyAntiLagDerender(obj) end 
    end) 
end 
local function disableAntiLag() 
    removeAccessoriesEnabled=false 
    antiLagEnabled=false 
    if antiLagDescConn then antiLagDescConn:Disconnect();antiLagDescConn=nil end 
    pcall(function() 
        if defLightBrightness then Lighting.Brightness=defLightBrightness end 
        if defLightClock then Lighting.ClockTime=defLightClock end 
        if defLightAmbient then Lighting.OutdoorAmbient=defLightAmbient end 
        Lighting.ExposureCompensation=0 
    end) 
end 
local function findMedusa() 
    local c=LP.Character;if not c then return nil end 
    for _,t in ipairs(c:GetChildren()) do 
        if t:IsA("Tool") then 
            local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end 
        end 
    end 
    local bp=LP:FindFirstChild("Backpack") 
    if bp then 
        for _,t in ipairs(bp:GetChildren()) do 
            if t:IsA("Tool") then 
                local n=t.Name:lower();if n:find("medusa") or n:find("head") or n:find("stone") then return t end 
            end 
        end 
    end 
    return nil 
end 
local function useMedusaCounter() 
    if medusaDebounce then return end;if tick()-medusaLastUsed<MEDUSA_COOLDOWN then return end 
    local c=LP.Character;if not c then return end;medusaDebounce=true 
    local med=findMedusa();if not med then medusaDebounce=false;return end 
    if med.Parent~=c then 
        local hum2=c:FindFirstChildOfClass("Humanoid");if hum2 then hum2:EquipTool(med) end 
    end 
    pcall(function() med:Activate() end);medusaLastUsed=tick();medusaDebounce=false 
end 
local function onAnchorChanged(part) 
    return part:GetPropertyChangedSignal("Anchored"):Connect(function() 
        if part.Anchored and part.Transparency==1 then useMedusaCounter() end 
    end) 
end 
local function setupMedusa(char) 
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={} 
    if not char then return end 
    for _,part in ipairs(char:GetDescendants()) do 
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end 
    end 
    table.insert(Conns.anchor,char.DescendantAdded:Connect(function(part) 
        if part:IsA("BasePart") then table.insert(Conns.anchor,onAnchorChanged(part)) end 
    end)) 
end 
local function stopMedusaCounter() 
    for _,c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end;Conns.anchor={} 
end 
local BAT_COUNTER_SLAP_LIST={"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"} 
local function findBatForCounter() 
    local c=LP.Character;if not c then return nil end 
    local bp=LP:FindFirstChildOfClass("Backpack") 
    for _,name in ipairs(BAT_COUNTER_SLAP_LIST) do 
        local t=c:FindFirstChild(name) or (bp and bp:FindFirstChild(name));if t then return t end 
    end 
    for _,ch in ipairs(c:GetChildren()) do 
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end 
    end 
    if bp then 
        for _,ch in ipairs(bp:GetChildren()) do 
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end 
        end 
    end 
    return nil 
end 
local function swingBatForCounter(bat,char) 
    local hum2=char:FindFirstChildOfClass("Humanoid") 
    if bat.Parent~=char then 
        if hum2 then pcall(function() hum2:EquipTool(bat) end) end;task.wait(0.05) 
    end 
    local remote=bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction") 
    if remote and remote:IsA("RemoteEvent") then 
        pcall(function() remote:FireServer() end);task.wait(0.15);pcall(function() remote:FireServer() end) 
    else 
        pcall(function() bat:Activate() end);task.wait(0.15);pcall(function() bat:Activate() end) 
    end 
end 
startBatCounter=function() 
    if Conns.batCounter then return end 
    Conns.batCounter=RunService.Heartbeat:Connect(function() 
        if not batCounterEnabled then return end 
        if batCounterDebounce then return end 
        local char=LP.Character;if not char then return end 
        local hum2=char:FindFirstChildOfClass("Humanoid");if not hum2 then return end 
        local st=hum2:GetState() 
        if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then 
            batCounterDebounce=true 
            task.spawn(function() 
                local bat=findBatForCounter() 
                if bat then swingBatForCounter(bat,char) end 
                task.wait(0.5);batCounterDebounce=false 
            end) 
        end 
    end) 
end 
stopBatCounter=function() 
    if Conns.batCounter then Conns.batCounter:Disconnect();Conns.batCounter=nil end 
    batCounterDebounce=false 
end 
local function findBat() 
    local char=LP.Character; if not char then return nil end 
    for _,tool in ipairs(char:GetChildren()) do 
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end 
    end 
    local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack") 
    if bp then 
        for _,tool in ipairs(bp:GetChildren()) do 
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end 
        end 
    end 
    return nil 
end 
local function getAutoBatTarget() 
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") 
    if not root then return nil end 
    local closest,minDist=nil,math.huge 
    for _,plr in ipairs(Players:GetPlayers()) do 
        if plr~=LP and plr.Character then 
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart") 
            local hum=plr.Character:FindFirstChildOfClass("Humanoid") 
            if tRoot and hum and hum.Health>0 then 
                local dist=(tRoot.Position-root.Position).Magnitude 
                if dist<minDist then minDist=dist;closest=tRoot end 
            end 
        end 
    end 
    return closest 
end 
resetAutoBatMotion=function() 
    local char=LP.Character 
    local hrp=char and char:FindFirstChild("HumanoidRootPart") 
    local hum=char and char:FindFirstChildOfClass("Humanoid") 
    if hrp then hrp.AssemblyLinearVelocity=Vector3.zero;hrp.AssemblyAngularVelocity=Vector3.zero end 
    if hum then hum.AutoRotate=true end 
end 
local function enableAutoBat() 
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end 
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end 
    local char=LP.Character 
    if char then 
        local hum2=char:FindFirstChildOfClass("Humanoid") 
        if hum2 then hum2.AutoRotate=false end 
    end 
    autoBatEnabled=true 
end 
local function disableAutoBat() 
    autoBatEnabled=false 
    local char=LP.Character 
    if char then 
        local hum2=char:FindFirstChildOfClass("Humanoid") 
        if hum2 then hum2.AutoRotate=true end 
    end 
    if resetAutoBatMotion then resetAutoBatMotion() end 
end 
local function queueAutoLeftStart() 
    autoLeftEnabled=true 
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end 
    if autoBatEnabled then disableAutoBat();if autoBatSetVisual then autoBatSetVisual(false) end end 
    startAutoLeft() 
end 
local function queueAutoRightStart() 
    autoRightEnabled=true 
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end 
    if autoBatEnabled then disableAutoBat();if autoBatSetVisual then autoBatSetVisual(false) end end 
    startAutoRight() 
end 
queueAutoBatStart=function() 
    if autoLeftEnabled then autoLeftEnabled=false;if autoLeftSetVisual then autoLeftSetVisual(false) end;stopAutoLeft() end 
    if autoRightEnabled then autoRightEnabled=false;if autoRightSetVisual then autoRightSetVisual(false) end;stopAutoRight() end 
    enableAutoBat() 
end 
RunService.Heartbeat:Connect(function() 
    if not autoBatEnabled then return end 
    local char=LP.Character 
    local hum=char and char:FindFirstChildOfClass("Humanoid") 
    local root=char and char:FindFirstChild("HumanoidRootPart") 
    if not root or not hum then return end 
    if not char:FindFirstChildOfClass("Tool") then 
        local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack") 
        local bpBat=bp and bp:FindFirstChild("Bat") 
        if bpBat then pcall(function() hum:EquipTool(bpBat) end) end 
    end 
    local target=getAutoBatTarget() 
    if target then 
        local targetVel=target.AssemblyLinearVelocity 
        local targetPos=target.Position 
        local myPos=root.Position 
        local predictPos=targetPos+targetVel*0.14 
        predictPos=predictPos+target.CFrame.LookVector*0.3 
        local direction=predictPos-myPos 
        local flatDir=Vector3.new(direction.X,0,direction.Z) 
        if flatDir.Magnitude>0 then flatDir=flatDir.Unit else flatDir=Vector3.zero end 
        local chaseSpeed=AUTO_BAT_SPEED 
        local desiredHeight=targetPos.Y+3.7 
        local yVel=(desiredHeight-myPos.Y)*19.5+targetVel.Y*0.8 
        if hum.FloorMaterial~=Enum.Material.Air then yVel=math.max(yVel,13) end 
        yVel=math.clamp(yVel,-70,110) 
        local desiredVel=Vector3.new(flatDir.X*chaseSpeed,yVel,flatDir.Z*chaseSpeed) 
        root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(desiredVel,0.8) 
        local speed3=targetVel.Magnitude 
        local predictTime=math.clamp(speed3/150,0.05,0.2) 
        local predictedPos=targetPos+targetVel*predictTime 
        local toPredict=predictedPos-myPos 
        if toPredict.Magnitude>0.1 then 
            hum.AutoRotate=false 
            local goalCF=CFrame.lookAt(myPos,predictedPos) 
            local diffCF=root.CFrame:Inverse()*goalCF 
            local rx,ry,rz=diffCF:ToEulerAnglesXYZ() 
            rx=math.clamp(rx,-2.5,2.5); ry=math.clamp(ry,-2.5,2.5); rz=math.clamp(rz,-2.5,2.5) 
            root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(rx*42,ry*42,rz*42)) 
        end 
    else 
        hum.AutoRotate=true 
        root.AssemblyAngularVelocity=Vector3.zero 
        root.AssemblyLinearVelocity=Vector3.zero 
    end 
    if autoSwingEnabled then 
        local bat=char:FindFirstChild("Bat") 
        if bat then pcall(function() bat:Activate() end) 
        else 
            local tool=char:FindFirstChildOfClass("Tool") 
            if tool then pcall(function() tool:Activate() end) end 
        end 
    end 
end) 
autoSwitchSpeedEnabled=false 
autoTurnOffSpeedEnabled=false 
autoSwitchLaggerSpeedEnabled=false 
autoSwitchSpeedConn=nil 
AUTO_SWITCH_THRESHOLD=25 
fpsBoostEnabled=false 
fovEnabled=false 
fovValue=90 
fovConn=nil 
setAutoSwitchSpeedVisual,setAutoTurnOffSpeedVisual,setAutoSwitchLaggerSpeedVisual,setFpsBoostVisual,setFovVisual=nil,nil,nil,nil,nil 
fovValueBox=nil 
function applyFPSBoost() 
    pcall(function() settings().Rendering.QualityLevel=Enum.QualityLevel.Level01 end) 
end 
if aimbot2Enabled==nil then aimbot2Enabled=false end
_G.DeepBatV2ManualEnabled = _G.DeepBatV2ManualEnabled or false
aimbot2Conn=aimbot2Conn or nil 
aimbot2PrevAutoRotate=aimbot2PrevAutoRotate or nil 
aimbot2HitCD=aimbot2HitCD or false
aimbot2LockedTarget=aimbot2LockedTarget or nil
setAimbot2Visual=setAimbot2Visual or nil 
AIMBOT2_SWING_CD=0.35 
AIMBOT2_HIT_DIST=15 
AIMBOT2_BAT_SLAP_LIST=AIMBOT2_BAT_SLAP_LIST or { 
    "Bat","Slap","Iron Slap","Gold Slap","Diamond Slap", 
    "Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap", 
    "Nuclear Slap","Galaxy Slap","Glitched Slap" 
} 
function aimbot2FindBat()
    local char=LP.Character if not char then return nil end

    for _,name in ipairs(AIMBOT2_BAT_SLAP_LIST) do
        local t=char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end

    local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
    if bp then
        for _,name in ipairs(AIMBOT2_BAT_SLAP_LIST) do
            local t=bp:FindFirstChild(name)
            if t and t:IsA("Tool") then return t end
        end
    end

    for _,ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then
            return ch
        end
    end

    if bp then
        for _,ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then
                return ch
            end
        end
    end

    return nil
end 
function aimbot2TrySwing()
    if aimbot2HitCD then return end
    aimbot2HitCD=true

    pcall(function()
        local char=LP.Character
        if not char then return end

        local hum=char:FindFirstChildOfClass("Humanoid")
        local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
        local bat=aimbot2FindBat()
        if not bat then return end

        local previous=char:FindFirstChildOfClass("Tool")
        local autoEquipped=(bat.Parent~=char)

        if autoEquipped and hum then
            pcall(function() hum:EquipTool(bat) end)
        end

        pcall(function() bat:Activate() end)

        -- O BAT V2 não mantém o bastão equipado.
        -- Se ele equipou automaticamente para bater, guarda novamente logo depois.
        if autoEquipped then
            task.delay(0.10,function()
                pcall(function()
                    local c=LP.Character
                    local h=c and c:FindFirstChildOfClass("Humanoid")
                    local backpack=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
                    if not c or not h or not backpack then return end

                    if bat and bat.Parent==c then
                        bat.Parent=backpack
                    end

                    if previous and previous~=bat and previous.Parent==backpack then
                        h:EquipTool(previous)
                    end
                end)
            end)
        end
    end)

    task.delay(AIMBOT2_SWING_CD,function()
        aimbot2HitCD=false
    end)
end 
function aimbot2TargetIsValid(target)
    if not target or not target.Parent then return false end
    local char=target.Parent
    local hum=char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health<=0 then return false end
    local plr=Players:GetPlayerFromCharacter(char)
    if not plr or plr==LP then return false end
    return true
end

function aimbot2GetClosestTarget() 
    local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") 
    if not root then return nil,math.huge end 
    local closest,minDist=nil,math.huge 
    for _,plr in ipairs(Players:GetPlayers()) do 
        if plr~=LP and plr.Character then 
            local tRoot=plr.Character:FindFirstChild("HumanoidRootPart") 
            local hum=plr.Character:FindFirstChildOfClass("Humanoid") 
            if tRoot and hum and hum.Health>0 then 
                local dist=(tRoot.Position-root.Position).Magnitude 
                if dist<minDist then minDist=dist;closest=tRoot end 
            end 
        end 
    end 
    return closest,minDist 
end 
function startAimbot2() 
    if aimbot2Conn then aimbot2Conn:Disconnect();aimbot2Conn=nil end 
    aimbot2Enabled=true
    aimbot2LockedTarget=nil
    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") 
    if hum then 
        if aimbot2PrevAutoRotate==nil then aimbot2PrevAutoRotate=hum.AutoRotate end 
        hum.AutoRotate=false 
    end 
    aimbot2Conn=RunService.RenderStepped:Connect(function() 
        if not aimbot2Enabled then return end 
        local char=LP.Character;if not char then return end 
        local root=char:FindFirstChild("HumanoidRootPart");if not root then return end 
        local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end 
        -- O bastão só é equipado dentro de aimbot2TrySwing(), na hora do ataque.
        -- Mantém o mesmo alvo ("grudado") enquanto ele continuar válido.
        if not aimbot2TargetIsValid(aimbot2LockedTarget) then
            aimbot2LockedTarget=nil
            local newTarget=aimbot2GetClosestTarget()
            aimbot2LockedTarget=newTarget
        end
        local target=aimbot2LockedTarget
        if not target then
            return
        end
        local targetDist=(target.Position-root.Position).Magnitude

        -- Cancela a influência do analógico enquanto o BAT V2 está perseguindo.
        hum.AutoRotate=false
        hum:Move(Vector3.zero,false)

        local myPos=root.Position 
        local targetPos=target.Position 
        local direction=targetPos-myPos 
        local flatDir=Vector3.new(direction.X,0,direction.Z) 
        if flatDir.Magnitude>0 then flatDir=flatDir.Unit else flatDir=Vector3.zero end 
        local chaseSpeed=58 
        local desiredHeight=targetPos.Y+3.7 
        local yVel=(desiredHeight-myPos.Y)*19.5 
        if hum.FloorMaterial~=Enum.Material.Air then yVel=math.max(yVel,13) end 
        yVel=math.clamp(yVel,-70,110) 
        local desiredVel=Vector3.new(flatDir.X*chaseSpeed,yVel,flatDir.Z*chaseSpeed) 
        root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(desiredVel,0.8) 
        local toTarget=targetPos-myPos 
        if toTarget.Magnitude>0.1 then 
            local goalCF=CFrame.lookAt(myPos,targetPos) 
            local diffCF=root.CFrame:Inverse()*goalCF 
            local rx,ry,rz=diffCF:ToEulerAnglesXYZ() 
            rx=math.clamp(rx,-2.5,2.5);ry=math.clamp(ry,-2.5,2.5);rz=math.clamp(rz,-2.5,2.5) 
            root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(Vector3.new(rx*42,ry*42,rz*42)) 
        end 
        if targetDist<=AIMBOT2_HIT_DIST then aimbot2TrySwing() end 
    end) 
end 
function stopAimbot2()
    aimbot2Enabled=false
    aimbot2LockedTarget=nil
    if aimbot2Conn then aimbot2Conn:Disconnect();aimbot2Conn=nil end 
    local c=LP.Character 
    local root=c and c:FindFirstChild("HumanoidRootPart") 
    if root then root.AssemblyLinearVelocity=Vector3.zero root.AssemblyAngularVelocity=Vector3.zero end 
    local hum=c and c:FindFirstChildOfClass("Humanoid") 
    if hum then 
        hum.AutoRotate=(aimbot2PrevAutoRotate==nil) and true or aimbot2PrevAutoRotate 
        hum.PlatformStand=false 
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end) 
    end 
    aimbot2HitCD=false 
end 
function setAimbot2(on)
    on=(on==true)
    _G.DeepBatV2ManualEnabled=on

    if on then
        startAimbot2()
    else
        if tpAimbotEnabled then
            -- TP Aimbot continua usando o motor oculto apenas para o swing.
            startAimbot2()
        else
            stopAimbot2()
        end
    end

    if setAimbot2Visual then setAimbot2Visual(on) end
    if mobBtnRefs and mobBtnRefs.aimbot2 then mobBtnRefs.aimbot2(on) end
    pcall(saveConfig)
end 
local tpAimbotEnabled = tpAimbotEnabled or false
tpAimbotMode = tpAimbotMode or "v1"
if tpAimbotMode~="v1" and tpAimbotMode~="v2" then tpAimbotMode="v1" end

local spaceTpAntiDieEnabled = spaceTpAntiDieEnabled or false
local setSpaceTpAntiDieVisual = setSpaceTpAntiDieVisual or nil

-- ============================================================
-- SPACE TP BAT CORE
-- Motor substituto do antigo TP Aimbot. A GUI do Deep permanece.
-- V1/V2 e Anti Die portados do Space Tp Bat enviado pelo usuário.
-- ============================================================
do
    if _G.DeepSpaceTP and type(_G.DeepSpaceTP.destroy)=="function" then
        pcall(_G.DeepSpaceTP.destroy)
    end

    local S={
        running=false,
        thread=nil,
        hitCooldown=false,
        antiDie=false,
        deathConnections={},
        heartbeatConnection=nil,
        characterAddedConnection=nil,
        configs={
            v1={
                range=250,
                tpOffset=Vector3.new(0,0,0),
                loopDelay=0.08,
                smartRotation=true,
                resetVelocity=true,
                predictMovement=true,
                predictionFactor=0.15,
                healthCheck=true,
                teamCheck=false,
                behindTarget=false,
                behindDistance=4,
                antiFling=true,
                sideOffset=2.5,
            },
            v2={
                range=250,
                tpOffset=Vector3.new(0,3,0),
                loopDelay=0.08,
                smartRotation=false,
                resetVelocity=true,
                predictMovement=false,
                predictionFactor=0,
                healthCheck=true,
                teamCheck=false,
                behindTarget=false,
                behindDistance=0,
                antiFling=false,
                sideOffset=0,
            },
        }
    }
    _G.DeepSpaceTP=S

    local function config()
        return S.configs[tpAimbotMode] or S.configs.v1
    end

    local function myRoot()
        local char=LP.Character
        return char and char:FindFirstChild("HumanoidRootPart") or nil
    end

    local function myHum()
        local char=LP.Character
        return char and char:FindFirstChildOfClass("Humanoid") or nil
    end

    local function getBat()
        local char=LP.Character
        if not char then return nil end

        local tool=char:FindFirstChild("Bat")
        if tool and tool:IsA("Tool") then return tool end

        local backpack=LP:FindFirstChild("Backpack")
        if backpack then
            tool=backpack:FindFirstChild("Bat")
            if tool and tool:IsA("Tool") then
                local hum=char:FindFirstChildOfClass("Humanoid")
                if hum then
                    pcall(function() hum:EquipTool(tool) end)
                else
                    tool.Parent=char
                end
                return tool
            end
        end

        return nil
    end

    local function tryHitBat()
        if S.hitCooldown then return end
        S.hitCooldown=true

        pcall(function()
            local bat=getBat()
            if bat then
                bat:Activate()
                local remoteEvent=bat:FindFirstChildWhichIsA("RemoteEvent")
                if remoteEvent then
                    remoteEvent:FireServer()
                end
            end
        end)

        task.delay(0.08,function()
            S.hitCooldown=false
        end)
    end

    local function validEnemy(player)
        local c=config()
        if player==LP then return false end
        if not player.Character then return false end

        local hum=player.Character:FindFirstChildOfClass("Humanoid")
        if not hum then return false end
        if c.healthCheck and hum.Health<=0 then return false end

        if c.teamCheck and player.Team==LP.Team and player.Team~=nil then
            return false
        end

        local root=player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return false end

        return true,root,hum
    end

    local function predictedPosition(root)
        local c=config()
        if not c.predictMovement then
            return root.Position
        end
        return root.Position+(root.AssemblyLinearVelocity*c.predictionFactor)
    end

    local function nearestEnemy()
        local c=config()
        local root=myRoot()
        if not root then return nil end

        local nearest=nil
        local shortest=c.range

        for _,player in ipairs(Players:GetPlayers()) do
            local ok,targetRoot=validEnemy(player)
            if ok then
                local dist=(targetRoot.Position-root.Position).Magnitude
                if dist<shortest then
                    shortest=dist
                    nearest=targetRoot
                end
            end
        end

        return nearest
    end

    local function teleportTo(targetRoot)
        local c=config()
        local root=myRoot()
        local hum=myHum()
        if not root or not targetRoot or not targetRoot.Parent then return end

        local targetPos=predictedPosition(targetRoot)
        local finalPos

        if c.behindTarget then
            local delta=targetPos-root.Position
            local direction=delta.Magnitude>0.001 and delta.Unit or Vector3.new(0,0,-1)
            finalPos=targetPos+(direction*-c.behindDistance)+Vector3.new(0,2,0)
        else
            if c.sideOffset and c.sideOffset>0 then
                local dir=root.Position-targetPos
                dir=Vector3.new(dir.X,0,dir.Z)
                if dir.Magnitude<0.1 then
                    dir=Vector3.new(1,0,0)
                else
                    dir=dir.Unit
                end
                finalPos=targetPos+(dir*c.sideOffset)
            else
                finalPos=targetPos+c.tpOffset
            end
        end

        if c.smartRotation then
            root.CFrame=CFrame.new(finalPos,targetPos)
        else
            root.CFrame=CFrame.new(finalPos)
        end

        if c.resetVelocity then
            root.Velocity=Vector3.zero
            root.AssemblyLinearVelocity=Vector3.zero
            root.RotVelocity=Vector3.zero
            root.AssemblyAngularVelocity=Vector3.zero
        end

        if c.antiFling and hum then
            hum.PlatformStand=false
            hum.Sit=false
        end
    end

    function _G.DeepStartTPAimbot()
        if S.running then return true end
        if not LP.Character or not myRoot() then return false end

        S.running=true
        tpAimbotEnabled=true

        S.thread=task.spawn(function()
            while S.running and tpAimbotEnabled do
                local target=nearestEnemy()
                if target then
                    teleportTo(target)
                    tryHitBat()
                end
                task.wait(config().loopDelay)
            end
        end)

        return true
    end

    function _G.DeepStopTPAimbot()
        S.running=false
        tpAimbotEnabled=false

        if S.thread then
            pcall(function() task.cancel(S.thread) end)
            S.thread=nil
        end
    end

    local function disconnectAntiDie()
        for _,conn in ipairs(S.deathConnections) do
            pcall(function() conn:Disconnect() end)
        end
        S.deathConnections={}

        if S.heartbeatConnection then
            pcall(function() S.heartbeatConnection:Disconnect() end)
            S.heartbeatConnection=nil
        end
    end

    local function protectCharacter(character)
        if not S.antiDie or not character then return end

        disconnectAntiDie()

        local hum=character:FindFirstChildOfClass("Humanoid")
            or character:WaitForChild("Humanoid",5)
        if not hum then return end

        pcall(function()
            hum.MaxHealth=math.huge
            hum.Health=math.huge
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
        end)

        table.insert(S.deathConnections,hum.StateChanged:Connect(function(_,newState)
            if not S.antiDie then return end
            if newState==Enum.HumanoidStateType.Dead then
                pcall(function()
                    hum.Health=math.huge
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead,false)
                end)
            end
        end))

        table.insert(S.deathConnections,hum:GetPropertyChangedSignal("Health"):Connect(function()
            if not S.antiDie then return end
            if hum.Health<hum.MaxHealth then
                pcall(function() hum.Health=math.huge end)
            end
        end))

        S.heartbeatConnection=RunService.Heartbeat:Connect(function()
            if not S.antiDie then return end
            if hum and hum.Parent and hum.Health<hum.MaxHealth then
                pcall(function() hum.Health=math.huge end)
            end
        end)
    end

    function _G.DeepSpaceSetAntiDie(on)
        on=(on==true)
        S.antiDie=on
        spaceTpAntiDieEnabled=on

        if on then
            if LP.Character then protectCharacter(LP.Character) end
        else
            disconnectAntiDie()
            local char=LP.Character
            local hum=char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                pcall(function()
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead,true)
                    hum.MaxHealth=100
                    if hum.Health>100 or hum.Health<=0 then hum.Health=100 end
                end)
            end
        end

        if setSpaceTpAntiDieVisual then
            pcall(setSpaceTpAntiDieVisual,on)
        end

        pcall(saveConfig)
        return S.antiDie
    end

    S.characterAddedConnection=LP.CharacterAdded:Connect(function(character)
        if S.antiDie then
            task.delay(0.2,function()
                if S.antiDie and LP.Character==character then
                    protectCharacter(character)
                end
            end)
        end
    end)

    function S.destroy()
        _G.DeepStopTPAimbot()
        S.antiDie=false
        disconnectAntiDie()
        if S.characterAddedConnection then
            pcall(function() S.characterAddedConnection:Disconnect() end)
            S.characterAddedConnection=nil
        end
    end
end

function setTPAimbotMode(mode)
    mode=tostring(mode or "v1"):lower()
    if mode~="v1" and mode~="v2" then mode="v1" end

    if tpAimbotMode==mode then
        if _G.DeepRefreshTPAimbotMode then pcall(_G.DeepRefreshTPAimbotMode) end
        if _G.DeepRefreshTPAimbotLabels then pcall(_G.DeepRefreshTPAimbotLabels) end
        return
    end

    local wasOn=tpAimbotEnabled==true
    if wasOn then _G.DeepStopTPAimbot() end

    tpAimbotMode=mode

    if _G.DeepRefreshTPAimbotMode then pcall(_G.DeepRefreshTPAimbotMode) end
    if _G.DeepRefreshTPAimbotLabels then pcall(_G.DeepRefreshTPAimbotLabels) end

    if wasOn then _G.DeepStartTPAimbot() end
    pcall(saveConfig)
end

function setTPAimbot(on)
    on=(on==true)

    if on then
        local ok=_G.DeepStartTPAimbot()
        if ok==false then
            tpAimbotEnabled=false
            if mobBtnRefs and mobBtnRefs.antiDesync then
                mobBtnRefs.antiDesync(false)
            end
            if setTPAimbotVisual then
                setTPAimbotVisual(false)
            end
            return false
        end
        tpAimbotEnabled=true
    else
        _G.DeepStopTPAimbot()
        tpAimbotEnabled=false
    end

    if setTPAimbotVisual then
        setTPAimbotVisual(tpAimbotEnabled)
    end
    if mobBtnRefs and mobBtnRefs.antiDesync then
        mobBtnRefs.antiDesync(tpAimbotEnabled)
    end
    if _G.DeepRefreshTPAimbotLabels then
        pcall(_G.DeepRefreshTPAimbotLabels)
    end
    pcall(saveConfig)
    return true
end


-- GREEN DUELS PORT - AIMBOT NORMAL + AIMBOT BYPASS
-- Adaptado das rotinas Normal Aimbot / AntiHit do Green Duels.
-- ============================================================
do
    if _G.DeepGreenAimbot and type(_G.DeepGreenAimbot.destroy)=="function" then
        pcall(_G.DeepGreenAimbot.destroy)
    end

    local G={
        normal=false,
        bypass=false,
        enabled=false,
        version="NORMAL",
        singleVisual=nil,
        normalConn=nil,
        bypassConn=nil,
        normalSpeed=58,
        bypassSpeed=58,
        hitBusy=false,
        normalVisual=nil,
        bypassVisual=nil,
        attachmentName="DeepGreenAimbotAttachment",
        moverName="DeepGreenAimbotVelocity",
        minForce=1000000,
        maxForce=50000000,
    }
    _G.DeepGreenAimbot=G

    local function disconnect(conn)
        if conn then pcall(function() conn:Disconnect() end) end
    end

    local function isBatLike(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n=tool.Name:lower()
        if n:find("medusa",1,true) or n:find("head",1,true) or n:find("stone",1,true) then
            return false
        end
        return n:find("bat",1,true)~=nil or n:find("slap",1,true)~=nil
    end

    local function findBat()
        local char=LP.Character
        if not char then return nil end

        local equipped=char:FindFirstChildOfClass("Tool")
        if isBatLike(equipped) then return equipped end

        for _,tool in ipairs(char:GetChildren()) do
            if isBatLike(tool) then return tool end
        end

        local bp=LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
        if bp then
            for _,tool in ipairs(bp:GetChildren()) do
                if isBatLike(tool) then return tool end
            end
        end
        return nil
    end

    local function equipBat()
        local char=LP.Character
        if not char then return nil end
        local hum=char:FindFirstChildOfClass("Humanoid")
        local tool=findBat()
        if tool and tool.Parent~=char and hum then
            pcall(function() hum:EquipTool(tool) end)
        end
        return tool
    end

    local function closestTargetRoot()
        local char=LP.Character
        local myRoot=char and char:FindFirstChild("HumanoidRootPart")
        if not myRoot then return nil,math.huge end

        local closest=nil
        local best=math.huge
        for _,plr in ipairs(Players:GetPlayers()) do
            if plr~=LP and plr.Character then
                local root=plr.Character:FindFirstChild("HumanoidRootPart")
                local hum=plr.Character:FindFirstChildOfClass("Humanoid")
                if root and hum and hum.Health>0 then
                    local dist=(root.Position-myRoot.Position).Magnitude
                    if dist<best then
                        best=dist
                        closest=root
                    end
                end
            end
        end
        return closest,best
    end

    local function clearMover(root)
        if not root then return end
        local mover=root:FindFirstChild(G.moverName)
        if mover then pcall(function() mover:Destroy() end) end
        local att=root:FindFirstChild(G.attachmentName)
        if att then pcall(function() att:Destroy() end) end
    end

    local function getMover(root)
        local mover=root:FindFirstChild(G.moverName)
        if mover and not mover:IsA("LinearVelocity") then
            mover:Destroy()
            mover=nil
        end

        local att=root:FindFirstChild(G.attachmentName)
        if att and not att:IsA("Attachment") then
            att:Destroy()
            att=nil
        end

        if not att then
            att=Instance.new("Attachment")
            att.Name=G.attachmentName
            att.Parent=root
        end

        if not mover then
            mover=Instance.new("LinearVelocity")
            mover.Name=G.moverName
            mover.Attachment0=att
            mover.RelativeTo=Enum.ActuatorRelativeTo.World
            mover.VelocityConstraintMode=Enum.VelocityConstraintMode.Vector
            mover.VectorVelocity=root.AssemblyLinearVelocity
            pcall(function()
                mover.ForceLimitsEnabled=true
                mover.ForceLimitMode=Enum.ForceLimitMode.PerAxis
            end)
            mover.Parent=root
        end
        return mover
    end

    local function applyNormalVelocity(root,velocity,speed,dt)
        local mover=getMover(root)
        local force=math.clamp(
            root.AssemblyMass*math.max((tonumber(speed) or 0)*220,6000),
            G.minForce,
            G.maxForce
        )
        pcall(function()
            mover.Enabled=true
            mover.MaxAxesForce=Vector3.new(force,force,force)
        end)
        mover.VectorVelocity=mover.VectorVelocity:Lerp(
            velocity,
            1-math.exp(-math.max(dt or 1/60,0)*26)
        )
    end

    local function resetMotion()
        local char=LP.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if root then
            clearMover(root)
            root.AssemblyAngularVelocity=Vector3.zero
        end
        if hum then
            hum.AutoRotate=true
            hum.PlatformStand=false
            pcall(function() hum:Move(Vector3.zero,false) end)
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
    end

    local function stopConflictingMovement()
        if autoLeftEnabled then
            autoLeftEnabled=false
            if autoLeftSetVisual then pcall(autoLeftSetVisual,false) end
            if stopAutoLeft then pcall(stopAutoLeft) end
            if mobBtnRefs and mobBtnRefs.autoLeft then pcall(mobBtnRefs.autoLeft,false) end
        end

        if autoRightEnabled then
            autoRightEnabled=false
            if autoRightSetVisual then pcall(autoRightSetVisual,false) end
            if stopAutoRight then pcall(stopAutoRight) end
            if mobBtnRefs and mobBtnRefs.autoRight then pcall(mobBtnRefs.autoRight,false) end
        end

        if autoBatEnabled then
            autoBatEnabled=false
            if disableAutoBat then pcall(disableAutoBat) end
            if autoBatSetVisual then pcall(autoBatSetVisual,false) end
            if mobBtnRefs and mobBtnRefs.autoBat then pcall(mobBtnRefs.autoBat,false) end
        end

        if _G.DeepBatV2ManualEnabled and type(setAimbot2)=="function" then
            pcall(setAimbot2,false)
        end

        if tpAimbotEnabled and type(setTPAimbot)=="function" then
            pcall(setTPAimbot,false)
        end
    end

    local function trySwing(maxDistance)
        if not autoSwingEnabled or G.hitBusy then return end
        local _,dist=closestTargetRoot()
        if maxDistance and dist>maxDistance then return end

        local tool=equipBat()
        if not tool then return end

        G.hitBusy=true
        pcall(function()
            tool.Enabled=true
            tool:Activate()
            local remote=tool:FindFirstChildWhichIsA("RemoteEvent",true)
            if remote then
                pcall(function() remote:FireServer() end)
            end
        end)
        task.delay(0.5,function() G.hitBusy=false end)
    end

    local function stopNormal()
        G.normal=false
        disconnect(G.normalConn)
        G.normalConn=nil
        resetMotion()
        if G.normalVisual then pcall(G.normalVisual,false) end
        if mobBtnRefs and mobBtnRefs.greenNormal then pcall(mobBtnRefs.greenNormal,false) end
    end

    local function stopBypass()
        G.bypass=false
        disconnect(G.bypassConn)
        G.bypassConn=nil
        resetMotion()
        if G.bypassVisual then pcall(G.bypassVisual,false) end
        if mobBtnRefs and mobBtnRefs.greenBypass then pcall(mobBtnRefs.greenBypass,false) end
    end

    local function startNormal()
        stopBypass()
        stopConflictingMovement()
        disconnect(G.normalConn)
        G.normal=true

        G.normalConn=RunService.RenderStepped:Connect(function(dt)
            if not G.normal then return end
            local char=LP.Character
            local root=char and char:FindFirstChild("HumanoidRootPart")
            local hum=char and char:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health<=0 then return end

            local tool=equipBat()
            local target=closestTargetRoot()
            if not target then
                hum.AutoRotate=true
                root.AssemblyAngularVelocity=Vector3.zero
                clearMover(root)
                return
            end

            local targetVel=target.AssemblyLinearVelocity
            local myPos=root.Position
            local targetPos=target.Position
            local predictPos=targetPos+targetVel*0.14+target.CFrame.LookVector*0.3
            local delta=predictPos-myPos
            local flat=Vector3.new(delta.X,0,delta.Z)
            if flat.Magnitude<0.01 then return end
            local unit=flat.Unit
            local speed=math.clamp(tonumber(G.normalSpeed) or 58,1,500)

            local y=(targetPos.Y+3.7-myPos.Y)*19.5+targetVel.Y*0.8
            if hum.FloorMaterial~=Enum.Material.Air then y=math.max(y,14) end
            local desired=Vector3.new(unit.X*speed,math.clamp(y,-70,110),unit.Z*speed)
            applyNormalVelocity(root,desired,speed,dt)

            local predicted=targetPos+targetVel*math.clamp(targetVel.Magnitude/150,0.05,0.2)
            if (predicted-myPos).Magnitude>0.1 then
                hum.AutoRotate=false
                local goal=CFrame.lookAt(myPos,predicted)
                local rx,ry,rz=(root.CFrame:Inverse()*goal):ToEulerAnglesXYZ()
                root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(
                    Vector3.new(
                        math.clamp(rx,-2.5,2.5)*42,
                        math.clamp(ry,-2.5,2.5)*42,
                        math.clamp(rz,-2.5,2.5)*42
                    )
                )
            end

            if autoSwingEnabled and tool then
                trySwing(nil)
            end
        end)

        if G.normalVisual then pcall(G.normalVisual,true) end
        if mobBtnRefs and mobBtnRefs.greenNormal then pcall(mobBtnRefs.greenNormal,true) end
    end

    local function startBypass()
        stopNormal()
        stopConflictingMovement()
        disconnect(G.bypassConn)
        G.bypass=true

        G.bypassConn=RunService.Heartbeat:Connect(function()
            if not G.bypass then return end

            local char=LP.Character
            local root=char and char:FindFirstChild("HumanoidRootPart")
            local hum=char and char:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health<=0 then return end

            if not char:FindFirstChildOfClass("Tool") then
                equipBat()
            end

            local target,dist=closestTargetRoot()
            if not target then
                hum.AutoRotate=true
                pcall(function() hum:Move(Vector3.zero,false) end)
                return
            end

            local myPos=root.Position
            local targetPos=target.Position
            local delta=targetPos-myPos
            local flat=Vector3.new(delta.X,0,delta.Z)
            local unit=flat.Magnitude>0 and flat.Unit or Vector3.zero
            local speed=math.clamp(tonumber(G.bypassSpeed) or 58,1,500)

            -- Igual ao comportamento AntiHit do Green:
            -- quando o WalkSpeed está baixo, usa Humanoid:Move;
            -- caso contrário usa velocidade física.
            if hum.WalkSpeed<25 then
                hum.AutoRotate=true
                hum:Move(unit,false)
                if hum.FloorMaterial~=Enum.Material.Air then
                    root.Velocity=Vector3.new(
                        unit.X*speed,
                        root.Velocity.Y,
                        unit.Z*speed
                    )
                end
                return
            end

            hum.AutoRotate=false
            if autoSwingEnabled and dist<=8 then
                trySwing(8)
            end

            local y=(targetPos.Y+3.7-myPos.Y)*19.5
            if hum.FloorMaterial~=Enum.Material.Air then y=math.max(y,13) end

            root.AssemblyLinearVelocity=root.AssemblyLinearVelocity:Lerp(
                Vector3.new(unit.X*speed,math.clamp(y,-70,110),unit.Z*speed),
                0.8
            )

            if (targetPos-myPos).Magnitude>0.1 then
                local goal=CFrame.lookAt(myPos,targetPos)
                local rx,ry,rz=(root.CFrame:Inverse()*goal):ToEulerAnglesXYZ()
                root.AssemblyAngularVelocity=root.CFrame:VectorToWorldSpace(
                    Vector3.new(
                        math.clamp(rx,-2.5,2.5)*42,
                        math.clamp(ry,-2.5,2.5)*42,
                        math.clamp(rz,-2.5,2.5)*42
                    )
                )
            end
        end)

        if G.bypassVisual then pcall(G.bypassVisual,true) end
        if mobBtnRefs and mobBtnRefs.greenBypass then pcall(mobBtnRefs.greenBypass,true) end
    end

    function _G.DeepSetGreenNormalAimbot(on)
        if on then startNormal() else stopNormal() end
        pcall(saveConfig)
        return G.normal
    end

    function _G.DeepSetGreenBypassAimbot(on)
        if on then startBypass() else stopBypass() end
        pcall(saveConfig)
        return G.bypass
    end

    function _G.DeepRefreshGreenAimbotUI()
        if G.singleVisual then
            pcall(G.singleVisual,G.enabled)
        end
        if _G.DeepGreenAimbotVersionButton then
            _G.DeepGreenAimbotVersionButton.Text=G.version
        end
        if G.normalSpeedBox and G.normalSpeedBox.Parent then
            local focused=false
            pcall(function() focused=G.normalSpeedBox:IsFocused() end)
            if not focused then G.normalSpeedBox.Text=tostring(G.normalSpeed) end
        end
        if G.bypassSpeedBox and G.bypassSpeedBox.Parent then
            local focused=false
            pcall(function() focused=G.bypassSpeedBox:IsFocused() end)
            if not focused then G.bypassSpeedBox.Text=tostring(G.bypassSpeed) end
        end
    end

    function _G.DeepSetGreenAimbotSpeed(version,value,skipSave)
        version=tostring(version or "NORMAL"):upper()
        local n=tonumber(value)
        if not n then return false end
        n=math.clamp(n,1,500)

        if version=="BYPASS" then
            G.bypassSpeed=n
            if G.bypassSpeedBox and G.bypassSpeedBox.Parent then
                G.bypassSpeedBox.Text=tostring(n)
            end
        else
            G.normalSpeed=n
            if G.normalSpeedBox and G.normalSpeedBox.Parent then
                G.normalSpeedBox.Text=tostring(n)
            end
        end

        if not skipSave then pcall(saveConfig) end
        return true,n
    end

    function _G.DeepSetGreenAimbotVersion(version)
        version=tostring(version or "NORMAL"):upper()
        if version~="NORMAL" and version~="BYPASS" then
            version="NORMAL"
        end

        G.version=version

        if G.enabled then
            if G.version=="BYPASS" then
                stopNormal()
                startBypass()
            else
                stopBypass()
                startNormal()
            end
        end

        _G.DeepRefreshGreenAimbotUI()
        pcall(saveConfig)
        return G.version
    end

    function _G.DeepSetGreenAimbot(on)
        G.enabled=(on==true)

        if not G.enabled then
            stopNormal()
            stopBypass()
        elseif G.version=="BYPASS" then
            stopNormal()
            startBypass()
        else
            stopBypass()
            startNormal()
        end

        _G.DeepRefreshGreenAimbotUI()
        pcall(saveConfig)
        return G.enabled
    end

    function G.destroy()
        G.normal=false
        G.bypass=false
        disconnect(G.normalConn)
        disconnect(G.bypassConn)
        G.normalConn=nil
        G.bypassConn=nil
        resetMotion()
    end
end

if bodyLockEnabled==nil then bodyLockEnabled=false end 
bodyLockRadius=bodyLockRadius or 60 
bodyLockConn=bodyLockConn or nil 
setBodyLockVisual=setBodyLockVisual or nil 
bodyLockRadiusBox=bodyLockRadiusBox or nil 
function getNearestBodyLockTarget() 
    local character=LP.Character 
    local root=character and character:FindFirstChild("HumanoidRootPart") 
    if not root then return nil end 
    local nearest=nil 
    local shortest=math.huge 
    for _,plr in ipairs(Players:GetPlayers()) do 
        if plr~=LP and plr.Character then 
            local tr=plr.Character:FindFirstChild("HumanoidRootPart") 
            local hum=plr.Character:FindFirstChildOfClass("Humanoid") 
            if tr and hum and hum.Health>0 then 
                local d=(tr.Position-root.Position).Magnitude 
                if d<=bodyLockRadius and d<shortest then shortest=d nearest=plr end 
            end 
        end 
    end 
    return nearest 
end 
function startBodyLock() 
    if bodyLockConn then return end 
    bodyLockEnabled=true 
    bodyLockConn=RunService.Heartbeat:Connect(function() 
        if not bodyLockEnabled then return end 
        local character=LP.Character 
        local myRoot=character and character:FindFirstChild("HumanoidRootPart") 
        local humanoid=character and character:FindFirstChildOfClass("Humanoid") 
        if not myRoot or not humanoid or humanoid.Health<=0 then return end 
        local target=getNearestBodyLockTarget() 
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then 
            local targetPos=target.Character.HumanoidRootPart.Position 
            local myPos=myRoot.Position 
            local offset=Vector3.new(targetPos.X,myPos.Y,targetPos.Z)-myPos 
            if offset.Magnitude>0.1 then 
                humanoid.AutoRotate=false 
                local lookDir=offset.Unit 
                local currentDir=myRoot.CFrame.LookVector 
                local cross=currentDir:Cross(lookDir) 
                local currentVel=myRoot.AssemblyAngularVelocity 
                myRoot.AssemblyAngularVelocity=Vector3.new(currentVel.X,cross.Y*40,currentVel.Z) 
            end 
        else 
            humanoid.AutoRotate=true 
        end 
    end) 
end 
function stopBodyLock() 
    bodyLockEnabled=false 
    if bodyLockConn then bodyLockConn:Disconnect();bodyLockConn=nil end 
    local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid") 
    if hum then hum.AutoRotate=true end 
end 
function setBodyLock(on) 
    bodyLockEnabled=on 
    if on then startBodyLock() else stopBodyLock() end 
    if setBodyLockVisual then setBodyLockVisual(on) end 
    pcall(saveConfig) 
end 
LP.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    setupSpeedIndicator(char)
    pcall(function() _G.DeepStartRagdollTimerSystem(char) end)
    if medusaCounterEnabled then setupMedusa(char) end
    if batCounterEnabled then startBatCounter() end
    if unwalkEnabled then task.wait(0.5);startUnwalk() end
end)
if LP.Character then
    setupSpeedIndicator(LP.Character)
    pcall(function() _G.DeepStartRagdollTimerSystem(LP.Character) end)
end
if mobileButtonsSize==nil then mobileButtonsSize=100 end 
if mobileButtonShape==nil then mobileButtonShape="squarcle" end 
if mobileDragSmall==nil then mobileDragSmall=false end 
if mobileMovingMode==nil then mobileMovingMode=false end 
if hubImageChoice==nil then hubImageChoice=1 end 
if buttonImageChoice==nil then buttonImageChoice=1 end 
local HUB_ARTS={
    [1]="rbxassetid://82054758948423",
    [2]="rbxthumb://type=Asset&id=97069004530020&w=420&h=420",
    [3]="rbxassetid://82457207608895",
    [4]="rbxassetid://86319509375427",
    [5]="rbxassetid://85428036348598"
}
local BUTTON_ARTS={
    [1]="rbxassetid://82054758948423",
    [2]="rbxthumb://type=Asset&id=97069004530020&w=420&h=420",
    [3]="rbxassetid://82457207608895",
    [4]="rbxassetid://86319509375427",
    [5]="rbxassetid://85428036348598"
}
hubBgImageRef=hubBgImageRef or nil
mobBtnRefs=mobBtnRefs or {}
mobBtnTextRefs=mobBtnTextRefs or {} 
mobLastLiveSave=mobLastLiveSave or 0 
mobGuiRef=mobGuiRef or nil 
mobContainerRef=mobContainerRef or nil 
mobBtnSavedContainerPos=mobBtnSavedContainerPos or nil 
mobBtnSavedIndPos=mobBtnSavedIndPos or {} 
setMobileDragSmallVisual=setMobileDragSmallVisual or nil 
setMobileMovingModeVisual=setMobileMovingModeVisual or nil 
local configPersistenceEnabled = false
pcall(function()
    if isfile and isfile("exeMobile.json") then configPersistenceEnabled = true end
end)
function deleteSavedConfig()
    configPersistenceEnabled = false
    if delfile then
        pcall(function() if isfile and isfile("exeMobile.json") then delfile("exeMobile.json") end end)
    end
end

local function getHubArtImage()
    return HUB_ARTS[hubImageChoice] or HUB_ARTS[1]
end

local function getButtonArtImage()
    return BUTTON_ARTS[buttonImageChoice] or BUTTON_ARTS[1]
end

local function applyHubArtNow()
    if hubBgImageRef and hubBgImageRef.Parent then
        hubBgImageRef.Image = getHubArtImage()
    end
end

function saveMobileButtonPositions() 
    if not mobGuiRef then return end 
    local container=mobGuiRef:FindFirstChild("Buttons") 
    if not container then return end 
    mobBtnSavedContainerPos={xs=container.Position.X.Scale,xo=container.Position.X.Offset,ys=container.Position.Y.Scale,yo=container.Position.Y.Offset} 
    mobBtnSavedIndPos={} 
    for _,b in ipairs(container:GetChildren()) do 
        if b:IsA("Frame") and b:GetAttribute("Idx") then 
            mobBtnSavedIndPos[tostring(b:GetAttribute("Idx"))]={xs=b.Position.X.Scale,xo=b.Position.X.Offset,ys=b.Position.Y.Scale,yo=b.Position.Y.Offset} 
        end 
    end 
end 
function saveMobileButtonsConfigOnly() 
    if not configPersistenceEnabled then return end
    pcall(saveMobileButtonPositions) 
    pcall(function() 
        if not (writefile and HS) then return end 
        local cfg={} 
        pcall(function() 
            if isfile and isfile("exeMobile.json") and readfile then 
                local old=HS:JSONDecode(readfile("exeMobile.json")) 
                if type(old)=="table" then cfg=old end 
            end 
        end) 
        cfg.mobileButtonsSize=mobileButtonsSize 
        cfg.mobileButtonShape=mobileButtonShape 
        cfg.mobileDragSmall=mobileDragSmall 
        cfg.mobileMovingMode=mobileMovingMode 
        cfg.hubImageChoice=hubImageChoice
        cfg.buttonImageChoice=buttonImageChoice
        cfg.mobBtnSavedContainerPos=mobBtnSavedContainerPos 
        cfg.mobBtnSavedIndPos=mobBtnSavedIndPos 
        cfg.uiScale=uiScale 
        writefile("exeMobile.json",HS:JSONEncode(cfg)) 
    end) 
end 
function destroyMobileButtons() 
    if mobGuiRef then pcall(saveMobileButtonPositions);pcall(function() mobGuiRef:Destroy() end);mobGuiRef=nil end
    mobContainerRef=nil 
    for _,n in ipairs({"ExeMobileButtons","WhiteMobileButtons","AdaptMobileButtons"}) do 
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end 
        local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild(n);if o then o:Destroy() end end 
    end 
    mobBtnRefs={} 
end 
function resetMobileButtonPositions() 
    if mobGuiRef then pcall(function() mobGuiRef:Destroy() end);mobGuiRef=nil end 
    for _,n in ipairs({"ExeMobileButtons","WhiteMobileButtons","AdaptMobileButtons"}) do 
        local old=game:GetService("CoreGui"):FindFirstChild(n);if old then old:Destroy() end 
        local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild(n);if o then o:Destroy() end end 
    end 
    mobBtnSavedContainerPos=nil 
    mobBtnSavedIndPos={} 
    mobileMovingMode=false 
    if setMobileMovingModeVisual then pcall(function() setMobileMovingModeVisual(false) end) end 
    buildMobileButtons() 
    pcall(saveConfig);saveMobileButtonsConfigOnly() 
    task.delay(0.2,function() pcall(saveConfig);saveMobileButtonsConfigOnly() end) 
end 
task.spawn(function() 
    while task.wait(0.5) do 
        pcall(function() 
            saveMobileButtonPositions() 
            saveConfig() 
            saveMobileButtonsConfigOnly() 
        end) 
    end 
end) 
function buildMobileButtons() 
    destroyMobileButtons() 
    local MB_SIZE=math.floor(82*(mobileButtonsSize or 100)/100) 
    local MB_GAP=8 
    local COLS=3 
    local ROWS=4 
    local totalW=COLS*MB_SIZE+(COLS-1)*MB_GAP 
    local totalH=ROWS*MB_SIZE+(ROWS-1)*MB_GAP 
    local WHITE=Color3.fromRGB(255,255,255) 
    local BG=Color3.fromRGB(8,8,12) 
    local OFF=Color3.fromRGB(28,28,35) 
    local DIM=Color3.fromRGB(150,150,150) 
    local W=Color3.fromRGB(255,255,255) 
    local ON_BG=Color3.fromRGB(40,40,50) 
    local defs={ 
        {top="DROP",bot=(dropVersion=="FLIGHT" and "FLIGHT" or "JUMP"),key="drop",oneShot=true,layout="stacked"}, 
        {top="AUTO",bot="LEFT",key="autoLeft",layout="stacked"}, 
        {top="BAT",bot="AIMBOT",key="autoBat",layout="stacked"}, 
        {top="AUTO",bot="RIGHT",key="autoRight",layout="stacked"}, 
        {top="TP",bot="DOWN",key="tpDown",oneShot=true,layout="stacked"}, 
        {top="CARRY",bot="SPEED",key="carrySpeed",layout="stacked"}, 
        {top="LAGGER",bot="SPEED",key="laggerSpeed",layout="stacked"}, 
        {top="LAGGER",bot="CARRY",key="laggerCarry",layout="stacked"}, 
        {top="TP",bot=(tpAimbotMode=="v2" and "AIMBOT V2" or "AIMBOT V1"),key="antiDesync",layout="stacked"},
        {top="BAT",bot="V2",key="aimbot2",layout="stacked"},
        {top="BYPASS",bot="",key="bypass",layout="stacked"},
    } 
    local function getCorner() 
        if mobileButtonShape=="circle" then return UDim.new(1,0) 
        elseif mobileButtonShape=="straight" then return UDim.new(0,0) 
        elseif mobileButtonShape=="squarcle" then return UDim.new(0,14) 
        else return UDim.new(0,12) end 
    end 
    local g=Instance.new("ScreenGui");g.Name="DeepDuels";g.ResetOnSpawn=false;g.DisplayOrder=20;g.IgnoreGuiInset=true 
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(g) end end) 
    if not pcall(function() g.Parent=game:GetService("CoreGui") end) then g.Parent=LP:WaitForChild("PlayerGui") end 
    mobGuiRef=g 
    local container=Instance.new("Frame",g);container.Name="Buttons";container.Size=UDim2.new(0,totalW,0,totalH);container.Position=UDim2.new(1,-(totalW+10),0,80);container.BackgroundTransparency=1;container.BorderSizePixel=0
    mobContainerRef=container
    -- O conjunto inteiro pode ser movido quando Edit Buttons e Lock UI estão DESLIGADOS.
    -- Edit Buttons continua reservado para mover os botões individualmente.
    container.Active=(not uiLocked and not mobileMovingMode)

    local groupDrag=false
    local groupDragStart=nil
    local groupStartPos=nil
    container.InputBegan:Connect(function(input)
        if uiLocked or mobileMovingMode then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            groupDrag=true
            groupDragStart=input.Position
            groupStartPos=container.Position
            input.Changed:Connect(function()
                if input.UserInputState==Enum.UserInputState.End then
                    groupDrag=false
                    mobBtnSavedContainerPos={xs=container.Position.X.Scale,xo=container.Position.X.Offset,ys=container.Position.Y.Scale,yo=container.Position.Y.Offset}
                    saveMobileButtonsConfigOnly()
                end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not groupDrag then return end
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then
            local d=input.Position-groupDragStart
            container.Position=UDim2.new(groupStartPos.X.Scale,groupStartPos.X.Offset+d.X,groupStartPos.Y.Scale,groupStartPos.Y.Offset+d.Y)
        end
    end)
    if mobBtnSavedContainerPos then container.Position=UDim2.new(mobBtnSavedContainerPos.xs,mobBtnSavedContainerPos.xo,mobBtnSavedContainerPos.ys,mobBtnSavedContainerPos.yo) end 
    for i,def in ipairs(defs) do 
        local col=(i-1)%COLS;local row=math.floor((i-1)/COLS) 
        local b=Instance.new("Frame",container);b:SetAttribute("Idx",i);b.Size=UDim2.new(0,MB_SIZE,0,MB_SIZE);b.Position=UDim2.new(0,col*(MB_SIZE+MB_GAP),0,row*(MB_SIZE+MB_GAP));b.BackgroundColor3=OFF;b.BorderSizePixel=0;b.ClipsDescendants=true;b.Active=false 
        local savedInd=mobBtnSavedIndPos and mobBtnSavedIndPos[tostring(i)] 
        if type(savedInd)=="table" then 
            b.Position=UDim2.new(savedInd.xs or 0,savedInd.xo or 0,savedInd.ys or 0,savedInd.yo or 0) 
        end 

        Instance.new("UICorner",b).CornerRadius=getCorner() 
        local art=Instance.new("ImageLabel",b);art.Name="Art";art.BackgroundTransparency=1;art.Image=getButtonArtImage();art.ScaleType=Enum.ScaleType.Crop;art.Size=UDim2.new(1,0,1,0);art.Position=UDim2.new(0,0,0,0);art.ZIndex=1;art.ImageTransparency=0.6
        Instance.new("UICorner",art).CornerRadius=getCorner()
        local artShade=Instance.new("Frame",b);artShade.Name="ArtShade";artShade.Size=UDim2.new(1,0,1,0);artShade.Position=UDim2.new(0,0,0,0);artShade.BackgroundColor3=Color3.fromRGB(0,0,0);artShade.BackgroundTransparency=0.45;artShade.BorderSizePixel=0;artShade.ZIndex=2
        Instance.new("UICorner",artShade).CornerRadius=getCorner()
        local st=Instance.new("UIStroke",b);st.Color=Color3.fromRGB(70,70,80);st.Thickness=1.4;st.Transparency=0 
        local top=Instance.new("TextLabel",b);top.BackgroundTransparency=1;top.Text=def.top;top.TextColor3=W;top.Font=Enum.Font.SciFi;top.TextSize=math.max(8,math.floor(10*mobileButtonsSize/100));top.TextStrokeTransparency=0;top.TextStrokeColor3=Color3.fromRGB(0,0,0);top.ZIndex=3 
        local bot=Instance.new("TextLabel",b);bot.BackgroundTransparency=1;bot.Text=def.bot;bot.TextColor3=W;bot.Font=Enum.Font.SciFi;bot.TextSize=math.max(7,math.floor(7.5*mobileButtonsSize/100));bot.TextStrokeTransparency=0;bot.TextStrokeColor3=Color3.fromRGB(0,0,0);bot.ZIndex=3 
                top.TextYAlignment=Enum.TextYAlignment.Center 
        bot.TextYAlignment=Enum.TextYAlignment.Center 
        top.TextXAlignment=Enum.TextXAlignment.Center 
        bot.TextXAlignment=Enum.TextXAlignment.Center 
        top.TextStrokeTransparency=1 
        bot.TextStrokeTransparency=1 
        if def.layout=="sideBySide" then 
            top.Size=UDim2.new(0.5,0,1,0);top.Position=UDim2.new(0,0,0,0) 
            bot.Size=UDim2.new(0.5,0,1,0);bot.Position=UDim2.new(0.5,0,0,0) 
        elseif def.bot=="" then 
            top.Size=UDim2.new(1,-8,1,-8);top.Position=UDim2.new(0,4,0,4);top.TextScaled=true;top.TextWrapped=false 
            bot.Size=UDim2.new(0,0,0,0);bot.Position=UDim2.new(0,0,0,0) 
        else 
            top.Size=UDim2.new(1,-8,0.5,-4);top.Position=UDim2.new(0,4,0,2);top.TextScaled=true;top.TextWrapped=false 
            bot.Size=UDim2.new(1,-8,0.5,-4);bot.Position=UDim2.new(0,4,0.5,2);bot.TextScaled=true;bot.TextWrapped=false 
        end 
        local on=false 
        local function setOn(state) 
            on=(state==true) 
            art.Image=getButtonArtImage()
            if on then 
                b.BackgroundColor3=Color3.fromRGB(255,255,255) 
                art.ImageTransparency=0.38
                artShade.BackgroundTransparency=0.62
                top.TextColor3=Color3.fromRGB(0,0,0) 
                bot.TextColor3=Color3.fromRGB(0,0,0) 
                st.Color=Color3.fromRGB(255,255,255) 
            else 
                b.BackgroundColor3=Color3.fromRGB(0,0,0) 
                art.ImageTransparency=0.6
                artShade.BackgroundTransparency=0.45
                top.TextColor3=Color3.fromRGB(255,255,255) 
                bot.TextColor3=Color3.fromRGB(255,255,255) 
                st.Color=Color3.fromRGB(70,70,80) 
            end 
        end 
        mobBtnRefs[def.key]=setOn
        mobBtnTextRefs[def.key]={top=top,bot=bot}
        if def.key=="antiDesync" then
            _G.DeepRefreshTPAimbotLabels=function()
                local modeText=(tpAimbotMode=="v2") and "AIMBOT V2" or "AIMBOT V1"
                local ref=mobBtnTextRefs and mobBtnTextRefs.antiDesync
                if ref then
                    if ref.top then ref.top.Text="TP" end
                    if ref.bot then ref.bot.Text=modeText end
                end
                if _G.DeepTPAimbotMenuLabel and _G.DeepTPAimbotMenuLabel.Parent then
                    _G.DeepTPAimbotMenuLabel.Text=(tpAimbotMode=="v2") and "TP AIMBOT V2" or "TP AIMBOT V1"
                end
            end
            pcall(_G.DeepRefreshTPAimbotLabels)
        end
        if def.key=="autoLeft" then setOn(autoLeftEnabled) 
        elseif def.key=="autoRight" then setOn(autoRightEnabled) 
        elseif def.key=="autoBat" then setOn(autoBatEnabled) 
        elseif def.key=="carrySpeed" then setOn(speedMode and not laggerToggled) 
        elseif def.key=="laggerSpeed" then setOn(laggerToggled and laggerPhase==1) 
        elseif def.key=="laggerCarry" then setOn(laggerToggled and laggerPhase==2) 
        elseif def.key=="antiDesync" then setOn(tpAimbotEnabled)
        elseif def.key=="aimbot2" then setOn(_G.DeepBatV2ManualEnabled)
        elseif def.key=="bypass" then setOn(_G.ExeBypass and _G.ExeBypass.enabled)
        end 
        local hit=Instance.new("TextButton",b) 
        hit.Name="Hitbox";hit.Size=UDim2.new(1,0,1,0);hit.Position=UDim2.new(0,0,0,0);hit.BackgroundTransparency=1;hit.Text="";hit.ZIndex=20;hit.AutoButtonColor=false 
        local dragging=false 
        local dragStart=nil 
        local startPos=nil 
        local moved=false 
        hit.InputBegan:Connect(function(input) 
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then 
                local freeOrangeButton = (def.key=="antiDesync")
                -- Lock UI trava o TP AIMBOT.
                if uiLocked then return end
                -- TP AIMBOT pode mover livremente enquanto a UI estiver destravada.
                if not freeOrangeButton and not mobileMovingMode then return end
                dragging=true moved=false dragStart=input.Position startPos=b.Position 
                input.Changed:Connect(function() 
                    if input.UserInputState==Enum.UserInputState.End then dragging=false end 
                end) 
            end 
        end) 
        UIS.InputChanged:Connect(function(input) 
            if not dragging then return end
            if uiLocked then dragging=false return end
            if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then 
                local d=input.Position-dragStart 
                if math.abs(d.X)>5 or math.abs(d.Y)>5 then moved=true end 
                if moved then 
                    b.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y) 
                    mobBtnSavedIndPos[tostring(i)]={xs=b.Position.X.Scale,xo=b.Position.X.Offset,ys=b.Position.Y.Scale,yo=b.Position.Y.Offset} 
                    saveMobileButtonsConfigOnly() 
                end 
            end 
        end) 
        hit.InputEnded:Connect(function(input) 
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then 
                local freeOrangeButton = (def.key=="antiDesync")
                if not moved and (not mobileMovingMode or freeOrangeButton) then 
                    if def.key=="drop" then 
                        runSelectedDrop() 
                        setOn(true) 
                        task.delay(0.45,function() if not dropActive and not jumpDropActive then setOn(false) end end) 
                    elseif def.key=="tpDown" then 
                        task.spawn(runTPFloor);setOn(true);task.delay(0.35,function() setOn(false) end) 
                    elseif def.key=="autoLeft" then 
                        autoLeftEnabled=not autoLeftEnabled;if autoLeftEnabled then queueAutoLeftStart() else stopAutoLeft() end;if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end;setOn(autoLeftEnabled);if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end;saveConfig();saveMobileButtonsConfigOnly() 
                    elseif def.key=="autoRight" then 
                        autoRightEnabled=not autoRightEnabled;if autoRightEnabled then queueAutoRightStart() else stopAutoRight() end;if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end;setOn(autoRightEnabled);if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end;saveConfig();saveMobileButtonsConfigOnly() 
                    elseif def.key=="autoBat" then 
                        if autoBatEnabled then autoBatEnabled=false;disableAutoBat();setOn(false);if autoBatSetVisual then autoBatSetVisual(false) end 
                        else queueAutoBatStart();setOn(autoBatEnabled);if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end;if mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(autoLeftEnabled) end;if mobBtnRefs.autoRight then mobBtnRefs.autoRight(autoRightEnabled) end 
                        end;saveConfig();saveMobileButtonsConfigOnly() 
                    elseif def.key=="carrySpeed" then 
                        if speedMode and not laggerToggled then
                            speedMode=false;laggerToggled=false;laggerPhase=0
                        else
                            speedMode=true;laggerToggled=false;laggerPhase=0
                        end
                        if modeValLbl then modeValLbl.Text=speedMode and "CARRY" or "NORMAL" end
                        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(speedMode and not laggerToggled) end 
                        if mobBtnRefs.laggerSpeed then mobBtnRefs.laggerSpeed(false) end 
                        if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(false) end 
                        saveConfig();saveMobileButtonsConfigOnly() 
                    elseif def.key=="laggerSpeed" then 
                        if laggerToggled and laggerPhase==1 then
                            speedMode=false;laggerToggled=false;laggerPhase=0
                        else
                            speedMode=false;laggerToggled=true;laggerPhase=1
                        end
                        if modeValLbl then modeValLbl.Text=laggerToggled and "LAGGER NORMAL" or "NORMAL" end
                        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(false) end 
                        if mobBtnRefs.laggerSpeed then mobBtnRefs.laggerSpeed(laggerToggled and laggerPhase==1) end 
                        if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(false) end 
                        saveConfig();saveMobileButtonsConfigOnly() 
                    elseif def.key=="laggerCarry" then 
                        if laggerToggled and laggerPhase==2 then
                            speedMode=false;laggerToggled=false;laggerPhase=0
                        else
                            speedMode=false;laggerToggled=true;laggerPhase=2
                        end
                        if modeValLbl then modeValLbl.Text=laggerToggled and "LAGGER CARRY" or "NORMAL" end
                        if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(false) end 
                        if mobBtnRefs.laggerSpeed then mobBtnRefs.laggerSpeed(false) end 
                        if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerToggled and laggerPhase==2) end 
                        saveConfig();saveMobileButtonsConfigOnly() 
                    elseif def.key=="antiDesync" then 
                        setTPAimbot(not tpAimbotEnabled);setOn(tpAimbotEnabled);saveConfig();saveMobileButtonsConfigOnly()
                    elseif def.key=="aimbot2" then
                        setAimbot2(not _G.DeepBatV2ManualEnabled);setOn(_G.DeepBatV2ManualEnabled);saveConfig();saveMobileButtonsConfigOnly()
                    elseif def.key=="bypass" then
                        if _G.ExeBypass then
                            _G.ExeSetBypass(not _G.ExeBypass.enabled)
                            setOn(_G.ExeBypass.enabled)
                        end
                        saveConfig();saveMobileButtonsConfigOnly()
                    end 
                end 
                dragging=false moved=false 
            end 
        end) 
    end 
end 
function saveConfig() 
    if not configPersistenceEnabled then return end
    pcall(saveMobileButtonPositions) 
    local function ks(e) return {kb=e.kb and e.kb.Name or nil} end 
    local function ps(o) return o and {xs=o.Position.X.Scale,xo=o.Position.X.Offset,ys=o.Position.Y.Scale,yo=o.Position.Y.Offset} or nil end 
    local cfg={ 
        normalSpeed=NS,carrySpeed=CS,dropVersion=dropVersion, 
        dropBrainrotKey=ks(KB.DropBrainrot),autoLeftKey=ks(KB.AutoLeft),autoRightKey=ks(KB.AutoRight), 
        autoBatKey=ks(KB.AutoBat),laggerToggleKey=ks(KB.LaggerToggle),tpFloorKey=ks(KB.TPFloor),guiHideKey=ks(KB.GuiHide), 
        speedToggleKey=ks(KB.SpeedToggle),aimbot2Key=ks(KB.Aimbot2),antiDesyncAimbotKey=ks(KB.AntiDesyncAimbot),laggerPanelKey=exeLaggerPanelKey and exeLaggerPanelKey.Name or nil, 
        grabRadius=Steal.StealRadius,stealDuration=Steal.StealDuration,delayRadius=Steal.DelayRadius,stopPercent=Steal.StopPercent, 
        antiRagdoll=antiRagdollEnabled,ragdollTimer=_G.DeepRagdollTimerEnabled,autoStealEnabled=Steal.AutoStealEnabled,
        infiniteJump=infJumpEnabled,medusaCounter=medusaCounterEnabled,
        batCounter=batCounterEnabled,
        bypassEnabled=(_G.ExeBypass and _G.ExeBypass.enabled==true),bypassPower=(_G.ExeBypass and _G.ExeBypass.power or 72000),bypassAutoBrainrot=(_G.ExeBypass and _G.ExeBypass.autoBrainrot==true),
        bodyLockEnabled=bodyLockEnabled,bodyLockRadius=bodyLockRadius, 
        carryMode=speedMode,laggerMode=laggerToggled,laggerCarryMode=laggerPhase==2,laggerSpeed=LAGGER_SPEED,laggerCarrySpeed=LAGGER_CARRY_SPEED, 
        autoBat=autoBatEnabled,autoSwing=autoSwingEnabled,autoBatSpeed=AUTO_BAT_SPEED,greenNormalAimbotSpeed=(_G.DeepGreenAimbot and _G.DeepGreenAimbot.normalSpeed or 58),greenBypassAimbotSpeed=(_G.DeepGreenAimbot and _G.DeepGreenAimbot.bypassSpeed or 58),greenAimbotVersion=(_G.DeepGreenAimbot and _G.DeepGreenAimbot.version or "NORMAL"),greenAimbotEnabled=(_G.DeepGreenAimbot and _G.DeepGreenAimbot.enabled==true),aimbot2=_G.DeepBatV2ManualEnabled,batV2=_G.DeepBatV2ManualEnabled,antiDesyncAimbot=tpAimbotEnabled,tpAimbotMode=tpAimbotMode,spaceTpAntiDie=spaceTpAntiDieEnabled,         espEnabled=_G.DeepESP.enabled,espLine=_G.DeepESP.line,espSquare=_G.DeepESP.square,espExpanded=_G.DeepESP.expanded,
        antiBatMaster=(_G.DeepAntiBat and _G.DeepAntiBat.enabled==true),
        antiBatV1=(_G.DeepAntiBat and _G.DeepAntiBat.v1==true),
        antiBatV2=(_G.DeepAntiBat and _G.DeepAntiBat.v2==true),
        antiBatExpanded=(_G.DeepAntiBat and _G.DeepAntiBat.expanded==true),

        unwalkEnabled=unwalkEnabled, 
        anti404Drop=antiDrop404Enabled,anti404Enabled=(antiDrop404Enabled and antiDie404Enabled and antiBat404Enabled and infJumpEnabled),anti404Die=antiDie404Enabled,anti404Bat=antiBat404Enabled, 
        antiLag=antiLagEnabled,stretchRez=stretchRezEnabled,fpsBoostEnabled=fpsBoostEnabled, 
        autoSwitchSpeed=autoSwitchSpeedEnabled,autoTurnOffSpeed=autoTurnOffSpeedEnabled,autoSwitchLaggerSpeed=autoSwitchLaggerSpeedEnabled, 
        fovEnabled=fovEnabled,fovValue=fovValue, 
        uiScale=uiScale,autoGrabScale=_G.DeepAutoGrabScale,uiLocked=uiLocked,hubImageChoice=hubImageChoice,buttonImageChoice=buttonImageChoice,
        e01NewEnabled=(_G.DeepE01New and _G.DeepE01New.enabled==true),
        skinKatana=(_G.DeepSkins and _G.DeepSkins.katanaEnabled==true),
        skinMinecraft=(_G.DeepSkins and _G.DeepSkins.minecraftEnabled==true),
        skinMinecraftColor=(_G.DeepSkins and _G.DeepSkins.minecraftColor or "Default"),
        skinAnimPack=(_G.DeepSkins and _G.DeepSkins.animPack or "Off"),
        skinOutfitIndex=(_G.DeepSkins and _G.DeepSkins.outfitIndex or 6),
        skinBackgroundIndex=(_G.DeepSkins and _G.DeepSkins.backgroundIndex or 1),
        mobileButtonsSize=mobileButtonsSize,mobileButtonShape=mobileButtonShape,mobileDragSmall=mobileDragSmall,mobileMovingMode=mobileMovingMode,laggerSpeedKey="laggerSpeed",laggerCarryKey="laggerCarry",carrySpeedKey="carrySpeed", 
        mobBtnSavedContainerPos=mobBtnSavedContainerPos,mobBtnSavedIndPos=mobBtnSavedIndPos, 
        guiPos=ps(exeMainFrame),miniPos=ps(exeMiniButton),grabBarPos=ps(exeGrabBar), 
        stealBarPos=stealBarContainer and ps(stealBarContainer) or nil 
    } 
    if writefile then pcall(function() writefile("exeMobile.json",HS:JSONEncode(cfg)) end) end 
end 
task.spawn(function() 
    while task.wait(1) do pcall(saveConfig) end 
end) 
pcall(function() game:BindToClose(function() pcall(saveConfig) end) end) 
pcall(function() LP.AncestryChanged:Connect(function(_,parent) if not parent then pcall(saveConfig) end end) end) 
local function refreshSpeedButtons()
    if mobBtnRefs and mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(speedMode and not laggerToggled) end
    if mobBtnRefs and mobBtnRefs.laggerSpeed then mobBtnRefs.laggerSpeed(laggerToggled and laggerPhase==1) end
    if mobBtnRefs and mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(laggerToggled and laggerPhase==2) end
end
local setInstaGrab,setInfJumpVisual,setAntiRagVisual,setMedusaVisual 
local setUnwalkVisual,setAntiLagVisual,setAutoSwingVisual 

function buildDeepAnimationPackControl(page,mkRow,mkLabel)
    local row=mkRow(page,38)
    mkLabel(row,"Animation Pack")

    local left=Instance.new("TextButton",row)
    left.Size=UDim2.new(0,24,0,22)
    left.Position=UDim2.new(1,-150,0.5,-11)
    left.BackgroundColor3=Color3.fromRGB(10,10,14)
    left.BorderSizePixel=0
    left.Text="<"
    left.TextColor3=Color3.fromRGB(255,255,255)
    left.Font=Enum.Font.SciFi
    left.TextSize=12
    left.ZIndex=5
    Instance.new("UICorner",left).CornerRadius=UDim.new(0,5)
    local ls=Instance.new("UIStroke",left)
    ls.Color=Color3.fromRGB(80,80,90)
    ls.Thickness=1

    local value=Instance.new("TextLabel",row)
    value.Size=UDim2.new(0,92,0,22)
    value.Position=UDim2.new(1,-122,0.5,-11)
    value.BackgroundColor3=Color3.fromRGB(10,10,14)
    value.BorderSizePixel=0
    value.TextColor3=Color3.fromRGB(255,255,255)
    value.Font=Enum.Font.SciFi
    value.TextSize=8
    value.TextXAlignment=Enum.TextXAlignment.Center
    value.TextTruncate=Enum.TextTruncate.AtEnd
    value.ZIndex=5
    Instance.new("UICorner",value).CornerRadius=UDim.new(0,5)
    local vs=Instance.new("UIStroke",value)
    vs.Color=Color3.fromRGB(45,45,55)
    vs.Thickness=1

    local right=Instance.new("TextButton",row)
    right.Size=UDim2.new(0,24,0,22)
    right.Position=UDim2.new(1,-26,0.5,-11)
    right.BackgroundColor3=Color3.fromRGB(10,10,14)
    right.BorderSizePixel=0
    right.Text=">"
    right.TextColor3=Color3.fromRGB(255,255,255)
    right.Font=Enum.Font.SciFi
    right.TextSize=12
    right.ZIndex=5
    Instance.new("UICorner",right).CornerRadius=UDim.new(0,5)
    local rs=Instance.new("UIStroke",right)
    rs.Color=Color3.fromRGB(80,80,90)
    rs.Thickness=1

    _G.DeepAnimPack.refresh=function()
        value.Text=tostring(_G.DeepAnimPack.selected or "OFF"):upper()
    end
    _G.DeepAnimPack.refresh()

    left.Activated:Connect(function()
        if _anyKeyListening then return end
        local pack=_G.DeepAnimPack.setIndex((_G.DeepAnimPack.index or 1)-1)
        if setUnwalkVisual then setUnwalkVisual(pack=="Unwalk") end
    end)

    right.Activated:Connect(function()
        if _anyKeyListening then return end
        local pack=_G.DeepAnimPack.setIndex((_G.DeepAnimPack.index or 1)+1)
        if setUnwalkVisual then setUnwalkVisual(pack=="Unwalk") end
    end)
end
local normalBox,carryBox,laggerBox,laggerCarryBox,radInput,durationBox,uiScaleBox 
local set404AntiDropVisual,set404AntiDieVisual,set404InfiniteJumpVisual,set404AntiBatVisual
local antiDrop404Enabled=false
local antiDie404Enabled=false
local antiBat404Enabled=false
local anti404Conns={drop=nil,die=nil,bat=nil}
local anti404LastSafe=nil

function _G.DeepSetAntiDropTag(on)
    local char=LP.Character
    local head=char and char:FindFirstChild("Head")
    local bb=head and head:FindFirstChild("DeepDuelsBB")
    local lbl=bb and bb:FindFirstChild("AntiDropLbl")
    if not lbl then return end

    lbl.Text="Best anti drop Deep duels"
    lbl.Visible=(on==true)
end

LP.CharacterAdded:Connect(function(char)
    task.spawn(function()
        task.wait(0.7)
        if LP.Character==char and antiDrop404Enabled then
            pcall(function() _G.DeepSetAntiDropTag(true) end)
        end
    end)
end)

local anti404Tick=0
local anti404LastRescue=0

local function start404AntiDrop()
    if anti404Conns.drop then return end

    anti404Tick=0
    anti404Conns.drop=RunService.Heartbeat:Connect(function(dt)
        if not antiDrop404Enabled and not antiDie404Enabled then
            return
        end

        anti404Tick=anti404Tick+(dt or 0)
        if anti404Tick<0.08 then return end
        anti404Tick=0

        local char=LP.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not char or not hum or not root then return end

        -- Anti Drop: atualiza a posição segura sem escrever CFrame a cada frame.
        if antiDrop404Enabled then
            if hum.FloorMaterial~=Enum.Material.Air and root.Position.Y>-500 then
                anti404LastSafe=root.CFrame
            elseif anti404LastSafe and root.Position.Y<-50 and (os.clock()-anti404LastRescue)>0.75 then
                anti404LastRescue=os.clock()
                pcall(function()
                    root.CFrame=anti404LastSafe
                    root.AssemblyLinearVelocity=Vector3.zero
                    root.AssemblyAngularVelocity=Vector3.zero
                end)
            end
        end

        -- Anti Die: não força Health client-side continuamente.
        -- Isso evita disputa com o servidor/respawn, que causava travadas.
        if antiDie404Enabled and hum.Health<=0 then
            return
        end

    end)
end

local function stop404AntiDrop()
    if anti404Conns.drop then
        anti404Conns.drop:Disconnect()
        anti404Conns.drop=nil
    end
    anti404LastSafe=nil
    anti404Tick=0
end

local function start404AntiDie()
    start404AntiDrop()
end

local function stop404AntiDie()
    -- O loop é compartilhado com Anti Drop.
end

local antiBatVelocityConn=nil
local antiBatVelocitySpeed=10000
local antiBatVelocityAngle=0
local antiBatVelocityDirection=1

local function stop404AntiBat()
    if antiBatVelocityConn then
        pcall(function() antiBatVelocityConn:Disconnect() end)
        antiBatVelocityConn=nil
    end
    antiBatVelocitySpeed=10000
    antiBatVelocityAngle=0
    antiBatVelocityDirection=1
    _G._AmbitiousAntiBatDesiredXZ=nil
    _G._AmbitiousAntiBatSpiking=false
end

local function start404AntiBat()
    stop404AntiBat()
    if not antiBat404Enabled then return end

    antiBatVelocityConn=RunService.Heartbeat:Connect(function()
        if not antiBat404Enabled then return end

        local char=LP.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not root or not root.Parent then return end

        -- O Anti Bat continua ligado, mas nao sobrescreve o movimento
        -- enquanto qualquer aimbot do Deep estiver controlando o personagem.
        local greenActive = _G.DeepGreenAimbot and (
            _G.DeepGreenAimbot.enabled == true
            or _G.DeepGreenAimbot.normal == true
            or _G.DeepGreenAimbot.bypass == true
        )
        local batV2Active = _G.DeepBatV2ManualEnabled == true
        local tpActive = tpAimbotEnabled == true
        local batAimbotActive = autoBatEnabled == true

        if greenActive or batV2Active or tpActive or batAimbotActive then
            _G._AmbitiousAntiBatSpiking=false
            _G._AmbitiousAntiBatDesiredXZ=nil
            return
        end

        local origXZ=Vector3.new(root.Velocity.X,0,root.Velocity.Z)

        antiBatVelocitySpeed=antiBatVelocitySpeed+(50*antiBatVelocityDirection)
        if antiBatVelocitySpeed>=20000 then
            antiBatVelocitySpeed=20000
            antiBatVelocityDirection=-1
        elseif antiBatVelocitySpeed<=10000 then
            antiBatVelocitySpeed=10000
            antiBatVelocityDirection=1
        end

        antiBatVelocityAngle=antiBatVelocityAngle+(math.random()*0.5)
        local radius=antiBatVelocitySpeed+math.random(-5000,5000)
        local newX=math.cos(antiBatVelocityAngle)*radius
        local newZ=math.sin(antiBatVelocityAngle)*radius

        _G._AmbitiousAntiBatSpiking=true
        root.Velocity=Vector3.new(newX,root.Velocity.Y,newZ)

        RunService.RenderStepped:Wait()

        if root and root.Parent then
            local want=_G._AmbitiousAntiBatDesiredXZ
            if want then
                root.Velocity=Vector3.new(want.X,root.Velocity.Y,want.Z)
            else
                root.Velocity=Vector3.new(origXZ.X,root.Velocity.Y,origXZ.Z)
            end
        end

        _G._AmbitiousAntiBatSpiking=false
    end)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        if antiBat404Enabled then
            if not antiBatVelocityConn then
                pcall(start404AntiBat)
            end
        elseif antiBatVelocityConn then
            pcall(stop404AntiBat)
        end
    end
end)

LP.CharacterAdded:Connect(function()
    if antiBat404Enabled then
        task.defer(function()
            task.wait(0.4)
            if antiBat404Enabled then pcall(start404AntiBat) end
        end)
    else
        pcall(stop404AntiBat)
    end
end)


-- ============================================================
-- ANTI BAT V1 / V2
-- V1 = Anti Bat antigo.
-- V2 = desync de posição feito para neutralizar a perseguição do Bat V2.
-- ============================================================
_G.DeepAntiBat=_G.DeepAntiBat or {
    enabled=false,
    v1=true,
    v2=false,
    expanded=false,
    v2Conn=nil,
    v2FallbackConn=nil,
    v2Fake=nil,
    v2Root=nil,
    v2FakeY=-1000,
    v2FallbackSpeed=18000,
    v2FallbackAngle=0,
    v2FallbackDirection=1,
    ui={}
}

function _G.DeepAntiBat.stopV2()
    local D=_G.DeepAntiBat
    if not D then return end

    if D.v2Conn then
        pcall(function() D.v2Conn:Disconnect() end)
        D.v2Conn=nil
    end

    if D.v2FallbackConn then
        pcall(function() D.v2FallbackConn:Disconnect() end)
        D.v2FallbackConn=nil
    end

    pcall(function()
        if sethiddenproperty and D.v2Root and D.v2Root.Parent then
            sethiddenproperty(D.v2Root,"PhysicsRepRootPart",D.v2Root)
        end
    end)

    if D.v2Fake then
        pcall(function() D.v2Fake:Destroy() end)
        D.v2Fake=nil
    end

    D.v2Root=nil
    D.v2FallbackSpeed=18000
    D.v2FallbackAngle=0
    D.v2FallbackDirection=1
end

function _G.DeepAntiBat.makeV2Fake(root)
    local D=_G.DeepAntiBat
    if not D or not root then return nil end

    if D.v2Fake then
        pcall(function() D.v2Fake:Destroy() end)
        D.v2Fake=nil
    end

    local fake=Instance.new("Part")
    fake.Name="DeepAntiBatV2FakeHRP"
    fake.Size=Vector3.new(2,2,1)
    fake.Anchored=true
    fake.CanCollide=false
    fake.CanTouch=false
    fake.CanQuery=false
    fake.Transparency=1
    fake.CFrame=CFrame.new(root.Position.X,D.v2FakeY or -1000,root.Position.Z)
    fake.Parent=workspace

    D.v2Fake=fake
    D.v2Root=root
    return fake
end

function _G.DeepAntiBat.startV2Fallback()
    local D=_G.DeepAntiBat
    if not D or D.v2FallbackConn then return end

    D.v2FallbackSpeed=18000
    D.v2FallbackAngle=0
    D.v2FallbackDirection=1

    D.v2FallbackConn=RunService.Heartbeat:Connect(function()
        if not D.enabled or not D.v2 then return end
        if sethiddenproperty then return end

        local char=LP.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not root or not root.Parent then return end

        local original=Vector3.new(root.Velocity.X,0,root.Velocity.Z)

        D.v2FallbackSpeed=D.v2FallbackSpeed+(100*D.v2FallbackDirection)
        if D.v2FallbackSpeed>=30000 then
            D.v2FallbackSpeed=30000
            D.v2FallbackDirection=-1
        elseif D.v2FallbackSpeed<=18000 then
            D.v2FallbackSpeed=18000
            D.v2FallbackDirection=1
        end

        D.v2FallbackAngle=D.v2FallbackAngle+(math.random()*0.9)
        local radius=D.v2FallbackSpeed+math.random(-6500,6500)
        local x=math.cos(D.v2FallbackAngle)*radius
        local z=math.sin(D.v2FallbackAngle)*radius

        root.Velocity=Vector3.new(x,root.Velocity.Y,z)

        task.spawn(function()
            RunService.RenderStepped:Wait()
            if root and root.Parent then
                root.Velocity=Vector3.new(original.X,root.Velocity.Y,original.Z)
            end
        end)
    end)
end

function _G.DeepAntiBat.startV2()
    local D=_G.DeepAntiBat
    if not D then return end

    D.stopV2()

    if not D.enabled or not D.v2 then return end

    if sethiddenproperty then
        D.v2Conn=RunService.Heartbeat:Connect(function()
            if not D.enabled or not D.v2 then return end

            local char=LP.Character
            local root=char and char:FindFirstChild("HumanoidRootPart")
            if not root or not root.Parent then return end

            if D.v2Root~=root or not D.v2Fake or not D.v2Fake.Parent then
                pcall(function()
                    if D.v2Root and D.v2Root.Parent then
                        sethiddenproperty(D.v2Root,"PhysicsRepRootPart",D.v2Root)
                    end
                end)
                D.makeV2Fake(root)
            end

            local fake=D.v2Fake
            if not fake or not fake.Parent then return end

            fake.CFrame=CFrame.new(root.Position.X,D.v2FakeY or -1000,root.Position.Z)
            fake.AssemblyLinearVelocity=Vector3.new(0,-1000,0)

            pcall(function()
                sethiddenproperty(root,"PhysicsRepRootPart",fake)
            end)
        end)
    else
        D.startV2Fallback()
    end
end

function _G.DeepAntiBat.refreshRuntime()
    local D=_G.DeepAntiBat
    if not D then return end

    -- O motor V1 so roda se Master + V1 estiverem ligados.
    antiBat404Enabled=(D.enabled==true and D.v1==true)
    if antiBat404Enabled then
        pcall(start404AntiBat)
    else
        pcall(stop404AntiBat)
    end

    -- O motor V2 so roda se Master + V2 estiverem ligados.
    if D.enabled==true and D.v2==true then
        pcall(D.startV2)
    else
        pcall(D.stopV2)
    end

    if set404AntiBatVisual then
        pcall(set404AntiBatVisual,D.enabled==true)
    end
    if D.ui.v1Visual then pcall(D.ui.v1Visual,D.v1==true) end
    if D.ui.v2Visual then pcall(D.ui.v2Visual,D.v2==true) end
end

function _G.DeepAntiBat.setMaster(on)
    _G.DeepAntiBat.enabled=(on==true)
    _G.DeepAntiBat.refreshRuntime()
end

function _G.DeepAntiBat.setV1(on)
    _G.DeepAntiBat.v1=(on==true)
    _G.DeepAntiBat.refreshRuntime()
end

function _G.DeepAntiBat.setV2(on)
    _G.DeepAntiBat.v2=(on==true)
    _G.DeepAntiBat.refreshRuntime()
end


local function refreshSpeedModeLabel() 
    if modeValLbl then 
        modeValLbl.Text=laggerToggled and (laggerPhase==2 and "LAGGER CARRY" or "LAGGER NORMAL") or (speedMode and "CARRY" or "NORMAL") 
    end 
end 
local function setCarrySpeedMode() 
    speedMode=true;laggerToggled=false;laggerPhase=0;refreshSpeedModeLabel();refreshSpeedButtons()
end 
local function setLaggerSpeedMode() 
    speedMode=false;laggerToggled=true;laggerPhase=1;refreshSpeedModeLabel();refreshSpeedButtons()
end 
local function setLaggerCarryMode() 
    speedMode=false;laggerToggled=true;laggerPhase=2;refreshSpeedModeLabel();refreshSpeedButtons()
end 
local function toggleCarryMode() 
    if laggerToggled then setCarrySpeedMode() else speedMode=not speedMode;refreshSpeedModeLabel();refreshSpeedButtons() end 
end 
local function toggleLaggerMode() 
    if not laggerToggled then setLaggerCarryMode() elseif laggerPhase==2 then setLaggerSpeedMode() else setLaggerCarryMode() end 
end 
local function setModeNormal() 
    speedMode=false;laggerToggled=false;laggerPhase=0;refreshSpeedModeLabel();refreshSpeedButtons()
end 
local function setModeCarry() setCarrySpeedMode() end 
local function stopAutoSwitchSpeed() 
    if autoSwitchSpeedConn then autoSwitchSpeedConn:Disconnect();autoSwitchSpeedConn=nil end 
end 
local function startAutoSwitchSpeed() 
    if autoSwitchSpeedConn then return end 
    autoSwitchSpeedConn=RunService.Heartbeat:Connect(function() 
        if not autoSwitchSpeedEnabled and not autoTurnOffSpeedEnabled and not autoSwitchLaggerSpeedEnabled then stopAutoSwitchSpeed();return end 
        local char=LP.Character;if not char then return end 
        local hum=char:FindFirstChildOfClass("Humanoid");if not hum then return end 
        local ws=hum.WalkSpeed or 16 
        if autoSwitchSpeedEnabled and ws<=AUTO_SWITCH_THRESHOLD and not speedMode then setModeCarry() 
        elseif autoTurnOffSpeedEnabled and ws>AUTO_SWITCH_THRESHOLD and speedMode then setModeNormal() end 
        if autoSwitchLaggerSpeedEnabled and ws<=AUTO_SWITCH_THRESHOLD and not laggerToggled then 
            speedMode=false laggerToggled=true laggerPhase=2 refreshSpeedModeLabel() 
            if mobBtnRefs and mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(false) end 
            if mobBtnRefs and mobBtnRefs.laggerSpeed then mobBtnRefs.laggerSpeed(false) end
            if mobBtnRefs and mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(true) end 
        elseif autoSwitchLaggerSpeedEnabled and ws>AUTO_SWITCH_THRESHOLD and laggerToggled then setModeNormal() end 
    end) 
end 
function _G.DeepSetAutoGrabScale(value)
    local v=tonumber(value) or 1
    v=math.clamp(v,0.60,1.50)
    _G.DeepAutoGrabScale=v

    local sc=_G.DeepAutoGrabScaleObj
    if sc and sc.Parent then
        sc.Scale=v
    end

    if _G.DeepRefreshAutoGrabScaleButtons then
        pcall(_G.DeepRefreshAutoGrabScaleButtons)
    end
end

function _G.DeepBuildAutoGrabScaleControl(page,mkRow,mkLabel,INP,WHITE,W,STROKE)
    local row=mkRow(page,32)
    mkLabel(row,"Auto Grab Scale")

    local sizes={60,75,90,100,110,125,150}
    local bw=25
    local gap=2
    local startX=-6-(#sizes*(bw+gap))
    local refs={}

    local function refresh()
        local selected=math.floor((_G.DeepAutoGrabScale or 1)*100+0.5)
        for _,ref in ipairs(refs) do
            local active=(ref.sz==selected)
            ref.btn.BackgroundColor3=active and Color3.fromRGB(60,60,80) or INP
            ref.btn.TextColor3=active and WHITE or W
        end
    end
    _G.DeepRefreshAutoGrabScaleButtons=refresh

    for i,sz in ipairs(sizes) do
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,bw,0,20)
        btn.Position=UDim2.new(1,startX+(i-1)*(bw+gap),0.5,-10)
        btn.BackgroundColor3=INP
        btn.BorderSizePixel=0
        btn.Text=tostring(sz)
        btn.TextColor3=W
        btn.Font=Enum.Font.SciFi
        btn.TextSize=7
        btn.ZIndex=5

        local corner=Instance.new("UICorner",btn)
        corner.CornerRadius=UDim.new(0,5)

        local stroke=Instance.new("UIStroke",btn)
        stroke.Color=STROKE
        stroke.Thickness=1

        refs[#refs+1]={btn=btn,sz=sz}

        btn.Activated:Connect(function()
            _G.DeepSetAutoGrabScale(sz/100)
            refresh()
            pcall(saveConfig)
        end)
    end

    refresh()
end

-- ============================================================
-- DEEP SONG PLAYER
-- ============================================================
_G.DeepSong=_G.DeepSong or {
    currentSound=nil,
    visuals={},
    active=nil
}

_G.DeepSong.beretta={
    title="Beretta",
    url="https://file.garden/algLafWA1jk8WMfK/Beretta%20-%20video%20oficial(MP3_160K).mp3",
    file="Deep_beretta.mp3",
    volume=0.75,
    startAt=10
}

_G.DeepSong.tuff={
    title="Tuff Song",
    url="https://files.catbox.moe/rvf2vy.mp3",
    file="Deep_tuffsong.mp3",
    volume=0.75
}

function _G.DeepSong.notify(text)
    warn("[DEEP SONG] "..tostring(text))
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification",{
            Title="Song",
            Text=tostring(text),
            Duration=4
        })
    end)
end

function _G.DeepSong.getRequest()
    if type(request)=="function" then return request end
    if type(http_request)=="function" then return http_request end
    if syn and type(syn.request)=="function" then return syn.request end
    if fluxus and type(fluxus.request)=="function" then return fluxus.request end
    return nil
end

function _G.DeepSong.getAssetFunction()
    if type(getcustomasset)=="function" then return getcustomasset end
    if type(getsynasset)=="function" then return getsynasset end
    if type(getcustomassetv2)=="function" then return getcustomassetv2 end
    return nil
end

function _G.DeepSong.validBody(body)
    if type(body)~="string" or #body<1024 then return false end
    local h=body:sub(1,64):lower()
    if h:find("<html",1,true) or h:find("<!doctype",1,true) then return false end
    return true
end

function _G.DeepSong.download(config)
    if type(isfile)=="function" then
        local ok,exists=pcall(isfile,config.file)
        if ok and exists then return true end
    end

    if type(writefile)~="function" then
        return false,"Seu executor não possui writefile."
    end

    local req=_G.DeepSong.getRequest()
    if type(req)~="function" then
        return false,"Seu executor não possui request/http_request."
    end

    local ok,response=pcall(req,{
        Url=config.url,
        Method="GET",
        Headers={
            ["User-Agent"]="Mozilla/5.0",
            ["Accept"]="audio/mpeg,audio/*,*/*;q=0.8",
            ["Cache-Control"]="no-cache"
        }
    })

    if not ok or type(response)~="table" then
        return false,"Falha ao baixar a música."
    end

    local code=tonumber(response.StatusCode or response.Status or response.status_code) or 0
    local body=response.Body or response.body

    if code~=0 and (code<200 or code>=300) then
        return false,"Servidor retornou HTTP "..tostring(code)
    end

    if not _G.DeepSong.validBody(body) then
        return false,"O servidor não enviou um MP3 válido."
    end

    local wrote,err=pcall(writefile,config.file,body)
    if not wrote then return false,tostring(err) end
    return true
end

function _G.DeepSong.localAsset(config)
    local getAsset=_G.DeepSong.getAssetFunction()
    if type(getAsset)~="function" or type(isfile)~="function" then return nil end

    local exists=false
    pcall(function() exists=isfile(config.file) end)
    if not exists then return nil end

    local ok,asset=pcall(getAsset,config.file)
    if ok and type(asset)=="string" and asset~="" then
        return asset
    end
    return nil
end

function _G.DeepSong.refreshVisuals()
    for key,setter in pairs(_G.DeepSong.visuals) do
        if setter then
            pcall(setter,_G.DeepSong.active==key)
        end
    end
end

function _G.DeepSong.stop()
    if _G.DeepSong.currentSound then
        pcall(function() _G.DeepSong.currentSound:Stop() end)
        pcall(function() _G.DeepSong.currentSound:Destroy() end)
        _G.DeepSong.currentSound=nil
    end
    _G.DeepSong.active=nil
    _G.DeepSong.refreshVisuals()
end

function _G.DeepSong.play(key)
    local config=_G.DeepSong[key]
    if type(config)~="table" then return false end

    _G.DeepSong.stop()

    local asset=_G.DeepSong.localAsset(config)
    if not asset then
        _G.DeepSong.notify("Baixando "..config.title.."...")
        local ok,err=_G.DeepSong.download(config)
        if not ok then
            _G.DeepSong.notify(config.title..": "..tostring(err))
            return false
        end
        asset=_G.DeepSong.localAsset(config)
    end

    if not asset then
        _G.DeepSong.notify(config.title..": getcustomasset não conseguiu carregar o MP3.")
        return false
    end

    local sound=Instance.new("Sound")
    sound.Name="Deep_Song_"..config.title:gsub("[^%w]","_")
    sound.SoundId=asset
    sound.Volume=config.volume or 0.75
    sound.Looped=true
    sound.Parent=game:GetService("SoundService")

    _G.DeepSong.currentSound=sound
    _G.DeepSong.active=key
    _G.DeepSong.refreshVisuals()

    local loadedConn
    loadedConn=sound.Loaded:Connect(function()
        if _G.DeepSong.currentSound~=sound then return end
        if config.startAt then
            pcall(function() sound.TimePosition=config.startAt end)
        end
        pcall(function() sound:Play() end)
    end)

    task.delay(8,function()
        if loadedConn then pcall(function() loadedConn:Disconnect() end) end
        if _G.DeepSong.currentSound==sound and not sound.IsLoaded then
            _G.DeepSong.stop()
            _G.DeepSong.notify(config.title..": o Roblox/executor não carregou o áudio local.")
        end
    end)

    pcall(function()
        if config.startAt then sound.TimePosition=config.startAt end
        sound:Play()
    end)

    return true
end


local function buildGui() 
    local BG = Color3.fromRGB(5,5,7) 
    local BG2 = Color3.fromRGB(9,9,13) 
    local CARD = Color3.fromRGB(14,14,18) 
    local HOV = Color3.fromRGB(22,22,28) 
    local WHITE = Color3.fromRGB(255,255,255) 
    local WHITEDIM= Color3.fromRGB(200,200,200) 
    local STROKE= Color3.fromRGB(80,80,90) 
    local W = Color3.fromRGB(255,255,255) 
    local DIM = Color3.fromRGB(180,180,180) 
    local INP = Color3.fromRGB(10,10,14) 
    local OFF = Color3.fromRGB(28,28,35) 
    local old=game:GetService("CoreGui"):FindFirstChild("DeepDuels") or game:GetService("CoreGui"):FindFirstChild(".exe");if old then old:Destroy() end 
    local pg=LP:FindFirstChild("PlayerGui");if pg then local o=pg:FindFirstChild("DeepDuels") or pg:FindFirstChild(".exe");if o then o:Destroy() end end 
    local gui=Instance.new("ScreenGui") 
    gui.Name="DeepDuels";gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.IgnoreGuiInset=true 
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end) 
    if not pcall(function() gui.Parent=game:GetService("CoreGui") end) then gui.Parent=LP:WaitForChild("PlayerGui") end 
    local main=Instance.new("Frame",gui) 
    main.Size=UDim2.new(0,272,0,340);main.Position=UDim2.new(0.5,-136,0.5,-170);exeMainFrame=main 
    main.BackgroundColor3=BG;main.BackgroundTransparency=0;main.BorderSizePixel=0;main.ClipsDescendants=true 
    Instance.new("UICorner",main).CornerRadius=UDim.new(0,18) 
    local bgImage = Instance.new("ImageLabel", main) 
    bgImage.Size = UDim2.new(0.5,-2,1,-76)
    bgImage.Position = UDim2.new(0,0,0,76)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = getHubArtImage() 
    bgImage.ScaleType = Enum.ScaleType.Crop 
    bgImage.ZIndex = 0 
    bgImage.Parent = main
    hubBgImageRef = bgImage
    Instance.new("UICorner",bgImage).CornerRadius=UDim.new(0,18) 
    main.BackgroundTransparency = 1 
    local overlay = Instance.new("Frame", main) 
    overlay.Size = UDim2.new(1,0,1,0) 
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0) 
    overlay.BackgroundTransparency = 0.45 
    overlay.BorderSizePixel = 0 
    overlay.ZIndex = 1 
    Instance.new("UICorner", overlay).CornerRadius = UDim.new(0,18) 
    local scaleObj=Instance.new("UIScale",main);scaleObj.Scale=uiScale 
    local function drag(f,lockable) 
        local dn,ds,sp,di=false 
        f.InputBegan:Connect(function(i) 
            if lockable and uiLocked then return end 
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then 
                dn=true;ds=i.Position;sp=f.Position 
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dn=false;pcall(saveConfig) end end) 
            end 
        end) 
        f.InputChanged:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then di=i end end) 
        UIS.InputChanged:Connect(function(i) 
            if lockable and uiLocked then dn=false;return end 
            if i==di and dn then 
                local nX=sp.X.Offset+(i.Position.X-ds.X) 
                local nY=sp.Y.Offset+(i.Position.Y-ds.Y) 
                f.Position=UDim2.new(sp.X.Scale,nX,sp.Y.Scale,nY) 
            end 
        end) 
    end 
    drag(main,true) 
    local hdr=Instance.new("Frame",main) 
    hdr.Size=UDim2.new(1,0,0,36);hdr.BackgroundColor3=BG2;hdr.BackgroundTransparency=0;hdr.BorderSizePixel=0;hdr.ZIndex=2 
    Instance.new("UICorner",hdr).CornerRadius=UDim.new(0,18) 
    local ttl=Instance.new("TextLabel",hdr) 
    ttl.Size=UDim2.new(1,-78,1,0);ttl.Position=UDim2.new(0,10,0,0)
    ttl.BackgroundTransparency=1;ttl.Text="DEEP DUELS";ttl.ZIndex=4 
    ttl.TextColor3=WHITE;ttl.Font=Enum.Font.SciFi;ttl.TextSize=13 
    ttl.TextXAlignment=Enum.TextXAlignment.Left 
    local bottomNav=Instance.new("Frame",main) 
    bottomNav.Size=UDim2.new(1,0,0,40);bottomNav.Position=UDim2.new(0,0,0,36);bottomNav.BackgroundColor3=Color3.fromRGB(0,0,0);bottomNav.BorderSizePixel=0;bottomNav.ZIndex=10 
    bottomNav.BackgroundTransparency=0.45 
    Instance.new("UICorner",bottomNav).CornerRadius=UDim.new(0,0) 
    local navStroke=Instance.new("UIStroke",bottomNav);navStroke.Color=Color3.fromRGB(255,255,255);navStroke.Thickness=0.5;navStroke.Transparency=0.7 
    local pages,tabButtons={} ,{} 
    local navDragState={dragging=false,moved=false,start=nil,mainStart=nil} 
    local function navDragBegin(input) 
        if uiLocked then return end 
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then 
            navDragState.dragging=true 
            navDragState.moved=false 
            navDragState.start=input.Position 
            navDragState.mainStart=main.Position 
        end 
    end 
    local function navDragMove(input) 
        if not navDragState.dragging or uiLocked then return end 
        if input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch then 
            local d=input.Position-navDragState.start 
            if math.abs(d.X)>4 or math.abs(d.Y)>4 then navDragState.moved=true end 
            if navDragState.moved then 
                main.Position=UDim2.new(navDragState.mainStart.X.Scale,navDragState.mainStart.X.Offset+d.X,navDragState.mainStart.Y.Scale,navDragState.mainStart.Y.Offset+d.Y) 
            end 
        end 
    end 
    local function navDragEnd() 
        if navDragState.dragging then 
            local wasMoved=navDragState.moved 
            navDragState.dragging=false 
            navDragState.moved=false 
            if wasMoved then pcall(saveConfig) end 
        end 
    end 
    bottomNav.Active=true 
    bottomNav.InputBegan:Connect(navDragBegin) 
    bottomNav.InputChanged:Connect(navDragMove) 
    bottomNav.InputEnded:Connect(function(input) 
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then navDragEnd() end 
    end) 
    local function selectPage(id) 
        for name,page in pairs(pages) do page.Visible=(name==id) end 
        for name,btn in pairs(tabButtons) do 
            local active=name==id 
            TS:Create(btn,TweenInfo.new(0.12),{BackgroundColor3=active and Color3.fromRGB(255,255,255) or Color3.fromRGB(0,0,0),BackgroundTransparency=active and 0 or 1,TextColor3=active and Color3.fromRGB(0,0,0) or Color3.fromRGB(180,180,180)}):Play() 
            for _,ch in ipairs(btn:GetChildren()) do 
                if ch:IsA("UIStroke") then ch.Transparency=active and 0.6 or 1 end 
            end 
        end 
    end 
    -- Navegação alinhada igualmente em toda a largura do hub.
    local tabs={ {"menu","MAIN"}, {"lock","STEAL"}, {"aimbot","AIMBOT"}, {"config","SETTINGS"} }
    for i,t in ipairs(tabs) do
        local btn=Instance.new("TextButton",bottomNav)
        btn.Size=UDim2.new(0.25,-4,0,34)
        btn.Position=UDim2.new((i-1)*0.25,2,0.5,-17)
        btn.BackgroundColor3=Color3.fromRGB(10,10,14);btn.BackgroundTransparency=0;btn.BorderSizePixel=0;btn.Text=t[2];btn.TextColor3=DIM 
        btn.Font=Enum.Font.SciFi;btn.TextSize=8;btn.TextXAlignment=Enum.TextXAlignment.Center;btn.TextYAlignment=Enum.TextYAlignment.Center;btn.ZIndex=11 
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6) 
        Instance.new("UIStroke",btn).Color=Color3.fromRGB(40,40,50) 
        tabButtons[t[1]]=btn 
        btn.MouseEnter:Connect(function() if not pages[t[1]].Visible and not navDragState.moved then TS:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=HOV,TextColor3=WHITE}):Play() end end) 
        btn.MouseLeave:Connect(function() if not pages[t[1]].Visible and not navDragState.moved then TS:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(10,10,14),TextColor3=DIM}):Play() end end) 
        btn.InputBegan:Connect(navDragBegin) 
        btn.InputChanged:Connect(navDragMove) 
        btn.InputEnded:Connect(function(input) 
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then navDragEnd() end 
        end) 
        btn.Activated:Connect(function() 
            if not navDragState.moved then selectPage(t[1]) end 
        end) 
    end 
    local miniBtn=Instance.new("TextButton",gui) 
    miniBtn.Size=UDim2.new(0,100,0,28);miniBtn.Position=UDim2.new(1,-110,0,60);exeMiniButton=miniBtn 
    miniBtn.BackgroundColor3=BG2;miniBtn.BorderSizePixel=0 
    miniBtn.Text="DEEP DUELS";miniBtn.TextColor3=WHITE;miniBtn.Font=Enum.Font.SciFi;miniBtn.TextSize=11 
    miniBtn.ZIndex=20;miniBtn.Visible=false 
    Instance.new("UICorner",miniBtn).CornerRadius=UDim.new(0,8) 
    local miniStroke=Instance.new("UIStroke",miniBtn);miniStroke.Color=STROKE;miniStroke.Thickness=1.2 
    drag(miniBtn,false) 
    miniBtn.MouseEnter:Connect(function() TS:Create(miniBtn,TweenInfo.new(0.1),{BackgroundColor3=HOV}):Play() end) 
    miniBtn.MouseLeave:Connect(function() TS:Create(miniBtn,TweenInfo.new(0.1),{BackgroundColor3=BG2}):Play() end) 
    local function showGui() main.Visible=true;miniBtn.Visible=false end 
    local function hideGui() main.Visible=false;miniBtn.Visible=true end 
    local closeBtn=Instance.new("TextButton",hdr) 
    closeBtn.Size=UDim2.new(0,52,0,28);closeBtn.Position=UDim2.new(1,-58,0.5,-14)
    closeBtn.BackgroundColor3=BG2;closeBtn.BackgroundTransparency=1;closeBtn.BorderSizePixel=0;closeBtn.ZIndex=4 
    closeBtn.Text="-";closeBtn.TextColor3=WHITEDIM;closeBtn.Font=Enum.Font.SciFi;closeBtn.TextSize=22 
    Instance.new("UICorner",closeBtn).CornerRadius=UDim.new(0,6) 
    closeBtn.MouseEnter:Connect(function() TS:Create(closeBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(32,32,40),TextColor3=WHITEDIM}):Play() end) 
    closeBtn.MouseLeave:Connect(function() TS:Create(closeBtn,TweenInfo.new(0.1),{BackgroundColor3=BG2,TextColor3=WHITEDIM}):Play() end) 
    closeBtn.MouseButton1Click:Connect(hideGui) 
    miniBtn.MouseButton1Click:Connect(showGui) 
    local function mkPage(id) 
        local sf=Instance.new("ScrollingFrame",main) 
        sf.Size=UDim2.new(1,0,1,-76);sf.Position=UDim2.new(0,0,0,76) 
        sf.BackgroundTransparency=1;sf.BorderSizePixel=0;sf.ClipsDescendants=true;sf.Visible=false;sf.ZIndex=2 
        sf.ScrollBarThickness=3;sf.ScrollBarImageColor3=WHITE 
        sf.CanvasSize=UDim2.new(0,0,0,0);sf.AutomaticCanvasSize=Enum.AutomaticSize.Y 
        local ll=Instance.new("UIListLayout",sf);ll.SortOrder=Enum.SortOrder.LayoutOrder;ll.Padding=UDim.new(0,2) 
        local pad=Instance.new("UIPadding",sf) 
        pad.PaddingLeft=UDim.new(0,7);pad.PaddingRight=UDim.new(0,7) 
        pad.PaddingTop=UDim.new(0,7);pad.PaddingBottom=UDim.new(0,7) 
        pages[id]=sf 
        return sf 
    end 
    local menuPage,lockPage,aimbotPage,configPage=mkPage("menu"),mkPage("lock"),mkPage("aimbot"),mkPage("config") 
    local loByPage={} 
    local function LO(page) loByPage[page]=(loByPage[page] or 0)+1;return loByPage[page] end 
    local function mkSect(page,txt) 
        local f=Instance.new("Frame",page);f.Size=UDim2.new(1,0,0,22);f.BackgroundTransparency=1;f.BorderSizePixel=0;f.LayoutOrder=LO(page);f.ZIndex=3 
        local l=Instance.new("TextLabel",f);l.Size=UDim2.new(1,-8,1,0);l.Position=UDim2.new(0,8,0,0) 
        l.BackgroundTransparency=1;l.Text=txt:upper();l.TextColor3=WHITE;l.ZIndex=4 
        l.Font=Enum.Font.SciFi;l.TextSize=9;l.TextXAlignment=Enum.TextXAlignment.Left 
        l.TextStrokeTransparency=0.85;l.TextStrokeColor3=Color3.fromRGB(0,0,0) 
    end 
    local function mkRow(page,h) 
        local f=Instance.new("Frame",page);f.Size=UDim2.new(1,0,0,(h==32 and 28 or (h or 28)))
        f.BackgroundColor3=CARD;f.BackgroundTransparency=0.55;f.BorderSizePixel=0;f.LayoutOrder=LO(page);f.ZIndex=3 
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,7) 
        local rowStroke=Instance.new("UIStroke",f);rowStroke.Color=Color3.fromRGB(45,45,52);rowStroke.Thickness=0.7;rowStroke.Transparency=0 
        f.MouseEnter:Connect(function() TS:Create(f,TweenInfo.new(0.08),{BackgroundColor3=HOV,BackgroundTransparency=0.55}):Play() end) 
        f.MouseLeave:Connect(function() TS:Create(f,TweenInfo.new(0.08),{BackgroundColor3=CARD,BackgroundTransparency=0.55}):Play() end) 
        return f 
    end 
    local function mkLabel(row,txt) 
        local l=Instance.new("TextLabel",row);l.Size=UDim2.new(0.44,-4,1,0);l.Position=UDim2.new(0,8,0,0)
        l.BackgroundTransparency=1;l.Text=txt:upper();l.TextColor3=W;l.ZIndex=4
        l.Font=Enum.Font.SciFi;l.TextSize=8;l.TextScaled=false;l.TextTruncate=Enum.TextTruncate.AtEnd;l.TextXAlignment=Enum.TextXAlignment.Left
    end 
    local function mkPill(row,offset) 
        local pill=Instance.new("Frame",row);pill.Size=UDim2.new(0,32,0,17)
        pill.Position=UDim2.new(1,-(offset or 38),0.5,-8.5)
        pill.BackgroundColor3=OFF;pill.BorderSizePixel=0;pill.ZIndex=3 
        Instance.new("UICorner",pill).CornerRadius=UDim.new(1,0) 
        local dot=Instance.new("Frame",pill);dot.Size=UDim2.new(0,11,0,11);dot.Position=UDim2.new(0,3,0.5,-5.5)
        dot.BackgroundColor3=DIM;dot.BorderSizePixel=0;dot.ZIndex=4 
        Instance.new("UICorner",dot).CornerRadius=UDim.new(1,0) 
        return pill,dot 
    end 
    local function animPill(pill,dot,on) 
        TS:Create(pill,TweenInfo.new(0.18,Enum.EasingStyle.Quad),{BackgroundColor3=on and Color3.fromRGB(60,60,80) or OFF}):Play() 
        TS:Create(dot,TweenInfo.new(0.18,Enum.EasingStyle.Back),{ Position=on and UDim2.new(1,-14,0.5,-5.5) or UDim2.new(0,3,0.5,-5.5), BackgroundColor3=on and WHITE or DIM }):Play()
    end 
    local function mkToggle(page,txt,cb) 
        local row=mkRow(page,32);mkLabel(row,txt) 
        local pill,dot=mkPill(row,38) 
        local on=false 
        local function sv(s) on=s;animPill(pill,dot,s) end 
        local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5 
        clk.Activated:Connect(function() if _anyKeyListening then return end;on=not on;sv(on);cb(on) end) 
        pill.ZIndex=3;dot.ZIndex=4 
        return sv 
    end 
    local function mkBox(parent,default,w,xOff,cb) 
        local tb=Instance.new("TextBox",parent) 
        tb.Size=UDim2.new(0,math.min(w or 50,48),0,20);tb.Position=UDim2.new(1,-(xOff or 54),0.5,-10)
        tb.BackgroundColor3=INP;tb.BorderSizePixel=0;tb.Text=tostring(default);tb.TextColor3=W 
        tb.Font=Enum.Font.SciFi;tb.TextSize=10;tb.ClearTextOnFocus=false;tb.ZIndex=5 
        Instance.new("UICorner",tb).CornerRadius=UDim.new(0,5) 
        local bs=Instance.new("UIStroke",tb);bs.Color=Color3.fromRGB(30,30,38);bs.Thickness=1 
        tb.Focused:Connect(function() TS:Create(bs,TweenInfo.new(0.12),{Color=WHITEDIM}):Play() end) 
        tb.FocusLost:Connect(function() 
            TS:Create(bs,TweenInfo.new(0.12),{Color=Color3.fromRGB(30,30,38)}):Play() 
            if cb then local n=tonumber(tb.Text);if n then cb(n) else tb.Text=tostring(default) end end 
        end) 
        return tb 
    end 
    local function isGamepadInput(inp) return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad")~=nil end 
    local function isBindableInput(inp) 
        if not inp or inp.KeyCode==Enum.KeyCode.Unknown then return false end 
        if inp.UserInputType==Enum.UserInputType.Keyboard then return true end 
        return isGamepadInput(inp) 
    end 
    local function kbMatch(entry,kc) return kc and (kc==entry.kb) end 
    local keyRefs={} 
    local function keyLabel(entry) return (entry.kb and entry.kb.Name:upper()) or "NONE" end 
    local function refreshKeyRefs(entry) 
        for _,r in ipairs(keyRefs) do if r.entry==entry then r.btn.Text=keyLabel(entry) end end 
    end 
    local function mkKBButton(parent,kbEntry) 
        local btn=Instance.new("TextButton",parent) 
        btn.Size=UDim2.new(0,56,0,20);btn.Position=UDim2.new(1,-62,0.5,-10)
        btn.BackgroundColor3=INP;btn.BorderSizePixel=0 
        btn.Text=keyLabel(kbEntry);btn.TextColor3=W 
        btn.Font=Enum.Font.SciFi;btn.TextSize=9;btn.ZIndex=5 
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5) 
        table.insert(keyRefs,{entry=kbEntry,btn=btn}) 
        local listening=false 
        local conn=nil 
        local previous=btn.Text 
        local listenStart=0 
        local function stopListen(cancel) 
            listening=false _anyKeyListening=false 
            if conn then conn:Disconnect();conn=nil end 
            if cancel then btn.Text=previous else refreshKeyRefs(kbEntry) end 
            btn.TextColor3=W 
        end 
        btn.Activated:Connect(function() 
            if listening then stopListen(true);return end 
            previous=btn.Text 
            listening=true _anyKeyListening=true listenStart=tick() 
            btn.Text="..." btn.TextColor3=WHITE 
            conn=UIS.InputBegan:Connect(function(inp,gpe) 
                if not listening then return end 
                if inp.KeyCode==Enum.KeyCode.Escape then stopListen(true);return end 
                if inp.KeyCode==Enum.KeyCode.Unknown then return end 
                if inp.UserInputType~=Enum.UserInputType.Keyboard then return end 
                kbEntry.kb=inp.KeyCode 
                stopListen(false) 
                pcall(saveConfig) 
                pcall(function() if saveMobileButtonsConfigOnly then saveMobileButtonsConfigOnly() end end) 
            end) 
        end) 
        return btn 
    end 
    local function mkKeyRow(page,txt,kbEntry) 
        local row=mkRow(page,32);mkLabel(row,txt);mkKBButton(row,kbEntry) 
    end 
    local function mkModeRow(page) 
        local row=mkRow(page,32);mkLabel(row,"Mode") 
        modeValLbl=Instance.new("TextLabel",row) 
        modeValLbl.Size=UDim2.new(0,110,1,0);modeValLbl.Position=UDim2.new(1,-116,0,0) 
        modeValLbl.BackgroundTransparency=1;modeValLbl.Text="NORMAL";modeValLbl.TextColor3=WHITE 
        modeValLbl.Font=Enum.Font.SciFi;modeValLbl.TextSize=10;modeValLbl.TextXAlignment=Enum.TextXAlignment.Right 
        refreshSpeedModeLabel() 
    end 
    local function mkActionButton(page,labelTxt,btnTxt,cb) 
        local row=mkRow(page,32);mkLabel(row,labelTxt) 
        local btn=Instance.new("TextButton",row) 
        btn.Size=UDim2.new(0,56,0,20);btn.Position=UDim2.new(1,-62,0.5,-10)
        btn.BackgroundColor3=INP;btn.BorderSizePixel=0;btn.Text=btnTxt:upper();btn.TextColor3=WHITE 
        btn.Font=Enum.Font.SciFi;btn.TextSize=9;btn.ZIndex=5 
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6) 
        local bs=Instance.new("UIStroke",btn);bs.Color=STROKE;bs.Thickness=1 
        btn.MouseEnter:Connect(function() TS:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=HOV}):Play() end) 
        btn.MouseLeave:Connect(function() TS:Create(btn,TweenInfo.new(0.08),{BackgroundColor3=INP}):Play() end) 
        btn.Activated:Connect(cb) 
        return btn 
    end 
    mkSect(menuPage,"Speed Configuration") 
    do 
        local row=mkRow(menuPage,32);mkLabel(row,"Normal Speed");normalBox=mkBox(row,NS,55,62,function(v) if v>0 and v<=500 then NS=v end;saveConfig() end) 
    end 
    do 
        local row=mkRow(menuPage,32);mkLabel(row,"Carry Speed");carryBox=mkBox(row,CS,55,62,function(v) if v>0 and v<=500 then CS=v end;saveConfig() end) 
    end 
    mkModeRow(menuPage) 
    mkSect(menuPage,"Auto Speed") 
    setAutoSwitchSpeedVisual=mkToggle(menuPage,"Auto Switch Speed",function(on) autoSwitchSpeedEnabled=on;if on or autoTurnOffSpeedEnabled or autoSwitchLaggerSpeedEnabled then startAutoSwitchSpeed() else stopAutoSwitchSpeed() end;saveConfig() end) 
    setAutoSwitchLaggerSpeedVisual=mkToggle(menuPage,"Auto Switch Lagger Speed",function(on) autoSwitchLaggerSpeedEnabled=on;if on or autoSwitchSpeedEnabled or autoTurnOffSpeedEnabled then startAutoSwitchSpeed() else stopAutoSwitchSpeed() end;saveConfig() end) 
    setAutoTurnOffSpeedVisual=mkToggle(menuPage,"Auto Turn Off Speed",function(on) autoTurnOffSpeedEnabled=on;if on or autoSwitchSpeedEnabled or autoSwitchLaggerSpeedEnabled then startAutoSwitchSpeed() else stopAutoSwitchSpeed() end;saveConfig() end) 
    mkSect(menuPage,"Lagger Speed") 
    do 
        local row=mkRow(menuPage,32);mkLabel(row,"Lagger Normal Speed");laggerBox=mkBox(row,LAGGER_SPEED,55,62,function(v) if v>0 and v<=500 then LAGGER_SPEED=v end;saveConfig() end) 
    end 
    do 
        local row=mkRow(menuPage,32);mkLabel(row,"Lagger Carry Speed");laggerCarryBox=mkBox(row,LAGGER_CARRY_SPEED,55,62,function(v) if v>0 and v<=500 then LAGGER_CARRY_SPEED=v end;saveConfig() end) 
    end 
    mkSect(menuPage,"Drop")
    mkActionButton(menuPage,"Drop","DROP",function()
        runSelectedDrop()
    end)
    do
        local row=mkRow(menuPage,32)
        mkLabel(row,"Version")
        local refs={}
        local versions={{id="FLIGHT",txt="FLIGHT"},{id="JUMP",txt="JUMP"}}
        local function refreshDropVersionButtons()
            for _,r in ipairs(refs) do
                local active=(dropVersion==r.id)
                r.btn.BackgroundColor3=active and Color3.fromRGB(255,255,255) or INP
                r.btn.TextColor3=active and Color3.fromRGB(0,0,0) or WHITE
            end
            refreshDropMobileLabel()
        end
        _G.DeepRefreshDropVersionUI=refreshDropVersionButtons
        for i,v in ipairs(versions) do
            local btn=Instance.new("TextButton",row)
            btn.Size=UDim2.new(0,48,0,20)
            btn.Position=UDim2.new(1,-(6+(#versions-i+1)*52),0.5,-10)
            btn.BackgroundColor3=INP
            btn.BorderSizePixel=0
            btn.Text=v.txt
            btn.TextColor3=WHITE
            btn.Font=Enum.Font.SciFi
            btn.TextSize=8
            btn.ZIndex=5
            Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
            local st=Instance.new("UIStroke",btn);st.Color=STROKE;st.Thickness=1
            table.insert(refs,{id=v.id,btn=btn})
            btn.Activated:Connect(function()
                setDropVersion(v.id)
                refreshDropVersionButtons()
            end)
        end
        refreshDropVersionButtons()
    end
    mkSect(menuPage,"Jump") 
    setInfJumpVisual=mkToggle(menuPage,"Infinite Jump",function(on) infJumpEnabled=on;saveConfig() end) 
    setAntiRagVisual=mkToggle(menuPage,"Anti Ragdoll",function(on) antiRagdollEnabled=on;if on then startAntiRagdoll() else stopAntiRagdoll() end;saveConfig() end)
    _G.DeepRagdollTimerVisual=mkToggle(menuPage,"Ragdoll Timer",function(on)
        _G.DeepRagdollTimerEnabled=(on==true)
        if not _G.DeepRagdollTimerEnabled then
            pcall(_G.DeepClearRagdollTimer)
        else
            pcall(function()
                if LP.Character then _G.DeepStartRagdollTimerSystem(LP.Character) end
            end)
        end
        saveConfig()
    end)
    setUnwalkVisual=mkToggle(menuPage,"Unwalk",function(on) unwalkEnabled=on;if on then startUnwalk() else stopUnwalk() end;saveConfig() end)
    mkSect(menuPage,"ESP")
    do
        local row=mkRow(menuPage,32);mkLabel(row,"ESP")
        _G.DeepESP.expandBtn=Instance.new("TextButton",row)
        _G.DeepESP.expandBtn.Size=UDim2.new(0,20,0,17)
        _G.DeepESP.expandBtn.Position=UDim2.new(1,-64,0.5,-8.5)
        _G.DeepESP.expandBtn.BackgroundColor3=INP
        _G.DeepESP.expandBtn.BorderSizePixel=0
        _G.DeepESP.expandBtn.Text=_G.DeepESP.expanded and "-" or "+"
        _G.DeepESP.expandBtn.TextColor3=WHITE
        _G.DeepESP.expandBtn.Font=Enum.Font.SciFi
        _G.DeepESP.expandBtn.TextSize=14
        _G.DeepESP.expandBtn.ZIndex=5
        Instance.new("UICorner",_G.DeepESP.expandBtn).CornerRadius=UDim.new(0,5)
        local pill,dot=mkPill(row,38)
        _G.DeepESP.masterVisual=function(v) animPill(pill,dot,v==true) end
        _G.DeepESP.masterVisual(_G.DeepESP.enabled)
        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            _G.DeepESP.setEnabled(not _G.DeepESP.enabled)
            saveConfig()
        end)
    end
    do
        _G.DeepESP.lineRow=mkRow(menuPage,32);mkLabel(_G.DeepESP.lineRow,"LINE")
        local pill,dot=mkPill(_G.DeepESP.lineRow,42)
        _G.DeepESP.lineVisual=function(v) animPill(pill,dot,v==true) end
        _G.DeepESP.lineVisual(_G.DeepESP.line)
        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            _G.DeepESP.line=not _G.DeepESP.line
            _G.DeepESP.lineVisual(_G.DeepESP.line)
            if not _G.DeepESP.line then for _,e in pairs(_G.DeepESP.entries) do if e.line then e.line.Visible=false end end end
            saveConfig()
        end)
    end
    do
        _G.DeepESP.squareRow=mkRow(menuPage,32);mkLabel(_G.DeepESP.squareRow,"SQUARE")
        local pill,dot=mkPill(_G.DeepESP.squareRow,42)
        _G.DeepESP.squareVisual=function(v) animPill(pill,dot,v==true) end
        _G.DeepESP.squareVisual(_G.DeepESP.square)
        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            _G.DeepESP.square=not _G.DeepESP.square
            _G.DeepESP.squareVisual(_G.DeepESP.square)
            if not _G.DeepESP.square then for _,e in pairs(_G.DeepESP.entries) do if e.box then e.box.Visible=false end;if e.name then e.name.Visible=false end end end
            saveConfig()
        end)
    end
    _G.DeepESP.refreshExpanded=function()
        if _G.DeepESP.lineRow then _G.DeepESP.lineRow.Visible=_G.DeepESP.expanded end
        if _G.DeepESP.squareRow then _G.DeepESP.squareRow.Visible=_G.DeepESP.expanded end
        if _G.DeepESP.expandBtn then _G.DeepESP.expandBtn.Text=_G.DeepESP.expanded and "-" or "+" end
    end
    _G.DeepESP.expandBtn.Activated:Connect(function()
        _G.DeepESP.expanded=not _G.DeepESP.expanded
        _G.DeepESP.refreshExpanded()
        saveConfig()
    end)
    _G.DeepESP.refreshExpanded()

    mkSect(menuPage,"Song")
    _G.DeepSong.visuals.tuff=mkToggle(menuPage,"Song Tuff",function(on)
        if on then
            _G.DeepSong.play("tuff")
        elseif _G.DeepSong.active=="tuff" then
            _G.DeepSong.stop()
        end
    end)
    _G.DeepSong.visuals.beretta=mkToggle(menuPage,"Song Beretta",function(on)
        if on then
            _G.DeepSong.play("beretta")
        elseif _G.DeepSong.active=="beretta" then
            _G.DeepSong.stop()
        end
    end)
    _G.DeepSong.refreshVisuals()

    mkSect(lockPage,"Auto Grab Configuration")

    setInstaGrab=mkToggle(lockPage,"Auto Grab",function(on)
        Steal.AutoStealEnabled=on
        if on then
            local ok=pcall(startAutoSteal)
            if not ok then
                Steal.AutoStealEnabled=false
                if setInstaGrab then setInstaGrab(false) end
            end
        else
            stopAutoSteal()
        end
        saveConfig()
    end)

    do
        local row=mkRow(lockPage,32)
        mkLabel(row,"Steal Radius")
        radInput=mkBox(row,Steal.StealRadius,55,62,function(v)
            if v and v>=1 and v<=500 then
                Steal.StealRadius=v
            else
                radInput.Text=tostring(Steal.StealRadius)
            end
            saveConfig()
        end)
    end

    do
        local row=mkRow(lockPage,32)
        mkLabel(row,"Delay Radius")
        delayRadiusBox=mkBox(row,Steal.DelayRadius,55,62,function(v)
            if v and v>=1 and v<=40 then
                Steal.DelayRadius=v
            else
                delayRadiusBox.Text=tostring(Steal.DelayRadius)
            end
            saveConfig()
        end)
    end

    do
        local row=mkRow(lockPage,32)
        mkLabel(row,"Steal Duration")
        stealDurBox=mkBox(row,Steal.StealDuration,55,62,function(v)
            if v and v>=0.1 and v<=5 then
                Steal.StealDuration=v
            else
                stealDurBox.Text=tostring(Steal.StealDuration)
            end
            saveConfig()
        end)
    end

    do
        local row=mkRow(lockPage,32)
        mkLabel(row,"Stop Time (%)")
        stopTimeBox=mkBox(row,Steal.StopPercent,55,62,function(v)
            if v and v>=1 and v<=100 then
                Steal.StopPercent=v
            else
                stopTimeBox.Text=tostring(Steal.StopPercent)
            end
            saveConfig()
        end)
    end

    mkSect(lockPage,"Counter") 
    setMedusaVisual=mkToggle(lockPage,"Medusa Counter",function(on) medusaCounterEnabled=on;if on then setupMedusa(LP.Character) else stopMedusaCounter() end;saveConfig() end) 
    setBatCounterVisual=mkToggle(lockPage,"Bat Counter",function(on) batCounterEnabled=on;if on then startBatCounter() else stopBatCounter() end;saveConfig() end)
    mkSect(lockPage,"Body Lock") 
    setBodyLockVisual=mkToggle(lockPage,"Body Lock",function(on) setBodyLock(on) end) 
    do 
        local row=mkRow(lockPage,32);mkLabel(row,"Body Lock Radius");bodyLockRadiusBox=mkBox(row,bodyLockRadius,55,62,function(v) if v>=1 and v<=500 then bodyLockRadius=v else bodyLockRadiusBox.Text=tostring(bodyLockRadius) end;saveConfig() end) 
    end 
    mkSect(aimbotPage,"Aimbot")

    _G.DeepGreenAimbot.singleVisual=mkToggle(aimbotPage,"Aimbot",function(on)
        _G.DeepSetGreenAimbot(on)
    end)

    do
        local row=mkRow(aimbotPage,32)
        mkLabel(row,"Aimbot Version")

        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,100,0,22)
        btn.Position=UDim2.new(1,-106,0.5,-11)
        btn.BackgroundColor3=INP
        btn.BorderSizePixel=0
        btn.TextColor3=WHITE
        btn.Font=Enum.Font.SciFi
        btn.TextSize=8
        btn.ZIndex=5
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,6)
        local st=Instance.new("UIStroke",btn)
        st.Color=STROKE
        st.Thickness=1

        _G.DeepGreenAimbotVersionButton=btn
        btn.Text=_G.DeepGreenAimbot.version or "NORMAL"

        btn.Activated:Connect(function()
            local current=_G.DeepGreenAimbot.version or "NORMAL"
            _G.DeepSetGreenAimbotVersion(current=="NORMAL" and "BYPASS" or "NORMAL")
        end)
    end

    do
        local row=mkRow(aimbotPage,32);mkLabel(row,"Normal Speed")
        local box
        box=mkBox(row,_G.DeepGreenAimbot.normalSpeed,55,62,function(v)
            if not _G.DeepSetGreenAimbotSpeed("NORMAL",v) then
                box.Text=tostring(_G.DeepGreenAimbot.normalSpeed)
            end
        end)
        _G.DeepGreenAimbot.normalSpeedBox=box
        box:GetPropertyChangedSignal("Text"):Connect(function()
            if not box:IsFocused() then return end
            local v=tonumber(box.Text)
            if v and v>=1 and v<=500 then
                _G.DeepSetGreenAimbotSpeed("NORMAL",v,true)
            end
        end)
    end

    do
        local row=mkRow(aimbotPage,32);mkLabel(row,"Bypass Speed")
        local box
        box=mkBox(row,_G.DeepGreenAimbot.bypassSpeed,55,62,function(v)
            if not _G.DeepSetGreenAimbotSpeed("BYPASS",v) then
                box.Text=tostring(_G.DeepGreenAimbot.bypassSpeed)
            end
        end)
        _G.DeepGreenAimbot.bypassSpeedBox=box
        box:GetPropertyChangedSignal("Text"):Connect(function()
            if not box:IsFocused() then return end
            local v=tonumber(box.Text)
            if v and v>=1 and v<=500 then
                _G.DeepSetGreenAimbotSpeed("BYPASS",v,true)
            end
        end)
    end

    mkSect(aimbotPage,"Bat Aimbot") 
    do 
        local row=mkRow(aimbotPage,32);mkLabel(row,"Bat Aimbot") 
        local pill,dot=mkPill(row,38) 
        local abOn=false 
        local function svAutoBat(s) abOn=s;animPill(pill,dot,s) end 
        autoBatSetVisual=svAutoBat 
        local clk=Instance.new("TextButton",pill);clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5 
        clk.Activated:Connect(function() if _anyKeyListening then return end;abOn=not abOn;svAutoBat(abOn);if abOn then queueAutoBatStart() else autoBatEnabled=false;disableAutoBat() end;saveConfig() end) 
    end 
    do
        local row=mkRow(aimbotPage,32);mkLabel(row,"Bat Aimbot Speed");autoBatSpeedBox=mkBox(row,AUTO_BAT_SPEED,55,62,function(v) if v and v>0 and v<=500 then AUTO_BAT_SPEED=v else autoBatSpeedBox.Text=tostring(AUTO_BAT_SPEED) end;saveConfig() end)
    end

    do
        local row=mkRow(aimbotPage,32);mkLabel(row,"Bat V2")
        local pill,dot=mkPill(row,38)
        local batV2On=_G.DeepBatV2ManualEnabled==true
        local function svBatV2(s)
            batV2On=(s==true)
            animPill(pill,dot,batV2On)
        end
        setAimbot2Visual=svBatV2
        svBatV2(batV2On)

        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0)
        clk.BackgroundTransparency=1
        clk.Text=""
        clk.ZIndex=5
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            setAimbot2(not _G.DeepBatV2ManualEnabled)
        end)
    end

    do
        local row=mkRow(aimbotPage,32)
        local label=Instance.new("TextLabel",row)
        label.Size=UDim2.new(0.62,0,1,0);label.Position=UDim2.new(0,9,0,0)
        label.BackgroundTransparency=1
        label.Text=(tpAimbotMode=="v2") and "TP AIMBOT V2" or "TP AIMBOT V1"
        label.TextColor3=W;label.ZIndex=4
        label.Font=Enum.Font.SciFi;label.TextSize=10;label.TextXAlignment=Enum.TextXAlignment.Left
        _G.DeepTPAimbotMenuLabel=label

        local pill,dot=mkPill(row,38)
        local on=false
        local function sv(s) on=s;animPill(pill,dot,s) end
        setTPAimbotVisual=sv
        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0);clk.BackgroundTransparency=1;clk.Text="";clk.ZIndex=5
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            setTPAimbot(not tpAimbotEnabled)
            sv(tpAimbotEnabled)
        end)
        if _G.DeepRefreshTPAimbotLabels then pcall(_G.DeepRefreshTPAimbotLabels) end
    end
    do
        local row=mkRow(aimbotPage,32);mkLabel(row,"TP Aimbot Mode")
        local refs={}
        local modes={{id="v1",txt="V1"},{id="v2",txt="V2"}}

        local function refreshTPMode()
            for _,r in ipairs(refs) do
                local active=(tpAimbotMode==r.id)
                r.btn.BackgroundColor3=active and Color3.fromRGB(255,255,255) or INP
                r.btn.TextColor3=active and Color3.fromRGB(0,0,0) or WHITE
            end
            if _G.DeepRefreshTPAimbotLabels then pcall(_G.DeepRefreshTPAimbotLabels) end
        end
        _G.DeepRefreshTPAimbotMode=refreshTPMode

        for i,m in ipairs(modes) do
            local btn=Instance.new("TextButton",row)
            btn.Size=UDim2.new(0,58,0,22)
            btn.Position=UDim2.new(1,-(122-(i-1)*62),0.5,-11)
            btn.BackgroundColor3=INP
            btn.BorderSizePixel=0
            btn.Text=m.txt
            btn.TextColor3=WHITE
            btn.Font=Enum.Font.SciFi
            btn.TextSize=9
            btn.ZIndex=5
            local cr=Instance.new("UICorner",btn);cr.CornerRadius=UDim.new(0,6)
            local st=Instance.new("UIStroke",btn);st.Color=STROKE;st.Thickness=1
            refs[#refs+1]={id=m.id,btn=btn}
            btn.Activated:Connect(function()
                setTPAimbotMode(m.id)
                refreshTPMode()
            end)
        end
        refreshTPMode()
    end

    setSpaceTpAntiDieVisual=mkToggle(aimbotPage,"Anti Die",function(on)
        _G.DeepSpaceSetAntiDie(on)
    end)
    if setSpaceTpAntiDieVisual then
        setSpaceTpAntiDieVisual(spaceTpAntiDieEnabled)
    end

    setAutoSwingVisual=mkToggle(aimbotPage,"Auto Swing",function(on) autoSwingEnabled=on;saveConfig() end) 
    if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end 
    mkSect(aimbotPage,"Anti Bat")
    do
        local row=mkRow(aimbotPage,32)
        mkLabel(row,"Anti Bat")

        _G.DeepAntiBat.expandBtn=Instance.new("TextButton",row)
        _G.DeepAntiBat.expandBtn.Size=UDim2.new(0,20,0,17)
        _G.DeepAntiBat.expandBtn.Position=UDim2.new(1,-64,0.5,-8.5)
        _G.DeepAntiBat.expandBtn.BackgroundColor3=INP
        _G.DeepAntiBat.expandBtn.BorderSizePixel=0
        _G.DeepAntiBat.expandBtn.Text=_G.DeepAntiBat.expanded and "-" or "+"
        _G.DeepAntiBat.expandBtn.TextColor3=WHITE
        _G.DeepAntiBat.expandBtn.Font=Enum.Font.SciFi
        _G.DeepAntiBat.expandBtn.TextSize=14
        _G.DeepAntiBat.expandBtn.ZIndex=5
        Instance.new("UICorner",_G.DeepAntiBat.expandBtn).CornerRadius=UDim.new(0,5)

        local pill,dot=mkPill(row,38)
        set404AntiBatVisual=function(v)
            animPill(pill,dot,v==true)
        end
        set404AntiBatVisual(_G.DeepAntiBat.enabled==true)

        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0)
        clk.BackgroundTransparency=1
        clk.Text=""
        clk.ZIndex=5
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            _G.DeepAntiBat.setMaster(not _G.DeepAntiBat.enabled)
            saveConfig()
        end)
    end

    do
        _G.DeepAntiBat.ui.v1Row=mkRow(aimbotPage,32)
        mkLabel(_G.DeepAntiBat.ui.v1Row,"Anti Bat V1")
        local pill,dot=mkPill(_G.DeepAntiBat.ui.v1Row,42)
        _G.DeepAntiBat.ui.v1Visual=function(v) animPill(pill,dot,v==true) end
        _G.DeepAntiBat.ui.v1Visual(_G.DeepAntiBat.v1==true)

        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0)
        clk.BackgroundTransparency=1
        clk.Text=""
        clk.ZIndex=5
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            _G.DeepAntiBat.setV1(not _G.DeepAntiBat.v1)
            saveConfig()
        end)
    end

    do
        _G.DeepAntiBat.ui.v2Row=mkRow(aimbotPage,32)
        mkLabel(_G.DeepAntiBat.ui.v2Row,"Anti Bat V2")
        local pill,dot=mkPill(_G.DeepAntiBat.ui.v2Row,42)
        _G.DeepAntiBat.ui.v2Visual=function(v) animPill(pill,dot,v==true) end
        _G.DeepAntiBat.ui.v2Visual(_G.DeepAntiBat.v2==true)

        local clk=Instance.new("TextButton",pill)
        clk.Size=UDim2.new(1,0,1,0)
        clk.BackgroundTransparency=1
        clk.Text=""
        clk.ZIndex=5
        clk.Activated:Connect(function()
            if _anyKeyListening then return end
            _G.DeepAntiBat.setV2(not _G.DeepAntiBat.v2)
            saveConfig()
        end)
    end

    _G.DeepAntiBat.refreshExpanded=function()
        if _G.DeepAntiBat.ui.v1Row then
            _G.DeepAntiBat.ui.v1Row.Visible=_G.DeepAntiBat.expanded==true
        end
        if _G.DeepAntiBat.ui.v2Row then
            _G.DeepAntiBat.ui.v2Row.Visible=_G.DeepAntiBat.expanded==true
        end
        if _G.DeepAntiBat.expandBtn then
            _G.DeepAntiBat.expandBtn.Text=_G.DeepAntiBat.expanded and "-" or "+"
        end
    end

    _G.DeepAntiBat.expandBtn.Activated:Connect(function()
        _G.DeepAntiBat.expanded=not _G.DeepAntiBat.expanded
        _G.DeepAntiBat.refreshExpanded()
        saveConfig()
    end)

    _G.DeepAntiBat.refreshExpanded()
    _G.DeepAntiBat.refreshRuntime()
    mkSect(aimbotPage,"Auto Path") 
    autoLeftSetVisual=mkToggle(aimbotPage,"Auto Left",function(on) autoLeftEnabled=on;if on then queueAutoLeftStart() else stopAutoLeft() end;saveConfig() end) 
    autoRightSetVisual=mkToggle(aimbotPage,"Auto Right",function(on) autoRightEnabled=on;if on then queueAutoRightStart() else stopAutoRight() end;saveConfig() end) 
    mkSect(configPage,"Bypass")
    _G.ExeBypassVisual=mkToggle(configPage,"Bypass",function(on)
        _G.ExeSetBypass(on)
    end)
    do
        local row=mkRow(configPage,32);mkLabel(row,"Power")
        _G.ExeBypassPowerBox=mkBox(row,_G.ExeBypass.power,55,72,function(v)
            _G.ExeSetBypassPower(v)
        end)
    end
    _G.ExeAutoBrainrotVisual=mkToggle(configPage,"Auto Brainrot",function(on)
        _G.ExeSetAutoBrainrot(on)
    end)

    mkSect(configPage,"Mobile Button Shape") 
    do 
        local row=mkRow(configPage,34);mkLabel(row,"Shape") 
        local shapeRefs={} 
        local shapes={ 
            {id="circle",txt="CIRCLE"}, 
            {id="squarcle",txt="ROUNDED"}, 
            {id="straight",txt="SQUARE"}, 
        } 
        local function refreshShape(sel) 
            for _,r in ipairs(shapeRefs) do 
                local active=r.id==sel 
                r.btn.BackgroundColor3=active and Color3.fromRGB(255,255,255) or INP 
                r.btn.TextColor3=active and Color3.fromRGB(0,0,0) or WHITE 
            end 
        end 
        for i,s in ipairs(shapes) do 
            local sb=Instance.new("TextButton",row) 
            sb.Size=UDim2.new(0,62,0,22);sb.Position=UDim2.new(1,-(i*65+2),0.5,-11) 
            sb.BackgroundColor3=(mobileButtonShape==s.id) and Color3.fromRGB(255,255,255) or INP 
            sb.BorderSizePixel=0;sb.Text=s.txt;sb.TextColor3=(mobileButtonShape==s.id) and Color3.fromRGB(0,0,0) or WHITE 
            sb.Font=Enum.Font.SciFi;sb.TextSize=7;sb.TextXAlignment=Enum.TextXAlignment.Center;sb.TextYAlignment=Enum.TextYAlignment.Center;sb.ZIndex=5 
            Instance.new("UICorner",sb).CornerRadius=UDim.new(0,6) 
            local bs=Instance.new("UIStroke",sb);bs.Color=STROKE;bs.Thickness=1 
            table.insert(shapeRefs,{btn=sb,id=s.id}) 
            sb.Activated:Connect(function() 
                mobileButtonShape=s.id 
                refreshShape(s.id) 
                buildMobileButtons() 
                saveConfig() 
                saveMobileButtonsConfigOnly() 
            end) 
        end 
    end 

    mkSect(configPage,"Anti Drop") 
    do 
        set404AntiDropVisual=mkToggle(configPage,"Anti Drop",function(on) 
            antiDrop404Enabled=on 
            antiDie404Enabled=on 
            antiBat404Enabled=on 
            infJumpEnabled=on 
            if on then 
                start404AntiDrop() 
                start404AntiDie() 
                start404AntiBat()
                pcall(function() _G.DeepSetAntiDropTag(true) end)
            else 
                stop404AntiDrop() 
                stop404AntiDie() 
                stop404AntiBat()
                pcall(function() _G.DeepSetAntiDropTag(false) end)
            end 
            if setInfJumpVisual then setInfJumpVisual(on) end 
            if set404AntiBatVisual then set404AntiBatVisual(on) end
            saveConfig() 
        end) 
        if set404AntiDropVisual then set404AntiDropVisual(antiDrop404Enabled) end 
    end

    -- E01 fica diretamente abaixo do Anti Drop.
    _G.DeepE01Visual=mkToggle(configPage,"E01",function(on)
        if _G.DeepSetE01 then
            _G.DeepSetE01(on)
            saveConfig()
        end
    end)

    mkSect(configPage,"Visual") 
    setAntiLagVisual=mkToggle(configPage,"Anti Lag",function(on) if on then enableAntiLag() else disableAntiLag() end;saveConfig() end) 
    setFpsBoostVisual=mkToggle(configPage,"FPS Boost",function(on) fpsBoostEnabled=on;if on then applyFPSBoost() end;saveConfig() end) 
    setStretchRezVisual=mkToggle(configPage,"Stretch Rez",function(on) if on then enableStretchRez() else disableStretchRez() end;saveConfig() end) 
    -- Camera/FOV controls removed from Settings.
    mkActionButton(configPage,"Reset Buttons","Reset",function() resetMobileButtonPositions() end) 
    do 
        local row=mkRow(configPage,32);mkLabel(row,"Btn Scale") 
        local sizes={60,75,100,125,150} 
        local bw=30 
        local startX=-6-(#sizes*(bw+3)) 
        local refs={} 
        local function refresh(sel) 
            for _,r in ipairs(refs) do 
                local a=r.sz==sel 
                r.btn.BackgroundColor3=a and Color3.fromRGB(60,60,80) or INP 
                r.btn.TextColor3=a and WHITE or W 
            end 
        end 
        for i,sz in ipairs(sizes) do 
            local sb=Instance.new("TextButton",row) 
            sb.Size=UDim2.new(0,bw,0,20);sb.Position=UDim2.new(1,startX+(i-1)*(bw+3),0.5,-10) 
            sb.BackgroundColor3=(mobileButtonsSize==sz) and Color3.fromRGB(60,60,80) or INP;sb.BorderSizePixel=0 
            sb.Text=tostring(sz);sb.TextColor3=(mobileButtonsSize==sz) and WHITE or W;sb.Font=Enum.Font.SciFi;sb.TextSize=8;sb.ZIndex=5 
            Instance.new("UICorner",sb).CornerRadius=UDim.new(0,5);local st=Instance.new("UIStroke",sb);st.Color=STROKE;st.Thickness=1 
            table.insert(refs,{btn=sb,sz=sz}) 
            sb.Activated:Connect(function() mobileButtonsSize=sz;refresh(sz);buildMobileButtons();pcall(saveConfig);saveMobileButtonsConfigOnly() end) 
        end 
    end 
    mkSect(configPage,"Artwork")
    do
        local row=mkRow(configPage,32);mkLabel(row,"Hub Art")
        local refs={}
        local names={{1,"1"},{2,"2"},{3,"3"},{4,"4"},{5,"5"}}
        local function refresh(sel)
            for _,r in ipairs(refs) do
                local active=(r.id==sel)
                r.btn.BackgroundColor3=active and Color3.fromRGB(60,60,80) or INP
                r.btn.TextColor3=active and WHITE or W
            end
        end
        for i,info in ipairs(names) do
            local id,label=info[1],info[2]
            local btn=Instance.new("TextButton",row)
            btn.Size=UDim2.new(0,28,0,20)
            btn.Position=UDim2.new(1,-(154-(i-1)*31),0.5,-10)
            btn.BackgroundColor3=(hubImageChoice==id) and Color3.fromRGB(60,60,80) or INP;btn.BorderSizePixel=0
            btn.Text=label;btn.TextColor3=(hubImageChoice==id) and WHITE or W;btn.Font=Enum.Font.SciFi;btn.TextSize=8;btn.ZIndex=5
            Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5)
            local st=Instance.new("UIStroke",btn);st.Color=STROKE;st.Thickness=1
            table.insert(refs,{btn=btn,id=id})
            btn.Activated:Connect(function()
                hubImageChoice=id
                refresh(id)
                applyHubArtNow()
                saveConfig()
                saveMobileButtonsConfigOnly()
            end)
        end
    end
    do
        local row=mkRow(configPage,32);mkLabel(row,"Btn Art")
        local refs={}
        local names={{1,"1"},{2,"2"},{3,"3"},{4,"4"},{5,"5"}}
        local function refresh(sel)
            for _,r in ipairs(refs) do
                local active=(r.id==sel)
                r.btn.BackgroundColor3=active and Color3.fromRGB(60,60,80) or INP
                r.btn.TextColor3=active and WHITE or W
            end
        end
        for i,info in ipairs(names) do
            local id,label=info[1],info[2]
            local btn=Instance.new("TextButton",row)
            btn.Size=UDim2.new(0,28,0,20)
            btn.Position=UDim2.new(1,-(154-(i-1)*31),0.5,-10)
            btn.BackgroundColor3=(buttonImageChoice==id) and Color3.fromRGB(60,60,80) or INP;btn.BorderSizePixel=0
            btn.Text=label;btn.TextColor3=(buttonImageChoice==id) and WHITE or W;btn.Font=Enum.Font.SciFi;btn.TextSize=8;btn.ZIndex=5
            Instance.new("UICorner",btn).CornerRadius=UDim.new(0,5)
            local st=Instance.new("UIStroke",btn);st.Color=STROKE;st.Thickness=1
            table.insert(refs,{btn=btn,id=id})
            btn.Activated:Connect(function()
                buttonImageChoice=id
                refresh(id)
                buildMobileButtons()
                saveConfig()
                saveMobileButtonsConfigOnly()
            end)
        end
    end

    mkSect(configPage,"Skins")
    do
        local S=_G.DeepSkins

        S.ui.bat=mkToggle(configPage,"Bat Skin",function(on)
            S.setKatana(on)
            saveConfig()
        end)
        if S.ui.bat then S.ui.bat(S.katanaEnabled) end

        S.ui.mc=mkToggle(configPage,"Minecraft Bat",function(on)
            S.setMinecraft(on)
            saveConfig()
        end)
        if S.ui.mc then S.ui.mc(S.minecraftEnabled) end

        local function makeSkinSelector(label,values,getIndex,onSelect)
            local row=mkRow(configPage,32)
            mkLabel(row,label)

            local left=Instance.new("TextButton",row)
            left.Size=UDim2.new(0,22,0,20)
            left.Position=UDim2.new(1,-150,0.5,-10)
            left.BackgroundColor3=INP
            left.BorderSizePixel=0
            left.Text="<"
            left.TextColor3=WHITE
            left.Font=Enum.Font.SciFi
            left.TextSize=10
            left.ZIndex=5
            Instance.new("UICorner",left).CornerRadius=UDim.new(0,5)
            local ls=Instance.new("UIStroke",left);ls.Color=STROKE;ls.Thickness=1

            local value=Instance.new("TextLabel",row)
            value.Size=UDim2.new(0,98,0,20)
            value.Position=UDim2.new(1,-125,0.5,-10)
            value.BackgroundColor3=INP
            value.BorderSizePixel=0
            value.TextColor3=WHITE
            value.Font=Enum.Font.SciFi
            value.TextSize=7
            value.TextTruncate=Enum.TextTruncate.AtEnd
            value.ZIndex=5
            Instance.new("UICorner",value).CornerRadius=UDim.new(0,5)
            local vs=Instance.new("UIStroke",value);vs.Color=STROKE;vs.Thickness=1

            local right=Instance.new("TextButton",row)
            right.Size=UDim2.new(0,22,0,20)
            right.Position=UDim2.new(1,-24,0.5,-10)
            right.BackgroundColor3=INP
            right.BorderSizePixel=0
            right.Text=">"
            right.TextColor3=WHITE
            right.Font=Enum.Font.SciFi
            right.TextSize=10
            right.ZIndex=5
            Instance.new("UICorner",right).CornerRadius=UDim.new(0,5)
            local rs=Instance.new("UIStroke",right);rs.Color=STROKE;rs.Thickness=1

            local function refresh()
                local idx=math.clamp(tonumber(getIndex()) or 1,1,#values)
                value.Text=tostring(values[idx] or "")
            end

            local function move(delta)
                local idx=tonumber(getIndex()) or 1
                idx=idx+delta
                if idx<1 then idx=#values end
                if idx>#values then idx=1 end
                onSelect(idx,values[idx])
                refresh()
                saveConfig()
            end

            left.Activated:Connect(function() move(-1) end)
            right.Activated:Connect(function() move(1) end)
            refresh()
            return refresh
        end

        S.ui.mcColorRefresh=makeSkinSelector("MC Bat Color",S.minecraftColorList,function()
            for i,v in ipairs(S.minecraftColorList) do if v==S.minecraftColor then return i end end
            return 1
        end,function(_,value)
            S.setMinecraftColor(value)
        end)

        S.ui.animRefresh=makeSkinSelector("Anim Pack",S.animList,function()
            for i,v in ipairs(S.animList) do if v==S.animPack then return i end end
            return 1
        end,function(_,value)
            S.setAnimPack(value)
        end)

        local outfitNames={}
        for i,v in ipairs(S.outfits) do outfitNames[i]=v.label end
        S.ui.outfitRefresh=makeSkinSelector("Outfit",outfitNames,function()
            return S.outfitIndex
        end,function(idx)
            S.applyOutfit(idx)
        end)

        local bgNames={}
        for i,v in ipairs(S.backgrounds) do bgNames[i]=v.label end
        S.ui.backgroundRefresh=makeSkinSelector("Background",bgNames,function()
            return S.backgroundIndex
        end,function(idx)
            S.applyBackground(idx)
        end)
    end

    mkSect(configPage,"Interface") 
    setLockVisual=mkToggle(configPage,"Lock UI",function(on) 
        uiLocked=on 
        if uiLocked and mobileMovingMode then 
            mobileMovingMode=false 
            if setMobileMovingModeVisual then setMobileMovingModeVisual(false) end 
        end
        if mobContainerRef then
            mobContainerRef.Active=(not uiLocked and not mobileMovingMode)
        end
        saveConfig() 
    end) 
    if setLockVisual then setLockVisual(uiLocked) end 
    setMobileMovingModeVisual=mkToggle(configPage,"Edit Buttons",function(on) 
        if on and uiLocked then 
            mobileMovingMode=false
            if mobContainerRef then mobContainerRef.Active=false end
            if setMobileMovingModeVisual then setMobileMovingModeVisual(false) end 
            return 
        end 
        mobileMovingMode=(on==true)
        if mobContainerRef then
            mobContainerRef.Active=(not uiLocked and not mobileMovingMode)
        end
        saveMobileButtonsConfigOnly() 
        saveConfig() 
    end) 
    if setMobileMovingModeVisual then setMobileMovingModeVisual(mobileMovingMode and not uiLocked) end
    _G.DeepBuildAutoGrabScaleControl(configPage,mkRow,mkLabel,INP,WHITE,W,STROKE)
    do
        local row=mkRow(configPage,32);mkLabel(row,"UI Scale") 
        local UI_SCALES={75,90,100,110,125,150} 
        local uiBtnW=28 
        local uiStartX=-6-(#UI_SCALES*(uiBtnW+2)) 
        local refs={} 
        local function refreshBtns(selected) 
            for _,ref in ipairs(refs) do 
                local active=ref.sz==selected 
                ref.btn.BackgroundColor3=active and Color3.fromRGB(60,60,80) or INP 
                ref.btn.TextColor3=active and WHITE or W 
            end 
        end 
        local selected=math.floor((uiScale*100)+0.5) 
        for i,sz in ipairs(UI_SCALES) do 
            local sb=Instance.new("TextButton",row) 
            sb.Size=UDim2.new(0,uiBtnW,0,20);sb.Position=UDim2.new(1,uiStartX+(i-1)*(uiBtnW+2),0.5,-10) 
            sb.BackgroundColor3=(selected==sz) and Color3.fromRGB(60,60,80) or INP;sb.BorderSizePixel=0 
            sb.Text=tostring(sz);sb.TextColor3=(selected==sz) and WHITE or W;sb.Font=Enum.Font.SciFi;sb.TextSize=8;sb.ZIndex=5 
            Instance.new("UICorner",sb).CornerRadius=UDim.new(0,5) 
            local bs=Instance.new("UIStroke",sb);bs.Color=STROKE;bs.Thickness=1 
            table.insert(refs,{btn=sb,sz=sz}) 
            sb.Activated:Connect(function() uiScale=sz/100;scaleObj.Scale=uiScale;refreshBtns(sz);saveConfig() end) 
        end 
    end 
    mkSect(configPage,"Configuration")
    do
        local row=mkRow(configPage,48);mkLabel(row,"Save Config")
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,130,0,32);btn.Position=UDim2.new(1,-138,0.5,-16)
        btn.BackgroundColor3=INP;btn.BorderSizePixel=0;btn.Text="SAVE CONFIG";btn.TextColor3=WHITE
        btn.Font=Enum.Font.SciFi;btn.TextSize=10;btn.ZIndex=5
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)
        local st=Instance.new("UIStroke",btn);st.Color=STROKE;st.Thickness=1
        btn.Activated:Connect(function()
            configPersistenceEnabled=true
            pcall(saveConfig)
            pcall(saveMobileButtonsConfigOnly)
            btn.Text="SAVED!"
            task.delay(0.9,function() if btn and btn.Parent then btn.Text="SAVE CONFIG" end end)
        end)
    end
    do
        local row=mkRow(configPage,48);mkLabel(row,"Delete Settings")
        local btn=Instance.new("TextButton",row)
        btn.Size=UDim2.new(0,130,0,32);btn.Position=UDim2.new(1,-138,0.5,-16)
        btn.BackgroundColor3=INP;btn.BorderSizePixel=0;btn.Text="DELETE SETTINGS";btn.TextColor3=WHITE
        btn.Font=Enum.Font.SciFi;btn.TextSize=10;btn.ZIndex=5
        Instance.new("UICorner",btn).CornerRadius=UDim.new(0,7)
        local st=Instance.new("UIStroke",btn);st.Color=STROKE;st.Thickness=1
        btn.Activated:Connect(function()
            deleteSavedConfig()
            btn.Text="DELETED!"
            task.delay(0.9,function() if btn and btn.Parent then btn.Text="DELETE SETTINGS" end end)
        end)
    end

    UIS.InputBegan:Connect(function(input,gpe) 
        if _anyKeyListening then return end 
        if input.UserInputType==Enum.UserInputType.Keyboard then 
            if gpe or UIS:GetFocusedTextBox() then return end 
        elseif not isGamepadInput(input) then return end 
        if not isBindableInput(input) then return end 
        local kc=input.KeyCode 
        if kbMatch(KB.LaggerToggle,kc) then toggleLaggerMode();saveConfig() 
        elseif kbMatch(KB.SpeedToggle,kc) then toggleCarryMode();saveConfig() 
        elseif kbMatch(KB.DropBrainrot,kc) then runSelectedDrop() 
        elseif kbMatch(KB.TPFloor,kc) then runTPFloor() 
        elseif kbMatch(KB.AutoLeft,kc) then 
            autoLeftEnabled=not autoLeftEnabled 
            if autoLeftEnabled then queueAutoLeftStart() else stopAutoLeft() end 
            if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end 
            saveConfig() 
        elseif kbMatch(KB.AutoRight,kc) then 
            autoRightEnabled=not autoRightEnabled 
            if autoRightEnabled then queueAutoRightStart() else stopAutoRight() end 
            if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end 
            saveConfig() 
        elseif kbMatch(KB.AutoBat,kc) then 
            if autoBatEnabled then 
                autoBatEnabled=false;disableAutoBat() 
                if autoBatSetVisual then autoBatSetVisual(false) end 
                if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(false) end 
            else 
                queueAutoBatStart() 
                if autoBatSetVisual then autoBatSetVisual(autoBatEnabled) end 
                if mobBtnRefs and mobBtnRefs.autoBat then mobBtnRefs.autoBat(autoBatEnabled) end 
            end 
            saveConfig() 
        elseif kbMatch(KB.GuiHide,kc) then 
            if main.Visible then hideGui() else showGui() end 
        end 
    end) 
    selectPage("menu") 
end 

-- ============================================================ 
-- STEAL BAR – CLASSIC FPS STYLE (PINALAKI) 
-- ============================================================ 
local StealBarGui = Instance.new("ScreenGui") 
StealBarGui.Name = "TargetStealBar" 
StealBarGui.IgnoreGuiInset = true 
StealBarGui.ResetOnSpawn = false 
StealBarGui.DisplayOrder = 999 
StealBarGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling 
StealBarGui.Parent = LP:WaitForChild("PlayerGui") 

stealBarContainer = Instance.new("Frame", StealBarGui) 
stealBarContainer.Name = "StealBarContainer" 
stealBarContainer.Size = UDim2.new(0, 320, 0, 42) 
stealBarContainer.Position = UDim2.new(0.5, -160, 0, 100) 
stealBarContainer.BackgroundTransparency = 1
stealBarContainer.ZIndex = 10

_G.DeepAutoGrabScaleObj = Instance.new("UIScale", stealBarContainer)
_G.DeepAutoGrabScaleObj.Name = "AutoGrabScale"
_G.DeepAutoGrabScaleObj.Scale = _G.DeepAutoGrabScale or 1

local main = Instance.new("Frame", stealBarContainer) 
main.Size = UDim2.new(1, 0, 1, 0) 
main.Position = UDim2.new(0, 0, 0, 0) 
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0) 
main.BackgroundTransparency = 0 
main.BorderSizePixel = 0 
main.ZIndex = 2 
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12) 

local border = Instance.new("UIStroke", main) 
border.Color = Color3.fromRGB(255, 255, 255) 
border.Thickness = 1.5 
border.Transparency = 0.3 
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border 

local progressFill = Instance.new("Frame", main) 
progressFill.Name = "ProgressFill" 
progressFill.Size = UDim2.new(0, 0, 1, 0) 
progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255) 
progressFill.BackgroundTransparency = 0 
progressFill.BorderSizePixel = 0 
progressFill.ZIndex = 3 
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 12) 

local label = Instance.new("TextLabel", main) 
label.Name = "Label" 
label.Size = UDim2.new(1, -16, 1, 0) 
label.Position = UDim2.new(0, 8, 0, 0) 
label.BackgroundTransparency = 1 
label.Text = "STEALING 0%" 
label.TextColor3 = Color3.fromRGB(255, 255, 255) 
label.TextSize = 16 
label.Font = Enum.Font.SciFi 
label.TextXAlignment = Enum.TextXAlignment.Left 
label.TextStrokeTransparency = 0.7 
label.ZIndex = 4 

local _lastPct = 0 
local _visualSpeed = 0.35
local _fps = 0
local _fpsFrames = 0
local _fpsClock = tick()
local _ping = 0
local StatsService = game:GetService("Stats")

RunService.RenderStepped:Connect(function(dt) 
    local target = 0
    if _G.DeepMayStealProgress~=nil then
        target=math.clamp(tonumber(_G.DeepMayStealProgress) or 0,0,1)
    elseif isStealing and stealStartTime then
        target = math.clamp((tick() - stealStartTime) / math.max(Steal.StealDuration, 0.01), 0, 1)
    end 
    _lastPct = _lastPct + (target - _lastPct) * math.min(dt * _visualSpeed * 60, 1) 
    local f = math.clamp(_lastPct, 0, 1)

    _fpsFrames = _fpsFrames + 1
    local now = tick()
    if now - _fpsClock >= 0.5 then
        _fps = math.floor((_fpsFrames / (now - _fpsClock)) + 0.5)
        _fpsFrames = 0
        _fpsClock = now
        pcall(function()
            local pingText = StatsService.Network.ServerStatsItem["Data Ping"]:GetValueString()
            _ping = tonumber(string.match(pingText, "[%d%.]+")) or _ping
        end)
    end

    if progressFill then progressFill.Size = UDim2.new(f, 0, 1, 0) end 
    if label then
        label.Text = string.format("STEALING %d%%   |   FPS %d   |   PING %d ms", math.floor(f * 100), _fps, math.floor(_ping + 0.5))
    end
end) 

local dragging, dragStart, startPos = false 
stealBarContainer.Active = true
stealBarContainer.InputBegan:Connect(function(inp) 
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        -- Barra STEAL (vermelho): só pode mover quando Edit Buttons estiver ativo.
        if uiLocked or not mobileMovingMode then return end
        dragging = true 
        dragStart = inp.Position 
        startPos = stealBarContainer.Position 
        inp.Changed:Connect(function() 
            if inp.UserInputState == Enum.UserInputState.End then dragging = false end 
        end) 
    end 
end) 
UIS.InputChanged:Connect(function(inp) 
    if not dragging then return end 
    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then 
        local delta = inp.Position - dragStart 
        local cam = workspace.CurrentCamera 
        local vp = cam and cam.ViewportSize or Vector2.new(1000, 1000) 
        local sz = stealBarContainer.AbsoluteSize 
        local newX = math.clamp(startPos.X.Scale * vp.X + startPos.X.Offset + delta.X, sz.X / 2, vp.X - sz.X / 2) 
        local newY = math.clamp(startPos.Y.Scale * vp.Y + startPos.Y.Offset + delta.Y, 0, vp.Y - sz.Y) 
        stealBarContainer.Position = UDim2.new(startPos.X.Scale, newX - startPos.X.Scale * vp.X, startPos.Y.Scale, newY - startPos.Y.Scale * vp.Y) 
    end 
end) 

-- ============================================================ 
-- LOAD CONFIG AND BUILD 
-- ============================================================ 
local _savedCfg = nil 

-- ============================================================
-- NEW E01 + SKINS
-- Portado somente das funcoes solicitadas.
-- ============================================================
_G.DeepE01New=_G.DeepE01New or {
    enabled=false,
    startedAt=nil,
    gui=nil,
    conn=nil
}

function _G.DeepE01NewIsCarrying()
    local character=LP.Character
    if not character then return false end

    for _,child in ipairs(character:GetChildren()) do
        local n=string.lower(tostring(child.Name or ""))
        if string.find(n,"brain",1,true)
            or string.find(n,"animal",1,true)
            or string.find(n,"carry",1,true)
            or string.find(n,"steal",1,true) then
            return true
        end
    end

    local humanoid=character:FindFirstChildOfClass("Humanoid")
    return humanoid
        and humanoid.WalkSpeed>0
        and humanoid.WalkSpeed<=25
        and humanoid.WalkSpeed~=16
        or false
end

function _G.DeepE01NewEnsureGui()
    local E=_G.DeepE01New
    if E.gui and E.gui.Parent then return E.gui end

    local pg=LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui",5)
    if not pg then return nil end

    local old=pg:FindFirstChild("CleanHubE01Warning")
    if old then pcall(function() old:Destroy() end) end

    local gui=Instance.new("ScreenGui")
    gui.Name="CleanHubE01Warning"
    gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=true
    gui.Enabled=false
    gui.Parent=pg

    local frame=Instance.new("Frame",gui)
    frame.Name="Bar"
    frame.AnchorPoint=Vector2.new(0.5,0)
    frame.Position=UDim2.new(0.5,0,0,18)
    frame.Size=UDim2.new(0,300,0,36)
    frame.BackgroundColor3=Color3.fromRGB(0,0,0)
    frame.BackgroundTransparency=0.34
    frame.BorderSizePixel=0
    frame.ClipsDescendants=true
    Instance.new("UICorner",frame).CornerRadius=UDim.new(1,0)

    local track=Instance.new("Frame",frame)
    track.Name="Track"
    track.Position=UDim2.new(0,3,0,3)
    track.Size=UDim2.new(1,-6,1,-6)
    track.BackgroundColor3=Color3.fromRGB(0,0,0)
    track.BackgroundTransparency=0.48
    track.BorderSizePixel=0
    track.ClipsDescendants=true
    Instance.new("UICorner",track).CornerRadius=UDim.new(1,0)

    local fill=Instance.new("Frame",track)
    fill.Name="Fill"
    fill.Size=UDim2.new(0,0,1,0)
    fill.BackgroundColor3=Color3.fromRGB(85,255,85)
    fill.BackgroundTransparency=0.48
    fill.BorderSizePixel=0
    Instance.new("UICorner",fill).CornerRadius=UDim.new(1,0)

    local label=Instance.new("TextLabel",frame)
    label.Name="Label"
    label.Size=UDim2.new(1,-16,1,0)
    label.Position=UDim2.new(0,8,0,0)
    label.BackgroundTransparency=1
    label.Font=Enum.Font.GothamBlack
    label.TextSize=14
    label.TextStrokeTransparency=0.18
    label.TextStrokeColor3=Color3.fromRGB(0,0,0)
    label.ZIndex=2

    E.gui=gui
    return gui
end

function _G.DeepE01NewStop()
    local E=_G.DeepE01New
    if not E then return end

    if E.conn then
        pcall(function() E.conn:Disconnect() end)
        E.conn=nil
    end
    E.startedAt=nil

    if E.gui and E.gui.Parent then
        E.gui.Enabled=false
    end
end

function _G.DeepE01NewStart()
    local E=_G.DeepE01New
    if not E or E.conn then return end

    E.conn=RunService.Heartbeat:Connect(function()
        if not E.enabled then
            if E.gui and E.gui.Parent then E.gui.Enabled=false end
            E.startedAt=nil
            return
        end

        if not _G.DeepE01NewIsCarrying() then
            if E.gui and E.gui.Parent then E.gui.Enabled=false end
            E.startedAt=nil
            return
        end

        E.startedAt=E.startedAt or tick()
        local progress=math.clamp((tick()-E.startedAt)/2.6,0,1)
        local gui=_G.DeepE01NewEnsureGui()
        if not gui then return end

        gui.Enabled=true
        local ready=progress>=1
        gui.Bar.Label.Text=ready and "STEAL" or "DONT STEAL"
        gui.Bar.Label.TextColor3=ready and Color3.fromRGB(85,255,125) or Color3.fromRGB(85,75,85)
        gui.Bar.Track.Fill.Size=UDim2.new(progress,0,1,0)
    end)
end

function _G.DeepSetE01(on)
    local E=_G.DeepE01New
    if not E then return false end

    E.enabled=(on==true)
    if E.enabled then
        _G.DeepE01NewStart()
    else
        _G.DeepE01NewStop()
    end

    if _G.DeepE01Visual then
        pcall(_G.DeepE01Visual,E.enabled)
    end
    return E.enabled
end

LP.CharacterAdded:Connect(function()
    local E=_G.DeepE01New
    if E then
        E.startedAt=nil
        if E.gui and E.gui.Parent then E.gui.Enabled=false end
    end
end)

-- ============================================================
-- SKINS
-- ============================================================
_G.DeepSkins=_G.DeepSkins or {}
do
    local S=_G.DeepSkins

    S.katanaEnabled=S.katanaEnabled==true
    S.minecraftEnabled=S.minecraftEnabled==true
    S.minecraftColor=S.minecraftColor or "Default"
    S.animPack=S.animPack or "Off"
    S.outfitIndex=tonumber(S.outfitIndex) or 6
    S.backgroundIndex=tonumber(S.backgroundIndex) or 1
    S.ui=S.ui or {}
    S.originalBat=S.originalBat or setmetatable({}, {__mode="k"})
    S.minecraftTemplate=S.minecraftTemplate or nil
    S.minecraftRgbConn=S.minecraftRgbConn or nil
    S.skinMonitor=S.skinMonitor or nil
    S.animConn=S.animConn or nil
    S.originalAnims=S.originalAnims or nil
    S.originalAppearance=S.originalAppearance or nil

    S.minecraftColors={
        ["Default"]=nil,
        ["Abyss Blue"]=Color3.fromRGB(0,40,150),
        ["Venom Green"]=Color3.fromRGB(20,85,50),
        ["Royal Gold"]=Color3.fromRGB(255,200,0),
        ["Velvet Rose"]=Color3.fromRGB(220,20,100),
        ["Crimson Night"]=Color3.fromRGB(90,0,20),
    }
    S.minecraftColorList={
        "Default","Abyss Blue","Venom Green","Royal Gold","Velvet Rose","Crimson Night","RGB"
    }

    S.animPacks={
        Zombie={idle1="rbxassetid://616158929",idle2="rbxassetid://616160636",walk="rbxassetid://616168032",run="rbxassetid://616163682",jump="rbxassetid://616161997",fall="rbxassetid://616157476",climb="rbxassetid://616156119",swim="rbxassetid://616165109",swimidle="rbxassetid://616166655"},
        Ninja={idle1="rbxassetid://656117400",idle2="rbxassetid://656117400",walk="rbxassetid://656121766",run="rbxassetid://656118852",jump="rbxassetid://656117878",fall="rbxassetid://656115606",climb="rbxassetid://656114359",swim="rbxassetid://656117400",swimidle="rbxassetid://656117400"},
        Knight={idle1="rbxassetid://657595757",idle2="rbxassetid://657595757",walk="rbxassetid://657552124",run="rbxassetid://657564596",jump="rbxassetid://658409194",fall="rbxassetid://657600338",climb="rbxassetid://658360781",swim="rbxassetid://657595757",swimidle="rbxassetid://657595757"},
        Elder={idle1="rbxassetid://845397899",idle2="rbxassetid://845397899",walk="rbxassetid://845403856",run="rbxassetid://845386501",jump="rbxassetid://845398858",fall="rbxassetid://845397673",climb="rbxassetid://845392038",swim="rbxassetid://845397899",swimidle="rbxassetid://845397899"},
        Levitate={idle1="rbxassetid://616006778",idle2="rbxassetid://616006778",walk="rbxassetid://616013216",run="rbxassetid://616013216",jump="rbxassetid://616008936",fall="rbxassetid://616005863",climb="rbxassetid://616003713",swim="rbxassetid://616006778",swimidle="rbxassetid://616006778"},
        Astronaut={idle1="rbxassetid://891621366",idle2="rbxassetid://891621366",walk="rbxassetid://891636393",run="rbxassetid://891636393",jump="rbxassetid://891627522",fall="rbxassetid://891617961",climb="rbxassetid://891609353",swim="rbxassetid://891621366",swimidle="rbxassetid://891621366"},
        Pirate={idle1="rbxassetid://750781874",idle2="rbxassetid://750781874",walk="rbxassetid://750785693",run="rbxassetid://750783738",jump="rbxassetid://750782230",fall="rbxassetid://750780242",climb="rbxassetid://750779899",swim="rbxassetid://750781874",swimidle="rbxassetid://750781874"},
        Toy={idle1="rbxassetid://782841498",idle2="rbxassetid://782841498",walk="rbxassetid://782843345",run="rbxassetid://782842708",jump="rbxassetid://782847020",fall="rbxassetid://782846423",climb="rbxassetid://782843869",swim="rbxassetid://782841498",swimidle="rbxassetid://782841498"},
        Vampire={idle1="rbxassetid://1083445855",idle2="rbxassetid://1083445855",walk="rbxassetid://1083473930",run="rbxassetid://1083462077",jump="rbxassetid://1083455352",fall="rbxassetid://1083443587",climb="rbxassetid://1083439238",swim="rbxassetid://1083445855",swimidle="rbxassetid://1083445855"},
        Werewolf={idle1="rbxassetid://1083195517",idle2="rbxassetid://1083195517",walk="rbxassetid://1083178339",run="rbxassetid://1083216690",jump="rbxassetid://1083218792",fall="rbxassetid://1083189019",climb="rbxassetid://1083182000",swim="rbxassetid://1083195517",swimidle="rbxassetid://1083195517"},
        Rthro={idle1="rbxassetid://2510196951",idle2="rbxassetid://2510196951",walk="rbxassetid://2510202577",run="rbxassetid://2510198475",jump="rbxassetid://2510197830",fall="rbxassetid://2510195892",climb="rbxassetid://2510192778",swim="rbxassetid://2510196951",swimidle="rbxassetid://2510196951"},
        Stylish={idle1="rbxassetid://616136790",idle2="rbxassetid://616136790",walk="rbxassetid://616146177",run="rbxassetid://616140816",jump="rbxassetid://616139451",fall="rbxassetid://616134815",climb="rbxassetid://616133594",swim="rbxassetid://616136790",swimidle="rbxassetid://616136790"},
    }
    S.animList={"Off","Zombie","Ninja","Knight","Elder","Levitate","Astronaut","Pirate","Toy","Vampire","Werewolf","Rthro","Stylish"}

    S.outfits={
        {label="Outfit 1",accessory=10159600649,offset=Vector3.new(0,1,-0.2),shirt="http://www.roblox.com/asset/?id=9683332638",pants="http://www.roblox.com/asset/?id=93182020184041",headMesh="http://www.roblox.com/asset/?id=134079402",headTexture="http://www.roblox.com/asset/?id=133940918",headlessKorblox=true},
        {label="Outfit 2",accessory=1744060292,offset=Vector3.new(0,1.3,-0.2),shirt="http://www.roblox.com/asset/?id=9683332638",pants="http://www.roblox.com/asset/?id=93182020184041",headMesh="http://www.roblox.com/asset/?id=134079402",headTexture="http://www.roblox.com/asset/?id=133940918",headlessKorblox=true},
        {label="Eclipse V1",accessory=121097973925756,offset=Vector3.new(0,0.9,0),shirt="http://www.roblox.com/asset/?id=123181702116947",pants="http://www.roblox.com/asset/?id=93330291631062",headMesh="http://www.roblox.com/asset/?id=134079402",headTexture="http://www.roblox.com/asset/?id=133940918",headlessKorblox=true},
        {label="Eclipse V2",accessory=10159600649,offset=Vector3.new(0,1,-0.2),shirt="http://www.roblox.com/asset/?id=101796619834594",pants="http://www.roblox.com/asset/?id=18975891159",headMesh="http://www.roblox.com/asset/?id=134079402",headTexture="http://www.roblox.com/asset/?id=133940918",headlessKorblox=true},
        {label="Eclipse V3",accessory=10159600649,offset=Vector3.new(0,0.9,-0.2),shirt="http://www.roblox.com/asset/?id=6361021759",pants="http://www.roblox.com/asset/?id=5414143509",headMesh="http://www.roblox.com/asset/?id=134079402",headTexture="http://www.roblox.com/asset/?id=133940918",headlessKorblox=true},
        {label="NO"},
    }

    S.backgrounds={
        {label="Off",id=nil},
        {label="BG 1",id="rbxassetid://77785523954153"},
        {label="BG 2",id="rbxassetid://122815453745063"},
        {label="BG 3",id="rbxassetid://77581705786454"},
        {label="BG 4",id="rbxassetid://86508089972764"},
        {label="BG 5",id="rbxassetid://99747773532595"},
        {label="BG 6",id="rbxassetid://139362780018712"},
        {label="BG 7",id="rbxassetid://81570223894096"},
        {label="BG 8",id="rbxassetid://94047991986188"},
        {label="BG 9",id="rbxassetid://118783198922289"},
        {label="BG 10",id="rbxassetid://101833990704596"},
        {label="BG 11",id="rbxassetid://109527418380162"},
    }

    function S.findBat()
        local char=LP.Character
        local bat=char and char:FindFirstChild("Bat")
        if bat and bat:IsA("Tool") then return bat end
        local bp=LP:FindFirstChildOfClass("Backpack")
        bat=bp and bp:FindFirstChild("Bat")
        if bat and bat:IsA("Tool") then return bat end
        return nil
    end

    function S.cacheBat(bat)
        if not bat or S.originalBat[bat] then return end
        local h=bat:FindFirstChild("Handle")
        local slash=bat:FindFirstChild("Slash")
        S.originalBat[bat]={
            transparency=h and h.Transparency or 0,
            localTransparency=h and h.LocalTransparencyModifier or 0,
            castShadow=h and h.CastShadow,
            slash=slash and slash:IsA("Sound") and slash.SoundId or nil,
        }
    end

    function S.restoreBat(bat)
        if not bat then return end
        local generated=bat:FindFirstChild("FlowerSkin_KatanaRealistic")
        if generated then pcall(function() generated:Destroy() end) end
        local mc=bat:FindFirstChild("CustomUnionVisual")
        if mc then pcall(function() mc:Destroy() end) end

        local h=bat:FindFirstChild("Handle")
        local original=S.originalBat[bat]
        if h then
            h.Transparency=original and original.transparency or 0
            h.LocalTransparencyModifier=original and original.localTransparency or 0
            if original and original.castShadow~=nil then h.CastShadow=original.castShadow else h.CastShadow=true end
            for _,child in ipairs(h:GetChildren()) do
                if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
                    pcall(function() child.Transparency=0 end)
                end
            end
        end
        local slash=bat:FindFirstChild("Slash")
        if slash and slash:IsA("Sound") and original and original.slash then slash.SoundId=original.slash end
    end

    function S.makeKatanaPart(model,name,size,offset,color,material,handle)
        local p=Instance.new("Part")
        p.Name=name
        p.Size=size
        p.Color=color
        p.Material=material
        p.Anchored=false
        p.CanCollide=false
        p.CanTouch=false
        p.CanQuery=false
        p.Massless=true
        p.CFrame=handle.CFrame*offset
        p.Parent=model
        local w=Instance.new("WeldConstraint")
        w.Name="FlowerSkin_AssetWeld"
        w.Part0=handle
        w.Part1=p
        w.Parent=p
        return p
    end

    function S.addKatanaTrail(part)
        if not part or part:FindFirstChild("FlowerSkin_ExtraRedVFX") then return end
        local a0=Instance.new("Attachment")
        a0.Name="FlowerSkin_ExtraRedVFX"
        a0.Position=Vector3.new(0,part.Size.Y*0.5,0)
        a0.Parent=part
        local a1=Instance.new("Attachment")
        a1.Name="FlowerSkin_ExtraRedVFX_End"
        a1.Position=Vector3.new(0,-part.Size.Y*0.5,0)
        a1.Parent=part
        local trail=Instance.new("Trail")
        trail.Name="FlowerSkin_ExtraRedVFX"
        trail.Attachment0=a0
        trail.Attachment1=a1
        trail.Color=ColorSequence.new({
            ColorSequenceKeypoint.new(0,Color3.new(1,0,0.392157)),
            ColorSequenceKeypoint.new(1,Color3.new(0.54902,0,0)),
        })
        trail.Transparency=NumberSequence.new({
            NumberSequenceKeypoint.new(0,0.35),
            NumberSequenceKeypoint.new(1,1),
        })
        trail.Lifetime=0.18
        trail.MinLength=0.02
        trail.Parent=part
    end

    function S.applyKatana()
        local bat=S.findBat()
        if not bat then return false end
        S.cacheBat(bat)
        S.restoreBat(bat)

        local handle=bat:FindFirstChild("Handle")
        if not handle or not handle:IsA("BasePart") then return false end
        handle.Transparency=1
        handle.LocalTransparencyModifier=1
        handle.CastShadow=false

        local slash=bat:FindFirstChild("Slash")
        if slash and slash:IsA("Sound") then
            slash.SoundId="rbxassetid://111808555599832"
        end

        local folder=Instance.new("Folder")
        folder.Name="FlowerSkin_KatanaRealistic"
        folder.Parent=bat
        local model=Instance.new("Model")
        model.Name="FlowerSkin_AssetKatana"
        model.Parent=folder

        S.makeKatanaPart(model,"Handle2",Vector3.new(0.22,1,0.22),CFrame.new(0,-0.48,0),Color3.new(0.176471,0.176471,0.045),Enum.Material.Metal,handle)
        local sharp=S.makeKatanaPart(model,"SharpParts",Vector3.new(0.18,2.4,0.12),CFrame.new(0,1.05,0),Color3.new(1,0,0.392157),Enum.Material.Neon,handle)
        S.makeKatanaPart(model,"WeaponPart",Vector3.new(0.3,2.7,0.08),CFrame.new(0.08,1.15,0),Color3.new(0.784314,0,0),Enum.Material.Neon,handle)
        S.makeKatanaPart(model,"GoldAccent",Vector3.new(0.5,0.12,0.08),CFrame.new(0,-0.28,0),Color3.new(1,0.843137,0),Enum.Material.Neon,handle)
        S.addKatanaTrail(sharp)
        return true
    end

    function S.loadMinecraftTemplate()
        if S.minecraftTemplate then return S.minecraftTemplate end
        local ok,objs=pcall(function() return game:GetObjects("rbxassetid://18566246244") end)
        if ok and objs and #objs>0 then
            local root=objs[1]
            local part=root:IsA("BasePart") and root or root:FindFirstChildWhichIsA("BasePart",true)
            if part then S.minecraftTemplate=part:Clone() end
            for _,o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
        return S.minecraftTemplate
    end

    function S.colorMinecraft(part)
        if not part then return end
        local color
        if S.minecraftColor=="RGB" then
            color=Color3.fromHSV((tick()%3)/3,1,1)
        else
            color=S.minecraftColors[S.minecraftColor]
        end
        if not color then return end
        part.Color=color
        if part:IsA("UnionOperation") then pcall(function() part.UsePartColor=true end) end
        local mesh=part:FindFirstChildWhichIsA("SpecialMesh")
        if mesh then mesh.VertexColor=Vector3.new(color.R,color.G,color.B) end
    end

    function S.applyMinecraft()
        local bat=S.findBat()
        if not bat then return false end
        S.cacheBat(bat)
        S.restoreBat(bat)
        local handle=bat:FindFirstChild("Handle")
        local template=S.loadMinecraftTemplate()
        if not handle or not template then return false end

        handle.Transparency=1
        handle.LocalTransparencyModifier=1
        for _,child in ipairs(handle:GetChildren()) do
            if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
                pcall(function() child.Transparency=1 end)
            end
        end

        local visual=template:Clone()
        visual.Name="CustomUnionVisual"
        visual.CanCollide=false
        visual.Massless=true
        visual.Anchored=false
        visual.CFrame=handle.CFrame*CFrame.new(-0.18,-0.52,-0.2)*CFrame.Angles(math.rad(45),0,math.rad(5))
        visual.Parent=bat
        S.colorMinecraft(visual)

        local weld=Instance.new("WeldConstraint")
        weld.Part0=handle
        weld.Part1=visual
        weld.Parent=visual
        return true
    end

    function S.stopMinecraftRgb()
        if S.minecraftRgbConn then
            pcall(function() S.minecraftRgbConn:Disconnect() end)
            S.minecraftRgbConn=nil
        end
    end

    function S.startMinecraftRgb()
        if S.minecraftRgbConn then return end
        S.minecraftRgbConn=RunService.RenderStepped:Connect(function()
            if not S.minecraftEnabled or S.minecraftColor~="RGB" then return end
            local bat=S.findBat()
            local v=bat and bat:FindFirstChild("CustomUnionVisual")
            if v and v:IsA("BasePart") then S.colorMinecraft(v) end
        end)
    end

    function S.setKatana(on)
        S.katanaEnabled=(on==true)
        if S.katanaEnabled then
            S.minecraftEnabled=false
            S.stopMinecraftRgb()
            local bat=S.findBat()
            if bat then S.restoreBat(bat) end
            pcall(S.applyKatana)
        else
            local bat=S.findBat()
            if bat then S.restoreBat(bat) end
        end
        if S.ui.bat then pcall(S.ui.bat,S.katanaEnabled) end
        if S.ui.mc then pcall(S.ui.mc,S.minecraftEnabled) end
    end

    function S.setMinecraft(on)
        S.minecraftEnabled=(on==true)
        if S.minecraftEnabled then
            S.katanaEnabled=false
            local bat=S.findBat()
            if bat then S.restoreBat(bat) end
            pcall(S.applyMinecraft)
            if S.minecraftColor=="RGB" then S.startMinecraftRgb() end
        else
            S.stopMinecraftRgb()
            local bat=S.findBat()
            if bat then S.restoreBat(bat) end
        end
        if S.ui.bat then pcall(S.ui.bat,S.katanaEnabled) end
        if S.ui.mc then pcall(S.ui.mc,S.minecraftEnabled) end
    end

    function S.setMinecraftColor(mode)
        if not S.minecraftColors[mode] and mode~="Default" and mode~="RGB" then mode="Default" end
        S.minecraftColor=mode
        if mode=="RGB" and S.minecraftEnabled then S.startMinecraftRgb() else S.stopMinecraftRgb() end
        if S.minecraftEnabled then pcall(S.applyMinecraft) end
    end

    function S.captureAnimations()
        local char=LP.Character
        local a=char and char:FindFirstChild("Animate")
        if not a or S.originalAnims then return end
        local function g(o) return o and o.AnimationId or nil end
        S.originalAnims={
            idle1=g(a.idle and a.idle:FindFirstChild("Animation1")),
            idle2=g(a.idle and a.idle:FindFirstChild("Animation2")),
            walk=g(a.walk and a.walk:FindFirstChild("WalkAnim")),
            run=g(a.run and a.run:FindFirstChild("RunAnim")),
            jump=g(a.jump and a.jump:FindFirstChild("JumpAnim")),
            fall=g(a.fall and a.fall:FindFirstChild("FallAnim")),
            climb=g(a.climb and a.climb:FindFirstChild("ClimbAnim")),
            swim=g(a.swim and a.swim:FindFirstChild("Swim")),
            swimidle=g(a.swimidle and a.swimidle:FindFirstChild("SwimIdle")),
        }
    end

    function S.writeAnimations(data)
        local char=LP.Character
        local a=char and char:FindFirstChild("Animate")
        if not a or not data then return end
        local function s(o,id) if o and id then o.AnimationId=id end end
        s(a.idle and a.idle:FindFirstChild("Animation1"),data.idle1)
        s(a.idle and a.idle:FindFirstChild("Animation2"),data.idle2)
        s(a.walk and a.walk:FindFirstChild("WalkAnim"),data.walk)
        s(a.run and a.run:FindFirstChild("RunAnim"),data.run)
        s(a.jump and a.jump:FindFirstChild("JumpAnim"),data.jump)
        s(a.fall and a.fall:FindFirstChild("FallAnim"),data.fall)
        s(a.climb and a.climb:FindFirstChild("ClimbAnim"),data.climb)
        s(a.swim and a.swim:FindFirstChild("Swim"),data.swim)
        s(a.swimidle and a.swimidle:FindFirstChild("SwimIdle"),data.swimidle)
    end

    function S.setAnimPack(name)
        if name~="Off" and not S.animPacks[name] then name="Off" end
        S.animPack=name
        S.captureAnimations()
        if S.animConn then
            pcall(function() S.animConn:Disconnect() end)
            S.animConn=nil
        end
        if name=="Off" then
            S.writeAnimations(S.originalAnims)
            return
        end
        S.writeAnimations(S.animPacks[name])
        S.animConn=RunService.Heartbeat:Connect(function()
            if S.animPack=="Off" then return end
            local pack=S.animPacks[S.animPack]
            if pack then S.writeAnimations(pack) end
        end)
        local hum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
        if hum then
            for _,track in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
        end
    end

    function S.captureAppearance()
        local char=LP.Character
        if not char or S.originalAppearance then return end
        local shirt=char:FindFirstChildWhichIsA("Shirt")
        local pants=char:FindFirstChildWhichIsA("Pants")
        local head=char:FindFirstChild("Head")
        local face=head and head:FindFirstChild("face")
        S.originalAppearance={
            shirt=shirt and shirt.ShirtTemplate or nil,
            pants=pants and pants.PantsTemplate or nil,
            headTransparency=head and head.Transparency or 0,
            headLocalTransparency=head and head.LocalTransparencyModifier or 0,
            faceTransparency=face and face.Transparency or 0,
        }
    end

    function S.clearOutfitGenerated()
        local char=LP.Character
        if not char then return end
        local acc=char:FindFirstChild("DeepSkinAccessory")
        if acc then pcall(function() acc:Destroy() end) end
        local leg=char:FindFirstChild("DeepSkinKorblox")
        if leg then pcall(function() leg:Destroy() end) end
    end

    function S.restoreAppearance()
        local char=LP.Character
        if not char then return end
        S.clearOutfitGenerated()
        local o=S.originalAppearance
        local shirt=char:FindFirstChildWhichIsA("Shirt")
        local pants=char:FindFirstChildWhichIsA("Pants")
        if o and o.shirt then
            shirt=shirt or Instance.new("Shirt",char)
            shirt.ShirtTemplate=o.shirt
        end
        if o and o.pants then
            pants=pants or Instance.new("Pants",char)
            pants.PantsTemplate=o.pants
        end
        local head=char:FindFirstChild("Head")
        if head then
            head.Transparency=o and o.headTransparency or 0
            head.LocalTransparencyModifier=o and o.headLocalTransparency or 0
            local face=head:FindFirstChild("face")
            if face then face.Transparency=o and o.faceTransparency or 0 end
        end
        for _,n in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot"}) do
            local p=char:FindFirstChild(n)
            if p and p:IsA("BasePart") then p.Transparency=0 end
        end
    end

    function S.applyOutfit(index)
        index=math.clamp(math.floor(tonumber(index) or 6),1,#S.outfits)
        S.outfitIndex=index
        local cfg=S.outfits[index]
        local char=LP.Character
        if not char then return end

        S.captureAppearance()
        S.restoreAppearance()
        if not cfg or cfg.label=="NO" then return end

        local shirt=char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt",char)
        local pants=char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants",char)
        shirt.ShirtTemplate=cfg.shirt or ""
        pants.PantsTemplate=cfg.pants or ""

        local head=char:FindFirstChild("Head")
        if head then
            local sm=head:FindFirstChildWhichIsA("SpecialMesh")
            if sm then
                pcall(function()
                    sm.MeshId=cfg.headMesh or sm.MeshId
                    sm.TextureId=cfg.headTexture or sm.TextureId
                end)
            end
        end

        if cfg.accessory and head then
            pcall(function()
                local objs=game:GetObjects("rbxassetid://"..tostring(cfg.accessory))
                local source
                for _,o in ipairs(objs or {}) do
                    source=o:IsA("BasePart") and o or o:FindFirstChildWhichIsA("BasePart",true)
                    if source then break end
                end
                if source then
                    local clone=source:Clone()
                    clone.Name="DeepSkinAccessory"
                    clone.CanCollide=false
                    clone.Anchored=false
                    clone.Massless=true
                    clone.CFrame=head.CFrame*CFrame.new(cfg.offset or Vector3.zero)
                    clone.Parent=char
                    local weld=Instance.new("WeldConstraint")
                    weld.Part0=head
                    weld.Part1=clone
                    weld.Parent=clone
                end
                for _,o in ipairs(objs or {}) do pcall(function() o:Destroy() end) end
            end)
        end

        if cfg.headlessKorblox then
            if head then
                head.Transparency=1
                head.LocalTransparencyModifier=1
                local face=head:FindFirstChild("face")
                if face then face.Transparency=1 end
            end
            for _,n in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot"}) do
                local p=char:FindFirstChild(n)
                if p and p:IsA("BasePart") then p.Transparency=1 end
            end
        end
    end

    function S.applyBackground(index)
        index=math.clamp(math.floor(tonumber(index) or 1),1,#S.backgrounds)
        S.backgroundIndex=index
        local bg=S.backgrounds[index]
        if hubBgImageRef and hubBgImageRef.Parent then
            if bg and bg.id then
                hubBgImageRef.Image=bg.id
                hubBgImageRef.ImageTransparency=0.55
            else
                hubBgImageRef.Image=getHubArtImage()
                hubBgImageRef.ImageTransparency=0
            end
        end
    end

    function S.applyAll()
        if S.katanaEnabled then
            S.setKatana(true)
        elseif S.minecraftEnabled then
            S.setMinecraft(true)
        else
            local bat=S.findBat()
            if bat then S.restoreBat(bat) end
        end
        S.setMinecraftColor(S.minecraftColor)
        S.setAnimPack(S.animPack)
        S.applyOutfit(S.outfitIndex)
        S.applyBackground(S.backgroundIndex)
    end

    if not S.skinMonitor then
        S.skinMonitor=task.spawn(function()
            while true do
                if S.katanaEnabled then
                    local bat=S.findBat()
                    if bat and not bat:FindFirstChild("FlowerSkin_KatanaRealistic") then pcall(S.applyKatana) end
                elseif S.minecraftEnabled then
                    local bat=S.findBat()
                    if bat and not bat:FindFirstChild("CustomUnionVisual") then pcall(S.applyMinecraft) end
                end
                task.wait(0.5)
            end
        end)
    end

    LP.CharacterAdded:Connect(function()
        S.originalAnims=nil
        S.originalAppearance=nil
        task.delay(1,function()
            if _G.DeepSkins then pcall(_G.DeepSkins.applyAll) end
        end)
    end)
end


local function loadConfigKeys() 
    if not(isfile and isfile("exeMobile.json")) then return end 
    local ok,cfg=pcall(function() return HS:JSONDecode(readfile("exeMobile.json")) end) 
    if not ok or not cfg then return end 
    _savedCfg=cfg 
    local function lk(e,d) 
        if type(d)~="table" then return end;if d.kb and Enum.KeyCode[d.kb] then e.kb=Enum.KeyCode[d.kb] end 
    end 
    lk(KB.DropBrainrot,cfg.dropBrainrotKey);lk(KB.AutoLeft,cfg.autoLeftKey);lk(KB.AutoRight,cfg.autoRightKey) 
    lk(KB.AutoBat,cfg.autoBatKey);lk(KB.LaggerToggle,cfg.laggerToggleKey) 
    lk(KB.TPFloor,cfg.tpFloorKey);lk(KB.GuiHide,cfg.guiHideKey);lk(KB.SpeedToggle,cfg.speedToggleKey);lk(KB.Aimbot2,cfg.aimbot2Key);lk(KB.AntiDesyncAimbot,cfg.antiDesyncAimbotKey) 
    if cfg.laggerPanelKey and Enum.KeyCode[cfg.laggerPanelKey] then exeLaggerPanelKey=Enum.KeyCode[cfg.laggerPanelKey] end 
    if cfg.normalSpeed then NS=cfg.normalSpeed end 
    if cfg.carrySpeed then CS=cfg.carrySpeed end 
    if cfg.dropVersion=="FLIGHT" or cfg.dropVersion=="JUMP" then dropVersion=cfg.dropVersion else dropVersion="JUMP" end
    if _G.DeepRefreshDropVersionUI then pcall(_G.DeepRefreshDropVersionUI) end
    refreshDropMobileLabel()
    if _G.ExeBypass then
        if type(cfg.bypassPower)=="number" then _G.ExeBypass.power=math.clamp(math.floor(cfg.bypassPower),10000,150000) else _G.ExeBypass.power=72000 end
        _G.ExeBypass.autoBrainrot=(cfg.bypassAutoBrainrot==true)
    end
    if cfg.grabRadius and type(cfg.grabRadius)=="number" then
        Steal.StealRadius=math.clamp(cfg.grabRadius,1,500)
    else
        Steal.StealRadius=20
    end

    if cfg.stealDuration and type(cfg.stealDuration)=="number" then
        Steal.StealDuration=math.clamp(cfg.stealDuration,0.1,5)
    else
        Steal.StealDuration=1.3
    end

    if cfg.delayRadius and type(cfg.delayRadius)=="number" then
        Steal.DelayRadius=math.clamp(cfg.delayRadius,1,40)
    elseif cfg.semiStealRadius and type(cfg.semiStealRadius)=="number" then
        Steal.DelayRadius=math.clamp(cfg.semiStealRadius,1,40)
    else
        Steal.DelayRadius=8
    end

    if cfg.stopPercent and type(cfg.stopPercent)=="number" then
        Steal.StopPercent=math.clamp(cfg.stopPercent,1,100)
    else
        Steal.StopPercent=75
    end
    if cfg.laggerSpeed and type(cfg.laggerSpeed)=="number" then LAGGER_SPEED=cfg.laggerSpeed end 
    if cfg.laggerCarrySpeed and type(cfg.laggerCarrySpeed)=="number" then LAGGER_CARRY_SPEED=cfg.laggerCarrySpeed end 
    if cfg.autoSwing~=nil then autoSwingEnabled=cfg.autoSwing==true end 
    if cfg.tpAimbotMode=="v1" or cfg.tpAimbotMode=="v2" then tpAimbotMode=cfg.tpAimbotMode else tpAimbotMode="v1" end
    if cfg.espEnabled~=nil then _G.DeepESP.enabled=cfg.espEnabled==true end
    if cfg.espLine~=nil then _G.DeepESP.line=cfg.espLine==true end
    if cfg.espSquare~=nil then _G.DeepESP.square=cfg.espSquare==true end
    if cfg.espExpanded~=nil then _G.DeepESP.expanded=cfg.espExpanded==true end
    if _G.DeepAntiBat then
        if cfg.antiBatMaster~=nil then
            _G.DeepAntiBat.enabled=cfg.antiBatMaster==true
        elseif cfg.anti404Bat~=nil then
            _G.DeepAntiBat.enabled=cfg.anti404Bat==true
        end
        if cfg.antiBatV1~=nil then
            _G.DeepAntiBat.v1=cfg.antiBatV1==true
        else
            _G.DeepAntiBat.v1=true
        end
        if cfg.antiBatV2~=nil then
            _G.DeepAntiBat.v2=cfg.antiBatV2==true
        end
        if cfg.antiBatExpanded~=nil then
            _G.DeepAntiBat.expanded=cfg.antiBatExpanded==true
        end
    end
    if cfg.autoBatSpeed and type(cfg.autoBatSpeed)=="number" then AUTO_BAT_SPEED=math.clamp(cfg.autoBatSpeed,1,500) end 
    if _G.DeepGreenAimbot then
        if type(cfg.greenNormalAimbotSpeed)=="number" then _G.DeepSetGreenAimbotSpeed("NORMAL",cfg.greenNormalAimbotSpeed,true) end
        if type(cfg.greenBypassAimbotSpeed)=="number" then _G.DeepSetGreenAimbotSpeed("BYPASS",cfg.greenBypassAimbotSpeed,true) end

        if type(cfg.greenAimbotVersion)=="string" then
            local gv=cfg.greenAimbotVersion:upper()
            if gv=="NORMAL" or gv=="BYPASS" then
                _G.DeepGreenAimbot.version=gv
            end
        end

        _G.DeepGreenAimbot.enabled=(cfg.greenAimbotEnabled==true)
        task.defer(function()
            if _G.DeepGreenAimbot.enabled then
                pcall(_G.DeepSetGreenAimbot,true)
            else
                pcall(_G.DeepRefreshGreenAimbotUI)
            end
        end)
    end
    if cfg.bodyLockRadius and type(cfg.bodyLockRadius)=="number" then bodyLockRadius=math.clamp(cfg.bodyLockRadius,1,500) end 
    if cfg.uiScale and type(cfg.uiScale)=="number" then uiScale=math.clamp(cfg.uiScale,0.6,1.6) end
    if cfg.autoGrabScale and type(cfg.autoGrabScale)=="number" then
        _G.DeepSetAutoGrabScale(math.clamp(cfg.autoGrabScale,0.60,1.50))
    else
        _G.DeepSetAutoGrabScale(_G.DeepAutoGrabScale or 1)
    end
    if cfg.uiLocked~=nil then uiLocked=cfg.uiLocked==true end 
    if cfg.fovValue and type(cfg.fovValue)=="number" then fovValue=math.clamp(cfg.fovValue,30,120) end 
    if cfg.mobileButtonsSize and type(cfg.mobileButtonsSize)=="number" then mobileButtonsSize=cfg.mobileButtonsSize end 
    if cfg.mobileButtonShape and type(cfg.mobileButtonShape)=="string" then mobileButtonShape=cfg.mobileButtonShape end 
    if cfg.hubImageChoice and type(cfg.hubImageChoice)=="number" then hubImageChoice=math.clamp(cfg.hubImageChoice,1,5) end
    if cfg.buttonImageChoice and type(cfg.buttonImageChoice)=="number" then buttonImageChoice=math.clamp(cfg.buttonImageChoice,1,5) end
    if _G.DeepE01New and cfg.e01NewEnabled~=nil then _G.DeepE01New.enabled=cfg.e01NewEnabled==true end
    if _G.DeepSkins then
        _G.DeepSkins.katanaEnabled=cfg.skinKatana==true
        _G.DeepSkins.minecraftEnabled=cfg.skinMinecraft==true
        if type(cfg.skinMinecraftColor)=="string" then _G.DeepSkins.minecraftColor=cfg.skinMinecraftColor end
        if type(cfg.skinAnimPack)=="string" then _G.DeepSkins.animPack=cfg.skinAnimPack end
        if type(cfg.skinOutfitIndex)=="number" then _G.DeepSkins.outfitIndex=math.clamp(math.floor(cfg.skinOutfitIndex),1,#_G.DeepSkins.outfits) end
        if type(cfg.skinBackgroundIndex)=="number" then _G.DeepSkins.backgroundIndex=math.clamp(math.floor(cfg.skinBackgroundIndex),1,#_G.DeepSkins.backgrounds) end
    end
    if cfg.mobileDragSmall~=nil then mobileDragSmall=cfg.mobileDragSmall==true end 
    if cfg.mobileMovingMode~=nil then mobileMovingMode=cfg.mobileMovingMode==true end 
    if cfg.anti404Drop~=nil then antiDrop404Enabled=cfg.anti404Drop==true end 
    if cfg.anti404Die~=nil then antiDie404Enabled=cfg.anti404Die==true end 
    antiBat404Enabled=false
    if cfg.mobBtnSavedContainerPos and type(cfg.mobBtnSavedContainerPos)=="table" then mobBtnSavedContainerPos=cfg.mobBtnSavedContainerPos end 
    if cfg.mobBtnSavedIndPos and type(cfg.mobBtnSavedIndPos)=="table" then mobBtnSavedIndPos=cfg.mobBtnSavedIndPos end 
end 
local function loadConfigState() 
    local cfg=_savedCfg;if not cfg then return end 
    if normalBox then normalBox.Text=tostring(NS) end 
    if carryBox then carryBox.Text=tostring(CS) end 
    if radInput then radInput.Text=tostring(Steal.StealRadius) end
    if delayRadiusBox then delayRadiusBox.Text=tostring(Steal.DelayRadius) end
    if stealDurBox then stealDurBox.Text=tostring(Steal.StealDuration) end
    if stopTimeBox then stopTimeBox.Text=tostring(Steal.StopPercent) end
    if laggerBox then laggerBox.Text=tostring(LAGGER_SPEED) end 
    if laggerCarryBox then laggerCarryBox.Text=tostring(LAGGER_CARRY_SPEED) end 
    if uiScaleBox then uiScaleBox.Text=tostring(uiScale) end 
    if fovValueBox then fovValueBox.Text=tostring(fovValue) end 
    if bodyLockRadiusBox then bodyLockRadiusBox.Text=tostring(bodyLockRadius) end 
    if autoBatSpeedBox then autoBatSpeedBox.Text=tostring(AUTO_BAT_SPEED) end 
    if cfg.guiPos and exeMainFrame then exeMainFrame.Position=UDim2.new(cfg.guiPos.xs or 0.5,cfg.guiPos.xo or -160,cfg.guiPos.ys or 0.5,cfg.guiPos.yo or -235) end 
    if cfg.miniPos and exeMiniButton then exeMiniButton.Position=UDim2.new(cfg.miniPos.xs or 0,cfg.miniPos.xo or 26,cfg.miniPos.ys or 0,cfg.miniPos.yo or 26) end 
    if cfg.grabBarPos and exeGrabBar then exeGrabBar.Position=UDim2.new(cfg.grabBarPos.xs or 0.5,cfg.grabBarPos.xo or -110,cfg.grabBarPos.ys or 1,cfg.grabBarPos.yo or -50) end 
    if cfg.stealBarPos and stealBarContainer then 
        stealBarContainer.Position = UDim2.new(cfg.stealBarPos.xs or 0.5, cfg.stealBarPos.xo or -160, cfg.stealBarPos.ys or 0, cfg.stealBarPos.yo or 100) 
    end 
    if setLockVisual then setLockVisual(uiLocked) end 
    if setMobileMovingModeVisual then setMobileMovingModeVisual(mobileMovingMode and not uiLocked) end
    if mobContainerRef then
        mobContainerRef.Active=(mobileMovingMode==true and not uiLocked)
    end
    if _G.DeepE01New then
        _G.DeepSetE01(_G.DeepE01New.enabled==true)
    end
    if _G.DeepSkins then
        if _G.DeepSkins.ui.bat then pcall(_G.DeepSkins.ui.bat,_G.DeepSkins.katanaEnabled) end
        if _G.DeepSkins.ui.mc then pcall(_G.DeepSkins.ui.mc,_G.DeepSkins.minecraftEnabled) end
        task.defer(function()
            task.wait(0.35)
            pcall(_G.DeepSkins.applyAll)
        end)
    end
    task.spawn(function() 
        task.wait(0.15) 
        if cfg.antiRagdoll then antiRagdollEnabled=true;if setAntiRagVisual then setAntiRagVisual(true) end;startAntiRagdoll() end
        if cfg.ragdollTimer then
            _G.DeepRagdollTimerEnabled=true
            if _G.DeepRagdollTimerVisual then _G.DeepRagdollTimerVisual(true) end
            pcall(function()
                if LP.Character then _G.DeepStartRagdollTimerSystem(LP.Character) end
            end)
        end
        if cfg.autoStealEnabled then Steal.AutoStealEnabled=true;if setInstaGrab then setInstaGrab(true) end;pcall(startAutoSteal) end
        if cfg.infiniteJump then infJumpEnabled=true;if setInfJumpVisual then setInfJumpVisual(true) end end 
        if cfg.medusaCounter then medusaCounterEnabled=true;if setMedusaVisual then setMedusaVisual(true) end;setupMedusa(LP.Character) end 
        if cfg.batCounter then batCounterEnabled=true;if setBatCounterVisual then setBatCounterVisual(true) end;startBatCounter() end
        if cfg.bodyLockEnabled then bodyLockEnabled=true;if setBodyLockVisual then setBodyLockVisual(true) end;startBodyLock() end 
        if _G.ExeBypass then
            if _G.ExeBypassPowerBox then _G.ExeBypassPowerBox.Text=tostring(_G.ExeBypass.power) end
            if _G.ExeAutoBrainrotVisual then _G.ExeAutoBrainrotVisual(_G.ExeBypass.autoBrainrot) end
            if _G.ExeBypass.autoBrainrot then
                _G.ExeSetAutoBrainrot(true,true)
            elseif cfg.bypassEnabled==true then
                _G.ExeSetBypass(true,true)
            else
                _G.ExeSetBypass(false,true)
            end
        end

        laggerToggled=false;speedMode=false;laggerPhase=0
        autoSwitchSpeedEnabled=false;autoTurnOffSpeedEnabled=false;autoSwitchLaggerSpeedEnabled=false
        refreshSpeedModeLabel();refreshSpeedButtons() 
        if setAutoSwingVisual then setAutoSwingVisual(autoSwingEnabled) end 
        if _G.DeepESP.lineVisual then _G.DeepESP.lineVisual(_G.DeepESP.line) end
        if _G.DeepESP.squareVisual then _G.DeepESP.squareVisual(_G.DeepESP.square) end
        if _G.DeepESP.refreshExpanded then _G.DeepESP.refreshExpanded() end
        _G.DeepESP.setEnabled(_G.DeepESP.enabled)
        if cfg.autoBat then autoBatEnabled=true;if autoBatSetVisual then autoBatSetVisual(true) end;queueAutoBatStart() end
        _G.DeepBatV2ManualEnabled=(cfg.batV2==true or cfg.aimbot2==true)
        if _G.DeepBatV2ManualEnabled then
            startAimbot2()
            if setAimbot2Visual then setAimbot2Visual(true) end
            if mobBtnRefs and mobBtnRefs.aimbot2 then mobBtnRefs.aimbot2(true) end
        else
            stopAimbot2()
            if setAimbot2Visual then setAimbot2Visual(false) end
            if mobBtnRefs and mobBtnRefs.aimbot2 then mobBtnRefs.aimbot2(false) end
        end
        -- TP Aimbot permanece desligado ao iniciar; pode ser ativado manualmente.
        spaceTpAntiDieEnabled=(cfg.spaceTpAntiDie==true)
        if spaceTpAntiDieEnabled then
            _G.DeepSpaceSetAntiDie(true)
        else
            _G.DeepSpaceSetAntiDie(false)
        end
        if cfg.unwalkEnabled then unwalkEnabled=true;if setUnwalkVisual then setUnwalkVisual(true) end;task.spawn(function() task.wait(0.5);startUnwalk() end) end 
        antiDrop404Enabled=false;antiDie404Enabled=false;infJumpEnabled=false
        stop404AntiDrop()
        pcall(function() _G.DeepSetAntiDropTag(false) end)
        if set404AntiDropVisual then set404AntiDropVisual(false) end
        if _G.DeepAntiBat then
            if _G.DeepAntiBat.refreshExpanded then pcall(_G.DeepAntiBat.refreshExpanded) end
            if _G.DeepAntiBat.refreshRuntime then pcall(_G.DeepAntiBat.refreshRuntime) end
        else
            stop404AntiBat()
        end
        if setInfJumpVisual then setInfJumpVisual(false) end 
        autoSwitchSpeedEnabled=false
        autoTurnOffSpeedEnabled=false
        autoSwitchLaggerSpeedEnabled=false
        stopAutoSwitchSpeed()
        if setAutoSwitchSpeedVisual then setAutoSwitchSpeedVisual(false) end
        if setAutoTurnOffSpeedVisual then setAutoTurnOffSpeedVisual(false) end
        if setAutoSwitchLaggerSpeedVisual then setAutoSwitchLaggerSpeedVisual(false) end 
        if cfg.fpsBoostEnabled then fpsBoostEnabled=true;if setFpsBoostVisual then setFpsBoostVisual(true) end;applyFPSBoost() end 
        if cfg.fovEnabled then fovEnabled=true;if setFovVisual then setFovVisual(true) end;setFovEnabled(true) end 
        if cfg.antiLag then enableAntiLag();if setAntiLagVisual then setAntiLagVisual(true) end end 
        if cfg.stretchRez then enableStretchRez();if setStretchRezVisual then setStretchRezVisual(true) end end 
    end) 
end 
loadConfigKeys() 
buildGui() 
loadConfigState() 
buildMobileButtons() 
UIS.InputBegan:Connect(function(input,gpe) 
    if _anyKeyListening then return end 
    if UIS:GetFocusedTextBox() then return end 
    if input.KeyCode==Enum.KeyCode.Unknown then return end 
    local kc=input.KeyCode 
    local function matches(entry) return entry and (kc==entry.kb) end 
    if matches(KB.Aimbot2) then setAimbot2(not _G.DeepBatV2ManualEnabled) pcall(saveConfig) end
    if matches(KB.AntiDesyncAimbot) then setTPAimbot(not tpAimbotEnabled) pcall(saveConfig) end
end) 
function openExeLaggerPanel() 
    local cg=game:GetService("CoreGui") 
    local old=cg:FindFirstChild("ExeLagger_UI") or cg:FindFirstChild("ExeLaggerPanel") 
    if old then old:Destroy();return end 
    local laggerScript=[===[ 
    local Players = game:GetService("Players") 
    local UserInputService = game:GetService("UserInputService") 
    local TweenService = game:GetService("TweenService") 
    local CoreGui = game:GetService("CoreGui") 
    local HttpService = game:GetService("HttpService") 
    local RunService = game:GetService("RunService") 
    local player = Players.LocalPlayer 
    local ConfigFile = "ExeMobileLaggerConfig.json" 
    local NIVELES = { 
        Low = { poder = 23 }, 
        Mid = { poder = 32 }, 
        High = { poder = 70 }, 
        Crazy = { poder = 90 } 
    } 
    local keybind = Enum.KeyCode.M 
    local laggerActive = false 
    local lagThread = nil 
    local nivelActual = "Low" 
    local ventanaBloqueada = false 
    local UI_CONFIG = { 
        White = Color3.fromRGB(255, 255, 255), 
        Black = Color3.fromRGB(0, 0, 0), 
        MainBg = Color3.fromRGB(0, 0, 0), 
        TitleColor = Color3.fromRGB(255, 255, 255), 
        TextColor = Color3.fromRGB(255, 255, 255), 
        ButtonInact = Color3.fromRGB(0, 0, 0), 
        ButtonLow = Color3.fromRGB(255, 255, 255), 
        ButtonMid = Color3.fromRGB(255, 255, 255), 
        ButtonHigh = Color3.fromRGB(255, 255, 255), 
        ButtonCrazy = Color3.fromRGB(255, 255, 255), 
        ToggleOff = Color3.fromRGB(0, 0, 0), 
        ToggleOn = Color3.fromRGB(255, 255, 255), 
        LockColor = Color3.fromRGB(255, 255, 255), 
        UnlockColor = Color3.fromRGB(0, 0, 0), 
        Font = Enum.Font.SciFi, 
        BorderColor = Color3.fromRGB(255, 255, 255), 
    } 
    local function SaveConfig() 
        local data = { 
            Nivel = nivelActual, 
            Bloqueado = ventanaBloqueada, 
            Keybind = keybind and keybind.Name or "M" 
        } 
        pcall(function() writefile(ConfigFile, HttpService:JSONEncode(data)) end) 
    end 
    local function LoadConfig() 
        if pcall(isfile, ConfigFile) and isfile(ConfigFile) then 
            pcall(function() 
                local data = HttpService:JSONDecode(readfile(ConfigFile)) 
                nivelActual = data.Nivel or "Low" 
                if nivelActual == "Ultra" then nivelActual = "Crazy" end 
                ventanaBloqueada = data.Bloqueado or false 
                if data.Keybind then 
                    for _,k in ipairs(Enum.KeyCode:GetEnumItems()) do 
                        if k.Name == data.Keybind then keybind = k break end 
                    end 
                end 
            end) 
        end 
    end 
    LoadConfig() 
    local function bomb(poder) 
        local main, spam = {}, {{}} 
        local z = spam[1] 
        for i = 1, 25 do 
            local t = {} 
            table.insert(z, t) 
            z = t 
        end 
        local max = math.min(12000, poder * 50) 
        for i = 1, max do 
            table.insert(main, spam) 
        end 
        pcall(function() game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main) end) 
    end 
    local toggleBall, toggleContainer, btnLow, btnMid, btnHigh, btnCrazy, lockButton 
    local titleLabel, textLagger, keybindTextBox, toggleClick 
    local function actualizarBotonesNivel() 
        if btnLow then 
            if nivelActual == "Low" then 
                btnLow.BackgroundColor3 = UI_CONFIG.ButtonLow 
                btnLow.TextColor3 = UI_CONFIG.Black 
                btnLow.BorderSizePixel = 1 
                btnLow.BorderColor3 = UI_CONFIG.BorderColor 
            else 
                btnLow.BackgroundColor3 = UI_CONFIG.ButtonInact 
                btnLow.TextColor3 = UI_CONFIG.White 
                btnLow.BorderSizePixel = 1 
                btnLow.BorderColor3 = UI_CONFIG.BorderColor 
            end 
        end 
        if btnMid then 
            if nivelActual == "Mid" then 
                btnMid.BackgroundColor3 = UI_CONFIG.ButtonMid 
                btnMid.TextColor3 = UI_CONFIG.Black 
                btnMid.BorderSizePixel = 1 
                btnMid.BorderColor3 = UI_CONFIG.BorderColor 
            else 
                btnMid.BackgroundColor3 = UI_CONFIG.ButtonInact 
                btnMid.TextColor3 = UI_CONFIG.White 
                btnMid.BorderSizePixel = 1 
                btnMid.BorderColor3 = UI_CONFIG.BorderColor 
            end 
        end 
        if btnHigh then 
            if nivelActual == "High" then 
                btnHigh.BackgroundColor3 = UI_CONFIG.ButtonHigh 
                btnHigh.TextColor3 = UI_CONFIG.Black 
                btnHigh.BorderSizePixel = 1 
                btnHigh.BorderColor3 = UI_CONFIG.BorderColor 
            else 
                btnHigh.BackgroundColor3 = UI_CONFIG.ButtonInact 
                btnHigh.TextColor3 = UI_CONFIG.White 
                btnHigh.BorderSizePixel = 1 
                btnHigh.BorderColor3 = UI_CONFIG.BorderColor 
            end 
        end 
        if btnCrazy then 
            if nivelActual == "Crazy" then 
                btnCrazy.BackgroundColor3 = UI_CONFIG.ButtonCrazy 
                btnCrazy.TextColor3 = UI_CONFIG.Black 
                btnCrazy.BorderSizePixel = 1 
                btnCrazy.BorderColor3 = UI_CONFIG.BorderColor 
            else 
                btnCrazy.BackgroundColor3 = UI_CONFIG.ButtonInact 
                btnCrazy.TextColor3 = UI_CONFIG.White 
                btnCrazy.BorderSizePixel = 1 
                btnCrazy.BorderColor3 = UI_CONFIG.BorderColor 
            end 
        end 
    end 
    local function actualizarSwitch() 
        if toggleContainer then toggleContainer.BackgroundColor3 = laggerActive and UI_CONFIG.ToggleOn or UI_CONFIG.ToggleOff end 
        if toggleBall then 
            toggleBall.BackgroundColor3 = laggerActive and UI_CONFIG.Black or UI_CONFIG.White 
            if laggerActive then toggleBall.Position = UDim2.new(1, -18, 0.5, -8) 
            else toggleBall.Position = UDim2.new(0, 2, 0.5, -8) end 
        end 
        if toggleClick then 
            toggleClick.Text = laggerActive and "ON" or "OFF" 
            toggleClick.TextColor3 = laggerActive and UI_CONFIG.Black or UI_CONFIG.White 
        end 
    end 
    local function actualizarCandado() 
        if lockButton then 
            lockButton.Text = ventanaBloqueada and "Locked" or "Unlocked" 
            if ventanaBloqueada then 
                lockButton.BackgroundColor3 = UI_CONFIG.LockColor 
                lockButton.TextColor3 = UI_CONFIG.Black 
            else 
                lockButton.BackgroundColor3 = UI_CONFIG.UnlockColor 
                lockButton.TextColor3 = UI_CONFIG.White 
            end 
        end 
    end 
    local function actualizarKeybindTextBox() 
        if keybindTextBox then keybindTextBox.Text = keybind.Name end 
    end 
    local function toggleLagger() 
        laggerActive = not laggerActive 
        local targetPos = laggerActive and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8) 
        if toggleBall then 
            TweenService:Create(toggleBall, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Position = targetPos }):Play() 
        end 
        actualizarSwitch() 
        if laggerActive then 
            if lagThread then task.cancel(lagThread) end 
            lagThread = task.spawn(function() 
                while laggerActive do 
                    pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(80000) end) 
                    bomb(NIVELES[nivelActual].poder) 
                    task.wait(0.18) 
                end 
            end) 
        else 
            if lagThread then task.cancel(lagThread); lagThread = nil end 
        end 
    end 
    if CoreGui:FindFirstChild("ExeLagger_UI") then CoreGui.ExeLagger_UI:Destroy() end 
    local screenGui = Instance.new("ScreenGui") 
    screenGui.Name = "ExeLagger_UI" 
    screenGui.Parent = CoreGui 
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling 
    screenGui.ResetOnSpawn = false 
    local mainFrame = Instance.new("Frame") 
    mainFrame.Name = "MainFrame" 
    mainFrame.BackgroundColor3 = UI_CONFIG.MainBg 
    mainFrame.BackgroundTransparency = 0 
    mainFrame.BorderSizePixel = 0 
    mainFrame.Size = UDim2.new(0, 200, 0, 110) 
    mainFrame.Position = UDim2.new(0.15, 0, 0.5, -55) 
    mainFrame.Parent = screenGui 
    mainFrame.ClipsDescendants = true 
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8) 
    local bgImage = Instance.new("ImageLabel") 
    bgImage.Name = "BgImage" 
    bgImage.Size = UDim2.new(1, 0, 1, 0) 
    bgImage.Position = UDim2.new(0, 0, 0, 0) 
    bgImage.BackgroundTransparency = 1 
    bgImage.Image = "rbxthumb://type=Asset&id=97069004530020&w=420&h=420" 
    bgImage.ImageColor3 = Color3.fromRGB(255, 255, 255) 
    bgImage.ImageTransparency = 0 
    bgImage.ScaleType = Enum.ScaleType.Stretch 
    bgImage.ZIndex = 1 
    bgImage.Parent = mainFrame 
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 8) 
    local bgOverlay = Instance.new("Frame") 
    bgOverlay.Name = "BgOverlay" 
    bgOverlay.Size = UDim2.new(1, 0, 1, 0) 
    bgOverlay.Position = UDim2.new(0, 0, 0, 0) 
    bgOverlay.BackgroundColor3 = UI_CONFIG.Black 
    bgOverlay.BackgroundTransparency = 0.82 
    bgOverlay.BorderSizePixel = 0 
    bgOverlay.ZIndex = 1 
    bgOverlay.Parent = mainFrame 
    Instance.new("UICorner", bgOverlay).CornerRadius = UDim.new(0, 8) 
    titleLabel = Instance.new("TextLabel", mainFrame) 
    titleLabel.BackgroundTransparency = 1 
    titleLabel.Position = UDim2.new(0, 8, 0, 4) 
    titleLabel.Size = UDim2.new(0, 140, 0, 25) 
    titleLabel.Font = UI_CONFIG.Font 
    titleLabel.Text = "DEEP DUELS" 
    titleLabel.TextColor3 = UI_CONFIG.TitleColor 
    titleLabel.TextSize = 13 
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left 
    titleLabel.TextYAlignment = Enum.TextYAlignment.Center 
    titleLabel.ZIndex = 3 
    -- Player avatar and name beside DEEP DUELS
    local playerAvatar = Instance.new("ImageLabel", mainFrame) 
    playerAvatar.Name = "PlayerAvatar" 
    playerAvatar.BackgroundTransparency = 1 
    playerAvatar.Size = UDim2.new(0, 24, 0, 24) 
    playerAvatar.Position = UDim2.new(0, 151, 0, 4) 
    playerAvatar.ZIndex = 4 
    playerAvatar.ScaleType = Enum.ScaleType.Crop 
    Instance.new("UICorner", playerAvatar).CornerRadius = UDim.new(1, 0) 
    local avatarStroke = Instance.new("UIStroke", playerAvatar) 
    avatarStroke.Color = UI_CONFIG.BorderColor 
    avatarStroke.Thickness = 1 
    pcall(function()
        playerAvatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LP.UserId) .. "&w=100&h=100" 
    end) 
    local playerNameLabel = Instance.new("TextLabel", mainFrame) 
    playerNameLabel.Name = "PlayerName" 
    playerNameLabel.BackgroundTransparency = 1 
    playerNameLabel.Position = UDim2.new(0, 179, 0, 4) 
    playerNameLabel.Size = UDim2.new(0, 95, 0, 24) 
    playerNameLabel.Font = UI_CONFIG.Font 
    playerNameLabel.Text = tostring(LP.DisplayName or LP.Name) 
    playerNameLabel.TextColor3 = UI_CONFIG.White 
    playerNameLabel.TextSize = 10 
    playerNameLabel.TextXAlignment = Enum.TextXAlignment.Left 
    playerNameLabel.TextYAlignment = Enum.TextYAlignment.Center 
    playerNameLabel.TextTruncate = Enum.TextTruncate.AtEnd 
    playerNameLabel.ZIndex = 4 
    local closeBtn = Instance.new("TextButton", mainFrame) 
    closeBtn.Name = "CloseButton" 
    closeBtn.Size = UDim2.new(0, 22, 0, 22) 
    closeBtn.Position = UDim2.new(1, -26, 0, 4) 
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 35, 55) 
    closeBtn.BorderSizePixel = 0 
    closeBtn.Text = "X" 
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255) 
    closeBtn.Font = UI_CONFIG.Font 
    closeBtn.TextSize = 11 
    closeBtn.ZIndex = 4 
    closeBtn.AutoButtonColor = false 
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0) 
    closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(255, 60, 80)}):Play() end) 
    closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(220, 35, 55)}):Play() end) 
    closeBtn.MouseButton1Click:Connect(function() laggerActive = false if lagThread then task.cancel(lagThread); lagThread = nil end pcall(function() screenGui:Destroy() end) end) 
    lockButton = Instance.new("TextButton", mainFrame) 
    lockButton.BackgroundColor3 = UI_CONFIG.UnlockColor 
    lockButton.BackgroundTransparency = 0.55 
    lockButton.BorderSizePixel = 1 
    lockButton.BorderColor3 = UI_CONFIG.BorderColor 
    lockButton.Position = UDim2.new(1, -58, 0, 4) 
    lockButton.Size = UDim2.new(0, 28, 0, 16) 
    lockButton.Font = UI_CONFIG.Font 
    lockButton.TextSize = 8 
    lockButton.TextColor3 = UI_CONFIG.White 
    lockButton.AutoButtonColor = false 
    lockButton.ZIndex = 2 
    Instance.new("UICorner", lockButton).CornerRadius = UDim.new(0, 4) 
    lockButton.MouseButton1Click:Connect(function() ventanaBloqueada = not ventanaBloqueada actualizarCandado() SaveConfig() end) 
    actualizarCandado() 
    textLagger = Instance.new("TextLabel", mainFrame) 
    textLagger.BackgroundTransparency = 1 
    textLagger.Position = UDim2.new(0, 6, 0, 34) 
    textLagger.Size = UDim2.new(0, 60, 0, 20) 
    textLagger.Font = UI_CONFIG.Font 
    textLagger.Text = "LAGGER" 
    textLagger.TextColor3 = UI_CONFIG.TextColor 
    textLagger.TextSize = 11 
    textLagger.TextXAlignment = Enum.TextXAlignment.Left 
    textLagger.TextYAlignment = Enum.TextYAlignment.Center 
    textLagger.ZIndex = 2 
    keybindTextBox = Instance.new("TextBox", mainFrame) 
    keybindTextBox.Name = "KeybindTextBox" 
    keybindTextBox.BackgroundColor3 = UI_CONFIG.Black 
    keybindTextBox.BackgroundTransparency = 0.55 
    keybindTextBox.BorderSizePixel = 1 
    keybindTextBox.BorderColor3 = UI_CONFIG.BorderColor 
    keybindTextBox.Position = UDim2.new(0, 70, 0, 34) 
    keybindTextBox.Size = UDim2.new(0, 45, 0, 20) 
    keybindTextBox.Font = UI_CONFIG.Font 
    keybindTextBox.Text = keybind.Name 
    keybindTextBox.TextColor3 = UI_CONFIG.White 
    keybindTextBox.TextSize = 10 
    keybindTextBox.ClearTextOnFocus = true 
    keybindTextBox.ZIndex = 2 
    Instance.new("UICorner", keybindTextBox).CornerRadius = UDim.new(0, 4) 
    local function actualizarKeybind() 
        local text = keybindTextBox.Text 
        local cleanText = text:gsub("%s+", ""):upper() 
        local foundKey = nil 
        for _, item in ipairs(Enum.KeyCode:GetEnumItems()) do 
            if item.Name:upper() == cleanText then foundKey = item break end 
        end 
        if foundKey then keybind = foundKey SaveConfig() end 
        keybindTextBox.Text = keybind.Name 
    end 
    keybindTextBox.FocusLost:Connect(function(enterPressed) actualizarKeybind() end) 
    toggleContainer = Instance.new("Frame", mainFrame) 
    toggleContainer.BackgroundColor3 = UI_CONFIG.ToggleOff 
    toggleContainer.BackgroundTransparency = 0.55 
    toggleContainer.BorderSizePixel = 1 
    toggleContainer.BorderColor3 = UI_CONFIG.BorderColor 
    toggleContainer.Position = UDim2.new(1, -54, 0, 34) 
    toggleContainer.Size = UDim2.new(0, 48, 0, 20) 
    toggleContainer.ZIndex = 2 
    Instance.new("UICorner", toggleContainer).CornerRadius = UDim.new(1, 0) 
    toggleBall = Instance.new("Frame", toggleContainer) 
    toggleBall.BackgroundColor3 = UI_CONFIG.White 
    toggleBall.BackgroundTransparency = 0.55 
    toggleBall.BorderSizePixel = 0 
    toggleBall.Size = UDim2.new(0, 16, 0, 16) 
    toggleBall.Position = UDim2.new(0, 2, 0.5, -8) 
    toggleBall.ZIndex = 2 
    Instance.new("UICorner", toggleBall).CornerRadius = UDim.new(1, 0) 
    toggleClick = Instance.new("TextButton", toggleContainer) 
    toggleClick.BackgroundTransparency = 1 
    toggleClick.Size = UDim2.new(1, 0, 1, 0) 
    toggleClick.ZIndex = 3 
    toggleClick.Font = UI_CONFIG.Font 
    toggleClick.Text = "OFF" 
    toggleClick.TextSize = 8 
    toggleClick.TextColor3 = UI_CONFIG.White 
    toggleClick.TextXAlignment = Enum.TextXAlignment.Center 
    toggleClick.TextYAlignment = Enum.TextYAlignment.Center 
    toggleClick.MouseButton1Click:Connect(toggleLagger) 
    toggleClick.AutoButtonColor = false 
    local btnY = 75 
    local btnW = 44 
    local btnH = 22 
    local espaciado = 4 
    local margenIzq = 6 
    btnLow = Instance.new("TextButton", mainFrame) 
    btnLow.Size = UDim2.new(0, btnW, 0, btnH) 
    btnLow.Position = UDim2.new(0, margenIzq, 0, btnY) 
    btnLow.Font = UI_CONFIG.Font 
    btnLow.Text = "LOW" 
    btnLow.TextColor3 = UI_CONFIG.White 
    btnLow.TextSize = 9 
    btnLow.AutoButtonColor = false 
    btnLow.BackgroundColor3 = UI_CONFIG.ButtonInact 
    btnLow.BackgroundTransparency = 0.55 
    btnLow.BorderSizePixel = 1 
    btnLow.BorderColor3 = UI_CONFIG.BorderColor 
    btnLow.ZIndex = 2 
    Instance.new("UICorner", btnLow).CornerRadius = UDim.new(0, 6) 
    btnLow.MouseButton1Click:Connect(function() nivelActual = "Low" actualizarBotonesNivel() SaveConfig() end) 
    btnMid = Instance.new("TextButton", mainFrame) 
    btnMid.Size = UDim2.new(0, btnW, 0, btnH) 
    btnMid.Position = UDim2.new(0, margenIzq + btnW + espaciado, 0, btnY) 
    btnMid.Font = UI_CONFIG.Font 
    btnMid.Text = "MID" 
    btnMid.TextColor3 = UI_CONFIG.White 
    btnMid.TextSize = 9 
    btnMid.AutoButtonColor = false 
    btnMid.BackgroundColor3 = UI_CONFIG.ButtonInact 
    btnMid.BackgroundTransparency = 0.55 
    btnMid.BorderSizePixel = 1 
    btnMid.BorderColor3 = UI_CONFIG.BorderColor 
    btnMid.ZIndex = 2 
    Instance.new("UICorner", btnMid).CornerRadius = UDim.new(0, 6) 
    btnMid.MouseButton1Click:Connect(function() nivelActual = "Mid" actualizarBotonesNivel() SaveConfig() end) 
    btnHigh = Instance.new("TextButton", mainFrame) 
    btnHigh.Size = UDim2.new(0, btnW, 0, btnH) 
    btnHigh.Position = UDim2.new(0, margenIzq + (btnW + espaciado) * 2, 0, btnY) 
    btnHigh.Font = UI_CONFIG.Font 
    btnHigh.Text = "HIGH" 
    btnHigh.TextColor3 = UI_CONFIG.White 
    btnHigh.TextSize = 9 
    btnHigh.AutoButtonColor = false 
    btnHigh.BackgroundColor3 = UI_CONFIG.ButtonInact 
    btnHigh.BackgroundTransparency = 0.55 
    btnHigh.BorderSizePixel = 1 
    btnHigh.BorderColor3 = UI_CONFIG.BorderColor 
    btnHigh.ZIndex = 2 
    Instance.new("UICorner", btnHigh).CornerRadius = UDim.new(0, 6) 
    btnHigh.MouseButton1Click:Connect(function() nivelActual = "High" actualizarBotonesNivel() SaveConfig() end) 
    btnCrazy = Instance.new("TextButton", mainFrame) 
    btnCrazy.Size = UDim2.new(0, btnW, 0, btnH) 
    btnCrazy.Position = UDim2.new(0, margenIzq + (btnW + espaciado) * 4, 0, btnY) 
    btnCrazy.Font = UI_CONFIG.Font 
    btnCrazy.Text = "CRAZY" 
    btnCrazy.TextColor3 = UI_CONFIG.White 
    btnCrazy.TextSize = 7 
    btnCrazy.AutoButtonColor = false 
    btnCrazy.BackgroundColor3 = UI_CONFIG.ButtonInact 
    btnCrazy.BackgroundTransparency = 0.55 
    btnCrazy.BorderSizePixel = 1 
    btnCrazy.BorderColor3 = UI_CONFIG.BorderColor 
    btnCrazy.ZIndex = 2 
    Instance.new("UICorner", btnCrazy).CornerRadius = UDim.new(0, 6) 
    btnCrazy.MouseButton1Click:Connect(function() nivelActual = "Crazy" actualizarBotonesNivel() SaveConfig() end) 
    actualizarBotonesNivel() 
    actualizarSwitch() 
    actualizarCandado() 
    actualizarKeybindTextBox() 
    local isDragging, dragStart, startPos = false, nil, nil 
    mainFrame.InputBegan:Connect(function(input) 
        if ventanaBloqueada then return end 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            isDragging = true 
            dragStart = input.Position 
            startPos = mainFrame.Position 
        end 
    end) 
    UserInputService.InputChanged:Connect(function(input) 
        if not isDragging or ventanaBloqueada then return end 
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then 
            local delta = input.Position - dragStart 
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y) 
        end 
    end) 
    mainFrame.InputEnded:Connect(function(input) 
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
            isDragging = false 
        end 
    end) 
    UserInputService.InputBegan:Connect(function(input, gp) 
        if not screenGui.Parent then return end 
        if gp then return end 
        if UserInputService:GetFocusedTextBox() then return end 
        if input.KeyCode == keybind then toggleLagger() end 
    end) 
    ]===] 
    local ok,err=pcall(function() loadstring(laggerScript)() end) 
    if not ok then warn("DEEP DUELS LAGGER ERROR",err) end 
end 
function exeStartKeyListen(btn,onSet) 
    if not btn or btn:GetAttribute("Listening") then return end 
    btn:SetAttribute("Listening",true) 
    _anyKeyListening=true 
    local prev=btn.Text 
    btn.Text="..." 
    btn.TextColor3=Color3.fromRGB(255,255,255) 
    local started=tick() 
    local conn 
    conn=UIS.InputBegan:Connect(function(inp) 
        if inp.KeyCode==Enum.KeyCode.Escape then 
            if conn then conn:Disconnect() end 
            btn:SetAttribute("Listening",false);_anyKeyListening=false;btn.Text=prev 
            return 
        end 
        if inp.UserInputType~=Enum.UserInputType.Keyboard then return end 
        if conn then conn:Disconnect() end 
        btn:SetAttribute("Listening",false);_anyKeyListening=false 
        btn.Text=inp.KeyCode.Name:upper() 
        if onSet then onSet(inp.KeyCode) end 
    end) 
end 
function setFovEnabled(on) 
    fovEnabled=on 
    if on then 
        if fovConn then fovConn:Disconnect() end 
        fovConn=RunService.RenderStepped:Connect(function() 
            if not fovEnabled then if fovConn then fovConn:Disconnect();fovConn=nil end;return end 
            if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=fovValue end 
        end) 
    else 
        if fovConn then fovConn:Disconnect();fovConn=nil end 
        if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=70 end 
    end 
end 
function resetFovAndCamera() 
    setFovEnabled(false) 
    if stretchRezEnabled then disableStretchRez();if setStretchRezVisual then setStretchRezVisual(false) end end 
    if workspace.CurrentCamera then workspace.CurrentCamera.FieldOfView=70 end 
end 

-- ============================================================
-- ============================================================
-- COMPATIBILITY MODE
-- Hooks de Kick/__namecall removidos para evitar incompatibilidade
-- com executores/proteções como Pol Sec.
-- ============================================================

print("DEEP DUELS - discord.gg/deT7abF96")
