*-----------------------------------------------------------
*Title      :  Dungeon Of The Dark
*Written by :  Tadgh Fitzpatrick, C00282704
*Date       :  
*Description:  A turned-based Dungeon crawler where the player tries to get as much gold as they can before they lose.
*-----------------------------------------------------------

*-------------------------------------------------------
*--------------STARTING MEMORY ADDRESS------------------
*-------------------------------------------------------
    ORG    $1000
    
*-------------------------------------------------------
*-------------------VALIDATION VALUES-------------------
*-------------------------------------------------------

COMBAT_ENC      EQU 50           ENCOUNTER NUMBER TO INITIALISE COMBAT
SHOP_ENC        EQU 80           ENCOUNTER NUMBER TO GIVE A POTION
FIFTY_FIFTY_ENC EQU 100           ENCOUNTER NUMBER TO GIVE A WEAPON
POTION_HEALING  EQU 30          HOW MUCH POTIONS HEAL
E_DAMAGE_BONUS  EQU 10          ENEMY DAMAGE INCREASE AFTER EVERY FIGHT
SWORD_COST      EQU 85          COST TO BUT A SWORD
POTION_COST     EQU 25



*-------------------------------------------------------
*-------------------START GAME--------------------------
*-------------------------------------------------------

START:
    MOVE.L  #$0000C800,D1               MOVE THE COLOUR GREEN INTO D1
    MOVE.B  #21,D0                      Load 4 into D0
    TRAP    #15                         Runs Trap 80 which changes the colour of the text
    CLR.L   D1                          CLEAR D1
    CLR.L   D0                          CLEAR D0
    BSR     WELCOME    		    BRANCH TO THE WELCOME MESSAGE, DISPLAYS SOME GAME INFO AND INTRO TO THE GAME 

WELCOME:
    LEA     WELCOME_MSG,A1      ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0              Load 14 into D0
    TRAP    #15                 RUNS TRAP #14 WHICH DISPLAYS THE MESSAGE IN A1
    
    MOVE.B  #4,D0               Load 4 into D0
    TRAP    #15                 Runs Trap 4 which asks for the users input
    
    CMP     #1,D1               Compares 1 to D1, setting Zero Flag to 1 if they're equal
    BEQ     GAME                Starts game if Zero Flag is 1
    
    CMP     #2,D1               Compares 2 to D1, setting Zero Flag to 1 if they're equal
    BEQ     COWARD              Ends game if Zero Flag is 1
    BSR     CLEAR_SCREEN        Branches to CLEAR_SCREEN which clears the screen of all text
    BRA     WELCOME             If 1 0r 2 isn't input, the WELCOME subroutine is run again until they enter 1 or 2

GAME:
    BSR     CLEAR_SCREEN        Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                 Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    LEA     DUNGEON_MSG,A1      Load address of DUNGEON_MSG into A1
    
    MOVE.B  #14,D0              Load 14 into D0
    TRAP    #15                 Runs Trap 14 which ouputs the message stored in A1, which should be DUNGEON_MSG
    
    BSR     PRESS_ENTER         Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN        Branch to CLEAR_SCREEN subroutine which clears the screen of all text
    BSR     HUD                 Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    
    BRA     GAMEPLAY            BRANCH TO GAMELOOP SUBROUTINE 
    
GAMEPLAY:
    BSR     CLEAR_SCREEN        Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                 Branch to the HUD subroutine, displaying the players Health, Potions and Gold

    CMP     #0,LOOPS
    
    ADD     #1,LOOPS            Increments Loops by 1, loops counting the amount of times Gameplay has been played
    CMP     #4,LOOPS            Compares 2 to Loops, setting the Zero Flag to 1 if they are equal
    BEQ     BOSS_COMBAT         Branches to Boss combat if Zero Flag is 1w
    
    BSR     ROLL_NUMBER    

    MOVE.W  #60,ENC_NUM           
    
    CMP.W   #(COMBAT_ENC),ENC_NUM       Compares the interger stored at COMBAT_ENC to ENC_NUM, setting Zero Flag to 1 if they're equal
    BLE     COMBAT                      Branches to COMBAT if Zero Flag is 1
    
    CMP.W   #(SHOP_ENC),ENC_NUM         Compares the interger stored at P_DISCOVERY to ENC_NUM, setting Zero Flag to 1 if they're equal
    BLE     SHOP                        Branches to NEW_POTION if Zero Flag is 1
    
    CMP.W   #(FIFTY_FIFTY_ENC),ENC_NUM  Compares the interger stored at W_DISCOVERY to ENC_NUM, setting Zero Flag to 1 if they're equal
    BLE     FIFTY_FIFTY                 Branches to NEW_POTION if Zero Flag is 1
    
    BRA     GAMEPLAY 
 
*----------------------------------------------------------------------------------------------------------------------------------------------------------------------
*------------------------------------------------------------------------GAMEPLAY ENCOUNTERS---------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------------------------------------------------------------------------

*-------------------------------------------------------
*------------------------COMBAT-------------------------
*-------------------------------------------------------
    
COMBAT:
    LEA     NORM_ENEMY_MSG,A1           Moves NORM_ENEMY_MSG to A1
    MOVE.B  #14,D0                      Moves 14 to D0
    TRAP    #15                         Runs Trap 15 to Display the message stored in A1
    ADD     #1, ENC_NUM                 Add 1 to ENC_NUM
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    BRA     COMBAT_CHOICE               Branches to COMBAT_CHOICE subroutine
    
ENEMY_CHOICE:
    MOVE    ENEMY_HEALTH,D3             MOVE ENEMY_HEALTH TO D4
    MOVE    PLAYER_DAMAGE,D4            MOVE PLAYER_DAMAGE TO D4

    CMP     #1,ENEMY_ATTACK             Compares 1 to ENEMY_ATTACK value, if they're equal it sets the Zero Flag to 1
    BEQ     ENEMY_WILL_ATTACK           Branches to the ENEMY_WILL_ATTACK subroutine if the Zero Flag is 1
    
    LEA     ENEMY_WILL_ATTACK_MSG_1,A1  Moves ENEMY_WILL_ATTACK_MSG_1 message to A1
    MOVE.B  #14,D0                      Moves 14 to D0
    TRAP    #15                         Runs trap 14 which displays the message stored in A1
    
    LEA     GAP_LINE,A1                 Moves GAP_LINE message to A1
    MOVE.B  #14,D0                      Moves 14 to D0
    TRAP    #15                         Runs trap 14 which displays the message stored in A1
    
    RTS
    
ENEMY_WILL_ATTACK:
    LEA     ENEMY_WILL_ATTACK_MSG_2,A1  Moves ENEMY_WILL_ATTACK_MSG_2 message to A1
    MOVE.B  #14,D0                      Moves 14 to D0
    TRAP    #15                         Runs trap 14 which displays
    
    LEA     GAP_LINE,A1                 MOVES GAP_LINE MESSAGE TO A1
    MOVE.B  #14,D0                      MOVES 14 TO D0
    TRAP    #15                         RUNS TRAP 14 WHICH DISPLAYS THE GAP_LINE MESSAGE
    
    ADD     #1,ENEMY_ATTACK             ADDS 1 TO ENEMY_ATTACK
    
    RTS

