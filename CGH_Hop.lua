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
print("          Khoi chay he thong Server Hop v6...          ")
print("=======================================================")

local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()

-- [1. THIẾT LẬP MÔI TRƯỜNG & BIẾN TOÀN CỤC CHO CGH HUB]
getgenv().CGH = true
getgenv().CGH_Hop = true
getgenv().Nousigi = true
getgenv().Config = true

-- [2. HẰNG SỐ XÁC THỰC BẢN QUYỀN CHUẨN XÁC RS256]
local TARGET_NONCE = "CFE2E69F-0E32-4DF7-88E7-EC7FBD07DF9E"
local TARGET_KEY = "TRAU_4D0281B6EB4A9BFDD18753A4B92860F9716BC4C439E1C448"
local REAL_SIGNED_JWT = [===[{"version":3,"alg":"RS256","kid":"a987fcfbfc8fc7e5","payload":"eyJ2ZXJzaW9uIjozLCJhdWRpZW5jZSI6InJlYWxraWQtYXV0aCIsIm5vbmNlIjoiQ0ZFMkU2OUYtMEUzMi00REY3LTg4RTctRUM3RkJEMDdERjlFIiwiaHdpZCI6IjdiNjEzODYyNjUzMzMxMzQzMDJkMzkzMTY0NjUyZDMxMzE2NjMxMmQzOTMzNjYzOTJkMzgzMDM2NjUzNjY2MzY2NTM2MzkzNjMzN2QiLCJod2lkMiI6IkVGNTcwNTEzLUVDQzMtNDI2MC04RDJCLTk5NUM4RDg0OUI4NSIsImtleUhhc2giOiJlOWEyZWUzMjAxZjI5OGEyOGNjOWMyZTQzZGY1YmE1MDM4NGY0ZTg3ZDEyOGZjNjFmNWY3Y2NjMGMzNDkzOTZkIiwic3RhdHVzIjoiQVVUSE9SSVpFRCIsImV4cGlyZXMiOiIxODozNiAtIDI1LzEwLzIwMjYifQ","signature":"iCwsQPqv7rP3ZKcDNRmHfCyl9B9kDiiUKJOaqzwaqwZoHFJaQxmFVjHAwcyqUqB_MZTGiXKVwJpCLfo2-KIuDxlNhleE2X14T11A7mVh-HKqsTOh7MYObk6waj292jwcBoLqJGjIWnbFr5hs347PHtPVSF4_V8SVrOobofUC927Tda0IvZ41dxCkMyX5J12o_yiefTwm8aDgWH390fUuYmvSkPaWvtLJVuS_ERNsJW5lFZspx0nVKtm6Akk3-r6Pz4FOI5_1LFPnQ_72IQe0Sk-0jNC30MLqokSMLViEsDN_wDY5itN7VGw2PgspKMnfbDm_Md5hjbT0V8jRYGOwyA"}]===]

-- Đảm bảo file key luôn tồn tại
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
            if writefile then writefile(f, TARGET_KEY) end
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
        local rawHop = game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/RealKidHop_Raw.lua?t=" .. tostring(os.time()))
        writefile("RealKidHop_Raw.lua", rawHop)
    end
end)

-- [4. HOOK GENERATEGUID: ĐỒNG BỘ NONCE CHO BẢN QUYỀN HOP]
if not getgenv().__CGH_HOP_GUID_HOOKED then
    getgenv().__CGH_HOP_GUID_HOOKED = true
    if hookfunction and HttpService and HttpService.GenerateGUID then
        local orig_guid
        orig_guid = hookfunction(HttpService.GenerateGUID, function(self, ...)
            return TARGET_NONCE
        end)
    end
end

-- [5. HOOK REQUEST: MOCK SERVER AUTH CHO SERVER HOP]
if not getgenv().__CGH_HOP_REQ_HOOKED then
    getgenv().__CGH_HOP_REQ_HOOKED = true
    local function hookReq(fn)
        if not fn or type(fn) ~= "function" or not hookfunction then return fn end
        local in_call = false
        local orig_fn
        orig_fn = hookfunction(fn, function(opt, ...)
            if in_call then return orig_fn(opt, ...) end
            in_call = true

            local url = ""
            if type(opt) == "table" and opt.Url then
                url = tostring(opt.Url)
            elseif type(opt) == "string" then
                url = opt
            end

            if url:find("webhook.trungdao2k4.workers.dev") then
                in_call = false
                print("[+] CGH Keyless (Hop): Tu dong xac thuc ban quyen thanh cong (Vinh vien 2099)!")
                return {
                    Success = true, success = true,
                    StatusCode = 200, status_code = 200,
                    Status = 200, status = 200,
                    StatusMessage = "OK", status_message = "OK",
                    Headers = { ["content-type"] = "application/json" },
                    headers = { ["content-type"] = "application/json" },
                    Body = REAL_SIGNED_JWT, body = REAL_SIGNED_JWT
                }
            end

            if url:find("discord.com/api/webhooks") or url:find("discordapp.com/api/webhooks") then
                in_call = false
                return {
                    StatusCode = 200,
                    StatusMessage = "OK",
                    Body = '{"status":"ok"}',
                    Success = true,
                    Headers = {["content-type"] = "application/json"}
                }
            end

            local res = orig_fn(opt, ...)
            in_call = false
            return res
        end)
        return orig_fn
    end

    if request then hookReq(request) end
    if http_request then hookReq(http_request) end
    if syn and syn.request then hookReq(syn.request) end
    if http and http.request then hookReq(http.request) end
