TestState = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  physics = Physics()
  
  controller = Gamepads.KeyboardController()

  self.bind "enter", ->
    engine.clear(true)
    
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

  self.bind "overlay", (canvas) ->
    canvas.withTransform Matrix.translation(0, 0), (canvas) ->
      controller.drawDebug(canvas)

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