COMBAT_CHOICE
    BSR     ENEMY_CHOICE                TELLS THE PLAYER WHAT THE ENEMY IS PLANNING TO DO
    LEA     PW_CHOICE_MSG,A1            PW_CHOICE ASKS THE USER WHAT ACTION THEY WISH TO TAKE FROM 3 OPTIONS
    MOVE.B  #14,D0                      PUTS 14 INTO D0
    TRAP    #15                         RUNS TRAP 14 WHICH DISPLAYS THE MESSAGE IN A1
    
    MOVE    ENEMY_HEALTH,D4
    MOVE    ENEMY_MAX_HEALTH,D5
    MOVE    PLAYER_DAMAGE,D6
    
    MOVE.B  #4,D0                       
    TRAP    #15                         RUNS TRAP 4 WHICH TAKES THE USERS INPUT INTO D1
    
    MOVE    D1,D4                       MOVES D1'S CONTENTS TO D4
    
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    MOVE    D4,D1                       MOVES D4 TO D1
    
    CMP     #1,D1                       COMPARES 1 TO D1
    BEQ     COMBAT_CHOICE_ATTACK                      IF 1 IS IN D1, BRANCH TO ATTACK SUBROUTINE
    CMP     #2,D1                       COMPARES 2 TO D1
    BEQ     COMBAT_CHOICE_POTION             IF 2 IS IN D1, BRANCH TO COMBAT_CHOICE_2
    CMP     #3,D1                       COMPARES 2 TO D1
    BEQ     COMBAT_CHOICE_BLOCK             BRANCH TO COMBAT_CHOICE_3
    
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    BRA     COMBAT_CHOICE
    
COMBAT_CHOICE_ATTACK:
    LEA     PLAYER_HIT_MSG,A1           LOAD THE EFFECTIVE ADDRESS OF PLAYER_HIT_MSG TO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, WHICH WILL DISPLAY THE MESSAGE IN A1
    CLR     D3
    CLR     D0
    MOVE    PLAYER_DAMAGE,D3            MOVE ENEMY_DAMAGE TO D3
    MOVE    ENEMY_HEALTH,D0
    SUB     D3,ENEMY_HEALTH             SUBTRACT D3 FROM ENEMY_HEALTH
    
    CMP     #0,ENEMY_HEALTH             COMPARES #0 AND THE VALUE IN ENEMY_HEALTH
    BLE     COMBAT_END
    
    BRA     COMBAT_P2                   BRANCH TO COMBAT_CHOICE_3

COMBAT_CHOICE_POTION:
    BSR     CHECK_POTION                BRANCH TO CHECK_POTION, WHICH WILL CHECK IF THE USER HAS POTIONS THEY CAN CONSUME
    BRA     COMBAT_P2                   BRANCH TO COMBAT_CHOICE_3
    
    
COMBAT_CHOICE_BLOCK:
    CMP     #3,D1                       COMPARES #3 AND THE VALUE IN D1
    BEQ     BLOCK_NORM_ATTACK           BRANCHES TO BLOCK_NORM_ATTACK, WHICH WILL REDUCE THE DAMAGE OF THE NEXT ATTACK THE PLAYER TAKES

COMBAT_P2:
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text.
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold              
    
    CMP     #0,ENEMY_HEALTH             COMPARES #0 AND THE VALUE IN ENEMY_HEALTH
    BLE     COMBAT_END
    
    CMP     #1,ENEMY_ATTACK             COMPARES #0 AND THE VALUE IN ENEMY_ATTACK
    BEQ     ENEMY_ATTACK_1              BRANCHES TO ENEMY_ATTACK_1, THE ENEMY WILL DO A NORMAL ATTACK
    
    CMP     #2,ENEMY_ATTACK             COMPARES #0 AND THE VALUE IN ENEMY_ATTACK
    BEQ     ENEMY_ATTACK_2              BRANCHES TO ENEMY_ATTACK_2, THE ENEMY CHARGES UP A BIG ATTACK
    
    CMP     #3,ENEMY_ATTACK             COMPARES #0 AND THE VALUE IN ENEMY_ATTACK
    BEQ     ENEMY_ATTACK_3              BRANCHES TO ENEMY_ATTACK_3, THE ENEMY WILL DO THEIR BIG ATTACK
    
ENEMY_ATTACK_1:
    LEA     ENEMY_ATTACK_MSG,A1         ENEMY_ATTACK_MSG DESCRIBES THE ENEMIES ATTACK
    MOVE.B  #14,D0                      MOVES 14 INTO D0
    TRAP    #15                         DISPLAYS MESSAGE AT THE ADDRESS STORED INT A1

    MOVE    ENEMY_DAMAGE,D3             MOVES ENEMY_DAMAGE INTO D3
    SUB     BLOCK,D3                    TAKES WHATEVER VALUE IS IN BLOCK AND TAKES IT AWAY FROM D3
    SUB     D3,HEALTH                   TAKES D3 AWAY FROM HEALTH
    
    MOVE    #0,BLOCK                    MOVES 0 TO BLOCK TO RESET RESETS BLOCK TO 0
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    CMP     #$0,HEALTH                  COMPARE 0 TO HEALTH
    BLE     DEATH_SCREEN                IF THEIR HEALTH IS EQUAL TO OR BELOW 0, BRANCH TO DEATH SCREEN

    ADD     #1,ENEMY_ATTACK             ADD 1 TO ENEMY_ATTACK
    BRA     COMBAT_CHOICE               BRANCH TO COMBAT CHOICE
    
ENEMY_ATTACK_2:
    LEA     ENEMY_PAUSE_MSG,A1          LOAD THE EFFECTIVE ADDRESS OF ENEMY_PAUSE_MSG INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 INT D0, OUTPUTS ENEMY_PAUSE_MSG
    
    ADD     #1,ENEMY_ATTACK             ADD 1 TO ENEMY_ATTACK
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    BRA     COMBAT_CHOICE               BRANCH TO COMBAT_CHOICE
    
ENEMY_ATTACK_3:
    LEA     ENEMY_ATTACK_MSG,A1         LOAD THE EFFECTIVE ADDRESS OF ENEMY_ATTACK_MSG TO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, WHICH WILL DISPLAY THE MESSAGE IN A1

    MOVE    ENEMY_DAMAGE,D3             MOVE ENEMY_DAMAGE TO D3
    SUB     BLOCK,D3                    SUBTRACT BLOCK FROM D3
    SUB     D3,HEALTH                   SUBTRACT D3 FROM (PLAYER)HEALTH
    
    MOVE    #0,BLOCK                    MOVE 0 TO BLOCK, RESETING IT TO 0
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    CMP     #0,HEALTH                   COMPARE 0 TO HEALTH
    BLE     DEATH_SCREEN                BRANCH TO DEATH_SCREEN IF HEALTH IS >= 0

    MOVE    #1,ENEMY_ATTACK             MOVE 1 TO ENEMY_ATTACK
    BRA     COMBAT_CHOICE               BRANCH TO COMBAT_CHOICE
    
COMBAT_END:
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold

    LEA     MONSTER_SLAIN,A1            LOAD THE EFFECTIVE ADDRESS OF MONSTER_SLAIN INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, WHIHC WILL DISPLAY THE MESSAGE STORED IN MONSTER_SLAIN
    
    MOVE    E_HEALTH_BONUS,D3               MOVE E_HEALTH_BONUS TO D3
    ADD     D3,ENEMY_MAX_HEALTH             ADD 10 TO MAX HEALTH
    ADD     #10,E_HEALTH_BONUS
    MOVE.W  ENEMY_MAX_HEALTH,ENEMY_HEALTH   MOVE ENEMY_MAX_HEALTH, ENEMY_HEALTH
    
    ADD     #15,GOLD                        ADD 15 TO GOLD
    ADD     #(E_DAMAGE_BONUS),ENEMY_DAMAGE  ADD 10 TO ENEMY_DAMAGE
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    BSR     NEW_POTION                  BRANCH TO NEW_POTION
    BSR     NEW_WEAPON                  BRANCH TO NEW_WEAPON
    
    BSR     POTION_OFFER                Branches to POTION_OFFER, offering the user to use a potion

    BRA     GAMEPLAY                    BRANCH TO GAMEPLAY

