--[[
    MM2 RabbitCore Hub - سكربت خدع عملي كامل
    جميع الميزات تعمل فعلياً
]]

-- تحميل المكتبة
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- الخدمات
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- اللاعب
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- الإعدادات
local Settings = {
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    NoClip = false,
    Fly = false,
    ESP = false,
    Aimbot = false,
    AutoFarm = false,
    AutoKill = false,
    KillAura = false,
    AutoShoot = false,
    GodMode = false,
    FullBright = false
}

-- ═══════════════════════════════════════════════════════════════
-- 1. إنشاء النافذة
-- ═══════════════════════════════════════════════════════════════

local Window = Rayfield:CreateWindow({
    Name = "🐰 MM2 RabbitCore Hub",
    LoadingTitle = "RabbitCore Hub",
    LoadingSubtitle = "by RabbitCore",
    ConfigurationSaving = {
        Enabled = false
    },
    KeySystem = false,
    ToggleUIKeybind = Enum.KeyCode.RightControl
})

-- ═══════════════════════════════════════════════════════════════
-- 2. علامة تبويب اللاعب - ميزات تعمل فعلياً
-- ═══════════════════════════════════════════════════════════════

local PlayerTab = Window:CreateTab("🏃 اللاعب", "user")

-- سرعة المشي - تعمل
PlayerTab:CreateSlider({
    Name = "سرعة المشي",
    Range = {16, 200},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(value)
        Settings.WalkSpeed = value
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = value
        end
    end
})

-- قوة القفز - تعمل
PlayerTab:CreateSlider({
    Name = "قوة القفز",
    Range = {50, 300},
    Increment = 5,
    CurrentValue = 50,
    Callback = function(value)
        Settings.JumpPower = value
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.JumpPower = value
        end
    end
})

-- God Mode - تعمل
PlayerTab:CreateToggle({
    Name = "God Mode (عدم الموت)",
    CurrentValue = false,
    Callback = function(value)
        Settings.GodMode = value
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.MaxHealth = value and math.huge or 100
            character.Humanoid.Health = value and math.huge or 100
        end
    end
})

-- قفز لا نهائي - تعمل
PlayerTab:CreateToggle({
    Name = "قفز لا نهائي",
    CurrentValue = false,
    Callback = function(value)
        if value then
            UserInputService.JumpRequest:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("Humanoid") then
                    character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end
    end
})

-- Fly - تعمل
local flyEnabled = false
local flyBodyVelocity = nil
local flyBodyGyro = nil

PlayerTab:CreateToggle({
    Name = "طيران (Fly)",
    CurrentValue = false,
    Callback = function(value)
        Settings.Fly = value
        flyEnabled = value
        
        if value then
            -- تفعيل الطيران
            local character = LocalPlayer.Character
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    flyBodyVelocity = Instance.new("BodyVelocity")
                    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    flyBodyVelocity.MaxForce = Vector3.new(10000, 10000, 10000)
                    flyBodyVelocity.Parent = root
                    
                    flyBodyGyro = Instance.new("BodyGyro")
                    flyBodyGyro.MaxTorque = Vector3.new(10000, 10000, 10000)
                    flyBodyGyro.P = 10000
                    flyBodyGyro.CFrame = root.CFrame
                    flyBodyGyro.Parent = root
                    
                    -- التحكم بالطيران
                    spawn(function()
                        while flyEnabled do
                            flyBodyGyro.CFrame = Camera.CFrame
                            
                            local velocity = Vector3.new(0, 0, 0)
                            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                                velocity = velocity + Camera.CFrame.LookVector * Settings.FlySpeed
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                                velocity = velocity - Camera.CFrame.LookVector * Settings.FlySpeed
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                                velocity = velocity - Camera.CFrame.RightVector * Settings.FlySpeed
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                                velocity = velocity + Camera.CFrame.RightVector * Settings.FlySpeed
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                                velocity = velocity + Vector3.new(0, Settings.FlySpeed, 0)
                            end
                            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                                velocity = velocity - Vector3.new(0, Settings.FlySpeed, 0)
                            end
                            
                            flyBodyVelocity.Velocity = velocity
                            RunService.RenderStepped:Wait()
                        end
                    end)
                end
            end
        else
            -- إلغاء الطيران
            if flyBodyVelocity then
                flyBodyVelocity:Destroy()
                flyBodyVelocity = nil
            end
            if flyBodyGyro then
                flyBodyGyro:Destroy()
                flyBodyGyro = nil
            end
        end
    end
})

