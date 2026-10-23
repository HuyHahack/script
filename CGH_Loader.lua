--[[
    ========================================================================
                                 CGH HUB
                      Blox Fruits - Vietnam Edition
                  Repository: https://github.com/HuyHahack/script
    ========================================================================
--]]

print("[+] CGH Hub Blox Fruits: Đang khởi chạy CGH Native Core...")

local function runCore()
    local core = nil
    if isfile and isfile("CGH_Native_Core.lua") then
        core = readfile("CGH_Native_Core.lua")
    else
        core = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Native_Core.lua")
    end
    
    if core and #core > 100 then
        local fn, err = loadstring(core)
        if fn then
            fn()
            print("[+] CGH Hub Blox Fruits kích hoạt thành công!")
        else
            warn("[!] Lỗi compile: " .. tostring(err))
        end
    else
        warn("[!] Không thể tải CGH_Native_Core.lua!")
    end
end

task.spawn(function()
    pcall(runCore)
end)
