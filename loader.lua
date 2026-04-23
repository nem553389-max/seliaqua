--[[
    SELIQUA HUB - Official Script
    Game: Sailor Piece
]]--

Local RunService = game:GetService("RunService")

local count = 0
local conn

conn = RunService.Heartbeat:Connect(function()
    count += 1
    if count >= 10 then
        conn:Disconnect()
    end
end)

while count < 10 do
    RunService.Heartbeat:Wait()
end


if count < 10 then
    error("detected")
    return
end

local Players = game:GetService("Players")
local LP = Players.LocalPlayer
local LocalPlayer = LP
local placeId = game.PlaceId
local jobId = game.JobId
local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CombatRemote = RS:WaitForChild("CombatSystem"):WaitForChild("Remotes"):WaitForChild("RequestHit")
local VirtualUser = game:GetService('VirtualUser')
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local privateServerId = game.PrivateServerId
local QuestModule = require(ReplicatedStorage.Modules.QuestConfig)
local quests = QuestModule.RepeatableQuests
local QuestEvent = ReplicatedStorage.RemoteEvents.QuestAccept
local Event = RS:WaitForChild("RemoteEvents"):WaitForChild("AllocateStat")
local Data = LP:WaitForChild("Data")
local StatPoints = Data:WaitForChild("StatPoints")
local MerchantConfig = require(game:GetService("ReplicatedStorage").Modules.MerchantConfig)
local PurchaseRemote = game:GetService("ReplicatedStorage").Remotes.MerchantRemotes.PurchaseMerchantItem
local HttpService = game:GetService("HttpService")
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local requestRemote = remotes:WaitForChild("RequestInventory")
local updateRemote = remotes:WaitForChild("UpdateInventory")
local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
local ItemRarityConfig = require(game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("ItemRarityConfig"))
local LoadoutEvent = ReplicatedStorage.RemoteEvents.LoadoutLoad
_G.selectedMerchantItems = {}
_G.AutoBuyMerchant = false
_G.PrioriySystem = false
_G.PrioriySystem2 = false
local IslandPositions = {
    ["Starter"] = {
        Position = Vector3.new(140.46328735351562,16.020355224609375,-232.6060028076172),
        Distance = 300
    },
    ["Jungle"] = {
        Position = Vector3.new(-549.4597778320312,-1.6375274658203125,450.9712829589844),
        Distance = 250
    },
    ["Desert"] = {
        Position = Vector3.new(-858.2831420898438,7.399674415588379,-423.21685791015625),
        Distance = 180
    },
    ["Snow"] = {
        Position = Vector3.new(-404.0072021484375,8.77878475189209,-1108.4066162109375),
        Distance = 350
    },
    ["Sailor"] = {
        Position = Vector3.new(241.33700561523438,58.223262786865234,878.6301879882812),
        Distance = 320
    },
    ["Shibuya"] = {
        Position = Vector3.new(1634.826171875,94.87212371826172,249.17959594726562),
        Distance = 700
    },
    ["HuecoMundo"] = {
        Position = Vector3.new(-548.8748168945312,0.3238450884819031,1172.332763671875),
        Distance = 400
    },
    ["Boss"] = {
        Position = Vector3.new(768.4255981445312,-0.6666639447212219,-1087.132568359375),
        Distance = 180
    },
    ["Shinjuku"] = {
        Position = Vector3.new(320.879638671875,-4.17604923248291,-2004.6363525390625),
        Distance = 750
    },
    ["Slime"] = {
        Position = Vector3.new(-1183.3363037109375,44.49148178100586,212.57144165039062),
        Distance = 400
    },
    ["Academy"] = {
        Position = Vector3.new(963.0895385742188,2.2623825073242188,1327.1123046875),
        Distance = 250
    },
    ["Judgement"] = {
        Position = Vector3.new(-1244.099609375,77.01905822753906,-1236.8636474609375),
        Distance = 420
    },
    ["SoulSociety"] = {
        Position = Vector3.new(-1303.7255859375,1624.6370849609375,1672.4981689453125),
        Distance = 170
    }
}

