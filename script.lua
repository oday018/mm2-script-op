
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")


local LocalPlayer = Players.LocalPlayer




local Executor = getexecutorname():sub(1)

local stuff = {
    EspDisabled = false,
}

local ESP = {
    Enabled = false,
    Boxes = true,
    FaceCamera = false,
    Names = true,
    TeamColor = true,
    Thickness = 1,
    AttachShift = 1,
    TeamMates = true,
    Players = true,
    
}


function ESP:Toggle(value)

end

if Executor ~= "Celery" then
ESP = loadstring(game:HttpGet("https://pastebin.com/raw/nums7qGL"))()
else
    stuff.EspDisabled = true
end

ESP:Toggle(false)

--Aimbot V2
spawn(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BaconStorage/Scripts/main/Aimbot.lua"))()
end)


local Coins
local GunDrop

for i,v in next,game:GetService("Workspace"):GetDescendants() do
if v.Name == "CoinContainer" then
Coins = v 
end
end

for i,v in next,game:GetService("Workspace"):GetDescendants() do
    if v.Name == "GunDrop" then
        GunDrop = v 
    end
    end


game:GetService("Workspace").DescendantAdded:Connect(function(a)
	if a.Name == "CoinContainer" then
		Coins = a
	end
end)

game:GetService("Workspace").DescendantAdded:Connect(function(a)
	if a.Name == "GunDrop" then
		GunDrop = a
	end
end)


if not getgenv().AutoFarmBase then
	local FarmBase = Instance.new("Part")
	FarmBase.Anchored = true

	FarmBase.CFrame = CFrame.new(0,1000,0)
    FarmBase.Size = Vector3.new(200,2,200)
    FarmBase.Parent = game:GetService("Workspace")
	getgenv().AutoFarmBase = FarmBase
end

local Main = {
    CharacterMods = {
        WalkSpeed = 16,
        JumpPower = 50,
        Noclip = true,
        InfiniteJump = false,
    },
    AutoFarm = {
        AutoFarmEnabled = false,
    },
    Misc = {
        ClickTP = false,
        ClickDestroy = false,
    },
}

local functions = {}
local loops = {}
local gui = {}

getgenv().DefaultColor = Color3.fromRGB(0, 91, 177)

getgenv().UIlib = ""

function loops:init()

    spawn(function()
        game:GetService("RunService").Heartbeat:Connect(function()
    if LocalPlayer.Character ~= nil  and LocalPlayer.Character:FindFirstChild("Humanoid") ~= nil then
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Main.CharacterMods.WalkSpeed
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Main.CharacterMods.JumpPower

end
end)

game:GetService("RunService").Heartbeat:Connect(function()
    if LocalPlayer.Character ~= nil then
        for i,v in next,game:GetService("Players").LocalPlayer.Character:GetDescendants() do
            if Main.CharacterMods.Noclip then
            if v:IsA("BasePart") or v:IsA("Part") and v.Parent == game:GetService("Players").LocalPlayer.Character then
            v.CanCollide = false
            end
            end
            end
    end

end)

end)


spawn(function()
    while true do
        wait()
        if Main.AutoFarm.AutoFarmEnabled then
        if Coins ~= nil and Coins:GetChildren()[1]  then
        for i,v in next,Coins:GetChildren() do
            if v:FindFirstChild("CoinVisual") and v:FindFirstChild("CoinVisual").Transparency ~= 0 then
        Teleport(v.CFrame + Vector3.new(0,-1.02,0))
    end 
        end
        wait(0.395)
        if Main.AutoFarm.AutoFarmEnabled then
        Teleport(getgenv().AutoFarmBase.CFrame + Vector3.new(0,3,0))
        end
    
        end

    end
    wait(4.2)
end
    end)


end

function functions:init()

    function RejoinServer()
    TeleportService:Teleport(game.PlaceId)
    end

    function FirstPersonEnabled(value)
    if value == true then
        game.Players.LocalPlayer.CameraMode = Enum.CameraMode.LockFirstPerson
    else
        game.Players.LocalPlayer.CameraMode = Enum.CameraMode.Classic
    end
end
function Teleport(CFrame)
    if LocalPlayer.Character ~= nil and game:GetService("Players").LocalPlayer.Character:FindFirstChild("HumanoidRootPart") ~= nil then
    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame
    end
end
    local Mouse = game.Players.LocalPlayer:GetMouse()
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input)
   if input.UserInputType == Enum.UserInputType.MouseButton1 and Main.Misc.ClickTP then
		if Mouse.Target then
game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.x, Mouse.Hit.y + 5, Mouse.Hit.z)
        end
	end
    if input.UserInputType == Enum.UserInputType.MouseButton1 and Main.Misc.ClickDestroy then
		if Mouse.Target then
            Mouse.Target:Destroy()
        end
	end

end)

UserInputService.InputBegan:Connect(function(input)
	if input.KeyCode == Enum.KeyCode.Space and Main.CharacterMods.InfiniteJump then
		if Mouse.Target then
			game.Players.LocalPlayer.Character.Humanoid:ChangeState(3)
		end
	end


end)


end

















