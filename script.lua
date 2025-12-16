local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "AcronHub",
   LoadingTitle = "AcronHub",
   LoadingSubtitle = "by Acron",
   ConfigurationSaving = {
      Enabled = false,
   }
})

-- MM2 Tab
local TabMM2 = Window:CreateTab("MM2", 0)
TabMM2:CreateSection("Farm")

local coinFarmConn = nil
local coinFarmEnabled = false
local lastCoinPos = nil
local lastTeleportTime = 0
local function findClosestCoin()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local rootPart = char.HumanoidRootPart
    local playerPos = rootPart.Position
    local closestCoin = nil
    local closestDistance = math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if (name:find("coin") or name:find("money") or name:find("cash") or 
            name:find("gold") or name:find("gem") or name:find("dollar")) and
           obj:IsA("BasePart") and obj.Parent and obj.Parent.Name ~= "Character" then
            local distance = (obj.Position - playerPos).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestCoin = obj
            end
        end
    end
    return closestCoin
end
local function startCoinFarm()
    if coinFarmConn then coinFarmConn:Disconnect() coinFarmConn = nil end
    coinFarmConn = game:GetService("RunService").Heartbeat:Connect(function()
        if not coinFarmEnabled then return end
        local player = game.Players.LocalPlayer
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local rootPart = char.HumanoidRootPart
        local closestCoin, closestDistance = nil, math.huge
        for _, obj in ipairs(workspace:GetDescendants()) do
            local name = obj.Name:lower()
            if (name:find("coin") or name:find("money") or name:find("cash") or 
                name:find("gold") or name:find("gem") or name:find("dollar")) and
                obj:IsA("BasePart") and obj.Parent and obj.Parent.Name ~= "Character" then
                local distance = (obj.Position - rootPart.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestCoin = obj
                end
            end
        end
        if closestCoin then
            rootPart.CFrame = CFrame.new(closestCoin.Position + Vector3.new(0, 1, 0))
        end
    end)
end
TabMM2:CreateToggle({
    Name = "Автофарм монет",
    CurrentValue = false,
    Callback = function(state)
        coinFarmEnabled = state
        if state then
            startCoinFarm()
        else
            if coinFarmConn then
                coinFarmConn:Disconnect()
                coinFarmConn = nil
            end
        end
    end
})

TabMM2:CreateSection("ESP")
local espConn = nil
local espObjects = {}
local gunESP = nil
local function clearESP()
    for _, obj in pairs(espObjects) do
        if obj and obj.Parent then obj:Destroy() end
    end
    espObjects = {}
    if gunESP and gunESP.Parent then gunESP:Destroy() gunESP = nil end
end
local function getRole(plr)
    local function hasTool(name)
        for _, tool in ipairs((plr.Backpack and plr.Backpack:GetChildren()) or {}) do
            if tool.Name:lower():find(name) then return true end
        end
        for _, tool in ipairs((plr.Character and plr.Character:GetChildren()) or {}) do
            if tool:IsA("Tool") and tool.Name:lower():find(name) then return true end
        end
        return false
    end
    if hasTool("knife") then return "murder" end
    if hasTool("gun") or hasTool("revolver") then return "sheriff" end
    return "innocent"
end
local function getColorByRole(role)
    if role == "murder" then return Color3.fromRGB(255,0,0) end
    if role == "sheriff" then return Color3.fromRGB(0,150,255) end
    return Color3.fromRGB(0,255,0)
end
local function createESP(plr, color)
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = plr.Character.HumanoidRootPart
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = root
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = root.Size + Vector3.new(0.5,0.5,0.5)
    box.Color3 = color
    box.Transparency = 0.5
    box.Parent = root
    espObjects[plr] = box
end
local function isPlayerCharacter(model)
    return model and model:IsA("Model") and model:FindFirstChildOfClass("Humanoid")
end
local function updateESP()
    clearESP()
    local players = game.Players:GetPlayers()
    for _, plr in ipairs(players) do
        if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local root = plr.Character.HumanoidRootPart
            if not espObjects[plr] then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = root
                box.AlwaysOnTop = true
                box.ZIndex = 10
                box.Size = root.Size + Vector3.new(0.5,0.5,0.5)
                box.Color3 = getColorByRole(getRole(plr))
                box.Transparency = 0.5
                box.Parent = root
                espObjects[plr] = box
            end
        end
    end
    for _, obj in ipairs(workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if (name:find("gun") or name:find("revolver")) and obj:IsA("BasePart") then
            local parent = obj.Parent
            if not isPlayerCharacter(parent) then
                if not gunESP or gunESP.Adornee ~= obj then
                    if gunESP and gunESP.Parent then gunESP:Destroy() end
                    gunESP = Instance.new("BoxHandleAdornment")
                    gunESP.Adornee = obj
                    gunESP.AlwaysOnTop = true
                    gunESP.ZIndex = 10
                    gunESP.Size = obj.Size + Vector3.new(0.5,0.5,0.5)
                    gunESP.Color3 = Color3.fromRGB(255, 140, 0)
                    gunESP.Transparency = 0.3
                    gunESP.Parent = obj
                end
                break
            end
        end
    end
end
local function setESP(state)
    if espConn then espConn:Disconnect() espConn = nil end
    clearESP()
    if state then
        espConn = game:GetService("RunService").Heartbeat:Connect(function()
            updateESP()
        end)
    end
end
TabMM2:CreateToggle({
    Name = "ESP (MM2)",
    CurrentValue = false,
    Callback = setESP
})

TabMM2:CreateSection("Aimbot")
local aimConn = nil
local function getClosestTarget()
    local lp = game.Players.LocalPlayer
    local myChar = lp.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (myRoot.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = plr
            end
        end
    end
    return closest
end
local function hasGun()
    local lp = game.Players.LocalPlayer
    for _, tool in ipairs((lp.Backpack and lp.Backpack:GetChildren()) or {}) do
        if tool.Name:lower():find("gun") or tool.Name:lower():find("revolver") then return true end
    end
    for _, tool in ipairs((lp.Character and lp.Character:GetChildren()) or {}) do
        if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name:lower():find("revolver")) then return true end
    end
    return false
end
local function setAim(state)
    if aimConn then aimConn:Disconnect() aimConn = nil end
    if state then
        aimConn = game:GetService("RunService").RenderStepped:Connect(function()
            local target = getClosestTarget()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local cam = workspace.CurrentCamera
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position)
                -- Для отладки:
                print("Aimbot: навёлся на ", target.Name)
            else
                -- Для отладки:
                print("Aimbot: нет цели")
            end
        end)
    end
end
TabMM2:CreateToggle({
    Name = "Aimbot (MM2)",
    CurrentValue = false,
    Callback = setAim
})

TabMM2:CreateToggle({
    Name = "Auto Gun (MM2)",
    CurrentValue = false,
    Callback = function(state)
        if state then
            _G.autoGunMM2 = true
            spawn(function()
                while _G.autoGunMM2 do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        local name = obj.Name:lower()
                        if (name:find("gun") or name:find("revolver")) and obj:IsA("BasePart") then
                            local char = game.Players.LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0,2,0)
                                wait(0.2)
                            end
                        end
                    end
                    wait(1)
                end
            end)
        else
            _G.autoGunMM2 = false
        end
    end
})

