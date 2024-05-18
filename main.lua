
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

function love.load()
    love.graphics.setBackgroundColor(frameBackColor);

    -- 初始菜单界面
    menuFrame = createMenuFrame(frameBackColor);
    -- 游戏界面
    gameFrame = createGameFrame(frameBackColor);
    -- 当前界面
    currFrame = menuFrame;

    
end

function love.update(dt)

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
    currFrame:draw();
end