local love = require "love"

function SFX()
    local bgm = love.audio.newSource("src/sounds/bgm.mp3", "stream")
    bgm:setVolume(1)
    bgm:setLooping(true) 

    local effects = {
        ship_explosion = love.audio.newSource("src/sounds/explosion_player.ogg", "static"),
        asteroid_explosion = love.audio.newSource("src/sounds/explosion_asteroid.ogg", "static"),
        laser = love.audio.newSource("src/sounds/laser.ogg", "static"),
        select = love.audio.newSource("src/sounds/option_select.ogg", "static"),
        thruster = love.audio.newSource("src/sounds/thruster_loud.ogg", "static"),
    }

    for _, effect in pairs(effects) do
        effect:setVolume(1)
    end

    return {
        sfx_played = false,

        setSFXPlayed = function(self, isPlayed)
            self.sfx_played = isPlayed
        end,

        playBGM = function(self)
            if not bgm:isPlaying() then
                bgm:play()
            end
        end,

        pausedBGM = function (self)
            if bgm:isPlaying() then
                bgm:pause()
            end
        end,

        stopPlayBGM = function (self)
            if bgm:isPlaying() then
                bgm:stop()
            end
        end,

        stopSFX = function(self, effect)
            if effects[effect]:isPlaying() then
                effects[effect]:stop()
            end
        end,

        playSFX = function(self, effect, mode)
            if mode == "single" then
                if not self.sfx_played then
                    self:setSFXPlayed(true)

                    if not effects[effect]:isPlaying() then
                        effects[effect]:play()
                    end
                end
            elseif mode == "slow" then
                if not effects[effect]:isPlaying() then
                    effects[effect]:play()
                end
            else
                self:stopSFX(effect)

                effects[effect]:play()
            end
        end,

        getBGMVolume = function (self)
            return bgm:getVolume()
        end,

        getEffectVolume = function (self)
            return effects["select"]:getVolume()
        end,

        setBGMVolume = function (self, value)
            bgm:setVolume(value)
        end,

        setEffectVolume = function (self, value)
            effects.select:setVolume(value)
            for _, effect in pairs(effects) do
                effect:setVolume(value)
            end
        end
    }
end

return SFX
