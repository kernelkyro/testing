--[[
    ███╗   ██╗ ██████╗ ██╗   ██╗██╗   ██╗███████╗
    ████╗  ██║██╔═══██╗██║   ██║██║   ██║██╔════╝
    ██╔██╗ ██║██║   ██║██║   ██║██║   ██║███████╗
    ██║╚██╗██║██║   ██║╚██╗ ██╔╝██║   ██║╚════██║
    ██║ ╚████║╚██████╔╝ ╚████╔╝ ╚██████╔╝███████║
    ╚═╝  ╚═══╝ ╚═════╝   ╚═══╝   ╚═════╝ ╚══════╝
                N O V U S   H U B
    Rivals Script | PC + Mobile | by epileptichurts
]]

--// SERVICES
local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local UIS               = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local CoreGui           = game:GetService("CoreGui")
local StarterGui        = game:GetService("StarterGui")
local Camera            = workspace.CurrentCamera
local LocalPlayer       = Players.LocalPlayer

--// CONFIG
local Config = {
    -- Aimbot
    Aimbot          = false,
    AimKey          = Enum.UserInputType.MouseButton2,
    AimSmoothness   = 0.15,
    AimFOV          = 120,
    AimTeamCheck    = true,
    AimWallCheck    = false,
    AimPart         = "HumanoidRootPart",
    -- Silent Aim
    SilentAim       = false,
    SilentFOV       = 150,
    SilentHitChance = 100,
    -- ESP
    ESP             = false,
    ESPBox          = true,
    ESPName         = true,
    ESPHealth       = true,
    ESPDistance     = true,
    ESPTracer       = false,
    ESPTeamCheck    = true,
    -- Movement
    SpeedEnabled    = false,
    SpeedValue      = 32,
    JumpEnabled     = false,
    JumpValue       = 80,
    FlyEnabled      = false,
    FlySpeed        = 60,
    -- Misc
    Fullbright      = false,
    NoClip          = false,
}

--// CLEANUP OLD INSTANCE
if CoreGui:FindFirstChild("NovusHub") then
    CoreGui.NovusHub:Destroy()
end
if game:GetService("ReplicatedStorage"):FindFirstChild("NovusHub_Old") then
    game:GetService("ReplicatedStorage").NovusHub_Old:Destroy()
end

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NovusHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function protect(gui)
    if gethui then
        gui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = CoreGui
    else
        gui.Parent = CoreGui
    end
end
protect(ScreenGui)

--// THEME
local Theme = {
    Bg          = Color3.fromRGB(14, 14, 20),
    Bg2         = Color3.fromRGB(20, 20, 30),
    Panel       = Color3.fromRGB(24, 24, 36),
    Border      = Color3.fromRGB(60, 40, 120),
    Accent      = Color3.fromRGB(138, 92, 246),
    Accent2     = Color3.fromRGB(236, 72, 153),
    Text        = Color3.fromRGB(230, 230, 240),
    SubText     = Color3.fromRGB(150, 150, 170),
    Off         = Color3.fromRGB(50, 50, 65),
    On          = Color3.fromRGB(138, 92, 246),
}

--// MAIN FRAME
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 560, 0, 380)
Main.Position = UDim2.new(0.5, -280, 0.5, -190)
Main.BackgroundColor3 = Theme.Bg
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Border
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.3
MainStroke.Parent = Main

-- Animated gradient background
local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Theme.Bg),
    ColorSequenceKeypoint.new(0.5, Theme.Bg2),
    ColorSequenceKeypoint.new(1, Theme.Bg),
}
Gradient.Rotation = 45
Gradient.Parent = Main

task.spawn(function()
    while Main.Parent do
        for i = 0, 360, 2 do
            Gradient.Rotation = i
            task.wait(0.03)
        end
    end
end)

--// TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 44)
TopBar.BackgroundColor3 = Theme.Bg2
TopBar.BackgroundTransparency = 0.2
TopBar.BorderSizePixel = 0
TopBar.Parent = Main

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 12)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 12)
TopFix.Position = UDim2.new(0, 0, 1, -12)
TopFix.BackgroundColor3 = Theme.Bg2
TopFix.BackgroundTransparency = 0.2
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

