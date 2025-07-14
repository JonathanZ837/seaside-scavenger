function button(x, y, width, height, scale, type, func) 
    button = {}
    button.width = width
    button.height = height
    button.x = x
    button.y = y
    button.type = type
    button.func = func
    button.scale = scale
    button.checkPressed = function (self, mouse_x, mouse_y) 
        if (mouse_x >= self.x) and (mouse_x <= self.x + self.width) and (mouse_y >= self.y) and (mouse_y <= self.y + self.height) then
            if not (self.type == "buy") then
                sounds.click:play()
            end
            self.func()
        end
    end

    button.draw = function (self) 
        local img
        if self.type == "play" then
            img = button_play
        elseif self.type == "quit" then
            img = button_quit
        elseif self.type == "start" then
            img = button_ready
        elseif self.type == "collection" then
            img = button_journal
        elseif self.type == "nextlevel" then
            img = button_nextlevel
        elseif self.type == "shop" then
            img = button_shop
        elseif self.type == "menu" then
            img = button_menu
        elseif self.type == "buy" then
            img = button_buy
        elseif self.type == "ready" then
            img = button_ready
        elseif self.type == "reroll" then
            img = button_reroll
        elseif self.type == "credits" then
            img = button_credits
        end

        local mouse_x,mouse_y = love.mouse.getPosition()
        local hot = (mouse_x >= self.x) and (mouse_x <= self.x + self.width) and (mouse_y >= self.y) and (mouse_y <= self.y + self.height) 
        if hot then
            love.graphics.draw(img, self.x-5, self.y-5, nil, self.scale + .2)
            if self.type == "collection" then
                love.graphics.print({dcoral_color,"COLLECTION"}, 575, 455, nil, 1.25, 1.25)
            elseif self.type == "buy" then
                love.graphics.print({dcoral_color,"BUY"}, self.x+ 15, self.y+ 3, nil, 1.25, 1.25)
            elseif self.type == "reroll" then
                love.graphics.print({dcoral_color,"REROLL"}, self.x + 15, self.y+ 7, nil, 1.25, 1.25)
                love.graphics.print({dcoral_color,"1"}, self.x + 135, self.y+ 7, nil, 1.25, 1.25)  
                love.graphics.draw(shell_currency, self.x + 150, self.y+ 15, nil, 2.08, 2.08)
            elseif self.type == "ready" then
                love.graphics.print({dcoral_color,"READY"}, self.x + 20, self.y+ 5, nil, 1.56, 1.56)
            end
        else 
            love.graphics.draw(img, self.x, self.y, nil, self.scale)
            if self.type == "collection" then
                love.graphics.print({dcoral_color,"COLLECTION"}, 580, 460, nil, 1.2, 1.2)
            elseif self.type == "buy" then
                love.graphics.print({dcoral_color,"BUY"}, self.x+ 20, self.y+ 8, nil, 1.2, 1.2)
            elseif self.type == "reroll" then
                love.graphics.print({dcoral_color,"REROLL"}, self.x + 20, self.y+ 12, nil, 1.2, 1.2)      
                love.graphics.print({dcoral_color,"1"}, self.x + 140, self.y+ 12, nil, 1.2, 1.2)  
                love.graphics.draw(shell_currency, self.x + 155, self.y+ 20, nil, 2, 2)

            elseif self.type == "ready" then
                love.graphics.print({dcoral_color,"READY"}, self.x + 25, self.y+ 10, nil, 1.5, 1.5)
            end
        end
    end
    return button
end


return button