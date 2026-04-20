-- [[ Seliaqua Hub - Fix Black Screen & UI ]] --

-- ใช้รหัสรูปภาพที่เสถียรกว่า (รูป Konosuba แนวตั้งเพื่อให้ไม่บังเมนู)
local ImageID = "rbxassetid://15264350119" 

local VirtualUser = game:GetService("VirtualUser")

-- 1. โหลด UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("★ Seliaqua Hub ★", "BloodTheme")

-- 2. ตั้งค่ารูปภาพ (ย้ายไปมุมไม่ให้บังปุ่ม)
pcall(function()
    local CoreGui = game:GetService("CoreGui")
    local MainUI = CoreGui:FindFirstChild("★ Seliaqua Hub ★")
    if MainUI then
        local frame = MainUI:FindFirstChildOfClass("Frame")
        if frame then
            frame.Active = true
            frame.Draggable = true
            
            -- สร้างรูปภาพขนาดเล็กไว้ที่มุมขวาล่างของเมนู
            local Logo = Instance.new("ImageLabel")
            Logo.Name = "SeliaquaLogo"
            Logo.Parent = frame
            Logo.BackgroundTransparency = 1
            Logo.Position = UDim2.new(0.7, 0, 0.7, 0) -- ย้ายไปมุมขวาล่าง
            Logo.Size = UDim2.new(0, 100, 0, 100)
            Logo.Image = ImageID
            Logo.ZIndex = 0 -- ให้รูปอยู่ด้านหลังปุ่ม
        end
    end
end)

-- 3. ตัวแปรระบบ
_G.AutoFarm = false
_G.AutoDungeon = false
_G.Distance = 8

-- 4. ระบบค้นหามอนสเตอร์
local function GetTarget()
    local target = nil
    local dist = math.huge
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
            if v.Name ~= game.Players.LocalPlayer.Name and not game.Players:GetPlayerFromCharacter(v) then
                local mag = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude
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
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end
end)

-- 6. เมนู UI (ปุ่มต่างๆ จะกลับมาแล้ว)
local Main = Window:NewTab("ฟาร์มหลัก")
local Section = Main:NewSection("Seliaqua Farming")

Section:NewToggle("เริ่มออโต้ฟาร์ม (Auto Farm)", "วาร์ปไปฟาร์มมอนสเตอร์", function(state)
    _G.AutoFarm = state
end)

Section:NewToggle("ออโต้ดันเจี้ยน (Infinity)", "ฟาร์มดาบ Shadow", function(state)
    _G.AutoDungeon = state
end)

local Settings = Window:NewTab("ตั้งค่า")
Settings:NewSection("UI Settings"):NewButton("ปิด UI (Destroy)", "ลบเมนู", function()
    Library:DestroyGui()
end)

print("★ Seliaqua Hub: UI Fixed! ★")