-- Glow dot
local Dot = Instance.new("Frame")
Dot.Size = UDim2.new(0, 10, 0, 10)
Dot.Position = UDim2.new(0, 16, 0.5, -5)
Dot.BackgroundColor3 = Theme.Accent
Dot.BorderSizePixel = 0
Dot.Parent = TopBar
Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

local DotGlow = Instance.new("ImageLabel")
DotGlow.Size = UDim2.new(0, 40, 0, 40)
DotGlow.Position = UDim2.new(0, 1, 0.5, -20)
DotGlow.BackgroundTransparency = 1
DotGlow.Image = "rbxassetid://5028857084"
DotGlow.ImageColor3 = Theme.Accent
DotGlow.ImageTransparency = 0.5
DotGlow.Parent = TopBar

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Position = UDim2.new(0, 34, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "NOVUS"
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.TextColor3 = Theme.Text
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TopBar

local TitleAccent = Instance.new("TextLabel")
TitleAccent.Size = UDim2.new(0, 80, 1, 0)
TitleAccent.Position = UDim2.new(0, 108, 0, 0)
TitleAccent.BackgroundTransparency = 1
TitleAccent.Text = "HUB"
TitleAccent.Font = Enum.Font.GothamBlack
TitleAccent.TextSize = 20
TitleAccent.TextColor3 = Theme.Accent
TitleAccent.TextXAlignment = Enum.TextXAlignment.Left
TitleAccent.Parent = TopBar

local TitleGrad = Instance.new("UIGradient")
TitleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Theme.Accent),
    ColorSequenceKeypoint.new(1, Theme.Accent2),
}
TitleGrad.Parent = TitleAccent

-- Close button
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0.5, -15)
CloseBtn.BackgroundColor3 = Theme.Off
CloseBtn.Text = "✕"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.TextColor3 = Theme.Text
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = TopBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 8)

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220, 60, 60)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.15), {BackgroundColor3 = Theme.Off}):Play()
end)

-- Minimize button
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -74, 0.5, -15)
MinBtn.BackgroundColor3 = Theme.Off
MinBtn.Text = "—"
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 14
MinBtn.TextColor3 = Theme.Text
MinBtn.AutoButtonColor = false
MinBtn.Parent = TopBar
Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0, 8)

--// SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 140, 1, -54)
Sidebar.Position = UDim2.new(0, 10, 0, 48)
Sidebar.BackgroundColor3 = Theme.Panel
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 10)

local SidebarLayout = Instance.new("UIListLayout")
SidebarLayout.Padding = UDim.new(0, 6)
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder
SidebarLayout.Parent = Sidebar

local SidebarPad = Instance.new("UIPadding")
SidebarPad.PaddingTop = UDim.new(0, 8)
SidebarPad.PaddingLeft = UDim.new(0, 8)
SidebarPad.PaddingRight = UDim.new(0, 8)
SidebarPad.Parent = Sidebar

--// CONTENT AREA
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -160, 1, -54)
Content.Position = UDim2.new(0, 150, 0, 48)
Content.BackgroundColor3 = Theme.Panel
Content.BackgroundTransparency = 0.3
Content.BorderSizePixel = 0
Content.Parent = Main
Instance.new("UICorner", Content).CornerRadius = UDim.new(0, 10)

local ContentScroll = Instance.new("ScrollingFrame")
ContentScroll.Size = UDim2.new(1, -16, 1, -16)
ContentScroll.Position = UDim2.new(0, 8, 0, 8)
ContentScroll.BackgroundTransparency = 1
ContentScroll.BorderSizePixel = 0
ContentScroll.ScrollBarThickness = 3
ContentScroll.ScrollBarImageColor3 = Theme.Accent
ContentScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
ContentScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
ContentScroll.Parent = Content

local ContentLayout = Instance.new("UIListLayout")
ContentLayout.Padding = UDim.new(0, 6)
ContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
ContentLayout.Parent = ContentScroll

