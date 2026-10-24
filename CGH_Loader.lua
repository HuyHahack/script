--[[
    =======================================================
                     CGH HUB - BLOX FRUITS
                 PHIÊN BẢN ĐẶC QUYỀN (KEYLESS)
               Vĩnh viễn không cần Key - 1 Click Run
               Tự động duy trì khi Hop / Rejoin Server
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

-- [3. HOOK SERVER HOP & QUEUE_ON_TELEPORT: CHỐNG BỊ VĂNG VỀ REALKID GỐC]
local CGH_TELEPORT_PERSIST = [=[
    repeat task.wait() until game:IsLoaded()
    pcall(function()
        if isfile and isfile("CGH_Loader.lua") then
            loadstring(readfile("CGH_Loader.lua"))()
        else
            loadstring(game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Loader.lua?t=" .. tostring(os.time())))()
        end
    end)
]=]

local function getQOT()
    return queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or queueonteleport
end

local function applyCGHQueue()
    local q = getQOT()
    if q then
        pcall(function()
            q(CGH_TELEPORT_PERSIST)
        end)
    end
end

-- Hook trực tiếp hàm queue_on_teleport của executor
pcall(function()
    local orig_q = getQOT()
    if orig_q and hookfunction then
        hookfunction(orig_q, function(script_str)
            -- Bất kỳ script nào (kể cả RealKid gốc) gọi queue_on_teleport thì đều bị tráo bằng CGH_Loader
            return orig_q(CGH_TELEPORT_PERSIST)
        end)
    end
    
    local cgh_qot = function(str)
        local raw = getQOT()
        if raw then
            return raw(CGH_TELEPORT_PERSIST)
        end
    end
    queue_on_teleport = cgh_qot
    if syn then syn.queue_on_teleport = cgh_qot end
    if fluxus then fluxus.queue_on_teleport = cgh_qot end
    queueonteleport = cgh_qot
end)

-- Lắng nghe sự kiện người chơi chuẩn bị dịch chuyển / nhảy server
pcall(function()
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
    if lp then
        lp.OnTeleport:Connect(function(state)
            applyCGHQueue()
        end)
    end
end)

-- Hook TeleportService để luôn nạp CGH_Loader trước khi đổi server
pcall(function()
    local TeleportService = game:GetService("TeleportService")
    local tpMethods = {"Teleport", "TeleportToPlaceInstance", "TeleportPartyAsync", "TeleportToSpawnByName"}
    for _, method in ipairs(tpMethods) do
        if TeleportService[method] and hookfunction then
            local orig_method
            orig_method = hookfunction(TeleportService[method], function(self, ...)
                applyCGHQueue()
                return orig_method(self, ...)
            end)
        end
    end
end)

-- Nạp sẵn 1 lần phòng trường hợp hop server bất ngờ
applyCGHQueue()

-- [3.5. HOOK STARTERGUI NOTIFICATION: CHUYEN HOAN TOAN NOTIFICATION SANG CGH HUB]
pcall(function()
    local StarterGui = game:GetService("StarterGui")
    if hookfunction and StarterGui and StarterGui.SetCore then
        local orig_setcore
        orig_setcore = hookfunction(StarterGui.SetCore, function(self, name, data, ...)
            if name == "SendNotification" and type(data) == "table" then
                if data.Title then
                    data.Title = tostring(data.Title):gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Nousigi", "CGH Hub")
                end
                if data.Text then
                    data.Text = tostring(data.Text):gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Nousigi", "CGH Hub")
                end
            end
            return orig_setcore(self, name, data, ...)
        end)
    end
end)

-- [4. HOOK SETCLIPBOARD: LINK RICKROLL]
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

-- [5. HOOK GAME:HTTPGET: CHUYỂN HƯỚNG MỌI CUỘC GỌI ANHDOMIXI / CORE SANG FILE MÁY]
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
                elseif (lurl:find("bloxfruits%.lua") or lurl:find("bloxfruits")) and not lurl:find("cgh") then
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
                elseif (lurl:find("bloxfruits%.lua") or lurl:find("bloxfruits")) and not lurl:find("cgh") then
                    if isfile and isfile("BloxFruits_Core.luau") then
                        return readfile("BloxFruits_Core.luau")
                    end
                end
            end
        end
        return orig_nc(self, ...)
    end)
end

-- [6. HOOK REQUEST: BỎ QUA TELEMETRY SERVER ĐÃ CHẾT ĐỂ CHỐNG TREO]
local hooked_fns = {}
local function hookReq(fn)
    if not fn or type(fn) ~= "function" or hooked_fns[fn] or not hookfunction then return fn end
    hooked_fns[fn] = true

    local in_call = false
    local orig
    orig = hookfunction(fn, function(opt)
        if in_call then return orig(opt) end
        in_call = true

        -- Cho phep cac request API hop server di qua tu nhien de RealKidHop hoat dong
        if type(opt) == "table" then
            local url = tostring(opt.Url or opt.url or ""):lower()
            -- Khong chan realkidapi nua de nhan danh sach server hop
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

-- [7. HOOK LOADSTRING: TỰ ĐỘNG BỌC GIAO DIỆN CGH_LIBRARY CỜ VIỆT NAM]
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

-- [8. KHỞI CHẠY ENGINE BLOX FRUITS GỐC 1.5MB (HOÀN TOÀN KHÔNG CẦN KEY)]
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

-- [9. FAIL-SAFE: TỰ ĐỘNG KÍCH HOẠT GIAO DIỆN & TÍNH NĂNG NẾU ENGINE CHẬM]
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
