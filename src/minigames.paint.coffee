Minigames.Paint = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  window.physics = Physics()

  self.bind "enter", ->
    engine.clear(true)

    # Draw the front Rink Boards at the correct zIndex
    engine.add
      class: "RinkBoardsProxy"

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
    gibs = engine.find("Gib")

    objects = players.concat zambonis, gibs
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
      splats = engine.find("Blood")

      splats.each (splat) ->
        if Collision.circular(player.circle(), splat.circle())
          player.bloody()

  # We must always return self as the last line
  return self

