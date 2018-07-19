TitleScreenState = Class {__includes = BaseState}

function TitleScreenState:update()
    if love.keyboard.keysPressed['return'] or love.keyboard.keysPressed[' '] then
        stateMachine:change('count')
    end
end

function TitleScreenState:render()
    love.graphics.setFont(flappyFont)
    love.graphics.printf('Fifty Bird', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(mediumFont)
    love.graphics.printf('Press Enter', 0, 100, VIRTUAL_WIDTH, 'center')
end