BLOCK_NORM_ATTACK:
    
    LEA     PLAYER_BLOCKING_MSG,A1      LOAD THE EFFECTIVE ADDRESS OF PLAYER_BLOCKING_MSG INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE IN A1
    MOVE    ENEMY_DAMAGE,D3             MOVE ENEMY_DAMAGE TO D3
    DIVU    #2,D3                       DIVIDE D3 BY 2
    MOVE    D3,BLOCK                    MOVE D3 TO BLOCK
    MOVE    #4,D1                       MOVE 4 TO D1
    BRA     COMBAT_P2             BRA TO COMBAT_CHOICE_3
    
    
*-------------------------------------------------------
*----------------------SHOP-----------------------------
*-------------------------------------------------------
SHOP:
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    LEA     SHOP_MSG,A1                 LOAD THE EFFECTIVE ADDRESS OF SHOP_MSG INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE IN A1
    
    MOVE.B  #4,D0                       
    TRAP    #15                         RUNS TRAP 4 WHICH TAKES THE USERS INPUT INTO D1
    
    CMP     #1,D1                       COMPARE 1 TO D1
    BEQ     SHOP_BUY_SWORD              BRANCH IF 1 EQUALS TO D1
    
    CMP     #2,D1                       COMPARE 3 TO D1                       
    BEQ     SHOP_BUY_POTION              BRANCH IF 2 EQUALS TO D1
    
    CMP     #3,D1                       COMPARE 3 TO D1
    BEQ     SHOP_EXIT                   BRANCH IF 3 EQUALS TO D1

    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    BSR     POTION_OFFER                Branches to POTION_OFFER, offering the user to use a potion
    
    BRA     SHOP                        BRANCH TO SHOP
    
SHOP_BUY_SWORD:
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    MOVE    #84,COST                    MOVE 84 TO COST
    BSR     CHECK_GOLD                  BRANCH TO CHECK_GOLD SUBROUTINE
    
    SUB     #(SWORD_COST),GOLD          SUBTRACT VALUE AT ADDRESS SWORD_COST FROM GOLD
    BSR     NEW_WEAPON                  BRANCH TO NEW_WEAPON SUBROUTINE
    BRA     SHOP                        BRANCH  TO SHOP

        
SHOP_BUY_POTION:
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    MOVE    #24,COST                    MOVE 24 TO COST
    BSR     CHECK_GOLD                  BRANCH TO CHECK_GOLD SUBROUTINE
    
    SUB     #(POTION_COST),GOLD         SUBTRACT VALUE AT ADDRESS POTION_COST FROM GOLD
    BSR     NEW_POTION                  BRANCH TO NEW_POTION SUBROUTINE
    BSR     POTION_OFFER                Branches to POTION_OFFER, offering the user to use a potion
    
    BRA     SHOP                        BRANCH TO SHOP
 
CHECK_GOLD:
    MOVE    COST,D3                     MOVE COST TO D3
    MOVE    GOLD,D4                     MOVE GOLD TO D4
    SUB     D3,D4                       SUBTRACT D3 FROM D4

    CMP     #0,D4                       COMPARE 0 TO D4
    BLE     NOT_ENOUGH                  BRANCH TO NOT_ENOUGH IF D4 <= 0
    
    RTS
    
NOT_ENOUGH:
    LEA     NOT_ENOUGH_MSG,A1           LOAD THE EFFECTIVE ADDRESS OF NOT_ENOUGH_MSG TO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0 WHICH OUPUTS THE MESSAGE IN A1
    
    BSR     PRESS_ENTER                 BRANCH TO PRESS_ENTER
    BSR     CLEAR_SCREEN                BRANCH TO CLEAR_SCREEN
    BSR     HUD                         BRANCH TO HUD
    
    BRA     SHOP                        BRANCH TO SHOP
    
        
SHOP_EXIT:
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold

    LEA     LEAVE_SHOP_MSG,A1           LOAD THE EFFECTIVE ADDRESS OF LEAVE_SHOP_MSG TO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0 WHICH OUPUTS THE MESSAGE IN A1
    
    BSR     PRESS_ENTER
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    BSR     POTION_OFFER        Branches to POTION_OFFER, offering the user to use a potion
        
    BRA     GAMEPLAY
*-------------------------------------------------------
*-------------------FIFTY_FIFTY-------------------------
*-------------------------------------------------------
FIFTY_FIFTY:
    LEA     FIFTY_FIFTY_MSG,A1          LOAD THE EFFECTIVE ADDRESS OF SHOP_MSG INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE IN A1
    
    MOVE.B  #4,D0                       MOVE 4 TO D0
    TRAP    #15                         RUN TRAP 4 FROM D0 TO TAKE THE USERS INPUT
    
    CMP     #1,D1                       COMPARE 1 TO D1
    BEQ     TAKE_CHANCE                 BRANCH TO TAKE_CHANCE IF D1 = 0
    
    CMP     #2,D1                       COMPARE 2 TO D1
    BEQ     TAKE_CHANCE_2               BRANCH TO TAKE_CHANCE_2 IF D1 = 2
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    BRA     FIFTY_FIFTY                 BRANCH TO FIFTY_FIFTY
    
TAKE_CHANCE:
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold

    CMP.W   #49,GOLD                    COMPARE 49 TO GOLD
    BLE     NOT_FIFTY                   BRANCH TO NOT_FIFTY IF GOLD <= 49
    
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    LEA     TOOK_CHANCE,A1              LOAD THE EFFECTIVE ADDRESS OF TOOK_CHANCE_MSG INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE IN A1
    
    BSR     ROLL_NUMBER                 BRANCH TO ROLL_NUMBER

    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold               
        
    CMP.W   #50,ENC_NUM                 COMPARE 50 TO ENC_NUM
    BLE     SUCCESS                     BRANCH TO SUCCESS IF ENC_NUM <= 50
    
    BRA     FAILURE                     BRANCH TO FAILURE
    
NOT_FIFTY:
    LEA     NOT_FIFTY_MSG,A1            LOAD THE EFFECTIVE ADDRESS OF NOT_FIFTY_MSG INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE IN A1
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    
    BRA     GAMEPLAY                    BRANCH TO GAMEPLAY
    
        
SUCCESS
    LEA     FIFTY_FIFTY_SUCCESS_MSG,A1  LOAD THE EFFECTIVE ADDRESS OF FIFITY_FIFTY_SUCCESS_MSG INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE IN A1
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    ADD     #50,GOLD

    BRA     GAMEPLAY
    
FAILURE:
    LEA     FIFTY_FIFTY_FAILURE_MSG,A1  LOAD THE EFFECTIVE ADDRESS OF FIFITY_FIFTY_SUCCESS_MSG INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE IN A1
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    CMP.W   #49,GOLD                    Compare 49 to GOLD       
    BLE     RESET_GOLD                  BRANCH IF LESS THAN OR EQUAL TO 49 
    
    SUB.W   #50,GOLD                    SUBTRACT 50 FROM GOLD

    BRA     GAMEPLAY                    BRANCH TO GAMEPLAY
    
RESET_GOLD:
    MOVE.W  #0, GOLD                    MOVE 0 TO GOLD
    
    BRA     GAMEPLAY                    BRANCH TO GAMEPLAY

TAKE_CHANCE_2:
    LEA     TAKE_CHANCE_2_MSG,A1        LOAD THE EFFECTIVE ADDRESS OF TAKE_CHANCE_2_MSG INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE IN A1
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    
    BRA     GAMEPLAY                    BRANCH TO GAMEPLAY

*-------------------------------------------------------
*-------------------BOSS COMBAT-------------------------
*-------------------------------------------------------
    
