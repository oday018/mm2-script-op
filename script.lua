-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local AimbotEnabled = false
local AimbotFOV = 100
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")

-- Load Rayfield UI Library
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Main Window
local Window = Rayfield:CreateWindow({
    Name = "Eclipse UI",
    LoadingTitle = "Welcome to the Hub",
    LoadingSubtitle = "by Delight",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "EclipseConfigs",
        FileName = "EclipseSettings"
    },
    KeySystem = true,
    KeySettings = {
        Title = "A Nightmare",
        Subtitle = "Key System",
        Note = "I gotch ya its Enlighten.",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"Enlighten", "DeEnlighten"}
    }
})

local versionUrl = "https://raw.githubusercontent.com/MehDelight/Eclipse-UI/refs/heads/main/Version"

local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://7034178313"
sound.Volume = 1
sound.Parent = SoundService

task.spawn(function()
    local success, result = pcall(function()
        return HttpService:GetAsync(versionUrl)
    end)

    if success and result then
        sound:Play()
        Rayfield:Notify({
            Title = "Script Hub Loaded",
            Content = "Current Version: " .. result,
            Duration = 6,
            Image = 4483362458,
        })
    else
        sound:Play()
        Rayfield:Notify({
            Title = "Script Hub Loaded",
            Content = "Version: 2.0",
            Duration = 6,
            Image = 4483362458,
        })
    end
end)

-- Tabs --
local MainTab = Window:CreateTab("Main", 4483362458)
local GameTab = Window:CreateTab("Games", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

-- Sections --

local PlayerSection = MainTab:CreateSection("Player")

-- WalkSpeed
MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 500},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Callback = function(Value)
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end,
})

-- JumpPower
MainTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 500},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpPower = Value

        end
    end,
})

MainTab:CreateSlider({
    Name = "Jump Height(if the jumppower didnt work",
    Range = {8, 500},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(Value)
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.JumpHeight = Value

        end
    end,
})

-- Noclip
local noclipEnabled = false
MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(Value)
        noclipEnabled = Value
        task.spawn(function()
            while noclipEnabled do
                local character = Player.Character
                if character then
                    for _, part in ipairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                task.wait()
            end
        end)
    end,
})

local FeaturesSection = MainTab:CreateSection("Features")
local AFSection = GameTab:CreateSection("Auto Farm")

-- Auto Hoops
GameTab:CreateToggle({
    Name = "Legends of Speed Auto Hoops",
    CurrentValue = false,
    Flag = "AutoHoopsToggle1",
    Callback = function(Value)
        _G.Auto = Value
        task.spawn(function()
            while _G.Auto do
                local rootPart = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    for _, v in ipairs(workspace.Hoops:GetChildren()) do
                        rootPart.CFrame = v.CFrame
                        task.wait(0.2)
                    end
                end
                task.wait(0.5)
            end
        end)
    end,
})

local QSSection = GameTab:CreateSection("Quick Script")
-- Infinite Yield
GameTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end,
})
local GSSection = GameTab:CreateSection("Game Script")

GameTab:CreateButton({
    Name = "Prison Life (PrisonWare)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Denverrz/scripts/master/PRISONWARE_v1.3.txt"))();
    end,
})

-- Blox Fruits (Redz Hub)
local BFButton = GameTab:CreateButton({
   Name = "Blox Fruit (redz hub)",
   Callback = function()
   
   loadstring(game:HttpGet("https://raw.githubusercontent.com/newredz/BloxFruits/refs/heads/main/Source.luau"))(Settings)
end,
})

GameTab:CreateButton({
    Name = "Arsenal Script",
    Callback = function()
        if game.PlaceId == 286090429 then
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Johnny39871/ArsenalScript/main/Script"))()
        else
            Rayfield:Notify({
                Title = "Wrong Game",
                Content = "Join Arsenal to use this script.",
                Duration = 5,
            })
        end
    end,
})

local DRButton = GameTab:CreateButton({
   Name = "Dead Rails (Nat Hub)",
   Callback = function()

   loadstring(game:HttpGet("https://raw.githubusercontent.com/ArdyBotzz/NatHub/refs/heads/master/NatHub.lua"))()
end,

})

