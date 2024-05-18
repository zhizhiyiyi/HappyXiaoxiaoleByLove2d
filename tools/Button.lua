
require("tools/Button");

Button = {};
Button.__index = Button;

function Button:new(x, y, width, height, str, backColor, outlineColor, activeColor)
    local ret = {
        x = x,
        y = y,
        width = width,
        height = height,
        str = str,
        backColor = backColor,
        outlineColor = outlineColor,
        activeColor = activeColor,
        isActive = false,
        enable = true,
    };
    setmetatable(ret, self);
    
end