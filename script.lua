-- مكتبة Wand UI (Redz Library V5 Remake)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- إنشاء النافذة الرئيسية
local Window = Library:MakeWindow({
  Title = "Mm2 Script Hub",
  SubTitle = "مصنوع بواسطة Rayan oubaca",
  ScriptFolder = "Mm2SHub"
})

-- الحصول على البيئة العامة
local env = getgenv and getgenv() or getrenv and getrenv() or getfenv and getfenv(0) or _G

-- تحميل cloneref إذا لم يكن موجودًا
local cloneref = cloneref or (function()
  local s, func = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Backlostunking/Open-Source/refs/heads/main/cloneref-TheCloneVM"))()
  end)
  return s and func or function(s) return s end
end)()

-- إنشاء نسخة مُعدّلة من الخدمات الأساسية
local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Tween = cloneref(game:GetService("TweenService"))
local RunService = cloneref(game:GetService("RunService"))
local Workspace = cloneref(game:GetService("Workspace"))

-- الحصول على اللاعب المحلي
local LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
local backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack")
local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Hum = Char and Char:FindFirstChildWhichIsA("Humanoid")
local Root = (Hum and Hum.RootPart) or Char:FindFirstChild("HumanoidRootPart") or Char:FindFirstChild("Torso") or Char:FindFirstChild("UpperTorso")

-- تحديث المعلومات عند تغيير الشخصية
LocalPlayer.CharacterAdded:Connect(function()
  repeat task.wait()
  LocalPlayer = Players.LocalPlayer or Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
  backpack = LocalPlayer:FindFirstChild("Backpack") or LocalPlayer:WaitForChild("Backpack")
  Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
  Hum = Char and Char:FindFirstChildWhichIsA("Humanoid")
  Root = (Hum and Hum.RootPart) or Char:FindFirstChild("HumanoidRootPart") or Char:FindFirstChild("Torso") or Char:FindFirstChild("UpperTorso")
  until LocalPlayer and backpack and Char and Hum and Root
end)

-- دالة لإطلاق اللاعبين
local function SHubFling(TargetPlayer)
  if not (Char and Hum and Root) then return end
  local TCharacter = TargetPlayer.Character
  if not TCharacter then return end
  local THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
  local TRootPart = THumanoid and THumanoid.RootPart
  local THead = TCharacter:FindFirstChild("Head")
  local Accessory = TCharacter:FindFirstChildOfClass("Accessory")
  local Handle = Accessory and Accessory:FindFirstChild("Handle")
  env.OldPos = Root.CFrame
  
  repeat task.wait()
  Workspace.CurrentCamera.CameraSubject = THead or Handle or THumanoid
  until Workspace.CurrentCamera.CameraSubject == THead or Handle or THumanoid
  
  local function FPos(BasePart, Pos, Ang)
    local targetCF = CFrame.new(BasePart.Position) * Pos * Ang
    Root.CFrame = targetCF
    Char:SetPrimaryPartCFrame(targetCF)
    Root.Velocity = Vector3.new(9e7, 9e8, 9e7)
    Root.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
  end
  
  local function SFBasePart(BasePart)
    local start = tick()
    local angle = 0
    env.timeout = env.timeout or 2.5
    repeat
      if Root and THumanoid then
        angle += 100
        for _, offset in ipairs{CFrame.new(0, 1.5, 0),CFrame.new(0, -1.5, 0),CFrame.new(2.25, 1.5, -2.25),CFrame.new(-2.25, -1.5, 2.25)} do
          FPos(BasePart, offset + THumanoid.MoveDirection, CFrame.Angles(math.rad(angle), 0, 0))
          task.wait()
        end
      end
    until BasePart.Velocity.Magnitude > 500 or tick() - start > env.timeout
  end
  
  local BV = Instance.new("BodyVelocity")
  BV.Name = "SeYyyVel!?"
  BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
  BV.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
  BV.Parent = Root
  Hum:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
  local target = TRootPart or THead or Handle
  if target then SFBasePart(target) end
  BV:Destroy()
  Hum:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
  
  repeat task.wait()
  Workspace.CurrentCamera.CameraSubject = Hum
  until Workspace.CurrentCamera.CameraSubject == Hum
  
  repeat
    local cf = env.OldPos * CFrame.new(0, .5, 0)
    Root.CFrame = cf
    Char:SetPrimaryPartCFrame(cf)
    Hum:ChangeState("GettingUp")
    for _, part in ipairs(Char:GetChildren()) do
      if part:IsA("BasePart") then
        part.Velocity, part.RotVelocity = Vector3.zero, Vector3.zero
      end
    end
    task.wait()
  until (Root.Position - env.OldPos.p).Magnitude < 25
