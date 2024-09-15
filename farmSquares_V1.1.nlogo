extensions [bitmap csv]

breed [edges edge]
breed [borders border]
breed [visuals visual]
breed [pendingSquares pendingSquare]
breed [arrows arrow]
breed [plusses plus]
breed [minuses minus]
breed [giving-plusses giving-plus]
breed [giving-minuses giving-minus]
breed [buttons button]
breed [selections selection]
breed [activities activity]
breed [env-functions env-function]
breed [env-vars env-var]
breed [integer-agents integer-agent]
breed [scorecards scorecard]
breed [selected-squares selected-square]
breed [player-squares player-square]
breed [panel-selections panel-selection]
breed [farm-actions farm-action]

patches-own [inGame? selected? shared? ownedBy selectedBy doing last_doing last_selectedBy soil_fert activity_record patch_yield current_doing_cost]
pendingSquares-own [permissions owner]
buttons-own [identity]
selections-own [row column counter visibleTo showing spatial?]
activities-own [ID	activity_name image	req	amt_min	amt_max annual badge phase_shown cost threshold benefit summary supply_per payment currentSupply adds_to takes_from negates spatial?]
env-functions-own [ID trigger neighborhood? neighborhoodSize direction? xOffset yOffset effectSize effectVar phases]
env-vars-own [ID effectVar valueMin valueMax valueDefault displayType displayLoc displayColor]
arrows-own [identity menu at-end]
integer-agents-own [ID visibleTo summaryOf]
scorecards-own [identity]
selected-squares-own [identity showing visibleTo]
player-squares-own [identity showing visibleTo active?]
plusses-own [counter visibleTo showing]
minuses-own [counter visibleTo showing]
giving-plusses-own [identity visibleTo]
giving-minuses-own [identity visibleTo]
visuals-own [showing]
panel-selections-own [ID visibleTo counter]
farm-actions-own [ID visibleTo counter]

globals [
  ;;game mechanism values
  numPlayers
  playerNames
  playerConfirm
  playerPosition
  playerActivities
  playerAccess
  playerAccessBySupply
  playerCurrentSelections
  playerConstrainedSupplies
  playerEarnedPayments
  playerResources
  playerCurrentResources
  playerPendingBenefits
  playerTempGiving
  playerGiving
  playerCounts
  messageAddressed
  gameInProgress
  finalTrading
  langSuffix
  numPatches
  currentYear
  currentPhase
  choosingSharedLand
  choosingPrivateLand
  choosingActivities
  vsla_chest
  seedSquares

  ;;visualization parameters and variables
  colorList
  border_color
  playerColor
  defaultPatchColor
  selectedShading
  confirmShading
  confirm-up-color
  confirm-down-color
  confirm-patch-color
  arrowEndColor
  arrowNotEndColor
  number_shape_list

  confirmFracLoc
  confirmPixLoc
  confirmPatchLoc
  confirmTile

  giveFracLoc
  givePixLoc
  givePatchLoc

  giveCancelFracLoc
  giveCancelPixLoc
  giveCancelPatchLoc

  giveConfirmFracLoc
  giveConfirmPixLoc
  giveConfirmPatchLoc

  x_pixels
  y_pixels
  x_panel_pixels
  pixelsPerPatch
  arrow_area
  arrow_rel_size
  numPanelPatches
  activities_per_row
  activityPanelSpatialHeight
  activityPanelSpatialBottom
  activityPanelNonSpatialHeight
  activityPanelNonSpatialBottom
  selection_rel_size
  plusminus_rel_size
  panel_selection_rel_size
  panel_selections_y
  panel_selections_h
  farm_actions_y
  give_panel_x
  give_panel_y
  give_panel_w
  give_panel_h




  ;;variables related to parsing parameter input
  gameName
  inputFileLabels
  completedGamesIDs
  parsedInput
  currentSessionParameters
  gameTag
  sessionList
  parameterHandled
  gameID

  ;;parameters to be set by input file
  numYears
  numPhases
  hasChoosingShared?
  hasChoosingPrivate?
  maxPrivateSquares
  activityListFileName
  activityInputs
  activity_property_labels
  tempActivityList
  activityCostList
  activityBenefitList
  envFunctionListFileName
  envFunctionInputs
  envFunction_property_labels
  envVarListFileName
  envVarInputs
  envVar_property_labels
  nonplayerFunctionListFileName
  nonplayerFunctionList
  nonplayerFunctionList_String
  nonplayerFunctionActivities
  nonplayerFunctionPhases
  nonplayerFunctionNames
  nonplayerFunctionInputs
  nonplayerFunction_property_labels
  nonspatialFunctionListFileName
  nonspatialFunctionList
  nonspatialFunctionList_String
  nonspatialFunctionActivities
  nonspatialFunctionPhases
  nonspatialFunctionNames
  nonspatialFunctionInputs
  nonspatialFunction_property_labels
  endgameFunctionListFileName
  endgameFunctionList
  endgameFunctionList_String
  endgameFunctionActivities
  endgameFunctionNames
  endgameFunctionInputs
  endgameFunction_property_labels
  spatialFunctionListFileName
  spatialFunctionList
  spatialFunctionList_String
  spatialFunctionActivities
  spatialFunctionPhases
  spatialFunctionNames
  spatialFunctionInputs
  spatialFunction_property_labels
  endowment
  vsla_int_rate
  lender_int_rate
  yield_high
  yield_low
  graze_yield

  ;;global variables used for taking inputs from input strings using run (which can't write to local variables)
  tempLocal
  tempList

  ]




;;EXAMPLES OF PROCEDURES THAT GAMES **WILL DEFINITELY** USE

to start-hubnet

  ;; clean the slate
  clear-all
  hubnet-reset

  ;; set all session variables that are preserved across games
  set playerNames (list)

  set playerPosition (list)
  set playerColor (list)
  set numPlayers 0
  set gameInProgress 0
  set vsla_chest 0

  set-default-shape borders "line-thick"
  set-default-shape edges "line"
  set-default-shape selections "circle"
  set-default-shape arrows "activity-arrow"
  set-default-shape activities "blank"
  set-default-shape env-functions "blank"
  set-default-shape env-vars "blank"
  set-default-shape scorecards "blank"
  set-default-shape selected-squares "selected-square"
  set-default-shape plusses "badge-plus"
  set-default-shape giving-minuses "badge-minus"
  set-default-shape giving-plusses "badge-plus"
  set-default-shape minuses "badge-minus"  set-default-shape player-squares "square"

  set number_shape_list (list "num-0" "num-1" "num-2" "num-3" "num-4" "num-5" "num-6" "num-7" "num-8" "num-9")


  set x_pixels 1080
  set y_pixels 720
  set x_panel_pixels 360
  set numPatches 8
  set numPanelPatches 4
  set activityPanelSpatialHeight 2.3
  set activityPanelSpatialBottom 3.5
  set activityPanelNonSpatialHeight 1.5
  set activityPanelNonSpatialBottom 2
  set activities_per_row 3
  set arrow_area 1
  set arrow_rel_size 0.7
  set selection_rel_size 0.9
  set plusminus_rel_size 0.3
  set panel_selection_rel_size 0.5
  set panel_selections_y 6
  set panel_selections_h 0.65
  set farm_actions_y 1.1
  set give_panel_x 1
  set give_panel_y 2
  set give_panel_w 6
  set give_panel_h 3


  set border_color black
  set colorList (list 95 14 26 115 125 45 135 93 13 23 113 123 3 133 98 18 28 118 128 8 138)  ;; add to this if you will have more than 21 players, but really, you shouldn't!!!
  set defaultPatchColor 65
  set selectedShading -3
  set confirmShading -3
  set confirm-up-color lime
  set confirm-down-color 61
  set confirm-patch-color 61

  set arrowEndColor gray
  set arrowNotEndColor blue

  ;; clear anything from the display, just in case
  clear-ticks
  clear-patches
  clear-turtles
  clear-drawing

    ;; try to read in the input parameter data - stop if the file doesn't exist
  if not file-exists? inputParameterFileName [ ;;if game parameter file is incorrect
    user-message "Please enter valid file name for input data"
    stop
  ]

  ;; open the file and read it in line by line
  set parsedInput csv:from-file inputParameterFileName
  set inputFileLabels item 0 parsedInput
  set sessionList []
  foreach but-first parsedInput [ ?1 -> set sessionList lput (item 0 ?1) sessionList ]
  set sessionList remove-duplicates sessionList

  ;; look in the list of completed game IDs, and take an initial guess that the session of interest is one higher than the highest session completed previously
  set completedGamesIDs []
  ifelse file-exists? "completedGames.csv" [
  file-open "completedGames.csv"
  while [not file-at-end?] [
    let tempValue file-read-line
    set completedGamesIDs lput read-from-string substring tempValue 0 position "_" tempValue completedGamesIDs
  ]
  set completedGamesIDs remove-duplicates completedGamesIDs
  set sessionID max completedGamesIDs + 1
  file-close
  ] [
  set sessionID -9999
  ]


  set currentSessionParameters []

end


to initialize-session

  ;; stop if we are currently in a session
  if (length currentSessionParameters > 0)
  [user-message "Current session is not complete.  Please continue current session.  Otherwise, to start new session, please first clear settings by clicking 'Launch Broadcast'"
    stop]

  ;; if the session requested isn't in our input parameters, stop
  if (not member? sessionID sessionList)
  [user-message "Session ID not found in input records"
    stop]

  ;; if the session requested has prior game data available, let the user know
  if (member? sessionID completedGamesIDs)
  [user-message "Warning: At least one game file with this sessionID has been found"]

  ;; pick the appropriate set of parameters for the current session from the previously parsed input file (i.e., all games listed as part of session 1)
  set currentSessionParameters filter [ ?1 -> item 0 ?1 = sessionID ] parsedInput

end

to start-game

  ;; stop if a game is already running
  if (gameInProgress = 1)
  [user-message "Current game is not complete.  Please continue current game.  Otherwise, to start new session, please first clear settings by clicking 'Launch Broadcast'"
    stop]



  ;; clear the output window and display
  clear-output
  clear-patches
  clear-turtles
  clear-drawing
  foreach playerPosition [ ?1 ->
    hubnet-clear-overrides (item (?1 - 1) playerNames)
  ]
  output-print "Output/Display cleared."

  ;;Set any parameters not set earlier, and not to be set from the read-in game file
  set playerCounts n-values numPlayers [0]

  ;set-default-shape borders "line"
  output-print "Game parameters initialized."

  ;; Start the game output file
  ;; the code below builds the game output file, named by the players and the current timestamp
  let tempDate date-and-time
  foreach [2 5 8 12 15 18 22] [ ?1 -> set tempDate replace-item ?1 tempDate "_" ]
  let playerNameList (word (item 0 playerNames) "_")
  foreach n-values (numPlayers - 1) [ ?1 ->  ?1 + 1 ] [ ?1 ->
   set playerNameList (word playerNameList "_" (item ?1 playerNames))
  ]
  set gameName (word gameTag "_" playerNameList "_" tempDate ".csv" )
  carefully [file-delete gameName file-open gameName] [file-open gameName]
  output-print "Game output file created."


  ;; read in game file input
  set-game-parameters

  ;; read in game activities
  read-activity-file
  read-env-var-file
  read-env-function-file
  read-nonspatial-function-file
  read-nonplayer-function-file
  read-spatial-function-file
  read-endgame-function-file

  ;; set up lists for number of each activities selected by player
  set playerActivities n-values numPlayers [0]
  foreach n-values (numPlayers) [?1 -> ?1] [ ?1 ->
    let playerActivityList n-values count activities [0]
    set playerActivities replace-item ?1 playerActivities playerActivityList
  ]

  ;; have a list where 'supply' for activities can be stored

  ;; make a blank slate to mark current selections
  set playerCurrentSelections playerActivities

  set playerAccess playerActivities
  set playerAccessBySupply playerAccess
  set playerConstrainedSupplies playerAccess
  set playerEarnedPayments playerAccess

    set playerResources n-values numPlayers [endowment]
  set playerCurrentResources n-values numPlayers [0]
  set playerPendingBenefits n-values numPlayers [0]
  set playerGiving n-values numPlayers [0]
  set playerTempGiving n-values numPlayers [0]

  ;;lay out the game board
  set pixelsPerPatch y_pixels / numPatches
  let patches_panel round(x_panel_pixels / pixelsPerPatch)
  resize-world (- patches_panel) (numPatches - 1) 0 (numPatches - 1)
  set-patch-size pixelsPerPatch ;;

  ;; separate the game land from the display area, and seed the landscape
  ask patches [
    set ownedBy -9999
    set selectedBy -9999
    set shared? false
    set selected? false
    set activity_record n-values count activities [0]

    if-else (pxcor < 0) [
      set inGame? false
      set pcolor 0
    ][
      set inGame? true
      set pcolor update-patch-color
      set doing []
      set selectedBy []
      set last_doing []
      set last_selectedBy []

    ]
  ]

  ;;show divisions between patches
  make-borders



  let yConvertPatch (numPatches / y_pixels)  ;;scaling vertical measures based on the currently optimized size of 50
  let xyConvertPatchPixel (patch-size / pixelsPerPatch)  ;; scaling vertical and horizontal measures based on currently optimized patch size of 14


  set confirmFracLoc (list 0.55 0.025 0.4 0.1) ;;fraction of height and width of panel, in form (list x-min y-min width height)
  set confirmPixLoc convertFracPix confirmFracLoc
  set confirmPatchLoc convertPixPatch confirmPixLoc
  create-buttons 1 [setxy ((item 0 confirmPatchLoc) + (item 2 confirmPatchLoc) / 2) ((item 1 confirmPatchLoc) - (item 3 confirmPatchLoc) / 2) set size (item 2 confirmPatchLoc) set color confirm-up-color set identity "confirm" set shape "confirm"]

  set giveFracLoc (list 0.05 0.875 0.4 0.1) ;;fraction of height and width of panel, in form (list x-min y-min width height)
  set givePixLoc convertFracPix giveFracLoc
  set givePatchLoc convertPixPatch givePixLoc
  create-buttons 1 [setxy ((item 0 givePatchLoc) + (item 2 givePatchLoc) / 2) ((item 1 givePatchLoc) - (item 3 givePatchLoc) / 2) set size (item 2 givePatchLoc) set color confirm-up-color set identity "give" set shape "give"]


  set giveConfirmPatchLoc (list 5 2.5 1 1)
  set giveConfirmPixLoc convertPatchPix giveConfirmPatchLoc
  create-buttons 1 [setxy ((item 0 giveConfirmPatchLoc) + (item 2 giveConfirmPatchLoc) / 2) ((item 1 giveConfirmPatchLoc) - (item 3 giveConfirmPatchLoc) / 2) set size (item 2 giveConfirmPatchLoc) set color confirm-up-color set identity "give-confirm" set shape "confirm" set hidden? true]

  set giveCancelPatchLoc (list 1 2.5 1 1)
  set giveCancelPixLoc convertPatchPix giveCancelPatchLoc
  create-buttons 1 [setxy ((item 0 giveCancelPatchLoc) + (item 2 giveCancelPatchLoc) / 2) ((item 1 giveCancelPatchLoc) - (item 3 giveCancelPatchLoc) / 2) set size (item 2 giveCancelPatchLoc) set color confirm-up-color set identity "give-cancel" set shape "cancel" set hidden? true]


  let startSquaresX give_panel_x + give_panel_w / 10
  let squaresWidth 4 * give_panel_w / 10
  let oneSquareWidth squaresWidth / numPlayers
  let squaresY give_panel_y + give_panel_h / 2
  foreach n-values numPlayers [?1 -> ?1] [ ?1 ->
    create-player-squares 1 [setxy (startSquaresX + (?1) * oneSquareWidth) squaresY
      set size oneSquareWidth * 0.9 set color item (?1) playerColor set hidden? true
      set showing (?1 + 1) set identity "give square"
      set visibleTo n-values numPlayers [false]
      set active? n-values numPlayers [false]
    ]

  ]

  create-giving-plusses 1 [setxy (give_panel_x + 6 * give_panel_w / 10) (give_panel_y + 2 * give_panel_h / 5) set size 1 set identity "give" set hidden? true set visibleTo n-values numPlayers [false]]
  create-giving-minuses 1 [setxy (give_panel_x + 8 * give_panel_w / 10 ) (give_panel_y + 2 * give_panel_h / 5) set size 1 set identity "give" set hidden? true set visibleTo n-values numPlayers [false]]

  ;;set up the space for selecting activities
  draw_box (- numPanelPatches - 0.5) (activityPanelSpatialBottom - 0.5) numPanelPatches activityPanelSpatialHeight white 1
  resize_activities_spatial
  draw_box (- numPanelPatches - 0.5) (activityPanelNonSpatialBottom - 0.5) numPanelPatches activityPanelNonSpatialHeight white 1
  resize_activities_nonspatial

  ;;add arrows
  let tempMenu n-values numPlayers [0]
  create-arrows 1 [setxy ( - arrow_area / 2 - 0.5) (activityPanelSpatialBottom - 0.25 + activityPanelSpatialHeight / 2 + activityPanelSpatialHeight * ((1 - arrow_rel_size) / 2)) set heading 0 set size (activityPanelSpatialHeight / 2) * arrow_rel_size set identity "up_spatial" set menu tempMenu set at-end tempMenu]
  create-arrows 1 [setxy ( - arrow_area / 2 - 0.5) (activityPanelSpatialBottom - 0.25 + activityPanelSpatialHeight * ((1 - arrow_rel_size) / 2)) set heading 180 set size (activityPanelSpatialHeight / 2) * arrow_rel_size set identity "down_spatial" set menu tempMenu set at-end tempMenu]

  create-arrows 1 [setxy ( - arrow_area / 2 - 0.5) (activityPanelNonSpatialBottom - 0.25 + activityPanelNonSpatialHeight / 2 + activityPanelNonSpatialHeight * ((1 - arrow_rel_size) / 2)) set heading 0 set size (activityPanelNonSpatialHeight / 2) * arrow_rel_size set identity "up_nonspatial" set menu tempMenu set at-end tempMenu]
  create-arrows 1 [setxy ( - arrow_area / 2 - 0.5) (activityPanelNonSpatialBottom - 0.25 + activityPanelNonSpatialHeight * ((1 - arrow_rel_size) / 2)) set heading 180 set size (activityPanelNonSpatialHeight / 2) * arrow_rel_size set identity "down_nonspatial" set menu tempMenu set at-end tempMenu]


  ;;and then do whatever else you'd do to initialize the game
  set playerConfirm n-values numPlayers [0]



  set gameInProgress 1
  set finalTrading false

  set currentYear 0
  set currentPhase 0

  update-nonplayer-functions

  (ifelse
    hasChoosingShared? [
    set choosingSharedLand 1
    output-print " CHOOSING SHARED LAND PHASE"
    file-print (word "Choosing shared land at " date-and-time)
  ]
    hasChoosingPrivate? [
    set choosingPrivateLand 1
    output-print " CHOOSING PRIVATE LAND PHASE"
    file-print (word "Choosing private land at " date-and-time)
  ]

    [;;if no shared or private selection to start, move into first actual-time phase
      set currentYear 1
      set currentPhase 1
      set choosingActivities 1
      output-print " BEGINNING AGRICULTURE PHASES"
      file-print (word "Beginning agriculture phases at " date-and-time)

      ;;if there are environmental functions to update, do so
      initialize-env-vars
      estimate-env-vars
      update-env-vars


  ])




  update-current-supply
  update-takes-from
  foreach n-values numPlayers [?1 -> ?1] [ ?1 ->
    update-access ?1
    update-displayed-spatial-activities ?1
    update-displayed-nonspatial-activities ?1
    update-current-selections ?1
    update-farm-actions ?1
  ]



   ;;add a round counter
  create-scorecards 1 [setxy (patches_panel * (- 0.85)) (numPatches - 0.87) set label (word currentYear " - " currentPhase) set identity "roundCounter"]

end

to listen

  ;; this is the main message processing procedure for the game.  this procedure responds to hubnet messages, one at a time, as long as the 'Listen Clients' button is down
  ;; where appropriate, this procedure can be made easier to read by exporting the response to the message case to its own procedure

  ;; while there are messages to be processed
  while [hubnet-message-waiting?] [

    ;; we use a 'message addressed' flag to avoid having to nest foreach loops (there is no switch/case structure in netlogo)
    ;; the procedure steps through each case from top to bottom until it finds criteria that fit.  it then executes that code and marks the message addressed
    ;; it is CRITICAL that you order the cases correctly - from MOST SPECIFIC to LEAST SPECIFIC - if there is any ambiguity in interpreting the message
    ;; e.g., where you have a button or other feature that sits within a larger clickable area, list the case for the button first, then the larger area surrounding it
    set messageAddressed 0

    ;; get the next message in the queue
    hubnet-fetch-message



    ;; CASE 1 and CASE 2 messages are responses to messages of players coming in and out of the game.  hopefully, what's there is a good fit to your purpose

    ;; CASE 3  are responses to a click/tap from a player.

    ;; CASE 4  are 'mouse up' responses after clicking, which at present we are not using.  these are helpful to make use of 'mouse drag' actions

    ;; CASE 5  are otherwise unhandled messages

    ;; CASE 1 if the message is that someone has entered the game
    if (hubnet-enter-message? and messageAddressed = 0)[

      ;; CASE 1.1 if the player has already been in the game, link them back in.  if the player is new, set them up to join
      ifelse (member? hubnet-message-source playerNames ) [

        ;; pre-existing player whose connection cut out
        let newMessage word hubnet-message-source " is back."
        hubnet-broadcast-message newMessage

        ;; give the player the current game information
        let currentMessagePosition (position hubnet-message-source playerNames);
        let currentPlayer currentMessagePosition + 1
        send-game-info currentMessagePosition

      ] ;; end previous player re-entering code

      [ ;; CASE 1.2 otherwise it's a new player trying to join

        ;; new players can only get registered if a game isn't underway
        if (gameInProgress = 0) [  ;;only let people join if we are between games


          ;; register the player name
          set playerNames lput hubnet-message-source playerNames


          ;; add the new player, and give them a color
            set numPlayers numPlayers + 1
          set playerPosition lput numPlayers playerPosition
          set playerColor lput (item (numPlayers - 1) colorList) playerColor

          ;; let everyone know
          let newMessage word hubnet-message-source " has joined the game."
          hubnet-broadcast-message newMessage
          ;file-print (word hubnet-message-source " has joined the game as Player " numPlayers " at " date-and-time)

        ]  ;; end new player code
      ] ;; end ifelse CASE 1.1 / CASE 1.2

      ;; mark this message as done
      set messageAddressed 1
    ] ;; end CASE 1

    ;; CASE 2 if the message is that someone left
    if (hubnet-exit-message? and messageAddressed = 0)[

      ;; nothing to do but let people know
      let newMessage word hubnet-message-source " has left.  Waiting."
      hubnet-broadcast-message newMessage

      ;; mark the message done
      set messageAddressed 1
    ] ;; end CASE 2

    ;;CASE 3 the remaining cases are messages that something has been tapped, which are only processed if 1) a game is underway, 2) the message hasn't been addressed earlier, and 3) the player is in the game
    if (gameInProgress = 1 and messageAddressed = 0 and (member? hubnet-message-source playerNames))[

      ;; identify the sender
      let currentMessagePosition (position hubnet-message-source playerNames);  ;;who the message is coming from, indexed from 0
      let currentPlayer (currentMessagePosition + 1); ;;who the player is, indexed from 1

      let notYetConfirmed? (item (currentPlayer - 1) playerConfirm = 0)

      let notPlayerGiving? (item (currentPlayer - 1) playerGiving = 0)
      if (hubnet-message-tag = "View" )  [  ;; the current player tapped something in the view


        ;;identify the patch
        let xPatch (item 0 hubnet-message)
        let yPatch (item 1 hubnet-message)
        let xPixel (xPatch - min-pxcor + 0.5) * patch-size
        let yPixel (max-pycor + 0.5 - yPatch) * patch-size

        let currentPXCor [pxcor] of patch xPatch yPatch
        let currentPYCor [pycor] of patch xPatch yPatch

        let patchInGame [inGame?] of patch xPatch yPatch
        let currentPatchActivity [doing] of patch xPatch yPatch

        ;; CASE 3.2 if the tap is selecting patches as shared or not
        ;; if it is the choosingSharedLand phase and the player taps a patch, toggle the selection
        if (patchInGame and messageAddressed = 0 and (choosingSharedLand = 1)) and notYetConfirmed? and notPlayerGiving? and finalTrading = false [

          output-print "Tap Case 3.0"
          ask patch xPatch yPatch [
            ifelse selected? [
              set selected? false
              file-print (word "Case 3.0 - Player " currentPlayer " unselected patch " pxcor " " pycor " at " date-and-time)
            ] [
              set selected? true
              file-print (word "Case 3.0 - Player " currentPlayer " selected patch " pxcor " " pycor " at " date-and-time)
            ]
            set pcolor update-patch-color
          ]
          ;; message is done
          set messageAddressed 1

        ]

        ;; CASE 3.1 if the tap is selecting pasture as own home or not
        ;; if it is the choosingSharedLand phase and the player taps a pasture, toggle the selection (patches whose x is >= 0 are pasture)
        if (patchInGame and messageAddressed = 0 and (choosingPrivateLand = 1)) and notYetConfirmed? and notPlayerGiving? and finalTrading = false [
          output-print "Tap Case 3.1"
          ask patch xPatch yPatch [
            ifelse selected? and selectedBy = currentPlayer [
              set selected? false
              set selectedBy -9999
              file-print (word "Case 3.1 - Player " currentPlayer " unselected patch " pxcor " " pycor " at " date-and-time)

            ] [
              if count patches with [selectedBy = currentPlayer] < maxPrivateSquares [
                set selected? true
                set selectedBy currentPlayer
                file-print (word "Case 3.1 - Player " currentPlayer " selected patch " pxcor " " pycor " at " date-and-time)

              ]
            ]
            set pcolor update-patch-color
          ]


          ;; message is done
          set messageAddressed 1

        ]

        ;; CASE 3.X if the tap is on a square that is in game and the player has selected a spatial activity
        let hasSelection any? selected-squares with [visibleTo = (currentPlayer - 1)]

        if (patchInGame and messageAddressed = 0 and choosingActivities = 1 and hasSelection) and notPlayerGiving? and finalTrading = false [

          action-in-space currentPlayer xPatch yPatch

          ;; mark message done
          set messageAddressed 1

        ]

        ;; CASE 3.2 if the tap is on an available selection
        if messageAddressed = 0 and item (currentPlayer - 1) playerConfirm = 0 and notPlayerGiving? [
          ask selections with [hidden? = false and spatial? = true and item currentMessagePosition visibleTo = 1] [
            let selectLoc (list (xcor - size / 2) (ycor + size / 2) size size)
            if clicked-area ( convertPatchPix selectLoc) [


              ;; mark the confirm and record
              let newMessage word (item (currentPlayer - 1) playerNames) " clicked an available selection."
              hubnet-broadcast-message newMessage
              output-print newMessage
              file-print (word "Case 3.2 - Player " currentPlayer " clicked an available selection at " date-and-time)

              selection-activity currentMessagePosition (item (currentPlayer - 1) showing) (list xcor ycor)

              ;; mark message done
              set messageAddressed 1
            ]

          ]
        ] ;; end 3.2

        ;; CASE 3.2 if the tap is on a plus sign
        if messageAddressed = 0 and item (currentPlayer - 1) playerConfirm = 0 and notPlayerGiving? and finalTrading = false [
          ask plusses with [hidden? = false and item currentMessagePosition visibleTo = 1] [
           let plusLoc (list (xcor - size / 2) (ycor + size / 2) size size)
          if clicked-area ( convertPatchPix plusLoc) [


              ;; mark the confirm and record
              let newMessage word (item (currentPlayer - 1) playerNames) " clicked a plus."
              hubnet-broadcast-message newMessage
              output-print newMessage
              file-print (word "Case 3.2 - Player " currentPlayer " clicked a plus at " date-and-time)

              plus-activity currentMessagePosition

              ;; mark message done
              set messageAddressed 1
            ]

          ]
        ] ;; end 3.2


        ;; CASE 3.3 if the tap is on a minus sign
        if messageAddressed = 0 and item (currentPlayer - 1) playerConfirm = 0 and notPlayerGiving? and finalTrading = false [
         ask minuses with [hidden? = false and item currentMessagePosition visibleTo = 1][
            let minusLoc (list (xcor - size / 2) (ycor + size / 2) size size)

            if clicked-area ( convertPatchPix minusLoc) [

              ;; mark the confirm and record
              let newMessage word (item (currentPlayer - 1) playerNames) " clicked a minus."
              hubnet-broadcast-message newMessage
              output-print newMessage
              file-print (word "Case 3.3 - Player " currentPlayer " clicked a minus at " date-and-time)

              minus-activity currentMessagePosition

              ;; mark message done
              set messageAddressed 1

            ]

          ]
        ] ;; end 3.3

        ;; CASE 3.2 if the tap is on a giving plus sign
        if messageAddressed = 0 and item (currentPlayer - 1) playerConfirm = 0 and (not notPlayerGiving?) [
          ask giving-plusses with [item (currentPlayer - 1) visibleTo = true] [

           let plusLoc (list (xcor - size / 2) (ycor + size / 2) size size)
          if clicked-area ( convertPatchPix plusLoc) [


              ;; mark the confirm and record
              let newMessage word (item (currentPlayer - 1) playerNames) " clicked a giving plus."
              hubnet-broadcast-message newMessage
              output-print newMessage
              file-print (word "Case 3.2 - Player " currentPlayer " clicked a giving plus at " date-and-time)

              giving-plus-activity currentMessagePosition

              ;; mark message done
              set messageAddressed 1
            ]

          ]
        ] ;; end 3.2


        ;; CASE 3.3 if the tap is on a giving minus sign
        if messageAddressed = 0 and item (currentPlayer - 1) playerConfirm = 0 and (not notPlayerGiving?) [
         ask giving-minuses with [item (currentPlayer - 1) visibleTo = true][

            let minusLoc (list (xcor - size / 2) (ycor + size / 2) size size)

            if clicked-area ( convertPatchPix minusLoc) [

              ;; mark the confirm and record
              let newMessage word (item (currentPlayer - 1) playerNames) " clicked a giving minus."
              hubnet-broadcast-message newMessage
              output-print newMessage
              file-print (word "Case 3.3 - Player " currentPlayer " clicked a giving minus at " date-and-time)

              giving-minus-activity currentMessagePosition

              ;; mark message done
              set messageAddressed 1

            ]

          ]
        ] ;; end 3.3

        ;; CASE 3.4 if the tap is on an arrow
        if messageAddressed = 0 and item (currentPlayer - 1) playerConfirm = 0 and notPlayerGiving? and finalTrading = false [
          ask arrows with [hidden? = false][
            let arrowLoc (list (xcor - size / 2) (ycor + size / 2) size size)

            if clicked-area ( convertPatchPix arrowLoc) [

              ;; mark the confirm and record
              let newMessage word (item (currentPlayer - 1) playerNames) " clicked an arrow."
              hubnet-broadcast-message newMessage
              output-print newMessage
              file-print (word "Case 3.3 - Player " currentPlayer " clicked an arrow at " date-and-time)

              ;; mark message done
              set messageAddressed 1
              arrow-activity currentMessagePosition identity (item (currentMessagePosition) menu)

            ]

          ]
        ] ;; end 3.4


        ;; CASE 3.4 if the tap is on a player square in the give window
        if messageAddressed = 0 and item (currentPlayer - 1) playerConfirm = 0 and (not notPlayerGiving?) [

          ask player-squares with [item (currentPlayer - 1) visibleTo = true][

            let squareLoc (list (xcor - size / 2) (ycor + size / 2) size size)

            if clicked-area ( convertPatchPix squareLoc) [

              ;; mark the confirm and record
              let newMessage word (item (currentPlayer - 1) playerNames) " clicked a player square."
              hubnet-broadcast-message newMessage
              output-print newMessage
              file-print (word "Case 3.3 - Player " currentPlayer " clicked a player to give to at " date-and-time)

              ;; mark message done
              set messageAddressed 1
              player-square-activity currentMessagePosition identity
            ]

          ]
        ] ;; end 3.4



        ;; CASE 3.15 if the tap is on the 'give-cancel button'
        if (clicked-area (giveCancelPixLoc) and messageAddressed = 0)[



          ;; mark the give request and record
          let newMessage word (item (currentPlayer - 1) playerNames) " clicked give-cancel."
          hubnet-broadcast-message newMessage
          output-print newMessage
          file-print (word "Case 3.15 - Player " currentPlayer " clicked give-cancel at " date-and-time)


          ;;move to give button actions
          give-cancel-activity (currentPlayer - 1)

          ;; mark message done
          set messageAddressed 1
        ]


        ;; CASE 3.15 if the tap is on the 'give-confirm button'
        if (clicked-area (giveConfirmPixLoc) and messageAddressed = 0)[



          ;; mark the give request and record
          let newMessage word (item (currentPlayer - 1) playerNames) " clicked give-confirm."
          hubnet-broadcast-message newMessage
          output-print newMessage
          file-print (word "Case 3.15 - Player " currentPlayer " clicked give-confirm at " date-and-time)


          ;;move to give button actions
          give-confirm-activity (currentPlayer - 1)

          ;; mark message done
          set messageAddressed 1
        ]

        ;; CASE 3.15 if the tap is on the 'give button'
        if (clicked-area (givePixLoc) and messageAddressed = 0) and notPlayerGiving? [



          ;; mark the give request and record
          let newMessage word (item (currentPlayer - 1) playerNames) " clicked give."
          hubnet-broadcast-message newMessage
          output-print newMessage
          file-print (word "Case 3.15 - Player " currentPlayer " clicked give at " date-and-time)


          ;;move to give button actions
          give-activity (currentPlayer - 1)

          ;; mark message done
          set messageAddressed 1
        ]

       ;; CASE 3.15 if the tap is on the 'confirm button'

        if (clicked-area (confirmPixLoc) and messageAddressed = 0 and notYetConfirmed? and notPlayerGiving? and finalTrading = false)[
          ;; if the player hasn't already clicked confirm this phase
          if item (currentPlayer - 1) playerConfirm = 0 and not (any? pendingSquares with [owner = currentPlayer]) [

            ;; mark the confirm and record
            let newMessage word (item (currentPlayer - 1) playerNames) " clicked confirm."
            hubnet-broadcast-message newMessage
            output-print newMessage
            file-print (word "Case 3.15 - Player " currentPlayer " clicked confirm at " date-and-time)

            set playerConfirm replace-item (currentPlayer - 1) playerConfirm 1


            ;; clear away any selections
            ask selected-squares with [visibleTo = (currentPlayer - 1)] [hubnet-clear-override (item (currentPlayer - 1) playerNames) self "shape" die]

            ;; darken the pasture to mark the confirm to the player
            ask patches with [inGame?] [
              hubnet-send-override (item (currentPlayer - 1) playerNames) self "pcolor" [confirm-patch-color]]


            ;; darken confirm button
            ask buttons with [identity = "confirm"] [hubnet-send-override (item (currentPlayer - 1) playerNames) self "color" [confirm-down-color]]

            ;; update the player's information
            send-game-info (currentPlayer - 1)

            ;; if EVERYONE has now confirmed, move to advance-phase
            if (sum playerConfirm = numPlayers) [
              advance-phase
            ]
          ]

          ;; mark message done
          set messageAddressed 1
        ]

      ] ;; end all cases for clicks within the  "view"


    ] ;; end all CASE 3 messages

    ;; CASE 4 - Mouse up after a click message
    if (gameInProgress = 1 and messageAddressed = 0 and hubnet-message-tag = "Mouse Up") [

     ;; no need to do anything
     set messageAddressed 1
    ]

    if (gameInProgress = 1 and messageAddressed = 0) [
      ;; CASE 5 if the message still hasn't been addressed, it means players clicked in a place that they weren't meant to - ignore it
      set messageAddressed 1
      output-print "Unhandled message"

    ]
  ]


