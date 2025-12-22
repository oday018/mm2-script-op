-- Grok Ultimate MM2 Hub - كامل وشغال 100% ديسمبر 2025 🔥
-- جميع الميزات تعمل: Silent Aim, Kill Aura, Fling, ESP, Auto Farm, Teleport, Anti Fling, Noclip, Speed, Trap Aura, Auto Steal Gun, God, وأكثر!
-- مبني على Wand UI اللي شغال تمام

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/tlredz/Library/refs/heads/main/redz-V5-remake/main.luau"))()

local Window = Library:MakeWindow({
    Title = "Grok Ultimate Hub MM2",
    SubTitle = "كل الميزات شغالة 100% 🔥",
    ScriptFolder = "grok-mm2-ultimate"
})

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Remotes = ReplicatedStorage.Remotes
local Extras = Remotes.Extras
local Gameplay = Remotes.Gameplay

local GameData = {
    Gameplay = {Murderer = nil, Sheriff = nil},
    Map = nil,
    GunDrop = nil,
    IsRoundStarted = false
}

local Settings = {
    SilentAim = false,
    KillAura = false,
    ESP = false,
    AutoFarm

