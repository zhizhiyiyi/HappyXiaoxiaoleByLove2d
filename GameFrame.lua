require("tools/Frame");
require("tools/HexColor");

GameFrame = Frame:new();

-- 游戏区域是一个长度为10个小方格，高度为16个小方格的封闭区域构成
-- 封闭区域由上下左右的4个edgeShape组成

function GameFrame:new(name, backColor, buttonArray, isEnable)
    local ret = {
        world = nil,
        object = nil,
        worldBlocks = nil,
        worldMeter = 64,
        worldGravity = 64 * 9.8,
        worldBlocksMaxNum = 100,
        worldBlockDefaultColor = {
            HexColor("#FF0000"),
            HexColor("#FFCC00"),
            HexColor("#37C870"),
            HexColor("#0066FF"),
            HexColor("#784421"),
            HexColor("#9933FF"),
            HexColor("#000000"),
        },
        worldReadyBlockIndex = 1,
        worldPosX = 400,
        worldPosY = 50,
        worldBlockSize = 40,
        worldXNum = 10,
        worldYNum = 16,
        worldWidth = 40 * 10,
        worldHeight = 40 * 17,
        particleArr = {},
    };
    setmetatable(ret, self);
    self.__index = self;
    ret:init(name, backColor, buttonArray, isEnable);
    return ret;
end

function GameFrame:generateParticle(color, x, y)
    local imageData = love.image.newImageData(5, 5);
    imageData:mapPixel(
        function(...)
            return color[1], color[2], color[3], 1;
        end
    );
    local image = love.graphics.newImage(imageData);

    local particleSystem = love.graphics.newParticleSystem(image, 100);
    particleSystem:setParticleLifetime(0.5, 2);
    particleSystem:setLinearAcceleration(0, self.worldGravity, 0, self.worldGravity);
    particleSystem:setSpread(2 * math.pi);
    particleSystem:setSpeed(100, 500);
    local result = {
        particleSystem = particleSystem,
        color = color,
        x = x,
        y = y,
        hasEmitted = false,
    };

    table.insert(self.particleArr, result);
end

function GameFrame:emitParticle()
    for i = 1, #self.particleArr do
        local currParticleSystem = self.particleArr[i];
        if not currParticleSystem.hasEmitted then
            currParticleSystem.particleSystem:emit(100);
            currParticleSystem.hasEmitted = true;
        end
    end
end

function GameFrame:updateParticle(dt)
    self:deleteUsedParticle();
    for i = 1, #self.particleArr do
        local currParticleSystem = self.particleArr[i];
        currParticleSystem.particleSystem:update(dt);
    end
end

-- 删除发射过的粒子效果
function GameFrame:deleteUsedParticle()
    local i = 1;
    while i <= #self.particleArr do
        local currParticleSystem = self.particleArr[i];
        if currParticleSystem.hasEmitted and currParticleSystem.particleSystem:getCount() == 0 then  
            self.particleArr[i].particleSystem:release();
            table.remove(self.particleArr, i);
        else
            i = i + 1;
        end
    end
end

function GameFrame:drawParticle()
    for i = 1, #self.particleArr do
        local currParticleSystem = self.particleArr[i];
        love.graphics.setColor(currParticleSystem.color);
        love.graphics.draw(currParticleSystem.particleSystem, currParticleSystem.x, currParticleSystem.y);
    end
end

function GameFrame:draw()
    if self.isEnable == false then
        return;
    end
    love.graphics.clear(self.backColor);
    love.graphics.setColor(HexColor("#000000"));
    local _, windowHeight = love.graphics.getDimensions();
    love.graphics.line(250, 0, 250, windowHeight);
    self.buttonArray:draw();

    self:drawPhysicsWorld();
    self:drawParticle();
end

