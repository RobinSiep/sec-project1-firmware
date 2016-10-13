package.loaded.led = nil
package.loaded.wsclient = nil
package.loaded.setup = nil
led = require "led"
wsclient = require "wsclient"
setup = require "setup"
led.init()
setup.wifi()