--// PAGES
local Pages = {}
local CurrentPage = nil

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, -16, 1, -16)
    Page.Position = UDim2.new(0, 8, 0, 8)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = Theme.Accent
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    Page.Visible = false
    Page.Parent = Content

    local Layout = Instance.new("UIListLayout")
    Layout.Padding = UDim.new(0, 6)
    Layout.SortOrder = Enum.SortOrder.LayoutOrder
    Layout.Parent = Page

    Pages[name] = Page
    return Page
end

--// UI BUILDERS
local function MakeToggle(parent, text, default, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -8, 0, 34)
    Btn.BackgroundColor3 = Theme.Bg2
    Btn.BackgroundTransparency = 0.2
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.Parent = parent
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextColor3 = Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Btn

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(0, 36, 0, 18)
    Track.Position = UDim2.new(1, -48, 0.5, -9)
    Track.BackgroundColor3 = Theme.Off
    Track.BorderSizePixel = 0
    Track.Parent = Btn
    Instance.new("UICorner", Track).CornerRadius = UDim.new(1, 0)

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = UDim2.new(0, 2, 0.5, -7)
    Knob.BackgroundColor3 = Theme.Text
    Knob.BorderSizePixel = 0
    Knob.Parent = Track
    Instance.new("UICorner", Knob).CornerRadius = UDim.new(1, 0)

    local state = default
    local function setState(v)
        state = v
        TweenService:Create(Track, TweenInfo.new(0.2), {
            BackgroundColor3 = v and Theme.On or Theme.Off
        }):Play()
        TweenService:Create(Knob, TweenInfo.new(0.2), {
            Position = v and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        }):Play()
        if callback then callback(v) end
    end

    Btn.MouseButton1Click:Connect(function() setState(not state) end)
    setState(default)

    return {
        Set = setState,
        Get = function() return state end,
        Instance = Btn,
    }
end

local function MakeSlider(parent, text, min, max, default, callback)
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(1, -8, 0, 50)
    Frame.BackgroundColor3 = Theme.Bg2
    Frame.BackgroundTransparency = 0.2
    Frame.Parent = parent
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -60, 0, 20)
    Label.Position = UDim2.new(0, 12, 0, 6)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextColor3 = Theme.Text
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -58, 0, 6)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = tostring(default)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 13
    ValueLabel.TextColor3 = Theme.Accent
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Frame

    local Bar = Instance.new("Frame")
    Bar.Size = UDim2.new(1, -24, 0, 6)
    Bar.Position = UDim2.new(0, 12, 1, -18)
    Bar.BackgroundColor3 = Theme.Off
    Bar.BorderSizePixel = 0
    Bar.Parent = Frame
    Instance.new("UICorner", Bar).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Theme.Accent
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local FillGrad = Instance.new("UIGradient")
    FillGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(1, Theme.Accent2),
    }
    FillGrad.Parent = Fill

    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * rel + 0.5)
        ValueLabel.Text = tostring(val)
        TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(rel, 0, 1, 0)}):Play()
        if callback then callback(val) end
    end

    Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            update(input)
        end
    end)
    Bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)

    return {
        Set = function(v)
            local rel = (v - min) / (max - min)
            ValueLabel.Text = tostring(v)
            Fill.Size = UDim2.new(rel, 0, 1, 0)
            if callback then callback(v) end
        end,
    }
end

local function MakeButton(parent, text, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -8, 0, 34)
    Btn.BackgroundColor3 = Theme.Accent
    Btn.Text = text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.TextColor3 = Color3.new(1, 1, 1)
    Btn.AutoButtonColor = false
    Btn.Parent = parent
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    local Grad = Instance.new("UIGradient")
    Grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(1, Theme.Accent2),
    }
    Grad.Parent = Btn

    Btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    return Btn
end

local function MakeLabel(parent, text)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -8, 0, 22)
    L.BackgroundTransparency = 1
    L.Text = text
    L.Font = Enum.Font.GothamBold
    L.TextSize = 12
    L.TextColor3 = Theme.SubText
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = parent
    return L
