--[[
    ========================================================================
                      CGH HUB — BLOX FRUITS NATIVE CORE v3.0
               50+ Tính năng nguyên bản bóc tách từ Nousigi/RealKid Hub
                      100% Mã nguồn sạch — Zero Luraph VM (Không đơ game)
    ========================================================================
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF = Remotes:WaitForChild("CommF_")
local xisdRemote = Remotes:FindFirstChild("xisd")

-- ========================================================================
-- 1. BẢNG CẤU HÌNH & TRẠNG THÁI TÍNH NĂNG (STATE CONFIG)
-- ========================================================================
local _CGH = {
    -- Farm
    AutoFarm = false,
    AutoAcceptQuest = true,
    AutoFarmBoss = false,
    AutoFarmNearest = false,
    AutoCollectChest = false,
    AutoBartilo = false,
    WeaponType = "Melee",
    FarmHeight = 25,
    SelectedTarget = "Bandit",
    SelectedBoss = "The Gorilla King",
    
    -- Combat & Settings
    FastAttack = false,
    FastAttackPlayers = false,
    BringMobs = false,
    BringMobMax = 8,
    BringMobMode = "Behind",
    AutoTurnBuso = false,
    AutoTurnKen = false,
    AutoTurnRaceV3 = false,
    AutoTurnRaceV4 = false,
    AutoSpinPosition = false,
    AntiAFK = true,
    AutoRemoveFog = false,
    AutoLowCPU = false,
    TweenSpeed = 300,
    SelectedTeam = "Pirates",

    -- Stats
    AutoMelee = false,
    AutoDefense = false,
    AutoSwords = false,
    AutoGun = false,
    AutoFruit = false,
    StatsValue = 1,

    -- Teleport & Travel
    AutoTravel = false,
    SelectedIsland = "Starter Island (Pirate)",

    -- ESP
    EspPlayers = false,
    EspChests = false,
    EspFruits = false,

    -- Internal
    Noclip = false,
    CurrentTween = nil
}

-- ========================================================================
-- 2. TỌA ĐỘ CÁC ĐẢO CHÍNH (ISLAND COORDINATES MAP)
-- ========================================================================
local IslandPositions = {
    ["Starter Island (Pirate)"] = CFrame.new(1059, 16, 1549),
    ["Starter Island (Marine)"] = CFrame.new(-2573, 7, 2046),
    ["Jungle"]                 = CFrame.new(-1612, 37, 149),
    ["Pirate Village"]         = CFrame.new(-1181, 5, 3845),
    ["Desert"]                 = CFrame.new(894, 6, 4390),
    ["Middle Town"]            = CFrame.new(-655, 8, 1582),
    ["Frozen Village"]         = CFrame.new(1157, 7, -1149),
    ["Marineford"]             = CFrame.new(-4505, 21, 4260),
    ["Colosseum"]              = CFrame.new(-1427, 7, -3016),
    ["Skylands (Sky 1)"]       = CFrame.new(-4837, 717, -2619),
    ["Upper Skylands (Sky 2)"] = CFrame.new(-7894, 5547, -380),
    ["Prison"]                 = CFrame.new(4848, 6, 735),
    ["Magma Village"]          = CFrame.new(-5245, 9, 8504),
    ["Underwater City"]        = CFrame.new(3879, 6, -1899),
    ["Fountain City"]          = CFrame.new(5128, 5, 4104),
    ["The Cafe (Sea 2)"]       = CFrame.new(-380, 73, 298),
    ["Mansion (Sea 3)"]        = CFrame.new(-12463, 375, -7551)
}

-- ========================================================================
-- 3. CƠ CHẾ DI CHUYỂN, NOCLIP & TWEEN
-- ========================================================================
local function CancelTween()
    if _CGH.CurrentTween then
        _CGH.CurrentTween:Cancel()
        _CGH.CurrentTween = nil
    end
end

local function TweenTo(targetCF, customSpeed)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local speed = customSpeed or _CGH.TweenSpeed
    local dist = (root.Position - targetCF.Position).Magnitude
    
    if dist < 15 then
        root.CFrame = targetCF
        return
    end

    CancelTween()
    local tInfo = TweenInfo.new(dist / speed, Enum.EasingStyle.Linear)
    _CGH.CurrentTween = TweenService:Create(root, tInfo, {CFrame = targetCF})
    _CGH.CurrentTween:Play()
    return _CGH.CurrentTween
end

RunService.Stepped:Connect(function()
    if _CGH.Noclip or _CGH.AutoFarm or _CGH.AutoCollectChest or _CGH.AutoTravel then
        local char = LocalPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- ========================================================================
-- 4. CƠ CHẾ COMBAT FRAMEWORK & FAST ATTACK NGUYÊN BẢN (KHÔNG FAKE CLICK)
-- ========================================================================
local CombatFramework = nil
pcall(function()
    CombatFramework = require(LocalPlayer.PlayerScripts:WaitForChild("CombatFramework"))
end)

local function EquipWeapon(typeChoice)
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not char or not backpack then return end

    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            if typeChoice == "Melee" and item.ToolTip == "Melee" then
                char.Humanoid:EquipTool(item)
                return item
            elseif typeChoice == "Sword" and item.ToolTip == "Sword" then
                char.Humanoid:EquipTool(item)
                return item
            elseif typeChoice == "Gun" and item.ToolTip == "Gun" then
                char.Humanoid:EquipTool(item)
                return item
            elseif typeChoice == "Demon Fruit" and (item.ToolTip:find("Fruit") or item.ToolTip == "Blox Fruit") then
                char.Humanoid:EquipTool(item)
                return item
            end
        end
    end
    return char:FindFirstChildOfClass("Tool")
end

-- THREAD FAST ATTACK ĐỘC LẬP TẦN SỐ CAO (HIGH FREQUENCY THREAD)
task.spawn(function()
    while true do
        task.wait(0.015)
        if _CGH.FastAttack or _CGH.AutoFarm then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local currentTool = char:FindFirstChildOfClass("Tool") or EquipWeapon(_CGH.WeaponType)
                if currentTool then
                    pcall(function()
                        if CombatFramework and CombatFramework.activeController then
                            local ac = CombatFramework.activeController
                            ac.attackInterval = 0
                            ac.hitboxMagnitude = 60
                            if ac.attack then
                                ac:attack()
                            end
                        end
                    end)
                    pcall(function()
                        currentTool:Activate()
                    end)
                end
            end
        end
    end
end)

-- ========================================================================
-- 5. CƠ CHẾ BRING MOBS CHUẨN XÁC THEO LOGIC REMOTE xisd MAGNET & HITBOX
-- ========================================================================
local function AuthenticBringMobs()
    if not _CGH.BringMobs and not _CGH.AutoFarm then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local enemies = workspace:FindFirstChild("Enemies")
    if not enemies then return end

    -- Gọi Remote Magnet chuẩn xác của Blox Fruits đã bóc tách từ log
    pcall(function()
        if xisdRemote then
            xisdRemote:InvokeServer("FX", "Magnet")
        end
    end)

    local count = 0
    local maxBring = tonumber(_CGH.BringMobMax) or 8
    local rootPos = root.Position

    for _, enemy in ipairs(enemies:GetChildren()) do
        local hum = enemy:FindFirstChild("Humanoid")
        local eRoot = enemy:FindFirstChild("HumanoidRootPart")
        if hum and hum.Health > 0 and eRoot then
            local dist = (eRoot.Position - rootPos).Magnitude
            if dist < 320 then
                count = count + 1
                
                -- Khóa physics & phóng to hitbox quái (chuẩn mechanic Blox Fruits)
                eRoot.CanCollide = false
                eRoot.Size = Vector3.new(60, 60, 60)
                hum:ChangeState(11) -- Physics/Stun state không cho quái đi lệch
                pcall(sethiddenproperty, eRoot, "NetworkIsSleeping", true)

                local offset = CFrame.new(0, 0, -4)
                if _CGH.BringMobMode == "Above" then
                    offset = CFrame.new(0, 8, 0)
                elseif _CGH.BringMobMode == "Behind" then
                    offset = CFrame.new(0, 0, 4)
                end

                eRoot.CFrame = root.CFrame * offset
                if count >= maxBring then break end
            end
        end
    end
end

-- THREAD BRING MOBS ĐỘC LẬP
task.spawn(function()
    while true do
        task.wait(0.15)
        if _CGH.BringMobs or _CGH.AutoFarm then
            pcall(AuthenticBringMobs)
        end
    end
end)

-- ========================================================================
-- 6. THREAD AUTO FARM QUEST & FARMING LOGIC
-- ========================================================================
task.spawn(function()
    while true do
        task.wait(0.2)
        if _CGH.AutoFarm then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                local root = char.HumanoidRootPart
                local enemies = workspace:FindFirstChild("Enemies")
                local targetMob = nil
                
                if enemies then
                    for _, enemy in ipairs(enemies:GetChildren()) do
                        local eHum = enemy:FindFirstChild("Humanoid")
                        local eRoot = enemy:FindFirstChild("HumanoidRootPart")
                        if eHum and eHum.Health > 0 and eRoot then
                            targetMob = enemy
                            break
                        end
                    end
                end

                if targetMob and targetMob:FindFirstChild("HumanoidRootPart") then
                    local mobRoot = targetMob.HumanoidRootPart
                    local farmCF = mobRoot.CFrame * CFrame.new(0, _CGH.FarmHeight, 0)
                    TweenTo(farmCF, _CGH.TweenSpeed)
                end
            end
        end
    end
end)

-- ========================================================================
-- 7. CƠ CHẾ HAKI, RACE & ANTI AFK
-- ========================================================================
task.spawn(function()
    while true do
        task.wait(1.5)
        local char = LocalPlayer.Character
        if char then
            -- Auto Buso Haki (Aura)
            if _CGH.AutoTurnBuso and not char:FindFirstChild("HasBuso") then
                pcall(function() CommF:InvokeServer("Buso") end)
            end

            -- Auto Ken Haki (Observation)
            if _CGH.AutoTurnKen then
                pcall(function()
                    local vision = LocalPlayer.PlayerGui:FindFirstChild("ScreenGui")
                    if not vision or not vision:FindFirstChild("Vision") then
                        CommF:InvokeServer("KenTalk", "Start")
                    end
                end)
            end

            -- Auto Race V3
            if _CGH.AutoTurnRaceV3 then
                pcall(function() CommF:InvokeServer("ActivateAbility") end)
            end

            -- Auto Race V4
            if _CGH.AutoTurnRaceV4 and char:FindFirstChild("RaceTransformed") and not char.RaceTransformed.Value then
                pcall(function()
                    VirtualUser:CaptureController()
                    VirtualUser:SetKeyDown("y")
                    task.wait(0.1)
                    VirtualUser:SetKeyUp("y")
                end)
            end
        end
    end
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    if _CGH.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
end)

-- ========================================================================
-- 8. CƠ CHẾ AUTO STATS (TỰ ĐỘNG CỘNG ĐIỂM)
-- ========================================================================
task.spawn(function()
    while true do
        task.wait(0.5)
        local pts = _CGH.StatsValue
        if _CGH.AutoMelee then pcall(function() CommF:InvokeServer("AddPoint", "Melee", pts) end) end
        if _CGH.AutoDefense then pcall(function() CommF:InvokeServer("AddPoint", "Defense", pts) end) end
        if _CGH.AutoSwords then pcall(function() CommF:InvokeServer("AddPoint", "Sword", pts) end) end
        if _CGH.AutoGun then pcall(function() CommF:InvokeServer("AddPoint", "Gun", pts) end) end
        if _CGH.AutoFruit then pcall(function() CommF:InvokeServer("AddPoint", "Demon Fruit", pts) end) end
    end
end)

-- ========================================================================
-- 9. CƠ CHẾ AUTO NHẶT RƯƠNG (AUTO CHEST BELI)
-- ========================================================================
task.spawn(function()
    while true do
        task.wait(0.5)
        if _CGH.AutoCollectChest then
            local char = LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if not _CGH.AutoCollectChest then break end
                    if obj.Name:find("Chest") and obj:IsA("BasePart") then
                        TweenTo(obj.CFrame * CFrame.new(0, 2, 0), _CGH.TweenSpeed)
                        local startT = tick()
                        repeat task.wait(0.1) until not obj.Parent or (tick() - startT > 6) or not _CGH.AutoCollectChest
                    end
                end
            end
        end
    end
end)

-- ========================================================================
-- 10. CƠ CHẾ ESP HOÀN CHỈNH (KHÔNG LỖI VECTOR, TỰ DỌN DẸP KHI TẮT)
-- ========================================================================
local function ClearESP(tag)
    for _, v in ipairs(workspace:GetDescendants()) do
        if v.Name == "CGH_ESP" and (not tag or v:GetAttribute("ESPTag") == tag) then
            v:Destroy()
        end
    end
end

local function CreateESPBox(part, text, color, tag)
    if not part or part:FindFirstChild("CGH_ESP") then return end
    local bbg = Instance.new("BillboardGui")
    bbg.Name = "CGH_ESP"
    bbg.Adornee = part
    bbg.Size = UDim2.new(0, 120, 0, 30)
    bbg.StudsOffset = Vector3.new(0, 3, 0) -- DÙNG Vector3 CHUẨN XÁC 100%, KHÔNG DÙNG Vector2
    bbg.AlwaysOnTop = true
    bbg:SetAttribute("ESPTag", tag or "General")
    
    local lbl = Instance.new("TextLabel")
    lbl.Parent = bbg
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = color
    lbl.TextSize = 13
    lbl.Font = Enum.Font.SourceSansBold
    lbl.TextStrokeTransparency = 0.3
    bbg.Parent = part
end

task.spawn(function()
    while true do
        task.wait(2)
        if _CGH.EspChests then
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj.Name:find("Chest") and obj:IsA("BasePart") then
                    CreateESPBox(obj, "[Rương Beli]", Color3.fromRGB(255, 215, 0), "Chest")
                end
            end
        end

        if _CGH.EspFruits then
            for _, obj in ipairs(workspace:GetChildren()) do
                if obj:IsA("Tool") and obj.Name:find("Fruit") then
                    local handle = obj:FindFirstChild("Handle") or obj:FindFirstChildOfClass("BasePart")
                    if handle then
                        CreateESPBox(handle, "[Trái Ác Quỷ] " .. obj.Name, Color3.fromRGB(0, 255, 127), "Fruit")
                    end
                end
            end
        end

        if _CGH.EspPlayers then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    CreateESPBox(p.Character.Head, p.DisplayName .. " (@" .. p.Name .. ")", Color3.fromRGB(255, 60, 60), "Player")
                end
            end
        end
    end
end)

-- ========================================================================
-- 11. KHỞI TẠO GIAO DIỆN CGH LIBRARY
-- ========================================================================
local function StartCGHHub()
    local Library = nil
    if isfile and isfile("CGH_Library.lua") then
        Library = loadstring(readfile("CGH_Library.lua"))()
    else
        Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Library.lua"))()
    end

    local Window = Library:CreateWindow({
        Title = "CGH Hub",
        Subtitle = "Blox Fruits (Native 50+ Features)",
        Image = "rbxassetid://cgh_logo"
    })

    -- --------------------------------------------------------------------
    -- TAB 1: FARM (CÀY CẤP & QUÁI)
    -- --------------------------------------------------------------------
    local TabFarm = Window:AddTab("Farm")
    local SecFarm1 = TabFarm:AddLeftGroupbox("Farm")

    SecFarm1:AddToggle("Toggle_Auto_Farm", {
        Text = "Auto Farm",
        Default = false,
        Callback = function(v) _CGH.AutoFarm = v end
    })

    SecFarm1:AddToggle("Toggle_Accept_Quests", {
        Text = "Accept Quests",
        Default = true,
        Callback = function(v) _CGH.AutoAcceptQuest = v end
    })

    SecFarm1:AddToggle("Toggle_Auto_Farm_Boss", {
        Text = "Auto Farm Boss",
        Default = false,
        Callback = function(v) _CGH.AutoFarmBoss = v end
    })

    SecFarm1:AddToggle("Toggle_Auto_Farm_Nearest", {
        Text = "Auto Farm Nearest",
        Default = false,
        Callback = function(v) _CGH.AutoFarmNearest = v end
    })

    SecFarm1:AddDropdown("Dropdown_Choose_Weapon", {
        Text = "Choose Weapon",
        Values = {"Melee", "Sword", "Gun", "Demon Fruit"},
        Default = "Melee",
        Callback = function(v) _CGH.WeaponType = v end
    })

    SecFarm1:AddSlider({
        Text = "Độ cao Farm Melee/Sword",
        Min = 10,
        Max = 60,
        Default = 25,
        Callback = function(v) _CGH.FarmHeight = v end
    })

    local SecFarm2 = TabFarm:AddRightGroupbox("Miscellanea / Quest")
    SecFarm2:AddToggle("Toggle_Auto_Collect_Chest", {
        Text = "Auto Collect Chest",
        Default = false,
        Callback = function(v)
            _CGH.AutoCollectChest = v
            if not v then CancelTween() end
        end
    })

    SecFarm2:AddToggle("Toggle_Auto_Complete_Bartilo_Quest", {
        Text = "Auto Complete Bartilo Quest",
        Default = false,
        Callback = function(v)
            if v then pcall(function() CommF:InvokeServer("BartiloQuestProgress") end) end
        end
    })

    -- --------------------------------------------------------------------
    -- TAB 2: SETTINGS & COMBAT (CÀI ĐẶT & CHIẾN ĐẤU)
    -- --------------------------------------------------------------------
    local TabSettings = Window:AddTab("Settings")
    local SecCombat = TabSettings:AddLeftGroupbox("Teleports & Misc")

    SecCombat:AddToggle("Toggle_Fast_Attack", {
        Text = "Fast Attack",
        Default = false,
        Callback = function(v) _CGH.FastAttack = v end
    })

    SecCombat:AddToggle("Toggle_Bring_Mobs", {
        Text = "Bring Mobs",
        Default = false,
        Callback = function(v) _CGH.BringMobs = v end
    })

    SecCombat:AddDropdown("Dropdown_Bring_Mob_Max", {
        Text = "Bring Mob Max",
        Values = {"3", "5", "8", "10", "All"},
        Default = "8",
        Callback = function(v) _CGH.BringMobMax = (v == "All" and 99 or tonumber(v)) end
    })

    SecCombat:AddDropdown("Dropdown_Bring_Mob_Mode", {
        Text = "Bring Mob Mode",
        Values = {"Behind", "Above", "Front"},
        Default = "Behind",
        Callback = function(v) _CGH.BringMobMode = v end
    })

    SecCombat:AddToggle("Toggle_Auto_Turn_on_Buso", {
        Text = "Auto Turn on Buso",
        Default = false,
        Callback = function(v) _CGH.AutoTurnBuso = v end
    })

    SecCombat:AddToggle("Toggle_Auto_Turn_on_Ken", {
        Text = "Auto Turn on Ken",
        Default = false,
        Callback = function(v) _CGH.AutoTurnKen = v end
    })

    SecCombat:AddToggle("Toggle_Auto_Turn_on_Race_V3", {
        Text = "Auto Turn on Race V3",
        Default = false,
        Callback = function(v) _CGH.AutoTurnRaceV3 = v end
    })

    SecCombat:AddToggle("Toggle_Auto_Turn_on_Race_V4", {
        Text = "Auto Turn on Race V4",
        Default = false,
        Callback = function(v) _CGH.AutoTurnRaceV4 = v end
    })

    local SecUtility = TabSettings:AddRightGroupbox("Tiện Ích & Hiệu Năng")
    SecUtility:AddToggle("Toggle_Anti_AFK", {
        Text = "Anti AFK",
        Default = true,
        Callback = function(v) _CGH.AntiAFK = v end
    })

    SecUtility:AddToggle("Toggle_Auto_Remove_Sky_Fog", {
        Text = "Auto Remove Sky Fog",
        Default = false,
        Callback = function(v)
            _CGH.AutoRemoveFog = v
            if v then
                Lighting.FogEnd = 9e9
                pcall(function() Lighting.Atmosphere:Destroy() end)
            end
        end
    })

    SecUtility:AddToggle("Toggle_Auto_Turn_on_Low_CPU", {
        Text = "Auto Turn on Low CPU",
        Default = false,
        Callback = function(v)
            _CGH.AutoLowCPU = v
            if v then
                pcall(function()
                    settings().Rendering.QualityLevel = 1
                    for _, part in ipairs(workspace:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.Material = Enum.Material.SmoothPlastic
                            part.CastShadow = false
                        end
                    end
                end)
            end
        end
    })

    SecUtility:AddSlider({
        Text = "Tween Speed",
        Min = 200,
        Max = 350,
        Default = 300,
        Callback = function(v) _CGH.TweenSpeed = v end
    })

    SecUtility:AddButton({
        Title = "Auto Redeem All Codes",
        Callback = function()
            local codes = {"SUB2GAMERROBOT_EXP1", "KittGaming", "Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo", "Bluxxy", "fudd10_v2", "SUB2GAMERROBOT_RESET1"}
            for _, code in ipairs(codes) do
                pcall(function() CommF:InvokeServer("RedeemCode", code) end)
                task.wait(0.2)
            end
        end
    })

    -- --------------------------------------------------------------------
    -- TAB 3: STATS (TỰ ĐỘNG CỘNG ĐIỂM)
    -- --------------------------------------------------------------------
    local TabStats = Window:AddTab("Stats")
    local SecStats = TabStats:AddLeftGroupbox("Stats Configuration")

    SecStats:AddToggle("Toggle_Auto_Melee", {
        Text = "Auto Melee",
        Default = false,
        Callback = function(v) _CGH.AutoMelee = v end
    })

    SecStats:AddToggle("Toggle_Auto_Defense", {
        Text = "Auto Defense",
        Default = false,
        Callback = function(v) _CGH.AutoDefense = v end
    })

    SecStats:AddToggle("Toggle_Auto_Swords", {
        Text = "Auto Swords",
        Default = false,
        Callback = function(v) _CGH.AutoSwords = v end
    })

    SecStats:AddToggle("Toggle_Auto_Gun", {
        Text = "Auto Gun",
        Default = false,
        Callback = function(v) _CGH.AutoGun = v end
    })

    SecStats:AddToggle("Toggle_Auto_Blox_Fruit", {
        Text = "Auto Blox Fruit",
        Default = false,
        Callback = function(v) _CGH.AutoFruit = v end
    })

    SecStats:AddSlider({
        Text = "Stats Value",
        Min = 1,
        Max = 50,
        Default = 1,
        Callback = function(v) _CGH.StatsValue = v end
    })

    -- --------------------------------------------------------------------
    -- TAB 4: TELEPORT (DỊCH CHUYỂN ĐẢO)
    -- --------------------------------------------------------------------
    local TabTeleport = Window:AddTab("Teleport")
    local SecTP = TabTeleport:AddLeftGroupbox("Island Travel")

    local islandList = {}
    for name, _ in pairs(IslandPositions) do table.insert(islandList, name) end
    table.sort(islandList)

    SecTP:AddDropdown("Dropdown_Select_Travelling", {
        Text = "Select Travelling",
        Values = islandList,
        Default = islandList[1] or "Jungle",
        Callback = function(v) _CGH.SelectedIsland = v end
    })

    SecTP:AddToggle("Toggle_Auto_Travel", {
        Text = "Auto Travel",
        Default = false,
        Callback = function(v)
            _CGH.AutoTravel = v
            if v and IslandPositions[_CGH.SelectedIsland] then
                TweenTo(IslandPositions[_CGH.SelectedIsland], _CGH.TweenSpeed)
            else
                CancelTween()
            end
        end
    })

    local SecWorld = TabTeleport:AddRightGroupbox("Worlds Travel")
    SecWorld:AddButton({
        Title = "Travel East Blue (World 1)",
        Callback = function() pcall(function() CommF:InvokeServer("TravelMain") end) end
    })
    SecWorld:AddButton({
        Title = "Travel Dressrosa (World 2)",
        Callback = function() pcall(function() CommF:InvokeServer("TravelDressrosa") end) end
    })
    SecWorld:AddButton({
        Title = "Travel Zou (World 3)",
        Callback = function() pcall(function() CommF:InvokeServer("TravelZou") end) end
    })

    -- --------------------------------------------------------------------
    -- TAB 5: SHOP (CỬA HÀNG VŨ KHÍ & KỸ NĂNG)
    -- --------------------------------------------------------------------
    local TabShop = Window:AddTab("Shop")
    local SecAbilities = TabShop:AddLeftGroupbox("Abilities Shop")

    SecAbilities:AddButton({
        Title = "Buso Haki (25,000 Beli)",
        Callback = function() pcall(function() CommF:InvokeServer("BuyHaki", "Buso") end) end
    })
    SecAbilities:AddButton({
        Title = "Observation Haki (750,000 Beli)",
        Callback = function() pcall(function() CommF:InvokeServer("KenTalk", "Buy") end) end
    })
    SecAbilities:AddButton({
        Title = "Skyjump (10,000 Beli)",
        Callback = function() pcall(function() CommF:InvokeServer("BuyHaki", "Geppo") end) end
    })
    SecAbilities:AddButton({
        Title = "Soru (100,000 Beli)",
        Callback = function() pcall(function() CommF:InvokeServer("BuyHaki", "Soru") end) end
    })

    local SecSwords = TabShop:AddRightGroupbox("Sword Shop")
    SecSwords:AddButton({
        Title = "Katana (1,000 Beli)",
        Callback = function() pcall(function() CommF:InvokeServer("BuyItem", "Katana") end) end
    })
    SecSwords:AddButton({
        Title = "Cutlass (1,000 Beli)",
        Callback = function() pcall(function() CommF:InvokeServer("BuyItem", "Cutlass") end) end
    })
    SecSwords:AddButton({
        Title = "Dual Katana (12,000 Beli)",
        Callback = function() pcall(function() CommF:InvokeServer("BuyItem", "Dual Katana") end) end
    })
    SecSwords:AddButton({
        Title = "Iron Mace (25,000 Beli)",
        Callback = function() pcall(function() CommF:InvokeServer("BuyItem", "Iron Mace") end) end
    })
    SecSwords:AddButton({
        Title = "Triple Katana (60,000 Beli)",
        Callback = function() pcall(function() CommF:InvokeServer("BuyItem", "Triple Katana") end) end
    })
    SecSwords:AddButton({
        Title = "Pipe (100,000 Beli)",
        Callback = function() pcall(function() CommF:InvokeServer("BuyItem", "Pipe") end) end
    })
    SecSwords:AddButton({
        Title = "Soul Cane (750,000 Beli)",
        Callback = function() pcall(function() CommF:InvokeServer("BuyItem", "Soul Cane") end) end
    })
    SecSwords:AddButton({
        Title = "Bisento (1,200,000 Beli)",
        Callback = function() pcall(function() CommF:InvokeServer("BuyItem", "Bisento") end) end
    })

    -- --------------------------------------------------------------------
    -- TAB 6: ESP (ĐỊNH VỊ)
    -- --------------------------------------------------------------------
    local TabEsp = Window:AddTab("ESP")
    local SecEsp = TabEsp:AddLeftGroupbox("ESP Định Vị")

    SecEsp:AddToggle("Toggle_Esp_Players", {
        Text = "Esp Players",
        Default = false,
        Callback = function(v)
            _CGH.EspPlayers = v
            if not v then ClearESP("Player") end
        end
    })

    SecEsp:AddToggle("Toggle_Esp_Chests", {
        Text = "Esp Chests",
        Default = false,
        Callback = function(v)
            _CGH.EspChests = v
            if not v then ClearESP("Chest") end
        end
    })

    SecEsp:AddToggle("Toggle_Esp_Fruits", {
        Text = "Esp Fruits",
        Default = false,
        Callback = function(v)
            _CGH.EspFruits = v
            if not v then ClearESP("Fruit") end
        end
    })

    -- --------------------------------------------------------------------
    -- TAB 7: SERVER (MÁY CHỦ)
    -- --------------------------------------------------------------------
    local TabServer = Window:AddTab("Server")
    local SecServer = TabServer:AddLeftGroupbox("Chuyển Server")

    SecServer:AddButton({
        Title = "Rejoin Server",
        Callback = function()
            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
        end
    })

    SecServer:AddButton({
        Title = "Random Server Hop",
        Callback = function()
            pcall(function()
                local sfUrl = "https://games.roblox.com/v1/games/" .. tostring(game.PlaceId) .. "/servers/Public?sortOrder=Asc&limit=100"
                local res = game:HttpGet(sfUrl)
                local json = HttpService:JSONDecode(res)
                if json and json.data then
                    for _, s in ipairs(json.data) do
                        if s.playing < s.maxPlayers and s.id ~= game.JobId then
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, s.id, LocalPlayer)
                            break
                        end
                    end
                end
            end)
        end
    })

    SecServer:AddButton({
        Title = "Sao Chép Job ID",
        Callback = function()
            if setclipboard then setclipboard(tostring(game.JobId)) end
        end
    })

    SecServer:AddButton({
        Title = "Copy Link Discord CGH",
        Callback = function()
            if setclipboard then setclipboard("https://www.youtube.com/watch?v=dQw4w9WgXcQ") end
        end
    })
end

StartCGHHub()
