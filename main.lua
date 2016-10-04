package.loaded.server = nil
package.loaded.led = nil
server = require "server"
led = require "led"
led.init()
server.setupWifi()

pollForCommands = function()
    tmr.alarm(0, 5000, 1, function()
        server.sendGet()
    end)
end

pollForCommands()

