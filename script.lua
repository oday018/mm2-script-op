local module = {}
module["gameId"] = 66654135 -- Restrict to Murder Mystery 2 only

-- تنظيف المتغيرات القديمة
local playerESP = false
local sheriffAimbot = false
local coinAutoCollect = false
local autoShooting = false
local shootOffset = 3.5
local gunESPActive = false

local phs = game:GetService("PathfindingService")
local rs = game:GetService("RunService")
local ts = game:GetService("TweenService")

local fu = require(_G.YARHM.FUNCTIONS)

-- وظيفة مساعدة للعثور على اللاعبين بأدوار محددة
local function findPlayerWithTool(toolName)
    for _, player in ipairs(game.Players:GetPlayers()) do
        -- البحث في الـ Backpack أولاً
        if player.Backpack:FindFirstChild(toolName) then
            return player
        end
        -- البحث في الـ Character
        if player.Character and player.Character:FindFirstChild(toolName) then
            return player
        end
    end
    return nil
end

local function findMurderer()
    return findPlayerWithTool("Knife")
end

local function findSheriff()
    return findPlayerWithTool("Gun")
end

-- نظام ESP للاعبين
local function updatePlayerESP()
    if not playerESP then return end
    
    -- تنظيف الـ ESPs القديمة
    for _, obj in ipairs(script.Parent:GetChildren()) do
        if obj.Name == "PlayerESP" or obj.Name:find("ESP_") then
            obj:Destroy()
        end
    end
    
    -- إضافة ESPs جديدة
    for _, player in ipairs(game.Players:GetPlayers()) do
        if player.Character then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESP_" .. player.Name
            highlight.Parent = script.Parent
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.Adornee = player.Character
            highlight.Enabled = playerESP
            
            -- تحديد اللون حسب الدور
            if player == findMurderer() then
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(200, 0, 0)
            elseif player == findSheriff() then
                highlight.FillColor = Color3.fromRGB(0, 150, 255)
                highlight.OutlineColor = Color3.fromRGB(0, 100, 200)
            else
                highlight.FillColor = Color3.fromRGB(0, 255, 0)
                highlight.OutlineColor = Color3.fromRGB(0, 200, 0)
            end
            
            -- تحديث عند تغيير الـ Character
            local connection
            connection = player.CharacterAdded:Connect(function(newChar)
                task.wait(1) -- انتظار تحميل الـ Character
                highlight.Adornee = newChar
            end)
            
            -- تنظيف عند الخروج
            player:GetPropertyChangedSignal("Parent"):Connect(function()
                if player.Parent == nil then
                    highlight:Destroy()
                    connection:Disconnect()
                end
            end)
        end
    end
end

-- ESP للسلاح المسقط
local function setupGunESP()
    if not script.Parent:FindFirstChild("GunESP") then
        local gunESP = Instance.new("Highlight")
        gunESP.Name = "GunESP"
        gunESP.Parent = script.Parent
        gunESP.FillColor = Color3.fromRGB(255, 255, 0)
        gunESP.OutlineColor = Color3.fromRGB(200, 200, 0)
        gunESP.FillTransparency = 0.3
        gunESP.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        gunESP.Enabled = false
        
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "GunBillboard"
        billboard.Parent = gunESP
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.AlwaysOnTop = true
        
        local textLabel = Instance.new("TextLabel")
        textLabel.Parent = billboard
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.Text = "⚔️ GUN DROPPED ⚔️"
        textLabel.TextColor3 = Color3.new(1, 1, 0)
        textLabel.TextScaled = true
        textLabel.BackgroundTransparency = 1
    end
    
    if workspace:FindFirstChild("GunDrop") then
        script.Parent.GunESP.Adornee = workspace.GunDrop
        script.Parent.GunESP.Enabled = true
        fu.notification("⚠️ Gun has been dropped! Yellow highlight visible.")
    end
end

-- جمع العملات تلقائياً
local coinCollectionLoop
local function startCoinCollection()
    if coinCollectionLoop then return end
    
    coinCollectionLoop = rs.Heartbeat:Connect(function()
        if not coinAutoCollect then
            coinCollectionLoop:Disconnect()
            coinCollectionLoop = nil
            return
        end
        
        local coinContainer = workspace:FindFirstChild("Normal")
        if not coinContainer then return end
        
        coinContainer = coinContainer:FindFirstChild("CoinContainer")
        if not coinContainer then return end
        
        local coin = coinContainer:FindFirstChild("Coin_Server")
        if not coin or not game.Players.LocalPlayer.Character then return end
        
        local humanoidRootPart = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        -- التحقق من الرؤية
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character}
        
        local direction = (coin.Position - humanoidRootPart.Position)
        local raycastResult = workspace:Raycast(humanoidRootPart.Position, direction, raycastParams)
        
        if not raycastResult or raycastResult.Instance:IsDescendantOf(coinContainer) then
            -- التحرك نحو العملة
            local moveDirection = (coin.Position - humanoidRootPart.Position).Unit
            game.Players.LocalPlayer.Character:MoveTo(humanoidRootPart.Position + moveDirection * 5)
        end
    end)
