require("tools/Frame");
require("tools/HexColor");

GameFrame = Frame:new();

function GameFrame:new(name, backColor, buttonArray, isEnable)
    local ret = {};
    setmetatable(ret, self);
    self.__index = self;
    ret:init(name, backColor, buttonArray, isEnable);
    return ret;
end

function GameFrame:draw(objects)
    if self.isEnable == false then
        return;
    end
    love.graphics.clear(self.backColor);
    love.graphics.setColor(HexColor("#000000"));
    local windowWidth, windowHeight = love.graphics.getDimensions();
    love.graphics.line(250, 0, 250, windowHeight);
    self.buttonArray:draw();

    love.graphics.setColor(HexColor("#238923"));
    love.graphics.polygon("fill", objects.block.body:getWorldPoints(objects.block.shape:getPoints()));
end