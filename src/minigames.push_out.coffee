Minigames["Sumo Push"] = (I={}) ->
  Object.reverseMerge I,
    music: "Substantially Sumo"
    winner: false

  self = Minigame(I)

  physics = Physics()

  arena = Point(App.width/2, App.height/2)
  arena.radius = 300

  self.on "beforeDraw", (canvas) ->
    canvas.drawCircle
      circle: arena
      color: "white"

  self.on "overlay", (canvas) ->
    if I.winner
      self.displayWinnerOverlay(canvas)

  # Add events and methods here
  self.on "update", ->
    return if I.paused

    # TODO: Detect Winner

    players = engine.find("Player").shuffle()
    zambonis = engine.find("Zamboni")

    if players.length is 1
      unless I.winner
        I.winner = players.first().I.teamStyle

        engine.delay 1.5, ->
          setupState = MinigameSetupState
            nextState: Minigames["Sumo Push"]

          engine.setState(setupState)

    objects = players.concat zambonis

    physics.process(objects)

    players.each (player) ->
      player.destroy() unless Collision.circular(player.circle(), arena)

  return self
