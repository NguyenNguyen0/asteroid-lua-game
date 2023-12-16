local love = require "love"
local Label = require "components.Label"
local Global = require "globals"

function Setting(self, player, sfx)
    local funcs = {
        home = function()
            game:changeGameState("menu")
        end,

        resetHightScore = function ()
            Global.writeJSON("save", { high_score = 0 } )
            Global.high_score = 0
            -- game.score = 0
            game.high_score = 0
        end,

        -- sound funcs
        soundVolumeUp = function()
            local volume = Global.sfx:getEffectVolume()
            if volume < 1 and volume >= 0 then
                Global.sfx:setEffectVolume(volume + 0.05)
            elseif volume < 0 then
                Global.sfx:setEffectVolume(0)
            elseif volume > 1 then
                Global.sfx:setEffectVolume(1)
            end
        end,

        soundVolumeDown = function()
            local volume = Global.sfx:getEffectVolume()
            if volume <= 1 and volume > 0 then
                Global.sfx:setEffectVolume(volume - 0.05)
            elseif volume < 0 then
                Global.sfx:setEffectVolume(0)
            elseif volume > 1 then
                Global.sfx:setEffectVolume(1)
            end
        end,

        -- music funcs
        musicVolumeUp = function()
            local volume = Global.sfx:getBGMVolume()
            if volume < 1 and volume >= 0 then
                Global.sfx:setBGMVolume(volume + 0.05)
            elseif volume < 0 then
                Global.sfx:setBGMVolume(0)
            elseif volume > 1 then
                Global.sfx:setBGMVolume(1)
            end
        end,

        musicVolumeDown = function()
            local volume = Global.sfx:getBGMVolume()
            if volume <= 1 and volume > 0 then
                Global.sfx:setBGMVolume(volume - 0.05)
            elseif volume < 0 then
                Global.sfx:setBGMVolume(0)
            elseif volume > 1 then
                Global.sfx:setBGMVolume(1)
            end
        end,
    }

    local sound_label_properties = {
        width = love.graphics.getWidth() / 4,
        height = 50,
        x = love.graphics.getWidth() / 3,
        y = love.graphics.getHeight() * 0.5,
    }

    local sound_btns_properties = {
        down_btn_x = sound_label_properties.x + sound_label_properties.width + 3,
        down_btn_y = sound_label_properties.y,
        up_btn_x = sound_label_properties.x + sound_label_properties.width + 55,
        up_btn_y = sound_label_properties.y,
    }

    local music_label_properties = {
        width = love.graphics.getWidth() / 4,
        height = 50,
        x = love.graphics.getWidth() / 3,
        y = love.graphics.getHeight() * 0.6,
    }

    local music_btns_properties = {
        down_btn_x = music_label_properties.x + music_label_properties.width + 3,
        down_btn_y = music_label_properties.y,
        up_btn_x = music_label_properties.x + music_label_properties.width + 55,
        up_btn_y = music_label_properties.y,
    }

    local setting_options = {
        Button(
            funcs.resetHightScore,
            nil,
            nil,
            100,
            50,
            "reset",
            "center",
            "h4",
            music_label_properties.x + music_label_properties.width + 3,
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
            love.graphics.getHeight() * 0.7
        ),

        -- Sounds up/down button
        sound_down_btn = Button(
            funcs.soundVolumeDown,
            nil,
            nil,
            50,
            50,
            "<",
            "center",
            "h3",
            sound_btns_properties.down_btn_x,
            sound_btns_properties.down_btn_y
        ),
        sound_up_btn = Button(
            funcs.soundVolumeUp,
            nil,
            nil,
            50,
            50,
            ">",
            "center",
            "h3",
            sound_btns_properties.up_btn_x,
            sound_btns_properties.up_btn_y
        ),
        -- Music up/down button
        music_down_btn = Button(
            funcs.musicVolumeDown,
            nil,
            nil,
            50,
            50,
            "<",
            "center",
            "h3",
            music_btns_properties.down_btn_x,
            music_btns_properties.down_btn_y
        ),
        music_up_btn = Button(
            funcs.musicVolumeUp,
            nil,
            nil,
            50,
            50,
            ">",
            "center",
            "h3",
            music_btns_properties.up_btn_x,
            music_btns_properties.up_btn_y
        ),
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

            Label(
                nil,
                nil,
                sound_label_properties.width,
                sound_label_properties.height,
                "Hight score: "..(Global.high_score),
                "center",
                "h4",
                sound_label_properties.x,
                love.graphics.getHeight() * 0.4
            ):draw()

            Label(
                nil,
                nil,
                sound_label_properties.width,
                sound_label_properties.height,
                "Sounds: " .. math.ceil(Global.sfx:getEffectVolume() * 100),
                "center",
                "h4",
                sound_label_properties.x,
                sound_label_properties.y
            ):draw()

            Label(
                nil,
                nil,
                music_label_properties.width,
                music_label_properties.height,
                "Music: " .. math.ceil(Global.sfx:getBGMVolume() * 100),
                "center",
                "h4",
                music_label_properties.x,
                music_label_properties.y
            ):draw()
            for _, option in pairs(setting_options) do
                option:draw()
            end
        end,

        run = function(self, clicked)
            local mouse_x, mouse_y = love.mouse.getPosition()

            for name, option in pairs(setting_options) do
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

return Setting
