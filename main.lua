local tile = require "tile"
local button = require "button"
local shopitem = require "shopitem"

inputBlocked = false
mismatchTimer = 0
mismatchTiles = nil

visionTimer = 0

strikes = 3
currstrikes = 3
shells = 0
currentlevel = 1
collection_shells = {shell1 = false, shell2 = false, shell3 = false, shell4 = false, bomb = false, vision = false}
prevState = nil
currState = 0
solvedLevel = false
failedLevel = false
flags = 0
currflags = 0
bombimmunity = false
visionduration = 1.0
shell1pay = 1
shell2pay = 2

dcoral_color = {0.671, 0.361, 0.267, 255}
coral_color = {0.969, 0.71, 0.518,255}
dgreen_color = {0.165, 0.341, 0.098, 255}
dyellow_color = {0.651, 0.612, 0.282,255}
dblue_color = {0, 0.404, 0.761, 255}
local game  = {
    state = {
        menu = true,
        collection = false,
        tutorial = false,
        level = false,
        shop = false,
        endscreen = false,
        credits = false
    }
}



local buttons = {
    menu = {
        button(280,340,240,80, 5, "play", function() 
            game.state.menu = false
            game.state.tutorial = true
            prevState = "tutorial"
        end
        ),

        button(280,440,240,80, 5, "quit", function() 
            love.event.quit() 
        end
        )
    },
    collection = {
        button(500,500,240,80, 5, "play", function() 
            game.state.collection = false
            game.state[prevState] = true
        end
        ),
    },
    level = {
        button(160,490,240,80, 5, "shop", function() 
            game.state.level = false
            game.state.shop = true
            prevState = "shop"
            inputBlocked = false
            currentlevel = currentlevel + 1
            currstrikes = strikes
            solvedLevel = false
            currflags = flags

            if (currentlevel == 8) then
                game.state.level = false
                game.state.shop = false
                game.state.endscreen = true
            end
            shuffle(shop_items)
            for i = 1,3 do
                newshopitem = shopitem(i * 170- 143, 40, shop_items[i])
                table.insert(currentshop, newshopitem)
            end

            for index in pairs(currentshop) do
                currentshop[index]:initialize()
            end
        end
        ),
        button(160,490,240,80, 5, "menu", function() 
            game.state.over = false
            game.state.menu = true
            prevState = "menu"
            inputBlocked = false
            failedLevel = false
 
            resetgame()
        end
        )
    },
    board = {
        button(560,450,200,60, 5, "collection", function() 
            game.state.collection = true
            game.state[prevState] = false
        end
        ),
    },
    tutorial = {
        button(155,420,240,80, 5, "nextlevel", function() 
            game.state.tutorial = false
            game.state.level = true
            prevState = "level"
        end
        )
    },

    shop = {
        button(285,510,240,65, 5, "ready", function() 
            game.state.shop = false
            game.state.level = true
            prevState = "level"
            currentshop = {}
        end
        ),
        button(20,510,240,55, 5, "reroll", function() 

            if (shells >= 1) then
                currentshop = {}
                shuffle(shop_items)
                for i = 1,3 do
                    newshopitem = shopitem(i * 170- 143, 40, shop_items[i])
                    table.insert(currentshop, newshopitem)
                end

                for index in pairs(currentshop) do
                    currentshop[index]:initialize()
                end
                shells = shells - 1
            end
        end
        ),
    },
    endscreen = {
        button(155,500,240,80, 5, "menu", function() 
            game.state.endscreen = false
            game.state.menu = true
            prevState = "menu"
            inputBlocked = false
            failedLevel = false

            resetgame()
        end
        ),
        button(415,500,240,80, 5, "credits", function() 
            game.state.endscreen = false
            game.state.credits = true
            prevState = "credits"
        end
        )
    },

    credits = {
        button(285,500,240,80, 5, "menu", function() 
            game.state.credits= false
            game.state.menu = true
            prevState = "menu"
            inputBlocked = false
            failedLevel = false

            resetgame()
        end
        )
    }
    
}

