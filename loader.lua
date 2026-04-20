-- [[ Seliaqua Hub - Fix Farming & Attack ]] --

local CoreGui = game:GetService("CoreGui")
if CoreGui:FindFirstChild("★ Seliaqua Hub ★") then
    CoreGui["★ Seliaqua Hub ★"]:Destroy()
end

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("★ Seliaqua Hub ★", "DarkTheme")

-- Variables
local Player = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
_G.AutoFarm = false
_G.Distance = 8

-- [ 1. ฟังก์ชันค้นหามอนสเตอร์ ] --
local function GetMonster()
    local target = nil
    -- สแกนหา NPC ในแมพ
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
            if v.Name ~= Player.Name and not game.Players:GetPlayerFromCharacter(v) then
                target = v
                break
            end
        end
    end
    return target
end

-- [ 2. ระบบ Loop ฟาร์ม + แก้ไขการโจมตี ] --
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            pcall(function()
                local mob = GetMonster()
                if mob then
                    -- วาร์ปไปตำแหน่งฟาร์ม (ล็อคหัว)
                    Player.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    
                    -- --- วิธีการโจมตี (Attack Methods) ---
                    
                    -- แบบที่ 1: คลิกหน้าจอ
                    VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                    
                    -- แบบที่ 2: ส่งสัญญาณโจมตี (ใช้บ่อยในแมพแนววันพีช)
                    local combatRemote = game:GetService("ReplicatedStorage"):FindFirstChild("Attack", true) or 
                                       game:GetService("ReplicatedStorage"):FindFirstChild("Combat", true)
                    
                    if combatRemote and combatRemote:IsA("RemoteEvent") then
                        combatRemote:FireServer()
                    end
                end
            end)
        end
    end
end)

-- [[ UI TABS ]] --
local Tab1 = Window:NewTab("ฟาร์มหลัก")
local Section1 = Tab1:NewSection("Auto Farm Fix")

Section1:NewToggle("เริ่มฟาร์ม (Auto Farm)", "ต้องถืออาวุธในมือด้วยนะครับ", function(state)
    _G.AutoFarm = state
end)

Section1:NewSlider("ระยะห่างวาร์ป", "ถ้าตีไม่โดนให้ปรับลง", 15, 5, function(s)
    _G.Distance = s
end)

local Tab2 = Window:NewTab("ตั้งค่า")
Tab2:NewSection("System"):NewKeybind("ซ่อนเมนู (F)", "กด F เพื่อเปิด/ปิด", Enum.KeyCode.F, function()
    Library:ToggleLib()
end)

print("★ Seliaqua Hub: Attack Fixed! ★")
