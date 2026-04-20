-- [[ Seliaqua Hub - Sailor Piece Script Source ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("★ Seliaqua Hub ★", "DarkTheme")

-- Variables
local Player = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
_G.AutoFarm = false
_G.KillAura = false
_G.AutoStats = false
_G.StatsToUp = "Strength"
_G.Distance = 8

-- [ 1. ฟังก์ชัน Auto Farm ] --
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local Target = nil
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        Target = v
                        break
                    end
                end
                
                if Target then
                    Player.Character.HumanoidRootPart.CFrame = Target.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end
end)

-- [ 2. ฟังก์ชัน Kill Aura (ดาเมจรอบตัว) ] --
task.spawn(function()
    while task.wait(0.1) do
        if _G.KillAura then
            pcall(function()
                for _, v in pairs(workspace.Enemies:GetChildren()) do
                    if (v.HumanoidRootPart.Position - Player.Character.HumanoidRootPart.Position).Magnitude <= 25 then
                        -- จำลองการโจมตี (เรียกใช้ Remote ตามโครงสร้าง scripts.js)
                        game:GetService("ReplicatedStorage").Events.Attack:FireServer()
                    end
                end
            end)
        end
    end
end)

-- [ 3. ฟังก์ชัน Auto Stats (อัพค่าพลังอัตโนมัติ) ] --
task.spawn(function()
    while task.wait(1) do
        if _G.AutoStats then
            game:GetService("ReplicatedStorage").Events.StatsUpgrade:FireServer(_G.StatsToUp)
        end
    end
end)

-- [[ UI TABS ]] --

local Main = Window:NewTab("ฟาร์มหลัก")
local Section = Main:NewSection("Auto Farming")

Section:NewToggle("เริ่มออโต้ฟาร์ม", "วาร์ปไปตีมอนสเตอร์", function(state)
    _G.AutoFarm = state
end)

Section:NewToggle("คิลออร่า (Kill Aura)", "ตีมอนสเตอร์รอบตัว", function(state)
    _G.KillAura = state
end)

local StatsTab = Window:NewTab("อัพสถานะ")
local StatsSection = StatsTab:NewSection("Auto Stats")

StatsSection:NewDropdown("เลือกค่าที่จะอัพ", "เลือก Strength/Stamina/ฯลฯ", {"Strength", "Defense", "Stamina", "Sword", "Fruit"}, function(current)
    _G.StatsToUp = current
end)

StatsSection:NewToggle("เปิดออโต้สเตตัส", "อัพสเตตัสให้อัตโนมัติ", function(state)
    _G.AutoStats = state
end)

local Settings = Window:NewTab("ตั้งค่า")
Settings:NewSection("System"):NewKeybind("ซ่อนเมนู (F)", "กด F เพื่อซ่อน", Enum.KeyCode.F, function()
    Library:ToggleLib()
end)

print("★ Seliaqua Hub: Source Merged Successfully! ★")
