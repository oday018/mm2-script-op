-- ==================== تحميل المكتبة ====================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- ==================== إنشاء النافذة ====================
local Window = Library:MakeWindow({
    Title = "🎯 سكربت القذف المتكامل",
    SubTitle = "جميع أنواع القذف | MM2",
    ScriptFolder = "Ultimate-Fling-Script"
})

-- ==================== الخدمات الأساسية ====================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

-- ==================== الدوال الأساسية ====================
local function GetRoles()
    -- دالة الحصول على أدوار اللاعبين
    local success, data = pcall(function()
        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    end)
    
    if not success or not data then
        return {}
    end
    
    local roles = {}
    for playerName, playerData in pairs(data) do
        if not playerData.Dead then
            roles[playerName] = playerData.Role
        end
    end
    
    return roles
end

-- ==================== دالة القذف المحسنة ====================
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
    
    -- 🔥 تجميد اللاعب إذا كان متحركاً
    if TRootPart and TRootPart.Velocity.Magnitude > 30 then
        local tempVelocity = TRootPart.Velocity
        TRootPart.Velocity = Vector3.new(0, 0, 0)
        task.wait(0.05)
        TRootPart.Velocity = tempVelocity
    end
    
    -- ⚡ توجيه الكاميرا
    repeat 
        task.wait(0.001)
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
        local timeout = 0.8
        
        repeat
            if HumanoidRootPart and THumanoid then
                angle = angle + 400
                
                -- تعويض حركة اللاعب المتحرك
                local moveCompensation = THumanoid.MoveDirection * 1.5
                
                for _, offset in ipairs{
                    CFrame.new(0, 2, 0) + moveCompensation,
                    CFrame.new(0, -1, 0) + moveCompensation,
                    CFrame.new(3, 1.5, -3) + moveCompensation,
                    CFrame.new(-3, -1.5, 3) + moveCompensation,
                    CFrame.new(0, 0, -4) + moveCompensation,
                    CFrame.new(0, 0, 4) + moveCompensation
                } do
                    FPos(BasePart, offset, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait(0.001)
                end
            end
        until BasePart.Velocity.Magnitude > 3000 or tick() - start > timeout
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
        
        -- 💥 قذف نهائي قوي
        if target and target.Parent then
            target.Velocity = Vector3.new(
                math.random(-80000, 80000),
                120000,
                math.random(-80000, 80000)
            )
            
            target.RotVelocity = Vector3.new(
                math.random(-15000, 15000),
                math.random(-15000, 15000),
                math.random(-15000, 15000)
            )
        end
    end
    
    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    
    -- العودة السريعة
    repeat 
        task.wait(0.001)
        Workspace.CurrentCamera.CameraSubject = Humanoid
    until Workspace.CurrentCamera.CameraSubject == Humanoid
    
    -- طريقة أسرع للعودة
    HumanoidRootPart.CFrame = OldPos * CFrame.new(0, .5, 0)
    Character:SetPrimaryPartCFrame(OldPos)
    Humanoid:ChangeState("GettingUp")
    
    -- تنظيف السرعة
    HumanoidRootPart.Velocity = Vector3.zero
    HumanoidRootPart.RotVelocity = Vector3.zero
    
    return true
end

-- ==================== إنشاء التبويبات ====================
local FlingTab = Window:MakeTab({
    Title = "🎯 القذف",
    Icon = "rbxassetid://4483345998"
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

FlingTab:AddSection("🔥 قذف الكل (توجل)")

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
                            Content = "تم قذف " .. flungCount .. " لاعب/لاعبين",
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
                Content = "تم إيقاف القذف الجماعي",
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
                    Content = "لم يتم العثور على اللاعب",
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

FlingTab:AddSection("✨ معلومات")

FlingTab:AddParagraph("🎮 سكربت القذف المتكامل", [[
• قذف القاتل
• قذف الشريف/البطل  
• قذف جميع اللاعبين
• قذف لاعب محدد
• قذف باللمس
• حماية من القذف
]])

-- ==================== تحديث الشخصية ====================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

-- ==================== التنبيه عند التحميل ====================
Window:Notify({
    Title = "✅ سكربت القذف جاهز",
    Content = "تم تحميل السكربت بنجاح!",
    Duration = 5
})

print("🎯 سكربت القذف المتكامل جاهز للاستخدام!")
