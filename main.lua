-- vscode配置love2d调试环境，参考https://www.duidaima.com/Group/Topic/OtherTools/15168
if arg[2] == "debug" then
    require("lldebugger").start()
end
require("tools/HexColor");
require("tools/Button");
require("tools/ButtonArray");
require("tools/Frame");
require("MenuFrame");
require("GameFrame");

_G.frameBackColor = HexColor("#FFFFFF");
_G.buttonBackColor = HexColor("#C0C0C0");
_G.buttonOutlineColor = HexColor("#000000");
_G.buttonActiveColor = HexColor("#2fc1c5");
_G.buttonStrColor = HexColor("#000000");

function menuFrameExitButtonPress()
    love.event.quit();
end

function menuFrameNewGameButtonPress()
    _G.currFrame = _G.gameFrame;
end

function gameFrameBackButtonPress()
    _G.currFrame = _G.menuFrame;
end

function gameFrameRestartButtonPress()
    if _G.gameFrame.world ~= nil then
        _G.gameFrame:destoryPhysicsWorld();
    end
    _G.gameFrame:createPhysicsWorld();
end

function createMenuFrame(frameBackColor)
    local windowWidth, windowHeight = love.graphics.getDimensions();
    local buttonWidth = 200;
    local buttonHeight = 50;
    local menuFrameNewGameButton = Button:new(windowWidth / 2 - buttonWidth / 2, windowHeight / 3, buttonWidth, buttonHeight, 
    "New Game", buttonBackColor, buttonOutlineColor, buttonActiveColor, buttonStrColor);
    menuFrameNewGameButton.handleMousePress = menuFrameNewGameButtonPress;
    
    local menuFrameExitButton = Button:new(windowWidth / 2 - buttonWidth / 2, windowHeight / 3 + buttonHeight + 30, buttonWidth, buttonHeight, 
    "Exit", buttonBackColor, buttonOutlineColor, buttonActiveColor, buttonStrColor);
    menuFrameExitButton.handleMousePress = menuFrameExitButtonPress;

    local menuFrameButtonArray = ButtonArray:new();
    menuFrameButtonArray:addButton(menuFrameNewGameButton);
    menuFrameButtonArray:addButton(menuFrameExitButton);

    local menuFrame = MenuFrame:new("menu", frameBackColor, menuFrameButtonArray, true);

    return menuFrame;
end

function createGameFrame(frameBackColor)
    local gameFrameButtonArray = ButtonArray:new();
    local gameFrame = GameFrame:new("menu", frameBackColor, gameFrameButtonArray, true);

    local _, windowHeight = love.graphics.getDimensions();
    local buttonWidth = 200;
    local buttonHeight = 50;
    local gameFrameNewGameButton = Button:new(30, windowHeight - 100, buttonWidth, buttonHeight, 
    "Back", buttonBackColor, buttonOutlineColor, buttonActiveColor, buttonStrColor);
    gameFrameNewGameButton.handleMousePress = gameFrameBackButtonPress;

    local gameFrameRestartButton = Button:new(30, windowHeight - 100 - buttonHeight, buttonWidth, buttonHeight, 
    "Restart", buttonBackColor, buttonOutlineColor, buttonActiveColor, buttonStrColor);
    gameFrameRestartButton.handleMousePress = gameFrameRestartButtonPress;

    gameFrameButtonArray:addButton(gameFrameRestartButton);
    gameFrameButtonArray:addButton(gameFrameNewGameButton);

    return gameFrame;
end

function love.load()
    love.graphics.setBackgroundColor(frameBackColor);

    -- 初始菜单界面
    _G.menuFrame = createMenuFrame(frameBackColor);
    -- 游戏界面
    _G.gameFrame = createGameFrame(frameBackColor);
    -- 当前界面
    _G.currFrame = _G.menuFrame;

end

function love.update(dt)
    if _G.gameFrame.world ~= nil then
        _G.gameFrame.world:update(dt)
        
        -- if love.keyboard.isDown("right") then
        --     _G.gameFrame.objects.block.body:applyForce(4000, 0)
        -- end
        -- if love.keyboard.isDown("left") then
        --     _G.gameFrame.objects.block.body:applyForce(-4000, 0)
        -- end
        -- if love.keyboard.isDown("up") then
        --     _G.gameFrame.objects.block.body:applyForce(0, -4000)
        -- end
    end
    
end

function love.mousemoved(x, y)
    currFrame:handleMouseMove(x, y);
end

function love.mousepressed(x, y)
    local pressedButton = currFrame:handleMousePress(x, y);
    if pressedButton then
        pressedButton:handleMousePress();
    end
end

function love.draw()
    currFrame:draw(objects);
end

