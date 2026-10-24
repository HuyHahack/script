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

            if type(opt) == "table" then
                local url = tostring(opt.Url or opt.url or ""):lower()
                
                -- Bẻ khóa Cloudflare Worker trả về JWT có chữ ký RSA hợp lệ tuyệt đối
                if url:find("webhook%.trungdao2k4") or url:find("workers%.dev") then
                    in_call = false
                    print("[+] CGH Keyless: Tu dong xac thuc ban quyen RSA thanh cong 100%!")
                    return {
                        Success = true, success = true,
                        StatusCode = 200, status_code = 200,
                        Status = 200, status = 200,
                        StatusMessage = "OK", status_message = "OK",
                        Headers = { ["content-type"] = "application/json" },
                        headers = { ["content-type"] = "application/json" },
                        Body = REAL_SIGNED_JWT, body = REAL_SIGNED_JWT
                    }
                end

                -- Mock telemetry realkidapi.online để không bị giật lag
                if url:find("realkidapi%.online") then
                    in_call = false
                    return {
                        Success = true, success = true,
                        StatusCode = 200, status_code = 200,
                        Status = 200, status = 200,
                        StatusMessage = "OK", status_message = "OK",
                        Headers = { ["content-type"] = "application/json" },
                        headers = { ["content-type"] = "application/json" },
                        Body = '{"success":true,"status":"ok"}', body = '{"success":true,"status":"ok"}'
                    }
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
end

-- [6. HOOK GAME.HTTPGET: PHỤC VỤ OFFLINE WORKSPACE]
if not getgenv().__CGH_HTTPGET_HOOKED then
    getgenv().__CGH_HTTPGET_HOOKED = true
    pcall(function()
        if hookfunction and game and game.HttpGet then
            local orig_httpget
            orig_httpget = hookfunction(game.HttpGet, function(self, url, ...)
                local lowerUrl = tostring(url):lower()
                if lowerUrl:find("anhdomixi") then
                    if isfile and isfile("anhdomixi.lua") then
                        local c = readfile("anhdomixi.lua")
                        if c and #c > 1000 then return c end
                    end
                elseif lowerUrl:find("bloxfruits_core") or lowerUrl:find("bloxfruits%.lua") then
                    if isfile and isfile("BloxFruits_Core.luau") then
                        local c = readfile("BloxFruits_Core.luau")
                        if c and #c > 1000 then return c end
                    end
                end
                return orig_httpget(self, url, ...)
            end)
        end
    end)
end

-- [7. BỘ GIÁM SÁT TỰ ĐỘNG BẬT VÀ TRANG TRÍ CGH HUB (CỜ VIỆT NAM + GOLD CHECKBOX)]
local GOLD = Color3.fromRGB(255, 215, 0)
local CRIMSON = Color3.fromRGB(180, 20, 30)

task.spawn(function()
    while true do
        task.wait(0.5)
        local gui = CoreGui:FindFirstChild("Nousigi Hub GUI") or CoreGui:FindFirstChild("CGH Hub GUI")
        if gui then
            gui.Name = "CGH Hub GUI"
            gui.Enabled = true

            -- Đổi Tiêu đề
            local title = gui:FindFirstChild("TextLabelMain", true)
            if title and not title.Text:find("CGH Team") then
                title.Text = '<font color="rgb(255,215,0)">CGH Hub</font> Blox Fruits - CGH Team'
            end

            -- Đổi Logo Cờ Việt Nam
            local logo = gui:FindFirstChild("Ruafimg", true)
            if logo and isfile and isfile("cgh_logo.png") and getcustomasset then
                pcall(function()
                    logo.Image = getcustomasset("cgh_logo.png")
                end)
            end

            -- Đổi màu viền và văn bản thành Vàng Gold & Đỏ Crimson
            for _, d in ipairs(gui:GetDescendants()) do
                if d:IsA("TextLabel") and d.Text:find("RealKid") then
                    d.Text = d.Text:gsub("RealKid", "CGH Hub"):gsub("ReadKid", "CGH Hub")
                end
                if d:IsA("UIStroke") and d.Color == Color3.fromRGB(0, 170, 255) then
                    d.Color = GOLD
                end
            end
        end

        -- Tự động nhấn nút Kiểm Tra Key nếu TrauHubKeySystem còn hiển thị
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

-- [8. KHỞI CHẠY BLOX FRUITS CORE ENGINE]
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
