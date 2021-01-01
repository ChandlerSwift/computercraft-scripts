if not http then
    printError("wget requires http API")
    printError("Set http_enable to true in ComputerCraft.cfg")
    return
end
 
local function get(url)
    local ok, err = http.checkURL(url)
    if not ok then
        print("Failed.")
        if err then
            printError(err)
        end
        return nil
    end

    local response = http.get(url, nil, true)
    if not response then
        print("Failed.")
        return nil
    end

    local sResponse = response.readAll()
    response.close()
    return sResponse
end
 
-- Determine file to download
local args = {...}
local filename = args[1]
local url = "https://raw.githubusercontent.com/ChandlerSwift/computercraft-scripts/master/" .. filename

-- Do the get
local res = get(url)
if res then
    local file = fs.open(shell.resolve(filename), "w")
    file.write(res)
    file.close()
end
