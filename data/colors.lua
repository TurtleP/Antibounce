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
    LightestGreen = "#9bbc0f"
}

--[[ Material Design ]]--

Colors.Material =
{
    Background    = "#cfff95",
    DarkestGreen  = "#1b5e20",
    DarkGreen     = "#33691e",
    LightGreen    = "#8bc34a",
    LightestGreen = "#9ccc65"
}

function Colors:toggleMode()
    self.mode = not self.mode

    if self.mode then
        self.currentMode = "GameBoy"
    else
        self.currentMode = "Material"
    end
end

function Colors:get(name)
    local str = self[self.currentMode][name]

    str = str:gsub("#", "")

    local out = {}
    for i = 1, #str, 2 do
        table.insert(out, tonumber(str:sub(i, i + 1), 16))
    end

    return {love.math.colorFromBytes(unpack(out))}
end

return Colors
