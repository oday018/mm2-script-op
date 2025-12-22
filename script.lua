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
-- РАЗДЕЛ 1: ЗАГРУЗКА БИБЛИОТЕКИ WAND UI
-- ═══════════════════════════════════════════════════════════════

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 2: ГЛОБАЛЬНЫЕ НАСТРОЙКИ И ФЛАГИ
-- ═══════════════════════════════════════════════════════════════

local Settings = {
    -- Player Movement Settings
    WalkSpeed = 16,
    JumpPower = 50,
    FlySpeed = 50,
    FlyVerticalSpeed = 30,
    NoClipEnabled = false,
    GodModeEnabled = false,
    InfiniteJumpEnabled = false,
    BunnyHopEnabled = false,
    SpinBotEnabled = false,
    SpinBotSpeed = 10,
    
    -- Player Protection Settings
    AntiRagdoll = false,
    AntiSlow = false,
    AntiStun = false,
    InfiniteStamina = false,
    AutoRespawn = false,
    
    -- Teleport Settings
    TeleportSpeed = 1,
    TeleportMode = "Instant",
    SafeTeleport = true,
    TeleportCooldown = 0.5,
    
    -- ESP Settings
    ESPEnabled = false,
    ShowBoxes = true,
    ShowTracers = false,
    ShowNames = true,
    ShowDistance = true,
    ShowHealth = true,
    ShowRoles = true,
    ShowSkeleton = false,
    ShowHeadDot = false,
    ShowLookDirection = false,
    ESPThickness = 1,
    ESPTransparency = 1,
    ESPRefreshRate = 0.1,
    
    -- ESP Colors
    MurdererColor = Color3.fromRGB(255, 0, 0),
    SheriffColor = Color3.fromRGB(0, 0, 255),
    InnocentColor = Color3.fromRGB(0, 255, 0),
    TracerColor = Color3.fromRGB(255, 255, 255),
    
    -- Visuals Settings
    FullBright = false,
    RemoveFog = false,
    Xray = false,
    PlayerChams = false,
    WeaponChams = false,
    CoinChams = false,
    AmbientColor = Color3.fromRGB(255, 255, 255),
    
    -- Camera Settings
    FOVValue = 70,
    ThirdPerson = false,
    ThirdPersonDistance = 15,
    CameraShakeRemoval = false,
    
    -- Murderer Settings
    AutoKill = false,
    KillAura = false,
    KillAuraRange = 15,
    KillAuraDelay = 0.1,
    SilentKill = false,
    AutoStab = false,
    ThrowKnifeAimbot = false,
    ThrowKnifeAimbotFOV = 180,
    TeleportKill = false,
    KillAllEnabled = false,
    MurdererAutoWin = false,
    
    -- Sheriff Settings
    AimbotEnabled = false,
    AimbotFOV = 200,
    AimbotSmooth = 1,
    AimbotTargetPart = "Head",
    AimbotPrediction = false,
    AimbotPredictionAmount = 0.1,
    SilentAim = false,
    AutoShoot = false,
    ShootAura = false,
    ShootAuraRange = 100,
    NoRecoil = false,
    NoSpread = false,
    InfiniteAmmo = false,
    RapidFire = false,
    RapidFireDelay = 0.1,
    AutoGrabGun = false,
    ShowFOVCircle = true,
    
    -- Innocent Settings
    AutoHide = false,
    AutoRunFromMurderer = false,
    RunFromMurdererDistance = 50,
    SafeSpotFinder = false,
    AutoGrabGunInnocent = false,
    RoleRevealNotif = true,
    MurdererProximityAlert = true,
    AlertDistance = 30,
    
    -- Coin Farm Settings
    AutoFarmEnabled = false,
    FarmMode = "Teleport",
    CoinFarmSpeed = 0.4,
    SmartCoinFarm = true,
    CoinESP = false,
    CoinTrackerEnabled = false,
    AutoCollectCoins = true,
    FarmOnlyWhenInnocent = true,
    AvoidMurdererWhileFarming = true,
    BagFullAction = "WaitForMurderer",
    CoinRangeCollection = 7,
    TeleportUnderCoin = true,
    UnderCoinOffset = -50,
    
    -- Automation Settings
    AntiAFK = false,
    AutoWin = false,
    AutoPlay = false,
    AutoRequeue = false,
    AutoSkipLobby = false,
    
    -- Misc Settings
    Notifications = true,
    NotificationDuration = 5,
    ChatNotifications = false,
    SoundNotifications = false,
    
    -- Trolling Settings
    FlingPlayers = false,
    FlingPower = 100,
    SpamChat = false,
    ChatSpamText = "RabbitCore on top!",
    ChatSpamDelay = 1,
    FakeRole = "None",
    
    -- Performance Settings
    OptimizePerformance = false,
    LowGraphics = false,
    DisableParticles = false,
    DisableAnimations = false,
}

-- Скрытые флаги для внутренней логики
local HiddenFlags = {
    CurrentlyMoving = false,
    CurrentlyTeleporting = false,
    LastTeleportTime = 0,
    GunDebounce = 0,
    KillDebounce = 0,
    CachedCoins = setmetatable({}, { __mode = "kv" }),
    CachedPlayers = {},
    CurrentMap = nil,
    GameState = "Lobby",
    LocalRole = "Innocent",
    MurdererPlayer = nil,
    SheriffPlayer = nil,
    DroppedGun = nil,
    LastCoinCheck = 0,
    PerformanceMode = false,
}

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 3: СОЗДАНИЕ ОСНОВНОГО ОКНА WAND UI
-- ═══════════════════════════════════════════════════════════════

