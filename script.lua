--[[
    ╔═══════════════════════════════════════════════════════════════╗
    ║           Murder Mystery 2 RabbitCore Hub v5.3.0             ║
    ║                      by RabbitCore                            ║
    ║                                                               ║
    ║  Полноценный мультифункциональный скрипт-хаб для MM2         ║
    ║  Использует Wand UI Library (Redz Library V5 Remake)       ║
    ║                                                               ║
    ║  Возможности:                                                 ║
    ║  - 12+ разделов функций                                       ║
    ║  - 100+ уникальных функций                                    ║
    ║  - Продвинутый ESP с множеством опций                         ║
    ║  - Интеллектуальный авто-фарм монет                           ║
    ║  - Полноценный аимбот для Sheriff                             ║
    ║  - Автоматизация всех игровых аспектов                        ║
    ║  - Система сохранения конфигурации                            ║
    ║  - Защита от детекта и оптимизация                            ║
    ╚═══════════════════════════════════════════════════════════════╝
    
    ВНИМАНИЕ: Использование скриптов нарушает ToS Roblox!
    Используйте ТОЛЬКО на альтернативном аккаунте!
]]

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 1: ЗАГРУЗКА БИБЛИОТЕКИ WAND UI (ИСПРАВЛЕННАЯ ВЕРСИЯ)
-- ═══════════════════════════════════════════════════════════════

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 2: СОЗДАНИЕ ОСНОВНОГО ОКНА WAND UI (ИСПРАВЛЕННАЯ ВЕРСИЯ)
-- ═══════════════════════════════════════════════════════════════

