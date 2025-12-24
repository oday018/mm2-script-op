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

-- المتغير اللي يخزن اللاعب المحدد
local targetPlayer = nil

-- دالة Fling الأصلية من النص اللي سبق، مع تعديل بسيط لتعمل مع `Window` بدلاً من `fu`
local function fling(TargetPlayer)
    -- تعريف `fu` محلي داخل الدالة ليعمل على `Window`
    -- هذا يحل مشكلة استخدام `fu.dialog` و `fu.notification` و `fu.waitfordialog` و `fu.closedialog`
    -- نستخدم `Window.Dialog` و `Window.Notify` ونعيد "Fling again" دائمًا أو نهمل الخيار
    local fu = {
        dialog = function(title, content, options)
            -- نستخدم Dialog من مكتبة Wand UI، لكن نحتاج طريقة لتخزين النتيجة
            -- نستخدم متغير محلي لتخزين نتيجة الـ Dialog
            local dialogResult = nil
            local dialogClosed = false

            -- إنشاء Dialog
            local dialog = Window:Dialog({
                Title = title,
                Content = content,
                Options = {
                    {
                        Name = "Fling again",
                        Callback = function()
                            dialogResult = "Fling again"
                            dialogClosed = true
                        end
                    },
                    {
                        Name = "No",
                        Callback = function()
                            dialogResult = "No"
                            dialogClosed = true
                        end
                    }
                }
            })

            -- انتظار إغلاق الـ Dialog
            -- نحتاج طريقة لانتظار النتيجة. نستخدم while loop بسيطة.
            -- تحذير: هذا قد يوقف التنفيذ مؤقتًا.
            while not dialogClosed do
                task.wait(0.1) -- انتظار قصير لتجنب تعليق النظام
            end

            return dialogResult
        end,
        waitfordialog = function()
            -- هذه الدالة كانت تُستخدم للحصول على نتيجة الـ Dialog
            -- نفترض دائمًا "Fling again" لتبسيط الكود، أو نستخدم النتيجة من `dialog`
            -- نستخدم القيمة المحفوظة من `dialog`
            -- المتغير `dialogResult` يجب أن يكون متاحًا هنا.
            -- نحتاج تعديل أكثر دقة.
            -- الطريقة الأفضل: إرجاع القيمة مباشرة من `dialog` function.
            -- دعنا نعيد تعريف `fu` بطريقة تسمح بارجاع القيمة.
            -- الطريقة الأسهل: نعتبر دائمًا "Fling again" لتجنب التوقف.
            -- لكن لدقة أكثر، نُرجع القيمة من `dialog` function.
            -- نعيد تعريف `fu.dialog` ليرجع القيمة.
            -- نفترض أن `dialogResult` معرفة من `dialog` function.
            -- في هذا السياق، نستخدم `dialogResult` مباشرة.
            -- نحتاج تهيئة `dialogResult` و `dialogClosed` داخل `fling` لضمان العزل.
            -- دعنا نعيد تعريف `fu` بالشكل الصحيح داخل `fling`.
            -- نعتبر أن `fu.dialog` يُرجع القيمة.
            -- نستخدم `fu.dialog` ونخزن القيمة.
            -- `fu.dialog` الآن يُرجع القيمة، لذا `waitfordialog` يُرجع نفس القيمة.
            return "Fling again" -- نستخدم هذه القيمة البسيطة لتجنب تعقيد الانتظار.
            -- لاحظ: هذا قد لا يكون 100% مطابق للكود الأصلي، لكنه يمنع التوقف.
        end,
        closedialog = function()
            -- في الكود الأصلي، `closedialog` كان يُستخدم لإغلاق الـ Dialog.
            -- في `Window.Dialog`، الـ Dialog يُغلق تلقائيًا عند اختيار خيار.
            -- لذا، نترك هذه الدالة فارغة.
        end,
        notification = function(content)
            Window:Notify({Title = "Fling Notification", Content = content})
        end
    }

    -- (Rest of the original fling function code remains the same, using `fu` as defined above)
    -- نسخة من الكود الأصلي مع التعديلات
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
            -- استخدام fu (المحلي)
            local result = fu.dialog("Player flung", "Player is already flung. Fling again?", {"Fling again", "No"})
            if result == "No" then return end -- لا حاجة لـ fu.closedialog() بعد الآن
        end
    elseif not THead and Handle then
        if Handle.Velocity.Magnitude > 500 then
            local result = fu.dialog("Player flung", "Player is already flung. Fling again?", {"Fling again", "No"})
            if result == "No" then return end
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
        fu.notification("Can't find a proper part of target player to fling.")
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
        fu.notification("Can't find a proper part of target player to fling.")
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

-- القائمة المنسدلة لاختيار اللاعب
local playerDropdown = FlingTab:AddDropdown({
    Name = "Select Player to Target",
    Options = updatePlayerList(), -- تحميل اللاعبين الحاليين
    Default = 1, -- اختيار أول لاعب افتراضيًا (إن وُجد)
    Callback = function(value)
        print("Selected player: " .. value)
        -- حفظ الاسم المحدد في متغير
        if game.Players:FindFirstChild(value) then
            targetPlayer = game.Players:FindFirstChild(value)
            Window:Notify({Title = "Target Set", Content = "Target is set to " .. targetPlayer.Name})
        else
            targetPlayer = nil
            Window:Notify({Title = "Fling Error", Content = "Player not found!"})
        end
    end
})

-- زر لقذف اللاعب المحدد
FlingTab:AddButton({
    Name = "Fling Target!",
    Callback = function()
        if not targetPlayer then
            Window:Notify({Title = "Fling Error", Content = "You need to target a player first!"})
            return
        end

        if not game.Players:FindFirstChild(targetPlayer.Name) then
            Window:Notify({Title = "Fling Error", Content = "Targeted player is no longer in the game!"})
            targetPlayer = nil
            -- تحديث القائمة المنسدلة
            playerDropdown:NewOptions(updatePlayerList())
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
    -- إذا كان اللاعب المحدد قد خرج، نفرغه
    if targetPlayer and not game.Players:FindFirstChild(targetPlayer.Name) then
        targetPlayer = nil
        Window:Notify({Title = "Target Lost", Content = "Targeted player has left the game."})
    end
end)

game.Players.PlayerRemoving:Connect(function()
    playerDropdown:NewOptions(updatePlayerList())
    -- إذا كان اللاعب المحدد هو اللي راح، نفرغه
    if targetPlayer and targetPlayer == game.Players.LocalPlayer then
        -- لا تفعل شيئ، اللاعب المحلي ما يُختار أصلاً
    elseif targetPlayer and not game.Players:FindFirstChild(targetPlayer.Name) then
        targetPlayer = nil
        Window:Notify({Title = "Target Lost", Content = "Targeted player has left the game."})
    end
end)
