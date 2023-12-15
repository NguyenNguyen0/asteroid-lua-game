local love = require "love"

function Label(text_color, label_color, width, height, text, text_align, font_size, label_x, label_y, text_x, text_y)
    local btn_text = {}

    if text_y then
        btn_text.y = text_y + label_y
    else
        btn_text.y = label_y
    end

    if text_x then
        btn_text.x = text_x + label_x
    else
        btn_text.x = label_x
    end

    return {
        text_color = text_color or { r = 1, g = 1, b = 1 },
        label_color = label_color or { r = 0, g = 0, b = 0 },
        width = width or 100,
        height = height or 100,
        text = text or "No text added",
        text_x = text_x or label_x or 0,
        text_y = text_y or label_y or 0,
        label_x = label_x or 0,
        label_y = label_y or 0,
        text_component = Text(
            text,
            btn_text.x,
            btn_text.y,
            font_size,
            false,
            false,
            width,
            text_align,
            1
        ),

        setLabelColor = function(self, red, green, blue)
            self.label_color = { r = red, g = green, b = blue }
        end,

        setTextColor = function(self, red, green, blue)
            self.text_color = { r = red, g = green, b = blue }
        end,

        checkHover = function(self, mouse_x, mouse_y, cursor_radius)
            if (mouse_x + cursor_radius >= self.label_x) and (mouse_x - cursor_radius <= self.label_x + self.width) then
                if (mouse_y + cursor_radius >= self.label_y) and (mouse_y - cursor_radius <= self.label_y + self.height) then
                    return true
                end
            end

            return false
        end,

        draw = function(self)
            love.graphics.setColor(self.label_color.r, self.label_color.g, self.label_color.b)
            love.graphics.rectangle("fill", self.label_x, self.label_y, self.width, self.height)

            self.text_component:setColor(self.text_color.r, self.text_color.g, self.text_color.b)
            self.text_component:draw()

            love.graphics.setColor(1, 1, 1)
        end,

        getPos = function(self)
            return self.label_x, self.label_y
        end,

        getTextPos = function(self)
            return self.text_x, self.text_y
        end,
    }
end

return Label