BOSS_COMBAT:
    MOVE.W  ENEMY_HEALTH,D2             BOSS HEALTH
    MOVE.W  ENEMY_DAMAGE,D4             BOSS DAMAGE
    
    MOVE    ENEMY_HEALTH,D7             MOVE ENEMY_HEALTH TO D7
    DIVU    #10,D7                      DIVIDE D7 BY 10
    MULU    #2,D7
    ADD.W   D7,D2                       ADD D7 TO D2(BOSS_HEALTH)
    MOVE.W  D2,BOSS_HEALTH              BOSS HEALTH
    
    MOVE    ENEMY_DAMAGE,D7             MOVE ENEMY_DAMAGE TO D7
    MOVE.W   D7,BOSS_DAMAGE                       ADD D7 TO D4

    LEA     BOSS_ENEMY_MSG_1,A1         LOAD THE EFFECTIVE ADDRESS OF BOSS_ENEMY_MSG_1 INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    
    CLR.L   D2                          CLEAR D1
    MOVE.L  #$001B8FDD,D1               store the hex for the colour WHITE in d1
    MOVE.B  #21,D0                      Load 4 into D0
    TRAP    #15                         Runs Trap 21 which changes the colour of the text to the colour stored in D1
    CLR.L   D1                          CLEAR D1
    CLR.L   D0                          CLEAR D0
    LEA     BOSS_ENEMY_MSG_2,A1         LOAD THE EFFECTIVE ADDRESS OF BOSS_ENEMY_MSG_2 INTO A1
    MOVE.B  #14,D0                      MOVE 14 INTO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1 
    
    BSR     MAIN_COLOUR                 RESETS COLOUR TO THE COLOUR IN MAIN_COLOUR
    LEA     BOSS_ENEMY_MSG_3,A1         LOAD THE EFFECTIVE ADDRESS OF BOSS_ENEMY_MSG_2 INTO A1
    MOVE.B  #14,D0                      MOVE 14 INTO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1                          
    
    BRA     BOSS_COMBAT_CHOICE          BRANCH TO BOSS_COMBAT_CHOICE

BOSS_COMBAT_CHOICE
    LEA     PW_CHOICE_MSG,A1
    MOVE.B  #14,D0                      Load 14 into D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    MOVE.B  #4,D0                       Load 4 into D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    MOVE    D1,D4
    
    BSR CLEAR_SCREEN                    Branch to CLEAR_SCREEN which clears the screen of all text
    BSR HUD                             Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    MOVE    D4,D1
    
    CMP     #1,D1                       COMPARE 1 TO D1
    BEQ     BOSS_COMBAT_CHOICE_ATTACK   BRANCH TO ATTACK_BOSS IF 1 = D1
    CMP     #2,D1                       COMPARE 3 TO D1
    BEQ     BOSS_COMBAT_CHOICE_POTION   BRANCH TO BOSS_COMBAT_CHOICE IF 3 = D1
    CMP     #3,D1
    BEQ     BOSS_COMBAT_CHOICE_BLOCK
    
    BRA     BOSS_COMBAT_CHOICE
    
BOSS_COMBAT_CHOICE_ATTACK:
    LEA     PLAYER_HIT_MSG,A1
    MOVE.B  #14,D0                      MOVE 14 into D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    CLR     D3
    CLR     D0
    
    MOVE    BOSS_DAMAGE,D3              MOVE BOSS_DAMAGE TO D3
    SUB     D3,BOSS_HEALTH              SUBTRACT D3 TO BOSS_HEALTH
    MOVE    BOSS_HEALTH,D3              MOVE BOSS_HEALTH TO D3
    
    CMP     #0,ENEMY_HEALTH             COMPARES #0 AND THE VALUE IN ENEMY_HEALTH
    BLE     COMBAT_END                  BRANCH TO COMBAT END IF ENEMY_HEALTH <= 0
    
    BRA     BOSS_COMBAT_P2              BRANCH TO BOSS_COMBAT_P2

BOSS_COMBAT_CHOICE_POTION:
    BSR     CHECK_POTION                BRANCH TO _CHECK_POTION
    BRA     BOSS_COMBAT_P2              BRANCH TO BOSS_COMBAT_CHOICE_3
    
    
BOSS_COMBAT_CHOICE_BLOCK:
    LEA     PLAYER_BLOCKING_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    MOVE    BOSS_DAMAGE,D3              MOVE BOSS_DAMAGE TO D3
    DIVU    #2,D3                       DIVIDE D3 BY 2
    MOVE    D3,BLOCK                    MOVE D3 TO BLOCK
    MOVE    #4,D1                       MOVE 4 TO D1
    BRA     BOSS_COMBAT_P2              BRANCH TO BOSS_COMBAT_P2

BOSS_COMBAT_P2:
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    CMP     #0,BOSS_HEALTH              COMPARE 0 TO BOSS_HEALTH
    BLE     BOSS_COMBAT_END             BOSS_COMBAT_END
    
    MOVE.B  ENEMY_MAX_HEALTH,D3
    MOVE.B  ENEMY_HEALTH,D4
    CMP     D3,D4         COMPARES #0 AND THE VALUE IN ENEMY_HEALTH
    BCS     COMBAT_END
    
    CMP     #1,BOSS_ATTACK              COMPARE 1 TO BOSS_ATTACK
    BEQ     BOSS_ATTACK_1               BRANCH TO BOSS_ATTACK_1 IF BOSS_ATTACK = 1
    
    CMP     #2,BOSS_ATTACK              COMPARE 2 TO BOSS_ATTACK
    BEQ     BOSS_ATTACK_2               BRANCH TO BOSS_ATTACK_2 IF BOSS_ATTACK = 2
    
    CMP     #3,BOSS_ATTACK              COMPARE 3 TO BOSS_ATTACK
    BEQ     BOSS_ATTACK_3               BRANCH TO BOSS_ATTACK_3 IF BOSS_ATTACK = 3
  
BOSS_ATTACK_1:
    LEA     ENEMY_ATTACK_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1

    MOVE    BOSS_DAMAGE,D3
    SUB     BLOCK,D3                    SUBTRACT BLOCK FROM D3
    SUB     D3,HEALTH                   SUBTRACT D3 FROM HEALTH
    
    MOVE    #0,BLOCK
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    CMP     #0,HEALTH                   COMPARE HEALTH TO 0
    BLE     DEATH_SCREEN                BRANCH TO DEATH_SCREEN IF HEALTH <= 0

    ADD     #1,BOSS_ATTACK              ADD 1 TO BOSS_ATTACK
    BRA     BOSS_COMBAT_CHOICE          BRANCH TO BOSS_COMAT CHOICE
    
BOSS_ATTACK_2:
    LEA     BOSS_CHARGE_MSG,A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    ADD     #1,BOSS_ATTACK              ADD 1 TO BOSS_ATTACK
    BRA     BOSS_COMBAT_CHOICE          BRANCH BOSS_COMBAT_CHOICE

BOSS_ATTACK_3:
    
    LEA     BIG_ATTACK_MSG,A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    MOVE    BOSS_DAMAGE,D3              MOVE BOSS_DAMAGE TO D3
    MOVE    CHARGE_ATTACK_DMG,D4
    ADD     D4,D3
    SUB     BLOCK,D3                    SUBTRACT BLOCK FROM D3
    SUB     D3,HEALTH                   SUBTRACT D3 FROM HEALTH
    
    MOVE    #0,BLOCK                    MOVE 0 TO BLOCK, RESETING IT
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    CLR     BOSS_ATTACK                 CLEAR BOSS_ATTACK
    CLR     D3                          CLEAR D3
    CLR     D4                          CLEAR D4
    
    CMP     #0,HEALTH                   CMP 0 TO HEALTH
    BLE     DEATH_SCREEN                BRANCH TO DEATH_SCREEN IF HEALTH IS <= 0
    
    
    BRA BOSS_COMBAT_CHOICE              BRANCH TO BOSS_COMBAT_CHOICE
    
