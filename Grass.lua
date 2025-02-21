local repo = "TwigDemonTF/computercraft"
local branch = "main"
local baseUrl = "https://raw.githubusercontent.com/" .. repo .. "/" .. branch .. "/"

-- Get the filename from the command-line argument
local file = ...

if not file then
    print("Usage: <script> <filename>")
    return
end

local url = baseUrl .. file
local response, err = http.get(
    url,
    {
        ["Cache-Control"] = "no-cache, no-store, must-revalidate",
        ["Pragma"] = "no-cache",
        ["Expires"] = 0
    }
)

if response then
    local content = response.readAll()
    response.close()

    local fileHandle = fs.open(file, "w")
    fileHandle.write(content)
    fileHandle.close()

    print("Downloaded: " .. file)
else
    print("Failed to download: " .. file .. " (" .. tostring(err) .. ")")
end