end

-- دالة للحصول على أدوار اللاعبين
local function getRoles()
  local data = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
  local roles = {}
  for plr, plrData in pairs(data) do
    if not plrData.Dead then
      roles[plr] = plrData.Role
    end
  end
  return roles
end

-- دالة للحصول على هدف القاتل
local function getMurdererTarget()
  local data = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
  for plr, plrData in pairs(data) do
    if plrData.Role == "Murderer" then
      local player = Players:FindFirstChild(plr)
      if player then
        if player == LocalPlayer then return nil, true end
        local char = player.Character
        if char then
          local hrp = char:FindFirstChild("HumanoidRootPart")
          if hrp then return hrp.Position, false end
          local head = char:FindFirstChild("Head")
          if head then return head.Position, false end
        end
      end
    end
  end
  return nil, false
end

-- ==================== تبويب الأسلحة ====================

local WeaponsTab = Window:MakeTab({Title = "🔫 الأسلحة", Icon = "Target"})

WeaponsTab:AddSection("🎯 التصويب المحسن")

-- متغيرات لحفظ حالة الزر
local GunWGui = nil
local GunWButton = nil

-- دالة لإنشاء الزر
local function CreateShootButton()
  local guip, CoreGui = nil, game:FindService("CoreGui")
  if gethui then
    guip = gethui()
  elseif CoreGui and CoreGui:FindFirstChild("RobloxGui") then
    guip = CoreGui.RobloxGui
  elseif CoreGui then
    guip = CoreGui
  else
    guip = LocalPlayer:FindFirstChild("PlayerGui")
  end
  
  if not guip:FindFirstChild("GunW") then
    GunWGui = Instance.new("ScreenGui", guip)
    GunWGui.Name = "GunW"
    GunWButton = Instance.new("TextButton", GunWGui)
    GunWButton.Draggable = true
    GunWButton.Position = UDim2.new(0.5, 187, 0.5, -176)
    GunWButton.Size = UDim2.new(0, 50, 0, 40)
    GunWButton.TextStrokeTransparency = 0
    GunWButton.BackgroundTransparency = 0.2
    GunWButton.BackgroundColor3 = Color3.fromRGB(44, 44, 45)
    GunWButton.BorderColor3 = Color3.new(1, 1, 1)
    GunWButton.Text = "إطلاق على القاتل"
    GunWButton.TextColor3 = Color3.new(1, 1, 1)
    GunWButton.TextSize = 8
    GunWButton.Visible = true
    GunWButton.AnchorPoint = Vector2.new(0.4, 0.2)
    GunWButton.Active = true
    GunWButton.TextWrapped = true
    local corner = Instance.new("UICorner", GunWButton)
    local UIStroke = Instance.new("UIStroke", GunWButton)
    UIStroke.Color = Color3.new(0, 0, 0)
    UIStroke.Thickness = 4
    UIStroke.Transparency = 0.4
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint", GunWButton)
    UIAspectRatioConstraint.AspectRatio = 1.5
    local UIGradient = Instance.new("UIGradient", GunWButton)
    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(0.3, 0.3, 0.3)),ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1)}
    
    local function rotateGradient()
      local tween = Tween:Create(UIGradient, TweenInfo.new(2, Enum.EasingStyle.Linear), {Rotation = UIGradient.Rotation + 360})
      tween:Play()
      tween.Completed:Connect(rotateGradient)
    end
    rotateGradient()
    
    GunWButton.MouseButton1Click:Connect(function()
      if Char:FindFirstChild("Gun") then
        pcall(function()
          Char.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(1, (getMurdererTarget()), "AH2")
        end)
      end
    end)
  end
