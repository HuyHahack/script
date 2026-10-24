--[[
    =======================================================
                     CGH HUB - BLOX FRUITS
                 PHIÊN BẢN ĐỘC QUYỀN (KEYLESS)
               Vĩnh viễn không cần Key - 1 Click Run
               Tự động duy trì khi Hop / Rejoin Server
           Repository: https://github.com/HuyHahack/script
    =======================================================
--]]

print("=======================================================")
print("            CGH HUB - BLOX FRUITS (KEYLESS)            ")
print("          Khoi chay he thong Blox Fruits v6...         ")
print("=======================================================")

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- [1. THIẾT LẬP MÔI TRƯỜNG & TRẠNG THÁI TOÀN CỤC CHO CGH HUB]
getgenv().Nousigi = true
getgenv().CGH = true
getgenv().Config = true
getgenv().UIToggled = true
getgenv().ReadyForGuiLoaded = true

-- [2. HẰNG SỐ XÁC THỰC BẢN QUYỀN HOÀN TOÀN CHUẨN XÁC VỚI CHỮ KÝ RSA]
local TARGET_NONCE = "CFE2E69F-0E32-4DF7-88E7-EC7FBD07DF9E"
local TARGET_KEY = "TRAU_4D0281B6EB4A9BFDD18753A4B92860F9716BC4C439E1C448"
local REAL_SIGNED_JWT = [===[{"version":3,"alg":"RS256","kid":"a987fcfbfc8fc7e5","payload":"eyJ2ZXJzaW9uIjozLCJhdWRpZW5jZSI6InJlYWxraWQtYXV0aCIsIm5vbmNlIjoiQ0ZFMkU2OUYtMEUzMi00REY3LTg4RTctRUM3RkJEMDdERjlFIiwiaHdpZCI6IjdiNjEzODYyNjUzMzMxMzQzMDJkMzkzMTY0NjUyZDMxMzE2NjMxMmQzOTMzNjYzOTJkMzgzMDM2NjUzNjY2MzY2NTM2MzkzNjMzN2QiLCJod2lkMiI6IkVGNTcwNTEzLUVDQzMtNDI2MC04RDJCLTk5NUM4RDg0OUI4NSIsImtleUhhc2giOiJlOWEyZWUzMjAxZjI5OGEyOGNjOWMyZTQzZGY1YmE1MDM4NGY0ZTg3ZDEyOGZjNjFmNWY3Y2NjMGMzNDkzOTZkIiwic3RhdHVzIjoiQVVUSE9SSVpFRCIsImV4cGlyZXMiOiIxODozNiAtIDI1LzEwLzIwMjYifQ","signature":"iCwsQPqv7rP3ZKcDNRmHfCyl9B9kDiiUKJOaqzwaqwZoHFJaQxmFVjHAwcyqUqB_MZTGiXKVwJpCLfo2-KIuDxlNhleE2X14T11A7mVh-HKqsTOh7MYObk6waj292jwcBoLqJGjIWnbFr5hs347PHtPVSF4_V8SVrOobofUC927Tda0IvZ41dxCkMyX5J12o_yiefTwm8aDgWH390fUuYmvSkPaWvtLJVuS_ERNsJW5lFZspx0nVKtm6Akk3-r6Pz4FOI5_1LFPnQ_72IQe0Sk-0jNC30MLqokSMLViEsDN_wDY5itN7VGw2PgspKMnfbDm_Md5hjbT0V8jRYGOwyA"}]===]

-- Đảm bảo key file luôn tồn tại
local targetKeyFiles = {
    "TrauHub_Save.txt",
    "RealKid_Key_" .. tostring(game.PlaceId) .. ".txt",
    "RealKid_Key_100117331123089.txt",
    "RealKid_Key_11348033272.txt",
    "RealKid_Key_11584810072.txt",
    "RealKid_Key_79091703265657.txt",
    "RealKid_Key_2753915549.txt",
    "RealKid_Key_4442272183.txt",
    "RealKid_Key_7449423635.txt",
    "CGH_Key.txt"
}