levels = {

    {--level 1
        types = {"shell2", "shell2", "shell1", "shell1"},
        tiles = {},
        shellsreq = 2,
        shellsfound = 0,
        gridx = 190,
        gridy = 220,
        positionrows = {0, 0, 1, 1},
        positioncols = {0, 1, 0, 1},
    },

    {--level 2
        types = {"blank", "blank", "shell1", "shell1", "shell2", "shell2"},
        tiles = {},
        shellsreq = 2,
        shellsfound = 0,
        gridx = 160,
        gridy = 220,
        positionrows = {0, 0, 0, 1, 1, 1},
        positioncols = {0, 1, 2, 0, 1, 2},
    },
    {--level 3
        types = {"shell1", "shell1", "shell1", "shell1", "shell2", "shell2", "bomb", "bomb", "blank"},
        tiles = {},
        shellsreq = 3,
        shellsfound = 0,
        gridx = 180,
        gridy = 200,
        positionrows = {0, 0, 0, 1, 1, 1, 2, 2, 2},
        positioncols = {0, 1, 2, 0, 1, 2, 0, 1, 2},
    },
    {--level 4
        types = {"shell1", "shell1", "shell1", "shell1", "shell2", "shell2", "bomb", "bomb", "vision", "vision", "shell2", "shell2"},
        tiles = {},
        shellsreq = 4,
        shellsfound = 0,
        gridx = 120,
        gridy = 200,
        positionrows = {0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2},
        positioncols = {0, 1, 2, 3,  0, 1, 2, 3, 0, 1, 2, 3},
    },
    {--level 5
        types = {"shell1", "shell1", "shell1", "shell1", "shell2", "shell2", "bomb", "bomb", "vision", "vision", "shell3", "shell3", "blank"},
        tiles = {},
        shellsreq = 4,
        shellsfound = 0,
        gridx = 80,
        gridy = 80,
        positionrows = {2, 1, 2, 3, 0, 1, 2,3, 4, 1, 2, 3,2},
        positioncols = {4, 3, 3, 3,  2, 2, 2, 2, 2, 1, 1, 1,0},
    },
    {--level 6
        types = {"shell1", "shell1", "shell1", "shell1", "shell2", "shell2", "bomb", "bomb", "bomb", "bomb","vision", "vision", "shell3", "shell3", "blank", "blank"},
        tiles = {},
        shellsreq = 4,
        shellsfound = 0,
        gridx = 90,
        gridy = 110,
        positionrows = {0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3},
        positioncols = {0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3},
    },
    {--level 7
        types = {"shell1", "shell1", "shell1", "shell1", "shell2", "shell2", "shell2", "shell2", "shell3","shell3", "shell4", "shell4","bomb", "bomb", "bomb", "bomb","vision", "vision", "blank", "blank"},
        tiles = {},
        shellsreq = 6,
        shellsfound = 0,
        gridx = 35,
        gridy = 50,
        positionrows = {0, 0, 1, 1, 1, 1, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 5, 5},
        positioncols = {0, 5, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 1, 2, 3, 4, 0, 5},
    },
}


-- shop_items = {"flag", "flag", "flag", "strike", "strike", "strike", "shell1x", "shell2x", "bomb_disable", "vision_enhance"}
shop_items = {"flag", "flag", "strike", "strike", "strike", "bomb_immun", "vision_enhance","shell1_mult", "shell2_mult"}
currentshop = {}


