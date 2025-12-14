--[[
    سكربت Murder Mystery 2 - النسخة العربية الموسعة
    تم التطوير بواسطة: real_redz
    الواجهة: Wand UI (Redz Library V5 Remake)
    الإصدار: 7.0.0
]]

-- ==================== انتظار تحميل اللعبة ====================
repeat task.wait() until game:IsLoaded()

-- ==================== تحميل المكتبة ====================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- ==================== إنشاء النافذة ====================
local Window = Library:MakeWindow({
    Title = "🎮 سكربت MM2 العربي",
    SubTitle = "جميع الميزات | النسخة الكاملة",
    ScriptFolder = "MM2-Arabic-Ultimate"
})

-- ==================== الخدمات والمتغيرات ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
repeat task.wait() until LocalPlayer.Character
local Character = LocalPlayer.Character
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Backpack = LocalPlayer:WaitForChild("Backpack")

-- ==================== دوال المساعدة ====================

-- دالة cloneref للحماية
local function CloneRef(instance)
    if typeof(instance) ~= "Instance" then 
        return instance 
    end
    
    local proxy = newproxy(true)
    local mt = getmetatable(proxy)
    
    local function SafeCall(func, ...)
        local ok, result = pcall(func, ...)
        return ok and result or nil
    end
    
    mt.__index = function(_, key)
        local value = SafeCall(function() 
            return instance[key] 
        end)
        
        if typeof(value) == "function" then
            return function(_, ...) 
                return instance[key](instance, ...) 
            end
        end
        return value
    end
    
    mt.__newindex = function(_, key, value)
        SafeCall(function() 
            instance[key] = value 
        end)
    end
    
    mt.__tostring = function()
        return instance:GetFullName()
    end
    
    mt.__metatable = "cloneref_protected"
    mt.__eq = function(_, other) 
        return other == instance 
    end
    
    mt.__call = function(_, ...) 
        return instance(...) 
    end
    
    return proxy
end

-- تطبيق cloneref على الخدمات
local SafePlayers = CloneRef(game:GetService("Players"))
local SafeReplicatedStorage = CloneRef(game:GetService("ReplicatedStorage"))

-- دالة الحصول على الأدوار
local function GetRoles()
    local data = SafeReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    local roles = {}
    
    for playerName, playerData in pairs(data) do
        if not playerData.Dead then
            roles[playerName] = playerData.Role
        end
    end
    
    return roles
end

-- دالة الحصول على القاتل
local function GetMurdererTarget()
    local data = SafeReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    
    for playerName, playerData in pairs(data) do
        if playerData.Role == "Murderer" then
            local player = SafePlayers:FindFirstChild(playerName)
            if player then
                if player == LocalPlayer then 
                    return nil, true 
                end
                
                local char = player.Character
                if char then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    if hrp then 
                        return hrp.Position, false 
                    end
                    
                    local head = char:FindFirstChild("Head")
                    if head then 
                        return head.Position, false 
                    end
                end
            end
        end
    end
    
    return nil, false
end








-- ==================== دالة القذف القوية الحقيقية ====================









-- دالة الإرسال (Fling) - النسخة المعدلة بالوقت المحسّن
local function SHubFling(TargetPlayer)
    if not (Character and Humanoid and HumanoidRootPart) then 
        return 
    end
    
    local TCharacter = TargetPlayer.Character
    if not TCharacter then 
        return 
    end
    
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")
    
    local OldPos = HumanoidRootPart.CFrame
    
    -- ⚡ الوقت: زيادة وقت التوجيه للكاميرا
    repeat 
        task.wait(0.005)  -- ⚡ 0.005 ثانية (مناسب)
        Workspace.CurrentCamera.CameraSubject = THead or Handle or THumanoid
    until Workspace.CurrentCamera.CameraSubject == THead or Handle or THumanoid
    
    local function FPos(BasePart, Pos, Ang)
        local targetCF = CFrame.new(BasePart.Position) * Pos * Ang
        HumanoidRootPart.CFrame = targetCF
        Character:SetPrimaryPartCFrame(targetCF)
        HumanoidRootPart.Velocity = Vector3.new(9e8, 9e9, 9e8)
        HumanoidRootPart.RotVelocity = Vector3.new(9e9, 9e9, 9e9)
    end
    
    local function SFBasePart(BasePart)
        local start = tick()
        local angle = 0
        local timeout = 1.5  -- ⚡ 1.5 ثانية (قذف طويل)
        
        repeat
            if HumanoidRootPart and THumanoid then
                angle = angle + 250  -- ⚡ سرعة دوران متوسطة
                for _, offset in ipairs{
                    CFrame.new(0, 1.5, 0),
                    CFrame.new(0, -1.5, 0),
                    CFrame.new(2.25, 1.5, -2.25),
                    CFrame.new(-2.25, -1.5, 2.25)
                } do
                    FPos(BasePart, offset + THumanoid.MoveDirection, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait(0.008)  -- ⚡ الأهم: من 2 إلى 0.008 (سرعة طبيعية)
                end
            end
        until BasePart.Velocity.Magnitude > 5000 or tick() - start > timeout
    end
    
    local BV = Instance.new("BodyVelocity")
    BV.Name = "FlingVelocity"
    BV.Velocity = Vector3.new(9e9, 9e9, 9e9)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Parent = HumanoidRootPart
    
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    
    local target = TRootPart or THead or Handle
    if target then 
        SFBasePart(target) 
    end
    
    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    
    -- ⚡ الوقت: زيادة وقت العودة للكاميرا
    repeat 
        task.wait(0.005)  -- ⚡ 0.005 ثانية
        Workspace.CurrentCamera.CameraSubject = Humanoid
    until Workspace.CurrentCamera.CameraSubject == Humanoid
    
    repeat
        local cf = OldPos * CFrame.new(0, .5, 0)
        HumanoidRootPart.CFrame = cf
        Character:SetPrimaryPartCFrame(cf)
        Humanoid:ChangeState("GettingUp")
        
        for _, part in ipairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Velocity = Vector3.zero
                part.RotVelocity = Vector3.zero
            end
        end
        
        task.wait(0.01)  -- ⚡ 0.01 ثانية
    until (HumanoidRootPart.Position - OldPos.p).Magnitude < 25
end














-- ==================== إنشاء التبويبات ====================

local MainTab = Window:MakeTab({Title = "🏠 الرئيسية", Icon = "Home"})
local PlayerTab = Window:MakeTab({Title = "👤 اللاعب", Icon = "User"})
local VisualTab = Window:MakeTab({Title = "👁️ المرئيات", Icon = "Eye"})
local TeleportTab = Window:MakeTab({Title = "📍 الانتقال", Icon = "Navigation"})
local WeaponsTab = Window:MakeTab({Title = "🔫 الأسلحة", Icon = "Target"})
local KillerTab = Window:MakeTab({Title = "🔥القاتل", Icon = "skull"})
local FlingTab = Window:MakeTab({Title = "💨 القذف", Icon = "Wind"})
local ScriptsTab = Window:MakeTab({Title = "📁 السكربتات", Icon = "Cloud"})
local SettingsTab = Window:MakeTab({Title = "⚙️ الإعدادات", Icon = "Settings"})

-- ==================== تبويب القتل ====================


KillerTab:AddSection("⚔️ قتل سريع للجميع")

-- قتل تلقائي سريع
local AutoKillAllEnabled = false
local AutoKillAllLoop = nil

KillerTab:AddToggle({
    Name = "قتل جميع اللاعبين (سريع)",
    Default = false,
    Callback = function(Value)
        AutoKillAllEnabled = Value
        
        if Value then
            -- التحقق من أن اللاعب هو القاتل
            local roles = GetRoles()
            local isMurderer = false
            
            for playerName, role in pairs(roles) do
                if playerName == LocalPlayer.Name and role == "Murderer" then
                    isMurderer = true
                    break
                end
            end
            
            if isMurderer then
                AutoKillAllLoop = task.spawn(function()
                    -- انتظر حتى تكون الشخصية متاحة
                    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
                    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
                    
                    while humanoidRootPart.Parent do
                        if AutoKillAllEnabled then
                            -- إنشاء قائمة بالأهداف الصالحة
                            local targets = {}
                            for _, player in pairs(Players:GetPlayers()) do
                                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                    table.insert(targets, player)
                                end
                            end

                            -- المرور على كل هدف ومطاردته
                            for _, player in pairs(targets) do
                                -- تحقق مستمر من أن التفعيل لا يزال قائماً والهدف صالح
                                if not AutoKillAllEnabled then break end
                                if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then continue end

                                -- === آلية الالتصاق والمطاردة السريعة ===
                                local stickDuration = 0.1 -- مدة الالتصاق (عشر ثانية)
                                local startTime = tick()

                                while tick() - startTime < stickDuration and AutoKillAllEnabled do
                                    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                                        -- الالتصاق التام مع انخفاض طفيف للاستقرار
                                        humanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame * CFrame.new(0, -1.5, 0)
                                        
                                        -- محاولة القتل الفوري
                                        if Character and Character:FindFirstChild("Knife") then
                                            pcall(function()
                                                Character.Knife.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, player.Character.HumanoidRootPart.Position, "AH2")
                                            end)
                                        end
                                    end
                                    RunService.Heartbeat:Wait() -- انتظار الإطار التالي لتتبع سلس وسريع جداً
                                end
                            end
                        else
                            -- إذا كان معطلاً، انتظر قليلاً قبل التحقق مرة أخرى
                            wait(0.1)
                        end
                    end
                end)
                
                Window:Notify({
                    Title = "⚡ تم تفعيل القتل السريع",
                    Content = "سيتم قتل جميع اللاعبين فوراً",
                    Duration = 3
                })
            else
                Window:Notify({
                    Title = "⚠️ تنبيه",
                    Content = "أنت لست القاتل! لا يمكن تفعيل هذه الميزة",
                    Duration = 3
                })
                AutoKillAllEnabled = false
            end
        else
            -- إيقاف القتل التلقائي
            if AutoKillAllLoop then
                AutoKillAllLoop:Cancel()
                AutoKillAllLoop = nil
            end
            
            Window:Notify({
                Title = "🛑 تم إيقاف القتل السريع",
                Content = "تم إيقاف ميزة القتل السريع",
                Duration = 3
            })
        end
    end
})

