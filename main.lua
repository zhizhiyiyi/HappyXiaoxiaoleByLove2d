
require("tools/HexColor");
require("tools/Button");
require("tools/ButtonArray")

frameBackColor = HexColor("#FFFFFF");
buttonBackColor = HexColor("#C0C0C0");
buttonOutlineColor = HexColor("#000000");
buttonActiveColor = HexColor("#2fc1c5");
buttonStrColor = HexColor("#000000");

function love.load()
    love.graphics.setBackgroundColor(frameBackColor);
    local windowWidth, windowHeight = love.graphics.getDimensions();
    local buttonWidth = 200;
    local buttonHeight = 50;
    local newGameButton = Button:new(windowWidth / 2 - buttonWidth / 2, windowHeight / 3, buttonWidth, buttonHeight, 
        "New Game", buttonBackColor, buttonOutlineColor, buttonActiveColor, buttonStrColor);
    local exitButton = Button:new(windowWidth / 2 - buttonWidth / 2, windowHeight / 3 + buttonHeight + 30, buttonWidth, buttonHeight, 
        "Exit", buttonBackColor, buttonOutlineColor, buttonActiveColor, buttonStrColor);
    buttonArray = ButtonArray:new();
    buttonArray:addButton(newGameButton);
    buttonArray:addButton(exitButton);
end

function love.update(dt)

end

function love.mousemoved(x, y)
    buttonArray:updateActiveState(x, y);
end

function love.draw()
    buttonArray:draw();
end