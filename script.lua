local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- متغيرات الحماية
local AntiFlingEnabled = false
local Connections = {}
local LastSafePos = Vector3.zero

-- دالة لتفعيل Anti-Fling
local function EnableAntiFling()
    if AntiFlingEnabled then return end
    AntiFlingEnabled = true

    local connection = RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end

        -- تخزين الموقع الآمن كل مرة تكون الحركة طبيعية
        if root.AssemblyLinearVelocity.Magnitude < 50 then
            LastSafePos = root.Position
        end

        -- كشف الـ Fling: سرعة أو دوران عالي جدًا
        if root.AssemblyLinearVelocity.Magnitude > 300 or root.AssemblyAngularVelocity.Magnitude > 300 then
            -- إيقاف القذف فورًا
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
            root.CFrame = CFrame.new(LastSafePos) -- الرجوع لمكان آمن

            -- إيقاف التصادم مع اللاعبين (للسلامة)
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in ipairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end)

    table.insert(Connections, connection)
end

-- دالة لتعطيل Anti-Fling
local function DisableAntiFling()
    if not AntiFlingEnabled then return end
    AntiFlingEnabled = false

    for _, connection in pairs(Connections) do
        connection:Disconnect()
    end
    Connections = {}
end

-- دالة التبديل
local function ToggleAntiFling(state)
    if state then
        EnableAntiFling()
    else
        DisableAntiFling()
    end
end

--// ================== UI ==================

local Library = loadstring(game:HttpGet(
    "https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"
))()

local Window = Library:MakeWindow({
    Title = "Example Hub",
    SubTitle = "Anti Fling Fix",
    ScriptFolder = "example-hub"
})

local MainTab = Window:MakeTab({
    Title = "an",
    Icon = "Shield"
})

MainTab:AddToggle({
    Name = "Anti Fling",
    Default = false,
    Callback = function(Value)
        ToggleAntiFling(Value)
    end
})
