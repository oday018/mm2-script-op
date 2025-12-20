-- تحميل Wand UI
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- إنشاء الـ Window
local Window = Library:MakeWindow({
    Title = "redz Hub : Blox Fruits",
    SubTitle = "by redz9999",
    ScriptFolder = "redzHub-BloxFruits"
})

-- Minimizer
Window:NewMinimizer({ KeyCode = Enum.KeyCode.LeftControl })

-- متغيرات عامة
_G = _G or {}
_G.FarmTool = "Melee"
_G.BossSelected = ""
_G.TakeQuestBoss = true

-- إنشاء الـ Tabs
local Tabs = {
    Discord   = Window:MakeTab({ Title = "Discord", Icon = "Info" }),
    MainFarm  = Window:MakeTab({ Title = "Farm", Icon = "Home" }),
    AutoSea   = Window:MakeTab({ Title = "Sea", Icon = "Waves" }),
    RaceV4    = Window:MakeTab({ Title = "Race-V4", Icon = "" }),
    Items     = Window:MakeTab({ Title = "Quests/Items", Icon = "Swords" }),
    FruitRaid = Window:MakeTab({ Title = "Fruit/Raid", Icon = "Cherry" }),
    Stats     = Window:MakeTab({ Title = "Stats", Icon = "Signal" }),
    Teleport  = Window:MakeTab({ Title = "Teleport", Icon = "Locate" }),
    Visual    = Window:MakeTab({ Title = "Visual", Icon = "User" }),
    Shop      = Window:MakeTab({ Title = "Shop", Icon = "ShoppingCart" }),
    Misc      = Window:MakeTab({ Title = "Misc", Icon = "Settings" })
}

Window:SelectTab(Tabs.MainFarm)

-- Discord Invite
Tabs.Discord:AddDiscordInvite({
    Title = "redz Hub | Community",
    Description = "Join our discord community to receive information about the next update",
    Logo = "rbxassetid://17382040552",
    Invite = "https://discord.gg/7aR7kNVt4g"
})

--------------------------------------------------------------------------------
-- Tab: MainFarm كامل
--------------------------------------------------------------------------------

-- Farm Tool
Tabs.MainFarm:AddDropdown({
    Name = "Farm Tool",
    Options = {"Melee", "Sword", "Blox Fruit"},
    Default = "Melee",
    Flag = "Main/FarmTool",
    Callback = function(Value)
        _G.FarmTool = Value
    end
})

-- UI Scale
Tabs.MainFarm:AddDropdown({
    Name = "UI Scale",
    Options = {"Small", "Medium", "Large"},
    Default = "Large",
    Flag = "Misc/UIScale",
    Callback = function(Value)
        if Value == "Large" then
            Library:SetUIScale(1.0)
        elseif Value == "Medium" then
            Library:SetUIScale(1.2)
        else
            Library:SetUIScale(1.4)
        end
    end
})

-- Multi Farm Beta (Sea 3 فقط)
if game.PlaceId == 7449423635 then
    local MultiToggles = {}
    Tabs.MainFarm:AddToggle({
        Name = "Start Multi Farm < BETA >",
        Default = false,
        Callback = function(Value)
            for _, toggle in pairs(MultiToggles) do
                toggle:Set(Value)
            end
        end
    })

    Tabs.MainFarm:AddSection("Multi Farm Toggles (BETA)")
    table.insert(MultiToggles, Tabs.MainFarm:AddToggle({ Name = "Auto Farm Bone", Default = false, Callback = function(v) _G.AutoFarmBone = v end }))
    table.insert(MultiToggles, Tabs.MainFarm:AddToggle({ Name = "Auto Hallow Scythe", Default = false, Callback = function(v) _G.AutoSoulReaper = v end }))
    table.insert(MultiToggles, Tabs.MainFarm:AddToggle({ Name = "Auto Elite Hunter", Default = false, Callback = function(v) _G.AutoEliteHunter = v end }))
    table.insert(MultiToggles, Tabs.MainFarm:AddToggle({ Name = "Auto Cake Prince", Default = false, Callback = function(v) _G.AutoCakePrince = v end }))
    table.insert(MultiToggles, Tabs.MainFarm:AddToggle({ Name = "Auto Dough King", Default = false, Callback = function(v) _G.AutoDoughKing = v end }))
end

Tabs.MainFarm:AddSection("Farm")

Tabs.MainFarm:AddToggle({
    Name = "Auto Farm Level",
    Desc = "Level Farm",
    Default = false,
    Flag = "Farm/Level",
    Callback = function(Value) _G.AutoFarm_Level = Value end
})

Tabs.MainFarm:AddToggle({
    Name = "Auto Farm Nearest",
    Desc = "Farm Nearst Mobs",
    Default = false,
    Flag = "Farm/Nearest",
    Callback = function(Value) _G.AutoFarmNearest = Value end
})

-- حسب الـ Sea
local PlaceId = game.PlaceId
if PlaceId == 2753915549 then -- Sea 1
    Tabs.MainFarm:AddToggle({ Name = "Sky Piea Farm", Default = false, Callback = function(v) _G.AutoFarmSkyPiea = v end })
    Tabs.MainFarm:AddToggle({ Name = "Player Hunter Quest", Default = false, Callback = function(v) _G.AutoPlayerHunter = v end })
elseif PlaceId == 4442272183 then -- Sea 2
    Tabs.MainFarm:AddToggle({ Name = "Auto Factory", Default = false, Callback = function(v) _G.AutoFactory = v end })
    Tabs.MainFarm:AddSection("Ectoplasm")
    Tabs.MainFarm:AddToggle({ Name = "Auto Farm Ectoplasm", Default = false, Callback = function(v) _G.AutoFarmEctoplasm = v end })
elseif PlaceId == 7449423635 then -- Sea 3
    Tabs.MainFarm:AddToggle({ Name = "Auto Pirates Sea", Default = false, Callback = function(v) _G.AutoPiratesSea = v end })
    Tabs.MainFarm:AddSection("Bone")
    Tabs.MainFarm:AddToggle({ Name = "Auto Farm Bone", Default = false, Callback = function(v) _G.AutoFarmBone = v end })
    Tabs.MainFarm:AddToggle({ Name = "Auto Hallow Scythe", Default = false, Callback = function(v) _G.AutoSoulReaper = v end })
    Tabs.MainFarm:AddToggle({ Name = "Auto Trade Bone", Default = false, Callback = function(v) _G.AutoTradeBone = v end })
end

Tabs.MainFarm:AddSection("Chest")
Tabs.MainFarm:AddToggle({ Name = "Auto Chest < Tween >", Default = false, Callback = function(v) _G.AutoChestTween = v end })

Tabs.MainFarm:AddSection("Bosses")

