local led = {}

local pin = 4
local value = gpio.LOW

led.toggle = function ()
    if value == gpio.LOW then
        value = gpio.HIGH
    else
        value = gpio.LOW
    end

    gpio.write(pin, value)
end

led.init = function()
    gpio.mode(pin, gpio.OUTPUT)
    gpio.write(pin, value)
end

return led
