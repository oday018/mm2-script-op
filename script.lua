-- Murder Mystery 2風ゲーム スクリプト
-- Rayfield UIライブラリを使用

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Murder Mystery 2 Game",
    LoadingTitle = "MM2 ゲームシステム",
    LoadingSubtitle = "by Your Name",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "MM2Config"
    },
    Discord = {
        Enabled = false,
        Invite = "noinvitelink",
        RememberJoins = true
    },
    KeySystem = false
})

-- プレイヤーとサービス
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Workspace = game:GetService("Workspace")

-- ゲームの状態管理
local GameState = {
    isGameActive = false,
    roundTime = 180,
    currentRound = 0,
    autoKillEnabled = false,
    autoKillTarget = nil
}

-- プレイヤーデータ
local PlayerData = {
    coins = 0,
    role = "Innocent",
    alive = true,
    hasKnife = false,
    hasGun = false
}

-- タブの作成
local MainTab = Window:CreateTab("メイン", 4483362458)
local WeaponTab = Window:CreateTab("武器", 4483362458)
local TeleportTab = Window:CreateTab("テレポート", 4483362458)
local InventoryTab = Window:CreateTab("インベントリ", 4483362458)
local StatsTab = Window:CreateTab("統計", 4483362458)
local SettingsTab = Window:CreateTab("設定", 4483362458)

-- メインタブ
local GameSection = MainTab:CreateSection("ゲーム管理")

local RoleLabel = MainTab:CreateLabel("現在の役職: " .. PlayerData.role)
local StatusLabel = MainTab:CreateLabel("ステータス: 待機中")
local TimeLabel = MainTab:CreateLabel("残り時間: --:--")

local StartButton = MainTab:CreateButton({
    Name = "ゲーム開始",
    Callback = function()
        startGame()
    end,
})

local EndButton = MainTab:CreateButton({
    Name = "ゲーム終了",
    Callback = function()
        endGame()
    end,
})

-- 武器タブ
local WeaponSection = WeaponTab:CreateSection("武器システム")

WeaponTab:CreateButton({
    Name = "ナイフを入手",
    Callback = function()
        giveWeapon("Knife")
    end,
})

WeaponTab:CreateButton({
    Name = "銃を入手",
    Callback = function()
        giveWeapon("Gun")
    end,
})

