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

local PERMANENT_KEY = "CGH_PERMANENT_KEYLESS_AUTH_2099"

-- Tự động đảm bảo các file key luôn sẵn sàng
pcall(function()
    local keyFiles = {
        "TrauHub_Save.txt",
        "RealKid_Key_" .. tostring(game.PlaceId) .. ".txt",
        "RealKid_Key_100117331123089.txt",
        "RealKid_Key_11348033272.txt",
        "RealKid_Key_11584810072.txt",
        "RealKid_Key_79091703265657.txt",
        "CGH_Key.txt"
    }
    for _, f in ipairs(keyFiles) do
        if writefile then
            writefile(f, PERMANENT_KEY)
        end
    end
end)

function TrauHubLib:Tween(object, properties, duration, style, direction)
    local info = TweenInfo.new(duration or 0.3, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, info, properties)
    tween:Play()
    return tween
end

function TrauHubLib:CreateParticles(parent)
    local particles = Instance.new("Frame")
    particles.Name = "Particles"
    particles.Size = UDim2.new(1, 0, 1, 0)
    particles.BackgroundTransparency = 1
    particles.ZIndex = 0
    particles.Parent = parent
end

function TrauHubLib:CreateUI(config)
    print("[+] CGH Key System: Kich hoat che do tu dong bypass keyless...")

    local gui = Instance.new("ScreenGui")
    gui.Name = "TrauHubKeySystem"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Enabled = false -- An hoan toan giao dien key goc
    gui.Parent = playerGui
    
    local container = Instance.new("Frame")
    container.Name = "Container"
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    container.Size = UDim2.new(0, 0, 0, 0)
    container.BackgroundColor3 = self.Colors.Surface
    container.BorderSizePixel = 0
    container.ClipsDescendants = true
    container.Parent = gui
    
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 90)
    header.BackgroundColor3 = self.Colors.Blue1
    header.BorderSizePixel = 0
    header.Parent = container
    
    local content = Instance.new("Frame")
    content.Name = "Content"
    content.Position = UDim2.new(0, 30, 0, 110)
    content.Size = UDim2.new(1, -60, 1, -140)
    content.BackgroundTransparency = 1
    content.Parent = container
    
    local inputContainer = Instance.new("Frame")
    inputContainer.Name = "InputContainer"
    inputContainer.Position = UDim2.new(0, 0, 0, 10)
    inputContainer.Size = UDim2.new(1, 0, 0, 45)
    inputContainer.BackgroundColor3 = self.Colors.Background
    inputContainer.BorderSizePixel = 0
    inputContainer.ClipsDescendants = true
    inputContainer.Parent = content
    
    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Position = UDim2.new(0, 15, 0, 0)
    keyInput.Size = UDim2.new(1, -30, 1, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.Font = Enum.Font.GothamMedium
    keyInput.PlaceholderText = "CGH Keyless Mode"
    keyInput.Text = PERMANENT_KEY -- Luon luon co san key hop le
    keyInput.TextColor3 = Color3.new(1, 1, 1)
    keyInput.TextSize = 14
    keyInput.TextXAlignment = Enum.TextXAlignment.Left
    keyInput.TextWrapped = false
    keyInput.ClipsDescendants = true
    keyInput.ClearTextOnFocus = false
    keyInput.Parent = inputContainer
    
    local buttonsFrame = Instance.new("Frame")
    buttonsFrame.Name = "Buttons"
    buttonsFrame.Position = UDim2.new(0, 0, 0, 75)
    buttonsFrame.Size = UDim2.new(1, 0, 0, 95)
    buttonsFrame.BackgroundTransparency = 1
    buttonsFrame.Parent = content
    
    local getKeyBtn = self:CreateModernButton(
        buttonsFrame,
        "Lấy Key",
        UDim2.new(0, 0, 0, 0),
        UDim2.new(1, 0, 0, 42),
        self.Colors.Purple,
        self.Colors.Blue1
    )
    
    local checkKeyBtn = self:CreateModernButton(
        buttonsFrame,
        "Kiểm Tra Key",
        UDim2.new(0, 0, 0, 52),
        UDim2.new(1, 0, 0, 42),
        self.Colors.Cyan,
        self.Colors.Blue3
    )
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "Status"
    statusLabel.Position = UDim2.new(0, 0, 1, 0)
    statusLabel.Size = UDim2.new(1, 0, 0, 20)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.Text = "CGH Hub: Keyless Authorized!"
    statusLabel.TextColor3 = self.Colors.Cyan
    statusLabel.TextSize = 12
    statusLabel.Parent = content
    
    self.UI = {
        ScreenGui = gui,
        Container = container,
        KeyInput = keyInput,
        GetKeyBtn = getKeyBtn,
        CheckKeyBtn = checkKeyBtn,
        StatusLabel = statusLabel
    }

    -- Co che tu dong click Nut Kiem Tra Key de script tien hanh xac thuc ngay lap tuc
    local authCallbacks = {}
    local origConnect = checkKeyBtn.MouseButton1Click.Connect
    pcall(function()
        hookfunction(checkKeyBtn.MouseButton1Click.Connect, function(self, fn)
            table.insert(authCallbacks, fn)
            task.defer(function()
                keyInput.Text = PERMANENT_KEY
                task.wait(0.05)
                pcall(fn)
            end)
            return origConnect(self, fn)
        end)
    end)

    -- Vong lap kich hoat fail-safe: lien tuc fire su kien click trong 3 giay dau
    task.spawn(function()
        for i = 1, 30 do
            task.wait(0.1)
            keyInput.Text = PERMANENT_KEY
            for _, fn in ipairs(authCallbacks) do
                pcall(fn)
            end
            if firesignal then
                pcall(firesignal, checkKeyBtn.MouseButton1Click)
            end
            if getconnections then
                for _, conn in ipairs(getconnections(checkKeyBtn.MouseButton1Click)) do
                    pcall(function() conn:Fire() end)
                end
            end
        end
    end)
    
    return gui
end

function TrauHubLib:CreateModernButton(parent, text, position, size, color1, color2)
    local button = Instance.new("TextButton")
    button.Position = position
    button.Size = size
    button.BackgroundColor3 = color1
    button.BorderSizePixel = 0
    button.Font = Enum.Font.GothamBold
    button.Text = text
    button.TextColor3 = Color3.new(1, 1, 1)
    button.TextSize = 14
    button.AutoButtonColor = false
    button.ClipsDescendants = true
    button.Parent = parent
    return button
end

return TrauHubLib