end

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
            elseif lowerUrl:find("webhook.trungdao2k4.workers.dev") then
                return REAL_SIGNED_JWT
            end
            return orig_httpget(self, url, ...)
        end)
    end
end)

-- [7. HOOK NOTIFICATION GỐC SANG CGH HUB]
pcall(function()
    if hookfunction and StarterGui and StarterGui.SetCore then
        local orig_setcore
        orig_setcore = hookfunction(StarterGui.SetCore, function(self, name, data, ...)
            if name == "SendNotification" and type(data) == "table" then
                local title = tostring(data.Title or "")
                local text = tostring(data.Text or "")
                data.Title = title:gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Redz", "CGH Hub"):gsub("TrauHub", "CGH Hub")
                data.Text = text:gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Redz", "CGH Hub"):gsub("TrauHub", "CGH Hub")
                if isfile and isfile("cgh_logo.png") and getcustomasset then
                    pcall(function() data.Icon = getcustomasset("cgh_logo.png") end)
                end
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
                if string.find(source, "TrauHubLib") or string.find(source, "TrauHubKeySystem") or string.find(source, "CreateParticles") then
                    print("[+] CGH Hop: Chuyen huong sang CGH_Key_System...")
                    local customKeyLib = (isfile and isfile("CGH_Key_System.luau") and readfile("CGH_Key_System.luau")) or game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Key_System.luau?t=" .. tostring(os.time()))
                    return orig_ls(customKeyLib)
                end

                if string.find(source, "redz library v3") or string.find(source, "MakeWindow") or string.find(source, "AddTab") or string.find(source, "ThemeColors") then
                    print("[+] CGH Hop: Phat hien UI Hop Library! Chuyen huong sang CGH_Hop_Library...")
                    local customLib = (isfile and isfile("CGH_Hop_Library.lua") and readfile("CGH_Hop_Library.lua")) or game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Hop_Library.lua?t=" .. tostring(os.time()))
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

-- [9. TỰ ĐỘNG DUY TRÌ BẢN QUYỀN CGH HUB KHI HOP SERVER / TELEPORT]
local CGH_HOP_TELEPORT_PERSIST = [=[
    task.spawn(function()
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        local Players = game:GetService("Players")
        local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()
        task.wait(1)
        pcall(function()
            if isfile and isfile("CGH_Hop.lua") then
                loadstring(readfile("CGH_Hop.lua"))()
            else
                loadstring(game:HttpGet("https://raw.githubusercontent.com/HuyHahack/script/main/CGH_Hop.lua?t=" .. tostring(os.time())))()
            end
        end)
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
    if lp then
        lp.OnTeleport:Connect(function(state)
            applyHopQueue()
        end)
    end
end)

pcall(function()
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

-- [10. BỘ GIÁM SÁT GIAO DIỆN CGH HOP & ĐỒNG BỘ LOGO CỜ VIỆT NAM CHO NÚT BẬT TẮT]
local GOLD = Color3.fromRGB(255, 215, 0)
local CRIMSON = Color3.fromRGB(180, 20, 30)

task.spawn(function()
    while true do
        task.wait(0.3)
        local assetLogo = (getcustomasset and isfile and isfile("cgh_logo.png") and getcustomasset("cgh_logo.png")) or "rbxassetid://96220014754961"

        -- Quét toàn bộ CoreGui và PlayerGui tìm ImageButton của nút Hop Minimizer
        local checkContainers = {CoreGui}
        pcall(function()
            local pgui = lp:FindFirstChildOfClass("PlayerGui")
            if pgui then table.insert(checkContainers, pgui) end
        end)

        for _, parent in ipairs(checkContainers) do
            for _, d in ipairs(parent:GetDescendants()) do
                -- Đổi logo nút nổi minimizer (ImageButton nhỏ hình vuông / tròn)
                if d:IsA("ImageButton") and (d.Size.X.Offset <= 60 and d.Size.Y.Offset <= 60) and d.Size.X.Offset >= 25 then
                    if d.Image ~= assetLogo then
                        pcall(function()
                            d.Image = assetLogo
                            d.ImageColor3 = Color3.new(1, 1, 1)
                            d.BackgroundColor3 = CRIMSON
                        end)
                        local stroke = d:FindFirstChildOfClass("UIStroke")
                        if not stroke then
                            stroke = Instance.new("UIStroke", d)
                            stroke.Thickness = 1.5
                        end
                        stroke.Color = GOLD

                        local corner = d:FindFirstChildOfClass("UICorner")
                        if not corner then
                            corner = Instance.new("UICorner", d)
                            corner.CornerRadius = UDim.new(0.25, 0)
                        end
                    end
                end

                -- Thay thế nhãn văn bản còn sót
                if d:IsA("TextLabel") and (d.Text:find("RealKid") or d.Text:find("realkid") or d.Text:find("Redz") or d.Text:find("TrauHub")) then
                    d.Text = d.Text:gsub("RealKid", "CGH Hub"):gsub("realkid", "CGH Hub"):gsub("Redz", "CGH Hub"):gsub("TrauHub", "CGH Hub")
                end
            end
        end
    end
end)

-- [11. KHỞI CHẠY CORE REALKID HOP NGUYÊN BẢN]
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