KillerTab:AddSection("⚙️ إعدادات القتل")

-- سرعة الانتقال
local KillSpeed = 16
local KeepKillSpeed = false

KillerTab:AddSlider({
    Name = "سرعة الانتقال",
    Min = 16,
    Max = 350,
    Default = 16,
    Increment = 1,
    Callback = function(Value)
        KillSpeed = Value
        if Humanoid and AutoKillAllEnabled then
            Humanoid.WalkSpeed = Value
        end
    end
})

KillerTab:AddToggle({
    Name = "تثبيت سرعة الانتقال تلقائياً",
    Default = false,
    Callback = function(Value)
        KeepKillSpeed = Value
        
        task.spawn(function()
            while KeepKillSpeed do
                if Humanoid and AutoKillAllEnabled and Humanoid.WalkSpeed ~= KillSpeed then
                    Humanoid.WalkSpeed = KillSpeed
                end
                task.wait(0.1)
            end
        end)
    end
})

-- قوة القفز
local KillJumpPower = 50
local KeepKillJumpPower = false

KillerTab:AddSlider({
    Name = "قوة القفز",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 1,
    Callback = function(Value)
        KillJumpPower = Value
        if Humanoid and AutoKillAllEnabled then
            Humanoid.JumpPower = Value
        end
    end
})

KillerTab:AddToggle({
    Name = "تثبيت قوة القفز تلقائياً",
    Default = false,
    Callback = function(Value)
        KeepKillJumpPower = Value
        
        task.spawn(function()
            while KeepKillJumpPower do
                if Humanoid and AutoKillAllEnabled and Humanoid.JumpPower ~= KillJumpPower then
                    Humanoid.JumpPower = KillJumpPower
                end
                task.wait(0.1)
            end
        end)
    end
})




















-- ==================== أزرار جديدة ====================

KillerTab:AddSection("🎯 قتل محدد")

-- زر قتل الشريف فقط
KillerTab:AddButton({
    Name = "قتل الشريف فقط",
    Callback = function()
        local roles = GetRoles()
        local sheriffFound = false
        
        for playerName, role in pairs(roles) do
            if role == "Sheriff" then
                local sheriff = Players:FindFirstChild(playerName)
                if sheriff and sheriff ~= LocalPlayer then
                    -- قتل الشريف
                    if Character and Character:FindFirstChild("Knife") then
                        pcall(function()
                            Character.Knife.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, sheriff.Character.HumanoidRootPart.Position, "AH2")
                        end)
                    end
                    sheriffFound = true
                    
                    Window:Notify({
                        Title = "✅ تم قتل الشريف",
                        Content = "تم قتل: " .. sheriff.Name,
                        Duration = 3
                    })
                    break
                end
            end
        end
        
        if not sheriffFound then
            Window:Notify({
                Title = "❌ خطأ",
                Content = "لم يتم العثور على الشريف",
                Duration = 3
            })
        end
    end
})

-- قائمة اختيار للاعبين
local function GetPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local SelectedPlayerToKill = nil

local PlayerKillDropdown = KillerTab:AddDropdown({
    Name = "اختر لاعب للقتل",
    Default = GetPlayerNames()[1] or "",
    Options = GetPlayerNames(),
    Callback = function(Value)
        SelectedPlayerToKill = Value
    end
})

-- تحديث القائمة
local function UpdateKillDropdown()
    PlayerKillDropdown:NewOptions(GetPlayerNames())
end

Players.PlayerAdded:Connect(UpdateKillDropdown)
Players.PlayerRemoving:Connect(UpdateKillDropdown)

-- زر قتل اللاعب المحدد
KillerTab:AddButton({
    Name = "قتل اللاعب المحدد",
    Callback = function()
        if SelectedPlayerToKill then
            local player = Players:FindFirstChild(SelectedPlayerToKill)
            if player and player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                -- قتل اللاعب المحدد
                if Character and Character:FindFirstChild("Knife") then
                    pcall(function()
                        Character.Knife.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, player.Character.HumanoidRootPart.Position, "AH2")
                    end)
                end
                
                Window:Notify({
                    Title = "✅ تم القتل",
                    Content = "تم قتل: " .. player.Name,
                    Duration = 3
                })
            else
                Window:Notify({
                    Title = "❌ خطأ",
                    Content = "لم يتم العثور على اللاعب: " .. (SelectedPlayerToKill or ""),
                    Duration = 3
                })
            end
        else
            Window:Notify({
                Title = "⚠️ تنبيه",
                Content = "يرجى اختيار لاعب أولاً",
                Duration = 3
            })
        end
    end
})



















-- ==================== المرئيات ====================

-- ==================== المرئيات ====================

VisualTab:AddSection("🎭 نظام الرؤية للأدوار")

-- ESP للأدوار (معدّل بألوان أغمق وأكثر وضوحاً)
local ESPEnabled = false
local ESPUpdateLoop = nil

-- قائمة بالألوان (معدلة لألوان أغمق وأكثر قوة)
local RoleColors = {
    Murderer = Color3.fromRGB(180, 0, 0),    -- أحمر داكن للقاتل
    Sheriff = Color3.fromRGB(0, 0, 180),     -- أزرق داكن للشريف
    Hero = Color3.fromRGB(180, 180, 0),      -- أصفر داكن للبطل
    Innocent = Color3.fromRGB(0, 180, 0),    -- أخضر داكن للأبرياء
    Default = Color3.fromRGB(150, 150, 150)  -- رمادي داكن افتراضي
}

local function ClearESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local esp = head:FindFirstChild("RoleESP")
                if esp then 
                    esp:Destroy() 
                end
            end
            
            local highlight = player.Character:FindFirstChild("RoleHighlight")
            if highlight then 
                highlight:Destroy() 
            end
        end
    end
end

local function ApplyHighlight(character, role)
    local existing = character:FindFirstChild("RoleHighlight")
    if existing then 
        existing:Destroy() 
    end
    
    local hl = Instance.new("Highlight")
    hl.Name = "RoleHighlight"
    hl.FillColor = RoleColors[role] or RoleColors.Default
    hl.OutlineColor = Color3.new(1, 1, 1)
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.FillTransparency = 0.4
    hl.OutlineTransparency = 0
    hl.Parent = character
end

local function CreateBillboard(head, role, playerName)
    local esp = Instance.new("BillboardGui")
    esp.Name = "RoleESP"
    esp.Adornee = head
    esp.Size = UDim2.new(5, 0, 5, 0)
    esp.AlwaysOnTop = true
    esp.Parent = head
    
    local label = Instance.new("TextLabel")
    label.Name = "RoleLabel"
    label.Parent = esp
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextStrokeTransparency = 0
    label.TextSize = 14
    label.TextColor3 = RoleColors[role] or RoleColors.Default
    label.Font = Enum.Font.GothamBold
    label.Text = playerName
    label.Parent = esp
end

local function UpdateESP()
    local roles = GetRoles()
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            if head then
                local role = roles[player.Name] or "Default"
                
                if not head:FindFirstChild("RoleESP") then
                    CreateBillboard(head, role, player.Name)
                else
                    local label = head.RoleESP:FindFirstChild("RoleLabel")
                    if label then
                        label.Text = player.Name
                        label.TextColor3 = RoleColors[role] or RoleColors.Default
                    end
                end
                
                local highlight = player.Character:FindFirstChild("RoleHighlight")
                if not highlight then
                    ApplyHighlight(player.Character, role)
                else
                    highlight.FillColor = RoleColors[role] or RoleColors.Default
                end
            end
        end
    end
end

local function StartESP()
    if ESPUpdateLoop then 
        return 
    end
    
    ESPUpdateLoop = task.spawn(function()
        while ESPEnabled do
            pcall(UpdateESP)
            task.wait(0.25)
        end
        
        ClearESP()
        ESPUpdateLoop = nil
    end)
end

VisualTab:AddToggle({
    Name = "تفعيل ESP للأدوار (اسم اللاعب الملون)",
    Default = false,
    Callback = function(Value)
        ESPEnabled = Value
        
        if Value then
            StartESP()
            Window:Notify({
                Title = "👁️ تم تفعيل ESP",
                Content = "تم تفعيل نظام الرؤية للأدوار",
                Duration = 3
            })
        else
            ClearESP()
        end
    end
})























