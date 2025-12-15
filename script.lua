-- ====================================================
-- 📦 مكتبة "Ghost UI" - صنعت خصيصاً لـ MM2 Coin Farming
-- ====================================================

local GhostUI = {}
GhostUI.__index = GhostUI

-- 🎨 الألوان الافتراضية
GhostUI.Theme = {
    Primary = Color3.fromRGB(120, 0, 200),  -- بنفسجي
    Secondary = Color3.fromRGB(50, 50, 50), -- رمادي غامق
    Text = Color3.fromRGB(255, 255, 255),   -- أبيض
    Accent = Color3.fromRGB(0, 200, 100)    -- أخضر
}

-- 🏗️ إنشاء نافذة رئيسية
function GhostUI:CreateWindow(config)
    local window = {}
    setmetatable(window, GhostUI)
    
    -- إعدادات النافذة
    window.Title = config.Title or "Ghost UI"
    window.SubTitle = config.SubTitle or "Powered by Ghost"
    window.Tabs = {}
    window.Visible = true
    
    -- 🖥️ إنشاء الشاشة الرئيسية
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "GhostUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = game:GetService("CoreGui") or game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- 📁 الإطار الرئيسي
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 500, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    -- 🔲 زوايا دائرية
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame
    
    -- 🎯 شريط العنوان
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = GhostUI.Theme.Primary
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 8)
    UICorner2.Parent = TitleBar
    
    -- 📝 العنوان الرئيسي
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    TitleLabel.Position = UDim2.new(0, 15, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = window.Title
    TitleLabel.TextColor3 = GhostUI.Theme.Text
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = TitleBar
    
    -- 📝 العنوان الفرعي
    local SubTitleLabel = Instance.new("TextLabel")
    SubTitleLabel.Name = "SubTitleLabel"
    SubTitleLabel.Size = UDim2.new(0.7, 0, 0, 20)
    SubTitleLabel.Position = UDim2.new(0, 15, 0, 22)
    SubTitleLabel.BackgroundTransparency = 1
    SubTitleLabel.Text = window.SubTitle
    SubTitleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    SubTitleLabel.TextSize = 14
    SubTitleLabel.Font = Enum.Font.Gotham
    SubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    SubTitleLabel.Parent = TitleBar
    
    -- ❌ زر الإغلاق
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0, 6)
    UICorner3.Parent = CloseButton
    
    -- 🔽 زر التصغير
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    MinimizeButton.Text = "_"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 20
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TitleBar
    
    local UICorner4 = Instance.new("UICorner")
    UICorner4.CornerRadius = UDim.new(0, 6)
    UICorner4.Parent = MinimizeButton
    
    -- 📑 منطقة التبويبات
    local TabsContainer = Instance.new("Frame")
    TabsContainer.Name = "TabsContainer"
    TabsContainer.Size = UDim2.new(0, 120, 1, -40)
    TabsContainer.Position = UDim2.new(0, 0, 0, 40)
    TabsContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    TabsContainer.BorderSizePixel = 0
    TabsContainer.Parent = MainFrame
    
    -- 📄 منطقة المحتوى
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -120, 1, -40)
    ContentContainer.Position = UDim2.new(0, 120, 0, 40)
    ContentContainer.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    ContentContainer.BorderSizePixel = 0
    ContentContainer.ClipsDescendants = true
    ContentContainer.Parent = MainFrame
    
    -- 🔄 تخزين العناصر
    window.Gui = ScreenGui
    window.MainFrame = MainFrame
    window.ContentContainer = ContentContainer
    window.TabsContainer = TabsContainer
    
    -- 🖱️ جعل النافذة قابلة للسحب
    local dragging = false
    local dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input == dragInput then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, 
                startPos.X.Offset + delta.X,
                startPos.Y.Scale, 
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    -- ⚡ وظائف الأزرار
    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
        window.Visible = false
    end)
    
    MinimizeButton.MouseButton1Click:Connect(function()
        local isMinimized = ContentContainer.Visible
        ContentContainer.Visible = not isMinimized
        TabsContainer.Visible = not isMinimized
        MinimizeButton.Text = isMinimized and "_" or "+"
    end)
    
    print("✅ إنشاء النافذة: " .. window.Title)
    return window
