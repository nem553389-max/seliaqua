-- [[ Seliaqua Hub - Clean Version (No Image) ]] --

local VirtualUser = game:GetService("VirtualUser")
local Player = game.Players.LocalPlayer

-- 1. ระบบกันหลุด (Anti-AFK)
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- 2. โหลด UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("★ Seliaqua Hub ★", "BloodTheme")

-- 3. ตัวแปรระบบ
_G.AutoFarm = false
_G.AutoDungeon = false
_G.Distance = 8

-- 4. ฟังก์ชันค้นหามอนสเตอร์ (ระบบวาร์ปที่แม่นยำ)
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

Section:NewToggle("เริ่มออโต้ฟาร์ม (Auto Farm)", "วาร์ปไปฟาร์มมอนสเตอร์", function(state)
    _G.AutoFarm = state
end)

Section:NewToggle("ออโต้ดันเจี้ยน (Infinity)", "ฟาร์มดาบ Shadow", function(state)
    _G.AutoDungeon = state
end)

Section:NewSlider("ระยะห่างฟาร์ม", "ปรับความสูง", 15, 5, function(s)
    _G.Distance = s
end)

local Settings = Window:NewTab("ตั้งค่า")
local SetSection = Settings:NewSection("UI Settings")

SetSection:NewButton("ปิด UI ถาวร (Destroy)", "ลบเมนูออกจากหน้าจอ", function()
    Library:DestroyGui()
end)

SetSection:NewKeybind("ปุ่มซ่อน/แสดง (F)", "กด F เพื่อเปิด-ปิดเมนู", Enum.KeyCode.F, function()
    Library:ToggleLib()
end)

print("★ Seliaqua Hub: Clean Version Loaded! ★")
