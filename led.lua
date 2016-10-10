package.loaded.config = nil

config = require "config"

local led = {}

local pin = config.gpio

led.on = false

led.control = function(state)
    gpio.write(pin, state)
end

led.vibrate = function(pattern)
    for i, state in ipairs(pattern) do
        if state == 0 then
            gpio.write(pin, gpio.HIGH)
        else
            gpio.write(pin, gpio.LOW)
        end

        tmr.delay(100000)
    end

    if led.on == true then
        led.vibrate(pattern)
    end
end

led.init = function(on, pattern)
    gpio.mode(pin, gpio.OUTPUT)

    led.on = on
    if on == true then
        led.vibrate(pattern)
    end
end

led.init(true, {0,0,0,1,1,0,1,1})

return led
