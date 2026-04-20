-- [[ Seliaqua Hub - Sailor Piece Edition ]] --

-- ใส่รหัสรูปภาพอนิเมะที่คุณส่งมา (อ้างอิงรูป KonoSuba)
local ImageID = "rbxassetid://15264350119" 

-- 1. ระบบกันหลุด (Anti-AFK)
local VirtualUser = game:GetService("VirtualUser")
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- 2. โหลด UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("★ Seliaqua Hub ★", "BloodTheme")

-- 3. ตั้งค่าให้ UI ขยับได้และโชว์โลโก้ค่าย
pcall(function()
    local CoreGui = game:GetService("CoreGui")
    local MainUI = CoreGui:FindFirstChild("★ Seliaqua Hub ★")
    if MainUI then
        local frame = MainUI:FindFirstChildOfClass("Frame")
        if frame then
            frame.Active = true
            frame.Draggable = true
            -- สร้างรูปภาพประกอบเมนู
            local Logo = Instance.new("ImageLabel")
            Logo.Name = "SeliaquaLogo"
            Logo.Parent = frame
            Logo.BackgroundTransparency = 1
            Logo.Position = UDim2.new(0, 10, 0, 50)
            Logo.Size = UDim2.new(0, 80, 0, 80)
            Logo.Image = ImageID
        end
    end
end)

-- 4. ตัวแปรระบบ