end

-- إطلاق النار التلقائي
local autoShootLoop
local function startAutoShooting()
    if autoShootLoop then return end
    
    autoShootLoop = rs.Heartbeat:Connect(function()
        if not autoShooting or findSheriff() ~= game.Players.LocalPlayer then
            if autoShootLoop then
                autoShootLoop:Disconnect()
                autoShootLoop = nil
            end
            return
        end
        
        local murderer = findMurderer()
        if not murderer or not murderer.Character then
            fu.notification("No murderer found.")
            return
        end
        
        local localChar = game.Players.LocalPlayer.Character
        if not localChar then return end
        
        local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
        local localHRP = localChar:FindFirstChild("HumanoidRootPart")
        if not murdererHRP or not localHRP then return end
        
        -- التحقق من الرؤية
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Exclude
        raycastParams.FilterDescendantsInstances = {localChar}
        
        local direction = (murdererHRP.Position - localHRP.Position)
        local raycastResult = workspace:Raycast(localHRP.Position, direction, raycastParams)
        
        if not raycastResult or raycastResult.Instance:IsDescendantOf(murderer.Character) then
            -- تجهيز السلاح
            local gun = localChar:FindFirstChild("Gun") 
            if not gun and game.Players.LocalPlayer.Backpack:FindFirstChild("Gun") then
                localChar.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack.Gun)
                task.wait(0.2)
                gun = localChar:FindFirstChild("Gun")
            end
            
            if gun and gun:FindFirstChild("KnifeServer") then
                -- حساب موقع الإطلاق مع التعويض
                local moveDirection = murderer.Character.Humanoid.MoveDirection
                local targetPosition = murdererHRP.Position + (moveDirection * shootOffset)
                
                local args = {
                    [1] = 1,
                    [2] = targetPosition,
                    [3] = "AH"
                }
                
                gun.KnifeServer.ShootGun:InvokeServer(unpack(args))
                fu.notification("🔫 Auto-shot fired!")
            end
        end
    end)
end

-- الاستماع لتغيرات اللعبة
workspace.ChildAdded:Connect(function(child)
    if child.Name == "Normal" then
        if playerESP then
            fu.notification("Map loaded. Setting up ESPs...")
            task.wait(3) -- انتظار تحميل الأدوار
            updatePlayerESP()
        end
        
        if gunESPActive then
            setupGunESP()
        end
    elseif child.Name == "GunDrop" and gunESPActive then
        setupGunESP()
    end
end)

workspace.ChildRemoved:Connect(function(child)
    if child.Name == "Normal" and playerESP then
        fu.notification("Game ended. Cleaning up ESPs...")
        for _, obj in ipairs(script.Parent:GetChildren()) do
            if obj.Name == "PlayerESP" or obj.Name:find("ESP_") then
                obj:Destroy()
            end
        end
    elseif child.Name == "GunDrop" and script.Parent:FindFirstChild("GunESP") then
        script.Parent.GunESP.Enabled = false
        fu.notification("Gun has been picked up.")
    end
end)

-- تعريف واجهة المستخدم
module["Name"] = "Murder Mystery 2"

module[1] = {
    Type = "Text",
    Args = {"🎮 Murder Mystery 2 Script", "center"}
}

module[2] = {
    Type = "Text",
    Args = {"ESPs & Visuals"}
}

module[3] = {
    Type = "ButtonGrid",
    Toggleable = true,
    Args = {2, {
        Player_ESP = function()
            playerESP = not playerESP
            if playerESP then
                updatePlayerESP()
                fu.notification("Player ESP enabled")
            else
                for _, obj in ipairs(script.Parent:GetChildren()) do
                    if obj.Name == "PlayerESP" or obj.Name:find("ESP_") then
                        obj:Destroy()
                    end
                end
                fu.notification("Player ESP disabled")
            end
        end,
        
        Dropped_Gun_ESP = function()
            gunESPActive = not gunESPActive
            if gunESPActive then
                setupGunESP()
                fu.notification("Gun ESP enabled")
            elseif script.Parent:FindFirstChild("GunESP") then
                script.Parent.GunESP:Destroy()
                fu.notification("Gun ESP disabled")
            end
        end
    }}
}

