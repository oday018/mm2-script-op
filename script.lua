-- ✨ Wand UI (Redz Library V5 Remake)
-- 📌 About
-- - **Wand UI** is a rebuilt and optimized version of **Redz Library V5**.
-- - It uses the same UI style as the original, with some improvements and refinements.
-- - The reason the UI is named **Wand** is that it should be the name of the next generation of **redz Hub** UIs
-- - 🔹 Made by **real_redz**
-- - 🔹 Designed mainly for use in **Redz Hub** scripts
-- - 🔹 Open-Source, Lightweight, and Optimized
-- ---
-- 🚀 Getting Starte
-- To load **Wand UI**, simply run:
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()
-- ### Creating a Window
local Window = Library:MakeWindow({
  Title = "Grok 4 : Blox Fruits",
  SubTitle = "Built by xAI",
  ScriptFolder = "BloxFruits"
})
-- ### Creating a Tab
local FarmTab = Window:MakeTab({
  Title = "Farm",
  Icon = "rbxassetid://4483345998"  -- Example icon, replace as needed
})
local PlayerTab = Window:MakeTab({
  Title = "Player",
  Icon = "rbxassetid://4483345998"
})
local ShopTab = Window:MakeTab({
  Title = "Shop",
  Icon = "rbxassetid://4483345998"
})
local MiscTab = Window:MakeTab({
  Title = "Misc",
  Icon = "rbxassetid://4483345998"
})

-- نقل الكود إلى Wand UI
-- ts file was generated at discord.gg/25ms


hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Death), function()
end)
hookfunction(require(game:GetService("ReplicatedStorage").Effect.Container.Respawn), function()
end)
if game.PlaceId ~= 2753915549 then
    if game.PlaceId ~= 4442272183 then
        if game.PlaceId == 7449423635 then
            World3 = true
        end
    else
        World2 = true
    end
else
    World1 = true
end
function MaterialMon()
    if _G.SelectMaterial == "Radiactive Material" then
        MMon = "Factory Staff"
        MPos = CFrame.new(- 105.889565, 72.8076935, - 670.247986, - 0.965929747, 0, - 0.258804798, 0, 1, 0, 0.258804798, 0, - 0.965929747)
        SP = "Bar"
    elseif _G.SelectMaterial == "Leather + Scrap Metal" then
        if game.PlaceId ~= 2753915549 then
            if game.PlaceId == 4442272183 then
                MMon = "Mercenary"
                MPos = CFrame.new(- 986.774475, 72.8755951, 1088.44653, - 0.656062722, 0, 0.754706323, 0, 1, 0, - 0.754706323, 0, - 0.656062722)
                SP = "DressTown"
            elseif game.PlaceId == 7449423635 then
                MMon = "Pirate Millionaire"
                MPos = CFrame.new(- 118.809372, 55.4874573, 5649.17041, - 0.965929747, 0, 0.258804798, 0, 1, 0, - 0.258804798, 0, - 0.965929747)
                SP = "Default"
            end
        else
            MMon = "Pirate"
            MPos = CFrame.new(- 967.433105, 13.5999937, 4034.24707, - 0.258864403, 0, - 0.965913713, 0, 1, 0, 0.965913713, 0, - 0.258864403)
            SP = "Pirate"
            MMon = "Brute"
            MPos = CFrame.new(- 1191.41235, 15.5999985, 4235.50928, 0.629286051, 0, - 0.777173758, 0, 1, 0, 0.777173758, 0, 0.629286051)
            SP = "Pirate"
        end
    elseif _G.SelectMaterial == "Magma Ore" then
        if game.PlaceId ~= 2753915549 then
            if game.PlaceId == 4442272183 then
                MMon = "Lava Pirate"
                MPos = CFrame.new(- 5158.77051, 14.4791956, - 4654.2627, - 0.848060489, 0, - 0.529899538, 0, 1, 0, 0.529899538, 0, - 0.848060489)
                SP = "CircleIslandFire"
            end
        else
            MMon = "Military Soldier"
            MPos = CFrame.new(- 5565.60156, 9.10001755, 8327.56934, - 0.838688731, 0, - 0.544611216, 0, 1, 0, 0.544611216, 0, - 0.838688731)
            SP = "Magma"
            MMon = "Military Spy"
            MPos = CFrame.new(- 5806.70068, 78.5000458, 8904.46973, 0.707134247, 0, 0.707079291, 0, 1, 0, - 0.707079291, 0, 0.707134247)
            SP = "Magma"
        end
    elseif _G.SelectMaterial == "Fish Tail" then
        if game.PlaceId ~= 2753915549 then
            if game.PlaceId == 7449423635 then
                MMon = "Fishman Captain"
                MPos = CFrame.new(- 10828.1064, 331.825989, - 9049.14648, - 0.0912091732, 0, 0.995831788, 0, 1, 0, - 0.995831788, 0, - 0.0912091732)
                SP = "PineappleTown"
            end
        else
            MMon = "Fishman Warrior"
            MPos = CFrame.new(60943.9023, 17.9492188, 1744.11133, 0.826706648, 0, - 0.562633216, 0, 1, 0, 0.562633216, 0, 0.826706648)
            SP = "Underwater City"
            MMon = "Fishman Commando"
            MPos = CFrame.new(61760.8984, 18.0800781, 1460.11133, - 0.632549644, 0, - 0.774520278, 0, 1, 0, 0.774520278, 0, - 0.632549644)
            SP = "Underwater City"
        end
    elseif _G.SelectMaterial ~= "Angel Wings" then
        if _G.SelectMaterial ~= "Mystic Droplet" then
            if _G.SelectMaterial ~= "Vampire Fang" then
                if _G.SelectMaterial ~= "Gunpowder" then
                    if _G.SelectMaterial == "Mini Tusk" then
                        MMon = "Mythological Pirate"
                        MPos = CFrame.new(- 13456.0498, 469.433228, - 7039.96436, 0, 0, 1, 0, 1, 0, - 1, 0, 0)
                        SP = "BigMansion"
                    elseif _G.SelectMaterial == "Conjured Cocoa" then
                        MMon = "Chocolate Bar Battler"
                        MPos = CFrame.new(582.828674, 25.5824986, - 12550.7041, - 0.766061664, 0, - 0.642767608, 0, 1, 0, 0.642767608, 0, - 0.766061664)
                        SP = "Chocolate"
                    end
                else
                    MMon = "Pistol Billionaire"
                    MPos = CFrame.new(- 185.693283, 84.7088699, 6103.62744, 0.90629667, 0, - 0.422642082, 0, 1, 0, 0.422642082, 0, 0.90629667)
                    SP = "Mansion"
                end
            else
                MMon = "Vampire"
                MPos = CFrame.new(- 6132.39453, 9.00769424, - 1466.16919, - 0.927179813, 0, - 0.374617696, 0, 1, 0, 0.374617696, 0, - 0.927179813)
                SP = "Graveyard"
            end
        else
            MMon = "Water Fighter"
            MPos = CFrame.new(- 3331.70459, 239.138336, - 10553.3564, - 0.29242146, 0, 0.95628953, 0, 1, 0, - 0.95628953, 0, - 0.29242146)
            SP = "ForgottenIsland"
        end
    else
        MMon = "Royal Soldier"
        MPos = CFrame.new(- 7759.45898, 5606.93652, - 1862.70276, - 0.866007447, 0, - 0.500031412, 0, 1, 0, 0.500031412, 0, - 0.866007447)
        SP = "SkyArea2"
    end
