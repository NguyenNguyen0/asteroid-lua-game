local love = require "love"

local Button = require "components.Button"
local Setting = require "states.Setting"

function Menu(game, player, sfx)
    local funcs = {
        newGame = function()
            game:startNewGame(player)
        end,

        quitGame = function()
            love.event.quit()
        end,

        settingGame = function()
            game:changeGameState("setting")
        end
    }

    local buttons = {
        Button(
            funcs.newGame,
            nil,
            nil,
            love.graphics.getWidth() / 3,
            50,
            "New Game",
            "center",
            "h3",
            love.graphics.getWidth() / 3,
            love.graphics.getHeight() * 0.4),
        Button(
            funcs.settingGame,
            nil,
            nil,
            love.graphics.getWidth() / 3,
            50,
            "Settings",
            "center",
            "h3",
            love.graphics.getWidth() / 3,
            love.graphics.getHeight() * 0.5),
        Button(
            funcs.quitGame,
            nil,
            nil,
            love.graphics.getWidth() / 3,
            50,
            "Quit",
            "center",
            "h3",
            love.graphics.getWidth() / 3,
            love.graphics.getHeight() * 0.6)
    }

    return {
        setting = Setting(nil, player, sfx),
        focused = "",

        run = function(self, clicked)
            local mouse_x, mouse_y = love.mouse.getPosition()

            for name, button in pairs(buttons) do
                if button:checkHover(mouse_x, mouse_y, 10) then
                    sfx:playSFX("select", "single")

                    if clicked then
                        button:click()
                    end

                    self.focused = name

                    button:setTextColor(0.8, 0.2, 0.2)
                else
                    if self.focused == name then
                        sfx:setSFXPlayed(false)
                    end
                    button:setTextColor(1, 1, 1)
                end
            end
        end,

        draw = function(self)
            Text(
                "ASTEROID GAME",
                0,
                love.graphics.getHeight() * 0.2,
                "h1",
                false,
                false,
                love.graphics.getWidth(),
                "center",
                1
            ):draw()

            for _, button in pairs(buttons) do
                button:draw()
            end
        end
    }
end

return Menu
