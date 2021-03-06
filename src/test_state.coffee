TestState = (I={}) ->
  self = GameState(I)

  physics = Physics()

  controller = Gamepads.KeyboardController
    debugColor: "#FFF"

  self.on "enter", ->
    engine.add
      class: "Puck"

    leftGoal = engine.add
      class: "Goal"
      right: false
      x: WALL_LEFT + ARENA_WIDTH/10 - 32

    rightGoal = engine.add
      class: "Goal"
      right: true
      x: WALL_LEFT + ARENA_WIDTH*9/10

  self.on "overlay", (canvas) ->
    canvas.withTransform Matrix.translation(50, 50), (canvas) ->
      controller.drawDebug(canvas)

  self.on "update", (dt) ->
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
          player.controlPuck(puck, dt)

    physics.process(objects)

    playersAndPucks.each (player) ->
      # Blood Collisions
      splats = engine.find("Blood")

      splats.each (splat) ->
        if Collision.circular(player.circle(), splat.circle())
          player.bloody()

  # We must always return self as the last line
  return self