local function ensureKeyFiles()
    for _, f in ipairs(targetKeyFiles) do
        pcall(function()
            if writefile then writefile(f, TARGET_KEY) end
        end)
    end
end
ensureKeyFiles()

task.spawn(function()
    while task.wait(1) do
        ensureKeyFiles()
    end
end)

-- [3. TỰ ĐỘNG TẢI VÀ CACHE CỜ VIỆT NAM & FILE CODE VÀO WORKSPACE]
pcall(function()
    if writefile and (not isfile or not isfile("cgh_logo.png")) then
        local imgData = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/cgh_logo.png")
        writefile("cgh_logo.png", imgData)
    end
end)

pcall(function()
    if writefile and (not isfile or not isfile("anhdomixi.lua")) then
        local domixiData = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/anhdomixi.lua?t=" .. tostring(os.time()))
        writefile("anhdomixi.lua", domixiData)
    end
end)

pcall(function()
    if writefile and (not isfile or not isfile("BloxFruits_Core.luau")) then
        local coreData = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/BloxFruits_Core.luau?t=" .. tostring(os.time()))
        writefile("BloxFruits_Core.luau", coreData)
    end
end)

-- [4. HOOK GENERATEGUID: ĐỒNG BỘ NONCE HOÀN HẢO VỚI CHỮ KÝ RS256]
if not getgenv().__CGH_GUID_HOOKED then
    getgenv().__CGH_GUID_HOOKED = true
    if hookfunction and HttpService and HttpService.GenerateGUID then
        local orig_guid
        orig_guid = hookfunction(HttpService.GenerateGUID, function(self, ...)
            return TARGET_NONCE
        end)
    end
end

-- [5. HOOK REQUEST: MOCK SERVER AUTHENTICATION VỚI CHỮ KÝ THẬT 100%]
if not getgenv().__CGH_REQ_HOOKED then
    getgenv().__CGH_REQ_HOOKED = true
    local function hookReq(fn)
        if not fn or type(fn) ~= "function" or not hookfunction then return fn end
        local in_call = false
        local orig
        orig = hookfunction(fn, function(opt)
            if in_call then return orig(opt) end
            in_call = true
            local url = ""
            if type(opt) == "table" and opt.Url then
                url = tostring(opt.Url)
            elseif type(opt) == "string" then
                url = opt
            end

            -- Chặn và trả JWT hợp lệ cho API xác thực
            if url:find("webhook.trungdao2k4.workers.dev") then
                in_call = false
                print("[+] CGH Keyless: Tu dong xac thuc ban quyen thanh cong (Vinh vien 2099)!")
                return {
                    StatusCode = 200,
                    StatusMessage = "OK",
                    Body = REAL_SIGNED_JWT,
                    Success = true,
                    Headers = {["content-type"] = "application/json"}
                }
            end

            -- Chặn discord webhook spam
            if url:find("discord.com/api/webhooks") or url:find("discordapp.com/api/webhooks") then
                in_call = false
                return {
                    StatusCode = 200,
                    StatusMessage = "OK",
                    Body = '{"status":"ok"}',
                    Success = true,
                    Headers = {["content-type"] = "application/json"}
                }
            end

            in_call = false
            return orig(opt)
        end)
        return orig
    end

    if http and http.request then hookReq(http.request) end
    if http_request then hookReq(http_request) end
    if request then hookReq(request) end
    if syn and syn.request then hookReq(syn.request) end
end

-- [6. HOOK HTTPGET: ĐIỀU HƯỚNG TẤT CẢ TÀI NGUYÊN VỀ CGH HUB]
if not getgenv().__CGH_HTTPGET_HOOKED then
    getgenv().__CGH_HTTPGET_HOOKED = true
    local orig_httpget
    orig_httpget = hookfunction(game.HttpGet, function(self, url, ...)
        local urlStr = tostring(url or "")

        -- Chuyển hướng anhdomixi sang local/repo sạch
        if urlStr:find("anhdomixi.lua") then
            if isfile and isfile("anhdomixi.lua") then
                local data = readfile("anhdomixi.lua")
                if data and #data > 1000 then return data end
            end
            return orig_httpget(self, "https://raw.githubusercontent.com/HuyHahack/script/main/anhdomixi.lua?t=" .. tostring(os.time()), ...)
        end

        -- Mock server response nếu gọi bằng HttpGet
        if urlStr:find("webhook.trungdao2k4.workers.dev") then
            return REAL_SIGNED_JWT
        end

        return orig_httpget(self, url, ...)
    end)