function GameFrame:createPhysicsWorld()
    if self.world ~= nil or self.object ~= nil then
        return;
    end
    love.physics.setMeter(self.worldMeter);
    self.world = love.physics.newWorld(0, self.worldGravity, true);
    self.objects = {};
    self.worldBlocks = {};
    for i = 1, self.worldXNum do
        self.worldBlocks[i] = {};
    end
    
    -- 设置一个矩形边界，所有物理模拟均限制在此矩形中
    -- 左上角坐标
    local leftUpX = self.worldPosX;
    local leftUpY = self.worldPosY;
    -- 右上角坐标
    local rightUpX = self.worldPosX + self.worldWidth;
    local rightUpY = self.worldPosY;
    -- 左下角坐标
    local leftDownX = self.worldPosX;
    local leftDownY = self.worldPosY + self.worldHeight;
    -- 右下角坐标
    local rightDownX = self.worldPosX + self.worldWidth;
    local rightDownY = self.worldPosY + self.worldHeight;

    self.objects.upBorder = {};
    self.objects.upBorder.body = love.physics.newBody(self.world, 0, 0, "static");
    self.objects.upBorder.shape = love.physics.newEdgeShape(leftUpX, leftUpY, rightUpX, rightUpY);
    self.objects.upBorder.fixture = love.physics.newFixture(self.objects.upBorder.body, self.objects.upBorder.shape);

    self.objects.leftBorder = {};
    self.objects.leftBorder.body = love.physics.newBody(self.world, 0, 0, "static");
    self.objects.leftBorder.shape = love.physics.newEdgeShape(leftUpX, leftUpY, leftDownX, leftDownY);
    self.objects.leftBorder.fixture = love.physics.newFixture(self.objects.leftBorder.body, self.objects.leftBorder.shape);

    self.objects.rightBorder = {};
    self.objects.rightBorder.body = love.physics.newBody(self.world, 0, 0, "static");
    self.objects.rightBorder.shape = love.physics.newEdgeShape(rightUpX, rightUpY, rightDownX, rightDownY);
    self.objects.rightBorder.fixture = love.physics.newFixture(self.objects.rightBorder.body, self.objects.rightBorder.shape);

    self.objects.downBorder = {};
    self.objects.downBorder.body = love.physics.newBody(self.world, 0, 0, "static");
    self.objects.downBorder.shape = love.physics.newEdgeShape(leftDownX, leftDownY, rightDownX, rightDownY);
    self.objects.downBorder.fixture = love.physics.newFixture(self.objects.downBorder.body, self.objects.downBorder.shape);
    self.objects.downBorder.fixture:setFriction(0.3);

    for i = 1, self.worldXNum - 1 do
        local currBorder = {};
        currBorder.body = love.physics.newBody(self.world, 0, 0, "static");
        currBorder.shape = love.physics.newEdgeShape(leftUpX + i * self.worldBlockSize, leftUpY + self.worldBlockSize, 
            leftUpX + i * self.worldBlockSize, leftDownY);
        currBorder.fixture = love.physics.newFixture(currBorder.body, currBorder.shape);
        table.insert(self.objects, currBorder);
    end

    for i = 1, self.worldYNum do
        for j = 1, self.worldXNum do
            self:generateBlock(j, self.worldPosY + (0.5 + self.worldYNum - i) * self.worldBlockSize);
        end
    end

end

function GameFrame:destoryPhysicsWorld()
    if self.world ~= nil then
        self.world:destroy();
        self.world = nil;
    end
    if self.objects ~= nil then
        self.objects = nil;
    end
    if self.worldBlocks ~= nil then
        self.worldBlocks = nil;
    end
end