local ListTrade = {
    ["Blessed Maiden"] = {
        {Name = "Aero Core", Amount = 3},
        {Name = "Celestial Mark", Amount = 1},
        {Name = "Gale Essence", Amount = 8},
        {Name = "Tide Remnant", Amount = 14},
        {Name = "Tempest Relic", Amount = 25}
    },
    ["Blessed Maiden Skill F"] = {
        {Name = "Aero Core", Amount = 8},
        {Name = "Celestial Mark", Amount = 2},
        {Name = "Tempest Relic", Amount = 75}
    },
    ["SJW V2"] = {
        {Name = "Monarch Core", Amount = 10},
        {Name = "Monarch Essence", Amount = 5},
        {Name = "Kamish Dagger", Amount = 2},
        {Name = "Shadow Crystal", Amount = 1}
    },
    ["Sukuna V2"] = {
        {Name = "Cursed Flesh", Amount = 1},
        {Name = "Malevolent Soul", Amount = 3},
        {Name = "Vessel Ring", Amount = 7},
        {Name = "Awakened Cursed Finger", Amount = 20}
    },
    ["Sukuna V2 Domain"] = {
        {Name = "Cursed Flesh", Amount = 1},
        {Name = "Malevolent Soul", Amount = 6},
        {Name = "Vessel Ring", Amount = 7},
        {Name = "Awakened Cursed Finger", Amount = 20},
        {Name = "Shrine Domain Shard", Amount = 1}
    },
    ["Gilgamesh Key"] = {
        {Name = "Phantasm Core", Amount = 3},
        {Name = "Ancient Shard", Amount = 6},
        {Name = "Throne Remnant", Amount = 12},
        {Name = "Golden Essence", Amount = 8},
        {Name = "Broken Sword", Amount = 100}
    },

    ["Gojo V2"] = {
        {Name = "Six Eye", Amount = 6},
        {Name = "Reversal Pulse", Amount = 9},
        {Name = "Blue Singularity", Amount = 6},
        {Name = "Infinity Essence", Amount = 1}
    },

    ["Gojo V2 Domain"] = {
        {Name = "Six Eye", Amount = 6},
        {Name = "Reversal Pulse", Amount = 9},
        {Name = "Blue Singularity", Amount = 6},
        {Name = "Infinity Essence", Amount = 1},
        {Name = "Infinity Domain Shard", Amount = 1}
    },
    ["Rimuru"] = {
        {Name = "Sage Pulse", Amount = 9},
        {Name = "Tempest Seal", Amount = 6},
        {Name = "Slime Remnant", Amount = 3},
        {Name = "Slime Core", Amount = 1}
    },
    ["Anos"] = {
        {Name = "Calamity Seal", Amount = 65},
        {Name = "Demonic Fragment", Amount = 12},
        {Name = "Demonic Shard", Amount = 6},
        {Name = "Destruction Eye", Amount = 2},
        {Name = "Imperial Mark", Amount = 1}
    },
    ["Ichigo"] = {
        {Name = "Boss Ticket", Amount = 500}
    },
    ["Cid"] = {
        {Name = "Atomic Core", Amount = 1},
        {Name = "Shadow Essence", Amount = 4},
        {Name = "Void Seed", Amount = 8},
        {Name = "Umbral Capsule", Amount = 20}
    },
    ["Madoka"] = {
        {Name = "Heart", Amount = 100},
        {Name = "Divine Fragment", Amount = 8},
        {Name = "Sacred Bow", Amount = 5},
        {Name = "Radiant Core", Amount = 3},
        {Name = "Pink Gem", Amount = 1}
    },
    ["Aizen V1"] = {
        {Name = "Hรยถgyoku Fragment", Amount = 1},
        {Name = "Reiatsu Core", Amount = 3},
        {Name = "Illusion Prism", Amount = 6},
        {Name = "Mirage Pendant", Amount = 10}
    },
    ["SJW V1"] = {
        {Name = "Abyss Edge", Amount = 6},
        {Name = "Dark Ring", Amount = 3},
        {Name = "Shadow Heart", Amount = 1}
    },
    ["Gojo V1"] = {
        {Name = "Void Fragment", Amount = 6},
        {Name = "Limitless Ring", Amount = 3},
        {Name = "Infinity Core", Amount = 1}
    },
    ["Sukuna V1"] = {
        {Name = "Crimson Heart", Amount = 1},
        {Name = "Cursed Finger", Amount = 6},
        {Name = "Dismantle Fang", Amount = 3}
    },
    ["Yamato"] = {
        {Name = "Azure Heart", Amount = 1},
        {Name = "Silent Storm", Amount = 3},
        {Name = "Yamato", Amount = 7},
        {Name = "Frozen Will", Amount = 14}
    },
    ["Aizen V2"] = {
        {Name = "Evolution Fragment", Amount = 1},
        {Name = "Transcendent Core", Amount = 3},
        {Name = "Divinity Essence", Amount = 8},
        {Name = "Fusion Ring", Amount = 15},
        {Name = "Chrysalis Sigil", Amount = 75}
    },
    ["Alter Saber Skill F"] = {
        {Name = "Alter Essence", Amount = 8},
        {Name = "Morgan Remnant", Amount = 15},
        {Name = "Corrupt Crown", Amount = 3},
        {Name = "Corruption Core", Amount = 12},
        {Name = "Dark Grail", Amount = 110}
    },
    ["Ascend Set 2-8"] = {
        {Name = "Void Fragment", Amount = 5},
        {Name = "Limitless Ring", Amount = 2},
        {Name = "Dismantle Fang", Amount = 7},
        {Name = "Dark Ring", Amount = 5},
        {Name = "Reiatsu Core", Amount = 4},
        {Name = "Hรยถgyoku Fragment", Amount = 2},
        {Name = "Atomic Core", Amount = 2},
        {Name = "Blood Ring", Amount = 4},
        {Name = "Flame Soul", Amount = 3},
        {Name = "Cursed Flesh", Amount = 2},
        {Name = "Infinity Essence", Amount = 2},
        {Name = "Phantasm Core", Amount = 2},
        {Name = "Slime Core", Amount = 3}
    },
    ["Blessing Set 1-10"] = {
        {Name = "Wood", Amount = 1185},
        {Name = "Iron", Amount = 575},
        {Name = "Obsidian", Amount = 365},
        {Name = "Mythril", Amount = 170},
        {Name = "Adamantite", Amount = 40}
    }
}

