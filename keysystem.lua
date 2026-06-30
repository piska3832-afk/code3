-- =============================================
-- Luna Key System
-- =============================================

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

print("🌙 Luna Key System loaded.")

local function GetKeyLink()
    return "https://link-target.net/4010771/L8DaJDxf3Uo3"
end

local sg = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
sg.Name = "LunaKey"

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 420, 0, 260)
frame.Position = UDim2.new(0.5, -210, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(18,18,32)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,70)
title.BackgroundTransparency = 1
title.Text = "🌙 Luna"
title.TextColor3 = Color3.fromRGB(170, 210, 255)
title.TextSize = 26
title.Font = Enum.Font.GothamBold

local input = Instance.new("TextBox", frame)
input.Size = UDim2.new(0.85,0,0,55)
input.Position = UDim2.new(0.075,0,0.38,0)
input.PlaceholderText = "Enter key..."
input.BackgroundColor3 = Color3.fromRGB(25,25,45)
input.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", input).CornerRadius = UDim.new(0,12)

local getKeyBtn = Instance.new("TextButton", frame)
getKeyBtn.Size = UDim2.new(0.4,0,0,50)
getKeyBtn.Position = UDim2.new(0.075,0,0.62,0)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(50,120,255)
getKeyBtn.Text = "Get Key"
getKeyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", getKeyBtn).CornerRadius = UDim.new(0,12)

local submitBtn = Instance.new("TextButton", frame)
submitBtn.Size = UDim2.new(0.4,0,0,50)
submitBtn.Position = UDim2.new(0.525,0,0.62,0)
submitBtn.BackgroundColor3 = Color3.fromRGB(80,200,120)
submitBtn.Text = "Submit"
submitBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", submitBtn).CornerRadius = UDim.new(0,12)

getKeyBtn.MouseButton1Click:Connect(function()
    setclipboard(GetKeyLink())
    getKeyBtn.Text = "Copied!"
    task.wait(1.5)
    getKeyBtn.Text = "Get Key"
end)

submitBtn.MouseButton1Click:Connect(function()
    if #input.Text >= 8 then
        print("✅ Key accepted!")
        sg:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/piska382-afk/code3/main/main.lua"))()
    else
        warn("❌ Invalid key!")
    end
end)

print("Waiting for key...")
