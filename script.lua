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

-- دالة الإرسال (Fling)
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
    
    repeat 
        task.wait()
        Workspace.CurrentCamera.CameraSubject = THead or Handle or THumanoid
    until Workspace.CurrentCamera.CameraSubject == THead or Handle or THumanoid
    
    local function FPos(BasePart, Pos, Ang)
        local targetCF = CFrame.new(BasePart.Position) * Pos * Ang
        HumanoidRootPart.CFrame = targetCF
        Character:SetPrimaryPartCFrame(targetCF)
        HumanoidRootPart.Velocity = Vector3.new(9e7, 9e8, 9e7)
        HumanoidRootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end
    
    local function SFBasePart(BasePart)
        local start = tick()
        local angle = 0
        local timeout = 2.5
        
        repeat
            if HumanoidRootPart and THumanoid then
                angle = angle + 100
                for _, offset in ipairs{
                    CFrame.new(0, 1.5, 0),
                    CFrame.new(0, -1.5, 0),
                    CFrame.new(2.25, 1.5, -2.25),
                    CFrame.new(-2.25, -1.5, 2.25)
                } do
                    FPos(BasePart, offset + THumanoid.MoveDirection, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()
                end
            end
        until BasePart.Velocity.Magnitude > 500 or tick() - start > timeout
    end
    
    local BV = Instance.new("BodyVelocity")
    BV.Name = "FlingVelocity"
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Parent = HumanoidRootPart
    
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    
    local target = TRootPart or THead or Handle
    if target then 
        SFBasePart(target) 
    end
    
    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    
    repeat 
        task.wait()
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
        
        task.wait()
    until (HumanoidRootPart.Position - OldPos.p).Magnitude < 25
end

-- ==================== إنشاء التبويبات ====================

local MainTab = Window:MakeTab({Title = "🏠 الرئيسية", Icon = "Home"})
local PlayerTab = Window:MakeTab({Title = "👤 اللاعب", Icon = "User"})
local VisualTab = Window:MakeTab({Title = "👁️ المرئيات", Icon = "Eye"})
local TeleportTab = Window:MakeTab({Title = "📍 الانتقال", Icon = "Navigation"})
local WeaponsTab = Window:MakeTab({Title = "🔫 الأسلحة", Icon = "Target"})
local FlingTab = Window:MakeTab({Title = "💨 القذف", Icon = "Wind"})
local ScriptsTab = Window:MakeTab({Title = "📁 السكربتات", Icon = "Cloud"})
local SettingsTab = Window:MakeTab({Title = "⚙️ الإعدادات", Icon = "Settings"})

-- ==================== تبويب القتل ====================

local KillerTab = Window:MakeTab({Title = "🔫 القتل", Icon = "Target"})

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


























-- ==================== تبويب المرئيات ====================




















VisualTab:AddSection("🎭 نظام الرؤية للأدوار")

-- ESP للأدوار
local ESPEnabled = false
local ESPUpdateLoop = nil

local RoleColors = {
    Murderer = Color3.fromRGB(255, 0, 0),    -- أحمر للقاتل
    Sheriff = Color3.fromRGB(0, 0, 255),     -- أزرق للشريف
    Hero = Color3.fromRGB(255, 255, 0),      -- أصفر للبطل
    Innocent = Color3.fromRGB(0, 255, 0),    -- أخضر للأبرياء
    Default = Color3.fromRGB(200, 200, 200)  -- رمادي افتراضي
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
    label.Text = string.format("الدور: %s | الاسم: %s", role, playerName)
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
                        label.Text = string.format("الدور: %s | الاسم: %s", role, player.Name)
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
    Name = "تفعيل ESP للأدوار والأسماء",
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
WeaponsTab:AddSection("🎯 التصويب")

-- زر إطلاق النار على القاتل
local ShootMurderButtonEnabled = false
local lastShotTime = 0
local SHOT_COOLDOWN = 0.2 -- 0.2 ثانية فقط بين الطلقات
local autoShootActive = false
local shootConnection = nil
local aimbotConnection = nil

-- === دالة التصويب الدقيق المحسنة ===
local function GetMurdererTarget()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    if not character then return nil, false end
    
    local closestTarget = nil
    local closestDistance = math.huge
    local targetHeadPosition = nil
    
    local myHead = character:FindFirstChild("Head")
    if not myHead then return nil, false end
    
    -- ابحث عن القاتل الأقرب
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherChar = otherPlayer.Character
            local humanoid = otherChar:FindFirstChild("Humanoid")
            
            if humanoid and humanoid.Health > 0 then
                -- في Murder Mystery 2، القاتل لديه سكين
                local hasKnife = otherChar:FindFirstChild("Knife") 
                local isMurderer = otherChar:FindFirstChild("Knife") or 
                                  (otherPlayer:FindFirstChild("Backpack") and 
                                   otherPlayer.Backpack:FindFirstChild("Knife"))
                
                if isMurderer then
                    local head = otherChar:FindFirstChild("Head")
                    local root = otherChar:FindFirstChild("HumanoidRootPart")
                    
                    if head and root then
                        -- حساب المسافة بدقة
                        local distance = (myHead.Position - head.Position).Magnitude
                        
                        if distance < closestDistance then
                            closestDistance = distance
                            closestTarget = otherChar
                            
                            -- حساب موقع التصويب بدقة (رأس + توقع الحركة)
                            local velocity = root.Velocity
                            local prediction = velocity * 0.1 -- توقع حركة الهدف
                            
                            -- التصويب الدقيق على الرأس
                            targetHeadPosition = head.Position + prediction + Vector3.new(0, 0.1, 0)
                        end
                    end
                end
            end
        end
    end
    
    if closestTarget and targetHeadPosition then
        -- تحقق إذا كان الهدف مرئياً
        local raycastParams = RaycastParams.new()
        raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        raycastParams.FilterDescendantsInstances = {character}
        raycastParams.IgnoreWater = true
        
        local ray = workspace:Raycast(myHead.Position, (targetHeadPosition - myHead.Position).Unit * 1000, raycastParams)
        
        if ray then
            if ray.Instance:IsDescendantOf(closestTarget) then
                return targetHeadPosition, false
            end
        else
            return targetHeadPosition, false
        end
    end
    
    return nil, false
end

-- === دالة تصويب AIMBOT محسنة ===
local function GetAimbotTarget()
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    local character = player.Character
    if not character then return nil, false end
    
    local myHead = character:FindFirstChild("Head")
    if not myHead then return nil, false end
    
    local camera = workspace.CurrentCamera
    local mouse = player:GetMouse()
    
    local closestTarget = nil
    local closestScreenDistance = math.huge
    local targetPosition = nil
    
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player and otherPlayer.Character then
            local otherChar = otherPlayer.Character
            local humanoid = otherChar:FindFirstChild("Humanoid")
            
            if humanoid and humanoid.Health > 0 then
                -- تحقق إذا كان القاتل
                local isMurderer = otherChar:FindFirstChild("Knife") or 
                                  (otherPlayer:FindFirstChild("Backpack") and 
                                   otherPlayer.Backpack:FindFirstChild("Knife"))
                
                if isMurderer then
                    local head = otherChar:FindFirstChild("Head")
                    local root = otherChar:FindFirstChild("HumanoidRootPart")
                    
                    if head and root then
                        -- حساب موقع الهدف على الشاشة
                        local screenPoint, onScreen = camera:WorldToViewportPoint(head.Position)
                        
                        if onScreen then
                            -- حساب المسافة من مركز الشاشة (تصويب أوتوماتيكي)
                            local mousePos = Vector2.new(mouse.X, mouse.Y)
                            local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
                            local distance = (mousePos - targetPos).Magnitude
                            
                            -- تصويب مباشر على أقرب هدف
                            if distance < closestScreenDistance then
                                closestScreenDistance = distance
                                closestTarget = otherChar
                                
                                -- حساب توقع حركة الهدف
                                local velocity = root.Velocity
                                local prediction = velocity * 0.15 -- زيادة توقع الحركة
                                
                                targetPosition = head.Position + prediction + Vector3.new(0, 0.15, 0)
                            end
                        end
                    end
                end
            end
        end
    end
    
    return targetPosition, false
end

-- === دالة الإطلاق السريع ===
local function QuickShoot()
    if tick() - lastShotTime < SHOT_COOLDOWN then return end
    
    local player = game:GetService("Players").LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    if not character then return end
    
    -- البحث السريع عن سلاح
    if not character:FindFirstChild("Gun") then
        local backpack = player:FindFirstChild("Backpack")
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item.Name == "Gun" then
                    item.Parent = character
                    task.wait(0.05) -- وقت انتظار قصير جداً
                    break
                end
            end
        end
    end
    
    local gun = character:FindFirstChild("Gun")
    if gun then
        -- استخدم AIMBOT للتصويب الدقيق
        local targetPos = GetAimbotTarget()
        
        if targetPos then
            -- إطلاق متعدد لزيادة الفرصة
            pcall(function()
                -- محاولة 1
                if gun:FindFirstChild("KnifeLocal") then
                    gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, targetPos, "AH2")
                elseif gun:FindFirstChild("RemoteFunction") then
                    gun.RemoteFunction:InvokeServer("Fire", targetPos)
                end
                
                task.wait(0.05)
                
                -- محاولة 2 (للتأكد)
                targetPos = targetPos + Vector3.new(math.random(-0.1, 0.1), math.random(-0.1, 0.1), math.random(-0.1, 0.1))
                if gun:FindFirstChild("KnifeLocal") then
                    gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, targetPos, "AH2")
                elseif gun:FindFirstChild("RemoteFunction") then
                    gun.RemoteFunction:InvokeServer("Fire", targetPos)
                end
            end)
            
            lastShotTime = tick()
            return true
        end
    end
    
    return false