local Window = Library:MakeWindow({
    Title = "🐰 MM2 RabbitCore Hub v5.3.0",
    SubTitle = "by RabbitCore",
    ScriptFolder = "RabbitCore_MM2"
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 4: ВКЛАДКА "ГЛАВНАЯ" (HOME)
-- ═══════════════════════════════════════════════════════════════

local HomeTab = Window:CreateTab("🏠 Home", "home")

local HomeSection = HomeTab:CreateSection("Добро пожаловать в RabbitCore Hub!")

HomeTab:CreateParagraph({
    Title = "MM2 RabbitCore Hub v5.3.0",
    Content = "Полноценный мультифункциональный скрипт-хаб для Murder Mystery 2.\n\n" ..
              "✅ 100+ Functions\n" ..
              "✅ 12 Categories\n" ..
              "✅ Full ESP System\n" ..
              "✅ Smart Coin Farm\n" ..
              "✅ Advanced Aimbot\n" ..
              "✅ Auto Kill/Shoot\n" ..
              "✅ Teleportation\n" ..
              "✅ And much more!"
})

local InfoSection = HomeTab:CreateSection("Текущая информация")

local RoleLabel = HomeTab:CreateLabel("Роль: Innocent")
local GameStateLabel = HomeTab:CreateLabel("Состояние: InGame")

local StatsSection = HomeTab:CreateSection("Статистика")

local CoinsCollectedLabel = HomeTab:CreateLabel("Собрано монет: 0")
local KillsLabel = HomeTab:CreateLabel("Убийств: 0")
local DeathsLabel = HomeTab:CreateLabel("Смертей: 0")
local WinsLabel = HomeTab:CreateLabel("Побед: 0")

local QuickActionsSection = HomeTab:CreateSection("Быстрые действия")

HomeTab:CreateButton({
    Name = "Быстрое включение ESP",
    Callback = function()
        Settings.ESPEnabled = not Settings.ESPEnabled
        UpdateAllESP()
        Notify("ESP", Settings.ESPEnabled and "Включен" or "Выключен", 2)
    end
})

HomeTab:CreateButton({
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
-- РАЗДЕЛ 5: ВКЛАДКА "ДВИЖЕНИЕ" (PLAYER)
-- ═══════════════════════════════════════════════════════════════

local PlayerTab = Window:CreateTab("🏃 Player", "user")

local MovementSection = PlayerTab:CreateSection("Движение")

PlayerTab:CreateSlider({
    Name = "Скорость ходьбы",
    Range = {16, 500},
    Increment = 1,
    Suffix = " studs/s",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(value)
        Settings.WalkSpeed = value
        local hum = GetHumanoid(GetCharacter(LocalPlayer))
        if hum then
            hum.WalkSpeed = value
        end
    end
})

PlayerTab:CreateSlider({
    Name = "Сила прыжка",
    Range = {50, 500},
    Increment = 5,
    Suffix = " power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(value)
        Settings.JumpPower = value
        local hum = GetHumanoid(GetCharacter(LocalPlayer))
        if hum then
            hum.JumpPower = value
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Полет",
    CurrentValue = false,
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

PlayerTab:CreateSlider({
    Name = "Скорость полета",
    Range = {10, 500},
    Increment = 5,
    Suffix = " studs/s",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(value)
        Settings.FlySpeed = value
    end
})

PlayerTab:CreateSlider({
    Name = "Вертикальная скорость",
    Range = {10, 200},
    Increment = 5,
    Suffix = " studs/s",
    CurrentValue = 30,
    Flag = "FlyVerticalSpeed",
    Callback = function(value)
        Settings.FlyVerticalSpeed = value
    end
})

PlayerTab:CreateToggle({
    Name = "Noclip (Прохождение сквозь стены)",
    CurrentValue = false,
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

PlayerTab:CreateToggle({
    Name = "Бесконечный прыжок",
    CurrentValue = false,
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

PlayerTab:CreateToggle({
    Name = "Bunny Hop",
    CurrentValue = false,
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

PlayerTab:CreateToggle({
    Name = "Spin Bot",
    CurrentValue = false,
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

PlayerTab:CreateSlider({
    Name = "Скорость вращения",
    Range = {1, 50},
    Increment = 1,
    Suffix = "°",
    CurrentValue = 10,
    Flag = "SpinBotSpeed",
    Callback = function(value)
        Settings.SpinBotSpeed = value
    end
})

local ProtectionSection = PlayerTab:CreateSection("Защита")

PlayerTab:CreateToggle({
    Name = "God Mode (Бессмертие)",
    CurrentValue = false,
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

PlayerTab:CreateToggle({
    Name = "Anti-Ragdoll",
    CurrentValue = false,
    Flag = "AntiRagdoll",
    Callback = function(value)
        Settings.AntiRagdoll = value
        if value then
            Connections.AntiRagdoll = RunService.Stepped:Connect(function()
                if not Settings.AntiRagdoll then return end
                local char = GetCharacter(LocalPlayer)
                if char then
                    for _, part in ipairs(char:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if Connections.AntiRagdoll then
                Connections.AntiRagdoll:Disconnect()
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Anti-Slow",
    CurrentValue = false,
    Flag = "AntiSlow",
    Callback = function(value)
        Settings.AntiSlow = value
    end
})

PlayerTab:CreateToggle({
    Name = "Anti-Stun",
    CurrentValue = false,
    Flag = "AntiStun",
    Callback = function(value)
        Settings.AntiStun = value
    end
})

PlayerTab:CreateToggle({
    Name = "Infinite Stamina (Бесконечная выносливость)",
    CurrentValue = false,
    Flag = "InfiniteStamina",
    Callback = function(value)
        Settings.InfiniteStamina = value
    end
})

PlayerTab:CreateToggle({
    Name = "Auto Respawn (Авто-респавн)",
    CurrentValue = false,
    Flag = "AutoRespawn",
    Callback = function(value)
        Settings.AutoRespawn = value
        if value then
            spawn(function()
                while Settings.AutoRespawn do
                    local hum = GetHumanoid(GetCharacter(LocalPlayer))
                    if hum and hum.Health <= 0 then
                        task.wait(1)
                        LocalPlayer:LoadCharacter()
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

local UtilitySection = PlayerTab:CreateSection("Утилиты")

PlayerTab:CreateButton({
    Name = "Сбросить персонажа",
    Callback = function()
        local hum = GetHumanoid(GetCharacter(LocalPlayer))
        if hum then
            hum.Health = 0
            Notify("Сброс", "Персонаж сброшен!", 2)
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 6: ВКЛАДКА "MURDERER" (УБИЙЦА)
-- ═══════════════════════════════════════════════════════════════

local MurdererTab = Window:CreateTab("🔪 Murderer", "skull")

local MurdererCombatSection = MurdererTab:CreateSection("Боевые функции")

MurdererTab:CreateToggle({
    Name = "Авто-Убийство",
    CurrentValue = false,
    Flag = "AutoKill",
    Callback = function(value)
        Settings.AutoKill = value
        if value then
            spawn(AutoKillLogic)
            Notify("Авто-Убийство", "Авто-убийство включено!", 3)
        end
    end
})

MurdererTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
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

MurdererTab:CreateSlider({
    Name = "Радиус Kill Aura",
    Range = {5, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 15,
    Flag = "KillAuraRange",
    Callback = function(value)
        Settings.KillAuraRange = value
    end
})

MurdererTab:CreateSlider({
    Name = "Задержка Kill Aura (сек)",
    Range = {0.1, 2},
    Increment = 0.1,
    Suffix = " сек",
    CurrentValue = 0.1,
    Flag = "KillAuraDelay",
    Callback = function(value)
        Settings.KillAuraDelay = value
    end
})

MurdererTab:CreateToggle({
    Name = "Телепорт к цели",
    CurrentValue = false,
    Flag = "TeleportKill",
    Callback = function(value)
        Settings.TeleportKill = value
    end
})

MurdererTab:CreateToggle({
    Name = "Silent Kill (Тихое убийство)",
    CurrentValue = false,
    Flag = "SilentKill",
    Callback = function(value)
        Settings.SilentKill = value
    end
})

MurdererTab:CreateToggle({
    Name = "Auto Stab (Авто-удар ножом)",
    CurrentValue = false,
    Flag = "AutoStab",
    Callback = function(value)
        Settings.AutoStab = value
    end
})

MurdererTab:CreateToggle({
    Name = "Throw Knife Aimbot (Аимбот броска)",
    CurrentValue = false,
    Flag = "ThrowKnifeAimbot",
    Callback = function(value)
        Settings.ThrowKnifeAimbot = value
    end
})

MurdererTab:CreateSlider({
    Name = "FOV броска ножа",
    Range = {50, 360},
    Increment = 10,
    Suffix = "°",
    CurrentValue = 180,
    Flag = "ThrowKnifeAimbotFOV",
    Callback = function(value)
        Settings.ThrowKnifeAimbotFOV = value
    end
})

MurdererTab:CreateToggle({
    Name = "Kill All (Убить всех)",
    CurrentValue = false,
    Flag = "KillAllEnabled",
    Callback = function(value)
        Settings.KillAllEnabled = value
        if value then
            spawn(function()
                while Settings.KillAllEnabled and task.wait(0.5) do
                    if GetRole(LocalPlayer) == "Murderer" then
                        local char = GetCharacter(LocalPlayer)
                        local root = GetRootPart(char)
                        local hum = GetHumanoid(char)
                        
                        if not (char and root and hum) then continue end
                        
                        local knife = char:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
                        if not knife then continue end
                        
                        if knife.Parent == LocalPlayer.Backpack then
                            hum:EquipTool(knife)
                            task.wait(0.2)
                        end
                        
                        local originalPos = root.CFrame
                        local killCount = 0
                        
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player == LocalPlayer then continue end
                            
                            local targetChar = GetCharacter(player)
                            local targetRoot = GetRootPart(targetChar)
                            
                            if not (targetChar and targetRoot) then continue end
                            
                            TeleportTo(targetRoot.Position + Vector3.new(0, 0, 2))
                            task.wait(0.1)
                            
                            pcall(function() knife:Activate() end)
                            killCount = killCount + 1
                            
                            task.wait(0.1)
                        end
                        
                        TeleportTo(originalPos.Position)
                        Notify("Kill All", "Убито игроков: " .. killCount, 5)
                        Statistics.KillCount = Statistics.KillCount + killCount
                    end
                end
            end)
        end
    end
})

MurdererTab:CreateToggle({
    Name = "Murderer Auto Win (Авто-победа)",
    CurrentValue = false,
    Flag = "MurdererAutoWin",
    Callback = function(value)
        Settings.MurdererAutoWin = value
        if value then
            spawn(function()
                while Settings.MurdererAutoWin and task.wait(2) do
                    if GetRole(LocalPlayer) == "Murderer" then
                        Settings.TeleportKill = true
                        Settings.KillAura = true
                        Settings.KillAuraRange = 50
                        
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer then
                                local char = GetCharacter(player)
                                local hum = GetHumanoid(char)
                                if hum and hum.Health > 0 then
                                    local root = GetRootPart(char)
                                    if root then
                                        TeleportTo(root.Position)
                                        task.wait(0.1)
                                        KillPlayer(player)
                                        task.wait(0.3)
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

local MurdererUtilitySection = MurdererTab:CreateSection("Утилиты")

MurdererTab:CreateButton({
    Name = "Телепорт к Murderer",
    Callback = function()
        local murderer = FindPlayerByRole("Murderer")
        if murderer then
            local root = GetRootPart(GetCharacter(murderer))
            if root then
                TeleportTo(root.Position)
                Notify("Телепорт", "Телепортированы к Murderer", 2)
            end
        else
            Notify("Ошибка", "Murderer не найден", 2)
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 7: ВКЛАДКА "SHERIFF" (ШЕРИФ)
-- ═══════════════════════════════════════════════════════════════

local SheriffTab = Window:CreateTab("🔫 Sheriff", "shield")

local SheriffCombatSection = SheriffTab:CreateSection("Боевые функции")

SheriffTab:CreateToggle({
    Name = "Аимбот",
    CurrentValue = false,
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

SheriffTab:CreateSlider({
    Name = "Размер FOV",
    Range = {50, 500},
    Increment = 10,
    Suffix = " px",
    CurrentValue = 200,
    Flag = "AimbotFOV",
    Callback = function(value)
        Settings.AimbotFOV = value
    end
})

SheriffTab:CreateSlider({
    Name = "Плавность аимбота",
    Range = {1, 10},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "AimbotSmooth",
    Callback = function(value)
        Settings.AimbotSmooth = value
    end
})

SheriffTab:CreateDropdown({
    Name = "Цель аимбота",
    Options = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
    CurrentOption = "Head",
    Flag = "AimbotTargetPart",
    Callback = function(option)
        Settings.AimbotTargetPart = option
    end
})

SheriffTab:CreateToggle({
    Name = "Предсказание движения",
    CurrentValue = false,
    Flag = "AimbotPrediction",
    Callback = function(value)
        Settings.AimbotPrediction = value
    end
})

SheriffTab:CreateSlider({
    Name = "Коэффициент предсказания",
    Range = {0.05, 0.5},
    Increment = 0.05,
    Suffix = "x",
    CurrentValue = 0.1,
    Flag = "AimbotPredictionAmount",
    Callback = function(value)
        Settings.AimbotPredictionAmount = value
    end
})

SheriffTab:CreateToggle({
    Name = "Silent Aim (Тихий аим)",
    CurrentValue = false,
    Flag = "SilentAim",
    Callback = function(value)
        Settings.SilentAim = value
    end
})

SheriffTab:CreateToggle({
    Name = "Авто-Стрельба",
    CurrentValue = false,
    Flag = "AutoShoot",
    Callback = function(value)
        Settings.AutoShoot = value
        if value then
            spawn(AutoShootLogic)
        end
    end
})

SheriffTab:CreateToggle({
    Name = "Shoot Aura (Аура стрельбы)",
    CurrentValue = false,
    Flag = "ShootAura",
    Callback = function(value)
        Settings.ShootAura = value
        if value then
            spawn(function()
                while Settings.ShootAura and task.wait(0.1) do
                    if GetRole(LocalPlayer) == "Sheriff" then
                        local char = GetCharacter(LocalPlayer)
                        local root = GetRootPart(char)
                        if not (char and root) then continue end
                        
                        local gun = char:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
                        if not gun then continue end
                        
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player == LocalPlayer then continue end
                            local targetRoot = GetRootPart(GetCharacter(player))
                            if targetRoot and (root.Position - targetRoot.Position).Magnitude < Settings.ShootAuraRange then
                                pcall(function() gun:Activate() end)
                            end
                        end
                    end
                end
            end)
        end
    end
})

SheriffTab:CreateSlider({
    Name = "Радиус Shoot Aura",
    Range = {20, 200},
    Increment = 10,
    Suffix = " studs",
    CurrentValue = 100,
    Flag = "ShootAuraRange",
    Callback = function(value)
        Settings.ShootAuraRange = value
    end
})

SheriffTab:CreateToggle({
    Name = "No Recoil (Без отдачи)",
    CurrentValue = false,
    Flag = "NoRecoil",
    Callback = function(value)
        Settings.NoRecoil = value
    end
})

SheriffTab:CreateToggle({
    Name = "No Spread (Без разброса)",
    CurrentValue = false,
    Flag = "NoSpread",
    Callback = function(value)
        Settings.NoSpread = value
    end
})

SheriffTab:CreateToggle({
    Name = "Infinite Ammo (Бесконечные патроны)",
    CurrentValue = false,
    Flag = "InfiniteAmmo",
    Callback = function(value)
        Settings.InfiniteAmmo = value
    end
})

SheriffTab:CreateToggle({
    Name = "Rapid Fire (Быстрая стрельба)",
    CurrentValue = false,
    Flag = "RapidFire",
    Callback = function(value)
        Settings.RapidFire = value
    end
})

SheriffTab:CreateSlider({
    Name = "Задержка быстрой стрельбы",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = " сек",
    CurrentValue = 0.1,
    Flag = "RapidFireDelay",
    Callback = function(value)
        Settings.RapidFireDelay = value
    end
})

SheriffTab:CreateToggle({
    Name = "Auto Grab Gun (Авто-подбор оружия)",
    CurrentValue = false,
    Flag = "AutoGrabGun",
    Callback = function(value)
        Settings.AutoGrabGun = value
        if value then
            spawn(AutoGrabGunLogic)
        end
    end
})

SheriffTab:CreateButton({
    Name = "Телепорт к Sheriff",
    Callback = function()
        local sheriff = FindPlayerByRole("Sheriff")
        if sheriff then
            local root = GetRootPart(GetCharacter(sheriff))
            if root then
                TeleportTo(root.Position)
                Notify("Телепорт", "Телепортированы к Sheriff", 2)
            end
        else
            Notify("Ошибка", "Sheriff не найден", 2)
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 8: ВКЛАДКА "INNOCENT" (НЕВИННЫЙ)
-- ═══════════════════════════════════════════════════════════════

local InnocentTab = Window:CreateTab("😇 Innocent", "user-check")

local InnocentSafetySection = InnocentTab:CreateSection("Безопасность")

InnocentTab:CreateToggle({
    Name = "Авто-Укрытие от убийцы",
    CurrentValue = false,
    Flag = "AutoHide",
    Callback = function(value)
        Settings.AutoHide = value
        if value then
            spawn(AutoHideLogic)
        end
    end
})

InnocentTab:CreateToggle({
    Name = "Авто-Бег от убийцы",
    CurrentValue = false,
    Flag = "AutoRunFromMurderer",
    Callback = function(value)
        Settings.AutoRunFromMurderer = value
        if value then
            spawn(AutoRunFromMurdererLogic)
        end
    end
})

InnocentTab:CreateSlider({
    Name = "Дистанция побега",
    Range = {20, 100},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = 50,
    Flag = "RunFromMurdererDistance",
    Callback = function(value)
        Settings.RunFromMurdererDistance = value
    end
})

InnocentTab:CreateToggle({
    Name = "Safe Spot Finder (Поиск безопасных мест)",
    CurrentValue = false,
    Flag = "SafeSpotFinder",
    Callback = function(value)
        Settings.SafeSpotFinder = value
    end
})

InnocentTab:CreateToggle({
    Name = "Авто-подбор оружия (Sheriff)",
    CurrentValue = false,
    Flag = "AutoGrabGunInnocent",
    Callback = function(value)
        Settings.AutoGrabGunInnocent = value
        if value then
            spawn(AutoGrabGunLogic)
        end
    end
})

local InnocentNotificationsSection = InnocentTab:CreateSection("Уведомления и алерты")

InnocentTab:CreateToggle({
    Name = "Уведомления о ролях",
    CurrentValue = true,
    Flag = "RoleRevealNotif",
    Callback = function(value)
        Settings.RoleRevealNotif = value
    end
})

InnocentTab:CreateToggle({
    Name = "Алерт приближения убийцы",
    CurrentValue = true,
    Flag = "MurdererProximityAlert",
    Callback = function(value)
        Settings.MurdererProximityAlert = value
    end
})

InnocentTab:CreateSlider({
    Name = "Дистанция алерта",
    Range = {10, 100},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = 30,
    Flag = "AlertDistance",
    Callback = function(value)
        Settings.AlertDistance = value
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 9: ВКЛАДКА "АВТОФАРМ" (COINS)
-- ═══════════════════════════════════════════════════════════════

local CoinsTab = Window:CreateTab("💰 Coins", "coins")

local CoinFarmSection = CoinsTab:CreateSection("Фарм монет")

CoinsTab:CreateToggle({
    Name = "Авто-Фарм монет",
    CurrentValue = false,
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

CoinsTab:CreateDropdown({
    Name = "Режим фарма",
    Options = {"Teleport", "Tween", "Glide"},
    CurrentOption = "Teleport",
    Flag = "FarmMode",
    Callback = function(option)
        Settings.FarmMode = option
        Notify("Режим фарма", "Установлен режим: " .. option, 2)
    end
})

CoinsTab:CreateSlider({
    Name = "Скорость фарма",
    Range = {0.1, 2},
    Increment = 0.1,
    Suffix = " сек",
    CurrentValue = 0.4,
    Flag = "CoinFarmSpeed",
    Callback = function(value)
        Settings.CoinFarmSpeed = value
    end
})

CoinsTab:CreateToggle({
    Name = "Фармить только как Innocent",
    CurrentValue = true,
    Flag = "FarmOnlyWhenInnocent",
    Callback = function(value)
        Settings.FarmOnlyWhenInnocent = value
    end
})

CoinsTab:CreateToggle({
    Name = "Избегать убийцу при фарме",
    CurrentValue = true,
    Flag = "AvoidMurdererWhileFarming",
    Callback = function(value)
        Settings.AvoidMurdererWhileFarming = value
    end
})

CoinsTab:CreateSlider({
    Name = "Радиус сбора монет",
    Range = {3, 20},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 7,
    Flag = "CoinRangeCollection",
    Callback = function(value)
        Settings.CoinRangeCollection = value
    end
})

CoinsTab:CreateToggle({
    Name = "Coin ESP",
    CurrentValue = false,
    Flag = "CoinESP",
    Callback = function(value)
        Settings.CoinESP = value
        if value then
            spawn(function()
                while Settings.CoinESP and task.wait(1) do
                    local map = GetMap()
                    if map and map:FindFirstChild("CoinContainer") then
                        for _, coin in ipairs(map.CoinContainer:GetChildren()) do
                            if not CoinESPObjects[coin] then
                                CreateCoinESP(coin)
                            end
                        end
                    end
                end
            end)
        else
            for coin, esp in pairs(CoinESPObjects) do
                if esp.UpdateConnection then esp.UpdateConnection:Disconnect() end
                if esp.Box then esp.Box:Remove() end
                if esp.Distance then esp.Distance:Remove() end
            end
            CoinESPObjects = {}
        end
    end
})

CoinsTab:CreateToggle({
    Name = "Coin Tracker (Трекер монет)",
    CurrentValue = false,
    Flag = "CoinTracker",
    Callback = function(value)
        Settings.CoinTrackerEnabled = value
    end
})

CoinsTab:CreateToggle({
    Name = "Авто-сбор монет",
    CurrentValue = true,
    Flag = "AutoCollectCoins",
    Callback = function(value)
        Settings.AutoCollectCoins = value
    end
})

CoinsTab:CreateDropdown({
    Name = "Действие при полной сумке",
    Options = {"WaitForMurderer", "KeepFarming", "Hide", "TeleportToSafety"},
    CurrentOption = "WaitForMurderer",
    Flag = "BagFullAction",
    Callback = function(option)
        Settings.BagFullAction = option
    end
})

CoinsTab:CreateToggle({
    Name = "Телепорт под монету",
    CurrentValue = true,
    Flag = "TeleportUnderCoin",
    Callback = function(value)
        Settings.TeleportUnderCoin = value
    end
})

CoinsTab:CreateSlider({
    Name = "Offset под монетой",
    Range = {-100, 0},
    Increment = 5,
    Suffix = " studs",
    CurrentValue = -50,
    Flag = "UnderCoinOffset",
    Callback = function(value)
        Settings.UnderCoinOffset = value
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 10: ВКЛАДКА "ESP" (ВИЗУАЛЫ)
-- ═══════════════════════════════════════════════════════════════

local ESPTab = Window:CreateTab("👁️ ESP", "eye")

local ESPMainSection = ESPTab:CreateSection("Основные настройки ESP")

ESPTab:CreateToggle({
    Name = "Включить ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(value)
        Settings.ESPEnabled = value
        UpdateAllESP()
        Notify("ESP", value and "ESP включен!" or "ESP выключен", 2)
    end
})

ESPTab:CreateToggle({
    Name = "Показывать боксы",
    CurrentValue = true,
    Flag = "ShowBoxes",
    Callback = function(value)
        Settings.ShowBoxes = value
    end
})

ESPTab:CreateToggle({
    Name = "Показывать трейсеры",
    CurrentValue = false,
    Flag = "ShowTracers",
    Callback = function(value)
        Settings.ShowTracers = value
    end
})

ESPTab:CreateToggle({
    Name = "Показывать имена",
    CurrentValue = true,
    Flag = "ShowNames",
    Callback = function(value)
        Settings.ShowNames = value
    end
})

ESPTab:CreateToggle({
    Name = "Показывать дистанцию",
    CurrentValue = true,
    Flag = "ShowDistance",
    Callback = function(value)
        Settings.ShowDistance = value
    end
})

ESPTab:CreateToggle({
    Name = "Показывать здоровье",
    CurrentValue = true,
    Flag = "ShowHealth",
    Callback = function(value)
        Settings.ShowHealth = value
    end
})

ESPTab:CreateToggle({
    Name = "Показывать роли",
    CurrentValue = true,
    Flag = "ShowRoles",
    Callback = function(value)
        Settings.ShowRoles = value
    end
})

ESPTab:CreateToggle({
    Name = "Показывать скелет",
    CurrentValue = false,
    Flag = "ShowSkeleton",
    Callback = function(value)
        Settings.ShowSkeleton = value
    end
})

ESPTab:CreateToggle({
    Name = "Точка на голове",
    CurrentValue = false,
    Flag = "ShowHeadDot",
    Callback = function(value)
        Settings.ShowHeadDot = value
    end
})

ESPTab:CreateToggle({
    Name = "Направление взгляда",
    CurrentValue = false,
    Flag = "ShowLookDirection",
    Callback = function(value)
        Settings.ShowLookDirection = value
    end
})

ESPTab:CreateSlider({
    Name = "Толщина линий ESP",
    Range = {1, 5},
    Increment = 1,
    Suffix = " px",
    CurrentValue = 1,
    Flag = "ESPThickness",
    Callback = function(value)
        Settings.ESPThickness = value
    end
})

ESPTab:CreateSlider({
    Name = "Прозрачность ESP",
    Range = {0.1, 1},
    Increment = 0.1,
    Suffix = "",
    CurrentValue = 1,
    Flag = "ESPTransparency",
    Callback = function(value)
        Settings.ESPTransparency = value
    end
})

ESPTab:CreateSlider({
    Name = "Частота обновления ESP (сек)",
    Range = {0.05, 1},
    Increment = 0.05,
    Suffix = " сек",
    CurrentValue = 0.1,
    Flag = "ESPRefreshRate",
    Callback = function(value)
        Settings.ESPRefreshRate = value
    end
})

local ESPColorSection = ESPTab:CreateSection("Цвета ESP")

ESPTab:CreateColorPicker({
    Name = "Цвет Murderer",
    Color = Settings.MurdererColor,
    Flag = "MurdererColor",
    Callback = function(Value)
        Settings.MurdererColor = Value
    end
})

ESPTab:CreateColorPicker({
    Name = "Цвет Sheriff",
    Color = Settings.SheriffColor,
    Flag = "SheriffColor",
    Callback = function(Value)
        Settings.SheriffColor = Value
    end
})

ESPTab:CreateColorPicker({
    Name = "Цвет Innocent",
    Color = Settings.InnocentColor,
    Flag = "InnocentColor",
    Callback = function(Value)
        Settings.InnocentColor = Value
    end
})

ESPTab:CreateColorPicker({
    Name = "Цвет трейсеров",
    Color = Settings.TracerColor,
    Flag = "TracerColor",
    Callback = function(Value)
        Settings.TracerColor = Value
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 11: ВКЛАДКА "ВИЗУАЛЫ" (VISUALS)
-- ═══════════════════════════════════════════════════════════════

local VisualsTab = Window:CreateTab("🎨 Visuals", "palette")

local VisualsLightingSection = VisualsTab:CreateSection("Освещение и яркость")

VisualsTab:CreateToggle({
    Name = "FullBright (Полная яркость)",
    CurrentValue = false,
    Flag = "FullBright",
    Callback = function(value)
        Settings.FullBright = value
        if value then
            Lighting.Brightness = 2
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
            Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        else
            Lighting.Brightness = 1
            Lighting.ClockTime = 12
            Lighting.FogEnd = 10000
            Lighting.GlobalShadows = true
            Lighting.OutdoorAmbient = Color3.fromRGB(70, 70, 70)
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Убрать туман",
    CurrentValue = false,
    Flag = "RemoveFog",
    Callback = function(value)
        Settings.RemoveFog = value
        if value then
            Lighting.FogEnd = 100000
        else
            Lighting.FogEnd = 10000
        end
    end
})

VisualsTab:CreateColorPicker({
    Name = "Цвет окружения",
    Color = Settings.AmbientColor,
    Flag = "AmbientColor",
    Callback = function(Value)
        Settings.AmbientColor = Value
        Lighting.Ambient = Value
        Lighting.OutdoorAmbient = Value
    end
})

local VisualsChamsSection = VisualsTab:CreateSection("Chams (Подсветка)")

VisualsTab:CreateToggle({
    Name = "X-Ray (Видеть сквозь стены)",
    CurrentValue = false,
    Flag = "Xray",
    Callback = function(value)
        Settings.Xray = value
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name ~= "HumanoidRootPart" then
                pcall(function()
                    obj.LocalTransparencyModifier = value and 0.5 or 0
                end)
            end
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Player Chams (Подсветка игроков)",
    CurrentValue = false,
    Flag = "PlayerChams",
    Callback = function(value)
        Settings.PlayerChams = value
        for _, player in ipairs(Players:GetPlayers()) do
            local char = GetCharacter(player)
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        pcall(function()
                            if value then
                                local highlight = Instance.new("Highlight")
                                highlight.Name = "RabbitCoreHighlight"
                                highlight.Adornee = char
                                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                                highlight.Parent = char
                            else
                                if char:FindFirstChild("RabbitCoreHighlight") then
                                    char.RabbitCoreHighlight:Destroy()
                                end
                            end
                        end)
                    end
                end
            end
        end
    end
})

VisualsTab:CreateToggle({
    Name = "Coin Chams (Подсветка монет)",
    CurrentValue = false,
    Flag = "CoinChams",
    Callback = function(value)
        Settings.CoinChams = value
        local map = GetMap()
        if map and map:FindFirstChild("CoinContainer") then
            for _, coin in ipairs(map.CoinContainer:GetChildren()) do
                pcall(function()
                    if value then
                        local highlight = Instance.new("Highlight")
                        highlight.Name = "CoinHighlight"
                        highlight.Adornee = coin
                        highlight.FillColor = Color3.fromRGB(255, 215, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                        highlight.Parent = coin
                    else
                        if coin:FindFirstChild("CoinHighlight") then
                            coin.CoinHighlight:Destroy()
                        end
                    end
                end)
            end
        end
    end
})

local VisualsCameraSection = VisualsTab:CreateSection("Настройки камеры")

VisualsTab:CreateSlider({
    Name = "FOV (Поле зрения)",
    Range = {70, 120},
    Increment = 1,
    Suffix = "°",
    CurrentValue = 70,
    Flag = "FOV",
    Callback = function(value)
        Settings.FOVValue = value
        Camera.FieldOfView = value
    end
})

VisualsTab:CreateToggle({
    Name = "Третье лицо",
    CurrentValue = false,
    Flag = "ThirdPerson",
    Callback = function(value)
        Settings.ThirdPerson = value
        if value then
            spawn(function()
                while Settings.ThirdPerson do
                    local char = GetCharacter(LocalPlayer)
                    local hum = GetHumanoid(char)
                    if hum then
                        hum.CameraOffset = Vector3.new(0, 0, -Settings.ThirdPersonDistance)
                    end
                    task.wait(0.1)
                end
            end)
        else
            local hum = GetHumanoid(GetCharacter(LocalPlayer))
            if hum then
                hum.CameraOffset = Vector3.zero
            end
        end
    end
})

VisualsTab:CreateSlider({
    Name = "Дистанция третьего лица",
    Range = {5, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 15,
    Flag = "ThirdPersonDistance",
    Callback = function(value)
        Settings.ThirdPersonDistance = value
    end
})

VisualsTab:CreateToggle({
    Name = "Убрать тряску камеры",
    CurrentValue = false,
    Flag = "CameraShakeRemoval",
    Callback = function(value)
        Settings.CameraShakeRemoval = value
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 12: ВКЛАДКА "ТЕЛЕПОРТАЦИЯ" (TELEPORT)
-- ═══════════════════════════════════════════════════════════════

local TeleportTab = Window:CreateTab("📍 Teleport", "map-pin")

local TeleportSettingsSection = TeleportTab:CreateSection("Настройки телепортации")

TeleportTab:CreateDropdown({
    Name = "Режим телепортации",
    Options = {"Instant", "Tween"},
    CurrentOption = "Instant",
    Flag = "TeleportMode",
    Callback = function(option)
        Settings.TeleportMode = option
    end
})

TeleportTab:CreateSlider({
    Name = "Скорость телепортации",
    Range = {0.1, 5},
    Increment = 0.1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "TeleportSpeed",
    Callback = function(value)
        Settings.TeleportSpeed = value
    end
})

TeleportTab:CreateToggle({
    Name = "Безопасная телепортация",
    CurrentValue = true,
    Flag = "SafeTeleport",
    Callback = function(value)
        Settings.SafeTeleport = value
    end
})

TeleportTab:CreateSlider({
    Name = "Задержка телепортации (сек)",
    Range = {0, 2},
    Increment = 0.1,
    Suffix = " сек",
    CurrentValue = 0.5,
    Flag = "TeleportCooldown",
    Callback = function(value)
        Settings.TeleportCooldown = value
    end
})

local TeleportPlayersSection = TeleportTab:CreateSection("Телепорт к игрокам")

local playerList = {}
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        table.insert(playerList, player.Name)
    end
end

TeleportTab:CreateDropdown({
    Name = "Выберите игрока",
    Options = playerList,
    CurrentOption = playerList[1] or "Нет игроков",
    Flag = "TeleportPlayer",
    Callback = function(option) end
})

TeleportTab:CreateButton({
    Name = "Телепорт к выбранному игроку",
    Callback = function()
        local selectedName = TeleportTab:GetDropdown("TeleportPlayer")
        local player = Players:FindFirstChild(selectedName)
        if player and player.Character then
            local root = GetRootPart(player.Character)
            if root then
                TeleportTo(root.Position)
                Notify("Телепорт", "Телепортированы к " .. selectedName, 2)
            end
        else
            Notify("Ошибка", "Игрок не найден", 2)
        end
    end
})

TeleportTab:CreateButton({
    Name = "Телепорт к Murderer",
    Callback = function()
        local murderer = FindPlayerByRole("Murderer")
        if murderer then
            local root = GetRootPart(murderer.Character)
            if root then
                TeleportTo(root.Position)
                Notify("Телепорт", "Телепортированы к Murderer", 2)
            end
        else
            Notify("Ошибка", "Murderer не найден", 2)
        end
    end
})

TeleportTab:CreateButton({
    Name = "Телепорт к Sheriff",
    Callback = function()
        local sheriff = FindPlayerByRole("Sheriff")
        if sheriff then
            local root = GetRootPart(sheriff.Character)
            if root then
                TeleportTo(root.Position)
                Notify("Телепорт", "Телепортированы к Sheriff", 2)
            end
        else
            Notify("Ошибка", "Sheriff не найден", 2)
        end
    end
})

local TeleportLocationsSection = TeleportTab:CreateSection("Телепорт по локациям")

TeleportTab:CreateButton({
    Name = "Телепорт в лобби",
    Callback = function()
        if Workspace:FindFirstChild("Lobby") and Workspace.Lobby:FindFirstChild("Spawns") then
            local spawn = Workspace.Lobby.Spawns:FindFirstChild("Spawn")
            if spawn then
                TeleportTo(spawn.CFrame.Position + Vector3.new(0, 2.8, 0))
                Notify("Телепорт", "Телепортированы в лобби", 2)
            end
        end
    end
})

TeleportTab:CreateButton({
    Name = "Телепорт к ближайшей монете",
    Callback = function()
        local map = GetMap()
        if map then
            local coin = GetClosestCoin(map)
            if coin then
                TeleportTo(coin:GetPivot().Position)
                Notify("Телепорт", "Телепортированы к монете", 2)
            else
                Notify("Ошибка", "Монеты не найдены", 2)
            end
        end
    end
})

TeleportTab:CreateButton({
    Name = "Телепорт к упавшему оружию",
    Callback = function()
        local gun = FindDroppedGun()
        if gun then
            TeleportTo(gun.Position)
            Notify("Телепорт", "Телепортированы к оружию", 2)
        else
            Notify("Ошибка", "Оружие не найдено", 2)
        end
    end
})

TeleportTab:CreateButton({
    Name = "Телепорт в безопасную зону",
    Callback = function()
        local safeZone = FindSafeZone()
        if safeZone then
            TeleportTo(safeZone.Position)
            Notify("Телепорт", "Телепортированы в безопасную зону", 2)
        else
            Notify("Ошибка", "Безопасные зоны не найдены", 2)
        end
    end
})

TeleportTab:CreateButton({
    Name = "Телепорт на возвышенность",
    Callback = function()
        local root = GetRootPart(GetCharacter(LocalPlayer))
        if root then
            TeleportTo(root.Position + Vector3.new(0, 100, 0))
            Notify("Телепорт", "Телепортированы вверх", 2)
        end
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 13: ВКЛАДКА "НАСТРОЙКИ" (SETTINGS)
-- ═══════════════════════════════════════════════════════════════

local SettingsTab = Window:CreateTab("⚙️ Settings", "sliders")

local SettingsNotificationsSection = SettingsTab:CreateSection("Уведомления")

SettingsTab:CreateToggle({
    Name = "Включить уведомления",
    CurrentValue = true,
    Flag = "Notifications",
    Callback = function(value)
        Settings.Notifications = value
    end
})

SettingsTab:CreateSlider({
    Name = "Длительность уведомлений (сек)",
    Range = {1, 10},
    Increment = 1,
    Suffix = " сек",
    CurrentValue = 5,
    Flag = "NotificationDuration",
    Callback = function(value)
        Settings.NotificationDuration = value
    end
})

SettingsTab:CreateToggle({
    Name = "Уведомления в чате",
    CurrentValue = false,
    Flag = "ChatNotifications",
    Callback = function(value)
        Settings.ChatNotifications = value
    end
})

SettingsTab:CreateToggle({
    Name = "Звуковые уведомления",
    CurrentValue = false,
    Flag = "SoundNotifications",
    Callback = function(value)
        Settings.SoundNotifications = value
    end
})

local SettingsAutomationSection = SettingsTab:CreateSection("Автоматизация")

SettingsTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(value)
        Settings.AntiAFK = value
    end
})

SettingsTab:CreateToggle({
    Name = "Auto Win (Авто-победа)",
    CurrentValue = false,
    Flag = "AutoWin",
    Callback = function(value)
        Settings.AutoWin = value
    end
})

SettingsTab:CreateToggle({
    Name = "Auto Play (Авто-игра)",
    CurrentValue = false,
    Flag = "AutoPlay",
    Callback = function(value)
        Settings.AutoPlay = value
    end
})

SettingsTab:CreateToggle({
    Name = "Auto Requeue (Авто-переподключение)",
    CurrentValue = false,
    Flag = "AutoRequeue",
    Callback = function(value)
        Settings.AutoRequeue = value
    end
})

SettingsTab:CreateToggle({
    Name = "Auto Skip Lobby (Пропуск лобби)",
    CurrentValue = false,
    Flag = "AutoSkipLobby",
    Callback = function(value)
        Settings.AutoSkipLobby = value
    end
})

local SettingsPerformanceSection = SettingsTab:CreateSection("Производительность")

SettingsTab:CreateToggle({
    Name = "Оптимизация производительности",
    CurrentValue = false,
    Flag = "OptimizePerformance",
    Callback = function(value)
        Settings.OptimizePerformance = value
        if value then
            OptimizePerformance()
        end
    end
})

SettingsTab:CreateToggle({
    Name = "Низкая графика",
    CurrentValue = false,
    Flag = "LowGraphics",
    Callback = function(value)
        Settings.LowGraphics = value
        if value then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") then
                    v.Enabled = false
                end
            end
        end
    end
})

SettingsTab:CreateToggle({
    Name = "Отключить частицы",
    CurrentValue = false,
    Flag = "DisableParticles",
    Callback = function(value)
        Settings.DisableParticles = value
    end
})

SettingsTab:CreateToggle({
    Name = "Отключить анимации",
    CurrentValue = false,
    Flag = "DisableAnimations",
    Callback = function(value)
        Settings.DisableAnimations = value
    end
})

local SettingsProtectionSection = SettingsTab:CreateSection("Защита")

SettingsTab:CreateToggle({
    Name = "Anti-Ragdoll",
    CurrentValue = false,
    Flag = "AntiRagdoll",
    Callback = function(value)
        Settings.AntiRagdoll = value
    end
})

SettingsTab:CreateToggle({
    Name = "Anti-Slow",
    CurrentValue = false,
    Flag = "AntiSlow",
    Callback = function(value)
        Settings.AntiSlow = value
    end
})

SettingsTab:CreateToggle({
    Name = "Anti-Stun",
    CurrentValue = false,
    Flag = "AntiStun",
    Callback = function(value)
        Settings.AntiStun = value
    end
})

SettingsTab:CreateToggle({
    Name = "Infinite Stamina (Бесконечная выносливость)",
    CurrentValue = false,
    Flag = "InfiniteStamina",
    Callback = function(value)
        Settings.InfiniteStamina = value
    end
})

SettingsTab:CreateToggle({
    Name = "Auto Respawn (Авто-респавн)",
    CurrentValue = false,
    Flag = "AutoRespawn",
    Callback = function(value)
        Settings.AutoRespawn = value
    end
})

-- ═══════════════════════════════════════════════════════════════
-- РАЗДЕЛ 14: ВКЛАДКА "РАЗНОЕ" (MISC)
-- ═══════════════════════════════════════════════════════════════

local MiscTab = Window:CreateTab("🎯 Misc", "more")

local MiscTrollingSection = MiscTab:CreateSection("Троллинг")

MiscTab:CreateToggle({
    Name = "Fling Players (Подкидывание игроков)",
    CurrentValue = false,
    Flag = "FlingPlayers",
    Callback = function(value)
        Settings.FlingPlayers = value
        if value then
            spawn(function()
                while Settings.FlingPlayers do
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer then
                            local char = GetCharacter(player)
                            local root = GetRootPart(char)
                            if root then
                                pcall(function()
                                    local flingVelocity = Vector3.new(
                                        math.random(-1, 1) * Settings.FlingPower,
                                        Settings.FlingPower,
                                        math.random(-1, 1) * Settings.FlingPower
                                    )
                                    root.AssemblyLinearVelocity = flingVelocity
                                end)
                            end
                        end
                    end
                    task.wait(0.5)
                end
            end)
        end
    end
})

MiscTab:CreateSlider({
    Name = "Сила подкидывания",
    Range = {10, 500},
    Increment = 10,
    Suffix = " power",
    CurrentValue = 100,
    Flag = "FlingPower",
    Callback = function(value)
        Settings.FlingPower = value
    end
})

MiscTab:CreateToggle({
    Name = "Spam Chat (Спам в чат)",
    CurrentValue = false,
    Flag = "SpamChat",
    Callback = function(value)
        Settings.SpamChat = value
        if value then
            spawn(function()
                while Settings.SpamChat do
                    pcall(function()
                        ReplicatedStorage.DefaultChatSystemChatEvents.SayMessageRequest:FireServer(
                            Settings.ChatSpamText,
                            "All"
                        )
                    end)
                    task.wait(Settings.ChatSpamDelay)
                end
            end)
        end
    end
})

MiscTab:CreateInput({
    Name = "Текст для спама",
    PlaceholderText = "Введите текст для спама",
    RemoveTextAfterFocusLost = false,
    CurrentValue = "RabbitCore on top!",
    Flag = "ChatSpamText",
    Callback = function(text)
        Settings.ChatSpamText = text
    end
})

MiscTab:CreateSlider({
    Name = "Задержка спама (сек)",
    Range = {0.5, 5},
    Increment = 0.5,
    Suffix = " сек",
    CurrentValue = 1,
    Flag = "ChatSpamDelay",
    Callback = function(value)
        Settings.ChatSpamDelay = value
    end
})

MiscTab:CreateDropdown({
    Name = "Поддельная роль",
    Options = {"None", "Murderer", "Sheriff", "Innocent"},
    CurrentOption = "None",
    Flag = "FakeRole",
    Callback = function(option)
        Settings.FakeRole = option
    end
})

local MiscUtilitySection = MiscTab:CreateSection("Утилиты")

MiscTab:CreateButton({
    Name = "Очистить чат",
    Callback = function()
        for i = 1, 100 do
            pcall(function()
                StarterGui:SetCore("ChatMakeSystemMessage", {
                    Text = " ",
                    Color = Color3.fromRGB(255, 255, 255)
                })
            end)
        end
        Notify("Утилиты", "Чат очищен", 2)
    end
})

MiscTab:CreateButton({
    Name = "Скопировать ID игры",
    Callback = function()
        setclipboard(tostring(game.PlaceId))
        Notify("Утилиты", "ID игры скопирован: " .. game.PlaceId, 3)
    end
})

MiscTab:CreateButton({
    Name = "Скопировать Job ID",
    Callback = function()
        setclipboard(tostring(game.JobId))
        Notify("Утилиты", "Job ID скопирован", 3)
    end
})

MiscTab:CreateButton({
    Name = "Server Hop (Сменить сервер)",
    Callback = function()
        pcall(function()
            local servers = {}
            local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100")
            local body = HttpService:JSONDecode(req)
            
            if body and body.data then
                for _, server in ipairs(body.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        table.insert(servers, server.id)
                    end
                end
            end
            
            if #servers > 0 then
                local randomServer = servers[math.random(1, #servers)]
                TeleportService:TeleportToPlaceInstance(game.PlaceId, randomServer, LocalPlayer)
                Notify("Server Hop", "Переподключение к новому серверу...", 3)
            else
                Notify("Server Hop", "Нет доступных серверов", 3)
            end
        end)
    end
})

MiscTab:CreateButton({
    Name = "Rejoin (Переподключение)",
    Callback = function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end
})

MiscTab:CreateButton({
    Name = "Копировать ссылку на игру",
    Callback = function()
        setclipboard("https://www.roblox.com/games/" .. game.PlaceId)
        Notify("Утилиты", "Ссылка на игру скопирована", 2)
    end
})

-- �
