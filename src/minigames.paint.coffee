Minigames.Paint = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  window.physics = Physics()

  self.bind "enter", ->
    engine.clear(true)

    # Draw the front Rink Boards at the correct zIndex
    engine.add
      class: "RinkBoardsProxy"

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

    # TODO: TEst only, get real data for configurator
    config.players = []
    n = 4
    n.times (i) ->
      p = Point.fromAngle(i * Math.TAU/4).scale(100).add(Point(App.width/2, App.height/2))
      config.players.push
        class: "Player"
        id: i
        x: p.x
        y: p.y

    # Add each player to game based on config data
    config.players.each (playerData) ->
      player = engine.add Object.extend({}, playerData)
      player.include Player.Paint

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

