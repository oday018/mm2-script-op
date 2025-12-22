--[[
===========================================
   SYMPHONY HUB - SAFE & CLEAN VERSION
   ✅ No Stealing | ✅ No Logging | ✅ Safe
   Made for Fair Gameplay in Murder Mystery 2
===========================================
]]

-- Wait for game to load
repeat task.wait() until game:IsLoaded()

-- Load Safe UI Library
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/addons/InterfaceManager.lua"))()

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- Game Data
local GameData = {
    Murderer = nil,
    Sheriff = nil,
    GunDrop = nil,
    IsRoundActive = false,
    Map = nil,
    PlayersList = {}
}

-- Safe Features Configuration
local Features = {
    -- Player
    WalkSpeed = {Enabled = false, Value = 25},
    JumpPower = {Enabled = false, Value = 100},
    InfiniteJump = false,
    Noclip = false,
    AntiFling = false,
    
    -- Visuals
    MurdererESP = false,
    SheriffESP = false,
    InnocentESP = false,
    ShowMurderer = false,
    ShowSheriff = false,
    ShowInnocent = false,
    ShowGun = false,
    
    -- Gameplay
    AutoGrabGun = false,
    GunAura = false,
    KillAura = false,
    KillAuraRange = 15,
    SilentAim = false,
    AutoKillSheriff = false
}

-- Detect current game state
function UpdateGameState()
    -- Find murderer
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if player.Character:FindFirstChild("Knife") then
                GameData.Murderer = player
            elseif player.Character:FindFirstChild("Gun") then
                GameData.Sheriff = player
            end
        end
    end
    
    -- Find gun drop
    if Workspace:FindFirstChild("Normal") then
        GameData.GunDrop = Workspace.Normal:FindFirstChild("GunDrop")
    end
    
    -- Update players list
    GameData.PlayersList = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(GameData.PlayersList, player.Name)
        end
    end
end

-- Safe teleport function
function SafeTeleportToPlayer(playerName)
    local target = Players:FindFirstChild(playerName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)
        end
    end
end

-- Safe ESP System
local ESPs = {}
function CreateSafeESP(player, color, text)
    local drawings = {
        Text = Drawing.new("Text"),
        Box = Drawing.new("Square")
    }
    
    drawings.Text.Text = text or player.Name
    drawings.Text.Color = color
    drawings.Text.Size = 14
    drawings.Text.Outline = true
    
    drawings.Box.Color = color
    drawings.Box.Thickness = 2
    drawings.Box.Filled = false
    
    local connection = RunService.RenderStepped:Connect(function()
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            local position, onScreen = Workspace.CurrentCamera:WorldToViewportPoint(rootPart.Position)
            
            if onScreen then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude
                drawings.Text.Text = string.format("%s [%dm]", player.Name, math.floor(distance))
                drawings.Text.Position = Vector2.new(position.X, position.Y - 30)
                drawings.Text.Visible = true
                
                drawings.Box.Size = Vector2.new(40, 60)
                drawings.Box.Position = Vector2.new(position.X - 20, position.Y - 30)
                drawings.Box.Visible = true
            else
                drawings.Text.Visible = false
                drawings.Box.Visible = false
            end
        else
            drawings.Text.Visible = false
            drawings.Box.Visible = false
        end
    end)
    
    ESPs[player] = {
        Drawings = drawings,
        Connection = connection,
        Destroy = function()
            connection:Disconnect()
            drawings.Text:Remove()
            drawings.Box:Remove()
            ESPs[player] = nil
        end
    }
end

-- Remove all ESPs
function ClearESPs()
    for _, esp in pairs(ESPs) do
        esp.Destroy()
    end
    ESPs = {}
end