end

--// SIDEBAR TABS
local Tabs = {
    {name = "Combat", icon = "⚔"},
    {name = "Visuals", icon = "👁"},
    {name = "Movement", icon = "🏃"},
    {name = "Misc", icon = "⚙"},
    {name = "Settings", icon = "🔧"},
}
local TabButtons = {}

local function SelectTab(name)
    for _, page in pairs(Pages) do page.Visible = false end
    if Pages[name] then Pages[name].Visible = true end
    CurrentPage = name
    for tabName, btn in pairs(TabButtons) do
        local active = tabName == name
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundColor3 = active and Theme.Accent or Theme.Bg2
        }):Play()
        btn.TextColor3 = active and Color3.new(1,1,1) or Theme.Text
    end
end

for _, tab in ipairs(Tabs) do
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 34)
    Btn.BackgroundColor3 = Theme.Bg2
    Btn.Text = "  " .. tab.icon .. "  " .. tab.name
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 13
    Btn.TextColor3 = Theme.Text
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.AutoButtonColor = false
    Btn.Parent = Sidebar
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 8)

    Btn.MouseButton1Click:Connect(function() SelectTab(tab.name) end)
    TabButtons[tab.name] = Btn
    CreatePage(tab.name)
end

--// =================== COMBAT PAGE ===================
local Combat = Pages["Combat"]
MakeLabel(Combat, "AIMBOT")
MakeToggle(Combat, "Enable Aimbot", Config.Aimbot, function(v) Config.Aimbot = v end)
MakeToggle(Combat, "Team Check", Config.AimTeamCheck, function(v) Config.AimTeamCheck = v end)
MakeToggle(Combat, "Wall Check", Config.AimWallCheck, function(v) Config.AimWallCheck = v end)
MakeSlider(Combat, "Aim FOV", 10, 500, Config.AimFOV, function(v) Config.AimFOV = v end)
MakeSlider(Combat, "Smoothness", 1, 100, 15, function(v) Config.AimSmoothness = v / 100 end)

MakeLabel(Combat, "SILENT AIM")
MakeToggle(Combat, "Enable Silent Aim", Config.SilentAim, function(v) Config.SilentAim = v end)
MakeSlider(Combat, "Silent FOV", 10, 500, Config.SilentFOV, function(v) Config.SilentFOV = v end)
MakeSlider(Combat, "Hit Chance %", 1, 100, Config.SilentHitChance, function(v) Config.SilentHitChance = v end)

--// =================== VISUALS PAGE ===================
local Visuals = Pages["Visuals"]
MakeLabel(Visuals, "ESP")
MakeToggle(Visuals, "Enable ESP", Config.ESP, function(v) Config.ESP = v end)
MakeToggle(Visuals, "Box", Config.ESPBox, function(v) Config.ESPBox = v end)
MakeToggle(Visuals, "Name", Config.ESPName, function(v) Config.ESPName = v end)
MakeToggle(Visuals, "Health", Config.ESPHealth, function(v) Config.ESPHealth = v end)
MakeToggle(Visuals, "Distance", Config.ESPDistance, function(v) Config.ESPDistance = v end)
MakeToggle(Visuals, "Tracer", Config.ESPTracer, function(v) Config.ESPTracer = v end)
MakeToggle(Visuals, "Team Check", Config.ESPTeamCheck, function(v) Config.ESPTeamCheck = v end)
MakeLabel(Visuals, "WORLD")
MakeToggle(Visuals, "Fullbright", Config.Fullbright, function(v)
    Config.Fullbright = v
    if v then
        game:GetService("Lighting").Brightness = 3
        game:GetService("Lighting").Ambient = Color3.fromRGB(200, 200, 200)
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(200, 200, 200)
    else
        game:GetService("Lighting").Brightness = 2
        game:GetService("Lighting").Ambient = Color3.fromRGB(70, 70, 70)
        game:GetService("Lighting").OutdoorAmbient = Color3.fromRGB(128, 128, 128)
    end
end)

