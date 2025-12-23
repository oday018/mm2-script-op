-- الخدمات
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService") -- مطلوبة للـ Draggable

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- المتغيرات
local antiFlingEnabled = false
local connections = {}

-- متغيرات الحماية (من دالتك)
local LastSafePos = Vector3.zero

-- دالة لتفعيل Anti-Fling (محدثة)
local function EnableAntiFling()
    if antiFlingEnabled then return end -- تأكد من أنها لم تُفعّل مسبقًا
    antiFlingEnabled = true
    print("Anti-Fling Started")

    local connection = RunService.Heartbeat:Connect(function()
        if not antiFlingEnabled then return end -- تحقق من التفعيل داخل الـ loop
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        -- تخزين الموقع الآمن كل مرة تكون الحركة طبيعية
        if root.AssemblyLinearVelocity.Magnitude < 50 then
            LastSafePos = root.Position
        end

        -- كشف الـ Fling: سرعة أو دوران عالي جدًا
        if root.AssemblyLinearVelocity.Magnitude > 300 or root.AssemblyAngularVelocity.Magnitude > 300 then
            -- إيقاف القذف فورًا
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = CFrame.new(LastSafePos) -- الرجوع لمكان آمن

            -- إيقاف التصادم مع اللاعبين (للسلامة)
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= player and plr.Character then
                    for _, part in ipairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end)
    table.insert(connections, connection) -- حفظ الاتصال
end

-- دالة ايقاف Anti-Fling
local function DisableAntiFling()
    if not antiFlingEnabled then return end -- تأكد من أنها مفعلة
    antiFlingEnabled = false
    print("Anti-Fling Stopped")

    -- قطع كل الاتصالات
    for _, connection in pairs(connections) do
        connection:Disconnect()
    end
    connections = {} -- مسح الجدول
end


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
toggleButton.Text = "مموع" -- الحالة الافتراضية
toggleButton.TextScaled = true
toggleButton.BorderSizePixel = 1
toggleButton.Parent = canvasGroup

-- دالة تبديل الحالة
local function toggleAntiFling()
    if antiFlingEnabled then
        DisableAntiFling() -- استخدم الدالة الجديدة
        toggleButton.Text = "مموع" -- بعد التوقف
    else
        EnableAntiFling() -- استخدم الدالة الجديدة
        toggleButton.Text = "مسموح" -- بعد البدء
    end
end

-- تعيين دالة التبديل عند الضغط على الزر
toggleButton.MouseButton1Click:Connect(toggleAntiFling)

print("Single Button Anti-Fling UI Created. Drag it around. Click to toggle ON/OFF.")

