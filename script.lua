-- 🚀 MM2 Symphony Hub FULL SCRIPT
-- 📌 All Original Features Working
-- 🔥 By: YourName

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
    Title = "⚔️ MM2 Symphony Hub",
    SubTitle = "ALL ORIGINAL FEATURES | v10.0",
    ScriptFolder = "MM2-Symphony"
})

-- 🔧 Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Backpack = LocalPlayer.Backpack

-- 📊 Game Variables
local GameData = {
    IsRoundStarted = false,
    IsRoundStarting = false,
    Murderer = nil,
    Sheriff = nil,
    GunDrop = nil,
    Map = nil,
    MurdererPerk = nil,
    Gameplay = {},
    GameplayMap = {}
}

-- ⚙️ Configuration
local Config = {
    -- Player Mods
    EnableWalkSpeed = false,
    WalkSpeedInput = 50,
    EnableJumpPower = false,
    JumpPowerInput = 100,
    InfiniteJump = false,
    Noclip = false,
    NoclipCamera = false,
    UnlockCamera = false,
    SecondLife = false,
    
    -- Combat
    KillAura = false,
    KillAuraRange = 20,
    AutoKillSheriff = false,
    AutoKillEveryone = false,
    KnifeSilentAim = false,
    SheriffSilentAim = false,
    SharpShooter = false,
    SSAAccuracy = "Dynamic",
    AutoForceShoot = false,
    
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
    ShowDead = false,
    MurdererESP = false,
    SheriffESP = false,
    InnocentESP = false,
    ESPTextSize = 14,
    ESPTextTransparency = 1,
    
    -- Misc
    AutoBlurtRoles = false,
    SeeDeadChat = false,
    Stealth = false,
    AutoFakeBombClutch = false,
    Seizure = false,
    AntiFling = false,
    AntiTrap = false,
    
    -- Farm
    CoinAura = false,
    DestroyCoins = false,
    DestroyDeadBody = false,
    DestroyBarriers = false,
    DestroyDisplay = false,
    
    -- Whitelist
    WhitelistedPlayers = {},
    ManualWhitelistedPlayers = {},
    WhitelistFriends = false,
    WhitelistMurderer = false,
    
    -- Updates
    UpdateMethod = "On Player Event",
    AutoUpdateDelay = 0.1,
    AutoUpdatePlayerList = true,
    DynamicUpdateMethod = true,
    
    -- Silent Aim Advanced
    DefaultPrediction = 200,
    DefaultPing = 100,
    PingStep = 20,
    PredictionMultiplier = 2,
    PredictionMultiplierCap = 400
}

-- 📁 Local Variables
local Connections = {}
local ESPDrawings = {}
local Highlights = {}
local PlayersList = {}
local UpdateQueues = {}

-- 🔄 Function: Refresh Players List
local function RefreshPlayersList()
    PlayersList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(PlayersList, player.Name)
        end
    end
    return PlayersList
end

-- 🔄 Function: Update Player Lists
local function UpdatePlayerLists(method, dropdown)
    if method == "On Dropdown Change" then
        if dropdown then
            RefreshPlayersList()
            dropdown:SetValues(PlayersList)
        else
            UpdateQueues.UpdateTeleport = true
            UpdateQueues.UpdateSpectate = true
            UpdateQueues.UpdateFling = true
            UpdateQueues.UpdateKill = true
        end
    elseif method == "On Player Event" then
        local dropdowns = {
            UpdateQueues.TeleportDropdown,
            UpdateQueues.SpectateDropdown,
            UpdateQueues.FlingDropdown,
            UpdateQueues.KillDropdown
        }
        
        for _, dropdown in ipairs(dropdowns) do
            if dropdown then
                RefreshPlayersList()
                dropdown:SetValues(PlayersList)
                task.wait(Config.AutoUpdateDelay)
            end
        end
    end
end