end

-- [7. TỰ ĐỘNG DUY TRÌ BẢN QUYỀN CGH HUB KHI HOP SERVER / TELEPORT]
local CGH_TELEPORT_PERSIST = [=[
    task.spawn(function()
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
        task.wait(1)
        pcall(function()
            if isfile and isfile("CGH_Loader.lua") then
                loadstring(readfile("CGH_Loader.lua"))()
            else
                loadstring(game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Loader.lua?t=" .. tostring(os.time())))()
            end
        end)
    end)
]=]

local function getQOT()
    return queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or queueonteleport
end

local function applyHopQueue()
    local q = getQOT()
    if q then pcall(function() q(CGH_TELEPORT_PERSIST) end) end
end

pcall(function()
    local orig_q = getQOT()
    if orig_q and hookfunction then
        hookfunction(orig_q, function(script_str)
            return orig_q(CGH_TELEPORT_PERSIST)
        end)
    end
    local cgh_hop_qot = function(str)
        local raw = getQOT()
        if raw then return raw(CGH_TELEPORT_PERSIST) end
    end
    queue_on_teleport = cgh_hop_qot
    if syn then syn.queue_on_teleport = cgh_hop_qot end
    if fluxus then fluxus.queue_on_teleport = cgh_hop_qot end
    queueonteleport = cgh_hop_qot
end)

pcall(function()
    if lp then
        lp.OnTeleport:Connect(function(state)
            applyHopQueue()
        end)
    end
end)

pcall(function()
    local tpMethods = {"Teleport", "TeleportToPlaceInstance", "TeleportPartyAsync", "TeleportToSpawnByName"}
    for _, method in ipairs(tpMethods) do
        if TeleportService[method] and hookfunction then
            local orig_method
            orig_method = hookfunction(TeleportService[method], function(self, ...)
                applyHopQueue()
                return orig_method(self, ...)
            end)
        end
    end
end)

applyHopQueue()

-- [8. HOOK STARTERGUI NOTIFICATION - ĐỔI TÊN SANG CGH HUB]
pcall(function()
    if hookfunction and StarterGui and StarterGui.SetCore then
        local orig_setcore
        orig_setcore = hookfunction(StarterGui.SetCore, function(self, name, data, ...)
            if name == "SendNotification" and type(data) == "table" then
                local title = tostring(data.Title or "")
                local text = tostring(data.Text or "")
                data.Title = title:gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Nousigi", "CGH Hub"):gsub("ReadKid", "CGH Hub"):gsub("TrauHub", "CGH Hub")
                data.Text = text:gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Nousigi", "CGH Hub"):gsub("ReadKid", "CGH Hub"):gsub("TrauHub", "CGH Hub")
                if isfile and isfile("cgh_logo.png") and getcustomasset then
                    pcall(function() data.Icon = getcustomasset("cgh_logo.png") end)
                end
            end
            return orig_setcore(self, name, data, ...)
        end)
    end
end)

-- [9. BỘ GIÁM SÁT GIAO DIỆN CGH HUB & ĐỒNG BỘ MÀU CỜ ĐỎ SAO VÀNG / LOGO]
local GOLD = Color3.fromRGB(255, 215, 0)
local CRIMSON = Color3.fromRGB(180, 20, 30)
local CRIMSON_GRADIENT = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 30, 45)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 20, 30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 10, 20))
}