BOSS_COMBAT_END:
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold

    LEA     BOSS_SLAIN,A1
    MOVE.B  #14,D0                      MOVE 14 into D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    ADD     #100,GOLD                   ADD 100 GOLD
    MOVE    #0,LOOPS                    MOVE 0 TO LOOPS, RESETING IT
    ADD     #10,CHARGE_ATTACK_DMG
    
    MOVE.B  #4,D0                       MOVE 4 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    CMP     #1,D1                       COMPARE 1 TO D1
    BEQ     GAMEPLAY
    CMP     #2,D1                       COMPARE 2 TO D1
    BEQ     WIN                         BRANCH TO WIN IF D1 = 2
    BRA     GAMEPLAY                    BRANCH TO GAMEPLAY


*-------------------------------------------------------
*-------------------NEW EQUIPMENT-----------------------
*------------------------------------------------------- 

NEW_POTION:
    ADD     #1,POTIONS                  ADD 1 TO POTIONS
    LEA     NEW_POTION_MSG,A1           LOAD THE EFFECTIVE ADDRESS OF TOOK_CHANCE_MSG INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    RTS

NEW_WEAPON:
    ADD     #10,PLAYER_DAMAGE           ADD 10 TO PLAYER_DAMAGE
    LEA     NEW_WEAPON_MSG,A1           LOAD THE EFFECTIVE ADDRESS OF NEW_WEAPON_MSG INTO A1
    MOVE.B  #14,D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    MOVE.W  PLAYER_DAMAGE,D1            RETRIEVE THE VALUE PLAYER_DAMAGE AND MOVE TO D1
    MOVE.B  #3,D0                       MOVE LITERAL 3 TO D0
    TRAP    #15                         INTREPRET VALUE IN D0, WHICH 3 WHICH DISPLAYS D1
    LEA     NEXT_LINE_MSG,A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    BSR     PRESS_ENTER                 Branch to PRESS_ENTER subroutine which pauses the text so the user can read until they input something
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    BSR     HUD                         Branch to the HUD subroutine, displaying the players Health, Potions and Gold
    
    RTS 

*-------------------------------------------------------
*----------------------ACTIONS--------------------------
*-------------------------------------------------------    
    
POTION_OFFER:
    LEA     POTION_OFFER_MSG,A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    MOVE.B  #4,D0                       MOVE 4 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1 
    CMP     #$1,D1
    BEQ     CHECK_POTION
    RTS
    
CHECK_POTION:
    CMP     #0,POTIONS                  COMPARE 0 TO POTIONS
    BNE     DRINK_POTION                DRINK_POTION
    LEA     NO_POTION_MSG,A1            NO_POTION_MSG
    MOVE.B  #14,D0                      Load 14 into D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    RTS
    
*----------------------------------------------------------------------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------OPERATIONS----------------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------------------------------------------------------------------------
    
ROLL_NUMBER:
    MOVE.B #8, D0 	                    Loads D1 with Time in 100's of Seconds since midnight (6 Bits)
    TRAP #15  		                    Place time in D1

    AND.L   #$5FFFFF, D1 	            AND 6 Bits to prevent any overflow
    DIVU    #100, D1 	                Divide by 100, 1000, 10000 depending on Number range required
    SWAP    D1 		                    SWAP Higher Order Word and Lower Order Word in D1
    ADDQ.W  #1, D1 	                    Add 1 to D1.W so number is at least 1
    MOVE.W  D1, D2 	                    Extract the number from D1.W
    CLR.L   D1 		                    Clear contents of D1
    MOVE.W  D2, D1 	                    Move the generated number to D1
    MOVE.W  D1,ENC_NUM
    
    RTS
    
DRINK_POTION:
    MOVE    #(POTION_HEALING),D4        MOVE THE VALUE IN POTION_HEALING TO D4
    ADD     D4,HEALTH                   ADD D4 TO HEALTH
    SUB     #1,POTIONS                  SUBTRACT 1 FROM POTIONS
    
    LEA     POTION_USED_MSG,A1          LOAD THE EFFECTIVE ADDRESS OF POTION_USED INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         TRAP 15
    
    RTS                                 RETURN TO SUBROUTINE
    
PRESS_ENTER:
    LEA     PRESS_ENTER_MSG,A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    MOVE.B  #4,D0                       MOVE 4 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    RTS
    
HUD:
    CLR     D2                          CLEARS D2
    MOVE.L  #$00FFFFFF,D1               store the hex for the colour WHITE in d1
    MOVE.B  #21,D0                      Load 4 into D0
    TRAP    #15                         Runs Trap 21 which changes the colour of the text to the colour stored in D1
    CLR.L   D1                          CLEAR D1
    CLR.L   D0                          CLEAR D0
    
    MOVE.L  #$000000FF,D1               store the hex for the colour RED  in d1
    MOVE.B  #21,D0                      Load 4 into D0
    TRAP    #15                         Runs Trap 21 which changes the colour of the text to the colour stored in D1
    CLR.L   D1                          CLEAR D1
    CLR.L   D0                          CLEAR D0
    
    LEA     HUD_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    MOVE.L  #$00FFFFFF,D1               store the hex for the colour WHITE in d1
    MOVE.B  #21,D0                      Load 4 into D0
    TRAP    #15                         Runs Trap 21 which changes the colour of the text to the colour stored in D1
    CLR.L   D1                          CLEAR D1
    CLR.L   D0                          CLEAR D0
    
    MOVE.W  HEALTH,D1                   RETRIEVE THE VALUE HEALTH AND POINT TO AND MOVE TO D1
    MOVE.B  #3,D0                       MOVE LITERAL 3 TO D0
    TRAP    #15                         INTREPRET VALUE IN D0, WHICH 3 WHICH DISPLAYS D1
    LEA     NEXT_LINE_MSG,A1
    MOVE.B  #14,D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    MOVE.L  #$00FF00CA,D1               store the hex for the colour RED in d1
    MOVE.B  #21,D0                      Load 4 into D0
    TRAP    #15                         Runs Trap 21 which changes the colour of the text to the colour stored in D1
    CLR.L   D1                          CLEAR D1
    CLR.L   D0                          CLEAR D0
    LEA     HUD_MSG_2,A1       
    MOVE.B  #14,D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    MOVE.L  #$00FFFFFF,D1               store the hex for the colour WHITE in d1
    MOVE.B  #21,D0                      Load 4 into D0
    TRAP    #15                         Runs Trap 21 which changes the colour of the text to the colour stored in D1
    CLR.L   D1                          CLEAR D1
    CLR.L   D0                          CLEAR D0
    MOVE.W  POTIONS,D1                  RETRIEVE THE VALUE POTIONS AND POINT TO AND MOVE TO D1
    MOVE.B  #3,D0                       MOVE LITERAL 3 TO D0
    TRAP    #15                         INTREPRET VALUE IN D0, WHICH 3 WHICH DISPLAYS D1
    
    LEA     NEXT_LINE_MSG,A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, OUTPUTTING THE MESSAGE IN A1 TO THE SCREEN
    
    MOVE.L  #$0017B6E4,D1               store the hex for the colour GOLD in d1
    MOVE.B  #21,D0                      Load 4 into D0
    TRAP    #15                         Runs Trap 21 which changes the colour of the text to the colour stored in D1
    CLR.L   D1                          CLEAR D1
    CLR.L   D0                          CLEAR D0
    LEA     HUD_MSG_3,A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    MOVE.L  #$00FFFFFF,D1               store the hex for the colour WHITE in d1
    MOVE.B  #21,D0                      Load 4 into D0
    TRAP    #15                         Runs Trap 21 which changes the colour of the text to the colour stored in D1
    CLR.L   D1                          CLEAR D1
    CLR.L   D0                          CLEAR D0
    MOVE.W  GOLD,D1                     RETRIEVE THE VALUE POTIONS AND POINT TO AND MOVE TO D1
    MOVE.B  #3,D0                       MOVE LITERAL 3 TO D0
    TRAP    #15                         INTREPRET VALUE IN D0, WHICH 3 WHICH DISPLAYS D1
    LEA     NEXT_LINE_MSG,A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    BSR     MAIN_COLOUR                 BRANCH TO MAIN_COLOUR
    
    LEA     GAP_LINE,A1                 LOAD THE EFFECTIVE ADDRESS OF GAP_LINE INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    RTS
    