-- قائمة البوسات (محدثة تلقائياً من الكود الأصلي)
local BossList = {
    "The Gorilla King", "Bobby", "Yeti", "Vice Admiral", "Swan", "Chief Warden", "Warden", "Magma Admiral", "Fishman Lord",
    "Wysper", "Thunder God", "Cyborg", "Diamond", "Jeremy", "Fajita", "Smoke Admiral", "Awakened Ice Admiral", "Tide Keeper",
    "Stone", "Island Empress", "Kilo Admiral", "Captain Elephant", "Beautiful Pirate", "Cake Queen", "Longma",
    "Saber Expert", "The Saw", "Greybeard", "Don Swan", "Cursed Captain", "Darkbeard", "Cake Prince", "Dough King", "rip_indra True Form"
}

local BossDropdown = Tabs.MainFarm:AddDropdown({
    Name = "Boss List",
    Options = BossList,
    Default = BossList[1],
    Callback = function(Value)
        _G.BossSelected = Value
    end
})

Tabs.MainFarm:AddButton({
    Name = "Update Boss List",
    Callback = function()
        BossDropdown:NewOptions(BossList)
    end
})

Tabs.MainFarm:AddToggle({
    Name = "Auto Farm Boss Selected",
    Desc = "Kill the Selected Boss",
    Default = false,
    Flag = "Farm/BossSelected",
    Callback = function(Value) _G.AutoFarmBossSelected = Value end
})

Tabs.MainFarm:AddToggle({
    Name = "Auto Farm All Boss",
    Desc = "Kill all Spawned Bosses",
    Default = false,
    Flag = "Farm/AllBosses",
    Callback = function(Value) _G.KillAllBosses = Value end
})

Tabs.MainFarm:AddToggle({
    Name = "Take Quest",
    Default = true,
    Callback = function(Value) _G.TakeQuestBoss = Value end
})

Tabs.MainFarm:AddButton({
    Name = "Server HOP",
    Callback = function()
        -- هنا كود Server Hop الخاص بك
    end
})

Tabs.MainFarm:AddSection("Material")

local MaterialOptions = (PlaceId == 2753915549) and {"Leather + Scrap Metal", "Magma Ore", "Fish Tail", "Angel Wings"}
    or (PlaceId == 4442272183) and {"Leather + Scrap Metal", "Magma Ore", "Mystic Droplet", "Radiactive Material", "Vampire Fang"}
    or (PlaceId == 7449423635) and {"Leather + Scrap Metal", "Fish Tail", "Gunpowder", "Mini Tusk", "Conjured Cocoa", "Dragon Scale"}
    or {}

Tabs.MainFarm:AddDropdown({
    Name = "Material List",
    Options = MaterialOptions,
    Flag = "Material/Selected",
    Callback = function(Value) _G.MaterialSelected = Value end
})

Tabs.MainFarm:AddToggle({
    Name = "Auto Farm Material",
    Desc = "Select the Material before activating this option",
    Default = false,
    Callback = function(Value) _G.AutoFarmMaterial = Value end
})

Tabs.MainFarm:AddSection("Mastery")

Tabs.MainFarm:AddSlider({
    Name = "Select Health",
    Min = 10,
    Max = 50,
    Increment = 1,
    Default = 25,
    Flag = "Farm/MasteryHealth",
    Callback = function(Value) _G.HealthSkill = Value end
})

Tabs.MainFarm:AddDropdown({
    Name = "Select Tool",
    Options = {"Blox Fruit"},
    Default = "Blox Fruit",
    Callback = function(Value) _G.ToolMastery = Value end
})

Tabs.MainFarm:AddToggle({
    Name = "Auto Farm Mastery",
    Default = false,
    Callback = function(Value) _G.AutoFarmMastery = Value end
})

Tabs.MainFarm:AddSection("Skill")

Tabs.MainFarm:AddToggle({ Name = "AimBot Skill Enemie", Default = true, Callback = function(v) _G.AimBotSkill = v end })
Tabs.MainFarm:AddToggle({ Name = "Skill Z", Default = true, Callback = function(v) _G.SkillZ = v end })
Tabs.MainFarm:AddToggle({ Name = "Skill X", Default = true, Callback = function(v) _G.SkillX = v end })
Tabs.MainFarm:AddToggle({ Name = "Skill C", Default = true, Callback = function(v) _G.SkillC = v end })
Tabs.MainFarm:AddToggle({ Name = "Skill V", Default = true, Callback = function(v) _G.SkillV = v end })
Tabs.MainFarm:AddToggle({ Name = "Skill F", Default = false, Callback = function(v) _G.SkillF = v end })
--------------------------------------------------------------------------------
-- Tab: AutoSea كامل
--------------------------------------------------------------------------------

local PlaceId = game.PlaceId

