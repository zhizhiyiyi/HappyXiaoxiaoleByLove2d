require("tools/Array");
require("tools/Button");

ButtonArray = Array:new();
ButtonArray.__index = ButtonArray;

function ButtonArray:new()
    local ret = {};
    setmetatable(ret, self);
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

function ButtonArray:handleEvent(mouseX, mouseY)
    for _, currButton in ipairs(self) do
        if currButton:checkMouseIn(mouseX, mouseY) then
            currButton:handleEvent(mouseX, mouseY);
        end
    end
end