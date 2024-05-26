require("tools/Frame");
require("tools/HexColor");

GameFrame = Frame:new();

-- 游戏区域是一个长度为10个小方格，高度为16个小方格的封闭区域构成
-- 封闭区域由上下左右的4个edgeShape组成

function GameFrame:new(name, backColor, buttonArray, isEnable)
    local ret = {
        world = nil,
        object = nil,
        worldPosX = 300,
        worldPosY = 50,
        worldBlockSize = 50,
        worldXNum = 10,
        worldYNum = 16,
        worldWidth = 50 * 10,
        worldHeight = 50 * 16,
    };
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
    local _, windowHeight = love.graphics.getDimensions();
    love.graphics.line(250, 0, 250, windowHeight);
    self.buttonArray:draw();

    self:drawPhysicsWorld();
    
end

function GameFrame:createPhysicsWorld()
    if self.world ~= nil or self.object ~= nil then
        return;
    end
    love.physics.setMeter(64);
    self.world = love.physics.newWorld(0, 9.81 * 64, true);
    self.objects = {};
    
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
    self.objects.upBorder.body = love.physics.newBody(self.world, leftUpX, leftUpY, "static");
    self.objects.upBorder.shape = love.physics.newEdgeShape(leftUpX, leftUpY, rightUpX, rightUpY);
    self.objects.upBorder.fixture = love.physics.newFixture(self.objects.upBorder.body, self.objects.upBorder.shape);

    self.objects.leftBorder = {};
    self.objects.leftBorder.body = love.physics.newBody(self.world, leftUpX, leftUpY, "static");
    self.objects.leftBorder.shape = love.physics.newEdgeShape(leftUpX, leftUpY, leftDownX, leftDownY);
    self.objects.leftBorder.fixture = love.physics.newFixture(self.objects.leftBorder.body, self.objects.leftBorder.shape);

    self.objects.rightBorder = {};
    self.objects.rightBorder.body = love.physics.newBody(self.world, rightUpX, rightUpY, "static");
    self.objects.rightBorder.shape = love.physics.newEdgeShape(rightUpX, rightUpY, rightDownX, rightDownY);
    self.objects.rightBorder.fixture = love.physics.newFixture(self.objects.rightBorder.body, self.objects.rightBorder.shape);

    self.objects.downBorder = {};
    self.objects.downBorder.body = love.physics.newBody(self.world, leftDownX, leftDownY, "static");
    self.objects.downBorder.shape = love.physics.newEdgeShape(leftDownX, leftDownY, rightDownX, rightDownY);
    self.objects.downBorder.fixture = love.physics.newFixture(self.objects.downBorder.body, self.objects.downBorder.shape);
    self.objects.downBorder.fixture:setFriction(0.3);

    
    -- self.objects.block = {};
    -- self.objects.block.body = love.physics.newBody(self.world, 650 / 2, 650 / 2, "dynamic");
    -- self.objects.block.shape = love.physics.newRectangleShape(0, 0, 100, 100);
    -- self.objects.block.fixture = love.physics.newFixture(self.objects.block.body, self.objects.block.shape, 1);
    -- self.objects.block.fixture:setRestitution(0.5);
    -- self.objects.block.fixture:setFriction(0.3);
end

function GameFrame:destoryPhysicsWorld()
    if self.world ~= nil then
        self.world:destroy();
        self.world = nil;
    end
    if self.objects ~= nil then
        self.objects = nil;
    end
end

function GameFrame:drawPhysicsWorld()
    if self.world == nil then
        return;
    end
    love.graphics.setColor(HexColor("#000000"));
    love.graphics.line(self.objects.upBorder.body:getWorldPoints(self.objects.upBorder.shape:getPoints()));
end