end
function CheckQuest()
    MyLevel = game:GetService("Players").LocalPlayer.Data.Level.Value
    if World1 then
        if (MyLevel < 1 or MyLevel > 9) and SelectMonster ~= "Bandit" then
            if (MyLevel < 10 or MyLevel > 14) and SelectMonster ~= "Monkey" then
                if (MyLevel < 15 or MyLevel > 29) and SelectMonster ~= "Gorilla" then
                    if (MyLevel < 30 or MyLevel > 39) and SelectMonster ~= "Pirate" then
                        if (MyLevel < 40 or MyLevel > 59) and SelectMonster ~= "Brute" then
                            if (MyLevel < 60 or MyLevel > 74) and SelectMonster ~= "Desert Bandit" then
                                if (MyLevel < 75 or MyLevel > 89) and SelectMonster ~= "Desert Officer" then
                                    if (MyLevel < 90 or MyLevel > 99) and SelectMonster ~= "Snow Bandit" then
                                        if (MyLevel < 100 or MyLevel > 119) and SelectMonster ~= "Snowman" then
                                            if (MyLevel < 120 or MyLevel > 149) and SelectMonster ~= "Chief Petty Officer" then
                                                if (MyLevel < 150 or MyLevel > 174) and SelectMonster ~= "Sky Bandit" then
                                                    if (MyLevel < 175 or MyLevel > 189) and SelectMonster ~= "Dark Master" then
                                                        if (MyLevel < 190 or MyLevel > 209) and SelectMonster ~= "Prisoner" then
                                                            if (MyLevel < 210 or MyLevel > 249) and SelectMonster ~= "Dangerous Prisone" then
                                                                if (MyLevel < 250 or MyLevel > 274) and SelectMonster ~= "Toga Warrior" then
                                                                    if (MyLevel < 275 or MyLevel > 299) and SelectMonster ~= "Gladiator" then
                                                                        if (MyLevel < 300 or MyLevel > 324) and SelectMonster ~= "Military Soldier" then
                                                                            if (MyLevel < 325 or MyLevel > 374) and SelectMonster ~= "Military Spy" then
                                                                                if (MyLevel < 375 or MyLevel > 399) and SelectMonster ~= "Fishman Warrior" then
                                                                                    if (MyLevel < 400 or MyLevel > 449) and SelectMonster ~= "Fishman Commando" then
                                                                                        if (MyLevel < 450 or MyLevel > 474) and SelectMonster ~= "God\'s Guard" then
                                                                                            if (MyLevel < 475 or MyLevel > 524) and SelectMonster ~= "Shanda" then
                                                                                                if (MyLevel < 525 or MyLevel > 549) and SelectMonster ~= "Royal Squad" then
                                                                                                    if (MyLevel < 550 or MyLevel > 624) and SelectMonster ~= "Royal Soldier" then
                                                                                                        if (MyLevel < 625 or MyLevel > 649) and SelectMonster ~= "Galley Pirate" then
                                                                                                            if MyLevel >= 650 or SelectMonster == "Galley Captain" then
                                                                                                                Mon = "Galley Captain"
                                                                                                                LevelQuest = 2
                                                                                                                NameQuest = "FountainQuest"
                                                                                                                NameMon = "Galley Captain"
                                                                                                                CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, - 0, 0.996196866, - 0, 1, - 0, - 0.996196866, - 0, 0.087131381)
                                                                                                                CFrameMon = CFrame.new(5441.95166015625, 42.50205993652344, 4950.09375)
                                                                                                            end
                                                                                                        else
                                                                                                            Mon = "Galley Pirate"
                                                                                                            LevelQuest = 1
                                                                                                            NameQuest = "FountainQuest"
                                                                                                            NameMon = "Galley Pirate"
                                                                                                            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293, 0.087131381, - 0, 0.996196866, - 0, 1, - 0, - 0.996196866, - 0, 0.087131381)
                                                                                                            CFrameMon = CFrame.new(5551.02197265625, 78.90135192871094, 3930.412841796875)
                                                                                                        end
                                                                                                    else
                                                                                                        Mon = "Royal Soldier"
                                                                                                        LevelQuest = 2
                                                                                                        NameQuest = "SkyExp2Quest"
                                                                                                        NameMon = "Royal Soldier"
                                                                                                        CFrameQuest = CFrame.new(- 7906.81592, 5634.6626, - 1411.99194, - 0, - 0, - 1, - 0, 1, - 0, 1, - 0, - 0)
                                                                                                        CFrameMon = CFrame.new(- 7836.75341796875, 5645.6640625, - 1790.6236572265625)
                                                                                                    end
                                                                                                else
                                                                                                    Mon = "Royal Squad"
                                                                                                    LevelQuest = 1
                                                                                                    NameQuest = "SkyExp2Quest"
                                                                                                    NameMon = "Royal Squad"
                                                                                                    CFrameQuest = CFrame.new(- 7906.81592, 5634.6626, - 1411.99194, - 0, - 0, - 1, - 0, 1, - 0, 1, - 0, - 0)
                                                                                                    CFrameMon = CFrame.new(- 7624.25244140625, 5658.13330078125, - 1467.354248046875)
                                                                                                end
                                                                                            else
                                                                                                Mon = "Shanda"
                                                                                                LevelQuest = 2
                                                                                                NameQuest = "SkyExp1Quest"
                                                                                                NameMon = "Shanda"
                                                                                                CFrameQuest = CFrame.new(- 7859.09814, 5544.19043, - 381.476196, - 0.422592998, - 0, 0.906319618, - 0, 1, - 0, - 0.906319618, - 0, - 0.422592998)
                                                                                                CFrameMon = CFrame.new(- 7678.48974609375, 5566.40380859375, - 497.2156066894531)
                                                                                                if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                                                                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 7894.6176757813, 5547.1416015625, - 380.29119873047))
                                                                                                end
                                                                                            end
                                                                                        else
                                                                                            Mon = "God\'s Guard"
                                                                                            LevelQuest = 1
                                                                                            NameQuest = "SkyExp1Quest"
                                                                                            NameMon = "God\'s Guard"
                                                                                            CFrameQuest = CFrame.new(- 4721.88867, 843.874695, - 1949.96643, 0.996191859, - 0, - 0.0871884301, - 0, 1, - 0, 0.0871884301, - 0, 0.996191859)
                                                                                            CFrameMon = CFrame.new(- 4710.04296875, 845.2769775390625, - 1927.3079833984375)
                                                                                            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                                                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 4607.82275, 872.54248, - 1667.55688))
                                                                                            end
                                                                                        end
                                                                                    else
                                                                                        Mon = "Fishman Commando"
                                                                                        LevelQuest = 2
                                                                                        NameQuest = "FishmanQuest"
                                                                                        NameMon = "Fishman Commando"
                                                                                        CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
                                                                                        CFrameMon = CFrame.new(61922.6328125, 18.482830047607422, 1493.934326171875)
                                                                                        if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                                                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
                                                                                        end
                                                                                    end
                                                                                else
                                                                                    Mon = "Fishman Warrior"
                                                                                    LevelQuest = 1
                                                                                    NameQuest = "FishmanQuest"
                                                                                    NameMon = "Fishman Warrior"
                                                                                    CFrameQuest = CFrame.new(61122.65234375, 18.497442245483, 1569.3997802734)
                                                                                    CFrameMon = CFrame.new(60878.30078125, 18.482830047607422, 1543.7574462890625)
                                                                                    if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                                                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.8515625, 11.6796875, 1819.7841796875))
                                                                                    end
                                                                                end
                                                                            else
                                                                                Mon = "Military Spy"
                                                                                LevelQuest = 2
                                                                                NameQuest = "MagmaQuest"
                                                                                NameMon = "Military Spy"
                                                                                CFrameQuest = CFrame.new(- 5313.37012, 10.9500084, 8515.29395, - 0.499959469, - 0, 0.866048813, - 0, 1, - 0, - 0.866048813, - 0, - 0.499959469)
                                                                                CFrameMon = CFrame.new(- 5802.8681640625, 86.26241302490234, 8828.859375)
                                                                            end
                                                                        else
                                                                            Mon = "Military Soldier"
                                                                            LevelQuest = 1
                                                                            NameQuest = "MagmaQuest"
                                                                            NameMon = "Military Soldier"
                                                                            CFrameQuest = CFrame.new(- 5313.37012, 10.9500084, 8515.29395, - 0.499959469, - 0, 0.866048813, - 0, 1, - 0, - 0.866048813, - 0, - 0.499959469)
                                                                            CFrameMon = CFrame.new(- 5411.16455078125, 11.081554412841797, 8454.29296875)
                                                                        end
                                                                    else
                                                                        Mon = "Gladiator"
                                                                        LevelQuest = 2
                                                                        NameQuest = "ColosseumQuest"
                                                                        NameMon = "Gladiator"
                                                                        CFrameQuest = CFrame.new(- 1580.04663, 6.35000277, - 2986.47534, - 0.515037298, - 0, - 0.857167721, - 0, 1, - 0, 0.857167721, - 0, - 0.515037298)
                                                                        CFrameMon = CFrame.new(- 1292.838134765625, 56.380882263183594, - 3339.031494140625)
                                                                    end
                                                                else
                                                                    Mon = "Toga Warrior"
                                                                    LevelQuest = 1
                                                                    NameQuest = "ColosseumQuest"
                                                                    NameMon = "Toga Warrior"
                                                                    CFrameQuest = CFrame.new(- 1580.04663, 6.35000277, - 2986.47534, - 0.515037298, - 0, - 0.857167721, - 0, 1, - 0, 0.857167721, - 0, - 0.515037298)
                                                                    CFrameMon = CFrame.new(- 1820.21484375, 51.68385696411133, - 2740.6650390625)
                                                                end
                                                            else
                                                                Mon = "Dangerous Prisoner"
                                                                LevelQuest = 2
                                                                NameQuest = "PrisonerQuest"
                                                                NameMon = "Dangerous Prisoner"
                                                                CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, - 0.0894274712, - 5.00292918e-9, - 0.995993316, 1.60817859e-9, 1, - 5.16744869e-9, 0.995993316, - 2.06384709e-9, - 0.0894274712)
                                                                CFrameMon = CFrame.new(5654.5634765625, 15.633401870727539, 866.2991943359375)
                                                            end
                                                        else
                                                            Mon = "Prisoner"
                                                            LevelQuest = 1
                                                            NameQuest = "PrisonerQuest"
                                                            NameMon = "Prisoner"
                                                            CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514, - 0.0894274712, - 5.00292918e-9, - 0.995993316, 1.60817859e-9, 1, - 5.16744869e-9, 0.995993316, - 2.06384709e-9, - 0.0894274712)
                                                            CFrameMon = CFrame.new(5098.9736328125, - 0.3204058110713959, 474.2373352050781)
                                                        end
                                                    else
                                                        Mon = "Dark Master"
                                                        LevelQuest = 2
                                                        NameQuest = "SkyQuest"
                                                        NameMon = "Dark Master"
                                                        CFrameQuest = CFrame.new(- 4839.53027, 716.368591, - 2619.44165, 0.866007268, - 0, 0.500031412, - 0, 1, - 0, - 0.500031412, - 0, 0.866007268)
                                                        CFrameMon = CFrame.new(- 5259.8447265625, 391.3976745605469, - 2229.035400390625)
                                                    end
                                                else
                                                    Mon = "Sky Bandit"
                                                    LevelQuest = 1
                                                    NameQuest = "SkyQuest"
                                                    NameMon = "Sky Bandit"
                                                    CFrameQuest = CFrame.new(- 4839.53027, 716.368591, - 2619.44165, 0.866007268, - 0, 0.500031412, - 0, 1, - 0, - 0.500031412, - 0, 0.866007268)
                                                    CFrameMon = CFrame.new(- 4953.20703125, 295.74420166015625, - 2899.22900390625)
                                                end
                                            else
                                                Mon = "Chief Petty Officer"
                                                LevelQuest = 1
                                                NameQuest = "MarineQuest2"
                                                NameMon = "Chief Petty Officer"
                                                CFrameQuest = CFrame.new(- 5039.58643, 27.3500385, 4324.68018, - 0, - 0, - 1, - 0, 1, - 0, 1, - 0, - 0)
                                                CFrameMon = CFrame.new(- 4881.23095703125, 22.65204429626465, 4273.75244140625)
                                            end
                                        else
                                            Mon = "Snowman"
                                            LevelQuest = 2
                                            NameQuest = "SnowQuest"
                                            NameMon = "Snowman"
                                            CFrameQuest = CFrame.new(1389.74451, 88.1519318, - 1298.90796, - 0.342042685, - 0, 0.939684391, - 0, 1, - 0, - 0.939684391, - 0, - 0.342042685)
                                            CFrameMon = CFrame.new(1201.6412353515625, 144.57958984375, - 1550.0670166015625)
                                        end
                                    else
                                        Mon = "Snow Bandit"
                                        LevelQuest = 1
                                        NameQuest = "SnowQuest"
                                        NameMon = "Snow Bandit"
                                        CFrameQuest = CFrame.new(1389.74451, 88.1519318, - 1298.90796, - 0.342042685, - 0, 0.939684391, - 0, 1, - 0, - 0.939684391, - 0, - 0.342042685)
                                        CFrameMon = CFrame.new(1354.347900390625, 87.27277374267578, - 1393.946533203125)
                                    end
                                else
                                    Mon = "Desert Officer"
                                    LevelQuest = 2
                                    NameQuest = "DesertQuest"
                                    NameMon = "Desert Officer"
                                    CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, - 0, - 0.573571265, - 0, 1, - 0, 0.573571265, - 0, 0.819155693)
                                    CFrameMon = CFrame.new(1608.2822265625, 8.614224433898926, 4371.00732421875)
                                end
                            else
                                Mon = "Desert Bandit"
                                LevelQuest = 1
                                NameQuest = "DesertQuest"
                                NameMon = "Desert Bandit"
                                CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359, 0.819155693, - 0, - 0.573571265, - 0, 1, - 0, 0.573571265, - 0, 0.819155693)
                                CFrameMon = CFrame.new(924.7998046875, 6.44867467880249, 4481.5859375)
                            end
                        else
                            Mon = "Brute"
                            LevelQuest = 2
                            NameQuest = "BuggyQuest1"
                            NameMon = "Brute"
                            CFrameQuest = CFrame.new(- 1141.07483, 4.10001802, 3831.5498, 0.965929627, - 0, - 0.258804798, - 0, 1, - 0, 0.258804798, - 0, 0.965929627)
                            CFrameMon = CFrame.new(- 1140.083740234375, 14.809885025024414, 4322.92138671875)
                        end
                    else
                        Mon = "Pirate"
                        LevelQuest = 1
                        NameQuest = "BuggyQuest1"
                        NameMon = "Pirate"
                        CFrameQuest = CFrame.new(- 1141.07483, 4.10001802, 3831.5498, 0.965929627, - 0, - 0.258804798, - 0, 1, - 0, 0.258804798, - 0, 0.965929627)
                        CFrameMon = CFrame.new(- 1103.513427734375, 13.752052307128906, 3896.091064453125)
                    end
                else
                    Mon = "Gorilla"
                    LevelQuest = 2
                    NameQuest = "JungleQuest"
                    NameMon = "Gorilla"
                    CFrameQuest = CFrame.new(- 1598.08911, 35.5501175, 153.377838, - 0, - 0, 1, - 0, 1, - 0, - 1, - 0, - 0)
                    CFrameMon = CFrame.new(- 1129.8836669921875, 40.46354675292969, - 525.4237060546875)
                end
            else
                Mon = "Monkey"
                LevelQuest = 1
                NameQuest = "JungleQuest"
                NameMon = "Monkey"
                CFrameQuest = CFrame.new(- 1598.08911, 35.5501175, 153.377838, - 0, - 0, 1, - 0, 1, - 0, - 1, - 0, - 0)
                CFrameMon = CFrame.new(- 1448.51806640625, 67.85301208496094, 11.46579647064209)
            end
        else
            Mon = "Bandit"
            LevelQuest = 1
            NameQuest = "BanditQuest1"
            NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231, 0.939700544, - 0, - 0.341998369, - 0, 1, - 0, 0.341998369, - 0, 0.939700544)
            CFrameMon = CFrame.new(1045.962646484375, 27.00250816345215, 1560.8203125)
        end
    elseif World2 then
        if (MyLevel < 700 or MyLevel > 724) and SelectMonster ~= "Raider" then
            if (MyLevel < 725 or MyLevel > 774) and SelectMonster ~= "Mercenary" then
                if (MyLevel < 775 or MyLevel > 799) and SelectMonster ~= "Swan Pirate" then
                    if (MyLevel < 800 or MyLevel > 874) and SelectMonster ~= "Factory Staff" then
                        if (MyLevel < 875 or MyLevel > 899) and SelectMonster ~= "Marine Lieutenant" then
                            if (MyLevel < 900 or MyLevel > 949) and SelectMonster ~= "Marine Captain" then
                                if (MyLevel < 950 or MyLevel > 974) and SelectMonster ~= "Zombie" then
                                    if (MyLevel < 975 or MyLevel > 999) and SelectMonster ~= "Vampire" then
                                        if (MyLevel < 1000 or MyLevel > 1049) and SelectMonster ~= "Snow Trooper" then
                                            if (MyLevel < 1050 or MyLevel > 1099) and SelectMonster ~= "Winter Warrior" then
                                                if (MyLevel < 1100 or MyLevel > 1124) and SelectMonster ~= "Lab Subordinate" then
                                                    if (MyLevel < 1125 or MyLevel > 1174) and SelectMonster ~= "Horned Warrior" then
                                                        if (MyLevel < 1175 or MyLevel > 1199) and SelectMonster ~= "Magma Ninja" then
                                                            if (MyLevel < 1200 or MyLevel > 1249) and SelectMonster ~= "Lava Pirate" then
                                                                if (MyLevel < 1250 or MyLevel > 1274) and SelectMonster ~= "Ship Deckhand" then
                                                                    if (MyLevel < 1275 or MyLevel > 1299) and SelectMonster ~= "Ship Engineer" then
                                                                        if (MyLevel < 1300 or MyLevel > 1324) and SelectMonster ~= "Ship Steward" then
                                                                            if (MyLevel < 1325 or MyLevel > 1349) and SelectMonster ~= "Ship Officer" then
                                                                                if (MyLevel < 1350 or MyLevel > 1374) and SelectMonster ~= "Arctic Warrior" then
                                                                                    if (MyLevel < 1375 or MyLevel > 1424) and SelectMonster ~= "Snow Lurker" then
                                                                                        if (MyLevel < 1425 or MyLevel > 1449) and SelectMonster ~= "Sea Soldier" then
                                                                                            if MyLevel >= 1450 or SelectMonster == "Water Fighter" then
                                                                                                Mon = "Water Fighter"
                                                                                                LevelQuest = 2
                                                                                                NameQuest = "ForgottenQuest"
                                                                                                NameMon = "Water Fighter"
                                                                                                CFrameQuest = CFrame.new(- 3054.44458, 235.544281, - 10142.8193, 0.990270376, - 0, - 0.13915664, - 0, 1, - 0, 0.13915664, - 0, 0.990270376)
                                                                                                CFrameMon = CFrame.new(- 3352.9013671875, 285.01556396484375, - 10534.841796875)
                                                                                            end
                                                                                        else
                                                                                            Mon = "Sea Soldier"
                                                                                            LevelQuest = 1
                                                                                            NameQuest = "ForgottenQuest"
                                                                                            NameMon = "Sea Soldier"
                                                                                            CFrameQuest = CFrame.new(- 3054.44458, 235.544281, - 10142.8193, 0.990270376, - 0, - 0.13915664, - 0, 1, - 0, 0.13915664, - 0, 0.990270376)
                                                                                            CFrameMon = CFrame.new(- 3028.2236328125, 64.67451477050781, - 9775.4267578125)
                                                                                        end
                                                                                    else
                                                                                        Mon = "Snow Lurker"
                                                                                        LevelQuest = 2
                                                                                        NameQuest = "FrostQuest"
                                                                                        NameMon = "Snow Lurker"
                                                                                        CFrameQuest = CFrame.new(5667.6582, 26.7997818, - 6486.08984, - 0.933587909, - 0, - 0.358349502, - 0, 1, - 0, 0.358349502, - 0, - 0.933587909)
                                                                                        CFrameMon = CFrame.new(5407.07373046875, 69.19437408447266, - 6880.88037109375)
                                                                                    end
                                                                                else
                                                                                    Mon = "Arctic Warrior"
                                                                                    LevelQuest = 1
                                                                                    NameQuest = "FrostQuest"
                                                                                    NameMon = "Arctic Warrior"
                                                                                    CFrameQuest = CFrame.new(5667.6582, 26.7997818, - 6486.08984, - 0.933587909, - 0, - 0.358349502, - 0, 1, - 0, 0.358349502, - 0, - 0.933587909)
                                                                                    CFrameMon = CFrame.new(5966.24609375, 62.97002029418945, - 6179.3828125)
                                                                                    if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                                                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 6508.5581054688, 5000.034996032715, - 132.83953857422))
                                                                                    end
                                                                                end
                                                                            else
                                                                                Mon = "Ship Officer"
                                                                                LevelQuest = 2
                                                                                NameQuest = "ShipQuest2"
                                                                                NameMon = "Ship Officer"
                                                                                CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)
                                                                                CFrameMon = CFrame.new(1036.0179443359375, 181.4390411376953, 33315.7265625)
                                                                                if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                                                                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                                                                                end
                                                                            end
                                                                        else
                                                                            Mon = "Ship Steward"
                                                                            LevelQuest = 1
                                                                            NameQuest = "ShipQuest2"
                                                                            NameMon = "Ship Steward"
                                                                            CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)
                                                                            CFrameMon = CFrame.new(919.4385375976562, 129.55599975585938, 33436.03515625)
                                                                            if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                                                                            end
                                                                        end
                                                                    else
                                                                        Mon = "Ship Engineer"
                                                                        LevelQuest = 2
                                                                        NameQuest = "ShipQuest1"
                                                                        NameMon = "Ship Engineer"
                                                                        CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)
                                                                        CFrameMon = CFrame.new(919.4786376953125, 43.54401397705078, 32779.96875)
                                                                        if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                                                                        end
                                                                    end
                                                                else
                                                                    Mon = "Ship Deckhand"
                                                                    LevelQuest = 1
                                                                    NameQuest = "ShipQuest1"
                                                                    NameMon = "Ship Deckhand"
                                                                    CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)
                                                                    CFrameMon = CFrame.new(1212.0111083984375, 150.79205322265625, 33059.24609375)
                                                                    if _G.AutoFarm and (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude > 10000 then
                                                                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(923.21252441406, 126.9760055542, 32852.83203125))
                                                                    end
                                                                end
                                                            else
                                                                Mon = "Lava Pirate"
                                                                LevelQuest = 2
                                                                NameQuest = "FireSideQuest"
                                                                NameMon = "Lava Pirate"
                                                                CFrameQuest = CFrame.new(- 5428.03174, 15.0622921, - 5299.43457, - 0.882952213, - 0, 0.469463557, - 0, 1, - 0, - 0.469463557, - 0, - 0.882952213)
                                                                CFrameMon = CFrame.new(- 5213.33154296875, 49.73788070678711, - 4701.451171875)
                                                            end
                                                        else
                                                            Mon = "Magma Ninja"
                                                            LevelQuest = 1
                                                            NameQuest = "FireSideQuest"
                                                            NameMon = "Magma Ninja"
                                                            CFrameQuest = CFrame.new(- 5428.03174, 15.0622921, - 5299.43457, - 0.882952213, - 0, 0.469463557, - 0, 1, - 0, - 0.469463557, - 0, - 0.882952213)
                                                            CFrameMon = CFrame.new(- 5449.6728515625, 76.65874481201172, - 5808.20068359375)
                                                        end
                                                    else
                                                        Mon = "Horned Warrior"
                                                        LevelQuest = 2
                                                        NameQuest = "IceSideQuest"
                                                        NameMon = "Horned Warrior"
                                                        CFrameQuest = CFrame.new(- 6064.06885, 15.2422857, - 4902.97852, 0.453972578, - 0, - 0.891015649, - 0, 1, - 0, 0.891015649, - 0, 0.453972578)
                                                        CFrameMon = CFrame.new(- 6341.36669921875, 15.951770782470703, - 5723.162109375)
                                                    end
                                                else
                                                    Mon = "Lab Subordinate"
                                                    LevelQuest = 1
                                                    NameQuest = "IceSideQuest"
                                                    NameMon = "Lab Subordinate"
                                                    CFrameQuest = CFrame.new(- 6064.06885, 15.2422857, - 4902.97852, 0.453972578, - 0, - 0.891015649, - 0, 1, - 0, 0.891015649, - 0, 0.453972578)
                                                    CFrameMon = CFrame.new(- 5707.4716796875, 15.951709747314453, - 4513.39208984375)
                                                end
                                            else
                                                Mon = "Winter Warrior"
                                                LevelQuest = 2
                                                NameQuest = "SnowMountainQuest"
                                                NameMon = "Winter Warrior"
                                                CFrameQuest = CFrame.new(609.858826, 400.119904, - 5372.25928, - 0.374604106, - 0, 0.92718488, - 0, 1, - 0, - 0.92718488, - 0, - 0.374604106)
                                                CFrameMon = CFrame.new(1142.7451171875, 475.6398010253906, - 5199.41650390625)
                                            end
                                        else
                                            Mon = "Snow Trooper"
                                            LevelQuest = 1
                                            NameQuest = "SnowMountainQuest"
                                            NameMon = "Snow Trooper"
                                            CFrameQuest = CFrame.new(609.858826, 400.119904, - 5372.25928, - 0.374604106, - 0, 0.92718488, - 0, 1, - 0, - 0.92718488, - 0, - 0.374604106)
                                            CFrameMon = CFrame.new(549.1473388671875, 427.3870544433594, - 5563.69873046875)
                                        end
                                    else
                                        Mon = "Vampire"
                                        LevelQuest = 2
                                        NameQuest = "ZombieQuest"
                                        NameMon = "Vampire"
                                        CFrameQuest = CFrame.new(- 5497.06152, 47.5923004, - 795.237061, - 0.29242146, - 0, - 0.95628953, - 0, 1, - 0, 0.95628953, - 0, - 0.29242146)
                                        CFrameMon = CFrame.new(- 6037.66796875, 32.18463897705078, - 1340.6597900390625)
                                    end
                                else
                                    Mon = "Zombie"
                                    LevelQuest = 1
                                    NameQuest = "ZombieQuest"
                                    NameMon = "Zombie"
                                    CFrameQuest = CFrame.new(- 5497.06152, 47.5923004, - 795.237061, - 0.29242146, - 0, - 0.95628953, - 0, 1, - 0, 0.95628953, - 0, - 0.29242146)
                                    CFrameMon = CFrame.new(- 5657.77685546875, 78.96973419189453, - 928.68701171875)
                                end
                            else
                                Mon = "Marine Captain"
                                LevelQuest = 2
                                NameQuest = "MarineQuest3"
                                NameMon = "Marine Captain"
                                CFrameQuest = CFrame.new(- 2440.79639, 71.7140732, - 3216.06812, 0.866007268, - 0, 0.500031412, - 0, 1, - 0, - 0.500031412, - 0, 0.866007268)
                                CFrameMon = CFrame.new(- 1861.2310791015625, 80.17658233642578, - 3254.697509765625)
                            end
                        else
                            Mon = "Marine Lieutenant"
                            LevelQuest = 1
                            NameQuest = "MarineQuest3"
                            NameMon = "Marine Lieutenant"
                            CFrameQuest = CFrame.new(- 2440.79639, 71.7140732, - 3216.06812, 0.866007268, - 0, 0.500031412, - 0, 1, - 0, - 0.500031412, - 0, 0.866007268)
                            CFrameMon = CFrame.new(- 2821.372314453125, 75.8...(truncated 476098 characters)...ock Tr\195\161i C\195\162y",
    ["Content"] = "\196\144ang t\225\186\163i d\225\187\175 li\225\187\135u..."
})
task.spawn(function()
	-- upvalues: (ref) vu1417, (ref) vu1416
    while task.wait(60) do
        pcall(function()
			-- upvalues: (ref) vu1417, (ref) vu1416
            vu1417:Set(vu1416())
        end)
    end
end)
pcall(function()
	-- upvalues: (ref) vu1417, (ref) vu1416
    vu1417:Set(vu1416())
end)

