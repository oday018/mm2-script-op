-- ==================== تحميل المكتبة ====================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- ==================== إنشاء النافذة ====================
local Window = Library:MakeWindow({
    Title = "🎯 سكربت القذف الفعال",
    SubTitle = "بنفس نمط القذف الأصلي المحسن",
    ScriptFolder = "Fling-Script"
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

-- ==================== دالة الحصول على الأدوار ====================
local function GetRoles()
    local success, data = pcall(function()
        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
    end)
    
    if not success then return {} end
    return data or {}
end

-- ==================== دالة الإرسال (Fling) - النسخة المعدلة ====================
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
    
    -- ⚡ زيادة سرعة التوجيه
    repeat 
        task.wait(0.0005)  -- ⬅️ أسرع (كان 0.001)
        Workspace.CurrentCamera.CameraSubject = THead or Handle or THumanoid
    until Workspace.CurrentCamera.CameraSubject == THead or Handle or THumanoid
    
    local function FPos(BasePart, Pos, Ang)
        local targetCF = CFrame.new(BasePart.Position) * Pos * Ang
        HumanoidRootPart.CFrame = targetCF
        Character:SetPrimaryPartCFrame(targetCF)
        HumanoidRootPart.Velocity = Vector3.new(9e8, 9e9, 9e8)  -- ✅ نفس القوة
        HumanoidRootPart.RotVelocity = Vector3.new(9e9, 9e9, 9e9)  -- ✅ نفس الدوران
    end
    
    local function SFBasePart(BasePart)
        local start = tick()
        local angle = 0
        local timeout = 0.3  -- ⬅️ وقت أقل (كان 0.5)
        
        repeat
            if HumanoidRootPart and THumanoid then
                angle = angle + 700  -- ⬅️ دوران أسرع (كان 500)
                
                -- 🔥 إضافة تعويض حركة الهدف
                local moveCompensation = THumanoid.MoveDirection * 1.5
                
                for _, offset in ipairs{
                    CFrame.new(0, 1.5, 0),
                    CFrame.new(0, -1.5, 0),
                    CFrame.new(2.25, 1.5, -2.25),
                    CFrame.new(-2.25, -1.5, 2.25)
                } do
                    -- تطبيق التعويض
                    FPos(BasePart, offset + moveCompensation, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait(0.0005)  -- ⬅️ أسرع (كان 0.001)
                end
            end
        until BasePart.Velocity.Magnitude > 4000 or tick() - start > timeout  -- ⬅️ حد أقل (كان 5000)
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
    
    -- ⚡ زيادة سرعة العودة
    repeat 
        task.wait(0.0005)  -- ⬅️ أسرع (كان 0.001)
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
        
        task.wait(0.0005)  -- ⬅️ أسرع (كان 0.001)
    until (HumanoidRootPart.Position - OldPos.p).Magnitude < 20  -- ⬅️ عودة أبكر (كان 25)
    
    return true
end

-- ==================== إنشاء التبويب ====================
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
        
        for playerName, playerData in pairs(roles) do
            if playerData.Role == "Murderer" then
                local murderer = Players:FindFirstChild(playerName)
                if murderer and murderer ~= LocalPlayer then
                    local success = SHubFling(murderer)
                    found = success
                    
                    Window:Notify({
                        Title = "💨 تم قذف القاتل",
                        Content = success and "تم قذف: " .. murderer.Name or "قذف غير كامل",
                        Duration = 2  -- ⬅️ وقت أقل
                    })
                    break
                end
            end
        end
        
        if not found then
            Window:Notify({
                Title = "❌ خطأ",
                Content = "لم يتم العثور على القاتل",
                Duration = 2
            })
        end
    end
})

FlingTab:AddButton({
    Name = "قذف الشريف/البطل",
    Callback = function()
        local roles = GetRoles()
        local found = false
        
        for playerName, playerData in pairs(roles) do
            if playerData.Role == "Sheriff" or playerData.Role == "Hero" then
                local target = Players:FindFirstChild(playerName)
                if target and target ~= LocalPlayer then
                    local success = SHubFling(target)
                    found = success
                    
                    Window:Notify({
                        Title = "💨 تم القذف",
                        Content = success and "تم قذف: " .. target.Name or "قذف غير كامل",
                        Duration = 2
                    })
                    break
                end
            end
        end
        
        if not found then
            Window:Notify({
                Title = "❌ خطأ",
                Content = "لم يتم العثور على الشريف أو البطل",
                Duration = 2
            })
        end
    end
})

FlingTab:AddSection("🔥 قذف الكل")

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
                    
                    for playerName, playerData in pairs(roles) do
                        local player = Players:FindFirstChild(playerName)
                        if player and player ~= LocalPlayer then
                            local success = SHubFling(player)
                            if success then
                                flungCount = flungCount + 1
                            end
                            task.wait(0.2)  -- ⬅️ وقت أقل بين القذف
                        end
                    end
                    
                    if flungCount > 0 then
                        Window:Notify({
                            Title = "💥 قذف مستمر",
                            Content = "تم قذف " .. flungCount .. " لاعب",
                            Duration = 1
                        })
                    end
                    
                    task.wait(1.5)  -- ⬅️ وقت أقل بين الدورات
                end
            end)
            
            Window:Notify({
                Title = "🔥 تم تفعيل قذف الكل",
                Content = "سيتم قذف جميع اللاعبين",
                Duration = 2
            })
        else
            if FlingAllLoop then
                FlingAllLoop:Cancel()
                FlingAllLoop = nil
            end
            
            Window:Notify({
                Title = "🛑 تم إيقاف قذف الكل",
                Content = "توقف القذف الجماعي",
                Duration = 2
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

UpdateDropdown()
Players.PlayerAdded:Connect(UpdateDropdown)
Players.PlayerRemoving:Connect(UpdateDropdown)

FlingTab:AddButton({
    Name = "قذف اللاعب المحدد",
    Callback = function()
        if SelectedPlayer then
            local player = Players:FindFirstChild(SelectedPlayer)
            if player and player ~= LocalPlayer then
                local success = SHubFling(player)
                
                Window:Notify({
                    Title = success and "💨 تم القذف" or "⚠️ قذف جزئي",
                    Content = success and "تم قذف: " .. player.Name or "لم يكتمل القذف",
                    Duration = 2
                })
            else
                Window:Notify({
                    Title = "❌ خطأ",
                    Content = "اللاعب غير موجود",
                    Duration = 2
                })
            end
        else
            Window:Notify({
                Title = "⚠️ تنبيه",
                Content = "اختر لاعباً أولاً",
                Duration = 2
            })
        end
    end
})

FlingTab:AddSection("⚙️ إعدادات القذف")

FlingTab:AddButton({
    Name = "🔄 تحديث الشخصية",
    Callback = function()
        Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
        HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        
        Window:Notify({
            Title = "✅ تم التحديث",
            Content = "جاهز للقذف",
            Duration = 2
        })
    end
})

FlingTab:AddParagraph("✨ معلومات", [[
🎮 سكربت القذف المعدل:
• وقت القذف: 0.3 ثانية (أسرع)
• سرعة دوران: 700 درجة/إطار
• تعويض حركة الهدف: ✓
• وقت بين النقاط: 0.0005 ثانية
• يعود لموقعه بسرعة
]])

-- ==================== تحديث الشخصية ====================
LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(0.3)  -- ⬅️ وقت أقل
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

-- ==================== إشعار البدء ====================
task.wait(0.5)
Window:Notify({
    Title = "✅ سكربت القذف جاهز",
    Content = "النسخة السريعة | كل شيء أسرع",
    Duration = 3
})

print("🎯 سكربت القذف المعدل تم تحميله!")
