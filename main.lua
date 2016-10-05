package.loaded.server = nil
package.loaded.led = nil
package.loaded.wsclient = nil
package.loaded.setup = nil
server = require "server"
led = require "led"
wsclient = require "wsclient"
setup = require "setup"
led.init()
--server.setupWifi()
setup.wifi()
wsclient.setup()


