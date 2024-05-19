
require("tools/HexColor");
require("tools/Button");
require("tools/ButtonArray");
require("tools/Frame");
require("MenuFrame");
require("GameFrame");

frameBackColor = HexColor("#FFFFFF");
buttonBackColor = HexColor("#C0C0C0");
buttonOutlineColor = HexColor("#000000");
buttonActiveColor = HexColor("#2fc1c5");
buttonStrColor = HexColor("#000000");

menuFrameExitButtonPress = function ()
    love.event.quit();
end

function createMenuFrame(frameBackColor)
    local windowWidth, windowHeight = love.graphics.getDimensions();
    local buttonWidth = 200;
    local buttonHeight = 50;
    local menuFrameNewGameButton = Button:new(windowWidth / 2 - buttonWidth / 2, windowHeight / 3, buttonWidth, buttonHeight, 
    "New Game", buttonBackColor, buttonOutlineColor, buttonActiveColor, buttonStrColor);
    local menuFrameExitButton = Button:new(windowWidth / 2 - buttonWidth / 2, windowHeight / 3 + buttonHeight + 30, buttonWidth, buttonHeight, 
    "Exit", buttonBackColor, buttonOutlineColor, buttonActiveColor, buttonStrColor);
    menuFrameExitButton.handleMousePress = menuFrameExitButtonPress;

    menuFrameButtonArray = ButtonArray:new();
    menuFrameButtonArray:addButton(menuFrameNewGameButton);
    menuFrameButtonArray:addButton(menuFrameExitButton);

    menuFrame = MenuFrame:new("menu", frameBackColor, menuFrameButtonArray, true);

    return menuFrame;
end

function createGameFrame(frameBackColor)
    local windowWidth, windowHeight = love.graphics.getDimensions();
    local buttonWidth = 200;
    local buttonHeight = 50;
    local gameFrameNewGameButton = Button:new(30, windowHeight - 100, buttonWidth, buttonHeight, 
    "Back", buttonBackColor, buttonOutlineColor, buttonActiveColor, buttonStrColor);
    gameFrameButtonArray = ButtonArray:new();
    gameFrameButtonArray:addButton(gameFrameNewGameButton);

    gameFrame = GameFrame:new("menu", frameBackColor, gameFrameButtonArray, true);

    return gameFrame;
end

function createPhysicsWorld()
    love.physics.setMeter(64);
    world = love.physics.newWorld(0, 9.81 * 64, true);
    objects = {};

    local windowWidth, windowHeight = love.graphics.getDimensions();
    
    -- 设置一个矩形边界，所有物理模拟均限制在此举行中
    objects.downBorder = {};
    objects.downBorder.body = love.physics.newBody(world, 0, 0, "static");
    objects.downBorder.shape = love.physics.newEdgeShape(0, windowHeight, windowWidth, windowHeight);
    objects.downBorder.fixture = love.physics.newFixture(objects.downBorder.body, objects.downBorder.shape);
    objects.downBorder.fixture:setFriction(0.3);

    objects.leftBorder = {};
    objects.leftBorder.body = love.physics.newBody(world, 0, 0, "static");
    objects.leftBorder.shape = love.physics.newEdgeShape(0, 0, 0, windowHeight);
    objects.leftBorder.fixture = love.physics.newFixture(objects.leftBorder.body, objects.leftBorder.shape);

    objects.rightBorder = {};
    objects.rightBorder.body = love.physics.newBody(world, 0, 0, "static");
    objects.rightBorder.shape = love.physics.newEdgeShape(windowWidth, 0, windowWidth, windowHeight);
    objects.rightBorder.fixture = love.physics.newFixture(objects.rightBorder.body, objects.rightBorder.shape);

    objects.upBorder = {};
    objects.upBorder.body = love.physics.newBody(world, 0, 0, "static");
    objects.upBorder.shape = love.physics.newEdgeShape(0, 0, windowWidth, 0);
    objects.upBorder.fixture = love.physics.newFixture(objects.upBorder.body, objects.upBorder.shape);

    objects.block = {};
    objects.block.body = love.physics.newBody(world, 650 / 2, 650 / 2, "dynamic");
    objects.block.shape = love.physics.newRectangleShape(0, 0, 100, 100);
    objects.block.fixture = love.physics.newFixture(objects.block.body, objects.block.shape, 1);
    objects.block.fixture:setRestitution(0.5);
    objects.block.fixture:setFriction(0.3);
end

function love.load()
    love.graphics.setBackgroundColor(frameBackColor);

    -- 初始菜单界面
    menuFrame = createMenuFrame(frameBackColor);
    -- 游戏界面
    gameFrame = createGameFrame(frameBackColor);
    createPhysicsWorld();
    -- 当前界面
    currFrame = menuFrame;

    
end

function love.update(dt)
    world:update(dt)
    if love.keyboard.isDown("right") then
        objects.block.body:applyForce(4000, 0)
    end
    if love.keyboard.isDown("left") then
        objects.block.body:applyForce(-4000, 0)
    end
    if love.keyboard.isDown("up") then
        objects.block.body:applyForce(0, -4000)
    end
end

function love.mousemoved(x, y)
    currFrame:handleMouseMove(x, y);
end

function love.mousepressed(x, y)
    local pressedButton = currFrame:handleMousePress(x, y);
    if pressedButton then
        if pressedButton.str == "New Game" then
            currFrame = gameFrame;
        elseif pressedButton.str == "Back" then
            currFrame = menuFrame;
        end
    end
end

function love.draw()
    currFrame:draw(objects);
end