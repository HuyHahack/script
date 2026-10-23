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

-- [2. GHI ĐÈ TOKEN BYPASS AUTH CHO REALKID]
pcall(function()
    local key = "TRAU_0E32B39DDBA01BDDCD7DF94F852880B6D64C4B9D0563EAB0"
    local save = "TRAU_5ED2C42BACED0ADB86FC42D48ECC842CD6F19F9E52F2C525"
    if writefile then
        writefile("RealKid_Key_" .. tostring(game.PlaceId) .. ".txt", key)
        writefile("RealKid_Key_2753915549.txt", key)
        writefile("RealKid_Key_4442272183.txt", key)
        writefile("RealKid_Key_7449423635.txt", key)
        writefile("TrauHub_Save.txt", save)
        writefile("CGH_Key.txt", "CGH_AUTHENTICATED")
    end
end)

-- [3. HOOK SETCLIPBOARD: MỌI LINK DISCORD ĐỀU THÀNH RICK ROLL]
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

-- [4. HOOK LOADSTRING: ÉP TOÀN BỘ UI SANG CGH_LIBRARY SẠCH]
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

-- [5. HỆ THỐNG AUTO-UPDATE VÀ KÍCH HOẠT LÕI REALKID]
local coreScript = nil

-- Ưu tiên tải bản Blox Fruits mới nhất từ CDN gốc (tự gọt sạch backdoor), nếu lỗi sẽ tự fallback về bản lưu trên GitHub
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
