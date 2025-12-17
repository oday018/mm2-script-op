-- مكتبة بسيطة لإنشاء واجهات جميلة
local Rayfield = {}
Rayfield.__index = Rayfield

function Rayfield:CreateWindow(name)
    local self = setmetatable({}, Rayfield)
    
    -- النافذة الرئيسية
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = name
    self.ScreenGui.Parent = game.CoreGui
    self.ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- الإطار الرئيسي
    self.MainFrame = Instance.new("Frame")
    self.MainFrame.Name = "MainFrame"
    self.MainFrame.Size = UDim2.new(0, 350, 0, 40)
    self.MainFrame.Position = UDim2.new(0.5, -175, 0.1, 0)
    self.MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    self.MainFrame.BorderSizePixel = 0
    self.MainFrame.Parent = self.ScreenGui
    
    -- زوايا دائرية
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = self.MainFrame
    
    -- ظل خفيف
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(60, 60, 60)
    UIStroke.Thickness = 1
    UIStroke.Parent = self.MainFrame
    
    -- شريط العنوان
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Name = "TitleBar"
    self.TitleBar.Size = UDim2.new(1, 0, 0, 35)
    self.TitleBar.BackgroundTransparency = 1
    self.TitleBar.Parent = self.MainFrame
    
    -- اسم النافذة
    self.Title = Instance.new("TextLabel")
    self.Title.Name = "Title"
    self.Title.Size = UDim2.new(1, -40, 1, 0)
    self.Title.Position = UDim2.new(0, 10, 0, 0)
    self.Title.BackgroundTransparency = 1
    self.Title.Text = name
    self.Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.Title.TextSize = 16
    self.Title.Font = Enum.Font.GothamSemibold
    self.Title.TextXAlignment = Enum.TextXAlignment.Left
    self.Title.Parent = self.TitleBar
    
    -- زر الإغلاق (اختياري)
    self.CloseButton = Instance.new("TextButton")
    self.CloseButton.Name = "CloseButton"
    self.CloseButton.Size = UDim2.new(0, 25, 0, 25)
    self.CloseButton.Position = UDim2.new(1, -30, 0, 5)
    self.CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.CloseButton.Text = "X"
    self.CloseButton.TextColor3 = Color3.fromRGB(255, 100, 100)
    self.CloseButton.TextSize = 14
    self.CloseButton.Font = Enum.Font.GothamBold
    self.CloseButton.Parent = self.TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 4)
    CloseCorner.Parent = self.CloseButton
    
    self.CloseButton.MouseButton1Click:Connect(function()
        self.ScreenGui:Destroy()
    end)
    
    -- جعل النافذة قابلة للسحب
    local dragging = false
    local dragInput, dragStart, startPos
    
    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- حاوية المحتوى
    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Name = "ContentContainer"
    self.ContentContainer.Size = UDim2.new(1, -20, 1, -45)
    self.ContentContainer.Position = UDim2.new(0, 10, 0, 40)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.Parent = self.MainFrame
    
    self.ContentSize = 0
    
    return self
end

function Rayfield:ResizeWindow(height)
    self.MainFrame.Size = UDim2.new(0, 350, 0, height + 45)
end

function Rayfield:CreateButton(name, callback)
    self.ContentSize = self.ContentSize + 45
    
    local ButtonFrame = Instance.new("Frame")
    ButtonFrame.Name = name .. "Button"
    ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
    ButtonFrame.Position = UDim2.new(0, 0, 0, self.ContentSize - 45)
    ButtonFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ButtonFrame.BorderSizePixel = 0
    ButtonFrame.Parent = self.ContentContainer
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = ButtonFrame
    
    local Button = Instance.new("TextButton")
    Button.Name = "Button"
    Button.Size = UDim2.new(1, 0, 1, 0)
    Button.BackgroundTransparency = 1
    Button.Text = ""
    Button.Parent = ButtonFrame
    
    local ButtonText = Instance.new("TextLabel")
    ButtonText.Name = "ButtonText"
    ButtonText.Size = UDim2.new(1, -20, 1, 0)
    ButtonText.Position = UDim2.new(0, 10, 0, 0)
    ButtonText.BackgroundTransparency = 1
    ButtonText.Text = name
    ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ButtonText.TextSize = 14
    ButtonText.Font = Enum.Font.Gotham
    ButtonText.TextXAlignment = Enum.TextXAlignment.Left
    ButtonText.Parent = ButtonFrame
    
    local ToggleIndicator = Instance.new("Frame")
    ToggleIndicator.Name = "ToggleIndicator"
    ToggleIndicator.Size = UDim2.new(0, 20, 0, 20)
    ToggleIndicator.Position = UDim2.new(1, -30, 0.5, -10)
    ToggleIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    ToggleIndicator.Parent = ButtonFrame
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 4)
    ToggleCorner.Parent = ToggleIndicator
    
    local state = false
    
    local function updateState()
        if state then
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
            ButtonText.TextColor3 = Color3.fromRGB(200, 220, 255)
        else
            ToggleIndicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
            ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    
    Button.MouseButton1Click:Connect(function()
        state = not state
        updateState()
        if callback then
            callback(state)
        end
    end)
    
    -- تأثيرات hover
    Button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            ButtonFrame,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}
        ):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            ButtonFrame,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}
        ):Play()
    end)
    
    self:ResizeWindow(self.ContentSize)
    
    return {
        SetState = function(newState)
            state = newState
            updateState()
        end,
        GetState = function()
            return state
        end
    }
