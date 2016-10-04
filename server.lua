package.loaded.led = nil
led = require "led"
local server = {}

server.createHTTPServer = function()
    if srv~=nil then
      srv:close()
    end

    srv = net.createServer(net.TCP)
    srv:listen(80, function(conn)
        conn:on("receive", function(sck, payload)
            if string.find(payload, "toggle") ~= nil then
                print("toggled")
                led.toggle()
            end
            sck:send("OK")
        end)
        conn:on("sent", function(sck) sck:close() end)
    end)
end

server.sendGet = function()
    sk = net.createConnection(net.TCP, 0)
    sk:on("receive", function(sck, payload)
        if string.find(payload, "toggle") ~= nil then
            print("toggled")
            led.toggle()
        end
    end)

    sk:on("connection", function(sck,c)
        -- Wait for connection before sending.
        sck:send("GET / HTTP/1.1\r\nHost: 192.168.0.36\r\nConnection: keep-alive\r\nAccept: */*\r\n\r\n")
    end)
    sk:connect(6543,"192.168.2.244")
end

server.setupWifi = function()
    -- connect to WiFi access point
    wifi.setmode(wifi.STATION)
    wifi.sta.config("SSID", "password")
    print(wifi.sta.getip())
end

return server
