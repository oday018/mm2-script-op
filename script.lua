-- نفس الواجهة UI...

------------------------------------------------
-- إعدادات متقدمة
------------------------------------------------
local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local RANGE = 200
local TELEPORT_DELAY = 0.3  -- زيادة التأخير
local Y_OFFSET = -3
local SAFE_DELAY = 0.08  -- تأخير أمان إضافي

-- متغيرات التتبع
local isTeleporting = false
local lastCoin = nil

------------------------------------------------
-- أقرب عملة مع تجنب التكرار
------------------------------------------------
local function getClosestCoin()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    local root = lp.Character.HumanoidRootPart
    local closestCoin
    local shortest = RANGE

    for _,v in ipairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("coin") and v ~= lastCoin then
            local dist = (v.Position - root.Position).Magnitude
            if dist <= shortest then
                shortest = dist
                closestCoin = v
            end
        end
    end
    return closestCoin
end

------------------------------------------------
-- انتقال آمن
------------------------------------------------
local function safeTeleportToCoin(coin)
    if not coin or not coin:IsDescendantOf(workspace) then return end
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then return end
    if isTeleporting then return end
    
    isTeleporting = true
    local root = lp.Character.HumanoidRootPart
    
    -- الانتقال إلى العملة
    root.CFrame = coin.CFrame * CFrame.new(0, Y_OFFSET, 0)
    task.wait(SAFE_DELAY)
    
    -- حركة بسيطة للتأكد من الجمع
    root.CFrame = root.CFrame * CFrame.new(0, 1, 0)
    
    -- تذكر آخر عملة
    lastCoin = coin
    task.wait(0.05)
    isTeleporting = false
end

------------------------------------------------
-- Farm Loop الرئيسي
------------------------------------------------
task.spawn(function()
    while true do
        if FarmCoins then
            local coin = getClosestCoin()
            if coin then
                safeTeleportToCoin(coin)
                task.wait(TELEPORT_DELAY)
            else
                -- إعادة تعيين إذا لم توجد عملات
                lastCoin = nil
                task.wait(1)
            end
        else
            task.wait(1)
        end
    end
end)

-- تنظيف عند الخروج
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == lp then
        FarmCoins = false
        if ui then ui:Destroy() end
    end
end)