-- Вкладка Движение
local TabMovement = Window:CreateTab("Движение", 0)
TabMovement:CreateSection("Movement")

local fastSpeed = 100
local defaultSpeed = 16
local jumpPower = 100
local defaultJump = 50
local speedConn = nil
local speedEnabled = false
local jumpConn = nil
local immortalConn = nil
local immortalEnabled = false

local lastCoinPos = nil
local lastTeleportTime = 0

-- Movement
local noclipConn = nil
local noclipEnabled = false

local espConn = nil
local espEnabled = false
local espObjects = {}

local gunESP = nil

local aimConn = nil
local aimEnabled = false

local currentAnimTrack = nil
local currentAnimObj = nil

local function setSpeed(state)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if state then
        speedEnabled = true
        if hum then hum.WalkSpeed = fastSpeed end
        if speedConn then speedConn:Disconnect() end
        speedConn = hum and hum.StateChanged:Connect(function()
            if speedEnabled and hum.WalkSpeed ~= fastSpeed then
                hum.WalkSpeed = fastSpeed
            end
        end)
    else
        speedEnabled = false
        if hum then hum.WalkSpeed = defaultSpeed end
        if speedConn then speedConn:Disconnect() speedConn = nil end
    end
end

TabMovement:CreateToggle({
   Name = "Скорость x6",
   CurrentValue = false,
   Callback = setSpeed
})

local function setJump(state)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if state then
        if hum then hum.JumpPower = jumpPower end
        if jumpConn then jumpConn:Disconnect() end
        jumpConn = hum and hum.StateChanged:Connect(function()
            if hum.JumpPower ~= jumpPower then
                hum.JumpPower = jumpPower
            end
        end)
    else
        if hum then hum.JumpPower = defaultJump end
        if jumpConn then jumpConn:Disconnect() jumpConn = nil end
    end
end

TabMovement:CreateToggle({
   Name = "Прыжок x2",
   CurrentValue = false,
   Callback = setJump
})

TabMovement:CreateButton({
   Name = "Стандартные значения",
   Callback = function()
      local player = game.Players.LocalPlayer
      local char = player.Character or player.CharacterAdded:Wait()
      local hum = char:FindFirstChildWhichIsA("Humanoid")
      if hum then
         hum.WalkSpeed = defaultSpeed
         hum.JumpPower = defaultJump
         hum.Health = 100
      end
      if speedConn then speedConn:Disconnect() speedConn = nil end
      if jumpConn then jumpConn:Disconnect() jumpConn = nil end
      if immortalConn then immortalConn:Disconnect() immortalConn = nil end
      speedEnabled = false
      immortalEnabled = false
   end
})

