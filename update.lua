package.loaded.config = nil

local update = {}
config = require "config"


update.getVersionInfo = function()
    majorVer, minorVer, devVer, chipID, flashID, flashSize, flashMode, flashSpeed = node.info()
    nodeMCUVersion = majorVer.."."..minorVer.."."..devVer
    firmwareVersion = config.version
    return nodeMCUVersion, firmwareVersion
end

update.updateFile = function(filePayload)
    fileData = {}
    i = 0
    for line in string.gmatch(filePayload, '[^\n]+') do
        fileData[i] = line
        print(line)
        i = i + 1
    end

    filename = fileData[1]
    if file.exists(filename) then
        print("file exists, making a backup")
        file.rename(filename, filename..".bkp")
    end
    
    file.open(filename, "w+")
    for i = 3, #fileData do
        file.writeline(fileData[i])
    end
    file.close(filename)
end

return update