function love.load()    
    
    love.graphics.setDefaultFilter("nearest", "nearest")

    cursor = love.graphics.newImage('sprites/cursor.png')
    love.mouse.setVisible(false)

    local cutefont = love.graphics.newFont("fonts/CutePixel.ttf", 32)
    love.graphics.setFont(cutefont)
    cutefont:setLineHeight(0.8)
    sounds = {
        click = love.audio.newSource("sounds/dig.wav", "static"),
        dig = love.audio.newSource("sounds/dig.wav", "static"),
        correct = love.audio.newSource("sounds/correct.wav", "static"),
        wrong = love.audio.newSource("sounds/wrong.mp3", "static"),
        explode = love.audio.newSource("sounds/explode.mp3", "static"),
        vision = love.audio.newSource("sounds/vision.wav", "static"),
        purchase = love.audio.newSource("sounds/purchase.wav", "static"),
        click = love.audio.newSource("sounds/click.wav", "static"),
        music = love.audio.newSource("sounds/music.wav", "static"),
        fuse = love.audio.newSource("sounds/fuse.wav", "static")
    }
    sounds.music:setLooping(true)
    sounds.music:setVolume(0.15)
    sounds.music:play()
    background = love.graphics.newImage('sprites/background.png')

    board_img = love.graphics.newImage("sprites/board.png")

    button_play = love.graphics.newImage("sprites/playbutton.png")
    button_quit = love.graphics.newImage("sprites/quit.png")
    button_journal = love.graphics.newImage("sprites/journal.png")
    button_nextlevel = love.graphics.newImage("sprites/nextlevel.png")
    button_shop = love.graphics.newImage("sprites/shop.png")
    button_menu = love.graphics.newImage("sprites/menu.png")
    button_ready = love.graphics.newImage("sprites/ready.png")
    button_buy = love.graphics.newImage("sprites/buy.png")
    button_reroll = love.graphics.newImage("sprites/reroll.png")
    button_credits = love.graphics.newImage("sprites/credits.png")

    

    tutorial_board = love.graphics.newImage("sprites/tutorialboard.png")
    tutorial_img1 = love.graphics.newImage("sprites/tutorial1.png")
    tutorial_img2 = love.graphics.newImage("sprites/tutorial2c.png")
    tutorial_check = love.graphics.newImage("sprites/check.png")
    tutorial_x = love.graphics.newImage("sprites/x.png")

    collection_background = love.graphics.newImage("sprites/collectionbackground.png")
    collection_shell1 = love.graphics.newImage("sprites/collection_shell1.png")
    collection_shell2 = love.graphics.newImage("sprites/collection_shell2.png")
    collection_shell3 = love.graphics.newImage("sprites/collection_shell3.png")
    collection_shell4 = love.graphics.newImage("sprites/collection_shell4.png")
    collection_vision = love.graphics.newImage("sprites/collection_vision.png")
    collection_bomb = love.graphics.newImage("sprites/collection_bomb.png")

    collection_shell1_s = love.graphics.newImage("sprites/collection_shell1_s.png")
    collection_shell2_s = love.graphics.newImage("sprites/collection_shell2_s.png")
    collection_shell3_s = love.graphics.newImage("sprites/collection_shell3_s.png")
    collection_shell4_s = love.graphics.newImage("sprites/collection_shell4_s.png")
    collection_vision_s = love.graphics.newImage("sprites/collection_vision_s.png")
    collection_bomb_s = love.graphics.newImage("sprites/collection_bomb_s.png")

    level_tile1 = love.graphics.newImage("sprites/tile1.png")
    level_tile2 = love.graphics.newImage("sprites/tile2.png")
    level_tile3 = love.graphics.newImage("sprites/tile3.png")
    level_shell1 = love.graphics.newImage("sprites/shell1.png")
    level_shell2 = love.graphics.newImage("sprites/shell2.png")
    level_shell3 = love.graphics.newImage("sprites/shell3.png")
    level_shell4 = love.graphics.newImage("sprites/shell4.png")
    level_vision = love.graphics.newImage("sprites/vision.png")
    level_bomb = love.graphics.newImage("sprites/bomb.png")

    level_shell1_s = love.graphics.newImage("sprites/shell1_s.png")
    level_shell2_s = love.graphics.newImage("sprites/shell2_s.png")
    level_shell3_s = love.graphics.newImage("sprites/shell3_s.png")
    level_shell4_s = love.graphics.newImage("sprites/shell4_s.png")
    level_vision_s = love.graphics.newImage("sprites/vision_s.png")
    level_bomb_s = love.graphics.newImage("sprites/bomb_s.png")

    level_shell1_w = love.graphics.newImage("sprites/shell1_w.png")
    level_shell2_w = love.graphics.newImage("sprites/shell2_w.png")
    level_shell3_w = love.graphics.newImage("sprites/shell3_w.png")
    level_shell4_w = love.graphics.newImage("sprites/shell4_w.png")
    level_vision_w = love.graphics.newImage("sprites/vision_w.png")
    level_bomb_w = love.graphics.newImage("sprites/bomb_w.png")

    level_shell1_c = love.graphics.newImage("sprites/shell1_c.png")
    level_shell2_c = love.graphics.newImage("sprites/shell2_c.png")
    level_shell3_c = love.graphics.newImage("sprites/shell3_c.png")
    level_shell4_c = love.graphics.newImage("sprites/shell4_c.png")
    level_vision_c = love.graphics.newImage("sprites/vision_c.png")
    level_bomb_c = love.graphics.newImage("sprites/bomb_c.png")

    shop_panel = love.graphics.newImage("sprites/shop_panel.png")
    shop_flag = love.graphics.newImage("sprites/flag.png")
    shop_strike = love.graphics.newImage("sprites/strike.png")
    shop_bomb_immun = love.graphics.newImage("sprites/bomb_immunity.png")
    shop_vision_enhance = love.graphics.newImage("sprites/vision_enhance.png")
    shop_shell1_mult = love.graphics.newImage("sprites/shell1_mult.png")
    shop_shell2_mult = love.graphics.newImage("sprites/shell2_mult.png")

    endbackground = love.graphics.newImage("sprites/endbackground.png")

    shell_currency = love.graphics.newImage("sprites/shell.png")

    for index in pairs(levels) do
        shuffle(levels[index].types)
        for i in pairs(levels[index].types) do
            newtile = tile(levels[index].gridx + levels[index].positioncols[i]*80,levels[index].gridy + levels[index].positionrows[i]*80,levels[index].types[i])
            table.insert(levels[index].tiles, newtile)
        end
    end
    
