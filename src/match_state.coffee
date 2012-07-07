MatchState = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  physics = Physics()

  self.bind "enter", ->
    engine.clear(true)

    rink.show()

    scoreboard = engine.add
      class: "Scoreboard"
      # periodTime: 120
      # period: 3

    scoreboard.bind "restart", ->
      engine.setState(MatchSetupState())

    config.players.each (playerData) ->
      engine.add $.extend({}, playerData)

    engine.add
      class: "Puck"
        
    2.times (i) ->
      engine.add
        class: "Fan"
        x: i * 512
        y: 0

    leftGoal = engine.add
      class: "Goal"
      right: false
      x: WALL_LEFT + ARENA_WIDTH/10 - 32

    leftGoal.bind "score", ->
      scoreboard.score "home"

    rightGoal = engine.add
      class: "Goal"
      right: true
      x: WALL_LEFT + ARENA_WIDTH*9/10

    rightGoal.bind "score", ->
      scoreboard.score "away"

    if config.music
      Music.play "music1"

  # Add events and methods here
  self.bind "update", ->
    pucks = engine.find("Puck")
    players = engine.find("Player").shuffle()
    zambonis = engine.find("Zamboni")

    objects = players.concat zambonis, pucks
    playersAndPucks = players.concat pucks

    # Puck handling
    players.each (player) ->
      return if player.I.wipeout

      pucks.each (puck) ->
        if Collision.circular(player.controlCircle(), puck.circle())
          player.controlPuck(puck)

    physics.process(objects)

    playersAndPucks.each (player) ->
      # Blood Collisions
      splats = engine.find("Blood")

      splats.each (splat) ->
        if Collision.circular(player.circle(), splat.circle())
          player.bloody()

  # We must always return self as the last line
  return self

