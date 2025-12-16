local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")
local players = game:GetService("Players")
local wrk = game:GetService("Workspace")
local plr = players.LocalPlayer
local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
local humanoid = plr.Character:FindFirstChild("Humanoid")

local function onCharacterAdded(character)
    hrp = character:WaitForChild("HumanoidRootPart")
    humanoid = character:WaitForChild("Humanoid")
end

plr.CharacterAdded:Connect(onCharacterAdded)

if plr.Character then
    onCharacterAdded(plr.Character)
end

local camera = wrk.CurrentCamera
local mouse = plr:GetMouse()

local httprequest = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local hue = 0
local rainbowFov = false
local rainbowSpeed = 0.005

local aimFov = 100
local aimParts = {"Head"}
local aiming = false
local predictionStrength = 0.065
local smoothing = 0.05

local aimbotEnabled = false
local wallCheck = true
local stickyAimEnabled = false
local teamCheck = false
local healthCheck = false
local minHealth = 0

local antiAim = false

local antiAimAmountX = 0
local antiAimAmountY = -100
local antiAimAmountZ = 0

local antiAimMethod = "Reset Velo"

local randomVeloRange = 100

local spinBot = false
local spinBotSpeed = 20

local circleColor = Color3.fromRGB(255, 0, 0)
local targetedCircleColor = Color3.fromRGB(0, 255, 0)

local aimViewerEnabled = false
local ignoreSelf = true

-- Function to fetch keys from a URL
local function fetchKeys(url)
    local success, response = pcall(function()
        return game:HttpGet(url)
    end)
    if not success then
        warn("Failed to fetch keys from: " .. url)
        return {}
    end
    local keys = {}
    for key in response:gmatch("[^\r\n]+") do
        table.insert(keys, key)
    end
    return keys
end

-- Fetch keys from both sources
local validKeys = {}
local githubKeys = fetchKeys("https://raw.githubusercontent.com/THEBWARE/-/refs/heads/main/johncenaop.txt")
local pastebinKeys = fetchKeys("https://pastebin.com/raw/UEuXVrir")

-- Combine keys from both sources
for _, key in ipairs(githubKeys) do
    table.insert(validKeys, key)
end
for _, key in ipairs(pastebinKeys) do
    table.insert(validKeys, key)
end

-- Copy key link to clipboard automatically if getgenv().autocopykey is true
if getgenv().autocopykey == true then
    setclipboard("https://thebware.github.io/-/key.html")
    Rayfield:Notify({
        Title = "Key Link Copied",
        Content = "The key link has been copied to your clipboard!",
        Duration = 6.5,
        Image = nil,
    })
end

-- Create Window with Key System
local Window = Rayfield:CreateWindow({
    Name = "Cevor MM2 V8",
    Icon = 0,
    LoadingTitle = "Cevor MM2 V8",
    LoadingSubtitle = "by ScripterBob",
    Theme = "Default",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "CevorMM2Config",
        FileName = "CevorMM2Config"
    },
    Discord = {
        Enabled = true,
        Invite = "https://discord.gg/PpYn4v5vR2",
        RememberJoins = true
    },
    KeySystem = true,
    KeySettings = {
        Title = "Cevor MM2 V8",
        Subtitle = "Key System",
        Note = "Key Link Has Been Copied To Clipboard",
        FileName = "CevorMM2Key",
        SaveKey = false,
        GrabKeyFromSite = false, -- Disable grabbing key from site (we handle it manually)
        Key = validKeys -- Use the combined keys
    }
})

-- Notify User
Rayfield:Notify({
    Title = "Cevor MM2 V8",
    Content = "Script loaded successfully!",
    Duration = 6.5,
    Image = nil,
})

local MainTab = Window:CreateTab("🏠 Main", nil)
local Section = MainTab:CreateSection("Main Features")

local Aimbot = Window:CreateTab("Aimbot 🎯")
local AntiAim = Window:CreateTab("Anti-Aim 😡")
local Misc = Window:CreateTab("Misc 🤷‍♂️")

local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 2
fovCircle.Radius = aimFov
fovCircle.Filled = false
fovCircle.Color = circleColor
fovCircle.Visible = false

local currentTarget = nil

local function checkTeam(player)
    if teamCheck and player.Team == plr.Team then
        return true
    end
    return false
end

local function checkWall(targetCharacter)
    local targetHead = targetCharacter:FindFirstChild("Head")
    if not targetHead then return true end

    local origin = camera.CFrame.Position
    local direction = (targetHead.Position - origin).unit * (targetHead.Position - origin).magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {plr.Character, targetCharacter}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist

    local raycastResult = wrk:Raycast(origin, direction, raycastParams)
    return raycastResult and raycastResult.Instance ~= nil
end

local function getClosestPart(character)
    local closestPart = nil
    local shortestCursorDistance = aimFov
    local cameraPos = camera.CFrame.Position

    for _, partName in ipairs(aimParts) do
        local part = character:FindFirstChild(partName)
        if part then
            local partPos = camera:WorldToViewportPoint(part.Position)
            local screenPos = Vector2.new(partPos.X, partPos.Y)
            local cursorDistance = (screenPos - Vector2.new(mouse.X, mouse.Y)).Magnitude

            if cursorDistance < shortestCursorDistance and partPos.Z > 0 then
                shortestCursorDistance = cursorDistance
                closestPart = part
            end
        end
    end

    return closestPart
