MatchState = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  physics = Physics()

  team = "smiley"

  self.bind "enter", ->
    engine.clear(true)

    scoreboard = engine.add
      class: "Scoreboard"
      # periodTime: 120
      # period: 3

    scoreboard.bind "restart", ->
      engine.setState(MatchSetupState())

    engine.add
      spriteName: "#{team}_wall_nw"
      x: 64
      y: WALL_TOP + 24
      scale: 1/8
      width: 128
      height: 128
      zIndex: 1

    # Note: This is actually wall_ne, image is flipped
    engine.add
      spriteName: "#{team}_wall_nw"
      x: WALL_RIGHT - 32
      y: WALL_TOP + 24
      scale: 1/8
      hflip: true
      width: 128
      height: 128
      zIndex: 1

    engine.add
      spriteName: "#{team}_wall_sw"
      x: 80
      y: WALL_BOTTOM - 64
      scale: 1/8
      width: 128
      height: 128
      zIndex: 2

    engine.add
      spriteName: "#{team}_wall_sw"
      x: WALL_RIGHT - 48
      y: WALL_BOTTOM - 64
      scale: 1/8
      hflip: true
      width: 128
      height: 128
      zIndex: 2

    engine.add
      class: "Boards"
      sprite: Sprite.loadByName("#{team}_wall_n")
      y: WALL_TOP - 64
      zIndex: 1

    engine.add
      class: "Boards"
      sprite: Sprite.loadByName("#{team}_wall_s")
      y: WALL_BOTTOM - 64
      zIndex: 10

    config.players.each (playerData) ->
      engine.add $.extend({}, playerData)

    engine.add
      class: "Puck"

    leftGoal = engine.add
      class: "Goal"
      team: 0
      x: WALL_LEFT + ARENA_WIDTH/10 - 32

    leftGoal.bind "score", ->
      scoreboard.score "home"

    rightGoal = engine.add
      class: "Goal"
      team: 1
      x: WALL_LEFT + ARENA_WIDTH*9/10

    rightGoal.bind "score", ->
      scoreboard.score "away"

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

