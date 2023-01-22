PlayState = Class{_includes = BaseState}

PIPE_SPEED = 80
PIPE_WIDTH = 100
PIPE_HEIGHT = 288

BIRD_WIDTH = 38
BIRD_HEIGHT = 24

function PlayState:init()
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0

    self.lastY = -PIPE_HEIGHT + math.random(80) + 20
end

function PlayState:update(dt)
        
    spawnTimer = spawnTimer + dt

    if spawnTimer > 2 then
        --[[ This allows for the last Y coordinate to be modified
        to ensure the pipe gaps aren't too far apart. --  ]]
        
        local y = math.max(-PIPE_HEIGHT + 10,
            math.min(lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        lastY = y

        table.insert(pipePairs, PipePair(y))
        spawnTimer = 0
    end

    bird:update(dt)

    for k, pair in pairs(pipePairs) do
        pair:update(dt)

        for l, pipe in pairs(pair.pipes) do
            if bird:collides(pipe) then
                scrolling = false
            end
        end

        for k, pair in pairs(pipePairs) do
            if pair.remove then
                table.remove(pipePairs, k)
            end
        end
    end
end