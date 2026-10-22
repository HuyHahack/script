--[[
    =======================================================
                        CGH HUB
               Blox Fruits - Vietnam Edition
           Repository: https://github.com/HuyHahack/script
    =======================================================
--]]

-- [1. TỰ ĐỘNG TẢI VÀ CACHE LOGO CỜ VIỆT NAM]
pcall(function()
    if writefile and (not isfile or not isfile("cgh_logo.png")) then
        local imgData = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/cgh_logo.png")
        writefile("cgh_logo.png", imgData)
    end
end)

local function getCustomLogo()
    if isfile and isfile("cgh_logo.png") and getcustomasset then
        return getcustomasset("cgh_logo.png")
    end
    return "rbxassetid://96220014754961"
end

-- [2. HOOK SETCLIPBOARD: MỌI LINK DISCORD ĐỀU THÀNH RICK ROLL]
local RICK_ROLL = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
if setclipboard then
    local orig_setclipboard = setclipboard
    setclipboard = function(text)
        if type(text) == "string" and (string.find(text, "discord%.gg") or string.find(text, "discord%.com")) then
            return orig_setclipboard(RICK_ROLL)
        end
        return orig_setclipboard(text)
    end
end

-- [3. GIAO DIỆN AUTH / KEY SYSTEM CHO CGH HUB]
local function StartCGHKeySystem(onSuccess)
    local CoreGui = game:GetService("CoreGui")
    local TweenService = game:GetService("TweenService")

    if CoreGui:FindFirstChild("CGH_Auth_GUI") then
        CoreGui.CGH_Auth_GUI:Destroy()
    end

    local AuthGui = Instance.new("ScreenGui")
    AuthGui.Name = "CGH_Auth_GUI"
    AuthGui.Parent = CoreGui
    AuthGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.Parent = AuthGui
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 360, 0, 220)
    Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Main.BorderSizePixel = 0

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Main

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(220, 20, 40)
    UIStroke.Thickness = 2
    UIStroke.Parent = Main

    local Logo = Instance.new("ImageLabel")
    Logo.Name = "Logo"
    Logo.Parent = Main
    Logo.Position = UDim2.new(0, 20, 0, 15)
    Logo.Size = UDim2.new(0, 40, 0, 40)
    Logo.BackgroundTransparency = 1
    Logo.Image = getCustomLogo()

    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 8)
    LogoCorner.Parent = Logo

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Main
    Title.Position = UDim2.new(0, 70, 0, 15)
    Title.Size = UDim2.new(0, 200, 0, 25)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = "CGH HUB - AUTH"
    Title.TextColor3 = Color3.fromRGB(255, 215, 0)
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Parent = Main
    SubTitle.Position = UDim2.new(0, 70, 0, 38)
    SubTitle.Size = UDim2.new(0, 200, 0, 15)
    SubTitle.BackgroundTransparency = 1
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.Text = "Nhập bất kỳ key nào để kích hoạt"
    SubTitle.TextColor3 = Color3.fromRGB(160, 160, 160)
    SubTitle.TextSize = 12
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left

    local KeyBoxFrame = Instance.new("Frame")
    KeyBoxFrame.Parent = Main
    KeyBoxFrame.Position = UDim2.new(0, 20, 0, 75)
    KeyBoxFrame.Size = UDim2.new(1, -40, 0, 40)
    KeyBoxFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 34)

    local KeyBoxCorner = Instance.new("UICorner")
    KeyBoxCorner.CornerRadius = UDim.new(0, 6)
    KeyBoxCorner.Parent = KeyBoxFrame

    local KeyBox = Instance.new("TextBox")
    KeyBox.Parent = KeyBoxFrame
    KeyBox.Size = UDim2.new(1, -20, 1, 0)
    KeyBox.Position = UDim2.new(0, 10, 0, 0)
    KeyBox.BackgroundTransparency = 1
    KeyBox.Font = Enum.Font.GothamMedium
    KeyBox.PlaceholderText = "Nhập Key tại đây..."
    KeyBox.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
    KeyBox.Text = isfile and isfile("CGH_Key.txt") and readfile("CGH_Key.txt") or ""
    KeyBox.TextColor3 = Color3.fromRGB(240, 240, 240)
    KeyBox.TextSize = 14

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Parent = Main
    SubmitBtn.Position = UDim2.new(0, 20, 0, 130)
    SubmitBtn.Size = UDim2.new(0.5, -25, 0, 38)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(220, 30, 40)
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Text = "SUBMIT KEY"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 14

    local SubmitCorner = Instance.new("UICorner")
    SubmitCorner.CornerRadius = UDim.new(0, 6)
    SubmitCorner.Parent = SubmitBtn

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Parent = Main
    GetKeyBtn.Position = UDim2.new(0.5, 5, 0, 130)
    GetKeyBtn.Size = UDim2.new(0.5, -25, 0, 38)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 46)
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.Text = "GET KEY (FREE)"
    GetKeyBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
    GetKeyBtn.TextSize = 13

    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 6)
    GetKeyCorner.Parent = GetKeyBtn

    local StatusText = Instance.new("TextLabel")
    StatusText.Parent = Main
    StatusText.Position = UDim2.new(0, 20, 0, 180)
    StatusText.Size = UDim2.new(1, -40, 0, 20)
    StatusText.BackgroundTransparency = 1
    StatusText.Font = Enum.Font.Gotham
    StatusText.Text = "Hệ thống Auth CGH sẵn sàng."
    StatusText.TextColor3 = Color3.fromRGB(150, 150, 150)
    StatusText.TextSize = 12

    SubmitBtn.MouseButton1Click:Connect(function()
        local input = KeyBox.Text
        StatusText.Text = "Đang xác thực..."
        StatusText.TextColor3 = Color3.fromRGB(255, 215, 0)
        task.wait(0.3)

        if writefile then writefile("CGH_Key.txt", input) end
        StatusText.Text = "Key hợp lệ! Đang mở CGH Hub..."
        StatusText.TextColor3 = Color3.fromRGB(50, 220, 100)
        task.wait(0.5)

        TweenService:Create(Main, TweenInfo.new(0.3), { Position = UDim2.new(0.5, 0, 0.4, 0), BackgroundTransparency = 1 }):Play()
        task.wait(0.3)
        AuthGui:Destroy()
        onSuccess()
    end)

    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(RICK_ROLL)
            StatusText.Text = "Đã copy link Rickroll vào clipboard!"
            StatusText.TextColor3 = Color3.fromRGB(0, 180, 255)
        end
    end)