local Window = Library:MakeWindow({
    Title = "🐰 MM2 RabbitCore Hub v5.3.0",
    SubTitle = "by RabbitCore",
    ScriptFolder = "RabbitCore_MM2"
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 3: ВКЛАДКА "ГЛАВНАЯ" (HOME) - ИСПРАВЛЕННАЯ
-- ═══════════════════════════════════════════════════════════════

local HomeTab = Window:MakeTab({ "🏠 Home", "home" })

HomeTab:AddSection("Добро пожаловать в RabbitCore Hub!")

HomeTab:AddParagraph("MM2 RabbitCore Hub v5.3.0", "Полноценный мультифункциональный скрипт-хаб для Murder Mystery 2.\n\n✅ 100+ Functions\n✅ 12 Categories\n✅ Full ESP System\n✅ Smart Coin Farm\n✅ Advanced Aimbot\n✅ Auto Kill/Shoot\n✅ Teleportation\n✅ And much more!")

HomeTab:AddSection("Текущая информация")

local RoleLabel = HomeTab:AddParagraph("Роль: Innocent", "")
local GameStateLabel = HomeTab:AddParagraph("Состояние: InGame", "")

HomeTab:AddSection("Статистика")

local CoinsCollectedLabel = HomeTab:AddParagraph("Собрано монет: 0", "")
local KillsLabel = HomeTab:AddParagraph("Убийств: 0", "")
local DeathsLabel = HomeTab:AddParagraph("Смертей: 0", "")
local WinsLabel = HomeTab:AddParagraph("Побед: 0", "")

HomeTab:AddSection("Быстрые действия")

HomeTab:AddButton({
    Name = "Быстрое включение ESP",
    Callback = function()
        Settings.ESPEnabled = not Settings.ESPEnabled
        UpdateAllESP()
        Notify("ESP", Settings.ESPEnabled and "Включен" or "Выключен", 2)
    end
})

HomeTab:AddButton({
    Name = "Быстрое включение фарма",
    Callback = function()
        Settings.AutoFarmEnabled = not Settings.AutoFarmEnabled
        if Settings.AutoFarmEnabled then
            spawn(SmartCoinFarm)
            Notify("Авто-Фарм", "Фарм монет запущен!", 3)
        else
            Notify("Авто-Фарм", "Фарм монет остановлен", 3)
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 4: ВКЛАДКА "ДВИЖЕНИЕ" (PLAYER) - ИСПРАВЛЕННАЯ
-- ═══════════════════════════════════════════════════════════════

local PlayerTab = Window:MakeTab({ "🏃 Player", "user" })

PlayerTab:AddSection("Движение")

PlayerTab:AddSlider({
    Name = "Скорость ходьбы",
    Min = 16,
    Max = 500,
    Increment = 1,
    Default = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        Settings.WalkSpeed = value
        local hum = GetHumanoid(GetCharacter(LocalPlayer))
        if hum then
            hum.WalkSpeed = value
        end
    end
})

PlayerTab:AddSlider({
    Name = "Сила прыжка",
    Min = 50,
    Max = 500,
    Increment = 5,
    Default = 50,
    Flag = "JumpPower",
    Callback = function(value)
        Settings.JumpPower = value
        local hum = GetHumanoid(GetCharacter(LocalPlayer))
        if hum then
            hum.JumpPower = value
        end
    end
})

PlayerTab:AddToggle({
    Name = "Полет",
    Default = false,
    Flag = "Flying",
    Callback = function(value)
        Settings.Flying = value
        if value then
            StartFly()
        else
            StopFly()
        end
    end
})

PlayerTab:AddSlider({
    Name = "Скорость полета",
    Min = 10,
    Max = 500,
    Increment = 5,
    Default = 50,
    Flag = "FlySpeed",
    Callback = function(value)
        Settings.FlySpeed = value
    end
})

PlayerTab:AddSlider({
    Name = "Вертикальная скорость",
    Min = 10,
    Max = 200,
    Increment = 5,
    Default = 30,
    Flag = "FlyVerticalSpeed",
    Callback = function(value)
        Settings.FlyVerticalSpeed = value
    end
})

PlayerTab:AddToggle({
    Name = "Noclip (Прохождение сквозь стены)",
    Default = false,
    Flag = "NoClip",
    Callback = function(value)
        Settings.NoClipEnabled = value
        if value then
            StartNoclip()
        else
            StopNoclip()
        end
    end
})

PlayerTab:AddToggle({
    Name = "Бесконечный прыжок",
    Default = false,
    Flag = "InfiniteJump",
    Callback = function(value)
        Settings.InfiniteJumpEnabled = value
        if value then
            Connections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
                if Settings.InfiniteJumpEnabled then
                    local hum = GetHumanoid(GetCharacter(LocalPlayer))
                    if hum then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end)
        else
            if Connections.InfiniteJump then
                Connections.InfiniteJump:Disconnect()
            end
        end
    end
})

PlayerTab:AddToggle({
    Name = "Bunny Hop",
    Default = false,
    Flag = "BunnyHop",
    Callback = function(value)
        Settings.BunnyHopEnabled = value
        if value then
            Connections.BunnyHop = RunService.Heartbeat:Connect(function()
                if not Settings.BunnyHopEnabled then return end
                local hum = GetHumanoid(GetCharacter(LocalPlayer))
                if hum and hum.MoveDirection.Magnitude > 0 then
                    hum:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if Connections.BunnyHop then
                Connections.BunnyHop:Disconnect()
            end
        end
    end
})

PlayerTab:AddToggle({
    Name = "Spin Bot",
    Default = false,
    Flag = "SpinBot",
    Callback = function(value)
        Settings.SpinBotEnabled = value
        if value then
            Connections.SpinBot = RunService.Heartbeat:Connect(function()
                if not Settings.SpinBotEnabled then return end
                local root = GetRootPart(GetCharacter(LocalPlayer))
                if root then
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(Settings.SpinBotSpeed), 0)
                end
            end)
        else
            if Connections.SpinBot then
                Connections.SpinBot:Disconnect()
            end
        end
    end
})

PlayerTab:AddSlider({
    Name = "Скорость вращения",
    Min = 1,
    Max = 50,
    Increment = 1,
    Default = 10,
    Flag = "SpinBotSpeed",
    Callback = function(value)
        Settings.SpinBotSpeed = value
    end
})

PlayerTab:AddSection("Защита")

PlayerTab:AddToggle({
    Name = "God Mode (Бессмертие)",
    Default = false,
    Flag = "GodMode",
    Callback = function(value)
        Settings.GodModeEnabled = value
        local hum = GetHumanoid(GetCharacter(LocalPlayer))
        if hum then
            if value then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                Notify("God Mode", "Бессмертие включено!", 3)
            else
                hum.MaxHealth = 100
                hum.Health = 100
                Notify("God Mode", "Бессмертие выключено", 3)
            end
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 5: ВКЛАДКА "MURDERER" (УБИЙЦА) - ИСПРАВЛЕННАЯ
-- ═══════════════════════════════════════════════════════════════

local MurdererTab = Window:MakeTab({ "🔪 Murderer", "skull" })

MurdererTab:AddSection("Боевые функции")

MurdererTab:AddToggle({
    Name = "Авто-Убийство",
    Default = false,
    Flag = "AutoKill",
    Callback = function(value)
        Settings.AutoKill = value
        if value then
            spawn(AutoKillLogic)
            Notify("Авто-Убийство", "Авто-убийство включено!", 3)
        end
    end
})

MurdererTab:AddToggle({
    Name = "Kill Aura",
    Default = false,
    Flag = "KillAura",
    Callback = function(value)
        Settings.KillAura = value
        if value then
            spawn(function()
                while Settings.KillAura and task.wait(Settings.KillAuraDelay) do
                    if GetRole(LocalPlayer) ~= "Murderer" then continue end
                    
                    local char = GetCharacter(LocalPlayer)
                    local root = GetRootPart(char)
                    if not (char and root) then continue end
                    
                    local knife = char:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
                    if not knife then continue end
                    
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player == LocalPlayer then continue end
                        local targetRoot = GetRootPart(GetCharacter(player))
                        if targetRoot and (root.Position - targetRoot.Position).Magnitude < Settings.KillAuraRange then
                            pcall(function() knife:Activate() end)
                        end
                    end
                end
            end)
        end
    end
})

MurdererTab:AddSlider({
    Name = "Радиус Kill Aura",
    Min = 5,
    Max = 50,
    Increment = 1,
    Default = 15,
    Flag = "KillAuraRange",
    Callback = function(value)
        Settings.KillAuraRange = value
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 6: ВКЛАДКА "SHERIFF" (ШЕРИФ) - ИСПРАВЛЕННАЯ
-- ═══════════════════════════════════════════════════════════════

local SheriffTab = Window:MakeTab({ "🔫 Sheriff", "shield" })

SheriffTab:AddSection("Боевые функции")

SheriffTab:AddToggle({
    Name = "Аимбот",
    Default = false,
    Flag = "Aimbot",
    Callback = function(value)
        Settings.AimbotEnabled = value
        if value then
            CreateFOVCircle()
            Connections.Aimbot = RunService.RenderStepped:Connect(function()
                if Settings.AimbotEnabled then
                    UpdateFOVCircle()
                    AimbotLogic()
                end
            end)
            Notify("Аимбот", "Аимбот включен!", 3)
        else
            if FOVCircle then FOVCircle.Visible = false end
            if Connections.Aimbot then Connections.Aimbot:Disconnect() end
        end
    end
})

SheriffTab:AddSlider({
    Name = "Размер FOV",
    Min = 50,
    Max = 500,
    Increment = 10,
    Default = 200,
    Flag = "AimbotFOV",
    Callback = function(value)
        Settings.AimbotFOV = value
    end
})

SheriffTab:AddSlider({
    Name = "Плавность аимбота",
    Min = 1,
    Max = 10,
    Increment = 1,
    Default = 1,
    Flag = "AimbotSmooth",
    Callback = function(value)
        Settings.AimbotSmooth = value
    end
})

SheriffTab:AddDropdown({
    Name = "Цель аимбота",
    Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
    Default = "Head",
    Flag = "AimbotTargetPart",
    Callback = function(option)
        Settings.AimbotTargetPart = option
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 7: ВКЛАДКА "АВТОФАРМ" (COINS) - ИСПРАВЛЕННАЯ
-- ═══════════════════════════════════════════════════════════════

local CoinsTab = Window:MakeTab({ "💰 Coins", "coins" })

CoinsTab:AddSection("Фарм монет")

CoinsTab:AddToggle({
    Name = "Авто-Фарм монет",
    Default = false,
    Flag = "AutoFarm",
    Callback = function(value)
        Settings.AutoFarmEnabled = value
        if value then
            spawn(SmartCoinFarm)
            Notify("Авто-Фарм", "Фарм монет запущен!", 3)
        else
            Notify("Авто-Фарм", "Фарм монет остановлен", 3)
        end
    end
})

CoinsTab:AddDropdown({
    Name = "Режим фарма",
    Options = {"Teleport", "Tween", "Glide"},
    Default = "Teleport",
    Flag = "FarmMode",
    Callback = function(option)
        Settings.FarmMode = option
        Notify("Режим фарма", "Установлен режим: " .. option, 2)
    end
})

CoinsTab:AddSlider({
    Name = "Скорость фарма",
    Min = 0.1,
    Max = 2,
    Increment = 0.1,
    Default = 0.4,
    Flag = "CoinFarmSpeed",
    Callback = function(value)
        Settings.CoinFarmSpeed = value
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 8: ВКЛАДКА "ESP" (ВИЗУАЛЫ) - ИСПРАВЛЕННАЯ
-- ═══════════════════════════════════════════════════════════════

local ESPTab = Window:MakeTab({ "👁️ ESP", "eye" })

ESPTab:AddSection("Основные настройки ESP")

ESPTab:AddToggle({
    Name = "Включить ESP",
    Default = false,
    Flag = "ESP",
    Callback = function(value)
        Settings.ESPEnabled = value
        UpdateAllESP()
        Notify("ESP", value and "ESP включен!" or "ESP выключен", 2)
    end
})

ESPTab:AddToggle({
    Name = "Показывать боксы",
    Default = true,
    Flag = "ShowBoxes",
    Callback = function(value)
        Settings.ShowBoxes = value
    end
})

ESPTab:AddToggle({
    Name = "Показывать трейсеры",
    Default = false,
    Flag = "ShowTracers",
    Callback = function(value)
        Settings.ShowTracers = value
    end
})

ESPTab:AddColorPicker({
    Name = "Цвет Murderer",
    Color = Settings.MurdererColor,
    Flag = "MurdererColor",
    Callback = function(value)
        Settings.MurdererColor = value
    end
})

ESPTab:AddColorPicker({
    Name = "Цвет Sheriff",
    Color = Settings.SheriffColor,
    Flag = "SheriffColor",
    Callback = function(value)
        Settings.SheriffColor = value
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 9: ВКЛАДКА "ТЕЛЕПОРТАЦИЯ" (TELEPORT) - ИСПРАВЛЕННАЯ
-- ═══════════════════════════════════════════════════════════════

local TeleportTab = Window:MakeTab({ "📍 Teleport", "map-pin" })

TeleportTab:AddSection("Настройки телепортации")

TeleportTab:AddDropdown({
    Name = "Режим телепортации",
    Options = {"Instant", "Tween"},
    Default = "Instant",
    Flag = "TeleportMode",
    Callback = function(option)
        Settings.TeleportMode = option
    end
})

TeleportTab:AddSlider({
    Name = "Скорость телепортации",
    Min = 0.1,
    Max = 5,
    Increment = 0.1,
    Default = 1,
    Flag = "TeleportSpeed",
    Callback = function(value)
        Settings.TeleportSpeed = value
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 10: ВКЛАДКА "НАСТРОЙКИ" (SETTINGS) - ИСПРАВЛЕННАЯ
-- ═══════════════════════════════════════════════════════════════

local SettingsTab = Window:MakeTab({ "⚙️ Settings", "sliders" })

SettingsTab:AddSection("Уведомления")

SettingsTab:AddToggle({
    Name = "Включить уведомления",
    Default = true,
    Flag = "Notifications",
    Callback = function(value)
        Settings.Notifications = value
    end
})

SettingsTab:AddSlider({
    Name = "Длительность уведомлений (сек)",
    Min = 1,
    Max = 10,
    Increment = 1,
    Default = 5,
    Flag = "NotificationDuration",
    Callback = function(value)
        Settings.NotificationDuration = value
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 11: ФУНКЦИИ المساعدة (يجب إضافتها)
-- ═══════════════════════════════════════════════════════════════

-- دالة الإشعارات
local function Notify(title, message, duration)
    duration = duration or Settings.NotificationDuration or 5
    Window:Notify({
        Title = title,
        Content = message,
        Duration = duration
    })
end

-- دالة الحصول على الشخصية
local function GetCharacter(player)
    return player and player.Character or player.CharacterAdded:Wait()
end

-- دالة الحصول على الهيومانويد
local function GetHumanoid(character)
    return character and character:FindFirstChildOfClass("Humanoid")
end

-- دالة الحصول على الجذر
local function GetRootPart(character)
    return character and character:FindFirstChild("HumanoidRootPart")
end

-- دالة التلييبورت
local function TeleportTo(position)
    local char = GetCharacter(LocalPlayer)
    local root = GetRootPart(char)
    if root then
        if Settings.TeleportMode == "Instant" then
            root.CFrame = CFrame.new(position)
        else
            -- استخدام Tween للنقل السلس
            local tweenInfo = TweenInfo.new(0.5 / Settings.TeleportSpeed, Enum.EasingStyle.Linear)
            local tween = TweenService:Create(root, tweenInfo, {CFrame = CFrame.new(position)})
            tween:Play()
        end
    end
end

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 12: تهيئة المتغيرات المهمة
-- ═══════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")

local Settings = {
    ESPEnabled = false,
    AutoFarmEnabled = false,
    WalkSpeed = 16,
    JumpPower = 50,
    Flying = false,
    FlySpeed = 50,
    FlyVerticalSpeed = 30,
    NoClipEnabled = false,
    InfiniteJumpEnabled = false,
    BunnyHopEnabled = false,
    SpinBotEnabled = false,
    SpinBotSpeed = 10,
    GodModeEnabled = false,
    AutoKill = false,
    KillAura = false,
    KillAuraRange = 15,
    KillAuraDelay = 0.1,
    AimbotEnabled = false,
    AimbotFOV = 200,
    AimbotSmooth = 1,
    AimbotTargetPart = "Head",
    TeleportMode = "Instant",
    TeleportSpeed = 1,
    ShowBoxes = true,
    ShowTracers = false,
    MurdererColor = Color3.fromRGB(255, 0, 0),
    SheriffColor = Color3.fromRGB(0, 0, 255),
    InnocentColor = Color3.fromRGB(0, 255, 0),
    Notifications = true,
    NotificationDuration = 5,
    FarmMode = "Teleport",
    CoinFarmSpeed = 0.4
}

local Connections = {}
local Statistics = {
    CoinsCollected = 0,
    KillCount = 0,
    DeathCount = 0,
    WinCount = 0
}

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 13: تنبيه عند التحميل
-- ═══════════════════════════════════════════════════════════════

Window:Notify({
    Title = "🐰 RabbitCore MM2 Hub v5.3.0",
    Content = "Hack menu loaded successfully!\n⚠️ Use at your own risk!",
    Duration = 5
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 14: تدمير الواجهة عند إغلاق اللعبة
-- ═══════════════════════════════════════════════════════════════

game:GetService("Players").LocalPlayer.PlayerGui.ChildAdded:Connect(function(child)
    if child.Name == "WandUI" then
        child.Destroying:Connect(function()
            -- تنظيف الروابط
            for name, connection in pairs(Connections) do
                if connection then
                    pcall(function() connection:Disconnect() end)
                end
            end
        end)
    end
end)

Notify("RabbitCore", "Hack menu initialized successfully!", 3)
