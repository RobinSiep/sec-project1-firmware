package.loaded.led = nil
package.loaded.wsclient = nil
package.loaded.setup = nil
led = require "led"
wsclient = require "wsclient"
setup = require "setup"
led.init()
led.pattern = {1,0,1,0}
led.on()
setup.wifi()
wsclient.setup()