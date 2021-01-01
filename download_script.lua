if not http then
    printError("wget requires http API")
    printError("Set http_enable to true in ComputerCraft.cfg")
    return
end
 
local function get(sUrl)
    local ok, err = http.checkURL(sUrl)
    if not ok then
        print("Failed.")
        if err then
            printError(err)
        end
        return nil
    end

    local response = http.get(sUrl, nil, true)
    if not response then
        print("Failed.")
        return nil
    end

    local sResponse = response.readAll()
    response.close()
    return sResponse
end
 
-- Determine file to download
local sFile = tArgs[1]
local sUrl = "https://raw.githubusercontent.com/ChandlerSwift/computercraft-scripts/master/" .. sFile

-- Do the get
local res = get(sUrl)
if res then
    local file = fs.open(sPath, "wb")
    file.write(res)
    file.close()
end
