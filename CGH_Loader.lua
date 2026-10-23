--[[
    =======================================================
                        CGH HUB
               Blox Fruits - Vietnam Edition
           Repository: https://github.com/HuyHahack/script
    =======================================================
--]]

local function log(msg)
    pcall(function()
        local formatted = os.date("[%H:%M:%S] ") .. tostring(msg)
        if appendfile then
            appendfile("cgh_debug.txt", formatted .. "\n")
        elseif writefile then
            writefile("cgh_debug.txt", formatted .. "\n")
        end
    end)
    print(tostring(msg))
end

log("[+] CGH Hub Blox Fruits v2: Đang chuẩn bị môi trường...")

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

-- [3. TỰ ĐỘNG DỌN DẸP MỌI KHUNG KEY GUI CŨ TRÊN MÀN HÌNH NẾU CÒN SÓT LẠI]
task.spawn(function()
    local function cleanGuis(parent)
        if not parent then return end
        for _, gui in ipairs(parent:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Name ~= "CGH_Auth_GUI" and gui.Name ~= "CGH Hub GUI" and gui.Name ~= "Nousigi Hub GUI" then
                local shouldKill = false
                local lowerName = gui.Name:lower()
                if lowerName:find("realkid") or lowerName:find("key") or lowerName:find("auth") then
                    shouldKill = true
                else
                    for _, desc in ipairs(gui:GetDescendants()) do
                        if desc:IsA("TextLabel") or desc:IsA("TextButton") then
                            local txt = desc.Text:lower()
                            if txt:find("xin chào anh em") or txt:find("kiểm tra") or txt:find("kết nối gián đoạn") then
                                shouldKill = true
                                break
                            end
                        end
                    end
                end
                if shouldKill then
                    pcall(function() gui:Destroy() end)
                end
            end
        end
    end

    for _ = 1, 15 do
        pcall(function()
            cleanGuis(game:GetService("CoreGui"))
            local lp = game:GetService("Players").LocalPlayer
            if lp and lp:FindFirstChild("PlayerGui") then
                cleanGuis(lp.PlayerGui)
            end
        end)
        task.wait(0.2)
    end
end)

-- [4. HOOK REQUEST: BẢO VỆ & PHÂN LOẠI ENDPOINT CHUẨN XÁC]
local AUTH_PAYLOAD = 'loadstring(game:HttpGet("https://cdnrealkidhub.pages.dev/anhdomixi.lua"))()'
local function hookReq(reqFunc)
    if not reqFunc or not hookfunction then return reqFunc end
    local orig_req
    orig_req = hookfunction(reqFunc, function(options)
        if type(options) == "table" and type(options.Url) == "string" then
            local url = options.Url:lower()
            -- Endpoint xác thực key: trả về payload nạp engine
            if url:find("trungdao2k4") or (options.Body and tostring(options.Body):find("auth")) then
                return {
                    Success = true,
                    success = true,
                    StatusCode = 200,
                    status = 200,
                    StatusMessage = "OK",
                    Headers = { ["content-type"] = "text/plain" },
                    Body = AUTH_PAYLOAD,
                    body = AUTH_PAYLOAD
                }
            -- Endpoint telemetry / tracker trái / boss: trả về JSON hợp lệ để không lỗi JSONDecode
            elseif url:find("realkidapi") or url:find("workers.dev") then
                return {
                    Success = true,
                    success = true,
                    StatusCode = 200,
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
    return orig_req
end

pcall(function() if request then hookReq(request) end end)
pcall(function() if http_request then hookReq(http_request) end end)
pcall(function() if syn and syn.request then hookReq(syn.request) end end)
pcall(function() if http and http.request then hookReq(http.request) end end)

-- [5. HOOK SETCLIPBOARD: MỌI LINK DISCORD ĐỀU THÀNH RICK ROLL]
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

-- [6. HOOK LOADSTRING: ÉP TOÀN BỘ UI SANG CGH_LIBRARY SẠCH]
local orig_loadstring
orig_loadstring = hookfunction(loadstring, function(src, chunkname, ...)
    if type(src) == "string" and (string.find(src, "Nousigi Hub") or string.find(src, "dut dit") or string.find(src, "T1UIColor") or string.find(src, "RealKid")) then
        log("[+] Intercepted UI Library! Chuyển hướng sang CGH_Library...")
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

-- [7. KÍCH HOẠT THẲNG LÕI GAME GỐC REALKID (BYPASSED HOÀN TOÀN TẦNG KEY)]
log("[+] CGH Hub Blox Fruits v2: Đang nạp engine chính...")

local coreScript = nil

-- Ưu tiên 1: File lưu trong workspace máy
if isfile and isfile("BloxFruits_Core.luau") then
    local content = readfile("BloxFruits_Core.luau")
    if content and #content > 1000 then
        coreScript = content
        log("[+] Đã nạp BloxFruits_Core từ workspace máy (" .. tostring(#content) .. " bytes)")
    end
end

-- Ưu tiên 2: Tải từ GitHub repo chính thức
if not coreScript or #coreScript < 1000 then
    local ok2, ghPayload = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/BloxFruits_Core.luau?t=" .. tostring(os.time()))
    end)
    if ok2 and ghPayload and #ghPayload > 1000 then
        coreScript = ghPayload
        log("[+] Đã nạp BloxFruits_Core từ GitHub (" .. tostring(#ghPayload) .. " bytes)")
    end
end

-- Ưu tiên 3: Tải trực tiếp từ CDN tác giả
if not coreScript or #coreScript < 1000 then
    local ok, livePayload = pcall(function()
        return game:HttpGet("https://cdnrealkidhub.pages.dev/anhdomixi.lua")
    end)
    if ok and livePayload and #livePayload > 1000 then
        coreScript = livePayload
        log("[+] Đã nạp BloxFruits_Core từ CDN (" .. tostring(#livePayload) .. " bytes)")
    end
end

if coreScript and #coreScript > 1000 then
    local fn, err = loadstring(coreScript)
    if fn then
        log("[+] Compile mã nguồn Blox Fruits thành công! Đang thực thi...")
        local success, runErr = xpcall(fn, function(e)
            return tostring(e) .. "\n" .. debug.traceback()
        end)
        if success then
            log("[+] CGH Hub Blox Fruits đã kích hoạt hoàn tất!")
        else
            log("[!] LỖI RUNTIME BLOX FRUITS: " .. tostring(runErr))
        end
    else
        log("[!] LỖI COMPILE BLOX FRUITS: " .. tostring(err))
    end
else
    log("[!] Không thể nạp mã nguồn Blox Fruits (file rỗng hoặc bị chặn mạng)!")
end
