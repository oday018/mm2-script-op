if game.PlaceId == 142823291 then
    local Players = game:GetService('Players')
    local CoreGUI = game:GetService('CoreGui')
    local TweenService = game:GetService('TweenService')
    local UserInputService = game:GetService("UserInputService")
    local TextService = game:GetService("TextService")

    local Player = Players.LocalPlayer
    getgenv().coinFarm = false

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "1QLUA_HUB"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGUI

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 260, 0, 210)
    MainFrame.Position = UDim2.new(0.5, -130, 0.5, -105)
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

    local FarmToggle = Instance.new("TextButton")
    FarmToggle.Size = UDim2.new(1, -20, 0, 30)
    FarmToggle.Position = UDim2.new(0, 10, 0, 90)
    FarmToggle.BackgroundColor3 = Color3.fromRGB(20, 70, 35)
    FarmToggle.TextColor3 = Color3.fromRGB(255, 100, 100)
    FarmToggle.Text = "Farming: OFF"
    FarmToggle.Font = Enum.Font.GothamBold
    FarmToggle.TextSize = 14
    FarmToggle.BorderSizePixel = 0
    FarmToggle.Parent = MainFrame
    Instance.new("UICorner", FarmToggle).CornerRadius = UDim.new(0, 8)

    local CopyLinkButton = Instance.new("TextButton")
    CopyLinkButton.Size = UDim2.new(1, -20, 0, 30)
    CopyLinkButton.Position = UDim2.new(0, 10, 0, 135)
    CopyLinkButton.BackgroundColor3 = Color3.fromRGB(20, 70, 35)
    CopyLinkButton.TextColor3 = Color3.fromRGB(200, 255, 200)
    CopyLinkButton.Text = "Поддержать разработчика"
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

    -- دالة جديدة للحركة السلسة (Flying/Ghost Movement)
    local function flyToCoin(coin)
        if not Player.Character or not Player.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local characterRoot = Player.Character.HumanoidRootPart
        local targetPosition = coin.Position
        
        -- حساب المسافة والمدة
        local distance = (targetPosition - characterRoot.Position).Magnitude
        local duration = math.clamp(distance / 30, 1, 3) -- سرعة متناسبة مع المسافة
        
        -- إعدادات الحركة السلسة
        local tweenInfo = TweenInfo.new(
            duration,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out,
            1,
            false,
            0
        )
        
        -- إنشاء الهدف للحركة (يحلق فوق العملة)
        local goal = {
            CFrame = CFrame.new(targetPosition.X, targetPosition.Y + 8, targetPosition.Z)
        }
        
        -- إنشاء الحركة
        local tween = TweenService:Create(characterRoot, tweenInfo, goal)
        tween:Play()
        
        -- إضافة حركة طفو (Floating effect)
        local floatTween = TweenService:Create(characterRoot, 
            TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
            {CFrame = characterRoot.CFrame * CFrame.new(0, 3, 0)}
        )
        floatTween:Play()
    end

    local function coinFarm()
        while getgenv().coinFarm do
            for _, v in ipairs(workspace:GetDescendants()) do
                if not getgenv().coinFarm then return end
                if v:IsA("BasePart") and v.Name == "Coin_Server" then
                    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                        -- استخدام الحركة السلسة بدلاً من الت teleport المباشر
                        flyToCoin(v)
                        local waitTime = 2.5
                        local waited = 0
                        while waited < waitTime do
                            if not getgenv().coinFarm then return end
                            task.wait(0.1)
                            waited = waited + 0.1
                        end
                    end
                end
            end
            task.wait(0.1)
        end
    end

    local farming = false
    FarmToggle.MouseButton1Click:Connect(function()
        farming = not farming
        getgenv().coinFarm = farming
        FarmToggle.Text = "Farming: " .. (farming and "ON" or "OFF")
        FarmToggle.TextColor3 = farming and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        if farming then
            task.spawn(coinFarm)
        end
    end)
end
