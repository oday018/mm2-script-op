-- Wand UI MM2 Exploit
-- By real_redz

-- Load Wand UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Player and Character
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Camera = Workspace.CurrentCamera

-- Game Variables
local GameData = {
    Roles = {},
    Map = nil,
    GunDrop = nil,
    IsRoundStarted = false,
    WhitelistedPlayers = {},
    LastPosition = HumanoidRootPart.CFrame,
    LastVelocity = Vector3.new(0, 0, 0)
}

-- Create Main Window
local Window = Library:MakeWindow({
    Title = "Wand UI | Murder Mystery 2",
    SubTitle = "V5 Remake by real_redz",
    ScriptFolder = "MM2-Exploit"
})

-- Create Tabs
local MainTab = Window:MakeTab({Title = "Main", Icon = "Home"})
local TeleportTab = Window:MakeTab({Title = "Teleport", Icon = "Navigation"})
local CombatTab = Window:MakeTab({Title = "Combat", Icon = "Swords"})
local VisualTab = Window:MakeTab({Title = "Visual", Icon = "Eye"})
local PlayerTab = Window:MakeTab({Title = "Players", Icon = "Users"})
local MiscTab = Window:MakeTab({Title = "Miscellaneous", Icon = "Settings"})

-- Show Welcome Notification
Window:Notify({
    Title = "Wand UI Loaded",
    Content = "Murder Mystery 2 Exploit by real_redz",
    Duration = 5,
    Image = "rbxassetid://10734953451"
})

-- ============================================================================
-- SECTION 1: PLAYER MANAGEMENT & WHITELIST
-- ============================================================================

PlayerTab:AddSection("Player Management")

-- Whitelist System
local WhitelistedPlayers = {}

local WhitelistDropdown = PlayerTab:AddDropdown({
    Name = "Select Player to Whitelist",
    Options = {},
    Default = "",
    Callback = function(Selected)
        if Selected and Selected ~= "" and not table.find(WhitelistedPlayers, Selected) then
            table.insert(WhitelistedPlayers, Selected)
            Window:Notify({
                Title = "Whitelist",
                Content = "Added " .. Selected .. " to whitelist",
                Duration = 3
            })
        end
    end
})

local RemoveWhitelistDropdown = PlayerTab:AddDropdown({
    Name = "Select Player to Remove",
    Options = {},
    Default = "",
    Callback = function(Selected)
        if Selected and Selected ~= "" then
            local index = table.find(WhitelistedPlayers, Selected)
            if index then
                table.remove(WhitelistedPlayers, index)
                Window:Notify({
                    Title = "Whitelist",
                    Content = "Removed " .. Selected .. " from whitelist",
                    Duration = 3
                })
            end
        end
    end
})

PlayerTab:AddButton({
    Name = "Refresh Player Lists",
    Callback = function()
        local playerNames = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playerNames, player.Name)
            end
        end
        WhitelistDropdown:SetValues(playerNames)
        RemoveWhitelistDropdown:SetValues(playerNames)
    end
})

PlayerTab:AddButton({
    Name = "Clear All Whitelists",
    Callback = function()
        WhitelistedPlayers = {}
        Window:Notify({
            Title = "Whitelist",
            Content = "Cleared all whitelisted players",
            Duration = 3
        })
    end
})

-- ============================================================================
-- SECTION 2: TELEPORT SYSTEM
-- ============================================================================

TeleportTab:AddSection("Teleport Locations")

-- Role-based teleport
TeleportTab:AddButton({
    Name = "Teleport to Murderer",
    Callback = function()
        if GameData.Roles.Murderer then
            local murderer = Players:FindFirstChild(GameData.Roles.Murderer)
            if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
                HumanoidRootPart.CFrame = murderer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            end
        end
    end
})

TeleportTab:AddButton({
    Name = "Teleport to Sheriff",
    Callback = function()
        if GameData.Roles.Sheriff then
            local sheriff = Players:FindFirstChild(GameData.Roles.Sheriff)
            if sheriff and sheriff.Character and sheriff.Character:FindFirstChild("HumanoidRootPart") then
                HumanoidRootPart.CFrame = sheriff.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            end
        end
    end
})

