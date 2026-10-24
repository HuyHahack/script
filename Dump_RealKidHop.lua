--[[
    =======================================================
               CGH DUMPER & API SNIFFER - REALKID HOP
      Tự động bắt toàn bộ API, Request Body, Response JSON,
      Chunks mã nguồn và Server Teleport của RealKidHop
    =======================================================
--]]

print("=======================================================")
print("       [CGH] KHOI CHAY REALKID HOP DUMPER & SNIFFER     ")
print("=======================================================")

local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local DUMP_TXT = "RealKidHop_API_Dump.txt"
local DUMP_JSON = "RealKidHop_Traffic.json"

local trafficHistory = {}

local function appendLog(text)
    print(text)
    pcall(function()
        if appendfile then
            appendfile(DUMP_TXT, text .. "\n")
        elseif writefile then
            local old = (isfile and isfile(DUMP_TXT) and readfile(DUMP_TXT)) or ""
            writefile(DUMP_TXT, old .. text .. "\n")
        end
    end)
end

local function saveTrafficJson(entry)
    table.insert(trafficHistory, entry)
    pcall(function()
        if writefile then
            writefile(DUMP_JSON, HttpService:JSONEncode(trafficHistory))
        end
    end)
end

-- Khởi tạo file log mới với header
pcall(function()
    if writefile then
        writefile(DUMP_TXT, "=== [CGH] REALKID HOP API & NETWORK TRAFFIC LOG ===\nThoi gian bat dau: " .. os.date("%c") .. "\n\n")
    end
end)

appendLog("[+] He thong Sniffer da san sang ghi nhan moi API...")

