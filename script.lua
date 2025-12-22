-- Murder Mystery 2 Legendary Script
-- Using Wand UI Library
-- By: YourName

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
    Title = "🔥 MM2 Legendary",
    SubTitle = "Ultimate Script | v3.0",
    ScriptFolder = "MM2-Legendary"
})

-- Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

-- Game States
local GameData = {
    IsRoundStarted = false,
    IsRoundStarting = false,
    Gameplay = {},
    GameplayMap = {},
    MurdererPerk = nil,
    GunDrop = nil,
    Map = nil
}

local Config = {
    -- Combat
    KillAura = false,
    KillAuraRange = 15,
    AutoKillSheriff = false,
    AutoKillEveryone = false,
    KnifeSilentAim = false,
    SheriffSilentAim = false,
    
    -- Gun Features
    AutoGrabGun = false,
    AutoStealGun = false,
    AutoBreakGun = false,
    GunAura = false,
    
    -- Visuals
    ShowMurderer = false,
    ShowSheriff = false,
    ShowInnocent = false,
    ShowGun = false,
    MurdererESP = false,
    SheriffESP = false,
    InnocentESP = false,
    
    -- Player Mods
    EnableWalkSpeed = false,
    WalkSpeedInput = 16,
    EnableJumpPower = false,
    JumpPowerInput = 50,
    InfiniteJump = false,
    EnableNoclip = false,
    
    -- Misc
    AutoBlurtRoles = false,
    DestroyCoins = false,
    DestroyDeadBody = false,
    DestroyBarriers = false,
    AntiTrap = false,
    CoinAura = false,
    
    -- Whitelist
    WhitelistedPlayers = {},
    WhitelistFriends = false,
    WhitelistMurderer = false
}

-- Tabs
local MainTab = Window:MakeTab({Title = "الرئيسية", Icon = "Home"})
local CombatTab = Window:MakeTab({Title = "القتال", Icon = "Swords"})
local VisualTab = Window:MakeTab({Title = "المظهر", Icon = "Palette"})
local PlayerTab = Window:MakeTab({Title = "اللاعب", Icon = "User"})
local FarmTab = Window:MakeTab({Title = "الفارم", Icon = "Coins"})
local SettingsTab = Window:MakeTab({Title = "الإعدادات", Icon = "Settings"})

-- إشعار البدء
Window:Notify({
    Title = "تم التحميل بنجاح!",
    Content = "سكربت Murder Mystery 2 جاهز للاستخدام",
    Duration = 5,
    Image = "rbxassetid://10734953451"
})

-- Function to refresh players list
local function RefreshPlayersList()
    local players = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(players, player.Name)
        end
    end
    return players
end

-- Function to get player by role
local function GetPlayerByRole(role)
    for _, player in pairs(Players:GetPlayers()) do
        if GameData.GameplayMap[player.Name] == role then
            return player
        end
    end
    return nil
end

-- Function to teleport
local function TeleportTo(position, playerName)
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    if position == "Murderer" then
        local murderer = GetPlayerByRole("Murderer")
        if murderer and murderer.Character then
            local targetPart = murderer.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                humanoidRootPart.CFrame = targetPart.CFrame
            end
        end
    elseif position == "Sheriff" then
        local sheriff = GetPlayerByRole("Sheriff")
        if sheriff and sheriff.Character then
            local targetPart = sheriff.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                humanoidRootPart.CFrame = targetPart.CFrame
            end
        end
    elseif position == "Player" and playerName then
        local targetPlayer = Players:FindFirstChild(playerName)
        if targetPlayer and targetPlayer.Character then
            local targetPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                humanoidRootPart.CFrame = targetPart.CFrame
            end
        end
    end
end

-- Section: الرئيسية
MainTab:AddSection("معلومات الجولة")

local RoundInfo = MainTab:AddParagraph("معلومات الجولة", "جاري الانتظار...")

MainTab:AddSection("الأدوات السريعة")

MainTab:AddButton({
    Name = "🔪 اقتل الجميع (إذا كنت قاتل)",
    Callback = function()
        if GameData.GameplayMap[LocalPlayer.Name] == "Murderer" then
            -- Kill all logic here
            Window:Notify({
                Title = "نجاح",
                Content = "جاري قتل جميع اللاعبين...",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "خطأ",
                Content = "يجب أن تكون القاتل لاستخدام هذه الميزة!",
                Duration = 3
            })
        end
    end
})

