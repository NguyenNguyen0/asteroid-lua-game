local love = require "love"

function Pause(self)
    local funcs = {
        changeToSettingMenu = function ()
            game:changeGameState("setting")    
        end,

        home = function()
            game:changeGameState("menu")
        end,

        backToGame = function ()
            game:changeGameState("running")
        end
    }

    local pause_options = {
        Button(
            funcs.changeToSettingMenu,
            nil,
            nil,
            love.graphics.getWidth() / 3,
            50,
            "Settings",
            "center",
            "h4",
            love.graphics.getWidth() / 3,
            love.graphics.getHeight() * 0.4
        ),
        Button(
            funcs.home,
            nil,
            nil,
            love.graphics.getWidth() / 3,
            50,
            "Home",
            "center",
            "h4",
            love.graphics.getWidth() / 3,
            love.graphics.getHeight() * 0.5
        ),
        Button(
            funcs.backToGame,
            nil,
            nil,
            love.graphics.getWidth() / 3,
            50,
            "Back",
            "center",
            "h4",
            love.graphics.getWidth() / 3,
            love.graphics.getHeight() * 0.6
        )
    }

    return {
        focused = "",

        draw = function(self)
            Text(
                "PAUSED",
                0,
                love.graphics.getHeight() * 0.2,
                "h1",
                false,
                false,
                love.graphics.getWidth(),
                "center",
                1
            ):draw()

            for _, option in pairs(pause_options) do
                option:draw()
            end
        end,

        run = function(self, clicked)
            local mouse_x, mouse_y = love.mouse.getPosition()

            for name, option in pairs(pause_options) do
                if option:checkHover(mouse_x, mouse_y, 10) then
                    self.focused = name
                    sfx:playSFX("select", "single")

                    if clicked then
                        option:click()
                    end

                    option:setTextColor(0.8, 0.2, 0.2) -- red color
                else
                    if self.focused == name then
                        sfx:setSFXPlayed(false)
                    end
                    option:setTextColor(1, 1, 1)
                end
            end
        end
    }
end

return Pause