end

to advance-phase

  ;; called once at the end of every phase, once all players have clicked 'confirm'.  depending on the phases listed for the current turn, different things happen


  ;; it is called twice between the end of the last phase of a year and the first phase of another.  the first time, it will launch the 'show-game-information' routine and exit;
  ;; once players have clicked confirm to exit the game information, it will be called again to finish advancing the phase

  ; if game information is not currently showing (i.e., this is the first time executed after end of phase)

  ;; use advanceHandled? as a flag to mark a particular case as being handled
  let advanceHandled? false



  ;;CASE 1 - ADVANCING OUT OF CHOOSING SHARED LAND
  if (not advanceHandled? and choosingSharedLand = 1) [

    ;;mark us out of the choosing shared land phase
    set choosingSharedLand 0

    ;;mark out the shared village
    ask patches with [selected?] [set selected? false set shared? true file-print (word "Patch " pxcor " " pycor " shared")]
    ask patches with [inGame?] [set pcolor update-patch-color]
    make-shared-borders

    ;;reset player confirms
    foreach playerPosition [ ?1 ->
      set playerConfirm replace-item (?1 - 1) playerConfirm 0
      send-game-info (?1 - 1)
    ]


    ;;clear any overrides before moving to next phase
    foreach playerPosition [ ?1 ->
      ask patches with [inGame?] [hubnet-clear-override (item (?1 - 1) playerNames) self "pcolor"]
    ]

    ;;if the game includes marking of private lands, move to that; otherwise  move into first actual-time phase
    ifelse hasChoosingPrivate? [
      set choosingPrivateLand 1
      output-print " CHOOSING PRIVATE LAND PHASE"
      file-print (word "Choosing private land at " date-and-time)
    ] [
      set currentYear 1
      set currentPhase 1

      set choosingActivities 1
      output-print " BEGINNING AGRICULTURE PHASES"
      file-print (word "Beginning agriculture phases at " date-and-time)
    ]

    ;;mark the phase as advanced
    set advanceHandled? true
  ]



  ;;CASE 2 - ADVANCING OUT OF CHOOSING PRIVATE LAND
  if (not advanceHandled? and choosingPrivateLand = 1) [

    ;;mark us out of the choosing private land phase
    set choosingPrivateLand 0

    ;;mark out the shared village
    ask patches with [selected?] [set selected? false set shared? false set ownedBy selectedBy file-print (word "Patch " pxcor " " pycor " owned by Player " selectedBy)]
    ask patches with [inGame?] [set pcolor update-patch-color]
    make-private-borders

    ;;reset player confirms
    foreach playerPosition [ ?1 ->
      set playerConfirm replace-item (?1 - 1) playerConfirm 0
      send-game-info (?1 - 1)
    ]


    ;;clear any overrides before moving to next phase
    foreach playerPosition [ ?1 ->
      ask patches with [inGame?] [hubnet-clear-override (item (?1 - 1) playerNames) self "pcolor"]
    ]

    ;;move into first actual-time phase
    set currentYear 1
    set currentPhase 1

    set choosingActivities 1

    output-print " BEGINNING AGRICULTURE PHASES"
    file-print (word "Beginning agriculture phases at " date-and-time)

    ;;mark the phase as advanced
    set advanceHandled? true
  ]


  if (not advanceHandled?) [
  ;;CASE 3 - advancing agriculture

    output-print "Advance phase - Case 3"
    ;; do everything here that should happen before information is shared

    ;;DO EVERYTHING HERE TO ADVANCE AGRICULTURE, WITH REAL TIME PASSING EACH TURN

    advance-farm-time


    ;;NOW ADVANCE THE YEAR/PHASE
    ;; now that we've done all the things we might want to do before advancing the phase, move on and update the phase
    ;; if we are in the last phase of the year, we either need to advance to the next year or end game
    ifelse currentPhase = numPhases [ ;; LAST PHASE OF YEAR


      ifelse currentYear = numYears [
        output-print "Advance Phase - ending game"
        file-print (word "Game ended at " date-and-time)

        ;;CASE 1.1 - END GAME

        ask patches with [inGame?] [set pcolor gray]
        ask buttons with [identity = "confirm"] [die]


        ;;let there be final opportunity for trading
        set finalTrading true
        ask scorecards with [identity = "roundCounter"] [set label (word  "- - -" )]

        ;; game facilitator ends final trading by clicking 'End game' button

      ] [

        ;;CASE 1.2 - END OF YEAR, ADVANCE TO NEXT YEAR
        ;; year is advanced by one.  go to the 'game-information' routine, but leave a marker that we're doing that.
        ;; after that has been shown, we'll come back here, but we don't want to advance the counters again.  we unfortunately can't
        ;; just stay in this loop because we need to listen for 'confirms' again, and while we're in here, hubnet isn't listening

        output-print "Advance Phase - advancing year"
        file-print (word "Advancing to next year at" date-and-time)
        set currentPhase 1
        set currentYear (currentYear + 1)



        ;stop
      ]


    ] [

      ;;CASE 1.3 - MIDDLE OF A YEAR, ADVANCE TO NEXT PHASE

      output-print "Advance Phase - advancing phase in year"
      file-print (word "Advancing to next phase at " date-and-time)
      set currentPhase (currentPhase + 1)

    ] ;; end of ifelse currentPhase = numPhases



  ]




    ;; RESET CONFIRMS TO UNCONFIRMED, AND UPDATE ALL VISUALIZATIONS BASED ON CHANGES ABOVE
    foreach playerPosition [ ?1 ->
      set playerConfirm replace-item (?1 - 1) playerConfirm 0
      ask buttons with [identity = "confirm"] [hubnet-clear-override (item (?1 - 1) playerNames) self "color"]

      update-access (?1 - 1)
      update-displayed-spatial-activities (?1 - 1)
      update-displayed-nonspatial-activities (?1 - 1)
      send-game-info (?1 - 1)
      update-farm-actions (?1 - 1)
      update-current-selections (?1 - 1)

    ]
    update-current-supply
    update-takes-from


   if (finalTrading = false) [

    ;;update round counters

    ask scorecards with [identity = "roundCounter"] [set label (word currentYear " - " currentPhase)]


    ask patches with [inGame?] [set pcolor update-patch-color]

  ]

    ;;clear any overrides before moving to next phase
    foreach playerPosition [ ?1 ->
      ask patches with [inGame?] [hubnet-clear-override (item (?1 - 1) playerNames) self "pcolor"]
    ]


end

to end-game

   if (finalTrading = false)[
    ifelse gameInProgress = 1 [
      user-message "Current game has not yet moved to final trading and can't be ended.  Please continue current game.  Otherwise, to start new session, please first clear settings by clicking 'Launch Broadcast'"
      stop
    ][
      user-message "There is no game currently in progress.  You may launch the next game or start a new session."
      stop

    ]
  ]

  set finalTrading false
  ask buttons [die]
  ;; at the end of the game, show final information, mark the game as stopped, and finalize files

  set gameInProgress 0

  update-endgame-functions


  ;;show what each player earns

  (ifelse
  gameID = 0 [

      foreach n-values numPlayers [?1 -> ?1] [?1 ->
        output-print (word "Player " (?1 + 1) " earns " item ?1 playerResources)
        file-print (word "Player " (?1 + 1) " earns " item ?1 playerResources)
      ]

  ]
  gameID = "1A" [
      foreach n-values numPlayers [?1 -> ?1] [?1 ->
        output-print (word "Player " (?1 + 1) " earns " min playerResources)
        file-print (word "Player " (?1 + 1) " earns " min playerResources)
      ]
  ]
  gameID = "1B" [
      foreach n-values numPlayers [?1 -> ?1] [?1 ->
        output-print (word "Player " (?1 + 1) " earns " mean playerResources)
        file-print (word "Player " (?1 + 1) " earns " mean playerResources)
      ]
  ]
  gameID = 2 [
      output-print "Earnings determined by group"
      foreach n-values numPlayers [?1 -> ?1] [?1 ->
        output-print (word "Player " (?1 + 1) " score " item ?1 playerResources)
        file-print (word "Player " (?1 + 1) " score " item ?1 playerResources)
      ]
      output-print (word "Min score is " min playerResources)
      output-print (word "Mean score is " mean playerResources)
  ]
    )



  file-close

  file-open "completedGames.csv"
  file-print gameName
  file-close

  stop

end
to make-shared-borders
    ;; make border around shared parcels
  ;; do this using 'border' agents that stamp an image of themselves between patches and then die
  ;; note:  if you have wraparound, the setxy line has to be modified to account for this

  ask patches with [shared?] [
    let x1 pxcor
    let y1 pycor
    ask neighbors4 [
      let x2 pxcor
      let y2 pycor
     if not shared?  [
       sprout-borders 1 [set color black

         setxy mean (list x1 x2) mean (list y1 y2)
         ifelse y1 != y2 [set heading 90] [set heading 0]
         stamp die]


      ]
    ]

  ]

end

to make-private-borders
    ;; make border around shared parcels
  ;; do this using 'border' agents that stamp an image of themselves between patches and then die
  ;; note:  if you have wraparound, the setxy line has to be modified to account for this

  ask patches with [ownedBy > 0] [
    let currentOwner ownedBy
    let x1 pxcor
    let y1 pycor

    sprout 1 [set size 0.2 setxy pxcor - 0.25 pycor + 0.25 set shape "house" set color (item (currentOwner - 1) playerColor) stamp die]

    ask neighbors4 [
      let x2 pxcor
      let y2 pycor
      let neighborOwner ownedBy
     if neighborOwner != currentOwner  [
       sprout-borders 1 [set color (item (currentOwner - 1) playerColor)
         setxy mean (list x1 x2) mean (list y1 y2)
         ifelse y1 != y2 [set heading 90] [set heading 0]
         stamp die]


      ]
    ]

  ]

end



;;EXAMPLES OF PROCEDURES THAT GAMES **WILL PROBABLY** USE


to-report convertFracPix [fracLoc]
  let pixLoc (list ((item 0 fracLoc) * x_panel_pixels) ((item 1 fracLoc) * y_pixels) ((item 2 fracLoc) * x_panel_pixels) ((item 3 fracLoc) * y_pixels))
  report pixLoc
end

to-report convertPixPatch [pixLoc]
  let patchLoc (list (min-pxcor - 0.5 + (item 0 pixLoc) / pixelsPerPatch) (max-pycor + 0.5 - (item 1 pixLoc) / pixelsPerPatch) ((item 2 pixLoc) / pixelsPerPatch) ((item 3 pixLoc) / pixelsPerPatch))
  report patchLoc
end

to-report convertPatchPix [patchLoc]
  let pixLoc (list (((item 0 patchLoc) - min-pxcor + 0.5) * pixelsPerPatch) (( max-pycor + 0.5 - (item 1 patchLoc)) * pixelsPerPatch) ((item 2 patchLoc) * pixelsPerPatch) ((item 3 patchLoc) * pixelsPerPatch))
  report pixLoc
end

to-report clicked-area [ currentPixLoc ]

  ;; checks the boundaries of a click message against those of a 'button' to see if it was the one clicked
  ;; inputs are boundaries in PIXEL SPACE

  let xPixel ((item 0 hubnet-message) - min-pxcor + 0.5) * patch-size
  let yPixel (max-pycor + 0.5 - (item 1 hubnet-message)) * patch-size
  let xPixMin item 0 currentPixLoc
  let xPixMax item 0 currentPixLoc + item 2 currentPixLoc
  let yPixMin item 1 currentPixLoc
  let yPixMax item 1 currentPixLoc + item 3 currentPixLoc
  ifelse xPixel > xPixMin and xPixel < xPixMax and yPixel > yPixMin and yPixel < yPixMax [  ;; player "clicked"  the current button
    report true
  ] [
    report false
  ]

end

