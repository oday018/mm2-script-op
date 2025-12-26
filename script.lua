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

-- حفظ FPDH الأصلي
if not getgenv().FPDH then
    getgenv().FPDH = workspace.FallenPartsDestroyHeight
end

-- دالة بحث عن اللاعب
local function findPlayer(input)
    if not input or input == "" then return nil end
    input = tostring(input):lower()
    if tonumber(input) then
        local plr = Players:GetPlayerByUserId(tonumber(input))
        if plr then return plr end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name:lower():find(input, 1, true) then
            return plr
        end
    end
    return nil
end

-- ==================== إنشاء تاب Fling ====================
local FlingTab = Window:MakeTab({
    Title = "💥 Fling",
    Icon = "Flame" -- يمكنك تغيير الأيقونة لـ "Bomb", "Rocket", أو حذفها
})

-- متغير لتخزين الهدف
local TargetPlayer = nil

-- ==================== حقل إدخال: إدخال اسم/ID اللاعب ====================
FlingTab:AddTextBox({
    Name = "🎯 اسم أو ID اللاعب",
    Placeholder = "اكتب اسم اللاعب هنا...",
    ClearOnFocus = true,
    Callback = function(input)
        if not input or input == "" then
            Window:Notify({
                Title = "Fling",
                Content = "يرجى إدخال اسم اللاعب!"
            })
            TargetPlayer = nil
            return
        end

        local player = findPlayer(input)
        if not player then
            Window:Notify({
                Title = "Fling",
                Content = "اللاعب غير موجود!"
            })
            TargetPlayer = nil
            return
        end

        TargetPlayer = player
        Window:Notify({
            Title = "Fling",
            Content = "الهدف: " .. player.Name
        })
    end
})

-- ==================== زر القذف ====================
FlingTab:AddButton({
    Name = "🚀 قذف اللاعب",
    Debounce = 0.5,
    Callback = function()
        if not TargetPlayer then
            Window:Notify({
                Title = "Fling",
                Content = "حدد لاعبًا أولًا!"
            })
            return
        end

        if not Players:FindFirstChild(TargetPlayer.Name) then
            Window:Notify({
                Title = "Fling",
                Content = "اللاعب خرج من اللعبة!"
            })
            TargetPlayer = nil
            return
        end

        local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
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
                Content = "الهدف ما عنده شخصية!"
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

        -- دالة التموضع والقذف
        local function applyFling(BasePart, Pos, Ang)
            local cf = CFrame.new(BasePart.Position) * Pos * Ang
            RootPart.CFrame = cf
            Character:SetPrimaryPartCFrame(cf)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end

        -- منطق الفلينق
        local function executeFling(BasePart)
            local startTime = tick()
            local angle = 0

            repeat
                if not (RootPart and THumanoid and BasePart and BasePart.Parent == TCharacter) then break end

                if BasePart.Velocity.Magnitude < 50 then
                    angle += 100
                    local dir = THumanoid.MoveDirection
                    local mag = BasePart.Velocity.Magnitude / 1.25
                    applyFling(BasePart, CFrame.new(0, 1.5, 0) + dir * mag, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()
                    applyFling(BasePart, CFrame.new(0, -1.5, 0) + dir * mag, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()
                    applyFling(BasePart, CFrame.new(2.25, 1.5, -2.25) + dir * mag, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()
                    applyFling(BasePart, CFrame.new(-2.25, -1.5, 2.25) + dir * mag, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()
                    applyFling(BasePart, CFrame.new(0, 1.5, 0) + dir, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()
                    applyFling(BasePart, CFrame.new(0, -1.5, 0) + dir, CFrame.Angles(math.rad(angle), 0, 0))
                    task.wait()
                else
                    local ws = THumanoid.WalkSpeed
                    local vmag = TRootPart and TRootPart.Velocity.Magnitude or 0
                    applyFling(BasePart, CFrame.new(0, 1.5, ws), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                    applyFling(BasePart, CFrame.new(0, -1.5, -ws), CFrame.Angles(0, 0, 0)); task.wait()
                    applyFling(BasePart, CFrame.new(0, 1.5, ws), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                    applyFling(BasePart, CFrame.new(0, 1.5, vmag / 1.25), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                    applyFling(BasePart, CFrame.new(0, -1.5, -vmag / 1.25), CFrame.Angles(0, 0, 0)); task.wait()
                    applyFling(BasePart, CFrame.new(0, 1.5, vmag / 1.25), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                    applyFling(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0)); task.wait()
                    applyFling(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0)); task.wait()
                    applyFling(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0)); task.wait()
                    applyFling(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0)); task.wait()
                end
            until BasePart.Velocity.Magnitude > 500
                or BasePart.Parent ~= TCharacter
                or TargetPlayer.Parent ~= Players
                or TargetPlayer.Character ~= TCharacter
                or (THumanoid and THumanoid.Sit)
                or Humanoid.Health <= 0
                or (tick() - startTime > 2)
        end

        -- تعديل FPDH مؤقت
        local oldFPDH = workspace.FallenPartsDestroyHeight
        workspace.FallenPartsDestroyHeight = math.huge

        -- BodyVelocity
        local BV = Instance.new("BodyVelocity")
        BV.Name = "FlingBlast"
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BV.Parent = RootPart

        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

        -- اختيار أفضل جزء
        local partToUse = (TRootPart and THead and (TRootPart.Position - THead.Position).Magnitude > 5) and THead
            or TRootPart or THead or Handle

        if partToUse then
            executeFling(partToUse)
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

        -- إرجاع الموضع
        local restore = (getgenv().OldPos or RootPart.CFrame) * CFrame.new(0, 0.5, 0)
        repeat
            RootPart.CFrame = restore
            Character:SetPrimaryPartCFrame(restore)
            Humanoid:ChangeState("GettingUp")
            for _, child in ipairs(Character:GetChildren()) do
                if child:IsA("BasePart") then
                    child.Velocity = Vector3.zero
                    child.RotVelocity = Vector3.zero
                end
            end
            task.wait()
        until (RootPart.Position - restore.Position).Magnitude < 25

        Window:Notify({
            Title = "Fling",
            Content = "تم قذف " .. TargetPlayer.Name .. " بنجاح! 💥"
        })
    end
})
