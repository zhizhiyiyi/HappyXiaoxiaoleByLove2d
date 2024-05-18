
Array = {};
Array.__index = Array;

function Array:new()
    local ret = {};
    setmetatable(ret, self);
    return ret;
end

function Array:pushBack(elem)
    table.insert(self, elem);
end