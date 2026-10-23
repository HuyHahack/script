--[[
    =======================================================
                        CGH HUB
               Blox Fruits - Vietnam Edition
           Repository: https://github.com/HuyHahack/script
    =======================================================
--]]

-- [1. TỰ ĐỘNG TẢI VÀ CACHE LOGO CỜ VIỆT NAM, THƯ VIỆN UI & ENGINE GỐC]
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

pcall(function()
    if writefile and (not isfile or not isfile("anhdomixi.lua")) then
        local domixiData = game:HttpGet("https://cdnrealkidhub.pages.dev/anhdomixi.lua")
        writefile("anhdomixi.lua", domixiData)
    end
end)

local function getCustomLogo()
    if isfile and isfile("cgh_logo.png") and getcustomasset then
        return getcustomasset("cgh_logo.png")
    end
    return "rbxassetid://96220014754961"
end

-- [2. THIẾT LẬP TRẠNG THÁI TOÀN CỤC CHO CGH HUB]
getgenv().Nousigi = true
getgenv().CGH = true
getgenv().Config = true
getgenv().UIToggled = true
getgenv().ReadyForGuiLoaded = true

-- [3. GHI SẴN REAL KEY CHO MỌI PLACE BLOX FRUITS ĐỂ REALKID TỰ ĐIỀN]
local REAL_KEY = "TRAU_4D0281B6EB4A9BFDD18753A4B92860F9716BC4C439E1C448"
pcall(function()
    if writefile then
        writefile("RealKid_Key_" .. tostring(game.PlaceId) .. ".txt", REAL_KEY)
        writefile("RealKid_Key_2753915549.txt", REAL_KEY)
        writefile("RealKid_Key_4442272183.txt", REAL_KEY)
        writefile("RealKid_Key_7449423635.txt", REAL_KEY)
        writefile("RealKid_Key_79091703265657.txt", REAL_KEY)
        writefile("RealKid_Key_100117331123089.txt", REAL_KEY)
        writefile("TrauHub_Save.txt", REAL_KEY)
        writefile("CGH_Key.txt", REAL_KEY)
    end
end)

-- [4. HOOK SETCLIPBOARD: MỌI LINK DISCORD ĐỀU THÀNH RICK ROLL]
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

-- [5. HOOK REQUEST: CHO PHÉP REAL KEY GỬI LÊN SERVER VÀ DUMP PHẢN HỒI GỐC]
local hooked_fns = {}
local function hookReq(fn)
    if not fn or type(fn) ~= "function" or hooked_fns[fn] or not hookfunction then return fn end
    hooked_fns[fn] = true

    local in_call = false
    local orig
    orig = hookfunction(fn, function(opt)
        if in_call then return orig(opt) end
        in_call = true

        if type(opt) == "table" then
            local url = tostring(opt.Url or opt.url or ""):lower()
            -- Bỏ qua endpoint telemetry đã chết để không treo game
            if url:find("realkidapi") then
                in_call = false
                local okJson = '{"success":true,"status":"ok"}'
                return {
                    Success = true, success = true,
                    StatusCode = 200, status_code = 200,
                    Status = 200, status = 200,
                    StatusMessage = "OK", status_message = "OK",
                    Headers = { ["content-type"] = "application/json" },
                    headers = { ["content-type"] = "application/json" },
                    Body = okJson, body = okJson
                }
            elseif url:find("trungdao2k4") then
                print("[+] Gửi Real Key lên server RealKid Auth...")
                local res = orig(opt)
                local sc = res and (res.StatusCode or res.status_code)
                print("[+] Server Auth trả về StatusCode: " .. tostring(sc))
                if res and (res.Body or res.body) then
                    local b = tostring(res.Body or res.body)
                    print("[+] Độ dài Body nhận được: " .. tostring(#b) .. " bytes")
                    if writefile then
                        pcall(writefile, "RealKid_Server_Response.txt", b)
                    end
                end
                in_call = false
                return res
            end
        end

        local res = orig(opt)
        in_call = false
        return res
    end)
    return orig
end

pcall(function() if request then hookReq(request) end end)
pcall(function() if http_request then hookReq(http_request) end end)
pcall(function() if syn and syn.request then hookReq(syn.request) end end)
pcall(function() if http and http.request then hookReq(http.request) end end)

-- [6. DUMPER & HOOK LOADSTRING: DUMP TẤT CẢ MÃ NGUỒN ĐƯỢC GIẢI MÃ & BỌC CGH UI]
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

    if type(src) == "string" and #src > 10 then
        -- Tự động Dump mọi chunk script mà game thực thi
        pcall(function()
            if writefile then
                local dumpName = "dumped_chunk_" .. tostring(#src) .. "_" .. tostring(os.time()) .. ".luau"
                writefile(dumpName, src)
                print("[+] ĐÃ DUMP CHUNK: " .. dumpName .. " (" .. tostring(#src) .. " bytes)")
            end
        end)

        -- Bọc UI Nousigi sang CGH Library sạch cờ Việt Nam
        if string.find(src, "Nousigi Hub") or string.find(src, "dut dit") or string.find(src, "T1UIColor") then
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
    end

    if chunkname ~= nil then
        return orig_loadstring(src, chunkname, ...)
    else
        return orig_loadstring(src)
    end
end)

-- [7. TỰ ĐỘNG BẤM 'KIỂM TRA' TRÊN KHUNG BLUE REALKID]
task.spawn(function()
    local coreGui = game:GetService("CoreGui")
    local playerGui = game:GetService("Players").LocalPlayer and game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")

    for _ = 1, 60 do
        task.wait(0.3)
        for _, parent in ipairs({coreGui, playerGui}) do
            if parent then
                for _, obj in ipairs(parent:GetDescendants()) do
                    if obj:IsA("TextButton") and (obj.Text:find("KIỂM TRA") or obj.Text:find("Kiem Tra")) then
                        print("[+] Phát hiện nút KIỂM TRA! Tự động nhấn để gửi Auth...")
                        if firesignal then
                            firesignal(obj.MouseButton1Click)
                        elseif getconnections then
                            for _, c in ipairs(getconnections(obj.MouseButton1Click)) do
                                c:Fire()
                            end
                        end
                        return
                    end
                end
            end
        end
    end
end)

-- [8. GIAO DIỆN AUTH / KEY SYSTEM CHO CGH HUB]
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
    KeyBox.Text = REAL_KEY
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

    task.delay(0.5, proceed)
end

-- [9. KHỞI CHẠY LÕI GAME GỐC REALKID 1.5MB (PATCHED CGH HUB)]
StartCGHKeySystem(function()
    print("[+] CGH Auth passed. Đang khởi chạy Blox Fruits engine...")
    getgenv().UIToggled = true
    getgenv().ReadyForGuiLoaded = true

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
            print("[+] Bắt đầu thực thi Blox Fruits engine...")
            task.spawn(function()
                local ok, runErr = pcall(fn)
                if ok then
                    print("[+] CGH Hub Blox Fruits đã kích hoạt thành công!")
                else
                    warn("[!] Lỗi runtime BloxFruits_Core: " .. tostring(runErr))
                end
            end)
        else
            warn("[!] Lỗi compile BloxFruits_Core: " .. tostring(err))
        end
    else
        warn("[!] Không thể nạp BloxFruits_Core.luau!")
    end
end)
