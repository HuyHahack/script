--[[
    =======================================================
                        CGH HUB
               Blox Fruits - Vietnam Edition
           Repository: https://github.com/HuyHahack/script
    =======================================================
--]]

-- [1. TỰ ĐỘNG TẢI VÀ CACHE LOGO CỜ VIỆT NAM & THƯ VIỆN UI]
pcall(function()
    if writefile and (not isfile or not isfile("cgh_logo.png")) then
        local imgData = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/cgh_logo.png")
        writefile("cgh_logo.png", imgData)
    end
end)

pcall(function()
    if writefile and (not isfile or not isfile("CGH_Library.lua")) then
        local libData = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Library.lua?t=" .. tostring(os.time()))
        writefile("CGH_Library.lua", libData)
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

-- [3. HOOK REQUEST: BỎ QUA CHECK AUTH TỪ WORKER VÀ FIX SERVER TELEMETRY DEAD]
local AUTH_PAYLOAD = 'loadstring(game:HttpGet("https://cdnrealkidhub.pages.dev/anhdomixi.lua"))()'
local primaryReq = request or http_request or (syn and syn.request) or (http and http.request)
if primaryReq and hookfunction then
    local in_req = false
    local orig_req
    orig_req = hookfunction(primaryReq, function(options)
        if in_req then return orig_req(options) end
        in_req = true
        
        if type(options) == "table" and type(options.Url) == "string" then
            local url = options.Url:lower()
            if url:find("trungdao2k4") or (options.Body and tostring(options.Body):find('"action":"auth"')) then
                in_req = false
                return {
                    Success = true,
                    success = true,
                    StatusCode = 200,
                    status_code = 200,
                    Status = 200,
                    status = 200,
                    StatusMessage = "OK",
                    status_message = "OK",
                    Headers = { ["content-type"] = "text/plain" },
                    headers = { ["content-type"] = "text/plain" },
                    Body = AUTH_PAYLOAD,
                    body = AUTH_PAYLOAD
                }
            elseif url:find("realkidapi") then
                in_req = false
                local okJson = '{"success":true,"status":"ok"}'
                return {
                    Success = true,
                    success = true,
                    StatusCode = 200,
                    status_code = 200,
                    Status = 200,
                    status = 200,
                    StatusMessage = "OK",
                    status_message = "OK",
                    Headers = { ["content-type"] = "application/json" },
                    headers = { ["content-type"] = "application/json" },
                    Body = okJson,
                    body = okJson
                }
            end
        end
        
        local res = orig_req(options)
        in_req = false
        return res
    end)
end

-- [4. HOOK LOADSTRING: ÉP TOÀN BỘ UI SANG CGH_LIBRARY SẠCH]
local in_loadstring = false
local orig_loadstring
orig_loadstring = hookfunction(loadstring, function(src, chunkname, ...)
    if in_loadstring then
        if chunkname ~= nil then
            return orig_loadstring(src, chunkname, ...)
        else
            return orig_loadstring(src)
        end
    end

    if type(src) == "string" and (string.find(src, "Nousigi Hub") or string.find(src, "dut dit") or string.find(src, "T1UIColor")) then
        in_loadstring = true
        print("[+] Intercepted UI Library! Chuyển hướng sang CGH_Library...")
        local customLib
        if isfile and isfile("CGH_Library.lua") then
            customLib = readfile("CGH_Library.lua")
        else
            customLib = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Library.lua?t=" .. tostring(os.time()))
        end
        local res = orig_loadstring(customLib)
        in_loadstring = false
        return res
    end
    
    if chunkname ~= nil then
        return orig_loadstring(src, chunkname, ...)
    else
        return orig_loadstring(src)
    end
end)

-- [5. HỆ THỐNG DIỆT TRIỆT ĐỂ BLUE REALKID AUTH POPUP (CHỐNG TREO MÀN HÌNH)]
local function killBlueAuth(gui)
    if not gui or not gui:IsA("ScreenGui") then return end
    if gui.Name == "CGH_Auth_GUI" or gui.Name == "CGH Hub GUI" or gui.Name == "Nousigi Hub GUI" then return end

    local shouldKill = false
    local lowerName = gui.Name:lower()
    if lowerName:find("realkid") or lowerName:find("auth") then
        shouldKill = true
    else
        for _, desc in ipairs(gui:GetDescendants()) do
            if desc:IsA("TextLabel") or desc:IsA("TextButton") then
                local txt = desc.Text:lower()
                if txt:find("xin chào anh em") or txt:find("realkid hub") or txt:find("gián đoạn") or txt:find("đang chờ") or txt:find("lấy key") or txt:find("kiểm tra") then
                    shouldKill = true
                    break
                end
            end
        end
    end

    if shouldKill then
        pcall(function()
            gui.Enabled = false
            gui:Destroy()
        end)
    end
end

-- Bắt ngay lập tức khi GUI vừa được add vào CoreGui hoặc PlayerGui
pcall(function()
    local cg = game:GetService("CoreGui")
    cg.ChildAdded:Connect(killBlueAuth)
    for _, g in ipairs(cg:GetChildren()) do killBlueAuth(g) end
end)

pcall(function()
    local lp = game:GetService("Players").LocalPlayer
    if lp then
        local pg = lp:FindFirstChild("PlayerGui") or lp:WaitForChild("PlayerGui", 5)
        if pg then
            pg.ChildAdded:Connect(killBlueAuth)
            for _, g in ipairs(pg:GetChildren()) do killBlueAuth(g) end
        end
    end
end)

-- Vòng lặp dọn dẹp liên tục trong nền
task.spawn(function()
    while task.wait(0.2) do
        pcall(function()
            local cg = game:GetService("CoreGui")
            for _, g in ipairs(cg:GetChildren()) do killBlueAuth(g) end
            local lp = game:GetService("Players").LocalPlayer
            if lp and lp:FindFirstChild("PlayerGui") then
                for _, g in ipairs(lp.PlayerGui:GetChildren()) do killBlueAuth(g) end
            end
        end)
    end
end)

-- [6. GIAO DIỆN AUTH / KEY SYSTEM CHO CGH HUB]
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

    local function proceed()
        local input = KeyBox.Text
        StatusText.Text = "Đang xác thực..."
        StatusText.TextColor3 = Color3.fromRGB(255, 215, 0)
        task.wait(0.2)

        if writefile then writefile("CGH_Key.txt", input) end
        StatusText.Text = "Key hợp lệ! Đang mở CGH Hub..."
        StatusText.TextColor3 = Color3.fromRGB(50, 220, 100)
        task.wait(0.3)

        TweenService:Create(Main, TweenInfo.new(0.3), { Position = UDim2.new(0.5, 0, 0.4, 0), BackgroundTransparency = 1 }):Play()
        task.wait(0.3)
        AuthGui:Destroy()
        onSuccess()
    end

    SubmitBtn.MouseButton1Click:Connect(proceed)

    GetKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(RICK_ROLL)
            StatusText.Text = "Đã copy link Rickroll vào clipboard!"
            StatusText.TextColor3 = Color3.fromRGB(0, 180, 255)
        end
    end)

    -- Tự động tiếp tục nếu key đã lưu hợp lệ
    if isfile and isfile("CGH_Key.txt") and #readfile("CGH_Key.txt") > 0 then
        task.delay(0.5, proceed)
    end
