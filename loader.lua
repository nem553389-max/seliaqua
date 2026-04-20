-- [[ Seliaqua Hub - Fix Black Screen Version ]] --

-- 1. ล้าง UI เก่าที่อาจค้างอยู่ (แก้จอดำ)
local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("★ Seliaqua Hub ★") then
    CoreGui["★ Seliaqua Hub ★"]:Destroy()
end

local VirtualUser = game:GetService("VirtualUser")
local Player = game.Players.LocalPlayer

-- 2. โหลด UI Library (เปลี่ยนเป็นธีม Dark ที่เสถียรกว่า)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("★ Seliaqua Hub ★", "DarkTheme") -- เปลี่ยนจาก Blood เป็น Dark เพื่อแก้บั๊กสี

-- 3. ตัวแปรระบบ
_G.AutoFarm = false
_G.AutoDungeon = false
_G.Distance = 8

-- 4. ฟังก์ชันค้นหาเป้าหมาย
local function GetTarget()
    local target = nil
    local dist = math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            if v.Name ~= Player.Name and not game.Players:GetPlayerFromCharacter(v) then
                local mag = (Player.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
                if mag < dist then
                    dist = mag
                    target = v
                end
            end
        end
    end
    return target
end

-- 5. ระบบ Loop ฟาร์ม
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm or _G.AutoDungeon then
            pcall(function()
                local target = GetTarget()
                if target then
                    Player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end
end)

-- 6. เมนู UI
local Main = Window:NewTab("ฟาร์มหลัก")
local Section = Main:NewSection("Seliaqua Farming")

Section:NewToggle("เริ่มออโต้ฟาร์ม (Auto Farm)", "วาร์ปไปฟาร์ม", function(state)
    _G.AutoFarm = state
end)

Section:NewToggle("ออโต้ดันเจี้ยน (Infinity)", "ฟาร์มดาบ Shadow", function(state)
    _G.AutoDungeon = state
end)

local Settings = Window:NewTab("ตั้งค่า")
Settings:NewSection("UI Settings"):NewButton("ปิด UI (Destroy)", "ลบเมนู", function()
    Library:DestroyGui()
end)

print("★ Seliaqua Hub: Version Fix-Black Loaded! ★")