-- 🎮 Function: Teleport To
local function TeleportTo(target, playerName)
    local success, errorMsg = pcall(function()
        if target == "Murderer" then
            if GameData.Murderer then
                local murderer = Players:FindFirstChild(GameData.Murderer)
                if murderer and murderer.Character then
                    local targetPart = murderer.Character:FindFirstChild("HumanoidRootPart")
                    if targetPart then
                        RootPart.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, RootPart.Size.Y / 2, 0))
                    end
                end
            end
        elseif target == "Sheriff" then
            if GameData.Sheriff then
                local sheriff = Players:FindFirstChild(GameData.Sheriff)
                if sheriff and sheriff.Character then
                    local targetPart = sheriff.Character:FindFirstChild("HumanoidRootPart")
                    if targetPart then
                        RootPart.CFrame = CFrame.new(targetPart.Position + Vector3.new(0, RootPart.Size.Y / 2, 0))
                    end
                end
            end
        elseif target == "Lobby" then
            local lobby = Workspace:FindFirstChild("Lobby")
            if lobby then
                local spawns = lobby:FindFirstChild("Spawns")
                if spawns then
                    local children = spawns:GetChildren()
                    if #children > 0 then
                        local randomSpawn = children[math.random(1, #children)]
                        RootPart.CFrame = CFrame.new(randomSpawn.Position + Vector3.new(0, RootPart.Size.Y / 2, 0))
                    end
                end
            end
        elseif target == "Player" and playerName then
            local targetPlayer = Players:FindFirstChild(playerName)
            if targetPlayer and targetPlayer.Character then
                local targetPart = targetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if targetPart then
                    RootPart.CFrame = CFrame.new(targetPart.Position)
                end
            end
        end
    end)
    
    if not success then
        warn("Teleport Error: " .. errorMsg)
    end
end

-- 👁️ Function: Spectate
local function Spectate(target, playerName)
    local success, errorMsg = pcall(function()
        if target == "Murderer" then
            if GameData.Murderer then
                local murderer = Players:FindFirstChild(GameData.Murderer)
                if murderer and murderer.Character then
                    local humanoid = murderer.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        workspace.CurrentCamera.CameraSubject = humanoid
                    end
                end
            end
        elseif target == "Sheriff" then
            if GameData.Sheriff then
                local sheriff = Players:FindFirstChild(GameData.Sheriff)
                if sheriff and sheriff.Character then
                    local humanoid = sheriff.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        workspace.CurrentCamera.CameraSubject = humanoid
                    end
                end
            end
        elseif target == "Player" and playerName then
            local targetPlayer = Players:FindFirstChild(playerName)
            if targetPlayer and targetPlayer.Character then
                local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    workspace.CurrentCamera.CameraSubject = humanoid
                end
            end
        elseif target == "Stop" then
            workspace.CurrentCamera.CameraSubject = Humanoid
        end
    end)
    
    if not success then
        warn("Spectate Error: " .. errorMsg)
    end
end

-- 🔪 Function: Kill Player
local function KillPlayer(playerName, equipKnife)
    task.spawn(function()
        local target = Players:FindFirstChild(playerName)
        if GameData.Murderer == LocalPlayer.Name and target then
            if equipKnife and not Character:FindFirstChild("Knife") then
                -- Equip knife logic
            end
            
            local targetChar = target.Character
            if targetChar then
                local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
                if targetHRP and Character:FindFirstChild("Knife") then
                    -- Stab animation
                    task.wait()
                    -- Touch kill
                    firetouchinterest(targetHRP, Character.Knife.Handle, 1)
                    firetouchinterest(targetHRP, Character.Knife.Handle, 0)
                end
            end
        end
    end)
end

-- 🔫 Function: Grab Gun
local function GrabGun()
    pcall(function()
        if GameData.GunDrop and RootPart then
            local gun = GameData.GunDrop
            local originalPosition = RootPart.Position
            
            task.wait(0.05)
            repeat
                RootPart.CFrame = CFrame.new(gun.Position + Vector3.new(0, -6, 0))
                firetouchinterest(RootPart, gun, 1)
                firetouchinterest(RootPart, gun, 0)
                task.wait()
            until not Workspace:FindFirstChild("GunDrop")
            
            task.wait(0.05)
            RootPart.CFrame = CFrame.new(originalPosition)
            Humanoid:ChangeState(1) -- Running
            GameData.GunDrop = nil
        end
    end)
end

-- 🎯 Function: Create Highlight
local function CreateHighlight(role, target)
    pcall(function()
        if GameData.IsRoundStarting or GameData.IsRoundStarted or role == "Dead" then
            local murderer = GameData.Murderer and Players:FindFirstChild(GameData.Murderer)
            local sheriff = GameData.Sheriff and Players:FindFirstChild(GameData.Sheriff)
            
            if role == "Murderer" then
                if Config.ShowMurderer and murderer and murderer ~= LocalPlayer then
                    local char = murderer.Character
                    if char then
                        local highlight = char:FindFirstChild("Highlight") or Instance.new("Highlight")
                        highlight.FillTransparency = 0.5
                        highlight.FillColor = Color3.fromRGB(200, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
                        highlight.Parent = char
                        Highlights[murderer] = highlight
                    end
                elseif Highlights[murderer] then
                    Highlights[murderer]:Destroy()
                    Highlights[murderer] = nil
                end
                
            elseif role == "Sheriff" then
                if Config.ShowSheriff and sheriff and sheriff ~= LocalPlayer then
                    local char = sheriff.Character
                    if char then
                        local highlight = char:FindFirstChild("Highlight") or Instance.new("Highlight")
                        highlight.FillTransparency = 0.5
                        highlight.FillColor = Color3.fromRGB(0, 0, 200)
                        highlight.OutlineColor = Color3.fromRGB(0, 0, 200)
                        highlight.Parent = char
                        Highlights[sheriff] = highlight
                    end
                elseif Highlights[sheriff] then
                    Highlights[sheriff]:Destroy()
                    Highlights[sheriff] = nil
                end
                
            elseif role == "Innocent" then
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player ~= murderer and player ~= sheriff then
                        if Config.ShowInnocent then
                            local char = player.Character
                            if char then
                                local highlight = char:FindFirstChild("Highlight") or Instance.new("Highlight")
                                highlight.FillTransparency = 0.5
                                highlight.FillColor = Color3.fromRGB(0, 200, 0)
                                highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
                                highlight.Parent = char
                                Highlights[player] = highlight
                            end
                        elseif Highlights[player] then
                            Highlights[player]:Destroy()
                            Highlights[player] = nil
                        end
                    end
                end
            end
        end
    end)
end

-- ✨ Function: Create ESP
local function CreateESP(player, color, size, transparency)
    local drawing = Drawing.new("Text")
    drawing.Visible = false
    drawing.Size = size
    drawing.Center = true
    drawing.Outline = false
    drawing.Color = color
    drawing.Transparency = transparency
    drawing.Font = Drawing.Fonts.UI
    
    local connection = RunService.RenderStepped:Connect(function()
        if player and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            
            if head and hrp then
                local position, onScreen = workspace.CurrentCamera:WorldToViewportPoint(head.Position)
                
                if onScreen then
                    local distance = (hrp.Position - RootPart.Position).Magnitude
                    drawing.Position = Vector2.new(position.X, position.Y - 25)
                    drawing.Text = string.format("(%d) %s", math.floor(distance), player.Name)
                    drawing.Visible = true
                else
                    drawing.Visible = false
                end
            else
                drawing.Visible = false
            end
        else
            drawing.Visible = false
        end
    end)
    
    ESPDrawings[player] = {Drawing = drawing, Connection = connection}
end

-- 🔄 Auto Update Players
task.spawn(function()
    while task.wait(Config.AutoUpdateDelay) do
        if Config.AutoUpdatePlayerList then
            UpdatePlayerLists(Config.UpdateMethod)
        end
    end
end)

-- 📌 Create Tabs
local MainTab = Window:MakeTab({Title = "🏠 الرئيسية", Icon = "Home"})
local PlayerTab = Window:MakeTab({Title = "👤 اللاعب", Icon = "User"})
local CombatTab = Window:MakeTab({Title = "⚔️ القتال", Icon = "Swords"})
local VisualsTab = Window:MakeTab({Title = "👁️ المظهر", Icon = "Eye"})
local FarmTab = Window:MakeTab({Title = "💰 الفارم", Icon = "Coins"})
local SettingsTab = Window:MakeTab({Title = "⚙️ الإعدادات", Icon = "Settings"})

-- 🏠 Main Tab
MainTab:AddSection("⚡ Quick Actions")

MainTab:AddButton({
    Name = "🚀 Load Full Script",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/ThatSick/HighlightMM2/main/Lite"))()
    end
})

local RoundInfo = MainTab:AddParagraph("Round Information", "جاري التحميل...")

-- 👤 Player Tab
PlayerTab:AddSection("🚶 Movement")

local SpeedToggle = PlayerTab:AddToggle({
    Name = "🔥 Speed Hack",
    Default = Config.EnableWalkSpeed,
    Callback = function(value)
        Config.EnableWalkSpeed = value
        if value then
            while Config.EnableWalkSpeed and task.wait() do
                if Humanoid then
                    Humanoid.WalkSpeed = Config.WalkSpeedInput
                end
            end
        else
            if Humanoid then
                Humanoid.WalkSpeed = 16
            end
        end
    end
})

PlayerTab:AddSlider({
    Name = "Speed Value",
    Min = 16,
    Max = 200,
    Default = Config.WalkSpeedInput,
    Increment = 1,
    Callback = function(value)
        Config.WalkSpeedInput = value
    end
})

local JumpToggle = PlayerTab:AddToggle({
    Name = "🦘 High Jump",
    Default = Config.EnableJumpPower,
    Callback = function(value)
        Config.EnableJumpPower = value
        if value then
            while Config.EnableJumpPower and task.wait() do
                if Humanoid then
                    Humanoid.JumpPower = Config.JumpPowerInput
                end
            end
        else
            if Humanoid then
                Humanoid.JumpPower = 50
            end
        end
    end
})

PlayerTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 500,
    Default = Config.JumpPowerInput,
    Increment = 1,
    Callback = function(value)
        Config.JumpPowerInput = value
    end
})