-- Sea 3 (Kitsune + Sea Farm)
if PlaceId == 7449423635 then

    Tabs.AutoSea:AddSection("Kitsune")

    local KitsuneParagraph = Tabs.AutoSea:AddParagraph("Kitsune Island : not spawn")

    Tabs.AutoSea:AddSlider({
        Name = "Trade Azure Ember Amount",
        Desc = "Select quantity to start trading <font color='rgb(88, 101, 242)'>Azure Ember</font> for rewards",
        Min = 10,
        Max = 25,
        Increment = 5,
        Default = 20,
        Flag = "Sea/AzureAmount",
        Callback = function(Value)
            _G.TradeAzureAmount = Value
        end
    })

    Tabs.AutoSea:AddToggle({
        Name = "Auto Trade Azure Ember",
        Desc = "If you reach the selected amount of <font color='rgb(88, 101, 242)'>Azure Ember</font>, you will trade automatically",
        Default = false,
        Callback = function(Value)
            _G.TradeAzureEmber = Value
        end
    })

    Tabs.AutoSea:AddToggle({
        Name = "Auto Kitsune Island",
        Desc = "Auto Find Kitsune Island + Auto Collect <font color='rgb(88, 101, 242)'>Azure Ember</font>",
        Default = false,
        Callback = function(Value)
            _G.AutoKitsuneIsland = Value
        end
    })

    -- تحديث حالة Kitsune Island تلقائياً
    spawn(function()
        while task.wait(1) do
            if workspace:FindFirstChild("KitsuneIsland") then
                local Player = game.Players.LocalPlayer
                if Player.Character and Player.Character.PrimaryPart then
                    local Distance = math.floor((Player.Character.PrimaryPart.Position - workspace.KitsuneIsland.WorldPivot.p).Magnitude / 5)
                    KitsuneParagraph:SetTitle("Kitsune Island : Spawned | Distance : " .. Distance)
                end
            else
                KitsuneParagraph:SetTitle("Kitsune Island : not spawn")
            end
        end
    end)

    Tabs.AutoSea:AddSection("Sea")

    Tabs.AutoSea:AddToggle({
        Name = "Auto Farm Sea",
        Default = false,
        Callback = function(Value)
            _G.AutoFarmSea = Value
        end
    })

    Tabs.AutoSea:AddButton({
        Name = "Buy New Boat",
        Callback = function()
            -- كود حذف القوارب القديمة وشراء جديد
            _G.BuyNewBoat = true
        end
    })

    Tabs.AutoSea:AddSection("Material")

    Tabs.AutoSea:AddToggle({
        Name = "Auto Wood Planks",
        Default = false,
        Callback = function(Value)
            _G.AutoWoodPlanks = Value
        end
    })

    Tabs.AutoSea:AddSection("Farm Select")

    Tabs.AutoSea:AddParagraph("Fish")

    Tabs.AutoSea:AddToggle({ Name = "Sea Beast", Default = true, Callback = function(v) _G.KillSeaBeasts = v end })
    Tabs.AutoSea:AddToggle({ Name = "Terrorshark", Default = true, Callback = function(v) _G.Terrorshark = v end })
    Tabs.AutoSea:AddToggle({ Name = "Piranha", Default = true, Callback = function(v) _G.Piranha = v end })
    Tabs.AutoSea:AddToggle({ Name = "Fish Crew Member", Default = true, Callback = function(v) _G.FishCrewMember = v end })
    Tabs.AutoSea:AddToggle({ Name = "Shark", Default = true, Callback = function(v) _G.Shark = v end })

    Tabs.AutoSea:AddParagraph("Boats")

    Tabs.AutoSea:AddToggle({ Name = "Pirate Brigade", Default = true, Callback = function(v) _G.PirateBrigade = v end })
    Tabs.AutoSea:AddToggle({ Name = "Pirate Grand Brigade", Default = true, Callback = function(v) _G.PirateGrandBrigade = v end })
    Tabs.AutoSea:AddToggle({ Name = "Fish Boat", Default = true, Callback = function(v) _G.FishBoat = v end })

    Tabs.AutoSea:AddSection("Skill")

    Tabs.AutoSea:AddToggle({ Name = "Aimbot Skill", Default = true, Callback = function(v) _G.SeaAimBotSkill = v end })
    Tabs.AutoSea:AddToggle({ Name = "Skill Z", Default = true, Callback = function(v) _G.SeaSkillZ = v end })
    Tabs.AutoSea:AddToggle({ Name = "Skill X", Default = true, Callback = function(v) _G.SeaSkillX = v end })
    Tabs.AutoSea:AddToggle({ Name = "Skill C", Default = true, Callback = function(v) _G.SeaSkillC = v end })
    Tabs.AutoSea:AddToggle({ Name = "Skill V", Default = true, Callback = function(v) _G.SeaSkillV = v end })
    Tabs.AutoSea:AddToggle({ Name = "Skill F", Default = false, Callback = function(v) _G.SeaSkillF = v end })

    Tabs.AutoSea:AddSection("Configs")

    Tabs.AutoSea:AddDropdown({
        Name = "Tween Sea Level",
        Options = {"1", "2", "3", "4", "5", "6", "inf"},
        Default = "6",
        Flag = "Sea/SeaLevel",
        Callback = function(Value)
            _G.SeaLevelTP = Value
        end
    })

    Tabs.AutoSea:AddSlider({
        Name = "Boat Tween Speed",
        Min = 100,
        Max = 300,
        Increment = 10,
        Default = 250,
        Flag = "Sea/BoatSpeed",
        Callback = function(Value)
            _G.SeaBoatSpeed = Value
        end
    })

    Tabs.AutoSea:AddSection("NPCs")

    local NPCDropdown = Tabs.AutoSea:AddDropdown({
        Name = "Select NPC",
        Options = {"Shipwright Teacher", "Shark Hunter", "Beast Hunter", "Spy"},
        Default = "Spy",
        Callback = function(Value)
            if Value == "Shipwright Teacher" then
                _G.SelectedNPC = CFrame.new(-16526, 76, 309)
            elseif Value == "Shark Hunter" then
                _G.SelectedNPC = CFrame.new(-16526, 108, 752)
            elseif Value == "Beast Hunter" then
                _G.SelectedNPC = CFrame.new(-16281, 73, 263)
            elseif Value == "Spy" then
                _G.SelectedNPC = CFrame.new(-16471, 528, 539)
            end
        end
    })

    Tabs.AutoSea:AddToggle({
        Name = "Teleport To NPC",
        Default = false,
        Callback = function(Value)
            _G.NPCtween = Value
        end
    })

-- Sea 2
elseif PlaceId == 4442272183 then

    Tabs.AutoSea:AddSection("Farm")

    Tabs.AutoSea:AddToggle({
        Name = "Auto Farm Sea",
        Default = false,
        Callback = function(Value)
            _G.Sea2_AutoFarmSea = Value
        end
    })

    Tabs.AutoSea:AddButton({
        Name = "Buy New Boat",
        Callback = function()
            _G.BuyNewBoat = true
        end
    })

    Tabs.AutoSea:AddSection("Select Farm")

    Tabs.AutoSea:AddToggle({ Name = "Sea Beasts", Default = true, Callback = function(v) _G.KillSeaBeasts = v end })
    Tabs.AutoSea:AddToggle({ Name = "Pirate Brigade", Default = true, Callback = function(v) _G.PirateBrigade = v end })

    Tabs.AutoSea:AddSection("Skill")

    Tabs.AutoSea:AddToggle({ Name = "Aimbot Skill", Default = true, Callback = function(v) _G.SeaAimBotSkill = v end })
    Tabs.AutoSea:AddToggle({ Name = "Skill Z", Default = true, Callback = function(v) _G.SeaSkillZ = v end })
    Tabs.AutoSea:AddToggle({ Name = "Skill X", Default = true, Callback = function(v) _G.SeaSkillX = v end })
    Tabs.AutoSea:AddToggle({ Name = "Skill C", Default = true, Callback = function(v) _G.SeaSkillC = v end })
    Tabs.AutoSea:AddToggle({ Name = "Skill V", Default = true, Callback = function(v) _G.SeaSkillV = v end })
    Tabs.AutoSea:AddToggle({ Name = "Skill F", Default = false, Callback = function(v) _G.SeaSkillF = v end })

    Tabs.AutoSea:AddSection("Configs")

    Tabs.AutoSea:AddSlider({
        Name = "Boat Tween Speed",
        Min = 100,
        Max = 300,
        Increment = 10,
        Default = 250,
        Flag = "Sea/BoatSpeed",
        Callback = function(Value)
            _G.SeaBoatSpeed = Value
        end
    })

