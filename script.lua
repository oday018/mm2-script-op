if game.PlaceId == 142823291 then
    local Players = game:GetService('Players')
    local CoreGUI = game:GetService('CoreGui')
    local TweenService = game:GetService('TweenService')
    local UserInputService = game:GetService("UserInputService")
    local TextService = game:GetService("TextService")
    local RunService = game:GetService("RunService")
    local Workspace = game:GetService("Workspace")

    local Player = Players.LocalPlayer
    getgenv().coinFarm = false
    
    -- 🔧 المتغيرات الأساسية
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    Player.CharacterAdded:Connect(function(newChar)
        Character = newChar
        Humanoid = Character:WaitForChild("Humanoid")
        HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    end)

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "1QLUA_HUB"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGUI

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 260, 0, 340) -- ⬆️ زدنا الارتفاع
    MainFrame.Position = UDim2.new(0.5, -130, 0.5, -170)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 50, 25)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local FrameCorner = Instance.new("UICorner", MainFrame)
    FrameCorner.CornerRadius = UDim.new(0, 12)

    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 25)
    Header.BackgroundColor3 = Color3.fromRGB(20, 70, 35)
    Header.Parent = MainFrame
    local HeaderCorner = Instance.new("UICorner", Header)
    HeaderCorner.CornerRadius = UDim.new(0, 12)

    local Title = Instance.new("TextLabel")
    Title.Text = "1QLUA HUB • MM2"
    Title.Size = UDim2.new(1, -25, 1, 0)
    Title.Position = UDim2.new(0, 5, 0, 0)
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamSemibold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    local Close = Instance.new("TextButton")
    Close.Size = UDim2.new(0, 25, 0, 25)
    Close.Position = UDim2.new(1, -25, 0, 0)
    Close.Text = "_"
    Close.TextColor3 = Color3.fromRGB(200, 200, 200)
    Close.BackgroundTransparency = 1
    Close.Font = Enum.Font.GothamBold
    Close.TextSize = 16
    Close.Parent = Header

    local MinimizedButton = Instance.new("TextButton")
    MinimizedButton.Size = UDim2.new(0, 35, 0, 35)
    MinimizedButton.Position = UDim2.new(0, 10, 0, 10)
    MinimizedButton.Text = "1Q"
    MinimizedButton.Visible = false
    MinimizedButton.BackgroundColor3 = Color3.fromRGB(15, 50, 25)
    MinimizedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizedButton.Font = Enum.Font.GothamBold
    MinimizedButton.TextSize = 14
    MinimizedButton.Parent = ScreenGui
    Instance.new("UICorner", MinimizedButton).CornerRadius = UDim.new(1, 0)

    Close.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        MinimizedButton.Visible = true
    end)

    MinimizedButton.MouseButton1Click:Connect(function()
        MainFrame.Visible = true
        MinimizedButton.Visible = false
    end)

    local function makeDraggable(frame, handle)
        local dragging = false
        local dragInput, dragStart, startPos

        local function update(input)
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end

        handle.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position

                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)

        handle.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                update(input)
            end
        end)
    end

    makeDraggable(MainFrame, Header)

    local Description = Instance.new("TextLabel")
    Description.Text = "Использование на людных серверах может привлечь внимание игроков и вызвать репорты или бан."
    Description.Size = UDim2.new(1, -20, 0, 50)
    Description.Position = UDim2.new(0, 10, 0, 35)
    Description.TextColor3 = Color3.fromRGB(255, 255, 255)
    Description.TextWrapped = true
    Description.BackgroundTransparency = 1
    Description.Font = Enum.Font.Gotham
    Description.TextSize = 12
    Description.Parent = MainFrame

    -- 🔥 قسم المميزات الأساسية
    local FeaturesY = 90
    
    -- 1. Coin Farming
    local FarmToggle = Instance.new("TextButton")
    FarmToggle.Size = UDim2.new(1, -20, 0, 30)
    FarmToggle.Position = UDim2.new(0, 10, 0, FeaturesY)
    FarmToggle.BackgroundColor3 = Color3.fromRGB(20, 70, 35)
    FarmToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
    FarmToggle.Text = "💰 Coin Farming: OFF"
    FarmToggle.Font = Enum.Font.GothamBold
    FarmToggle.TextSize = 14
    FarmToggle.BorderSizePixel = 0
    FarmToggle.Parent = MainFrame
    Instance.new("UICorner", FarmToggle).CornerRadius = UDim.new(0, 8)
    FeaturesY = FeaturesY + 35

    -- 2. Fling Murderer
    local FlingButton = Instance.new("TextButton")
    FlingButton.Size = UDim2.new(1, -20, 0, 30)
    FlingButton.Position = UDim2.new(0, 10, 0, FeaturesY)
    FlingButton.BackgroundColor3 = Color3.fromRGB(20, 70, 35)
    FlingButton.TextColor3 = Color3.fromRGB(255, 150, 150)
    FlingButton.Text = "💀 Fling Murderer"
    FlingButton.Font = Enum.Font.GothamBold
    FlingButton.TextSize = 14
    FlingButton.BorderSizePixel = 0
    FlingButton.Parent = MainFrame
    Instance.new("UICorner", FlingButton).CornerRadius = UDim.new(0, 8)
    FeaturesY = FeaturesY + 35

    -- 3. Anti-Fling
    local AntiFlingToggle = Instance.new("TextButton")
    AntiFlingToggle.Size = UDim2.new(1, -20, 0, 30)
    AntiFlingToggle.Position = UDim2.new(0, 10, 0, FeaturesY)
    AntiFlingToggle.BackgroundColor3 = Color3.fromRGB(20, 70, 35)
    AntiFlingToggle.TextColor3 = Color3.fromRGB(100, 200, 255)
    AntiFlingToggle.Text = "🛡️ Anti-Fling: OFF"
    AntiFlingToggle.Font = Enum.Font.GothamBold
    AntiFlingToggle.TextSize = 14
    AntiFlingToggle.BorderSizePixel = 0
    AntiFlingToggle.Parent = MainFrame
    Instance.new("UICorner", AntiFlingToggle).CornerRadius = UDim.new(0, 8)
    FeaturesY = FeaturesY + 35

    -- 4. Speed Hack
    local SpeedButton = Instance.new("TextButton")
    SpeedButton.Size = UDim2.new(1, -20, 0, 30)
    SpeedButton.Position = UDim2.new(0, 10, 0, FeaturesY)
    SpeedButton.BackgroundColor3 = Color3.fromRGB(20, 70, 35)
    SpeedButton.TextColor3 = Color3.fromRGB(150, 255, 150)
    SpeedButton.Text = "⚡ Speed: 16"
    SpeedButton.Font = Enum.Font.GothamBold
    SpeedButton.TextSize = 14
    SpeedButton.BorderSizePixel = 0
    SpeedButton.Parent = MainFrame
    Instance.new("UICorner", SpeedButton).CornerRadius = UDim.new(0, 8)
    FeaturesY = FeaturesY + 35

    -- 🔗 زر الدعم
    local CopyLinkButton = Instance.new("TextButton")
    CopyLinkButton.Size = UDim2.new(1, -20, 0, 30)
    CopyLinkButton.Position = UDim2.new(0, 10, 0, FeaturesY)
    CopyLinkButton.BackgroundColor3 = Color3.fromRGB(20, 70, 35)
    CopyLinkButton.TextColor3 = Color3.fromRGB(200, 255, 200)
    CopyLinkButton.Text = "💬 Поддержать разработчика"
    CopyLinkButton.Font = Enum.Font.GothamBold
    CopyLinkButton.TextSize = 14
    CopyLinkButton.BorderSizePixel = 0
    CopyLinkButton.Parent = MainFrame
    Instance.new("UICorner", CopyLinkButton).CornerRadius = UDim.new(0, 8)

    CopyLinkButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard("https://discord.com/channels/1220754754578419842/1373567821010829312")
        elseif set_clipboard then
            set_clipboard("https://discord.com/channels/1220754754578419842/1373567821010829312")
        else
            Player:Kick("Ваш executor не поддерживает копирование в буфер обмена, ссылка:\nhttps://discord.com/channels/1220754754578419842/1373567821010829312")
        end
    end)

    -- 🔧 الدوال الأساسية
    
    -- 1. Coin Farming (محسنة)
    local function coinFarm()
        local collected = 0
        local startTime = tick()
        
        while getgenv().coinFarm do
            local coins = {}
            
            -- البحث السريع
            for _, v in ipairs(workspace:GetDescendants()) do
                if not getgenv().coinFarm then break end
                if v:IsA("BasePart") and v.Name == "Coin_Server" then
                    table.insert(coins, v)
                end
            end
            
            -- الانتقال السريع
            for _, coin in ipairs(coins) do
                if not getgenv().coinFarm then return end
                
                if Character and HumanoidRootPart then
                    HumanoidRootPart.CFrame = coin.CFrame
                    task.wait(2) -- ⚡ 90 جزء من الثانية
                    collected = collected + 1
                end
            end
            
            -- تحديث النص
            local elapsed = math.floor(tick() - startTime)
            FarmToggle.Text = string.format("💰 Farming: ON (%d)", collected)
            
            if #coins == 0 then
                task.wait(1)
            else
                task.wait(1)
            end
        end
    end

    -- 2. دالة القذف
    local function SHubFling(TargetPlayer)
        if not (Character and Humanoid and HumanoidRootPart) then return end
        
        local TCharacter = TargetPlayer.Character
        if not TCharacter then return end
        
        local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
        local TRootPart = THumanoid and THumanoid.RootPart
        local THead = TCharacter:FindFirstChild("Head")
        
        local OldPos = HumanoidRootPart.CFrame
        
        -- تغيير الكاميرا
        Workspace.CurrentCamera.CameraSubject = THead or THumanoid
        task.wait(0.01)
        
        local BV = Instance.new("BodyVelocity")
        BV.Name = "1Q_Fling"
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BV.Parent = HumanoidRootPart
        
        local start = tick()
        local angle = 0
        
        while tick() - start < 1.5 do
            if HumanoidRootPart and TRootPart then
                angle = angle + 200
                local offsets = {
                    CFrame.new(0, 2, 0),
                    CFrame.new(0, -2, 0),
                    CFrame.new(3, 0, -3),
                    CFrame.new(-3, 0, 3)
                }
                
                for _, offset in ipairs(offsets) do
                    local targetCF = TRootPart.CFrame * offset * CFrame.Angles(math.rad(angle), 0, 0)
                    HumanoidRootPart.CFrame = targetCF
                    task.wait(0.008)
                end
            end
        end
        
        BV:Destroy()
        HumanoidRootPart.CFrame = OldPos
        Workspace.CurrentCamera.CameraSubject = Humanoid
    end

    -- 3. Anti-Fling System
    local AntiFlingEnabled = false
    local AntiFlingConnection = nil
    
    local function EnableAntiFling()
        AntiFlingEnabled = true
        local safePosition = HumanoidRootPart.CFrame
        
        AntiFlingConnection = RunService.Heartbeat:Connect(function()
            if not AntiFlingEnabled or not HumanoidRootPart then return end
            
            -- كشف السرعة العالية
            if HumanoidRootPart.Velocity.Magnitude > 500 or HumanoidRootPart.RotVelocity.Magnitude > 800 then
                HumanoidRootPart.Velocity = Vector3.zero
                HumanoidRootPart.RotVelocity = Vector3.zero
                HumanoidRootPart.CFrame = safePosition
            else
                safePosition = HumanoidRootPart.CFrame
            end
            
            -- منع BodyVelocities خارجية
            for _, child in ipairs(HumanoidRootPart:GetChildren()) do
                if child:IsA("BodyVelocity") and child.Name ~= "1Q_Fling" then
                    child:Destroy()
                end
            end
        end)
        
        print("🛡️ Anti-Fling مفعل")
    end
    
    local function DisableAntiFling()
        AntiFlingEnabled = false
        if AntiFlingConnection then
            AntiFlingConnection:Disconnect()
            AntiFlingConnection = nil
        end
        print("✅ Anti-Fling معطل")
    end

    -- 🎮 ربط الأزرار
    
    -- زر الفلينق
    FlingButton.MouseButton1Click:Connect(function()
        -- البحث عن القاتل
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= Player then
                local char = player.Character
                if char then
                    local humanoid = char:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        -- فلينق بسيط
                        task.spawn(function()
                            SHubFling(player)
                        end)
                        break
                    end
                end
            end
        end
    end)
    
    -- زر الفلينق
    AntiFlingToggle.MouseButton1Click:Connect(function()
        if AntiFlingEnabled then
            DisableAntiFling()
            AntiFlingToggle.Text = "🛡️ Anti-Fling: OFF"
            AntiFlingToggle.TextColor3 = Color3.fromRGB(100, 200, 255)
        else
            EnableAntiFling()
            AntiFlingToggle.Text = "🛡️ Anti-Fling: ON"
            AntiFlingToggle.TextColor3 = Color3.fromRGB(50, 255, 100)
        end
    end)
    
    -- زر السرعة
    SpeedButton.MouseButton1Click:Connect(function()
        local speeds = {16, 30, 50, 100, 150}
        local currentSpeed = Humanoid.WalkSpeed or 16
        local nextIndex = 1
        
        for i, speed in ipairs(speeds) do
            if currentSpeed < speed then
                nextIndex = i
                break
            elseif i == #speeds then
                nextIndex = 1
            end
        end
        
        local newSpeed = speeds[nextIndex]
        Humanoid.WalkSpeed = newSpeed
        SpeedButton.Text = "⚡ Speed: " .. newSpeed
        
        -- لون حسب السرعة
        if newSpeed <= 30 then
            SpeedButton.TextColor3 = Color3.fromRGB(150, 255, 150)
        elseif newSpeed <= 100 then
            SpeedButton.TextColor3 = Color3.fromRGB(255, 255, 100)
        else
            SpeedButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
    
    -- زر الزراعة
    FarmToggle.MouseButton1Click:Connect(function()
        getgenv().coinFarm = not getgenv().coinFarm
        
        if getgenv().coinFarm then
            FarmToggle.Text = "💰 Farming: ON"
            FarmToggle.TextColor3 = Color3.fromRGB(100, 255, 100)
            task.spawn(coinFarm)
        else
            FarmToggle.Text = "💰 Farming: OFF"
            FarmToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    end)
end


