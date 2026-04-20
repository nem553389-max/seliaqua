-- [[ Seliaqua Hub - Full Menu Version ]] --

-- ล้าง UI เก่าที่อาจจะค้างอยู่ (สำคัญมาก)
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("★ Seliaqua Hub ★") then
    CoreGui["★ Seliaqua Hub ★"]:Destroy()
end

-- โหลด Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("★ Seliaqua Hub ★", "DarkTheme")

-- Variables
local Player = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
_G.AutoFarm = false
_G.AutoStats = false
_G.StatsToUp = "Strength"
_G.Distance = 8

-- [ 1. หน้าฟาร์มหลัก ] --
local Tab1 = Window:NewTab("ฟาร์มเลเวล")
local Section1 = Tab1:NewSection("Auto Farming")

Section1:NewToggle("เริ่มฟาร์มอัตโนมัติ", "วาร์ปไปตีมอนสเตอร์ใกล้ที่สุด", function(state)
    _G.AutoFarm = state
end)

Section1:NewSlider("ระยะห่างการวาร์ป", "ปรับความสูง", 15, 5, function(s)
    _G.Distance = s
end)

-- [ 2. หน้าอัพสเตตัส ] --
local Tab2 = Window:NewTab("สเตตัส")
local Section2 = Tab2:NewSection("Auto Stats")

Section2:NewDropdown("เลือกสายที่จะอัพ", "เลือกค่าพลัง", {"Strength", "Defense", "Sword", "Fruit"}, function(current)
    _G.StatsToUp = current
end)

Section2:NewToggle("เปิดออโต้สเตตัส", "อัพสเตตัสให้อัตโนมัติ", function(state)
    _G.AutoStats = state
end)

-- [ 3. หน้าเทเลพอร์ต ] --
local Tab3 = Window:NewTab("วาร์ปเกาะ")
local Section3 = Tab3:NewSection("Teleport Locations")

Section3:NewButton("เกาะเริ่มต้น", "วาร์ปไปเกาะ 1", function()
    Player.Character.HumanoidRootPart.CFrame = CFrame.new(100, 50, 100) -- แก้พิกัดได้
end)

Section3:NewButton("เกาะบอส", "วาร์ปไปจุดเกิดบอส", function()
    Player.Character.HumanoidRootPart.CFrame = CFrame.new(500, 50, 500) -- แก้พิกัดได้
end)

-- [ 4. หน้าตั้งค่า ] --
local Tab4 = Window:NewTab("ตั้งค่า")
local Section4 = Tab4:NewSection("Settings")

Section4:NewKeybind("ซ่อนเมนู (F)", "กด F เพื่อเปิด/ปิด", Enum.KeyCode.F, function()
    Library:ToggleLib()
end)

Section4:NewButton("ปิดสคริปต์", "ลบเมนูทิ้ง", function()
    Library:DestroyGui()
end)

-- [[ ระบบการทำงาน (Logic) ]] --

-- Loop ฟาร์ม
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local Target = nil
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                        if v.Name ~= Player.Name and not game.Players:GetPlayerFromCharacter(v) then
                            Target = v
                            break
                        end
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

-- Loop อัพ Stats
task.spawn(function()
    while task.wait(1) do
        if _G.AutoStats then
            game:GetService("ReplicatedStorage").Events.StatsUpgrade:FireServer(_G.StatsToUp, 1)
        end
    end
end)

print("★ Seliaqua Hub: Full Menu Loaded! ★")