end

function love.update(dt)
    sandps:update(dt)
    if mismatchTimer > 0 then
        mismatchTimer = mismatchTimer - dt
        if mismatchTimer <= 0 and mismatchTiles then
            mismatchTiles[1].revealed = false
            mismatchTiles[2].revealed = false
            mismatchTiles[1].wrong = false
            mismatchTiles[2].wrong = false
            mismatchTiles = nil
            inputBlocked = false
            matchingtile = nil
        end
    end

    if visionTimer > 0 then
        visionTimer = visionTimer - dt
        if visionTimer <= 0 then
            for index in pairs(levels[currentlevel].tiles) do 
                if levels[currentlevel].tiles[index].solved == false then
                    levels[currentlevel].tiles[index].revealed = false
                end
            end
            inputBlocked = false
        end
    end

end

function love.draw()
    love.graphics.draw(background,0,0)

    if not (game.state.menu or game.state.collection or game.state.endscreen or game.state.credits) then
        love.graphics.draw(board_img, 540, 50, nil, 5, 5)

        love.graphics.print({dcoral_color,shells}, 610,220,nil, 2, 2)
        love.graphics.draw(shell_currency, 565,232,nil, 3.2, 3.2)
        love.graphics.print({dcoral_color, "Level ".. currentlevel}, 550,110,nil, 1.3, 1.3)
        love.graphics.print({dcoral_color,"Strikes: ".. currstrikes}, 550,150,nil)
        love.graphics.print({dcoral_color,"Shells Remaining: ".. (levels[currentlevel].shellsreq - levels[currentlevel].shellsfound)}, 550,175,nil)
        love.graphics.draw(shop_flag, 660, 225, nil, 3.2, 3.2)
        love.graphics.print({dcoral_color, currflags}, 710, 220, nil, 2, 2)
        for index in pairs(buttons.board) do 
            buttons.board[index]:draw()
        end
    end

    if game.state.menu then
        local title_img = love.graphics.newImage("sprites/title.png")
        love.graphics.draw(title_img, 160,70, nil, 5, 5)
        for index in pairs(buttons.menu) do 
            buttons.menu[index]:draw()
        end

        love.graphics.print({dcoral_color, "All art made by Jonathan Zeng with Aseprite :)"}, 120, 550)
        -- buttons.menu[1]:draw()
    elseif game.state.collection then
        love.graphics.draw(collection_background,0,0, nil, 4, 4)
        for index in pairs(buttons.collection) do 
            buttons.collection[index]:draw()
        end

        love.graphics.print({dblue_color,"COLLECTION"}, 200, -15, nil, 3, 3)

        love.graphics.print({dcoral_color,"Additional info: \n -When the first tile with an item is dug, the tile will have a yellow outline \nindicating that the item must now be matched. \n -If the next item clicked is matching with the yellow tile, it will collect that shell/item. \n -If the next item is not matching, both will turn red and the tiles will be covered again. \n -Blank tiles will not be counted as a tile with an item, but will be revealed once dug."}, 20, 370, nil, 0.7, 0.7)

        if collection_shells.shell1 then
            love.graphics.draw(collection_shell1, 40, 100, nil, 5, 5)
            love.graphics.printf({dcoral_color, "Scallop: \nA common seashell with a distinct coral hue. Worth 1 shell.\n"}, 20, 175, 170,"center", nil, .7, .7)
        else 
            love.graphics.draw(collection_shell1_s, 40, 100, nil, 5, 5)
            love.graphics.printf({dcoral_color, "???"}, 20, 175, 170,"center", nil, .7, .7)
        end
        if collection_shells.shell2 then
            love.graphics.draw(collection_shell2, 170, 100, nil, 5, 5)
            love.graphics.printf({dcoral_color, "Cowrie: \nA snail shell with teeth-like ridges, used as currency by many cultures. Worth 2 shells.\n"}, 150, 175, 170,"center", nil, .7, .7)
        else
            love.graphics.draw(collection_shell2_s, 170, 100, nil, 5, 5)
            love.graphics.printf({dcoral_color, "???"}, 150, 175, 170,"center", nil, .7, .7)
        end

        if collection_shells.shell3 then
            love.graphics.draw(collection_shell3, 300, 100, nil, 5, 5)
            love.graphics.printf({dcoral_color, "Conch: \nA shell with a pointy spire and mesmerizing shape. Worth 4 shells.\n"}, 280, 175, 170,"center", nil, .7, .7)
        else
            love.graphics.draw(collection_shell3_s, 300, 100, nil, 5, 5)
            love.graphics.printf({dcoral_color, "???"}, 280, 175, 170,"center", nil, .7, .7)
        end

        if collection_shells.shell4 then
            love.graphics.draw(collection_shell4, 430, 100, nil, 5, 5)
            love.graphics.printf({dcoral_color, "Junonia: \nA dotted shell prized for its rarity and beauty. Worth 8 shells.\n"}, 410, 175, 170,"center", nil, .7, .7)
        else
            love.graphics.draw(collection_shell4_s, 430, 100, nil, 5, 5)
            love.graphics.printf({dcoral_color, "???"}, 410, 175, 170,"center", nil, .7, .7)
        end

        if collection_shells.bomb then
            love.graphics.draw(collection_bomb, 560, 100, nil, 5, 5)
            love.graphics.printf({dcoral_color, "Bomb: Explodes upon matching, causing the player to lose half their shells and take a strike.\n \n"}, 540, 175, 170,"center", nil, .7, .7)
        else 
            love.graphics.draw(collection_bomb_s, 560, 100, nil, 5, 5)
            love.graphics.printf({dcoral_color, "???"}, 540, 175, 170,"center", nil, .7, .7)
        end


        if collection_shells.vision then
            love.graphics.draw(collection_vision, 690, 100, nil, 5, 5)
            love.graphics.printf({dcoral_color, "Vision: \n Activates upon matching, letting the player see the entire board for a brief moment.\n"}, 670, 175, 170,"center", nil, .7, .7)
        else
            love.graphics.draw(collection_vision_s, 690, 100, nil, 5, 5)
            love.graphics.printf({dcoral_color, "???"}, 670, 175, 170,"center", nil, .7, .7)
        end
        
        love.graphics.print({dcoral_color, "Check back here as you discover more shells & items!"}, 20, 520, nil, .7, .7)
    elseif game.state.tutorial then
        love.graphics.draw(tutorial_board, 30,50,nil, 5, 5)
        for index in pairs(buttons.tutorial) do 
            buttons.tutorial[index]:draw()
        end

        love.graphics.print({dgreen_color, "Welcome to Junonia Beach!"}, 60, 60, nil, 1.35, 1.35)
        love.graphics.print({dgreen_color, "You are a curious collector of seashells, ready to \nunearth all the treasures Junonia Beach has to offer!"}, 60, 100, nil, .65, .65)

        love.graphics.draw(tutorial_img2, 60,150, nil, 0.5, 0.5)
        love.graphics.draw(tutorial_img1, 280,150, nil, 0.5, 0.5)

        love.graphics.draw(tutorial_check, 130,270, nil, 1.2, 1.2)
        love.graphics.draw(tutorial_x, 350,270, nil, 1.2, 1.2)

        love.graphics.print({dgreen_color, "Match tiles of the same type! Find all the shells on the \nboard before you run out of strikes! Upgrade your \nloadout by purchasing powerups in the shop with \nyour shells! (Access your collection to see useful info)"}, 60, 330, nil, .65, .65)
    elseif game.state.level then

        if failedLevel then
            love.graphics.print({dcoral_color, "Game over, you ran out of strikes!"}, 80, 80)
            buttons.level[2]:draw()
        end
        if solvedLevel then
            love.graphics.print({dcoral_color, "Level Complete!"}, 190, 90)
            buttons.level[1]:draw()
        end

        love.graphics.print({dcoral_color,"Find all the shells to win!"}, 550, 70, nil, 0.73, 0.73)
        
        for index in pairs(levels[currentlevel].tiles) do 
            levels[currentlevel].tiles[index]:draw()
        end
        love.graphics.draw(sandps, mousex, mousey)

 
    elseif game.state.shop then
        love.graphics.print({dcoral_color,"Welcome to the shop!"}, 550, 70, nil, 0.73, 0.73)

        for index in pairs(currentshop) do
            currentshop[index]:draw()
        end
        for index in pairs(buttons.shop) do 
            buttons.shop[index]:draw()
        end

    elseif game.state.endscreen then
        love.graphics.draw(endbackground, 0, 0, nil, 4, 4)
        love.graphics.printf({dblue_color,"Thank you for playing Seaside Scavenger!"}, 130, 10, 300, "center", nil, 1.8, 1.8)
        love.graphics.printf({dcoral_color,"Developed by: Jonathan Zeng\n"}, 120, 420, 400, "center", nil, 1.5, 1.5)
        for index in pairs(buttons.endscreen) do 
            buttons.endscreen[index]:draw()
        end
    elseif game.state.credits then
        love.graphics.draw(endbackground, 0, 0, nil, 4, 4)
        love.graphics.printf({dblue_color,"Audio Credits: "}, 130, 10, 300, "center", nil, 1.8, 1.8)