VisualTab:AddSection("🔫 رؤية السلاح")

-- ESP للسلاح
local GunESPEnabled = false

VisualTab:AddToggle({
    Name = "رؤية السلاح على الأرض",
    Default = false,
    Callback = function(Value)
        GunESPEnabled = Value
        
        task.spawn(function()
            while GunESPEnabled do
                local gun = Workspace:FindFirstChild("GunDrop", true)
                
                if gun then
                    if not gun:FindFirstChild("GunHighlight") then
                        local gunHighlight = Instance.new("Highlight", gun)
                        gunHighlight.Name = "GunHighlight"
                        gunHighlight.FillColor = Color3.new(1, 1, 0)
                        gunHighlight.OutlineColor = Color3.new(1, 1, 1)
                        gunHighlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        gunHighlight.FillTransparency = 0.4
                        gunHighlight.OutlineTransparency = 0.5
                    end
                    
                    if not gun:FindFirstChild("GunESP") then
                        local esp = Instance.new("BillboardGui")
                        esp.Name = "GunESP"
                        esp.Adornee = gun
                        esp.Size = UDim2.new(5, 0, 5, 0)
                        esp.AlwaysOnTop = true
                        esp.Parent = gun
                        
                        local text = Instance.new("TextLabel", esp)
                        text.Name = "GunLabel"
                        text.Size = UDim2.new(1, 0, 1, 0)
                        text.BackgroundTransparency = 1
                        text.TextStrokeTransparency = 0
                        text.TextColor3 = Color3.fromRGB(255, 255, 0)
                        text.Font = Enum.Font.GothamBold
                        text.TextSize = 16
                        text.Text = "🔫 مسدس متساقط"
                        text.Parent = esp
                    end
                else
                    -- تنظيف إذا لم يوجد مسدس
                    local oldGun = Workspace:FindFirstChild("GunDrop", true)
                    if oldGun then
                        if oldGun:FindFirstChild("GunHighlight") then
                            oldGun.GunHighlight:Destroy()
                        end
                        if oldGun:FindFirstChild("GunESP") then
                            oldGun.GunESP:Destroy()
                        end
                    end
                end
                
                task.wait(0.1)
            end
            
            -- تنظيف عند الإيقاف
            local gun = Workspace:FindFirstChild("GunDrop", true)
            if gun then
                if gun:FindFirstChild("GunHighlight") then
                    gun.GunHighlight:Destroy()
                end
                if gun:FindFirstChild("GunESP") then
                    gun.GunESP:Destroy()
                end
            end
        end)
        
        if Value then
            Window:Notify({
                Title = "🔫 تم تفعيل رؤية السلاح",
                Content = "يمكنك الآن رؤية السلاح على الأرض",
                Duration = 3
            })
        end
    end
})

-- ==================== تبويب الأسلحة ====================

WeaponsTab:AddSection("🔫 جمع الأسلحة")

WeaponsTab:AddButton({
    Name = "أخذ السلاح",
    Callback = function()
        local gun = Workspace:FindFirstChild("GunDrop", true)
        if gun and HumanoidRootPart then
            if firetouchinterest then
                firetouchinterest(HumanoidRootPart, gun, 0)
                firetouchinterest(HumanoidRootPart, gun, 1)
            else
                gun.CFrame = HumanoidRootPart.CFrame
            end
            
            Window:Notify({
                Title = "✅ تم التقاط السلاح",
                Content = "تم أخذ المسدس بنجاح",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "❌ خطأ",
                Content = "لم يتم العثور على مسدس",
                Duration = 3
            })
        end
    end
})

-- أخذ تلقائي للسلاح
local AutoGrabGun = false

WeaponsTab:AddToggle({
    Name = "أخذ السلاح تلقائياً",
    Default = false,
    Callback = function(Value)
        AutoGrabGun = Value
        
        task.spawn(function()
            while AutoGrabGun do
                if Character and HumanoidRootPart then
                    local gun = Workspace:FindFirstChild("GunDrop", true)
                    if gun then
                        if firetouchinterest then
                            firetouchinterest(HumanoidRootPart, gun, 0)
                            firetouchinterest(HumanoidRootPart, gun, 1)
                        else
                            gun.CFrame = HumanoidRootPart.CFrame
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
        
        if Value then
            Window:Notify({
                Title = "🔄 تم تفعيل الأخذ التلقائي",
                Content = "سيتم أخذ السلاح تلقائياً",
                Duration = 3
            })
        end
    end
})

WeaponsTab:AddButton({
    Name = "سرقة السلاح من الشريف/البطل",
    Callback = function()
        if Character and Humanoid and Backpack then
            local stolen = false
            
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    -- البحث في الشخصية
                    if player.Character and player.Character:FindFirstChild("Gun") then
                        player.Character:FindFirstChild("Gun").Parent = Character
                        Humanoid:EquipTool(Character:FindFirstChild("Gun"))
                        Humanoid:UnequipTools()
                        stolen = true
                        break
                    
                    -- البحث في الحقيبة
                    elseif player:FindFirstChild("Backpack") and player.Backpack:FindFirstChild("Gun") then
                        player.Backpack:FindFirstChild("Gun").Parent = Backpack
                        Humanoid:EquipTool(Backpack:FindFirstChild("Gun"))
                        Humanoid:UnequipTools()
                        stolen = true
                        break
                    end
                end
            end
            
            if stolen then
                Window:Notify({
                    Title = "😈 تمت السرقة",
                    Content = "تمت سرقة السلاح بنجاح",
                    Duration = 3
                })
            else
                Window:Notify({
                    Title = "❌ خطأ",
                    Content = "لم يتم العثور على مسدس للسرقة",
                    Duration = 3
                })
            end
        end
    end
})

























-- ==================== تبويب الأسلحة ====================












WeaponsTab:AddSection("🎯 التصويب")

-- زر إطلاق النار على القاتل
local ShootMurderButtonEnabled = false
local lastShotTime = 0
local SHOT_COOLDOWN = 0.2
local autoShootActive = false
local shootConnection = nil
local aimbotConnection = nil

-- دالة الإطلاق المباشرة والمحسنة
local function QuickShoot()
    if tick() - lastShotTime < SHOT_COOLDOWN then return false end
    
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    
    if not character then 
        character = player.CharacterAdded:Wait()
        task.wait(0.1)
    end
    
    if not character then return false end
    
    -- أخذ السلاح من الحقيبة
    local gun = character:FindFirstChild("Gun")
    if not gun then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item.Name == "Gun" then
                    item.Parent = character
                    gun = item
                    task.wait(0.1)
                    break
                end
            end
        end
    end
    
    gun = character:FindFirstChild("Gun")
    if not gun then
        warn("⚠️ لا يوجد سلاح!")
        return false
    end
    
    -- البحث عن القاتل
    local Players = game:GetService("Players")
    local targetPos = nil
    
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherChar = otherPlayer.Character
            local humanoid = otherChar:FindFirstChild("Humanoid")
            
            if humanoid and humanoid.Health > 0 then
                local isMurderer = otherChar:FindFirstChild("Knife") or 
                                  (otherPlayer:FindFirstChild("Backpack") and 
                                   otherPlayer.Backpack:FindFirstChild("Knife"))
                
                if isMurderer then
                    local head = otherChar:FindFirstChild("Head")
                    if head then
                        local root = otherChar:FindFirstChild("HumanoidRootPart")
                        local velocity = root and root.Velocity or Vector3.new(0,0,0)
                        targetPos = head.Position + (velocity * 0.15) + Vector3.new(0, 0.2, 0)
                        break
                    end
                end
            end
        end
    end
    
    if targetPos then
        local success = pcall(function()
            if gun:FindFirstChild("KnifeLocal") then
                gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, targetPos, "AH2")
            elseif gun:FindFirstChild("RemoteFunction") then
                gun.RemoteFunction:InvokeServer("Fire", targetPos)
            end
        end)
        
        if success then
            lastShotTime = tick()
            return true
        end
    end
    
    return false
end

local function StartAimbot()
    if aimbotConnection then return end
    
    aimbotConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not ShootMurderButtonEnabled then return end
        
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        if not character then return end
        
        local gun = character:FindFirstChild("Gun")
        if gun then
            local Players = game:GetService("Players")
            local targetPos = nil
            
            for _, otherPlayer in ipairs(Players:GetPlayers()) do
                if otherPlayer ~= player and otherPlayer.Character then
                    local otherChar = otherPlayer.Character
                    local humanoid = otherChar:FindFirstChild("Humanoid")
                    
                    if humanoid and humanoid.Health > 0 then
                        local isMurderer = otherChar:FindFirstChild("Knife") or 
                                          (otherPlayer:FindFirstChild("Backpack") and 
                                           otherPlayer.Backpack:FindFirstChild("Knife"))
                        
                        if isMurderer then
                            local head = otherChar:FindFirstChild("Head")
                            if head then
                                local root = otherChar:FindFirstChild("HumanoidRootPart")
                                local velocity = root and root.Velocity or Vector3.new(0,0,0)
                                targetPos = head.Position + (velocity * 0.15) + Vector3.new(0, 0.2, 0)
                                break
                            end
                        end
                    end
                end
            end
            
            if targetPos then
                pcall(function()
                    if gun:FindFirstChild("KnifeLocal") then
                        gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, targetPos, "AH2")
                    elseif gun:FindFirstChild("RemoteFunction") then
                        gun.RemoteFunction:InvokeServer("Fire", targetPos)
                    end
                end)
                lastShotTime = tick()
            end
        end
    end)