TeleportTab:AddButton({
    Name = "Teleport to Lobby",
    Callback = function()
        local lobby = Workspace:FindFirstChild("Lobby")
        if lobby and lobby:FindFirstChild("Lobby") then
            local spawns = lobby.Lobby.Spawns:GetChildren()
            if #spawns > 0 then
                HumanoidRootPart.CFrame = spawns[math.random(1, #spawns)].CFrame
            end
        end
    end
})

-- Player teleport
TeleportTab:AddSection("Teleport to Player")

local TeleportPlayerDropdown = TeleportTab:AddDropdown({
    Name = "Select Player",
    Options = {},
    Default = "",
    Callback = function(Selected)
        if Selected and Selected ~= "" then
            local player = Players:FindFirstChild(Selected)
            if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            end
        end
    end
})

-- ============================================================================
-- SECTION 3: COMBAT & FLING SYSTEM
-- ============================================================================

CombatTab:AddSection("Fling System")

local FlingTargetDropdown = CombatTab:AddDropdown({
    Name = "Select Player to Fling",
    Options = {},
    Default = "",
    Callback = function(Selected)
        if Selected and Selected ~= "" then
            local targetPlayer = Players:FindFirstChild(Selected)
            if targetPlayer then
                Fling(targetPlayer)
            end
        end
    end
})

CombatTab:AddButton({
    Name = "Fling All Players",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not table.find(WhitelistedPlayers, player.Name) then
                Fling(player)
            end
        end
    end
})

CombatTab:AddSection("Kill System")

local KillTargetDropdown = CombatTab:AddDropdown({
    Name = "Select Player to Kill",
    Options = {},
    Default = "",
    Callback = function(Selected)
        if Selected and Selected ~= "" then
            KillPlayer(Selected)
        end
    end
})

CombatTab:AddButton({
    Name = "Kill All Players",
    Callback = function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and not table.find(WhitelistedPlayers, player.Name) then
                KillPlayer(player.Name)
            end
        end
    end
})

-- ============================================================================
-- SECTION 4: VISUAL FEATURES
-- ============================================================================

VisualTab:AddSection("ESP System")

local ESPEnabled = false
local ESPInstances = {}

local ESPToggle = VisualTab:AddToggle({
    Name = "Enable ESP",
    Default = false,
    Callback = function(Value)
        ESPEnabled = Value
        if not Value then
            ClearESP()
        else
            CreateESP()
        end
    end
})

local MurdererESPToggle = VisualTab:AddToggle({
    Name = "Murderer ESP",
    Default = true,
    Callback = function(Value)
        -- Murderer ESP logic
    end
})

local SheriffESPToggle = VisualTab:AddToggle({
    Name = "Sheriff ESP",
    Default = true,
    Callback = function(Value)
        -- Sheriff ESP logic
    end
})

local GunDropESPToggle = VisualTab:AddToggle({
    Name = "Gun Drop ESP",
    Default = true,
    Callback = function(Value)
        -- Gun drop ESP logic
    end
})

-- ============================================================================
-- SECTION 5: MISCELLANEOUS FEATURES
-- ============================================================================

MiscTab:AddSection("Auto Features")

local AutoGrabGunToggle = MiscTab:AddToggle({
    Name = "Auto Grab Gun",
    Default = false,
    Callback = function(Value)
        if Value then
            Window:Notify({
                Title = "Auto Grab",
                Content = "Auto grab gun enabled",
                Duration = 3
            })
        end
    end
})

local AutoStealGunToggle = MiscTab:AddToggle({
    Name = "Auto Steal Gun",
    Default = false,
    Callback = function(Value)
        if Value then
            Window:Notify({
                Title = "Auto Steal",
                Content = "Auto steal gun enabled",
                Duration = 3
            })
        end
    end
})

local AutoKillToggle = MiscTab:AddToggle({
    Name = "Auto Kill Nearest",
    Default = false,
    Callback = function(Value)
        if Value then
            Window:Notify({
                Title = "Auto Kill",
                Content = "Auto kill enabled",
                Duration = 3
            })
        end
    end
})

MiscTab:AddSection("Anti-Fling")

local AntiFlingEnabled = false
local AntiFlingToggle = MiscTab:AddToggle({
    Name = "Enable Anti-Fling",
    Default = false,
    Callback = function(Value)
        AntiFlingEnabled = Value
        Window:Notify({
            Title = "Anti-Fling",
            Content = Value and "Enabled" or "Disabled",
            Duration = 3
        })
    end
})

-- ============================================================================
-- SECTION 6: CORE FUNCTIONS
-- ============================================================================

-- Fling Function
function Fling(targetPlayer)
    pcall(function()
        local char = targetPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChildOfClass("Humanoid") then 
            return 
        end
        
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local root = humanoid.RootPart
        
        if humanoid.Sit then return end
        
        getgenv().OldPos = HumanoidRootPart.CFrame
        
        Workspace.FallenPartsDestroyHeight = 0/0
        
        local bv = Instance.new("BodyVelocity")
        bv.Name = "FlingVelocity"
        bv.Parent = HumanoidRootPart
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = Vector3.new(90000000, 900000000, 90000000)
        
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        Camera.CameraSubject = char.Head or humanoid
        
        local function FlingPart(part)
            HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 1.5, 0) * CFrame.Angles(math.rad(90), 0, 0)
            Character:SetPrimaryPartCFrame(HumanoidRootPart.CFrame)
            task.wait()
            HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, -1.5, 0)
            Character:SetPrimaryPartCFrame(HumanoidRootPart.CFrame)
            task.wait()
        end
        
        local startTime = tick()
        while tick() - startTime < 8 and root.Parent and humanoid.Health > 0 do
            FlingPart(root)
            task.wait()
        end
        
        bv:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        Camera.CameraSubject = Humanoid
        HumanoidRootPart.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
        
        Window:Notify({
            Title = "Fling",
            Content = "Fling completed on " .. targetPlayer.Name,
            Duration = 3
        })
    end)
