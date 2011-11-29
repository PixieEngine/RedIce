StateMatch = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  physics = Physics()

  # Add events and methods here
  self.bind "update", ->
    pucks = self.find("Puck")
    players = self.find("Player").shuffle()
    zambonis = self.find("Zamboni")

    objects = players.concat zambonis, pucks
    playersAndPucks = players.concat pucks

    # Puck handling
    players.each (player) ->
      return if player.I.wipeout

      pucks.each (puck) ->
        if Collision.circular(player.controlCircle(), puck.circle())
          player.controlPuck(puck)

    physics.process(objects)

    playersAndPucks.each (player) ->
      # Blood Collisions
      splats = self.find("Blood")

      splats.each (splat) ->
        if Collision.circular(player.circle(), splat.circle())
          player.bloody()

  # We must always return self as the last line
  return self

