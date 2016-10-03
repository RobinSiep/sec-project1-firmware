local server = {}

server.createHTTPServer = function()
    if srv~=nil then
      srv:close()
    end

    srv = net.createServer(net.TCP)
    srv:listen(80, function(conn)
        conn:on("receive", function(sck, payload)
            print(payload)
            sck:send("HTTP/1.0 200 OK\r\nContent-Type: text/html\r\n\r\n<h1> Hello, NodeMCU.</h1>")
        end)
        conn:on("sent", function(sck) sck:close() end)
    end)
end

server.setupWifi = function()
    -- connect to WiFi access point
    wifi.setmode(wifi.STATION)
    wifi.sta.config("Crazy Diamond", "oldsmobilef85")
end

return server
