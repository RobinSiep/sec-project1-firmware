package.loaded.config = nil

local update = {}
config = require "config"

update.list = {}

update.getVersionInfo = function()
    majorVer, minorVer, devVer, chipID, flashID, flashSize, flashMode, flashSpeed = node.info()
    nodeMCUVersion = majorVer.."."..minorVer.."."..devVer
    firmwareVersion = config.version
    return nodeMCUVersion, firmwareVersion
end

update.updateFile = function(filePayload)
    ok, err = pcall(updateFile, filePayload)
    if not ok then
        print("update failed, restoring")
        update.restore()
    end
    return ok
end

updateFile = function(filePayload)
    fileData = {}
    i = 1
    for line in string.gmatch(filePayload, '[^\n]+') do
        fileData[i] = line
        print(line)
        i = i + 1
    end

    filename = fileData[2]
    --add filename to update list
    table.insert(update.list, filename)
    
    if file.exists(filename) then
        print("file exists, making a backup")
        file.rename(filename, filename..".bkp")
    end

    print("writing to file "..filename)
    file.open(filename, "w+")
    for i = 4, #fileData do
        file.writeline(fileData[i])
    end
    file.close(filename)
end

update.restore = function()
    files = file.list()
    for existingFile, value in pairs(files) do
        --check if the file is a backup
        if existingFile:sub(-4,-1) == ".bkp" then
            --check if a new file has already been made
            updateFile = existingFile:sub(1, -5)
            if file.exists(updateFile) then
               file.remove(updateFile)
            end

            file.rename(existingFile, updateFile)
        end
    end
end

update.clean = function()
    files = file.list()
    for existingFile,value in pairs(files) do
        found = false
        for index, newFile in pairs(update.list) do
            if newFile == existingFile then
                found = true
            end
        end
        if not found then
            file.remove(existingFile)
        end
    end
    update.list = {}
end

update.finish = function()
    update.clean()
    -- reboot
    dofile("init.lua")
end

return update