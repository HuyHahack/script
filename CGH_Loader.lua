--[[
    =======================================================
                     CGH HUB - BLOX FRUITS
                 PHIÊN BẢN ĐỘC QUYỀN (KEYLESS)
               Vĩnh viễn không cần Key - 1 Click Run
           Repository: https://github.com/HuyHahack/script
    =======================================================
--]]

print("=======================================================")
print("            CGH HUB - BLOX FRUITS (KEYLESS)            ")
print("          Khoi chay he thong Blox Fruits v3...         ")
print("=======================================================")

-- [1. THIẾT LẬP MÔI TRƯỜNG & TRẠNG THÁI TOÀN CỤC CHO CGH HUB]
getgenv().Nousigi = true
getgenv().CGH = true
getgenv().Config = true
getgenv().UIToggled = true
getgenv().ReadyForGuiLoaded = true

-- [2. TỰ ĐỘNG TẢI VÀ CACHE MỌI TÀI NGUYÊN VÀO WORKSPACE]
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

pcall(function()
    if writefile and (not isfile or not isfile("BloxFruits_Core.luau")) then
        local coreData = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/BloxFruits_Core.luau?t=" .. tostring(os.time()))
        writefile("BloxFruits_Core.luau", coreData)
    end
end)

-- [3. HOOK SETCLIPBOARD: LINK RICKROLL]
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

-- [4. HOOK GAME:HTTPGET: CHUYỂN HƯỚNG MỌI CUỘC GỌI ANHDOMIXI / CORE SANG FILE MÁY]
pcall(function()
    if hookfunction and game and game.HttpGet then
        local orig_httpget
        orig_httpget = hookfunction(game.HttpGet, function(self, url, ...)
            if type(url) == "string" then
                local lurl = url:lower()
                if lurl:find("anhdomixi") or lurl:find("traurobloxdeptrai") then
                    if isfile and isfile("anhdomixi.lua") then
                        return readfile("anhdomixi.lua")
                    end
                elseif lurl:find("bloxfruits%.lua") and not lurl:find("cgh") then
                    if isfile and isfile("BloxFruits_Core.luau") then
                        return readfile("BloxFruits_Core.luau")
                    end
                end
            end
            return orig_httpget(self, url, ...)
        end)
    end
end)

if hookmetamethod then
    local orig_nc
    orig_nc = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if method == "HttpGet" or method == "httpGet" or method == "HttpGetAsync" then
            local args = {...}
            local url = args[1]
            if type(url) == "string" then
                local lurl = url:lower()
                if lurl:find("anhdomixi") or lurl:find("traurobloxdeptrai") then
                    if isfile and isfile("anhdomixi.lua") then
                        return readfile("anhdomixi.lua")
                    end
                elseif lurl:find("bloxfruits%.lua") and not lurl:find("cgh") then
                    if isfile and isfile("BloxFruits_Core.luau") then
                        return readfile("BloxFruits_Core.luau")
                    end
                end
            end
        end
        return orig_nc(self, ...)
    end)
end

-- [5. HOOK REQUEST: BỎ QUA TELEMETRY SERVER ĐÃ CHẾT ĐỂ CHỐNG TREO]
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

-- [6. HOOK LOADSTRING: TỰ ĐỘNG BỌC GIAO DIỆN CGH_LIBRARY CỜ VIỆT NAM]
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

    if type(src) == "string" and (string.find(src, "Nousigi Hub") or string.find(src, "dut dit") or string.find(src, "T1UIColor")) then
        in_loadstring = true
        print("[+] Phat hien UI Library! Chuyen huong sang CGH_Library (Co Viet Nam)...")
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

    if chunkname ~= nil then
        return orig_loadstring(src, chunkname, ...)
    else
        return orig_loadstring(src)
    end
end)

-- [7. KHỞI CHẠY ENGINE BLOX FRUITS GỐC 1.5MB (HOÀN TOÀN KHÔNG CẦN KEY)]
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
    local fn, err = loadstring(coreScript)
    if fn then
        print("[+] Bat dau thuc thi Blox Fruits engine...")
        task.spawn(function()
            local ok, runErr = pcall(fn)
            if not ok then
                warn("[!] Runtime BloxFruits_Core: " .. tostring(runErr))
            end
        end)
    else
        warn("[!] Compile BloxFruits_Core: " .. tostring(err))
    end
else
    warn("[!] Khong the doc BloxFruits_Core.luau!")
end

-- [8. FAIL-SAFE: TỰ ĐỘNG KÍCH HOẠT GIAO DIỆN & TÍNH NĂNG NẾU ENGINE CHẬM]
task.delay(1.5, function()
    local cg = game:GetService("CoreGui")
    if not cg:FindFirstChild("CGH Hub GUI") and not cg:FindFirstChild("Nousigi Hub GUI") then
        print("[+] Fail-safe: Nap truc tiep Blox Fruits UI & Features...")
        local sCode = nil
        if isfile and isfile("anhdomixi.lua") then
            sCode = readfile("anhdomixi.lua")
        else
            sCode = game:HttpGet("https://cdnrealkidhub.pages.dev/anhdomixi.lua")
        end
        if sCode and #sCode > 100 then
            local uifn, uierr = loadstring(sCode)
            if uifn then
                task.spawn(uifn)
                print("[+] CGH Hub Blox Fruits da khoi dong thanh cong!")
            else
                warn("[!] Loi khoi dong UI: " .. tostring(uierr))
            end
        end
    else
        print("[+] CGH Hub GUI da xuat hien tren man hinh thanh cong!")
    end
end)