end

local function getTarget()
    local nearestPlayer = nil
    local closestPart = nil
    local shortestCursorDistance = aimFov

    for _, player in ipairs(players:GetPlayers()) do
        if player ~= plr and player.Character and not checkTeam(player) then
            if player.Character.Humanoid.Health >= minHealth or not healthCheck then
                local targetPart = getClosestPart(player.Character)
                if targetPart then
                    local screenPos = camera:WorldToViewportPoint(targetPart.Position)
                    local cursorDistance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude

                    if cursorDistance < shortestCursorDistance then
                        if not checkWall(player.Character) or not wallCheck then
                            shortestCursorDistance = cursorDistance
                            nearestPlayer = player
                            closestPart = targetPart
                        end
                    end
                end
            end
        end
    end

    return nearestPlayer, closestPart
end

local function predict(player, part)
    if player and part then
        local velocity = player.Character.HumanoidRootPart.Velocity
        local predictedPosition = part.Position + (velocity * predictionStrength)
        return predictedPosition
    end
    return nil
end

local function smooth(from, to)
    return from:Lerp(to, smoothing)
end

local function aimAt(player, part)
    local predictedPosition = predict(player, part)
    if predictedPosition then
        if player.Character.Humanoid.Health >= minHealth or not healthCheck then
            local targetCFrame = CFrame.new(camera.CFrame.Position, predictedPosition)
            camera.CFrame = smooth(camera.CFrame, targetCFrame)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local offset = 50
        fovCircle.Position = Vector2.new(mouse.X, mouse.Y + offset)

        if rainbowFov then
            hue = hue + rainbowSpeed
            if hue > 1 then hue = 0 end
            fovCircle.Color = Color3.fromHSV(hue, 1, 1)
        else
            if aiming and currentTarget then
                fovCircle.Color = targetedCircleColor
            else
                fovCircle.Color = circleColor
            end
        end

        if aiming then
            if stickyAimEnabled and currentTarget then
                local headPos = camera:WorldToViewportPoint(currentTarget.Character.Head.Position)
                local screenPos = Vector2.new(headPos.X, headPos.Y)
                local cursorDistance = (screenPos - Vector2.new(mouse.X, mouse.Y)).Magnitude

                if cursorDistance > aimFov or (wallCheck and checkWall(currentTarget.Character)) or checkTeam(currentTarget) then
                    currentTarget = nil
                end
            end

            if not stickyAimEnabled or not currentTarget then
                local target, targetPart = getTarget()
                currentTarget = target
                currentTargetPart = targetPart
            end

            if currentTarget and currentTargetPart then
                aimAt(currentTarget, currentTargetPart)
            end
        else
            currentTarget = nil
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if antiAim then
        if antiAimMethod == "Reset Velo" then
            local vel = hrp.Velocity
            hrp.Velocity = Vector3.new(antiAimAmountX, antiAimAmountY, antiAimAmountZ)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
        elseif antiAimMethod == "Reset Pos [BROKEN]" then
            local pos = hrp.CFrame
            hrp.Velocity = Vector3.new(antiAimAmountX, antiAimAmountY, antiAimAmountZ)
            RunService.RenderStepped:Wait()
            hrp.CFrame = pos
        elseif antiAimMethod == "Random Velo" then
            local vel = hrp.Velocity
            local a = math.random(-randomVeloRange,randomVeloRange)
            local s = math.random(-randomVeloRange,randomVeloRange)
            local d = math.random(-randomVeloRange,randomVeloRange)
            hrp.Velocity = Vector3.new(a,s,d)
            RunService.RenderStepped:Wait()
            hrp.Velocity = vel
        end
    end
end)

mouse.Button2Down:Connect(function()
    if aimbotEnabled then
        aiming = true
    end
end)

mouse.Button2Up:Connect(function()
    if aimbotEnabled then
        aiming = false
    end
end)

local aimbot = Aimbot:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        aimbotEnabled = Value
        fovCircle.Visible = Value
    end
})

local aimpart = Aimbot:CreateDropdown({
    Name = "Aim Part",
    Options = {"Head","HumanoidRootPart","Left Arm","Right Arm","Torso","Left Leg","Right Leg"},
    CurrentOption = {"Head"},
    MultipleOptions = true,
    Flag = "AimPart",
    Callback = function(Options)
        aimParts = Options
    end,
 })

local smoothingslider = Aimbot:CreateSlider({
    Name = "Smoothing",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 5,
    Flag = "Smoothing",
    Callback = function(Value)
        smoothing = 1 - (Value / 100)
    end,
})

local predictionstrength = Aimbot:CreateSlider({
    Name = "Prediction Strength",
    Range = {0, 0.2},
    Increment = 0.001,
    CurrentValue = 0.065,
    Flag = "PredictionStrength",
    Callback = function(Value)
        predictionStrength = Value
    end,
})

local fovvisibility = Aimbot:CreateToggle({
    Name = "Fov Visibility",
    CurrentValue = true,
    Flag = "FovVisibility",
    Callback = function(Value)
        fovCircle.Visible = Value
    end
})

