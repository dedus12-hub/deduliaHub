-- dedulia Hub | No Key | PC + Mobile

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LP = Players.LocalPlayer

-- ================= GUI =================
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "deduliaHub"

-- Floating button
local float = Instance.new("TextButton", gui)
float.Size = UDim2.new(0,55,0,55)
float.Position = UDim2.new(1,-70,0.5,-30)
float.Text = "D"
float.Font = Enum.Font.GothamBold
float.TextSize = 22
float.BackgroundColor3 = Color3.fromRGB(60,60,60)
float.TextColor3 = Color3.new(1,1,1)
float.Active = true
float.Draggable = true
Instance.new("UICorner", float).CornerRadius = UDim.new(1,0)

-- Main hub
local hub = Instance.new("Frame", gui)
hub.Size = UDim2.new(0,340,0,320)
hub.Position = UDim2.new(0.5,-170,0.5,-160)
hub.BackgroundColor3 = Color3.fromRGB(22,22,22)
hub.Visible = false
hub.Active = true
hub.Draggable = true
Instance.new("UICorner", hub).CornerRadius = UDim.new(0,18)

float.MouseButton1Click:Connect(function()
    hub.Visible = not hub.Visible
end)

-- Button creator
local function btn(text,y)
    local b = Instance.new("TextButton", hub)
    b.Size = UDim2.new(0,260,0,45)
    b.Position = UDim2.new(0.5,-130,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(45,45,45)
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.Gotham
    b.TextSize = 17
    Instance.new("UICorner", b)
    return b
end

-- ================= SPEED =================
local speedOn = false
btn("Speed",50).MouseButton1Click:Connect(function()
    speedOn = not speedOn
    if LP.Character and LP.Character:FindFirstChild("Humanoid") then
        LP.Character.Humanoid.WalkSpeed = speedOn and 45 or 16
    end
end)

-- ================= FLY (PC + MOBILE) =================
local flyOn = false
local bv, bg
btn("Fly",105).MouseButton1Click:Connect(function()
    flyOn = not flyOn
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    if flyOn then
        bv = Instance.new("BodyVelocity", hrp)
        bg = Instance.new("BodyGyro", hrp)
        bv.MaxForce = Vector3.new(1e9,1e9,1e9)
        bg.MaxTorque = Vector3.new(1e9,1e9,1e9)

        RunService.RenderStepped:Connect(function()
            if not flyOn then return end
            local dir = Vector3.zero

            -- PC controls
            if UIS:IsKeyDown(Enum.KeyCode.W) then dir += Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= Camera.CFrame.LookVector end
            if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.D) then dir += Camera.CFrame.RightVector end
            if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
            if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

            -- Mobile fallback (по направлению камеры)
            if dir.Magnitude == 0 then
                dir = Camera.CFrame.LookVector
            end

            bv.Velocity = dir * 60
            bg.CFrame = Camera.CFrame
        end)
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

-- ================= AIMBOT (SAFE) =================
local aimbotOn = false
btn("Aimbot",160).MouseButton1Click:Connect(function()
    aimbotOn = not aimbotOn
end)

RunService.RenderStepped:Connect(function()
    if not aimbotOn then return end
    local closest, dist = nil, math.huge
    for _,p in pairs(Players:GetPlayers()) do
        if p ~= LP and p.Character and p.Character:FindFirstChild("Head") then
            local d = (Camera.CFrame.Position - p.Character.Head.Position).Magnitudeif d < dist then
                dist = d
                closest = p
            end
        end
    end
    if closest and closest.Character and closest.Character:FindFirstChild("Head") then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, closest.Character.Head.Position)
    end
end)
