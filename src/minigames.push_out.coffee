Minigames.PushOut = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  # TODO Parameterize physics
  # TODO Parameterize rink
  physics = Physics()

  arenaRadius = 300
  center = Point(App.width/2, App.height/2)

  self.bind "enter", ->
    engine.clear(true)

    # TODO: TEst only
    n = 4
    n.times (i) ->
      p = Point.fromAngle(i * Math.TAU/4).scale(100).add(center)
      engine.add
        class: "Player"
        id: i
        x: p.x
        y: p.y

    # Add each player to game based on config data
    config.players.each (playerData) ->
      engine.add Object.extend({}, playerData)

    if config.music
      Music.play "music1"

  self.bind "beforeDraw", (canvas) ->
    canvas.drawCircle(
      x: center.x
      y: center.y
      color: "white"
      radius: arenaRadius
    )

  # Add events and methods here
  self.bind "update", ->
    players = engine.find("Player").shuffle()
    zambonis = engine.find("Zamboni")

    objects = players.concat zambonis

    physics.process(objects)

  # We must always return self as the last line
  return self