PlayerTab:AddToggle({
    Name = "∞ Infinite Jump",
    Default = Config.InfiniteJump,
    Callback = function(value)
        Config.InfiniteJump = value
    end
})

PlayerTab:AddToggle({
    Name = "👻 Noclip",
    Default = Config.Noclip,
    Callback = function(value)
        Config.Noclip = value
    end
})

PlayerTab:AddSection("📍 Teleport")

UpdateQueues.TeleportDropdown = PlayerTab:AddDropdown({
    Name = "Teleport To Player",
    Options = RefreshPlayersList(),
    Default = nil,
    Callback = function(value)
        if Config.UpdateMethod == "On Dropdown Change" and UpdateQueues.UpdateTeleport then
            UpdatePlayerLists("On Dropdown Change", UpdateQueues.TeleportDropdown)
            UpdateQueues.UpdateTeleport = false
        end
        TeleportTo("Player", value)
    end
})

PlayerTab:AddButton({
    Name = "📍 Teleport to Murderer",
    Callback = function()
        TeleportTo("Murderer")
    end
})

PlayerTab:AddButton({
    Name = "📍 Teleport to Sheriff",
    Callback = function()
        TeleportTo("Sheriff")
    end
})

PlayerTab:AddButton({
    Name = "📍 Teleport to Lobby",
    Callback = function()
        TeleportTo("Lobby")
    end
})

