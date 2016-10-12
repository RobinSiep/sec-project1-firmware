package.loaded.led = nil
package.loaded.wsclient = nil
led = require "led"
wsclient = require "wsclient"
led.init()
wsclient.setup()