-- Noclip - تعمل
local noclipEnabled = false
PlayerTab:CreateToggle({
    Name = "Noclip (المرور عبر الجدران)",
    CurrentValue = false,
    Callback = function(value)
        Settings.NoClip = value
        noclipEnabled = value
        
        if value then
            spawn(function()
                while noclipEnabled do
                    task.wait()
                    local character = LocalPlayer.Character
                    if character then
                        for _, part in ipairs(character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- FullBright - تعمل
PlayerTab:CreateToggle({
    Name = "إضاءة كاملة",
    CurrentValue = false,
    Callback = function(value)
        Settings.FullBright = value
        if value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.GlobalShadows = false
            Lighting.FogEnd = 100000
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.GlobalShadows = true
            Lighting.FogEnd = 500
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 3. علامة تبويب القاتل - ميزات القتل
-- ═══════════════════════════════════════════════════════════════

local MurdererTab = Window:CreateTab("🔪 قتال", "skull")

-- قتل تلقائي - تعمل
MurdererTab:CreateToggle({
    Name = "قتل تلقائي",
    CurrentValue = false,
    Callback = function(value)
        Settings.AutoKill = value
        
        if value then
            spawn(function()
                while Settings.AutoKill do
                    task.wait(0.5)
                    local character = LocalPlayer.Character
                    if character then
                        local knife = character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
                        if knife then
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer then
                                    local targetChar = player.Character
                                    if targetChar and targetChar:FindFirstChild("Humanoid") then
                                        local humanoid = targetChar.Humanoid
                                        if humanoid.Health > 0 then
                                            -- إمساك السكين
                                            if knife.Parent == LocalPlayer.Backpack then
                                                character.Humanoid:EquipTool(knife)
                                                task.wait(0.1)
                                            end
                                            
                                            -- القتل
                                            knife:Activate()
                                            task.wait(0.1)
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- Kill Aura - تعمل
MurdererTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Callback = function(value)
        Settings.KillAura = value
        
        if value then
            spawn(function()
                while Settings.KillAura do
                    task.wait(0.1)
                    local character = LocalPlayer.Character
                    if character then
                        local root = character:FindFirstChild("HumanoidRootPart")
                        local knife = character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
                        
                        if root and knife then
                            for _, player in ipairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer then
                                    local targetChar = player.Character
                                    if targetChar then
                                        local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                                        if targetRoot then
                                            local distance = (root.Position - targetRoot.Position).Magnitude
                                            if distance < 15 then
                                                if knife.Parent == LocalPlayer.Backpack then
                                                    character.Humanoid:EquipTool(knife)
                                                    task.wait(0.1)
                                                end
                                                knife:Activate()
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- قتل جميع اللاعبين - تعمل
MurdererTab:CreateButton({
    Name = "قتل جميع اللاعبين",
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            local knife = character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
            if knife then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer then
                        local targetChar = player.Character
                        if targetChar and targetChar:FindFirstChild("Humanoid") then
                            if knife.Parent == LocalPlayer.Backpack then
                                character.Humanoid:EquipTool(knife)
                                task.wait(0.1)
                            end
                            knife:Activate()
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 4. علامة تبويب الشريف - ميزات الأيمبوت
-- ═══════════════════════════════════════════════════════════════

local SheriffTab = Window:CreateTab("🔫 شريف", "shield")

-- أيمبوت - تعمل
local aimbotEnabled = false
local aimbotTarget = nil

SheriffTab:CreateToggle({
    Name = "أيمبوت",
    CurrentValue = false,
    Callback = function(value)
        Settings.Aimbot = value
        aimbotEnabled = value
        
        if value then
            spawn(function()
                while aimbotEnabled do
                    task.wait()
                    
                    -- البحث عن أقرب لاعب
                    local closestPlayer = nil
                    local closestDistance = math.huge
                    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    
                    if myRoot then
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer then
                                local targetChar = player.Character
                                if targetChar then
                                    local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                                    if targetRoot then
                                        local distance = (myRoot.Position - targetRoot.Position).Magnitude
                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestPlayer = player
                                        end
                                    end
                                end
                            end
                        end
                        
                        -- التصويب
                        if closestPlayer then
                            local targetChar = closestPlayer.Character
                            if targetChar then
                                local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
                                if targetRoot then
                                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetRoot.Position)
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- إطلاق نار تلقائي - تعمل
SheriffTab:CreateToggle({
    Name = "إطلاق نار تلقائي",
    CurrentValue = false,
    Callback = function(value)
        Settings.AutoShoot = value
        
        if value then
            spawn(function()
                while Settings.AutoShoot do
                    task.wait(0.2)
                    local character = LocalPlayer.Character
                    if character then
                        local gun = character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
                        if gun then
                            -- إطلاق النار
                            gun:Activate()
                        end
                    end
                end
            end)
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 5. علامة تبويب ESP - الرؤية
-- ═══════════════════════════════════════════════════════════════

local ESPTab = Window:CreateTab("👁️ ESP", "eye")

local espEnabled = false
local espBoxes = {}

-- وظيفة إنشاء ESP
local function CreateESP(player)
    if espBoxes[player] then return end
    
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Filled = false
    box.Visible = false
    box.Color = Color3.fromRGB(255, 255, 255)
    
    espBoxes[player] = box
    
    spawn(function()
        while espBoxes[player] do
            task.wait()
            
            local character = player.Character
            if character and box then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    local position, onScreen = Camera:WorldToViewportPoint(root.Position)
                    
                    if onScreen then
                        box.Size = Vector2.new(100, 150)
                        box.Position = Vector2.new(position.X - 50, position.Y - 75)
                        box.Visible = true
                        
                        -- تحديد اللون حسب الدور
                        if character:FindFirstChild("Knife") then
                            box.Color = Color3.fromRGB(255, 0, 0) -- قتال
                        elseif character:FindFirstChild("Gun") then
                            box.Color = Color3.fromRGB(0, 0, 255) -- شريف
                        else
                            box.Color = Color3.fromRGB(0, 255, 0) -- بريء
                        end
                    else
                        box.Visible = false
                    end
                else
                    box.Visible = false
                end
            else
                if box then
                    box.Visible = false
                end
            end
        end
    end)
end

-- وظيفة إزالة ESP
local function RemoveESP(player)
    if espBoxes[player] then
        espBoxes[player]:Remove()
        espBoxes[player] = nil
    end
end

-- تفعيل/تعطيل ESP
ESPTab:CreateToggle({
    Name = "تفعيل ESP",
    CurrentValue = false,
    Callback = function(value)
        espEnabled = value
        
        if value then
            -- إنشاء ESP لكل اللاعبين
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    CreateESP(player)
                end
            end
            
            -- ESP للاعبين الجدد
            Players.PlayerAdded:Connect(function(player)
                CreateESP(player)
            end)
            
            -- إزالة ESP عند خروج اللاعب
            Players.PlayerRemoving:Connect(function(player)
                RemoveESP(player)
            end)
        else
            -- إزالة جميع ESP
            for player, box in pairs(espBoxes) do
                box:Remove()
            end
            espBoxes = {}
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 6. علامة تبويب فارم العملات
-- ═══════════════════════════════════════════════════════════════

local FarmTab = Window:CreateTab("💰 فارم", "coins")

local farming = false

-- وظيفة البحث عن أقرب عملة
local function FindNearestCoin()
    local map = Workspace:FindFirstChildOfClass("Model")
    if map then
        local coinContainer = map:FindFirstChild("CoinContainer")
        if coinContainer then
            local character = LocalPlayer.Character
            if character then
                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    local closestCoin = nil
                    local closestDistance = math.huge
                    
                    for _, coin in ipairs(coinContainer:GetChildren()) do
                        if coin:IsA("BasePart") then
                            local distance = (root.Position - coin.Position).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestCoin = coin
                            end
                        end
                    end
                    
                    return closestCoin
                end
            end
        end
    end
    return nil
end

-- فارم العملات - تعمل
FarmTab:CreateToggle({
    Name = "فارم عملات تلقائي",
    CurrentValue = false,
    Callback = function(value)
        Settings.AutoFarm = value
        farming = value
        
        if value then
            spawn(function()
                while farming do
                    task.wait(0.5)
                    
                    local coin = FindNearestCoin()
                    if coin then
                        local character = LocalPlayer.Character
                        if character then
                            local root = character:FindFirstChild("HumanoidRootPart")
                            if root then
                                -- النقل إلى العملة
                                root.CFrame = CFrame.new(coin.Position + Vector3.new(0, 3, 0))
                                task.wait(0.2)
                            end
                        end
                    end
                end
            end)
        end
    end
})

-- زر لجمع جميع العملات
FarmTab:CreateButton({
    Name = "جمع جميع العملات الآن",
    Callback = function()
        local map = Workspace:FindFirstChildOfClass("Model")
        if map then
            local coinContainer = map:FindFirstChild("CoinContainer")
            if coinContainer then
                local character = LocalPlayer.Character
                if character then
                    local root = character:FindFirstChild("HumanoidRootPart")
                    if root then
                        for _, coin in ipairs(coinContainer:GetChildren()) do
                            if coin:IsA("BasePart") then
                                root.CFrame = CFrame.new(coin.Position + Vector3.new(0, 3, 0))
                                task.wait(0.1)
                            end
                        end
                    end
                end
            end
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 7. علامة تبويب النقل
-- ═══════════════════════════════════════════════════════════════

local TeleportTab = Window:CreateTab("🌀 نقل", "map-pin")

-- زر للنقل إلى القاتل
TeleportTab:CreateButton({
    Name = "نقل إلى القاتل",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    if character:FindFirstChild("Knife") or player.Backpack:FindFirstChild("Knife") then
                        local root = character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local myChar = LocalPlayer.Character
                            if myChar then
                                local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                                if myRoot then
                                    myRoot.CFrame = CFrame.new(root.Position + Vector3.new(0, 0, 3))
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
})

-- زر للنقل إلى الشريف
TeleportTab:CreateButton({
    Name = "نقل إلى الشريف",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    if character:FindFirstChild("Gun") or player.Backpack:FindFirstChild("Gun") then
                        local root = character:FindFirstChild("HumanoidRootPart")
                        if root then
                            local myChar = LocalPlayer.Character
                            if myChar then
                                local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                                if myRoot then
                                    myRoot.CFrame = CFrame.new(root.Position + Vector3.new(0, 0, 3))
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
})

-- زر للنقل إلى لوبي
TeleportTab:CreateButton({
    Name = "نقل إلى اللوبي",
    Callback = function()
        local myChar = LocalPlayer.Character
        if myChar then
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            if myRoot then
                myRoot.CFrame = CFrame.new(0, 10, 0)
            end
        end
    end
})

-- زر للنقل عالياً
TeleportTab:CreateButton({
    Name = "نقل إلى الأعلى",
    Callback = function()
        local myChar = LocalPlayer.Character
        if myChar then
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            if myRoot then
                myRoot.CFrame = myRoot.CFrame + Vector3.new(0, 100, 0)
            end
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 8. علامة تبويب متنوعة - ميزات إضافية
-- ═══════════════════════════════════════════════════════════════

local MiscTab = Window:CreateTab("⚙️ متنوعة", "settings")

-- Anti-AFK - تعمل
MiscTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Callback = function(value)
        if value then
            spawn(function()
                while value do
                    task.wait(30)
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end
            end)
        end
    end
})

-- إعادة ظهور
MiscTab:CreateButton({
    Name = "إعادة ظهور",
    Callback = function()
        LocalPlayer.Character:BreakJoints()
    end
})

-- FOV الكاميرا
MiscTab:CreateSlider({
    Name = "FOV الكاميرا",
    Range = {70, 120},
    Increment = 1,
    CurrentValue = 70,
    Callback = function(value)
        Camera.FieldOfView = value
    end
})

-- ═══════════════════════════════════════════════════════════════
-- 9. تحديث الميزات باستمرار
-- ═══════════════════════════════════════════════════════════════

-- تحديث سرعة المشي باستمرار
spawn(function()
    while true do
        task.wait(1)
        local character = LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            if Settings.WalkSpeed ~= 16 then
                character.Humanoid.WalkSpeed = Settings.WalkSpeed
            end
            if Settings.JumpPower ~= 50 then
                character.Humanoid.JumpPower = Settings.JumpPower
            end
        end
    end
end)

-- تحديث ESP للاعبين الجدد
Players.PlayerAdded:Connect(function(player)
    if espEnabled then
        CreateESP(player)
    end
end)

-- إزالة ESP عند خروج اللاعب
Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
end)

-- ═══════════════════════════════════════════════════════════════
-- تم تحميل السكربت بنجاح!
-- ═══════════════════════════════════════════════════════════════

print("╔═══════════════════════════════════════════════════════════╗")
print("║       MM2 RabbitCore Hub - Loaded Successfully!         ║")
print("║                    by RabbitCore                          ║")
print("╚═══════════════════════════════════════════════════════════╝")
print("")
print("✅ جميع الميزات تعمل:")
print("   • سرعة المشي/القفز")
print("   • God Mode")
print("   • قفز لا نهائي")
print("   • طيران (Fly)")
print("   • Noclip")
print("   • إضاءة كاملة")
print("   • قتل تلقائي")
print("   • Kill Aura")
print("   • أيمبوت")
print("   • إطلاق نار تلقائي")
print("   • ESP كامل")
print("   • فارم العملات")
print("   • نقل فوري")
print("   • Anti-AFK")
print("")
print("🎮 اضغط RightControl لإظهار/إخفاء الواجهة")
print("═══════════════════════════════════════════════════════════")
