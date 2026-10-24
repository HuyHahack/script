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
print("          Khoi chay he thong Server Hop v1...          ")
print("=======================================================")

local HttpService = game:GetService("HttpService")

-- [1. THIẾT LẬP MÔI TRƯỜNG & BIẾN TOÀN CỤC CHO CGH HUB]
getgenv().CGH = true
getgenv().CGH_Hop = true

-- [2. TỰ ĐỘNG TẢI VÀ CACHE TÀI NGUYÊN VÀO WORKSPACE]
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
    if writefile and (not isfile or not isfile("RealKidHop_Raw.lua")) then
        local rawHop = game:HttpGet("https://cdnrealkidhub.pages.dev/RealKidHop.lua")
        writefile("RealKidHop_Raw.lua", rawHop)
    end
end)

-- Tạo file key tượng trưng để engine không bao giờ vẽ popup đòi key
pcall(function()
    local dummyKey = "CGH_PERMANENT_KEY_NO_EXPIRATION"
    local files = {
        "TrauHub_Save.txt",
        "RealKid_Key_" .. tostring(game.PlaceId) .. ".txt",
        "RealKid_Key_100117331123089.txt",
        "RealKid_Key_11348033272.txt",
        "RealKid_Key_11584810072.txt",
        "RealKid_Key_79091703265657.txt"
    }
    for _, f in ipairs(files) do
        if writefile and (not isfile or not isfile(f)) then
            writefile(f, dummyKey)
        end
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

-- [4. HOOK XÁC THỰC BẢN QUYỀN ĐỘNG (HOÀN TOÀN KHÔNG CẦN KEY THẬT, HẠN NĂM 2099)]
local function hookReq(fn)
    if not fn or type(fn) ~= "function" or not hookfunction then return fn end
    local in_call = false
    local orig_fn
    orig_fn = hookfunction(fn, function(opt, ...)
        if in_call then return orig_fn(opt, ...) end
        in_call = true

        if type(opt) == "table" then
            local url = tostring(opt.Url or opt.url or ""):lower()
            -- Bắt xác thực key -> Giả lập chữ ký số RS256 khớp chuẩn 100% với Nonce của phiên chơi hiện tại
            if url:find("webhook%.trungdao2k4") or url:find("workers%.dev") then
                in_call = false
                local b = opt.Body or opt.body or ""
                local reqData = {}
                pcall(function() reqData = HttpService:JSONDecode(b) end)
                local currentNonce = reqData.nonce or "DYNAMIC-NONCE"
                local currentHwid = reqData.hwid or ""
                local currentHwid2 = reqData.hwid2 or ""

                -- Tạo Payload hợp lệ vĩnh viễn với hạn sử dụng năm 2099
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

                print("[+] CGH Keyless: Gia lap xac thuc ban quyen thanh cong (Vinh vien 2099)!")
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

        -- Các request API khác (realkidapi.online) để đi tự nhiên 100% để lấy Job ID
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

-- [5. HOOK LOADSTRING: TRÁO GIAO DIỆN SANG CGH_HOP_LIBRARY CỜ VIỆT NAM]
pcall(function()
    if hookfunction and loadstring then
        local in_ls = false
        local orig_ls
        orig_ls = hookfunction(loadstring, function(src, chunkname, ...)
            if in_ls then
                if chunkname ~= nil then return orig_ls(src, chunkname, ...) else return orig_ls(src) end
            end

            if type(src) == "string" and (string.find(src, "tlredz") or string.find(src, "redz-V5-remake") or string.find(src, "MakeWindow")) then
                in_ls = true
                print("[+] Phat hien UI RedzLib! Chuyen huong sang CGH_Hop_Library (CGH HUB - Co Viet Nam)...")
                local customLib
                if isfile and isfile("CGH_Hop_Library.lua") then
                    customLib = readfile("CGH_Hop_Library.lua")
                else
                    customLib = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Hop_Library.lua?t=" .. tostring(os.time()))
                end
                local res = orig_ls(customLib)
                in_ls = false
                return res
            end

            if chunkname ~= nil then return orig_ls(src, chunkname, ...) else return orig_ls(src) end
        end)
    end
end)

-- [6. HOOK SERVER HOP PERSISTENCE: DUY TRÌ SCRIPT KHI NHẢY SERVER]
local CGH_HOP_PERSIST = [=[
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

pcall(function()
    local orig_q = getQOT()
    if orig_q and hookfunction then
        hookfunction(orig_q, function(script_str)
            return orig_q(CGH_HOP_PERSIST)
        end)
    end
    local custom_q = function(s)
        local q = getQOT()
        if q then return q(CGH_HOP_PERSIST) end
    end
    queue_on_teleport = custom_q
    if syn then syn.queue_on_teleport = custom_q end
    if fluxus then fluxus.queue_on_teleport = custom_q end
    queueonteleport = custom_q
end)

-- [7. KHỞI CHẠY ENGINE SERVER HOP 506KB]
print("[+] Dang nap engine Server Hop 506KB...")
local hopCode = nil
if isfile and isfile("RealKidHop_Raw.lua") then
    local c = readfile("RealKidHop_Raw.lua")
    if c and #c > 1000 then
        hopCode = c
        print("[+] Da nap RealKidHop_Raw tu workspace (" .. tostring(#c) .. " bytes)")
    end
end

if not hopCode or #hopCode < 1000 then
    local ok, liveCode = pcall(function()
        return game:HttpGet("https://cdnrealkidhub.pages.dev/RealKidHop.lua")
    end)
    if ok and liveCode and #liveCode > 1000 then
        hopCode = liveCode
        print("[+] Da nap RealKidHop_Raw tu CDN (" .. tostring(#liveCode) .. " bytes)")
    end
end

if hopCode and #hopCode > 100 then
    local fn, err = loadstring(hopCode)
    if fn then
        print("[+] Bat dau thuc thi CGH HUB - SERVER HOP...")
        task.spawn(function()
            local ok, runErr = pcall(fn)
            if not ok then
                warn("[!] Runtime Hop Engine: " .. tostring(runErr))
            end
        end)
    else
        warn("[!] Compile Hop Engine: " .. tostring(err))
    end
else
    warn("[!] Khong the doc engine Server Hop!")
end
