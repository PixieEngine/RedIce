PuckLeader = (I) ->

  self = GameObject(I).extend
    draw: (canvas) ->
      # Do nothing

  self.on "update", (canvas) ->
    if puck = engine.find("Puck").first()
      puckPosition = puck.position()
      puckVelocity = puck.velocity()

      # Camera should lead puck by a multiple of the pucks velocity
      position = puckPosition.add(puckVelocity.scale(40))

      I.x = position.x
      I.y = position.y
    else
      I.x = ARENA_CENTER.x
      I.y = ARENA_CENTER.y

  return self