--// =================== MOVEMENT PAGE ===================
local Movement = Pages["Movement"]
MakeLabel(Movement, "SPEED")
MakeToggle(Movement, "Enable Speed", Config.SpeedEnabled, function(v) Config.SpeedEnabled = v end)
MakeSlider(Movement, "Speed Value", 16, 200, Config.SpeedValue, function(v) Config.SpeedValue = v end)
MakeLabel(Movement, "JUMP")
MakeToggle(Movement, "Enable Jump Power", Config.JumpEnabled, function(v) Config.JumpEnabled = v end)
MakeSlider(Movement, "Jump Value", 50, 300, Config.JumpValue, function(v) Config.JumpValue = v end)
MakeLabel(Movement, "FLY")
MakeToggle(Movement, "Enable Fly", Config.FlyEnabled, function(v) Config.FlyEnabled = v end)
MakeSlider(Movement, "Fly Speed", 10, 300, Config.FlySpeed, function(v) Config.FlySpeed = v end)

--// =================== MISC PAGE ===================
local Misc = Pages["Misc"]
MakeLabel(Misc, "CHARACTER")
MakeToggle(Misc, "NoClip", Config.NoClip, function(v) Config.NoClip = v end)
MakeButton(Misc, "Reset Character", function()
    LocalPlayer.Character:BreakJoints()
end)
MakeButton(Misc, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)
MakeButton(Misc, "Server Hop", function()
    local Http = game:GetService("HttpService")
    local ok, res = pcall(function()
        return Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    if ok and res and res.data then
        for _, s in ipairs(res.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                return
            end
        end
    end
end)

--// =================== SETTINGS PAGE ===================
local Settings = Pages["Settings"]
MakeLabel(Settings, "UI")
MakeButton(Settings, "Toggle UI", function()
    Main.Visible = not Main.Visible
end)
MakeButton(Settings, "Rejoin", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)
MakeLabel(Settings, "INFO")
local InfoLabel = MakeLabel(Settings, "Novus Hub v1.0 — by epileptichurts")
InfoLabel.TextSize = 11

--// =================== ESP SYSTEM ===================
local ESPObjects = {}
local Drawings = {}
local hasDrawing = pcall(function() return Drawing.new("Square") end)

if hasDrawing then
    local function newDrawing(plr)
        local data = {}
        data.Box = Drawing.new("Square")
        data.Box.Thickness = 1
        data.Box.Color = Color3.fromRGB(138, 92, 246)
        data.Box.Filled = false
        data.Box.Visible = false

        data.Name = Drawing.new("Text")
        data.Name.Size = 14
        data.Name.Center = true
        data.Name.Outline = true
        data.Name.Color = Color3.fromRGB(255, 255, 255)
        data.Name.Visible = false

        data.Health = Drawing.new("Text")
        data.Health.Size = 12
        data.Health.Center = true
        data.Health.Outline = true
        data.Health.Color = Color3.fromRGB(0, 255, 0)
        data.Health.Visible = false

        data.Distance = Drawing.new("Text")
        data.Distance.Size = 12
        data.Distance.Center = true
        data.Distance.Outline = true
        data.Distance.Color = Color3.fromRGB(200, 200, 200)
        data.Distance.Visible = false

        data.Tracer = Drawing.new("Line")
        data.Tracer.Thickness = 1
        data.Tracer.Color = Color3.fromRGB(236, 72, 153)
        data.Tracer.Visible = false

        Drawings[plr] = data
    end

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then newDrawing(p) end
    end
    Players.PlayerAdded:Connect(function(p) newDrawing(p) end)
    Players.PlayerRemoving:Connect(function(p)
        if Drawings[p] then
            for _, d in pairs(Drawings[p]) do
                pcall(function() d:Remove() end)
            end
            Drawings[p] = nil
        end
    end)
end

--// =================== MAIN LOOP ===================
local lastAim = 0
RunService.RenderStepped:Connect(function(dt)
    -- ESP
    for plr, data in pairs(Drawings) do
        local char = plr.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        local show = Config.ESP and hrp and hum and hum.Health > 0
        if Config.ESPTeamCheck and plr.Team == LocalPlayer.Team then show = false end

        if not show then
            data.Box.Visible = false
            data.Name.Visible = false
            data.Health.Visible = false
            data.Distance.Visible = false
            data.Tracer.Visible = false
            continue
        end

        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen or pos.Z < 0 then
            data.Box.Visible = false
            data.Name.Visible = false
            data.Health.Visible = false
            data.Distance.Visible = false
            data.Tracer.Visible = false
            continue
        end

        local size = Vector2.new(
            (Camera.ViewportSize.Y / pos.Z) * 1.8,
            (Camera.ViewportSize.Y / pos.Z) * 3
        )
        local topLeft = Vector2.new(pos.X - size.X / 2, pos.Y - size.Y / 2)

        if Config.ESPBox then
            data.Box.Size = size
            data.Box.Position = topLeft
            data.Box.Visible = true
        else
            data.Box.Visible = false
        end

        if Config.ESPName then
            data.Name.Position = Vector2.new(pos.X, topLeft.Y - 18)
            data.Name.Text = plr.Name
            data.Name.Visible = true
        else
            data.Name.Visible = false
        end

        if Config.ESPHealth then
            data.Health.Position = Vector2.new(pos.X, topLeft.Y + size.Y + 2)
            data.Health.Text = tostring(math.floor(hum.Health)) .. " HP"
            data.Health.Visible = true
        else
            data.Health.Visible = false
        end

        if Config.ESPDistance then
            local d = math.floor((Camera.CFrame.Position - hrp.Position).Magnitude)
            data.Distance.Position = Vector2.new(pos.X, topLeft.Y + size.Y + 16)
            data.Distance.Text = "[" .. d .. " studs]"
            data.Distance.Visible = true
        else
            data.Distance.Visible = false
        end

        if Config.ESPTracer then
            data.Tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            data.Tracer.To = Vector2.new(pos.X, pos.Y)
            data.Tracer.Visible = true
        else
            data.Tracer.Visible = false
        end
    end
end)

--// =================== AIMBOT ===================
local aiming = false
local function getTarget()
    local closest, dist = nil, Config.AimFOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer then continue end
        local char = plr.Character
        if not char then continue end
        local hrp = char:FindFirstChild(Config.AimPart)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then continue end
        if Config.AimTeamCheck and plr.Team == LocalPlayer.Team then continue end

        if Config.AimWallCheck then
            local ray = Ray.new(Camera.CFrame.Position, (hrp.Position - Camera.CFrame.Position).Unit * 500)
            local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character, Camera})
            if hit and not hit:IsDescendantOf(char) then continue end
        end

        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if onScreen then
            local mag = (Vector2.new(pos.X, pos.Y) - Camera.ViewportSize / 2).Magnitude
            if mag < dist then
                dist = mag
                closest = hrp
            end
        end
    end
    return closest