-- Farm Tab
FarmTab:AddSection("Teleport Island | Di Chuy\225\187\131n \196\144\225\186\191n \196\144\225\186\163o")
local function vu1420(pu1418)
    pcall(function()
		-- upvalues: (ref) pu1418
        if type(topos) ~= "function" then
            local v1419 = game:GetService("Players").LocalPlayer
            if v1419 and v1419.Character and v1419.Character:FindFirstChild("HumanoidRootPart") then
                v1419.Character.HumanoidRootPart.CFrame = pu1418
            end
        else
            topos(pu1418)
        end
    end)
end
local v1421 = World1 and {
    "WindMill",
    "Marine",
    "Middle Town",
    "Jungle",
    "Pirate Village",
    "Desert",
    "Snow Island",
    "MarineFord",
    "Colosseum",
    "Sky Island 1",
    "Sky Island 2",
    "Sky Island 3",
    "Prison",
    "Magma Village",
    "Under Water Island",
    "Fountain City",
    "Shank Room",
    "Mob Island"
} or (World2 and {
    "The Cafe",
    "Frist Spot",
    "Dark Area",
    "Flamingo Mansion",
    "Flamingo Room",
    "Green Zone",
    "Factory",
    "Colossuim",
    "Zombie Island",
    "Two Snow Mountain",
    "Punk Hazard",
    "Cursed Ship",
    "Ice Castle",
    "Forgotten Island",
    "Ussop Island",
    "Mini Sky Island"
} or (World3 and {
    "Mansion",
    "Port Town",
    "Great Tree",
    "Castle On The Sea",
    "MiniSky",
    "Hydra Island",
    "Floating Turtle",
    "Haunted Castle",
    "Ice Cream Island",
    "Peanut Island",
    "Cake Island",
    "Cocoa Island",
    "Candy Island",
    "Tiki Outpost",
    "Dragon Dojo"
} or {
    "Spawn"
}))
FarmTab:AddDropdown({
  Name = "Select Island",
  Description = "Ch\225\187\141n \196\145\225\186\163o \196\145\225\187\131 teleport",
  Options = v1421,
  Default = v1421[1],
  Callback = function(p1422)
      _G.SelectIsland = p1422
  end
})
FarmTab:AddToggle({
  Name = "Auto Tween To Island",
  Description = "T\225\187\177 \196\145\225\187\153ng di chuy\225\187\131n t\225\187\155i \196\145\225\186\163o \196\145\195\163 ch\225\187\141n",
  Default = false,
  Callback = function(p1423)
      _G.TeleportIsland = p1423
      StopTween(_G.TeleportIsland)
  end
})
local function vu1424()
	-- upvalues: (ref) vu1420
    if _G.SelectIsland then
        if _G.SelectIsland == "WindMill" then
            vu1420(CFrame.new(979.799, 16.516, 1429.047))
        elseif _G.SelectIsland == "Marine" then
            vu1420(CFrame.new(- 2566.43, 6.856, 2045.256))
        elseif _G.SelectIsland == "Middle Town" then
            vu1420(CFrame.new(- 690.331, 15.094, 1582.238))
        elseif _G.SelectIsland == "Jungle" then
            vu1420(CFrame.new(- 1612.796, 36.852, 149.128))
        elseif _G.SelectIsland ~= "Pirate Village" then
            if _G.SelectIsland == "Desert" then
                vu1420(CFrame.new(944.158, 20.92, 4373.3))
            elseif _G.SelectIsland ~= "Snow Island" then
                if _G.SelectIsland ~= "MarineFord" then
                    if _G.SelectIsland == "Colosseum" then
                        vu1420(CFrame.new(- 1427.62, 7.288, - 2792.772))
                    elseif _G.SelectIsland == "Sky Island 1" then
                        vu1420(CFrame.new(- 4869.103, 733.461, - 2667.018))
                    elseif _G.SelectIsland == "Sky Island 2" then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 4607.823, 872.543, - 1667.557))
                    elseif _G.SelectIsland == "Sky Island 3" then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 7894.618, 5547.142, - 380.291))
                    elseif _G.SelectIsland == "Prison" then
                        vu1420(CFrame.new(4875.33, 5.652, 734.85))
                    elseif _G.SelectIsland ~= "Magma Village" then
                        if _G.SelectIsland == "Under Water Island" then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(61163.852, 11.68, 1819.784))
                        elseif _G.SelectIsland ~= "Fountain City" then
                            if _G.SelectIsland == "Shank Room" then
                                vu1420(CFrame.new(- 1442.166, 29.879, - 28.355))
                            elseif _G.SelectIsland == "Mob Island" then
                                vu1420(CFrame.new(- 2850.201, 7.392, 5354.993))
                            elseif _G.SelectIsland ~= "The Cafe" then
                                if _G.SelectIsland == "Frist Spot" then
                                    vu1420(CFrame.new(- 11.311, 29.277, 2771.522))
                                elseif _G.SelectIsland ~= "Dark Area" then
                                    if _G.SelectIsland == "Flamingo Mansion" then
                                        vu1420(CFrame.new(- 483.734, 332.038, 595.327))
                                    elseif _G.SelectIsland == "Flamingo Room" then
                                        vu1420(CFrame.new(2284.414, 15.152, 875.725))
                                    elseif _G.SelectIsland == "Green Zone" then
                                        vu1420(CFrame.new(- 2448.53, 73.016, - 3210.631))
                                    elseif _G.SelectIsland ~= "Factory" then
                                        if _G.SelectIsland ~= "Colossuim" then
                                            if _G.SelectIsland == "Zombie Island" then
                                                vu1420(CFrame.new(- 5622.033, 492.196, - 781.786))
                                            elseif _G.SelectIsland ~= "Two Snow Mountain" then
                                                if _G.SelectIsland ~= "Punk Hazard" then
                                                    if _G.SelectIsland == "Cursed Ship" then
                                                        vu1420(CFrame.new(923.402, 125.057, 32885.875))
                                                    elseif _G.SelectIsland == "Ice Castle" then
                                                        vu1420(CFrame.new(6148.412, 294.387, - 6741.117))
                                                    elseif _G.SelectIsland == "Forgotten Island" then
                                                        vu1420(CFrame.new(- 3032.764, 317.897, - 10075.373))
                                                    elseif _G.SelectIsland ~= "Ussop Island" then
                                                        if _G.SelectIsland == "Mini Sky Island" or _G.SelectIsland == "MiniSky" then
                                                            vu1420(CFrame.new(- 288.741, 49326.316, - 35248.594))
                                                        elseif _G.SelectIsland == "Great Tree" then
                                                            vu1420(CFrame.new(2681.274, 1682.809, - 7190.985))
                                                        elseif _G.SelectIsland == "Castle On The Sea" then
                                                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 5083.26, 314.606, - 3175.673))
                                                        elseif _G.SelectIsland == "Port Town" then
                                                            vu1420(CFrame.new(- 226.751, 20.603, 5538.34))
                                                        elseif _G.SelectIsland == "Hydra Island" then
                                                            vu1420(CFrame.new(5291.249, 1005.443, 393.762))
                                                        elseif _G.SelectIsland ~= "Floating Turtle" then
                                                            if _G.SelectIsland == "Mansion" then
                                                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("requestEntrance", Vector3.new(- 12471.17, 374.94, - 7551.678))
                                                            elseif _G.SelectIsland == "Haunted Castle" then
                                                                vu1420(CFrame.new(- 9515.372, 164.006, 5786.061))
                                                            elseif _G.SelectIsland ~= "Ice Cream Island" then
                                                                if _G.SelectIsland ~= "Peanut Island" then
                                                                    if _G.SelectIsland == "Cake Island" then
                                                                        vu1420(CFrame.new(- 1884.775, 19.328, - 11666.897))
                                                                    elseif _G.SelectIsland == "Cocoa Island" then
                                                                        vu1420(CFrame.new(87.943, 73.555, - 12319.465))
                                                                    elseif _G.SelectIsland ~= "Candy Island" then
                                                                        if _G.SelectIsland == "Tiki Outpost" then
                                                                            vu1420(CFrame.new(- 16218.683, 9.086, 445.618))
                                                                        elseif _G.SelectIsland == "Dragon Dojo" then
                                                                            vu1420(CFrame.new(5743.319, 1206.91, 936.011))
                                                                        end
                                                                    else
                                                                        vu1420(CFrame.new(- 1014.424, 149.111, - 14555.963))
                                                                    end
                                                                else
                                                                    vu1420(CFrame.new(- 2062.748, 50.474, - 10232.568))
                                                                end
                                                            else
                                                                vu1420(CFrame.new(- 902.568, 79.932, - 10988.848))
                                                            end
                                                        else
                                                            vu1420(CFrame.new(- 13274.528, 531.821, - 7579.223))
                                                        end
                                                    else
                                                        vu1420(CFrame.new(4816.862, 8.46, 2863.82))
                                                    end
                                                else
                                                    vu1420(CFrame.new(- 6127.654, 15.952, - 5040.286))
                                                end
                                            else
                                                vu1420(CFrame.new(753.143, 408.236, - 5274.615))
                                            end
                                        else
                                            vu1420(CFrame.new(- 1503.622, 219.796, 1369.31))
                                        end
                                    else
                                        vu1420(CFrame.new(424.127, 211.162, - 427.54))
                                    end
                                else
                                    vu1420(CFrame.new(3780.03, 22.652, - 3498.586))
                                end
                            else
                                vu1420(CFrame.new(- 380.479, 77.22, 255.826))
                            end
                        else
                            vu1420(CFrame.new(5127.128, 59.501, 4105.446))
                        end
                    else
                        vu1420(CFrame.new(- 5247.716, 12.884, 8504.969))
                    end
                else
                    vu1420(CFrame.new(- 4914.821, 50.964, 4281.028))
                end
            else
                vu1420(CFrame.new(1347.807, 104.668, - 1319.737))
            end
        else
            vu1420(CFrame.new(- 1181.309, 4.751, 3803.546))
        end
    end
