require("tools/Array");
require("tools/Button");

ButtonArray = Array:new();

function ButtonArray:new()
    local ret = {};
    setmetatable(ret, self);
    self.__index = self;
    return ret;
end

function ButtonArray:addButton(currButton)
    self:pushBack(currButton);
end

function ButtonArray:draw()
    for _, currButton in ipairs(self) do
        currButton:draw();
    end
end

function ButtonArray:updateActiveState(mouseX, mouseY)
    for _, currButton in ipairs(self) do
        if currButton:checkMouseIn(mouseX, mouseY) then
            currButton:setActive(true);
        else
            currButton:setActive(false);
        end
    end
end

function ButtonArray:handleButtonPress(mouseX, mouseY)
    for _, currButton in ipairs(self) do
        if currButton:checkMouseIn(mouseX, mouseY) then
            currButton:handleButtonPress(mouseX, mouseY);
            return currButton;
        end
    end
    return nil;
end