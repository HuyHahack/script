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
print("          Khoi chay he thong Blox Fruits v5...         ")
print("=======================================================")

local HttpService = game:GetService("HttpService")

-- [1. THIẾT LẬP MÔI TRƯỜNG & TRẠNG THÁI TOÀN CỤC CHO CGH HUB]
getgenv().Nousigi = true
getgenv().CGH = true
getgenv().Config = true
getgenv().UIToggled = true
getgenv().ReadyForGuiLoaded = true

-- [2. ĐẢM BẢO FILE KEY LUÔN TỒN TẠI VÀ BẢO VỆ TUYỆT ĐỐI]
local PERMANENT_KEY = "CGH_PERMANENT_KEYLESS_AUTH_2099"
local targetKeyFiles = {
    "TrauHub_Save.txt",
    "RealKid_Key_" .. tostring(game.PlaceId) .. ".txt",
    "RealKid_Key_100117331123089.txt",
    "RealKid_Key_11348033272.txt",
    "RealKid_Key_11584810072.txt",
    "RealKid_Key_79091703265657.txt",
    "CGH_Key.txt"
}

local function ensureKeyFiles()
    for _, f in ipairs(targetKeyFiles) do
        pcall(function()
            if writefile then
                writefile(f, PERMANENT_KEY)
            end
        end)
    end
end
ensureKeyFiles()

task.spawn(function()
    while task.wait(1) do
        ensureKeyFiles()
    end
end)

-- [3. TỰ ĐỘNG TẢI VÀ CACHE MỌI TÀI NGUYÊN VÀO WORKSPACE]
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
    if writefile and (not isfile or not isfile("BloxFruits_Engine.luau")) then
        local engineData = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/BloxFruits_Engine.luau?t=" .. tostring(os.time()))
        writefile("BloxFruits_Engine.luau", engineData)
    end
end)

pcall(function()
    if writefile and (not isfile or not isfile("BloxFruits_Core.luau")) then
        local coreData = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/BloxFruits_Core.luau?t=" .. tostring(os.time()))
        writefile("BloxFruits_Core.luau", coreData)
    end
end)

