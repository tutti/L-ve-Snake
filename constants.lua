C = true -- Allows reference to C from functions within C
C = {
    tick = 0.05,
    board = {
        width = 70,
        height = 50,
        left = 50,
        top = 50
    },
    cell = {
        width = 10,
        height = 10
    },
    colour = {
        white = {255, 255, 255},
        black = {0, 0, 0},
        grey = {100, 100, 100},
        red = {255, 0, 0},
        lightred = {255, 100, 100},
        darkred = {150, 0, 0},
        green = {0, 255, 0},
        lightgreen = {150, 255, 100},
        darkgreen = {50, 100, 50},
        blue = {0, 0, 255},
        lightblue = {150, 150, 255},
        darkblue = {0, 0, 150},
        cyan = {0, 255, 255},
        magenta = {255, 0, 255},
        yellow = {255, 255, 0},
        orange = {255, 150, 0}
    },
    direction = {
        up = {0, -1},
        down = {0, 1},
        left = {-1, 0},
        right = {1, 0},
        none = {0, 0},
        random = function()
            local rnd = love.math.random(4)
            if rnd == 1 then return C.direction.up end
            if rnd == 2 then return C.direction.down end
            if rnd == 3 then return C.direction.left end
            if rnd == 4 then return C.direction.right end
        end
    },

    snake = {
        length = 20,
        minGrowth = -3,
        maxGrowth = 5
    },
    pellet = {
        minimum = 1, -- The game will always have this many pellets on the board
        powerCooldownMin = 3, -- 3
        powerCooldownMax = 7 -- 7
    },

    -- Non-player actors
    bouncer = {
        life = 200,
        explosionSize = 4
    },
    antimatter = {
        ticksPerStage = 20
    },
    gigasnake = {
        length = 150,
        size = 2,
        dropChance = 0.02
    },
    tetromino = {
        count = 5,
        ticksPerMove = 10
    },
    evilsnake = {
        changeDirectionMin = 5,
        changeDirectionMax = 15,
        length = 50,
        life = 200
    },
    invader = {
        frameTicks = 10,
        bulletTicks = 13,
        bulletLength = 5,
        bulletExplosionSize = 2
    },

    -- Events
    bombs = {
        bombCount = 5,
        bombSize = 1
    },

    -- Powerups
    invincibility = {
        ticks = 100
    },

    -- Shapes
    shapes = {
        -- Note: Shapes are coded as [row][column], i.e. [y][x].
        tetrominoes = {
            {{true, true, true, true}}, -- I
            {{true, true}, {true, true}}, -- O
            {{true, false, false}, {true, true, true}}, -- J
            {{false, false, true}, {true, true, true}}, -- L
            {{true, true, true}, {false, true, false}}, -- T
            {{false, true, true}, {true, true, false}}, -- S
            {{true, true, false}, {false, true, true}} -- Z
        },
        invaders = {
            { -- Invader 1
                { -- Frame 1
                    {false, false, false, false, true,  true,  true,  true,  false, false, false, false},
                    {false, true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  false},
                    {true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true },
                    {true,  true,  true,  false, false, true,  true,  false, false, true,  true,  true },
                    {true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true },
                    {false, false, false, true,  true,  false, false, true,  true,  false, false, false},
                    {false, false, true,  true,  false, true,  true,  false, true,  true,  false, false},
                    {false, false, false, true,  true,  false, false, true,  true,  false, false, false},
                },
                { -- Frame 2
                    {false, false, false, false, true,  true,  true,  true,  false, false, false, false},
                    {false, true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  false},
                    {true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true },
                    {true,  true,  true,  false, false, true,  true,  false, false, true,  true,  true },
                    {true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true },
                    {false, false, false, true,  true,  false, false, true,  true,  false, false, false},
                    {false, false, true,  true,  false, true,  true,  false, true,  true,  false, false},
                    {true,  true,  false, false, false, false, false, false, false, false, true,  true },
                }
            },
            { -- Invader 2
                { -- Frame 1
                    {false, false, true,  false, false, false, false, false, true,  false, false},
                    {false, false, false, true,  false, false, false, true,  false, false, false},
                    {false, false, true,  true,  true,  true,  true,  true,  true,  false, false},
                    {false, true,  true,  false, true,  true,  true,  false, true,  true,  false},
                    {true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true },
                    {true,  false, true,  true,  true,  true,  true,  true,  true,  false, true },
                    {true,  false, true,  false, false, false, false, false, true,  false, true },
                    {false, false, false, true,  true,  false, true,  true,  false, false, false},
                },
                { -- Frame 2
                    {false, false, true,  false, false, false, false, false, true,  false, false},
                    {true,  false, false, true,  false, false, false, true,  false, false, true },
                    {true,  false, true,  true,  true,  true,  true,  true,  true,  false, true },
                    {true,  true,  true,  false, true,  true,  true,  false, true,  true,  true },
                    {true,  true,  true,  true,  true,  true,  true,  true,  true,  true,  true },
                    {false, true,  true,  true,  true,  true,  true,  true,  true,  true,  false},
                    {false, false, true,  false, false, false, false, false, true,  false, false},
                    {false, true,  false, false, false, false, false, false, false, true,  false},
                }
            },
            { -- Invader 3
                { -- Frame 1
                    {false, false, false, true,  true,  false, false, false},
                    {false, false, true,  true,  true,  true,  false, false},
                    {false, true,  true,  true,  true,  true,  true,  false},
                    {true,  true,  false, true,  true,  false, true,  true },
                    {true,  true,  true,  true,  true,  true,  true,  true },
                    {false, true,  false, true,  true,  false, true,  false},
                    {true,  false, false, false, false, false, false, true },
                    {false, true,  false, false, false, false, true,  false},
                },
                { -- Frame 2
                    {false, false, false, true,  true,  false, false, false},
                    {false, false, true,  true,  true,  true,  false, false},
                    {false, true,  true,  true,  true,  true,  true,  false},
                    {true,  true,  false, true,  true,  false, true,  true },
                    {true,  true,  true,  true,  true,  true,  true,  true },
                    {false, false, true,  false, false, true,  false, false},
                    {false, true,  false, true,  true,  false, true,  false},
                    {true,  false, true,  false, false, true,  false, true },
                }
            }
        }
    }
}