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

-- [2. GHI ĐÈ TOKEN LƯU TRỮ KEY HỢP LỆ TRONG WORKSPACE]
pcall(function()
    local validKey = "TRAU_D681832834B3C47DC3B817046FDEAFAF32E0911348B00509"
    local validSave = "TRAU_5ED2C42BACED0ADB86FC42D48ECC842CD6F19F9E52F2C525"
    if writefile then
        writefile("RealKid_Key_" .. tostring(game.PlaceId) .. ".txt", validKey)
        writefile("RealKid_Key_2753915549.txt", validKey)
        writefile("RealKid_Key_4442272183.txt", validKey)
        writefile("RealKid_Key_7449423635.txt", validKey)
        writefile("TrauHub_Save.txt", validSave)
        writefile("CGH_Key.txt", "CGH_AUTHENTICATED")
    end
end)

-- [3. HOOK REQUEST: BYPASS 100% HỆ THỐNG AUTH CỦA REALKID]
-- Server trungdao2k4 khi key hợp lệ sẽ trả về đoạn mã load payload game chính
local AUTH_SUCCESS_PAYLOAD = 'loadstring(game:HttpGet("https://cdnrealkidhub.pages.dev/anhdomixi.lua"))()'

local function hookReq(reqFunc)
    if not reqFunc or not hookfunction then return reqFunc end
    local orig_req
    orig_req = hookfunction(reqFunc, function(options)
        if type(options) == "table" and type(options.Url) == "string" then
            local url = options.Url:lower()
            -- Chặn mọi cuộc gọi xác thực của RealKid và trả về mã kích hoạt thành công
            if url:find("trungdao2k4") or url:find("realkidapi") or url:find("workers.dev") then
                if options.Body and tostring(options.Body):find("auth") then
                    return {
                        StatusCode = 200,
                        StatusMessage = "OK",
                        Headers = { ["Content-Type"] = "text/plain" },
                        Body = AUTH_SUCCESS_PAYLOAD
                    }
                end
                -- Chặn telemetry gửi dữ liệu người chơi
                return {
                    StatusCode = 200,
                    StatusMessage = "OK",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = '{"success":true}'
                }
            end
        end
        return orig_req(options)
    end)
    return orig_req
end

pcall(function() if request then hookReq(request) end end)
pcall(function() if http_request then hookReq(http_request) end end)
pcall(function() if syn and syn.request then hookReq(syn.request) end end)
pcall(function() if http and http.request then hookReq(http.request) end end)

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

-- [5. HOOK LOADSTRING: ÉP TOÀN BỘ UI SANG CGH_LIBRARY SẠCH]
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

-- [6. TỰ ĐỘNG BẤM KIỂM TRA NẾU KHUNG KEY HIỆN LÊN]
task.spawn(function()
    for _ = 1, 25 do
        task.wait(0.3)
        local coreGui = game:GetService("CoreGui")
        local playerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        local found = false

        for _, parent in ipairs({coreGui, playerGui}) do
            if parent then
                for _, obj in ipairs(parent:GetDescendants()) do
                    if obj:IsA("TextButton") and (obj.Text:find("KIỂM TRA") or obj.Text:find("Kiem Tra")) then
                        if firesignal then
                            firesignal(obj.MouseButton1Click)
                        else
                            for _, c in ipairs(getconnections(obj.MouseButton1Click)) do
                                c:Fire()
                            end
                        end
                        found = true
                        break
                    end
                end
            end
            if found then break end
        end
        if found then break end
    end
end)

-- [7. KÍCH HOẠT SCRIPT GỐC REALKID ĐÃ ĐƯỢC PATCH]
print("[+] CGH Hub Blox Fruits: Đang nạp engine chính...")

local coreScript = nil
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

if not coreScript or #coreScript < 1000 then
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