end

-- === AIMBOT التلقائي ===
local function StartAimbot()
    if aimbotConnection then return end
    
    aimbotConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not ShootMurderButtonEnabled then return end
        
        local player = game:GetService("Players").LocalPlayer
        local character = player.Character
        if not character then return end
        
        local gun = character:FindFirstChild("Gun")
        if gun then
            local targetPos = GetAimbotTarget()
            if targetPos then
                -- إطلاق مباشر بدون تأخير
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

WeaponsTab:AddToggle({
    Name = "🎯 إطلاق سريع على القاتل",
    Default = false,
    Callback = function(Value)
        ShootMurderButtonEnabled = Value
        
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        
        local guip = game:GetService("CoreGui")
        if gethui then
            guip = gethui()
        end
        
        if Value then
            if guip:FindFirstChild("ShootMurderButton") then
                guip:FindFirstChild("ShootMurderButton"):Destroy()
            end
            
            -- == تصميم صغير وسهل الحركة ==
            local ScreenGui = Instance.new("ScreenGui", guip)
            ScreenGui.Name = "ShootMurderButton"
            ScreenGui.ResetOnSpawn = false
            ScreenGui.IgnoreGuiInset = true
            
            -- الإطار الرئيسي الصغير
            local MainFrame = Instance.new("Frame", ScreenGui)
            MainFrame.Name = "MainFrame"
            MainFrame.Draggable = true  -- هذا الي يخليه يتحرك!
            MainFrame.Active = true
            MainFrame.Selectable = true
            MainFrame.Position = UDim2.new(0.8, 0, 0.5, 0) -- في اليمين
            MainFrame.Size = UDim2.new(0, 160, 0, 170) -- صغير
            MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            MainFrame.BackgroundTransparency = 0.05
            MainFrame.BorderSizePixel = 0
            
            local MainCorner = Instance.new("UICorner", MainFrame)
            MainCorner.CornerRadius = UDim.new(0, 10)
            
            local MainStroke = Instance.new("UIStroke", MainFrame)
            MainStroke.Color = Color3.fromRGB(80, 120, 255)
            MainStroke.Thickness = 2
            
            -- العنوان (يمكن السحب منه)
            local Title = Instance.new("TextLabel", MainFrame)
            Title.Name = "Title"
            Title.Position = UDim2.new(0, 0, 0, 0)
            Title.Size = UDim2.new(1, 0, 0, 30)
            Title.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            Title.Text = "🎯 AIMBOT"
            Title.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title.TextSize = 14
            Title.Font = Enum.Font.GothamBold
            Title.Draggable = true  -- يمكن السحب من العنوان
            Title.Active = true
            
            local TitleCorner = Instance.new("UICorner", Title)
            TitleCorner.CornerRadius = UDim.new(0, 10)
            
            -- زر الإطلاق (صغير)
            local QuickButton = Instance.new("TextButton", MainFrame)
            QuickButton.Name = "QuickButton"
            QuickButton.Position = UDim2.new(0.1, 0, 0.25, 0)
            QuickButton.Size = UDim2.new(0.8, 0, 0, 40)
            QuickButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
            QuickButton.TextColor3 = Color3.new(1, 1, 1)
            QuickButton.Text = "🔫 إطلاق"
            QuickButton.TextSize = 14
            QuickButton.Font = Enum.Font.GothamBold
            QuickButton.AutoButtonColor = true
            QuickButton.Draggable = false  -- هذا الزر ما يتحرك
            
            local QuickCorner = Instance.new("UICorner", QuickButton)
            QuickCorner.CornerRadius = UDim.new(0, 8)
            
            local QuickStroke = Instance.new("UIStroke", QuickButton)
            QuickStroke.Color = Color3.new(1, 1, 1)
            QuickStroke.Thickness = 1.5
            
            -- زر AIMBOT (صغير)
            local AimbotButton = Instance.new("TextButton", MainFrame)
            AimbotButton.Name = "AimbotButton"
            AimbotButton.Position = UDim2.new(0.1, 0, 0.55, 0)
            AimbotButton.Size = UDim2.new(0.8, 0, 0, 40)
            AimbotButton.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
            AimbotButton.TextColor3 = Color3.new(1, 1, 1)
            AimbotButton.Text = "🤖 تلقائي"
            AimbotButton.TextSize = 14
            AimbotButton.Font = Enum.Font.GothamBold
            AimbotButton.AutoButtonColor = true
            AimbotButton.Draggable = false
            
            local AimbotCorner = Instance.new("UICorner", AimbotButton)
            AimbotCorner.CornerRadius = UDim.new(0, 8)
            
            local AimbotStroke = Instance.new("UIStroke", AimbotButton)
            AimbotStroke.Color = Color3.new(1, 1, 1)
            AimbotStroke.Thickness = 1.5
            
            -- مؤشر صغير
            local StatusDot = Instance.new("Frame", MainFrame)
            StatusDot.Name = "StatusDot"
            StatusDot.Position = UDim2.new(0.85, 0, 0.9, 0)
            StatusDot.Size = UDim2.new(0, 10, 0, 10)
            StatusDot.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
            StatusDot.BorderSizePixel = 0
            
            local DotCorner = Instance.new("UICorner", StatusDot)
            DotCorner.CornerRadius = UDim.new(1, 0)
            
            -- أحداث الأزرار
            local aimbotActive = true
            
            QuickButton.MouseButton1Click:Connect(function()
                local success = QuickShoot()
                if success then
                    QuickButton.Text = "✅ تم!"
                    task.wait(0.3)
                    QuickButton.Text = "🔫 إطلاق"
                else
                    QuickButton.Text = "❌ فشل"
                    task.wait(0.5)
                    QuickButton.Text = "🔫 إطلاق"
                end
            end)
            
            AimbotButton.MouseButton1Click:Connect(function()
                aimbotActive = not aimbotActive
                
                if aimbotActive then
                    AimbotButton.Text = "✅ تلقائي"
                    AimbotButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
                    StatusDot.BackgroundColor3 = Color3.fromRGB(50, 255, 50)
                    StartAimbot()
                else
                    AimbotButton.Text = "🤖 تلقائي"
                    AimbotButton.BackgroundColor3 = Color3.fromRGB(60, 100, 255)
                    StatusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                    
                    if aimbotConnection then
                        aimbotConnection:Disconnect()
                        aimbotConnection = nil
                    end
                end
            end)
            
            -- تشغيل AIMBOT تلقائياً
            StartAimbot()
            
            -- إضافة أداة للسحب (لتسهيل الحركة)
            local DragButton = Instance.new("TextButton", MainFrame)
            DragButton.Name = "DragButton"
            DragButton.Position = UDim2.new(0, 0, 0, 0)
            DragButton.Size = UDim2.new(1, 0, 0, 30)
            DragButton.BackgroundTransparency = 1
            DragButton.Text = ""
            DragButton.Draggable = true
            DragButton.Active = true
            
            -- زر إغلاق صغير
            local CloseButton = Instance.new("TextButton", MainFrame)
            CloseButton.Name = "CloseButton"
            CloseButton.Position = UDim2.new(0.9, 0, 0, 5)
            CloseButton.Size = UDim2.new(0, 20, 0, 20)
            CloseButton.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
            CloseButton.Text = "X"
            CloseButton.TextColor3 = Color3.new(1, 1, 1)
            CloseButton.TextSize = 12
            CloseButton.Font = Enum.Font.GothamBold
            
            local CloseCorner = Instance.new("UICorner", CloseButton)
            CloseCorner.CornerRadius = UDim.new(1, 0)
            
            CloseButton.MouseButton1Click:Connect(function()
                ScreenGui:Destroy()
                ShootMurderButtonEnabled = false
                if aimbotConnection then
                    aimbotConnection:Disconnect()
                    aimbotConnection = nil
                end
            end)
            
        else
            if aimbotConnection then
                aimbotConnection:Disconnect()
                aimbotConnection = nil
            end
            
            if guip:FindFirstChild("ShootMurderButton") then
                guip:FindFirstChild("ShootMurderButton"):Destroy()
            end
        end
    end
})
-- ==================== تبويب القذف ====================
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
                            task.wait(0.2)
                        end
                    end
                    
                    if flungCount > 0 then
                        Window:Notify({
                            Title = "💥 قذف مستمر",
                            Content = "تم قذف " .. flungCount .. " لاعب/لاعبين في هذه الدورة",
                            Duration = 2
                        })
                    end
                    
                    task.wait(3)
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