local AutoKillToggle = WeaponTab:CreateToggle({
    Name = "AutoKill有効化",
    CurrentValue = false,
    Flag = "AutoKill",
    Callback = function(Value)
        GameState.autoKillEnabled = Value
        if Value then
            Rayfield:Notify({
                Title = "AutoKill",
                Content = "AutoKillが有効になりました",
                Duration = 3,
                Image = 4483362458,
            })
            startAutoKill()
        else
            Rayfield:Notify({
                Title = "AutoKill",
                Content = "AutoKillが無効になりました",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end,
})

local TargetDropdown = WeaponTab:CreateDropdown({
    Name = "ターゲット選択",
    Options = {"全員", "最寄りのプレイヤー", "ランダム"},
    CurrentOption = "最寄りのプレイヤー",
    Flag = "Target",
    Callback = function(Option)
        GameState.autoKillTarget = Option
        Rayfield:Notify({
            Title = "ターゲット設定",
            Content = "ターゲット: " .. Option,
            Duration = 2,
            Image = 4483362458,
        })
    end,
})

WeaponTab:CreateButton({
    Name = "即座にキル",
    Callback = function()
        instantKill()
    end,
})

-- テレポートタブ
local TeleportSection = TeleportTab:CreateSection("マップテレポート")

TeleportTab:CreateButton({
    Name = "ロビーへテレポート",
    Callback = function()
        teleportToLobby()
    end,
})

TeleportTab:CreateButton({
    Name = "マップ1へテレポート",
    Callback = function()
        teleportToMap("Map1")
    end,
})

TeleportTab:CreateButton({
    Name = "マップ2へテレポート",
    Callback = function()
        teleportToMap("Map2")
    end,
})

TeleportTab:CreateButton({
    Name = "マップ3へテレポート",
    Callback = function()
        teleportToMap("Map3")
    end,
})

local PlayerTeleportSection = TeleportTab:CreateSection("プレイヤーテレポート")

local TeleportToPlayerInput = TeleportTab:CreateInput({
    Name = "プレイヤー名",
    PlaceholderText = "プレイヤー名を入力",
    RemoveTextAfterFocusLost = false,
    Callback = function(Text)
        teleportToPlayer(Text)
    end,
})

-- インベントリタブ
local InventorySection = InventoryTab:CreateSection("アイテム管理")

InventoryTab:CreateButton({
    Name = "全アイテム入手",
    Callback = function()
        giveAllItems()
    end,
})

InventoryTab:CreateButton({
    Name = "全武器入手",
    Callback = function()
        giveAllWeapons()
    end,
})

InventoryTab:CreateButton({
    Name = "コイン10000追加",
    Callback = function()
        PlayerData.coins = PlayerData.coins + 10000
        updateStats()
        Rayfield:Notify({
            Title = "コイン追加",
            Content = "+10000コイン獲得！",
            Duration = 3,
            Image = 4483362458,
        })
    end,
})

local ItemList = InventoryTab:CreateSection("個別アイテム")

local commonItems = {
    "Knife_Default",
    "Knife_Classic",
    "Gun_Revolver",
    "Gun_Sheriff",
    "Emote_Wave",
    "Emote_Dance",
    "Pet_Dog",
    "Pet_Cat"
}

for _, item in ipairs(commonItems) do
    InventoryTab:CreateButton({
        Name = item .. " を入手",
        Callback = function()
            giveSpecificItem(item)
        end,
    })
end

-- 統計タブ
local StatsSection = StatsTab:CreateSection("プレイヤー統計")

local CoinsLabel = StatsTab:CreateLabel("コイン: " .. PlayerData.coins)
local RoundsLabel = StatsTab:CreateLabel("ラウンド数: " .. GameState.currentRound)
local WeaponLabel = StatsTab:CreateLabel("所持武器: なし")

-- 設定タブ
local SettingsSection = SettingsTab:CreateSection("ゲーム設定")

local RoundTimeSlider = SettingsTab:CreateSlider({
    Name = "ラウンド時間 (秒)",
    Range = {60, 600},
    Increment = 30,
    CurrentValue = 180,
    Flag = "RoundTime",
    Callback = function(Value)
        GameState.roundTime = Value
    end,
})

SettingsTab:CreateToggle({
    Name = "無敵モード",
    CurrentValue = false,
    Flag = "GodMode",
    Callback = function(Value)
        setGodMode(Value)
    end,
})

SettingsTab:CreateSlider({
    Name = "移動速度",
    Range = {16, 100},
    Increment = 1,
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value)
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end
    end,
})

-- ゲーム関数
function startGame()
    if GameState.isGameActive then
        Rayfield:Notify({
            Title = "エラー",
            Content = "ゲームは既に進行中です",
            Duration = 3,
            Image = 4483362458,
        })
        return
    end
    
    GameState.isGameActive = true
    GameState.currentRound = GameState.currentRound + 1
    PlayerData.alive = true
    
    assignRoles()
    StatusLabel:Set("ステータス: ゲーム中")
    RoundsLabel:Set("ラウンド数: " .. GameState.currentRound)
    
    Rayfield:Notify({
        Title = "ゲーム開始",
        Content = "ラウンド " .. GameState.currentRound .. " が開始されました！",
        Duration = 3,
        Image = 4483362458,
    })
    
    startTimer()
end

function endGame()
    if not GameState.isGameActive then
        Rayfield:Notify({
            Title = "エラー",
            Content = "進行中のゲームがありません",
            Duration = 3,
            Image = 4483362458,
        })
        return
    end
    
    GameState.isGameActive = false
    StatusLabel:Set("ステータス: 終了")
    
    local reward = 50
    if PlayerData.role == "Murderer" and PlayerData.alive then
        reward = 200
    elseif PlayerData.role == "Sheriff" and PlayerData.alive then
        reward = 150
    end
    
    PlayerData.coins = PlayerData.coins + reward
    updateStats()
    
    Rayfield:Notify({
        Title = "ゲーム終了",
        Content = "+" .. reward .. " コイン獲得！",
        Duration = 5,
        Image = 4483362458,
    })
    
    TimeLabel:Set("残り時間: --:--")
end

function assignRoles()
    local roles = {"Innocent", "Sheriff", "Murderer"}
    local randomRole = roles[math.random(1, #roles)]
    
    PlayerData.role = randomRole
    RoleLabel:Set("現在の役職: " .. randomRole)
    
    Rayfield:Notify({
        Title = "役職決定",
        Content = "あなたは " .. randomRole .. " です！",
        Duration = 5,
        Image = 4483362458,
    })
end

function startTimer()
    spawn(function()
        local timeLeft = GameState.roundTime
        
        while timeLeft > 0 and GameState.isGameActive do
            local minutes = math.floor(timeLeft / 60)
            local seconds = timeLeft % 60
            TimeLabel:Set(string.format("残り時間: %02d:%02d", minutes, seconds))
            
            wait(1)
            timeLeft = timeLeft - 1
        end
        
        if GameState.isGameActive then
            endGame()
        end
    end)
end

function updateStats()
    CoinsLabel:Set("コイン: " .. PlayerData.coins)
    RoundsLabel:Set("ラウンド数: " .. GameState.currentRound)
    
    local weapons = {}
    if PlayerData.hasKnife then table.insert(weapons, "ナイフ") end
    if PlayerData.hasGun then table.insert(weapons, "銃") end
    
    if #weapons > 0 then
        WeaponLabel:Set("所持武器: " .. table.concat(weapons, ", "))
    else
        WeaponLabel:Set("所持武器: なし")
    end
end

-- 武器システム
function giveWeapon(weaponType)
    if weaponType == "Knife" then
        PlayerData.hasKnife = true
        Rayfield:Notify({
            Title = "武器入手",
            Content = "ナイフを入手しました！",
            Duration = 3,
            Image = 4483362458,
        })
    elseif weaponType == "Gun" then
        PlayerData.hasGun = true
        Rayfield:Notify({
            Title = "武器入手",
            Content = "銃を入手しました！",
            Duration = 3,
            Image = 4483362458,
        })
    end
    
    updateStats()
end

function startAutoKill()
    spawn(function()
        while GameState.autoKillEnabled do
            if PlayerData.hasKnife or PlayerData.hasGun then
                local target = findTarget()
                if target then
                    killPlayer(target)
                end
            end
            wait(0.5)
        end
    end)
end

function findTarget()
    local target = nil
    local closest = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            if GameState.autoKillTarget == "最寄りのプレイヤー" then
                local distance = (player.Character.HumanoidRootPart.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                if distance < closest then
                    closest = distance
                    target = player
                end
            elseif GameState.autoKillTarget == "ランダム" then
                target = player
                break
            elseif GameState.autoKillTarget == "全員" then
                return player
            end
        end
    end
    
    return target
end

function killPlayer(target)
    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
        -- キルロジックをここに実装
        Rayfield:Notify({
            Title = "キル",
            Content = target.Name .. " をキルしました",
            Duration = 2,
            Image = 4483362458,
        })
    end
end

function instantKill()
    local target = findTarget()
    if target then
        killPlayer(target)
    else
        Rayfield:Notify({
            Title = "エラー",
            Content = "ターゲットが見つかりません",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

-- テレポートシステム
function teleportToLobby()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        -- ロビーの座標（環境に合わせて変更してください）
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
        
        Rayfield:Notify({
            Title = "テレポート",
            Content = "ロビーへテレポートしました",
            Duration = 2,
            Image = 4483362458,
        })
    end
end

function teleportToMap(mapName)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local mapPositions = {
            Map1 = CFrame.new(100, 50, 100),
            Map2 = CFrame.new(200, 50, 200),
            Map3 = CFrame.new(300, 50, 300)
        }
        
        if mapPositions[mapName] then
            LocalPlayer.Character.HumanoidRootPart.CFrame = mapPositions[mapName]
            
            Rayfield:Notify({
                Title = "テレポート",
                Content = mapName .. " へテレポートしました",
                Duration = 2,
                Image = 4483362458,
            })
        end
    end
end

function teleportToPlayer(playerName)
    local targetPlayer = Players:FindFirstChild(playerName)
    
    if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
            
            Rayfield:Notify({
                Title = "テレポート",
                Content = playerName .. " へテレポートしました",
                Duration = 2,
                Image = 4483362458,
            })
        end
    else
        Rayfield:Notify({
            Title = "エラー",
            Content = "プレイヤーが見つかりません",
            Duration = 3,
            Image = 4483362458,
        })
    end
end

-- インベントリシステム
function giveAllItems()
    PlayerData.hasKnife = true
    PlayerData.hasGun = true
    PlayerData.coins = PlayerData.coins + 50000
    
    updateStats()
    
    Rayfield:Notify({
        Title = "全アイテム入手",
        Content = "全アイテムを入手しました！",
        Duration = 3,
        Image = 4483362458,
    })
end

function giveAllWeapons()
    PlayerData.hasKnife = true
    PlayerData.hasGun = true
    
    updateStats()
    
    Rayfield:Notify({
        Title = "全武器入手",
        Content = "全武器を入手しました！",
        Duration = 3,
        Image = 4483362458,
    })
end

function giveSpecificItem(itemName)
    Rayfield:Notify({
        Title = "アイテム入手",
        Content = itemName .. " を入手しました！",
        Duration = 2,
        Image = 4483362458,
    })
end

-- 設定関数
function setGodMode(enabled)
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        if enabled then
            LocalPlayer.Character.Humanoid.MaxHealth = math.huge
            LocalPlayer.Character.Humanoid.Health = math.huge
            
            Rayfield:Notify({
                Title = "無敵モード",
                Content = "無敵モードが有効になりました",
                Duration = 3,
                Image = 4483362458,
            })
        else
            LocalPlayer.Character.Humanoid.MaxHealth = 100
            LocalPlayer.Character.Humanoid.Health = 100
            
            Rayfield:Notify({
                Title = "無敵モード",
                Content = "無敵モードが無効になりました",
                Duration = 3,
                Image = 4483362458,
            })
        end
    end
end

-- 初期化
Rayfield:Notify({
    Title = "MM2 ゲームシステム",
    Content = "すべての機能が読み込まれました！",
    Duration = 5,
    Image = 4483362458,
})

updateStats()

print("MM2 Game System with all features loaded!")
