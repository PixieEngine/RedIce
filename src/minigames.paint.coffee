Minigames.Paint = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  window.physics = Physics()

  self.on "enter", ->
    engine.clear(true)

    engine.add
      class: "Rink"
      wallTop: 0
      wallBottom: App.height
      wallLeft: 0
      wallRight: App.width

    i = 0
    colors = [
      "#000000"
      "#FFFFFF"
      "#666666"
      "#DCDCDC"
      "#EB070E"
      "#F69508"
      "#FFDE49"
      "#388326"
      "#0246E3"
      "#563495"
      "#58C4F5"
      "#E5AC99"
      "#5B4635"
      "#FFFEE9"
    ]

    colors.each (color, i) ->
      engine.add
        class: "Paint"
        y: 0
        x: (i + 0.5) * App.width / colors.length
        color: color

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
  self.on "update", ->
    players = engine.find("Player").shuffle()
    zambonis = engine.find("Zamboni")

    objects = players.concat zambonis

    physics.process(objects)

  # We must always return self as the last line
  return self