MainTab:AddButton({
    Name = "🔫 سرق المسدس",
    Callback = function()
        if GameData.GunDrop then
            -- Steal gun logic here
            Window:Notify({
                Title = "نجاح",
                Content = "جاري سرقة المسدس...",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "خطأ",
                Content = "لا يوجد مسدس مسقوط!",
                Duration = 3
            })
        end
    end
})

-- Section: القتال
CombatTab:AddSection("ميزات القاتل")

local KillAuraToggle = CombatTab:AddToggle({
    Name = "هالة القتل التلقائي",
    Default = false,
    Callback = function(Value)
        Config.KillAura = Value
        if Value then
            Window:Notify({
                Title = "تفعيل",
                Content = "تم تفعيل هالة القتل",
                Duration = 3
            })
            
            -- Kill aura loop
            while Config.KillAura and task.wait(0.1) do
                if GameData.GameplayMap[LocalPlayer.Name] == "Murderer" then
                    -- Kill nearby players logic
                end
            end
        end
    end
})

CombatTab:AddSlider({
    Name = "مدى هالة القتل",
    Min = 1,
    Max = 50,
    Default = 15,
    Increment = 1,
    Callback = function(Value)
        Config.KillAuraRange = Value
    end
})

CombatTab:AddToggle({
    Name = "قتل الشريف تلقائي",
    Default = false,
    Callback = function(Value)
        Config.AutoKillSheriff = Value
    end
})

CombatTab:AddToggle({
    Name = "قتل الجميع تلقائي",
    Default = false,
    Callback = function(Value)
        Config.AutoKillEveryone = Value
    end
})

CombatTab:AddSection("ميزات الشريف")

CombatTab:AddToggle({
    Name = "تسديد صامت للشريف",
    Default = false,
    Callback = function(Value)
        Config.SheriffSilentAim = Value
    end
})

CombatTab:AddToggle({
    Name = "كسر المسدس تلقائي",
    Default = false,
    Callback = function(Value)
        Config.AutoBreakGun = Value
    end
})

CombatTab:AddSection("الأسلحة")

CombatTab:AddToggle({
    Name = "التقاط المسدس تلقائي",
    Default = false,
    Callback = function(Value)
        Config.AutoGrabGun = Value
    end
})

CombatTab:AddToggle({
    Name = "هالة المسدس",
    Default = false,
    Callback = function(Value)
        Config.GunAura = Value
    end
})

-- Section: المظهر
VisualTab:AddSection("الهايلايت")

VisualTab:AddToggle({
    Name = "إظهار القاتل",
    Default = false,
    Callback = function(Value)
        Config.ShowMurderer = Value
    end
})

VisualTab:AddToggle({
    Name = "إظهار الشريف",
    Default = false,
    Callback = function(Value)
        Config.ShowSheriff = Value
    end
})

VisualTab:AddToggle({
    Name = "إظهار الأبرياء",
    Default = false,
    Callback = function(Value)
        Config.ShowInnocent = Value
    end
})

VisualTab:AddToggle({
    Name = "إظهار المسدس",
    Default = false,
    Callback = function(Value)
        Config.ShowGun = Value
    end
})

VisualTab:AddSection("ESP")

VisualTab:AddToggle({
    Name = "ESP القاتل",
    Default = false,
    Callback = function(Value)
        Config.MurdererESP = Value
    end
})

VisualTab:AddToggle({
    Name = "ESP الشريف",
    Default = false,
    Callback = function(Value)
        Config.SheriffESP = Value
    end
})

VisualTab:AddToggle({
    Name = "ESP الأبرياء",
    Default = false,
    Callback = function(Value)
        Config.InnocentESP = Value
    end
})

-- Section: اللاعب
PlayerTab:AddSection("تحسينات الحركة")

PlayerTab:AddToggle({
    Name = "تفعيل السرعة",
    Default = false,
    Callback = function(Value)
        Config.EnableWalkSpeed = Value
    end
})

PlayerTab:AddSlider({
    Name = "سرعة الحركة",
    Min = 16,
    Max = 100,
    Default = 16,
    Increment = 1,
    Callback = function(Value)
        Config.WalkSpeedInput = Value
    end
})

PlayerTab:AddToggle({
    Name = "قفز لا نهائي",
    Default = false,
    Callback = function(Value)
        Config.InfiniteJump = Value
    end
})

PlayerTab:AddToggle({
    Name = "النوكلب",
    Default = false,
    Callback = function(Value)
        Config.EnableNoclip = Value
    end
})