_G.AutoBuildSwitch = false
_G.LuckBuild = 1
_G.DamageBuild = 2
_G.BuildThreshold = 15

local TradeNames = {}

for name,_ in pairs(ListTrade) do
    table.insert(TradeNames, name)
end

local function SafetyMode()
	local Players = game:GetService("Players")
	local LP = Players.LocalPlayer

	local BlacklistedUsers = {
  [2595714482] = true,
  [516173765] = true,
  [4512218864] = true,
  [1743329681] = true,
  [653208846] = true,
  [3226663238] = true,
  [1994122448] = true,
  [2925788551] = true,
  [3017035996] = true,
  [377698788] = true,
  [2829959745] = true
	}

	local function Check(player)
  if BlacklistedUsers[player.UserId] then
   game:Shutdown()
  end
	end

	for _,player in ipairs(Players:GetPlayers()) do
  Check(player)
	end

	Players.PlayerAdded:Connect(Check)
end

local fileName = "Rc Hub/Config/TotalExecution.json"
if not isfile(fileName) then
    writefile(fileName, "0")
end
local currentValue = tonumber(readfile(fileName)) or 0
currentValue = currentValue + 1
writefile(fileName, tostring(currentValue))

_G.SpeedTweenS = 190
_G.SelectModeTP = "Tween"
local selectedWeapon = "None"