end

-- ➕ إنشاء تبويب جديد
function GhostUI:MakeTab(config)
    local tab = {}
    tab.Name = config.Title or "Tab"
    tab.Icon = config.Icon or ""
    tab.Buttons = {}
    tab.Toggles = {}
    tab.Sliders = {}
    
    -- 📑 زر التبويب
    local TabButton = Instance.new("TextButton")
    TabButton.Name = "Tab_" .. tab.Name
    TabButton.Size = UDim2.new(1, -10, 0, 40)
    TabButton.Position = UDim2.new(0, 5, 0, (#self.Tabs * 45) + 5)
    TabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    TabButton.Text = "  " .. tab.Name
    TabButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    TabButton.TextSize = 14
    TabButton.Font = Enum.Font.Gotham
    TabButton.TextXAlignment = Enum.TextXAlignment.Left
    TabButton.Parent = self.TabsContainer
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = TabButton
    
    -- 📂 إطار محتوى التبويب
    local TabFrame = Instance.new("ScrollingFrame")
    TabFrame.Name = "Frame_" .. tab.Name
    TabFrame.Size = UDim2.new(1, 0, 1, 0)
    TabFrame.Position = UDim2.new(0, 0, 0, 0)
    TabFrame.BackgroundTransparency = 1
    TabFrame.BorderSizePixel = 0
    TabFrame.ScrollBarThickness = 4
    TabFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 100)
    TabFrame.Visible = (#self.Tabs == 0) -- الأول يكون ظاهر
    TabFrame.Parent = self.ContentContainer
    
    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Padding = UDim.new(0, 10)
    UIListLayout.Parent = TabFrame
    
    tab.Button = TabButton
    tab.Frame = TabFrame
    tab.ContentY = 10
    
    -- 🖱️ تفعيل التبويب عند النقر
    TabButton.MouseButton1Click:Connect(function()
        -- إخفاء كل التبويبات
        for _, otherTab in pairs(self.Tabs) do
            otherTab.Frame.Visible = false
            otherTab.Button.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
        end
        
        -- إظهار التبويب المحدد
        TabFrame.Visible = true
        TabButton.BackgroundColor3 = GhostUI.Theme.Accent
    end)
    
    -- إضافة التبويب إلى القائمة
    table.insert(self.Tabs, tab)
    
    -- إذا كان أول تبويب، نفعله
    if #self.Tabs == 1 then
        TabButton.BackgroundColor3 = GhostUI.Theme.Accent
    end
    
    return tab
end

-- 🔘 إضافة زر
function GhostUI:AddButton(tab, config)
    local button = {}
    button.Name = config.Name or "Button"
    button.Callback = config.Callback or function() end
    
    -- 🖱️ إنشاء الزر
    local Button = Instance.new("TextButton")
    Button.Name = "Button_" .. button.Name
    Button.Size = UDim2.new(1, -20, 0, 40)
    Button.Position = UDim2.new(0, 10, 0, tab.ContentY)
    Button.BackgroundColor3 = GhostUI.Theme.Primary
    Button.Text = button.Name
    Button.TextColor3 = GhostUI.Theme.Text
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamBold
    Button.Parent = tab.Frame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = Button
    
    -- 💫 تأثير عند التحويم
    Button.MouseEnter:Connect(function()
        game:GetService("TweenService"):Create(
            Button,
            TweenInfo.new(0.2),
            {BackgroundColor3 = Color3.fromRGB(140, 40, 220)}
        ):Play()
    end)
    
    Button.MouseLeave:Connect(function()
        game:GetService("TweenService"):Create(
            Button,
            TweenInfo.new(0.2),
            {BackgroundColor3 = GhostUI.Theme.Primary}
        ):Play()
    end)
    
    -- 📞 تفعيل الوظيفة عند النقر
    Button.MouseButton1Click:Connect(function()
        button.Callback()
    end)
    
    tab.ContentY = tab.ContentY + 50
    tab.Frame.CanvasSize = UDim2.new(0, 0, 0, tab.ContentY + 10)
    
    table.insert(tab.Buttons, button)
    return button
end

-- 🔄 إضافة تبديل (Toggle)
function GhostUI:AddToggle(tab, config)
    local toggle = {}
    toggle.Name = config.Name or "Toggle"
    toggle.Value = config.Default or false
    toggle.Callback = config.Callback or function() end
    
    -- 🎨 إنشاء إطار التبديل
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "Toggle_" .. toggle.Name
    ToggleFrame.Size = UDim2.new(1, -20, 0, 40)
    ToggleFrame.Position = UDim2.new(0, 10, 0, tab.ContentY)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    ToggleFrame.Parent = tab.Frame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = ToggleFrame
    
    -- 📝 عنوان التبديل
    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Name = "Label"
    ToggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Text = toggle.Name
    ToggleLabel.TextColor3 = GhostUI.Theme.Text
    ToggleLabel.TextSize = 14
    ToggleLabel.Font = Enum.Font.Gotham
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    ToggleLabel.Parent = ToggleFrame
    
    -- 🟢 زر التبديل
    local ToggleButton = Instance.new("TextButton")
    ToggleButton.Name = "Switch"
    ToggleButton.Size = UDim2.new(0, 50, 0, 25)
    ToggleButton.Position = UDim2.new(1, -65, 0.5, -12.5)
    ToggleButton.BackgroundColor3 = toggle.Value and GhostUI.Theme.Accent or Color3.fromRGB(80, 80, 100)
    ToggleButton.Text = ""
    ToggleButton.Parent = ToggleFrame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0, 12)
    UICorner2.Parent = ToggleButton
    
    -- ⚪ دائرة داخلية
    local ToggleCircle = Instance.new("Frame")
    ToggleCircle.Name = "Circle"
    ToggleCircle.Size = UDim2.new(0, 21, 0, 21)
    ToggleCircle.Position = toggle.Value and UDim2.new(1, -28, 0.5, -10.5) or UDim2.new(0, 4, 0.5, -10.5)
    ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ToggleCircle.Parent = ToggleButton
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0.5, 0)
    UICorner3.Parent = ToggleCircle
    
    -- 🖱️ وظيفة التبديل
    ToggleButton.MouseButton1Click:Connect(function()
        toggle.Value = not toggle.Value
        
        -- تغيير اللون
        ToggleButton.BackgroundColor3 = toggle.Value and GhostUI.Theme.Accent or Color3.fromRGB(80, 80, 100)
        
        -- تحريك الدائرة
        local newPosition = toggle.Value and UDim2.new(1, -28, 0.5, -10.5) or UDim2.new(0, 4, 0.5, -10.5)
        game:GetService("TweenService"):Create(
            ToggleCircle,
            TweenInfo.new(0.2),
            {Position = newPosition}
        ):Play()
        
        -- تفعيل الدالة
        toggle.Callback(toggle.Value)
    end)
    
    tab.ContentY = tab.ContentY + 50
    tab.Frame.CanvasSize = UDim2.new(0, 0, 0, tab.ContentY + 10)
    
    table.insert(tab.Toggles, toggle)
    return toggle
