Minigames.Paint = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  window.physics = Physics()

  self.bind "enter", ->
    engine.clear(true)

    # Draw the front Rink Boards at the correct zIndex
    engine.add
      class: "RinkBoardsProxy"

    # TODO: TEst only
    p = engine.add
      class: "Player"
      id: 3

    p.include Player.Paint

    n = 8
    i = 0

    ["0", "F"].each (r) ->
      ["0", "F"].each (g) ->
        ["0", "F"].each (b) ->
          color = ["#", r, g, b].join("")

          engine.add
            class: "Paint"
            y: WALL_TOP
            x: WALL_LEFT + (i + 0.5) * (WALL_RIGHT - WALL_LEFT) / n
            color: color

          i += 1

    # Add each player to game based on config data
    config.players.each (playerData) ->
      engine.add Object.extend({}, playerData)

    if config.music
      Music.play "music1"

  self.bind "beforeDraw", (canvas) ->
    Fan.crowd.invoke("draw", canvas)
    rink.drawBase(canvas)
    rink.drawBack(canvas)

  # Add events and methods here
  self.bind "update", ->
    players = engine.find("Player").shuffle()
    zambonis = engine.find("Zamboni")

    objects = players.concat zambonis

    physics.process(objects)

  # We must always return self as the last line
  return self