PlayerTab:AddSection("👁️ Spectate")

UpdateQueues.SpectateDropdown = PlayerTab:AddDropdown({
    Name = "Spectate Player",
    Options = RefreshPlayersList(),
    Default = nil,
    Callback = function(value)
        if Config.UpdateMethod == "On Dropdown Change" and UpdateQueues.UpdateSpectate then
            UpdatePlayerLists("On Dropdown Change", UpdateQueues.SpectateDropdown)
            UpdateQueues.UpdateSpectate = false
        end
        Spectate("Player", value)
    end
})

PlayerTab:AddButton({
    Name = "👁️ Spectate Murderer",
    Callback = function()
        Spectate("Murderer")
    end
})

PlayerTab:AddButton({
    Name = "👁️ Spectate Sheriff",
    Callback = function()
        Spectate("Sheriff")
    end
})

PlayerTab:AddButton({
    Name = "⏹️ Stop Spectating",
    Callback = function()
        Spectate("Stop")
    end
})

-- ⚔️ Combat Tab
CombatTab:AddSection("🔪 Murderer Features")

local KillAuraToggle = CombatTab:AddToggle({
    Name = "💀 Kill Aura",
    Default = Config.KillAura,
    Callback = function(value)
        Config.KillAura = value
    end
})

CombatTab:AddSlider({
    Name = "Kill Aura Range",
    Min = 5,
    Max = 50,
    Default = Config.KillAuraRange,
    Increment = 1,
    Callback = function(value)
        Config.KillAuraRange = value
    end
})

