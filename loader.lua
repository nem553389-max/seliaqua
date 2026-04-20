-- [[ Seliaqua Hub - Sailor Piece Auto Farm Level ]] --

local VirtualUser = game:GetService("VirtualUser")
local Player = game.Players.LocalPlayer

-- 1. ระบบกันหลุด (Anti-AFK)
Player.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- 2. โหลด UI Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("★ Seliaqua Hub ★", "DarkTheme")

-- 3. ตัวแปรระบบ
_G.AutoFarm = false
_G.AutoSkills = false
_G.Distance = 8
_G.WeaponType = "Melee" -- ค่าเริ่มต้นเป็นหมัด

-- 4. ฟังก์ชันรับเควสอัตโนมัติ (หัวใจหลักจากในคลิป)
local function CheckQuest()
    local level = Player.Data.Level.Value
    -- ใส่ระบบเช็คเลเวลเพื่อรับเควสที่เหมาะสม (ตัวอย่างคร่าวๆ ตามเกาะแรก)
    if level >= 1 and level < 50 then
        return "Quest1"
    elseif level >= 50 and level < 100 then
        return "Quest2"
    end
    -- คุณสามารถเพิ่มเงื่อนไขตามเควสในแมพจริงได้ที่นี่
end

-- 5. ระบบวาร์ปและตี (Fast Farm)
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                -- ค้นหาศัตรูที่ใกล้ที่สุด
                local Target = nil
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                        if v.Name ~= Player.Name and not game.Players:GetPlayerFromCharacter(v) then
                            Target = v
                            break
                        end
                    end
                end

                if Target then
                    -- วาร์ปไปล็อคตำแหน่ง (ฟาร์มเร็วมากแบบในคลิป)
                    Player.Character.HumanoidRootPart.CFrame = Target.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    
                    -- กดตีอัตโนมัติ
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                end
            end)
        end
    end
end)

-- 6. ระบบใช้สกิลอัตโนมัติ (Z, X, C, V)
task.spawn(function()
    while task.wait(1) do
        if _G.AutoSkills and _G.AutoFarm then
            local vim = game:GetService("VirtualInputManager")
            vim:SendKeyEvent(true, "Z", false, game)
            vim:SendKeyEvent(true, "X", false, game)
            vim:SendKeyEvent(true, "C", false, game)
            vim:SendKeyEvent(true, "V", false, game)
        end
    end
end)

-- 7. เม
