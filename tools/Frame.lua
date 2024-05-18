require("tools/ButtonArray");

Frame = {};

function Frame:new(name, buttonArray, isEnable)
    local ret = {
        name = name,
        buttonArray = buttonArray,
        isEnable = isEnable,
    };
    setmetatable(ret, self);
    self.__index = self;
    return ret;
end

function Frame:init(name, buttonArray, isEnable)
    self.name = name;
    self.buttonArray = buttonArray;
    self.isEnable = isEnable;
end

function Frame:draw()
    if self.isEnable == false then
        return;
    end
    self.buttonArray:draw();
end

function Frame:handleMouseMove(x, y)
    self.buttonArray:updateActiveState(x, y);
end

function Frame:handleMousePress(x, y)
    self.buttonArray:handleMousePress(x, y);
end