FlingTab:AddButton({
    Name = "قذف اللاعب المحدد",
    Callback = function()
        if SelectedPlayer then
            local player = Players:FindFirstChild(SelectedPlayer)
            if player and player ~= LocalPlayer then
                SHubFling(player)
                
                Window:Notify({
                    Title = "💨 تم قذف اللاعب",
                    Content = "تم قذف: " .. player.Name,
                    Duration = 3
                })
            else
                Window:Notify({
                    Title = "❌ خطأ",
                    Content = "لم يتم العثور على اللاعب: " .. (SelectedPlayer or ""),
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

FlingTab:AddSection("⚙️ إعدادات القذف")

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

-- منع القذف
local AntiFlingEnabled = false

FlingTab:AddToggle({
    Name = "منع القذف (المرور عبر اللاعبين)",
    Default = false,
    Callback = function(Value)
        AntiFlingEnabled = Value
        
        if not Value then
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
                task.wait()
            end
        end)
    end
})

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

PlayerTab:AddSlider({
    Name = "سرعة المشي",
    Min = 16,
    Max = 350,
    Default = 16,
    Increment = 1,
    Callback = function(Value)
        WalkSpeed = Value
        if Humanoid then
            Humanoid.WalkSpeed = Value
        end
    end
})

PlayerTab:AddToggle({
    Name = "تثبيت سرعة المشي تلقائياً",
    Default = false,
    Callback = function(Value)
        KeepWalkSpeed = Value
        
        task.spawn(function()
            while KeepWalkSpeed do
                if Humanoid and Humanoid.WalkSpeed ~= WalkSpeed then
                    Humanoid.WalkSpeed = WalkSpeed
                end
                task.wait(0.1)
            end
        end)
    end
})

-- قوة القفز
local JumpPower = 50
local KeepJumpPower = false

PlayerTab:AddSlider({
    Name = "قوة القفز",
    Min = 50,
    Max = 500,
    Default = 50,
    Increment = 1,
    Callback = function(Value)
        JumpPower = Value
        if Humanoid then
            Humanoid.JumpPower = Value
        end
    end
})

PlayerTab:AddToggle({
    Name = "تثبيت قوة القفز تلقائياً",
    Default = false,
    Callback = function(Value)
        KeepJumpPower = Value
        
        task.spawn(function()
            while KeepJumpPower do
                if Humanoid and Humanoid.JumpPower ~= JumpPower then
                    Humanoid.JumpPower = JumpPower
                end
                task.wait(0.1)
            end
        end)
    end
})

-- وضع الإله (عدم الموت)
local GodmodeEnabled = false

PlayerTab:AddToggle({
    Name = "وضع الإله (عدم الموت)",
    Default = false,
    Callback = function(Value)
        GodmodeEnabled = Value
        
        local godConnection
        local deathConnection
        
        local function UpdateGodmode()
            if godConnection then
                godConnection:Disconnect()
                godConnection = nil
            end
            
            if Humanoid then
                godConnection = Humanoid.HealthChanged:Connect(function()
                    if GodmodeEnabled and Humanoid.Health < Humanoid.MaxHealth then
                        Humanoid.Health = Humanoid.MaxHealth
                    end
                end)
            end
        end
        
        local function OnCharacterAdded(newChar)
            Character = newChar
            Humanoid = Character:WaitForChild("Humanoid")
            UpdateGodmode()
        end
        
        if deathConnection then 
            deathConnection:Disconnect() 
        end
        
        deathConnection = LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
        UpdateGodmode()
        
        if Value then
            Window:Notify({
                Title = "🛡️ تم تفعيل وضع الإله",
                Content = "لن تتمكن من الموت الآن",
                Duration = 3
            })
        end
    end
})

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
    "🔧 المطور: real_redz\n" ..
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
                        loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()
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