end

-- 📊 إضافة منزلق (Slider)
function GhostUI:AddSlider(tab, config)
    local slider = {}
    slider.Name = config.Name or "Slider"
    slider.Min = config.Min or 0
    slider.Max = config.Max or 100
    slider.Value = config.Default or 50
    slider.Callback = config.Callback or function() end
    
    -- 🎨 إنشاء إطار المنزلق
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "Slider_" .. slider.Name
    SliderFrame.Size = UDim2.new(1, -20, 0, 60)
    SliderFrame.Position = UDim2.new(0, 10, 0, tab.ContentY)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    SliderFrame.Parent = tab.Frame
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = SliderFrame
    
    -- 📝 عنوان المنزلق
    local SliderLabel = Instance.new("TextLabel")
    SliderLabel.Name = "Label"
    SliderLabel.Size = UDim2.new(1, -20, 0, 20)
    SliderLabel.Position = UDim2.new(0, 10, 0, 5)
    SliderLabel.BackgroundTransparency = 1
    SliderLabel.Text = slider.Name .. ": " .. slider.Value
    SliderLabel.TextColor3 = GhostUI.Theme.Text
    SliderLabel.TextSize = 14
    SliderLabel.Font = Enum.Font.Gotham
    SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
    SliderLabel.Parent = SliderFrame
    
    -- 🎚️ المسار
    local SliderTrack = Instance.new("Frame")
    SliderTrack.Name = "Track"
    SliderTrack.Size = UDim2.new(1, -40, 0, 6)
    SliderTrack.Position = UDim2.new(0, 20, 0, 35)
    SliderTrack.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
    SliderTrack.Parent = SliderFrame
    
    local UICorner2 = Instance.new("UICorner")
    UICorner2.CornerRadius = UDim.new(0.5, 0)
    UICorner2.Parent = SliderTrack
    
    -- 🟢 المسار الممتلئ
    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "Fill"
    SliderFill.Size = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), 0, 1, 0)
    SliderFill.Position = UDim2.new(0, 0, 0, 0)
    SliderFill.BackgroundColor3 = GhostUI.Theme.Accent
    SliderFill.Parent = SliderTrack
    
    local UICorner3 = Instance.new("UICorner")
    UICorner3.CornerRadius = UDim.new(0.5, 0)
    UICorner3.Parent = SliderFill
    
    -- 🔘 مؤشر المنزلق
    local SliderButton = Instance.new("TextButton")
    SliderButton.Name = "Button"
    SliderButton.Size = UDim2.new(0, 16, 0, 16)
    SliderButton.Position = UDim2.new((slider.Value - slider.Min) / (slider.Max - slider.Min), -8, 0.5, -8)
    SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SliderButton.Text = ""
    SliderButton.ZIndex = 2
    SliderButton.Parent = SliderTrack
    
    local UICorner4 = Instance.new("UICorner")
    UICorner4.CornerRadius = UDim.new(0.5, 0)
    UICorner4.Parent = SliderButton
    
    -- 🖱️ وظيفة السحب
    local dragging = false
    
    SliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)
    
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local mousePos = game:GetService("UserInputService"):GetMouseLocation()
            local sliderAbsolutePos = SliderTrack.AbsolutePosition
            local sliderAbsoluteSize = SliderTrack.AbsoluteSize
            
            local relativeX = math.clamp(
                (mousePos.X - sliderAbsolutePos.X) / sliderAbsoluteSize.X,
                0, 1
            )
            
            slider.Value = math.floor(slider.Min + (relativeX * (slider.Max - slider.Min)))
            
            -- تحديث العرض والموضع
            SliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
            SliderButton.Position = UDim2.new(relativeX, -8, 0.5, -8)
            
            -- تحديث النص
            SliderLabel.Text = slider.Name .. ": " .. slider.Value
            
            -- تفعيل الدالة
            slider.Callback(slider.Value)
        end
    end)
    
    tab.ContentY = tab.ContentY + 70
    tab.Frame.CanvasSize = UDim2.new(0, 0, 0, tab.ContentY + 10)
    
    table.insert(tab.Sliders, slider)
    return slider