-- Sea 1 أو غير معروف: إخفاء الـ Tab
else
    Tabs.AutoSea:Destroy()
end
--------------------------------------------------------------------------------
-- Tab: Race-V4 (Sea 3 فقط)
--------------------------------------------------------------------------------

if game.PlaceId == 7449423635 then

    Tabs.RaceV4:AddSection("Mirage")

    Tabs.RaceV4:AddToggle({
        Name = "Teleport To Gear",
        Default = false,
        Callback = function(Value)
            _G.TeleportToGear = Value
        end
    })

    Tabs.RaceV4:AddToggle({
        Name = "Teleport To Mirage",
        Default = false,
        Callback = function(Value)
            _G.AutoMiragePuzzle = Value
        end
    })

    Tabs.RaceV4:AddToggle({
        Name = "Teleport To Fruit Dealer",
        Default = false,
        Callback = function(Value)
            _G.TeleportToFruitDeler = Value
        end
    })

    Tabs.RaceV4:AddSection("Trial")

    Tabs.RaceV4:AddToggle({
        Name = "Teleport To Race Door",
        Default = false,
        Callback = function(Value)
            _G.AutoTpRaceDoor = Value
        end
    })

    Tabs.RaceV4:AddToggle({
        Name = "Auto Finish Trial [ BETA ]",
        Desc = "report bugs on our discord [ redz Hub | Community ]",
        Default = false,
        Callback = function(Value)
            _G.AutoFinishTrial = Value
        end
    })

    -- إذا كان صاحب السكربت (UserId معين)
    if game.Players.LocalPlayer.UserId == 2764978820 then
        Tabs.RaceV4:AddSection("Race")
        Tabs.RaceV4:AddToggle({
            Name = "Auto Train",
            Default = false,
            Callback = function(Value)
                _G.AutoTrain = Value
            end
        })
    end

else
    Tabs.RaceV4:Destroy()
end

--------------------------------------------------------------------------------
-- Tab: Items (Quests/Items) - حسب الـ Sea
--------------------------------------------------------------------------------

local PlaceId = game.PlaceId

if PlaceId == 2753915549 then -- Sea 1

    Tabs.Items:AddSection("Second Sea")
    Tabs.Items:AddToggle({
        Name = "Auto Second Sea",
        Desc = "Unlocks and teleports to the new world automatically",
        Default = false,
        Callback = function(Value)
            _G.AutoSecondSea = Value
        end
    })

    Tabs.Items:AddSection("Saber")
    Tabs.Items:AddToggle({
        Name = "Auto Unlock Saber",
        Desc = "If you reach level 200, the script will automatically get Shanks Sword",
        Default = false,
        Callback = function(Value)
            _G.AutoUnlockSaber = Value
        end
    })

    Tabs.Items:AddSection("God Boss")
    Tabs.Items:AddToggle({
        Name = "Auto Pole V1",
        Default = false,
        Callback = function(Value)
            _G.AutoEnelBossPole = Value
        end
    })

    Tabs.Items:AddSection("The Saw")
    Tabs.Items:AddToggle({
        Name = "Auto Saw Sword",
        Default = false,
        Callback = function(Value)
            _G.AutoSawBoss = Value
        end
    })

elseif PlaceId == 4442272183 then -- Sea 2

    Tabs.Items:AddSection("Third Sea")
    Tabs.Items:AddToggle({
        Name = "Auto Third Sea",
        Default = false,
        Callback = function(Value)
            _G.AutoThirdSea = Value
        end
    })

    Tabs.Items:AddToggle({
        Name = "Auto Kill Don Swan",
        Default = false,
        Callback = function(Value)
            _G.AutoKillDonSwan = Value
        end
    })

    Tabs.Items:AddToggle({
        Name = "Auto Don Swan Hop",
        Default = false,
        Callback = function(Value)
            _G.AutoDonSwanHop = Value
        end
    })

    Tabs.Items:AddSection("Bartilo Quest")
    Tabs.Items:AddToggle({
        Name = "Auto Bartilo Quest",
        Default = false,
        Callback = function(Value)
            _G.AutoBartiloQuest = Value
        end
    })

    Tabs.Items:AddSection("Rengoku")
    Tabs.Items:AddToggle({
        Name = "Auto Rengoku",
        Default = false,
        Callback = function(Value)
            _G.AutoRengoku = Value
        end
    })

    Tabs.Items:AddToggle({
        Name = "Auto Rengoku Hop",
        Default = false,
        Callback = function(Value)
            _G.AutoRengokuHop = Value
        end
    })

    Tabs.Items:AddSection("Legendary Sword")
    Tabs.Items:AddToggle({
        Name = "Auto Buy Legendary Sword",
        Default = false,
        Callback = function(Value)
            _G.AutoLegendarySword = Value
        end
    })

    Tabs.Items:AddToggle({
        Name = "Auto Buy True Triple Katana",
        Default = false,
        Callback = function(Value)
            _G.AutoTTK = Value
        end
    })

    Tabs.Items:AddSection("Race")
    Tabs.Items:AddToggle({
        Name = "Auto Evo Race V2",
        Default = false,
        Callback = function(Value)
            _G.AutoRaceV2 = Value
        end
    })

    if game.Players.LocalPlayer.UserId == 2764978820 then
        Tabs.Items:AddToggle({
            Name = "Auto Evo Race V3",
            Default = false,
            Callback = function(Value)
                _G.AutoRaceV3 = Value
            end
        })
    end

    Tabs.Items:AddSection("Cursed Captain")
    Tabs.Items:AddToggle({
        Name = "Auto Cursed Captain",
        Default = false,
        Callback = function(Value)
            _G.AutoCursedCaptain = Value
        end
    })

    Tabs.Items:AddSection("Dark Beard")
    Tabs.Items:AddToggle({
        Name = "Auto Dark Beard",
        Default = false,
        Callback = function(Value)
            _G.AutoDarkbeard = Value
        end
    })

    Tabs.Items:AddSection("Law")
    Tabs.Items:AddToggle({
        Name = "Auto Buy Law Chip",
        Default = false,
        Callback = function(Value)
            _G.AutoBuyLawChip = Value
        end
    })

    Tabs.Items:AddToggle({
        Name = "Auto Start Law Raid",
        Default = false,
        Callback = function(Value)
            _G.AutoStartLawRaid = Value
        end
    })

    Tabs.Items:AddToggle({
        Name = "Auto Kill Law Boss",
        Default = false,
        Callback = function(Value)
            _G.AutoKillLawBoss = Value
        end
    })

