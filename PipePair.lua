PipePair = Class{}

local GAP_HEIGHT = 110

function PipePair:init(y)
    self.y = y
    self.pipes = {
        ['upper'] = Pipe('top', y - PIPE_HEIGHT),
        ['lower'] = Pipe('bottom', y + math.max(GAP_HEIGHT,math.min(150,math.random(40))))
    }
    self.remove = false
end

function PipePair:update(dt)
    self.pipes.upper:update(dt)
    self.pipes.lower:update(dt)
    if self.pipes.upper.x < -PIPE_WIDTH then
        table.remove(self.pipes,upper)
        table.remove(self.pipes,lower)
        self.remove = true
    end
end

function PipePair:clear()
    table.remove(self.pipes,upper)
    table.remove(self.pipes,lower)
end

function PipePair:render()
    self.pipes.upper:render()
    self.pipes.lower:render()    
end