--         https://freesound.org/people/f3bbbo/sounds/651292/

-- https://freesound.org/people/CogFireStudios/sounds/531510/

-- https://freesound.org/people/Raclure/sounds/483598/

-- https://freesound.org/people/Jay_You/sounds/460432/

-- https://freesound.org/people/Zangrutz/sounds/155235/

-- https://freesound.org/people/Christopherderp/sounds/342200/
-- https://freesound.org/people/BlondPanda/sounds/659889/
-- https://freesound.org/people/j1987/sounds/140715/
        love.graphics.printf({dcoral_color,"https://freesound.org/people/f3bbbo/sounds/651292/\n"}, 20, 120, 800, "center", nil, 1, 1)
        love.graphics.printf({dcoral_color,"https://freesound.org/people/CogFireStudios/sounds/531510/\n"}, 20, 150, 800, "center", nil, 1, 1)
        love.graphics.printf({dcoral_color,"https://freesound.org/people/Raclure/sounds/483598/\n"}, 20, 180, 800, "center", nil, 1, 1)
        love.graphics.printf({dcoral_color,"https://freesound.org/people/Jay_You/sounds/460432/\n"}, 20, 210, 800, "center", nil, 1, 1)
        love.graphics.printf({dcoral_color,"https://freesound.org/people/Zangrutz/sounds/155235/\n"}, 20, 240, 800, "center", nil, 1, 1)
        love.graphics.printf({dcoral_color,"https://freesound.org/people/Christopherderp/sounds/342200/\n"}, 20, 270, 800, "center", nil, 1, 1)
        love.graphics.printf({dcoral_color,"https://freesound.org/people/BlondPanda/sounds/659889/\n"}, 20, 300, 800, "center", nil, 1, 1)
        love.graphics.printf({dcoral_color,"https://freesound.org/people/j1987/sounds/140715/\n"}, 20, 330, 800, "center", nil, 1, 1)
        for index in pairs(buttons.credits) do 
            buttons.credits[index]:draw()
        end
    end

    local mx, my = love.mouse.getPosition()
    love.graphics.draw(cursor, mx, my,nil, 3, 3)

    