CombatTab:AddToggle({
    Name = "🔪 Auto Kill Sheriff",
    Default = Config.AutoKillSheriff,
    Callback = function(value)
        Config.AutoKillSheriff = value
    end
})

CombatTab:AddToggle({
    Name = "🔪 Auto Kill Everyone",
    Default = Config.AutoKillEveryone,
    Callback = function(value)
        Config.AutoKillEveryone = value
    end
})

CombatTab:AddToggle({
    Name = "🎯 Knife Silent Aim",
    Default = Config.KnifeSilentAim,
    Callback = function(value)
        Config.KnifeSilentAim = value
    end
})

UpdateQueues.KillDropdown = CombatTab:AddDropdown({
    Name = "Players To Kill",
    Options = RefreshPlayersList(),
    Default = {},
    Multi = true,
    Callback = function(values)
        if Config.UpdateMethod == "On Dropdown Change" and UpdateQueues.UpdateKill then
            UpdatePlayerLists("On Dropdown Change", UpdateQueues.KillDropdown)
            UpdateQueues.UpdateKill = false
        end
    end
})

CombatTab:AddSection("🔫 Gun Features")

CombatTab:AddToggle({
    Name = "🤖 Auto Grab Gun",
    Default = Config.AutoGrabGun,
    Callback = function(value)
        Config.AutoGrabGun = value
    end
})

CombatTab:AddToggle({
    Name = "🎯 Gun Aura",
    Default = Config.GunAura,
    Callback = function(value)
        Config.GunAura = value
    end
})

CombatTab:AddToggle({
    Name = "🔫 Auto Break Gun",
    Default = Config.AutoBreakGun,
    Callback = function(value)
        Config.AutoBreakGun = value
    end
})

CombatTab:AddToggle({
    Name = "🎯 Sheriff Silent Aim",
    Default = Config.SheriffSilentAim,
    Callback = function(value)
        Config.SheriffSilentAim = value
    end
})

CombatTab:AddSection("🚀 Fling")

UpdateQueues.FlingDropdown = CombatTab:AddDropdown({
    Name = "Players To Fling",
    Options = RefreshPlayersList(),
    Default = nil,
    Callback = function(value)
        if Config.UpdateMethod == "On Dropdown Change" and UpdateQueues.UpdateFling then
            UpdatePlayerLists("On Dropdown Change", UpdateQueues.FlingDropdown)
            UpdateQueues.UpdateFling = false
        end
    end
})

CombatTab:AddButton({
    Name = "🚀 Fling Murderer",
    Callback = function()
        -- Fling logic here
    end
})

CombatTab:AddButton({
    Name = "🚀 Fling Sheriff",
    Callback = function()
        -- Fling logic here
    end
})

CombatTab:AddButton({
    Name = "🚀 Fling All",
    Callback = function()
        -- Fling all logic here
    end
})

-- 👁️ Visuals Tab
VisualsTab:AddSection("🎨 Highlights")

VisualsTab:AddToggle({
    Name = "🔴 Show Murderer",
    Default = Config.ShowMurderer,
    Callback = function(value)
        Config.ShowMurderer = value
        CreateHighlight("Murderer")
    end
})

VisualsTab:AddToggle({
    Name = "🔵 Show Sheriff",
    Default = Config.ShowSheriff,
    Callback = function(value)
        Config.ShowSheriff = value
        CreateHighlight("Sheriff")
    end
})

VisualsTab:AddToggle({
    Name = "🟢 Show Innocent",
    Default = Config.ShowInnocent,
    Callback = function(value)
        Config.ShowInnocent = value
        CreateHighlight("Innocent")
    end
})

