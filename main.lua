
require("tools/HexColor");

frameBackColor = HexColor("#FFFFFF");
buttonBackColor = HexColor("#C0C0C0");
buttonOutlineColor = HexColor("#000000");
buttonActiveColor = HexColor("#2fc1c5");

function love.load()
    love.graphics.setBackgroundColor(frameBackColor);
end

function love.update(dt)

end

function love.draw()
    love.graphics.print("Hello World", 100, 100);
end