end

-- [4. KHỞI CHẠY VÀ HOOK CHUYỂN HƯỚNG SANG CGH_LIBRARY SẠCH]
StartCGHKeySystem(function()
    print("[+] CGH Auth passed. Đang khởi chạy Blox Fruits engine...")

    -- Hook loadstring: Ép toàn bộ UI sang CGH_Library.lua sạch
    local orig_loadstring
    orig_loadstring = hookfunction(loadstring, function(src, chunkname, ...)
        if type(src) == "string" and (string.find(src, "Nousigi Hub") or string.find(src, "dut dit") or string.find(src, "T1UIColor")) then
            print("[+] Intercepted UI Library! Chuyển hướng sang CGH_Library...")
            local customLib
            if isfile and isfile("CGH_Library.lua") then
                customLib = readfile("CGH_Library.lua")
            else
                customLib = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Library.lua")
            end
            return orig_loadstring(customLib)
        end
        
        if chunkname ~= nil then
            return orig_loadstring(src, chunkname, ...)
        else
            return orig_loadstring(src)
        end
    end)

    -- [5. HỆ THỐNG AUTO-UPDATE NÂNG CAO]
    -- Ưu tiên tải bản Blox Fruits mới nhất từ CDN gốc (tự gọt sạch backdoor), nếu lỗi sẽ tự fallback về bản lưu trên GitHub
    local coreScript = nil
    
    local success, liveScript = pcall(function()
        return game:HttpGet("https://cdnrealkidhub.pages.dev/BloxFruits.lua")
    end)
    
    if success and liveScript and #liveScript > 1000 then
        -- Tự động gọt sạch đoạn backdoor trauroblox/anhdomixi nếu có ở đầu
        local pos = liveScript:find("%-%- This file was protected")
        if pos then
            coreScript = liveScript:sub(pos)
            print("[+] Đã tự động cập nhật bản Blox Fruits mới nhất từ Live CDN!")
        else
            coreScript = liveScript
        end
    end
    
    -- Fallback về bản tĩnh trên GitHub nếu Live CDN bị chặn hoặc lỗi
    if not coreScript or #coreScript < 1000 then
        print("[*] Live CDN không phản hồi, đang chuyển sang bản lưu GitHub...")
        if isfile and isfile("BloxFruits_Core.luau") then
            coreScript = readfile("BloxFruits_Core.luau")
        else
            coreScript = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/BloxFruits_Core.luau")
        end
    end

    if coreScript and #coreScript > 100 then
        local fn, err = loadstring(coreScript)
        if fn then
            fn()
            print("[+] CGH Hub Blox Fruits đã kích hoạt thành công!")
        else
            warn("[!] Lỗi compile BloxFruits_Core: " .. tostring(err))
        end
    else
        warn("[!] Không thể tải BloxFruits_Core.luau!")
    end
end)
