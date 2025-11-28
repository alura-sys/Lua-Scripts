local RAW = "https://raw.githubusercontent.com/alura-sys/Lua-Scripts/main/Halloween"

local function quick_get(u)
    if syn and syn.request then
        local r = syn.request({ Url = u, Method = "GET" })
        assert(r and r.StatusCode == 200, "syn.request "..tostring(r and r.StatusCode))
        return r.Body
    elseif http and http.request then
        local r = http.request({ Url = u, Method = "GET" })
        assert(r and r.StatusCode == 200, "http.request "..tostring(r and r.StatusCode))
        return r.Body
    elseif request then
        local r = request({ Url = u, Method = "GET" })
        assert(r and r.StatusCode == 200, "request "..tostring(r and r.StatusCode))
        return r.Body
    end
    return game:HttpGet(u)
end

local util_src = quick_get(RAW .. "/util.lua")
local Util = assert(loadstring(util_src, "Halloween/util"))()

local urls = {
    ["Halloween/config"] = RAW .. "/config.lua",
    ["Halloween/functions"] = RAW .. "/functions.lua",
    ["Halloween/gui"] = RAW .. "/gui.lua",
    ["Halloween/main"] = RAW .. "/main.lua"
}

return Util.bootstrap(urls, "Halloween/main")


