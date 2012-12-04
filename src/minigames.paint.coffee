Minigames.Paint = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  window.physics = Physics()

  self.bind "enter", ->
    engine.clear(true)

    engine.add
      class: "Rink"
      wallTop: 0
      wallBottom: App.height
      wallLeft: 0
      wallRight: App.width

    n = 8
    i = 0

    ["0", "F"].each (r) ->
      ["0", "F"].each (g) ->
        ["0", "F"].each (b) ->
          color = ["#", r, g, b].join("")

          engine.add
            class: "Paint"
            y: 0
            x: (i + 0.5) * App.width / n
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

  # Add events and methods here
  self.bind "update", ->
    players = engine.find("Player").shuffle()
    zambonis = engine.find("Zamboni")

    objects = players.concat zambonis

    physics.process(objects)

  # We must always return self as the last line
  return self