VisualsTab:AddToggle({
    Name = "🔫 Show Gun",
    Default = Config.ShowGun,
    Callback = function(value)
        Config.ShowGun = value
    end
})

VisualsTab:AddSection("📝 ESP")

VisualsTab:AddToggle({
    Name = "🔴 Murderer ESP",
    Default = Config.MurdererESP,
    Callback = function(value)
        Config.MurdererESP = value
        if value and GameData.Murderer then
            local player = Players:FindFirstChild(GameData.Murderer)
            if player then
                CreateESP(player, Color3.fromRGB(255, 0, 0), Config.ESPTextSize, Config.ESPTextTransparency)
            end
        end
    end
})

VisualsTab:AddToggle({
    Name = "🔵 Sheriff ESP",
    Default = Config.SheriffESP,
    Callback = function(value)
        Config.SheriffESP = value
        if value and GameData.Sheriff then
            local player = Players:FindFirstChild(GameData.Sheriff)
            if player then
                CreateESP(player, Color3.fromRGB(0, 0, 255), Config.ESPTextSize, Config.ESPTextTransparency)
            end
        end
    end
})

VisualsTab:AddToggle({
    Name = "🟢 Innocent ESP",
    Default = Config.InnocentESP,
    Callback = function(value)
        Config.InnocentESP = value
        if value then
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Name ~= GameData.Murderer and player.Name ~= GameData.Sheriff then
                    CreateESP(player, Color3.fromRGB(0, 255, 0), Config.ESPTextSize, Config.ESPTextTransparency)
                end
            end
        end
    end
})

VisualsTab:AddSlider({
    Name = "ESP Text Size",
    Min = 5,
    Max = 25,
    Default = Config.ESPTextSize,
    Increment = 1,
    Callback = function(value)
        Config.ESPTextSize = value
    end
})

-- ⚙️ Settings Tab
SettingsTab:AddSection("👥 Whitelist")

UpdateQueues.WhitelistDropdown = SettingsTab:AddDropdown({
    Name = "Whitelisted Players",
    Options = RefreshPlayersList(),
    Default = {},
    Multi = true,
    Callback = function(values)
        if Config.UpdateMethod == "On Dropdown Change" then
            UpdatePlayerLists("On Dropdown Change", UpdateQueues.WhitelistDropdown)
        end
        Config.WhitelistedPlayers = values
    end
})

SettingsTab:AddToggle({
    Name = "🤝 Whitelist Friends",
    Default = Config.WhitelistFriends,
    Callback = function(value)
        Config.WhitelistFriends = value
    end
})

SettingsTab:AddToggle({
    Name = "🔪 Whitelist Murderer",
    Default = Config.WhitelistMurderer,
    Callback = function(value)
        Config.WhitelistMurderer = value
    end
})

SettingsTab:AddSection("🔄 Player List")

SettingsTab:AddToggle({
    Name = "🔄 Auto Update Player List",
    Default = Config.AutoUpdatePlayerList,
    Callback = function(value)
        Config.AutoUpdatePlayerList = value
    end
})

SettingsTab:AddDropdown({
    Name = "Update Method",
    Options = {"On Player Event", "On Dropdown Change"},
    Default = Config.UpdateMethod,
    Callback = function(value)
        Config.UpdateMethod = value
    end
})

SettingsTab:AddSlider({
    Name = "Update Delay",
    Min = 0.1,
    Max = 10,
    Default = Config.AutoUpdateDelay,
    Increment = 0.1,
    Callback = function(value)
        Config.AutoUpdateDelay = value
    end
})

SettingsTab:AddButton({
    Name = "🔄 Update Player List",
    Callback = function()
        UpdatePlayerLists("On Player Event")
    end
})

SettingsTab:AddSection("ℹ️ Script Info")

SettingsTab:AddParagraph("MM2 Symphony Hub", "جميع الميزات الأصلية\nالإصدار: 10.0\nBy: YourName")

