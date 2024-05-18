
Array = {};

function Array:new()
    local ret = {};
    setmetatable(ret, self);
    self.__index = self;
    return ret;
end

function Array:pushBack(elem)
    table.insert(self, elem);
end