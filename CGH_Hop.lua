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

-- [0. TỰ ĐỘNG BẢO ĐẢM KEY BẢN QUYỀN - KEYLESS 100% VĨNH VIỄN]
local REAL_MASTER_KEY = "TRAU_4D0281B6EB4A9BFDD18753A4B92860F9716BC4C439E1C448"

local function autoInjectKeyFiles()
    local keyFiles = {
        "TrauHub_Save.txt",
        "CGH_Key.txt",
        "teddy_key_gay.txt",
        "RealKid_Key_" .. tostring(game.PlaceId) .. ".txt",
        "RealKid_Key_100117331123089.txt",
        "RealKid_Key_11348033272.txt",
        "RealKid_Key_11584810072.txt",
        "RealKid_Key_2753915549.txt",
        "RealKid_Key_4442272183.txt",
        "RealKid_Key_7449423635.txt",
        "RealKid_Key_79091703265657.txt"
    }
    for _, fname in ipairs(keyFiles) do
        pcall(function()
            if writefile then
                writefile(fname, REAL_MASTER_KEY)
            end
        end)
    end
end
autoInjectKeyFiles()

-- Tự động dập tắt và xác thực bất kỳ bảng Key GUI nào nếu xuất hiện
task.spawn(function()
    local Players = game:GetService("Players")
    local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
    local pGui = lp:WaitForChild("PlayerGui", 10)
    if pGui then
        pGui.ChildAdded:Connect(function(child)
            if child.Name == "TrauHubKeySystem" or child.Name:find("Key") then
                task.defer(function()
                    pcall(function()
                        local keyInput = child:FindFirstChild("KeyInput", true)
                        local checkBtn = child:FindFirstChild("CheckKeyBtn", true) or child:FindFirstChild("KIỂM TRA", true)
                        if keyInput and keyInput:IsA("TextBox") then
                            keyInput.Text = REAL_MASTER_KEY
                        end
                        if checkBtn and checkBtn:IsA("TextButton") then
                            if getconnections then
                                for _, c in ipairs(getconnections(checkBtn.MouseButton1Click) or {}) do
                                    c:Fire()
                                end
                            end
                        end
                    end)
                end)
            end
        end)
    end
end)

print("             CGH HUB - SERVER HOP (KEYLESS)            ")
print("          Khoi chay he thong Server Hop v1...          ")
print("=======================================================")

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

-- [3. HOOK XÁC THỰC BẢN QUYỀN (KEYLESS BẢO HÀNH VĨNH VIỄN)]
local function hookReq(fn)
    if not fn or type(fn) ~= "function" or not hookfunction then return fn end
    local in_call = false
    local orig_fn
    orig_fn = hookfunction(fn, function(opt, ...)
        if in_call then return orig_fn(opt, ...) end
        in_call = true

        if type(opt) == "table" then
            local url = tostring(opt.Url or opt.url or ""):lower()
            -- Bắt xác thực key của Cloudflare Workers -> Luôn tiêm Master Key hợp lệ vào payload
            if url:find("webhook%.trungdao2k4") or url:find("workers%.dev") then
                pcall(function()
                    local HttpService = game:GetService("HttpService")
                    local b = opt.Body or opt.body
                    if type(b) == "string" and #b > 0 then
                        local d = HttpService:JSONDecode(b)
                        d.key = "TRAU_4D0281B6EB4A9BFDD18753A4B92860F9716BC4C439E1C448"
                        local nb = HttpService:JSONEncode(d)
                        opt.Body = nb
                        if opt.body then opt.body = nb end
                    end
                end)
                print("[+] CGH Keyless: Tu dong xac thuc ban quyen voi Cloudflare...")
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

-- [4. HOOK LOADSTRING: TRÁO GIAO DIỆN SANG CGH_HOP_LIBRARY CỜ VIỆT NAM]
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

-- [5. HOOK SERVER HOP PERSISTENCE: DUY TRÌ SCRIPT KHI NHẢY SERVER]
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

-- [6. KHỞI CHẠY ENGINE SERVER HOP GỐC 506KB]
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
