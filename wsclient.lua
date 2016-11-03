package.loaded.config = nil
package.loaded.led = nil
package.loaded.update =nil

config = require "config"
led = require "led"
update = require "update"

local wsclient = {}

updatePayload = nil

stored_ws = nil

tmr.register(0, 10000, tmr.ALARM_SEMI, function() connect(stored_ws) end)
tmr.register(1, 900000, tmr.ALARM_SEMI, function() pollForUpdate() end)

connect = function(ws)
    ws:connect(config.host)
end

identify = function(ws)
    payload = {
        ["identifier"] = config.secretID
    }
    ok, json = pcall(cjson.encode, payload)
    if ok then
        ws:send(json)
    else
        print("Failed to encode payload")
    end
end

parsePayload = function(payload, ws)
    -- Parses the received payload
    if payload == nil then
        print("payload is nil")
        return
    end

    if payload:sub(1, 4) == "FILE" then
        print("update retrieved")
        handleUpdate(payload, ws)
        return
    end

    if payload == "UPDATE FINISH" then
        if updating == true then
            update.finish()
            updating = false
        else
            -- This means the chipset most likely hard reset and disconnected because the chipset
            -- doesn't indicate it was updating
            update.restore()
        end
        return
    end

    payload = payload:lower()
    payload = payload:gsub("%'", "")
    payload = payload:gsub("%'", "")
    payload = payload:gsub("on", '"on"')
    payload = payload:gsub("pattern", '"pattern"')
    print(payload)

    ok, data = pcall(cjson.decode, payload)

    if not ok then
        print("Failed decoding")
        return
    end

    print("parsed payload")

    if type(data["pattern"]) == "table" then
        led.pattern = data["pattern"]
    end
    
    if data["on"] == true then
        led.on()
    elseif data["on"] == false then
        led.off()
    end
end

handleUpdate = function(payload, ws)
    updating = true
    result = update.updateFile(payload)
    updateResult = {
        ["result"] = result
    }
    ok, json = pcall(cjson.encode, updateResult)
    if ok then
        ws:send(json)
    else
        print("Failed parsing update result")
    end
end
    

parseUpdateInfo = function(nodeMCUVersion, firmwareVersion)
    updateInfo = {
        ["identifier"] = config.secretID,
        ["nodeMCUVersion"] = nodeMCUVersion,
        ["firmware_version"] = firmwareVersion
    }
    print("parsing update info")
    ok, json = pcall(cjson.encode, updateInfo)
    if ok then
        updatePayload = json
    else
        print("Failed to encode update info!")
    end
end

registerCallbacks = function(ws)
    ws:on("connection", function(ws)
        print("connected")
        -- Get update info ready for polling
        nodeMCUVersion, firmware_version = update.getVersionInfo()
        parseUpdateInfo(nodeMCUVersion, firmwareVersion)

        -- identify to the server
        identify(ws)

        -- start polling for update
        pollForUpdate(ws)
        tmr.start(1)
    end)
    ws:on("receive", function(_, msg, opcode)
        print("payload received", opcode)
        parsePayload(msg, ws)
    end)
    ws:on("close", function(_, status)
        print("disconnected", status)
        -- attempt reconnect
        tmr.start(0)
    end)
end

pollForUpdate = function(ws)
    print("polling for update")
    ws:send(updatePayload)
end

wsclient.setup = function()
    ws = websocket.createClient()
    stored_ws = ws
    registerCallbacks(ws)
    connect(ws)
end

return wsclient
