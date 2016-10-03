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

server.setupWifi = function()
    -- connect to WiFi access point
    wifi.setmode(wifi.STATION)
    wifi.sta.config("Crazy Diamond", "oldsmobilef85")
    print(wifi.sta.getip())
end

return server