to make-borders
    ;; make border around pasture parcels
  ;; do this using 'border' agents that stamp an image of themselves between patches and then die
  ;; note:  if you have wraparound, the setxy line has to be modified to account for this


  ask patches with [pxcor >= 0 and pycor < max-pycor] [
    sprout-edges 1 [set color border_color
      setxy pxcor pycor + 0.5
      set heading 90
      stamp die]
  ]

  ask patches with [pxcor >= 0 and pxcor < max-pxcor] [
    sprout-edges 1 [set color border_color
      setxy pxcor + 0.5 pycor
      set heading 0
      stamp die]
  ]
end


to-report update-patch-color

  let currentColor defaultPatchColor
  if inGame? [

    if selected? [
      set currentColor (currentColor + selectedShading)


    ]
  ]

  report currentColor
end


;;EXAMPLES OF PROCEDURES THAT GAMES **MIGHT** USE

to send-game-info [currentPosition]

  ;; sends current, player-specific game info to the specified player.  this is useful if the player has left the game and returned, so that any view overrides are re-established.
  ;;example:  ask dayBoxes [hubnet-send-override (item currentPosition playerNames) self "hidden?" [true]]

  update-displayed-spatial-activities currentPosition
  update-displayed-nonspatial-activities currentPosition
    ask integer-agents [
    if not (member? (currentPosition) visibleTo) [

      hubnet-send-override  (item (currentPosition) playerNames) self "shape" ["blank"]
    ]
  ]

  ask selected-squares [
    foreach n-values (numPlayers) [?2 -> ?2 ] [ ?2 ->
      if ?2 != visibleTo [
        hubnet-send-override  (item (?2) playerNames) self "shape" ["blank"]
      ]
    ]

  ]

  if item currentPosition playerGiving = 1 [

    ;;make a black 'giving window' by asking everyone in it to go blank or black
    ask patches with [pxcor >= give_panel_x and pxcor <= give_panel_x + give_panel_w - 1 and pycor >= give_panel_y and pycor <= give_panel_y + give_panel_h] [
      hubnet-send-override (item (currentPosition) playerNames) self "pcolor" [black]
      ask visuals-here [
        hubnet-send-override (item (currentPosition) playerNames) self "shape" ["blank"]
      ]
      ask integer-agents-here with [member? "env_var_" ID or ID = "yield"] [
        hubnet-send-override (item (currentPosition) playerNames) self "shape" ["blank"]
      ]
    ]
    ask buttons with [identity = "give-cancel"] [
      hubnet-clear-override (item (currentPosition) playerNames) self "shape"
      hubnet-send-override (item (currentPosition) playerNames) self "hidden?" [false]]
    ask buttons with [identity = "give-confirm"] [
      hubnet-clear-override (item (currentPosition) playerNames) self "shape"
      hubnet-send-override (item (currentPosition) playerNames) self "hidden?" [false]]
    ask player-squares [
      hubnet-send-override (item (currentPosition) playerNames) self "hidden?" [false]
      set visibleTo replace-item currentPosition visibleTo true
    ]
    ask giving-minuses  [
      hubnet-send-override (item (currentPosition) playerNames) self "hidden?" [false]
      set visibleTo replace-item currentPosition visibleTo true
    ]
    ask giving-plusses [
      hubnet-send-override (item (currentPosition) playerNames) self "hidden?" [false]
      set visibleTo replace-item currentPosition visibleTo true
    ]
    make-current-give-number currentPosition

  ]

end


