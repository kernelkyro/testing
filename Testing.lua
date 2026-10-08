--[[
    Roblox Client Script — Fly / Teleport / Bring
    Executor context (Synapse, Krnl, Fluxus, Solara, etc.)
    Loadstring-ready.
    
    Fly: toggle via GUI or RightShift
    Teleport To: moves YOUR character to selected player
    Bring: attempts to move TARGET player to you (fires teleport remotes)
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- ============ STATE ============
local flying = false
local flySpeed = 60
local flyConnection = nil
local bodyVelocity = nil
local bodyGyro = nil
local selectedPlayer = nil

-- ============ GUI ============
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlyTPGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local parented = false
pcall(function()
    screenGui.Parent = game:GetService("CoreGui")
    parented = true
end)
if not parented then
    pcall(function()
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        parented = true
    end)
end
if not parented then
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 320)
mainFrame.Position = UDim2.new(0, 20, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
title.BorderSizePixel = 0
title.Text = "fly / tp"
title.TextColor3 = Color3.fromRGB(220, 220, 230)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = title

-- fly toggle
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0.9, 0, 0, 32)
flyBtn.Position = UDim2.new(0.05, 0, 0, 40)
flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
flyBtn.BorderSizePixel = 0
flyBtn.Text = "Fly: OFF"
flyBtn.TextColor3 = Color3.fromRGB(220, 220, 230)
flyBtn.Font = Enum.Font.Gotham
flyBtn.TextSize = 13
flyBtn.Parent = mainFrame

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(0, 6)
flyCorner.Parent = flyBtn

-- speed input
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0.9, 0, 0, 28)
speedBox.Position = UDim2.new(0.05, 0, 0, 80)
speedBox.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
speedBox.BorderSizePixel = 0
speedBox.Text = "60"
speedBox.PlaceholderText = "fly speed"
speedBox.TextColor3 = Color3.fromRGB(220, 220, 230)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 13
speedBox.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedBox

speedBox.FocusLost:Connect(function()
    local n = tonumber(speedBox.Text)
    if n and n > 0 then
        flySpeed = n
    else
        speedBox.Text = tostring(flySpeed)
    end
end)

-- player list label
local listLabel = Instance.new("TextLabel")
listLabel.Size = UDim2.new(0.9, 0, 0, 20)
listLabel.Position = UDim2.new(0.05, 0, 0, 115)
listLabel.BackgroundTransparency = 1
listLabel.Text = "players"
listLabel.TextColor3 = Color3.fromRGB(150, 150, 165)
listLabel.Font = Enum.Font.Gotham
listLabel.TextSize = 11
listLabel.TextXAlignment = Enum.TextXAlignment.Left
listLabel.Parent = mainFrame

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(0.9, 0, 0, 100)
playerList.Position = UDim2.new(0.05, 0, 0, 138)
playerList.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
playerList.BorderSizePixel = 0
playerList.ScrollBarThickness = 4
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.AutomaticCanvasSize = Enum.AutomaticSize.Y
playerList.Parent = mainFrame

local listCorner = Instance.new("UICorner")
listCorner.CornerRadius = UDim.new(0, 6)
listCorner.Parent = playerList

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 2)
listLayout.Parent = playerList

-- action buttons
local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.9, 0, 0, 32)
tpBtn.Position = UDim2.new(0.05, 0, 0, 248)
tpBtn.BackgroundColor3 = Color3.fromRGB(50, 80, 140)
tpBtn.BorderSizePixel = 0
tpBtn.Text = "Teleport To"
tpBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 13
tpBtn.Parent = mainFrame

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 6)
tpCorner.Parent = tpBtn

local bringBtn = Instance.new("TextButton")
bringBtn.Size = UDim2.new(0.9, 0, 0, 32)
bringBtn.Position = UDim2.new(0.05, 0, 0, 284)
bringBtn.BackgroundColor3 = Color3.fromRGB(140, 50, 60)
bringBtn.BorderSizePixel = 0
bringBtn.Text = "Bring"
bringBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
bringBtn.Font = Enum.Font.GothamBold
bringBtn.TextSize = 13
bringBtn.Parent = mainFrame

local bringCorner = Instance.new("UICorner")
bringCorner.CornerRadius = UDim.new(0, 6)
bringCorner.Parent = bringBtn

