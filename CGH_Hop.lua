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
print("          Khoi chay he thong Server Hop v2...          ")
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

local function isKeyFile(path)
    if type(path) ~= "string" then return false end
    local lower = path:lower()
    return lower:find("trauhub_save") or lower:find("realkid_key") or lower:find("cgh_key")
end

pcall(function()
    if isfile and hookfunction then
        local orig_isfile = isfile
        hookfunction(isfile, function(path)
            if isKeyFile(path) then return true end
            return orig_isfile(path)
        end)
    end
    if readfile and hookfunction then
        local orig_readfile = readfile
        hookfunction(readfile, function(path)
            if isKeyFile(path) then return PERMANENT_KEY end
            return orig_readfile(path)
        end)
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

-- [4. BỘ MÃ HÓA BASE64-URL CHUẨN JWT]
local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
local function toBase64Url(data)
    local b64
    if crypt and crypt.base64encode then
        b64 = crypt.base64encode(data)
    elseif syn and syn.crypt and syn.crypt.base64 and syn.crypt.base64.encode then
        b64 = syn.crypt.base64.encode(data)
    else
        b64 = ((data:gsub('.', function(x) 
            local r,b='',x:byte()
            for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
            return r;
        end)..'0000'):gsub('%d%d%d?%d?%d?', function(x)
            if (#x < 6) then return '' end
            local c=0
            for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
            return b64chars:sub(c+1,c+1)
        end)..({ '', '==', '=' })[#data%3+1])
    end
    return b64:gsub("%+", "-"):gsub("/", "_"):gsub("=", "")
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
            -- Bắt xác thực key -> Giả lập chữ ký số RS256 khớp chuẩn 100% với Nonce của phiên chơi hiện tại
            if url:find("webhook%.trungdao2k4") or url:find("workers%.dev") then
                in_call = false
                local b = opt.Body or opt.body or ""
                local reqData = {}
                pcall(function() reqData = HttpService:JSONDecode(b) end)
                local currentNonce = reqData.nonce or "CGH-HOP-NONCE"
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

                local b64Payload = toBase64Url(HttpService:JSONEncode(dynPayload))
                local mockJwt = HttpService:JSONEncode({
                    version = 3,
                    alg = "RS256",
                    kid = "a987fcfbfc8fc7e5",
                    payload = b64Payload,
                    signature = "iCwsQPqv7rP3ZKcDNRmHfCyl9B9kDiiUKJOaqzwaqwZoHFJaQxmFVjHAwcyqUqB_MZTGiXKVwJpCLfo2-KIuDxlNhleE2X14T11A7mVh-HKqsTOh7MYObk6waj292jwcBoLqJGjIWnbFr5hs347PHtPVSF4_V8SVrOobofUC927Tda0IvZ41dxCkMyX5J12o_yiefTwm8aDgWH390fUuYmvSkPaWvtLJVuS_ERNsJW5lFZspx0nVKtm6Akk3-r6Pz4FOI5_1LFPnQ_72IQe0Sk-0jNC30MLqokSMLViEsDN_wDY5itN7VGw2PgspKMnfbDm_Md5hjbT0V8jRYGOwyA"
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

-- [6. HOOK STARTERGUI NOTIFICATION - CHUYỂN TOÀN BỘ SANG CGH HUB]
pcall(function()
    local StarterGui = game:GetService("StarterGui")
    if hookfunction and StarterGui and StarterGui.SetCore then
        local orig_setcore
        orig_setcore = hookfunction(StarterGui.SetCore, function(self, name, data, ...)
            if name == "SendNotification" and type(data) == "table" then
                local title = tostring(data.Title or "")
                local text = tostring(data.Text or "")
                if text:lower():find("nhập key") or text:lower():find("nhap key") or text:lower():find("vui lòng nhập") then
                    data.Title = "CGH Hub"
                    data.Text = "Hệ thống Server Hop đã sẵn sàng!"
                else
                    data.Title = title:gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Redz", "CGH Hub"):gsub("TrauHub", "CGH Hub")
                    data.Text = text:gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Redz", "CGH Hub"):gsub("TrauHub", "CGH Hub")
                end
            end
            return orig_setcore(self, name, data, ...)
        end)
    end
end)

-- [7. HOOK LOADSTRING: TRÁO GIAO DIỆN SANG CGH_HOP_LIBRARY VÀ BẺ KHÓA TRAUHUBLIB]
pcall(function()
    if hookfunction and loadstring then
        local in_ls = false
        local orig_ls
        orig_ls = hookfunction(loadstring, function(src, chunkname, ...)
            if in_ls then
                if chunkname ~= nil then return orig_ls(src, chunkname, ...) else return orig_ls(src) end
            end

            -- Tráo Key System Library sang bản tàng hình tự động kích hoạt
            if type(src) == "string" and (string.find(src, "TrauHubLib") or string.find(src, "TrauHubKeySystem") or string.find(src, "CreateParticles")) then
                in_ls = true
                print("[+] Phat hien Key System Library! Chuyen huong sang CGH_Key_System (Bypass Invisible)...")
                local customKeyLib
                if isfile and isfile("CGH_Key_System.luau") then
                    customKeyLib = readfile("CGH_Key_System.luau")
                else
                    customKeyLib = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Key_System.luau?t=" .. tostring(os.time()))
                end
                local res = orig_ls(customKeyLib)
                in_ls = false
                return res
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

-- [8. HOOK SERVER HOP PERSISTENCE: DUY TRÌ SCRIPT KHI NHẢY SERVER]
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

local function applyHopQueue()
    local q = getQOT()
    if q then
        pcall(function()
            q(CGH_HOP_PERSIST)
        end)
    end
end

pcall(function()
    local orig_q = getQOT()
    if orig_q and hookfunction then
        hookfunction(orig_q, function(script_str)
            return orig_q(CGH_HOP_PERSIST)
        end)
    end
    local hop_qot = function(str)
        local raw = getQOT()
        if raw then return raw(CGH_HOP_PERSIST) end
    end
    queue_on_teleport = hop_qot
    if syn then syn.queue_on_teleport = hop_qot end
    if fluxus then fluxus.queue_on_teleport = hop_qot end
    queueonteleport = hop_qot
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

-- [9. KHỞI CHẠY ENGINE SERVER HOP]
print("[+] Dang nap engine Server Hop...")
local hopCode = nil
if isfile and isfile("RealKidHop_Raw.lua") then
    local c = readfile("RealKidHop_Raw.lua")
    if c and #c > 1000 then
        hopCode = c
        print("[+] Da nap RealKidHop_Raw tu workspace (" .. tostring(#c) .. " bytes)")
    end
end

if not hopCode or #hopCode < 1000 then
    local ok, liveHop = pcall(function()
        return game:HttpGet("https://cdnrealkidhub.pages.dev/RealKidHop.lua")
    end)
    if ok and liveHop and #liveHop > 1000 then
        hopCode = liveHop
        print("[+] Da nap RealKidHop_Raw tu CDN (" .. tostring(#liveHop) .. " bytes)")
    end
end

if hopCode and #hopCode > 100 then
    local fn, err = loadstring(hopCode)
    if fn then
        print("[+] Bat dau thuc thi he thong Server Hop...")
        task.spawn(function()
            local ok, runErr = pcall(fn)
            if not ok then warn("[!] Runtime RealKidHop: " .. tostring(runErr)) end
        end)
    else
        warn("[!] Compile RealKidHop: " .. tostring(err))
    end
end
