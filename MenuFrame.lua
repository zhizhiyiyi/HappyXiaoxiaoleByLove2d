require("tools/Frame");

MenuFrame = Frame:new();

function MenuFrame:new(name, buttonArray, isEnable)
    local ret = {};
    setmetatable(ret, self);
    self.__index = self;
    ret:init(name, buttonArray, isEnable);
    return ret;
end