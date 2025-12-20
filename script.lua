local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
    Title = "Aim Bot | Player Hunter",
    SubTitle = "Blox Fruits",
    ScriptFolder = "AimBot"
})

local Tab = Window:MakeTab({
    Title = "Main",
    Icon = "Sword"
})

-- المتغيرات اللازمة (يجب أن تكون موجودة في السكريبت الأساسي)
_G.AutoPlayerHunter = false
_G.SelectWeapon = "Melee"  -- غيرها حسب السلاح الذي تستخدمه

-- دوال مساعدة (يجب أن تكون موجودة أو معرفة في السكريبت الأساسي)
function StopTween(value) end
function AutoHaki() 
    if game.Players.LocalPlayer.Character:FindFirstChild("Haki") then
        game.Players.LocalPlayer.Character.Haki.Value = true
    end
end
function EquipWeapon(name)
    local tool = game.Players.LocalPlayer.Backpack:FindFirstChild(name) or game.Players.LocalPlayer.Character:FindFirstChild(name)
    if tool then
        tool.Parent = game.Players.LocalPlayer.Character
    end
end
function topos(cf)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cf
    end
end

Tab:AddToggle({
    Title = "Aim Bot (Auto Kill Player Quest)",
    Description = "يطير للاعب اللي عليه المهمة ويقتله تلقائياً",
    Default = false,
    Callback = function(value)
        _G.AutoPlayerHunter = value
        StopTween(_G.AutoPlayerHunter)
    end
})

-- السبونات اللازمة لتشغيل الـ Aim Bot
spawn(function()
    game:GetService("RunService").Heartbeat:Connect(function()
        pcall(function()
            if _G.AutoPlayerHunter and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
            end
        end)
    end)
end)

spawn(function()
    pcall(function()
        while wait(0.1) do
            if _G.AutoPlayerHunter and game.Players.LocalPlayer.PlayerGui.Main.PvpDisabled.Visible then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("EnablePvp")
            end
        end
    end)
end)

spawn(function()
    while task.wait() do
        if _G.AutoPlayerHunter then
            pcall(function()
                if game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible then
                    for _, playerChar in pairs(game.Workspace.Characters:GetChildren()) do
                        if playerChar:FindFirstChild("Humanoid") and playerChar:FindFirstChild("HumanoidRootPart") then
                            if string.find(game.Players.LocalPlayer.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text, playerChar.Name) then
                                repeat
                                    task.wait()
                                    AutoHaki()
                                    EquipWeapon(_G.SelectWeapon)
                                    topos(playerChar.HumanoidRootPart.CFrame * CFrame.new(0, 30, 5))
                                    playerChar.HumanoidRootPart.Size = Vector3.new(60, 60, 60)
                                    game:GetService("VirtualUser"):CaptureController()
                                    game:GetService("VirtualUser"):Button1Down(Vector2.new(1280, 672))
                                until not _G.AutoPlayerHunter or playerChar.Humanoid.Health <= 0 or not game.Players.LocalPlayer.PlayerGui.Main.Quest.Visible
                                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                            end
                        end
                    end
                else
                    task.wait(0.5)
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
                end
            end)
        end
    end
end)

Tab:AddButton({
    Title = "Get Quest (Player Hunter)",
    Description = "يأخذ مهمة صيد اللاعبين",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("PlayerHunter")
    end
})
