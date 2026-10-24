--[[
    =======================================================
               CGH HUB - BYPASS KEY SYSTEM LIB
       Tự động vô hình hóa 100% giao diện nhập key
       Tự động kích hoạt luồng auth thành công vĩnh viễn
    =======================================================
--]]

local TrauHubLib = {}

TrauHubLib.Colors = {
    Blue1 = Color3.fromRGB(41, 128, 185),
    Blue2 = Color3.fromRGB(52, 152, 219),
    Blue3 = Color3.fromRGB(30, 96, 145),
    Cyan = Color3.fromRGB(26, 188, 156),
    Purple = Color3.fromRGB(155, 89, 182),
    Orange = Color3.fromRGB(230, 126, 34),
    Red = Color3.fromRGB(231, 76, 60),
    Background = Color3.fromRGB(15, 20, 30),
    Surface = Color3.fromRGB(25, 35, 50),
    TextGray = Color3.fromRGB(149, 165, 166)
}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

function TrauHubLib:Tween(object, properties, duration, style, direction)
    local info = TweenInfo.new(duration or 0.1, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

function TrauHubLib:CreateParticles(parent)
    local particles = Instance.new("Frame")
    particles.Name = "Particles"
    particles.Parent = parent
    return particles
end

function TrauHubLib:CreateModernButton(parent, text, position, size, color1, color2)
    local button = Instance.new("TextButton")
    button.Name = text or "ModernButton"
    button.Position = position or UDim2.new(0, 0, 0, 0)
    button.Size = size or UDim2.new(0, 100, 0, 30)
    button.Text = text or ""
    button.Parent = parent
    return button
end

function TrauHubLib:CreateUI(config)
    print("[+] CGH Key System Hook: Bat duoc yeu cau tao Key GUI -> Tu dong bypass va an GUI...")
    
    -- ScreenGui hoàn toàn tàng hình (Enabled = false) để người dùng không bao giờ thấy bảng xanh
    local gui = Instance.new("ScreenGui")
    gui.Name = "TrauHubKeySystem"
    gui.ResetOnSpawn = false
    gui.Enabled = false
    gui.Parent = playerGui
    
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Parent = gui
    
    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Text = "CGH_PERMANENT_KEY_2099"
    keyInput.Parent = container
    
    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Name = "GetKeyBtn"
    getKeyBtn.Parent = container
    
    local checkKeyBtn = Instance.new("TextButton")
    checkKeyBtn.Name = "CheckKeyBtn"
    checkKeyBtn.Text = "Kiểm Tra Key"
    checkKeyBtn.Parent = container
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.Text = "Xác thực thành công!"
    statusLabel.Parent = container
    
    self.UI = {
        ScreenGui = gui,
        Container = container,
        KeyInput = keyInput,
        GetKeyBtn = getKeyBtn,
        CheckKeyBtn = checkKeyBtn,
        StatusLabel = statusLabel
    }
    
    -- Tự động kích hoạt nút Kiểm Tra Key sau 0.2 giây để luồng auth của script tự hoàn thành
    task.spawn(function()
        task.wait(0.2)
        pcall(function()
            if getconnections then
                for _, conn in ipairs(getconnections(checkKeyBtn.MouseButton1Click)) do
                    conn:Fire()
                end
            end
        end)
    end)
    
    return gui
end

return TrauHubLib