to resize_activities_spatial
  let x_fit (numPanelPatches  - arrow_area) / activities_per_row
  let activity_rows  floor ((activityPanelSpatialHeight) / x_fit)


  let y_fit x_fit

  ;;how much empty space do we need to account for
  ;;let x_spacer (numPanelPatches / activities_per_row - x_fit) / activities_per_row
  let x_spacer 0
  let y_spacer ((activityPanelSpatialHeight) / activity_rows - y_fit) / activity_rows

  ;; now we know how many will fit in our space (activity_rows by activities_per_row
  ;; place them starting from the top
  let selectionCounter 0
  if any? selections [set selectionCounter max [counter] of selections]

  foreach n-values (activity_rows) [ ?1 ->  ?1 + 1 ] [ ?1 ->
    let row_num ?1
    foreach n-values (activities_per_row) [ ?2 ->  ?2 + 1 ] [ ?2 ->
      let col_num ?2
      set selectionCounter selectionCounter + 1
      create-selections 1 [setxy ((- numPanelPatches) + (x_fit + x_spacer) * (col_num - 1) + (x_fit + x_spacer) / 2 - 0.5) ((activityPanelSpatialBottom + activityPanelSpatialHeight - 1) - (y_fit + y_spacer) * (row_num - 1) - (y_fit + y_spacer) / 2 + 0.5)
        set size x_fit * selection_rel_size
        set counter selectionCounter
        set visibleTo n-values numPlayers [0]
        set showing n-values numPlayers [0]
        set spatial? true
      ]

    ]
  ]


end

to resize_activities_nonspatial
  let x_fit (numPanelPatches  - arrow_area) / activities_per_row
  let activity_rows  floor ((activityPanelNonSpatialHeight) / x_fit)


  let y_fit x_fit

  ;;how much empty space do we need to account for
  ;;let x_spacer (numPanelPatches / activities_per_row - x_fit) / activities_per_row
  let x_spacer 0
  let y_spacer ((activityPanelNonSpatialHeight) / activity_rows - y_fit) / activity_rows

  ;; now we know how many will fit in our space (activity_rows by activities_per_row
  ;; place them starting from the top
  let selectionCounter 0
  if any? selections [set selectionCounter max [counter] of selections]

  foreach n-values (activity_rows) [ ?1 ->  ?1 + 1 ] [ ?1 ->
    let row_num ?1
    foreach n-values (activities_per_row) [ ?2 ->  ?2 + 1 ] [ ?2 ->
      let col_num ?2
      set selectionCounter selectionCounter + 1
      create-selections 1 [setxy ((- numPanelPatches) + (x_fit + x_spacer) * (col_num - 1) + (x_fit + x_spacer) / 2 - 0.5) ((activityPanelNonSpatialBottom + activityPanelNonSpatialHeight - 1) - (y_fit + y_spacer) * (row_num - 1) - (y_fit + y_spacer) / 2 + 0.5)
        set size x_fit * selection_rel_size
        set counter selectionCounter
        set visibleTo n-values numPlayers [0]
        set showing n-values numPlayers [0]
        set spatial? false
      ]

      create-plusses 1 [setxy ((- numPanelPatches) + (x_fit + x_spacer) * (col_num - 1) + (x_fit + x_spacer) / 4 - 0.5) ((activityPanelNonSpatialBottom + activityPanelNonSpatialHeight - 1) - (y_fit + y_spacer) * (row_num - 1) - (y_fit + y_spacer) * 3 / 4 + 0.5 )
        set size x_fit * plusminus_rel_size
        set color gray
        set counter selectionCounter
        set visibleTo n-values numPlayers [0]
        set showing visibleTo
      ]
      create-minuses 1 [setxy ((- numPanelPatches) + (x_fit + x_spacer) * (col_num - 1) + (x_fit + x_spacer) * 3 / 4 - 0.5) ((activityPanelNonSpatialBottom + activityPanelNonSpatialHeight - 1) - (y_fit + y_spacer) * (row_num - 1) - (y_fit + y_spacer) * 3 / 4 + 0.5 )
        set size x_fit * plusminus_rel_size
        set color gray
        set counter selectionCounter
        set visibleTo n-values numPlayers [0]
        set showing visibleTo
      ]
    ]
  ]


end
to draw_box [box_x box_y box_w box_h color_num bar_size]


  let overlap_bar bar_size * 1.

  let remaining_length box_w
  let not_first 0
  while [ remaining_length > 0] [
    if remaining_length < bar_size [set remaining_length bar_size]
    create-borders 1 [set color color_num set size overlap_bar
      setxy box_x + bar_size / 2 + box_w - remaining_length - (overlap_bar - bar_size) * not_first box_y
      set not_first 1
      set heading 90
      stamp die ]
      set remaining_length remaining_length - bar_size
  ]

  set remaining_length box_w
  set not_first 0
  while [ remaining_length > 0] [
    if remaining_length < bar_size [set remaining_length bar_size]
    create-borders 1 [set color color_num set size overlap_bar
      setxy box_x + bar_size / 2 + box_w - remaining_length - (overlap_bar - bar_size)  * not_first box_y + box_h
      set not_first 1
      set heading 90
      stamp die ]
      set remaining_length remaining_length - bar_size
  ]

  set remaining_length box_h
  set not_first 0
  while [ remaining_length > 0] [
    if remaining_length < bar_size [set remaining_length bar_size]
    create-borders 1 [set color color_num set size overlap_bar
      setxy box_x box_y + bar_size / 2 + box_h - remaining_length - (overlap_bar - bar_size)  * not_first
      set not_first 1
      set heading 0
      stamp die ]
      set remaining_length remaining_length - bar_size
  ]

  set remaining_length box_h
  set not_first 0
  while [ remaining_length > 0] [
    if remaining_length < bar_size [set remaining_length bar_size]
    create-borders 1 [set color color_num set size overlap_bar
      setxy box_x + box_w box_y + bar_size / 2 + box_h - remaining_length - (overlap_bar - bar_size)  * not_first
      set not_first 1
      set heading 0
      stamp die ]
      set remaining_length remaining_length - bar_size
  ]

end

to read-activity-file

  ;; try to read in the input parameter data - stop if the file doesn't exist
  if not file-exists? activityListFileName [ ;;if game parameter file is incorrect
    user-message "Please enter valid file name for activity data"
    stop
  ]

  ;; open the file and read it in line by line
  set activityInputs csv:from-file activityListFileName
  set activity_property_labels item 0 activityInputs
  foreach but-first activityInputs [ ?0 ->

    let currentActivity ?0

    create-activities 1 [
    ;; there are two lists - one with variable names, one with values
    (foreach activity_property_labels currentActivity [ [?1 ?2] -> ;; first element is variable name, second element is value

      ;; we use a 'parameter handled' structure to avoid having nested foreach statements, in case there are different ways to handle inputs
      set parameterHandled 0

      ;; requirement list and phase shown list may come in as a single value, or may be multiple values
      if parameterHandled = 0 and (?1 = "req" or ?1 = "phase_shown" or ?1 = "cost" or ?1 = "threshold") [  ;; any other case
        file-print (word ?1 ": " ?2 )
        let currentParameter []
        set currentParameter (word "set " ?1 " (list " ?2 ")" )

        run currentParameter
        set parameterHandled 1
      ]

        ;; all other cases not specified above are handled as below - the parameter of the same name is set to the specified value
      if parameterHandled = 0 [  ;; any other case
        ;;output-print (word ?1 ": " ?2 )
        file-print (word ?1 ": " ?2 )
        let currentParameter []
        ifelse is-string? ?2 [
          set currentParameter (word "set " ?1 "  \"" ?2 "\"" )
        ][
          set currentParameter (word "set " ?1 " " ?2 )
        ]
        run currentParameter
        set parameterHandled 1
      ]

    ])

    ]
  ]

  set activityCostList n-values (count activities) [0]
  set activityBenefitList n-values (count activities) [0]
  foreach n-values (count activities) [ ?1 -> ?1 + 1] [ ?1 ->

    ask one-of activities with [ID = ?1] [
      set activityCostList replace-item (?1 - 1) activityCostList cost
      set activityBenefitList replace-item (?1 - 1) activityBenefitList benefit
    ]

  ]

  output-print "Activity file read."


end

to read-env-var-file



  ;; try to read in the input parameter data - stop if the file doesn't exist
  if not file-exists? envVarListFileName [ ;;if game parameter file is incorrect
    user-message "Please enter valid file name for environmental variable data"
    stop
  ]

  ;; open the file and read it in line by line
  set envVarInputs csv:from-file envVarListFileName
  set envVar_property_labels item 0 envVarInputs
  foreach but-first envVarInputs [ ?0 ->

    let currentEnvVar ?0

    create-env-vars 1 [
    ;; there are two lists - one with variable names, one with values
    (foreach envVar_property_labels currentEnvVar [ [?1 ?2] -> ;; first element is variable name, second element is value

      ;; we use a 'parameter handled' structure to avoid having nested foreach statements, in case there are different ways to handle inputs
      set parameterHandled 0

      ;; requirement list and phase shown list may come in as a single value, or may be multiple values
      if parameterHandled = 0 and (?1 = "req" or ?1 = "phases") [  ;; any other case
        file-print (word ?1 ": " ?2 )
        let currentParameter []
        set currentParameter (word "set " ?1 " (list " ?2 ")" )

        run currentParameter
        set parameterHandled 1
      ]

        ;; all other cases not specified above are handled as below - the parameter of the same name is set to the specified value
      if parameterHandled = 0 [  ;; any other case
        ;;output-print (word ?1 ": " ?2 )
        file-print (word ?1 ": " ?2 )
        let currentParameter []
        ifelse is-string? ?2 [
          set currentParameter (word "set " ?1 "  \"" ?2 "\"" )
        ][
          set currentParameter (word "set " ?1 " " ?2 )
        ]

        run currentParameter
        set parameterHandled 1
      ]

    ])

    ]
  ]


  output-print "Environmental function file read."


end

to read-env-function-file



  ;; try to read in the input parameter data - stop if the file doesn't exist
  if not file-exists? envFunctionListFileName [ ;;if game parameter file is incorrect
    user-message "Please enter valid file name for environmental function data"
    stop
  ]

  ;; open the file and read it in line by line
  set envFunctionInputs csv:from-file envFunctionListFileName
  set envFunction_property_labels item 0 envFunctionInputs
  foreach but-first envFunctionInputs [ ?0 ->

    let currentEnvFunction ?0

    create-env-functions 1 [
    ;; there are two lists - one with variable names, one with values
    (foreach envFunction_property_labels currentEnvFunction [ [?1 ?2] -> ;; first element is variable name, second element is value

      ;; we use a 'parameter handled' structure to avoid having nested foreach statements, in case there are different ways to handle inputs
      set parameterHandled 0

      ;; requirement list and phase shown list may come in as a single value, or may be multiple values
      if parameterHandled = 0 and (?1 = "req" or ?1 = "phases") [  ;; any other case
        file-print (word ?1 ": " ?2 )
        let currentParameter []
        set currentParameter (word "set " ?1 " (list " ?2 ")" )

        run currentParameter
        set parameterHandled 1
      ]

        ;; all other cases not specified above are handled as below - the parameter of the same name is set to the specified value
      if parameterHandled = 0 [  ;; any other case
        ;;output-print (word ?1 ": " ?2 )
        file-print (word ?1 ": " ?2 )
        let currentParameter []
        ifelse is-string? ?2 [
          set currentParameter (word "set " ?1 "  \"" ?2 "\"" )
        ][
          set currentParameter (word "set " ?1 " " ?2 )
        ]

        run currentParameter
        set parameterHandled 1
      ]

    ])

    ]
  ]


  output-print "Environmental function file read."


end


to read-spatial-function-file


  ;; try to read in the input parameter data - stop if the file doesn't exist
  if not file-exists? spatialFunctionListFileName [ ;;if game parameter file is incorrect
    user-message "Please enter valid file name for spatial function data"
    stop
  ]

  set spatialFunctionList (list)
  set spatialFunctionList_String (list)
  set spatialFunctionActivities (list)
  set spatialFunctionPhases (list)
  set spatialFunctionNames (list)
  ;; open the file and read it in line by line
  set spatialFunctionInputs csv:from-file spatialFunctionListFileName
  set spatialFunction_property_labels item 0 spatialFunctionInputs
  foreach but-first spatialFunctionInputs [currentFunction ->

    ;; function input file has 6 items in each record:
    ;;0 - the name,
    ;;1 - the activity ids included
    ;;2 - what they are named as in the anonymous command
    ;;3 - the anonymous right hand side
    ;;4 - the anonymous left hand side outcome variable
    ;;5 - whether we are adding to or replacing the LHS variable
    ;;6 - the phases it is estimated in

    ;;set up the anonymous command, depending on whether the outcome is a member of the activity list, or a different variable
    let temp_lhs []
    let currentString []
    if-else is-string? item 4 currentFunction [
      set temp_lhs item 4 currentFunction
      if-else item 5 currentFunction = "add" [
        set currentString (word "[[" item 2 currentFunction "] -> set " temp_lhs " " temp_lhs " + (" item 3 currentFunction ")]")
      ][
        set currentString (word "[[" item 2 currentFunction "] -> set " temp_lhs "(" item 3 currentFunction ")]")
      ]
    ][
      set temp_lhs (word  item 4 currentfunction " tempActivityList")
      if-else item 5 currentFunction = "add" [
        set currentString (word "[[ " item 2 currentFunction "] -> set tempLocal item " ((item 4 currentfunction) - 1) " activity_record "
          " set activity_record (replace-item " ((item 4 currentfunction) - 1) " activity_record tempLocal + (" item 3 currentFunction "))]")
        ;; replace the list of activities with an updated list that adds the current function value to the identified item
      ][
        set currentString (word "[[ " item 2 currentFunction "] -> set tempLocal item " ((item 4 currentfunction) - 1) " activity_record "
          " set activity_record (replace-item " ((item 4 currentfunction) - 1) " activity_record (" item 3 currentFunction "))]")
        ;; replace the list of activities with an updated list that replaces the current function value with the identified item
      ]
    ]

    ;;add function to functionList
    set spatialFunctionList_String lput currentString spatialFunctionList_String

    ;;add name to name list
    set spatialFunctionNames lput item 0 currentFunction spatialFunctionNames

    ;;add input requirements to list.
    let tempActivities n-values (count activities) [0]
    set tempList (word "set tempList (list " item 1 currentFunction ")")
    run tempList
    foreach tempList [x -> set tempActivities replace-item (x - 1) tempActivities 1]
    set spatialFunctionActivities lput tempActivities spatialFunctionActivities

    ;;add phases applied to list
    let tempPhases n-values (numPhases + 1) [0] ;;Note - tempPhases is 1-indexed ... the '0' value captures any functions to be executed BEFORE phase 1 starts
    set tempList (word "set tempList (list " item 6 currentFunction ")")
    run tempList
    foreach tempList [x -> set tempPhases replace-item (x - 1) tempPhases 1]
    set spatialFunctionPhases lput tempPhases spatialFunctionPhases

  ]

  output-print "Spatial Function file read."


end


to read-nonplayer-function-file


  ;; try to read in the input parameter data - stop if the file doesn't exist
  if not file-exists? nonplayerFunctionListFileName [ ;;if game parameter file is incorrect
    user-message "Please enter valid file name for nonplayer function data"
    stop
  ]

  set nonplayerFunctionList (list)
  set nonplayerFunctionList_String (list)
  set nonplayerFunctionActivities (list)
  set nonplayerFunctionPhases (list)
  set nonplayerFunctionNames (list)
  ;; open the file and read it in line by line
  set nonplayerFunctionInputs csv:from-file nonplayerFunctionListFileName
  set nonplayerFunction_property_labels item 0 nonplayerFunctionInputs
  foreach but-first nonplayerFunctionInputs [currentFunction ->

    ;; function input file has 4 items in each record:
    ;;0 - the name,

    ;;1 - the anonymous right hand side
    ;;2 - the anonymous left hand side outcome variable
    ;;3 - whether we are adding to or replacing the LHS variable
    ;;4 - the phases it is estimated in

    ;;set up the anonymous command, depending on whether the outcome is a member of the activity list, or a different variable
    let temp_lhs []
    let currentString []

    set temp_lhs item 2 currentFunction
    (if-else item 3 currentFunction = "add" [
      set currentString (word "set " temp_lhs " " temp_lhs " + (" item 1 currentFunction ")")
      ]
      item 3 currentFunction = "replace" [
        set currentString (word "set " temp_lhs " (" item 1 currentFunction ")")
      ]
      empty? item 3 currentFunction [
        set currentString item 1 currentFunction
    ])


    ;;add function to functionList
    set nonplayerFunctionList_String lput currentString nonplayerFunctionList_String

    ;;add name to name list
    set nonplayerFunctionNames lput item 0 currentFunction nonplayerFunctionNames

    ;;add phases applied to list
    let tempPhases n-values (numPhases + 1) [0] ;;Note - tempPhases is 1-indexed ... the '0' value captures any functions to be executed BEFORE phase 1 starts
    set tempList (word "set tempList (list " item 4 currentFunction ")")
    run tempList
    foreach tempList [x -> set tempPhases replace-item x tempPhases 1] ;; again, note that this is 1-indexed
    set nonplayerFunctionPhases lput tempPhases nonplayerFunctionPhases

  ]

  output-print "Nonplayer Function file read."


end


to read-nonspatial-function-file


  ;; try to read in the input parameter data - stop if the file doesn't exist
  if not file-exists? nonspatialFunctionListFileName [ ;;if game parameter file is incorrect
    user-message "Please enter valid file name for nonspatial function data"
    stop
  ]

  set nonspatialFunctionList (list)
  set nonspatialFunctionList_String (list)
  set nonspatialFunctionActivities (list)
  set nonspatialFunctionPhases (list)
  set nonspatialFunctionNames (list)
  ;; open the file and read it in line by line
  set nonspatialFunctionInputs csv:from-file nonspatialFunctionListFileName
  set nonspatialFunction_property_labels item 0 nonspatialFunctionInputs
  foreach but-first nonspatialFunctionInputs [currentFunction ->

    ;; function input file has 6 items in each record:
    ;;0 - the name,
    ;;1 - the activity ids included
    ;;2 - what they are named as in the anonymous command
    ;;3 - the anonymous right hand side
    ;;4 - the anonymous left hand side outcome variable
    ;;5 - whether we are adding to or replacing the LHS variable
    ;;6 - the phases it is estimated in

    ;;set up the anonymous command, depending on whether the outcome is a member of the activity list, or a different variable
    let temp_lhs []
    let currentString []
    if-else is-string? item 4 currentFunction [
      set temp_lhs item 4 currentFunction
      if-else item 5 currentFunction = "add" [
        set currentString (word "[[playerNumber " item 2 currentFunction "] -> set " temp_lhs " replace-item playerNumber " temp_lhs " ((item playerNumber " temp_lhs ") + (" item 3 currentFunction "))]")
      ][
        set currentString (word "[[playerNumber " item 2 currentFunction "] -> set " temp_lhs " replace-item playerNumber " temp_lhs " (" item 3 currentFunction ")]")
      ]
    ][
      set temp_lhs (word  item 4 currentfunction " tempActivityList")
      if-else item 5 currentFunction = "add" [
      set currentString (word "[[playerNumber " item 2 currentFunction "] -> set tempActivityList item playerNumber playerActivities "
       " set playerActivities replace-item playerNumber playerActivities (replace-item " ((item 4 currentfunction) - 1) " tempActivityList item " ((item 4 currentfunction) - 1) " tempActivityList + (" item 3 currentFunction "))]")
        ;; replace the list of activities for the current player with an updated list that adds the current function value to the identified item for this player
      ][
       set currentString (word "[[playerNumber " item 2 currentFunction "] -> set tempActivityList item playerNumber playerActivities "
       " set playerActivities replace-item playerNumber playerActivities (replace-item " ((item 4 currentfunction) - 1) " tempActivityList (" item 3 currentFunction "))]")
    ;; replace the list of activities for the current player with an updated list that replaces the current function value with the identified item for this player
      ]
    ]

    ;;add function to functionList
    set nonspatialFunctionList_String lput currentString nonspatialFunctionList_String

    ;;add name to name list
    set nonspatialFunctionNames lput item 0 currentFunction nonspatialFunctionNames

    ;;add input requirements to list.
    let tempActivities n-values (count activities) [0]
    set tempList (word "set tempList (list " item 1 currentFunction ")")
    run tempList
    foreach tempList [x -> set tempActivities replace-item (x - 1) tempActivities 1]
    set nonspatialFunctionActivities lput tempActivities nonspatialFunctionActivities

    ;;add phases applied to list
    let tempPhases n-values numPhases [0]
    set tempList (word "set tempList (list " item 6 currentFunction ")")
    run tempList
    foreach tempList [x -> set tempPhases replace-item (x - 1) tempPhases 1]
    set nonspatialFunctionPhases lput tempPhases nonspatialFunctionPhases

  ]

  output-print "Nonspatial Function file read."


end

to read-endgame-function-file


  ;; try to read in the input parameter data - stop if the file doesn't exist
  if not file-exists? endgameFunctionListFileName [ ;;if game parameter file is incorrect
    user-message "Please enter valid file name for endgame function data"
    stop
  ]

  set endgameFunctionList (list)
  set endgameFunctionList_String (list)
  set endgameFunctionActivities (list)
  set endgameFunctionNames (list)
  ;; open the file and read it in line by line
  set endgameFunctionInputs csv:from-file endgameFunctionListFileName
  set endgameFunction_property_labels item 0 endgameFunctionInputs
  foreach but-first endgameFunctionInputs [currentFunction ->

    ;; function input file has 5 items in each record:
    ;;0 - the name,
    ;;1 - the activity ids included
    ;;2 - what they are named as in the anonymous command
    ;;3 - the anonymous right hand side
    ;;4 - the anonymous left hand side outcome variable
    ;;5 - whether we are adding to or replacing the LHS variable


    ;;set up the anonymous command, depending on whether the outcome is a member of the activity list, or a different variable
    let temp_lhs []
    let currentString []
    if-else is-string? item 4 currentFunction [
      set temp_lhs item 4 currentFunction
      if-else item 5 currentFunction = "add" [
        set currentString (word "[[playerNumber " item 2 currentFunction "] -> set " temp_lhs " replace-item playerNumber " temp_lhs " ((item playerNumber " temp_lhs ") + (" item 3 currentFunction "))]")
      ][
        set currentString (word "[[playerNumber " item 2 currentFunction "] -> set " temp_lhs " replace-item playerNumber " temp_lhs " (" item 3 currentFunction ")]")
      ]
    ][
      set temp_lhs (word  item 4 currentfunction " tempActivityList")
      if-else item 5 currentFunction = "add" [
      set currentString (word "[[playerNumber " item 2 currentFunction "] -> set tempActivityList item playerNumber playerActivities "
       " set playerActivities replace-item playerNumber playerActivities (replace-item " ((item 4 currentfunction) - 1) " tempActivityList item " ((item 4 currentfunction) - 1) " tempActivityList + (" item 3 currentFunction "))]")
        ;; replace the list of activities for the current player with an updated list that adds the current function value to the identified item for this player
      ][
       set currentString (word "[[playerNumber " item 2 currentFunction "] -> set tempActivityList item playerNumber playerActivities "
       " set playerActivities replace-item playerNumber playerActivities (replace-item " ((item 4 currentfunction) - 1) " tempActivityList (" item 3 currentFunction "))]")
    ;; replace the list of activities for the current player with an updated list that replaces the current function value with the identified item for this player
      ]
    ]

    ;;add function to functionList
    set endgameFunctionList_String lput currentString endgameFunctionList_String

    ;;add name to name list
    set endgameFunctionNames lput item 0 currentFunction endgameFunctionNames

    ;;add input requirements to list.
    let tempActivities n-values (count activities) [0]
    set tempList (word "set tempList (list " item 1 currentFunction ")")
    run tempList
    foreach tempList [x -> set tempActivities replace-item (x - 1) tempActivities 1]
    set endgameFunctionActivities lput tempActivities endgameFunctionActivities

  ]

  output-print "Nonspatial Function file read."


end

to set-game-parameters

  ;; this procedure takes the list of parameters names and values and processes them for use in the current game

  ;; take the current game's set of parameters
  let currentGameParameters item 0 currentSessionParameters
  set currentSessionParameters sublist currentSessionParameters 1 length currentSessionParameters

  ;; there are two lists - one with variable names, one with values
  (foreach inputFileLabels currentGameParameters [ [?1 ?2] -> ;; first element is variable name, second element is value

    ;; we use a 'parameter handled' structure to avoid having nested foreach statements
    set parameterHandled 0

    ;; if it's the game id, set the game tag as being a practice (if it's 0) or game number otherwise
    if ?1 = "gameID" and parameterHandled = 0[
      ifelse ?2 = 0 [ set gameTag "GP" output-print (word "Game: GP") file-print (word "Game: GP")] [ set gameTag (word "G" ?2) output-print (word "Game: G" ?2) file-print (word "Game: G" ?2)]
      ;;output-print " "
      ;;output-print " "
      ;;output-print "Relevant Game Parameters:"
      ;;output-print " "
      ;;file-print (word ?1 ": " ?2 )
      ;;set parameterHandled 1
    ]

    ;; add any particular cases for parameter handling here [SEE GREEN RESERVES GAME FOR EXAMPLES]



    ;; all other cases not specified above are handled as below - the parameter of the same name is set to the specified value
    if parameterHandled = 0 [  ;; any other case
                               ;;output-print (word ?1 ": " ?2 )
      file-print (word ?1 ": " ?2 )
      let currentParameter []
      ifelse is-string? ?2 [
        set currentParameter (word "set " ?1 "  \"" ?2 "\"" )
      ][
        set currentParameter (word "set " ?1 " " ?2 )
      ]
      set tempLocal currentParameter
      run currentParameter

      set parameterHandled 1
    ]

  ])
  file-print ""

  output-print " "
  output-print " "


  show (word "gameID = " gameID)
  (ifelse
  gameID = 0 [
      output-print "Treatment 0 (Baseline)"
      output-print "Players earn proportional"
      output-print "to their own score"
      output-print ""
      output-print ""
  ]
  gameID = "1A" [
      output-print "Treatment 1A"
      output-print "Players earn proportional"
      output-print "to the LOWEST score"
      output-print ""
      output-print ""
  ]
  gameID = "1B" [
      output-print "Treatment 1B"
      output-print "Players earn proportional"
      output-print "to the AVERAGE score"
      output-print ""
      output-print ""
  ]
  gameID = 2 [
      output-print "Treatment 2"
      output-print "Players decide"
      output-print "payment rule"
      output-print ""
      output-print ""
  ]
    )

end



to update-access [playerNumber]

  ;; get the list of 'how many players are doing each activity right now
  let sumPlayerActivities n-values (count activities) [0]
  let hasSupply sumPlayerActivities
  foreach n-values numPlayers [x -> x][ ?0 ->
    set sumPlayerActivities  (map [ [a b] -> a + b] (item ?0 playerActivities) sumPlayerActivities)
  ]
  ask activities [
   set hasSupply replace-item (ID - 1) hasSupply supply_per
  ]


  let accessList n-values count activities [1]
  let accessBySupply n-values count activities [0]

  ask activities [

    ;; for those that have requirements, check which players meet the reqs - if they miss any
    ;; of them, set to zero UNLESS that requirement has a non-zero 'supply_per' and someone else has it
    foreach req [ ?1 ->

     if item (?1 - 1) (item playerNumber playerActivities) = 0 [ ;; if the player doesn't have this requirement

        if (item (?1 - 1) sumPlayerActivities = 0 or item (?1 - 1) hasSupply = 0) [ ;;i.e., if it isn't a supplied activity that someone else has
          set accessList replace-item (ID - 1) accessList 0
        ]

        if (item (?1 - 1) sumPlayerActivities > 0 and item (?1 - 1) hasSupply > 0) [ ;;i.e., it's a 'supply' var and someone else has it
          set accessBySupply replace-item (ID - 1) accessBySupply 1
        ]

      ]
    ]

    ;; for those that are only visible in certain phases
    if not empty? phase_shown [
      let showNow 0
      ;; set showNow to 1 if we are in any of the phases it should be shown in
      foreach phase_shown [ ?1 ->
        if ?1 = currentPhase [set showNow 1]
      ]

      if showNow = 0 [set accessList replace-item (ID - 1) accessList 0]
    ]
  ]

  set playerAccess replace-item (playerNumber) playerAccess accessList
  set playerAccessBySupply replace-item (playerNumber) playerAccessBySupply accessBySupply


  ;;make sure the arrow settings are appropriate to the new access menu
  ;; this has to be done separately for the 2 menus
  let countSpatial count activities with [item (ID - 1) accessList > 0 and spatial? = true]
  let countNonspatial count activities with [item (ID - 1) accessList > 0 and spatial? = false]

  if-else countSpatial <= count selections with [spatial? = true] [
    ;; the player only needs one menu, so the arrows should indicate this
    ask arrows with [member? "_spatial" identity] [set at-end replace-item (playerNumber) at-end 1]
  ][
    ask arrows with [identity = "up_spatial"] [set at-end replace-item (playerNumber) at-end 1]
    ask arrows with [identity = "down_spatial"] [set at-end replace-item (playerNumber) at-end 0]
  ]
  if-else countnonSpatial <= count selections with [spatial? = false] [
    ;; the player only needs one menu, so the arrows should indicate this
    ask arrows with [member? "_nonspatial" identity] [set at-end replace-item (playerNumber) at-end 1]
  ][
    ask arrows with [identity = "up_nonspatial"] [set at-end replace-item (playerNumber) at-end 1]
    ask arrows with [identity = "down_nonspatial"] [set at-end replace-item (playerNumber) at-end 0]
  ]
  ask arrows [set menu replace-item (playerNumber) menu 0]
end

to update-takes-from

  ;;for every activity that offers a supply to other activities
  ask activities with [not empty? takes_from] [
    let myID ID
    let myTakes takes_from

    ask selections with [member? myID showing] [ ;; ask the selection showing this activity

      foreach n-values numPlayers [x -> x] [?1 ->   ;; for each of the things they are showing, by player
        if (item ?1 visibleTo) = 1 [
          let currentID item ?1 showing


          ask integer-agents with [member? ?1 visibleTo and ID = (word "currentPool " currentID)] [die]
          run (word "integer-as-agents (" myTakes ") 0.5 blue (xcor - size / 3) (ycor + size / 3) (list " ?1 ") (word \"currentPool \" " currentID ") true")

        ]

      ]

    ]

  ]


end

to update-current-supply

  ;;for every activity that offers a supply to other activities
  ask activities with [supply_per > 0] [



  ;;count how many are owned and supplied,
    let assetID ID

    let inUse 0
    set currentSupply 0
    foreach n-values numPlayers [x -> x] [ ?1 ->
       if (item (assetID - 1) (item ?1 playerActivities) = 1) [

        set currentSupply currentSupply + (item (assetID - 1) (item ?1 playerActivities) * supply_per  )
      ]

    ]


    ;;count  how many things requiring it are being done by others who don't own it
    ask activities with [member? assetID req] [


      let reqID ID


      foreach n-values numPlayers [x -> x] [ ?1 ->

        if (item (assetID - 1) (item ?1 playerActivities) = 0) [;; (they don't own it)

          set inUse  (inUse + item (reqID - 1) (item ?1 playerCurrentSelections)) ;; (add the amount of the activity requiring myID that is being done

        ]

      ]

    ]

    ;;now we have the total times asset i is used in other activities j that require it, by others that don't own it
    set currentSupply currentSupply - inUse

  ]


  ask selections  [ ;; ask all the selections

    foreach n-values numPlayers [x -> x] [?1 ->   ;; for each of the things they are showing, by player
      if (item ?1 visibleTo) = 1 [
        let currentID item ?1 showing

        if (item (currentID - 1) (item ?1 playerAccessBySupply) = 1) [   ;;if this player has access to the activity only through a local supply
          let currentReqs []
          ask one-of activities with [ID = currentID] [set currentReqs req]  ;;look across all requirements

          let constrainedSupply min  ([currentSupply] of activities with [member? ID currentReqs]) ;; and find the most constraining supply limit

          ;; save that as the player-specific constraint for this activity
          let currentConstraint item ?1 playerConstrainedSupplies
          set playerConstrainedSupplies replace-item ?1 playerConstrainedSupplies (replace-item (currentID - 1) currentConstraint constrainedSupply)
          ask integer-agents with [member? ?1 visibleTo and ID = (word "currentSupply " currentID)] [die]
          integer-as-agents (constrainedSupply) 0.5 blue (xcor - size / 3) (ycor + size / 3) (list ?1) (word "currentSupply " currentID)
        ]
      ]

    ]

  ]



end

to update-displayed-spatial-activities [playerNumber]

  ;;kill the numbers that were previously there
  ask integer-agents with [member? playerNumber visibleTo and ID = "activityCost_spatial"] [die]
  ask integer-agents with [member? playerNumber visibleTo and member? "currentSupply" ID] [die]

  ;;find out which menu we should be looking at
  let currentMenuCount item (playerNumber) [menu] of one-of arrows with [identity = "up_spatial"]

  let accessList item playerNumber playerAccess


  ;;make ordered list of all displayable activities
  let available-activities sort-on [ID] activities with [item (ID - 1) accessList > 0 and spatial? = true]

  ask selections with [spatial? = true] [hubnet-send-override (item (playerNumber) playerNames) self "shape" ["blank"] set visibleTo replace-item playerNumber visibleTo 0 set showing replace-item playerNumber showing 0]

  if not empty? available-activities [
    set available-activities sublist available-activities (currentMenuCount * count selections with [spatial? = true]) (length available-activities)


    ;;show the available activities

    foreach sort-on [counter] selections with [spatial? = true] [ ?1 ->
      ask ?1 [

        let myCounter counter
        if not empty? available-activities [
          let currentID [ID] of first available-activities
          hubnet-send-override (item (playerNumber) playerNames) self "shape" [[image] of first available-activities]
          hubnet-send-override (item (playerNumber) playerNames) self "color" [item playerNumber playerColor]
          set visibleTo replace-item playerNumber visibleTo 1
          set showing replace-item playerNumber showing currentID
          let myShowing item playerNumber showing

          ;;show the cost of doing this
          let costList [cost] of one-of activities with [ID = myShowing]
          let thresList [threshold] of one-of activities with [ID = myShowing]
          let currentCount count patches with [doing = myShowing and selectedBy = playerNumber]
          let notDone false
          if length costList > 1 [
            set notDone (currentCount >= item 1 thresList)
          ]
          while [length costList > 1 and notDone] [
            set costList but-first costList
            set thresList but-first thresList
            if length costList > 1 [
              set notDone (currentCount >= item 1 thresList)
            ]
          ]
          let currentCost item 0 costList


          integer-as-agents (currentCost) 0.5 pink (xcor + size / 3) (ycor + size / 3) (list playerNumber) "activityCost_spatial"

          ;;if this player has access to the activity only through a local supply, show the local supply
          if (item (currentID - 1) (item playerNumber playerAccessBySupply) = 1) [
            integer-as-agents (item (myShowing - 1) (item playerNumber playerConstrainedSupplies)) 0.5 blue (xcor - size / 3) (ycor + size / 3) (list playerNumber) (word "currentSupply " myShowing)
          ]

          ;;if this activity has a pooled availability (like a loan fund) show the pooled supply
          if not empty? [takes_from] of one-of activities with [ID = myShowing] [
            set tempLocal 0
            run (word "set tempLocal " [takes_from] of one-of activities with [ID = myShowing])
            integer-as-agents tempLocal 0.5 blue (xcor - size / 3) (ycor + size / 3) (list playerNumber) (word "currentPool " myShowing)
          ]

          set available-activities but-first available-activities
        ]
      ]

    ]

  ]

  ;;make sure the arrows appropriately reflect availability of menus
  ask arrows [

    if-else item playerNumber at-end = 0 [

      hubnet-send-override (item playerNumber playerNames) self "color" [arrowNotEndColor]
    ][

        hubnet-send-override (item playerNumber playerNames) self "color" [arrowEndColor]
    ]
  ]

end


to update-displayed-nonspatial-activities [playerNumber]

  ;;kill the numbers that were previously there
  ask integer-agents with [member? playerNumber visibleTo and ID = "activityCost_nonspatial"] [die]
  ask integer-agents with [member? playerNumber visibleTo and member? "currentSupply" ID] [die]

  ;;find out which menu we should be looking at
  let currentMenuCount item (playerNumber) [menu] of one-of arrows with [identity = "up_nonspatial"]

  let accessList item playerNumber playerAccess


  ;;make ordered list of all displayable activities
  let available-activities sort-on [ID] activities with [item (ID - 1) accessList > 0 and spatial? = false]


  ask selections with [spatial? = false] [hubnet-send-override (item (playerNumber) playerNames) self "shape" ["blank"] set visibleTo replace-item playerNumber visibleTo 0 set showing replace-item playerNumber showing 0]
  ask plusses [hubnet-send-override (item (playerNumber) playerNames) self "shape" ["blank"] set visibleTo replace-item playerNumber visibleTo 0 set showing replace-item playerNumber showing 0]
  ask minuses [hubnet-send-override (item (playerNumber) playerNames) self "shape" ["blank"] set visibleTo replace-item playerNumber visibleTo 0 set showing replace-item playerNumber showing 0]

  if not empty? available-activities [
    set available-activities sublist available-activities (currentMenuCount * count selections) (length available-activities)


    ;;show the available activities

    foreach sort-on [counter] selections with [spatial? = false] [ ?1 ->
      ask ?1 [

        let myCounter counter
        if not empty? available-activities [
          let currentID [ID] of first available-activities
          hubnet-send-override (item (playerNumber) playerNames) self "shape" [[image] of first available-activities]
          set visibleTo replace-item playerNumber visibleTo 1
          set showing replace-item playerNumber showing currentID
          let myShowing item playerNumber showing

          ;;show the cost of doing this (cost is a list, but is always one item long for nonspatial activities)
          integer-as-agents ([item 0 cost] of one-of activities with [ID = myShowing]) 0.5 pink (xcor + size / 3) (ycor + size / 3) (list playerNumber) "activityCost_nonspatial"



          ;;if this player has access to the activity only through a local supply, show the local supply
          if (item (currentID - 1) (item playerNumber playerAccessBySupply) = 1) [
            integer-as-agents (item (myShowing - 1) (item playerNumber playerConstrainedSupplies)) 0.5 blue (xcor - size / 3) (ycor + size / 3) (list playerNumber) (word "currentSupply " myShowing)
          ]

          ;;if this activity has a pooled availability (like a loan fund) show the pooled supply
          if not empty? [takes_from] of one-of activities with [ID = myShowing] [
            set tempLocal 0
            run (word "set tempLocal " [takes_from] of one-of activities with [ID = myShowing])
            integer-as-agents tempLocal 0.5 blue (xcor - size / 3) (ycor + size / 3) (list playerNumber) (word "currentPool " myShowing)
          ]

          ask plusses with [counter = myCounter] [hubnet-send-override (item (playerNumber) playerNames) self "shape" ["badge-plus"]
            set visibleTo replace-item playerNumber visibleTo 1
            update-colors currentID playerNumber
            set showing replace-item playerNumber showing currentID]
          ask minuses with [counter = myCounter] [hubnet-send-override (item (playerNumber) playerNames) self "shape" ["badge-minus"]
            set visibleTo replace-item playerNumber visibleTo 1
            update-colors currentID playerNumber
            set showing replace-item playerNumber showing currentID]

          set available-activities but-first available-activities
        ]
      ]

    ]

  ]

  ;;make sure the arrows appropriately reflect availability of menus
  ask arrows [

    if-else item playerNumber at-end = 0 [

      hubnet-send-override (item playerNumber playerNames) self "color" [arrowNotEndColor]
    ][

        hubnet-send-override (item playerNumber playerNames) self "color" [arrowEndColor]
    ]
  ]

end


to integer-as-agents [intI sizeI colI posX posY seen_by name]


  let strI (word intI)
  let offset 0
  while [length strI > 0] [
   let currentI first strI
    ask one-of patches [  ;; a little hack to make this procedure usable both in observer and turtle context - ask a patch to do it.
      sprout-integer-agents 1 [
        set visibleTo (list)
        setxy  posX + offset posY
        set size sizeI
        if-else currentI = "-" [
          set shape "num-minus"
        ][
          set shape item (read-from-string currentI) number_shape_list]
        set color colI
        set ID name


        foreach n-values (numPlayers) [?2 -> ?2 ] [ ?2 ->

          if-else (member? ?2 seen_by) [
            set visibleTo lput ?2 visibleTo
          ] [
            hubnet-send-override  (item (?2) playerNames) self "shape" ["blank"]
          ]
        ]


      ]

    ]
    set strI but-first strI

    set offset offset + sizeI * 0.5
  ]


end


to player-square-activity [playerNumber currentIdentity]

  if playerNumber != (showing - 1) [
    let mySize size
    ;;remove all selected squares for this player
    ask selected-squares with [identity = "give selection" and showing = playerNumber] [die]


    if-else item playerNumber active? [
      ;;if this *was* active for this player, make it not active (and all others for good measure)
      ask player-squares with [identity = "give square"] [set active? (replace-item playerNumber active? false)]

    ]
    [
      ;;if this wasn't active for this player, make it (and only it) active for this player
      ask player-squares with [identity = "give square"] [set active? (replace-item playerNumber active? false)]
      set active? (replace-item playerNumber active? true)

      hatch-selected-squares 1
      [ set color white
        set size mySize * 1.1
        set identity "give selection"
        set showing playerNumber
        set hidden? false
        foreach n-values (numPlayers) [?2 -> ?2 ] [ ?2 ->
          if ?2 != playerNumber [
            hubnet-send-override  (item (?2) playerNames) self "shape" ["blank"]
          ]
        ]
      ]
    ]

  ]
end

to arrow-activity [playerNumber currentIdentity currentMenu]


  let accessList item (playerNumber) playerAccess
  let countSpatial count activities with [item (ID - 1) accessList > 0 and spatial? = true]
  let countNonspatial count activities with [item (ID - 1) accessList > 0 and spatial? = false]


  let numItems []
  let sizeMenu []
  ifelse member? "_spatial" currentIdentity [
    set numItems countSpatial
    set sizeMenu count selections with [spatial? = true]
  ] [
    set numItems countNonspatial
    set sizeMenu count selections with [spatial? = false]
  ]

  let tag_s_ns []
  ifelse member? "_spatial" currentIdentity [
      set tag_s_ns "_spatial"
    ][
      set tag_s_ns "_nonspatial"
    ]

  ;;update the menu number IF we can actually move to a new menu
  if(member? "down" currentIdentity) and (numItems > sizeMenu * (currentMenu + 1)) [
  ;;request to move down, and there are more items to show
    set currentMenu currentMenu + 1

    ask arrows with [member? tag_s_ns identity] [set menu replace-item playerNumber menu currentMenu]

    ask selected-squares with [visibleTo = playerNumber] [die] ;;we're going to move so all selections are off
  ]

  if(member? "up" currentIdentity) and (currentMenu > 0) [
  ;;request to move down, and there are more items to show
    set currentMenu currentMenu - 1

    ask arrows with [member? tag_s_ns identity] [set menu replace-item playerNumber menu currentMenu]
    ask selected-squares with [visibleTo = playerNumber] [die] ;;we're going to move so all selections are off

  ]


  ;;make sure all arrows are correctly identified as being at end or not
  ;;make sure the arrow settings are appropriate to the new access menu
  if-else numItems <= sizeMenu * (currentMenu + 1) [
    ;; can't go any further
    ask arrows with [identity = (word "down" tag_s_ns)] [set at-end replace-item (playerNumber) at-end 1]
  ][
    ask arrows with [identity = (word "down" tag_s_ns)] [set at-end replace-item (playerNumber) at-end 0]
  ]

  if-else currentMenu > 0 [
    ;; can't go any further
    ask arrows with [identity = (word "up" tag_s_ns)] [set at-end replace-item (playerNumber) at-end 0]
  ][
    ask arrows with [identity = (word "up" tag_s_ns)] [set at-end replace-item (playerNumber) at-end 1]
  ]


  update-displayed-spatial-activities playerNumber
  update-displayed-nonspatial-activities playerNumber
  update-current-supply
  update-takes-from
end

to selection-activity [playerNumber currentSelection location]

  let selectionHandled 0
  ;;if this one is already selected, unselect it, and exit
  if (selectionHandled = 0 and any? selected-squares with [showing = currentSelection and visibleTo = playerNumber]) [
    ask selected-squares with [showing = currentSelection and visibleTo = playerNumber] [die]

    set selectionHandled 1
  ]

  ;;if there is another activity selected, but NOT THIS ONE, unselect it and select this one
  if (selectionHandled = 0 and any? selected-squares with [visibleTo = playerNumber]) [
    ask selected-squares with [visibleTo = playerNumber] [die]
  ]
  if (selectionHandled = 0) [
    hatch-selected-squares 1 [
      setxy (item 0 location) (item 1 location)
      set size 1
      set color item playerNumber playerColor
      set showing currentSelection
      set visibleTo playerNumber
      foreach n-values (numPlayers) [?2 -> ?2 ] [ ?2 ->
            if ?2 != playerNumber [
          hubnet-send-override  (item (?2) playerNames) self "shape" ["blank"]
        ]
      ]
    ]

    set selectionHandled 1
  ]

end

to update-colors [currentCounter playerNumber]

  let currentCount item (currentCounter - 1) (item playerNumber playerCurrentSelections)
  let currentMax [amt_max] of one-of activities with [ID = currentCounter]
  let currentMin [amt_min] of one-of activities with [ID = currentCounter]

  ;;allow for possibility that max values are specified not as numbers but as other variables
  if is-string? currentMax [run (word "set currentMax " currentMax)]

  ask plusses with [item playerNumber showing = currentCounter] [
    if-else currentCount = currentMax [
      ;; code to gray out and disable plus sign
      hubnet-send-override (item (playerNumber) playerNames) self "color" [gray]
    ] [
      hubnet-send-override (item (playerNumber) playerNames) self "color" [blue]
    ]
  ]

  ask minuses with [item playerNumber showing = currentCounter] [
    if-else currentCount = currentMin [
      ;; code to gray out and disable plus sign
      hubnet-send-override (item (playerNumber) playerNames) self "color" [gray]

    ] [
      hubnet-send-override (item (playerNumber) playerNames) self "color" [blue]

    ]
  ]

end

to giving-plus-activity [currentMessagePosition]

  let budget (item currentMessagePosition playerResources) - (item currentMessagePosition playerCurrentResources) -  (item currentMessagePosition playerTempGiving)




  if budget > 0 [
    let tempAmount item currentMessagePosition playerTempGiving
    set playerTempGiving replace-item currentMessagePosition playerTempGiving (tempAmount + 1)
  ]

  make-current-give-number currentMessagePosition

end

to giving-minus-activity [currentMessagePosition]

  let currentGiving (item currentMessagePosition playerTempGiving)


  if currentGiving > 0 [
    set playerTempGiving replace-item currentMessagePosition playerTempGiving (currentGiving - 1)
  ]

  make-current-give-number currentMessagePosition

end

to plus-activity [currentMessagePosition]

  let myActivity item currentMessagePosition showing
  let currentMax [amt_max] of one-of activities with [ID = myActivity]

  ;;allow for possibility that max values are specified not as numbers but as other variables
  if is-string? currentMax [run (word "set currentMax " currentMax)]

  let takes_from? false
  set tempLocal 1
  ;;check if this is constrained externally by a 'takes_from' variable
  if( not empty? [takes_from] of one-of activities with [ID = myActivity]) [
    set takes_from? true

    run (word "set tempLocal " [takes_from] of one-of activities with [ID = myActivity])
  ]

  let currentCost [item 0 cost] of one-of activities with [ID = myActivity]

  ;; if we can add more of the current activity, do
  let currentCount item (myActivity - 1) (item currentMessagePosition playerCurrentSelections)
  let potentialCost item currentMessagePosition playerCurrentResources + currentCost
  let budget item currentMessagePosition playerResources

  let supplyFlag 1
  if item (myActivity - 1) (item currentMessagePosition playerConstrainedSupplies) = 0 and item (myActivity - 1) (item currentMessagePosition playerAccessBySupply) = 1 [
    ;;this player can only access this thing by supply, and the supply is 0
    set supplyFlag 0
  ]

  if (currentCount < currentMax and potentialCost <= budget and supplyFlag = 1 and tempLocal > 0) [
    set currentCount currentCount + 1
    set playerCurrentSelections (replace-item currentMessagePosition playerCurrentSelections (replace-item (myActivity - 1) (item currentMessagePosition playerCurrentSelections) (currentCount)))

    if takes_from? [
      let currentVar [takes_from] of one-of activities with [ID = myActivity]
      run (word "set " currentVar " " currentVar " - 1")
    ]

  ]

  update-colors myActivity currentMessagePosition
  update-current-selections currentMessagePosition
  update-current-supply
  update-takes-from


end

to minus-activity [currentMessagePosition]

 let myActivity item currentMessagePosition showing
  let currentMin [amt_min] of one-of activities with [ID = myActivity]
  let currentCost [item 0 cost] of one-of activities with [ID = myActivity]

  let takes_from? false
  ;;check if this is constrained externally by a 'takes_from' variable
  if( not empty? [takes_from] of one-of activities with [ID = myActivity]) [
    set takes_from? true
  ]

  ;; if we can subtract more of the current activity, do
  let currentCount item (myActivity - 1) (item currentMessagePosition playerCurrentSelections)
  let potentialCost item currentMessagePosition playerCurrentResources - currentCost
  let budget item currentMessagePosition playerResources
  if (currentCount > currentMin and potentialCost <= budget) [
    set currentCount currentCount - 1
    set playerCurrentSelections (replace-item currentMessagePosition playerCurrentSelections (replace-item (myActivity - 1) (item currentMessagePosition playerCurrentSelections) (currentCount)))

    if takes_from? [
      let currentVar [takes_from] of one-of activities with [ID = myActivity]
      run (word "set " currentVar " " currentVar " + 1")
    ]

  ]

  update-colors myActivity currentMessagePosition
  update-current-selections currentMessagePosition
  update-current-supply
  update-takes-from

end

to update-current-selections [playerNumber]
  ;;update the array of currently selected activities in the player panel

  ;;kill whatever was there before
  ask panel-selections with [visibleTo = playerNumber] [die]
  ask integer-agents with [member? playerNumber visibleTo and ID = "selection"] [die]
  ask integer-agents with [member? playerNumber visibleTo and ID = "currentResource"] [die]

  ;;count how many unique activities there are
  let currentItemList (list)
  let currentCountList (list)
  let currentCostList (list)
  let currentBenefitList (list)
  let currentSelectionList (item playerNumber playerCurrentSelections)

  foreach n-values (length currentSelectionList) [?1 -> ?1] [ ?1 ->
    if item ?1 currentSelectionList > 0 and [spatial?] of one-of activities with [ID = ?1 + 1] = false [
      set currentItemList lput ?1 currentItemList
      set currentCountList lput (item ?1 currentSelectionList) currentCountList
      set currentCostList lput ((item 0 item ?1 activityCostList) * (item ?1 currentSelectionList)) currentCostList ;; activityCostList is a nested list, because it includes the spatial activities that can have thresholds/lists
      set currentBenefitList lput ((item ?1 activityBenefitList) * (item ?1 currentSelectionList)) currentBenefitList
    ]
  ]

  ;let currentItems length (filter [i -> i > 0] item playerNumber playerCurrentSelections)

  let currentItems length currentItemList

  ;;estimate the size and positioning of each one
  let availSpace numPanelPatches * (panel_selection_rel_size * 0.95)
  let panelSpacing 0
  if currentItems > 1 [
    set panelSpacing (min list panel_selections_h (availSpace / (currentItems - 1)))
  ]

  let startX  (- numPanelPatches + numPanelPatches * (panel_selection_rel_size * 0.05))

  let tempSize panel_selections_h
  ;;add them all in, making them visible only to current player
  foreach n-values currentItems [?1 -> ?1 ] [ ?1 ->
    hatch-panel-selections 1 [
      setxy (startX + ?1 * panelSpacing) panel_selections_y
      let tempShape [];
      ask one-of activities with [ID = (item ?1 currentItemList) + 1] [set tempShape image] ;;weird workaround to access the shape name
      set shape tempShape
      set size tempSize
      set visibleTo playerNumber
      foreach n-values (numPlayers) [?2 -> ?2 ] [ ?2 ->
        if ?2 != playerNumber [
         hubnet-send-override  (item (?2) playerNames) self "shape" ["blank"]
        ]
      ]
    ]
    integer-as-agents (item ?1 currentCountList) 0.3 white (startX + ?1 * panelSpacing + (tempSize * 0.45)) (panel_selections_y - tempSize * 0.45) (list playerNumber) "selection"

    ]

  set playerCurrentResources replace-item playerNumber playerCurrentResources calculate-resource-use (playerNumber)
  set playerPendingBenefits replace-item playerNumber playerPendingBenefits (sum currentBenefitList)
  ;;
  update-all-resources playerNumber

end

to initialize-env-vars

  ask env-vars [


    let currentCommand (word "set " effectVar " " valueDefault)

    ask patches with [inGame?] [

      run currentCommand

    ]

  ]

end

to estimate-env-vars
  ask env-functions with [member? currentPhase phases] [

    ;; displayType displayLoc
    let myTrigger trigger
    let myNeighborhood? neighborhood?
    let myDirection? direction?
    let myNeighborhoodSize neighborhoodSize
    let myXOffset xOffset
    let myYOffset yOffset
    let myEffectVar effectVar



    let myValueMin []
    let myValueMax []

    ask one-of env-vars with [effectVar = myEffectVar] [


      set myValueMin valueMin
      set myValueMax valueMax

    ]

    let currentEffect []

    set currentEffect (word " + " effectSize)

    let currentCommand (word "set " effectVar " max (list " myValueMin " (min (list " myValueMax " (" effectVar currentEffect "))))")

    ;;find patches where trigger condition met

    let triggerID [ID] of one-of activities with [activity_name = myTrigger]
    ask patches with [doing = triggerID] [



      let affectedNeighbors []
      let myX pxcor
      let myY pycor
      (ifelse
        myNeighborhood? [

          set affectedNeighbors patches with [pxcor <= myX + myNeighborhoodSize and pxcor >= myX - myNeighborhoodSize and
          pycor <= myY + myNeighborhoodSize and pycor >= myY - myNeighborhoodSize]


        ]
        myDirection? [

          set affectedNeighbors patch-at myXOffset myYOffset
        ])

      if any? affectedNeighbors with [inGame?] [

        ask affectedNeighbors [run currentCommand]

      ]



    ]
  ]

end

to update-env-vars


  ask env-vars [

    let labelX []
    let labelY []


    (ifelse
      displayLoc = "LR" [set labelX ( 0.35) set labelY (- 0.35)]
      displayLoc = "UR" [set labelX ( 0.35) set labelY 0.35]
      displayLoc = "LL" [set labelX (- 0.4) set labelY (- 0.35)]
      displayLoc = "UL" [set labelX (- 0.4) set labelY ( 0.35)])


    let myEffectVar effectVar
    let myDisplayColor displayColor
    ask patches with [inGame?] [
      ask integer-agents-here with [ID = (word "env_var_" myEffectVar)] [die]

      let currentInteger (word "integer-as-agents " myEffectVar " 0.25 " myDisplayColor " pxcor + " labelX " pycor + " labelY " (n-values numPlayers [?1 -> ?1]) \"env_var_" myEffectVar "\"")
      run currentInteger

      run (word "set tempLocal " myEffectVar)
      file-print (word "Environmental Variable - " myEffectVar " has value " tempLocal " at patch " pxcor " " pycor " at " date-and-time)

    ]
  ]

end

to update-farm-actions [playerNumber]
  ;;update the array of 'badge' actions taken in the player farm panel

  ;;kill whatever was there before
  ask farm-actions with [visibleTo = playerNumber] [die]
  ask integer-agents with [member? playerNumber visibleTo and ID = "action"] [die]
  ask integer-agents with [member? playerNumber visibleTo and ID = "resource"] [die]

  ;;;;;;;;;;;;;;;;;;;;;
  ;;count how many unique activities there are for badges
  let currentItemList (list)
  let currentCountList (list)
  let currentActionList (item playerNumber playerActivities)
  foreach n-values (length currentActionList) [?1 -> ?1] [ ?1 ->
    if (item ?1 currentActionList > 0) and ([badge] of one-of activities with [ID = ?1 + 1] = 1) [
      set currentItemList lput ?1 currentItemList
      set currentCountList lput (item ?1 currentActionList) currentCountList
    ]
  ]

  let currentItems length currentItemList

  ;; build badges for player's own farm badge list

  ;;estimate the size and positioning of each one
   ;;estimate the size and positioning of each one
  let availSpace numPanelPatches * (panel_selection_rel_size * 0.95)
  let panelSpacing 0
  if currentItems > 1 [
    set panelSpacing (min list panel_selections_h (availSpace / (currentItems - 1)))
  ]

  let startX  (- numPanelPatches + numPanelPatches * (panel_selection_rel_size * 0.05))

  let tempSize panel_selections_h
  ;;add them all in, making them visible only to current player
  foreach n-values currentItems [?1 -> ?1 ] [ ?1 ->
    create-farm-actions 1 [
      setxy (startX + ?1 * panelSpacing) farm_actions_y
      let tempShape [];
      ask one-of activities with [ID = (item ?1 currentItemList) + 1] [set tempShape image] ;;weird workaround to access the shape name
      set shape tempShape
      set size tempSize
      set visibleTo playerNumber
      foreach n-values (numPlayers) [?2 -> ?2 ] [ ?2 ->
        if ?2 != playerNumber [
         hubnet-send-override  (item (?2) playerNames) self "shape" ["blank"]
        ]
      ]
      integer-as-agents (item ?1 currentCountList) 0.3 white (startX + ?1 * panelSpacing + (tempSize * 0.45)) (farm_actions_y - tempSize * 0.45) (list playerNumber) "action"
    ]
  ]



  integer-as-agents (item playerNumber playerResources) 1 green (- numPanelPatches * 0.5) (numPatches * 0.025) (list playerNumber) "resource"


end


to update-nonspatial-functions


  ;;check each function to see if it should be run in this phase


  foreach n-values (length nonspatialFunctionList_String) [?0 -> ?0] [ nonspatialFunctionNumber ->

    ;;if it should be run, run for each player
    if item (currentPhase - 1) (item nonspatialFunctionNumber nonspatialFunctionPhases) > 0 [

      ;;pull the base string for this nonspatialFunction
      let currentFunction_String item nonspatialFunctionNumber nonspatialFunctionList_String

      ;;for each player
      foreach n-values (numPlayers) [?1 -> ?1 ] [ playerNumber ->
        let currentActivityList item nonspatialFunctionNumber nonspatialFunctionActivities
        let currentPlayerActivities item playerNumber playerActivities

        let currentInputs (list)
        foreach n-values (length currentActivityList) [?2 -> ?2] [activityNumber ->
          if item activityNumber currentActivityList > 0 [set currentInputs lput item activityNumber currentPlayerActivities currentInputs ]

        ]



        set currentInputs fput playerNumber currentInputs


        ;;set up a string to run.  i tried to get this to work using anonymous commands, but couldn't figure out how to turn my list of inputs into a set of independent inputs.  this works fine
        let tempA (word currentFunction_String ")")
        foreach n-values (length currentInputs) [?3 -> ?3] [indX ->
          set tempA (word "[" (item (length currentInputs - 1 - indX) currentInputs) "] " tempA)

        ]


        set tempA (word "(foreach " tempA)

        (run tempA)


      ]

    ]
  ]
end


to update-endgame-functions



  ;;check each function to see if it should be run in this phase


  foreach n-values (length endgameFunctionList_String) [?0 -> ?0] [ endgameFunctionNumber ->


      ;;pull the base string for this endgameFunction
      let currentFunction_String item endgameFunctionNumber endgameFunctionList_String

      ;;for each player
      foreach n-values (numPlayers) [?1 -> ?1 ] [ playerNumber ->
        let currentActivityList item endgameFunctionNumber endgameFunctionActivities
        let currentPlayerActivities item playerNumber playerActivities

        let currentInputs (list)
        foreach n-values (length currentActivityList) [?2 -> ?2] [activityNumber ->
          if item activityNumber currentActivityList > 0 [set currentInputs lput item activityNumber currentPlayerActivities currentInputs ]

        ]



        set currentInputs fput playerNumber currentInputs


        ;;set up a string to run.  i tried to get this to work using anonymous commands, but couldn't figure out how to turn my list of inputs into a set of independent inputs.  this works fine
        let tempA (word currentFunction_String ")")
        foreach n-values (length currentInputs) [?3 -> ?3] [indX ->
          set tempA (word "[" (item (length currentInputs - 1 - indX) currentInputs) "] " tempA)

        ]


        set tempA (word "(foreach " tempA)

        (run tempA)


      ]


  ]

  foreach playerPosition [ ?1 ->
    update-all-resources (?1 - 1)
    update-farm-actions (?1 - 1)
  ]

end

to update-spatial-functions


  ;;check each function to see if it should be run in this phase


  foreach n-values (length spatialFunctionList_String) [?0 -> ?0] [ spatialFunctionNumber ->

    ;;if it should be run, run for each patch in the game
    if item (currentPhase - 1) (item spatialFunctionNumber spatialFunctionPhases) > 0 [


      ;;pull the base string for this spatialFunction
      let currentFunction_String item spatialFunctionNumber spatialFunctionList_String

      ;;for each patch in the game
      ask patches with [inGame?] [
        let currentActivityList item spatialFunctionNumber spatialFunctionActivities




        let currentInputs (list)
        foreach n-values (length currentActivityList) [?2 -> ?2] [activityNumber ->
          if item activityNumber currentActivityList > 0 [set currentInputs lput item activityNumber activity_record currentInputs ]

        ]




        ;;set up a string to run.  i tried to get this to work using anonymous commands, but couldn't figure out how to turn my list of inputs into a set of independent inputs.  this works fine
        let tempA (word currentFunction_String ")")
        foreach n-values (length currentInputs) [?3 -> ?3] [indX ->
          set tempA (word "[" (item (length currentInputs - 1 - indX) currentInputs) "] " tempA)

        ]




        set tempA (word "(foreach " tempA)

        (run tempA)


      ]

    ]

  ]
end


to update-nonplayer-functions


  ;;check each function to see if it should be run in this phase


  foreach n-values (length nonplayerFunctionList_String) [?0 -> ?0] [ nonplayerFunctionNumber ->

    ;;if it should be run, run for each player
    if item (currentPhase) (item nonplayerFunctionNumber nonplayerFunctionPhases) > 0 [  ;;; be aware that currentPhase is 1-indexed ... if we have a function meant to be done at currentPhase = 0, it is BEFORE start.

      ;;pull the base string for this function
      let currentFunction_String item nonplayerFunctionNumber nonplayerFunctionList_String

      run currentFunction_String


    ]

  ]

end


to advance-farm-time


  ;;if there are environmental functions to update, do so
  estimate-env-vars
  update-env-vars

  ;;add to the records of patches
  ask patches with [inGame?] [
    if is-number? doing [
      let tempCount item (doing - 1) activity_record
      set activity_record replace-item (doing - 1) activity_record (tempCount + 1)
      set last_doing doing
      set last_selectedBy selectedBy
      set doing []
      set current_doing_cost []
      set selectedBy []

    ]
  ]

    ;;if there are simulation-level variables that current selections need to add to or negate, update them:
  ;; (note that 'takes_from' are updated in real time to avoid budget overruns, while 'adds_to' and 'negate' are only updated once contributions are confirmed
  ask activities with [not empty? adds_to] [
    foreach n-values numPlayers [?1 -> ?1] [?1 ->
      run (word "set " adds_to " " adds_to " + " item (ID - 1) item ?1 playerCurrentSelections)
    ]
  ]
  ask activities with [is-number? negates] [

    foreach n-values numPlayers [?1 -> ?1] [?1 ->

      let currentDebt item (negates - 1) item ?1 playerActivities
      let currentPayment item (ID - 1) item ?1 playerCurrentSelections
      let newDebt currentDebt - currentPayment
      set playerActivities replace-item ?1 playerActivities (replace-item (negates - 1) (item ?1 playerActivities) newDebt)

      file-print (word "Debt - Player " ?1 " paid debt " currentPayment " via activity " ID " at " date-and-time)

    ]
  ]

  ;;if there are farm functions to update, do so.  ALL UPDATES TO ACTIVITY RECORD ARE SPECIFIED IN THE SPATIAL FUNCTIONS INPUT FILE, INCLUDING 'RESET'

  update-nonspatial-functions

  update-spatial-functions


   ;;if there are yields, allocate them to whoever did something last, and reset them
  ask patches with [inGame?] [
   if patch_yield > 0 [

      let tempResources item last_selectedBy playerResources
      set playerResources replace-item last_selectedBy playerResources (tempResources + patch_yield)

      file-print (word "Yield - Player " last_selectedBy " earned yield " patch_yield " from patch " pxcor " " pycor " at " date-and-time)

      ask integer-agents-here with [ID = "yield"] [die]
      integer-as-agents patch_yield 0.65  item last_selectedBy playerColor pxcor pycor (n-values numPlayers [?1 -> ?1]) "yield"


      set patch_yield 0

    ]

  ]


  ;;if there are payments to be made for supplies used, calculate them

  ;; make a blank slate for earned payments by players across activities
  set playerEarnedPayments n-values numPlayers [n-values count activities [0]]


  ;;for activities with payments
  ask activities with [payment > 0] [
    ;;look for activities that rely on them
    let capitalID ID
    let myPayment payment
    let uses 0
    ask activities with [member? capitalID req] [
      ;; look who is doing those activities without owning the capital

      let useID ID
      foreach n-values numPlayers [?1 -> ?1] [?1 ->
        if (item (capitalID - 1) item ?1 playerActivities = 0) and (item (useID - 1) item ?1 playerCurrentSelections > 0) [
          ;;this player doesn't have the capital but used it for this activity
          set uses uses + (item (useID - 1) item ?1 playerCurrentSelections)
        ]

      ]

    ]
    ;; split among owners
    let totalCapital 0
    foreach n-values numPlayers [?1 -> ?1] [?1 ->
      set totalCapital totalCapital + (item (capitalID - 1) item ?1 playerActivities)
    ]

    if totalCapital > 0 [
      foreach n-values numPlayers [?1 -> ?1] [?1 ->
        let tempPayments item ?1 playerEarnedPayments
        set playerEarnedPayments replace-item ?1 playerEarnedPayments replace-item (capitalID - 1) tempPayments round((item (capitalID - 1) item ?1 playerActivities) / totalCapital * myPayment)

        file-print (word "Payment - Player " ?1 " earned payment " round((item (capitalID - 1) item ?1 playerActivities) / totalCapital * myPayment) " from asset " capitalID " at " date-and-time)

      ]
    ]
  ]


 ;;update farm counters

  ;;step through all of players' selections and update their points/farms as necessary
  foreach n-values numPlayers [?1 -> ?1] [?1 ->

    let newActivitiesList (map [ [a b] -> a + b] (item ?1 playerActivities) (item ?1 playerCurrentSelections))
    set playerActivities replace-item ?1 playerActivities newActivitiesList
    set playerCurrentSelections replace-item ?1 playerCurrentSelections (n-values (length newActivitiesList) [0])

    set playerResources replace-item ?1 playerResources ((item ?1 playerResources) - item ?1 playerCurrentResources + item ?1 playerPendingBenefits + sum(item ?1 playerEarnedPayments) + endowment)
    set playerCurrentResources replace-item ?1 playerCurrentResources 0
    set playerPendingBenefits replace-item ?1 playerPendingBenefits 0



    update-farm-actions (?1)


  ]

end

to give-activity [playerNumber]

  ;;mark this player as currently giving
   set playerGiving replace-item playerNumber playerGiving 1

  ;;make a black 'giving window' by asking everyone in it to go blank or black
  ask patches with [pxcor >= give_panel_x and pxcor <= give_panel_x + give_panel_w - 1 and pycor >= give_panel_y and pycor <= give_panel_y + give_panel_h] [
    hubnet-send-override (item (playerNumber) playerNames) self "pcolor" [black]
    ask visuals-here [
      hubnet-send-override (item (playerNumber) playerNames) self "shape" ["blank"]
    ]
    ask integer-agents-here with [member? "env_var_" ID or ID = "yield"] [
      hubnet-send-override (item (playerNumber) playerNames) self "shape" ["blank"]
    ]
  ]
   ask buttons with [identity = "give-cancel"] [
    hubnet-clear-override (item (playerNumber) playerNames) self "shape"
    hubnet-send-override (item (playerNumber) playerNames) self "hidden?" [false]]
  ask buttons with [identity = "give-confirm"] [
    hubnet-clear-override (item (playerNumber) playerNames) self "shape"
    hubnet-send-override (item (playerNumber) playerNames) self "hidden?" [false]]
 ask player-squares [
    hubnet-send-override (item (playerNumber) playerNames) self "hidden?" [false]
    set visibleTo replace-item playerNumber visibleTo true
  ]
  ask giving-minuses  [
    hubnet-send-override (item (playerNumber) playerNames) self "hidden?" [false]
    set visibleTo replace-item playerNumber visibleTo true
  ]
  ask giving-plusses [
    hubnet-send-override (item (playerNumber) playerNames) self "hidden?" [false]
    set visibleTo replace-item playerNumber visibleTo true
  ]
  make-current-give-number playerNumber
end

to make-current-give-number [playerNumber]
  ask integer-agents with [ID = "currentGive" and member? playerNumber visibleTo] [die]
  integer-as-agents (item playerNumber playerTempGiving) 1.5 blue (give_panel_x + 7 * give_panel_w / 10) (give_panel_y + 7 * give_panel_h / 8) (list playerNumber) "currentGive"



  let budget (item playerNumber playerResources) - (item playerNumber playerCurrentResources) -  (item playerNumber playerTempGiving)
  let currentGiving (item playerNumber playerTempGiving)



  ask giving-plusses  [
    if-else budget = 0 [
      ;; code to gray out and disable plus sign
      hubnet-send-override (item (playerNumber) playerNames) self "color" [gray]
    ] [
      hubnet-send-override (item (playerNumber) playerNames) self "color" [blue]
    ]
  ]

  ask giving-minuses  [
    if-else currentGiving = 0 [
      ;; code to gray out and disable plus sign
      hubnet-send-override (item (playerNumber) playerNames) self "color" [gray]

    ] [
      hubnet-send-override (item (playerNumber) playerNames) self "color" [blue]

    ]
  ]
end

to give-cancel-activity [playerNumber]

  set playerTempGiving replace-item playerNumber playerTempGiving 0
  ;;mark this player as finished giving
  set playerGiving replace-item playerNumber playerGiving 0

  ;;make a black 'giving window' by asking everyone in it to go blank or black
  ask patches with [pxcor >= give_panel_x and pxcor <= give_panel_x + give_panel_w - 1 and pycor >= give_panel_y and pycor <= give_panel_y + give_panel_h] [
    hubnet-clear-override (item (playerNumber) playerNames) self "pcolor"
    ask visuals-here [
      hubnet-clear-override (item (playerNumber) playerNames) self "shape"
    ]
    ask integer-agents-here with [member? "env_var_" ID or ID = "yield"] [
      hubnet-clear-override (item (playerNumber) playerNames) self "shape"
    ]
  ]
  ask buttons with [identity = "give-confirm"] [
    hubnet-clear-override (item (playerNumber) playerNames) self "hidden?"
  ]
  ask buttons with [identity = "give-cancel"] [
    hubnet-clear-override (item (playerNumber) playerNames) self "hidden?"
  ]
  ask player-squares [
    hubnet-clear-override (item (playerNumber) playerNames) self "hidden?"
    set visibleTo replace-item playerNumber visibleTo false
    set active? replace-item playerNumber active? false
  ]
  ask giving-minuses [
    hubnet-clear-override (item (playerNumber) playerNames) self "hidden?"
    set visibleTo replace-item playerNumber visibleTo false
  ]
  ask giving-plusses [
    hubnet-clear-override (item (playerNumber) playerNames) self "hidden?"
    set visibleTo replace-item playerNumber visibleTo false
  ]

  ask selected-squares with [identity = "give selection" and showing = playerNumber] [die]
  ask integer-agents with [ID = "currentGive" and member? playerNumber visibleTo] [die]


end

to give-confirm-activity [playerNumber]

  let receiver player-squares with [item playerNumber active? = true]
  if any? receiver [ ;; have to have an active recipient for confirm to be valid

    let receiverNumber ([showing] of one-of receiver) - 1
    let gift item playerNumber playerTempGiving
    set playerTempGiving replace-item playerNumber playerTempGiving 0
    let tempResources item playerNumber playerResources
    set playerResources replace-item playerNumber playerResources (tempResources - gift)
    set tempResources item receiverNumber playerResources
    set playerResources replace-item receiverNumber playerResources (tempResources + gift)

    file-print (word "Give event - Player " playerNumber " gave " gift " to Player " receiverNumber " at " date-and-time)

    ;;mark this player as finished giving
    set playerGiving replace-item playerNumber playerGiving 0

    ;;make a black 'giving window' by asking everyone in it to go blank or black
    ask patches with [pxcor >= give_panel_x and pxcor <= give_panel_x + give_panel_w - 1 and pycor >= give_panel_y and pycor <= give_panel_y + give_panel_h] [
      hubnet-clear-override (item (playerNumber) playerNames) self "pcolor"
      ask visuals-here [
        hubnet-clear-override (item (playerNumber) playerNames) self "shape"
      ]
      ask integer-agents-here with [member? "env_var_" ID or ID = "yield"] [
        hubnet-clear-override (item (playerNumber) playerNames) self "shape"
      ]
    ]
    ask buttons with [identity = "give-confirm"] [
      hubnet-clear-override (item (playerNumber) playerNames) self "hidden?"
    ]
    ask buttons with [identity = "give-cancel"] [
      hubnet-clear-override (item (playerNumber) playerNames) self "hidden?"
    ]
    ask player-squares [
      hubnet-clear-override (item (playerNumber) playerNames) self "hidden?"
      set visibleTo replace-item playerNumber visibleTo false
      set active? replace-item playerNumber active? false
    ]
    ask giving-minuses [
      hubnet-clear-override (item (playerNumber) playerNames) self "hidden?"
      set visibleTo replace-item playerNumber visibleTo false
    ]
    ask giving-plusses [
      hubnet-clear-override (item (playerNumber) playerNames) self "hidden?"
      set visibleTo replace-item playerNumber visibleTo false
    ]

    ask selected-squares with [identity = "give selection" and showing = playerNumber] [die]
    ask integer-agents with [ID = "currentGive" and member? playerNumber visibleTo] [die]

  update-all-resources playerNumber
  update-all-resources receiverNumber
  ]

end

to action-in-space [currentPlayer xPatch yPatch]


  ask patch xPatch yPatch [ask integer-agents-here with [ID = "yield"] [die]]

  let currentPatchActivity [doing] of patch xPatch yPatch
  let currentUser [selectedBy] of patch xPatch yPatch

  let currentActivity [showing] of one-of selected-squares with [visibleTo = (currentPlayer - 1)]
  let currentMax [amt_max] of one-of activities with [ID = currentActivity]

  let supplyFlag 1
  if item (currentActivity - 1) (item (currentPlayer - 1) playerConstrainedSupplies) = 0 and item (currentActivity - 1) (item (currentPlayer - 1) playerAccessBySupply) = 1 [
    ;;this player can only access this thing by supply, and the supply is 0
    set supplyFlag 0
  ]

  ;;if the patch is currently selected for this activity BY THIS PLAYER, unselect it and go back to whatever it was last time
  if currentPatchActivity = currentActivity and currentUser = (currentPlayer - 1)[

    ;;find out what it would have cost one unit ago, given other activities
    let costList [cost] of one-of activities with [ID = currentPatchActivity]
    let thresList [threshold] of one-of activities with [ID = currentPatchActivity]
    let currentCount (count patches with [doing = currentPatchActivity and selectedBy = (currentPlayer - 1)]) - 1
    let notDone false
    if length costList > 1 [
      set notDone (currentCount >= item 1 thresList)
    ]
    while [length costList > 1 and notDone] [
      set costList but-first costList
      set thresList but-first thresList
      if length costList > 1 [
        set notDone (currentCount >= item 1 thresList)
      ]
    ]
    let currentCost item 0 costList


    let currentResources item (currentPlayer - 1) playerCurrentResources

    set playerCurrentSelections (replace-item (currentPlayer - 1) playerCurrentSelections (replace-item (currentActivity - 1) (item (currentPlayer - 1) playerCurrentSelections) (currentCount)))

    file-print (word "Changed land use - Player " (currentPlayer - 1) " unselected activity " currentActivity " in patch " xPatch " " yPatch " at " date-and-time)

    ask patch xPatch yPatch [
      set doing []
      set current_doing_cost []
      set selectedBy []
      set pcolor update-patch-color
      ask visuals-here [die]
      if is-number? last_doing [
        sprout-visuals 1 [
          set size 1
          set showing last_doing
          let myLast last_doing
          set shape [image] of one-of activities with [ID = myLast]
          if  is-number? last_selectedBy [set color item (last_selectedBy) playerColor]
        ]
      ]

    ]

    set playerCurrentResources replace-item (currentPlayer - 1) playerCurrentResources calculate-resource-use (currentPlayer - 1)
    update-all-resources (currentPlayer - 1)
    set messageAddressed 1

  ]

  ;;if it is selected as anything else BY THE CURRENT PLAYER, set it to the current activity
  if messageAddressed = 0 [
    if (is-number? currentPatchActivity and currentUser = (currentPlayer - 1)) [

      ;;undo the current activity and return resources
      ;;find out what it would have cost one unit ago, given other activities
      let costList [cost] of one-of activities with [ID = currentPatchActivity]
      let thresList [threshold] of one-of activities with [ID = currentPatchActivity]
      let currentCount (count patches with [doing = currentPatchActivity and selectedBy = (currentPlayer - 1)]) - 1
      let notDone false
      if length costList > 1 [
        set notDone (currentCount >= item 1 thresList)
      ]
      while [length costList > 1 and notDone] [
        set costList but-first costList
        set thresList but-first thresList
        if length costList > 1 [
          set notDone (currentCount >= item 1 thresList)
        ]
      ]
      let previousCost item 0 costList

      let previousActivityCount currentCount

      ;;find out what the new activity currently costs, given other activities
      set costList [cost] of one-of activities with [ID = currentActivity]
      set thresList [threshold] of one-of activities with [ID = currentActivity]

      set currentCount count patches with [doing = currentActivity and selectedBy = (currentPlayer - 1)]

      set notDone false
      if length costList > 1 [
        set notDone (currentCount >= item 1 thresList)
      ]
      while [length costList > 1 and notDone] [
        set costList but-first costList
        set thresList but-first thresList
        if length costList > 1 [
          set notDone (currentCount >= item 1 thresList)
        ]
      ]
      let currentCost item 0 costList


      ;;show costList show thresList show currentThresPos show currentCost

      let currentResources item (currentPlayer - 1) playerCurrentResources
      if (currentCost + currentResources - previousCost) <= (item (currentPlayer - 1) playerResources) and supplyFlag = 1 and currentCount < currentMax [ ;; there is space in current resource budget to do this

        set playerCurrentSelections (replace-item (currentPlayer - 1) playerCurrentSelections (replace-item (currentActivity - 1) (item (currentPlayer - 1) playerCurrentSelections) (currentCount + 1)))
        set playerCurrentSelections (replace-item (currentPlayer - 1) playerCurrentSelections (replace-item (currentPatchActivity - 1) (item (currentPlayer - 1) playerCurrentSelections) (previousActivityCount)))

        file-print (word "Changed land use - Player " (currentPlayer - 1) " selected activity " currentActivity " in patch " xPatch " " yPatch " at " date-and-time)

        ask patch xPatch yPatch [
          set pcolor black
          ask visuals-here [die]
          set doing currentActivity
          ask patch xPatch yPatch [set current_doing_cost currentCost]
          set selectedBy (currentPlayer - 1)
          sprout-visuals 1 [
            set size 1
            set showing currentActivity
            set shape [image] of one-of activities with [ID = currentActivity]
            set color item (currentPlayer - 1) playerColor
          ]
        ]
        set playerCurrentResources replace-item (currentPlayer - 1) playerCurrentResources calculate-resource-use (currentPlayer - 1)
        update-all-resources (currentPlayer - 1)
      ]
      set messageAddressed 1


    ]
  ]


    ;;if it is selected as nothing, set it to the current activity
  if messageAddressed = 0 [
    if  (not is-number? currentPatchActivity or not is-number? currentUser) [


      ;;find out what it currently costs, given other activities
      let costList [cost] of one-of activities with [ID = currentActivity]
      let thresList [threshold] of one-of activities with [ID = currentActivity]

      let currentCount count patches with [doing = currentActivity and selectedBy = (currentPlayer - 1)]
      let currentThresPos 0
      let notDone false
      if length costList > 1 [
        set notDone (currentCount >= item 1 thresList)
      ]
      while [length costList > 1 and notDone] [
        set costList but-first costList
        set thresList but-first thresList
        if length costList > 1 [
          set notDone (currentCount >= item 1 thresList)
        ]
      ]
      let currentCost item 0 costList

      ask patch xPatch yPatch [set current_doing_cost currentCost]

      let currentResources item (currentPlayer - 1) playerCurrentResources
      if (currentCost + currentResources) <= (item (currentPlayer - 1) playerResources) and supplyFlag = 1 and currentCount < currentMax[ ;; there is space in current resource budget to do this

        set playerCurrentSelections (replace-item (currentPlayer - 1) playerCurrentSelections (replace-item (currentActivity - 1) (item (currentPlayer - 1) playerCurrentSelections) (currentCount + 1)))

        file-print (word "Changed land use - Player " (currentPlayer - 1) " selected activity " currentActivity " in patch " xPatch " " yPatch " at " date-and-time)

        ask patch xPatch yPatch [
          set pcolor black
          ask visuals-here [die]
          set doing currentActivity
          set current_doing_cost currentCost
          set selectedBy (currentPlayer - 1)
          sprout-visuals 1 [
            set size 1
            set showing currentActivity
            set shape [image] of one-of activities with [ID = currentActivity]
            set color item (currentPlayer - 1) playerColor
          ]
        ]
        set playerCurrentResources replace-item (currentPlayer - 1) playerCurrentResources calculate-resource-use (currentPlayer - 1)
        update-all-resources (currentPlayer - 1)
      ]

    ]

  ]

  update-displayed-spatial-activities (currentPlayer - 1)
  update-current-supply

end

to-report calculate-resource-use [playerNumber]

  let resourceUse_spatial sum [current_doing_cost] of patches with [inGame? and selectedBy = playerNumber]


  let currentSelectionList (item playerNumber playerCurrentSelections)

  let currentCostList (list)
  foreach n-values (length currentSelectionList) [?1 -> ?1] [ ?1 ->
    if item ?1 currentSelectionList > 0 and [spatial?] of one-of activities with [ID = ?1 + 1] = false [
      set currentCostList lput ((item 0 item ?1 activityCostList) * (item ?1 currentSelectionList)) currentCostList ;; activityCostList is a nested list, because it includes the spatial activities that can have thresholds/lists
    ]
  ]

  let resourceUse_nonspatial sum currentCostList

  report resourceUse_nonspatial + resourceUse_spatial

end

to update-all-resources [playerNumber]

  ask integer-agents with [ID = "currentResource" and member? playerNumber visibleTo] [die]
    integer-as-agents (item playerNumber playerCurrentResources) 1 red (- numPanelPatches * 0.5) (numPatches * 0.735) (list playerNumber) "currentResource"
 ask integer-agents with [ID = "resource" and member? playerNumber visibleTo] [die]

   integer-as-agents (item playerNumber playerResources) 1 green (- numPanelPatches * 0.5) (numPatches * 0.025) (list playerNumber) "resource"

end
@#$#@#$#@
GRAPHICS-WINDOW
279
10
1367
739
-1
-1
90.0
1
50
1
1
1
0
0
0
1
-4
7
0
7
0
0
0
ticks
30.0

BUTTON
12
324
159
357
Launch Next Game
start-game
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
24
87
165
120
Launch Broadcast
start-hubnet
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
24
126
155
159
Listen to Clients
listen
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

OUTPUT
10
370
250
628
13

INPUTBOX
23
14
252
74
inputParameterFileName
fullSessionList.csv
1
0
String

INPUTBOX
23
182
143
242
sessionID
4.0
1
0
Number

BUTTON
21
254
154
287
Initialize Session
initialize-session
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
168
324
260
357
End game
end-game
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
11
693
149
738
Who has confirmed?
playerConfirm
17
1
11

MONITOR
11
638
212
683
Who is registered in the game?
playerNames
17
1
11

@#$#@#$#@
## WHAT IS IT?

This is a basic template for using HubNet in NetLogo to develop multiplayer games.  It includes some of the most basic elements - procedures to run a game, and to listen for / handle HubNet messages.

It also includes a few bits of sample code for key features of a game:

> marking some parts of the view as 'in the game' and other parts as part of the display

> allowing players to manipulate the game surface in a way that is seen by other players, either by changing patch colors or by changing turtle shapes

> having game elements that display differently on each player's screen

This template does not use any NetLogo UI elements in the HubNet client interface.  Instead, we create virtual UI elements in the 'display' portion of the view, for which we have much more visual control (colors, size, etc.)

## HOW IT WORKS

Specific actions in this game template

> Tap on a red square to turn it green, and observe your 'turned green' counter go up

> Tap on a green square to turn it red, and observe your 'turned red' counter go down

> Tap on the 'confirm' button and see the record of it being clicked appear in the host's output monitor


## START-UP INSTRUCTIONS

> 1. Log all of your tablets onto the same network.  If you are in the field using a portable router, this is likely to be the only available wifi network.

> 2. Open the game file on your host tablet.  Zoom out until it fits in your screen

> 3. If necessary, change the language setting on the host.

> 4. Click ‘Launch Broadcast’.  This will reset the software, as well as read in the file containing all game settings.

> 5. Select ‘Mirror 2D view on clients’ on the Hubnet Control Center.

> 6. Click ‘Listen Clients’ on the main screen.  This tells your tablet to listen for the actions of the client computers.  If there ever are any errors generated by Netlogo, this will turn off.  Make sure you turn it back on after clearing the error.

> 7. Open Hubnet on all of the client computers.  Enter the player names in the client computers, in the form ‘PlayerName_HHID’.

> 8. If the game being broadcast shows up in the list, select it.  Otherwise, manually type in the server address (shown in ‘Hubnet Control Center’).

> 9. Click ‘Enter’ on each client.

> 10. Click 'Launch Next Game' to start game.

** A small bug – once you start *EACH* new game, you must have one client exit and re-enter.  For some reason the image files do not load initially, but will load on all client computers once a player has exited and re-entered.  I believe this is something to do with an imperfect match between the world size and the client window size, which auto-corrects on re-entry.  Be sure not to change the player name or number when they re-enter.


## NETLOGO FEATURES

This template exploits the use of the bitmap extension, agent labeling, and hubnet overrides to get around the limitations of NetLogo's visualization capacities.

In the hubnet client, all actual buttons are avoided.  Instead, the world is extended, with patches to the right of the origin capturing elements of the game play, and patches to the left of the origin being used only to display game messages.

Language support is achieved by porting all in-game text to bitmap images that are loaded into the view.

## THINGS TO TRY

This template is meant as a starting point for the development of a dynamic game.  A few of the first things you might try, as exercises to get comfortable with the interface, are:

> Add 'turns'

>> Add a global variable that records whether players have clicked 'Confirm'

>> Adjust the 'Listen' procedure so that once a player clicks 'Confirm', they can't change squares betwen red and green anymore

>> Add a procedure to be run when all players have clicked 'Confirm' - maybe it sends a message to all players, maybe it changes all the colors to something new, maybe it's some cool thing I can't even imagine

>> Within the procedure above, reset the global variable that records 'Confirm' clicks so that players can play again.  Make sure that this procedure is called within the 'Listen' procedure

> Add 'ownership'

>> Add a property to patches that records which player turns them green

>> Adjust the update-patch-state procedure to only change back from green to red, if they were clicked on by the same player who turned them green to begin with

>> Adjust your 'end of turn' procedure to be triggered either by all players clicking confirm, or by all patches in the game being turned green, making each turn a sort of 'resource derby'

>> Adjust the color scheme so that instead of turning red to green, the patches clicked on by players turn from dark gray to the color assigned to that player, so that each player can see who is taking what

> Fill out the panel

>> Create counters that capture the score players accumulate from round to round, and label them (with text, pictures, whatever you think works best)

Now explore what's possible.  Are there spatial interactions that matter?  Is it better to have lots of patches together that are the same color?  Is there something different about a patch sharing a border with another?  Are there other ways that players might interact?

## CREDITS AND REFERENCES

Examples of some of the games published using this approach are:

> Bell, A. R., Rakotonarivo, O. S., Bhargava, A., Duthie, A. B., Zhang, W., Sargent, R., Lewis, A. R., & Kipchumba, A. (2023). Financial incentives often fail to reconcile agricultural productivity and pro-conservation behavior. Communications Earth and Environment, 4(2023), 27. https://doi.org/10.1038/s43247-023-00689-6

> Rakotonarivo, O. S., Bell, A., Dillon, B., Duthie, A. B., Kipchumba, A., Rasolofoson, R. A., Razafimanahaka, J., & Bunnefeld, N. (2021). Experimental Evidence on the Impact of Payments and Property Rights on Forest User Decisions. Frontiers in Conservation Science, 2(July), 1–16. https://doi.org/10.3389/fcosc.2021.661987

> Rakotonarivo, O. S., Jones, I. L., Bell, A., Duthie, A. B., Cusack, J., Minderman, J., Hogan, J., Hodgson, I., & Bunnefeld, N. (2020). Experimental evidence for conservation conflict interventions: The importance of financial payments, community trust and equity attitudes. People and Nature, August, 1–14. https://doi.org/10.1002/pan3.10155

> Rakotonarivo, S. O., Bell, A. R., Abernethy, K., Minderman, J., Bradley Duthie, A., Redpath, S., Keane, A., Travers, H., Bourgeois, S., Moukagni, L. L., Cusack, J. J., Jones, I. L., Pozo, R. A., & Bunnefeld, N. (2021). The role of incentive-based instruments and social equity in conservation conflict interventions. Ecology and Society, 26(2). https://doi.org/10.5751/ES-12306-260208

> Sargent, R., Rakotonarivo, O. S., Rushton, S. P., Cascio, B. J., Grau, A., Bell, A. R., Bunnefeld, N., Dickman, A., & Pfeifer, M. (2022). An experimental game to examine pastoralists’ preferences for human–lion coexistence strategies. People and Nature, June, 1–16. https://doi.org/10.1002/pan3.10393

> Bell, A., & Zhang, W. (2016). Payments discourage coordination in ecosystem services provision: evidence from behavioral experiments in Southeast Asia. Environmental Research Letters, 11, 114024. https://doi.org/10.1088/1748-9326/11/11/114024

> ﻿Bell, A., Zhang, W., & Nou, K. (2016). Pesticide use and cooperative management of natural enemy habitat in a framed field experiment. Agricultural Systems, 143, 1–13. https://doi.org/10.1016/j.agsy.2015.11.012
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

2wt
false
8
Polygon -6459832 true false 120 165 30 105 105 75 165 135 180 150 165 150 105 90 60 105 135 165 135 180
Polygon -2064490 true false 120 150 120 225 210 255 210 195
Polygon -2674135 true false 180 135 255 165 255 225 210 255 210 195 120 150
Line -16777216 false 135 180 165 195
Line -16777216 false 135 195 165 210
Line -16777216 false 134 187 164 202
Circle -7500403 true false 130 205 72
Circle -16777216 true false 136 211 60
Polygon -7500403 true false 184 143 183 103 197 81 209 92 193 104 197 151
Circle -11221820 false true 4 4 290
Circle -11221820 false true 0 0 298
Circle -11221820 false true 2 2 294
Circle -11221820 false true 6 6 286

acacia
false
0
Polygon -6459832 true false 130 226 138 206 135 141 111 126 75 109 54 109 36 104 98 112 113 121 104 106 129 122 128 102 146 126 174 105 163 130 212 108 181 128 187 107 188 129 224 114 212 124 250 116 173 141 156 152 156 209 165 224 150 219 143 227 140 223
Polygon -10899396 true false 41 112 125 111 177 116 205 114 234 118 249 118 275 115 257 99 216 95 190 81 137 62 97 80 69 73 59 84 31 99 16 115

activity-arrow
true
0
Polygon -7500403 true true 150 0 60 150 105 150 105 293 195 293 195 150 240 150

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

badge-minus
false
9
Rectangle -11221820 true false 45 45 255 255
Polygon -13791810 true true 45 45 45 255 255 255 255 45 45 45 60 240 240 240 240 60 60 60
Polygon -13791810 true true 60 60 60 240 45 255 45 45 60 45
Polygon -13791810 true true 75 120 75 180 120 180 120 180 165 180 180 180 180 180 225 180 225 120 180 120 180 120 120 120 120 120

badge-plus
false
9
Rectangle -11221820 true false 45 45 255 255
Polygon -13791810 true true 45 45 45 255 255 255 255 45 45 45 60 240 240 240 240 60 60 60
Polygon -13791810 true true 60 60 60 240 45 255 45 45 60 45
Polygon -13791810 true true 75 120 75 180 120 180 120 225 165 225 180 225 180 180 225 180 225 120 180 120 180 75 120 75 120 120

bar
true
0
Rectangle -7500403 true true 0 0 300 30

blank
true
0

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

cancel
false
6
Rectangle -2674135 true false 0 60 300 225
Rectangle -1 true false 9 72 286 212
Polygon -2674135 true false 45 90 90 90 255 195 30 90
Polygon -2674135 true false 180 90 255 90 75 195 30 195

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

check
false
0
Polygon -7500403 true true 55 138 22 155 53 196 72 232 91 288 111 272 136 258 147 220 167 174 208 113 280 24 257 7 192 78 151 138 106 213 87 182

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

confirm
false
6
Rectangle -10899396 true false 0 60 300 225
Rectangle -13840069 true true 9 72 286 212
Polygon -10899396 true false 75 135 45 165 105 210 270 75 105 165

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

crook
false
0
Polygon -7500403 true true 135 285 135 90 90 60 90 30 135 0 180 15 210 60 195 75 180 30 135 15 105 30 105 60 150 75 150 285 135 285

crop-base
false
0
Polygon -10899396 true false 240 285 285 225 285 165
Polygon -10899396 true false 225 285 210 135 180 75 180 240
Polygon -10899396 true false 225 105 240 105 240 285 225 285
Polygon -10899396 true false 90 270 45 60 45 210
Polygon -10899396 true false 105 270 165 180 165 90 120 180
Polygon -10899396 true false 90 60 90 285 105 285 105 60
Circle -1184463 true false 54 54 42
Circle -1184463 true false 99 69 42
Circle -1184463 true false 54 99 42
Circle -1184463 true false 99 114 42
Circle -1184463 true false 54 144 42
Circle -1184463 true false 99 159 42
Circle -1184463 true false 54 189 42
Circle -1184463 true false 84 24 42
Circle -1184463 true false 234 99 42
Circle -1184463 true false 189 114 42
Circle -1184463 true false 204 69 42
Circle -1184463 true false 234 144 42
Circle -1184463 true false 189 159 42
Circle -1184463 true false 234 189 42
Circle -1184463 true false 189 204 42

cyclone
false
0
Polygon -6459832 true false 60 240 135 120 150 120 93 219 94 238 109 257 78 243 65 255 61 246 40 243
Polygon -10899396 true false 134 124 133 106 185 81 271 84 215 88 277 102 176 100 266 112 170 111 288 122 179 118 257 128 156 122
Line -13791810 false 80 119 148 143
Line -13791810 false 34 78 103 97
Line -13791810 false 74 73 128 94
Line -13791810 false 156 145 252 179
Line -13791810 false 114 167 189 192
Line -13791810 false 162 131 233 147
Line -13791810 false 112 64 156 76
Line -13791810 false 53 165 127 195
Line -13791810 false 164 213 228 244
Line -13791810 false 218 208 265 229
Line -13791810 false 15 172 41 181
Line -13791810 false 9 112 109 154
Line -13791810 false 142 51 256 93
Line -13791810 false 123 226 170 241
Line -13791810 false 206 182 241 187
Line -13791810 false 157 29 227 62
Line -13791810 false 67 215 159 260
Polygon -13791810 true false 109 270 213 266 216 278 184 282 175 277 88 275 75 266 117 261
Circle -13791810 false false -2 -2 304

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

funeral
false
0
Circle -11221820 false false 0 0 300
Circle -11221820 true false 185 136 30
Circle -11221820 true false 105 240 30
Circle -11221820 true false 132 241 28
Circle -11221820 true false 164 226 21
Circle -11221820 true false 165 243 34
Circle -11221820 true false 45 235 30
Circle -11221820 true false 72 232 28
Circle -11221820 true false 191 226 23
Circle -11221820 true false 209 232 30
Rectangle -11221820 true false 57 265 66 282
Rectangle -11221820 true false 84 264 93 282
Rectangle -11221820 true false 113 275 128 293
Rectangle -11221820 true false 146 279 155 298
Rectangle -11221820 true false 177 281 189 295
Rectangle -11221820 true false 214 268 229 285
Rectangle -11221820 true false 200 258 209 282
Polygon -955883 true false 90 120 105 120
Rectangle -11221820 true false 120 135 180 165
Rectangle -11221820 true false 60 150 120 165
Rectangle -11221820 false false 30 165 255 180

give
false
6
Rectangle -13345367 true false 0 60 300 225
Rectangle -13840069 true true 9 72 286 212
Rectangle -10899396 true false 24 94 99 139
Circle -2674135 true false 46 105 28
Rectangle -10899396 true false 36 117 111 162
Circle -2674135 true false 62 126 28
Rectangle -10899396 true false 54 138 129 183
Circle -2674135 true false 78 149 28
Polygon -10899396 true false 155 124
Polygon -13791810 true false 160 128 220 128 220 98 265 143 220 188 220 158 160 158

graze-animals
false
8
Circle -11221820 false true 6 6 288
Line -10899396 false 105 240 105 210
Line -10899396 false 135 195 135 165
Line -10899396 false 165 150 165 120
Line -10899396 false 195 105 195 75
Line -10899396 false 225 75 225 45
Line -10899396 false 45 195 45 165
Line -10899396 false 75 135 75 90
Line -10899396 false 120 75 120 45
Line -10899396 false 165 30 165 15
Line -10899396 false 195 255 195 225
Line -10899396 false 225 195 225 150
Line -10899396 false 270 120 270 105
Polygon -10899396 true false 45 182 27 175 27 163 39 172
Polygon -10899396 true false 76 110 95 92 95 78 85 93
Polygon -10899396 true false 104 223 91 223 88 184
Polygon -10899396 true false 134 180 118 170 117 150 128 160
Polygon -10899396 true false 139 193 155 180 151 168 139 188
Polygon -10899396 true false 169 134 181 117 179 101 171 124
Polygon -10899396 true false 199 93 211 72 205 65 199 81
Polygon -10899396 true false 226 63 236 63 243 45 236 45
Polygon -10899396 true false 121 61 105 61 97 28 118 48
Polygon -10899396 true false 200 241 216 232 218 208 198 235
Polygon -10899396 true false 226 171 205 166 205 140 222 160
Polygon -10899396 true false 273 111 252 99 275 84 281 101
Polygon -6459832 true false 53 140 53 110 92 104 117 128 124 121 123 147 112 136 97 123 106 143 92 125 92 143 86 126 65 126 65 141 60 128
Polygon -6459832 true false 109 231 109 201 148 195 173 219 180 212 179 238 168 227 153 214 162 234 148 216 148 234 142 217 121 217 121 232 116 219
Polygon -6459832 true false 249 125 249 95 210 89 185 113 178 106 179 132 190 121 205 108 196 128 210 110 210 128 216 111 237 111 237 126 242 113
Circle -11221820 false true 0 0 300
Circle -11221820 false true 2 2 296
Circle -11221820 false true 4 4 292

grow-2wt
false
8
Circle -11221820 false true 6 5 292
Line -10899396 false 105 240 105 210
Line -10899396 false 135 195 135 165
Line -10899396 false 165 150 165 120
Line -10899396 false 195 105 195 75
Line -10899396 false 225 75 225 45
Line -10899396 false 45 195 45 165
Line -10899396 false 75 135 75 90
Line -10899396 false 120 75 120 45
Line -10899396 false 165 30 165 15
Line -10899396 false 195 255 195 225
Line -10899396 false 225 195 225 150
Line -10899396 false 270 120 270 105
Polygon -10899396 true false 45 182 27 175 27 163 39 172
Polygon -10899396 true false 76 110 95 92 95 78 85 93
Polygon -10899396 true false 104 223 91 223 88 184
Polygon -10899396 true false 134 180 118 170 117 150 128 160
Polygon -10899396 true false 139 193 155 180 151 168 139 188
Polygon -10899396 true false 169 134 181 117 179 101 171 124
Polygon -10899396 true false 199 93 211 72 205 65 199 81
Polygon -10899396 true false 226 63 236 63 243 45 236 45
Polygon -10899396 true false 121 61 105 61 97 28 118 48
Polygon -10899396 true false 200 241 216 232 218 208 198 235
Polygon -10899396 true false 226 171 205 166 205 140 222 160
Polygon -10899396 true false 273 111 252 99 275 84 281 101
Polygon -10899396 true false 166 91 150 91 142 58 163 78
Polygon -10899396 true false 181 216 160 211 160 185 177 205
Polygon -10899396 true false 151 246 130 241 130 215 147 235
Polygon -10899396 true false 260 181 276 172 278 148 258 175
Polygon -10899396 true false 33 111 12 99 35 84 41 101
Polygon -10899396 true false 78 171 57 159 80 144 86 161
Polygon -10899396 true false 109 134 121 117 119 101 111 124
Polygon -10899396 true false 244 224 256 207 254 191 246 214
Polygon -10899396 true false 76 256 60 256 52 223 73 243
Polygon -10899396 true false 168 276 147 264 170 249 176 266
Polygon -10899396 true false 241 126 220 121 220 95 237 115
Polygon -10899396 true false 166 51 145 46 145 20 162 40
Polygon -10899396 true false 91 66 70 61 70 35 87 55
Line -10899396 false 17 142 17 97
Line -10899396 false 83 195 83 150
Line -10899396 false 143 108 143 63
Line -10899396 false 164 90 164 45
Line -10899396 false 129 264 129 219
Line -10899396 false 179 254 179 209
Line -10899396 false 147 291 147 246
Line -10899396 false 75 275 75 230
Line -10899396 false 75 275 75 230
Line -10899396 false 238 163 238 118
Circle -1184463 true false 11 99 14
Circle -1184463 true false 38 158 14
Circle -1184463 true false 68 225 14
Circle -1184463 true false 74 242 14
Circle -1184463 true false 139 240 14
Circle -1184463 true false 186 218 14
Circle -1184463 true false 173 198 14
Circle -1184463 true false 130 172 14
Circle -1184463 true false 126 154 14
Circle -1184463 true false 66 85 14
Circle -1184463 true false 156 116 14
Circle -1184463 true false 221 163 14
Circle -1184463 true false 217 143 14
Circle -1184463 true false 231 111 14
Circle -1184463 true false 263 90 14
Circle -1184463 true false 216 36 14
Circle -1184463 true false 188 66 14
Circle -1184463 true false 133 53 14
Circle -1184463 true false 157 42 14
Circle -1184463 true false 114 36 14
Circle -1184463 true false 251 172 14
Polygon -2674135 true false 57 129 156 142 100 162 24 151
Polygon -2674135 true false 100 160 152 142 148 182 108 195
Polygon -2064490 true false 27 152 99 159 108 193 38 183
Line -16777216 false 62 166 35 163
Line -16777216 false 62 174 39 171
Line -16777216 false 65 181 44 179
Polygon -7500403 true false 68 147 66 137 66 102 83 88 92 105 79 113 79 141
Polygon -7500403 true false 3 147 30 151 34 167 6 167
Polygon -13791810 true false 152 165 180 173 194 157 194 124 213 113 231 90 254 88 254 70 267 70 247 54 243 72 235 81 205 96 199 119 182 124 177 161
Polygon -13791810 true false 138 216 191 263 216 246 244 248 244 232 277 193 277 164 283 147 278 220 235 263 217 283 171 260
Circle -11221820 false true 2 1 300
Circle -11221820 false true 8 7 288
Circle -11221820 false true 4 3 296

grow-high
false
8
Circle -11221820 false true 4 1 300
Line -10899396 false 105 240 105 210
Line -10899396 false 135 195 135 165
Line -10899396 false 165 150 165 120
Line -10899396 false 195 105 195 75
Line -10899396 false 225 75 225 45
Line -10899396 false 45 195 45 165
Line -10899396 false 75 135 75 90
Line -10899396 false 120 75 120 45
Line -10899396 false 165 30 165 15
Line -10899396 false 195 255 195 225
Line -10899396 false 225 195 225 150
Line -10899396 false 270 120 270 105
Polygon -10899396 true false 45 182 27 175 27 163 39 172
Polygon -10899396 true false 76 110 95 92 95 78 85 93
Polygon -10899396 true false 104 223 91 223 88 184
Polygon -10899396 true false 134 180 118 170 117 150 128 160
Polygon -10899396 true false 139 193 155 180 151 168 139 188
Polygon -10899396 true false 169 134 181 117 179 101 171 124
Polygon -10899396 true false 199 93 211 72 205 65 199 81
Polygon -10899396 true false 226 63 236 63 243 45 236 45
Polygon -10899396 true false 121 61 105 61 97 28 118 48
Polygon -10899396 true false 200 241 216 232 218 208 198 235
Polygon -10899396 true false 226 171 205 166 205 140 222 160
Polygon -10899396 true false 273 111 252 99 275 84 281 101
Polygon -10899396 true false 166 91 150 91 142 58 163 78
Polygon -10899396 true false 181 216 160 211 160 185 177 205
Polygon -10899396 true false 151 246 130 241 130 215 147 235
Polygon -10899396 true false 260 181 276 172 278 148 258 175
Polygon -10899396 true false 33 111 12 99 35 84 41 101
Polygon -10899396 true false 78 171 57 159 80 144 86 161
Polygon -10899396 true false 109 134 121 117 119 101 111 124
Polygon -10899396 true false 244 224 256 207 254 191 246 214
Polygon -10899396 true false 76 256 60 256 52 223 73 243
Polygon -10899396 true false 168 276 147 264 170 249 176 266
Polygon -10899396 true false 241 126 220 121 220 95 237 115
Polygon -10899396 true false 166 51 145 46 145 20 162 40
Polygon -10899396 true false 91 66 70 61 70 35 87 55
Line -10899396 false 17 142 17 97
Line -10899396 false 83 195 83 150
Line -10899396 false 143 108 143 63
Line -10899396 false 164 90 164 45
Line -10899396 false 129 264 129 219
Line -10899396 false 179 254 179 209
Line -10899396 false 147 291 147 246
Line -10899396 false 75 275 75 230
Line -10899396 false 75 275 75 230
Line -10899396 false 238 163 238 118
Circle -1184463 true false 11 99 14
Circle -1184463 true false 38 158 14
Circle -1184463 true false 68 225 14
Circle -1184463 true false 74 242 14
Circle -1184463 true false 139 240 14
Circle -1184463 true false 186 218 14
Circle -1184463 true false 173 198 14
Circle -1184463 true false 130 172 14
Circle -1184463 true false 126 154 14
Circle -1184463 true false 66 85 14
Circle -1184463 true false 156 116 14
Circle -1184463 true false 221 163 14
Circle -1184463 true false 217 143 14
Circle -1184463 true false 231 111 14
Circle -1184463 true false 263 90 14
Circle -1184463 true false 216 36 14
Circle -1184463 true false 188 66 14
Circle -1184463 true false 133 53 14
Circle -1184463 true false 157 42 14
Circle -1184463 true false 114 36 14
Circle -1184463 true false 251 172 14
Circle -11221820 false true 10 7 288
Circle -11221820 false true 6 3 296
Circle -11221820 false true 8 5 292

grow-low
false
8
Circle -11221820 false true 6 6 288
Line -10899396 false 105 240 105 210
Line -10899396 false 135 195 135 165
Line -10899396 false 165 150 165 120
Line -10899396 false 195 105 195 75
Line -10899396 false 225 75 225 45
Line -10899396 false 45 195 45 165
Line -10899396 false 75 135 75 90
Line -10899396 false 120 75 120 45
Line -10899396 false 165 30 165 15
Line -10899396 false 195 255 195 225
Line -10899396 false 225 195 225 150
Line -10899396 false 270 120 270 105
Polygon -10899396 true false 45 182 27 175 27 163 39 172
Polygon -10899396 true false 76 110 95 92 95 78 85 93
Polygon -10899396 true false 104 223 91 223 88 184
Polygon -10899396 true false 134 180 118 170 117 150 128 160
Polygon -10899396 true false 139 193 155 180 151 168 139 188
Polygon -10899396 true false 169 134 181 117 179 101 171 124
Polygon -10899396 true false 199 93 211 72 205 65 199 81
Polygon -10899396 true false 226 63 236 63 243 45 236 45
Polygon -10899396 true false 121 61 105 61 97 28 118 48
Polygon -10899396 true false 200 241 216 232 218 208 198 235
Polygon -10899396 true false 226 171 205 166 205 140 222 160
Polygon -10899396 true false 273 111 252 99 275 84 281 101
Circle -1184463 true false 116 50 14
Circle -1184463 true false 129 160 14
Circle -1184463 true false 101 203 14
Circle -1184463 true false 225 165 14
Circle -1184463 true false 220 142 14
Circle -1184463 true false 215 38 14
Circle -11221820 false true 0 0 300
Circle -11221820 false true 2 2 296
Circle -11221820 false true 4 4 292

harvest-2wt
false
8
Circle -11221820 false true 7 6 288
Circle -11221820 false true 0 0 300
Circle -11221820 false true 5 4 292
Circle -11221820 false true 3 2 296
Line -10899396 false 105 240 105 210
Line -10899396 false 135 195 135 165
Line -10899396 false 60 210 60 180
Line -10899396 false 45 225 45 195
Line -10899396 false 60 90 60 60
Line -10899396 false 45 195 45 165
Line -10899396 false 75 135 75 90
Line -10899396 false 120 75 120 45
Line -10899396 false 135 30 135 15
Line -10899396 false 105 210 105 180
Line -10899396 false 60 240 60 195
Line -10899396 false 60 60 60 45
Polygon -10899396 true false 45 182 27 175 27 163 39 172
Polygon -10899396 true false 76 110 95 92 95 78 85 93
Polygon -10899396 true false 104 223 91 223 88 184
Polygon -10899396 true false 134 180 118 170 117 150 128 160
Polygon -10899396 true false 124 223 140 210 136 198 124 218
Polygon -10899396 true false 94 119 106 102 104 86 96 109
Polygon -10899396 true false 94 138 106 117 100 110 94 126
Polygon -10899396 true false 76 153 86 153 93 135 86 135
Polygon -10899396 true false 121 61 105 61 97 28 118 48
Polygon -10899396 true false 80 121 96 112 98 88 78 115
Polygon -10899396 true false 76 216 55 211 55 185 72 205
Polygon -10899396 true false 63 216 42 204 65 189 71 206
Polygon -10899396 true false 106 136 90 136 82 103 103 123
Polygon -10899396 true false 61 156 40 151 40 125 57 145
Polygon -10899396 true false 136 261 115 256 115 230 132 250
Polygon -10899396 true false 35 151 51 142 53 118 33 145
Polygon -10899396 true false 33 111 12 99 35 84 41 101
Polygon -10899396 true false 78 171 57 159 80 144 86 161
Polygon -10899396 true false 109 134 121 117 119 101 111 124
Polygon -10899396 true false 49 134 61 117 59 101 51 124
Polygon -10899396 true false 91 211 75 211 67 178 88 198
Polygon -10899396 true false 108 216 87 204 110 189 116 206
Polygon -10899396 true false 136 141 115 136 115 110 132 130
Polygon -10899396 true false 91 81 70 76 70 50 87 70
Polygon -10899396 true false 91 66 70 61 70 35 87 55
Line -10899396 false 17 142 17 97
Line -10899396 false 83 195 83 150
Line -10899396 false 98 153 98 108
Line -10899396 false 29 210 29 165
Line -10899396 false 129 264 129 219
Line -10899396 false 119 209 119 164
Line -10899396 false 102 246 102 201
Line -10899396 false 75 275 75 230
Line -10899396 false 105 275 105 230
Line -10899396 false 103 103 103 58
Circle -1184463 true false 236 189 14
Circle -1184463 true false 234 134 14
Circle -1184463 true false 219 136 14
Circle -1184463 true false 239 212 14
Circle -1184463 true false 199 225 14
Circle -1184463 true false 216 203 14
Circle -1184463 true false 188 168 14
Circle -1184463 true false 247 164 14
Circle -1184463 true false 201 184 14
Circle -1184463 true false 206 131 14
Circle -1184463 true false 202 128 14
Circle -1184463 true false 221 163 14
Circle -1184463 true false 232 143 14
Circle -1184463 true false 227 123 14
Circle -1184463 true false 236 159 14
Circle -1184463 true false 237 120 14
Circle -1184463 true false 214 119 14
Circle -1184463 true false 223 115 14
Circle -1184463 true false 204 141 14
Circle -1184463 true false 251 172 14
Polygon -2674135 true false 120 90 180 105 210 105 150 90
Polygon -2674135 true false 180 105 210 105 210 120 180 120
Polygon -2064490 true false 180 120 120 105 120 90 180 105
Circle -16777216 true false 135 105 30
Polygon -6459832 true false 120 90 90 75 120 60 150 90 135 90 120 75 105 75
Polygon -6459832 true false 195 140 180 155 195 155 180 200 187 233 201 241 238 241 259 234 276 182 273 153 280 151 271 140 239 144 219 144
Line -16777216 false 195 156 214 161
Line -16777216 false 262 221 241 227
Polygon -16777216 true false 202 177 196 204 201 221 240 223 253 195 253 175 224 180
Circle -1184463 true false 210 184 14
Circle -1184463 true false 204 197 14
Circle -1184463 true false 225 201 14
Circle -1184463 true false 222 187 14

harvest-high
false
8
Circle -11221820 false true 7 7 288
Circle -11221820 false true 1 1 300
Circle -11221820 false true 3 3 296
Circle -11221820 false true 5 4 292
Line -10899396 false 105 240 105 210
Line -10899396 false 135 195 135 165
Line -10899396 false 60 210 60 180
Line -10899396 false 45 225 45 195
Line -10899396 false 60 90 60 60
Line -10899396 false 45 195 45 165
Line -10899396 false 75 135 75 90
Line -10899396 false 120 75 120 45
Line -10899396 false 135 30 135 15
Line -10899396 false 105 210 105 180
Line -10899396 false 60 240 60 195
Line -10899396 false 60 60 60 45
Polygon -10899396 true false 45 182 27 175 27 163 39 172
Polygon -10899396 true false 76 110 95 92 95 78 85 93
Polygon -10899396 true false 104 223 91 223 88 184
Polygon -10899396 true false 134 180 118 170 117 150 128 160
Polygon -10899396 true false 124 223 140 210 136 198 124 218
Polygon -10899396 true false 94 119 106 102 104 86 96 109
Polygon -10899396 true false 94 138 106 117 100 110 94 126
Polygon -10899396 true false 76 153 86 153 93 135 86 135
Polygon -10899396 true false 121 61 105 61 97 28 118 48
Polygon -10899396 true false 80 121 96 112 98 88 78 115
Polygon -10899396 true false 76 216 55 211 55 185 72 205
Polygon -10899396 true false 63 216 42 204 65 189 71 206
Polygon -10899396 true false 106 136 90 136 82 103 103 123
Polygon -10899396 true false 61 156 40 151 40 125 57 145
Polygon -10899396 true false 136 261 115 256 115 230 132 250
Polygon -10899396 true false 35 151 51 142 53 118 33 145
Polygon -10899396 true false 33 111 12 99 35 84 41 101
Polygon -10899396 true false 78 171 57 159 80 144 86 161
Polygon -10899396 true false 109 134 121 117 119 101 111 124
Polygon -10899396 true false 49 134 61 117 59 101 51 124
Polygon -10899396 true false 91 211 75 211 67 178 88 198
Polygon -10899396 true false 108 216 87 204 110 189 116 206
Polygon -10899396 true false 136 141 115 136 115 110 132 130
Polygon -10899396 true false 91 81 70 76 70 50 87 70
Polygon -10899396 true false 91 66 70 61 70 35 87 55
Line -10899396 false 17 142 17 97
Line -10899396 false 83 195 83 150
Line -10899396 false 98 153 98 108
Line -10899396 false 29 210 29 165
Line -10899396 false 129 264 129 219
Line -10899396 false 119 209 119 164
Line -10899396 false 102 246 102 201
Line -10899396 false 75 275 75 230
Line -10899396 false 105 275 105 230
Line -10899396 false 103 103 103 58
Circle -1184463 true false 236 189 14
Circle -1184463 true false 239 212 14
Circle -1184463 true false 199 225 14
Circle -1184463 true false 216 203 14
Circle -1184463 true false 188 168 14
Circle -1184463 true false 201 184 14
Circle -1184463 true false 196 132 14
Circle -1184463 true false 181 139 14
Circle -1184463 true false 221 163 14
Circle -1184463 true false 232 143 14
Circle -1184463 true false 220 138 14
Circle -1184463 true false 248 135 14
Circle -1184463 true false 231 132 14
Circle -1184463 true false 214 128 14
Circle -1184463 true false 191 143 14
Circle -1184463 true false 204 141 14
Circle -1184463 true false 251 172 14
Polygon -6459832 true false 171 232 201 242 223 244 252 240 267 232 262 228 268 201 271 164 268 155 275 154 272 143 239 151 227 152 190 152 171 144 175 154 174 171 167 198 169 218 165 233
Line -16777216 false 177 159 197 168
Line -16777216 false 261 229 244 233
Line -16777216 false 268 155 230 164
Polygon -16777216 true false 193 185 190 206 192 218 233 223 252 217 253 178 218 184
Circle -1184463 true false 203 192 14
Circle -1184463 true false 213 198 14
Circle -1184463 true false 221 190 14
Circle -1184463 true false 234 202 14

harvest-low
false
8
Circle -11221820 false true 6 6 288
Circle -11221820 false true 0 0 300
Circle -11221820 false true 2 2 296
Circle -11221820 false true 4 4 292
Line -10899396 false 45 180 45 150
Line -10899396 false 60 150 60 120
Line -10899396 false 90 195 90 165
Line -10899396 false 90 150 90 120
Line -10899396 false 105 195 105 165
Line -10899396 false 30 195 30 165
Line -10899396 false 45 165 45 120
Line -10899396 false 105 120 105 90
Line -10899396 false 90 90 90 75
Line -10899396 false 60 225 60 195
Line -10899396 false 60 195 60 150
Line -10899396 false 120 255 120 240
Polygon -10899396 true false 30 167 12 160 12 148 24 157
Polygon -10899396 true false 46 125 65 107 65 93 55 108
Polygon -10899396 true false 74 178 61 178 58 139
Polygon -10899396 true false 59 165 43 155 42 135 53 145
Polygon -10899396 true false 34 193 50 180 46 168 34 188
Polygon -10899396 true false 79 149 91 132 89 116 81 139
Polygon -10899396 true false 94 108 106 87 100 80 94 96
Polygon -10899396 true false 76 243 86 243 93 225 86 225
Polygon -10899396 true false 76 91 60 91 52 58 73 78
Polygon -10899396 true false 50 166 66 157 68 133 48 160
Polygon -10899396 true false 91 141 70 136 70 110 87 130
Polygon -10899396 true false 108 141 87 129 110 114 116 131
Circle -1184463 true false 194 186 14
Circle -1184463 true false 220 164 14
Circle -1184463 true false 208 157 14
Circle -1184463 true false 195 162 14
Circle -1184463 true false 181 154 14
Polygon -6459832 true false 176 156 202 166 231 167 245 163 249 174 240 179 243 199 225 218 187 217 173 202 180 177 174 167
Line -16777216 false 180 180 201 188
Line -16777216 false 239 201 215 205
Circle -1184463 true false 198 191 14

hay
false
0
Polygon -1184463 true false 50 187 97 222 119 234 178 236 219 234 248 211 272 182 205 122 219 50 204 78 203 40 194 95 190 29 178 111 168 22 160 103 142 34 139 98 126 37 128 99 118 45 124 124 96 38 108 114
Polygon -6459832 true false 110 116 138 127 164 126 210 118 214 129 171 144 123 143 102 125 99 121 106 113

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

land-prep-2wt
false
8
Circle -11221820 false true 2 2 296
Circle -6459832 true false 72 216 9
Circle -6459832 true false 250 224 9
Circle -6459832 true false 163 274 9
Circle -6459832 true false 226 268 9
Circle -6459832 true false 79 70 9
Circle -6459832 true false 79 276 9
Circle -6459832 true false 35 220 9
Circle -6459832 true false 74 37 9
Circle -6459832 true false 266 73 9
Circle -6459832 true false 207 62 9
Circle -6459832 true false 115 81 9
Circle -6459832 true false 225 125 9
Circle -6459832 true false 162 104 9
Circle -6459832 true false 146 210 9
Circle -6459832 true false 259 109 9
Circle -6459832 true false 105 239 9
Circle -6459832 true false 34 55 9
Circle -6459832 true false 229 40 9
Circle -6459832 true false 259 130 9
Circle -6459832 true false 259 175 9
Circle -6459832 true false 244 190 9
Circle -6459832 true false 154 235 9
Circle -6459832 true false 79 250 9
Circle -6459832 true false 154 55 9
Circle -6459832 true false 214 100 9
Circle -6459832 true false 124 40 9
Circle -6459832 true false 94 190 9
Circle -6459832 true false 34 145 9
Circle -6459832 true false 169 79 9
Circle -6459832 true false 109 19 9
Circle -6459832 true false 214 19 9
Circle -6459832 true false 184 19 9
Circle -6459832 true false 49 169 9
Circle -6459832 true false 124 169 9
Circle -6459832 true false 154 169 9
Circle -6459832 true false 34 199 9
Circle -6459832 true false 259 199 9
Circle -6459832 true false 94 94 9
Circle -6459832 true false 184 124 9
Circle -6459832 true false 19 109 9
Circle -6459832 true false 79 154 9
Circle -6459832 true false 184 64 9
Circle -6459832 true false 124 244 9
Circle -6459832 true false 19 154 9
Circle -6459832 true false 64 229 9
Circle -6459832 true false 124 274 9
Circle -6459832 true false 214 229 9
Circle -6459832 true false 184 259 9
Polygon -2674135 true false 120 120 225 165 180 180 75 135
Polygon -2674135 true false 180 180 225 165 225 210 180 225
Polygon -2064490 true false 181 224 181 179 76 134 76 179
Circle -7500403 true false 85 169 68
Circle -16777216 true false 89 177 54
Line -16777216 false 90 157 113 167
Line -16777216 false 95 155 118 165
Polygon -6459832 true false 82 134 44 94 81 76 113 119 116 124 121 122 78 66 29 90
Circle -11221820 false true 6 6 288
Circle -11221820 false true 0 0 300
Circle -11221820 false true 4 4 292

land-prep-high
false
8
Circle -11221820 false true 6 6 288
Polygon -6459832 true false 60 105 225 165 210 180 60 120 45 105
Polygon -7500403 true false 195 225 195 195 240 150 240 195 195 240
Polygon -7500403 true false 195 195 180 150 240 150 195 165
Circle -6459832 true false 72 216 9
Circle -6459832 true false 250 224 9
Circle -6459832 true false 163 274 9
Circle -6459832 true false 226 268 9
Circle -6459832 true false 79 70 9
Circle -6459832 true false 79 276 9
Circle -6459832 true false 5 175 9
Circle -6459832 true false 74 37 9
Circle -6459832 true false 266 73 9
Circle -6459832 true false 207 62 9
Circle -6459832 true false 115 81 9
Circle -6459832 true false 225 125 9
Circle -6459832 true false 162 104 9
Circle -6459832 true false 146 210 9
Circle -6459832 true false 259 109 9
Circle -6459832 true false 105 239 9
Circle -6459832 true false 34 55 9
Circle -6459832 true false 244 55 9
Circle -6459832 true false 259 130 9
Circle -6459832 true false 259 175 9
Circle -6459832 true false 169 55 9
Circle -6459832 true false 154 235 9
Circle -6459832 true false 79 250 9
Circle -6459832 true false 154 55 9
Circle -6459832 true false 214 100 9
Circle -6459832 true false 124 40 9
Circle -6459832 true false 94 190 9
Circle -6459832 true false 34 145 9
Circle -6459832 true false 169 79 9
Circle -6459832 true false 109 19 9
Circle -6459832 true false 214 19 9
Circle -6459832 true false 184 19 9
Circle -6459832 true false 49 169 9
Circle -6459832 true false 124 169 9
Circle -6459832 true false 154 169 9
Circle -6459832 true false 34 199 9
Circle -6459832 true false 259 199 9
Circle -6459832 true false 94 94 9
Circle -6459832 true false 184 124 9
Circle -6459832 true false 19 109 9
Circle -6459832 true false 79 154 9
Circle -6459832 true false 49 64 9
Circle -6459832 true false 109 229 9
Circle -6459832 true false 34 229 9
Circle -6459832 true false 64 229 9
Circle -6459832 true false 124 274 9
Circle -6459832 true false 214 229 9
Circle -6459832 true false 184 259 9
Circle -11221820 false true 0 0 300
Circle -11221820 false true 2 2 296
Circle -11221820 false true 4 4 292

land-prep-low
false
8
Circle -11221820 false true 6 6 288
Polygon -6459832 true false 60 105 225 165 210 180 60 120 45 105
Polygon -7500403 true false 195 225 195 195 240 150 240 195 195 240
Polygon -7500403 true false 195 195 180 150 240 150 195 165
Circle -6459832 true false 72 216 9
Circle -6459832 true false 250 224 9
Circle -6459832 true false 163 274 9
Circle -6459832 true false 151 43 9
Circle -6459832 true false 34 190 9
Circle -6459832 true false 79 246 9
Circle -6459832 true false 35 145 9
Circle -6459832 true false 74 37 9
Circle -6459832 true false 266 73 9
Circle -6459832 true false 207 62 9
Circle -6459832 true false 115 81 9
Circle -6459832 true false 225 125 9
Circle -6459832 true false 162 104 9
Circle -6459832 true false 131 210 9
Circle -6459832 true false 79 169 9
Circle -6459832 true false 105 239 9
Circle -11221820 false true 0 0 300
Circle -11221820 false true 2 2 296
Circle -11221820 false true 4 4 292

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

lender-borrow
false
0
Circle -13791810 false false 6 6 288
Polygon -7500403 true true 120 120
Polygon -16777216 true false 31 180 34 179
Polygon -16777216 true false 61 121 50 121 53 85
Rectangle -10899396 true false 119 246 179 276
Polygon -13791810 true false 153 189 144 190 144 214 135 214 149 237 162 214 154 214
Circle -955883 true false 139 251 20
Circle -13791810 true false 94 60 45
Polygon -13791810 true false 132 111 102 111 79 146 99 149 102 182 134 182 136 150 153 146
Rectangle -10899396 true false 168 81 228 111
Circle -955883 true false 188 87 20
Rectangle -10899396 true false 182 98 242 128
Circle -955883 true false 201 105 20
Rectangle -10899396 true false 196 119 256 149
Circle -955883 true false 217 126 20
Circle -13791810 false false 0 0 300
Circle -13791810 false false 2 2 296
Circle -13791810 false false 4 4 292

lender-pay
false
0
Circle -2674135 false false 6 6 288
Polygon -7500403 true true 120 120
Polygon -16777216 true false 31 180 34 179
Polygon -16777216 true false 61 121 50 121 53 85
Rectangle -10899396 true false 119 246 179 276
Polygon -2674135 true false 153 238 144 237 144 213 135 213 149 190 162 213 154 213
Circle -955883 true false 139 251 20
Circle -2674135 true false 94 60 45
Polygon -2674135 true false 132 111 102 111 79 146 99 149 102 182 134 182 136 150 153 146
Rectangle -10899396 true false 168 81 228 111
Circle -955883 true false 188 87 20
Rectangle -10899396 true false 182 98 242 128
Circle -955883 true false 201 105 20
Rectangle -10899396 true false 196 119 256 149
Circle -955883 true false 217 126 20
Circle -2674135 false false 0 0 300
Circle -2674135 false false 2 2 296
Circle -2674135 false false 4 4 292

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

line-thick
true
0
Line -7500403 true 150 0 150 300
Rectangle -7500403 true true 135 0 150 315

num-0
false
0
Polygon -7500403 true true 150 30 120 30 90 60 75 105 75 210 90 240 120 270 180 270 210 240 225 210 225 105 210 60 180 30 150 30 150 60 180 60 195 75 210 105 210 210 195 225 180 240 120 240 90 210 90 105 105 75 120 60 150 60

num-1
false
0
Polygon -7500403 true true 120 60 135 30 165 30 165 240 180 255 180 270 120 270 120 255 135 240 135 60

num-2
false
0
Polygon -7500403 true true 75 120 75 90 90 60 105 45 135 30 165 30 195 45 210 60 225 90 225 120 210 150 180 165 150 180 135 195 105 225 105 240 225 240 225 270 75 270 75 210 90 195 120 165 150 150 180 135 195 105 180 75 150 60 135 60 120 75 105 90

num-3
false
0
Polygon -7500403 true true 75 30 225 30 225 60 165 135 195 150 225 180 225 225 210 255 180 270 135 270 90 255 75 225 75 210 105 210 120 240 180 240 195 225 195 195 180 180 135 150 135 120 195 60 75 60

num-4
false
0
Polygon -7500403 true true 75 135 165 30 195 30 195 135 225 135 225 165 195 165 195 270 165 270 165 165 75 165 75 135 165 135 165 60 105 135

num-5
false
0
Polygon -7500403 true true 75 195 105 225 135 240 165 240 195 225 195 180 180 150 150 135 105 150 75 150 75 30 225 30 225 60 105 60 105 120 150 105 195 120 225 150 225 225 195 255 165 270 135 270 90 255 75 240

num-6
false
0
Polygon -7500403 true true 165 30 90 135 75 180 75 210 90 255 120 270 165 270 195 270 210 255 225 210 225 180 210 150 180 135 120 135 105 150 105 180 120 165 165 165 195 180 195 210 195 225 180 240 135 240 105 225 105 195 105 165 105 150 120 135 195 30

num-7
false
0
Polygon -7500403 true true 75 30 225 30 225 60 165 135 120 270 90 270 135 120 180 60 75 60

num-8
false
0
Polygon -7500403 true true 150 15 105 30 90 45 90 75 90 90 90 105 120 120 90 150 75 180 75 210 75 240 90 255 120 270 150 270 180 270 210 255 225 240 225 195 225 180 210 150 180 120 210 105 210 90 210 75 210 45 195 30 150 15 150 45 180 60 180 90 150 105 150 135 180 150 195 180 195 225 180 240 165 240 135 240 120 240 105 225 105 180 120 150 150 135 150 105 120 90 120 75 120 60 150 45 150 45

num-9
false
0
Polygon -7500403 true true 135 270 210 165 225 120 225 90 210 45 180 30 135 30 105 30 90 45 75 90 75 120 90 150 120 165 180 165 195 150 195 120 180 135 135 135 105 120 105 90 105 75 120 60 165 60 195 75 195 105 195 135 195 150 180 165 105 270

num-minus
false
0
Rectangle -7500403 true true 105 135 195 165

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

person cutting
false
0
Circle -7500403 true true 65 5 80
Polygon -7500403 true true 60 90 75 195 45 285 60 300 90 300 105 225 120 300 150 300 165 285 135 195 150 90
Rectangle -7500403 true true 82 79 127 94
Polygon -7500403 true true 150 90 195 150 180 180 120 105
Polygon -7500403 true true 60 90 15 150 30 180 90 105
Polygon -6459832 true false 165 210 210 120 240 120 255 120 270 90 285 60 285 30 255 15 210 0 255 45 255 90 225 105 210 105 165 195

person resting
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105
Line -16777216 false 125 39 140 39
Line -16777216 false 155 39 170 39
Circle -16777216 true false 136 55 15

person walking
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 165 285 135 270 150 225 210 270 255 210 225 225 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 255 105 240 135 165 120
Polygon -7500403 true true 105 90 60 150 75 180 135 105
Polygon -16777216 true false 120 105 150 105 150 90 180 120 150 150 150 135 120 135

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

raindrops
false
0
Polygon -13345367 true false 114 51 97 82 98 101 115 116 138 108 145 84 145 48 144 20
Polygon -13345367 true false 120 156 103 187 104 206 121 221 144 213 151 189 151 153 150 125
Polygon -13345367 true false 190 96 173 127 174 146 191 161 214 153 221 129 221 93 220 65
Polygon -13345367 true false 216 204 199 235 200 254 217 269 240 261 247 237 247 201 246 173
Polygon -13345367 true false 47 179 30 210 31 229 48 244 71 236 78 212 78 176 77 148

selected-square
false
0
Rectangle -7500403 true true 0 0 15 300
Rectangle -7500403 true true 15 0 300 15
Rectangle -7500403 true true 285 15 300 300
Rectangle -7500403 true true 15 285 285 300

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

sheep 2
false
0
Polygon -7500403 true true 209 183 194 198 179 198 164 183 164 174 149 183 89 183 74 168 59 198 44 198 29 185 43 151 28 121 44 91 59 80 89 80 164 95 194 80 254 65 269 80 284 125 269 140 239 125 224 153 209 168
Rectangle -7500403 true true 180 195 195 225
Rectangle -7500403 true true 45 195 60 225
Rectangle -16777216 true false 180 225 195 240
Rectangle -16777216 true false 45 225 60 240
Polygon -7500403 true true 245 60 250 72 240 78 225 63 230 51
Polygon -7500403 true true 25 72 40 80 42 98 22 91
Line -16777216 false 270 137 251 122
Line -16777216 false 266 90 254 90

square
false
0
Rectangle -7500403 true true 30 30 270 270

square outline
false
4
Polygon -1184463 true true 15 15 285 15 285 285 15 285 15 30 30 30 30 270 270 270 270 30 15 30

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

vsla-borrow
false
0
Circle -13791810 false false 0 0 300
Polygon -7500403 true true 120 120
Polygon -16777216 true false 31 180 34 179
Polygon -13791810 true false 17 180 46 59 60 59 89 181 73 180 64 136 45 136 34 178
Polygon -13791810 true false 73 62 102 179 118 179 147 61 133 61 112 150 89 61
Polygon -13791810 true false 163 63 131 181 190 181 195 165 149 166 164 122 195 123 202 108 169 108 176 76 207 76 212 61
Polygon -13791810 true false 199 179 223 59 264 59 263 76 231 75 214 165 258 164 257 179
Polygon -16777216 true false 61 121 50 121 53 85
Rectangle -10899396 true false 119 246 179 276
Polygon -13791810 true false 153 189 144 190 144 214 135 214 149 237 162 214 154 214
Circle -955883 true false 139 251 20

vsla-join
false
0
Circle -10899396 false false 0 0 300
Polygon -7500403 true true 120 120
Polygon -16777216 true false 31 180 34 179
Polygon -10899396 true false 17 180 46 59 60 59 89 181 73 180 64 136 45 136 34 178
Polygon -10899396 true false 73 62 102 179 118 179 147 61 133 61 112 150 89 61
Polygon -10899396 true false 163 63 131 181 190 181 195 165 149 166 164 122 195 123 202 108 169 108 176 76 207 76 212 61
Polygon -10899396 true false 199 179 223 59 264 59 263 76 231 75 214 165 258 164 257 179
Polygon -16777216 true false 61 121 50 121 53 85
Polygon -10899396 true false 165 287 133 287 133 238 106 253 149 190 192 253 165 242

vsla-pay
false
0
Circle -2674135 false false 0 0 300
Polygon -7500403 true true 120 120
Polygon -16777216 true false 31 180 34 179
Polygon -2674135 true false 17 180 46 59 60 59 89 181 73 180 64 136 45 136 34 178
Polygon -2674135 true false 73 62 102 179 118 179 147 61 133 61 112 150 89 61
Polygon -2674135 true false 163 63 131 181 190 181 195 165 149 166 164 122 195 123 202 108 169 108 176 76 207 76 212 61
Polygon -2674135 true false 199 179 223 59 264 59 263 76 231 75 214 165 258 164 257 179
Polygon -16777216 true false 61 121 50 121 53 85
Rectangle -10899396 true false 119 246 179 276
Polygon -2674135 true false 153 236 144 235 144 211 135 211 149 188 162 211 154 211
Circle -955883 true false 139 251 20

vsla-share
false
0
Circle -10899396 false false 0 0 300
Polygon -7500403 true true 120 120
Polygon -16777216 true false 31 180 34 179
Polygon -10899396 true false 17 180 46 59 60 59 89 181 73 180 64 136 45 136 34 178
Polygon -10899396 true false 73 62 102 179 118 179 147 61 133 61 112 150 89 61
Polygon -10899396 true false 163 63 131 181 190 181 195 165 149 166 164 122 195 123 202 108 169 108 176 76 207 76 212 61
Polygon -10899396 true false 199 179 223 59 264 59 263 76 231 75 214 165 258 164 257 179
Polygon -16777216 true false 61 121 50 121 53 85
Rectangle -10899396 true false 119 246 179 276
Polygon -10899396 true false 154 237 145 236 145 212 136 212 150 189 163 212 155 212
Circle -955883 true false 139 251 20

wedding
false
0
Circle -2064490 true false 105 61 30
Circle -2064490 true false 155 61 30
Rectangle -2064490 true false 98 99 143 144
Rectangle -2064490 true false 111 139 129 203
Rectangle -2064490 true false 155 100 182 199
Polygon -2064490 true false 60 210 60 90 75 60 90 45 150 15 180 30 210 45 225 60 240 90 240 210 225 210 225 90 210 60 150 30 90 60 75 90 75 210
Circle -2064490 true false 105 240 30
Circle -2064490 true false 132 241 28
Circle -2064490 true false 164 226 21
Circle -2064490 true false 165 243 34
Circle -2064490 true false 45 235 30
Circle -2064490 true false 72 232 28
Circle -2064490 true false 191 226 23
Circle -2064490 true false 209 232 30
Rectangle -2064490 true false 57 265 66 282
Rectangle -2064490 true false 84 264 93 282
Rectangle -2064490 true false 113 275 128 293
Rectangle -2064490 true false 146 279 155 298
Rectangle -2064490 true false 177 281 189 295
Rectangle -2064490 true false 214 268 229 285
Rectangle -2064490 true false 200 258 209 282
Circle -2064490 false false 0 0 300

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.3.0
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
VIEW
7
10
1087
730
0
0
0
1
1
1
1
1
0
1
1
1
-4
7
0
7

@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
