--[[
    Bird Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Bird is what we control in the game via clicking or the space bar; whenever we press either,
    the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
    the ground or a pipe, the game is over.
]]

Bird = Class{}

local GRAVITY = 3

function Bird:init()
    -- load bird image from disk and assign its width and height
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    -- position bird in the middle of the screen
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- Y velocity; gravity
    self.dy = 0
end

function Bird:reset()
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)
    self.dy = 0
end

function Bird:collides(pipe)
    if self.x <= ((pipe.x + 2) + (PIPE_WIDTH - 4)) and self.x >= (pipe.x + 2) then
        if self.y <= ((pipe.y + 2) + (PIPE_HEIGHT - 4)) and self.y >= (pipe.y + 2) then
            return true
        elseif (self.y + self.height) <= ((pipe.y + 2) + (PIPE_HEIGHT - 4)) and (self.y + self.height) >= (pipe.y + 2) then
            return true
        end
    elseif (self.x + self.width) <= ((pipe.x + 2) + (PIPE_WIDTH - 4)) and (self.x + self.width) >= (pipe.x + 2) then
        if self.y <= ((pipe.y + 2) + (PIPE_HEIGHT - 4)) and self.y >= (pipe.y + 2) then
            return true
        elseif (self.y + self.height) <= ((pipe.y + 2) + (PIPE_HEIGHT - 4)) and (self.y + self.height) >= (pipe.y + 2) then
            return true
        end
    end
    return false
end

function Bird:update(dt)
    -- apply gravity to velocity
    self.dy = self.dy + GRAVITY * dt

    -- add a sudden burst of negative gravity if we hit space
    if love.keyboard.wasPressed(' ') then
        self.dy = -0.5
    end

    -- apply current velocity to Y position
    self.y = (self.y + self.dy) >= 0 and (self.y + self.dy) or 0  
    self.y = (self.y + self.dy) <= (VIRTUAL_HEIGHT - self.height - 15) and (self.y + self.dy) or (VIRTUAL_HEIGHT - self.height - 15)  
end

function Bird:render()
    love.graphics.draw(self.image, self.x, self.y)
end