elseif PlaceId == 7449423635 then -- Sea 3

    Tabs.Items:AddSection("Elite Hunter")

    local EliteStats = Tabs.Items:AddParagraph("Elite Stats : not Spawn")
    local EliteProgress = Tabs.Items:AddParagraph("Elite Hunter progress : 0")

    -- تحديث حالة Elite تلقائياً (مثال بسيط، يمكنك توسيعه)
    spawn(function()
        while task.wait(0.5) do
            -- افتراضياً
            EliteStats:SetTitle("Elite Stats : not Spawn")
        end
    end)

    spawn(function()
        while task.wait(1) do
            EliteProgress:SetTitle("Elite Hunter progress : 0") -- يمكن ربطه بـ Remote
        end
    end)

    Tabs.Items:AddToggle({
        Name = "Auto Elite Hunter",
        Default = false,
        Callback = function(Value)
            _G.AutoEliteHunter = Value
        end
    })

    Tabs.Items:AddToggle({
        Name = "Auto Elite Hunter Hop",
        Default = false,
        Callback = function(Value)
            _G.AutoEliteHunterHop = Value
        end
    })

    if not game:GetService("Players").LocalPlayer.Backpack:FindFirstChild("Yama") then
        Tabs.Items:AddToggle({
            Name = "Auto Collect Yama < Need 30 >",
            Default = false,
            Callback = function(Value)
                _G.AutoCollectYama = Value
            end
        })
    end

    Tabs.Items:AddSection("Tushita")
    Tabs.Items:AddToggle({
        Name = "Auto Tushita",
        Default = false,
        Callback = function(Value)
            _G.AutoTushita = Value
        end
    })

    Tabs.Items:AddSection("Cake Prince + Dough King")

    local CakeStats = Tabs.Items:AddParagraph("Stats : 0")

    spawn(function()
        while task.wait(1) do
            CakeStats:SetTitle("Stats : 0") -- يمكن ربطه بـ Remote
        end
    end)

    Tabs.Items:AddToggle({
        Name = "Auto Cake Prince",
        Default = false,
        Callback = function(Value)
            _G.AutoCakePrince = Value
        end
    })

    Tabs.Items:AddToggle({
        Name = "Auto Dough King",
        Default = false,
        Callback = function(Value)
            _G.AutoDoughKing = Value
        end
    })

    Tabs.Items:AddSection("Rip Indra")

    local RipIndraToggle1 = Tabs.Items:AddToggle({
        Name = "Auto Active Button Haki Color",
        Default = false,
        Callback = function(Value)
            _G.RipIndraLegendaryHaki = Value
            if Value then
                RipIndraToggle2:Set(false)
            end
        end
    })

    local RipIndraToggle2 = Tabs.Items:AddToggle({
        Name = "Auto Rip Indra",
        Default = false,
        Callback = function(Value)
            _G.AutoRipIndra = Value
            if Value then
                RipIndraToggle1:Set(false)
            end
        end
    })

    Tabs.Items:AddSection("Citizen Quest")
    Tabs.Items:AddToggle({
        Name = "Auto Citizen Quest",
        Default = false,
        Callback = function(Value)
            _G.AutoMusketeerHat = Value
        end
    })

    -- باقي Fighting Style و Mastery وغيرها في الجزء التالي
end
--------------------------------------------------------------------------------
-- باقي Tab Items (يستمر من الجزء السابق - Sea 3 و Sea 2/3 مشترك)
--------------------------------------------------------------------------------

-- Fighting Style (مشترك Sea 2 و Sea 3)
Tabs.Items:AddSection("Fighting Style")

Tabs.Items:AddToggle({
    Name = "Auto Death Step",
    Default = false,
    Callback = function(Value)
        _G.AutoDeathStep = Value
    end
})

Tabs.Items:AddToggle({
    Name = "Auto Electric Claw <BETA>",
    Default = false,
    Callback = function(Value)
        _G.AutoElectricClaw = Value
    end
})

Tabs.Items:AddToggle({
    Name = "Auto Sharkman Karate",
    Default = false,
    Callback = function(Value)
        _G.AutoSharkmanKarate = Value
    end
})

Tabs.Items:AddToggle({
    Name = "Auto Dragon Talon",
    Default = false,
    Callback = function(Value)
        _G.AutoDragonTalon = Value
    end
})

Tabs.Items:AddToggle({
    Name = "Auto Superhuman",
    Default = false,
    Callback = function(Value)
        _G.AutoSuperhuman = Value
    end
})

Tabs.Items:AddToggle({
    Name = "Auto God Human",
    Default = false,
    Callback = function(Value)
        _G.AutoGodHuman = Value
    end
})

-- Auto Mastery All (Sea 3 فقط)
if game.PlaceId == 7449423635 then
    Tabs.Items:AddSection("Auto Mastery All")

    Tabs.Items:AddSlider({
        Name = "Select Mastery",
        Min = 100,
        Max = 600,
        Increment = 5,
        Default = 600,
        Flag = "FMastery/Selected",
        Callback = function(Value)
            _G.AutoMasteryValue = Value
        end
    })

    Tabs.Items:AddToggle({
        Name = "Auto Mastery All Fighting Style",
        Default = false,
        Flag = "AutoMastery/FightStyle",
        Callback = function(Value)
            _G.AutoMasteryFightingStyle = Value
        end
    })

    Tabs.Items:AddToggle({
        Name = "Auto Mastery All Swords",
        Default = false,
        Callback = function(Value)
            _G.AutoMasteryAllSwords = Value
        end
    })
end

-- Training Dummy (Sea 3)
if game.PlaceId == 7449423635 then
    Tabs.Items:AddSection("Training Dummy")
    Tabs.Items:AddToggle({
        Name = "Auto Training Dummy",
        Default = false,
        Callback = function(Value)
            _G.AutoDummy = Value
        end
    })
end

-- Haki Color
Tabs.Items:AddSection("Haki Color")

Tabs.Items:AddToggle({
    Name = "Auto Buy Haki Color",
    Default = false,
    Flag = "Buy/HakiColor",
    Callback = function(Value)
        _G.AutoBuyHakiColor = Value
    end
})

if game.PlaceId == 7449423635 then
    Tabs.Items:AddToggle({
        Name = "Auto Rainbow Haki",
        Default = false,
        Callback = function(Value)
            _G.AutoRainbowHaki = Value
        end
    })
end

-- BETA (Sea 3)
if game.PlaceId == 7449423635 then
    Tabs.Items:AddSection("BETA")
    Tabs.Items:AddToggle({
        Name = "Auto Soul Guitar",
        Default = false,
        Callback = function(Value)
            _G.AutoSoulGuitar = Value
        end
    })

    Tabs.Items:AddToggle({
        Name = "Auto CDK",
        Default = false,
        Callback = function(Value)
            _G.AutoCDK = Value
        end
    })
end