end

UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Config.AimKey then aiming = true end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Config.AimKey then aiming = false end
end)

RunService.RenderStepped:Connect(function(dt)
    if not Config.Aimbot or not aiming then return end
    local target = getTarget()
    if target then
        local current = Camera.CFrame
        local desired = CFrame.new(current.Position, target.Position)
        Camera.CFrame = current:Lerp(desired, Config.AimSmoothness)
    end
end)

--// =================== MOVEMENT ===================
RunService.Heartbeat:Connect(function()
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end

    if Config.SpeedEnabled then
        hum.WalkSpeed = Config.SpeedValue
    end
    if Config.JumpEnabled then
        hum.UseJumpPower = true
        hum.JumpPower = Config.JumpValue
    end
    if Config.NoClip then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

--// FLY
local flyBodyVel, flyBodyGyro
local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    flyBodyVel = Instance.new("BodyVelocity")
    flyBodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBodyVel.Velocity = Vector3.zero
    flyBodyVel.Parent = hrp

    flyBodyGyro = Instance.new("BodyGyro")
    flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBodyGyro.P = 1000
    flyBodyGyro.CFrame = hrp.CFrame
    flyBodyGyro.Parent = hrp
end
local function stopFly()
    if flyBodyVel then flyBodyVel:Destroy() flyBodyVel = nil end
    if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
end

RunService.RenderStepped:Connect(function()
    if Config.FlyEnabled then
        if not flyBodyVel then startFly() end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and flyBodyVel and flyBodyGyro then
            local dir = Vector3.zero
            local cam = Camera.CFrame
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end
            flyBodyVel.Velocity = dir.Magnitude > 0 and dir.Unit * Config.FlySpeed or Vector3.zero
            flyBodyGyro.CFrame = cam
        end
    else
        if flyBodyVel then stopFly() end
    end
end)

--// =================== UI EVENTS ===================
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    -- floating reopen button
    local Reopen = Instance.new("TextButton")
    Reopen.Name = "NovusReopen"
    Reopen.Size = UDim2.new(0, 50, 0, 50)
    Reopen.Position = UDim2.new(0, 20, 0, 100)
    Reopen.BackgroundColor3 = Theme.Accent
    Reopen.Text = "N"
    Reopen.Font = Enum.Font.GothamBlack
    Reopen.TextSize = 22
    Reopen.TextColor3 = Color3.new(1,1,1)
    Reopen.AutoButtonColor = false
    Reopen.Active = true
    Reopen.Draggable = true
    Reopen.Parent = ScreenGui
    Instance.new("UICorner", Reopen).CornerRadius = UDim.new(1, 0)

    local ReopenGrad = Instance.new("UIGradient")
    ReopenGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Theme.Accent),
        ColorSequenceKeypoint.new(1, Theme.Accent2),
    }
    ReopenGrad.Parent = Reopen

    Reopen.MouseButton1Click:Connect(function()
        Main.Visible = true
        Reopen:Destroy()
    end)
