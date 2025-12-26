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
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = workspace

-- حفظ FPDH الأصلي (لإرجاعه لاحقًا)
if not getgenv().FPDH then
    getgenv().FPDH = workspace.FallenPartsDestroyHeight
end

-- تطبيق cloneref على الخدمات
local SafePlayers = cloneref(game:GetService("Players"))
local SafeReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

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

-- ==================== دالة القذف (SHubFling من السكربت القديم) ====================
local function SHubFling(TargetPlayer)
    local Player = LocalPlayer
    local Character = Player.Character or Player.CharacterAdded:Wait()
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    if not (Character and Humanoid and RootPart) then
        Window:Notify({
            Title = "Fling",
            Content = "شخصيتك غير جاهزة!"
        })
        return
    end

    local TCharacter = TargetPlayer.Character
    if not TCharacter then
        Window:Notify({
            Title = "Fling",
            Content = "اللاعب المحدد ما عنده شخصية!"
        })
        return
    end

    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")

    -- حفظ الموقع الأصلي
    if RootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = RootPart.CFrame
    end

    -- دالة تطبيق القذف
    local function FPos(BasePart, Pos, Ang)
        local cf = CFrame.new(BasePart.Position) * Pos * Ang
        RootPart.CFrame = cf
        Character:SetPrimaryPartCFrame(cf)
        RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
        RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end

    -- منطق الفلينق
    local function ExecuteFling(BasePart)
        local startTime = tick()
        local angle = 0

        repeat
            if not (RootPart and THumanoid and BasePart and BasePart.Parent == TCharacter) then break end

            if BasePart.Velocity.Magnitude < 50 then
                angle += 100
                local dir = THumanoid.MoveDirection
                local mag = BasePart.Velocity.Magnitude / 1.25
                FPos(BasePart, CFrame.new(0, 1.5, 0) + dir * mag, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                FPos(BasePart, CFrame.new(0, -1.5, 0) + dir * mag, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + dir * mag, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + dir * mag, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                FPos(BasePart, CFrame.new(0, 1.5, 0) + dir, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
                FPos(BasePart, CFrame.new(0, -1.5, 0) + dir, CFrame.Angles(math.rad(angle), 0, 0)); task.wait()
            else
                local ws = THumanoid.WalkSpeed
                local vmag = TRootPart and TRootPart.Velocity.Magnitude or 0
                FPos(BasePart, CFrame.new(0, 1.5, ws), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                FPos(BasePart, CFrame.new(0, -1.5, -ws), CFrame.Angles(0, 0, 0)); task.wait()
                FPos(BasePart, CFrame.new(0, 1.5, ws), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                FPos(BasePart, CFrame.new(0, 1.5, vmag / 1.25), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                FPos(BasePart, CFrame.new(0, -1.5, -vmag / 1.25), CFrame.Angles(0, 0, 0)); task.wait()
                FPos(BasePart, CFrame.new(0, 1.5, vmag / 1.25), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0)); task.wait()
                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0)); task.wait()
                FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0)); task.wait()
            end
        until BasePart.Velocity.Magnitude > 500
            or BasePart.Parent ~= TCharacter
            or TargetPlayer.Parent ~= Players
            or TargetPlayer.Character ~= TCharacter
            or (THumanoid and THumanoid.Sit)
            or Humanoid.Health <= 0
            or (tick() - startTime > 2)
    end

    -- تعديل FPDH مؤقتًا
    local oldFPDH = workspace.FallenPartsDestroyHeight
    workspace.FallenPartsDestroyHeight = math.huge

    -- BodyVelocity للقذف القوي
    local BV = Instance.new("BodyVelocity")
    BV.Name = "FlingBlast"
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    BV.Parent = RootPart

    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    -- اختيار أفضل جزء في هدف الفلينق
    local partToUse = (TRootPart and THead and (TRootPart.Position - THead.Position).Magnitude > 5) and THead
        or TRootPart or THead or Handle

    if partToUse then
        ExecuteFling(partToUse)
    else
        Window:Notify({
            Title = "Fling",
            Content = "ما قدرت ألاقي جزء مناسب للقذف!"
        })
        BV:Destroy()
        workspace.FallenPartsDestroyHeight = oldFPDH
        return
    end

    -- تنظيف
    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    workspace.CurrentCamera.CameraSubject = Humanoid
    workspace.FallenPartsDestroyHeight = oldFPDH

    -- إرجاع الموقع الأصلي
    local restoreCFrame = (getgenv().OldPos or RootPart.CFrame) * CFrame.new(0, 0.5, 0)
    repeat
        RootPart.CFrame = restoreCFrame
        Character:SetPrimaryPartCFrame(restoreCFrame)
        Humanoid:ChangeState("GettingUp")
        for _, child in ipairs(Character:GetChildren()) do
            if child:IsA("BasePart") then
                child.Velocity = Vector3.zero
                child.RotVelocity = Vector3.zero
            end
        end
        task.wait()
    until (RootPart.Position - restoreCFrame.Position).Magnitude < 25
end

-- ==================== إنشاء تاب Fling ====================
local FlingTab = Window:MakeTab({
    Title = "💥 Fling",
    Icon = "Bomb"
})

-- ===================================================================
-- ==================== قذف حسب الدور ====================
-- ===================================================================

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
                    SHubFling(murderer) -- استخدام دالة القذف
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
                    SHubFling(target) -- استخدام دالة القذف
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

-- ===================================================================
-- ==================== قذف الكل (الأبادة) ====================
-- ===================================================================

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
                            SHubFling(player) -- استخدام دالة القذف
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

-- ===================================================================
-- ==================== قذف لاعب محدد ====================
-- ===================================================================

FlingTab:AddSection("🎯 قذف لاعب محدد")

-- متغيرات
local SelectedPlayerName = nil

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

-- القائمة المنسدلة (Dropdown)
local PlayerDropdown = FlingTab:AddDropdown({
    Name = "🎯 اختر لاعب للقذف",
    Options = GetPlayerNames(),
    Default = GetPlayerNames()[1] or "",
    Callback = function(Value)
        SelectedPlayerName = Value
    end
})

FlingTab:AddButton({
    Name = "🚀 قذف اللاعب المحدد",
    Callback = function()
        if not SelectedPlayerName then
            Window:Notify({
                Title = "Fling",
                Content = "يرجى اختيار لاعب من القائمة أولًا!"
            })
            return
        end

        local TargetPlayer = Players:FindFirstChild(SelectedPlayerName)
        if not TargetPlayer then
            Window:Notify({
                Title = "Fling",
                Content = "اللاعب غير موجود حالياً!"
            })
            SelectedPlayerName = nil
            return
        end

        SHubFling(TargetPlayer)

        Window:Notify({
            Title = "Fling",
            Content = "تم قذف " .. TargetPlayer.Name .. " بنجاح! 💥"
        })
    end
})

-- تحديث القائمة عند دخول/خروج لاعب
Players.PlayerAdded:Connect(function()
    task.wait(0.5)
    PlayerDropdown:NewOptions(GetPlayerNames())
    if not table.find(GetPlayerNames(), SelectedPlayerName) then
        SelectedPlayerName = GetPlayerNames()[1] or nil
        PlayerDropdown:SetValue(SelectedPlayerName or "")
    end
end)

Players.PlayerRemoving:Connect(function()
    task.wait(0.1)
    PlayerDropdown:NewOptions(GetPlayerNames())
    if not table.find(GetPlayerNames(), SelectedPlayerName) then
        SelectedPlayerName = GetPlayerNames()[1] or nil
        PlayerDropdown:SetValue(SelectedPlayerName or "")
    end
end)

-- ===================================================================
-- ==================== إعدادات القذف ====================
-- ===================================================================

FlingTab:AddSection("⚙️ إعدادات القذف")

FlingTab:AddSlider({
    Name = "وقت القذف (بالثواني)",
    Min = 0.5,
    Max = 10,
    Default = 2.5,
    Increment = 0.1,
    Callback = function(Value)
        Window:Notify({
            Title = "⏱️ تم ضبط الوقت",
            Content = "تم ضبط وقت القذف إلى " .. string.format("%.1f", Value) .. " ثانية",
            Duration = 3
        })
    end
})