function GameFrame:drawPhysicsWorld()
    if self.world == nil then
        return;
    end

    -- 画格子线
    -- -- 竖向格子线
    -- love.graphics.setColor(HexColor("#C0C0C0"));
    -- for i = 1, 9 do
    --     love.graphics.line(self.worldPosX + i * self.worldBlockSize, self.worldPosY + self.worldBlockSize, self.worldPosX + i * self.worldBlockSize, self.worldPosY + self.worldHeight);
    -- end
    -- -- 横向格子线
    -- for i = 1, 15 do
    --     love.graphics.line(self.worldPosX, self.worldPosY + i * self.worldBlockSize, self.worldPosX + self.worldWidth, self.worldPosY + i * self.worldBlockSize);
    -- end

    -- 画选择框
    love.graphics.setColor(HexColor("#FF0000"));
    love.graphics.rectangle("line", self.worldPosX + (self.worldReadyBlockIndex - 1) * self.worldBlockSize, self.worldPosY, self.worldBlockSize, self.worldBlockSize);

    -- 画世界边界
    love.graphics.setColor(HexColor("#000000"));
    love.graphics.line(self.objects.upBorder.body:getWorldPoints(self.objects.upBorder.shape:getPoints()));
    
    love.graphics.setColor(HexColor("#000000"));
    love.graphics.line(self.objects.leftBorder.body:getWorldPoints(self.objects.leftBorder.shape:getPoints()));
    
    love.graphics.setColor(HexColor("#000000"));
    love.graphics.line(self.objects.rightBorder.body:getWorldPoints(self.objects.rightBorder.shape:getPoints()));
    
    love.graphics.setColor(HexColor("#000000"));
    love.graphics.line(self.objects.downBorder.body:getWorldPoints(self.objects.downBorder.shape:getPoints()));

    -- 画格栅
    -- love.graphics.setColor(HexColor("#000000"));
    -- for i = 1, self.worldXNum - 1 do
    --     love.graphics.line(self.objects[i].body:getWorldPoints(self.objects[i].shape:getPoints()));
    -- end

    -- 画物理方块
    for i = 1, #self.worldBlocks do
        for j = 1, #self.worldBlocks[i] do
            local currBlock = self.worldBlocks[i][j];
            love.graphics.setColor(currBlock.color);
            love.graphics.polygon("fill", currBlock.body:getWorldPoints(currBlock.shape:getPoints()));
        end
    end
end