end

-- 📌 إضافة قسم (Section)
function GhostUI:AddSection(tab, text)
    local section = {}
    section.Text = text or "Section"
    
    -- 📝 إنشاء القسم
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Name = "Section_" .. section.Text
    SectionFrame.Size = UDim2.new(1, -20, 0, 30)
    SectionFrame.Position = UDim2.new(0, 10, 0, tab.ContentY)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.Parent = tab.Frame
    
    local SectionLabel = Instance.new("TextLabel")
    SectionLabel.Name = "Label"
    SectionLabel.Size = UDim2.new(1, 0, 1, 0)
    SectionLabel.BackgroundTransparency = 1
    SectionLabel.Text = "─ " .. string.upper(section.Text) .. " ─"
    SectionLabel.TextColor3 = Color3.fromRGB(150, 150, 170)
    SectionLabel.TextSize = 12
    SectionLabel.Font = Enum.Font.GothamBold
    SectionLabel.Parent = SectionFrame
    
    tab.ContentY = tab.ContentY + 40
    tab.Frame.CanvasSize = UDim2.new(0, 0, 0, tab.ContentY + 10)
    
    return section
end

-- ====================================================
-- 🎮 كود جمع العملات لـ MM2 (يعمل مع GhostUI)
-- ====================================================

local function StartMM2CoinFarmer()
    print("🚀 بدء سكربت MM2 Coin Farmer...")
    
    -- 📦 تحميل مكتبة GhostUI
    local GhostUI = getgenv().GhostUI
    if not GhostUI then
        print("❌ مكتبة GhostUI غير موجودة!")
        return
    end
    
    -- 🪟 إنشاء نافذة
    local Window = GhostUI:CreateWindow({
        Title = "MM2 Coin Master",
        SubTitle = "Auto Farm v2.0"
    })
    
    -- 📑 تبويب الزراعة
    local FarmTab = Window:MakeTab({Title = "Farming"})
    
    -- 📍 قسم الإعدادات
    Window:AddSection(FarmTab, "إعدادات الزراعة")
    
    local farmEnabled = false
    local farmSpeed = 2
    local searchRadius = 100
    
    -- 🔄 تبديل الزراعة
    Window:AddToggle(FarmTab, {
        Name = "تفعيل الزراعة التلقائية",
        Default = false,
        Callback = function(value)
            farmEnabled = value
            if value then
                StartFarming()
            end
        end
    })
    
    -- 📊 منزلق السرعة
    Window:AddSlider(FarmTab, {
        Name = "سرعة الحركة",
        Min = 1,
        Max = 5,
        Default = 2,
        Callback = function(value)
            farmSpeed = value
        end
    })
    
    -- 📏 منزلق مسافة البحث
    Window:AddSlider(FarmTab, {
        Name = "مسافة البحث",
        Min = 50,
        Max = 200,
        Default = 100,
        Callback = function(value)
            searchRadius = value
        end
    })
    
    -- 📑 تبويب معلومات
    local InfoTab = Window:MakeTab({Title = "معلومات"})
    
    Window:AddSection(InfoTab, "إحصائيات")
    
    local coinsCollected = 0
    local totalDistance = 0
    
    -- 🔄 تحديث المعلومات
    local function UpdateStats()
        -- هذه الدالة ستحدث الإحصائيات
    end
    
    -- 📈 زر عرض الإحصائيات
    Window:AddButton(InfoTab, {
        Name = "عرض الإحصائيات",
        Callback = function()
            print("💰 العملات المجموعة: " .. coinsCollected)
            print("📍 المسافة المقطوعة: " .. math.floor(totalDistance) .. " متر")
        end
    })
    
    -- 🔍 وظيفة البحث عن العملات
    local function FindNearestCoin()
        local player = game.Players.LocalPlayer
        if not player or not player.Character then return nil end
        
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if not rootPart then return nil end
        
        local playerPos = rootPart.Position
        local nearestCoin = nil
        local minDistance = searchRadius + 1
        
        -- البحث في كل الأشياء في الخريطة
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and (string.find(obj.Name:lower(), "coin") or obj.Name == "Coin_Server") then
                local distance = (obj.Position - playerPos).Magnitude
                if distance < minDistance then
                    minDistance = distance
                    nearestCoin = obj
                end
            end
        end
        
        return nearestCoin, minDistance
    end
    
    -- 🚶 وظيفة الحركة الطبيعية
    local function MoveToCoinNatural(coin)
        local player = game.Players.LocalPlayer
        if not player or not player.Character then return false end
        
        local humanoid = player.Character:FindFirstChild("Humanoid")
        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
        
        if not humanoid or not rootPart then return false end
        
        local targetPos = coin.Position
        
        -- الحساب إذا كان الهدف قريب
        local distance = (targetPos - rootPart.Position).Magnitude
        
        if distance > searchRadius then
            print("⚡ العملة بعيدة جداً: " .. math.floor(distance) .. " متر")
            return false
        end
        
        -- المشي نحو الهدف
        humanoid:MoveTo(targetPos)
        
        -- الانتظار للوصول
        local waitTime = math.min(distance / (10 * farmSpeed), 5)
        
        for i = 1, math.floor(waitTime / 0.1) do
            if not farmEnabled then break end
            
            local currentDistance = (targetPos - rootPart.Position).Magnitude
            if currentDistance < 10 then -- قريب بما يكفي
                -- محاولة جمع العملة
                if coin and coin.Parent then
                    firetouchinterest(rootPart, coin, 0)
                    task.wait(0.05)
                    firetouchinterest(rootPart, coin, 1)
                    coinsCollected = coinsCollected + 1
                    totalDistance = totalDistance + distance
                    print("✅ جمع عملة! المجموع: " .. coinsCollected)
                    return true
                end
                break
            end
            task.wait(0.1)
        end
        
        return false
    end
    
    -- 🔄 الحلقة الرئيسية للزراعة
    local function StartFarming()
        spawn(function()
            print("🌱 بدء الزراعة...")
            
            while farmEnabled do
                -- انتظار تحميل الشخصية
                local player = game.Players.LocalPlayer
                if not player or not player.Character then
                    task.wait(1)
                    continue
                end
                
                local humanoid = player.Character:FindFirstChild("Humanoid")
                if not humanoid then
                    task.wait(1)
                    continue
                end
                
                -- البحث عن أقرب عملة
                local coin, distance = FindNearestCoin()
                
                if coin then
                    print("🎯 العثور على عملة (" .. math.floor(distance) .. " متر)")
                    
                    -- التحرك نحو العملة
                    local success = MoveToCoinNatural(coin)
                    
                    if success then
                        task.wait(0.3) -- استراحة قصيرة بعد الجمع
                    else
                        task.wait(0.5)
                    end
                else
                    -- لا توجد عملات، انتظار قليلاً
                    print("🔍 جاري البحث عن عملات...")
                    task.wait(1)
                end
            end
            
            print("🛑 توقفت الزراعة")
        end)
    end
    
    -- ⚙️ تبويب الإعدادات
    local SettingsTab = Window:MakeTab({Title = "إعدادات"})
    
    Window:AddSection(SettingsTab, "عام")
    
    -- 🎨 تغيير اللون
    Window:AddButton(SettingsTab, {
        Name = "تغيير لون الواجهة",
        Callback = function()
            local colors = {
                Color3.fromRGB(120, 0, 200),  -- بنفسجي
                Color3.fromRGB(0, 120, 215),  -- أزرق
                Color3.fromRGB(215, 50, 0),   -- أحمر
                Color3.fromRGB(0, 170, 100)   -- أخضر
            }
            
            local randomColor = colors[math.random(1, #colors)]
            GhostUI.Theme.Primary = randomColor
            
            -- تحديث الألوان
            for _, obj in pairs(Window.MainFrame:GetDescendants()) do
                if obj.Name == "TitleBar" then
                    obj.BackgroundColor3 = randomColor
                end
            end
        end
    })
    
    -- 🧹 تنظيف
    Window:AddButton(SettingsTab, {
        Name = "إغلاق الواجهة",
        Callback = function()
            Window.Gui:Destroy()
        end
    })
    
    print("✅ تم تحميل GhostUI و MM2 Farmer بنجاح!")
    print("📖 التعليمات:")
    print("1. اذهب إلى تبويب Farming")
    print("2. شغل 'تفعيل الزراعة التلقائية'")
    print("3. اضبط السرعة والمسافة حسب رغبتك")
end

-- ====================================================
-- 🚀 بدء تشغيل كل شيء
-- ====================================================

-- حفظ المكتبة في الذاكرة
getgenv().GhostUI = GhostUI

-- بدء السكربت بعد تحميل اللعبة
if game.PlaceId == 142823291 then -- MM2 Place ID
    print("🎮 تم اكتشاف Murder Mystery 2")
    
    -- الانتظار لتحميل الشخصية
    local player = game.Players.LocalPlayer
    player.CharacterAdded:Wait()
    
    -- بدء المزارع بعد 3 ثواني
    task.wait(3)
    StartMM2CoinFarmer()
else
    warn("⚠️ هذا السكربت مصمم لـ MM2 فقط!")
    warn("⚙️ جاري تحميل الواجهة فقط...")
    
    -- تحميل الواجهة فقط
    task.wait(1)
    StartMM2CoinFarmer()
end