local aimbotfov = Aimbot:CreateSlider({
    Name = "Aimbot Fov",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = 100,
    Flag = "AimbotFov",
    Callback = function(Value)
        aimFov = Value
        fovCircle.Radius = aimFov
    end,
})

local wallcheck = Aimbot:CreateToggle({
    Name = "Wall Check",
    CurrentValue = true,
    Flag = "WallCheck",
    Callback = function(Value)
        wallCheck = Value
    end
})

local stickyaim = Aimbot:CreateToggle({
    Name = "Sticky Aim",
    CurrentValue = false,
    Flag = "StickyAim",
    Callback = function(Value)
        stickyAimEnabled = Value
    end
})

local teamchecktoggle = Aimbot:CreateToggle({
    Name = "Team Check",
    CurrentValue = false,
    Flag = "TeamCheck",
    Callback = function(Value)
        teamCheck = Value
    end
})

local healthchecktoggle = Aimbot:CreateToggle({
    Name = "Health Check",
    CurrentValue = false,
    Flag = "HealthCheck",
    Callback = function(Value)
        healthCheck = Value
    end
})

local minhealth = Aimbot:CreateSlider({
    Name = "Min Health",
    Range = {0, 100},
    Increment = 1,
    CurrentValue = 0,
    Flag = "MinHealth",
    Callback = function(Value)
        minHealth = Value
    end,
})

local circlecolor = Aimbot:CreateColorPicker({
    Name = "Fov Color",
    Color = circleColor,
    Callback = function(Color)
        circleColor = Color
        fovCircle.Color = Color
    end
})

local targetedcirclecolor = Aimbot:CreateColorPicker({
    Name = "Targeted Fov Color",
    Color = targetedCircleColor,
    Callback = function(Color)
        targetedCircleColor = Color
    end
})

local circlerainbow = Aimbot:CreateToggle({
    Name = "Rainbow Fov",
    CurrentValue = false,
    Flag = "RainbowFov",
    Callback = function(Value)
        rainbowFov = Value
    end
})

local antiaimtoggle = AntiAim:CreateToggle({
    Name = "Anti-Aim",
    CurrentValue = false,
    Flag = "AntiAim",
    Callback = function(Value)
        antiAim = Value
        if Value then
            Rayfield:Notify({Title = "Anti-Aim", Content = "Enabled!", Duration = 1, Image = 4483362458,})
        else
            Rayfield:Notify({Title = "Anti-Aim", Content = "Disabled!", Duration = 1, Image = 4483362458,})
        end
    end
})

local antiaimmethod = AntiAim:CreateDropdown({
    Name = "Anti-Aim Method",
    Options = {"Reset Velo","Random Velo","Reset Pos [BROKEN]"},
    CurrentOption = "Reset Velo",
    Flag = "AntiAimMethod",
    Callback = function(Option)
        antiAimMethod = type(Option) == "table" and Option[1] or Option
        if antiAimMethod == "Reset Velo" then
            Rayfield:Notify({Title = "Reset Velocity", Content = "Nobody will see it, but exploiters will aim in the wrong place.", Duration = 5, Image = 4483362458,})
        elseif antiAimMethod == "Reset Pos [BROKEN]" then
            Rayfield:Notify({Title = "Reset Pos [BROKEN]", Content = "This is a bit buggy right now, so idk if it works that well", Duration = 5, Image = 4483362458,})
        elseif antiAimMethod == "Random Velo" then
            Rayfield:Notify({Title = "Random Velocity", Content = "Depending on ping some peoplev will see u 'teleporting' around but you are actually in the same spot the entire time.", Duration = 5, Image = 4483362458,})
        end
    end,
})

local antiaimamountx = AntiAim:CreateSlider({
    Name = "Anti-Aim Amount X",
    Range = {-1000, 1000},
    Increment = 10,
    CurrentValue = 0,
    Flag = "AntiAimAmountX",
    Callback = function(Value)
        antiAimAmountX = Value
    end,
})

local antiaimamounty = AntiAim:CreateSlider({
    Name = "Anti-Aim Amount Y",
    Range = {-1000, 1000},
    Increment = 10,
    CurrentValue = -100,
    Flag = "AntiAimAmountY",
    Callback = function(Value)
        antiAimAmountY = Value
    end,
})

local antiaimamountz = AntiAim:CreateSlider({
    Name = "Anti-Aim Amount Z",
    Range = {-1000, 1000},
    Increment = 10,
    CurrentValue = 0,
    Flag = "AntiAimAmountZ",
    Callback = function(Value)
        antiAimAmountZ = Value
    end,
})

local randomvelorange = AntiAim:CreateSlider({
    Name = "Random Velo Range",
    Range = {0, 1000},
    Increment = 10,
    CurrentValue = 100,
    Flag = "RandomVeloRange",
    Callback = function(Value)
        randomVeloRange = Value
    end,
})

-- [< Misc >]

