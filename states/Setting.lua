local love = require "love"

function Setting(self, player, sfx)
    local funcs = {
        home = function ()
            game:changeGameState("menu")
        end
    }

    local setting_options = { 
        Button(
            funcs.home,
            nil,
            nil,
            love.graphics.getWidth() / 3,
            50,
            "Home",
            "center",
            "h3",
            love.graphics.getWidth() / 3,
            love.graphics.getHeight() * 0.4),
    }

    return {
        focused = "",

        draw = function(self)
            Text(
                "SETTING MENU",
                0,
                love.graphics.getHeight() * 0.2,
                "h2",
                false,
                false,
                love.graphics.getWidth(),
                "center",
                1
            ):draw()

            for key, option in pairs(setting_options) do
                option:draw()
            end
        end,

        run = function(self, clicked)
            local mouse_x, mouse_y = love.mouse.getPosition()

            for name, option in pairs(setting_options) do
                if option:checkHover(mouse_x, mouse_y, 10) then
                    sfx:playFX("select", "single")

                    if clicked then
                        option:click()
                    end

                    self.focused = name

                    option:setTextColor(0.8, 0.2, 0.2)
                else
                    if self.focused == name then
                        sfx:setFXPlayed(false)
                    end
                    option:setTextColor(1, 1, 1)
                end
            end
        end
    }
end

return Setting