end

-- Kill Player Function
function KillPlayer(playerName)
    pcall(function()
        local target = Players:FindFirstChild(playerName)
        if not target or not target.Character then return end
        
        -- Implementation depends on role
        Window:Notify({
            Title = "Kill",
            Content = "Attempting to kill " .. playerName,
            Duration = 3
        })
    end)
end

-- ESP Functions
function CreateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreatePlayerESP(player)
        end
    end
end

function CreatePlayerESP(player)
    -- ESP implementation here
end

function ClearESP()
    for _, instance in pairs(ESPInstances) do
        if instance then
            instance:Destroy()
        end
    end
    ESPInstances = {}
end

-- Anti-Fling Protection
RunService.Heartbeat:Connect(function()
    if AntiFlingEnabled then
        pcall(function()
            if HumanoidRootPart.AssemblyLinearVelocity.Magnitude > 250 or HumanoidRootPart.AssemblyAngularVelocity.Magnitude > 250 then
                HumanoidRootPart.CFrame = GameData.LastPosition
                HumanoidRootPart.AssemblyLinearVelocity = GameData.LastVelocity
                HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            else
                GameData.LastPosition = HumanoidRootPart.CFrame
                GameData.LastVelocity = HumanoidRootPart.AssemblyLinearVelocity
            end
            
            -- Collision protection
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in ipairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end)
    end
end)

-- Role Detection
function UpdateRoles()
    -- Implement role detection logic
end

-- Map Detection
function FindMap()
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Model") and (obj.Name == "CoinContainer" or obj.Name == "CoinAreas") then
            GameData.Map = obj.Parent
            break
        end
    end
end

-- Gun Drop Detection
function FindGunDrop()
    local normalMap = Workspace:FindFirstChild("Normal")
    if normalMap then
        GameData.GunDrop = normalMap:FindFirstChild("GunDrop")
    end
end

-- Auto Functions
function AutoGrabGun()
    if AutoGrabGunToggle.Value and GameData.GunDrop then
        -- Implement auto grab
    end
end

function AutoStealGun()
    if AutoStealGunToggle.Value then
        -- Implement auto steal
    end
end

function AutoKillNearest()
    if AutoKillToggle.Value then
        -- Implement auto kill
    end
end

-- Update Functions
function UpdateAll()
    UpdateRoles()
    FindMap()
    FindGunDrop()
    AutoGrabGun()
    AutoStealGun()
    AutoKillNearest()
end

-- ============================================================================
-- SECTION 7: EVENTS & INITIALIZATION
-- ============================================================================

-- Player list updater
local function UpdatePlayerLists()
    local playerNames = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(playerNames, player.Name)
        end
    end
    WhitelistDropdown:SetValues(playerNames)
    RemoveWhitelistDropdown:SetValues(playerNames)
    TeleportPlayerDropdown:SetValues(playerNames)
    FlingTargetDropdown:SetValues(playerNames)
    KillTargetDropdown:SetValues(playerNames)
end

-- Connect events
Players.PlayerAdded:Connect(UpdatePlayerLists)
Players.PlayerRemoving:Connect(UpdatePlayerLists)

-- Main loop
RunService.Heartbeat:Connect(function()
    UpdateAll()
end)

-- Initial setup
UpdatePlayerLists()
FindMap()

-- Dialog on load
Window:Dialog({
    Title = "Welcome to Wand UI",
    Content = "This script contains exploit features for Murder Mystery 2.\nUse at your own risk.",
    Options = {
        {
            Name = "I Understand",
            Callback = function()
                Window:Notify({
                    Title = "Ready",
                    Content = "Script initialized successfully",
                    Duration = 3
                })
            end
        },
        {
            Name = "Exit"
        }
    }
})
