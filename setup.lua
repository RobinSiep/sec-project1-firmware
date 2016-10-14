package.loaded.config = nil

config = require "config"

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
        return false
    end
    print(wifi.sta.getip())
    return true

end

setup.wifi = function()
    if not try_connecting() then
        run_setup()
    end
end

return setup
