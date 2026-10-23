--[[
    ========================================================================
                                 CGH HUB
                      Blox Fruits - Vietnam Edition
                  Repository: https://github.com/HuyHahack/script
    ========================================================================
--]]

local env = (getgenv and getgenv()) or _G or {}

-- [1. TẢI VÀ CACHE LOGO CỜ VIỆT NAM]
pcall(function()
    if env.writefile and (not env.isfile or not env.isfile("cgh_logo.png")) then
        local imgData = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/cgh_logo.png")
        env.writefile("cgh_logo.png", imgData)
    end
end)

-- [2. HỆ THỐNG BYPASS AUTH GỐC CỦA TÁC GIẢ]
local BYPASS_TOKEN = "TRAU_0E32B39DDBA01BDDCD7DF94F852880B6D64C4B9D0563EAB0"
local BYPASS_SAVE = "TRAU_5ED2C42BACED0ADB86FC42D48ECC842CD6F19F9E52F2C525"

-- Tự động ghi sẵn file key hợp lệ vào workspace
pcall(function()
    local placeId = tostring(game.PlaceId)
    if env.writefile then
        env.writefile("RealKid_Key_" .. placeId .. ".txt", BYPASS_TOKEN)
        env.writefile("TrauHub_Save.txt", BYPASS_SAVE)
        env.writefile("CGH_Key.txt", "CGH_VIP_AUTHENTICATED")
    end
end)

-- Hook isfile và readfile an toàn qua global env (không gây đệ quy/crash)
local real_isfile = env.isfile or isfile
local real_readfile = env.readfile or readfile

if real_isfile and real_readfile then
    env.isfile = function(file)
        if type(file) == "string" then
            if file:find("RealKid_Key") or file:find("TrauHub_Save") or file:find("teddy_key") then
                return true
            end
        end
        return real_isfile(file)
    end

    env.readfile = function(file)
        if type(file) == "string" then
            if file:find("RealKid_Key") or file:find("teddy_key") then
                return BYPASS_TOKEN
            elseif file:find("TrauHub_Save") then
                return BYPASS_SAVE
            end
        end
        return real_readfile(file)
    end
end

-- Hook request để chặn Webhook gián điệp và giả lập phản hồi Auth thành công
local real_req = env.request or env.http_request or (env.syn and env.syn.request) or (env.http and env.http.request)
if real_req then
    local function custom_request(options)
        if type(options) == "table" and type(options.Url) == "string" then
            local url = options.Url:lower()
            if url:find("webhook.trungdao2k4.workers.dev") or url:find("realkidapi.online") then
                if options.Body and tostring(options.Body):find("auth") then
                    return {
                        StatusCode = 200,
                        StatusMessage = "OK",
                        Headers = { ["Content-Type"] = "application/json" },
                        Body = '{"success":true,"status":"success","message":"Bypassed by CGH Hub","valid":true}'
                    }
                end
                return {
                    StatusCode = 200,
                    StatusMessage = "OK",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = '{"success":true}'
                }
            end
        end
        return real_req(options)
    end
    
    if env.request then env.request = custom_request end
    if env.http_request then env.http_request = custom_request end
    if env.syn and env.syn.request then env.syn.request = custom_request end
    if env.http and env.http.request then env.http.request = custom_request end
end

-- [3. HOOK SETCLIPBOARD: MỌI LINK DISCORD ĐỀU THÀNH RICK ROLL]
local RICK_ROLL = "https://www.youtube.com/watch?v=dQw4w9WgXcQ"
local real_setclipboard = env.setclipboard or setclipboard
if real_setclipboard then
    env.setclipboard = function(text)
        if type(text) == "string" and (string.find(text, "discord%.gg") or string.find(text, "discord%.com")) then
            return real_setclipboard(RICK_ROLL)
        end
        return real_setclipboard(text)
    end
end

-- [4. HOOK LOADSTRING CHUYỂN HƯỚNG SANG CGH_LIBRARY SẠCH]
local real_loadstring = env.loadstring or loadstring
env.loadstring = function(src, chunkname, ...)
    if type(src) == "string" and (string.find(src, "Nousigi Hub") or string.find(src, "dut dit") or string.find(src, "T1UIColor")) then
        print("[+] Intercepted UI Library! Chuyển hướng sang CGH_Library...")
        local customLib
        if env.isfile and env.isfile("CGH_Library.lua") then
            customLib = env.readfile("CGH_Library.lua")
        else
            customLib = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Library.lua")
        end
        return real_loadstring(customLib)
    end
    
    if chunkname ~= nil then
        return real_loadstring(src, chunkname, ...)
    else
        return real_loadstring(src)
    end
end

-- [5. KÍCH HOẠT THẲNG LÕI BLOX FRUITS CHUẨN 100%]
print("[+] CGH Hub Blox Fruits: Đang nạp mã nguồn chính...")

local coreScript = nil

-- Ưu tiên 1: Đọc file lõi sạch đã lưu cục bộ
if env.isfile and env.isfile("BloxFruits_Core.luau") then
    coreScript = env.readfile("BloxFruits_Core.luau")
end

-- Ưu tiên 2: Tải từ GitHub Repository
if not coreScript or #coreScript < 1000 then
    local ok, res = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/BloxFruits_Core.luau")
    end)
    if ok and res and #res > 1000 then
        coreScript = res
    end
end

-- Ưu tiên 3: Fallback lấy từ CDN gốc và gọt sạch backdoor
if not coreScript or #coreScript < 1000 then
    local success, liveScript = pcall(function()
        return game:HttpGet("https://cdnrealkidhub.pages.dev/BloxFruits.lua")
    end)
    if success and liveScript and #liveScript > 1000 then
        local pos = liveScript:find("%-%- This file was protected")
        if pos then
            coreScript = liveScript:sub(pos)
        else
            coreScript = liveScript
        end
    end
end

if coreScript and #coreScript > 100 then
    local fn, err = real_loadstring(coreScript)
    if fn then
        print("[+] Kích hoạt thành công Blox Fruits Engine dưới thương hiệu CGH Hub!")
        fn()
    else
        warn("[!] Lỗi compile BloxFruits_Core: " .. tostring(err))
    end
else
    warn("[!] Không thể nạp BloxFruits_Core.luau!")
end
