local MM2Lib = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PathfindingService = game:GetService("PathfindingService")
local VirtualUser = game:GetService("VirtualUser")

-- ======================
-- Utils
-- ======================

function MM2Lib.IsInRound()
    return LocalPlayer.PlayerGui.MainGUI.Game.Waiting.Visible == false
end

-- ======================
-- Role Detection
-- ======================

function MM2Lib.GetMurderer()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr.Character and (plr.Character:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife")) then
            return plr
        end
    end
end

function MM2Lib.GetSheriff()
    for _,plr in pairs(Players:GetPlayers()) do
        if plr.Character and (
            plr.Character:FindFirstChild("Gun") or
            plr.Character:FindFirstChild("Revolver") or
            plr.Backpack:FindFirstChild("Gun") or
            plr.Backpack:FindFirstChild("Revolver")
        ) then
            return plr
        end
    end
end

-- ======================
-- Teleport
-- ======================

function MM2Lib.TeleportToPlayer(plr)
    if plr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame =
        plr.Character.HumanoidRootPart.CFrame * CFrame.new(0,3,0)
    end
end

-- ======================
-- Autofarm Coins
-- ======================

local autofarm = false
local controls = require(LocalPlayer.PlayerScripts.PlayerModule):GetControls()

local function findMap()
    for _,v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v:FindFirstChild("CoinContainer") then
            return v
        end
    end
end

local function getClosestCoinPath()
    if not MM2Lib.IsInRound() then return end

    local map = findMap()
    if not map then return end

    local coins = {}
    for _,coin in pairs(map.CoinContainer:GetChildren()) do
        if coin.Name ~= "CollectedCoin" then
            table.insert(coins, {coin, LocalPlayer:DistanceFromCharacter(coin.Position)})
        end
    end

    table.sort(coins, function(a,b)
        return a[2] < b[2]
    end)

    for _,data in pairs(coins) do
        local path = PathfindingService:CreatePath()
        path:ComputeAsync(LocalPlayer.Character.HumanoidRootPart.Position, data[1].Position)
        if path.Status == Enum.PathStatus.Success then
            return path
        end
    end
end

function MM2Lib.ToggleAutofarm(state)
    autofarm = state

    task.spawn(function()
        while autofarm do
            pcall(function()
                local path = getClosestCoinPath()
                if not path then return end

                controls:Disable()
                for _,wp in pairs(path:GetWaypoints()) do
                    if not autofarm or not MM2Lib.IsInRound() then break end
                    LocalPlayer.Character.Humanoid:MoveTo(wp.Position)
                    if wp.Action == Enum.PathWaypointAction.Jump then
                        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                    LocalPlayer.Character.Humanoid.MoveToFinished:Wait()
                end
                controls:Enable()
            end)
            task.wait()
        end
        controls:Enable()
    end)
end

-- ======================
-- Emotes
-- ======================

function MM2Lib.PlayEmote(name)
    game:GetService("ReplicatedStorage").PlayEmote:Fire(name)
end

-- ======================
-- Anti AFK
-- ======================

function MM2Lib.EnableAntiAFK()
    LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- ======================
-- ESP / Aimbot (External)
-- ======================

function MM2Lib.LoadESP()
    loadstring(_G["EzHubModules"]["createespmodule"])()
end

function MM2Lib.LoadAimbot(gui)
    loadstring(_G["EzHubModules"]["createaimbotmodule"])().newAimbotTab(gui)
end

return MM2Lib