local spinbottoggle = Misc:CreateToggle({
    Name = "Spin-Bot",
    CurrentValue = false,
    Flag = "SpinBot",
    Callback = function(Value)
        spinBot = Value
        if Value then
            for i,v in pairs(hrp:GetChildren()) do
                if v.Name == "Spinning" then
                    v:Destroy()
                end
            end
            plr.Character.Humanoid.AutoRotate = false
            local Spin = Instance.new("BodyAngularVelocity")
            Spin.Name = "Spinning"
            Spin.Parent = hrp
            Spin.MaxTorque = Vector3.new(0, math.huge, 0)
            Spin.AngularVelocity = Vector3.new(0,spinBotSpeed,0)
            Rayfield:Notify({Title = "Spin Bot", Content = "Enabled!", Duration = 1, Image = 4483362458,})
        else
            for i,v in pairs(hrp:GetChildren()) do
                if v.Name == "Spinning" then
                    v:Destroy()
                end
            end
            plr.Character.Humanoid.AutoRotate = true
            Rayfield:Notify({Title = "Spin Bot", Content = "Disabled!", Duration = 1, Image = 4483362458,})
        end
    end
})

local spinbotspeed = Misc:CreateSlider({
    Name = "Spin-Bot Speed",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = 20,
    Flag = "SpinBotSpeed",
    Callback = function(Value)
        spinBotSpeed = Value
        if spinBot then
            for i,v in pairs(hrp:GetChildren()) do
                if v.Name == "Spinning" then
                    v:Destroy()
                end
            end
            local Spin = Instance.new("BodyAngularVelocity")
            Spin.Name = "Spinning"
            Spin.Parent = hrp
            Spin.MaxTorque = Vector3.new(0, math.huge, 0)
            Spin.AngularVelocity = Vector3.new(0,Value,0)
        end
    end,
})

