-- ✨ Wand UI (Redz Library V5 Remake)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
  Title = "Blox Fruits - Aim Bot Skill",
  SubTitle = "يعمل في جميع السياس - Aim Bot للمهارات (Devil Fruit)",
  ScriptFolder = "blox-fruits-aimbot-skill"
})

local AimBotTab = Window:MakeTab({
  Title = "Aim Bot Skill",
  Icon = "target"
})

-- الدالة الأساسية للـ Aim Bot (توجيه الكاميرا نحو العدو الأقرب)
local function GetNearestEnemy()
    local NearestEnemy = nil
    local NearestMagnitude = math.huge
    local LocalPlayer = game.Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

    for _, Enemy in pairs(game.Workspace.Enemies:GetChildren()) do
        if Enemy:FindFirstChild("Humanoid") and Enemy.Humanoid.Health > 0 and Enemy:FindFirstChild("HumanoidRootPart") then
            local Magnitude = (Enemy.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
            if Magnitude < NearestMagnitude then
                NearestMagnitude = Magnitude
                NearestEnemy = Enemy.HumanoidRootPart
            end
        end
    end
    return NearestEnemy
end

-- Aim Bot Skill Toggle
AimBotTab:AddSection("إعدادات Aim Bot للمهارات")

AimBotTab:AddToggle({
  Name = "Aim Bot Skill (توجيه الكاميرا نحو العدو)",
  Default = true,
  Callback = function(Value)
    getgenv().AimBotSkill = Value
  end
})

AimBotTab:AddToggle({
  Name = "Skill Z",
  Default = true,
  Callback = function(Value)
    getgenv().SkillZ = Value
  end
})

AimBotTab:AddToggle({
  Name = "Skill X",
  Default = true,
  Callback = function(Value)
    getgenv().SkillX = Value
  end
})

AimBotTab:AddToggle({
  Name = "Skill C",
  Default = true,
  Callback = function(Value)
    getgenv().SkillC = Value
  end
})

AimBotTab:AddToggle({
  Name = "Skill V",
  Default = true,
  Callback = function(Value)
    getgenv().SkillV = Value
  end
})

AimBotTab:AddToggle({
  Name = "Skill F",
  Default = false,
  Callback = function(Value)
    getgenv().SkillF = Value
  end
})

-- اللوب الرئيسي لتفعيل الـ Aim Bot والمهارات
spawn(function()
    while task.wait() do
        if getgenv().AimBotSkill then
            local EnemyPart = GetNearestEnemy()
            if EnemyPart then
                workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, EnemyPart.Position)
            end
        end
    end
end)

-- لوب لاستخدام المهارات تلقائياً عند وجود عدو قريب
spawn(function()
    while task.wait(0.5) do
        if GetNearestEnemy() and (getgenv().SkillZ or getgenv().SkillX or getgenv().SkillC or getgenv().SkillV or getgenv().SkillF) then
            if getgenv().SkillZ then game:GetService("VirtualInputManager"):SendKeyEvent(true, "Z", false, game) task.wait(0.1) game:GetService("VirtualInputManager"):SendKeyEvent(false, "Z", false, game) end
            if getgenv().SkillX then game:GetService("VirtualInputManager"):SendKeyEvent(true, "X", false, game) task.wait(0.1) game:GetService("VirtualInputManager"):SendKeyEvent(false, "X", false, game) end
            if getgenv().SkillC then game:GetService("VirtualInputManager"):SendKeyEvent(true, "C", false, game) task.wait(0.1) game:GetService("VirtualInputManager"):SendKeyEvent(false, "C", false, game) end
            if getgenv().SkillV then game:GetService("VirtualInputManager"):SendKeyEvent(true, "V", false, game) task.wait(0.1) game:GetService("VirtualInputManager"):SendKeyEvent(false, "V", false, game) end
            if getgenv().SkillF then game:GetService("VirtualInputManager"):SendKeyEvent(true, "F", false, game) task.wait(0.1) game:GetService("VirtualInputManager"):SendKeyEvent(false, "F", false, game) end
        end
    end
end)

Window:Notify({
  Title = "Aim Bot Skill جاهز!",
  Content = "الآن يوجه الكاميرا نحو العدو الأقرب ويستخدم المهارات تلقائياً\nيعمل في كل السياس بدون مشاكل (تم تحديث الطريقة لعام 2025)",
  Duration = 10
})

AimBotTab:AddParagraph({
  Title = "ملاحظة",
  Content = "• شغل الـ Aim Bot Skill\n• اقترب من عدو (NPC)\n• الكاميرا ستتجه تلقائياً نحوه والمهارات المفعلة ستُستخدم\n• يعمل مع Devil Fruit skills بشكل مثالي\nاستخدم بحذر عشان ما تتبند!"
})