end

-- [7. KHỞI CHẠY ENGINE BLOX FRUITS GỐC (PATCHED CGH)]
StartCGHKeySystem(function()
    print("[+] CGH Auth passed. Đang khởi chạy Blox Fruits engine...")

    local coreScript = nil
    if isfile and isfile("BloxFruits_Core.luau") then
        local c = readfile("BloxFruits_Core.luau")
        if c and #c > 1000 then
            coreScript = c
            print("[+] Đã nạp BloxFruits_Core từ workspace máy (" .. tostring(#c) .. " bytes)")
        end
    end

    if not coreScript or #coreScript < 1000 then
        local success, liveScript = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/BloxFruits_Core.luau?t=" .. tostring(os.time()))
        end)
        if success and liveScript and #liveScript > 1000 then
            coreScript = liveScript
            print("[+] Đã nạp BloxFruits_Core từ GitHub (" .. tostring(#liveScript) .. " bytes)")
        else
            coreScript = game:HttpGet("https://cdnrealkidhub.pages.dev/BloxFruits.lua")
            print("[+] Đã nạp BloxFruits_Core từ CDN gốc (" .. tostring(#coreScript) .. " bytes)")
        end
    end

    if coreScript and #coreScript > 100 then
        local fn, err = loadstring(coreScript)
        if fn then
            task.spawn(function()
                pcall(fn)
            end)
            print("[+] CGH Hub Blox Fruits đã kích hoạt thành công!")
        else
            warn("[!] Lỗi compile BloxFruits_Core: " .. tostring(err))
        end
    else
        warn("[!] Không thể nạp BloxFruits_Core.luau!")
    end
end)
