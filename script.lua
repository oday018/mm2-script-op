-- First, load the Wand UI library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- Create the main window
local Window = Library:MakeWindow({
    Title = "Wand UI | Murder Mystery 2",
    SubTitle = "v5 Remake by real_redz",
    ScriptFolder = "MM2-Hack"
})

-- Create tabs
local MainTab = Window:MakeTab({Title = "Main", Icon = "Home"})
local TeleportTab = Window:MakeTab({Title = "Teleport", Icon = "Navigation"})
local VisualTab = Window:MakeTab({Title = "Visual", Icon = "Eye"})
local CombatTab = Window:MakeTab({Title = "Combat", Icon = "Swords"})
local MiscTab = Window:MakeTab({Title = "Miscellaneous", Icon = "Settings"})
local SettingsTab = Window:MakeTab({Title = "Settings", Icon = "Cog"})

-- Initialize your game variables
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- Game state tracking
local GameState = {
    Roles = {},
    IsRoundActive = false,
    GunDrop = nil,
    Map = nil,
    WhitelistedPlayers = {}
}

-- Whitelist section
MiscTab:AddSection("Whitelist")

local WhitelistDropdown = MiscTab:AddDropdown({
    Name = "Select Player to Whitelist",
    Options = {},
    Default = "",
    Callback = function(Selected)
        if Selected and Selected ~= "" then
            table.insert(GameState.WhitelistedPlayers, Selected)
            Library:Notify({
                Title = "Whitelist",
                Content = "Added " .. Selected .. " to whitelist",
                Duration = 3
            })
        end
    end
})

MiscTab:AddButton({
    Name = "Refresh Player List",
    Callback = function()
        local PlayerNames = {}
        for _, Player in ipairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer then
                table.insert(PlayerNames, Player.Name)
            end
        end
        WhitelistDropdown:SetValues(PlayerNames)
    end
})

MiscTab:AddButton({
    Name = "Clear Whitelist",
    Callback = function()
        GameState.WhitelistedPlayers = {}
        Library:Notify({
            Title = "Whitelist",
            Content = "Cleared all whitelisted players",
            Duration = 3
        })
    end
})

-- Teleport section
TeleportTab:AddSection("Teleport Locations")

TeleportTab:AddButton({
    Name = "Teleport to Murderer",
    Callback = function()
        if GameState.Roles.Murderer then
            local MurdererChar = GameState.Roles.Murderer.Character
            if MurdererChar and MurdererChar:FindFirstChild("HumanoidRootPart") then
                HumanoidRootPart.CFrame = MurdererChar.HumanoidRootPart.CFrame
            end
        else
            Library:Notify({
                Title = "Teleport",
                Content = "Murderer not found",
                Duration = 3
            })
        end
    end
})

TeleportTab:AddButton({
    Name = "Teleport to Sheriff",
    Callback = function()
        if GameState.Roles.Sheriff then
            local SheriffChar = GameState.Roles.Sheriff.Character
            if SheriffChar and SheriffChar:FindFirstChild("HumanoidRootPart") then
                HumanoidRootPart.CFrame = SheriffChar.HumanoidRootPart.CFrame
            end
        else
            Library:Notify({
                Title = "Teleport",
                Content = "Sheriff not found",
                Duration = 3
            })
        end
    end
})

TeleportTab:AddSection("Custom Teleport")

local TeleportTargetDropdown = TeleportTab:AddDropdown({
    Name = "Teleport to Player",
    Options = {},
    Default = "",
    Callback = function(Selected)
        if Selected and Selected ~= "" then
            local TargetPlayer = Players:FindFirstChild(Selected)
            if TargetPlayer and TargetPlayer.Character then
                local TargetRoot = TargetPlayer.Character:FindFirstChild("HumanoidRootPart")
                if TargetRoot then
                    HumanoidRootPart.CFrame = TargetRoot.CFrame
                end
            end
        end
    end
})

-- Auto-grab features
MainTab:AddSection("Auto Features")

local AutoGrabGunToggle = MainTab:AddToggle({
    Name = "Auto Grab Gun",
    Default = false,
    Callback = function(Value)
        if Value then
            Library:Notify({
                Title = "Auto Grab",
                Content = "Auto grab gun enabled",
                Duration = 3
            })
        end
    end
})

local AutoStealGunToggle = MainTab:AddToggle({
    Name = "Auto Steal Gun",
    Default = false,
    Callback = function(Value)
        if Value then
            Library:Notify({
                Title = "Auto Steal",
                Content = "Auto steal gun enabled",
                Duration = 3
            })
        end
    end
})

-- Combat features
CombatTab:AddSection("Murderer Features")

local MurdererMode = CombatTab:AddToggle({
    Name = "Enable Murderer Mode",
    Default = false,
    Callback = function(Value)
        if Value and GameState.Roles.Murderer and GameState.Roles.Murderer == LocalPlayer then
            Library:Notify({
                Title = "Murderer Mode",
                Content = "Enabled murderer abilities",
                Duration = 3
            })
        elseif Value then
            Library:Notify({
                Title = "Warning",
                Content = "You are not the murderer",
                Duration = 3
            })
        end
    end
})

CombatTab:AddButton({
    Name = "Auto Kill Nearest Player",
    Callback = function()
        if GameState.Roles.Murderer == LocalPlayer then
            -- Implementation for auto kill
        end
    end
})

-- Visual features
VisualTab:AddSection("ESP")

local MurdererESPToggle = VisualTab:AddToggle({
    Name = "Murderer ESP",
    Default = false,
    Callback = function(Value)
        if Value then
            -- Implement murderer ESP
        end
    end
})

local SheriffESPToggle = VisualTab:AddToggle({
    Name = "Sheriff ESP",
    Default = false,
    Callback = function(Value)
        if Value then
            -- Implement sheriff ESP
        end
    end
})

-- Settings
SettingsTab:AddSection("UI Settings")

local UIScaleSlider = SettingsTab:AddSlider({
    Name = "UI Scale",
    Min = 0.6,
    Max = 1.6,
    Default = 1.0,
    Increment = 0.1,
    Callback = function(Value)
        Library:SetUIScale(Value)
    end
})

-- Function to update player lists
function UpdatePlayerLists()
    local PlayerNames = {}
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            table.insert(PlayerNames, Player.Name)
        end
    end
    WhitelistDropdown:SetValues(PlayerNames)
    TeleportTargetDropdown:SetValues(PlayerNames)
end

-- Connect events
Players.PlayerAdded:Connect(UpdatePlayerLists)
Players.PlayerRemoving:Connect(UpdatePlayerLists)

-- Initial update
UpdatePlayerLists()

-- Game state monitoring
game:GetService("RunService").Heartbeat:Connect(function()
    -- Update game state here
    -- Check for roles, gun drop, etc.
end)

-- Show welcome notification
Library:Notify({
    Title = "Wand UI Loaded",
    Content = "Murder Mystery 2 Hack by real_redz",
    Duration = 5,
    Image = "rbxassetid://10734953451"
})
