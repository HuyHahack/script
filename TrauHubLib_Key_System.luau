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
    
    for i = 1, 10 do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(3, 6), 0, math.random(3, 6))
        particle.Position = UDim2.new(math.random(0, 100) / 100, 0, math.random(0, 100) / 100, 0)
        particle.BackgroundColor3 = self.Colors.Blue2
        particle.BackgroundTransparency = math.random(60, 90) / 100
        particle.BorderSizePixel = 0
        particle.Parent = particles
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = particle
        
        task.spawn(function()
            while particle.Parent do
                local duration = math.random(3, 6)
                local y = math.random(-30, 30)
                self:Tween(particle, {
                    Position = particle.Position + UDim2.new(0, 0, 0, y)
                }, duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
                task.wait(duration)
            end
        end)
    end
end

function TrauHubLib:CreateUI(config)
    local gui = Instance.new("ScreenGui")
    gui.Name = "TrauHubKeySystem"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
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
    
    local containerCorner = Instance.new("UICorner")
    containerCorner.CornerRadius = UDim.new(0, 16)
    containerCorner.Parent = container
    
    self:CreateParticles(container)
    
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 90)
    header.BackgroundColor3 = self.Colors.Blue1
    header.BorderSizePixel = 0
    header.Parent = container
    
    local headerGradient = Instance.new("UIGradient")
    headerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, self.Colors.Blue1),
        ColorSequenceKeypoint.new(1, self.Colors.Blue3)
    })
    headerGradient.Rotation = 45
    headerGradient.Parent = header
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 16)
    headerCorner.Parent = header
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.AnchorPoint = Vector2.new(1, 0)
    closeBtn.Position = UDim2.new(1, -10, 0, 10)
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.Text = "X"
    closeBtn.TextColor3 = self.Colors.Red
    closeBtn.TextSize = 16
    closeBtn.Parent = header
    
    closeBtn.MouseEnter:Connect(function()
        self:Tween(closeBtn, {TextColor3 = Color3.new(1, 1, 1)}, 0.2)
    end)
    closeBtn.MouseLeave:Connect(function()
        self:Tween(closeBtn, {TextColor3 = self.Colors.Red}, 0.2)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        self:Tween(container, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        task.wait(0.4)
        gui:Destroy()
    end)
    
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Position = UDim2.new(0, 0, 0, 20)
    title.Size = UDim2.new(1, 0, 0, 30)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = config.Title
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextSize = 22
    title.Parent = header
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Position = UDim2.new(0, 0, 0, 50)
    subtitle.Size = UDim2.new(1, 0, 0, 20)
    subtitle.BackgroundTransparency = 1
    subtitle.Font = Enum.Font.GothamMedium
    subtitle.Text = config.Subtitle
    subtitle.TextColor3 = Color3.new(0.9, 0.9, 0.9)
    subtitle.TextSize = 13
    subtitle.Parent = header
    
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
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = inputContainer
    
    local inputStroke = Instance.new("UIStroke")
    inputStroke.Color = self.Colors.Blue1
    inputStroke.Thickness = 2
    inputStroke.Transparency = 0.7
    inputStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    inputStroke.Parent = inputContainer
    
    local keyInput = Instance.new("TextBox")
    keyInput.Name = "KeyInput"
    keyInput.Position = UDim2.new(0, 15, 0, 0)
    keyInput.Size = UDim2.new(1, -30, 1, 0)
    keyInput.BackgroundTransparency = 1
    keyInput.Font = Enum.Font.GothamMedium
    keyInput.PlaceholderText = "Nhập key của bạn..."
    keyInput.PlaceholderColor3 = self.Colors.TextGray
    keyInput.Text = ""
    keyInput.TextColor3 = Color3.new(1, 1, 1)
    keyInput.TextSize = 14
    keyInput.TextXAlignment = Enum.TextXAlignment.Left
    keyInput.TextWrapped = false
    keyInput.ClipsDescendants = true
    keyInput.ClearTextOnFocus = false
    keyInput.Parent = inputContainer
    
    keyInput.Focused:Connect(function()
        self:Tween(inputStroke, {Transparency = 0}, 0.2)
    end)
    
    keyInput.FocusLost:Connect(function()
        self:Tween(inputStroke, {Transparency = 0.7}, 0.2)
    end)
    
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
    statusLabel.Text = ""
    statusLabel.TextColor3 = self.Colors.TextGray
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
    
    self:Tween(container, {
        Size = UDim2.new(0, 360, 0, 320)
    }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    
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
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = button
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })
    gradient.Rotation = 45
    gradient.Parent = button
    
    button.MouseEnter:Connect(function()
        self:Tween(button, {
            Size = size + UDim2.new(0, 4, 0, 2)
        }, 0.2, Enum.EasingStyle.Quad)
    end)
    
    button.MouseLeave:Connect(function()
        self:Tween(button, {
            Size = size
        }, 0.2, Enum.EasingStyle.Quad)
    end)
    
    button.MouseButton1Down:Connect(function()
        self:Tween(button, {
            Size = size - UDim2.new(0, 2, 0, 2)
        }, 0.1, Enum.EasingStyle.Quad)
    end)
    
    button.MouseButton1Up:Connect(function()
        self:Tween(button, {
            Size = size + UDim2.new(0, 4, 0, 2)
        }, 0.1, Enum.EasingStyle.Quad)
    end)
    
    return button
end

return TrauHubLib
