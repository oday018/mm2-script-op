-- ==================== تحميل المكتبة ====================
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- ==================== إنشاء النافذة ====================
local Window = Library:MakeWindow({
    Title = "🎮 سكربت MM2 العربي",
    SubTitle = "جميع الميزات | النسخة الكاملة",
    ScriptFolder = "MM2-Arabic-Ultimate"
})

-- ==================== Fling Module متكامل داخل الواجهة ====================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local workspace = workspace

-- === دالة للبحث عن اللاعب (تدعم الاسم الجزئي، الرقم، إلخ) ===
local function getPlayer(input, fallback)
    if not input then return fallback and fallback.Name end
    input = tostring(input):lower()
    if tonumber(input) then
        local plr = Players:GetPlayerByUserId(tonumber(input))
        if plr then return plr.Name end
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name:lower():find(input, 1, true) then
            return plr.Name
        end
    end
    return fallback and fallback.Name
end

-- === متغير عالمي للـ FPDH لو ما كان معرف ===
if not getgenv().FPDH then
    getgenv().FPDH = workspace.FallenPartsDestroyHeight
end

-- === متغير لتخزين الهدف ===
local TargetPlayer = nil

-- ==================== إضافة قسم Fling إلى النافذة ====================
Window:MakeSection({
    Title = "💥 Fling",
    Description = "قذف اللاعبين بأسلوب احترافي",
    Buttons = {
        -- حقل إدخال: اختيار اللاعب
        {
            Type = "Input",
            Args = {"اسم أو ID اللاعب", "تعيين", function(Self, input)
                local name = getPlayer(input, LocalPlayer)
                local plr = Players:FindFirstChild(name)
                if not plr then
                    Window:Notify("Fling", "اللاعب غير موجود!")
                    return
                end
                TargetPlayer = plr
                Window:Notify("Fling", "الهدف: " .. plr.Name)
            end}
        },
        -- زر القذف
        {
            Type = "Button",
            Args = {"قذف اللاعب", function()
                if not TargetPlayer then
                    Window:Notify("Fling", "حدد لاعب أولًا!")
                    return
                end
                if not Players:FindFirstChild(TargetPlayer.Name) then
                    Window:Notify("Fling", "اللاعب خرج من اللعبة!")
                    TargetPlayer = nil
                    return
                end

                local Player = LocalPlayer
                local Character = Player.Character or Player.CharacterAdded:Wait()
                local Humanoid = Character:FindFirstChildOfClass("Humanoid")
                local RootPart = Humanoid and Humanoid.RootPart

                if not (Character and Humanoid and RootPart) then
                    Window:Notify("Fling", "شخصيتك غير جاهزة!")
                    return
                end

                local TCharacter = TargetPlayer.Character
                if not TCharacter then
                    Window:Notify("Fling", "الهدف ما عنده شخصية!")
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

                -- دالة تحريك الجذر
                local FPos = function(BasePart, Pos, Ang)
                    local cf = CFrame.new(BasePart.Position) * Pos * Ang
                    RootPart.CFrame = cf
                    Character:SetPrimaryPartCFrame(cf)
                    RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
                    RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
                end

                -- دالة الفلينق الأساسية
                local SFBasePart = function(BasePart)
                    local startTime = tick()
                    local timeout = 2
                    local angle = 0

                    repeat
                        if not (RootPart and THumanoid and BasePart and BasePart.Parent == TCharacter) then break end
                        if BasePart.Velocity.Magnitude < 50 then
                            angle = angle + 100
                            local dir = THumanoid.MoveDirection
                            FPos(BasePart, CFrame.new(0, 1.5, 0) + dir * (BasePart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, 0) + dir * (BasePart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + dir * (BasePart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + dir * (BasePart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, 1.5, 0) + dir, CFrame.Angles(math.rad(angle), 0, 0))
                            task.wait()
                            FPos(BasePart, CFrame.new(0, -1.5, 0) + dir, CFrame.Angles(math.rad(angle), 0, 0))
                            task.wait()
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
                        or (tick() - startTime > timeout)
                end

                -- تعديل FPDH مؤقتًا
                local oldFPDH = workspace.FallenPartsDestroyHeight
                workspace.FallenPartsDestroyHeight = math.huge

                -- BodyVelocity للقذف
                local BV = Instance.new("BodyVelocity")
                BV.Name = "FlingVel"
                BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
                BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                BV.Parent = RootPart

                Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

                -- اختيار أفضل جزء للقذف منه
                local partToUse = nil
                if TRootPart and THead and (TRootPart.Position - THead.Position).Magnitude > 5 then
                    partToUse = THead
                elseif TRootPart then
                    partToUse = TRootPart
                elseif THead then
                    partToUse = THead
                elseif Handle then
                    partToUse = Handle
                end

                if partToUse then
                    SFBasePart(partToUse)
                else
                    Window:Notify("Fling", "ما قدرت ألاقي جزء مناسب للقذف!")
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
            end}
        }
    }
})
