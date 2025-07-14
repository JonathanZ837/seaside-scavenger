matchingtile = nil

local img = love.graphics.newImage('sprites/particle.png')
sandps = love.graphics.newParticleSystem(img, 32)
sandps:setParticleLifetime(0.5, 0.7) 
sandps:setLinearAcceleration(-200, 0, 200, 800)
sandps:setSizes(2)


function tile(x, y, item) 
    return {
        width = 80,
        height = 80,
        x = x,
        y = y,
        item = item,
        revealed = false,
        text_x = x + 40,
        text_y = y + 40,
        solved = false,
        selected = false,
        wrong = false,
        flagged = false,



        checkPressed = function (self, mouse_x, mouse_y,currlevel, button) 
            if inputBlocked then return end
            if (mouse_x >= self.x) and (mouse_x <= self.x + self.width) and (mouse_y >= self.y) and (mouse_y <= self.y + self.height) then
                if button == 2 then
                    if self.revealed == false and self.flagged == false and currflags > 0 then
                        self.flagged = true
                        currflags = currflags - 1
                    end
                else
                    if self.solved then
                        return
                    elseif matchingtile == self then
                        return
                    elseif self.item == "blank" then
                        sounds.dig:play()
                        sandps:emit(50)
                        self.revealed = true
                        self.solved = true
                    elseif (matchingtile == nil) then
                        sounds.dig:play()
                        sandps:emit(50)
                        matchingtile = self
                        self.revealed = true
                        self.selected = true
                        if (self.item == "bomb") then
                            sounds.fuse:play()
                        end
                    elseif (matchingtile.item == self.item) then
                        sandps:emit(50)
                        self.revealed = true
                        self.solved = true
                        self.selected = false
                        matchingtile.solved = true
                        matchingtile = nil
                        
                        if self.item == "shell1" then
                            sounds.correct:play()
                            collection_shells.shell1 = true
                            currlevel.shellsfound = currlevel.shellsfound + 1
                            shells = shells + shell1pay
                            if (levels[currentlevel].shellsfound == levels[currentlevel].shellsreq) then
                                for index in pairs(levels[currentlevel].tiles) do 
                                    levels[currentlevel].tiles[index].revealed = true
                                    inputBlocked = true
                                end
                        
                                solvedLevel = true
                            end
                        elseif self.item == "shell2" then
                            sounds.correct:play()
                            collection_shells.shell2 = true
                            currlevel.shellsfound = currlevel.shellsfound + 1
                            shells = shells + shell2pay
                            if (levels[currentlevel].shellsfound == levels[currentlevel].shellsreq) then
                                for index in pairs(levels[currentlevel].tiles) do 
                                    levels[currentlevel].tiles[index].revealed = true
                                    inputBlocked = true
                                end
                        
                                solvedLevel = true
                            end
                        elseif self.item == "shell3" then
                            sounds.correct:play()
                            collection_shells.shell3 = true
                            currlevel.shellsfound = currlevel.shellsfound + 1
                            shells = shells + 4
                            if (levels[currentlevel].shellsfound == levels[currentlevel].shellsreq) then
                                for index in pairs(levels[currentlevel].tiles) do 
                                    levels[currentlevel].tiles[index].revealed = true
                                    inputBlocked = true
                                end
                        
                                solvedLevel = true
                            end
                        elseif self.item == "shell4" then
                            sounds.correct:play()
                            collection_shells.shell4 = true
                            currlevel.shellsfound = currlevel.shellsfound + 1
                            shells = shells + 8
                            if (levels[currentlevel].shellsfound == levels[currentlevel].shellsreq) then
                                for index in pairs(levels[currentlevel].tiles) do 
                                    levels[currentlevel].tiles[index].revealed = true
                                    inputBlocked = true
                                end
                                solvedLevel = true
                            end
                        elseif self.item == "bomb" then
                            collection_shells.bomb = true
                            if not bombimmunity then
                                sounds.explode:play()
                                currstrikes  = currstrikes - 1
                                if shells % 2 == 0 then
                                    shells = shells/2
                                else
                                    shells = (shells+1)/2
                                end
                                if currstrikes == 0 then
                                    for index in pairs(levels[currentlevel].tiles) do 
                                        levels[currentlevel].tiles[index].revealed = true
                                        levels[currentlevel].tiles[index].selected = false
                                        inputBlocked = true
                                    end
                            
                                    failedLevel = true
                                end
                            end
                        elseif self.item == "vision" then
                            sounds.vision:play()
                            collection_shells.vision = true
                            for index in pairs(levels[currentlevel].tiles) do 
                                levels[currentlevel].tiles[index].revealed = true
                            end
                            inputBlocked = true
                            visionTimer = visionduration
                            
                        end
                    else
                        sounds.wrong:play()
                        sandps:emit(50)
                        currstrikes  = currstrikes - 1
                        if currstrikes == 0 then
                            for index in pairs(levels[currentlevel].tiles) do 
                                levels[currentlevel].tiles[index].revealed = true
                                inputBlocked = true
                                levels[currentlevel].tiles[index].selected = false
                            end
                    
                            failedLevel = true
                            return
                        end
    
                        self.revealed = true
                        matchingtile.wrong = true
                        self.wrong = true
                        
                        inputBlocked = true -- Block input during the delay
                        mismatchTimer = 1.5 -- seconds
        
                        -- Store both tiles for later hiding
                        mismatchTiles = {
                            self,
                            matchingtile
                        }
    
                        
                    end
                end
                
                
            end
        end,

  
        draw = function (self) 
            if self.revealed then
                local tilesprite

                if self.solved then
                    if item == "blank" then
                        tilesprite = level_tile2
                    elseif item == "shell1" then
                        tilesprite = level_shell1_c
                    elseif item == "shell2" then
                        tilesprite = level_shell2_c
                    elseif item == "shell3" then
                        tilesprite = level_shell3_c
                    elseif item == "shell4" then
                        tilesprite = level_shell4_c
                    elseif item == "shell3" then
                    elseif item == "bomb" then
                        tilesprite = level_bomb_c
                    elseif item == "vision" then
                        tilesprite = level_vision_c
                    end
                elseif self.wrong then
                    if item == "blank" then
                        tilesprite = level_tile2
                    elseif item == "shell1" then
                        tilesprite = level_shell1_w
                    elseif item == "shell2" then
                        tilesprite = level_shell2_w
                    elseif item == "shell3" then
                        tilesprite = level_shell3_w
                    elseif item == "shell4" then
                        tilesprite = level_shell4_w
                    elseif item == "bomb" then
                        tilesprite = level_bomb_w
                    elseif item == "vision" then
                        tilesprite = level_vision_w
                    end
                elseif self.selected then
                    if item == "blank" then
                        tilesprite = level_tile2
                    elseif item == "shell1" then
                        tilesprite = level_shell1_s
                    elseif item == "shell2" then
                        tilesprite = level_shell2_s
                    elseif item == "shell3" then
                        tilesprite = level_shell3_w
                    elseif item == "shell4" then
                        tilesprite = level_shell4_w
                    elseif item == "bomb" then
                        tilesprite = level_bomb_s
                    elseif item == "vision" then
                        tilesprite = level_vision_s
                    end
                else
                    if item == "blank" then
                        tilesprite = level_tile2
                    elseif item == "shell1" then
                        tilesprite = level_shell1
                    elseif item == "shell2" then
                        tilesprite = level_shell2
                    elseif item == "shell3" then
                        tilesprite = level_shell3
                    elseif item == "shell4" then
                        tilesprite = level_shell4
                    elseif item == "bomb" then
                        tilesprite = level_bomb
                    elseif item == "vision" then
                        tilesprite = level_vision
                    end
                end
                love.graphics.draw(tilesprite, self.x, self.y, nil, 5)
            else 

                local tilesprite = nil
                if self.flagged then
                    tilesprite = level_tile3
                else
                    tilesprite = level_tile1
                end
                                
                local mouse_x,mouse_y = love.mouse.getPosition()
                local hot = (mouse_x >= self.x) and (mouse_x <= self.x + self.width) and (mouse_y >= self.y) and (mouse_y <= self.y + self.height) 
                if hot then
                    love.graphics.draw(tilesprite, self.x-3, self.y-3, nil, 5.4)
                else 
                    love.graphics.draw(tilesprite, self.x, self.y, nil, 5)
                end
            end
        end,
    }
    
end



return tile