local wsclient = {}

connect = function(ws)
    ws:connect(config.host)
end

registerCallbacks = function(ws)
    ws:on("connection", function(ws)
        print("connected")
    end)
    print("one")
    ws:on("receive", function(_, msg, opcode)
        print(msg)
    end)
    ws:on("close", function(_, status)
        print("disconnected", status)
        -- atempt reconnect
        tmr.alarm(0, 10000, 1, function()
        connect(ws)
    end)
    end)
end

wsclient.setup = function()
    ws = websocket.createClient()
    registerCallbacks(ws)
    connect(ws)
end

return wsclient
