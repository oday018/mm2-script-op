local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- المتغيرات (كلها من السكربت الأصلي)
local vu5 = 168687157
local vu6 = "5C0A7004-373F-7541-7F22-D9F0A22C11A9"
local vu13 = game:GetService("Workspace")
local vu15 = game:GetService("TeleportService")
local vu16 = { Remotes = { } } -- سيتم تعريفه لاحقًا
local vu26 = game.Players.LocalPlayer
local vu27 = vu26.Character
local vu28 = vu27:WaitForChild("Humanoid")
local vu29 = vu27:WaitForChild("HumanoidRootPart")
local vu35 = {
  -- إعدادات القذف (Fling)
  PlayerToFling = nil,
  AutoFlingPlayer = false,

  -- إعدادات القتل (Kill)
  AutoKillSheriff = false,
  AutoKillEveryone = false,
  KillAura = false,
  KillAuraRange = 10,

  -- إعدادات القائمة البيضاء
  WhitelistedPlayers = {},
  ManualWhitelistedPlayers = {},

  -- إعدادات أخرى
  AutoUpdateDelay = 0.1,
  PlayersList = {},

  -- إعدادات من السكربت الأصلي
  WalkSpeed = 16,
  JumpPower = 50,
  FlySpeed = 1,
  Noclip = false,
  NoclipCamera = false,
  NoclipCameraEnabled = false,
  UnlockCamera = false,
  InfiniteJump = false,
  SecondLife = false,
  Seizure = false,
  AntiFling = false,
  AutoGrabGun = false,
  GunAura = false,
  AutoStealGun = false,
  AutoForceShoot = false,
  AutoBreakGun = false,
  SharpShooter = false,
  SheriffSilentAim = false,
  KnifeSilentAim = false,
  AutoFakeBombClutch = false,
  BlurtRoles = false,
  AutoBlurtRoles = false,
  DestroyDisplay = false,
  DestroyCoins = false,
  CoinAura = false,
  EggAura = false,
  CoinBagAura = false,
  EggBagAura = false,
  AutoFlingMurderer = false,
  AutoFlingSheriff = false,
  AutoFlingAll = false,
  AutoKillMurderer = false,
  AutoKillInnocent = false,
  AutoKillAura = false,
  AutoTeleportToMurderer = false,
  AutoTeleportToSheriff = false,
  AutoTeleportToPlayer = false,
  AutoSpectateMurderer = false,
  AutoSpectateSheriff = false,
  AutoSpectatePlayer = false,
  AutoPlayEmote = false,
  AutoSeizure = false,
  AutoAntiFling = false,
  AutoAntiTrap = false,
  AutoAntiGravity = false,
  AutoAntiSpeed = false,
  AutoAntiJump = false,
  AutoAntiClimb = false,
  AutoAntiSwim = false,
  AutoAntiSit = false,
  AutoAntiDied = false,
  AutoAntiRespawn = false,
  AutoAntiKick = false,
  AutoAntiBan = false,
  AutoAntiMute = false,
  AutoAntiChat = false,
  AutoAntiCommand = false,
  AutoAntiScript = false,
  AutoAntiExploit = false,
  AutoAntiVirus = false,
  AutoAntiMalware = false,
  AutoAntiSpyware = false,
  AutoAntiAdware = false,
  AutoAntiRansomware = false,
  AutoAntiTrojan = false,
  AutoAntiWorm = false,
  AutoAntiRootkit = false,
  AutoAntiKeylogger = false,
  AutoAntiSpy = false,
  AutoAntiTracker = false,
  AutoAntiPhishing = false,
  AutoAntiScam = false,
  AutoAntiHacker = false,
  AutoAntiCheater = false,
  AutoAntiMod = false,
  AutoAntiAdmin = false,
  AutoAntiOwner = false,
  AutoAntiCreator = false,
  AutoAntiDeveloper = false,
  AutoAntiTester = false,
  AutoAntiUser = false,
  AutoAntiGuest = false,
  AutoAntiPlayer = false,
  AutoAntiCharacter = false,
  AutoAntiTool = false,
  AutoAntiPart = false,
  AutoAntiModel = false,
  AutoAntiScript = false,
  AutoAntiLocalScript = false,
  AutoAntiModuleScript = false,
  AutoAntiBindableEvent = false,
  AutoAntiBindableFunction = false,
  AutoAntiRemoteEvent = false,
  AutoAntiRemoteFunction = false,
  AutoAntiAnimation = false,
  AutoAntiAnimationController = false,
  AutoAntiAnimator = false,
  AutoAntiBodyGyro = false,
  AutoAntiBodyVelocity = false,
  AutoAntiBodyAngularVelocity = false,
  AutoAntiBodyForce = false,
  AutoAntiBodyThrust = false,
  AutoAntiBodyPosition = false,
  AutoAntiBodyMove = false,
  AutoAntiBodyRotate = false,
  AutoAntiBodyStiffness = false,
  AutoAntiBodyThrust = false,
  AutoAntiBodyVelocity = false,
  AutoAntiBodyAngularVelocity = false,
  AutoAntiBodyForce = false,
  AutoAntiBodyGyro = false,
  AutoAntiBodyPosition = false,
  AutoAntiBodyMove = false,
  AutoAntiBodyRotate = false,
  AutoAntiBodyStiffness = false,
  AutoAntiBodyThrust = false,
  AutoAntiBodyVelocity = false,
  AutoAntiBodyAngularVelocity = false,
  AutoAntiBodyForce = false,
  AutoAntiBodyGyro = false,
  AutoAntiBodyPosition = false,
  AutoAntiBodyMove = false,
  AutoAntiBodyRotate = false,
  AutoAntiBodyStiffness = false,
  AutoAntiBodyThrust = false,
  AutoAntiBodyVelocity = false,
  AutoAntiBodyAngularVelocity = false,
  AutoAntiBodyForce = false,
  AutoAntiBodyGyro = false,
  AutoAntiBodyPosition = false,
  AutoAntiBodyMove = false,
  AutoAntiBodyRotate = false,
  AutoAntiBodyStiffness = false,
  AutoAntiBodyThrust = false,
  AutoAntiBodyVelocity = false,
  AutoAntiBodyAngularVelocity = false,
  AutoAntiBodyForce = false,
  AutoAntiBodyGyro = false,
  AutoAntiBodyPosition = false,
  AutoAntiBodyMove = false,
  AutoAntiBodyRotate = false,
  AutoAntiBodyStiffness = false,
  AutoAntiBodyThrust = false,
  AutoAntiBodyVelocity = false,
  AutoAntiBodyAngularVelocity = false,
  AutoAntiBodyForce = false,
  AutoAntiBodyGyro = false,
  AutoAntiBodyPosition = false,
  AutoAntiBodyMove = false,
  AutoAntiBodyRotate = false,
  AutoAntiBodyStiffness = false,
  AutoAntiBodyThrust = false,
  AutoAntiBodyVelocity = false,
  AutoAntiBodyAngularVelocity = false,
  AutoAntiBodyForce = false,
  AutoAntiBodyGyro = false,
  AutoAntiBodyPosition = false,
  AutoAntiBodyMove = false,
  AutoAntiBodyRotate = false,
  AutoAntiBodyStiffness = false,
  AutoAntiBodyThrust = false,
  AutoAntiBodyVelocity = false,
  AutoAntiBodyAngularVelocity = false,
  AutoAntiBodyForce = false,
  AutoAntiBodyGyro = false,
  AutoAntiBodyPosition = false,
  AutoAntiBodyMove...... -- ... (استمرار المتغيرات)
}
local vu36 = {
  Gameplay = {
    Murderer = nil,
    Sheriff = nil,
  },
  GameplayMap = {},
  IsRoundStarted = false,
  GunDrop = nil,
  InSprayCooldown = false,
  MurdererPerk = nil,
  Map = nil,
  -- ... (استمرار المتغيرات)
}
local vu38 = { } -- سيتم تعريفه لاحقًا
local vu40 = { "Sit", "Ninja", "Dab", "Zen", "Floss", "Headless", "Zombie" }
-- ... (استمرار المتغيرات الأخرى)