CLEAR_SCREEN: 
    MOVE.B  #11,D0                      CLEAR SCREEN
    MOVE.W  #$FF00,D1                   IF YOU RUN TRAP 11 WHILE #$FF00 IS IN D1, IT CLEARS THE SCREEN OF ALL TEXT
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    RTS    
    
MAIN_COLOUR:
    MOVE.L  #$0000C800,D1               MOVE THE COLOUR GREEN INTO D1
    MOVE.B  #21,D0                      Load 4 into D0
    TRAP    #15                         Runs Trap 80 which changes the colour of the text
    CLR.L   D1                          CLEAR D1
    CLR.L   D0                          CLEAR D0
    RTS
   
    
*-------------------------------------------------------
*-------------------END SCEENS--------------------------
*-------------------------------------------------------
COWARD:
    LEA     COWARD_MSG,A1               ASSIGN MESSAGE TO ADDRESS REGISTER A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    BRA     END    
    
DEATH_SCREEN:
    MOVE.L  #$000000FF,D1               Store the hex for the colour WHITE in d1
    MOVE.B  #21,D0                      Load 4 into D0
    TRAP    #15                         Runs Trap 21 which changes the colour of the text to the colour stored in D1
    CLR.L   D1                          CLEAR D1
    CLR.L   D0                          CLEAR D0
    
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    LEA     DEATH_MSG,A1                LOAD THE EFFECTIVE ADDRESS OF DEATH_MSG INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    BRA     END
   
WIN:
    BSR     CLEAR_SCREEN                Branch to CLEAR_SCREEN which clears the screen of all text
    
    CLR.L   D2                          CLEAR D2
    MOVE.L  #$0017B6E4,D1               Store the hex for the colour GOLD in d1
    MOVE.B  #21,D0                      Load 4 into D0
    TRAP    #15                         Runs Trap 21 which changes the colour of the text to the colour stored in D1
    CLR.L   D1                          CLEAR D1
    CLR.L   D0                          CLEAR D0
    
    LEA     WIN_MSG_1,A1                LOAD THE EFFECTIVE ADDRESS OF WIN_MSG_1 INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    MOVE.W  HEALTH,D1                   MOVE HEALTH TO D1
    MOVE.B  #3,D0                       MOVE 3 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    LEA     NEXT_LINE_MSG,A1            LOAD THE EFFECTIVE ADDRESS OF NEXT_LINE_MSG INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    LEA     WIN_MSG_2,A1                LOAD THE EFFECTIVE ADDRESS OF WIN_MSG_2 INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    MOVE.W  POTIONS,D1                  MOVE POTIONS TO D1
    MOVE.B  #3,D0                       MOVE 3 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    
    LEA     WIN_MSG_3,A1                LOAD THE EFFECTIVE ADDRESS OF WIN_MSG_3 INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    LEA     WIN_MSG_4,A1                LOAD THE EFFECTIVE ADDRESS OF WIN_MSG_4 INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    MOVE.W  GOLD,D1                     MOVE GOLD TO D1
    MOVE.B  #3,D0                       MOVE 3 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    LEA     NEXT_LINE_MSG,A1            LOAD THE EFFECTIVE ADDRESS OF NEXT_LINE_MSG INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    LEA     NEXT_LINE_MSG,A1            LOAD THE EFFECTIVE ADDRESS OF NEXT_LINE_MSG INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    LEA     WIN_MSG_5,A1                LOAD THE EFFECTIVE ADDRESS OF WIN_MSG_5 INTO A1
    MOVE.B  #14,D0                      MOVE 14 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1
    
    MOVE.W  HEALTH,D4                   MOVE.W HEALTH TO D4
    ADD     D4,SCORE                    ADD D4 TO SCORE
    
    MOVE.W  POTIONS,D4                  MOVE POTIONS TO D4
    MULU    #10,D4                      MULTIPLY D4 BY 10
    ADD     D4,SCORE                    ADD D4 TO SCORE
    
    MOVE.W  GOLD,D4                     MOVE GOLD TO D4
    ADD     D4,SCORE                    ADD D4 TO SCORE
    
    
    MOVE.W  SCORE,D1                    MOVE SCORE TO D1
    MOVE.B  #3,D0                       MOVE 3 TO D0
    TRAP    #15                         RUN TRAP 14 FROM D0, DISPLAYS THE MESSAGE STORED IN A1


    BRA     END                         BRANCH TO END
    
END:

    SIMHALT             ; halt simulator

*-------------------------------------------------------
*-------------------DATA DELARATIONS--------------------
*-------------------------------------------------------
BIG_ATTACK_MSG:
                    DC.B    'BOOM!'
                    DC.B    $0D,$0A
                    DC.B    'The Creatures limbs rush forward almost too fast to see!'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    'They slam into you, dealing MASSIVE damage!'
                    DC.B    $0D,$0A,0

BOSS_CHARGE_MSG:
                    DC.B    'The creature pulls its appendages back!'
                    DC.B    $0D,$0A
                    DC.B    'The creature starts to make a WINDING UP sound.'
                    DC.B    $0D,$0A,0

BOSS_ENEMY_MSG_1:   DC.B    'You come to the end of the dark corridor, a tall dusty door.'
                    DC.B    $0D,$0A
                    DC.B    'With no other options you push open the ancient barrier to'
                    DC.B    $0D,$0A
                    DC.B    'reveal an empty room, save for the small chest at its center.'
                    DC.B    $0D,$0A
                    DC.B    'You enter the room and reach to open the container when'
                    DC.B    $0D,$0A
                    DC.B    'a chill runs down your spine.'
                    DC.B    $0D,$0A,0
                    
BOSS_SLAIN:         DC.B    'You........YOU DID IT! YOU DEFEATED THE CREATURE!'
                    DC.B    $0D,$0A                
                    DC.B    'Despite your victory and the creature fading away,'
                    DC.B    $0D,$0A 
                    DC.B    'that wicked grin will never leave your mind.'
                    DC.B    $0D,$0A
                    DC.B    'Either way you take the treasure in the chest, a handful of gold.'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    '+100 GOLD!'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    'Theres a door behind the chest going further into the Dungeon'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    '*************************************************************************'
                    DC.B    $0D,$0A
                    DC.B    '[1]KEEP GOING.'
                    DC.B    $0D,$0A
                    DC.B    '[2]TURN AROUND AND LEAVE.'
                    DC.B    $0D,$0A,0
      
                
                    
