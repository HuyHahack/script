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

-- [3. HOOK LOADSTRING: ÉP TOÀN BỘ UI SANG CGH_LIBRARY SẠCH]
local orig_loadstring
orig_loadstring = hookfunction(loadstring, function(src, chunkname, ...)
    if type(src) == "string" and (string.find(src, "Nousigi Hub") or string.find(src, "dut dit") or string.find(src, "T1UIColor") or string.find(src, "RealKid")) then
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

-- [4. TẢI VÀ KÍCH HOẠT LÕI BLOX FRUITS (BỎ QUA HOÀN TOÀN TẦNG AUTH CHECK)]
print("[+] CGH Hub Blox Fruits: Đang kích hoạt lõi game...")

local coreScript = nil
if isfile and isfile("BloxFruits_Core.luau") then
    coreScript = readfile("BloxFruits_Core.luau")
else
    coreScript = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/BloxFruits_Core.luau")
end

if coreScript and #coreScript > 1000 then
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