end

function love.mousepressed(x,y,button,istouch,presses)

    if not (game.state.menu or game.state.collection) then
        if button == 1 then
            for index in pairs(buttons.board) do 
                buttons.board[index]:checkPressed(x,y) 
            end
        end
    end
    if game.state.menu then
        if button == 1 then
            for index in pairs(buttons.menu) do 
                buttons.menu[index]:checkPressed(x,y) 
            end
        end
    elseif game.state.tutorial then
        if button == 1 then
            for index in pairs(buttons.tutorial) do 
                buttons.tutorial[index]:checkPressed(x,y) 
            end
        end
    elseif game.state.collection then
        for index in pairs(buttons.collection) do 
            buttons.collection[index]:checkPressed(x,y) 
        end
    elseif game.state.level then
        if button == 1 or button == 2 then
            mousex,mousey = love.mouse.getPosition()
            for index in pairs(levels[currentlevel].tiles) do 
                levels[currentlevel].tiles[index]:checkPressed(x,y, levels[currentlevel], button) 
            end

            if solvedLevel then
                buttons.level[1]:checkPressed(x,y) 
            end
            if failedLevel then
                buttons.level[2]:checkPressed(x,y)
            end 
        end
        
    elseif game.state.shop then
        if button == 1 then
            for index in pairs(buttons.shop) do 
                buttons.shop[index]:checkPressed(x,y) 
            end

            for index in pairs(currentshop) do
                if not currentshop[index].bought then
                    currentshop[index].buybutton:checkPressed(x,y)
                end
            end
        end
    elseif game.state.endscreen then
        if button == 1 then
            for index in pairs(buttons.endscreen) do 
                buttons.endscreen[index]:checkPressed(x,y) 
            end
        end
    elseif game.state.credits then
        if button == 1 then
            for index in pairs(buttons.credits) do 
                buttons.credits[index]:checkPressed(x,y) 
            end
        end
    end
end


function shuffle(tbl)
    math.randomseed(os.time())
    for i = #tbl, 2, -1 do
      local j = math.random(i)
      tbl[i], tbl[j] = tbl[j], tbl[i]
    end
    return tbl
  end

function resetgame()

    
    for index in pairs(levels) do
        shuffle(levels[index].types)
        levels[index].tiles = {}
        for i in pairs(levels[index].types) do
            newtile = tile(levels[index].gridx + levels[index].positioncols[i]*80,levels[index].gridy + levels[index].positionrows[i]*80,levels[index].types[i])
            table.insert(levels[index].tiles, newtile)
        end
        levels[index].shellsfound = 0
    end
    strikes = 3
    currstrikes = 3
    currentlevel = 1
    shells = 0
    flags = 0
    currflags = 0
    matchingtile = nil
    bombimmunity = false
    visionduration = 1.0
    shell1pay = 1
    shell2pay = 2

end