local TohButton = GameTab:CreateButton({
   Name = "Tower of Hell",
   Callback = function()
   
   if game.PlaceId == 1962086868 then

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/jensonhirst/Orion/main/source')))()

local OrionWindow = OrionLib:MakeWindow({Name = "Tower of Hell", HidePremium = false, SaveConfig = true, ConfigFolder = "Delight"})

local MainTab = OrionWindow:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

MainTab:AddButton({
  Name = "Anti Cheat Bypass",
  Callback = function()
  local playerscripts = game:GetService'Players'.LocalPlayer.PlayerScripts

local script1 = playerscripts.LocalScript
local script2 = playerscripts.LocalScript2

local script1signal = script1.Changed
local script2signal = script2.Changed

for i, connection in next, getconnections(script1signal) do
    connection:Disable()
end
for i, connection in next, getconnections(script2signal) do
    connection:Disable()
end

script1:Destroy()
script2:Destroy()
end,
})

MainTab:AddButton({
	Name = "Teleport to end",
	Callback = function()
		local part = workspace:FindFirstChild("Teleportend")
		
		-- Create the part if it doesn't exist
		if not part then
			part = Instance.new("Part")
			part.Name = "Teleportend"
			part.Parent = workspace
			part.CanCollide = false
			part.Anchored = true
			part.Transparency = 1
			part.CFrame = CFrame.new(
				-30.4304543, 297.748871, 27.8156776,
				0.647168756, -3.15087179e-10, -0.762346804,
				4.84563811e-09, 1, 3.70022968e-09,
				0.762346804, -6.08872952e-09, 0.647168756
			)
		end

		-- Teleport the player
		local char = game.Players.LocalPlayer.Character
		if char and char:FindFirstChild("HumanoidRootPart") then
			char.HumanoidRootPart.CFrame = part.CFrame
		end
	end,
})

MainTab:AddButton({
	Name = "All gear",
	Callback = function()
local j = game.ReplicatedStorage.Assets.Gear.jump:Clone()
local g = game.ReplicatedStorage.Assets.Gear.gravity:Clone()
local h = game.ReplicatedStorage.Assets.Gear.hook:Clone()
local ho = game.ReplicatedStorage.Assets.Gear.hourglass:Clone()
local f = game.ReplicatedStorage.Assets.Gear.fusion:Clone()
j.Parent = game.Players.LocalPlayer.Backpack
f.Parent = game.Players.LocalPlayer.Backpack
ho.Parent = game.Players.LocalPlayer.Backpack
g.Parent = game.Players.LocalPlayer.Backpack
h.Parent = game.Players.LocalPlayer.Backpack
  	end,
})

MainTab:AddButton({
	Name = "God mode",
	Callback = function()
local player = game.Players.LocalPlayer
local character = player.Character

function GodMode()
    character.Humanoid:GetPropertyChangedSignal("Health"):Connect(function()
        if character.Humanoid.Health < 100 then
            character.Humanoid.Health = 100
        end
    end)
end


GodMode()
end,
})

else

Rayfield:Notify({
   Title = "Unsupported Game.",
   Content = "This game is not the supported game to execute the script. You will be kicked after 5-6 seconds.",
   Duration = 6.5,
   Image = 4483362458,

})

task.wait(6.5)
game.Players.LocalPlayer:Kick("Unsupported Game.")

end

   end,
})



-------

-- Destroy UI
SettingsTab:CreateKeybind({
    Name = "Destroy UI",
    CurrentKeybind = "Q",
    Callback = function()
        Rayfield:Destroy()
    end,
})

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local localPlayer = game.Players.LocalPlayer
    local character = localPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end

    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local distance = (character.HumanoidRootPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestPlayer = player
            end
        end
    end
    return closestPlayer
end

local function fling()
    local target = getClosestPlayer()
    local localPlayer = game.Players.LocalPlayer
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local char = localPlayer.Character
        local targetHRP = target.Character.HumanoidRootPart

        -- Create velocity
        local flingVelocity = Instance.new("BodyVelocity")
        flingVelocity.Velocity = Vector3.new(9999, 9999, 9999) -- change as needed
        flingVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
        flingVelocity.P = 1e9
        flingVelocity.Parent = targetHRP

        -- Remove after short delay
        game.Debris:AddItem(flingVelocity, 0.1)
    end
end

MainTab:CreateButton({
    Name = "Fling Player",
    Callback = function()
        fling()
    end,
})

-- Teleport to Player
local TweenPlayer = MainTab:CreateInput({
   Name = "Tween to player",
   CurrentValue = "",
   PlaceholderText = "Put the player name to teleport",
   RemoveTextAfterFocusLost = false,
   Flag = "Input1",
   Callback = function(Text)
       local ts = game:GetService("TweenService")
       local ti = TweenInfo.new(1, Enum.EasingStyle.Linear)
       local Player = game.Players.LocalPlayer
       
       local char = Player.Character or Player.CharacterAdded:Wait()
       local root = char:WaitForChild("HumanoidRootPart")
       
       local TargetPlayer = game.Players:FindFirstChild(Text)
       if TargetPlayer and TargetPlayer.Character and TargetPlayer.Character:FindFirstChild("HumanoidRootPart") then
           local Goal = {}
           Goal.CFrame = TargetPlayer.Character.HumanoidRootPart.CFrame

           local Tween = ts:Create(root, ti, Goal)
           Tween:Play()
       else
           warn("Target player or their HumanoidRootPart not found!")
       end
   end
})

MainTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Callback = function(Value)
        AimbotEnabled = Value
    end,
})

