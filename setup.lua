package.loaded.config = nil

config = require "config"

local setup = {}

cfg = {}

cfg.pwd=config.wpapwd
cfg.auth=AUTH_WPA2_PSK
cfg.ssid=config.SSID
cfg.channel=6
cfg.hidden=0
cfg.max=2
cfg.beacon=100

setup.wifi = function()
    wifi.setmode(wifi.STATIONAP)
    wifi.setphymode(wifi.PHYMODE_N)
    wifi.ap.config(cfg)
    enduser_setup.manual(true)
    enduser_setup.start(
            function()
                print("Connected", wifi.sta.getip())
                enduser_setup.stop()
            end,
            function(err, str)
                print(err, str)
            end
    )
end

return setup