-- [1. HOOK TOAN BO HE THONG HTTP REQUEST (REQUEST, SYN, FLUXUS, HTTP)]
local function hookHttpFunction(name, fn)
    if not fn or type(fn) ~= "function" or not hookfunction then return fn end
    
    local in_call = false
    local orig_fn
    orig_fn = hookfunction(fn, function(options, ...)
        if in_call then return orig_fn(options, ...) end
        in_call = true

        local opt = options
        local method = (type(opt) == "table" and (opt.Method or opt.method or "GET")) or "GET"
        local url = (type(opt) == "table" and (opt.Url or opt.url or "")) or ""
        local reqBody = (type(opt) == "table" and (opt.Body or opt.body or "")) or ""
        local headers = (type(opt) == "table" and (opt.Headers or opt.headers or {})) or {}

        local logEntry = {
            timestamp = os.time(),
            date = os.date("%X"),
            hook = name,
            method = tostring(method):upper(),
            url = tostring(url),
            request_body = reqBody,
            headers = headers,
            response_code = 0,
            response_body = ""
        }

        local sep = "------------------------------------------------------------"
        appendLog(sep)
        appendLog(string.format("[%s] [%s] URL: %s", logEntry.date, logEntry.method, logEntry.url))
        if #tostring(reqBody) > 0 then
            appendLog(string.format(">>> REQUEST PAYLOAD:\n%s", tostring(reqBody)))
        end

        -- Cho request THỰC TẾ đi đến server, KHÔNG CHẶN để RealKidHop hoạt động bình thường
        local success, response = pcall(orig_fn, opt, ...)

        in_call = false

        if success and response then
            local statusCode = response.StatusCode or response.status_code or response.Status or 200
            local resBody = response.Body or response.body or ""
            logEntry.response_code = statusCode
            logEntry.response_body = resBody

            appendLog(string.format("<<< STATUS: %s | BYTES: %d", tostring(statusCode), #tostring(resBody)))
            if #tostring(resBody) > 0 then
                local preview = tostring(resBody)
                if #preview > 1500 then
                    preview = preview:sub(1, 1500) .. "\n... [TRUNCATED " .. tostring(#resBody - 1500) .. " BYTES]"
                end
                appendLog(string.format("<<< SERVER RESPONSE JSON/DATA:\n%s", preview))
            end
            appendLog(sep)

            saveTrafficJson(logEntry)
            return response
        else
            appendLog(string.format("[!] HTTP ERROR: %s", tostring(response)))
            appendLog(sep)
            saveTrafficJson(logEntry)
            return response
        end
    end)
    return orig_fn
end

pcall(function() if request then hookHttpFunction("request", request) end end)
pcall(function() if http_request then hookHttpFunction("http_request", http_request) end end)
pcall(function() if syn and syn.request then hookHttpFunction("syn.request", syn.request) end end)
pcall(function() if http and http.request then hookHttpFunction("http.request", http.request) end end)

-- [2. HOOK GAME:HTTPGET]
pcall(function()
    if hookfunction and game and game.HttpGet then
        local orig_get
        orig_get = hookfunction(game.HttpGet, function(self, url, ...)
            appendLog(string.format("[game:HttpGet] %s", tostring(url)))
            local res = orig_get(self, url, ...)
            pcall(function()
                appendLog(string.format("<<< Tra ve %d bytes tu %s", #tostring(res), tostring(url)))
            end)
            return res
        end)
    end
end)

-- [3. HOOK LOADSTRING DE DUMP CAC CHUNK DUOC DICH MA]
pcall(function()
    if hookfunction and loadstring then
        local orig_ls
        local chunkCount = 0
        orig_ls = hookfunction(loadstring, function(source, chunkname, ...)
            if type(source) == "string" and #source > 50 then
                chunkCount = chunkCount + 1
                local filename = string.format("dumped_hop_%d_%d.luau", #source, os.time())
                pcall(function()
                    if writefile and not isfile(filename) then
                        writefile(filename, source)
                        appendLog(string.format("[+] DUMPED CHUNK #%d: %s (%d bytes)", chunkCount, filename, #source))
                    end
                end)
            end
            if chunkname ~= nil then
                return orig_ls(source, chunkname, ...)
            else
                return orig_ls(source)
            end
        end)
    end
end)

-- [4. HOOK TELEPORTSERVICE DE BAT JOB ID MA REALKID HOP TIM DUOC]
pcall(function()
    local methods = {"Teleport", "TeleportToPlaceInstance", "TeleportPartyAsync", "TeleportToSpawnByName"}
    for _, m in ipairs(methods) do
        if TeleportService[m] and hookfunction then
            local orig_m
            orig_m = hookfunction(TeleportService[m], function(self, ...)
                local args = {...}
                appendLog("============================================================")
                appendLog(string.format("[HOP TRIGGERED!] TeleportService:%s Duoc Goi!", m))
                for i, arg in ipairs(args) do
                    appendLog(string.format("  - Tham so [%d]: %s", i, tostring(arg)))
                end
                appendLog("============================================================")
                return orig_m(self, ...)
            end)
        end
    end
end)

-- [5. KHOI CHAY REALKIDHOP.LUA CHINH CHU DE BAT DAU SNIFF]
appendLog("[+] Dang tai va thuc thi RealKidHop tu cdnrealkidhub.pages.dev...")
task.spawn(function()
    local ok, scriptCode = pcall(function()
        if isfile and isfile("RealKidHop_Raw.lua") then
            return readfile("RealKidHop_Raw.lua")
        else
            return game:HttpGet("https://cdnrealkidhub.pages.dev/RealKidHop.lua")
        end
    end)

    if ok and scriptCode and #scriptCode > 100 then
        appendLog(string.format("[+] Da tai RealKidHop.lua (%d bytes). Bat dau chay...", #scriptCode))
        local fn, compileErr = loadstring(scriptCode)
        if fn then
            local execOk, runErr = pcall(fn)
            if not execOk then
                appendLog(string.format("[!] RealKidHop Runtime Error: %s", tostring(runErr)))
            else
                appendLog("[+] RealKidHop da khoi dong thanh cong trong che do Sniffer!")
            end
        else
            appendLog(string.format("[!] Compile RealKidHop that bai: %s", tostring(compileErr)))
        end
    else
        appendLog("[!] Khong the tai RealKidHop.lua tu may hoac internet!")
    end
end)