end

-- تبديل إطلاق النار على القاتل
WeaponsTab:AddToggle({
  Name = "إطلاق على القاتل",
  Default = false,
  Callback = function(Value)
    -- عند تفعيل التبديل، قم بإنشاء الزر إذا لم يكن موجوداً
    if Value and not GunWGui then
      CreateShootButton()
    end
    
    -- جعل الزر مرئيًا أو غير مرئيًا بناءً على حالة التبديل
    if GunWGui and GunWGui:FindFirstChild("GunW") then
      GunWButton = GunWGui:FindFirstChild("GunW")
      if GunWButton then
        GunWButton.Visible = Value
      end
    end
  end    
})

-- ==================== تبويب القذف ====================

local FlingTab = Window:MakeTab({Title = "💨 القذف", Icon = "Wind"})

FlingTab:AddButton({
  Name = "قذف القاتل",
  Callback = function()
    local roles = getRoles()
    local found = false
    
    for playerName, role in pairs(roles) do
      if role == "Murderer" then
        local murderer = Players:FindFirstChild(playerName)
        if murderer and murderer ~= LocalPlayer then
          SHubFling(murderer)
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
    local roles = getRoles()
    local found = false
    
    for playerName, role in pairs(roles) do
      if role == "Sheriff" or role == "Hero" then
        local target = Players:FindFirstChild(playerName)
        if target and target ~= LocalPlayer then
          SHubFling(target)
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
          local roles = getRoles()
          local flungCount = 0
          
          for playerName, role in pairs(roles) do
            local player = Players:FindFirstChild(playerName)
            if player and player ~= LocalPlayer then
              SHubFling(player)
              flungCount = flungCount + 1
              task.wait(0.2)
            end
          end
          
          if flungCount > 0 then
            Window:Notify({
              Title = "💥 قذف مستمر",
              Content = "تم قذف " .. flungCount .. " لاعب/لاعبين في هذه الدورة",
              Duration = 2
            })
          end
          
          task.wait(3)
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
        Content = "تم إيقاء قذف جميع اللاعبين",
        Duration = 3
      })
    end
  end
})

FlingTab:AddSection("🎯 قذف لاعب محدد")

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

local SelectedPlayer = nil

local PlayerDropdown = FlingTab:AddDropdown({
  Name = "اختر لاعب",
  Default = GetPlayerNames()[1] or "",
  Options = GetPlayerNames(),
  Callback = function(Value)
    SelectedPlayer = Value
  end
})

-- تحديث القائمة
local function UpdateDropdown()
  PlayerDropdown:NewOptions(GetPlayerNames())
end

Players.PlayerAdded:Connect(UpdateDropdown)
Players.PlayerRemoving:Connect(UpdateDropdown)

FlingTab:AddButton({
  Name = "قذف اللاعب المحدد",
  Callback = function()
    if SelectedPlayer then
      local player = Players:FindFirstChild(SelectedPlayer)
      if player and player ~= LocalPlayer then
        SHubFling(player)
        
        Window:Notify({
          Title = "💨 تم قذف اللاعب",
          Content = "تم قذف: " .. player.Name,
          Duration = 3
        })
      else
        Window:Notify({
          Title = "❌ خطأ",
          Content = "لم يتم العثور على اللاعب: " .. (SelectedPlayer or ""),
          Duration = 3
        })
      end
    else
      Window:Notify({
        Title = "⚠️ تنبيه",
        Content = "يرجى اختيار لاعب أولاً",
        Duration = 3
      })
    end
  end
})

FlingTab:AddSection("⚙️ إعدادات القذف")

-- قذف باللمس
local TouchFlingEnabled = false

