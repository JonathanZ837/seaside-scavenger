local button = require "button"

function shopitem(x, y, item) 
    return {
        x = x,
        y = y,
        item = item,
        icon = nil,
        name = nil,
        description = nil,
        price = nil,
        bought = false,
        func = nil,
        buybutton = nil, 

        initialize = function(self) 
            if self.item == "strike" then
                self.icon = shop_strike
                self.name = "Strike"
                self.description = "Gain an extra strike each level"
                self.price = 4
                self.func = function()
                    if shells >= self.price then
                        sounds.purchase:play()
                        shells = shells - self.price
                        strikes = strikes + 1
                        currstrikes = currstrikes + 1
                        self.bought = true
                    else 
                        sounds.wrong:play()
                    end
                end
                self.buybutton = button(x + 10, y + 395, 130,55,5,  "buy", self.func)
            elseif self.item == "flag" then
                self.icon = shop_flag
                self.name = "Flag"
                self.description = "A flag used to keep track of tiles. Right click on a hidden tile to place your flag."
                self.price = 3
                self.func = function()
                    if shells >= self.price then
                        sounds.purchase:play()
                        shells = shells - self.price
                        flags = flags + 1
                        currflags = currflags + 1
                        self.bought = true
                    else 
                        sounds.wrong:play()
                    end
                end
                self.buybutton = button(x + 10, y + 395, 130,55,5,  "buy", self.func)
            elseif self.item == "bomb_immun" then
                self.icon = shop_bomb_immun
                self.name = "Bomb Defuse"
                self.description = "Protects you against bombs. Upon matching a bomb, you will not lose shells or get striked."
                self.price = 8
                self.func = function()
                    if shells >= self.price then
                        sounds.purchase:play()
                        shells = shells - self.price
                        bombimmunity = true
                        self.bought = true
                    else 
                        sounds.wrong:play()
                    end
                end
                self.buybutton = button(x + 10, y + 395, 130,55,5,  "buy", self.func)
            elseif self.item == "vision_enhance" then
                self.icon = shop_vision_enhance
                self.name = "Vision Enhance"
                self.description = "Enhance your vision. Upon matching a vision ability, increase the duration of the powerup."
                self.price = 5
                self.func = function()
                    if shells >= self.price then
                        sounds.purchase:play()
                        shells = shells - self.price
                        visionduration = visionduration + 1
                        self.bought = true
                    else 
                        sounds.wrong:play()
                    end
                end
                self.buybutton = button(x + 10, y + 395, 130,55,5,  "buy", self.func)
            elseif self.item == "shell1_mult" then
                self.icon = shop_shell1_mult
                self.name = "Scallop Affinity"
                self.description = "Gain an extra shell when matching a scallop."
                self.price = 4
                self.func = function()
                    if shells >= self.price then
                        sounds.purchase:play()
                        shells = shells - self.price
                        shell1pay = shell1pay + 1
                        self.bought = true
                    else 
                        sounds.wrong:play()
                    end
                end
                self.buybutton = button(x + 10, y + 395, 130,55,5,  "buy", self.func)
            elseif self.item == "shell2_mult" then
                self.icon = shop_shell2_mult
                self.name = "Cowrie Affinity"
                self.description = "Gain two extra shells when matching a cowrie."
                self.price = 5
                self.func = function()
                    if shells >= self.price then
                        sounds.purchase:play()
                        shells = shells - self.price
                        shell1pay = shell1pay + 2
                        self.bought = true
                    else 
                        sounds.wrong:play()
                    end
                end
                self.buybutton = button(x + 10, y + 395, 130,55,5, "buy", self.func)
            end
        end,
        draw = function(self)
            love.graphics.draw(shop_panel, self.x, self.y, nil, 5, 5)
            love.graphics.printf({dyellow_color, self.name}, self.x + 20, self.y + 60, 100, "center", nil, 1.1, 1.1)
            love.graphics.printf({dyellow_color,self.description}, self.x + 15, self.y + 200, 180, "center", nil, 0.7, 0.7)
            love.graphics.draw(self.icon, self.x+35, self.y+125, nil, 5, 5)
            love.graphics.draw(shell_currency, self.x + 45, self.y + 360, nil, 2, 2)
            love.graphics.print({dyellow_color, self.price}, self.x + 75, self.y + 350, nil, 1.4, 1.4)

            if not self.bought then
                self.buybutton:draw()
            else
                love.graphics.print({dyellow_color,"Purchased"}, self.x + 15, self.y + 400, nil, 1, 1)
            end
        end,
    }
end

return shopitem