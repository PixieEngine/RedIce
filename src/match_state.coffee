MatchState = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  window.physics = Physics()

  Fan.crowd = Fan.generateCrowd()

  [homeTeam, awayTeam] = config.teams

  self.on "enter", ->
    engine.clear(true)

    engine.camera().position(ARENA_CENTER)

    engine.add
      class: "PuckLeader"

    rink = engine.add
      class: "Rink"
      team: config.teams.first()

    scoreboard = engine.add
      class: "Scoreboard"
      team: homeTeam
      # periodTime: 120
      # period: 3

    scoreboard.on "restart", ->
      if config.storyMode # TODO: Reduce globals!
        config.defeatedTeams.push config.opponentTeam
        engine.setState(MapState())
      else
        engine.setState(MatchSetupState())

    # Add each player to game based on config data
    config.players.each (playerData) ->
      engine.add Object.extend({}, playerData)

    engine.add
      class: "Puck"

    leftGoal = engine.add
      class: "Goal"
      right: false
      team: homeTeam
      x: WALL_LEFT + ARENA_WIDTH/10 - 32

    leftGoal.on "score", ->
      scoreboard.score "home"

    rightGoal = engine.add
      class: "Goal"
      right: true
      team: awayTeam
      x: WALL_LEFT + ARENA_WIDTH*9/10

    rightGoal.on "score", ->
      scoreboard.score "away"

    Music.volume config.musicVolume
    Music.play TEAM_MUSIC[homeTeam].rand()

  # Add events and methods here
  self.on "update", ->
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
        return unless puck.puckControl() # This puck is out of control!

        controlCircles.each (circle) ->
          if Collision.circular(circle, puck.circle())
            player.controlPuck(puck)

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
          player.bloody()

  # We must always return self as the last line
  return self