end

function Rayfield:CreateLabel(text)
    self.ContentSize = self.ContentSize + 30
    
    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.Position = UDim2.new(0, 0, 0, self.ContentSize - 30)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(200, 200, 200)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = self.ContentContainer
    
    self:ResizeWindow(self.ContentSize)
    
    return Label
end

-- ============================================
-- كود المزرعة مع الواجهة الجديدة
-- ============================================

-- إنشاء النافذة
local Window = Rayfield:CreateWindow("Coin Fly Farm")

-- إضافة وصف
Window:CreateLabel("Click to toggle coin farming")

-- المتغير العام
getgenv().FarmCoins = false

-- إنشاء الزر
local FarmButton = Window:CreateButton("Farm Coins", function(state)
    FarmCoins = state
    print("Farm Coins:", state)
end)

------------------------------------------------
-- إعدادات المزرعة
------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer
local RANGE = 200
local FLIGHT_SPEED = 80
local ROTATION_SPEED = 10
local Y_OFFSET = -3
local COLLECT_DISTANCE = 5

------------------------------------------------
-- نظام البحث عن العملات
------------------------------------------------
local currentTarget = nil
local lastCoinCheck = 0
local COIN_CHECK_INTERVAL = 0.3

local function getClosestCoin()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local root = lp.Character.HumanoidRootPart
    local closestCoin
    local shortest = RANGE
    
    if tick() - lastCoinCheck < COIN_CHECK_INTERVAL and currentTarget and currentTarget.Parent then
        return currentTarget
    end
    
    lastCoinCheck = tick()
    
    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("coin") or v.Name:lower():find("part")) and v.Parent then
            local dist = (v.Position - root.Position).Magnitude
            if dist <= shortest then
                shortest = dist
                closestCoin = v
            end
        end
    end
    
    currentTarget = closestCoin
    return closestCoin
end

------------------------------------------------
-- نظام الطيران
------------------------------------------------
local function flyToCoin(coin)
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    if not coin or not coin.Parent then return end
    
    local root = lp.Character.HumanoidRootPart
    local humanoid = lp.Character:FindFirstChild("Humanoid")
    
    if humanoid then
        humanoid.PlatformStand = true
    end
    
    local targetPos = coin.Position + Vector3.new(0, Y_OFFSET, 0)
    local direction = (targetPos - root.Position)
    local distance = direction.Magnitude
    
    if distance <= COLLECT_DISTANCE then
        currentTarget = nil
        return true
    end
    
    direction = direction.Unit
    local velocity = direction * FLIGHT_SPEED
    
    local bv = root:FindFirstChild("FlightVelocity") or Instance.new("BodyVelocity")
    bv.Name = "FlightVelocity"
    bv.P = 10000
    bv.MaxForce = Vector3.new(10000, 10000, 10000)
    bv.Velocity = velocity
    bv.Parent = root
    
    return false
end

local function cleanupFlight()
    if lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
        local root = lp.Character.HumanoidRootPart
        local humanoid = lp.Character:FindFirstChild("Humanoid")
        
        if humanoid then
            humanoid.PlatformStand = false
        end
        
        local bv = root:FindFirstChild("FlightVelocity")
        if bv then
            bv:Destroy()
        end
    end
end

------------------------------------------------
-- لوب المزرعة
------------------------------------------------
local connection
local function startFarming()
    if connection then connection:Disconnect() end
    
    connection = RunService.RenderStepped:Connect(function()
        if not FarmCoins then 
            cleanupFlight()
            return 
        end
        
        if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then 
            cleanupFlight()
            return 
        end
        
        local coin = getClosestCoin()
        
        if coin then
            local reached = flyToCoin(coin)
            if reached then
                currentTarget = nil
                lastCoinCheck = 0
            end
        else
            cleanupFlight()
        end
    end)
end

-- إضافة تلقائية عند تغيير حالة الزر
FarmButton.SetState = function(newState)
    FarmCoins = newState
    
    if FarmCoins then
        startFarming()
    else
        if connection then 
            connection:Disconnect() 
            connection = nil
        end
        cleanupFlight()
    end
end

print("Coin Fly Farm UI loaded successfully!")
