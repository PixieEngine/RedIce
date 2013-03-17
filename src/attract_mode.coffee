AttractMode = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  window.physics = Physics()

  Fan.crowd = Fan.generateCrowd()

  [homeTeam, awayTeam] = teamStyles = ["smiley", "spike"]

  playerData = []

  MAX_PLAYERS.times (i) ->
    playerData.push
      class: "Player"
      cpu: true
      teamIndex: Math.floor(2 * i / MAX_PLAYERS)
      bodyStyle: TeamSheet.bodyStyles.rand()
      headStyle: TeamSheet.headStyles.rand()

  # COPYPASTO
  [away, home] = playerData.partition (playerData) ->
    playerData.teamIndex

  away.each (red, i) ->
    red.slot = i
    red.y = WALL_TOP + ARENA_HEIGHT * (i + 1) / (away.length + 1)
    red.x = WALL_LEFT + ARENA_WIDTH/2 - ARENA_WIDTH / 6
    red.heading = 0.5.rotations
    red.teamStyle = teamStyles.last()

  home.each (blue, i) ->
    blue.slot = i
    blue.y = WALL_TOP + ARENA_HEIGHT * (i + 1) / (home.length + 1)
    blue.x = WALL_LEFT + ARENA_WIDTH/2 + ARENA_WIDTH / 6
    blue.teamStyle = teamStyles.first()
  # END COPYPASTO

  self.on "enter", ->
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
    playerData.each (datum) ->
      engine.add datum

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

  age = 0
  # Add events and methods here
  self.on "update", (dt) ->
    age += dt

    keyPressed = engine.controllers().inject false, (keyPressed, controller) ->
      keyPressed or controller.buttonPressed "ANY"

    if keyPressed or (age >= 40)
      engine.setState MainMenuState()

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