BOSS_ENEMY_MSG_2:   DC.B    '.|||/^^^^^^^^^^^^\\\\||||||||||||||//////^^^^^^^^^^^^^^^^^^^^\|||||||||||||/'
                    DC.B    $0D,$0A
                    DC.B    '.||||\               \||||||||||||/                        \|||||||||||/'
                    DC.B    $0D,$0A
                    DC.B    '.|                       *\||**                             |||||||||||/ '
                    DC.B    $0D,$0A
                    DC.B    '.\||||||||\______           ||\\                            /|||||||||||/  '
                    DC.B    $0D,$0A
                    DC.B    '   \||||||||||||||||/,     ^|||||\oo\\,,,    ,/||/,,,,,,,/|||||||||||||/    '
                    DC.B    $0D,$0A
                    DC.B    '     \|||||||||||/        |||||||            /|||||||||||||||||||||/      '
                    DC.B    $0D,$0A
                    DC.B    '        \|||||\             ||||||||......,/|||||||||||||||||||||||/        '
                    DC.B    $0D,$0A
                    DC.B    '          \\\               |||||||||||\ooo||||||||||||||||||||||/          '
                    DC.B    $0D,$0A
                    DC.B    '             \\             |||||||||||// ,, ,, ,,    /||||||||/            '
                    DC.B    $0D,$0A
                    DC.B    '       \                    |||||||//  ,,\/ \/ \/   ||||||||/              '
                    DC.B    $0D,$0A
                    DC.B    '          \\              ^\||||//^,, \/  /\ /\  ||||||||/                '
                    DC.B    $0D,$0A 
                    DC.B    '             \\                  \/  \/  /\ '' '' |||||||/                  '
                    DC.B    $0D,$0A
                    DC.B    '               \\\                 /\  /\''   ||||||||/                      '
                    DC.B    $0D,$0A
                    DC.B    '                 \\\               ''  '' ||||||||/                       '
                    DC.B    $0D,$0A
                    DC.B    '                    \\\      ||||||||||||||||||/                          '
                    DC.B    $0D,$0A
                    DC.B    '                       \\        \\\|||||||/                            '
                    DC.B    $0D,$0A
                    DC.B    '                         \\       ||||||/                             '
                    DC.B    $0D,$0A
                    DC.B    '                            ''****                              '
                    DC.B    $0D,$0A,0

BOSS_ENEMY_MSG_3                    DC.B    'You turn to see a grin, a truelly horrible grin.'
                    DC.B    $0D,$0A
                    DC.B    'Malevolence dripping from its motionless gaze.'
                    DC.B    $0D,$0A
                    DC.B    'You grit your teeth and ready your blade.'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A,0
               
COWARD_MSG:         DC.B    'If the great heroes of old failed, theres no point in trying.'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    'YOU CHOSE TO LEAVE.'
                    DC.B    $0D,$0A,0
       
DUNGEON_MSG:        DC.B    'You walk through the entrance and down the old stone steps.'
                    DC.B    $0D,$0A
                    DC.B    'The light from the entrance becoming a spec in te distance.'
                    DC.B    $0D,$0A
                    DC.B    'Reaching the bottom, you light your torch before beggining your'                
                    DC.B    $0D,$0A
                    DC.B    'march along a seemingly infinite hallway.'
                    DC.B    $0D,$0A,0         

DEATH_MSG:          DC.B    '**********************************************************************************'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    '                                   YOU DIED.'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A 
                    DC.B    '***********************************************************************************'
                    DC.B    $0D,$0A,0
                
ENEMY_ATTACK_MSG:   DC.B    'One of the enemies amorphous arms pierces the darkness!'
                    DC.B    $0D,$0A
                    DC.B    'BLAM!'
                    DC.B    $0D,$0A
                    DC.B    'YOU WERE STRUCK AND TOOK DAMAGE!'
                    DC.B    $0D,$0A,0
                    
ENEMY_PAUSE_MSG:    DC.B    'The creature did nothing this turn.'
                    DC.B    $0D,$0A,0
                    
ENEMY_WILL_ATTACK_MSG_1:    DC.B    'You can feel VOILENT INTENT emanating from the creature.'
                            DC.B    $0D,$0A
                            DC.B    $0D,$0A,0

ENEMY_WILL_ATTACK_MSG_2:    DC.B    'You can feel its GAZE from the shadows'
                            DC.B    $0D,$0A
                            DC.B    $0D,$0A,0        
LEAVE_SHOP_MSG:     DC.B    'You turn to leave'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    '"Do be careful. Wouldnt want that gold to go to waste"'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    'You continue your Journey.'
                    DC.B    $0D,$0A,0
                   
MONSTER_SLAIN:      DC.B    'With one last hearty stab you defeat the indescribeable.'
                    DC.B    $0D,$0A                
                    DC.B    'It slumps backwards into the darkness with a noticeable thud.'
                    DC.B    $0D,$0A 
                    DC.B    'You push forward to see no body, just some gold on the ground.'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    '+15 GOLD.'
                    DC.B    $0D,$0A,0
 
NO_POTION_MSG:      DC.B    'YOU HAVE NO POTIONS!'
                    DC.B    $0D,$0A,0

NORM_ENEMY_MSG:     DC.B    'As you wander through the darkness you hear "Something".'
                    DC.B    $0D,$0A
                    DC.B    'It stomps down the corridor toward you at an alarming speed.'
                    DC.B    $0D,$0A
                    DC.B    'It stand just a meter or two away yet the darkness seems to'
                    DC.B    $0D,$0A
                    DC.B    'protect most of it from your torchs light.'
                    DC.B    $0D,$0A
                    DC.B    'You can vaguely make out a corridor filling humanoid figure.'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    'YOU DRAW YOUR BLADE.'
                    DC.B    $0D,$0A,0
                
NEW_POTION_MSG:     DC.B    'You acquired a potion!'
                    DC.B    $0D,$0A,0
                    DC.B    '+1 POTION'
                    DC.B    $0D,$0A,0
                
NEW_WEAPON_MSG:     DC.B    'You acquired a new, better weapon'
                    DC.B    $0D,$0A
                    DC.B    '+10 WEAPON DAMAGE.'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    'WEAPON DAMAGE = ',0
                
NEXT_LINE_MSG:      DC.B    $0D,$0A,0

NOT_ENOUGH_MSG:     DC.B    'YOU DONT HAVE ENOUGH TO BUT THIS!'
                    DC.B    $0D,$0A,0
                    
NOT_FIFTY_MSG:     DC.B    '"YOUR POOOOOOR!"'
                    DC.B    $0D,$0A
                    DC.B    'THE CREATURE SHOUTS MOCKINGLY BEFORE RUNNING INTO THE DARKNESS'
                    DC.B    $0D,$0A
                    DC.B    'YOU CONTINUE ON.'
                    DC.B    $0D,$0A,0
                
POTION_OFFER_MSG:   DC.B    'WOULD YOU LIKE TO DRINK A POTION?'
                    DC.B    $0D,$0A                
                    DC.B    '[1]YES'
                    DC.B    $0D,$0A 
                    DC.B    '[2]NO'
                    DC.B    $0D,$0A ,0

POTION_USED_MSG:    DC.B    'YOU DRANK A POTION?'
                    DC.B    $0D,$0A                
                    DC.B    '+30 HP'
                    DC.B    $0D,$0A ,0              
                
PW_CHOICE_MSG:      DC.B    'WHAT DO YOU WANT TO DO?'
                    DC.B    $0D,$0A
                    DC.B    '[1] ATTACK'
                    DC.B    $0D,$0A
                    DC.B    '[2] POTION'
                    DC.B    $0D,$0A
                    DC.B    '[3] BLOCK'
                    DC.B    $0D,$0A,0 

PLAYER_HIT_MSG:     DC.B    'SCHWING!'
                    DC.B    $0D,$0A
                    DC.B    'You feel your blade slice through something in the darkness!'
                    DC.B    $0D,$0A
                    DC.B    'The creature doesnt seem to react'
                    DC.B    $0D,$0A,0
                
PLAYER_BLOCKING_MSG:    DC.B    'You raise your gaurd, bracing for an attack!'
                        DC.B    $0D,$0A
                        DC.B    $0D,$0A
                        DC.B    '[DAMAGE OF NEXT ATTACK RECEIVED REDUCED]'
                        DC.B    $0D,$0A
                        DC.B    $0D,$0A,0

POTIONS_MSG:        DC.B    'NUMBER OF POTIONS : ',0 

PRESS_ENTER_MSG:    DC.B    $0D,$0A
                    DC.B    '---------------------PRESS ENTER---------------------'
                    DC.B    $0D,$0A,0
                    
