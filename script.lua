-- الخدمات
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- المتغيرات
local antiFlingEnabled = false
local connections = {}

-- انشاء الواجهة (CanvasGroup)
local gui = Instance.new("ScreenGui")
gui.Name = "SingleButtonAntiFlingGUI"
gui.Parent = player:WaitForChild("PlayerGui")

local canvasGroup = Instance.new("CanvasGroup")
canvasGroup.Name = "MainCanvas"
canvasGroup.Size = UDim2.fromOffset(120, 40) -- حجم صغير
canvasGroup.Position = UDim2.fromScale(0.01, 0.5) -- يسار الشاشة، في المنتصف
canvasGroup.BackgroundColor3 = Color3.fromRGB(255, 255, 0) -- لون صفر
canvasGroup.BackgroundTransparency = 0.3
canvasGroup.BorderSizePixel = 2
canvasGroup.BorderColor3 = Color3.fromRGB(0, 0, 0)
canvasGroup.Draggable = true
canvasGroup.Active = true
canvasGroup.Parent = gui

-- انشاء الزر الوحيد
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.fromScale(1, 1) -- ياخذ كامل مساحة الـ CanvasGroup
toggleButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- لون داكن شوية
toggleButton.Text = "ممنوع" -- الحالة الافتراضية
toggleButton.TextScaled = true
toggleButton.BorderSizePixel = 1
toggleButton.Parent = canvasGroup

-- دالة تشغيل Anti-Fling
local function startAntiFling()
    if antiFlingEnabled then return end
    antiFlingEnabled = true
    print("Anti-Fling Started")

    local connection = RunService.Heartbeat:Connect(function()
        if character and humanoidRootPart and humanoidRootPart.Velocity.Magnitude > 100 then
            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        end
    end)
    table.insert(connections, connection)
end

-- دالة ايقاف Anti-Fling
local function stopAntiFling()
    if not antiFlingEnabled then return end
    antiFlingEnabled = false
    print("Anti-Fling Stopped")

    for _, connection in pairs(connections) do
        connection:Disconnect()
    end
    connections = {}
end

-- دالة تبديل الحالة
local function toggleAntiFling()
    if antiFlingEnabled then
        stopAntiFling()
        toggleButton.Text = "ممنوع" -- بعد التوقف
    else
        startAntiFling()
        toggleButton.Text = "مسموح" -- بعد البدء
    end
end

-- تعيين دالة التبديل عند الضغط على الزر
toggleButton.MouseButton1Click:Connect(toggleAntiFling)

print("Single Button Anti-Fling UI Created. Drag it around. Click to toggle ON/OFF.")
