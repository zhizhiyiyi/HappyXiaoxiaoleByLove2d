require("tools/Frame");

GameFrame = Frame:new();

function GameFrame:new(name, backColor, buttonArray, isEnable)
    local ret = {};
    setmetatable(ret, self);
    self.__index = self;
    ret:init(name, backColor, buttonArray, isEnable);
    return ret;
end

function GameFrame:draw()
    if self.isEnable == false then
        return;
    end
    love.graphics.clear(self.backColor);
    self.buttonArray:draw();
end