end
task.spawn(function()
	-- upvalues: (ref) vu1424
    while task.wait(0.5) do
        if _G.TeleportIsland then
            vu1424()
        end
    end
end)
FarmTab:AddSection("Teleport Sea | Di Chuy\225\187\131n Sea 1,2,3")
FarmTab:AddButton({
  Name = "Sea 1",
  Description = "Bi\225\187\131n 1",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
  end
})
FarmTab:AddButton({
  Name = "Sea 2",
  Description = "Bi\225\187\131n 2",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
  end
})
FarmTab:AddButton({
  Name = "Sea 3",
  Description = "Bi\225\187\131n 3",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
  end
})

-- Player Tab
PlayerTab:AddSection("Teleport Player | Di Chuy\225\187\131n \196\144\225\186\191n Player")
local v1425, v1426, v1427 = pairs(game.Players:GetPlayers())
local v1428 = {}
while true do
    local v1429
    v1427, v1429 = v1425(v1426, v1427)
    if v1427 == nil then
        break
    end
    table.insert(v1428, v1429.Name)
end
PlayerTab:AddButton({
  Name = "Get Quest Elite Players",
  Description = "Nh\225\186\173n Nhi\225\187\135m V\225\187\165 Ng\198\176\225\187\157i Ch\198\161i",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
  end
})
PlayerTab:AddToggle({
  Name = "Auto Kill Player Quest",
  Description = "Bay \196\144\225\186\191n Ng\198\176\225\187\157i Ch\198\161i \196\144\198\176\225\187\163c Nh\225\186\173n Nhi\225\187\135m V\225\187\165",
  Default = false,
  Callback = function(p1430)
      _G.AutoPlayerHunter = p1430
      StopTween(_G.AutoPlayerHunter)
  end
})
spawn(function()
    game:GetService("RunService").Heartbeat:connect(function()
        pcall(function()
            if _G.AutoPlayerHunter and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") then
                game:GetService("Players").LocalPlayer.Character.Humanoid:ChangeState(11)
            end
        end)
    end)
end)
spawn(function()
    pcall(function()
        while wait(0.1) do
            if _G.AutoPlayerHunter and game:GetService("Players").LocalPlayer.PlayerGui.Main.PvpDisabled.Visible == true then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
            end
        end
    end)
end)
spawn(function()
    while wait() do
        if _G.AutoPlayerHunter then
            if game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible ~= false then
                local v1431, v1432, v1433 = pairs(game:GetService("Workspace").Characters:GetChildren())
                while true do
                    local v1434
                    v1433, v1434 = v1431(v1432, v1433)
                    if v1433 == nil then
                        break
                    end
                    if string.find(game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, v1434.Name) then
                        repeat
                            wait()
                            AutoHaki()
                            EquipWeapon(_G.SelectWeapon)
                            Useskill = true
                            topos(v1434.HumanoidRootPart.CFrame * CFrame.new(1, 7, 3))
                            v1434.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            game:GetService("VirtualUser"):CaptureController()
                            game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                        until _G.AutoPlayerHunter == false or v1434.Humanoid.Health <= 0
                        Useskill = false
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                    end
                end
            else
                wait(0.5)
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
            end
        end
    end
end)
PlayerTab:AddToggle({
  Name = "Auto Safe Mode",
  Description = "T\225\187\177 \196\144\225\187\153ng An To\195\160n Di Chuy\225\187\131n L\195\170n Tr\225\187\157i An To\195\160n",
  Default = false,
  Callback = function(p1435)
      _G.SafeMode = p1435
      StopTween(_G.SafeMode)
  end
})
spawn(function()
    pcall(function()
        while wait() do
            if _G.SafeMode then
                game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.new(0, 200, 0)
            end
        end
    end)
end)
PlayerTab:AddSection("Buff")
local vu1436 = game:GetService("Players").LocalPlayer
getgenv().WalkSpeedValue = 30
getgenv().JumpValue = 50
local function vu1439(p1437)
    local vu1438 = p1437:WaitForChild("Humanoid", 5)
    if vu1438 then
        vu1438.WalkSpeed = getgenv().WalkSpeedValue
        vu1438.JumpPower = getgenv().JumpValue
        vu1438:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			-- upvalues: (ref) vu1438
            vu1438.WalkSpeed = getgenv().WalkSpeedValue
        end)
    end