-- GodMode
local function setImmortal(state)
    local player = game.Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if state then
        immortalEnabled = true
        if hum then hum.Health = math.huge end
        if immortalConn then immortalConn:Disconnect() end
        immortalConn = hum and hum.HealthChanged:Connect(function()
            if immortalEnabled and hum.Health < math.huge then
                hum.Health = math.huge
            end
        end)
    else
        immortalEnabled = false
        if hum then hum.Health = 100 end
        if immortalConn then immortalConn:Disconnect() immortalConn = nil end
    end
end

TabMovement:CreateToggle({
   Name = "Бессмертие",
   CurrentValue = false,
   Callback = function(state)
      setImmortal(state)
   end
})

-- Teleport
local players = {}
for _, plr in ipairs(game.Players:GetPlayers()) do
    if plr ~= game.Players.LocalPlayer then
        table.insert(players, plr.Name)
    end
end

local selectedPlayer = players[1] or ""
local dropdown = TabMovement:CreateDropdown({
   Name = "Игроки на сервере",
   Options = players,
   CurrentOption = selectedPlayer,
   Callback = function(value)
      selectedPlayer = value
   end
})

TabMovement:CreateButton({
   Name = "Телепорт к игроку",
   Callback = function()
      local target = game.Players:FindFirstChild(selectedPlayer)
      local localChar = game.Players.LocalPlayer.Character
      local targetChar = target and target.Character
      if localChar and targetChar and targetChar:FindFirstChild("HumanoidRootPart") and localChar:FindFirstChild("HumanoidRootPart") then
         localChar.HumanoidRootPart.CFrame = targetChar.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
      end
   end
})

-- MM2: Автофарм монет
local coinFarmConn = nil
local coinFarmEnabled = false

