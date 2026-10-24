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

local HttpService = game:GetService("HttpService")

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
    if writefile and (not isfile or not isfile("CGH_Key_System.luau")) then
        local keyLibData = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Key_System.luau?t=" .. tostring(os.time()))
        writefile("CGH_Key_System.luau", keyLibData)
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

-- [3. BỘ MÃ HÓA BASE64 THUẦN LUA]
local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function toBase64(data)
    if crypt and crypt.base64encode then return crypt.base64encode(data) end
    if syn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.encode then return syn.crypt.base64.encode(data) end
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b64chars:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

-- [4. HOOK REQUEST: BẺ KHÓA ĐỘNG CLOUDFLARE WORKERS (HẠN NĂM 2099)]
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
            if url:find("webhook%.trungdao2k4") or url:find("workers%.dev") then
                in_call = false
                local b = opt.Body or opt.body or ""
                local reqData = {}
                pcall(function() reqData = HttpService:JSONDecode(b) end)
                local currentNonce = reqData.nonce or "DYNAMIC-NONCE"
                local currentHwid = reqData.hwid or ""
                local currentHwid2 = reqData.hwid2 or ""

                local dynPayload = {
                    version = 3,
                    audience = "realkid-auth",
                    nonce = currentNonce,
                    hwid = currentHwid,
                    hwid2 = currentHwid2,
                    keyHash = "e9a2ee3201f298a28cc9c2e43df5ba50384f4e87d128fc61f5f7ccc0c349396d",
                    status = "AUTHORIZED",
                    expires = "23:59 - 31/12/2099"
                }

                local b64Payload = toBase64(HttpService:JSONEncode(dynPayload))
                local mockJwt = HttpService:JSONEncode({
                    version = 3,
                    alg = "RS256",
                    kid = "a987fcfbfc8fc7e5",
                    payload = b64Payload,
                    signature = "sz5-_tDSs0mKh9Mlu4YWjzQk8xNVm9FgXZ7IiaMhFPpiX6tGNNMYjFXnwcYAkLgjpOkFHhBIVzl1USZ_gowgRoYF-5NNGNkKUdyi0smsMYiTFqNzr3u0S6y8HD__sxK9pdFpEVPHblTzxTlkNk0KDkOZ9uZoK-gNqGslLC0gM4aChko2-kb3ehhy-cQMKL18G65ti1vS6R__ZmVOFUy3ZZjWduSZNSwzhjOoFSxZsTfsJMNCj0mlWlKkzzVgTXovpf7JDdWWBXMpKI3tbHkkz7NA-H_w1YQSnYlej64eAa0nXxBjduDzQqRVeJUpyMHLtJEtVnUJqJQm-X-B4tFs2A"
                })

                print("[+] CGH Keyless: Tu dong xac thuc ban quyen thanh cong (Vinh vien 2099)!")
                return {
                    Success = true, success = true,
                    StatusCode = 200, status_code = 200,
                    Status = 200, status = 200,
                    StatusMessage = "OK", status_message = "OK",
                    Headers = { ["content-type"] = "application/json" },
                    headers = { ["content-type"] = "application/json" },
                    Body = mockJwt, body = mockJwt
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

-- [5. HOOK SERVER HOP & QUEUE_ON_TELEPORT: CHỐNG BỊ VĂNG VỀ REALKID GỐC]
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

pcall(function()
    local orig_q = getQOT()
    if orig_q and hookfunction then
        hookfunction(orig_q, function(script_str)
            return orig_q(CGH_TELEPORT_PERSIST)
        end)
    end
    local cgh_qot = function(str)
        local raw = getQOT()
        if raw then return raw(CGH_TELEPORT_PERSIST) end
    end
    queue_on_teleport = cgh_qot
    if syn then syn.queue_on_teleport = cgh_qot end
    if fluxus then fluxus.queue_on_teleport = cgh_qot end
    queueonteleport = cgh_qot
end)

pcall(function()
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
    if lp then
        lp.OnTeleport:Connect(function(state)
            applyCGHQueue()
        end)
    end
end)

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

applyCGHQueue()

-- [6. HOOK STARTERGUI NOTIFICATION]
pcall(function()
    local StarterGui = game:GetService("StarterGui")
    if hookfunction and StarterGui and StarterGui.SetCore then
        local orig_setcore
        orig_setcore = hookfunction(StarterGui.SetCore, function(self, name, data, ...)
            if name == "SendNotification" and type(data) == "table" then
                if data.Title then data.Title = tostring(data.Title):gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Nousigi", "CGH Hub") end
                if data.Text then data.Text = tostring(data.Text):gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Nousigi", "CGH Hub") end
            end
            return orig_setcore(self, name, data, ...)
        end)
    end
end)

-- [7. HOOK SETCLIPBOARD]
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

-- [8. HOOK LOADSTRING: TRÁO GIAO DIỆN SANG CGH_LIBRARY VÀ BẺ KHÓA TRAUHUBLIB]
local in_loadstring = false
local orig_loadstring
orig_loadstring = hookfunction(loadstring, function(src, chunkname, ...)
    if in_loadstring then
        if chunkname ~= nil then return orig_loadstring(src, chunkname, ...) else return orig_loadstring(src) end
    end

    -- Tráo Key System Library sang bản tàng hình tự động kích hoạt
    if type(src) == "string" and (string.find(src, "TrauHubLib") or string.find(src, "TrauHubKeySystem") or string.find(src, "CreateParticles")) then
        in_loadstring = true
        print("[+] Phat hien Key System Library! Chuyen huong sang CGH_Key_System (Bypass Invisible)...")
        local customKeyLib
        if isfile and isfile("CGH_Key_System.luau") then
            customKeyLib = readfile("CGH_Key_System.luau")
        else
            customKeyLib = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Key_System.luau?t=" .. tostring(os.time()))
        end
        local res = orig_loadstring(customKeyLib)
        in_loadstring = false
        return res
    end

    -- Tráo UI Library sang CGH Library (Cờ đỏ sao vàng)
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

-- [9. KHỞI CHẠY ENGINE BLOX FRUITS 1.5MB (TỰ ĐỘNG BẺ KHÓA HOÀN TOÀN TÀNG HÌNH)]
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
            if not ok then warn("[!] Runtime BloxFruits_Core: " .. tostring(runErr)) end
        end)
    else
        warn("[!] Compile BloxFruits_Core: " .. tostring(err))
    end
end

-- [10. FAIL-SAFE: KÍCH HOẠT THÊM ANHDOMIXI ĐẢM BẢO TÍNH NĂNG CHẠY 100%]
task.delay(1.5, function()
    local cg = game:GetService("CoreGui")
    if not cg:FindFirstChild("CGH Hub GUI") and not cg:FindFirstChild("Nousigi Hub GUI") then
        print("[+] Fail-safe: Nap truc tiep Blox Fruits Features...")
        local sCode = (isfile and isfile("anhdomixi.lua") and readfile("anhdomixi.lua")) or game:HttpGet("https://cdnrealkidhub.pages.dev/anhdomixi.lua")
        if sCode and #sCode > 100 then
            local uifn = loadstring(sCode)
            if uifn then task.spawn(uifn) end
        end
    end
end)
