local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()


-- Fling Section
local FlingSection = Tab:AddSection("Fling")

-- قائمة اللاعبين (يتم تحديثها تلقائيًا)
local PlayerList = {}
for _, Player in pairs(game.Players:GetPlayers()) do
  if Player.Name ~= game.Players.LocalPlayer.Name then
    table.insert(PlayerList, Player.Name)
  end
end

FlingSection:AddDropdown({
  Name = "Players To Fling",
  Options = PlayerList,
  Default = PlayerList[1] or nil,
  Callback = function(Value)
    -- اختيار لاعب معين للقذف
    vu35.PlayerToFling = Value
  end
})

FlingSection:AddButton({
  Name = "Fling Murderer",
  Callback = function()
    -- قذف القاتل
    local MurdererName = tostring(vu36.Gameplay.Murderer)
    if MurdererName and MurdererName ~= "None" then
      FlingKill(MurdererName)
    else
      print("Murderer not found!")
    end
  end
})

FlingSection:AddButton({
  Name = "Fling Sheriff",
  Callback = function()
    -- قذف الشريف
    local SheriffName = tostring(vu36.Gameplay.Sheriff)
    if SheriffName and SheriffName ~= "None" then
      FlingKill(SheriffName)
    else
      print("Sheriff not found!")
    end
  end
})

FlingSection:AddButton({
  Name = "Fling All",
  Callback = function()
    -- قذف جميع اللاعبين
    for _, Player in pairs(game.Players:GetPlayers()) do
      if Player.Name ~= game.Players.LocalPlayer.Name and not IsPlayerWhitelisted(Player.Name) then
        FlingKill(Player.Name)
      end
    end
  end
})

FlingSection:AddToggle({
  Name = "Auto Fling Player",
  Default = false,
  Callback = function(Value)
    -- تفعيل/تعطيل القذف التلقائي للاعب محدد
    if Value then
      vu35.AutoFlingPlayer = true
      while vu35.AutoFlingPlayer and task.wait(0.1) do
        if vu35.PlayerToFling then
          FlingKill(vu35.PlayerToFling)
        end
      end
    else
      vu35.AutoFlingPlayer = false
    end
  end
})












-- Murderer Section
local MurdererSection = Tab:AddSection("Murderer")

MurdererSection:AddButton({
  Name = "Kill Sheriff",
  Callback = function()
    -- قتل الشريف فقط
    local SheriffName = tostring(vu36.Gameplay.Sheriff)
    if SheriffName and SheriffName ~= "None" then
      if tostring(vu36.Gameplay.Murderer) == game.Players.LocalPlayer.Name then
        KillPlayer(SheriffName, true)
      else
        print("You are not the murderer!")
      end
    else
      print("Sheriff not found!")
    end
  end
})

MurdererSection:AddButton({
  Name = "Kill Everyone",
  Callback = function()
    -- قتل جميع اللاعبين
    if tostring(vu36.Gameplay.Murderer) == game.Players.LocalPlayer.Name then
      for _, Player in pairs(game.Players:GetPlayers()) do
        if Player.Name ~= game.Players.LocalPlayer.Name and not IsPlayerWhitelisted(Player.Name) then
          KillPlayer(Player.Name, true)
        end
      end
    else
      print("You are not the murderer!")
    end
  end
})

MurdererSection:AddToggle({
  Name = "Auto Kill Sheriff",
  Default = false,
  Callback = function(Value)
    -- تفعيل/تعطيل القتل التلقائي للشريف
    vu35.AutoKillSheriff = Value
    if Value then
      local MurdererName = tostring(vu36.Gameplay.Murderer)
      local SheriffName = tostring(vu36.Gameplay.Sheriff)
      if MurdererName == game.Players.LocalPlayer.Name and SheriffName and SheriffName ~= "None" then
        KillPlayer(SheriffName, true)
      end
    end
  end
})

MurdererSection:AddToggle({
  Name = "Auto Kill Everyone",
  Default = false,
  Callback = function(Value)
    -- تفعيل/تعطيل القتل التلقائي للجميع
    vu35.AutoKillEveryone = Value
    if Value and tostring(vu36.Gameplay.Murderer) == game.Players.LocalPlayer.Name then
      for _, Player in pairs(game.Players:GetPlayers()) do
        if Player.Name ~= game.Players.LocalPlayer.Name and not IsPlayerWhitelisted(Player.Name) then
          KillPlayer(Player.Name, true)
        end
      end
    end
  end
})

MurdererSection:AddToggle({
  Name = "Kill Aura",
  Default = false,
  Callback = function(Value)
    -- تفعيل/تعطيل قتل تلقائي لمن حولك
    vu35.KillAura = Value
    if Value then
      vu35.KillAuraLoop = true
      while vu35.KillAuraLoop and vu35.KillAura do
        task.wait()
        for _, Player in pairs(game.Players:GetPlayers()) do
          if Player.Name ~= game.Players.LocalPlayer.Name and not IsPlayerWhitelisted(Player.Name) then
            local Character = Player.Character
            if Character then
              local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
              if HumanoidRootPart then
                local Distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - HumanoidRootPart.Position).Magnitude
                if Distance <= vu35.KillAuraRange then
                  KillPlayer(Player.Name, true)
                end
              end
            end
          end
        end
      end
    else
      vu35.KillAuraLoop = false
    end
  end
})

MurdererSection:AddSlider({
  Name = "Kill Aura Range",
  Min = 1,
  Max = 60,
  Default = 10,
  Callback = function(Value)
    -- تحديد مدى Kill Aura
    vu35.KillAuraRange = Value
  end
})