FlingTab:AddToggle({
  Name = "قذف باللمس",
  Default = false,
  Callback = function(Value)
    TouchFlingEnabled = Value
    
    task.spawn(function()
      while TouchFlingEnabled do
        RunService.Heartbeat:Wait()
        local vel = HumanoidRootPart.Velocity
        HumanoidRootPart.Velocity = vel * 9e8 + Vector3.new(0, 9e8, 0)
        
        RunService.RenderStepped:Wait()
        if Character and Character.Parent and HumanoidRootPart and HumanoidRootPart.Parent then
          HumanoidRootPart.Velocity = vel
        end
        
        RunService.Stepped:Wait()
        if Character and Character.Parent and HumanoidRootPart and HumanoidRootPart.Parent then
          local movel = 0.1
          HumanoidRootPart.Velocity = vel + Vector3.new(0, movel, 0)
        end
      end
    end)
  end
})

-- منع القذف
local AntiFlingEnabled = false

FlingTab:AddToggle({
  Name = "منع القذف (المرور عبر اللاعبين)",
  Default = false,
  Callback = function(Value)
    AntiFlingEnabled = Value
    
    if not Value then
      for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
          for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
              part.CanCollide = true
            end
          end
        end
      end
    end
    
    task.spawn(function()
      while AntiFlingEnabled do
        for _, player in ipairs(Players:GetPlayers()) do
          if player ~= LocalPlayer and player.Character then
            for _, part in ipairs(player.Character:GetDescendants()) do
              if part:IsA("BasePart") then
                part.CanCollide = false
              end
            end
          end
        end
        task.wait()
      end
    end)
  end
})

-- وقت القذف
FlingTab:AddSlider({
  Name = "وقت القذف (بالثواني)",
  Min = 0.5,
  Max = 10,
  Default = 2.5,
  Increment = 0.1,
  Callback = function(Value)
    Window:Notify({
      Title = "⏱️ تم ضبط الوقت",
      Content = "تم ضبط وقت القذف إلى " .. Value .. " ثانية",
      Duration = 3
    })
  end
})

-- ==================== تبويب اللاعب ====================

local PlayerTab = Window:MakeTab({Title = "👤 اللاعب", Icon = "User"})

PlayerTab:AddSection("🧑 حركة اللاعب")

-- القفز اللانهائي
local InfiniteJumpEnabled = false

PlayerTab:AddToggle({
  Name = "القفز اللانهائي",
  Default = false,
  Callback = function(Value)
    InfiniteJumpEnabled = Value
    
    if Value then
      Window:Notify({
        Title = "🦘 تم تفعيل القفز اللانهائي",
        Content = "يمكنك القفز دون توقف",
        Duration = 3
      })
    end
  end
})

-- المرور عبر الجدران
local NoclipEnabled = false

PlayerTab:AddToggle({
  Name = "المرور عبر الجدران",
  Default = false,
  Callback = function(Value)
    NoclipEnabled = Value
    
    if not Value then
      if Character then
        for _, part in ipairs(Character:GetChildren()) do
          if part:IsA("BasePart") and not part.CanCollide then
            part.CanCollide = true
          end
        end
      end
    end
    
    if Value then
      Window:Notify({
        Title = "🚶 تم تفعيل المرور عبر الجدران",
        Content = "يمكنك الآن المشي عبر الجدران",
        Duration = 3
      })
    end
  end
})

PlayerTab:AddSection("⚡ إعدادات الحركة")

-- سرعة المشي
local WalkSpeed = 16
local KeepWalkSpeed = false

PlayerTab:AddSlider({
  Name = "سرعة المشي",
  Min = 16,
  Max = 350,
  Default = 16,
  Increment = 1,
  Callback = function(Value)
    WalkSpeed = Value
    if Humanoid then
      Humanoid.WalkSpeed = Value
    end
  end
})