end
vu1436.CharacterAdded:Connect(function(p1440)
	-- upvalues: (ref) vu1439
    vu1439(p1440)
end)
if vu1436.Character then
    vu1439(vu1436.Character)
end
PlayerTab:AddSlider({
  Name = "Speed Ch\225\186\161y by tuananhiosdz",
  Min = 26,
  Max = 300,
  Default = getgenv().WalkSpeedValue,
  Callback = function(p1441)
		-- upvalues: (ref) vu1436
        getgenv().WalkSpeedValue = p1441
        local v1442 = vu1436.Character
        if v1442 then
            v1442 = vu1436.Character:FindFirstChild("Humanoid")
        end
        if v1442 then
            v1442.WalkSpeed = p1441
        end
  end
})
PlayerTab:AddSlider({
  Name = "Nh\225\186\163y Cao by tuananhiosdz",
  Min = 50,
  Max = 500,
  Default = getgenv().JumpValue,
  Callback = function(p1443)
		-- upvalues: (ref) vu1436
        getgenv().JumpValue = p1443
        local v1444 = vu1436.Character
        if v1444 then
            v1444 = vu1436.Character:FindFirstChild("Humanoid")
        end
        if v1444 then
            v1444.JumpPower = p1443
        end
  end
})
PlayerTab:AddToggle({
  Name = "Delete Lava",
  Description = "Xo\195\161 Lava Tr\195\161nh B\225\187\139 M\225\186\165y Th\225\186\177ng Kid L\225\187\143 D\195\172m Lava :))",
  Default = false,
  Callback = function(p1445)
      _G.RemoveLava = p1445
  end
})
spawn(function()
    while task.wait(1) do
        if _G.RemoveLava then
            local v1446, v1447, v1448 = pairs(workspace:GetDescendants())
            while true do
                local v1449
                v1448, v1449 = v1446(v1447, v1448)
                if v1448 == nil then
                    break
                end
                local vu1450 = v1449
                if vu1450:IsA("BasePart") and string.lower(vu1450.Name):find("lava") then
                    pcall(function()
						-- upvalues: (ref) vu1450
                        vu1450:Destroy()
                    end)
                end
            end
        end
    end
end)
PlayerTab:AddSection("Esp | \196\144\225\187\139nh V\225\187\139...")
PlayerTab:AddToggle({
  Name = "Esp Players",
  Default = false,
  Callback = function(p1451)
      ESPPlayer = p1451
      if ESPPlayer then
          task.spawn(function()
              while ESPPlayer do
                  UpdatePlayerChams()
                  task.wait(1)
              end
          end)
      else
          UpdatePlayerChams()
      end
  end
})
PlayerTab:AddToggle({
  Name = "Esp Chest",
  Default = false,
  Callback = function(p1452)
      _G.ChestESP = p1452
      if _G.ChestESP then
          task.spawn(function()
              while _G.ChestESP do
                  UpdateChestESP()
                  task.wait(1)
              end
          end)
      else
          UpdateChestESP()
      end
  end
})
PlayerTab:AddToggle({
  Name = "Esp Fruits",
  Default = false,
  Callback = function(p1453)
      DevilFruitESP = p1453
      if DevilFruitESP then
          task.spawn(function()
              while DevilFruitESP do
                  UpdateDevilChams()
                  task.wait(1)
              end
          end)
      else
          UpdateDevilChams()
      end
  end
})
PlayerTab:AddToggle({
  Name = "Esp Berry",
  Default = false,
  Callback = function(p1454)
      Berry = p1454
      if Berry then
          UpdateBerriesESP()
      else
          local v1455, v1456, v1457 = pairs(game:GetService("CollectionService"):GetTagged("BerryBush"))
          while true do
              local v1458
              v1457, v1458 = v1455(v1456, v1457)
              if v1457 == nil then
                  break
              end
              if v1458.Parent:FindFirstChild("BerryESP") then
                  v1458.Parent.BerryESP:Destroy()
              end
          end
      end
  end
})