-- Infinite Jump
local infiniteJumpEnabled = false
MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        infiniteJumpEnabled = Value
    end,
})

UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled then
        local humanoid = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- ESP
local espEnabled = false
local espFolder = Instance.new("Folder", game.CoreGui)
espFolder.Name = "ESP"

local function createHighlight(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        if not espFolder:FindFirstChild(player.Name) then
            local highlight = Instance.new("Highlight")
            highlight.Name = player.Name
            highlight.Adornee = player.Character
            highlight.FillColor = Color3.fromRGB(128, 0, 128)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
            highlight.FillTransparency = 0.5
            highlight.Parent = espFolder
        end
    end
end

local function removeHighlight(player)
    local highlight = espFolder:FindFirstChild(player.Name)
    if highlight then
        highlight:Destroy()
    end
end

Players.PlayerRemoving:Connect(removeHighlight)
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        if espEnabled then
            task.wait(1)
            createHighlight(player)
        end
    end)
end)

task.spawn(function()
    while true do
        if espEnabled then
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= Player then
                    createHighlight(player)
                end
            end
        else
            for _, obj in ipairs(espFolder:GetChildren()) do
                obj:Destroy()
            end
        end
        task.wait(1)
    end
end)

MainTab:CreateToggle({
    Name = "Player ESP (Purple)",
    CurrentValue = false,
    Callback = function(Value)
        espEnabled = Value
    end,
})

-- Server Hop
SettingsTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local PlaceId = game.PlaceId
        local Servers = {}
        local Player = game.Players.LocalPlayer

        local function serverHop()
            local success, response = pcall(function()
                return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
            end)

            if success and response and response.data then
                for _, server in ipairs(response.data) do
                    if server.playing < server.maxPlayers and server.id ~= game.JobId then
                        queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/MehDelight/Eclipse-UI/refs/heads/main/script'))()")
                        TeleportService:TeleportToPlaceInstance(PlaceId, server.id, Player)
                        break
                    end
                end
            end
        end

        serverHop()
    end,
})

-- Rejoin Button --

SettingsTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/MehDelight/Eclipse-UI/refs/heads/main/script'))()")
        TeleportService:Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
})

-- Anti-AFK
SettingsTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            getgenv().AntiAFKConnection = Player.Idled:Connect(function()
                VirtualUser = game:GetService("VirtualUser")
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                task.wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
            end)
        else
            if getgenv().AntiAFKConnection then
                getgenv().AntiAFKConnection:Disconnect()
                getgenv().AntiAFKConnection = nil
            end
        end
    end,
})

-- [Silent Aimbot Additions for Multiple Games]

local silentAimbotEnabled = false

local function getClosestPlayerToMouse() local closest, distance = nil, math.huge for _, plr in ipairs(Players:GetPlayers()) do if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Head") then local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(plr.Character.Head.Position) if onScreen then local mousePos = UserInputService:GetMouseLocation() local mag = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude if mag < distance then closest = plr distance = mag end end end end return closest end

local oldNamecall oldNamecall = hookmetamethod(game, "__namecall", function(self, ...) local args = { ... } local method = getnamecallmethod()

if silentAimbotEnabled then
    if game.PlaceId == 286090429 and tostring(self) == "HitPart" and method == "FireServer" then -- Arsenal
        local target = getClosestPlayerToMouse()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            args[2] = target.Character.Head
            args[3] = target.Character.Head.Position
            return oldNamecall(self, unpack(args))
        end
    elseif game.PlaceId == 66654135 and tostring(self) == "ShootGun" and method == "FireServer" then -- MM2
        local target = getClosestPlayerToMouse()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local shootDir = (target.Character.Head.Position - workspace.CurrentCamera.CFrame.Position).Unit * 500
            args[1] = workspace.CurrentCamera.CFrame.Position
            args[2] = shootDir
            return oldNamecall(self, unpack(args))
        end
    elseif game.PlaceId == 292439477 and tostring(self) == "HitDetection" and method == "FireServer" then -- Phantom Forces
        local target = getClosestPlayerToMouse()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            args[2] = target.Character.Head
            args[3] = target.Character.Head.Position
            return oldNamecall(self, unpack(args))
        end
    end
end

return oldNamecall(self, ...)

end)

MainTab:CreateToggle({
Name = "Silent Aimbot",
CurrentValue = false,
Callback = function(Value)
silentAimbotEnabled = Value
end,
})

local function getClosestPlayer()
    local closest, shortestDistance = nil, AimbotFOV
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= Player and plr.Character and plr.Character:FindFirstChild("Head") then
            local screenPos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            if onScreen then
                local viewportSize = Camera.ViewportSize
                local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                if distance < shortestDistance then
                    closest = plr
                    shortestDistance = distance
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if AimbotEnabled then
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
        end
    end
end)
