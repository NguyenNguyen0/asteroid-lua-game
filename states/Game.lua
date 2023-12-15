--@diagnostic disable: lowercase-global
local love = require "love"

local Global = require "globals"
local Text = require "components.Text"
local Asteroids = require "objects.Asteroid"

function Game(save_data, sfx)
    return {
        level = 1,
        state = {
            menu = true,
            paused = false,
            running = false,
            ended = false,
            setting = false
        },
        score = 0,
        high_score = save_data["high_score"] or 0,
        screen_text = {},
        game_over = false,

        saveGame = function (self)
            Global.writeJSON("save", { high_score = self.high_score })
        end,

        changeGameState = function(self, state)
            self.state.menu = state == "menu"
            self.state.paused = state == "paused"
            self.state.running = state == "running"
            self.state.ended = state == "ended"
            self.state.setting = state == "setting"

            if self.state.ended then
                self:gameOver()
            end
        end,

        gameOver = function(self)
            self.screen_text = {
                Text(
                    "GAME OVER",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    true,
                    true,
                    love.graphics.getWidth(),
                    "center"
                )
            }

            self.game_over = true

            self:saveGame()
        end,

        draw = function(self, faded)
            local opacity = 1

            if faded then
                opacity = 0.5
            end

            for index, text in pairs(self.screen_text) do
                if self.game_over then
                    self.game_over = text:draw(self.screen_text, index)

                    if not self.game_over then
                        self:changeGameState("menu")
                    end
                else
                    text:draw(self.screen_text, index)
                end
            end

            Text(
                "SCORE: " .. self.score,
                -20,
                10,
                "h4",
                false,
                false,
                love.graphics.getWidth(),
                "right",
                faded and opacity or 0.6
            ):draw()

            Text(
                "HIGH SCORE: " .. self.high_score,
                -20,
                10,
                "h5",
                false,
                false,
                love.graphics.getWidth(),
                "center",
                faded and opacity or 0.5
            ):draw()

            if faded then
                Text(
                    "PAUSED",
                    0,
                    love.graphics.getHeight() * 0.4,
                    "h1",
                    false,
                    false,
                    love.graphics.getWidth(),
                    "center"
                ):draw()
            end
        end,

        startNewGame = function(self, player)
            if player.lives <= 0 then
                self:changeGameState("ended")
            else
                self:changeGameState("running")
            end

            local num_asteroids = 0

            asteroids = {}

            self.screen_text = {
                Text(
                    "Level " .. self.level,
                    0,
                    love.graphics.getHeight() * 0.25,
                    "h1",
                    true,
                    true,
                    love.graphics.getWidth(),
                    "center"
                )
            }

            -- SPAWN ASTEROIDS
            for i = 1, num_asteroids + self.level do
                local as_x, as_y

                repeat
                    as_x = math.floor(math.random(love.graphics.getWidth()))
                    as_y = math.floor(math.random(love.graphics.getHeight()))
                until Global.calculateDistance(player.x, player.y, as_x, as_y) > Global.ASTEROID_SIZE * 2 + player.radius

                table.insert(asteroids, Asteroids(as_x, as_y, Global.ASTEROID_SIZE, self.level, sfx))
            end
        end
    }
end

return Game
