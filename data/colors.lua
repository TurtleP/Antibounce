local Colors = {}

Colors.currentMode = "Material"
Colors.mode = false

--[[ Original Colors ]]--
Colors.GameBoy =
{
    Background    = "#cadc9f",
    DarkestGreen  = "#0f380f",
    DarkGreen     = "#306230",
    LightGreen    = "#8bac0f",
    LightestGreen = "#9bbc0f",

    Cached = {}
}

--[[ Material Design ]]--

Colors.Material =
{
    Background    = "#cfff95",
    DarkestGreen  = "#1b5e20",
    DarkGreen     = "#33691e",
    LightGreen    = "#8bc34a",
    LightestGreen = "#9ccc65",

    Cached = {}
}

function Colors:hex2Color(str)
    str = str:gsub("#", "")

    local out = {}
    for i = 1, #str, 2 do
        table.insert(out, tonumber(str:sub(i, i + 1), 16))
    end

    return {love.math.colorFromBytes(unpack(out))}
end

function Colors:cache(which)
    for k, v in pairs(self[which]) do
        if type(v) == "string" then
            local value = self:hex2Color(v)
            self[which].Cached[k] = value
        end
    end
end

function Colors:toggleMode()
    self.mode = not self.mode

    if self.mode then
        self.currentMode = "GameBoy"
    else
        self.currentMode = "Material"
    end
end

function Colors:get(name)
    if name:sub(1, 1) == "#" then
        return self[self.currentMode][name:gsub("#", "")]
    end
    return self[self.currentMode].Cached[name]
end

Colors:cache("Material")
Colors:cache("GameBoy")

return Colors
