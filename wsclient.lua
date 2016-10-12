package.loaded.config = nil
package.loaded.led = nil
package.loaded.update =nil

config = require "config"
led = require "led"
update = require "update"

local wsclient = {}

updatePayload = nil

tmr.register(0, 1000, tmr.ALARM_SEMI, function() wsclient.setup() end)
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

parsePayload = function(payload)
    -- Parses the received payload
    if payload == nil then
        print("payload is nil")
        return
    end

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

parseUpdateInfo = function(nodeMCUVersion, firmwareVersion)
    updateInfo = {
        ["nodeMCUVersion"] = nodeMCUVersion,
        ["firmwareVersion"] = firmwareVersion
    }
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
        nodeMCUVersion, firmwareVersion = update.getVersionInfo()
        parseUpdateInfo(nodeMCUVersion, firmwareVersion)

        -- identify to the server
        identify(ws)

        -- start polling for update
        pollForUpdate(ws)
        tmr.start(1)
    end)
    ws:on("receive", function(_, msg, opcode)
        print("payload received", opcode)
        parsePayload(msg)
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
    registerCallbacks(ws)
    connect(ws)
end

wsclient.setup()

return wsclient
