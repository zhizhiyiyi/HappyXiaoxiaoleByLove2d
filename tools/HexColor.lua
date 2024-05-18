
HexColor = {};

function HexColor(hexStr)
    local rStr = string.sub(hexStr, 2, 3);
    local gStr = string.sub(hexStr, 4, 5);
    local bStr = string.sub(hexStr, 6, 7);
    local r = tonumber(rStr, 16);
    local g = tonumber(gStr, 16);
    local b = tonumber(bStr, 16);
    return {r / 255, g / 255, b / 255};
end

