---@diagnostic disable: lowercase-global, inject-field

local love = require "love"

local Player = require "objects.Player"
local Game = require "states.Game"
local Menu = require "states.Menu"
local Global = require "globals"

math.randomseed(os.time())
local reset_complete = false

local function reset()
    local save_data = Global.high_score
    Global.destroy_asteroid = false

    sfx = Global.sfx
    player = Player(3, sfx)
    game = Game(save_data, sfx)
    menu = Menu(game, player, sfx)
end

function love.load()
    -- love.graphics.setBackgroundColor(0.7, 0.7, 0.7)
    love.mouse.setVisible(false)
    mouse_x, mouse_y = 0, 0

    reset()
end

-- KEYBINDING
function love.keypressed(key)
    if game.state.running then
        if key == "w" or key == "up" or key == "kp8" then
            player.thrusting = true
        end

        if key == "space" or key == "down" or key == "kp5" then
            player:shootLaser()
        end

        if key == "escape" then
            game:changeGameState("paused")
        end
    elseif game.state.paused then
        if key == "escape" then
            game:changeGameState("running")
        end
    end
end

function love.keyreleased(key)
    if key == "w" or key == "up" or key == "kp8" then
        player.thrusting = false
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if game.state.running then
            player:shootLaser()
        else
            clicked_mouse = true
        end
    end
end

-- END KEYBINDING

function love.update(dt)
    mouse_x, mouse_y = love.mouse.getPosition()

    -- BACKGROUND MUSIC HANDLE
    if game.state.running and not Global.is_playing_bgm then
        sfx:playBGM()
        Global.is_playing_bgm = true
    elseif game.state.running and Global.is_playing_bgm then
        sfx:playBGM()
    elseif game.state.paused then
        sfx:pausedBGM()
    elseif not game.state.running and not game.state.paused then
        sfx:stopPlayBGM()
        Global.is_playing_bgm = false
    end

    if game.state.running then
        player:movePlayer(dt)

        -- CHECK ASTEROIDS EXPLODING
        for ast_index, asteroid in pairs(asteroids) do
            if not player.exploding and not player.invincible then
                if Global.calculateDistance(player.x, player.y, asteroid.x, asteroid.y) < asteroid.radius + player.radius then
                    player:explode()
                    Global.destroy_asteroid = true
                end
            else
                player.explode_time = player.explode_time - 1

                if player.explode_time == 0 then
                    if player.lives - 1 <= 0 then
                        game:changeGameState("ended")
                        return
                    end

                    player = Player(player.lives - 1, sfx)
                end
            end

            -- CHECK LASERS DESTROY ASTEROIDS
            for _, laser in pairs(player.lasers) do
                if Global.calculateDistance(laser.x, laser.y, asteroid.x, asteroid.y) < asteroid.radius then
                    laser:explode()
                    asteroid:destroy(asteroids, ast_index, game)
                end
            end

            -- CHECK DESTROY ASTEROID
            if Global.destroy_asteroid then
                if player.lives - 1 <= 0 then
                    if player.explode_time == 0 then
                        Global.destroy_asteroid = false
                        asteroid:destroy(asteroids, ast_index, game)
                    end
                else
                    Global.destroy_asteroid = false
                    asteroid:destroy(asteroids, ast_index, game)
                end
            end

            asteroid:move(dt)
        end

        -- START NEW GAME IF PLAYER DESTROY ALL ASTEROID
        if #asteroids == 0 then
            game.level = game.level + 1
            game:startNewGame(player)
        end
    elseif game.state.menu then
        menu:run(clicked_mouse)
        clicked_mouse = false

        if not reset_complete then
            reset()
            reset_complete = true
        end
    elseif game.state.ended then
        reset_complete = false
    elseif game.state.setting then
        menu.setting:run(clicked_mouse)
        clicked_mouse = false
    end
end

function love.draw()
    if game.state.running or game.state.paused then
        player:drawLives(game.state.paused)
        player:draw(game.state.paused)

        for _, asteroid in pairs(asteroids) do
            asteroid:draw(game.state.paused)
        end

        game:draw(game.state.paused)
    elseif game.state.menu then
        menu:draw()
    elseif game.state.ended then
        game:draw()
    elseif game.state.setting then
        menu.setting:draw()
    end

    love.graphics.setColor(1, 1, 1, 1)

    if not game.state.running then
        love.graphics.circle("fill", mouse_x, mouse_y, 10)
    end

    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, love.graphics.getHeight() - 30)
end
