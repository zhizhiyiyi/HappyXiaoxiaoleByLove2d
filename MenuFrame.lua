require("tools/Frame");

MenuFrame = Frame:new();

function MenuFrame:new(name, backColor, buttonArray, isEnable)
    local ret = {};
    setmetatable(ret, self);
    self.__index = self;
    ret:init(name, backColor, buttonArray, isEnable);
    return ret;
end