local ServerHop = Misc:CreateButton({
	Name = "Server Hop",
	Callback = function()
		if httprequest then
            local servers = {}
            local req = httprequest({Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", game.PlaceId)})
            local body = HttpService:JSONDecode(req.Body)
        
            if body and body.data then
                for i, v in next, body.data do
                    if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= game.JobId then
                        table.insert(servers, 1, v.id)
                    end
                end
            end
        
            if #servers > 0 then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], plr)
            else
                Rayfield:Notify({Title = "Server Hop", Content = "Couldn't find a valid server!!!", Duration = 1, Image = 4483362458,})
            end
        else
            Rayfield:Notify({Title = "Server Hop", Content = "Your executor is ass!", Duration = 1, Image = 4483362458,})
        end
	end,
})

-- Server Hop Tab
local ServerHopTab = Window:CreateTab("🌐 Server Hop", nil)
local ServerHopSection = ServerHopTab:CreateSection("Server Hop Features")

-- Server Hop Functions
local function rejoinServer()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
end

local function joinLowCountServer()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    local lowestPlayerCount = math.huge
    local bestServer = nil
    for i, v in pairs(Servers.data) do
        if v.playing < lowestPlayerCount and v.playing < v.maxPlayers and v.id ~= game.JobId then
            lowestPlayerCount = v.playing
            bestServer = v
        end
    end
    if bestServer then
        TPS:TeleportToPlaceInstance(game.PlaceId, bestServer.id)
    else
        Rayfield:Notify({
            Title = "Server Hop",
            Content = "Couldn't find a low player count server!",
            Duration = 6.5,
            Image = nil,
        })
    end
end

local function joinHighCountServer()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"))
    local highestPlayerCount = 0
    local bestServer = nil
    for i, v in pairs(Servers.data) do
        if v.playing > highestPlayerCount and v.playing < v.maxPlayers and v.id ~= game.JobId then
            highestPlayerCount = v.playing
            bestServer = v
        end
    end
    if bestServer then
        TPS:TeleportToPlaceInstance(game.PlaceId, bestServer.id)
    else
        Rayfield:Notify({
            Title = "Server Hop",
            Content = "Couldn't find a high player count server!",
            Duration = 6.5,
            Image = nil,
        })
    end
end

local function joinBestPingServer()
    local Http = game:GetService("HttpService")
    local TPS = game:GetService("TeleportService")
    local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    local bestPing = math.huge
    local bestServer = nil
    for i, v in pairs(Servers.data) do
        if v.ping < bestPing and v.playing < v.maxPlayers and v.id ~= game.JobId then
            bestPing = v.ping
            bestServer = v
        end
    end
    if bestServer then
        TPS:TeleportToPlaceInstance(game.PlaceId, bestServer.id)
    else
        Rayfield:Notify({
            Title = "Server Hop",
            Content = "Couldn't find a server with the best ping!",
            Duration = 6.5,
            Image = nil,
        })
    end
end

-- Server Hop Buttons
local RejoinButton = ServerHopTab:CreateButton({
    Name = "Rejoin Current Server",
    Callback = rejoinServer,
})

local LowCountButton = ServerHopTab:CreateButton({
    Name = "Join Low Player Count Server",
    Callback = joinLowCountServer,
})

local HighCountButton = ServerHopTab:CreateButton({
    Name = "Join High Player Count Server",
    Callback = joinHighCountServer,
})

local BestPingButton = ServerHopTab:CreateButton({
    Name = "Join Best Ping Server",
    Callback = joinBestPingServer,
})

-- Auto Server Hop Toggle
local AutoServerHopToggle = ServerHopTab:CreateToggle({
    Name = "Auto Server Hop (30 mins)",
    CurrentValue = false,
    Flag = "AutoServerHop",
    Callback = function(Value)
        if Value then
            local function serverHop()
                while AutoServerHopToggle.CurrentValue do
                    wait(1800) -- 30 minutes
                    local Http = game:GetService("HttpService")
                    local TPS = game:GetService("TeleportService")
                    local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
                    for i, v in pairs(Servers.data) do
                        if v.playing ~= v.maxPlayers then
                            TPS:TeleportToPlaceInstance(game.PlaceId, v.id)
                        end
                    end
                end
            end
            serverHop()
        end
    end,
})

-- Copy Key Link Button
local CopyKeyLinkButton = MainTab:CreateButton({
    Name = "Copy Key Link",
    Callback = function()
        setclipboard("https://thebware.github.io/-/key.html")
        Rayfield:Notify({
            Title = "Key Link Copied",
            Content = "The key link has been copied to your clipboard!",
            Duration = 6.5,
            Image = nil,
        })
    end,
})

-- Main Account Mode Toggle
local MainAccountModeToggle = MainTab:CreateToggle({
    Name = "Main Account Mode",
    CurrentValue = false,
    Flag = "MainAccountMode",
    Callback = function(Value)
        if Value then
            Rayfield:Notify({
                Title = "Main Account Mode",
                Content = "Risky features have been disabled to protect your account.",
                Duration = 6.5,
                Image = nil,
            })
        else
            Rayfield:Notify({
                Title = "Main Account Mode",
                Content = "Risky features have been enabled.",
                Duration = 6.5,
                Image = nil,
            })
        end
    end,
})

-- Function to check if Main Account Mode is enabled
local function isMainAccountMode()
    return MainAccountModeToggle.CurrentValue
end

-- Unload Button
local UnloadButton = MainTab:CreateButton({
    Name = "Unload Script",
    Callback = function()
        Rayfield:Destroy()
        for _, v in pairs(game.CoreGui:GetChildren()) do
            if v.Name == "ScreenGui" then
                v:Destroy()
            end
        end
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        for _, connection in pairs(getconnections(game:GetService("RunService").Stepped)) do
            connection:Disconnect()
        end
    end,
})

-- Kill All Button (Disabled in Main Account Mode)
local KillAllButton = MainTab:CreateButton({
    Name = "Kill All",
    Callback = function()
        if isMainAccountMode() then
            Rayfield:Notify({
                Title = "Main Account Mode",
                Content = "This feature is disabled in Main Account Mode.",
                Duration = 6.5,
                Image = nil,
            })
            return
        end
        local teleportedPlayers = {}
        local function killAll()
            while true do
                wait(2)
                local players = {}
                for _, player in pairs(game.Players:GetPlayers()) do
                    if player ~= game.Players.LocalPlayer and not table.find(teleportedPlayers, player) then
                        table.insert(players, player)
                    end
                end
                if #players > 0 then
                    local randomPlayer = players[math.random(1, #players)]
                    local character = randomPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        game.Players.LocalPlayer.Character:MoveTo(character.HumanoidRootPart.Position)
                        table.insert(teleportedPlayers, randomPlayer)
                    end
                else
                    break
                end
            end
        end
        killAll()
    end,
})

-- ESP Button (Enabled in Main Account Mode)
local ESPButton = MainTab:CreateButton({
    Name = "ESP",
    Callback = function()
        local Players = game:GetService("Players")
        local function createHighlight(player)
            local character = player.Character
            if not character then return end
            local highlight = Instance.new("Highlight")
            highlight.Adornee = character
            highlight.FillColor = Color3.new(1, 0, 0)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = character
        end
        local function onCharacterAdded(character)
            local player = Players:GetPlayerFromCharacter(character)
            if player then
                createHighlight(player)
            end
        end
        local function refreshHighlights()
            for _, player in pairs(Players:GetPlayers()) do
                if player.Character then
                    for _, child in pairs(player.Character:GetChildren()) do
                        if child:IsA("Highlight") then
                            child:Destroy()
                        end
                    end
                    createHighlight(player)
                end
            end
        end
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(onCharacterAdded)
            if player.Character then
                createHighlight(player)
            end
        end)
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                createHighlight(player)
            end
            player.CharacterAdded:Connect(onCharacterAdded)
        end
        while true do
            refreshHighlights()
            print("Refreshed Cevor ESP")
            wait(1)
        end
    end,
})

-- Player Tab (Blocked in Main Account Mode)
local PlayerTab = Window:CreateTab("👤 Player", nil)
local PlayerSection = PlayerTab:CreateSection("Player Modifications")

-- Disable Players Tab if Main Account Mode is enabled
if isMainAccountMode() then
    PlayerTab:SetEnabled(false)
    Rayfield:Notify({
        Title = "Main Account Mode",
        Content = "Player modifications are disabled in Main Account Mode.",
        Duration = 6.5,
        Image = nil,
    })
end

-- Walk Speed Slider (Blocked in Main Account Mode)
local WalkSpeedSlider = PlayerTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        if isMainAccountMode() then
            Rayfield:Notify({
                Title = "Main Account Mode",
                Content = "This feature is disabled in Main Account Mode.",
                Duration = 6.5,
                Image = nil,
            })
            return
        end
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})

-- Jump Power Slider (Blocked in Main Account Mode)
local JumpPowerSlider = PlayerTab:CreateSlider({
    Name = "Jump Power",
    Range = {50, 200},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value)
        if isMainAccountMode() then
            Rayfield:Notify({
                Title = "Main Account Mode",
                Content = "This feature is disabled in Main Account Mode.",
                Duration = 6.5,
                Image = nil,
            })
            return
        end
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end,
})

