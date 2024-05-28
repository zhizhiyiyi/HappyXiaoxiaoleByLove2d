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
    menuFrameNewGameButton.handleButtonPress = menuFrameNewGameButtonPress;
    
    local menuFrameExitButton = Button:new(windowWidth / 2 - buttonWidth / 2, windowHeight / 3 + buttonHeight + 30, buttonWidth, buttonHeight, 
    "Exit", buttonBackColor, buttonOutlineColor, buttonActiveColor, buttonStrColor);
    menuFrameExitButton.handleButtonPress = menuFrameExitButtonPress;

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
    gameFrameNewGameButton.handleButtonPress = gameFrameBackButtonPress;

    local gameFrameRestartButton = Button:new(30, windowHeight - 100 - buttonHeight, buttonWidth, buttonHeight, 
    "Restart", buttonBackColor, buttonOutlineColor, buttonActiveColor, buttonStrColor);
    gameFrameRestartButton.handleButtonPress = gameFrameRestartButtonPress;

    gameFrameButtonArray:addButton(gameFrameRestartButton);
    gameFrameButtonArray:addButton(gameFrameNewGameButton);

    return gameFrame;
end

function love.load()
    math.randomseed(os.time());
    love.graphics.setBackgroundColor(frameBackColor);

    -- 初始菜单界面
    _G.menuFrame = createMenuFrame(frameBackColor);
    -- 游戏界面
    _G.gameFrame = createGameFrame(frameBackColor);
    -- 当前界面
    _G.currFrame = _G.menuFrame;

    -- 用于防止按钮一直按下时事件一直更新
    _G.isKeyBoardActive = false;
end

function love.update(dt)
    if _G.gameFrame.world ~= nil then
        _G.gameFrame.world:update(dt)
        
        if love.keyboard.isDown("right") then
            if not _G.isKeyBoardActive then
                local currIndex = _G.gameFrame.worldReadyBlockIndex;
                _G.gameFrame.worldReadyBlockIndex = math.min(currIndex + 1, _G.gameFrame.worldXNum);
            end
            _G.isKeyBoardActive = true;
        elseif love.keyboard.isDown("left") then
            if not _G.isKeyBoardActive then
                local currIndex = _G.gameFrame.worldReadyBlockIndex;
                _G.gameFrame.worldReadyBlockIndex = math.max(currIndex - 1, 1);
            end
            _G.isKeyBoardActive = true;
        elseif love.keyboard.isDown("space") then
            if not _G.isKeyBoardActive then
                _G.gameFrame:generateBlock(_G.gameFrame.worldReadyBlockIndex);
            end
            _G.isKeyBoardActive = true;
        else
            _G.isKeyBoardActive = false;
        end
    end
    
end

function love.mousemoved(x, y)
    currFrame:handleMouseMove(x, y);
end

function love.mousepressed(x, y)
    local pressedButton = currFrame:handleButtonPress(x, y);
    if pressedButton then
        pressedButton:handleButtonPress();
    else
        currFrame:handleMouseClick(x, y);
    end
end

function love.draw()
    currFrame:draw(objects);
    
    local currFont = love.graphics.newFont("tools/m6x11plus.ttf", 30);
    love.graphics.setFont(currFont);
    love.graphics.setColor(HexColor("#000000"));
    love.graphics.print("FPS: "..tostring(love.timer.getFPS()), 10, 10);
    
end

