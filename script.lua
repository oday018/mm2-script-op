-- ✨ Wand UI (Redz Library V5 Remake)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
  Title = "Blox Fruits - Aim Bot / Bounty Hunter",
  SubTitle = "Universal All Maps/Seas - Player Killer",
  ScriptFolder = "blox-fruits-aimbot"
})

local AimBotTab = Window:MakeTab({
  Title = "Aim Bot & Bounty Hunter",
  Icon = "target"
})

-- Necessary Functions
function AutoHaki()
    if not game:GetService("Players").LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end

function EquipWeapon(WeaponName)
    if game.Players.LocalPlayer.Backpack:FindFirstChild(WeaponName) then
        game.Players.LocalPlayer.Backpack[WeaponName].Parent = game.Players.LocalPlayer.Character
    end
end

local topos = function(pos)
    local tweenService = game:GetService("TweenService")
    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    local distance = (pos.Position - humanoidRootPart.Position).Magnitude
    local tweenInfo = TweenInfo.new(distance / 300, Enum.TweenStatus.InProgress)
    local tween = tweenService:Create(humanoidRootPart, tweenInfo, {CFrame = pos})
    tween:Play()
end

-- Aim Bot Tab Content
AimBotTab:AddSection("Universal Bounty / Player Hunter")

AimBotTab:AddToggle({
  Name = "Auto Bounty Hunt (Player Killer)",
  Description = "يبحث عن لاعبين في كل المابات ويهاجمهم تلقائياً (يعمل في جميع السياس)",
  Default = false,
  Callback = function(Value)
    _G.AutoBountyHunt = Value
  end
})

AimBotTab:AddDropdown({
  Name = "Select Weapon",
  Description = "اختر السلاح للـ Aim Bot",
  Options = {"Melee", "Sword", "Gun", "Fruit"}, -- يمكن تعديلها حسب أسلحتك
  Default = "Melee",
  Callback = function(Value)
    _G.SelectWeapon = Value
  end
})

AimBotTab:AddToggle({
  Name = "Auto Get Player Hunter Quest",
  Description = "يأخذ الـ Quest تلقائياً إذا لم يكن موجود",
  Default = true,
  Callback = function(Value)
    _G.AutoGetQuest = Value
  end
})

AimBotTab:AddToggle({
  Name = "Enable PVP",
  Description = "يفعل PVP تلقائياً",
  Default = true,
  Callback = function(Value)
    _G.EnablePVP = Value
  end
})

-- Main Loop for Bounty Hunt (Universal - All Maps)
spawn(function()
  while wait(0.1) do
    if _G.AutoBountyHunt then
      pcall(function()
        -- Enable PVP if disabled
        if _G.EnablePVP and game:GetService("Players").LocalPlayer.PlayerGui.Main.PvpDisabled.Visible then
          game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
        end

        -- Get Quest if not active
        if _G.AutoGetQuest and not game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
          game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
        end

        -- Find and attack target player from quest
        if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible then
          local questTitle = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
          for _, player in pairs(game:GetService("Workspace").Characters:GetChildren()) do
            if player.Name ~= game.Players.LocalPlayer.Name and string.find(questTitle, player.Name) and player:FindFirstChild("Humanoid") and player.Humanoid.Health > 0 then
              repeat
                wait()
                AutoHaki()
                EquipWeapon(_G.SelectWeapon or "Melee")
                topos(player.HumanoidRootPart.CFrame * CFrame.new(0, 30, 5)) -- فوق اللاعب قليلاً
                player.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
              until not _G.AutoBountyHunt or player.Humanoid.Health <= 0 or not game:GetService("Players"):FindFirstChild(player.Name)
              -- Abandon quest after kill
              game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
            end
          end
        end
      end)
    end
  end
end)

AimBotTab:AddParagraph({
  Title = "ملاحظة مهمة",
  Content = "هذا الـ Aim Bot يعمل في جميع المابات والسياس (Sea 1/2/3)\nلا يعتمد على موقع معين، يبحث عن اللاعب المطلوب في الـ Quest أينما كان.\nاستخدم بحذر لتجنب الباند!"
})

Window:Notify({
  Title = "Aim Bot Loaded",
  Content = "الآن جاهز للصيد في كل المابات!",
  Duration = 8
})
