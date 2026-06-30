-- =============================================
-- Glassmorphism Luna Menu + Анимации
-- =============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local silentEnabled = false
local espEnabled = false
local fov = 160

-- Silent Aim + ESP (тот же код)
local function getClosest()
    local closest = nil
    local shortest = math.huge
    local mouse = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    for _, plr in Players:GetPlayers() do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local head = plr.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mouse).Magnitude
                if dist < shortest and dist < fov then
                    shortest = dist
                    closest = head
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not silentEnabled then return end
    local target = getClosest()
    if target then
        local lookAt = CFrame.lookAt(Camera.CFrame.Position, target.Position)
        Camera.CFrame = Camera.CFrame:Lerp(lookAt, 0.68)
    end
end)

local espObjects = {}
local function createESP(plr)
    if plr == LocalPlayer or espObjects[plr] then return end
    local char = plr.Character
    if not char then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = char:FindFirstChild("HumanoidRootPart")
    box.Size = Vector3.new(4,6,4)
    box.Color3 = Color3.fromRGB(100, 200, 255)
    box.Transparency = 0.65
    box.AlwaysOnTop = true
    box.ZIndex = 5
    box.Parent = char
    espObjects[plr] = box
end

RunService.Heartbeat:Connect(function()
    if not espEnabled then return end
    for _, plr in Players:GetPlayers() do
        if plr.Character then createESP(plr) end
    end
end)

-- === Glassmorphism Menu ===
local sg = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
sg.Name = "GlassLuna"

local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 400, 0, 460)
main.Position = UDim2.new(0.5, -200, 0.5, -300)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
main.BackgroundTransparency = 0.35  -- стекло
main.Active = true
main.Draggable = true

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 1.5
stroke.Color = Color3.fromRGB(100, 180, 255)
stroke.Transparency = 0.6

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 20)

-- Анимация появления
task.wait(0.2)
TweenService:Create(main, TweenInfo.new(0.9, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, -200, 0.5, -230),
    BackgroundTransparency = 0.35
}):Play()

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,70)
title.BackgroundTransparency = 1
title.Text = "🌙 Luna"
title.TextColor3 = Color3.fromRGB(180, 220, 255)
title.TextSize = 26
title.Font = Enum.Font.GothamBold

local function CreateGlassBtn(text, y, callback)
    local btn = Instance.new("TextButton", main)
    btn.Size = UDim2.new(0.88,0,0,58)
    btn.Position = UDim2.new(0.06,0,y,0)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
    btn.BackgroundTransparency = 0.4
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamSemibold
    
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Thickness = 1
    btnStroke.Color = Color3.fromRGB(120, 200, 255)
    btnStroke.Transparency = 0.5
    
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 16)
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

CreateGlassBtn("🌑 Silent Aim (ПКМ)", 0.2, function() print("Silent Aim работает по ПКМ") end)
CreateGlassBtn("👁 ESP ВКЛ", 0.37, function() espEnabled = true; print("ESP ВКЛ") end)
CreateGlassBtn("👁 ESP ВЫКЛ", 0.54, function() espEnabled = false; print("ESP ВЫКЛ") end)

-- Бинд ПКМ
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        silentEnabled = true
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        silentEnabled = false
    end
end)

print("🌙 Glass Luna Menu загружена.")
-- =============================================
-- Other Players Hitbox Expander (для всех кроме тебя)
-- Solar Executor
-- =============================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local expanderEnabled = false
local size = 15 -- размер хитбокса других игроков (чем больше — тем легче попадать)
local connections = {}
local originalSizes = {}

local function expandPlayerHitbox(plr)
    if plr == LocalPlayer then return end
    local char = plr.Character
    if not char then return end
    
    for _, part in pairs(char:GetChildren()) do
        if part:IsA("BasePart") then
            if not originalSizes[part] then
                originalSizes[part] = part.Size
            end
            part.Size = Vector3.new(size, size, size)
            part.Transparency = 0.75
            part.CanCollide = false -- чтобы не мешало ходить
        end
    end
end

local function resetAll()
    for part, orig in pairs(originalSizes) do
        if part and part.Parent then
            part.Size = orig
            part.Transparency = 0
            part.CanCollide = true
        end
    end
    originalSizes = {}
end

local function enableExpander()
    expanderEnabled = true
    print("🔴 Other Players Hitbox Expander ON | Размер:", size)
    
    -- Обновление каждые 0.2 секунды
    table.insert(connections, RunService.Heartbeat:Connect(function()
        if not expanderEnabled then return end
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                expandPlayerHitbox(plr)
            end
        end
    end))
    
    -- На новых игроков
    Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function()
            task.wait(0.5)
            if expanderEnabled then expandPlayerHitbox(plr) end
        end)
    end)
end

local function disableExpander()
    expanderEnabled = false
    for _, c in pairs(connections) do c:Disconnect() end
    connections = {}
    resetAll()
    print("🔴 Other Players Hitbox Expander OFF")
end

-- Меню
local sg = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
sg.Name = "OtherHitbox"

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 380, 0, 260)
frame.Position = UDim2.new(0.5, -190, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,35)
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,50)
title.BackgroundColor3 = Color3.fromRGB(40,0,0)
title.Text = "🔴 Other Players Hitbox"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold

-- Кнопки размеров
local sizes = {8, 12, 18, 25, 35, 50}

for i, s in ipairs(sizes) do
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0.28, 0, 0, 45)
    btn.Position = UDim2.new(0.05 + ((i-1)%2)*0.48, 0, 0.28 + math.floor((i-1)/2)*0.22, 0)
    btn.BackgroundColor3 = Color3.fromRGB(80, 20, 20)
    btn.Text = s .. " studs"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.MouseButton1Click:Connect(function()
        size = s
        enableExpander()
    end)
end

local off = Instance.new("TextButton", frame)
off.Size = UDim2.new(0.9,0,0,50)
off.Position = UDim2.new(0.05,0,0.78,0)
off.BackgroundColor3 = Color3.fromRGB(20,20,20)
off.Text = "OFF"
off.TextColor3 = Color3.new(1, 0.3, 0.3)
off.MouseButton1Click:Connect(disableExpander)

print("Other Players Hitbox Expander загружен!")