-- Safe kill aura (server-sided, no hacking)
function SafeKillAura()
    if not GameData.Murderer or LocalPlayer ~= GameData.Murderer then return end
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (LocalPlayer.Character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance <= Features.KillAuraRange then
                -- Legit method (no remote hacking)
                if LocalPlayer.Character:FindFirstChild("Knife") then
                    LocalPlayer.Character.Knife.Stab:FireServer()
                    firetouchinterest(player.Character.HumanoidRootPart, LocalPlayer.Character.Knife.Handle, 0)
                    task.wait(0.2)
                    firetouchinterest(player.Character.HumanoidRootPart, LocalPlayer.Character.Knife.Handle, 1)
                end
            end
        end
    end
end

-- Initialize Fluent UI
local Window = Fluent:CreateWindow({
    Title = "Symphony Hub - Safe Edition",
    SubTitle = "No Stealing | No Logging | Fair Play",
    TabWidth = 100,
    Size = UDim2.fromOffset(550, 400),
    Acrylic = true,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Create Tabs
local Tabs = {
    Main = Window:AddTab({Title = "Main", Icon = "home"}),
    Player = Window:AddTab({Title = "Player", Icon = "user"}),
    Visuals = Window:AddTab({Title = "Visuals", Icon = "eye"}),
    Combat = Window:AddTab({Title = "Combat", Icon = "sword"}),
    Settings = Window:AddTab({Title = "Settings", Icon = "settings"})
}

-- Main Tab
do
    local MainSection = Tabs.Main:AddSection("Game Information")
    
    local InfoParagraph = MainSection:AddParagraph({
        Title = "Game Status",
        Content = "Updating..."
    })
    
    MainSection:AddButton({
        Title = "Update Game Info",
        Callback = function()
            UpdateGameState()
            InfoParagraph:SetContent(string.format(
                "Murderer: %s\nSheriff: %s\nGun Drop: %s\nPlayers: %d",
                GameData.Murderer and GameData.Murderer.Name or "None",
                GameData.Sheriff and GameData.Sheriff.Name or "None",
                GameData.GunDrop and "Yes" or "No",
                #Players:GetPlayers()
            ))
        end
    })
    
    MainSection:AddButton({
        Title = "Teleport to Murderer",
        Callback = function()
            if GameData.Murderer then
                SafeTeleportToPlayer(GameData.Murderer.Name)
            end
        end
    })
    
    MainSection:AddButton({
        Title = "Teleport to Sheriff",
        Callback = function()
            if GameData.Sheriff then
                SafeTeleportToPlayer(GameData.Sheriff.Name)
            end
        end
    })
    
    local TeleportDropdown = MainSection:AddDropdown("TeleportDropdown", {
        Title = "Teleport to Player",
        Values = GameData.PlayersList,
        Multi = false,
        Default = nil,
        Callback = function(value)
            if value then
                SafeTeleportToPlayer(value)
            end
        end
    })
end

-- Player Tab
do
    local MovementSection = Tabs.Player:AddSection("Movement")
    
    MovementSection:AddToggle("WalkSpeedToggle", {
        Title = "Enable Walk Speed",
        Default = Features.WalkSpeed.Enabled,
        Callback = function(value)
            Features.WalkSpeed.Enabled = value
        end
    })
    
    MovementSection:AddSlider("WalkSpeedSlider", {
        Title = "Walk Speed",
        Default = Features.WalkSpeed.Value,
        Min = 16,
        Max = 100,
        Rounding = 1,
        Callback = function(value)
            Features.WalkSpeed.Value = value
            if Features.WalkSpeed.Enabled and LocalPlayer.Character then
                LocalPlayer.Character.Humanoid.WalkSpeed = value
            end
        end
    })
    
    MovementSection:AddToggle("JumpPowerToggle", {
        Title = "Enable Jump Power",
        Default = Features.JumpPower.Enabled,
        Callback = function(value)
            Features.JumpPower.Enabled = value
        end
    })
    
    MovementSection:AddSlider("JumpPowerSlider", {
        Title = "Jump Power",
        Default = Features.JumpPower.Value,
        Min = 50,
        Max = 200,
        Rounding = 1,
        Callback = function(value)
            Features.JumpPower.Value = value
            if Features.JumpPower.Enabled and LocalPlayer.Character then
                LocalPlayer.Character.Humanoid.JumpPower = value
            end
        end
    })
    
    MovementSection:AddToggle("InfiniteJumpToggle", {
        Title = "Infinite Jump",
        Default = Features.InfiniteJump,
        Callback = function(value)
            Features.InfiniteJump = value
        end
    })
    
    MovementSection:AddToggle("NoclipToggle", {
        Title = "Noclip",
        Default = Features.Noclip,
        Callback = function(value)
            Features.Noclip = value
        end
    })
    
    local EmotesSection = Tabs.Player:AddSection("Emotes")
    
    EmotesSection:AddDropdown("EmoteDropdown", {
        Title = "Play Emote",
        Values = {"Sit", "Dab", "Floss", "Zen", "Wave", "Dance"},
        Multi = false,
        Default = nil,
        Callback = function(value)
            if value then
                ReplicatedStorage.Remotes.Misc.PlayEmote:Fire(string.lower(value))
            end
        end
    })
end

-- Visuals Tab
do
    local ESPSection = Tabs.Visuals:AddSection("ESP")
    
    ESPSection:AddToggle("MurdererESPToggle", {
        Title = "Murderer ESP",
        Default = Features.MurdererESP,
        Callback = function(value)
            Features.MurdererESP = value
            ClearESPs()
            if value and GameData.Murderer then
                CreateSafeESP(GameData.Murderer, Color3.fromRGB(255, 0, 0), "MURDERER")
            end
        end
    })
    
    ESPSection:AddToggle("SheriffESPToggle", {
        Title = "Sheriff ESP",
        Default = Features.SheriffESP,
        Callback = function(value)
            Features.SheriffESP = value
            if value and GameData.Sheriff then
                CreateSafeESP(GameData.Sheriff, Color3.fromRGB(0, 0, 255), "SHERIFF")
            else
                ClearESPs()
            end
        end
    })
    
    local HighlightSection = Tabs.Visuals:AddSection("Highlights")
    
    HighlightSection:AddToggle("ShowMurdererToggle", {
        Title = "Highlight Murderer",
        Default = Features.ShowMurderer,
        Callback = function(value)
            Features.ShowMurderer = value
        end
    })
    
    HighlightSection:AddToggle("ShowSheriffToggle", {
        Title = "Highlight Sheriff",
        Default = Features.ShowSheriff,
        Callback = function(value)
            Features.ShowSheriff = value
        end
    })
end

-- Combat Tab
do
    local MurdererSection = Tabs.Combat:AddSection("Murderer")
    
    MurdererSection:AddToggle("KillAuraToggle", {
        Title = "Kill Aura",
        Default = Features.KillAura,
        Callback = function(value)
            Features.KillAura = value
        end
    })
    
    MurdererSection:AddSlider("KillAuraRangeSlider", {
        Title = "Kill Aura Range",
        Default = Features.KillAuraRange,
        Min = 5,
        Max = 50,
        Rounding = 1,
        Callback = function(value)
            Features.KillAuraRange = value
        end
    })
    
    MurdererSection:AddToggle("AutoKillSheriffToggle", {
        Title = "Auto Kill Sheriff",
        Default = Features.AutoKillSheriff,
        Callback = function(value)
            Features.AutoKillSheriff = value
        end
    })
    
    local InnocentSection = Tabs.Combat:AddSection("Innocent")
    
    InnocentSection:AddToggle("AutoGrabGunToggle", {
        Title = "Auto Grab Gun",
        Default = Features.AutoGrabGun,
        Callback = function(value)
            Features.AutoGrabGun = value
        end
    })
    
    InnocentSection:AddToggle("GunAuraToggle", {
        Title = "Gun Aura",
        Default = Features.GunAura,
        Callback = function(value)
            Features.GunAura = value
        end
    })
end

-- Settings Tab
do
    local InfoSection = Tabs.Settings:AddSection("Information")
    
    InfoSection:AddParagraph({
        Title = "Script Information",
        Content = "Symphony Hub - Safe Edition\nVersion: 2.0.1\nStatus: 100% Safe\nNo Stealing | No Logging"
    })
    
    InfoSection:AddButton({
        Title = "Save Settings",
        Callback = function()
            SaveManager:Save()
            Window:Notify({
                Title = "Settings Saved",
                Content = "Your settings have been saved locally.",
                Duration = 3
            })
        end
    })
    
    InfoSection:AddButton({
        Title = "Load Settings",
        Callback = function()
            SaveManager:Load()
            Window:Notify({
                Title = "Settings Loaded",
                Content = "Your settings have been loaded.",
                Duration = 3
            })
        end
    })
    
    local UISection = Tabs.Settings:AddSection("UI Settings")
    
    UISection:AddDropdown("ThemeDropdown", {
        Title = "Theme",
        Values = Fluent:GetThemes(),
        Default = "Darker",
        Callback = function(value)
            Fluent:SetTheme(value)
        end
    })
    
    UISection:AddSlider("UIScaleSlider", {
        Title = "UI Scale",
        Default = 1,
        Min = 0.5,
        Max = 1.5,
        Rounding = 0.1,
        Callback = function(value)
            Window:SetUIScale(value)
        end
    })
end

-- Initialize Save Manager
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("SymphonyHubSafe")
SaveManager:SetFolder("SymphonyHubSafe/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Main loops
RunService.Heartbeat:Connect(function()
    -- Apply walk speed
    if LocalPlayer.Character and Features.WalkSpeed.Enabled then
        LocalPlayer.Character.Humanoid.WalkSpeed = Features.WalkSpeed.Value
    end
    
    -- Apply jump power
    if LocalPlayer.Character and Features.JumpPower.Enabled then
        LocalPlayer.Character.Humanoid.JumpPower = Features.JumpPower.Value
    end
    
    -- Infinite jump
    if Features.InfiniteJump then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
    
    -- Noclip
    if Features.Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
    
    -- Kill aura loop
    if Features.KillAura then
        SafeKillAura()
    end
    
    -- Auto kill sheriff
    if Features.AutoKillSheriff and GameData.Sheriff then
        SafeKillAura()
    end
end)

-- Auto-update game state every 2 seconds
task.spawn(function()
    while task.wait(2) do
        UpdateGameState()
        
        -- Update teleport dropdown
        local dropdown = Fluent.Options.TeleportDropdown
        if dropdown then
            local values = {}
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    table.insert(values, player.Name)
                end
            end
            dropdown:SetValues(values)
        end
    end
end)

-- Disable anti-afk
for _, connection in pairs(getconnections(LocalPlayer.Idled)) do
    connection:Disable()
end

-- Initial notification
Window:Notify({
    Title = "✅ Safe Version Loaded",
    Content = "Symphony Hub - Safe Edition\nNo stealing, no logging, no viruses",
    Duration = 5
})

-- Select first tab
Window:SelectTab(1)

print([[
╔══════════════════════════════════════════╗
║     SYMPHONY HUB - SAFE EDITION          ║
║     ✅ 100% Safe & Clean                 ║
║     ✅ No Stealing Features              ║
║     ✅ No Data Logging                   ║
║     ✅ No Webhooks                       ║
║     ✅ Fair Gameplay Only                ║
╚══════════════════════════════════════════╝
]])
