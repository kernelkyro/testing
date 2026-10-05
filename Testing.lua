--// Spin a Catboy | Novus Lite | epileptichurts
local Players     = game:GetService("Players")
local RunService  = game:GetService("RunService")
local UIS         = game:GetService("UserInputService")
local LP          = Players.LocalPlayer

--// CONFIG
local Config = {
    Speed      = false,
    SpeedVal   = 50,
    Jump       = false,
    JumpVal    = 100,
    AntiAfk    = true,
}

--// UI
local Gui = Instance.new("ScreenGui")
Gui.Name = "NovusCatboy"
Gui.ResetOnSpawn = false
if gethui then Gui.Parent = gethui()
elseif syn and syn.protect_gui then syn.protect_gui(Gui) Gui.Parent = game:GetService("CoreGui")
else Gui.Parent = game:GetService("CoreGui") end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 220, 0, 180)
Main.Position = UDim2.new(0, 20, 0, 100)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = Gui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(138, 92, 246)
Stroke.Thickness = 1.5
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "NOVUS • Catboy"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextColor3 = Color3.fromRGB(230, 230, 240)
Title.Parent = Main

--// toggle builder
local function MakeToggle(text, y, default, cb)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, -20, 0, 30)
    Btn.Position = UDim2.new(0, 10, 0, y)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.Parent = Main
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -60, 1, 0)
    L.Position = UDim2.new(0, 10, 0, 0)
    L.BackgroundTransparency = 1
    L.Text = text
    L.Font = Enum.Font.GothamMedium
    L.TextSize = 12
    L.TextColor3 = Color3.fromRGB(230, 230, 240)
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = Btn

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 12, 0, 12)
    Dot.Position = UDim2.new(1, -22, 0.5, -6)
    Dot.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    Dot.BorderSizePixel = 0
    Dot.Parent = Btn
    Instance.new("UICorner", Dot).CornerRadius = UDim.new(1, 0)

    local state = default
    local function set(v)
        state = v
        Dot.BackgroundColor3 = v and Color3.fromRGB(138, 92, 246) or Color3.fromRGB(60, 60, 80)
        if cb then cb(v) end
    end
    Btn.MouseButton1Click:Connect(function() set(not state) end)
    set(default)
    return set
end

--// controls
MakeToggle("WalkSpeed", 35, false, function(v) Config.Speed = v end)
MakeToggle("JumpPower", 70, false, function(v) Config.Jump = v end)
MakeToggle("Anti-AFK", 105, true, function(v) Config.AntiAfk = v end)

--// loop
RunService.Heartbeat:Connect(function()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    if Config.Speed then hum.WalkSpeed = Config.SpeedVal end
    if Config.Jump then
        hum.UseJumpPower = true
        hum.JumpPower = Config.JumpVal
    end
end)

--// anti afk
LP.Idled:Connect(function()
    if Config.AntiAfk then
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):ClickButton2(Vector2.new())
    end
end)

print("[Novus] Catboy loaded.")
