package.loaded.config = nil

local update = {}
config = require "config"

update.getVersionInfo = function()
    majorVer, minorVer, devVer, chipID, flashID, flashSize, flashMode, flashSpeed = node.info()
    nodeMCUVersion = majorVer.."."..minorVer.."."..devVer
    firmwareVersion = config.version
    return nodeMCUVersion, firmwareVersion
end

return update