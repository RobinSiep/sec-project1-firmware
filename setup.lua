package.loaded.config = nil

config = require "config"

tmr.register(4, 5000, tmr.ALARM_SINGLE, function() try_connecting() end)

local setup = {}

function run_setup()
    wifi.setmode(wifi.SOFTAP)
    cfg={}
    cfg.ssid=config.SSID
    cfg.auth=AUTH_WPA2_PSK
    cfg.pwd=config.wpapwd
    wifi.ap.config(cfg)

    print("Opening WiFi credentials portal")
    dofile ("dns-liar.lua")
    dofile ("dnsserver.lua")
end

function try_connecting()
    wifi.setmode(wifi.STATION)
    print(wifi.sta.getip())
    if wifi.sta.getip() == nil then
        run_setup()
        return
    end
end

setup.wifi = function()
    tmr.start(4)
end

return setup
