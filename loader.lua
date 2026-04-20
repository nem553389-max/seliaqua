-- [[ Seliaqua Hub - Fix Fly Still No Attack ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("★ Seliaqua Hub ★", "DarkTheme")

-- Variables
local Player = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
_G.AutoFarm = false
_G.Distance = 7

-- [ 1. ระบบแก้ทาง: บังคับถืออาวุธ (Force Equip) ] --
local function ForceEquipTool()
    local Char = Player.Character or Player.CharacterAdded:Wait()
    pcall(function()
        -- ถ้าไม่มีของในมือ
        if not Char:FindFirstChildOfClass("Tool") then
            -- หาของชิ้นแรกในกระเป๋า (มักจะเป็นอาวุธหลัก)
            local tool = Player.Backpack:FindFirstChildOfClass("Tool")
            if tool then
                Char.Humanoid:EquipTool(tool)
            end
        end
    end)
end

-- [ 2. ระบบแก้ทาง: ตีทะลวงเซิร์ฟเวอร์ (Remote Spike Attack) ] --
local function SpikeAttack()
    pcall(function()
        local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
        -- สุ่มหา Remote ที่เกมใช้โจมตี (ชื่อมักจะมีคำว่า Combat/Attack)
        for _, v in pairs(remotes:GetDescendants()) do
            if v:IsA("RemoteEvent") and (v.Name:find("Combat") or v.Name:find("Attack")) then
                -- ส่งสัญญาณตรงเข้าเซิร์ฟเวอร์ (ข้ามระบบตรวจคลิก)
                v:FireServer()
            end
        end
        -- เสริมด้วยการคลิกพื้นฐาน
        VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- [ 3. ระบบบินสมูทล้อคตัว ] --
local function TweenTo(Pos)
    local Char = Player.Character or Player.CharacterAdded:Wait()
    local Root = Char:FindFirstChild("HumanoidRootPart")
    if Root then
        local Distance = (Root.Position - Pos.Position).Magnitude
        local info = TweenInfo.new(Distance / 100, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(Root, info, {CFrame = Pos})
        tween:Play()
    end
end

-- [ 4. ระบบ Loop หลัก ] --
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            local Char = Player.Character
            local Hum = Char and Char:FindFirstChild("Humanoid")
            if Hum and Hum.Health > 0 then
                pcall(function()
                    local Target = nil
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            if not game.Players:GetPlayerFromCharacter(v) and v.Name ~= Player.Name then
                                Target = v break
                            end
                        end
                    end

                    if Target then
                        -- บินล็อคเป้า
                        local Pos = Target.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                        TweenTo(Pos)
                        
                        -- บังคับถืออาวุธ
                        ForceEquipTool()
                        
                        -- บังคับตี!
                        SpikeAttack()
                    end
                end)
            else
                task.wait(2) -- รอเกิดใหม่
            end
        end
    end
end)

-- [[ UI TABS ]] --
local Tab = Window:NewTab("ฟาร์มหลัก")
local Section = Tab:NewSection("Auto Farm V6 (Spike Attack)")

Section:NewToggle("เริ่มฟาร์ม (บิน+บังคับตี)", "จะตีได้แน่นอนไม่ว่าตัวละครจะยืนที่ไหน", function(state)
    _G.AutoFarm = state
end)

Section:NewSlider("ระยะห่าง (แนะนำ 7)", "ปรับสูงต่ำตอนฟัน", 15, 5, function(s)
    _G.Distance = s
end)

local Tab3 = Window:NewTab("ตั้งค่า")
Tab3:NewSection("System"):NewKeybind("ซ่อนเมนู (F)", "กด F เพื่อเปิด/ปิด", Enum.KeyCode.F, function()
    Library:ToggleLib()
end)

print("★ Seliaqua Hub: Spike Attack System Loaded! ★")