-- Infinite Jump Toggle (Blocked in Main Account Mode)
local InfiniteJumpToggle = PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        if isMainAccountMode() then
            Rayfield:Notify({
                Title = "Main Account Mode",
                Content = "This feature is disabled in Main Account Mode.",
                Duration = 6.5,
                Image = nil,
            })
            return
        end
        if Value then
            game:GetService("UserInputService").JumpRequest:Connect(function()
                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end)
        end
    end,
})

-- No Clip Toggle (Blocked in Main Account Mode)
local NoClipToggle = PlayerTab:CreateToggle({
    Name = "No Clip",
    CurrentValue = false,
    Flag = "NoClip",
    Callback = function(Value)
        if isMainAccountMode() then
            Rayfield:Notify({
                Title = "Main Account Mode",
                Content = "This feature is disabled in Main Account Mode.",
                Duration = 6.5,
                Image = nil,
            })
            return
        end
        if Value then
            local noclipLoop
            noclipLoop = game:GetService("RunService").Stepped:Connect(function()
                if NoClipToggle.CurrentValue then
                    for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = false
                        end
                    end
                else
                    noclipLoop:Disconnect()
                end
            end)
        end
    end,
})

-- Anti-AFK
local AntiAFKButton = PlayerTab:CreateButton({
    Name = "Anti-AFK",
    Callback = function()
        local VirtualUser = game:GetService("VirtualUser")
        game.Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end,
})

-- Teleport to Player Dropdown (Fixed)
local TeleportDropdown = PlayerTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = {},
    CurrentOption = "Select Player",
    Flag = "TeleportDropdown",
    Callback = function(Option)
        local targetPlayer = game.Players:FindFirstChild(Option)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            game.Players.LocalPlayer.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
        end
    end,
})

-- Update Teleport Dropdown
local function updateTeleportDropdown()
    TeleportDropdown.Options = {}
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer then
            table.insert(TeleportDropdown.Options, player.Name)
        end
    end
end

updateTeleportDropdown()
game.Players.PlayerAdded:Connect(updateTeleportDropdown)
game.Players.PlayerRemoving:Connect(updateTeleportDropdown)

-- Fly GUI (Mobile Support, Disabled in Main Account Mode)
local FlyButton = PlayerTab:CreateButton({
    Name = "Fly GUI",
    Callback = function()
        if isMainAccountMode() then
            Rayfield:Notify({
                Title = "Main Account Mode",
                Content = "This feature is disabled in Main Account Mode.",
                Duration = 6.5,
                Image = nil,
            })
            return
        end
        -- Fly Script
        local player = game.Players.LocalPlayer
        local flying = false
        local speed = 50 -- Default fly speed
        local torso = player.Character:FindFirstChild("HumanoidRootPart")
        local bg, bp

        -- Function to start flying
        local function startFlying()
            flying = true
            bg = Instance.new("BodyGyro", torso)
            bg.maxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.P = 10000
            bg.cframe = torso.CFrame

            bp = Instance.new("BodyPosition", torso)
            bp.maxForce = Vector3.new(math.huge, math.huge, math.huge)
            bp.position = torso.Position

            -- Fly movement
            local function fly()
                while flying and torso and bg and bp do
                    wait()
                    local direction = Vector3.new()
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                        direction = direction + workspace.CurrentCamera.CFrame.lookVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                        direction = direction - workspace.CurrentCamera.CFrame.lookVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                        direction = direction - workspace.CurrentCamera.CFrame.rightVector
                    end
                    if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                        direction = direction + workspace.CurrentCamera.CFrame.rightVector
                    end
                    bp.position = bp.position + direction * speed
                    bg.cframe = workspace.CurrentCamera.CFrame
                end
            end
            fly()
        end

        -- Function to stop flying
        local function stopFlying()
            flying = false
            if bg then bg:Destroy() end
            if bp then bp:Destroy() end
            player.Character.Humanoid.PlatformStand = false
        end

        -- Toggle fly on/off
        game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
            if input.KeyCode == Enum.KeyCode.X and not gameProcessed then
                if flying then
                    stopFlying()
                else
                    startFlying()
                end
            end
        end)

        -- Fly GUI
        local ScreenGui = Instance.new("ScreenGui")
        local Frame = Instance.new("Frame")
        local TextLabel = Instance.new("TextLabel")
        local TextLabel_2 = Instance.new("TextLabel")
        local TextButton = Instance.new("TextButton")

        ScreenGui.Parent = game.CoreGui
        Frame.Parent = ScreenGui
        Frame.BackgroundColor3 = Color3.fromRGB(24, 255, 51)
        Frame.BorderColor3 = Color3.fromRGB(255, 0, 4)
        Frame.BorderSizePixel = 15
        Frame.Position = UDim2.new(0.0575905927, 0, 0.653887033, 0)
        Frame.Size = UDim2.new(0, 295, 0, 152)
        Frame.Active = true
        Frame.Draggable = true

        TextLabel.Parent = Frame
        TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BackgroundTransparency = 1.000
        TextLabel.BorderColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.BorderSizePixel = 0
        TextLabel.Size = UDim2.new(0, 295, 0, 63)
        TextLabel.Font = Enum.Font.SciFi
        TextLabel.Text = "OP FLY SCRIPT"
        TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel.TextScaled = true
        TextLabel.TextSize = 14.000
        TextLabel.TextStrokeTransparency = 0.000
        TextLabel.TextWrapped = true

        TextLabel_2.Parent = Frame
        TextLabel_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel_2.BackgroundTransparency = 1.000
        TextLabel_2.BorderColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel_2.BorderSizePixel = 0
        TextLabel_2.Position = UDim2.new(0, 0, 0.342105269, 0)
        TextLabel_2.Size = UDim2.new(0, 295, 0, 18)
        TextLabel_2.Font = Enum.Font.SciFi
        TextLabel_2.Text = "(Press X to Fly)"
        TextLabel_2.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextLabel_2.TextScaled = true
        TextLabel_2.TextSize = 14.000
        TextLabel_2.TextStrokeTransparency = 0.000
        TextLabel_2.TextWrapped = true

        TextButton.Parent = Frame
        TextButton.BackgroundColor3 = Color3.fromRGB(8, 0, 255)
        TextButton.Position = UDim2.new(0.159322038, 0, 0.552631557, 0)
        TextButton.Size = UDim2.new(0, 200, 0, 50)
        TextButton.Font = Enum.Font.SciFi
        TextButton.Text = "Click Me To Fly"
        TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TextButton.TextScaled = true
        TextButton.TextSize = 14.000
        TextButton.TextStrokeTransparency = 0.000
        TextButton.TextWrapped = true

        -- Toggle fly on button click
        TextButton.MouseButton1Click:Connect(function()
            if flying then
                stopFlying()
            else
                startFlying()
            end
        end)
    end,
})