end




























-- ==================== زر إطلاق النار البسيط ====================
WeaponsTab:AddSection("🎯 التصويب السريع")

-- زر إطلاق النار على القاتل
local ShootMurderButtonEnabled = false
local lastShotTime = 0
local SHOT_COOLDOWN = 0.1
local lastMurderer = nil

-- 🎯 دالة البحث السريع عن القاتل
local function FindMurdererQuick()
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    -- أولاً: تحقق من القاتل السابق إذا كان لا يزال موجوداً
    if lastMurderer and lastMurderer.Parent and lastMurderer.Character then
        local char = lastMurderer.Character
        local humanoid = char:FindFirstChild("Humanoid")
        local head = char:FindFirstChild("Head")
        
        if humanoid and humanoid.Health > 0 and head then
            local isMurderer = char:FindFirstChild("Knife") or 
                              (lastMurderer:FindFirstChild("Backpack") and 
                               lastMurderer.Backpack:FindFirstChild("Knife"))
            
            if isMurderer then
                local root = char:FindFirstChild("HumanoidRootPart")
                local velocity = root and root.Velocity or Vector3.new(0,0,0)
                return head.Position + (velocity * 0.1) + Vector3.new(0, 0.15, 0)
            end
        end
    end
    
    -- ثانياً: بحث سريع عن أي قاتل
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local char = player.Character
            local humanoid = char:FindFirstChild("Humanoid")
            local head = char:FindFirstChild("Head")
            
            if humanoid and humanoid.Health > 0 and head then
                local isMurderer = char:FindFirstChild("Knife") or 
                                  (player:FindFirstChild("Backpack") and 
                                   player.Backpack:FindFirstChild("Knife"))
                
                if isMurderer then
                    lastMurderer = player
                    local root = char:FindFirstChild("HumanoidRootPart")
                    local velocity = root and root.Velocity or Vector3.new(0,0,0)
                    return head.Position + (velocity * 0.1) + Vector3.new(0, 0.15, 0)
                end
            end
        end
    end
    
    return nil
end

-- ⚡ دالة الإطلاق السريعة
local function QuickShoot()
    if tick() - lastShotTime < SHOT_COOLDOWN then return false end
    
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character
    
    if not character then return false end
    
    -- البحث عن السلاح
    local gun = character:FindFirstChild("Gun")
    if not gun then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item.Name == "Gun" then
                    item.Parent = character
                    gun = item
                    task.wait(0.05)
                    break
                end
            end
        end
    end
    
    if not gun then return false end
    
    -- البحث عن القاتل
    local targetPos = FindMurdererQuick()
    if not targetPos then return false end
    
    -- الإطلاق
    local success = pcall(function()
        if gun:FindFirstChild("KnifeLocal") then
            gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, targetPos, "AH2")
        elseif gun:FindFirstChild("RemoteFunction") then
            gun.RemoteFunction:InvokeServer("Fire", targetPos)
        end
    end)
    
    if success then
        lastShotTime = tick()
        return true
    end
    
    return false
end

WeaponsTab:AddToggle({
    Name = "🎯 زر إطلاق دائري",
    Default = false,
    Callback = function(Value)
        ShootMurderButtonEnabled = Value
        
        local guip = game:GetService("CoreGui")
        if gethui then
            guip = gethui()
        end
        
        if Value then
            if guip:FindFirstChild("ShootCircleButton") then
                guip:FindFirstChild("ShootCircleButton"):Destroy()
            end
            
            -- 🎯 إنشاء زر دائري صغير
            local ScreenGui = Instance.new("ScreenGui", guip)
            ScreenGui.Name = "ShootCircleButton"
            ScreenGui.ResetOnSpawn = false
            ScreenGui.IgnoreGuiInset = true
            
            -- 🔴 زر دائري أحمر
            local CircleButton = Instance.new("TextButton", ScreenGui)
            CircleButton.Name = "CircleButton"
            CircleButton.Draggable = true
            CircleButton.Active = true
            CircleButton.Position = UDim2.new(0.85, 0, 0.7, 0) -- زاوية الشاشة
            CircleButton.Size = UDim2.new(0, 50, 0, 50) -- دائرة صغيرة
            CircleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- أحمر
            CircleButton.TextColor3 = Color3.new(1, 1, 1)
            CircleButton.Text = "🔫"
            CircleButton.TextSize = 20
            CircleButton.Font = Enum.Font.GothamBold
            CircleButton.AutoButtonColor = true
            
            -- جعله دائري
            local CircleCorner = Instance.new("UICorner", CircleButton)
            CircleCorner.CornerRadius = UDim.new(1, 0) -- دائري كامل
            
            -- ظل أبيض حول الدائرة
            local CircleStroke = Instance.new("UIStroke", CircleButton)
            CircleStroke.Color = Color3.new(1, 1, 1)
            CircleStroke.Thickness = 2
            
            -- ✨ تأثير توهج أحمر
            local GlowEffect = Instance.new("ImageLabel", CircleButton)
            GlowEffect.Name = "GlowEffect"
            GlowEffect.BackgroundTransparency = 1
            GlowEffect.Size = UDim2.new(1, 10, 1, 10)
            GlowEffect.Position = UDim2.new(0, -5, 0, -5)
            GlowEffect.Image = "rbxassetid://4896580806" -- تأثير توهج
            GlowEffect.ImageColor3 = Color3.fromRGB(255, 100, 100)
            GlowEffect.ImageTransparency = 0.7
            GlowEffect.ZIndex = -1
            
            -- ⚡ حدث الضغط
            local isPressing = false
            
            CircleButton.MouseButton1Click:Connect(function()
                local success = QuickShoot()
                if success then
                    -- تأثير عند النجاح
                    CircleButton.BackgroundColor3 = Color3.fromRGB(50, 255, 50) -- أخضر
                    CircleButton.Text = "✅"
                    task.wait(0.2)
                    CircleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- يعود أحمر
                    CircleButton.Text = "🔫"
                else
                    -- تأثير عند الفشل
                    CircleButton.BackgroundColor3 = Color3.fromRGB(255, 150, 50) -- برتقالي
                    CircleButton.Text = "❌"
                    task.wait(0.3)
                    CircleButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                    CircleButton.Text = "🔫"
                end
            end)
            
            -- 🔄 الضغط المطول للإطلاق السريع
            CircleButton.MouseButton1Down:Connect(function()
                isPressing = true
                task.spawn(function()
                    task.wait(0.2) -- انتظر قليلاً ثم ابدأ بالإطلاق المتكرر
                    while isPressing and ShootMurderButtonEnabled do
                        QuickShoot()
                        task.wait(0.15) -- إطلاق متكرر
                    end
                end)
            end)
            
            CircleButton.MouseButton1Up:Connect(function()
                isPressing = false
            end)
            
            CircleButton.MouseLeave:Connect(function()
                isPressing = false
            end)
            
                    else
            if guip:FindFirstChild("ShootCircleButton") then
                guip:FindFirstChild("ShootCircleButton"):Destroy()
            end
        end
    end
})

-- ⚙️ إعدادات بسيطة
WeaponsTab:AddSlider({
    Name = "سرعة الإطلاق",
    Min = 0.05,
    Max = 0.3,
    Default = 0.1,
    Increment = 0.01,
    Callback = function(Value)
        SHOT_COOLDOWN = Value
    end
})










            










-- ==================== تبويب القذف ====================

FlingTab:AddSection("💨 قذف حسب الدور")






















FlingTab:AddButton({
    Name = "قذف القاتل",
    Callback = function()
        local roles = GetRoles()
        local found = false
        
        for playerName, role in pairs(roles) do
            if role == "Murderer" then
                local murderer = Players:FindFirstChild(playerName)
                if murderer and murderer ~= LocalPlayer then
                    SHubFling(murderer)
                    found = true
                    
                    Window:Notify({
                        Title = "💨 تم قذف القاتل",
                        Content = "تم قذف: " .. murderer.Name,
                        Duration = 3
                    })
                    break
                end
            end
        end
        
        if not found then
            Window:Notify({
                Title = "❌ خطأ",
                Content = "لم يتم العثور على القاتل",
                Duration = 3
            })
        end
    end
})

















FlingTab:AddButton({
    Name = "قذف الشريف/البطل",
    Callback = function()
        local roles = GetRoles()
        local found = false
        
        for playerName, role in pairs(roles) do
            if role == "Sheriff" or role == "Hero" then
                local target = Players:FindFirstChild(playerName)
                if target and target ~= LocalPlayer then
                    SHubFling(target)
                    found = true
                    
                    Window:Notify({
                        Title = "💨 تم القذف",
                        Content = "تم قذف: " .. target.Name .. " (" .. role .. ")",
                        Duration = 3
                    })
                    break
                end
            end
        end
        
        if not found then
            Window:Notify({
                Title = "❌ خطأ",
                Content = "لم يتم العثور على الشريف أو البطل",
                Duration = 3
            })
        end
    end
})
