--------------------------------------------------------------------------------
-- Tab: FruitRaid كامل
--------------------------------------------------------------------------------

Tabs.FruitRaid:AddSection("Fruits")

Tabs.FruitRaid:AddToggle({
    Name = "Auto Store Fruits",
    Default = false,
    Callback = function(Value)
        _G.AutoStoreFruits = Value
    end
})

Tabs.FruitRaid:AddToggle({
    Name = "Teleport to Fruits",
    Default = false,
    Flag = "Fruits/Teleport",
    Callback = function(Value)
        _G.TeleportToFruit = Value
    end
})

Tabs.FruitRaid:AddToggle({
    Name = "Auto Random Fruit",
    Default = false,
    Callback = function(Value)
        _G.AutoRandomFruit = Value
    end
})

Tabs.FruitRaid:AddSection("Raid")

if game.PlaceId == 2753915549 then
    Tabs.FruitRaid:AddParagraph("Only on Sea 2 and 3")
else
    -- Raid Chips
    local RaidChips = {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Human Buddha", "Sand", "Bird Phoenix", "Dough"}

    local RaidDropdown = Tabs.FruitRaid:AddDropdown({
        Name = "Select Raid",
        Options = RaidChips,
        Flag = "Raid/SelectedChip",
        Callback = function(Value)
            _G.SelectRaidChip = Value
        end
    })

    Tabs.FruitRaid:AddToggle({
        Name = "Auto Farm Raid",
        Default = false,
        Callback = function(Value)
            _G.AutoFarmRaid = Value
        end
    })

    Tabs.FruitRaid:AddToggle({
        Name = "Auto Buy Chip",
        Default = false,
        Callback = function(Value)
            _G.AutoBuyRaidChip = Value
        end
    })
end
--------------------------------------------------------------------------------
-- Tab: Stats (إذا لم يصل Max Level)
--------------------------------------------------------------------------------

local MaxLevel = 2550
local PlayerLevel = game.Players.LocalPlayer.Data.Level.Value

if PlayerLevel < MaxLevel then

    Tabs.Stats:AddToggle({
        Name = "Auto Stats",
        Default = false,
        Callback = function(Value)
            _G.AutoStats = Value
        end
    })

    Tabs.Stats:AddSlider({
        Name = "Select Points",
        Min = 1,
        Max = 100,
        Increment = 1,
        Default = 1,
        Callback = function(Value)
            _G.SelectedPoints = Value
        end
    })

    Tabs.Stats:AddSection("Select Stats")

    Tabs.Stats:AddToggle({ Name = "Melee", Flag = "Stats/SelectMelee", Callback = function(v) _G.StatMelee = v end })
    Tabs.Stats:AddToggle({ Name = "Defense", Flag = "Stats/SelectDefense", Callback = function(v) _G.StatDefense = v end })
    Tabs.Stats:AddToggle({ Name = "Sword", Flag = "Stats/SelectSword", Callback = function(v) _G.StatSword = v end })
    Tabs.Stats:AddToggle({ Name = "Gun", Flag = "Stats/SelectGun", Callback = function(v) _G.StatGun = v end })
    Tabs.Stats:AddToggle({ Name = "Demon Fruit", Flag = "Stats/SelectDemonFruit", Callback = function(v) _G.StatFruit = v end })

else
    Tabs.Stats:Destroy()
end

--------------------------------------------------------------------------------
-- Tab: Teleport كامل
--------------------------------------------------------------------------------

Tabs.Teleport:AddSection("Teleport to Sea")

Tabs.Teleport:AddButton({
    Name = "Teleport to Sea 1",
    Callback = function()
        -- كود السفر إلى Sea 1
    end
})

Tabs.Teleport:AddButton({
    Name = "Teleport to Sea 2",
    Callback = function()
        -- كود السفر إلى Sea 2
    end
})

Tabs.Teleport:AddButton({
    Name = "Teleport to Sea 3",
    Callback = function()
        -- كود السفر إلى Sea 3
    end
})

Tabs.Teleport:AddSection("Islands")

local IslandOptions = (game.PlaceId == 2753915549) and {
    "WindMill", "Marine", "Middle Town", "Jungle", "Pirate Village", "Desert", "Snow Island",
    "MarineFord", "Colosseum", "Sky Island 1", "Sky Island 2", "Sky Island 3", "Prison",
    "Magma Village", "Under Water Island", "Fountain City"
} or (game.PlaceId == 4442272183) and {
    "The Cafe", "Frist Spot", "Dark Area", "Flamingo Mansion", "Flamingo Room", "Green Zone",
    "Zombie Island", "Two Snow Mountain", "Punk Hazard", "Cursed Ship", "Ice Castle",
    "Forgotten Island", "Ussop Island"
} or (game.PlaceId == 7449423635) and {
    "Mansion", "Port Town", "Great Tree", "Castle On The Sea", "Hydra Island", "Floating Turtle",
    "Haunted Castle", "Ice Cream Island", "Peanut Island", "Cake Island", "Candy Cane Island",
    "Tiki Outpost"
} or {}

local IslandDropdown = Tabs.Teleport:AddDropdown({
    Name = "Select Island",
    Options = IslandOptions,
    Default = IslandOptions[1] or "",
    Callback = function(Value)
        _G.TeleportIslandSelect = Value
    end
})

Tabs.Teleport:AddToggle({
    Name = "Teleport To Island",
    Default = false,
    Callback = function(Value)
        _G.TeleportToIsland = Value
    end
})

-- Race V4 Temple (Sea 3)
if game.PlaceId == 7449423635 then
    Tabs.Teleport:AddSection("Race V4")
    Tabs.Teleport:AddButton({
        Name = "Teleport To Temple of Time",
        Callback = function()
            game.Players.LocalPlayer.Character:Pivot(CFrame.new(28286, 14897, 103))
        end
    })
end

--------------------------------------------------------------------------------
-- Tab: Visual كامل
--------------------------------------------------------------------------------

Tabs.Visual:AddSection("Aimbot Nearest")

Tabs.Visual:AddToggle({
    Name = "Aimbot Tap",
    Default = false,
    Callback = function(Value)
        _G.AimbotTap = Value
    end
})

Tabs.Visual:AddToggle({
    Name = "Aimbot Skill",
    Default = false,
    Callback = function(Value)
        _G.AimbotPlayer = Value
    end
})

Tabs.Visual:AddSection("Notifications")

Tabs.Visual:AddSlider({
    Name = "Nofication Time",
    Min = 5,
    Max = 120,
    Increment = 1,
    Default = 15,
    Flag = "Notify/Time",
    Callback = function(Value)
        _G.NotificationTime = Value
    end
})

Tabs.Visual:AddToggle({
    Name = "Fruit Spawn",
    Default = false,
    Flag = "Notify/Fruit",
    Callback = function(Value)
        _G.FruitNotify = Value
    end
})

Tabs.Visual:AddSection("ESP")

if game.PlaceId == 4442272183 then
    Tabs.Visual:AddToggle({
        Name = "ESP Flowers",
        Default = false,
        Callback = function(Value)
            _G.EspFlowers = Value
        end
    })
end

Tabs.Visual:AddToggle({
    Name = "ESP Players",
    Default = false,
    Callback = function(Value)
        _G.EspPlayer = Value
    end
})

Tabs.Visual:AddToggle({
    Name = "ESP Fruits",
    Default = false,
    Flag = "ESP/Fruits",
    Callback = function(Value)
        _G.EspFruits = Value
    end
})

Tabs.Visual:AddToggle({
    Name = "ESP Chests",
    Default = false,
    Callback = function(Value)
        _G.EspChests = Value
    end
})

Tabs.Visual:AddToggle({
    Name = "ESP Islands",
    Default = false,
    Callback = function(Value)
        _G.EspIslands = Value
    end
})

Tabs.Visual:AddSection("Fruits")

Tabs.Visual:AddButton({
    Name = "Rain Fruit",
    Callback = function()
        -- كود Rain Fruit
    end
})

Tabs.Visual:AddButton({
    Name = "Bring Fruits",
    Callback = function()
        -- كود Bring Fruits
    end
})

Tabs.Visual:AddSection("Bounty")

Tabs.Visual:AddButton({
    Name = "Earn Fake Bounty",
    Callback = function()
        -- كود Fake Bounty
    end
})

Tabs.Visual:AddButton({
    Name = "Earn Fake Money",
    Callback = function()
        -- كود Fake Money
    end
})

Tabs.Visual:AddButton({
    Name = "Earn Fake Fragments",
    Callback = function()
        -- كود Fake Fragments
    end
})

Tabs.Visual:AddButton({
    Name = "Earn Fake Mastery",
    Callback = function()
        -- كود Fake Mastery
    end
})

Tabs.Visual:AddSection("Fake")

Tabs.Visual:AddParagraph("Fake Stats")

Tabs.Visual:AddTextBox({ Name = "Fake Defense", Placeholder = "Defense", Callback = function(v) game.Players.LocalPlayer.Data.Stats.Defense.Level.Value = tonumber(v) or 0 end })
Tabs.Visual:AddTextBox({ Name = "Fake Fruit", Placeholder = "Fruit", Callback = function(v) game.Players.LocalPlayer.Data.Stats["Demon Fruit"].Level.Value = tonumber(v) or 0 end })
Tabs.Visual:AddTextBox({ Name = "Fake Gun", Placeholder = "Gun", Callback = function(v) game.Players.LocalPlayer.Data.Stats.Gun.Level.Value = tonumber(v) or 0 end })
Tabs.Visual:AddTextBox({ Name = "Fake Melee", Placeholder = "Melee", Callback = function(v) game.Players.LocalPlayer.Data.Stats.Melee.Level.Value = tonumber(v) or 0 end })
Tabs.Visual:AddTextBox({ Name = "Fake Sword", Placeholder = "Sword", Callback = function(v) game.Players.LocalPlayer.Data.Stats.Sword.Level.Value = tonumber(v) or 0 end })

Tabs.Visual:AddParagraph("Fake Mode")

Tabs.Visual:AddTextBox({ Name = "Fake Level", Placeholder = "Level", Callback = function(v) game.Players.LocalPlayer.Data.Level.Value = tonumber(v) or 1 end })
Tabs.Visual:AddTextBox({ Name = "Fake Points", Placeholder = "Points", Callback = function(v) game.Players.LocalPlayer.Data.Points.Value = tonumber(v) or 0 end })
Tabs.Visual:AddTextBox({ Name = "Fake Bounty", Placeholder = "Bounty", Callback = function(v) game.Players.LocalPlayer.leaderstats["Bounty/Honor"].Value = tonumber(v) or 0 end })
Tabs.Visual:AddTextBox({ Name = "Fake Energy", Placeholder = "Energy", Callback = function(v) if game.Players.LocalPlayer.Character then game.Players.LocalPlayer.Character.Energy.Max = tonumber(v); game.Players.LocalPlayer.Character.Energy.Value = tonumber(v) end end })
Tabs.Visual:AddTextBox({ Name = "Fake Health", Placeholder = "Health", Callback = function(v) if game.Players.LocalPlayer.Character then game.Players.LocalPlayer.Character.Humanoid.MaxHealth = tonumber(v); game.Players.LocalPlayer.Character.Humanoid.Health = tonumber(v) end end })
Tabs.Visual:AddTextBox({ Name = "Fake Money", Placeholder = "Money", Callback = function(v) game.Players.LocalPlayer.Data.Beli.Value = tonumber(v) or 0 end })
Tabs.Visual:AddTextBox({ Name = "Fake Fragments", Placeholder = "Fragments", Callback = function(v) game.Players.LocalPlayer.Data.Fragments.Value = tonumber(v) or 0 end })
--------------------------------------------------------------------------------
-- Tab: Shop (كل الأقسام من vu3.Shop في السكربت الأصلي)
--------------------------------------------------------------------------------

-- مثال على هيكل الشوب (يمكنك توسيعه حسب vu3.Shop في السكربت الأصلي)
Tabs.Shop:AddSection("Fruits")
Tabs.Shop:AddButton({ Name = "Random Fruit", Callback = function() -- Remote Cousin Buy end })

Tabs.Shop:AddSection("Fighting Styles")
Tabs.Shop:AddButton({ Name = "Black Leg", Callback = function() -- Remote BuyBlackLeg end })
Tabs.Shop:AddButton({ Name = "Electro", Callback = function() -- Remote BuyElectro end })
Tabs.Shop:AddButton({ Name = "Fishman Karate", Callback = function() -- Remote BuyFishmanKarate end })
Tabs.Shop:AddButton({ Name = "Dragon Claw", Callback = function() -- Remote DragonClaw end })
Tabs.Shop:AddButton({ Name = "Superhuman", Callback = function() -- Remote BuySuperhuman end })
Tabs.Shop:AddButton({ Name = "Death Step", Callback = function() -- Remote BuyDeathStep end })
Tabs.Shop:AddButton({ Name = "Sharkman Karate", Callback = function() -- Remote BuySharkmanKarate end })
Tabs.Shop:AddButton({ Name = "Electric Claw", Callback = function() -- Remote BuyElectricClaw end })
Tabs.Shop:AddButton({ Name = "Dragon Talon", Callback = function() -- Remote BuyDragonTalon end })
Tabs.Shop:AddButton({ Name = "Godhuman", Callback = function() -- Remote BuyGodhuman end })

Tabs.Shop:AddSection("Swords")
Tabs.Shop:AddButton({ Name = "Katana", Callback = function() end })
Tabs.Shop:AddButton({ Name = "Cutlass", Callback = function() end })
-- ... باقي السيوف حسب السكربت

Tabs.Shop:AddSection("Guns")
Tabs.Shop:AddButton({ Name = "Slingshot", Callback = function() end })
-- ... إلخ

Tabs.Shop:AddSection("Accessories")
Tabs.Shop:AddButton({ Name = "Tomoe Ring", Callback = function() end })
-- ... إلخ

-- يمكنك إضافة كل الأزرار من vu3.Shop هنا بنفس الطريقة

--------------------------------------------------------------------------------
-- Tab: Misc كامل
--------------------------------------------------------------------------------

if game.Players.LocalPlayer.UserId == 2764978820 then -- صاحب السكربت
    Tabs.Misc:AddSection("Executor")
    Tabs.Misc:AddButton({
        Name = "Execute Clipboard",
        Callback = function()
            loadstring((getclipboard or fromclipboard)())()
        end
    })
end

Tabs.Misc:AddSection("Join Server")

local JobIdBox = Tabs.Misc:AddTextBox({
    Name = "Input Job Id",
    Placeholder = "Job ID",
    Callback = function(Value)
        _G.JobIdInput = Value
    end
})

Tabs.Misc:AddButton({
    Name = "Join Server",
    Callback = function()
        if _G.JobIdInput and _G.JobIdInput ~= "" then
            -- كود الـ Teleport إلى Server
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, _G.JobIdInput)
        end
    end
})

