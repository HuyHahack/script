--[[
    =======================================================
                      CGH HUB - SERVER HOP
                 PHIÊN BẢN ĐẶC QUYỀN (KEYLESS)
               Vĩnh viễn không cần Key - 1 Click Run
               Tự động săn Mirage, Full Moon, Boss, Fruit
           Repository: https://github.com/HuyHahack/script
    =======================================================
--]]

print("=======================================================")
print("             CGH HUB - SERVER HOP (KEYLESS)            ")
print("          Khoi chay he thong Server Hop v3...          ")
print("=======================================================")

local HttpService = game:GetService("HttpService")

-- [1. THIẾT LẬP MÔI TRƯỜNG & BIẾN TOÀN CỤC CHO CGH HUB]
getgenv().CGH = true
getgenv().CGH_Hop = true

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

-- [3. TỰ ĐỘNG TẢI VÀ CACHE TÀI NGUYÊN VÀO WORKSPACE]
pcall(function()
    if writefile and (not isfile or not isfile("cgh_logo.png")) then
        local img = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/cgh_logo.png")
        writefile("cgh_logo.png", img)
    end
end)

pcall(function()
    if writefile and (not isfile or not isfile("CGH_Hop_Library.lua")) then
        local lib = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Hop_Library.lua?t=" .. tostring(os.time()))
        writefile("CGH_Hop_Library.lua", lib)
    end
end)

pcall(function()
    if writefile and (not isfile or not isfile("CGH_Key_System.luau")) then
        local keyLib = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Key_System.luau?t=" .. tostring(os.time()))
        writefile("CGH_Key_System.luau", keyLib)
    end
end)

pcall(function()
    if writefile and (not isfile or not isfile("RealKidHop_Raw.lua")) then
        local rawHop = game:HttpGet("https://cdnrealkidhub.pages.dev/RealKidHop.lua")
        writefile("RealKidHop_Raw.lua", rawHop)
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

-- [5. HOOK XÁC THỰC BẢN QUYỀN ĐỘNG (HOÀN TOÀN KHÔNG CẦN KEY THẬT, HẠN NĂM 2099)]
local function hookReq(fn)
    if not fn or type(fn) ~= "function" or not hookfunction then return fn end
    local in_call = false
    local orig_fn
    orig_fn = hookfunction(fn, function(opt, ...)
        if in_call then return orig_fn(opt, ...) end
        in_call = true

        if type(opt) == "table" then
            local url = tostring(opt.Url or opt.url or ""):lower()
            if url:find("webhook%.trungdao2k4") or url:find("workers%.dev") then
                in_call = false
                local b = opt.Body or opt.body or ""
                local reqData = {}
                pcall(function() reqData = HttpService:JSONDecode(b) end)
                local currentNonce = reqData.nonce or "CGH-HOP-NONCE"
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
                    expires = "23:59 - 31/12/2099"
                }

                local b64Payload = toBase64Url(HttpService:JSONEncode(dynPayload))
                local mockJwt = HttpService:JSONEncode({
                    version = 3,
                    alg = "RS256",
                    kid = "a987fcfbfc8fc7e5",
                    payload = b64Payload,
                    signature = "sz5-_tDSs0mKh9Mlu4YWjzQk8xNVm9FgXZ7IiaMhFPpiX6tGNNMYjFXnwcYAkLgjpOkFHhBIVzl1USZ_gowgRoYF-5NNGNkKUdyi0smsMYiTFqNzr3u0S6y8HD__sxK9pdFpEVPHblTzxTlkNk0KDkOZ9uZoK-gNqGslLC0gM4aChko2-kb3ehhy-cQMKL18G65ti1vS6R__ZmVOFUy3ZZjWduSZNSwzhjOoFSxZsTfsJMNCj0mlWlKkzzVgTXovpf7JDdWWBXMpKI3tbHkkz7NA-H_w1YQSnYlej64eAa0nXxBjduDzQqRVeJUpyMHLtJEtVnUJqJQm-X-B4tFs2A"
                })

                print("[+] CGH Keyless (Server Hop): Gia lap xac thuc ban quyen thanh cong (Vinh vien 2099)!")
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

        local res = orig_fn(opt, ...)
        in_call = false
        return res
    end)
    return orig_fn
end

pcall(function() if request then hookReq(request) end end)
pcall(function() if http_request then hookReq(http_request) end end)
pcall(function() if syn and syn.request then hookReq(syn.request) end end)
pcall(function() if http and http.request then hookReq(http.request) end end)

-- [6. HOOK GAME.HTTPGET: PHỤC VỤ OFFLINE WORKSPACE FILE]
pcall(function()
    if hookfunction and game and game.HttpGet then
        local orig_httpget
        orig_httpget = hookfunction(game.HttpGet, function(self, url, ...)
            local lowerUrl = tostring(url):lower()
            if lowerUrl:find("realkidhop") then
                if isfile and isfile("RealKidHop_Raw.lua") then
                    local c = readfile("RealKidHop_Raw.lua")
                    if c and #c > 1000 then return c end
                end
            elseif lowerUrl:find("cgh_hop_library") then
                if isfile and isfile("CGH_Hop_Library.lua") then
                    local c = readfile("CGH_Hop_Library.lua")
                    if c and #c > 1000 then return c end
                end
            end
            return orig_httpget(self, url, ...)
        end)
    end
end)

