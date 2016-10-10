local led = {}

local pin = 4
local value = gpio.LOW

led.on = false

led.control = function(state)
    value = state
    gpio.write(pin, value)
end

led.vibrate = function(pattern)
    for i, state in ipairs(pattern) do
        print("loop")
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
    led.on = on
    if on == true then
        led.vibrate(pattern)
    end
end

return led
