-- dedulia Hub
-- Simple & Working

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "deduliaHub"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 300, 0, 220)
frame.Position = UDim2.new(0.5, -150, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "dedulia Hub"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 20

local function button(text, y)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(0, 240, 0, 40)
    b.Position = UDim2.new(0.5, -120, 0, y)
    b.Text = text
    b.Font = Enum.Font.Gotham
    b.TextSize = 15
    b.TextColor3 = Color3.new(1,1,1)
    b.BackgroundColor3 = Color3.fromRGB(40,40,40)
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    return b
end

-- SPEED
local speedOn = false
local speedBtn = button("Speed: OFF", 50)

speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    speedBtn.Text = speedOn and "Speed: ON" or "Speed: OFF"
    LocalPlayer.Character.Humanoid.WalkSpeed = speedOn and 50 or 16
end)

-- FLY
local flyOn = false
local flyBtn = button("Fly: OFF", 100)
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
                bv.Velocity = Camera.CFrame.LookVector * 60
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
local espBtn = button("ESP: OFF", 150)

espBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    espBtn.Text = espOn and "ESP: ON" or "ESP: OFF"

    for _,plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if espOn then
                local h = Instance.new("Highlight", plr.Character)
                h.FillColor = Color3.fromRGB(255,0,0)
            else
                for _,v in pairs(plr.Character:GetChildren()) do
                    if v:IsA("Highlight") then v:Destroy() end
                end
            end
        end
    end
end)
