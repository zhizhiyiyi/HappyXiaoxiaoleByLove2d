
FloatScore = {};

-- 向上淡出效果
function FloatScore:new(initNum, startX, startY, fontSize, maxFloatDistance, floatSpeed, color)
    assert(type(initNum) == "number", "FloatScore initNum must be a number");
    local ret = {
        initNum = initNum,
        x = startX,
        y = startY,
        fontSize = fontSize,
        maxFloatDistance = maxFloatDistance,
        currFloatDistance = maxFloatDistance,
        floatSpeed = floatSpeed,
        color = color,
    };
    setmetatable(ret, self);
    self.__index = self;
    return ret;
end

function FloatScore:setPos(x, y)
    self.x = x;
    self.y = y;
end

function FloatScore:setNumber(num)
    self.initNum = num;
end

function FloatScore:setFontColor(color)
    self.color = color;
end

function FloatScore:reset()
    self.currFloatDistance = 0;
end

function FloatScore:update()
    if self.currFloatDistance >= self.maxFloatDistance then
        return;
    end
    self.currFloatDistance = self.currFloatDistance + self.floatSpeed;
    self.y = self.y - self.floatSpeed;
end

function FloatScore:draw()
    if self.currFloatDistance >= self.maxFloatDistance then
        return;
    end
    local alphaValue = 1 - self.currFloatDistance / self.maxFloatDistance;
    love.graphics.setColor(self.color[1], self.color[2], self.color[3], alphaValue);
    local currFont = love.graphics.newFont("tools/m6x11plus.ttf", self.fontSize);
    love.graphics.setFont(currFont);
    love.graphics.print(tostring(self.initNum), self.x + self.fontSize / 2, self.y - self.fontSize / 2);
end