-- Shop Tab
ShopTab:AddSection("Buy Melee V1")
ShopTab:AddButton({
  Name = "Buy Black Leg $150,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyBlackLeg")
  end
})
ShopTab:AddButton({
  Name = "Buy Electro $550,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectro")
  end
})
ShopTab:AddButton({
  Name = "Buy Water Kung Fu $750,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyFishmanKarate")
  end
})
ShopTab:AddButton({
  Name = "Buy Dragon Claw 1,500F",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "1")
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "DragonClaw", "2")
  end
})
ShopTab:AddSection("Buy Melee V2")
ShopTab:AddButton({
  Name = "Buy Superhuman $3,000,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
  end
})
ShopTab:AddButton({
  Name = "Buy Death Step $5,000,000 5,000F",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
  end
})
ShopTab:AddButton({
  Name = "Buy Sharkman Karate $2,500,000 5,000F",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate", true)
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
  end
})
ShopTab:AddButton({
  Name = "Buy Electric Claw $3,000,000 5,000F",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyElectricClaw")
  end
})
ShopTab:AddButton({
  Name = "Buy Dragon Talon $3,000,000 5,000F",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDragonTalon")
  end
})
ShopTab:AddButton({
  Name = "Buy God Human $5,000,000 5,000F",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
  end
})
ShopTab:AddButton({
  Name = "Buy Sanguine Art $5,000,000 5,000F",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySanguineArt", true)
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySanguineArt")
  end
})
ShopTab:AddSection("Buy Sea Event Crafting")
ShopTab:AddButton({
  Name = "Craft Dragonheart",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Dragonheart")
  end
})
ShopTab:AddButton({
  Name = "Craft Dragonstorm",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "Dragonstorm")
  end
})
ShopTab:AddButton({
  Name = "Craft DinoHood",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "DinoHood")
  end
})
ShopTab:AddButton({
  Name = "Craft SharkTooth",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "SharkTooth")
  end
})
ShopTab:AddButton({
  Name = "Craft TerrorJaw",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "TerrorJaw")
  end
})
ShopTab:AddButton({
  Name = "Craft SharkAnchor",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "SharkAnchor")
  end
})
ShopTab:AddButton({
  Name = "Craft LeviathanCrown",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanCrown")
  end
})
ShopTab:AddButton({
  Name = "Craft LeviathanShield",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanShield")
  end
})
ShopTab:AddButton({
  Name = "Craft LeviathanBoat",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LeviathanBoat")
  end
})
ShopTab:AddButton({
  Name = "Craft LegendaryScroll",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "LegendaryScroll")
  end
})
ShopTab:AddButton({
  Name = "Craft MythicalScroll",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("CraftItem", "Craft", "MythicalScroll")
  end
})
ShopTab:AddSection("Buy Haki,Soru...")
ShopTab:AddButton({
  Name = "Buy Geppo $10,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Geppo")
  end
})
ShopTab:AddButton({
  Name = "Buy Buso Haki $25,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Buso")
  end
})
ShopTab:AddButton({
  Name = "Buy Soru $25,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyHaki", "Soru")
  end
})
ShopTab:AddButton({
  Name = "Buy Observation Haki $750,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("KenTalk", "Buy")
  end
})
ShopTab:AddSection("Buy Sword,Gun")
ShopTab:AddButton({
  Name = "Buy Cutlass $1,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Cutlass")
  end
})
ShopTab:AddButton({
  Name = "Buy Katana $1,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Katana")
  end
})
ShopTab:AddButton({
  Name = "Buy Iron Mace $25,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Iron Mace")
  end
})
ShopTab:AddButton({
  Name = "Buy Dual Katana $12,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Duel Katana")
  end
})
ShopTab:AddButton({
  Name = "Buy Triple Katana $60,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Triple Katana")
  end
})
ShopTab:AddButton({
  Name = "Buy Pipe $100,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Pipe")
  end
})
ShopTab:AddButton({
  Name = "Buy Dual-Headed Blade $400,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Dual-Headed Blade")
  end
})
ShopTab:AddButton({
  Name = "Buy Bisento $1,200,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Bisento")
  end
})
ShopTab:AddButton({
  Name = "Buy Soul Cane $750,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Soul Cane")
  end
})
ShopTab:AddButton({
  Name = "Buy Pole V2 5,000F",
  Callback = function()
      game.ReplicatedStorage.Remotes.CommF_:InvokeServer("ThunderGodTalk")
  end
})
ShopTab:AddButton({
  Name = "Buy Slingshot $5,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Slingshot")
  end
})
ShopTab:AddButton({
  Name = "Buy Musket $8,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Musket")
  end
})
ShopTab:AddButton({
  Name = "Buy Flintlock $10,500",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Flintlock")
  end
})
ShopTab:AddButton({
  Name = "Refined Slingshot $30,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Refined Flintlock")
  end
})
ShopTab:AddButton({
  Name = "Buy Refined Flintlock $65,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
          "BuyItem",
          "Refined Flintlock"
      }))
  end
})
ShopTab:AddButton({
  Name = "Buy Cannon $100,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyItem", "Cannon")
  end
})
ShopTab:AddButton({
  Name = "Buy Kabucha 1,500F",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "1")
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Slingshot", "2")
  end
})
ShopTab:AddButton({
  Name = "Buy Bizarre Rifle 250 Ectoplasm",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Ectoplasm", "Buy", 1)
  end
})
ShopTab:AddButton({
  Name = "Buy Black Cape $50,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
          "BuyItem",
          "Black Cape"
      }))
  end
})
ShopTab:AddButton({
  Name = "Swordsman Hat $150,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
          "BuyItem",
          "Swordsman Hat"
      }))
  end
})
ShopTab:AddButton({
  Name = "Buy Tomoe Ring $500,000",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
          "BuyItem",
          "Tomoe Ring"
      }))
  end
})
ShopTab:AddSection("Reset Stats , Random Race")
ShopTab:AddButton({
  Name = "\196\144\225\187\149i T\225\187\153c Ghoul",
  Description = "",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
          "Ectoplasm",
          "Change",
          4
      }))
  end
})
ShopTab:AddButton({
  Name = "\196\144\225\187\149i T\225\187\153c Cyborg",
  Description = "",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
          "CyborgTrainer",
          "Buy"
      }))
  end
})
ShopTab:AddButton({
  Name = "Reset Stats 2,500F",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "1")
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Refund", "2")
  end
})
ShopTab:AddButton({
  Name = "Random Race 3,000F",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "1")
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BlackbeardReward", "Reroll", "2")
  end
})

