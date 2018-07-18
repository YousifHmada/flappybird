--[[
    GD50
    Flappy Bird Remake

    bird5
    "The Infinite Pipe Update"

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple 
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping 
    the screen, making the player's bird avatar flap its wings and move upwards slightly. 
    A variant of popular games like "Helicopter Game" that floated around the internet
    for years prior. Illustrates some of the most basic procedural generation of game
    levels possible as by having pipes stick out of the ground by varying amounts, acting
    as an infinitely generated obstacle course for the player.
]]


-- virtual resolution handling library
push = require 'push'

-- classic OOP class library
Class = require 'class'

-- bird class we've written
require 'Bird'

-- pipe class we've written
require 'Pipe'

-- pipePair class we've writtem
require 'PipePair'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- background image and starting scroll location (X axis)
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

-- ground image and starting scroll location (X axis)
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

-- speed at which we should scroll our images, scaled by dt
local BACKGROUND_SCROLL_SPEED = 90
local GROUND_SCROLL_SPEED = 120

-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 413

-- our bird sprite
local bird = Bird()

-- our table of spawning Pipes
local pipePairs = {}

local lastY = math.random(80) + 20

-- our timer for spawning pipes
local spawnTimer = 0

local scrolling = true

function reset()
    spawnTimer = 0
    lastY = math.random(80) + 20
    groundScroll = 0
    backgroundScroll = 0
    scrolling = true
    bird:reset()
    for k, pipePair in pairs(pipePairs) do
        pipePair:clear()
        table.remove(pipePairs, k)
    end
    pipePairs = {}
    love.keyboard.keysPressed = {}
end

function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')
    
    -- app window title
    love.window.setTitle('Fifty Bird')
    
    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
    
    -- initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
    
    if key == 'escape' then
        love.event.quit()
    elseif (key == 'return') and scrolling == false then
        reset()
    end
end

--[[
    New function used to check our global input table for keys we activated during
    this frame, looked up by their string value.
]]
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else
        return false
    end
end

function love.update(dt)
    if scrolling then
            -- scroll background by preset speed * dt, looping back to 0 after the looping point
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT

        -- scroll ground by preset speed * dt, looping back to 0 after the screen width passes
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt) 
            % VIRTUAL_WIDTH

        spawnTimer = spawnTimer + dt

        -- spawn a new Pipe if the timer is past 2 seconds
        if spawnTimer > 2 then
            local y = math.max(
                10, 
                math.min(
                    lastY + math.random(-30, 30), 
                    VIRTUAL_HEIGHT - 90
                )
            )
            lastY = y
            table.insert(pipePairs, PipePair(y))
            spawnTimer = 0
        end

        -- update the bird for input and gravity
        bird:update(dt)

        -- for every pipe in the scene...
        for k, pipePair in pairs(pipePairs) do
            pipePair:update(dt)

            for n, pipe in pairs(pipePair.pipes) do
                if bird:collides(pipe) then
                    scrolling = false
                end
            end

            -- if pipePair is no longer visible past left edge, remove it from scene
            if pipePair.remove then
                table.remove(pipePairs, k)
            end
        end

    end

    -- reset input table
    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()

    -- draw the background at the negative looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    -- render all the pipes in our scene
    for k, pipePair in pairs(pipePairs) do
        pipePair:render()
    end

    -- draw the ground on top of the background, toward the bottom of the screen,
    -- at its negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    -- render our bird to the screen using its own render logic
    bird:render()
    
    push:finish()
end