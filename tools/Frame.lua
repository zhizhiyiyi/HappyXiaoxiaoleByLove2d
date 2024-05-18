require("tools/ButtonArray");

Frame = {};

function Frame:new(name, backColor, buttonArray, isEnable)
    local ret = {
        name = name,
        backColor = backColor,
        buttonArray = buttonArray,
        isEnable = isEnable,
    };
    setmetatable(ret, self);
    self.__index = self;
    return ret;
end

function Frame:init(name, backColor, buttonArray, isEnable)
    self.name = name;
    self.backColor = backColor;
    self.buttonArray = buttonArray;
    self.isEnable = isEnable;
end

function Frame:draw()
    if self.isEnable == false then
        return;
    end
    love.graphics.clear(self.backColor);
    self.buttonArray:draw();
end

function Frame:handleMouseMove(x, y)
    self.buttonArray:updateActiveState(x, y);
end

function Frame:handleMousePress(x, y)
    return self.buttonArray:handleMousePress(x, y);
end