-- Misc Tab
MiscTab:AddSection("Settings Farming")
MiscTab:AddParagraph("Unban Fast Attack - M1 Fruit", "On: \226\156\133")
loadstring(game:HttpGet("https://raw.githubusercontent.com/AnhDangNhoEm/TuanAnhIOS/refs/heads/main/koby"))()
MiscTab:AddToggle({
  Name = "Bring Mod",
  Description = "T\225\187\177 \196\144\225\187\153ng Gom Qu\195\161i",
  Default = true,
  Callback = function(p1459)
      _G.BringMonster = p1459
      StopTween(_G.BringMonster)
  end
})
spawn(function()
    while task.wait() do
        pcall(function()
            CheckQuest()
            local v1460, v1461, v1462 = pairs(game:GetService("Workspace").Enemies:GetChildren())
            while true do
                local v1463
                v1462, v1463 = v1460(v1461, v1462)
                if v1462 == nil then
                    break
                end
                if _G.BringMonster and (StartBring and v1463.Name == MonFarm or v1463.Name == Mon and (v1463:FindFirstChild("Humanoid") and (v1463:FindFirstChild("HumanoidRootPart") and v1463.Humanoid.Health > 0)) and (v1463.HumanoidRootPart.Position - game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 320) then
                    if v1463.Name ~= "Factory Staff" then
                        if (v1463.Name == MonFarm or v1463.Name == Mon) and (v1463.HumanoidRootPart.Position - PosMon.Position).Magnitude <= 320 then
                            v1463.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                            v1463.HumanoidRootPart.CFrame = PosMon
                            v1463.HumanoidRootPart.CanCollide = false
                            v1463.Head.CanCollide = false
                            if v1463.Humanoid:FindFirstChild("Animator") then
                                v1463.Humanoid.Animator:Destroy()
                            end
                            sethiddenproperty(game.Players.LocalPlayer, "SimulationRadius", math.huge)
                        end
                    elseif (v1463.HumanoidRootPart.Position - PosMon.Position).Magnitude <= 250 then
                        v1463.Head.CanCollide = false
                        v1463.HumanoidRootPart.CanCollide = false
                        v1463.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                        v1463.HumanoidRootPart.CFrame = PosMon
                        if v1463.Humanoid:FindFirstChild("Animator") then
                            v1463.Humanoid.Animator:Destroy()
                        end
                        sethiddenproperty(game:GetService("Players").LocalPlayer, "SimulationRadius", math.huge)
                    end
                end
            end
        end)
    end
end)
function InMyNetWork(p1464)
    if isnetworkowner then
        return isnetworkowner(p1464)
    else
        return (p1464.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 320
    end
end
MiscTab:AddToggle({
  Name = "Set Home Point",
  Description = "L\198\176u \196\144i\225\187\131m H\225\187\147i Sinh",
  Default = false,
  Callback = function(p1465)
      _G.CheckPoint = p1465
  end
})
spawn(function()
    while wait() do
        if _G.CheckPoint then
            game:GetService("SetSpawnPoint")
        end
    end
end)
MiscTab:AddToggle({
  Name = "Infinite Soru",
  Default = false,
  Callback = function(p1466)
      _G.AutoHaki = p1466
  end
})
spawn(function()
    while task.wait(0.1) do
        if _G.AutoHaki then
            pcall(AutoHaki)
        end
    end
end)
MiscTab:AddToggle({
  Name = "Auto Active Race V3",
  Description = "T\225\187\177 \196\144\225\187\153ng B\225\186\173t T\225\187\153c V3",
  Default = false,
  Callback = function(p1467)
      _G.AutoRaceV3 = p1467
  end
})
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoRaceV3 then
                game:GetService("ReplicatedStorage").Remotes.CommE:FireServer("ActivateAbility")
            end
        end)
    end
end)
MiscTab:AddToggle({
  Name = "Auto Active Race V4",
  Description = "T\225\187\177 \196\144\225\187\153ng B\225\186\173t T\225\187\153c V4",
  Default = false,
  Callback = function(p1468)
      _G.AutoRaceV4 = p1468
  end
})
spawn(function()
    while wait() do
        pcall(function()
            if _G.AutoRaceV4 then
                game:GetService("VirtualInputManager"):SendKeyEvent(true, "Y", false, game)
                wait()
                game:GetService("VirtualInputManager"):SendKeyEvent(false, "Y", false, game)
            end
        end)
    end
end)
MiscTab:AddToggle({
  Name = "Infinite Soru",
  Default = false,
  Callback = function(p1469)
      InfiniteSoru = p1469
  end
})
spawn(function()
    while task.wait(1) do
        if InfiniteSoru and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= "HumanoidRootPart" then
            pcall(function()
                local v1470 = next
                local v1471, v1472 = getgc()
                while true do
                    local v1473
                    v1472, v1473 = v1470(v1471, v1472)
                    if v1472 == nil then
                        break
                    end
                    if getfenv(v1473).script == game.Players.LocalPlayer.Character:WaitForChild("Soru") then
                        local v1474, v1475, v1476 = pairs(debug.getupvalues(v1473))
                        while true do
                            local v1477
                            v1476, v1477 = v1474(v1475, v1476)
                            if v1476 == nil then
                                break
                            end
                            if type(v1477) == "table" and v1477.LastUse then
                                local v1478 = v1476
                                repeat
                                    task.wait(0.1)
                                    setupvalue(v1473, v1476, {
                                        ["LastAfter"] = 0,
                                        ["LastUse"] = 0
                                    })
                                until not InfiniteSoru or game:GetService("Players").LocalPlayer.Character.Humanoid.Health <= 0
                                v1476 = v1478
                            end
                        end
                    end
                end
            end)
        end
    end
end)
PosY = 30
MiscTab:AddToggle({
  Name = "Dodge No CD",
  Default = false,
  Callback = function(p1479)
      DodgewithoutCool = p1479
  end
})
function NoCooldown()
    local v1480 = next
    local v1481, v1482 = getgc()
    while true do
        local v1483
        v1482, v1483 = v1480(v1481, v1482)
        if v1482 == nil then
            break
        end
        if typeof(v1483) == "function" and getfenv(v1483).script == game.Players.LocalPlayer.Character:WaitForChild("Dodge") then
            local v1484 = next
            local v1485, v1486 = getupvalues(v1483)
            while true do
                local v1487
                v1486, v1487 = v1484(v1485, v1486)
                if v1486 == nil then
                    break
                end
                if tostring(v1487) == "0.4" then
                    setupvalue(v1483, v1486, 0)
                end
            end
        end
    end
