local lunajson = require "lunajson"
local SFX = require "components.SFX"

Global = {
    ASTEROID_SIZE = 100,
    show_debugging = false,
    destroy_asteroid = false,
    sfx = SFX(),
    is_playing_bgm = false,
    high_score = 0,
    perviousState = "menu",

    calculateDistance = function(x1, y1, x2, y2)
        return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2))
    end,

    readJSON = function(file_name)
        local file = io.open("src/data/" .. file_name .. ".json", "r")
        if file then
            local data = file:read("*all")
            file:close()
            return lunajson.decode(data)
        else
            return { high_score = 0 } -- default hight score
        end
    end,

    writeJSON = function(file_name, data)
        local file = io.open("src/data/" .. file_name .. ".json", "w")
        print(data)
        if file then
            file:write(lunajson.encode(data))
            file:close()
        end
    end
}

Global.high_score = Global.readJSON("save").high_score

return Global