-- [7. HOOK NOTIFICATION GỐC SANG CGH HUB]
pcall(function()
    local StarterGui = game:GetService("StarterGui")
    if hookfunction and StarterGui and StarterGui.SetCore then
        local orig_setcore
        orig_setcore = hookfunction(StarterGui.SetCore, function(self, name, data, ...)
            if name == "SendNotification" and type(data) == "table" then
                local title = tostring(data.Title or "")
                local text = tostring(data.Text or "")
                data.Title = title:gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Redz", "CGH Hub"):gsub("TrauHub", "CGH Hub")
                data.Text = text:gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Redz", "CGH Hub"):gsub("TrauHub", "CGH Hub")
            end
            return orig_setcore(self, name, data, ...)
        end)
    end
end)

-- [8. HOOK LOADSTRING ĐỔI UI SANG CGH_HOP_LIBRARY]
pcall(function()
    if hookfunction and loadstring then
        local orig_ls
        orig_ls = hookfunction(loadstring, function(source, chunkname, ...)
            if type(source) == "string" then
                -- Tráo Key System Library sang bản tàng hình tự động kích hoạt
                if string.find(source, "TrauHubLib") or string.find(source, "TrauHubKeySystem") or string.find(source, "CreateParticles") then
                    print("[+] CGH Hop: Chuyen huong sang CGH_Key_System...")
                    local customKeyLib = (isfile and isfile("CGH_Key_System.luau") and readfile("CGH_Key_System.luau")) or game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Key_System.luau?t=" .. tostring(os.time()))
                    return orig_ls(customKeyLib)
                end

                -- Tráo Redz UI Library sang CGH Hop Library (Giao diện Cờ Việt Nam)
                if string.find(source, "redz library v3") or string.find(source, "MakeWindow") or string.find(source, "AddTab") or string.find(source, "ThemeColors") then
                    print("[+] CGH Hop: Phat hien UI Hop Library! Chuyen huong sang CGH_Hop_Library...")
                    local customLib
                    if isfile and isfile("CGH_Hop_Library.lua") then
                        customLib = readfile("CGH_Hop_Library.lua")
                    else
                        customLib = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Hop_Library.lua?t=" .. tostring(os.time()))
                    end
                    return orig_ls(customLib)
                end
            end
            if chunkname ~= nil then
                return orig_ls(source, chunkname, ...)
            else
                return orig_ls(source)
            end
        end)
    end
end)

-- [9. DUY TRÌ BẢN QUYỀN CGH HUB KHI SERVER HOP HOẶC TELEPORT]
local CGH_HOP_TELEPORT_PERSIST = [=[
    repeat task.wait() until game:IsLoaded()
    pcall(function()
        if isfile and isfile("CGH_Hop.lua") then
            loadstring(readfile("CGH_Hop.lua"))()
        else
            loadstring(game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Hop.lua?t=" .. tostring(os.time())))()
        end
    end)
]=]

local function getQOT()
    return queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or queueonteleport
end

local function applyHopQueue()
    local q = getQOT()
    if q then pcall(function() q(CGH_HOP_TELEPORT_PERSIST) end) end
end

pcall(function()
    local orig_q = getQOT()
    if orig_q and hookfunction then
        hookfunction(orig_q, function(script_str)
            return orig_q(CGH_HOP_TELEPORT_PERSIST)
        end)
    end
    local cgh_hop_qot = function(str)
        local raw = getQOT()
        if raw then return raw(CGH_HOP_TELEPORT_PERSIST) end
    end
    queue_on_teleport = cgh_hop_qot
    if syn then syn.queue_on_teleport = cgh_hop_qot end
    if fluxus then fluxus.queue_on_teleport = cgh_hop_qot end
    queueonteleport = cgh_hop_qot
end)

pcall(function()
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
    if lp then
        lp.OnTeleport:Connect(function(state)
            applyHopQueue()
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
                applyHopQueue()
                return orig_method(self, ...)
            end)
        end
    end
end)

applyHopQueue()

-- [10. KHỞI CHẠY CORE REALKID HOP NGUYÊN BẢN (TỰ ĐỘNG BẺ KHÓA VÀ LOAD GIAO DIỆN CGH)]
print("[+] Dang nap engine Server Hop tu workspace hoac GitHub...")
local hopScript = nil
if isfile and isfile("RealKidHop_Raw.lua") then
    local c = readfile("RealKidHop_Raw.lua")
    if c and #c > 1000 then
        hopScript = c
        print("[+] Da nap RealKidHop_Raw tu workspace (" .. tostring(#c) .. " bytes)")
    end
end

if not hopScript or #hopScript < 1000 then
    local ok, liveHop = pcall(function()
        return game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/RealKidHop_Raw.lua?t=" .. tostring(os.time()))
    end)
    if ok and liveHop and #liveHop > 1000 then
        hopScript = liveHop
        print("[+] Da nap RealKidHop_Raw tu GitHub (" .. tostring(#liveHop) .. " bytes)")
    end
end

if not hopScript or #hopScript < 1000 then
    local ok, cdnHop = pcall(function()
        return game:HttpGet("https://cdnrealkidhub.pages.dev/RealKidHop.lua")
    end)
    if ok and cdnHop and #cdnHop > 1000 then
        hopScript = cdnHop
        print("[+] Da nap RealKidHop tu CDN (" .. tostring(#cdnHop) .. " bytes)")
    end
end

if hopScript and #hopScript > 100 then
    local fn, err = loadstring(hopScript)
    if fn then
        print("[+] Bat dau thuc thi Server Hop engine...")
        task.spawn(function()
            local ok, runErr = pcall(fn)
            if not ok then warn("[!] Runtime RealKidHop: " .. tostring(runErr)) end
        end)
    else
        warn("[!] Compile RealKidHop: " .. tostring(err))
    end
else
    warn("[!] Khong the tai ma nguon RealKidHop!")
end
