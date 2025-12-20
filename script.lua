-- ✨ Wand UI (Redz Library V5 Remake)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
  Title = "Blox Fruits - Aim Bot",
  SubTitle = "Universal All Seas - Aim Bot Skill",
  ScriptFolder = "blox-fruits-aimbot"
})

local AimBotTab = Window:MakeTab({
  Title = "Aim Bot",
  Icon = "target"
})

-- Aim Bot Functions from Original Script
function AimBotPart(part)
  if getgenv().AimBotSkill then
    local camera = workspace.CurrentCamera
    camera.CFrame = CFrame.new(camera.CFrame.Position, part.Position)
  end
end

-- Aim Bot Section (Universal - No Sea Checks)
AimBotTab:AddSection("Aim Bot Skill for Enemies")

AimBotTab:AddToggle({
  Name = "AimBot Skill Enemie",
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

-- Notification
Window:Notify({
  Title = "Aim Bot Loaded",
  Content = "Aim Bot Skill for Blox Fruits - Works in all Seas!",
  Duration = 5
})