task.spawn(function()
    local enabledInitial = false
    local notiHooked = false

    while true do
        task.wait(0.3)
        local assetLogo = (getcustomasset and isfile and isfile("cgh_logo.png") and getcustomasset("cgh_logo.png")) or "rbxassetid://96220014754961"

        -- 1. Đồng bộ cấu hình màu sắc trong getgenv().UIColor (Chuẩn cờ đỏ sao vàng)
        if getgenv().UIColor and type(getgenv().UIColor) == "table" then
            getgenv().UIColor["Logo Image"] = assetLogo
            getgenv().UIColor["Border Color"] = GOLD
            getgenv().UIColor["Toggle Border Color"] = GOLD
            getgenv().UIColor["Title Text Color"] = GOLD
            getgenv().UIColor["Button Color"] = CRIMSON
            getgenv().UIColor["Section Underline Color"] = GOLD
            getgenv().UIColor["Page Selected Color"] = GOLD
            getgenv().UIColor["Dropdown Selected Color"] = GOLD
            getgenv().UIColor["Slider Line Color"] = GOLD
            getgenv().UIColor["Slider Highlight Color"] = CRIMSON
            getgenv().UIColor["Search Icon Highlight Color"] = GOLD
        end

        -- 2. Tự động hiển thị giao diện CHÍNH XÁC 1 LẦN khi vừa khởi tạo xong
        local gui = CoreGui:FindFirstChild("Nousigi Hub GUI")
        if gui then
            if not enabledInitial then
                enabledInitial = true
                getgenv().UIToggled = true
                gui.Enabled = true
            end

            -- Đổi Tiêu đề sang CGH Hub
            local title = gui:FindFirstChild("TextLabelMain", true)
            if title and not title.Text:find("CGH Team") then
                title.Text = '<font color="rgb(255,215,0)">CGH Hub</font> Blox Fruits - CGH Team'
            end

            -- Đổi Logo sang Cờ Việt Nam
            local logo = gui:FindFirstChild("Ruafimg", true)
            if logo and logo.Image ~= assetLogo then
                pcall(function() logo.Image = assetLogo end)
            end

            -- Đổi màu toàn bộ thành phần theo phong cách CỜ ĐỎ SAO VÀNG
            for _, d in ipairs(gui:GetDescendants()) do
                -- Đổi tên RealKid -> CGH Hub
                if d:IsA("TextLabel") and (d.Text:find("RealKid") or d.Text:find("ReadKid") or d.Text:find("Nousigi")) then
                    d.Text = d.Text:gsub("RealKid", "CGH Hub"):gsub("ReadKid", "CGH Hub"):gsub("Nousigi", "CGH Hub")
                end
                -- Checkbox ruột vuông -> Vàng Gold
                if d.Name == "check" and d:IsA("Frame") and d.BackgroundColor3 ~= GOLD then
                    d.BackgroundColor3 = GOLD
                end
                -- Checkbox viền ngoài -> Vàng Gold
                if d.Name == "checkbox" and d:IsA("ImageLabel") and d.ImageColor3 ~= GOLD then
                    d.ImageColor3 = GOLD
                end
                -- Nút ClickArea -> Đỏ Crimson cờ đỏ
                if d.Name == "ClickArea" and d:IsA("Frame") then
                    if d.BackgroundColor3 ~= CRIMSON then
                        d.BackgroundColor3 = CRIMSON
                    end
                    local grad = d:FindFirstChildOfClass("UIGradient")
                    if grad and grad.Color ~= CRIMSON_GRADIENT then
                        grad.Color = CRIMSON_GRADIENT
                    end
                end
                -- Tab indicator và viền xanh dương cũ -> Vàng Gold
                if d:IsA("Frame") and d.BackgroundColor3 == Color3.fromRGB(0, 170, 255) then
                    d.BackgroundColor3 = GOLD
                end
                if d:IsA("UIStroke") and d.Color == Color3.fromRGB(0, 170, 255) then
                    d.Color = GOLD
                end
            end
        end

        -- 3. Trang trí Nút Bật Tắt Nổi (Logo Cờ Việt Nam + Nền Crimson + Viền Gold)
        local btnGui = CoreGui:FindFirstChild("Nousigi Hub Btn")
        if btnGui then
            local dutDit = btnGui:FindFirstChild("dut dit", true)
            if dutDit and dutDit.BackgroundColor3 ~= CRIMSON then
                dutDit.BackgroundColor3 = CRIMSON
                local stroke = dutDit:FindFirstChildOfClass("UIStroke")
                if not stroke then
                    stroke = Instance.new("UIStroke", dutDit)
                    stroke.Thickness = 1.5
                end
                stroke.Color = GOLD
            end

            -- Duyệt tất cả ImageLabel trong nút nổi và gán logo Cờ Việt Nam 100%
            for _, img in ipairs(btnGui:GetDescendants()) do
                if img:IsA("ImageLabel") and img.Image ~= assetLogo then
                    pcall(function()
                        img.Image = assetLogo
                        img.ImageColor3 = Color3.new(1, 1, 1)
                    end)
                end
            end
        end

        -- 4. Trang trí Thông báo Notifications trong NotiContainer
        local notiGui = CoreGui:FindFirstChild("Nousigi Hub Notification")
        if notiGui then
            local container = notiGui:FindFirstChild("NotiContainer")
            if container and not notiHooked then
                notiHooked = true
                local function cleanNoti(inst)
                    for _, d in ipairs(inst:GetDescendants()) do
                        if d:IsA("TextLabel") and (d.Text:find("RealKid") or d.Text:find("Nousigi") or d.Text:find("ReadKid")) then
                            d.Text = d.Text:gsub("RealKid", "CGH Hub"):gsub("Nousigi", "CGH Hub"):gsub("ReadKid", "CGH Hub")
                        end
                        if d:IsA("ImageLabel") and d.Image ~= assetLogo then
                            pcall(function() d.Image = assetLogo end)
                        end
                    end
                end

                container.ChildAdded:Connect(function(child)
                    task.wait(0.02)
                    cleanNoti(child)
                end)
                cleanNoti(container)
            end
        end

        -- 5. Tự động bypass TrauHubKeySystem nếu còn sót
        local pgui = lp:FindFirstChildOfClass("PlayerGui")
        local ks = pgui and pgui:FindFirstChild("TrauHubKeySystem")
        if ks then
            ks.Enabled = false
            local keyInput = ks:FindFirstChild("KeyInput", true)
            if keyInput then keyInput.Text = TARGET_KEY end
            for _, b in ipairs(ks:GetDescendants()) do
                if b:IsA("TextButton") and not b.Text:find("Lấy") then
                    if getconnections then
                        for _, c in ipairs(getconnections(b.MouseButton1Click)) do
                            pcall(function() c:Fire() end)
                        end
                    end
                end
            end
        end
    end
end)

