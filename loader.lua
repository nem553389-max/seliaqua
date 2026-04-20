-- [[ Seliaqua Hub - Super Fast Attack Fix ]] --

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

-- ปรับ UI ให้ใสและสวยงาม
local Window = Library.CreateLib("★ Seliaqua Hub ★", "DarkTheme")
pcall(function()
    for _, v in pairs(game:GetService("CoreGui"):FindFirstChild("★ Seliaqua Hub ★"):GetDescendants()) do
        if v:IsA("Frame") or v:IsA("ScrollingFrame") then
            v.BackgroundTransparency = 0.3
        end
    end
end)

-- Variables
local Player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
_G.AutoFarm = false
_G.Distance = 7

-- [ 1. ระบบโจมตีขั้นสูง (Advanced Attack System) ] --
local function ForceAttack()
    pcall(function()
        -- วิธีที่ 1: ส่งสัญญาณตรงเข้าเซิร์ฟเวอร์ (Remote Event)
        -- สุ่มหา Remote ที่มีคำว่า Combat หรือ Attack ในเกม Sailor Piece
        local remotes = ReplicatedStorage:FindFirstChild("Remotes") or ReplicatedStorage
        for _, v in pairs(remotes:GetDescendants()) do
            if v:IsA("RemoteEvent") and (v.Name:find("Combat") or v.Name:find("Attack")) then
                v:FireServer()
            end
        end

        -- วิธีที่ 2: จำลองการคลิกเมาส์ซ้าย
        game:GetService("VirtualUser"):CaptureController()
        game:GetService("VirtualUser"):Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end

-- [ 2. ระบบบินแบบสมูท ] --
local function TweenTo(CFrameTarget)
    local Char = Player.Character or Player.CharacterAdded:Wait()
    local Root = Char:FindFirstChild("HumanoidRootPart")
    if Root then
        local Distance = (Root.Position - CFrameTarget.Position).Magnitude
        local info = TweenInfo.new(Distance / 100, Enum.EasingStyle.Linear)
        local tween = TweenService:Create(Root, info, {CFrame = CFrameTarget})
        Root.Velocity = Vector3.new(0,0,0)
        tween:Play()
    end
end

-- [ 3. ระบบ Loop ฟาร์ม ] --
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm then
            local Char = Player.Character
            local Hum = Char and Char:FindFirstChild("Humanoid")
            
            if Hum and Hum.Health > 0 then
                pcall(function()
                    local Target = nil
                    -- สแกนหามอนสเตอร์ที่ใกล้ที่สุด
                    for _, v in pairs(workspace:GetDescendants()) do
                        if v:IsA("Model") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            if not game.Players:GetPlayerFromCharacter(v) and v.Name ~= Player.Name then
                                Target = v break
                            end
                        end
                    end

                    if Target then
                        -- บินไปล็อคตัว
                        local Pos = Target.HumanoidRootPart.CFrame * CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                        TweenTo(Pos)
                        
                        -- หยิบอาวุธ (ถ้าไม่ถือจะตีไม่ได้)
                        if not Char:FindFirstChildOfClass("Tool") then
                            local tool = Player.Backpack:FindFirstChildOfClass("Tool")
                            if tool then Hum:EquipTool(tool) end
                        end

                        -- สั่งโจมตีรัวๆ
                        ForceAttack()
                    end
                end)
            else
                task.wait(2) -- รอเกิดใหม่
            end
        end
    end
end)

-- [[ UI Menu ]] --
local Main = Window:NewTab("ฟาร์มหลัก")
local Section = Main:NewSection("Auto Farm V5 (Fix Attack)")

Section:NewToggle("เปิดออโต้ฟาร์ม (บิน+ตีรัว)", "จะตีรัวๆ และบินไปหาเป้าหมายเอง", function(state)
    _G.AutoFarm = state
end)

Section:NewSlider("ระยะห่างการฟัน", "แนะนำ 7-8", 15, 5, function(s)
    _G.Distance = s
end)

local Config = Window:NewTab("ตั้งค่า")
Config:NewSection("System"):NewKeybind("ซ่อนเมนู (F)", "กดปุ่ม F", Enum.KeyCode.F, function()
    Library:ToggleLib()
end)

print("★ Seliaqua Hub: Attack Fix Loaded! ★")