SHOP_MSG:           DC.B    $0D,$0A
                    DC.B    'You come across a shop inbedded in the corridors wall.'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    'There are rhytmic puffs of smoke coming from the till window'
                    DC.B    $0D,$0A
                    DC.B    'As you approach you hear a hoarse voice bellow from the window.'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    '"Come to buy or browse?"'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    'DO YOU WANT TO BUY:'
                    DC.B    $0D,$0A
                    DC.B    '[1]Sword   = 85 gold'
                    DC.B    $0D,$0A
                    DC.B    '[2]Potion  = 25 gold'
                    DC.B    $0D,$0A
                    DC.B    '[3]Leave'
                    DC.B    $0D,$0A,0
                    
FIFTY_FIFTY_MSG:    DC.B    $0D,$0A
                    DC.B    'A little creature stands in the hall. Like all the rest its hidden by the dakness'
                    DC.B    $0D,$0A
                    DC.B    'no matter how close you get, yet you can make out two hands cupped together'
                    DC.B    $0D,$0A
                    DC.B    'raised toward you.'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    'The creature speaks.'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    '"Hello, Brave adventuruer. I may double fifty gold if you give me some."'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    'Do you give it Fifty Gold?'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    '[1] Give Gold.'
                    DC.B    $0D,$0A
                    DC.B    '[2] Leave'
                    DC.B    $0D,$0A,0
                    
FIFTY_FIFTY_FAILURE_MSG:    DC.B    $0D,$0A
                            DC.B    'You hesitantly give the creature fifty coins!'
                            DC.B    $0D,$0A
                            DC.B    $0D,$0A
                            DC.B    'As soon as you let go of your wealth the creature jolts!'
                            DC.B    $0D,$0A
                            DC.B    $0D,$0A
                            DC.B    '"HAH!   SUCKER! HAHAHAHAHAHAHAHA!"'
                            DC.B    $0D,$0A
                            DC.B    $0D,$0A
                            DC.B    'It yells as you hear its little feet run down and disappear into the'
                            DC.B    $0D,$0A
                            DC.B    'corrdidor'
                            DC.B    $0D,$0A
                            DC.B    $0D,$0A
                            DC.B    '-50 Gold'
                            DC.B    $0D,$0A,0
                    
FIFTY_FIFTY_SUCCESS_MSG:    DC.B    $0D,$0A
                            DC.B    'You hesitantly give the creature fifty coins!'
                            DC.B    $0D,$0A
                            DC.B    $0D,$0A
                            DC.B    'As soon as you let go of your wealth the creature jolts!'
                            DC.B    $0D,$0A
                            DC.B    $0D,$0A
                            DC.B    'it silently disappears into the dakrness with your money'
                            DC.B    $0D,$0A
                            DC.B    'you push forward into the dark to see a big pile of gold'
                            DC.B    $0D,$0A
                            DC.B    $0D,$0A
                            DC.B    '+50 Gold'
                            DC.B    $0D,$0A,0
                            
TAKE_CHANCE_2_MSG:      DC.B    $0D,$0A
                            DC.B    'YOU DECIDED TO NOT TAKE THE RISK.'
                            DC.B    $0D,$0A
                            DC.B    'You stab your heel into the dark, making contact.'
                            DC.B    $0D,$0A
                            DC.B    $0D,$0A
                            DC.B    'GRWOOOOOOOO!.'
                            DC.B    $0D,$0A
                            DC.B    $0D,$0A
                            DC.B    'You hear the creature yelp, then bare footsteps running down the corridor.'
                            DC.B    $0D,$0A
                            DC.B    'You continue on your journey.'
                            DC.B    $0D,$0A,0
                            
                            
                                
TOOK_CHANCE:        DC.B    $0D,$0A
                    DC.B    'YOU TOOK THE CHANCE!'
                    DC.B    $0D,$0A,0
        
  
WIN_MSG_1:          DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    '                             CONGRADULATIONS!                                           '
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    '        You survived the dungeon and lived the rest of your days a hero!                  '
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    '                               YOUR SCORE                                              '
                    DC.B    $0D,$0A
                    DC.B    '                            ----------------                                              '
                    DC.B    $0D,$0A
                    DC.B    '                       Health|    ',0
                    
WIN_MSG_2:          DC.B    '                      Potions|    ',0

WIN_MSG_3:          DC.B    '(x10)'
                    DC.B    $0D,$0A,0
                    
WIN_MSG_4:          DC.B    '                         Gold|    ',0

WIN_MSG_5:          DC.B    '                              Final Total                                         '
                    DC.B    $0D,$0A
                    DC.B    '                                  ',0



WELCOME_MSG:        DC.B    'Title      :  Dungeon Of The Dark'
                    DC.B    $0D,$0A
                    DC.B    'Created by :  Tadgh Fitzpatrick'
                    DC.B    $0D,$0A
                    DC.B    'Released   : 07/03/2024'
                    DC.B    $0D,$0A
                    DC.B    '----------------------------------------------------------------------------------'
                    DC.B    $0D,$0A
                    DC.B    'Welcome to "The Dungeon Of The Dark", said to be a stairway into hell......................'
                    DC.B    $0D,$0A
                    DC.B    '.......and your last hope to be able to pay off your debts.'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A
                    DC.B    'Do you want to step into the horrifying unknown of the dungeon or go back up '             
                    DC.B    $0D,$0A
                    DC.B    'to meet your end by something you can comprehend?'
                    DC.B    $0D,$0A
                    DC.B    '----------------------------------------------------------------------------------'
                    DC.B    $0D,$0A
                    DC.B    '1: TO ENTER THE DUNGEON.'
                    DC.B    $0D,$0A
                    DC.B    '2: TO GIVE UP AND LEAVE THIS DARING GAME.'
                    DC.B    $0D,$0A,0           
                   
HUD_MSG:            DC.B    'Player Health : ',0
HUD_MSG_2:          DC.B    'Potions : ',0
HUD_MSG_3:          DC.B    'GOLD : ',0
GAP_LINE:           DC.B    '------------------------------------------------------------------------------------------------'
                    DC.B    $0D,$0A
                    DC.B    $0D,$0A,0
                    
SHOP_SWORD:         DC.B    'sword',0
SHOP_POTION:        DC.B    'potion',0
SHOP_LEAVE:         DC.B    'leave',0


HEALTH:             DC.W    100         PLAYER HEALTH
ENEMY_HEALTH:       DC.W    30
ENEMY_MAX_HEALTH:   DC.W    30
PLAYER_DAMAGE:      DC.W    10
ENEMY_DAMAGE:       DC.W    10
POTIONS:            DC.W    0           AMOUNT OF POTIONS THE PLAYER HAS
ENC_NUM:            DC.W    0           ENCOUNTEER NUMBER, KEEPS TRACK OF WHICH ENCOUNTER SHOULD BE PLAYING
GOLD:               DC.W    0           
LOOPS:              DC.W    0           THE AMOUNT OF TIME GAMEPLAY HAS LOOPED
BLOCK:              DC.W    0           THE AMOUNT OF DAMAGE REDUCED BY THE BLOCK ACTION
ENEMY_ATTACK:       DC.W    0           WHAT ATTACK THE ENEMY WILL DO
E_HEALTH_BONUS:     DC.W    40          ENEMY HEALTH INCREASE AFTER EVERY FIGHT

COST:               DC.W    0           VARIABLE TO STORE THE COST OF GOODS WHEN CHECKING IF YOU HAVE ENOUGH

SCORE:       DC.W    0

BOSS_HEALTH:        DC.W    0
BOSS_MAX_HEALTH:    DC.W    0
BOSS_DAMAGE:        DC.W    0
BOSS_ATTACK:        DC.W    0
CHARGE_ATTACK_DMG:  DC.W    10

    END START











































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