end)

--// MOBILE TOGGLE
local MobileBtn = Instance.new("TextButton")
MobileBtn.Size = UDim2.new(0, 50, 0, 50)
MobileBtn.Position = UDim2.new(0, 20, 0, 100)
MobileBtn.BackgroundColor3 = Theme.Accent
MobileBtn.Text = "N"
MobileBtn.Font = Enum.Font.GothamBlack
MobileBtn.TextSize = 22
MobileBtn.TextColor3 = Color3.new(1,1,1)
MobileBtn.AutoButtonColor = false
MobileBtn.Active = true
MobileBtn.Draggable = true
MobileBtn.Parent = ScreenGui
MobileBtn.Visible = UIS.TouchEnabled
Instance.new("UICorner", MobileBtn).CornerRadius = UDim.new(1, 0)

local MBGrad = Instance.new("UIGradient")
MBGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Theme.Accent),
    ColorSequenceKeypoint.new(1, Theme.Accent2),
}
MBGrad.Parent = MobileBtn

MobileBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

--// INITIAL TAB
SelectTab("Combat")

--// NOTIFICATION
local function notify(text)
    local N = Instance.new("TextLabel")
    N.Size = UDim2.new(0, 260, 0, 40)
    N.Position = UDim2.new(0.5, -130, 0, -50)
    N.BackgroundColor3 = Theme.Bg2
    N.Text = text
    N.Font = Enum.Font.GothamBold
    N.TextSize = 14
    N.TextColor3 = Theme.Text
    N.Parent = ScreenGui
    Instance.new("UICorner", N).CornerRadius = UDim.new(0, 10)

    local NStroke = Instance.new("UIStroke")
    NStroke.Color = Theme.Accent
    NStroke.Thickness = 1.5
    NStroke.Parent = N

    TweenService:Create(N, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -130, 0, 20)}):Play()
    task.wait(2.5)
    TweenService:Create(N, TweenInfo.new(0.4), {Position = UDim2.new(0.5, -130, 0, -50)}):Play()
    task.wait(0.5)
    N:Destroy()
end

notify("Novus Hub loaded — by epileptichurts")
print("[NOVUS HUB] Loaded. Welcome, Mr. Kanha.")
