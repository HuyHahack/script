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

pcall(function()
    local orig_q = getQOT()
    if orig_q and hookfunction then
        hookfunction(orig_q, function(script_str)
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

-- [5. HOOK GAME:HTTPGET: CHUYỂN HƯỚNG MỌI CUỘC GỌI ANHDOMIXI SANG FILE MÁY]
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
                end
            end
            return orig_httpget(self, url, ...)
        end)
    end
end)

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

-- [7. KHỞI CHẠY TRỰC TIẾP ENGINE TÍNH NĂNG BLOX FRUITS (HOÀN TOÀN KHÔNG CÓ BẢNG KEY)]
print("[+] Dang nap Blox Fruits Features Engine...")
local farmScript = nil
if isfile and isfile("anhdomixi.lua") then
    local c = readfile("anhdomixi.lua")
    if c and #c > 1000 then
        farmScript = c
        print("[+] Da nap Blox Fruits Features tu workspace (" .. tostring(#c) .. " bytes)")
    end
end

if not farmScript or #farmScript < 1000 then
    local ok, liveScript = pcall(function()
        return game:HttpGet("https://cdnrealkidhub.pages.dev/anhdomixi.lua")
    end)
    if ok and liveScript and #liveScript > 1000 then
        farmScript = liveScript
        print("[+] Da nap Blox Fruits Features tu CDN (" .. tostring(#liveScript) .. " bytes)")
    end
end

if farmScript and #farmScript > 100 then
    local fn, err = loadstring(farmScript)
    if fn then
        print("[+] Bat dau thuc thi CGH HUB Blox Fruits...")
        task.spawn(function()
            local ok, runErr = pcall(fn)
            if not ok then
                warn("[!] Runtime Blox Fruits Features: " .. tostring(runErr))
            end
        end)
    else
        warn("[!] Compile Blox Fruits Features: " .. tostring(err))
    end
else
    warn("[!] Khong the doc anhdomixi.lua!")
end
