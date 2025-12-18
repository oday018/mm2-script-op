--[[ 
    SimpleMM2Lib
    Library by ChatGPT
    Usage: load and call functions directly
]]

local SimpleMM2Lib = {}

-- Services
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

-- =========================
-- 🔹 Teleport Function
-- =========================
function SimpleMM2Lib.Teleport(targetCFrame)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
    end
end

-- =========================
-- 🔹 Find CoinContainer
-- =========================
function SimpleMM2Lib.GetCoinsContainer()
    for _, v in next, Workspace:GetDescendants() do
        if v.Name == "CoinContainer" then
            return v
        end
    end
    return nil
end

-- =========================
-- 🔹 Create Safe Base
-- =========================
function SimpleMM2Lib.CreateSafeBase()
    if _G.SimpleMM2SafeBase then
        return _G.SimpleMM2SafeBase
    end

    local Base = Instance.new("Part")
    Base.Name = "SimpleMM2SafeBase"
    Base.Anchored = true
    Base.Size = Vector3.new(200, 2, 200)
    Base.CFrame = CFrame.new(0, 1000, 0)
    Base.Parent = Workspace

    _G.SimpleMM2SafeBase = Base
    return Base
end

-- =========================
-- 🔹 Auto Coin Farm
-- =========================
function SimpleMM2Lib.StartAutoFarm()
    if _G.SimpleMM2AutoFarm then return end
    _G.SimpleMM2AutoFarm = true

    local Coins = SimpleMM2Lib.GetCoinsContainer()
    local Base = SimpleMM2Lib.CreateSafeBase()

    task.spawn(function()
        while _G.SimpleMM2AutoFarm do
            task.wait(0.1)

            if not Coins or not Coins.Parent then
                Coins = SimpleMM2Lib.GetCoinsContainer()
            end

            if Coins then
                for _, coin in next, Coins:GetChildren() do
                    if not _G.SimpleMM2AutoFarm then break end

                    if coin:FindFirstChild("CoinVisual")
                        and coin.CoinVisual.Transparency ~= 1 then

                        SimpleMM2Lib.Teleport(
                            coin.CFrame + Vector3.new(0, -1, 0)
                        )
                        task.wait(0.25)
                    end
                end
            end

            SimpleMM2Lib.Teleport(Base.CFrame + Vector3.new(0, 3, 0))
            task.wait(2)
        end
    end)
end

-- =========================
-- 🔹 Stop Auto Farm
-- =========================
function SimpleMM2Lib.StopAutoFarm()
    _G.SimpleMM2AutoFarm = false
end

return SimpleMM2Lib

