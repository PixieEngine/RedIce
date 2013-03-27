Minigames["Whack-A-Mole"] = (I={}) ->
  self = Minigame(I)

  physics = Physics()

  self.on "enter", ->
    engine.add
      class: "Rink"
      wallTop: 0
      wallBottom: App.height
      wallLeft: 0
      wallRight: App.width

  # Add events and methods here
  self.on "update", ->
    return if I.paused

    players = engine.find("Player").shuffle()
    zambonis = engine.find("Zamboni")

    objects = players.concat zambonis

    physics.process(objects)

  # We must always return self as the last line
  return self