-- Fly Speed Slider
local FlySpeedSlider = PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        speed = Value -- Update fly speed
    end,
})

-- Random Stuff Tab
local RandomTab = Window:CreateTab("🎲 Random Stuff", nil)
local RandomSection = RandomTab:CreateSection("Fun Features")

-- Infinite Yield
local InfiniteYieldButton = RandomTab:CreateButton({
    Name = "Infinite Yield",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
    end,
})

-- Yarhm
local YarhmButton = RandomTab:CreateButton({
    Name = "Yarhm",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Joystickplays/psychic-octo-invention/main/yarhm.lua", true))()
    end,
})

-- XhubMM2
local XhubMM2Button = RandomTab:CreateButton({
    Name = "XhubMM2",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Au0yX/Community/main/XhubMM2"))()
    end,
})

-- Invisibility
local InvisibilityButton = RandomTab:CreateButton({
    Name = "Invisibility",
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))()
    end,
})

-- Aimbot (Placeholder)
local AimbotToggle = MainTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        if Value then
            -- Add your aimbot logic here
        else
            -- Stop aimbot logic here
        end
    end,
})

-- Avatar Adjustment Tab (Blocked in Main Account Mode)
local AvatarTab = Window:CreateTab("👤 Avatar Adjustment", nil)
local AvatarSection = AvatarTab:CreateSection("FilteringEnabled-Compatible Avatar Features")

-- Disable Avatar Tab if Main Account Mode is enabled
if isMainAccountMode() then
    AvatarTab:SetEnabled(false)
    Rayfield:Notify({
        Title = "Main Account Mode",
        Content = "Avatar adjustments are disabled in Main Account Mode.",
        Duration = 6.5,
        Image = nil,
    })
end

-- Resize Character Slider (Blocked in Main Account Mode)
local ResizeSlider = AvatarTab:CreateSlider({
    Name = "Resize Character",
    Range = {0.5, 5},
    Increment = 0.1,
    Suffix = "Scale",
    CurrentValue = 1,
    Flag = "ResizeCharacter",
    Callback = function(Value)
        if isMainAccountMode() then
            Rayfield:Notify({
                Title = "Main Account Mode",
                Content = "This feature is disabled in Main Account Mode.",
                Duration = 6.5,
                Image = nil,
            })
            return
        end
        local character = game.Players.LocalPlayer.Character
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Size = part.Size * Value
            end
        end
    end,
})

-- Rainbow Character
local RainbowToggle = AvatarTab:CreateToggle({
    Name = "Rainbow Character",
    CurrentValue = false,
    Flag = "RainbowCharacter",
    Callback = function(Value)
        if Value then
            local function rainbowEffect()
                while RainbowToggle.CurrentValue do
                    for i = 0, 1, 0.01 do
                        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.Color = Color3.fromHSV(i, 1, 1)
                            end
                        end
                        wait(0.1)
                    end
                end
            end
            rainbowEffect()
        else
            -- Reset colors
            for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.Color = Color3.new(1, 1, 1)
                end
            end
        end
    end,
})

-- Invisible Head
local InvisibleHeadToggle = AvatarTab:CreateToggle({
    Name = "Invisible Head",
    CurrentValue = false,
    Flag = "InvisibleHead",
    Callback = function(Value)
        local head = game.Players.LocalPlayer.Character:FindFirstChild("Head")
        if head then
            head.Transparency = Value and 1 or 0
        end
    end,
})