end
spawn(function()
    while wait() do
        if DodgewithoutCool then
            pcall(function()
                NoCooldown()
            end)
        end
    end
end)
MiscTab:AddToggle({
  Name = "Infinite Geppo",
  Default = false,
  Callback = function(p1488)
      InfiniteGeppo = p1488
  end
})
spawn(function()
    while task.wait(1) do
        if InfiniteGeppo then
            pcall(function()
                local v1489 = next
                local v1490, v1491 = getgc()
                while true do
                    local v1492
                    v1491, v1492 = v1489(v1490, v1491)
                    if v1491 == nil then
                        break
                    end
                    if getfenv(v1492).script == game.Players.LocalPlayer.Character:WaitForChild("Geppo") then
                        local v1493 = next
                        local v1494, v1495 = getupvalues(v1492)
                        while true do
                            local v1496
                            v1495, v1496 = v1493(v1494, v1495)
                            if v1495 == nil then
                                break
                            end
                            if tostring(v1496) == "0" then
                                local v1497 = v1495
                                repeat
                                    wait(0.1)
                                    setupvalue(v1492, v1495, 0)
                                until not InfiniteGeppo or game:GetService("Players").LocalPlayer.Character.Humanoid.Health <= 0
                                v1495 = v1497
                            end
                        end
                    end
                end
            end)
        end
    end
end)
MiscTab:AddToggle({
  Name = "Walk on Water",
  Default = true,
  Callback = function(p1498)
      _G.WalkWater = p1498
  end
})
spawn(function()
    while task.wait() do
        pcall(function()
            if _G.WalkWater then
                game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 112, 1000)
            else
                game:GetService("Workspace").Map["WaterBase-Plane"].Size = Vector3.new(1000, 80, 1000)
            end
        end)
    end
end)
MiscTab:AddSection("Auto Increase Skill Points")
local v1499 = game:GetService("Players")
local vu1500 = game:GetService("ReplicatedStorage")
local vu1501 = v1499.LocalPlayer
local vu1502 = false
local vu1503 = false
local vu1504 = false
local vu1505 = false
local vu1506 = false
local vu1507 = 1
MiscTab:AddToggle({
  Name = "Melee",
  Description = "T\225\187\177 \196\144\225\187\153ng N\195\162ng \196\144i\225\187\131m Melee",
  Default = false,
  Callback = function(p1508)
		-- upvalues: (ref) vu1502
      vu1502 = p1508
  end
})
MiscTab:AddToggle({
  Name = "Defense",
  Description = "T\225\187\177 \196\144\225\187\153ng N\195\162ng \196\144i\225\187\131m N\196\131ng L\198\176\225\187\163ng",
  Default = false,
  Callback = function(p1509)
		-- upvalues: (ref) vu1503
      vu1503 = p1509
  end
})
MiscTab:AddToggle({
  Name = "Sword",
  Description = "T\225\187\177 \196\144\225\187\153ng N\195\162ng \196\144i\225\187\131m Ki\225\186\191m",
  Default = false,
  Callback = function(p1510)
		-- upvalues: (ref) vu1504
      vu1504 = p1510
  end
})
MiscTab:AddToggle({
  Name = "Gun",
  Description = "T\225\187\177 \196\144\225\187\153ng N\195\162ng \196\144i\225\187\131m S\195\186ng",
  Default = false,
  Callback = function(p1511)
		-- upvalues: (ref) vu1505
      vu1505 = p1511
  end
})
MiscTab:AddToggle({
  Name = "Fruis",
  Description = "T\225\187\177 \196\144\225\187\153ng N\195\162ng \196\144i\225\187\131m Tr\195\161i",
  Default = false,
  Callback = function(p1512)
		-- upvalues: (ref) vu1506
      vu1506 = p1512
  end
})
spawn(function()
	-- upvalues: (ref) vu1501, (ref) vu1507, (ref) vu1500, (ref) vu1502, (ref) vu1503, (ref) vu1504, (ref) vu1505, (ref) vu1506
    while wait() do
        if vu1507 <= vu1501.Data.Points.Value then
            local function v1515(p1513)
				-- upvalues: (ref) vu1507, (ref) vu1500
                local v1514 = {
                    "AddPoint",
                    p1513,
                    vu1507
                }
                vu1500.Remotes.CommF_:InvokeServer(unpack(v1514))
            end
            if vu1502 then
                v1515("Melee")
            end
            if vu1503 then
                v1515("Defense")
            end
            if vu1504 then
                v1515("Sword")
            end
            if vu1505 then
                v1515("Gun")
            end
            if vu1506 then
                v1515("Demon Fruit")
            end
        end
    end
end)
MiscTab:AddSection("Sea 1,2,3")
MiscTab:AddButton({
  Name = "Join Sea 1",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
  end
})
MiscTab:AddButton({
  Name = "Join Sea 2",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
  end
})
MiscTab:AddButton({
  Name = "Join Sea 3",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
  end
})
MiscTab:AddSection("Other")
MiscTab:AddButton({
  Name = "Join Pirates Team",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Pirates")
  end
})
MiscTab:AddButton({
  Name = "Join Marines Team",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("SetTeam", "Marines")
  end
})
MiscTab:AddButton({
  Name = "Open Title Name",
  Callback = function()
      game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer(unpack({
          "getTitles"
      }))
      game.Players.localPlayer.PlayerGui.Main.Titles.Visible = true
  end
})
MiscTab:AddButton({
  Name = "FPS Boost",
  Description = "T\196\131ng Fps",
  Callback = function()
      local v1516 = game
      local v1517 = v1516.Workspace
      local _ = v1516.Lighting
      local _ = v1517.Terrain
      settings().Rendering.QualityLevel = "Level01"
      local v1518, v1519, v1520 = pairs(v1516:GetDescendants())
      local v1521 = true
      while true do
          local v1522
          v1520, v1522 = v1518(v1519, v1520)
          if v1520 == nil then
              break
          end
          if v1522:IsA("Part") or (v1522:IsA("Union") or (v1522:IsA("CornerWedgePart") or v1522:IsA("TrussPart"))) then
              v1522.Material = "Plastic"
              v1522.Reflectance = 0
          elseif v1522:IsA("Decal") or v1522:IsA("Texture") and v1521 then
              v1522.Transparency = 1
          elseif v1522:IsA("ParticleEmitter") or v1522:IsA("Trail") then
              v1522.Lifetime = NumberRange.new(0)
          elseif v1522:IsA("Explosion") then
              v1522.BlastPressure = 1
              v1522.BlastRadius = 1
          elseif v1522:IsA("Fire") or (v1522:IsA("SpotLight") or v1522:IsA("Smoke")) then
              v1522.Enabled = false
          end
      end
  end
})
MiscTab:AddSection("Auto Codes")
local vu1523 = {
    "NOMOREHACK",
    "BANEXPLOIT",
    "WildDares",
    "BossBuild",
    "GetPranked",
    "EARN_FRUITS",
    "FIGHT4FRUIT",
    "NOEXPLOITER",
    "NOOB2ADMIN",
    "CODESLIDE",
    "ADMINHACKED",
    "ADMINDARES",
    "fruitconcepts",
    "krazydares",
    "TRIPLEABUSE",
    "SEATROLLING",
    "24NOADMIN",
    "REWARDFUN",
    "Chandler",
    "NEWTROLL",
    "KITT_RESET",
    "Sub2CaptainMaui",
    "kittgaming",
    "Sub2Fer999",
    "Enyu_is_Pro",
    "Magicbus",
    "JCWK",
    "Starcodeheo",
    "Bluxxy",
    "fudd10_v2",
    "SUB2GAMERROBOT_EXP1",
    "Sub2NoobMaster123",
    "Sub2UncleKizaru",
    "Sub2Daigrock",
    "Axiore",
    "TantaiGaming",
    "StrawHatMaine",
    "Sub2OfficialNoobie",
    "Fudd10",
    "Bignews",
    "TheGreatAce",
    "SECRET_ADMIN",
    "SUB2GAMERROBOT_RESET1",
    "SUB2OFFICIALNOOBIE",
    "AXIORE",
    "BIGNEWS",
    "BLUXXY",
    "CHANDLER",
    "ENYU_IS_PRO",
    "FUDD10",
    "FUDD10_V2",
    "KITTGAMING",
    "MAGICBUS",
    "STARCODEHEO",
    "STRAWHATMAINE",
    "SUB2CAPTAINMAUI",
    "SUB2DAIGROCK",
    "SUB2FER999",
    "SUB2NOOBMASTER123",
    "SUB2UNCLEKIZARU",
    "TANTAIGAMING",
    "THEGREATACE"
}

