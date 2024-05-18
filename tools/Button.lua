
Button = {};
Button.__index = Button;

function Button:new(x, y, width, height, str, backColor, outlineColor, activeColor, strColor)
    local ret = {
        x = x,
        y = y,
        width = width,
        height = height,
        str = str,
        backColor = backColor,
        outlineColor = outlineColor,
        activeColor = activeColor,
        strColor = strColor,
        isActive = false,
        isEnable = true,
        handleEvent = function () end,
    };
    setmetatable(ret, self);
    return ret;
end

function Button:setActive(isActive)
    self.isActive = isActive;
end

function Button:draw()
    if self.isActive == false then
        love.graphics.setColor(self.backColor);
    else
        love.graphics.setColor(self.activeColor);
    end
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height);
    love.graphics.setColor(self.outlineColor);
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height);
    love.graphics.setColor(self.strColor);
    local currFont = love.graphics.newFont("tools/m6x11plus.ttf", self.height);
    love.graphics.setFont(currFont);
    love.graphics.print(self.str, self:calcXPosForCenter(), self.y);
end

function Button:checkMouseIn(mouseX, mouseY)
    if mouseX <= self.x or mouseX >= self.x + self.width then
        return false;
    end
    if mouseY <= self.y or mouseY >= self.y + self.height then
        return false;
    end
    return true;
end

-- 保持文字居中对齐
function Button:calcXPosForCenter()
    local strLen = #self.str;
    local fontRatio = 0.45;
    local fontX = self.x + self.width / 2 - strLen * self.height * fontRatio / 2;
    return fontX;
end