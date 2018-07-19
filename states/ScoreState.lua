ScoreState = Class {__includes = BaseState}

function ScoreState:enter(enterOptions)
    self.score = enterOptions.score
end


function ScoreState:update()
    if love.keyboard.keysPressed['return'] or love.keyboard.keysPressed[' '] then
        stateMachine:change('count')
    end
end

function ScoreState:render()
    -- simply render the score to the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Oof! You lost!', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Score: ' .. tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')

    love.graphics.printf('Press Enter to Play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end

