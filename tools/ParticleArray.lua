require("tools/Array");

ParticleArray = Array:new();

function ParticleArray:new()
    local ret = {};
    setmetatable(ret, self);
    self.__index = self;
    return ret;
end

function ParticleArray:generateParticle(x, y, particleSize, particleColor, particleSum, particleGravity)
    local imageData = love.image.newImageData(particleSize, particleSize);
    imageData:mapPixel(
        function(...)
            return particleColor[1], particleColor[2], particleColor[3], 1;
        end
    );
    local image = love.graphics.newImage(imageData);

    local particleSystem = love.graphics.newParticleSystem(image, particleSum);
    particleSystem:setParticleLifetime(0.5, 2);
    particleSystem:setLinearAcceleration(0, particleGravity, 0, particleGravity);
    particleSystem:setSpread(2 * math.pi);
    particleSystem:setSpeed(100, 500);
    local result = {
        particleSystem = particleSystem,
        color = particleColor,
        x = x,
        y = y,
        hasEmitted = false,
    };
    return result;
end

function ParticleArray:emitParticle()
    for i = 1, #self do
        local currParticleSystem = self[i];
        if not currParticleSystem.hasEmitted then
            currParticleSystem.particleSystem:emit(100);
            currParticleSystem.hasEmitted = true;
        end
    end
end

-- 删除发射过的粒子效果
function ParticleArray:deleteUsedParticle()
    local i = 1;
    while i <= #self do
        local currParticleSystem = self[i];
        if currParticleSystem.hasEmitted and currParticleSystem.particleSystem:getCount() == 0 then  
            self[i].particleSystem:release();
            self:erase(i);
        else
            i = i + 1;
        end
    end
end

function ParticleArray:updateParticle(dt)
    self:deleteUsedParticle();
    for i = 1, #self do
        local currParticleSystem = self[i];
        currParticleSystem.particleSystem:update(dt);
    end
end

function ParticleArray:drawParticle()
    for i = 1, #self do
        local currParticleSystem = self[i];
        love.graphics.setColor(currParticleSystem.color);
        love.graphics.draw(currParticleSystem.particleSystem, currParticleSystem.x, currParticleSystem.y);
    end
end