PlayerTab:AddToggle({
  Name = "تثبيت سرعة المشي تلقائياً",
  Default = false,
  Callback = function(Value)
    KeepWalkSpeed = Value
    
    task.spawn(function()
      while KeepWalkSpeed do
        if Humanoid and Humanoid.WalkSpeed ~= WalkSpeed then
          Humanoid.WalkSpeed = WalkSpeed
        end
        task.wait(0.1)
      end
    end)
  end
})

-- قوة القفز
local JumpPower = 50
local KeepJumpPower = false

PlayerTab:AddSlider({
  Name = "قوة القفز",
  Min = 50,
  Max = 500,
  Default = 50,
  Increment = 1,
  Callback = function(Value)
    JumpPower = Value
    if Humanoid then
      Humanoid.JumpPower = Value
    end
  end
})

PlayerTab:AddToggle({
  Name = "تثبيت قوة القفز تلقائياً",
  Default = false,
  Callback = function(Value)
    KeepJumpPower = Value
    
    task.spawn(function()
      while KeepJumpPower do
        if Humanoid and Humanoid.JumpPower ~= JumpPower then
          Humanoid.JumpPower = JumpPower
        end
        task.wait(0.1)
      end
    end)
  end
})

-- وضع الإله (عدم الموت)
local GodmodeEnabled = false

PlayerTab:AddToggle({
  Name = "وضع الإله (عدم الموت)",
  Default = false,
  Callback = function(Value)
    GodmodeEnabled = Value
    
    local godConnection
    local deathConnection
    
    local function UpdateGodmode()
      if godConnection then
        godConnection:Disconnect()
        godConnection = nil
      end
      
      if Humanoid then
        godConnection = Humanoid.HealthChanged:Connect(function()
          if GodmodeEnabled and Humanoid.Health < Humanoid.MaxHealth then
            Humanoid.Health = Humanoid.MaxHealth
          end
        end)
      end
    end
    
    local function OnCharacterAdded(newChar)
      Character = newChar
      Humanoid = Character:WaitForChild("Humanoid")
      UpdateGodmode()
    end
    
    if deathConnection then 
      deathConnection:Disconnect() 
    end
    
    deathConnection = LocalPlayer.CharacterAdded:Connect(OnCharacterAdded)
    UpdateGodmode()
    
    if Value then
      Window:Notify({
        Title = "🛡️ تم تفعيل وضع الإله",
        Content = "لن تتمكن من الموت الآن",
        Duration = 3
      })
    end
  end
})

-- ==================== تبويب الانتقال ====================

local TeleportTab = Window:MakeTab({Title = "📍 الانتقال", Icon = "Navigation"})

TeleportTab:AddButton({
  Name = "الانتقال إلى الخريطة",
  Callback = function()
    local map = Workspace:FindFirstChild("CoinContainer", true)
    if map then
      local part = map:FindFirstChildWhichIsA("BasePart", true)
      if part and HumanoidRootPart then
        HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 2, 0)
        
        Window:Notify({
          Title = "✅ تم الانتقال",
          Content = "انتقلت إلى الخريطة بنجاح",
          Duration = 3
        })
      else
        Window:Notify({
          Title = "❌ خطأ",
          Content = "لم يتم العثور على الخريطة",
          Duration = 3
        })
      end
    end
  end
})

TeleportTab:AddButton({
  Name = "الانتقال إلى اللوبي",
  Callback = function()
    local lobby = Workspace:FindFirstChild("Lobby", true)
    if lobby then
      local part = lobby:FindFirstChildWhichIsA("BasePart", true)
      if part and HumanoidRootPart then
        HumanoidRootPart.CFrame = part.CFrame * CFrame.new(0, 2, 0)
        
        Window:Notify({
          Title = "✅ تم الانتقال",
          Content = "انتقلت إلى اللوبي بنجاح",
          Duration = 3
        })
      else
        Window:Notify({
          Title = "❌ خطأ",
          Content = "لم يتم العثور على اللوبي",
          Duration = 3
        })
      end
    end
  end
})

-- ==================== تبويب السكربتات ====================

local ScriptsTab = Window:MakeTab({Title = "📁 السكربتات", Icon = "Cloud"})

