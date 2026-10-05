--// Novus Fly + Teleport | epileptichurts
local Players       = game:GetService("Players")
local RunService    = game:GetService("RunService")
local UIS           = game:GetService("UserInputService")
local LocalPlayer   = Players.LocalPlayer
local Camera        = workspace.CurrentCamera

--// CONFIG
local Config = {
    FlySpeed  = 60,
    FlyKey    = Enum.KeyCode.F,
    TpKey     = Enum.KeyCode.T,
}

--// UI (tiny draggable panel)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NovusFlyTp"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
if gethui then ScreenGui.Parent = gethui()
elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = game:GetService("CoreGui")
else ScreenGui.Parent = game:GetService("CoreGui") end

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 200, 0, 130)
Main.Position = UDim2.new(0, 20, 0, 100)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(138, 92, 246)
Stroke.Thickness = 1.5
Stroke.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 26)
Title.BackgroundTransparency = 1
Title.Text = "NOVUS • Fly & TP"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13
Title.TextColor3 = Color3.fromRGB(230, 230, 240)
Title.Parent = Main

local function MakeBtn(text, y, color, cb)
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(1, -20, 0, 30)
    B.Position = UDim2.new(0, 10, 0, y)
    B.BackgroundColor3 = color
    B.Text = text
    B.Font = Enum.Font.GothamBold
    B.TextSize = 12
    B.TextColor3 = Color3.new(1, 1, 1)
    B.AutoButtonColor = false
    B.Parent = Main
    Instance.new("UICorner", B).CornerRadius = UDim.new(0, 6)
    B.MouseButton1Click:Connect(cb)
    return B
end

--// FLY
local flying = false
local bodyVel, bodyGyro

local function startFly()
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    bodyVel = Instance.new("BodyVelocity")
    bodyVel.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVel.Velocity = Vector3.zero
    bodyVel.Parent = hrp

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.P = 1000
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp

    flying = true
end

local function stopFly()
    flying = false
    if bodyVel then bodyVel:Destroy() bodyVel = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
end

RunService.RenderStepped:Connect(function()
    if not flying then return end
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp or not bodyVel or not bodyGyro then return end

    local dir = Vector3.zero
    local cam = Camera.CFrame
    if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.LookVector end
    if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.RightVector end
    if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
    if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

    bodyVel.Velocity = dir.Magnitude > 0 and dir.Unit * Config.FlySpeed or Vector3.zero
    bodyGyro.CFrame = cam
end)

--// TELEPORT
local function getMouseTarget()
    local mouse = LocalPlayer:GetMouse()
    if mouse.Target then
        return mouse.Hit.Position + Vector3.new(0, 3, 0)
    end
    return nil
end

local function teleportTo(pos)
    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if hrp and pos then
        hrp.CFrame = CFrame.new(pos)
    end
end

local function teleportToPlayer(name)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Name:lower():sub(1, #name) == name:lower() then
            local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                teleportTo(hrp.Position + Vector3.new(0, 3, 0))
                return true
            end
        end
    end
    return false
end

--// KEYBINDS
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Config.FlyKey then
        if flying then stopFly() else startFly() end
    elseif input.KeyCode == Config.TpKey then
        -- teleport to nearest player
        local closest, dist
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myHrp then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local d = (hrp.Position - myHrp.Position).Magnitude
                    if not dist or d < dist then
                        dist = d
                        closest = hrp
                    end
                end
            end
        end
        if closest then teleportTo(closest.Position + Vector3.new(0, 3, 0)) end
    end
end)

--// BUTTONS
local FlyBtn = MakeBtn("Fly: OFF  [F]", 30, Color3.fromRGB(50, 50, 65), function()
    if flying then stopFly() FlyBtn.Text = "Fly: OFF  [F]"
    else startFly() FlyBtn.Text = "Fly: ON  [F]" end
end)

MakeBtn("TP to Mouse  (PC)", 66, Color3.fromRGB(138, 92, 246), function()
    local pos = getMouseTarget()
    if pos then teleportTo(pos) end
end)

local nameBox = Instance.new("TextBox")
nameBox.Size = UDim2.new(0.55, 0, 0, 28)
nameBox.Position = UDim2.new(0, 10, 0, 100)
nameBox.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
nameBox.PlaceholderText = "player name"
nameBox.Text = ""
nameBox.Font = Enum.Font.Gotham
nameBox.TextSize = 11
nameBox.TextColor3 = Color3.fromRGB(230, 230, 240)
nameBox.Parent = Main
Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 6)

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.40, 0, 0, 28)
tpBtn.Position = UDim2.new(0.58, 0, 0, 100)
tpBtn.BackgroundColor3 = Color3.fromRGB(236, 72, 153)
tpBtn.Text = "TP to Player"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 11
tpBtn.TextColor3 = Color3.new(1,1,1)
tpBtn.Parent = Main
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

tpBtn.MouseButton1Click:Connect(function()
    if nameBox.Text ~= "" then teleportToPlayer(nameBox.Text) end
end)

--// mobile toggle
local MobileBtn = Instance.new("TextButton")
MobileBtn.Size = UDim2.new(0, 44, 0, 44)
MobileBtn.Position = UDim2.new(0, 20, 0, 240)
MobileBtn.BackgroundColor3 = Color3.fromRGB(138, 92, 246)
MobileBtn.Text = "N"
MobileBtn.Font = Enum.Font.GothamBlack
MobileBtn.TextSize = 18
MobileBtn.TextColor3 = Color3.new(1,1,1)
MobileBtn.AutoButtonColor = false
MobileBtn.Draggable = true
MobileBtn.Parent = ScreenGui
MobileBtn.Visible = UIS.TouchEnabled
Instance.new("UICorner", MobileBtn).CornerRadius = UDim.new(1, 0)

MobileBtn.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
end)

print("[Novus] Fly + TP loaded.")