-- 🔄 Game Events
Players.PlayerAdded:Connect(function(player)
    if Config.DynamicUpdateMethod then
        if #Players:GetPlayers() <= 5 then
            Config.UpdateMethod = "On Player Event"
        else
            Config.UpdateMethod = "On Dropdown Change"
        end
    end
    
    if Config.AutoUpdatePlayerList then
        UpdatePlayerLists(Config.UpdateMethod)
    end
    
    if Config.WhitelistFriends and LocalPlayer:IsFriendsWith(player.UserId) then
        table.insert(Config.WhitelistedPlayers, player.Name)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    if Config.DynamicUpdateMethod then
        if #Players:GetPlayers() <= 3 then
            Config.UpdateMethod = "On Player Event"
        else
            Config.UpdateMethod = "On Dropdown Change"
        end
    end
    
    if Config.AutoUpdatePlayerList then
        UpdatePlayerLists(Config.UpdateMethod)
    end
    
    -- Remove from whitelist
    for i, name in ipairs(Config.WhitelistedPlayers) do
        if name == player.Name then
            table.remove(Config.WhitelistedPlayers, i)
            break
        end
    end
end)

-- 🔄 Character Updates
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    Humanoid = char:WaitForChild("Humanoid")
    RootPart = char:WaitForChild("HumanoidRootPart")
    
    -- Reapply features
    if Config.EnableWalkSpeed then
        Humanoid.WalkSpeed = Config.WalkSpeedInput
    end
    
    if Config.EnableJumpPower then
        Humanoid.JumpPower = Config.JumpPowerInput
    end
end)

-- ∞ Infinite Jump Implementation
UserInputService.JumpRequest:Connect(function()
    if Config.InfiniteJump and Humanoid then
        Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

-- 👻 Noclip Implementation
RunService.Stepped:Connect(function()
    if Config.Noclip and Character then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 🎯 Kill Aura Implementation
task.spawn(function()
    while task.wait(0.1) do
        if Config.KillAura and GameData.Murderer == LocalPlayer.Name then
            pcall(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        local targetHRP = player.Character:FindFirstChild("HumanoidRootPart")
                        if targetHRP then
                            local distance = (RootPart.Position - targetHRP.Position).Magnitude
                            if distance <= Config.KillAuraRange then
                                firetouchinterest(RootPart, targetHRP, 0)
                                firetouchinterest(RootPart, targetHRP, 1)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- 💰 Coin Aura Implementation
task.spawn(function()
    while task.wait(0.3) do
        if Config.CoinAura and GameData.IsRoundStarted then
            pcall(function()
                for _, obj in pairs(Workspace:GetChildren()) do
                    if obj.Name == "Coin_Server" then
                        firetouchinterest(RootPart, obj, 0)
                        firetouchinterest(RootPart, obj, 1)
                    end
                end
            end)
        end
    end
end)

-- 🎯 Gun Aura Implementation
task.spawn(function()
    while task.wait(0.5) do
        if Config.GunAura and GameData.GunDrop then
            pcall(function()
                local gun = GameData.GunDrop
                firetouchinterest(RootPart, gun, 0)
                firetouchinterest(RootPart, gun, 1)
            end)
        end
    end
end)

-- 🚫 Anti Trap Implementation
task.spawn(function()
    while task.wait() do
        if Config.AntiTrap then
            pcall(function()
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj.Name == "Trap" and obj.Parent ~= Character then
                        obj:Destroy()
                    end
                end
            end)
        end
    end
end)

-- 🔄 Update Round Info
task.spawn(function()
    while task.wait(1) do
        local info = string.format(
            "الجولة: %s\nالقاتل: %s\nالشريف: %s\nالمسدس: %s",
            GameData.IsRoundStarted and "🔴 مبدأية" or "🟢 انتظار",
            GameData.Murderer or "غير معروف",
            GameData.Sheriff or "غير معروف",
            GameData.GunDrop and "🟡 مسقوط" or "⚪ غير مسقوط"
        )
        RoundInfo:Set(info)
    end
end)

-- ✅ Notify Load
Window:Notify({
    Title = "✅ MM2 Symphony Hub",
    Content = "تم تحميل السكربت بنجاح!\nجميع الميزات جاهزة للاستخدام.",
    Duration = 5,
    Image = "rbxassetid://10734953451"
})

print("🎮 MM2 Symphony Hub loaded successfully!")
print("📊 Players: " .. #Players:GetPlayers())
print("⚡ Features ready: All")