-- 向列号为columnIndex的列创建一个方块，列号从1开始数
function GameFrame:generateBlock(columnIndex, initPosY)
    if #self.worldBlocks[columnIndex] >= self.worldYNum - 1 then
        return;
    end
    local currBlock = {};
    currBlock.body = love.physics.newBody(self.world, 0, 0, "dynamic");
    currBlock.shape = love.physics.newRectangleShape(self.worldPosX + (columnIndex - 0.5) * self.worldBlockSize, initPosY, self.worldBlockSize - 2, self.worldBlockSize);
    currBlock.fixture = love.physics.newFixture(currBlock.body, currBlock.shape, 1);
    currBlock.fixture:setRestitution(0.2);
    currBlock.fixture:setFriction(0);
    currBlock.color = self.worldBlockDefaultColor[math.random(1, #self.worldBlockDefaultColor)];
    table.insert(self.worldBlocks[columnIndex], currBlock);
end

function GameFrame:handleMouseClick(x, y)
    if x < self.worldPosX or x > self.worldPosX + self.worldWidth then
        return;
    end
    if y < self.worldPosY or y > self.worldPosY + self.worldHeight then
        return;
    end

    if self.world == nil then
        return;
    end

    for i = 1, #self.worldBlocks do
        for j = 1, #self.worldBlocks[i] do
            local currBlock = self.worldBlocks[i][j];
            if currBlock.fixture:testPoint(x, y) then
                local delPos = self:getSameColorBlocksByBFS(i, j);

                table.sort(delPos, function(a, b)
                    return a[2] > b[2];
                end);

                for k = 1, #delPos do
                    local currDelXIndex = delPos[k][1];
                    local currDelYIndex = delPos[k][2];
                    local particleX = self.worldPosX + (currDelXIndex - 0.5) * self.worldBlockSize;
                    local particleY = self.worldPosY + self.worldHeight - (currDelYIndex - 0.5) * self.worldBlockSize;
                    self:generateParticle(currBlock.color, particleX, particleY);

                    -- 给上方方块施加爆炸反冲力
                    if #self.worldBlocks[currDelXIndex] >= currDelYIndex + 1 then
                        self.worldBlocks[currDelXIndex][currDelYIndex + 1].body:applyForce(0, -10000);
                    end

                    self.worldBlocks[currDelXIndex][currDelYIndex].body:destroy();
                    table.remove(self.worldBlocks[currDelXIndex], currDelYIndex);
                    self:emitParticle();
                end

                --self:generateBlock(i, self.worldPosY + 0.5 * self.worldBlockSize);
                break;
            end
        end
    end
end

function GameFrame:checkWorldBlockIndexInWorld(xIndex, yIndex)
    if xIndex < 1 or xIndex > self.worldXNum or yIndex < 1 or yIndex > self.worldYNum - 1 then
        return false;
    end
    return true;
end

function GameFrame:checkWorldBlockExisted(xIndex, yIndex)
    if xIndex < 1 or xIndex > self.worldXNum or yIndex < 1 or yIndex > #self.worldBlocks[xIndex] then
        return false;
    end
    return true;
end

function GameFrame:getSameColorBlocksByBFS(xIndex, yIndex)
    local ret = {};
    if not self:checkWorldBlockExisted(xIndex, yIndex) then
        return ret;
    end
    local targetColor = self.worldBlocks[xIndex][yIndex].color;
    local workList = {};
    local footPrint = {};
    for i = 1, self.worldXNum do
        footPrint[i] = {};
        for j = 1, self.worldYNum do
            footPrint[i][j] = false;
        end
    end
    table.insert(ret, {xIndex, yIndex});
    table.insert(workList, {xIndex, yIndex});
    footPrint[xIndex][yIndex] = true;

    while #workList ~= 0 do
        -- 注意：worldBlocks这个二维数组，堆积在上面的方块，它在二维数组中的下标更大
        -- 上
        local currXIndex = workList[1][1];
        local currYIndex = workList[1][2] + 1;
        if self:checkWorldBlockExisted(currXIndex, currYIndex) and footPrint[currXIndex][currYIndex] == false then
            local currColor = self.worldBlocks[currXIndex][currYIndex].color;
            if isSameColor(currColor, targetColor) then
                table.insert(ret, {currXIndex, currYIndex});
                table.insert(workList, {currXIndex, currYIndex});
                footPrint[currXIndex][currYIndex] = true;
            end
        end

        -- 下
        currXIndex = workList[1][1];
        currYIndex = workList[1][2] - 1;
        if self:checkWorldBlockExisted(currXIndex, currYIndex) and footPrint[currXIndex][currYIndex] == false then
            local currColor = self.worldBlocks[currXIndex][currYIndex].color;
            if isSameColor(currColor, targetColor) then
                table.insert(ret, {currXIndex, currYIndex});
                table.insert(workList, {currXIndex, currYIndex});
                footPrint[currXIndex][currYIndex] = true;
            end
        end

        -- 左
        currXIndex = workList[1][1] - 1;
        currYIndex = workList[1][2];
        if self:checkWorldBlockExisted(currXIndex, currYIndex) and footPrint[currXIndex][currYIndex] == false then
            local currColor = self.worldBlocks[currXIndex][currYIndex].color;
            if isSameColor(currColor, targetColor) then
                table.insert(ret, {currXIndex, currYIndex});
                table.insert(workList, {currXIndex, currYIndex});
                footPrint[currXIndex][currYIndex] = true;
            end
        end

        -- 右
        currXIndex = workList[1][1] + 1;
        currYIndex = workList[1][2];
        if self:checkWorldBlockExisted(currXIndex, currYIndex) and footPrint[currXIndex][currYIndex] == false then
            local currColor = self.worldBlocks[currXIndex][currYIndex].color;
            if isSameColor(currColor, targetColor) then
                table.insert(ret, {currXIndex, currYIndex});
                table.insert(workList, {currXIndex, currYIndex});
                footPrint[currXIndex][currYIndex] = true;
            end
        end

        table.remove(workList, 1);
    end
    return ret;
end

function isSameColor(color1, color2)
    for i = 1, 3 do
        if color1[i] ~= color2[i] then
            return false;
        end
    end
    return true;
end

