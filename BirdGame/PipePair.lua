PipePair = Clas{}

local GAP_HEIGHT = 120

function PipePaid:init(y)
    self.x = VIRTUAL_WIDTH + 32
    self.y = y 
    self.pipes = {
        ['upper'] = Pipe('top', self.y),
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    self.remove = false
end

function PipePair:update(dt)
    
end
