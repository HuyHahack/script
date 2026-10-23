--[[
    =======================================================
                        CGH HUB
               Blox Fruits - Vietnam Edition
           Repository: https://github.com/HuyHahack/script
    =======================================================
--]]

-- [1. TỰ ĐỘNG TẢI VÀ CACHE LOGO CỜ VIỆT NAM & THƯ VIỆN UI CGH]
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

-- [2. GHI ĐÈ KEY FILES HỢP LỆ VÀO WORKSPACE]
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

-- [3. HOOK REQUEST: BYPASS 100% HỆ THỐNG AUTH CỦA REALKID (ĐẦY ĐỦ TRƯỜNG UNC)]
local AUTH_PAYLOAD = 'loadstring(game:HttpGet("https://cdnrealkidhub.pages.dev/anhdomixi.lua"))()'
local primaryReq = request or http_request or (syn and syn.request) or (http and http.request)

if primaryReq and hookfunction then
    local orig_req
    orig_req = hookfunction(primaryReq, function(options)
        if type(options) == "table" and type(options.Url) == "string" then
            local url = options.Url:lower()
            if url:find("trungdao2k4") or (options.Body and tostring(options.Body):find("auth")) then
                return {
                    Success = true,
                    success = true,
                    StatusCode = 200,
                    status_code = 200,
                    Status = 200,
                    status = 200,
                    StatusMessage = "OK",
                    Headers = { ["content-type"] = "text/plain" },
                    Body = AUTH_PAYLOAD,
                    body = AUTH_PAYLOAD
                }
            elseif url:find("realkidapi") or url:find("workers.dev") then
                return {
                    Success = true,
                    success = true,
                    StatusCode = 200,
                    status_code = 200,
                    Status = 200,
                    status = 200,
                    StatusMessage = "OK",
                    Headers = { ["content-type"] = "application/json" },
                    Body = '{"success":true,"status":"ok"}',
                    body = '{"success":true,"status":"ok"}'
                }
            end
        end
        return orig_req(options)
    end)
end

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
    if type(src) == "string" and (string.find(src, "Nousigi Hub") or string.find(src, "dut dit") or string.find(src, "T1UIColor") or string.find(src, "RealKid")) then
        print("[+] Intercepted UI Library! Chuyển hướng sang CGH_Library...")
        local customLib
        if isfile and isfile("CGH_Library.lua") then
            customLib = readfile("CGH_Library.lua")
        else
            customLib = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Library.lua?t=" .. tostring(os.time()))
        end
        return orig_loadstring(customLib)
    end
    
    if chunkname ~= nil then
        return orig_loadstring(src, chunkname, ...)
    else
        return orig_loadstring(src)
    end
end)

-- [6. TỰ ĐỘNG BẤM KIỂM TRA NẾU KHUNG KEY REALKID XUẤT HIỆN]
task.spawn(function()
    for _ = 1, 30 do
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
                        elseif getconnections then
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

-- [7. KÍCH HOẠT SCRIPT GỐC REALKID ĐÃ ĐƯỢC PATCH (CHUẨN 1.5MB GITHUB CŨ)]
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
        coreScript = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/BloxFruits_Core.luau?t=" .. tostring(os.time()))
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
    warn("[!] Không thể nạp BloxFruits_Core.luau!")
end