game:GetService('Players').LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

function QuestR(a)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local QuestEvent = ReplicatedStorage.RemoteEvents.QuestAccept
QuestEvent:FireServer(a)
end

local function GetClosestIsland(npc)
    for islandName, data in pairs(IslandPositions) do
        local distance = (npc - data.Position).Magnitude
        
        if distance <= data.Distance then
            return islandName, data -- ✅ return dua-duanya
        end
    end

    return nil, nil
end

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PortalRemote = ReplicatedStorage.Remotes:WaitForChild("TeleportToPortal")

local function TeleportToIsland(islandName)
    if not islandName then return end
    PortalRemote:FireServer(islandName)
    local char = LP.Character or LP.CharacterAdded:Wait()
    repeat task.wait() until char:FindFirstChild("HumanoidRootPart")
end

local function formatNumber(n)
    n = tonumber(n) or 0
    local abs = math.abs(n)

    local function clean(num)
        local s = string.format("%.2f", num)
        return s:gsub("%.?0+$", "")
    end

    if abs >= 1e12 then
        return clean(n / 1e12) .. "T"
    elseif abs >= 1e9 then
        return clean(n / 1e9) .. "B"
    elseif abs >= 1e6 then
        return clean(n / 1e6) .. "M"
    elseif abs >= 1e3 then
        return clean(n / 1e3) .. "K"
    else
        return tostring(n)
    end
end


local function sendWebhook(itemsText, WEBHOOK_URL)
    local level = player.Data.Level.Value
    local money = formatNumber(player.Data.Money.Value)
    local gems = formatNumber(player.Data.Gems.Value)
    local timeString = os.date("%H:%M:%S")
    local data = {
        ["username"] = "RcHub Best Script!",
        ["avatar_url"] = "https://i.imgur.com/SGVO85F.png",
        ["embeds"] = {
            {
                ["title"] = "Player Inventory Data",
                ["description"] =
                    "**Player Infos**\n Players Name : || **" .. game.Players.LocalPlayer.Name .. "** ||\n\n" ..
                    "🧧 Level: **" .. level .. "** " ..
                    "💰 Money: **" .. money .. "** " ..
                    "💎 Gems: **" .. gems .. "**\n\n" ..
                    "📦 **Inventory Items**\n```" ..
                    itemsText ..
                    "```\n" ..
                    timeString,

                ["color"] = 65280
            }
        }
    }
    local encoded = HttpService:JSONEncode(data)
    local requestFunc = http_request or request or syn.request
    if requestFunc then
        requestFunc({
            Url = WEBHOOK_URL,
            Body = encoded,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            }
        })
    end
end

local function manualTrigger(link)
    local connection

    connection = updateRemote.OnClientEvent:Connect(function(category, data)
        if category ~= "Items" then return end
        if type(data) ~= "table" then return end

        connection:Disconnect()

        -- Group by Tier
        local tierData = {}
        local tierTotals = {}

        for _, item in pairs(data) do
            if type(item) == "table" and item.name then
                local name = item.name
                local qty = item.quantity or 1
                local tier = ItemRarityConfig:GetRarity(name) or "Common"

                tierData[tier] = tierData[tier] or {}
                tierData[tier][name] = (tierData[tier][name] or 0) + qty

                tierTotals[tier] = (tierTotals[tier] or 0) + qty
            end
        end

        -- Optional: urutkan tier biar rapi
        local tierOrder = {
            "Secret",
            "Mythical",
            "Legendary",
            "Epic",
            "Rare",
            "Uncommon",
            "Common"
        }

        local itemsText = ""

        for _, tier in ipairs(tierOrder) do
            if tierData[tier] then
                itemsText = itemsText ..
                    "📦 " .. tier ..
                    " Items \n"

                for name, qty in pairs(tierData[tier]) do
                    itemsText = itemsText ..
                        "- " .. name ..
                        " x" .. qty .. "\n"
                end

                itemsText = itemsText .. "\n"
            end
        end

        if itemsText == "" then
            itemsText = "Empty"
        end

        sendWebhook(itemsText, link)
    end)

    requestRemote:FireServer()
