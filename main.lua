package.loaded.server = nil
package.loaded.led = nil
server = require "server"
led = require "led"
led.init()
server.createHTTPServer()
server.setupWifi()