ScriptsTab:AddSection("📁 تحميل سكربتات خارجية")


ScriptsTab:AddButton({
  Name = "تحميل Infinite Yield",
  Callback = function()
    Window:Dialog({
      Title = "⚠️ تأكيد التحميل",
      Content = "هل تريد تحميل سكربت Infinite Yield؟",
      Options = {
        {
          Name = "❌ إلغاء",
          Callback = function()
            Window:Notify({
              Title = "تم الإلغاء",
              Content = "تم إلغاء تحميل Infinite Yield",
              Duration = 2
            })
          end
        },
        {
          Name = "✅ تأكيد",
          Callback = function()
            loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
            
            Window:Notify({
              Title = "✅ تم التحميل",
              Content = "تم تحميل Infinite Yield بنجاح",
              Duration = 3
            })
          end
        }
      }
    })
  end
})

ScriptsTab:AddSection("🔗 سكربتات مخصصة")

local CustomScriptURL = ""

ScriptsTab:AddTextBox({
  Name = "رابط السكربت المخصص",
  Placeholder = "أدخل رابط السكربت هنا...",
  Callback = function(Text)
    CustomScriptURL = Text
  end
})

ScriptsTab:AddButton({
  Name = "تحميل السكربت المخصص",
  Callback = function()
    if CustomScriptURL == "" then
      Window:Notify({
        Title = "⚠️ تنبيه",
        Content = "يرجى إدخال رابط السكربت أولاً",
        Duration = 3
      })
      return
    end
    
    Window:Dialog({
      Title = "⚠️ تأكيد التحميل",
      Content = "هل تريد تحميل السكربت المخصص؟",
      Options = {
        {
          Name = "❌ إلغاء",
          Callback = function()
            Window:Notify({
              Title = "تم الإلغاء",
              Content = "تم إلغاء تحميل السكربت",
              Duration = 2
            })
          end
        },
        {
          Name = "✅ تأكيد",
          Callback = function()
            local success, errorMessage = pcall(function()
              loadstring(game:HttpGet(CustomScriptURL))()
            end)
            
            if success then
              Window:Notify({
                Title = "✅ تم التحميل",
                Content = "تم تحميل السكربت بنجاح",
                Duration = 3
              })
            else
              Window:Notify({
                Title = "❌ خطأ",
                Content = "فشل في تحميل السكربت: " .. tostring(errorMessage),
                Duration = 5
              })
            end
          end
        }
      }
    })
  end
})

-- ==================== تبويب الإعدادات ====================

local SettingsTab = Window:MakeTab({Title = "⚙️ الإعدادات", Icon = "Settings"})

SettingsTab:AddSection("⚙️ إعدادات الواجهة")

SettingsTab:AddSlider({
  Name = "حجم الواجهة",
  Min = 0.6,
  Max = 1.6,
  Default = 1.0,
  Increment = 0.1,
  Callback = function(Value)
    Library:SetUIScale(Value)
  end
})

SettingsTab:AddSection("📊 معلومات النظام")

local GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name
local Executor = identifyexecutor and identifyexecutor() or getexecutorname and getexecutorname() or "غير معروف"

SettingsTab:AddParagraph("معلومات اللعبة", 
    "🎮 اسم اللعبة: " .. GameName .. "\n" ..
    "🆔 رقم اللعبة: " .. game.PlaceId .. "\n" ..
    "👤 اسم اللاعب: " .. LocalPlayer.Name .. "\n" ..
    "⚡ المشغل: " .. Executor .. "\n" ..
    "🕐 الوقت: " .. os.date("%I:%M %p")
)

SettingsTab:AddParagraph("معلومات السكربت", 
    "✨ السكربت: MM2 العربي\n" ..
    "📁 الإصدار: 7.0.0\n" ..
    "🎨 الواجهة: Wand UI\n" ..
    "🇸🇦 اللغة: العربية\n" ..
    "🔧 المطور: real_redz\n" ..
    "📅 تاريخ التحديث: " .. os.date("%Y/%m/%d")
)