FlingTab:AddSection("🔥 قذف الكل (الأبادة)")

local FlingAllEnabled = false
local FlingAllLoop = nil

FlingTab:AddToggle({
    Name = "قذف جميع اللاعبين",
    Default = false,
    Callback = function(Value)
        FlingAllEnabled = Value
        
        if Value then
            FlingAllLoop = task.spawn(function()
                while FlingAllEnabled do
                    local roles = GetRoles()
                    local flungCount = 0
                    
                    for playerName, role in pairs(roles) do
                        local player = Players:FindFirstChild(playerName)
                        if player and player ~= LocalPlayer then
                            SHubFling(player)
                            flungCount = flungCount + 1
                            task.wait(0.05) -- تم تقليل الوقت من 0.2 إلى 0.05 لجعل القذف أسرع
                        end
                    end
                    
                    if flungCount > 0 then
                        Window:Notify({
                            Title = "💥 قذف مستمر",
                            Content = "تم قذف " .. flungCount .. " لاعب/لاعبين في هذه الدورة",
                            Duration = 2
                        })
                    end
                    
                    task.wait(1) -- تم تقليل الوقت من 3 إلى 1 ثانية
                end
            end)
            
            Window:Notify({
                Title = "🔥 تم تفعيل قذف الكل",
                Content = "سيتم قذف جميع اللاعبين بشكل مستمر",
                Duration = 3
            })
        else
            if FlingAllLoop then
                FlingAllLoop:Cancel()
                FlingAllLoop = nil
            end
            
            Window:Notify({
                Title = "🛑 تم إيقاف قذف الكل",
                Content = "تم إيقاف قذف جميع اللاعبين",
                Duration = 3
            })
        end
    end
})






















FlingTab:AddSection("🎯 قذف لاعب محدد")

-- قائمة اللاعبين
local function GetPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local SelectedPlayer = nil

local PlayerDropdown = FlingTab:AddDropdown({
    Name = "اختر لاعب",
    Default = GetPlayerNames()[1] or "",
    Options = GetPlayerNames(),
    Callback = function(Value)
        SelectedPlayer = Value
    end
})

-- تحديث القائمة
local function UpdateDropdown()
    PlayerDropdown:NewOptions(GetPlayerNames())
end

Players.PlayerAdded:Connect(UpdateDropdown)
Players.PlayerRemoving:Connect(UpdateDropdown)












FlingTab:AddSection("🎯 قذف لاعب محدد")

-- متغيرات
local SelectedPlayer = nil
local FlingDuration = 2.5 -- قيمة افتراضية

-- قائمة اللاعبين
local function GetPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

-- الدالة المحسنة مع إضافة task.wait() لمنع التجميد
local function SafeSHubFling(player)
    if not player or not player.Character then return end
    
    task.spawn(function()
        SHubFling(player)
    end)
end

-- إنشاء Dropdown واحد فقط
local PlayerDropdown = FlingTab:AddDropdown({
    Name = "اختر لاعب",
    Default = "",
    Options = GetPlayerNames(),
    Callback = function(Value)
        SelectedPlayer = Players:FindFirstChild(Value)
    end
})

-- زر القذف
FlingTab:AddButton({
    Name = "قذف اللاعب المحدد",
    Callback = function()
        if not SelectedPlayer then
            Window:Notify({
                Title = "⚠️ تحذير",
                Content = "لم يتم اختيار لاعب",
                Duration = 3
            })
            return
        end
        
        if SelectedPlayer == LocalPlayer then
            Window:Notify({
                Title = "❌ خطأ",
                Content = "لا يمكنك قذف نفسك!",
                Duration = 3
            })
            return
        end
        
        -- استخدام الدالة المحسنة
        SafeSHubFling(SelectedPlayer)
        
        Window:Notify({
            Title = "💨 تم القذف",
            Content = "تم قذف: " .. SelectedPlayer.Name,
            Duration = 3
        })
    end
})

-- تحديث القائمة تلقائياً
local function UpdateDropdown()
    PlayerDropdown:NewOptions(GetPlayerNames())
    SelectedPlayer = nil -- إعادة تعيين عند تحديث اللاعبين
end

Players.PlayerAdded:Connect(function(player)
    UpdateDropdown()
end)

Players.PlayerRemoving:Connect(function(player)
    if player == SelectedPlayer then
        SelectedPlayer = nil
    end
    task.wait(0.1) -- تأخير بسيط قبل التحديث
    UpdateDropdown()
end)

-- تحديث أولي
UpdateDropdown()

FlingTab:AddSection("⚙️ إعدادات القذف")

-- وقت القذف
FlingTab:AddSlider({
    Name = "وقت القذف (بالثواني)",
    Min = 0.5,
    Max = 10,
    Default = 2.5,
    Increment = 0.1,
    Callback = function(Value)
        FlingDuration = Value
        Window:Notify({
            Title = "⏱️ تم ضبط الوقت",
            Content = "تم ضبط وقت القذف إلى " .. Value .. " ثانية",
            Duration = 3
        })
    end
})









-- قذف باللمس
local TouchFlingEnabled = false

FlingTab:AddToggle({
    Name = "قذف باللمس",
    Default = false,
    Callback = function(Value)
        TouchFlingEnabled = Value
        
        task.spawn(function()
            while TouchFlingEnabled do
                RunService.Heartbeat:Wait()
                local vel = HumanoidRootPart.Velocity
                HumanoidRootPart.Velocity = vel * 9e8 + Vector3.new(0, 9e8, 0)
                
                RunService.RenderStepped:Wait()
                if Character and Character.Parent and HumanoidRootPart and HumanoidRootPart.Parent then
                    HumanoidRootPart.Velocity = vel
                end
                
                RunService.Stepped:Wait()
                if Character and Character.Parent and HumanoidRootPart and HumanoidRootPart.Parent then
                    local movel = 0.1
                    HumanoidRootPart.Velocity = vel + Vector3.new(0, movel, 0)
                end
            end
        end)
    end
})








-- AntiFling (Noclip للآخرين)
local AntiFlingEnabled = false

FlingTab:AddToggle({
    Name = "Noclip Players (AntiFling)",
    Default = false,
    Callback = function(Value)
        AntiFlingEnabled = Value
        
        if Value then
            -- تفعيل الـ Noclip للجميع
            task.spawn(function()
                while AntiFlingEnabled do
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character then
                            for _, part in ipairs(player.Character:GetDescendants()) do
                                if part:IsA("BasePart") then
                                    part.CanCollide = false
                                end
                            end
                        end
                    end
                    task.wait(0.2)
                end
            end)
        else
            -- إعادة التصادم للجميع
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = true
                        end
                    end
                end
            end
        end
    end
})
























































FlingTab:AddSection("🎯 قذف هدف محدد")

-- زر لزق و قذف لاعب محدد مع رجعة قوية
local AttachedToPlayer = false
local CurrentTarget = nil
local AttachmentLoop = nil
local OriginalPosition = nil

