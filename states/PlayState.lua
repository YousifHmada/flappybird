PlayState = Class {__includes = BaseState}

function PlayState:init()
    self.spawnTimer = 0
    self.lastY = math.random(80) + 20
    self.pipePairs = {}
    self.bird = Bird()
    self.score = 0
end

function PlayState:update(dt)
    self.spawnTimer = self.spawnTimer + dt

    -- spawn a new Pipe if the timer is past 2 seconds
    if self.spawnTimer > 2 then
        local y = math.max(
            10, 
            math.min(
                self.lastY + math.random(-30, 30), 
                VIRTUAL_HEIGHT - 90
            )
        )
        self.lastY = y
        table.insert(self.pipePairs, PipePair(y))
        self.spawnTimer = 0
    end

    -- update the self.bird for input and gravity
    self.bird:update(dt)

    -- for every pipe in the scene...
    for k, pipePair in pairs(self.pipePairs) do
        pipePair:update(dt)

        for n, pipe in pairs(pipePair.pipes) do
            if self.bird:collides(pipe) then
                sounds['explosion']:play()
                sounds['hurt']:play()
                stateMachine:change('score', {
                    ['score'] = self.score
                })
            end
        end

        if not pipePair.scored and self.bird.x >= (pipePair.pipes['upper'].x + PIPE_WIDTH) then
            self.score = self.score + 1
            sounds['score']:play()
            pipePair.scored = true
        end

        -- if pipePair is no longer visible past left edge, remove it from scene
        if pipePair.remove then
            table.remove(self.pipePairs, k)
        end
    end


    -- reset if we get to the ground
    if self.bird.y > VIRTUAL_HEIGHT - 15 then
        sounds['explosion']:play()
        sounds['hurt']:play()
        stateMachine:change('score', {
            score = self.score
        })
    end

end

function PlayState:render()
    -- render all the pipes in our scene
    for k, pipePair in pairs(self.pipePairs) do
        pipePair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)

    self.bird:render()
end