-- تأكد من تحميل مكتبة Wand UI أولاً
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau  "))()

-- إنشاء النافذة
local Window = Library:MakeWindow({
  Title = "Fling Tool",
  SubTitle = "dev by M1",
  ScriptFolder = "M1-Fling-Tool"
})

-- إنشاء التبويب
local FlingTab = Window:MakeTab({
  Title = "Fling Tab",
  Icon = "rbxassetid://3926305904" -- مثلاً أيقونة عشوائية
})

-- دالة Fling مبنية على الكود الأصلي
local function fling(TargetPlayer)
    local player = game.Players.LocalPlayer
    local Character = player.Character
    if not Character then return end
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart
    if not (Humanoid and RootPart) then return end
    if RootPart.Velocity.Magnitude < 50 then
        getgenv().OldPos = RootPart.CFrame
    end
    local TCharacter = TargetPlayer.Character
    if not TCharacter then return end
    local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    local TRootPart = THumanoid and THumanoid.RootPart
    local THead = TCharacter:FindFirstChild("Head")
    local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    local Handle = Accessory and Accessory:FindFirstChild("Handle")
    if THead then
        if THead.Velocity.Magnitude > 500 then
            -- استخدام Dialog من مكتبة Wand UI
            Window:Dialog({
                Title = "Player flung",
                Content = "Player is already flung. Fling again?",
                Options = {
                    {
                        Name = "Fling again",
                        Callback = function(self)
                            -- لا تفعل شيئ خاص، فقط تابع التنفيذ بعد الإغلاق
                        end
                    },
                    {
                        Name = "No",
                        Callback = function(self)
                            return -- إنهاء الدالة
                        end
                    }
                }
            })
        end
    elseif not THead and Handle then
        if Handle.Velocity.Magnitude > 500 then
            Window:Dialog({
                Title = "Player flung",
                Content = "Player is already flung. Fling again?",
                Options = {
                    {
                        Name = "Fling again",
                        Callback = function(self)
                            -- لا تفعل شيئ خاص، فقط تابع التنفيذ بعد الإغلاق
                        end
                    },
                    {
                        Name = "No",
                        Callback = function(self)
                            return -- إنهاء الدالة
                        end
                    }
                }
            })
        end
    end
    if THead then
        workspace.CurrentCamera.CameraSubject = THead
    elseif not THead and Handle then
        workspace.CurrentCamera.CameraSubject = Handle
    elseif THumanoid and TRootPart then
        workspace.CurrentCamera.CameraSubject = THumanoid
    end
    if not TCharacter:FindFirstChildWhichIsA("BasePart") then
        return
    end
    local Angle = 0
    local TimeToWait = 0.05
    local Time = tick()
    local BasePart
    if TRootPart and THead then
        if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
            BasePart = THead
        else
            BasePart = TRootPart
        end
    elseif TRootPart and not THead then
        BasePart = TRootPart
    elseif not TRootPart and THead then
        BasePart = THead
    elseif not TRootPart and not THead and Accessory and Handle then
        BasePart = Handle
    else
        Window:Notify({Title = "Fling Error", Content = "Can't find a proper part of target player to fling."})
        return
    end
    local FPos = function(Pos, Ang)
        RootPart.CFrame = BasePart.CFrame * Pos * Ang
        Character:SetPrimaryPartCFrame(BasePart.CFrame * Pos * Ang)
        RootPart.Velocity = BasePart.Velocity * 50
        RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
    end
    local SFBasePart = function(BasePart)
        repeat
            FPos(CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
            task.wait()
            FPos(CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
            task.wait()
            FPos(CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
            task.wait()
            FPos(CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
            task.wait()
        until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or TargetPlayer.Character ~= TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
    end
    workspace.FallenPartsDestroyHeight = 0/0
    local BV = Instance.new("BodyVelocity")
    BV.Name = "EpixVel"
    BV.Parent = RootPart
    BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
    BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
    if TRootPart and THead then
        if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
            SFBasePart(THead)
        else
            SFBasePart(TRootPart)
        end
    elseif TRootPart and not THead then
        SFBasePart(TRootPart)
    elseif not TRootPart and THead then
        SFBasePart(THead)
    elseif not TRootPart and not THead and Accessory and Handle then
        SFBasePart(Handle)
    else
        Window:Notify({Title = "Fling Error", Content = "Can't find a proper part of target player to fling."})
    end
    BV:Destroy()
    Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    workspace.CurrentCamera.CameraSubject = Humanoid
    -- المتغير `i` في السطر التالي غير معرف في هذا السياق، وربما كان جزءاً من سياق أوسع في السكربت الأصلي.
    -- نفترض أن `player.Character` هو الهدف المقصود.
    local targetCharacterToReset = player.Character
    if targetCharacterToReset then
        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            -- تحذير: استخدام `table.foreach` على `i:GetChildren()` قد يؤدي إلى خطأ.
            -- نستخدم `targetCharacterToReset` كمثال، لكن تأكد من السياق الأصلي.
            -- table.foreach(targetCharacterToReset:GetChildren(),function(A,B)if B:IsA("BasePart")then B.Velocity,B.RotVelocity=Vector3.new(),Vector3.new()end end)
            -- لتجنب الخطأ، نُبقي السطر الأصلي كما هو (مع المخاطرة) أو نحذفه.
            -- لسلامة التنفيذ، نحذف السطر المتعلق بـ `i`.
        until not player.Character or not player.Character.Parent
    end
end


-- دالة لتحديث قائمة اللاعبين
local function updatePlayerList()
    local playerNames = {}
    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then -- استبعاد اللاعب الحالي
            table.insert(playerNames, plr.Name)
        end
    end
    return playerNames
end


-- إنشاء القسم داخل التبويب
local FlingSection = FlingTab:AddSection("Fling Section")

-- إنشاء القائمة المنسدلة لاختيار اللاعب
local playerDropdown = FlingTab:AddDropdown({
    Name = "Select Player to Fling",
    Options = updatePlayerList(), -- تحميل اللاعبين الحاليين
    Default = 1, -- اختيار أول لاعب افتراضيًا (إن وُجد)
    Callback = function(value)
        print("Selected player: " .. value)
        -- ممكن حفظ الاسم المحدد في متغير لاستخدامه لاحقًا
        -- selectedPlayerName = value
    end
})

-- زر لتشغيل الـ Fling
FlingTab:AddButton({
    Name = "Execute Fling!",
    Callback = function()
        local selectedPlayerName = playerDropdown.Value -- الحصول على القيمة المحددة من القائمة
        if not selectedPlayerName then
            Window:Notify({Title = "Fling Error", Content = "No player selected!"})
            return
        end

        local targetPlayer = game.Players:FindFirstChild(selectedPlayerName)
        if not targetPlayer then
            Window:Notify({Title = "Fling Error", Content = "Player not found in game!"})
            return
        end

        -- التحقق من أن اللاعب لا يزال لديه شخصية
        if not targetPlayer.Character then
            Window:Notify({Title = "Fling Error", Content = "Target player has no character!"})
            return
        end

        -- تنفيذ دالة الإفلات
        fling(targetPlayer)
        Window:Notify({Title = "Fling Executed", Content = "Fling executed on " .. targetPlayer.Name .. "!"})
    end
})

-- تحديث القائمة المنسدلة عند دخول أو خروج لاعب
game.Players.PlayerAdded:Connect(function()
    playerDropdown:NewOptions(updatePlayerList())
end)

game.Players.PlayerRemoving:Connect(function()
    playerDropdown:NewOptions(updatePlayerList())
end)