FlingTab:AddButton({
    Name = "🔗 لزق و قذف لاعب (مع رجعة)",
    Callback = function()
        -- إذا كان الزر مفعلاً بالفعل، أوقفه وارجع
        if AttachedToPlayer then
            if AttachmentLoop then
                AttachmentLoop:Disconnect()
                AttachmentLoop = nil
            end
            
            -- الرجعة القوية للمكان الأصلي
            if OriginalPosition and Character and HumanoidRootPart then
                Window:Notify({
                    Title = "↩️ جاري الرجوع",
                    Content = "جاري العودة للمكان الأصلي...",
                    Duration = 2
                })
                
                -- إرجاع قوي ومباشر
                HumanoidRootPart.CFrame = OriginalPosition
                Character:SetPrimaryPartCFrame(OriginalPosition)
                
                -- تأكيد الرجعة
                task.wait(0.1)
                HumanoidRootPart.CFrame = OriginalPosition
                
                -- إيقاف كل الحركات
                HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
                
                -- تنظيف الشخصية من أي حركة
                for _, part in ipairs(Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Velocity = Vector3.new(0, 0, 0)
                        part.RotVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end
            
            AttachedToPlayer = false
            CurrentTarget = nil
            OriginalPosition = nil
            
            Window:Notify({
                Title = "🔗 تم الإيقاف",
                Content = "توقف اللزق وتم الرجوع",
                Duration = 3
            })
            return
        end
        
        -- حفظ المكان الأصلي قبل البدء
        if Character and HumanoidRootPart then
            OriginalPosition = HumanoidRootPart.CFrame
        else
            Window:Notify({
                Title = "❌ خطأ",
                Content = "الشخصية غير موجودة",
                Duration = 3
            })
            return
        end
        
        -- الحصول على أسماء اللاعبين
        local playerNames = {}
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(playerNames, player.Name)
            end
        end
        
        if #playerNames == 0 then
            Window:Notify({
                Title = "⚠️ لا يوجد لاعبين",
                Content = "لا يوجد لاعبين آخرين",
                Duration = 3
            })
            return
        end
        
        -- قائمة اختيار اللاعب
        local selectedPlayerName = nil
        local dropdown = Window:MakeDropdown({
            Title = "اختر لاعب للزق به",
            Options = playerNames,
            Default = playerNames[1],
            Callback = function(Value)
                selectedPlayerName = Value
            end
        })
        
        dropdown:Show()
        
        -- الانتظار حتى يتم الاختيار
        while dropdown:IsVisible() do
            task.wait()
        end
        
        if not selectedPlayerName then
            Window:Notify({
                Title = "⚠️ تم الإلغاء",
                Content = "لم يتم اختيار لاعب",
                Duration = 3
            })
            return
        end
        
        local targetPlayer = Players:FindFirstChild(selectedPlayerName)
        if not targetPlayer or not targetPlayer.Character then
            Window:Notify({
                Title = "❌ خطأ",
                Content = "اللاعب غير موجود",
                Duration = 3
            })
            return
        end
        
        -- بدء اللزق
        AttachedToPlayer = true
        CurrentTarget = targetPlayer
        
        Window:Notify({
            Title = "🔗 تم البدء",
            Content = "جاري اللزق بـ " .. targetPlayer.Name .. " (سوف تعود تلقائياً)",
            Duration = 3
        })
        
        -- حلقة اللزق والقذف مع رجعة تلقائية بعد وقت
        AttachmentLoop = RunService.Heartbeat:Connect(function()
            if not AttachedToPlayer or not CurrentTarget or not CurrentTarget.Character then
                -- الرجعة التلقائية عند انتهاء اللزق
                if OriginalPosition and Character and HumanoidRootPart then
                    HumanoidRootPart.CFrame = OriginalPosition
                    task.wait(0.05)
                    HumanoidRootPart.CFrame = OriginalPosition
                end
                if AttachmentLoop then
                    AttachmentLoop:Disconnect()
                end
                return
            end
            
            -- الحصول على أجزاء الشخصية
            local targetChar = CurrentTarget.Character
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            
            local myChar = Character
            local myRoot = HumanoidRootPart
            
            if not targetRoot or not myRoot then
                return
            end
            
            -- اللزق خلف الظهر
            local backPosition = targetRoot.CFrame * CFrame.new(0, 0, 3)
            
            -- تطبيق اللزق مع حماية من الطيران
            myRoot.CFrame = backPosition
            
            -- حماية من الطيران - إعادة متكررة للمكان
            task.spawn(function()
                for i = 1, 3 do
                    task.wait(0.03)
                    if myRoot then
                        myRoot.CFrame = backPosition
                        myRoot.Velocity = Vector3.new(0, 0, 0)
                        myRoot.RotVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
            
            -- قذف اللاعب المستهدف فقط
            if tick() % 0.5 < 0.05 then
                local flingForce = Vector3.new(
                    math.random(-3000, 3000),
                    math.random(8000, 12000),
                    math.random(-3000, 3000)
                )
                
                if targetRoot then
                    targetRoot.Velocity = flingForce
                end
            end
            
            -- الرجعة التلقائية بعد 15 ثانية (يمكن تغييرها)
            if tick() % 30 < 0.1 then
                AttachedToPlayer = false
                if OriginalPosition and myRoot then
                    -- رجعة قوية وغصب
                    for i = 1, 10 do
                        myRoot.CFrame = OriginalPosition
                        task.wait(0.02)
                    end
                end
            end
        end)
    end
})

-- زر إرجاع قوي وغصب
FlingTab:AddButton({
    Name = "⏪ رجوع قوي للمكان الأصلي",
    Callback = function()
        if not OriginalPosition then
            Window:Notify({
                Title = "❌ لا يوجد مكان محفوظ",
                Content = "ابدأ اللزق أولاً ليتم حفظ مكانك",
                Duration = 3
            })
            return
        end
        
        if not Character or not HumanoidRootPart then
            Window:Notify({
                Title = "❌ خطأ",
                Content = "الشخصية غير موجودة",
                Duration = 3
            })
            return
        end
        
        -- إيقاف أي لزق جاري
        if AttachmentLoop then
            AttachmentLoop:Disconnect()
            AttachmentLoop = nil
        end
        
        AttachedToPlayer = false
        CurrentTarget = nil
        
        -- الرجعة القوية والمتكررة
        Window:Notify({
            Title = "⏪ جاري الرجوع بقوة",
            Content = "جار إعادتك للمكان الأصلي قسراً...",
            Duration = 2
        })
        
        -- إجراءات رجعة قوية
        for i = 1, 15 do
            if HumanoidRootPart then
                HumanoidRootPart.CFrame = OriginalPosition
                HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
                HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)
                
                -- تأكيد الرجعة كل مرة
                task.wait(0.05)
                
                -- إعادة تعيين الكاميرا
                if i == 5 then
                    Workspace.CurrentCamera.CameraSubject = Humanoid
                end
            end
        end
        
        -- تنظيف نهائي
        if Character then
            for _, part in ipairs(Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Velocity = Vector3.new(0, 0, 0)
                    part.RotVelocity = Vector3.new(0, 0, 0)
                    part.CFrame = OriginalPosition * CFrame.new(0, 0, 0)
                end
            end
        end
        
        -- إشعار النجاح
        Window:Notify({
            Title = "✅ تم الرجوع",
            Content = "تم إرجاعك للمكان الأصلي بنجاح",
            Duration = 3
        })
    end
})

-- زر حفظ المكان الحالي
FlingTab:AddButton({
    Name = "📍 حفظ المكان الحالي",
    Callback = function()
        if Character and HumanoidRootPart then
            OriginalPosition = HumanoidRootPart.CFrame
            Window:Notify({
                Title = "📍 تم الحفظ",
                Content = "تم حفظ مكانك الحالي للرجوع إليه",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "❌ خطأ",
                Content = "الشخصية غير موجودة",
                Duration = 3
            })
        end
    end
})

-- مؤقت الرجعة التلقائية
local AutoReturnTime = 15 -- ثانية

FlingTab:AddSlider({
    Name = "وقت الرجعة التلقائية (ثواني)",
    Min = 5,
    Max = 60,
    Default = 15,
    Increment = 5,
    Callback = function(Value)
        AutoReturnTime = Value
        Window:Notify({
            Title = "⏱️ تم الضبط",
            Content = "سيتم الرجوع بعد " .. Value .. " ثانية",
            Duration = 3
        })
    end
})



















-- التعامل مع لاعبين جدد أو يغادرون
Players.PlayerAdded:Connect(function(player)
    if AntiFlingEnabled and player.Character then
        -- تعيين CanCollide إلى true لللاعب الجديد
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(player)
    -- مسح بيانات اللاعب عند مغادرته
    if OriginalCanCollide[player] then
        OriginalCanCollide[player] = nil
    end
end)

-- التعامل مع تغيير الشخصية ( respawn )
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if AntiFlingEnabled and player ~= LocalPlayer then
            -- تعيين CanCollide إلى true للشخصية الجديدة
            task.wait(0.1) -- الانتظار قليلاً حتى يتم تحميل الشخصية
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end)
end)





-- وقت القذف
FlingTab:AddSlider({
    Name = "وقت القذف (بالثواني)",
    Min = 0.5,
    Max = 10,
    Default = 2.5,
    Increment = 0.1,
    Callback = function(Value)
        Window:Notify({
            Title = "⏱️ تم ضبط الوقت",
            Content = "تم ضبط وقت القذف إلى " .. Value .. " ثانية",
            Duration = 3
        })
    end
})





















-- ==================== تبويب اللاعب ====================

PlayerTab:AddSection("🧑 حركة اللاعب")

-- القفز اللانهائي
local InfiniteJumpEnabled = false

PlayerTab:AddToggle({
    Name = "القفز اللانهائي",
    Default = false,
    Callback = function(Value)
        InfiniteJumpEnabled = Value
        
        if Value then
            Window:Notify({
                Title = "🦘 تم تفعيل القفز اللانهائي",
                Content = "يمكنك القفز دون توقف",
                Duration = 3
            })
        end
    end
})

-- المرور عبر الجدران
local NoclipEnabled = false

PlayerTab:AddToggle({
    Name = "المرور عبر الجدران",
    Default = false,
    Callback = function(Value)
        NoclipEnabled = Value
        
        if not Value then
            if Character then
                for _, part in ipairs(Character:GetChildren()) do
                    if part:IsA("BasePart") and not part.CanCollide then
                        part.CanCollide = true
                    end
                end
            end
        end
        
        if Value then
            Window:Notify({
                Title = "🚶 تم تفعيل المرور عبر الجدران",
                Content = "يمكنك الآن المشي عبر الجدران",
                Duration = 3
            })
        end
    end
})


PlayerTab:AddSection("⚡ إعدادات الحركة")

-- سرعة المشي
local WalkSpeed = 16
local KeepWalkSpeed = false

PlayerTab:AddTextBox({
    Name = "سرعة المشي",
    Default = "16",
    TextDisappear = false,
    Callback = function(Value)
        local speed = tonumber(Value)
        if speed and speed >= 16 and speed <= 350 then
            WalkSpeed = speed
            if Humanoid then
                Humanoid.WalkSpeed = speed
            end
            
            Window:Notify({
                Title = "✅ تم تغيير السرعة",
                Content = "سرعة المشي: " .. speed,
                Duration = 2
            })
        else
            Window:Notify({
                Title = "❌ خطأ",
                Content = "يرجى إدخال رقم بين 16 و 350",
                Duration = 3
            })
        end
    end
})