module[4] = {
    Type = "Text",
    Args = {"Sheriff Tools"}
}

module[5] = {
    Type = "Button",
    Args = {"🔫 Shoot Murderer", function()
        if findSheriff() ~= game.Players.LocalPlayer then
            fu.notification("You're not the sheriff!")
            return
        end
        
        local murderer = findMurderer()
        if not murderer then
            fu.notification("No murderer found!")
            return
        end
        
        -- تجهيز السلاح
        local char = game.Players.LocalPlayer.Character
        local gun = char:FindFirstChild("Gun")
        if not gun and game.Players.LocalPlayer.Backpack:FindFirstChild("Gun") then
            char.Humanoid:EquipTool(game.Players.LocalPlayer.Backpack.Gun)
            task.wait(0.3)
            gun = char:FindFirstChild("Gun")
        end
        
        if gun and gun:FindFirstChild("KnifeServer") then
            local targetPos = murderer.Character.HumanoidRootPart.Position + 
                            (murderer.Character.Humanoid.MoveDirection * shootOffset)
            
            gun.KnifeServer.ShootGun:InvokeServer(1, targetPos, "AH")
            fu.notification("Shot fired at murderer!")
        else
            fu.notification("No gun found!")
        end
    end}
}

module[6] = {
    Type = "Input",
    Args = {"Shoot Offset", "Set", function(self, text)
        local num = tonumber(text)
        if num then
            shootOffset = math.clamp(num, 0, 10)
            fu.notification("Shoot offset set to: " .. shootOffset)
        else
            fu.notification("Invalid number!")
        end
    end}
}

module[7] = {
    Type = "Text",
    Args = {"Offset adjusts for target movement. Recommended: 3-4"}
}

module[8] = {
    Type = "ButtonGrid",
    Toggleable = true,
    Args = {2, {
        Auto_Collect_Coins = function()
            coinAutoCollect = not coinAutoCollect
            if coinAutoCollect then
                startCoinCollection()
                fu.notification("Coin magnet enabled")
            else
                fu.notification("Coin magnet disabled")
            end
        end,
        
        Auto_Shoot = function()
            autoShooting = not autoShooting
            if autoShooting then
                if findSheriff() == game.Players.LocalPlayer then
                    startAutoShooting()
                    fu.notification("Auto-shooting enabled")
                else
                    autoShooting = false
                    fu.notification("You're not the sheriff!")
                end
            else
                fu.notification("Auto-shooting disabled")
            end
        end
    }}
}

module[9] = {
    Type = "Text",
    Args = {"⚠️ Risky Features ⚠️", "center"}
}

module[10] = {
    Type = "Text",
    Args = {"These features may be detectable"}
}

module[11] = {
    Type = "Button",
    Args = {"⚡ Teleport to Gun", function()
        local gunDrop = workspace:FindFirstChild("GunDrop")
        if not gunDrop then
            fu.notification("No dropped gun found!")
            return
        end
        
        local char = game.Players.LocalPlayer.Character
        if not char then return end
        
        local humanoidRootPart = char:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then return end
        
        fu.notification("Calculating path to gun...")
        
        local path = phs:CreatePath({
            AgentRadius = 2,
            AgentHeight = 5,
            AgentCanJump = true,
            WaypointSpacing = 4
        })
        
        local success, message = pcall(function()
            path:ComputeAsync(humanoidRootPart.Position, gunDrop.Position)
        end)
        
        if success and path.Status == Enum.PathStatus.Success then
            local waypoints = path:GetWaypoints()
            fu.notification("Path found. Teleporting...")
            
            for _, waypoint in ipairs(waypoints) do
                humanoidRootPart.CFrame = CFrame.new(waypoint.Position + Vector3.new(0, 3, 0))
                task.wait(0.1)
            end
        else
            fu.notification("Failed to find path. Attempting direct teleport...")
            humanoidRootPart.CFrame = CFrame.new(gunDrop.Position + Vector3.new(0, 5, 0))
        end
    end}
}

-- تنظيف عند إعادة التحميل
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    if playerESP then
        task.wait(2)
        updatePlayerESP()
    end
end)

-- إضافة المكتبة
_G.Modules[#_G.Modules + 1] = module

return module
