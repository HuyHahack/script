--[[
    ========================================================================
                      CGH HUB — NATIVE BLOX FRUITS CORE
                      100% Mã nguồn sạch — Zero Luraph VM
    ========================================================================
--]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")

local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF = Remotes:WaitForChild("CommF_")

-- ========================================================================
-- 1. BỘ QUẢN LÝ CẤU HÌNH & TRẠNG THÁI (CONFIG)
-- ========================================================================
local CGH_Config = {
    AutoBuso = false,
    FastAttack = false,
    AttackSpeed = 0.1,
    AttackDistance = 55,
    AutoChest = false,
    AutoFarmLevel = false,
    SelectedWeapon = "Melee",
    Noclip = false
}

-- ========================================================================
-- 2. HỆ THỐNG DI CHUYỂN & NOCLIP AN TOÀN (TWEEN & NOCLIP ENGINE)
-- ========================================================================
local currentTween = nil

local function CancelTween()
    if currentTween then
        currentTween:Cancel()
        currentTween = nil
    end
end

local function TweenTo(targetCFrame, speed)
    local character = LocalPlayer.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    local rootPart = character.HumanoidRootPart

    local distance = (rootPart.Position - targetCFrame.Position).Magnitude
    speed = speed or 300
    local tweenDuration = distance / speed

    CancelTween()
    local tweenInfo = TweenInfo.new(tweenDuration, Enum.EasingStyle.Linear)
    currentTween = TweenService:Create(rootPart, tweenInfo, {CFrame = targetCFrame})
    currentTween:Play()
    return currentTween
end

-- Vòng lặp Noclip giữ nhân vật không bị kẹt địa hình khi bay
RunService.Stepped:Connect(function()
    if CGH_Config.Noclip or CGH_Config.AutoChest or CGH_Config.AutoFarmLevel then
        local character = LocalPlayer.Character
        if character then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end
    end
end)

-- ========================================================================
-- 3. TÍNH NĂNG: FAST ATTACK (TỰ ĐỘNG ĐÁNH TỐC ĐỘ CAO)
-- ========================================================================
local function EquipWeapon(weaponType)
    local character = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    if not character or not backpack then return end

    for _, item in ipairs(backpack:GetChildren()) do
        if item:IsA("Tool") then
            if weaponType == "Melee" and item.ToolTip == "Melee" then
                character.Humanoid:EquipTool(item)
                break
            elseif weaponType == "Sword" and item.ToolTip == "Sword" then
                character.Humanoid:EquipTool(item)
                break
            end
        end
    end
end

task.spawn(function()
    while true do
        task.wait(CGH_Config.AttackSpeed)
        if CGH_Config.FastAttack then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local rootPos = character.HumanoidRootPart.Position
                local tool = character:FindFirstChildOfClass("Tool")
                
                -- Tìm quái gần nhất trong bán kính
                local enemies = workspace:FindFirstChild("Enemies")
                if enemies then
                    for _, enemy in ipairs(enemies:GetChildren()) do
                        local enemyHumanoid = enemy:FindFirstChild("Humanoid")
                        local enemyRoot = enemy:FindFirstChild("HumanoidRootPart")
                        if enemyHumanoid and enemyHumanoid.Health > 0 and enemyRoot then
                            local dist = (enemyRoot.Position - rootPos).Magnitude
                            if dist <= CGH_Config.AttackDistance then
                                if tool then
                                    tool:Activate()
                                else
                                    EquipWeapon(CGH_Config.SelectedWeapon)
                                end
                                -- Giả lập tương tác click ảo để kích hoạt animation
                                VirtualUser:CaptureController()
                                VirtualUser:ClickButton1(Vector2.new(500, 500))
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ========================================================================
-- 4. TÍNH NĂNG: AUTO BUSO HAKI (AURA)
-- ========================================================================
task.spawn(function()
    while true do
        task.wait(2)
        if CGH_Config.AutoBuso then
            local character = LocalPlayer.Character
            if character and not character:FindFirstChild("HasBuso") then
                pcall(function()
                    CommF:InvokeServer("Buso")
                end)
            end
        end
    end
end)

-- ========================================================================
-- 5. TÍNH NĂNG: AUTO NHẶT RƯƠNG (AUTO CHEST BELI)
-- ========================================================================
task.spawn(function()
    while true do
        task.wait(0.5)
        if CGH_Config.AutoChest then
            local character = LocalPlayer.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                local chests = {}
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj.Name:find("Chest") and obj:IsA("BasePart") then
                        table.insert(chests, obj)
                    end
                end
                
                for _, chest in ipairs(chests) do
                    if not CGH_Config.AutoChest then break end
                    if chest and chest.Parent then
                        TweenTo(chest.CFrame * CFrame.new(0, 2, 0), 320)
                        local startTime = tick()
                        repeat
                            task.wait(0.1)
                        until not chest.Parent or (tick() - startTime > 7) or not CGH_Config.AutoChest
                    end
                end
            end
        end
    end
end)

-- ========================================================================
-- 6. TÍCH HỢP GIAO DIỆN CGH LIBRARY
-- ========================================================================
local function InitCGHInterface()
    -- Nạp giao diện sạch từ GitHub của paneer
    local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Library.lua"))()
    
    local Window = Library:CreateWindow({
        Title = "CGH Hub — Blox Fruits (Native Core)",
        Subtitle = "Bản mã nguồn sạch 100% — Zero Luraph",
        Image = "rbxassetid://cgh_logo"
    })

    -- TAB 1: AUTO FARM & COMBAT
    local TabMain = Window:AddTab("Auto Farm")
    local SecFarm = TabMain:AddLeftGroupbox("Chiến Đấu & Farm")

    SecFarm:AddToggle({
        Text = "Fast Attack (Tốc Đánh Cực Nhanh)",
        Default = false,
        Callback = function(val)
            CGH_Config.FastAttack = val
        end
    })

    SecFarm:AddToggle({
        Text = "Auto Bật Buso Haki (Aura)",
        Default = false,
        Callback = function(val)
            CGH_Config.AutoBuso = val
        end
    })

    SecFarm:AddDropdown({
        Text = "Vũ Khí Farm",
        Values = {"Melee", "Sword"},
        Default = "Melee",
        Callback = function(val)
            CGH_Config.SelectedWeapon = val
        end
    })

    SecFarm:AddSlider({
        Text = "Khoảng Cách Đánh",
        Min = 20,
        Max = 80,
        Default = 55,
        Callback = function(val)
            CGH_Config.AttackDistance = val
        end
    })

    -- TAB 2: TIỆN ÍCH & NHẶT RƯƠNG
    local TabMisc = Window:AddTab("Tiện Ích")
    local SecChest = TabMisc:AddLeftGroupbox("Nhặt Tiền & Teleport")

    SecChest:AddToggle({
        Text = "Auto Nhặt Rương (Beli Chest)",
        Default = false,
        Callback = function(val)
            CGH_Config.AutoChest = val
            if not val then CancelTween() end
        end
    })

    SecChest:AddToggle({
        Text = "Noclip Xuyên Tường",
        Default = false,
        Callback = function(val)
            CGH_Config.Noclip = val
        end
    })

    local SecDiscord = TabMisc:AddRightGroupbox("Cộng Đồng")
    SecDiscord:AddButton({
        Title = "Copy Link Discord CGH",
        Callback = function()
            if setclipboard then
                setclipboard("https://www.youtube.com/watch?v=dQw4w9WgXcQ")
            end
        end
    })
end

-- Khởi động hệ thống
InitCGHInterface()