end

local function IsBusoActive()
    local char = player.Character
    if not char then return false end

    local parts = {
        char:FindFirstChild("Right Arm"),
        char:FindFirstChild("Left Arm"),
    }

    for _, part in ipairs(parts) do
        if part and part:IsA("Part") then
            local c = part.Color
            if c.R == 0 and c.G == 0 and c.B == 0 then
                return true
            end
        end
    end

    return false
end

local function getNPC(kkj)
    local list = { "None" }
    local seen = {}

    local npcsFolder = Workspace:FindFirstChild("NPCs")
    if not npcsFolder then
        return list
    end

    for _, npc in ipairs(npcsFolder:GetChildren()) do
        if npc:FindFirstChild("Humanoid") then
            local name = npc.Name

            -- Skip kalau ada underscore
            if not kkj and name:find("_") then
                continue
            end

            -- Hapus angka
            name = name:gsub("%d+", "")

            -- Rapikan spasi (kalau ada sisa)
            name = name:match("^%s*(.-)%s*$")

            if name ~= "" and not seen[name] then
                seen[name] = true
                table.insert(list, name)
            end
        end
    end

    table.sort(list)
    return list
end

local function GetQuest(npcType)
    local bestNPC

    local function checkQuest(name, data)
        if data.requirements then
            for _, req in pairs(data.requirements) do
                if req.npcType == npcType then
                    bestNPC = name
                    return true
                end
            end
        end
    end

    for npcName, data in pairs(quests) do
        if checkQuest(npcName, data) then
            break
        end

        for subName, subData in pairs(data) do
            if type(subData) == "table" and subData.requirements then
                if checkQuest(subName, subData) then
                    break
                end
            end
        end
    end

    if bestNPC then
        QuestEvent:FireServer(bestNPC)
    end

    return bestNPC
end

local function findNPC(name, mode)
    if name == "None" then return nil end

    local npcsFolder = Workspace:FindFirstChild("NPCs")
    if not npcsFolder then return nil end

    for _, npc in pairs(npcsFolder:GetChildren()) do
        local hum = npc:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then continue end

        local originalName = npc.Name
        local processedName = originalName

        if mode == "Boss" then
            if originalName == name then
                return npc
            end
        else
            if mode ~= "IncludeUnderscore" and originalName:find("_") then
                continue
            end

            processedName = processedName:gsub("%d+", "")
            processedName = processedName:match("^%s*(.-)%s*$")

            if processedName == name then
                return npc
            end
        end
    end

    return nil
end

local function getAllWeapons()
    local weapons = { "None" }
    local backpack = LP:FindFirstChild("Backpack")
    local char = LP.Character
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                table.insert(weapons, tool.Name)
            end
        end
    end
    if char then
        for _, tool in pairs(char:GetChildren()) do
            if tool:IsA("Tool") and not table.find(weapons, tool.Name) then
                table.insert(weapons, tool.Name)
            end
        end
    end
    return weapons
end



local function AktifSkill()
    if _G.AutoSkill then
        local abilityRemote = ReplicatedStorage.AbilitySystem.Remotes.RequestAbility
        local fruitRemote = ReplicatedStorage.RemoteEvents.FruitPowerRemote

        -- Ability
        if _G.SkillZ then abilityRemote:FireServer(1) end
        if _G.SkillX then abilityRemote:FireServer(2) end
        if _G.SkillC then abilityRemote:FireServer(3) end
        if _G.SkillV then abilityRemote:FireServer(4) end
        if _G.SkillF then abilityRemote:FireServer(5) end
    end
end

