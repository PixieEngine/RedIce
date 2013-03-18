MatchState = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  window.physics = Physics()

  Fan.crowd = Fan.generateCrowd()

  {homeTeam, awayTeam} = config

  if config.homeTeam
    homeTeam = config.homeTeam

  if config.awayTeam
    awayTeam = config.awayTeam

  self.unbind "update"
  queuedObjects = []

  # TODO This whole thing is a weird compromise to allow for a pause menu
  # Ideally this would be a new gamestate that is pushed onto a gamestate stack
  # where the current gamestate would be visible beneath it, but until that's in place
  # we'll just skip updating all objects except menus if a menu exists
  self.on "update", (elapsedTime) ->
    I.updating = true

    if menu = engine.first "Menu"
      objects = [menu]
    else
      objects = I.objects

    objects.invoke "trigger", "beforeUpdate", elapsedTime
    objects.invoke "update", elapsedTime
    objects.invoke "trigger", "afterUpdate", elapsedTime

    # Still partition all objects to prevent everything from being removed when paused
    [toKeep, toRemove] = I.objects.partition (object) ->
      object.I.active

    toRemove.invoke "trigger", "remove"

    I.objects = toKeep.concat(queuedObjects)
    queuedObjects = []

    I.updating = false

  # TODO: Handle this whole pause menu thing better
  # Overriding add due to queued objects closure
  self.add = (entityData) ->
    self.trigger "beforeAdd", entityData

    object = GameObject.construct entityData
    object.create()

    self.trigger "afterAdd", object

    if I.updating
      queuedObjects.push object
    else
      I.objects.push object

    return object

  self.addPauseMenu = ->
    engine.add
      class: "Menu"
      matchPause: true


  self.on "enter", ->
    bloodCanvas.clear()

    engine.clear(true)

    engine.camera().position(ARENA_CENTER)

    engine.add
      class: "PuckLeader"

    rink = engine.add
      class: "Rink"
      team: homeTeam

    scoreboard = engine.add
      class: "Scoreboard"
      team: homeTeam
      # periodTime: 120
      # period: 3

    # Add each player to game based on config data
    config.players.each (playerData) ->
      engine.add Object.extend({}, playerData)

    engine.add
      class: "Puck"

    leftGoal = engine.add
      class: "Goal"
      right: false
      team: awayTeam
      x: WALL_LEFT + ARENA_WIDTH/10 - 32

    leftGoal.on "score", ->
      scoreboard.score "home"

    rightGoal = engine.add
      class: "Goal"
      right: true
      team: homeTeam
      x: WALL_LEFT + ARENA_WIDTH*9/10

    rightGoal.on "score", ->
      scoreboard.score "away"

    Music.volume config.musicVolume
    Music.play TEAM_MUSIC[homeTeam].rand()

  # Add events and methods here
  self.on "update", (dt) ->
    menu = engine.first("Menu")

    startPressed = engine.controllers().inject false, (startPressed, controller) ->
      startPressed or controller.buttonPressed "START"

    if startPressed
      if menu
        menu.destroy()
      else
        menu = self.addPauseMenu()

    # Go back to the map in Story Mode
    if menu and config.storyMode # TODO: Reduce globals!
      # TODO: if demo display buy now screen
      if winner = engine.first("Scoreboard").I.winner
        if winner is config.playerTeam
          config.defeatedTeams.push config.opponentTeam
          engine.setState(MapState())
        else
          # Game over screen
          engine.setState(Cutscene.gameOver[winner])

    return if menu

    Fan.crowd.invoke("update")

    pucks = engine.find("Puck")
    players = engine.find("Player").shuffle()
    zambonis = engine.find("Zamboni")
    gibs = engine.find("Gib")

    objects = players.concat zambonis, pucks, gibs
    playersAndPucks = players.concat pucks

    # Puck handling
    players.each (player) ->
      return if player.I.wipeout

      controlCircles = player.controlCircles()

      pucks.each (puck) ->
        controlCircles.each (circle) ->
          if Collision.circular(circle, puck.circle())
            return unless puck.puckControl(player) # This puck is out of control!
            player.controlPuck(puck, dt)

    physics.process(objects)

    if puckLeader = engine.first("PuckLeader")
      camera = engine.camera()

      camera.I.maxSpeed = 125
      camera.I.cameraBounds.width = ARENA_WIDTH + 40
      #camera.I.cameraBounds.height = ARENA_HEIGHT + 40

      camera.follow(puckLeader)

    playersAndPucks.each (player) ->
      # Blood Collisions
      splats = engine.find("Blood")

      splats.each (splat) ->
        if Collision.circular(player.circle(), splat.circle())
          player.bloody(splat.color())

  # We must always return self as the last line
  return self