-- Legless (Replaces Fake Korblox)
local LeglessButton = AvatarTab:CreateButton({
    Name = "Legless",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        local leftLeg = character:FindFirstChild("Left Leg")
        local rightLeg = character:FindFirstChild("Right Leg")
        if leftLeg then
            leftLeg.Size = Vector3.new(0.000000000000000000000000000000000000000001, 0.000000000000000000000000000000000000000001, 0.000000000000000000000000000000000000000001)
        end
        if rightLeg then
            rightLeg.Size = Vector3.new(0.000000000000000000000000000000000000000001, 0.000000000000000000000000000000000000000001, 0.000000000000000000000000000000000000000001)
        end
    end,
})

-- Fake Headless
local FakeHeadlessButton = AvatarTab:CreateButton({
    Name = "Fake Headless",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        local head = character:FindFirstChild("Head")
        if head then
            head.Size = Vector3.new(0.0000000000000000000001, 0.000000000000000000000000000000000001, 0.000000000000000000000000000000001) -- Super small head
        end
    end,
})

-- Giant Arms
local GiantArmsButton = AvatarTab:CreateButton({
    Name = "Giant Arms",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        local leftArm = character:FindFirstChild("Left Arm")
        local rightArm = character:FindFirstChild("Right Arm")
        if leftArm then leftArm.Size = leftArm.Size * 2 end
        if rightArm then rightArm.Size = rightArm.Size * 2 end
    end,
})

-- Tiny Legs
local TinyLegsButton = AvatarTab:CreateButton({
    Name = "Tiny Legs",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        local leftLeg = character:FindFirstChild("Left Leg")
        local rightLeg = character:FindFirstChild("Right Leg")
        if leftLeg then leftLeg.Size = leftLeg.Size / 2 end
        if rightLeg then rightLeg.Size = rightLeg.Size / 2 end
    end,
})

-- Spin Character
local SpinToggle = AvatarTab:CreateToggle({
    Name = "Spin Character",
    CurrentValue = false,
    Flag = "SpinCharacter",
    Callback = function(Value)
        if Value then
            local bodyGyro = Instance.new("BodyGyro", game.Players.LocalPlayer.Character.HumanoidRootPart)
            bodyGyro.maxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bodyGyro.P = 10000
            while SpinToggle.CurrentValue do
                bodyGyro.CFrame = bodyGyro.CFrame * CFrame.Angles(0, math.rad(10), 0)
                wait()
            end
            bodyGyro:Destroy()
        end
    end,
})

-- Invisible Body
local InvisibleBodyToggle = AvatarTab:CreateToggle({
    Name = "Invisible Body",
    CurrentValue = false,
    Flag = "InvisibleBody",
    Callback = function(Value)
        local character = game.Players.LocalPlayer.Character
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = Value and 1 or 0
            end
        end
    end,
})

-- Floating Head
local FloatingHeadButton = AvatarTab:CreateButton({
    Name = "Floating Head",
    Callback = function()
        local character = game.Players.LocalPlayer.Character
        local head = character:FindFirstChild("Head")
        if head then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part ~= head then
                    part.Transparency = 1
                end
            end
        end
    end,
})

-- Custom Color
local CustomColorButton = AvatarTab:CreateButton({
    Name = "Custom Color",
    Callback = function()
        local color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
        for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Color = color
            end
        end
    end,
})

-- Reset Avatar
local ResetAvatarButton = AvatarTab:CreateButton({
    Name = "Reset Avatar",
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end,
})

-- Main Account Mode Tab (Safe Features)
local MainAccountModeTab = Window:CreateTab("🔒 Main Account Mode", nil)
local MainAccountModeSection = MainAccountModeTab:CreateSection("Safe Features for Main Account Mode")

-- Anti-AFK
local AntiAFKButton = MainAccountModeTab:CreateButton({
    Name = "Anti-AFK",
    Callback = function()
        local VirtualUser = game:GetService("VirtualUser")
        game.Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end,
})

-- Server Hop Button
local ServerHopButton = MainAccountModeTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for i, v in pairs(Servers.data) do
            if v.playing ~= v.maxPlayers then
                TPS:TeleportToPlaceInstance(game.PlaceId, v.id)
            end
        end
    end,
})

-- ESP Button (Safe Version)
local ESPButton = MainAccountModeTab:CreateButton({
    Name = "ESP",
    Callback = function()
        local Players = game:GetService("Players")
        local function createHighlight(player)
            local character = player.Character
            if not character then return end
            local highlight = Instance.new("Highlight")
            highlight.Adornee = character
            highlight.FillColor = Color3.new(1, 0, 0)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = character
        end
        local function onCharacterAdded(character)
            local player = Players:GetPlayerFromCharacter(character)
            if player then
                createHighlight(player)
            end
        end
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(onCharacterAdded)
            if player.Character then
                createHighlight(player)
            end
        end)
        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                createHighlight(player)
            end
            player.CharacterAdded:Connect(onCharacterAdded)
        end
    end,
})

-- Notify User
Rayfield:Notify({
    Title = "Cevor MM2 V8",
    Content = "Script loaded successfully!",
    Duration = 6.5,
    Image = nil,
})