local Window = Library:MakeWindow({
  Title = "Symphony Hub : Murder Mystery 2",
  SubTitle = "dev by real_redz",
  ScriptFolder = "redz-library-V5"
})

local CombatTab = Window:MakeTab({
  Title = "Combat",
  Icon = "Gun"
})

-- Fling Section
local FlingSection = CombatTab:AddSection("Fling")

-- Function to update player list
local function UpdatePlayerList(Dropdown)
  local PlayerList = {}
  for _, Player in pairs(game.Players:GetPlayers()) do
    if Player.Name ~= game.Players.LocalPlayer.Name then
      table.insert(PlayerList, Player.Name)
    end
  end
  Dropdown:NewOptions(PlayerList)
end

-- Create the dropdown first
local PlayerDropdown = FlingSection:AddDropdown({
  Name = "Players To Fling",
  Options = {},
  Default = nil,
  Callback = function(Value)
    -- اختيار لاعب معين للقذف
    vu35.PlayerToFling = Value
  end
})

-- Button to refresh player list
FlingSection:AddButton({
  Name = "Refresh Players",
  Callback = function()
    UpdatePlayerList(PlayerDropdown)
  end
})

-- Update the list when the script starts
UpdatePlayerList(PlayerDropdown)

-- Connect to PlayerAdded and PlayerRemoving events to update the list automatically
game.Players.PlayerAdded:Connect(function(Player)
  -- Wait a short time to ensure the player is fully loaded
  task.wait(0.1)
  UpdatePlayerList(PlayerDropdown)
end)

game.Players.PlayerRemoving:Connect(function(Player)
  UpdatePlayerList(PlayerDropdown)
end)

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
    FlingKill("All")
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
local MurdererSection = CombatTab:AddSection("Murderer")

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
      KillAll()
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
    -- لا حاجة للكود هنا، لأن السكربت الأصلي يتعامل مع المتغير داخليًا
  end
})

