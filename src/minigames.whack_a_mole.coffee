Minigames["Whack-A-Mole"] = (I={}) ->
  Object.reverseMerge I,
    time: 30
    playerIncludes: [
      "WhackAMole"
    ]

  self = Minigame(I)

  physics = Physics()

  self.on "overlay", (canvas) ->
    if I.winner
      self.displayWinnerOverlay(canvas)

  self.on "enter", ->
    engine.add
      decals: false
      lines: false
      class: "Rink"
      wallTop: 32
      wallBottom: App.height - 32
      wallLeft: WALL_BUFFER_HORIZONTAL
      wallRight: App.width - WALL_BUFFER_HORIZONTAL

    9.times (i) ->
      y = (i / 3).floor()
      x = (i % 3)

      engine.add
        class: "MoleHole"
        y: (y + 1) / 4 * App.height
        x: (x + 1) / 4 * App.width

  drawTime = (canvas) ->
    canvas.font "40px 'Iceland'"

    canvas.centerText
      text: I.time.ceil().clamp(0, Infinity)
      color: "#BB7"
      y: 64

  self.on "overlay", (canvas) ->
    drawTime(canvas)

  # Add events and methods here
  self.on "update", (dt) ->
    return if I.paused

    I.time -= dt

    players = engine.find("Player").shuffle()
    zambonis = engine.find("Zamboni")

    objects = players.concat zambonis

    physics.process(objects)

    if I.time <= 0
      unless I.winner
        winningPlayer = players.maximum (player) ->
          player.I.score

        I.winner = winningPlayer.I.teamStyle

        engine.delay 3, ->
          setupState = MinigameSetupState
            nextState: Minigames["Whack-A-Mole"]

          engine.setState(setupState)

  # We must always return self as the last line
  return self
