-- ==================== تحميل المكتبة ====================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- ==================== إنشاء النافذة ====================
local Window = Library:MakeWindow({
    Title = "🎮 سكربت MM2 العربي",
    SubTitle = "جميع الميزات | النسخة الكاملة",
    ScriptFolder = "MM2-Arabic-Ultimate"
})

-- ==================== التعاريف الأساسية ====================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local workspace = workspace

if not getgenv().FPDH then
    getgenv().FPDH = workspace.FallenPartsDestroyHeight
end

-- ==================== دالة جلب الأدوار (MM2) ====================
local function GetRoles()
    local roles = {}
    local remote = workspace:FindFirstChild("GameSettings") and workspace.GameSettings:FindFirstChild("Roles") or nil
    if not remote then return roles end

    for _, v in pairs(remote:GetChildren()) do
        if v:IsA("StringValue") and v.Value ~= "" then
            roles[v.Name] = v.Value
        end
    end
    return roles
end

-- ==================== دالة القذف (miniFling) ====================
local FlingDuration = 2.5 -- سيتم تحديثها من السلايدر

local function miniFling(player)
    if not player or player == LocalPlayer then return end
    local Character = player.Character
    if not Character then return end

    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    if not RootPart then return end

    -- BodyVelocity للقذف العنيف
    local BV = Instance.new("BodyVelocity")
    BV.Velocity = Vector3.new(1e6, 1e6, 1e6)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.P = 1e6
    BV.Name = "FlingBlast"
    BV.Parent = RootPart

    -- BodyGyro لمنع التحكم
    local BG = Instance.new("BodyGyro")
    BG.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    BG.P = 1e6
    BG.CFrame = RootPart.CFrame
    BG.Parent = RootPart

    task.delay(FlingDuration, function()
        if BV and BV.Parent then BV:Destroy() end
        if BG and BG.Parent then BG:Destroy() end
    end)
end

-- ==================== تبويب القذف ====================
local FlingTab = Window:MakeTab({
    Title = "💥 Fling",
    Icon = "Bomb"
})

-- ==================== قسم: قذف حسب الدور ====================
FlingTab:AddSection("💨 قذف حسب الدور")

FlingTab:AddButton({
    Name = "قذف القاتل",
    Callback = function()
        local roles = GetRoles() -- دالة جلب الأدوار
        local found = false
        
        for playerName, role in pairs(roles) do
            if role == "Murderer" then
                local murderer = Players:FindFirstChild(playerName)
                if murderer and murderer ~= LocalPlayer then
                    miniFling(murderer) -- استخدام دالة القذف
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
        local roles = GetRoles() -- دالة جلب الأدوار
        local found = false
        
        for playerName, role in pairs(roles) do
            if role == "Sheriff" or role == "Hero" then
                local target = Players:FindFirstChild(playerName)
                if target and target ~= LocalPlayer then
                    miniFling(target) -- استخدام دالة القذف
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

-- ==================== قسم: قذف الكل (الأبادة) ====================
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
                    local roles = GetRoles() -- دالة جلب الأدوار
                    local flungCount = 0
                    
                    for playerName, role in pairs(roles) do
                        local player = Players:FindFirstChild(playerName)
                        if player and player ~= LocalPlayer then
                            miniFling(player) -- استخدام دالة القذف
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

-- ==================== قسم: قذف لاعب محدد ====================
FlingTab:AddSection("🎯 قذف لاعب محدد")

-- متغيرات
local SelectedPlayer = nil
-- local FlingDuration = 2.5 -- تم تعريفه مسبقًا

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
        miniFling(player) -- استخدام دالة القذف بدلاً من SHubFling
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

-- ==================== قسم: إعدادات القذف ====================
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