-- تبديل الحفاظ على السرعة
PlayerTab:AddToggle({
    Name = "الحفاظ على سرعة المشي",
    Default = false,
    Callback = function(Value)
        KeepWalkSpeed = Value
        if Value then
            if Humanoid then
                Humanoid.WalkSpeed = WalkSpeed
            end
            Window:Notify({
                Title = "🔒 تم تفعيل الحفاظ",
                Content = "سيتم الحفاظ على سرعة المشي: " .. WalkSpeed,
                Duration = 3
            })
        else
            Window:Notify({
                Title = "🔓 تم إيقاف الحفاظ",
                Content = "تم إيقاف الحفاظ على سرعة المشي",
                Duration = 3
            })
        end
    end
})

-- تطبيق السرعة تلقائياً عند تغيير الشخصية
Players.LocalPlayer.CharacterAdded:Connect(function(character)
    if KeepWalkSpeed and character:FindFirstChildOfClass("Humanoid") then
        task.wait(0.5) -- الانتظار قليلاً حتى يتم تحميل الشخصية
        character:FindFirstChildOfClass("Humanoid").WalkSpeed = WalkSpeed
    end
end)



-- قوة القفز
local JumpPower = 50
local KeepJumpPower = false

PlayerTab:AddTextBox({
    Name = "قوة القفز",
    Default = "50",
    TextDisappear = false,
    Callback = function(Value)
        local power = tonumber(Value)
        if power and power >= 50 and power <= 500 then
            JumpPower = power
            if Humanoid then
                Humanoid.JumpPower = power
            end
            
            Window:Notify({
                Title = "✅ تم تغيير قوة القفز",
                Content = "قوة القفز: " .. power,
                Duration = 2
            })
        else
            Window:Notify({
                Title = "❌ خطأ",
                Content = "يرجى إدخال رقم بين 50 و 500",
                Duration = 3
            })
        end
    end
})


-- تطبيق قوة القفز تلقائياً عند تغيير الشخصية
Players.LocalPlayer.CharacterAdded:Connect(function(character)
    if KeepJumpPower and character:FindFirstChildOfClass("Humanoid") then
        task.wait(0.5) -- الانتظار قليلاً حتى يتم تحميل الشخصية
        character:FindFirstChildOfClass("Humanoid").JumpPower = JumpPower
    end
end)





-- ==================== تبويب الانتقال ====================

TeleportTab:AddSection("📍 مواقع رئيسية")

TeleportTab:AddButton({
    Name = "الانتقال إلى الخريطة",
    Callback = function()
        local map = Workspace:FindFirstChild("CoinContainer", true)
        if map then
            local part = map:FindFirstChildWhichIsA("BasePart", true)
            if part and HumanoidRootPart then
                HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 2, 0)
                
                Window:Notify({
                    Title = "✅ تم الانتقال",
                    Content = "انتقلت إلى الخريطة بنجاح",
                    Duration = 3
                })
            else
                Window:Notify({
                    Title = "❌ خطأ",
                    Content = "لم يتم العثور على الخريطة",
                    Duration = 3
                })
            end
        end
    end
})

TeleportTab:AddButton({
    Name = "الانتقال إلى اللوبي",
    Callback = function()
        local lobby = Workspace:FindFirstChild("Lobby", true)
        if lobby then
            local part = lobby:FindFirstChildWhichIsA("BasePart", true)
            if part and HumanoidRootPart then
                HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 2, 0)
                
                Window:Notify({
                    Title = "✅ تم الانتقال",
                    Content = "انتقلت إلى اللوبي بنجاح",
                    Duration = 3
                })
            else
                Window:Notify({
                    Title = "❌ خطأ",
                    Content = "لم يتم العثور على اللوبي",
                    Duration = 3
                })
            end
        end
    end
})

















-- ميزة حفظ الموقع الحالي
TeleportTab:AddSection("💾 حفظ الموقع")

local SavedPosition = nil
local SavedPositionName = ""

TeleportTab:AddButton({
    Name = "📌 حفظ الموقع الحالي",
    Callback = function()
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            SavedPosition = LocalPlayer.Character.HumanoidRootPart.Position
            SavedPositionName = "الموقع المحفوظ"
            
            Window:Notify({
                Title = "✅ تم الحفظ",
                Content = "تم حفظ موقعك الحالي بنجاح",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "❌ خطأ",
                Content = "لا يمكنك حفظ الموقع حالياً",
                Duration = 3
            })
        end
    end
})

TeleportTab:AddButton({
    Name = "🔙 العودة إلى الموقع المحفوظ",
    Callback = function()
        if SavedPosition then
            LocalPlayer.Character:MoveTo(SavedPosition)
            
            Window:Notify({
                Title = "✅ تم الانتقال",
                Content = "تم العودة إلى الموقع المحفوظ",
                Duration = 3
            })
        else
            Window:Notify({
                Title = "⚠️ ملاحظة",
                Content = "لم يتم حفظ أي موقع بعد",
                Duration = 3
            })
        end
    end
})

-- ميزة الانتقال إلى أدوار محددة
TeleportTab:AddSection("🎯 الانتقال إلى أدوار")

TeleportTab:AddButton({
    Name = "🩸 انتقال إلى القاتل",
    Callback = function()
        local roles = GetRoles()
        local found = false
        
        for playerName, role in pairs(roles) do
            if role == "Murderer" then
                local murderer = Players:FindFirstChild(playerName)
                if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:MoveTo(murderer.Character.HumanoidRootPart.Position)
                    found = true
                    
                    Window:Notify({
                        Title = "✅ تم الانتقال",
                        Content = "تم الانتقال إلى القاتل: " .. murderer.Name,
                        Duration = 3
                    })
                    break
                end
            end
        end
        
        if not found then
            Window:Notify({
                Title = "❌ خطأ",
                Content = "لم يتم العثور على القاتل",
                Duration = 3
            })
        end
    end
})

TeleportTab:AddButton({
    Name = "🛡️ انتقال إلى الشريف/البطل",
    Callback = function()
        local roles = GetRoles()
        local found = false
        
        for playerName, role in pairs(roles) do
            if role == "Sheriff" or role == "Hero" then
                local target = Players:FindFirstChild(playerName)
                if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position)
                    found = true
                    
                    Window:Notify({
                        Title = "✅ تم الانتقال",
                        Content = "تم الانتقال إلى: " .. target.Name .. " (" .. role .. ")",
                        Duration = 3
                    })
                    break
                end
            end
        end
        
        if not found then
            Window:Notify({
                Title = "❌ خطأ",
                Content = "لم يتم العثور على الشريف أو البطل",
                Duration = 3
            })
        end
    end
})









-- ميزة الانتقال إلى لاعب محدد
TeleportTab:AddSection("👤 انتقال إلى لاعب")