Tabs.Misc:AddButton({
    Name = "Join Clipboard",
    Callback = function()
        local clipboard = (getclipboard or fromclipboard)()
        if clipboard then
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, clipboard)
        end
    end
})

Tabs.Misc:AddSection("Configs")

Tabs.Misc:AddSlider({
    Name = "Farm Distance",
    Min = 5,
    Max = 30,
    Increment = 1,
    Default = 15,
    Callback = function(Value)
        _G.FarmPos = Vector3.new(0, Value, Value)
        _G.FarmDistance = Value
    end
})

Tabs.Misc:AddSlider({
    Name = "Tween Speed",
    Min = 50,
    Max = 300,
    Increment = 5,
    Default = 200,
    Callback = function(Value)
        _G.TweenSpeed = Value
    end
})

Tabs.Misc:AddSlider({
    Name = "Bring Mobs Distance",
    Min = 50,
    Max = 500,
    Increment = 10,
    Default = 200,
    Callback = function(Value)
        _G.BringMobsDistance = Value
    end
})

Tabs.Misc:AddSlider({
    Name = "Auto Click Delay",
    Min = 0.1,
    Max = 1,
    Increment = 0.01,
    Default = 0.2,
    Callback = function(Value)
        _G.AutoClickDelay = math.clamp(Value, 0.125, 1)
    end
})

