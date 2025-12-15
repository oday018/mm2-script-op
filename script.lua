-- نحمل المكتبة
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

-- ننشئ النافذة الرئيسية
local Window = Library:MakeWindow({
    Title = "1Q LUA HUB",
    SubTitle = "Murder Mystery 2"
})

-- تبويب واحد بس
local MainTab = Window:MakeTab({
    Title = "Main"
})

-- متغير الفارم
local coinFarmEnabled = false
local farmTask = nil

-- وظيفة الفارم البسيطة
local function startCoinFarm()
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    
    while coinFarmEnabled do
        -- البحث عن أي عملة
        for _, v in ipairs(workspace:GetDescendants()) do
            if not coinFarmEnabled then break end
            
            if v:IsA("BasePart") and v.Name == "Coin_Server" then
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    -- ينتقل للعملة
                    Player.Character.HumanoidRootPart.CFrame = v.CFrame
                    break
                end
            end
        end
        
        -- ينتظر 2 ثانية بالضبط
        task.wait(2)
        
        -- يبحث عن عملة ثانية
        for _, v in ipairs(workspace:GetDescendants()) do
            if not coinFarmEnabled then break end
            
            if v:IsA("BasePart") and v.Name == "Coin_Server" then
                if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
                    -- ينتقل للعملة الجديدة
                    Player.Character.HumanoidRootPart.CFrame = v.CFrame
                    break
                end
            end
        end
        
        -- ينتظر 2 ثانية ثانية
        task.wait(2)
    end
end

-- زر التشغيل/الإيقاف
MainTab:AddButton({
    Name = "Start/Stop Farm",
    Callback = function()
        coinFarmEnabled = not coinFarmEnabled
        
        if coinFarmEnabled then
            -- يبدأ الفارم
            farmTask = task.spawn(startCoinFarm)
            Window:Notify({
                Title = "✅ Farm ON",
                Content = "Collecting coins every 2 seconds",
                Duration = 2
            })
        else
            -- يوقف الفارم
            if farmTask then
                task.cancel(farmTask)
                farmTask = nil
            end
            Window:Notify({
                Title = "⛔ Farm OFF",
                Content = "Farming stopped",
                Duration = 2
            })
        end
    end
})
