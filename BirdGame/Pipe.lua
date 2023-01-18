Pipe = Class{}

local PIPE_IMAGE = love.graphics.newImage('Assets/pipe.png')

local PIPE_SCROLL = -40

function Pipe:init()
    self.x = VIRTUAL_WIDTH + 20
    self.y = math.random(VIRTUAL_HEIGHT /4, VIRTUAL_HEIGHT - 10)
    self.width = PIPE_IMAGE:getWidth()
end

function Pipe:update(dt)
    self.x = self.x + PIPE_SCROLL * dt
end

function Pipe:render()
    love.graphics.draw(PIPE_IMAGE, self.x, self.y)
end