-- [10. KHỞI CHẠY BLOX FRUITS CORE ENGINE]
print("[+] Dang nap engine Blox Fruits 1.5MB...")
local coreScript = nil
if isfile and isfile("BloxFruits_Core.luau") then
    local c = readfile("BloxFruits_Core.luau")
    if c and #c > 1000 then
        coreScript = c
        print("[+] Da nap BloxFruits_Core tu workspace (" .. tostring(#c) .. " bytes)")
    end
end

if not coreScript or #coreScript < 1000 then
    local ok, liveScript = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/BloxFruits_Core.luau?t=" .. tostring(os.time()))
    end)
    if ok and liveScript and #liveScript > 1000 then
        coreScript = liveScript
        print("[+] Da nap BloxFruits_Core tu GitHub (" .. tostring(#liveScript) .. " bytes)")
    end
end

if coreScript and #coreScript > 100 then
    local fn, err = loadstring(coreScript, "BloxFruits_Core")
    if fn then
        print("[+] Bat dau thuc thi Blox Fruits engine...")
        task.spawn(function()
            local ok, runErr = pcall(fn)
            if not ok then warn("[!] Runtime BloxFruits_Core: " .. tostring(runErr)) end
        end)
    else
        warn("[!] Compile BloxFruits_Core: " .. tostring(err))
    end
end