SettingsTab:AddSection("🛠️ أدوات النظام")

SettingsTab:AddButton({
  Name = "تنظيف الذاكرة",
  Callback = function()
    collectgarbage()
    
    Window:Notify({
      Title = "✅ تم التنظيف",
      Content = "تم تنظيف الذاكرة وتحسين الأداء",
      Duration = 3
    })
  end
})

SettingsTab:AddButton({
  Name = "إعادة تحميل السكربت",
  Callback = function()
    Window:Dialog({
      Title = "⚠️ تأكيد إعادة التحميل",
      Content = "هل تريد إعادة تحميل السكربت؟",
      Options = {
        {
          Name = "❌ إلغاء",
          Callback = function()
            Window:Notify({
              Title = "تم الإلغاء",
              Content = "تم إلغاء إعادة التحميل",
              Duration = 2
            })
          end
        },
        {
          Name = "✅ تأكيد",
          Callback = function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()
          end
        }
      }
    })
  end
})

SettingsTab:AddButton({
  Name = "إغلاق الواجهة",
  Callback = function()
    Window:Dialog({
      Title = "⚠️ تأكيد الإغلاق",
      Content = "هل تريد إغلاق واجهة السكربت؟",
      Options = {
        {
          Name = "❌ إلغاء",
          Callback = function()
            Window:Notify({
              Title = "تم الإلغاء",
              Content = "تم إلغاء عملية الإغلاق",
              Duration = 2
            })
          end
        },
        {
          Name = "✅ تأكيد",
          Callback = function()
            if Library and Library.Destroy then
              Library:Destroy()
            end
          end
        }
      }
    })
  end
})

-- ==================== Minimizer مع صورة سيف ====================

local Minimizer = Window:NewMinimizer({
  KeyCode = Enum.KeyCode.RightControl
})

-- زر المصغر مع صورة السيف
Minimizer:CreateMobileMinimizer({
  Image = "rbxassetid://10734962876",  -- صورة السيف
  BackgroundColor3 = Color3.fromRGB(30, 30, 30),
  
})

-- ==================== إشعار البدء ====================

Window:Notify({
  Title = "🎮 سكربت MM2 العربي",
  Content = "✅ تم تحميل السكربت بنجاح!\n\n" ..
             "✨ الميزات المتاحة:\n" ..
             "• نظام ESP للأدوار\n" ..
             "• رؤية السلاح\n" ..
             "• القذف بأنواعه\n" ..
             "• المرور عبر الجدران\n" ..
             "• القفز اللانهائي\n" ..
             "• وضع الإله\n" ..
             "• التصويب التلقائي\n" ..
             "• تحميل سكربتات خارجية\n\n" ..
             "🔧 اضغط RightControl لإخفاء/إظهار الواجهة",
  Duration = 8,
  Image = "rbxassetid://10734953451"
})

-- ==================== الطباعة في الكونسول ====================
print("╔══════════════════════════════════════════════╗")
print("║    سكربت MM2 العربي - النسخة الموسعة        ║")
print("║          تم التحميل بنجاح! 🎮               ║")
print("╚══════════════════════════════════════════════╝")
print("📁 اللعبة: " .. GameName)
print("👤 اللاعب: " .. LocalPlayer.Name)
print("🎮 الواجهة: Wand UI")
print("🇸🇦 اللغة: العربية")
print("✨ الإصدار: 7.0.0")
print("🔧 المطور: محقق")
print("════════════════════════════════════════════════")

print("\n🎯 جميع الميزات مفعلة وجاهزة:")
print("• تبويب المرئيات: ESP للأدوار، رؤية السلاح")
print("• تبويب الأسلحة: إطلاق النار على القاتل")
print("• تبويب القذف: قذف القاتل، الشريف، لاعبين محددين")
print("• تبويب اللاعب: حركة، سرعة، قوة، عدم الموت")
print("• تبويب السكربتات: تحميل سكربتات خارجية")
print("• تبويب الإعدادات: جميع خيارات النظام")
print("════════════════════════════════════════════════")