-- [4. BỘ MÃ HÓA BASE64-URL & SHA256 CHUẨN]
local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function toBase64Url(data)
    local b64
    if crypt and crypt.base64encode then
        b64 = crypt.base64encode(data)
    elseif crypt and crypt.base64_encode then
        b64 = crypt.base64_encode(data)
    elseif base64_encode then
        b64 = base64_encode(data)
    elseif base64encode then
        b64 = base64encode(data)
    elseif base64 and base64.encode then
        b64 = base64.encode(data)
    elseif syn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.encode then
        b64 = syn.crypt.base64.encode(data)
    else
        b64 = ((data:gsub('.', function(x) 
            local r,b='',x:byte()
            for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
            return r;
        end)..'0000'):gsub('%d%d%d%d%d%d', function(x)
            local c=0
            for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
            return b64chars:sub(c+1,c+1)
        end)..({ '', '==', '=' })[#data%3+1])
    end
    return b64:gsub("%+", "-"):gsub("/", "_"):gsub("=", "")
end

local function getSha256(msg)
    if crypt and crypt.hash then
        local ok, res = pcall(crypt.hash, msg, "sha256")
        if ok and res and #res == 64 then return string.lower(res) end
    end
    if sha256 then
        local ok, res = pcall(sha256, msg)
        if ok and res and #res == 64 then return string.lower(res) end
    end
    if syn and syn.crypt and syn.crypt.hash then
        local ok, res = pcall(syn.crypt.hash, "sha256", msg)
        if ok and res and #res == 64 then return string.lower(res) end
    end
    if msg == "CGH_PERMANENT_KEYLESS_AUTH_2099" then
        return "ca053699b25a99e4aecdde9be4a4562a6155e32bde18b49903d9b5f4dcc17bc6"
    elseif msg == "TRAU_4D0281B6EB4A9BFDD18753A4B92860F9716BC4C439E1C448" then
        return "e9a2ee3201f298a28cc9c2e43df5ba50384f4e87d128fc61f5f7ccc0c349396d"
    elseif msg == "" or not msg then
        return "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
    end
    return "ca053699b25a99e4aecdde9be4a4562a6155e32bde18b49903d9b5f4dcc17bc6"
end

-- [5. HOOK REQUEST: BẺ KHÓA ĐỘNG CLOUDFLARE WORKERS (HẠN NĂM 2099, KHỚP SHA256 100%)]
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
                local currentNonce = reqData.nonce or "CGH-NONCE"
                local currentHwid = reqData.hwid or ""
                local currentHwid2 = reqData.hwid2 or ""
                local currentKey = (type(reqData.key) == "string" and #reqData.key > 0 and reqData.key) or PERMANENT_KEY
                local currentKeyHash = getSha256(currentKey)

                local dynPayload = {
                    version = 3,
                    audience = "realkid-auth",
                    nonce = currentNonce,
                    hwid = currentHwid,
                    hwid2 = currentHwid2,
                    keyHash = currentKeyHash,
                    status = "AUTHORIZED",
                    expires = "23:59 - 31/12/2035"
                }

                local b64Payload = toBase64Url(HttpService:JSONEncode(dynPayload))
                local mockJwt = HttpService:JSONEncode({
                    version = 3,
                    alg = "RS256",
                    kid = "a987fcfbfc8fc7e5",
                    payload = b64Payload,
                    signature = "iCwsQPqv7rP3ZKcDNRmHfCyl9B9kDiiUKJOaqzwaqwZoHFJaQxmFVjHAwcyqUqB_MZTGiXKVwJpCLfo2-KIuDxlNhleE2X14T11A7mVh-HKqsTOh7MYObk6waj292jwcBoLqJGjIWnbFr5hs347PHtPVSF4_V8SVrOobofUC927Tda0IvZ41dxCkMyX5J12o_yiefTwm8aDgWH390fUuYmvSkPaWvtLJVuS_ERNsJW5lFZspx0nVKtm6Akk3-r6Pz4FOI5_1LFPnQ_72IQe0Sk-0jNC30MLqokSMLViEsDN_wDY5itN7VGw2PgspKMnfbDm_Md5hjbT0V8jRYGOwyA"
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


end

-- [6. HOOK GAME.HTTPGET: PHỤC VỤ OFFLINE 100% CÁC FILE TRONG WORKSPACE]
pcall(function()
    if hookfunction and game and game.HttpGet then
        local orig_httpget
        orig_httpget = hookfunction(game.HttpGet, function(self, url, ...)
            local lowerUrl = tostring(url):lower()
            if lowerUrl:find("anhdomixi") and not lowerUrl:find("raw.githubusercontent.com/traurobloxdeptrai") then
                if isfile and isfile("anhdomixi.lua") then
                    local c = readfile("anhdomixi.lua")
                    if c and #c > 1000 then return c end
                end
            elseif lowerUrl:find("raw.githubusercontent.com/traurobloxdeptrai") or lowerUrl:find("bloxfruits_engine") then
                if isfile and isfile("BloxFruits_Engine.luau") then
                    local c = readfile("BloxFruits_Engine.luau")
                    if c and #c > 1000 then return c end
                end
            elseif lowerUrl:find("bloxfruits_core") or (lowerUrl:find("bloxfruits%.lua") and not lowerUrl:find("github.com/realkidhub")) then
                if isfile and isfile("BloxFruits_Core.luau") then
                    local c = readfile("BloxFruits_Core.luau")
                    if c and #c > 1000 then return c end
                end
            elseif lowerUrl:find("cgh_library") or lowerUrl:find("nousigi") then
                if isfile and isfile("CGH_Library.lua") then
                    local c = readfile("CGH_Library.lua")
                    if c and #c > 1000 then return c end
                end
            end
            return orig_httpget(self, url, ...)
        end)
    end
end)

-- [7. HOOK STARTERGUI NOTIFICATION - TOÀN BỘ CHUYỂN THÀNH CGH HUB]
pcall(function()
    local StarterGui = game:GetService("StarterGui")
    if hookfunction and StarterGui and StarterGui.SetCore then
        local orig_setcore
        orig_setcore = hookfunction(StarterGui.SetCore, function(self, name, data, ...)
            if name == "SendNotification" and type(data) == "table" then
                local title = tostring(data.Title or "")
                local text = tostring(data.Text or "")
                
                -- Ngăn chặn triệt để thông báo đòi key
                if text:lower():find("nhập key") or text:lower():find("nhap key") or text:lower():find("vui lòng nhập") then
                    data.Title = "CGH Hub"
                    data.Text = "Hệ thống Blox Fruits đã sẵn sàng!"
                else
                    data.Title = title:gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Nousigi", "CGH Hub"):gsub("ReadKid", "CGH Hub"):gsub("TrauHub", "CGH Hub")
                    data.Text = text:gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Nousigi", "CGH Hub"):gsub("ReadKid", "CGH Hub"):gsub("TrauHub", "CGH Hub")
                end
            end
            return orig_setcore(self, name, data, ...)
        end)
    end
end)

-- [8. HOOK SETCLIPBOARD - CHỐNG INVITE DISCORD RÁC]
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

-- [9. HOOK LOADSTRING: TRÁO GIAO DIỆN SANG CGH_LIBRARY VÀ BẺ KHÓA TRAUHUBLIB]
local in_loadstring = false
local orig_loadstring
if not getgenv().__CGH_LS_HOOKED then
    getgenv().__CGH_LS_HOOKED = true
    orig_loadstring = hookfunction(loadstring, function(src, chunkname, ...)
        if type(src) ~= "string" then
            if chunkname ~= nil then return orig_loadstring(src, chunkname, ...) else return orig_loadstring(src) end
        end
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

    -- Tráo UI Library sang CGH Library (Cờ đỏ sao vàng, Checkbox Vàng Gold)
    if type(src) == "string" and (string.find(src, "Nousigi Hub") or string.find(src, "dut dit") or string.find(src, "T1UIColor")) then
        in_loadstring = true
        print("[+] Phat hien UI Library! Chuyen huong sang CGH_Library (Co Viet Nam - Gold Checkbox)...")
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


end

-- [10. HOOK SERVER HOP & QUEUE_ON_TELEPORT: DUY TRÌ BẢN QUYỀN CGH HUB KHI CHUYỂN SERVER]
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

-- [11. KHỞI CHẠY ENGINE BLOX FRUITS 1.5MB]
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

-- [12. FAIL-SAFE ĐẢM BẢO GIAO DIỆN & TÍNH NĂNG NẠP 100%]
task.delay(3.5, function()
    local cg = game:GetService("CoreGui")
    if not cg:FindFirstChild("CGH Hub GUI") and not cg:FindFirstChild("Nousigi Hub GUI") then
        print("[+] Fail-safe: Nap truc tiep Blox Fruits Features & UI...")
        local sCode = (isfile and isfile("anhdomixi.lua") and readfile("anhdomixi.lua")) or game:HttpGet("https://cdnrealkidhub.pages.dev/anhdomixi.lua")
        if sCode and #sCode > 100 then
            local uifn, uierr = loadstring(sCode)
            if uifn then
                task.spawn(function()
                    local ok, err = pcall(uifn)
                    if not ok then warn("[!] Runtime Fail-safe anhdomixi: " .. tostring(err)) end
                end)
            else
                warn("[!] Compile Fail-safe anhdomixi: " .. tostring(uierr))
            end
        end
    end
end)