local function findClosestCoin()
    local player = game.Players.LocalPlayer
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    
    local rootPart = char.HumanoidRootPart
    local playerPos = rootPart.Position
    
    local closestCoin = nil
    local closestDistance = math.huge
    
    for _, obj in ipairs(workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if (name:find("coin") or name:find("money") or name:find("cash") or 
            name:find("gold") or name:find("gem") or name:find("dollar")) and
           obj:IsA("BasePart") and obj.Parent and obj.Parent.Name ~= "Character" then
            
            local distance = (obj.Position - playerPos).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestCoin = obj
            end
        end
    end
    
    return closestCoin
end

local function startCoinFarm()
    if coinFarmConn then coinFarmConn:Disconnect() coinFarmConn = nil end
    coinFarmConn = game:GetService("RunService").Heartbeat:Connect(function()
        if not coinFarmEnabled then return end
        
        local player = game.Players.LocalPlayer
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local rootPart = char.HumanoidRootPart
        local closestCoin = findClosestCoin()
        
        if tick() - lastTeleportTime < 0.15 then return end
        
        if closestCoin and closestCoin.Parent then
            local coinPos = closestCoin.Position
            if not lastCoinPos or (coinPos - lastCoinPos).Magnitude > 2 then
                rootPart.CFrame = CFrame.new(coinPos + Vector3.new(0, 1, 0))
                lastCoinPos = coinPos
                lastTeleportTime = tick()
            end
        end
    end)
end

TabMovement:CreateToggle({
   Name = "Автофарм монет",
   CurrentValue = false,
   Callback = function(state)
      coinFarmEnabled = state
      if state then
         startCoinFarm()
      else
         if coinFarmConn then
            coinFarmConn:Disconnect()
            coinFarmConn = nil
         end
      end
   end
})

local function setNoclip(state)
    noclipEnabled = state
    if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    if state then
        noclipConn = game:GetService("RunService").Stepped:Connect(function()
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

TabMovement:CreateToggle({
   Name = "Noclip",
   CurrentValue = false,
   Callback = setNoclip
})

local function clearESP()
    for plr, obj in pairs(espObjects) do
        if obj and obj.Parent then
            obj:Destroy()
        end
    end
    espObjects = {}
end

local function getRole(plr)
    local function hasTool(name)
        for _, tool in ipairs((plr.Backpack and plr.Backpack:GetChildren()) or {}) do
            if tool.Name:lower():find(name) then return true end
        end
        for _, tool in ipairs((plr.Character and plr.Character:GetChildren()) or {}) do
            if tool:IsA("Tool") and tool.Name:lower():find(name) then return true end
        end
        return false
    end
    if hasTool("knife") then return "murder" end
    if hasTool("gun") or hasTool("revolver") then return "sheriff" end
    return "innocent"
end

local function getColorByRole(role)
    if role == "murder" then return Color3.fromRGB(255,0,0) end
    if role == "sheriff" then return Color3.fromRGB(0,150,255) end
    return Color3.fromRGB(0,255,0)
end

local function createESP(plr, color)
    if not plr.Character or not plr.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = plr.Character.HumanoidRootPart
    local box = Instance.new("BoxHandleAdornment")
    box.Adornee = root
    box.AlwaysOnTop = true
    box.ZIndex = 10
    box.Size = root.Size + Vector3.new(0.5,0.5,0.5)
    box.Color3 = color
    box.Transparency = 0.5
    box.Parent = root
    espObjects[plr] = box
end

local function updateESP()
    clearESP()
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local role = getRole(plr)
            local color = getColorByRole(role)
            createESP(plr, color)
        end
    end
    if gunESP and gunESP.Parent then gunESP:Destroy() gunESP = nil end
    for _, obj in ipairs(workspace:GetDescendants()) do
        local name = obj.Name:lower()
        if (name:find("gun") or name:find("revolver")) and obj:IsA("BasePart") then
            local parent = obj.Parent
            if not isPlayerCharacter(parent) then
                gunESP = Instance.new("BoxHandleAdornment")
                gunESP.Adornee = obj
                gunESP.AlwaysOnTop = true
                gunESP.ZIndex = 10
                gunESP.Size = obj.Size + Vector3.new(0.5,0.5,0.5)
                gunESP.Color3 = Color3.fromRGB(255, 140, 0)
                gunESP.Transparency = 0.3
                gunESP.Parent = obj
                break
            end
        end
    end
end

local function setESP(state)
    espEnabled = state
    if espConn then espConn:Disconnect() espConn = nil end
    clearESP()
    if state then
        espConn = game:GetService("RunService").Heartbeat:Connect(function()
            updateESP()
        end)
    end
end

TabMovement:CreateToggle({
   Name = "ESP (MM2)",
   CurrentValue = false,
   Callback = setESP
})

local function getClosestTarget()
    local lp = game.Players.LocalPlayer
    local myChar = lp.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    local closest, minDist = nil, math.huge
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (myRoot.Position - plr.Character.HumanoidRootPart.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = plr
            end
        end
    end
    return closest
end

local function hasGun()
    local lp = game.Players.LocalPlayer
    for _, tool in ipairs((lp.Backpack and lp.Backpack:GetChildren()) or {}) do
        if tool.Name:lower():find("gun") or tool.Name:lower():find("revolver") then return true end
    end
    for _, tool in ipairs((lp.Character and lp.Character:GetChildren()) or {}) do
        if tool:IsA("Tool") and (tool.Name:lower():find("gun") or tool.Name:lower():find("revolver")) then return true end
    end
    return false
end

local function setAim(state)
    aimEnabled = state
    if aimConn then aimConn:Disconnect() aimConn = nil end
    if state then
        aimConn = game:GetService("RunService").RenderStepped:Connect(function()
            local target = getClosestTarget()
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local cam = workspace.CurrentCamera
                cam.CFrame = CFrame.new(cam.CFrame.Position, target.Character.HumanoidRootPart.Position)
                -- Для отладки:
                print("Aimbot: навёлся на ", target.Name)
            else
                -- Для отладки:
                print("Aimbot: нет цели")
            end
        end)
    end
end

TabMovement:CreateToggle({
   Name = "Aimbot (MM2)",
   CurrentValue = false,
   Callback = setAim
})

TabMovement:CreateToggle({
   Name = "Auto Gun (MM2)",
   CurrentValue = false,
   Callback = function(state)
      setAutoGun(state)
   end
})

-- Fly
local flyConn = nil
local flyEnabled = false
local flySpeed = 100

local function setFly(state)
    flyEnabled = state
    if flyConn then flyConn:Disconnect() flyConn = nil end
    if state then
        flyConn = game:GetService("RunService").RenderStepped:Connect(function()
            local char = game.Players.LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local move = Vector3.new()
                local UIS = game:GetService("UserInputService")
                if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
                if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
                if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + workspace.CurrentCamera.CFrame.UpVector end
                if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move = move - workspace.CurrentCamera.CFrame.UpVector end
                if move.Magnitude > 0 then
                    hrp.Velocity = move.Unit * flySpeed
                else
                    hrp.Velocity = Vector3.new(0,0,0)
                end
            end
        end)
    else
        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.Velocity = Vector3.new(0,0,0) end
    end
end

TabMovement:CreateToggle({
   Name = "Fly",
   CurrentValue = false,
   Callback = setFly
})

TabMovement:CreateButton({
   Name = "Anti-Ragdoll",
   Callback = function()
      local char = game.Players.LocalPlayer.Character
      if char then
         for _, v in ipairs(char:GetDescendants()) do
            if v:IsA("BallSocketConstraint") or v:IsA("HingeConstraint") then
               v:Destroy()
            end
         end
      end
   end
})

TabMovement:CreateButton({
   Name = "Fullbright",
   Callback = function()
      if game.Lighting then
         game.Lighting.Brightness = 5
         game.Lighting.ClockTime = 12
         game.Lighting.FogEnd = 1e10
         game.Lighting.GlobalShadows = false
         game.Lighting.OutdoorAmbient = Color3.new(1,1,1)
      end
   end
})

TabMovement:CreateButton({
   Name = "Remove Fog",
   Callback = function()
      if game.Lighting then
         game.Lighting.FogEnd = 1e10
      end
   end
})

-- Blox Fruits: Авто-сбор фруктов (пример)
TabMovement:CreateButton({
   Name = "Авто-сбор фруктов",
   Callback = function()
      local char = game.Players.LocalPlayer.Character
      if not char or not char:FindFirstChild("HumanoidRootPart") then return end
      local closestFruit = nil
      local minDist = math.huge
      for _, obj in ipairs(workspace:GetDescendants()) do
         if obj.Name:lower():find("fruit") and obj:IsA("BasePart") then
            local dist = (char.HumanoidRootPart.Position - obj.Position).Magnitude
            if dist < minDist then
               minDist = dist
               closestFruit = obj
            end
         end
      end
      if closestFruit then
         char.HumanoidRootPart.CFrame = CFrame.new(closestFruit.Position + Vector3.new(0,2,0))
      end
   end
})

-- Jailbreak Tab
local TabJB = Window:CreateTab("Jailbreak", 0)
TabJB:CreateSection("Robbery")

TabJB:CreateButton({
    Name = "Авто-ограбление банка",
    Callback = function()
        local bank = workspace:FindFirstChild("Bank")
        local char = game.Players.LocalPlayer.Character
        if bank and char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = bank.CFrame + Vector3.new(0,5,0)
            -- Здесь можно добавить взаимодействие с дверями и т.д.
        end
    end
})

-- Steal a Brainrot Tab
local TabBrainrot = Window:CreateTab("Steal a Brainrot", 0)
TabBrainrot:CreateSection("Brainrot")

local stealBrainrotConn = nil
local function findClosestBrainrot()
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local root = char.HumanoidRootPart
    local closest, minDist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("brainrot") and obj:IsA("BasePart") then
            local dist = (root.Position - obj.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = obj
            end
        end
    end
    return closest
end
local function setStealBrainrot(state)
    if stealBrainrotConn then stealBrainrotConn:Disconnect() stealBrainrotConn = nil end
    if state then
        stealBrainrotConn = game:GetService("RunService").RenderStepped:Connect(function()
            local char = game.Players.LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local brainrot = findClosestBrainrot()
            if brainrot and brainrot.Parent then
                root.CFrame = CFrame.new(brainrot.Position + Vector3.new(0,2,0))
            end
        end)
    end
end
TabBrainrot:CreateToggle({
    Name = "Автокража Brainrot",
    CurrentValue = false,
    Callback = setStealBrainrot
})

TabBrainrot:CreateSection("Base")
local bringBaseConn = nil
local function findBase()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("base") and obj:IsA("BasePart") then
            return obj
        end
    end
    return nil
end
local function hasBrainrotTool()
    local char = game.Players.LocalPlayer.Character
    for _, tool in ipairs(char and char:GetChildren() or {}) do
        if tool:IsA("Tool") and tool.Name:lower():find("brainrot") then
            return tool
        end
    end
    return nil
end
local function setBringBase(state)
    if bringBaseConn then bringBaseConn:Disconnect() bringBaseConn = nil end
    if state then
        bringBaseConn = game:GetService("RunService").RenderStepped:Connect(function()
            local char = game.Players.LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local tool = hasBrainrotTool()
            local base = findBase()
            if root and tool and base then
                root.CFrame = CFrame.new(base.Position + Vector3.new(0,2,0))
            end
        end)
    end
end
TabBrainrot:CreateToggle({
    Name = "Автоприношение на базу",
    CurrentValue = false,
    Callback = setBringBase
})

TabBrainrot:CreateButton({
    Name = "Закрыть базу",
    Callback = function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("door") and obj:IsA("BasePart") then
                obj.CanCollide = true
                obj.Transparency = 0
            end
        end
    end
})

TabBrainrot:CreateSection("Coins")
local coinBrainrotConn = nil
local function findClosestCoinBrainrot()
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local root = char.HumanoidRootPart
    local closest, minDist = nil, math.huge
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj.Name:lower():find("coin") and obj:IsA("BasePart") then
            local dist = (root.Position - obj.Position).Magnitude
            if dist < minDist then
                minDist = dist
                closest = obj
            end
        end
    end
    return closest
end
local function setCoinBrainrot(state)
    if coinBrainrotConn then coinBrainrotConn:Disconnect() coinBrainrotConn = nil end
    if state then
        coinBrainrotConn = game:GetService("RunService").RenderStepped:Connect(function()
            local char = game.Players.LocalPlayer.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if not root then return end
            local coin = findClosestCoinBrainrot()
            if coin and coin.Parent then
                root.CFrame = CFrame.new(coin.Position + Vector3.new(0,2,0))
            end
        end)
    end
end
TabBrainrot:CreateToggle({
    Name = "Автосбор монет",
    CurrentValue = false,
    Callback = setCoinBrainrot
})

-- Pet Simulator X Tab
local TabPSX = Window:CreateTab("Pet Simulator X", 0)
TabPSX:CreateSection("Фарм")

TabPSX:CreateToggle({
    Name = "Авто-фарм монет",
    CurrentValue = false,
    Callback = function(state)
        if state then
            _G.psxFarm = true
            spawn(function()
                while _G.psxFarm do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("coin") and obj:IsA("BasePart") then
                            local char = game.Players.LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0,2,0)
                                wait(0.2)
                            end
                        end
                    end
                    wait(1)
                end
            end)
        else
            _G.psxFarm = false
        end
    end
})

TabPSX:CreateSection("Яйца")
TabPSX:CreateButton({
    Name = "Авто-открытие яиц",
    Callback = function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("egg") and obj:IsA("BasePart") then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0,2,0)
                    wait(0.2)
                end
            end
        end
    end
})

TabPSX:CreateSection("Телепорт")
TabPSX:CreateButton({
    Name = "Телепорт в город",
    Callback = function()
        local zone = workspace:FindFirstChild("Spawn") or workspace:FindFirstChild("City")
        local char = game.Players.LocalPlayer.Character
        if zone and char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = zone.CFrame + Vector3.new(0,5,0)
        end
    end
})

-- Doors Tab
local TabDoors = Window:CreateTab("Doors", 0)
TabDoors:CreateSection("ESP")
TabDoors:CreateToggle({
    Name = "ESP предметов",
    CurrentValue = false,
    Callback = function(state)
        if state then
            _G.doorsESP = true
            spawn(function()
                while _G.doorsESP do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("key") or obj.Name:lower():find("lever") then
                            if not obj:FindFirstChild("SelectionBox") then
                                local sb = Instance.new("SelectionBox", obj)
                                sb.Adornee = obj
                                sb.Color3 = Color3.fromRGB(255,255,0)
                            end
                        end
                    end
                    wait(1)
                end
            end)
        else
            _G.doorsESP = false
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:FindFirstChild("SelectionBox") then
                    obj.SelectionBox:Destroy()
                end
            end
        end
    end
})

TabDoors:CreateSection("Телепорт")
TabDoors:CreateButton({
    Name = "Телепорт к выходу",
    Callback = function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("exit") and obj:IsA("BasePart") then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0,2,0)
                    break
                end
            end
        end
    end
})

-- Brookhaven Tab
local TabBrook = Window:CreateTab("Brookhaven", 0)
TabBrook:CreateSection("Телепорт")
TabBrook:CreateButton({
    Name = "Телепорт к горе",
    Callback = function()
        local pos = Vector3.new(1000, 300, 1000)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
    end
})

TabBrook:CreateSection("Троллинг")
TabBrook:CreateToggle({
    Name = "Следовать за игроком",
    CurrentValue = false,
    Callback = function(state)
        if state then
            _G.brookTroll = true
            spawn(function()
                while _G.brookTroll do
                    local players = game.Players:GetPlayers()
                    local me = game.Players.LocalPlayer
                    local victim = players[math.random(1,#players)]
                    if victim ~= me and victim.Character and victim.Character:FindFirstChild("HumanoidRootPart") then
                        local char = me.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CFrame = victim.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
                        end
                    end
                    wait(2)
                end
            end)
        else
            _G.brookTroll = false
        end
    end
})

-- Adopt Me Tab
local TabAdopt = Window:CreateTab("Adopt Me", 0)
TabAdopt:CreateSection("Фарм")
TabAdopt:CreateToggle({
    Name = "Авто-фарм денег",
    CurrentValue = false,
    Callback = function(state)
        if state then
            _G.adoptFarm = true
            spawn(function()
                while _G.adoptFarm do
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("money") and obj:IsA("BasePart") then
                            local char = game.Players.LocalPlayer.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0,2,0)
                                wait(0.2)
                            end
                        end
                    end
                    wait(1)
                end
            end)
        else
            _G.adoptFarm = false
        end
    end
})

TabAdopt:CreateSection("Подарки")
TabAdopt:CreateButton({
    Name = "Собрать подарки",
    Callback = function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("gift") and obj:IsA("BasePart") then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0,2,0)
                    wait(0.2)
                end
            end
        end
    end
})

-- BedWars Tab
local TabBW = Window:CreateTab("BedWars", 0)
TabBW:CreateSection("ESP")
TabBW:CreateToggle({
    Name = "ESP врагов",
    CurrentValue = false,
    Callback = function(state)
        if state then
            _G.bwESP = true
            spawn(function()
                while _G.bwESP do
                    for _, plr in ipairs(game.Players:GetPlayers()) do
                        if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            if not plr.Character.HumanoidRootPart:FindFirstChild("BWESP") then
                                local box = Instance.new("BoxHandleAdornment")
                                box.Name = "BWESP"
                                box.Adornee = plr.Character.HumanoidRootPart
                                box.AlwaysOnTop = true
                                box.ZIndex = 10
                                box.Size = plr.Character.HumanoidRootPart.Size + Vector3.new(0.5,0.5,0.5)
                                box.Color3 = Color3.fromRGB(255,0,0)
                                box.Transparency = 0.5
                                box.Parent = plr.Character.HumanoidRootPart
                            end
                        end
                    end
                    wait(1)
                end
            end)
        else
            _G.bwESP = false
            for _, plr in ipairs(game.Players:GetPlayers()) do
                if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local box = plr.Character.HumanoidRootPart:FindFirstChild("BWESP")
                    if box then box:Destroy() end
                end
            end
        end
    end
})

TabBW:CreateSection("Быстрые действия")
TabBW:CreateButton({
    Name = "Быстрый билд к кровати",
    Callback = function()
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj.Name:lower():find("bed") and obj:IsA("BasePart") then
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = obj.CFrame + Vector3.new(0,2,0)
                    break
                end
            end
        end
    end
})

-- AUT Tab
local TabAUT = Window:CreateTab("AUT", 0)
TabAUT:CreateSection("Фарм")
TabAUT:CreateToggle({
    Name = "Авто-фарм стрел",
    CurrentValue = false,
    Callback = function(state)
        if state then
            _G.autArrowFarm = true
            spawn(function()
                while _G.autArrowFarm do
                    local minDist = math.huge
                    local closest = nil
                    local char = game.Players.LocalPlayer.Character
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("arrow") and obj:IsA("BasePart") then
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                local dist = (char.HumanoidRootPart.Position - obj.Position).Magnitude
                                if dist < minDist then
                                    minDist = dist
                                    closest = obj
                                end
                            end
                        end
                    end
                    if closest and char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = closest.CFrame + Vector3.new(0,2,0)
                    end
                    wait(1)
                end
            end)
        else
            _G.autArrowFarm = false
        end
    end
})
TabAUT:CreateToggle({
    Name = "Авто-фарм масок",
    CurrentValue = false,
    Callback = function(state)
        if state then
            _G.autMaskFarm = true
            spawn(function()
                while _G.autMaskFarm do
                    local minDist = math.huge
                    local closest = nil
                    local char = game.Players.LocalPlayer.Character
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj.Name:lower():find("mask") and obj:IsA("BasePart") then
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                local dist = (char.HumanoidRootPart.Position - obj.Position).Magnitude
                                if dist < minDist then
                                    minDist = dist
                                    closest = obj
                                end
                            end
                        end
                    end
                    if closest and char and char:FindFirstChild("HumanoidRootPart") then
                        char.HumanoidRootPart.CFrame = closest.CFrame + Vector3.new(0,2,0)
                    end
                    wait(1)
                end
            end)
        else
            _G.autMaskFarm = false
        end
    end
})

TabAUT:CreateSection("Другое")
TabAUT:CreateButton({
    Name = "Авто-использование предметов",
    Callback = function()
        local bp = game.Players.LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, v in ipairs(bp:GetChildren()) do
                if v:IsA("Tool") then v.Parent = game.Players.LocalPlayer.Character end
            end
        end
    end
})
TabAUT:CreateButton({
    Name = "Телепорт к рандомному игроку",
    Callback = function()
        local players = game.Players:GetPlayers()
        local me = game.Players.LocalPlayer
        local others = {}
        for _, p in ipairs(players) do if p ~= me then table.insert(others, p) end end
        if #others > 0 then
            local victim = others[math.random(1,#others)]
            if victim.Character and victim.Character:FindFirstChild("HumanoidRootPart") then
                local char = me.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.CFrame = victim.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
                end
            end
        end
    end
})
TabAUT:CreateButton({
    Name = "Анти-заморозка (AUT)",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BoolValue") and v.Name:lower():find("freeze") then v:Destroy() end
            end
        end
    end
})
TabAUT:CreateButton({
    Name = "Авто-использование стрелы",
    Callback = function()
        local bp = game.Players.LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, v in ipairs(bp:GetChildren()) do
                if v.Name:lower():find("arrow") and v:IsA("Tool") then v.Parent = game.Players.LocalPlayer.Character end
            end
        end
    end
})

-- Universal Tab
local TabHZ = Window:CreateTab("Universal", 0)
TabHZ:CreateSection("Быстрые действия")
TabHZ:CreateButton({
    Name = "Быстрый респаун",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character then
            player.Character:BreakJoints()
        end
    end
})
TabHZ:CreateButton({
    Name = "Анти-замедление",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BoolValue") and v.Name:lower():find("slow") then v:Destroy() end
                if v:IsA("NumberValue") and v.Name:lower():find("slow") then v:Destroy() end
            end
            local hum = char:FindFirstChildWhichIsA("Humanoid")
            if hum then hum.WalkSpeed = 16 end
        end
    end
})
TabHZ:CreateButton({
    Name = "Анти-ловушки",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BoolValue") and v.Name:lower():find("trap") then v:Destroy() end
                if v:IsA("BoolValue") and v.Name:lower():find("stun") then v:Destroy() end
            end
        end
    end
})
TabHZ:CreateButton({
    Name = "Удалить эффекты",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                    v:Destroy()
                end
            end
        end
    end
})
TabHZ:CreateButton({
    Name = "Быстрый выход",
    Callback = function()
        game:Shutdown()
    end
})
TabHZ:CreateButton({
    Name = "Очистить инвентарь",
    Callback = function()
        local bp = game.Players.LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, v in ipairs(bp:GetChildren()) do
                v:Destroy()
            end
        end
    end
})
TabHZ:CreateButton({
    Name = "Восстановить здоровье",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        local hum = char and char:FindFirstChildWhichIsA("Humanoid")
        if hum then hum.Health = hum.MaxHealth end
    end
})
TabHZ:CreateButton({
    Name = "Телепорт на рандомную позицию",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(math.random(-500,500), 50, math.random(-500,500))
        end
    end
})
TabHZ:CreateButton({
    Name = "Анти-слепота",
    Callback = function()
        for _, v in ipairs(game.Lighting:GetChildren()) do
            if v:IsA("BlurEffect") then v:Destroy() end
            if v.Name:lower():find("blackout") then v:Destroy() end
        end
    end
})
TabHZ:CreateButton({
    Name = "Анти-невидимость",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v:IsA("BasePart") and v.Transparency > 0 then v.Transparency = 0 end
            end
        end
    end
})
TabHZ:CreateButton({
    Name = "Восстановить энергию",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        for _, v in ipairs(char:GetDescendants()) do
            if v.Name:lower():find("stamina") or v.Name:lower():find("energy") then
                if v:IsA("NumberValue") then v.Value = 100 end
            end
        end
    end
})
TabHZ:CreateButton({
    Name = "Удалить дебаффы",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char then
            for _, v in ipairs(char:GetDescendants()) do
                if v.Name:lower():find("debuff") or v.Name:lower():find("curse") then v:Destroy() end
            end
        end
    end
})
TabHZ:CreateInput({
    Name = "Телепорт к игроку",
    PlaceholderText = "Введи ник для телепорта",
    RemoveTextAfterFocusLost = false,
    Callback = function(nick)
        local plr = game.Players:FindFirstChild(nick)
        local char = game.Players.LocalPlayer.Character
        if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame + Vector3.new(2,0,0)
        end
    end
})
TabHZ:CreateButton({
    Name = "Очистить чат",
    Callback = function()
        for _, v in ipairs(game.CoreGui:GetDescendants()) do
            if v:IsA("TextLabel") and v.Text and #v.Text > 0 then
                v.Text = ""
            end
        end
    end
})
TabHZ:CreateButton({
    Name = "Анти-камера shake",
    Callback = function()
        workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
    end
})
TabHZ:CreateButton({
    Name = "Анти-камера zoom",
    Callback = function()
        workspace.CurrentCamera.FieldOfView = 70
    end
})
TabHZ:CreateButton({
    Name = "Быстрый ребёрн",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player:FindFirstChild("leaderstats") then
            for _, v in ipairs(player.leaderstats:GetChildren()) do
                if v.Name:lower():find("rebirth") or v.Name:lower():find("ребёрн") then
                    v.Value = v.Value + 1
                end
            end
        end
    end
})
TabHZ:CreateButton({
    Name = "Восстановить броню",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        for _, v in ipairs(char:GetDescendants()) do
            if v.Name:lower():find("armor") or v.Name:lower():find("броня") then
                if v:IsA("NumberValue") then v.Value = 100 end
            end
        end
    end
})
TabHZ:CreateButton({
    Name = "Удалить питомцев",
    Callback = function()
        local bp = game.Players.LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, v in ipairs(bp:GetChildren()) do
                if v.Name:lower():find("pet") or v.Name:lower():find("питомец") then v:Destroy() end
            end
        end
    end
})
TabHZ:CreateButton({
    Name = "Анти-отдача",
    Callback = function()
        if workspace.CurrentCamera:FindFirstChild("Recoil") then
            workspace.CurrentCamera.Recoil:Destroy()
        end
    end
})
TabHZ:CreateButton({
    Name = "Анти-камера blur",
    Callback = function()
        for _, v in ipairs(game.Lighting:GetChildren()) do
            if v:IsA("BlurEffect") then v:Destroy() end
        end
    end
})
TabHZ:CreateButton({
    Name = "Анти-камера blackout",
    Callback = function()
        for _, v in ipairs(game.Lighting:GetChildren()) do
            if v.Name:lower():find("blackout") then v:Destroy() end
        end
    end
})
TabHZ:CreateButton({
    Name = "Анти-камера spin",
    Callback = function()
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position)
    end
})
TabHZ:CreateButton({
    Name = "Анти-камера invert",
    Callback = function()
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position)
    end
})
TabHZ:CreateButton({
    Name = "Анти-камера upside-down",
    Callback = function()
        workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position)
    end
})
