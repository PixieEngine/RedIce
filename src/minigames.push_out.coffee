Minigames.PushOut = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  physics = Physics()

  arena = Point(App.width/2, App.height/2)
  arena.radius = 300

  self.on "enter", ->
    engine.clear(true)

    # TODO: TEst only
    n = 4
    n.times (i) ->
      p = Point.fromAngle(i * Math.TAU/4).scale(100).add(arena)
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

  self.on "beforeDraw", (canvas) ->
    canvas.drawCircle
      circle: arena
      color: "white"

  # Add events and methods here
  self.on "update", ->
    players = engine.find("Player").shuffle()
    zambonis = engine.find("Zamboni")

    objects = players.concat zambonis

    physics.process(objects)

    players.each (player) ->
      player.destroy() unless Collision.circular(player.circle(), arena)

  # We must always return self as the last line
  return self

