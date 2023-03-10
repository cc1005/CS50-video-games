--[[
    Heavily inspired by CS50gamedev course on edx
]]

push = require "push"
Class = require "class"

require "Paddle"
require "Ball"

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 180

function love.load()
    
    love.window.setTitle("ConPong")
    love.graphics.setDefaultFilter("nearest", "nearest")

    math.randomseed(os.time())

    microFont = love.graphics.newFont("font.ttf", 8)
    smallFont = love.graphics.newFont("font.ttf", 8)
    scoreFont = love.graphics.newFont("font.ttf", 24)
    
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = false,
        vsync = true
    })

    player1Score = 0
    player2Score = 0

    servingPlayer = 1

    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT / 2 - 30, 5, 20)

    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    gameState = "start"
end

function love.update(dt)
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('s') then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    if love.keyboard.isDown('up') then
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown('down') then
        player2.dy = PADDLE_SPEED
    else
        player2.dy = 0
    end

    
    if gameState == 'serve' then
        -- before switching to play, initialize ball's velocity based
        -- on player who last scored
        ball.dy = math.random(-50, 50)
        if servingPlayer == 1 then
            ball.dx = math.random(100, 120)
        else
            ball.dx = -math.random(100, 120)
        end
    elseif gameState == "play" then
        ball:update(dt)

        if ball:collides(player1) then
            ball.dx = -ball.dx * 1.2
            ball.x = player1.x + 5
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end
        
        if ball:collides(player2) then
            ball.dx = -ball.dx * 1.2
            ball.x = player2.x - 4
            if ball.dy < 0 then
                ball.dy = -math.random(10, 150)
            else
                ball.dy = math.random(10, 150)
            end
        end

        if ball.x < 0 then
            servingPlayer = 1
            player2Score = player2Score + 1
            if player2Score == 2 then
                winningPlayer = 2
                ball:reset()
                gameState = "done"
            else
                ball:reset()
                gameState = "serve"
            end
        end
    
        if ball.x > VIRTUAL_WIDTH then
            servingPlayer = 2
            player1Score = player1Score + 1
            if player1Score == 2 then
                winningPlayer = 1
                ball:reset()
                gameState = "done"
            else
                ball:reset()
                gameState = "serve"
            end
        end
    end

    player1:update(dt)
    player2:update(dt)
end  

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    elseif key == "enter" or key == "return" then
        if gameState == "start" then
            gameState = "play"
            -- All the below needs sorted out, serving is currently not working.
        elseif gameState == "serve" then
            gameState = "play"
        elseif gameState == "done" then
            gameState = "start"
            player1Score = 0
            player2Score = 0
        else
            gameState = "start"
            ball:reset()
        end 
    end
end

function love.draw()
    push:apply("start")

    love.graphics.clear(40/255, 45/255, 104/255, 255/255)
    love.graphics.setFont(smallFont)
    
    if gameState == 'start' then
        love.graphics.printf('Welcome to ConPong!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == "serve" then
        love.graphics.printf("Player " .. servingPlayer .. "'s serve", 0, 20, VIRTUAL_WIDTH, "center")
    elseif gameState == "done" then
        love.graphics.printf("Player " .. winningPlayer .. "'s skill has served them well! \n\n Player " .. winningPlayer .. "wins!", 0, 20, VIRTUAL_WIDTH, "center")
    else
        love.graphics.printf('CONPONG!', 0, 20, VIRTUAL_WIDTH, 'center')
    end
    
    love.graphics.print("Player 1: " .. tostring(player1Score), 10, VIRTUAL_HEIGHT - 10)
    love.graphics.print("Player 2: " .. tostring(player2Score), VIRTUAL_WIDTH - 100, VIRTUAL_HEIGHT - 10)

    player1:render()
    player2:render()
    ball:render()

    displayFPS()
    push:apply("end")
    
end 

function displayFPS()
    love.graphics.setFont(microFont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print(tostring(love.timer.getFPS()), 4, 4)
end
