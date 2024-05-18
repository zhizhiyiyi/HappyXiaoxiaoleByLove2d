
require("tools/HexColor");
require("tools/Button");
require("tools/ButtonArray");
require("tools/Frame");
require("MenuFrame");

frameBackColor = HexColor("#FFFFFF");
buttonBackColor = HexColor("#C0C0C0");
buttonOutlineColor = HexColor("#000000");
buttonActiveColor = HexColor("#2fc1c5");
buttonStrColor = HexColor("#000000");

menuFrameExitButtonPress = function (x, y)
    love.event.quit();
end

function love.load()
    love.graphics.setBackgroundColor(frameBackColor);
    local windowWidth, windowHeight = love.graphics.getDimensions();

    -- 初始菜单界面
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

    menuFrame = MenuFrame:new("menu", menuFrameButtonArray, true);

    -- 当前界面
    currFrame = menuFrame;

    
end

function love.update(dt)

end

function love.mousemoved(x, y)
    currFrame:handleMouseMove(x, y);
end

function love.mousepressed(x, y)
    currFrame:handleMousePress(x, y);
end

function love.draw()
    currFrame:draw();
end