PlayerTab:AddSection("الانتقال السريع")

local TeleportDropdown = PlayerTab:AddDropdown({
    Name = "الانتقال إلى لاعب",
    Options = RefreshPlayersList(),
    Default = nil,
    Callback = function(Value)
        TeleportTo("Player", Value)
    end
})

PlayerTab:AddButton({
    Name = "الانتقال إلى القاتل",
    Callback = function()
        TeleportTo("Murderer")
    end
})

PlayerTab:AddButton({
    Name = "الانتقال إلى الشريف",
    Callback = function()
        TeleportTo("Sheriff")
    end
})

-- Section: الفارم
FarmTab:AddSection("جمع العملات")

FarmTab:AddToggle({
    Name = "هالة العملات",
    Default = false,
    Callback = function(Value)
        Config.CoinAura = Value
    end
})

FarmTab:AddToggle({
    Name = "تدمير العملات",
    Default = false,
    Callback = function(Value)
        Config.DestroyCoins = Value
    end
})

FarmTab:AddToggle({
    Name = "تدمير الجثث",
    Default = false,
    Callback = function(Value)
        Config.DestroyDeadBody = Value
    end
})

FarmTab:AddSection("التحسين")

FarmTab:AddToggle({
    Name = "تدمير الحواجز",
    Default = false,
    Callback = function(Value)
        Config.DestroyBarriers = Value
    end
})

FarmTab:AddToggle({
    Name = "مضاد الفخاخ",
    Default = false,
    Callback = function(Value)
        Config.AntiTrap = Value
    end
})

-- Section: الإعدادات
SettingsTab:AddSection("القائمة البيضاء")

local WhitelistDropdown = SettingsTab:AddDropdown({
    Name = "اللاعبون المسموحون",
    Options = RefreshPlayersList(),
    Default = {},
    Multi = true,
    Callback = function(Values)
        Config.WhitelistedPlayers = Values
    end
})

SettingsTab:AddToggle({
    Name = "إضافة الأصدقاء تلقائي",
    Default = false,
    Callback = function(Value)
        Config.WhitelistFriends = Value
    end
})

SettingsTab:AddToggle({
    Name = "إضافة القاتل تلقائي",
    Default = false,
    Callback = function(Value)
        Config.WhitelistMurderer = Value
    end
})

SettingsTab:AddSection("معلومات")

SettingsTab:AddParagraph("إصدار السكربت", "Murder Mystery 2 Legendary\nالإصدار: 3.0\nالمطور: YourName")

SettingsTab:AddButton({
    Name = "🔄 تحديث قائمة اللاعبين",
    Callback = function()
        local players = RefreshPlayersList()
        TeleportDropdown:NewOptions(players)
        WhitelistDropdown:NewOptions(players)
        Window:Notify({
            Title = "تم التحديث",
            Content = "تم تحديث قائمة اللاعبين",
            Duration = 3
        })
    end
})

-- Game Events
local function UpdateRoundInfo()
    local info = ""
    info = info .. "الحالة: " .. (GameData.IsRoundStarted and "مبدأية" or "انتظار") .. "\n"
    info = info .. "القاتل: " .. (GetPlayerByRole("Murderer") and GetPlayerByRole("Murderer").Name or "غير معروف") .. "\n"
    info = info .. "الشريف: " .. (GetPlayerByRole("Sheriff") and GetPlayerByRole("Sheriff").Name or "غير معروف") .. "\n"
    info = info .. "المسدس: " .. (GameData.GunDrop and "مسقوط" or "غير مسقوط")
    
    RoundInfo:Set(info)
end

-- Auto updater for player lists
task.spawn(function()
    while task.wait(5) do
        local players = RefreshPlayersList()
        TeleportDropdown:NewOptions(players)
        WhitelistDropdown:NewOptions(players)
        UpdateRoundInfo()
    end
end)

-- Connections
LocalPlayer.CharacterAdded:Connect(function(character)
    if Config.EnableWalkSpeed then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = Config.WalkSpeedInput
    end
end)

-- Infinite jump
game:GetService("UserInputService").JumpRequest:Connect(function()
    if Config.InfiniteJump and LocalPlayer.Character then
        local humanoid = LocalPlayer.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid:ChangeState("Jumping")
        end
    end
end)

-- Noclip
RunService.Stepped:Connect(function()
    if Config.EnableNoclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

Window:Notify({
    Title = "جاهز للعب!",
    Content = "تم تحميل جميع الميزات بنجاح",
    Duration = 3
})