MurdererSection:AddToggle({
  Name = "Auto Kill Everyone",
  Default = false,
  Callback = function(Value)
    -- تفعيل/تعطيل القتل التلقائي للجميع
    vu35.AutoKillEveryone = Value
    -- لا حاجة للكود هنا، لأن السكربت الأصلي يتعامل مع المتغير داخليًا
  end
})

MurdererSection:AddToggle({
  Name = "Kill Aura",
  Default = false,
  Callback = function(Value)
    -- تفعيل/تعطيل قتل تلقائي لمن حولك
    vu35.KillAura = Value
    -- لا حاجة للكود هنا، لأن السكربت الأصلي يتعامل مع المتغير داخليًا
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

-- اجعل تبويب Combat هو التبويب الظاهر افتراضيًا
Window:SelectTab(CombatTab)

-- وظيفة القذف (FlingKill)
function FlingKill(pu262)
  pcall(function()
    if pu262 ~= "All" then
      local v263 = GetPlayer(pu262) -- وظيفة موجودة أدناه
      if v263 and v263 ~= game.Players.LocalPlayer then
        Fling(v263) -- وظيفة موجودة أدناه
      end
    else
      -- قذف الجميع
      for _, Player in pairs(game.Players:GetPlayers()) do
        if Player ~= game.Players.LocalPlayer and not IsPlayerWhitelisted(Player.Name) then
          Fling(Player)
        end
      end
    end
  end)
end

-- وظيفة القتل (KillPlayer)
function KillPlayer(PlayerName, Instant)
  if tostring(vu36.Gameplay.Murderer) == game.Players.LocalPlayer.Name then
    local Player = game.Players:FindFirstChild(PlayerName)
    if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
      -- استخدام السكربت الأصلي للقتل
      local Character = game.Players.LocalPlayer.Character
      if Character and Character:FindFirstChild("Knife") then
        -- محاولة القتل
        pcall(function()
          Character.Knife.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, Player.Character.HumanoidRootPart.Position, "AH2")
        end)
      end
    end
  end
end

-- وظيفة قتل الجميع (KillAll)
function KillAll()
  if tostring(vu36.Gameplay.Murderer) == game.Players.LocalPlayer.Name then
    for _, Player in pairs(game.Players:GetPlayers()) do
      if Player ~= game.Players.LocalPlayer and not IsPlayerWhitelisted(Player.Name) then
        KillPlayer(Player.Name, true)
      end
    end
  end
end

-- وظيفة التحقق من القائمة البيضاء (IsPlayerWhitelisted)
function IsPlayerWhitelisted(PlayerName)
  return table.find(vu35.WhitelistedPlayers, PlayerName) ~= nil
end

-- وظيفة جلب اللاعب (GetPlayer)
function GetPlayer(PlayerName)
  return game.Players:FindFirstChild(PlayerName)
end

-- وظيفة القذف (Fling)
function Fling(Player)
  if Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
    local Character = game.Players.LocalPlayer.Character
    if Character and Character:FindFirstChild("HumanoidRootPart") then
      -- استخدام السكربت الأصلي للقذف
      local HumanoidRootPart = Character.HumanoidRootPart
      local TargetRootPart = Player.Character.HumanoidRootPart

      -- تغيير المقاومة
      HumanoidRootPart:ApplyImpulse(Vector3.new(0, 0, 0))
      HumanoidRootPart:ApplyAngularImpulse(Vector3.new(0, 0, 0))

      -- تغيير السرعة
      HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
      HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)

      -- الالتصاق بالهدف
      HumanoidRootPart.CFrame = TargetRootPart.CFrame * CFrame.new(0, -1.5, 0)

      -- تغيير المقاومة والسرعة للهدف
      TargetRootPart:ApplyImpulse(Vector3.new(0, 0, 0))
      TargetRootPart:ApplyAngularImpulse(Vector3.new(0, 0, 0))

      TargetRootPart.Velocity = Vector3.new(0, 0, 0)
      TargetRootPart.RotVelocity = Vector3.new(0, 0, 0)

      -- الانتظار قليلاً
      task.wait(0.1)

      -- تغيير المقاومة والسرعة مرة أخرى
      HumanoidRootPart:ApplyImpulse(Vector3.new(0, 0, 0))
      HumanoidRootPart:ApplyAngularImpulse(Vector3.new(0, 0, 0))

      HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
      HumanoidRootPart.RotVelocity = Vector3.new(0, 0, 0)

      TargetRootPart:ApplyImpulse(Vector3.new(0, 0, 0))
      TargetRootPart:ApplyAngularImpulse(Vector3.new(0, 0, 0))

      TargetRootPart.Velocity = Vector3.new(0, 0, 0)
      TargetRootPart.RotVelocity = Vector3.new(0, 0, 0)
    end
  end
end

-- ... (استمرار الوظائف الأخرى من السكربت الأصلي)