-- قائمة اللاعبين
local function GetPlayerNames()
    local names = {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            table.insert(names, player.Name)
        end
    end
    return names
end

local SelectedPlayer = nil

-- قائمة منسدلة لاختيار اللاعب
local PlayerDropdown = TeleportTab:AddDropdown({
    Name = "اختر لاعب للانتقال إليه",
    Default = GetPlayerNames()[1] or "",
    Options = GetPlayerNames(),
    Callback = function(Value)
        SelectedPlayer = Value
    end
})

-- زر الانتقال
TeleportTab:AddButton({
    Name = "🚀 انتقل إلى اللاعب المختار",
    Callback = function()
        if SelectedPlayer then
            local targetPlayer = Players:FindFirstChild(SelectedPlayer)
            if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
                -- الانتقال إلى اللاعب المختار
                LocalPlayer.Character:MoveTo(targetPlayer.Character.HumanoidRootPart.Position)
                
                Window:Notify({
                    Title = "✅ تم الانتقال",
                    Content = "تم الانتقال إلى: " .. targetPlayer.Name,
                    Duration = 3
                })
            else
                Window:Notify({
                    Title = "❌ خطأ",
                    Content = "اللاعب '" .. SelectedPlayer .. "' غير موجود أو لا يملك شخصية",
                    Duration = 3
                })
            end
        else
            Window:Notify({
                Title = "⚠️ ملاحظة",
                Content = "يرجى اختيار لاعب أولاً",
                Duration = 3
            })
        end
    end
})

-- تحديث القائمة تلقائياً عند دخول أو خروج لاعبين
local function UpdateDropdown()
    PlayerDropdown:NewOptions(GetPlayerNames())
end

Players.PlayerAdded:Connect(UpdateDropdown)
Players.PlayerRemoving:Connect(UpdateDropdown)










-- ميزة الانتقال السريع
TeleportTab:AddSection("⚡ انتقالات سريعة")

TeleportTab:AddButton({
    Name = "🏠 الانتقال إلى Spawn",
    Callback = function()
        LocalPlayer.Character:MoveTo(Vector3.new(0, 100, 0)) -- إحداثيات Spawn الافتراضية
        
        Window:Notify({
            Title = "✅ تم الانتقال",
            Content = "تم الانتقال إلى Spawn",
            Duration = 3
        })
    end
})

TeleportTab:AddButton({
    Name = "👥 الانتقال إلى أقرب لاعب",
    Callback = function()
        local closestPlayer = nil
        local shortestDistance = math.huge
        
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
        
        if closestPlayer then
            LocalPlayer.Character:MoveTo(closestPlayer.Character.HumanoidRootPart.Position)
            
            Window:Notify({
                Title = "✅ تم الانتقال",
                Content = "تم الانتقال إلى أقرب لاعب: " .. closestPlayer.Name,
                Duration = 3
            })
        else
            Window:Notify({
                Title = "❌ خطأ",
                Content = "لا توجد لاعبين آخرين متواجدين",
                Duration = 3
            })
        end
    end
})



































-- ==================== تبويب السكربتات ====================

ScriptsTab:AddSection("📁 تحميل سكربتات خارجية")


ScriptsTab:AddButton({
    Name = "تحميل Infinite Yield",
    Callback = function()
        Window:Dialog({
            Title = "⚠️ تأكيد التحميل",
            Content = "هل تريد تحميل سكربت Infinite Yield؟",
            Options = {
                {
                    Name = "❌ إلغاء",
                    Callback = function()
                        Window:Notify({
                            Title = "تم الإلغاء",
                            Content = "تم إلغاء تحميل Infinite Yield",
                            Duration = 2
                        })
                    end
                },
                {
                    Name = "✅ تأكيد",
                    Callback = function()
                        loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
                        
                        Window:Notify({
                            Title = "✅ تم التحميل",
                            Content = "تم تحميل Infinite Yield بنجاح",
                            Duration = 3
                        })
                    end
                }
            }
        })
    end
})

ScriptsTab:AddSection("🔗 سكربتات مخصصة")

local CustomScriptURL = ""

ScriptsTab:AddTextBox({
    Name = "رابط السكربت المخصص",
    Placeholder = "أدخل رابط السكربت هنا...",
    Callback = function(Text)
        CustomScriptURL = Text
    end
})

ScriptsTab:AddButton({
    Name = "تحميل السكربت المخصص",
    Callback = function()
        if CustomScriptURL == "" then
            Window:Notify({
                Title = "⚠️ تنبيه",
                Content = "يرجى إدخال رابط السكربت أولاً",
                Duration = 3
            })
            return
        end
        
        Window:Dialog({
            Title = "⚠️ تأكيد التحميل",
            Content = "هل تريد تحميل السكربت المخصص؟",
            Options = {
                {
                    Name = "❌ إلغاء",
                    Callback = function()
                        Window:Notify({
                            Title = "تم الإلغاء",
                            Content = "تم إلغاء تحميل السكربت",
                            Duration = 2
                        })
                    end
                },
                {
                    Name = "✅ تأكيد",
                    Callback = function()
                        local success, errorMessage = pcall(function()
                            loadstring(game:HttpGet(CustomScriptURL))()
                        end)
                        
                        if success then
                            Window:Notify({
                                Title = "✅ تم التحميل",
                                Content = "تم تحميل السكربت بنجاح",
                                Duration = 3
                            })
                        else
                            Window:Notify({
                                Title = "❌ خطأ",
                                Content = "فشل في تحميل السكربت: " .. tostring(errorMessage),
                                Duration = 5
                            })
                        end
                    end
                }
            }
        })
    end
})
















-- ==================== تبويب الإعدادات ====================

SettingsTab:AddSection("⚙️ إعدادات الواجهة")

SettingsTab:AddSlider({
    Name = "حجم الواجهة",
    Min = 0.6,
    Max = 1.6,
    Default = 1.0,
    Increment = 0.1,
    Callback = function(Value)
        Library:SetUIScale(Value)
    end
})

SettingsTab:AddSection("📊 معلومات النظام")

local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local Executor = identifyexecutor and identifyexecutor() or getexecutorname and getexecutorname() or "غير معروف"

SettingsTab:AddParagraph("معلومات اللعبة", 
    "🎮 اسم اللعبة: " .. GameName .. "\n" ..
    "🆔 رقم اللعبة: " .. game.PlaceId .. "\n" ..
    "👤 اسم اللاعب: " .. LocalPlayer.Name .. "\n" ..
    "⚡ المشغل: " .. Executor .. "\n" ..
    "🕐 الوقت: " .. os.date("%I:%M %p")
)

SettingsTab:AddParagraph("معلومات السكربت", 
    "✨ السكربت: MM2 العربي\n" ..
    "📁 الإصدار: 7.0.0\n" ..
    "🎨 الواجهة: Wand UI\n" ..
    "🇸🇦 اللغة: العربية\n" ..
    "🔧 المطور: محقق\n" ..
    "📅 تاريخ التحديث: " .. os.date("%Y/%m/%d")
)

SettingsTab:AddSection("🛠️ أدوات النظام")

SettingsTab:AddButton({
    Name = "تنظيف الذاكرة",
    Callback = function()
        collectgarbage()
        
        Window:Notify({
            Title = "✅ تم التنظيف",
            Content = "تم تنظيف الذاكرة وتحسين الأداء",
            Duration = 3
        })
    end
})

SettingsTab:AddButton({
    Name = "إعادة تحميل السكربت",
    Callback = function()
        Window:Dialog({
            Title = "⚠️ تأكيد إعادة التحميل",
            Content = "هل تريد إعادة تحميل السكربت؟",
            Options = {
                {
                    Name = "❌ إلغاء",
                    Callback = function()
                        Window:Notify({
                            Title = "تم الإلغاء",
                            Content = "تم إلغاء إعادة التحميل",
                            Duration = 2
                        })
                    end
                },
                {
                    Name = "✅ تأكيد",
                    Callback = function()
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/oday018/mm2-script-op/refs/heads/main/script.lua"))()
                    end
                }
            }
        })
    end
})

SettingsTab:AddButton({
    Name = "إغلاق الواجهة",
    Callback = function()
        Window:Dialog({
            Title = "⚠️ تأكيد الإغلاق",
            Content = "هل تريد إغلاق واجهة السكربت؟",
            Options = {
                {
                    Name = "❌ إلغاء",
                    Callback = function()
                        Window:Notify({
                            Title = "تم الإلغاء",
                            Content = "تم إلغاء عملية الإغلاق",
                            Duration = 2
                        })
                    end
                },
                {
                    Name = "✅ تأكيد",
                    Callback = function()
                        if Library and Library.Destroy then
                            Library:Destroy()
                        end
                    end
                }
            }
        })
    end
})











-- ==================== إعدادات النظام ====================

-- تحديث الشخصية عند الموت
LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    -- إعادة تطبيق الإعدادات
    if WalkSpeed then
        Humanoid.WalkSpeed = WalkSpeed
    end
    if JumpPower then
        Humanoid.JumpPower = JumpPower
    end
end)

-- نظام القفز اللانهائي
UserInputService.JumpRequest:Connect(function()
    if InfiniteJumpEnabled then
        Humanoid:ChangeState("Jumping")
    end
end)

-- نظام المرور عبر الجدران
RunService.Stepped:Connect(function()
    if NoclipEnabled then
        for _, part in ipairs(Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)















-- ==================== Minimizer مع صورة سيف ====================

local Minimizer = Window:NewMinimizer({
    KeyCode = Enum.KeyCode.RightControl
})

-- زر المصغر مع صورة السيف
Minimizer:CreateMobileMinimizer({
    Image = "rbxassetid://10734962876",  -- صورة السيف
    BackgroundColor3 = Color3.fromRGB(30, 30, 30),
    
})










-- ==================== إشعار البدء ====================

Window:Notify({
    Title = "🎮 سكربت MM2 العربي",
    Content = "✅ تم تحميل السكربت بنجاح!\n\n" ..
             "✨ الميزات المتاحة:\n" ..
             "• نظام ESP للأدوار\n" ..
             "• رؤية السلاح\n" ..
             "• القذف بأنواعه\n" ..
             "• المرور عبر الجدران\n" ..
             "• القفز اللانهائي\n" ..
             "• وضع الإله\n" ..
             "• التصويب التلقائي\n" ..
             "• تحميل سكربتات خارجية\n\n" ..
             "🔧 اضغط RightControl لإخفاء/إظهار الواجهة",
    Duration = 8,
    Image = "rbxassetid://10734953451"
})
















-- ==================== الطباعة في الكونسول ====================
print("╔══════════════════════════════════════════════╗")
print("║    سكربت MM2 العربي - النسخة الموسعة        ║")
print("║          تم التحميل بنجاح! 🎮               ║")
print("╚══════════════════════════════════════════════╝")
print("📁 اللعبة: " .. GameName)
print("👤 اللاعب: " .. LocalPlayer.Name)
print("🎮 الواجهة: Wand UI")
print("🇸🇦 اللغة: العربية")
print("✨ الإصدار: 7.0.0")
print("🔧 المطور: محقق")
print("════════════════════════════════════════════════")

print("\n🎯 جميع الميزات مفعلة وجاهزة:")
print("• تبويب المرئيات: ESP للأدوار، رؤية السلاح")
print("• تبويب الأسلحة: أخذ وسرقة الأسلحة، التصويب")
print("• تبويب القذف: قذف القاتل، الشريف، لاعبين محددين")
print("• تبويب اللاعب: حركة، سرعة، قوة، عدم الموت")
print("• تبويب السكربتات: تحميل سكربتات خارجية")
print("• تبويب الإعدادات: جميع خيارات النظام")
print("════════════════════════════════════════════════")
