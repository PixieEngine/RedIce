Minigames["Sumo Push"] = (I={}) ->
  self = Minigame(I)

  physics = Physics()

  arena = Point(App.width/2, App.height/2)
  arena.radius = 300

  self.on "beforeDraw", (canvas) ->
    canvas.drawCircle
      circle: arena
      color: "white"

  # Add events and methods here
  self.on "update", ->
    # TODO: Detect Winner

    players = engine.find("Player").shuffle()
    zambonis = engine.find("Zamboni")

    objects = players.concat zambonis

    physics.process(objects)

    players.each (player) ->
      player.destroy() unless Collision.circular(player.circle(), arena)

  return self
