--PROPS
    moneyModel='prop_cash_trolly'

--MINIGAME
    --levels is how many levels you want. Max is 4, Min is 1
    levels=1
    --lifes is how many life player has, Max is 6, Min is 1
    lifes=3
    --time is how much time player has in minutes, Max is 9, min is 1 (I highly recommend to set it between 3-1)
    time=1

--MIN POLICE
    minPolice=2

--COOLDOWN ENTRE BANCOS
    cooldownTime=1200000
--BANKS
    Banks={
        --FLECCA PLAZA CUBOS
        ["Flecca1"]={
            --COORDS WHERE SHOOT TO START SCRIPT
            ["Area"]={
                {142.391204},--MIN X
                {154.061538},--MAX X
                {-1036.305542},--MAX Y
                {-1044.356080},--MIN Y
                {28.364136},
                {32.734008}
            },
            --COORDS OF TERMINAL OF BANK
            ["Terminal"]=vector3(
                146.861542,
                -1046.070312,
                29.364136
            ),
            --COORDS OF BOX
            ["Taladro"]=vector3(
                149.406586,
                -1050.303344,
                29.364136
            ),
            --COORDS OF MONEY PROPS
            ["Money"]={
                vector3(
                    151.160430,
                    -1046.597778,
                    29.330444
                ),
                vector3(
                    147.000000,
                    -1048.114258,
                    29.330444
                )
            },
            --DOOR ROTATION POSITION
            ["Rotation"]={
                249.846,
                159.846
            },
            --IS ON COOLDOWN
            ["Cooldown"]=false,
            --TIME FOR DOOR CLOSE
            ["Time"]=10000,
            --IS ROB
            ["Robado"]={
                false,
                false,
                false
            },
            --STARTED
            ["Iniciado"]=false,
            --DOOR OPEN
            ["DoorOpen"]=false,
            ["Sincro"]=false,
            ["hackeado"]=false
        },
        --FLECCA MOTEL ROSA
        ["Flecca2"]={
            --SHOOT TO START SCRIPT
            ["Area"]={
                {306.250550},
                {318.540650},
                {-274.364838},
                {-282.540650},
                {54.150146},
                {58.912842}
            },
            --COORDS OF TERMINAL OF BANK
            ["Terminal"]=vector3(
                311.195618,
                -284.439573,
                54.150146
            ),
            --COORDS OF BOX
            ["Taladro"]=vector3(
                313.846160,
                -288.975830,
                54.133300
            ),
            --COORDS OF MONEY PROPS
            ["Money"]={
                vector3(
                    315.323090,
                    -284.887908,
                    54.133300
                ),
                vector3(
                    311.498902,
                    -286.958252,
                    54.133300
                )
            },
            --DOOR ROTATION POSITION
            ["Rotation"]={
                249.846,
                159.846
            },
            --IS ON COOLDOWN
            ["Cooldown"]=false,
            --COOLDOWN TIME
            ["Time"]=120000,
            --IS ROB
            ["Robado"]={
                false,
                false,
                false
            },
            --STARTED
            ["Iniciado"]=false,
            --DOOR OPEN
            ["DoorOpen"]=false,
            ["Sincro"]=false,
            ["hackeado"]=false
        }
    }