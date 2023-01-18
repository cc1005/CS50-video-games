Bird = Class{}

local GRAVITY = 10
local jumpValue = 0

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - (self.width/ 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    self.dy = 0
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end

 
function Bird:jump()
    jumpValue = 70
end

function Bird:update(dt)
    self.dy = self.dy + (GRAVITY - jumpValue) * dt 
    if jumpValue < 0 then
        jumpValue = 0
    elseif jumpValue > 0 then
        jumpValue = jumpValue - 10
    end 
    self.y = self.y + self.dy
end