-- ============ PLAYER LIST BUILD ============
local function rebuildList()
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -4, 0, 24)
            btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
            btn.BorderSizePixel = 0
            btn.Text = plr.Name
            btn.TextColor3 = Color3.fromRGB(200, 200, 215)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 12
            btn.Parent = playerList
            
            local c = Instance.new("UICorner")
            c.CornerRadius = UDim.new(0, 4)
            c.Parent = btn
            
            btn.MouseButton1Click:Connect(function()
                selectedPlayer = plr
                for _, other in ipairs(playerList:GetChildren()) do
                    if other:IsA("TextButton") then
                        other.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                    end
                end
                btn.BackgroundColor3 = Color3.fromRGB(70, 100, 160)
            end)
        end
    end
end

rebuildList()
Players.PlayerAdded:Connect(rebuildList)
Players.PlayerRemoving:Connect(function(p)
    if selectedPlayer == p then selectedPlayer = nil end
    task.wait(0.1)
    rebuildList()
end)

-- ============ FLY ============
local function stopFly()
    flying = false
    flyBtn.Text = "Fly: OFF"
    flyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    if flyConnection then flyConnection:Disconnect() flyConnection = nil end
    if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
    if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
end

local function startFly()
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    flying = true
    flyBtn.Text = "Fly: ON"
    flyBtn.BackgroundColor3 = Color3.fromRGB(60, 120, 80)
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Velocity = Vector3.zero
    bodyVelocity.Parent = hrp
    
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.P = 1000
    bodyGyro.CFrame = hrp.CFrame
    bodyGyro.Parent = hrp
    
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying then return end
        local c = LocalPlayer.Character
        if not c then stopFly() return end
        local root = c:FindFirstChild("HumanoidRootPart")
        if not root then return end
        
        local cam = workspace.CurrentCamera
        local moveDir = Vector3.zero
        
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDir += cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDir -= cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDir -= cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDir += cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDir += Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDir -= Vector3.new(0, 1, 0)
        end
        
        if moveDir.Magnitude > 0 then
            moveDir = moveDir.Unit * flySpeed
        end
        
        bodyVelocity.Velocity = moveDir
        bodyGyro.CFrame = cam.CFrame
    end)
end

flyBtn.MouseButton1Click:Connect(function()
    if flying then stopFly() else startFly() end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if flying then stopFly() else startFly() end
    end
end)

-- ============ TELEPORT TO PLAYER ============
tpBtn.MouseButton1Click:Connect(function()
    if not selectedPlayer then return end
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local targetChar = selectedPlayer.Character
    if not targetChar then return end
    local targetHrp = targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHrp then return end
    
    hrp.CFrame = targetHrp.CFrame * CFrame.new(0, 0, 3)
end)

-- ============ BRING PLAYER ============
local function gatherRemotes()
    local remotes = {}
    local function scan(container)
        for _, obj in ipairs(container:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
                table.insert(remotes, obj)
            end
        end
    end
    scan(ReplicatedStorage)
    scan(workspace)
    return remotes
end

bringBtn.MouseButton1Click:Connect(function()
    if not selectedPlayer then return end
    local char = LocalPlayer.Character
    if not char then return end
    local myHrp = char:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    local myPos = myHrp.Position
    
    for _, remote in ipairs(gatherRemotes()) do
        if remote:IsA("RemoteFunction") then
            pcall(function() remote:InvokeServer(selectedPlayer, myPos) end)
            pcall(function() remote:InvokeServer("teleport", selectedPlayer, myPos) end)
            pcall(function() remote:InvokeServer(selectedPlayer.Name, myPos) end)
        elseif remote:IsA("RemoteEvent") then
            pcall(function() remote:FireServer(selectedPlayer, myPos) end)
            pcall(function() remote:FireServer("bring", selectedPlayer, myPos) end)
            pcall(function() remote:FireServer("teleport", selectedPlayer, myPos) end)
            pcall(function() remote:FireServer(selectedPlayer.Name, myPos) end)
            pcall(function() remote:FireServer(selectedPlayer, "bring") end)
            pcall(function() remote:FireServer("tp", selectedPlayer, myPos) end)
        end
    end
end)
