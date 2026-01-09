-- dedulia Hub | Mobile + Delta friendly

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- UI SCALE (под телефон)
local gui = Instance.new("ScreenGui")
gui.Name = "deduliaHub"
gui.Parent = game.CoreGui

local scale = Instance.new("UIScale", gui)
scale.Scale = UserInputService.TouchEnabled and 1.15 or 1

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 300)
frame.Position = UDim2.new(0.5, -160, 0.55, -150)
frame.BackgroundColor3 = Color3.fromRGB(22,22,22)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,45)
title.Text = "dedulia Hub (Mobile)"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- MINIMIZE BUTTON
local mini = Instance.new("TextButton", frame)
mini.Size = UDim2.new(0,40,0,40)
mini.Position = UDim2.new(1,-45,0,5)
mini.Text = "—"
mini.Font = Enum.Font.GothamBold
mini.TextSize = 22
mini.BackgroundColor3 = Color3.fromRGB(40,40,40)
mini.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", mini).CornerRadius = UDim.new(1,0)

local minimized = false
mini.MouseButton1Click:Connect(function()
    minimized = not minimized
    frame.Size = minimized and UDim2.new(0, 200, 0, 45) or UDim2.new(0, 320, 0, 300)
end)

-- BUTTON CREATOR (БОЛЬШИЕ КНОПКИ)
local function makeButton(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0, 260, 0, 50)
    b.Position = UDim2.new(0.5, -130, 0, y)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 18
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,14)
    return b
end

-- SPEED
local speedOn = false
local speedBtn = makeButton("Speed: OFF", 60)

speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    speedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"
    LocalPlayer.Character.Humanoid.WalkSpeed = speedOn and 45 or 16
end)

-- FLY (MOBILE)
local flyOn = false
local flyBtn = makeButton("Fly: OFF", 125)
local bv, bg

flyBtn.MouseButton1Click:Connect(function()
    flyOn = not flyOn
    flyBtn.Text = flyOn and "Fly: ON" or "Fly: OFF"

    local hrp = LocalPlayer.Character.HumanoidRootPart

    if flyOn then
        bv = Instance.new("BodyVelocity", hrp)
        bg = Instance.new("BodyGyro", hrp)
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        bg.MaxTorque = Vector3.new(1e9,1e9,1e9)

        RunService.RenderStepped:Connect(function()
            if flyOn then
                bv.Velocity = Camera.CFrame.LookVector * 50
                bg.CFrame = Camera.CFrame
            end
        end)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

-- ESP
local espOn = false
local espBtn = makeButton("ESP: OFF", 190)

espBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    espBtn.Text = espOn and "ESP: ON" or "ESP: OFF"

    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            if espOn then
                local h = Instance.new("Highlight", p.Character)
                h.FillColor = Color3.fromRGB(255,0,0)
                h.OutlineColor = Color3.new(1,1,1)
            else
                for _,v in pairs(p.Character:GetChildren()) do
                    if v:IsA("Highlight") then v:Destroy() end
                end
            end
        end
    end
end)