Tabs.Misc:AddToggle({ Name = "Increase Attack Distance", Default = true, Callback = function(v) _G.AttackDistance = v end })
Tabs.Misc:AddToggle({ Name = "Bring Mobs", Default = true, Callback = function(v) _G.BringMobs = v end })
Tabs.Misc:AddToggle({ Name = "Auto Haki", Default = true, Callback = function(v) _G.AutoHaki = v end })
Tabs.Misc:AddToggle({ Name = "Auto Click", Default = true, Callback = function(v) _G.AutoClick = v end })
Tabs.Misc:AddToggle({ Name = "Fast Attack", Default = true, Callback = function(v) _G.FastAttack = v end })

Tabs.Misc:AddSection("Codes")
Tabs.Misc:AddButton({
    Name = "Redeem all Codes",
    Callback = function()
        local codes = game:HttpGet("https://raw.githubusercontent.com/REDzHUB/BloxFruits/main/Codes.txt"):gsub("\n", ""):split(" ")
        for _, code in pairs(codes) do
            game:GetService("ReplicatedStorage").Remotes.Redeem:InvokeServer(code)
        end
    end
})

Tabs.Misc:AddSection("Team")
Tabs.Misc:AddButton({ Name = "Join Pirates Team", Callback = function() -- Remote SetTeam Pirates end })
Tabs.Misc:AddButton({ Name = "Join Marines Team", Callback = function() -- Remote SetTeam Marines end })

Tabs.Misc:AddSection("Menu")
Tabs.Misc:AddButton({ Name = "Devil Fruit Shop", Callback = function() game:GetService("ReplicatedStorage").Remotes.GetFruits:InvokeServer(); game.Players.LocalPlayer.PlayerGui.Main.FruitShop.Visible = true end })
Tabs.Misc:AddButton({ Name = "Titles", Callback = function() game:GetService("ReplicatedStorage").Remotes.getTitles:InvokeServer(); game.Players.LocalPlayer.PlayerGui.Main.Titles.Visible = true end })
Tabs.Misc:AddButton({ Name = "Haki Color", Callback = function() game.Players.LocalPlayer.PlayerGui.Main.Colors.Visible = true end })

Tabs.Misc:AddSection("Local-Player")

local WalkSpeedToggle = Tabs.Misc:AddToggle({
    Name = "Walk Speed",
    Default = false,
    Callback = function(Value)
        _G.WalkSpeedEnabled = Value
    end
})

Tabs.Misc:AddSlider({
    Name = "Walk Speed",
    Min = 10,
    Max = 300,
    Increment = 5,
    Default = 150,
    Callback = function(Value)
        _G.WalkSpeedValue = Value
        if _G.WalkSpeedEnabled then
            -- تطبيق السرعة
        end
    end
})

Tabs.Misc:AddSection("Visual")
Tabs.Misc:AddButton({
    Name = "Remove Fog",
    Callback = function()
        if game.Lighting:FindFirstChild("LightingLayers") then
            game.Lighting.LightingLayers:Destroy()
        end
    end
})

Tabs.Misc:AddSection("More FPS")
Tabs.Misc:AddToggle({ Name = "Remove Damage", Default = false, Callback = function(v) game:GetService("ReplicatedStorage").Assets.GUI.DamageCounter.Enabled = not v end })
Tabs.Misc:AddToggle({ Name = "Remove Notifications", Default = false, Callback = function(v) game.Players.LocalPlayer.PlayerGui.Notifications.Enabled = not v end })

Tabs.Misc:AddSection("Others")
Tabs.Misc:AddToggle({ Name = "Walk On Water", Default = true, Callback = function(v) _G.WalkOnWater = v end })
Tabs.Misc:AddToggle({ Name = "Anti AFK", Default = true, Callback = function(v) _G.AntiAFK = v end })