function gui:init()
    local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
    local Window = OrionLib:MakeWindow({Name = "Bacon Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "BaconHub"})
    local Tab = Window:MakeTab({
        Name = "Visual Cheats",
        Icon = "",
        PremiumOnly = false
    })

    local AimbotTab = Window:MakeTab({
        Name = "Aimbot",
        Icon = "",
        PremiumOnly = false
    })
    
    --[[local CombatTab = Window:MakeTab({
        Name = "Combat",
        Icon = "",
        PremiumOnly = false
    })]]

    local AutoFarmTab = Window:MakeTab({
        Name = "Auto Farm",
        Icon = "",
        PremiumOnly = false
    })
    local CharTab = Window:MakeTab({
        Name = "Character",
        Icon = "",
        PremiumOnly = false
    })
    local MiscTab = Window:MakeTab({
        Name = "Misc",
        Icon = "",
        PremiumOnly = false
    })
    local SettingsTab = Window:MakeTab({
        Name = "Settings",
        Icon = "",
        PremiumOnly = false
    })
    --[[CombatTab:AddButton({
        Name = "Pickup Gun",
        Callback = function()
                
          end    
    })]]
    Tab:AddToggle({
        Name = "Esp Enabled",
        Default = false,
        Callback = function(Value)
            ESP:Toggle(Value)
        end    
    })
    local Section = Tab:AddSection({
        Name = "Esp Settings"
    })
    Tab:AddToggle({
        Name = "Name Esp",
        Default = false,
        Callback = function(Value)
            ESP.Names = Value
        end    
    })
    Tab:AddToggle({
        Name = "Box Esp",
        Default = false,
        Callback = function(Value)
            ESP.Boxes = Value
        end    
    })
    Tab:AddToggle({
        Name = "Tracers",
        Default = false,
        Callback = function(Value)
            ESP.Tracers = Value
        end    
    })

    Tab:AddToggle({
        Name = "Team Color",
        Default = false,
        Callback = function(Value)
            ESP.TeamColor = Value
        end    
    })
    local Section = Tab:AddSection({
        Name = "Other"
    })

    Tab:AddToggle({
        Name = "First Person",
        Default = false,
        Callback = function(Value)
            spawn(function()
            FirstPersonEnabled(Value)
            end)
        end    
    })

    Tab:AddSlider({
        Name = "FOV",
        Min = 1,
        Max = 120,
        Default = 70,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "FOv",
        Callback = function(Value)
            game:GetService("Workspace").CurrentCamera.FieldOfView = Value
        end    
    })

    AimbotTab:AddToggle({
        Name = "Aimbot Enabled",
        Default = false,
        Callback = function(Value)
            getgenv().aimbot = Value
        end
    })
    local Section = AimbotTab:AddSection({
        Name = "Aimbot Settings"
    })

    AimbotTab:AddToggle({
        Name = "Team Check",
        Default = false,
        Callback = function(Value)
            getgenv().teamcheck = Value
        end
    })
    AimbotTab:AddToggle({
        Name = "Show FOV",
        Default = false,
        Callback = function(Value)
            getgenv().showfov = Value
        end
    })

    AimbotTab:AddSlider({
        Name = "FOV Size",
        Min = 40,
        Max = 800,
        Default = 120,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "FOV Size",
        Callback = function(Value)
            getgenv().fov = Value
        end    
    })
    AimbotTab:AddSlider({
        Name = "FOV Thickness",
        Min = 1,
        Max = 5,
        Default = 1,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "FOv Size",
        Callback = function(Value)
            getgenv().fovThickness = Value
        end    
    })


    AutoFarmTab:AddToggle({
        Name = "Auto Farm Enabled",
        Default = false,
        Callback = function(Value)
            Main.AutoFarm.AutoFarmEnabled = Value
        end    
    })

    CharTab:AddSlider({
        Name = "WalkSpeed",
        Min = 16,
        Max = 300,
        Default = 16,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "WalkSpeed",
        Callback = function(Value)
            Main.CharacterMods.WalkSpeed = Value
        end    
    })

    CharTab:AddSlider({
        Name = "JumpPower",
        Min = 50,
        Max = 500,
        Default = 16,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "JumpPower",
        Callback = function(Value)
            Main.CharacterMods.JumpPower = Value
        end    
    })
    CharTab:AddToggle({
        Name = "Noclip",
        Default = false,
        Callback = function(Value)
            Main.CharacterMods.Noclip = Value
        end    
    })

    CharTab:AddToggle({
        Name = "Infinite Jump",
        Default = false,
        Callback = function(Value)
            Main.CharacterMods.InfiniteJump = Value
        end    
    })

    MiscTab:AddToggle({
        Name = "Click TP",
        Default = false,
        Callback = function(Value)
            Main.Misc.ClickTP = Value
        end    
    })
    MiscTab:AddToggle({
        Name = "Click Destroy",
        Default = false,
        Callback = function(Value)
            Main.Misc.ClickDestroy = Value
        end    
    })

    MiscTab:AddButton({
        Name = "Rejoin Server",
        Callback = function()
            RejoinServer()
          end    
    })

    SettingsTab:AddButton({
        Name = "Copy Server JobId",
        Callback = function()
                setclipboard(game.JobId)
          end    
    })

    SettingsTab:AddButton({
        Name = "Copy Join Script",
        Callback = function()
            local Code = 'game:GetService("TeleportService"):TeleportToPlaceInstance(PlaceId,JOBID)'

            local Source = Code:gsub("PlaceId", '"' .. tostring(game.PlaceId) .. '"')
            local Sourcev2 = Source:gsub("JOBID", '"' .. tostring(game.JobId) .. '"')

            setclipboard(Sourcev2)
          end    
    })

    SettingsTab:AddButton({
        Name = "Copy Discord Invite",
        Callback = function()
            local InviteCode = game:HttpGet("https://pastebin.com/raw/f9BXUCRH")
            local InviteUrl = "discord.gg/" .. InviteCode
            setclipboard(InviteUrl)
          end    
    })
    if stuff.EspDisabled then
        OrionLib:MakeNotification({
            Name = "Bacon Hub",
            Content = "Esp is disabled on Celery",
            Time = 5
        })
    end
end


functions:init()
loops:init()
gui:init()
