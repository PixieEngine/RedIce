WALL_LEFT = 64
WALL_RIGHT = App.width - WALL_LEFT
WALL_TOP = 128
WALL_BOTTOM = App.height - WALL_TOP

window.engine = Engine 
  canvas: $("canvas").powerCanvas()
  zSort: true

engine.add
  sprite: Sprite.loadByName "title"

engine.add
  class: "Player"

engine.add
  class: "Player"
  controller: 1

engine.add
  class: "Puck"

engine.bind "draw", (canvas) ->
  canvas.strokeColor("black")

  canvas.strokeRect(WALL_LEFT, WALL_TOP, WALL_RIGHT - WALL_LEFT, WALL_BOTTOM - WALL_TOP)

engine.bind "update", ->
  # Resolve Collisions
  players = engine.find("Player").shuffle()

  players.push engine.find("Puck").first()

  threshold = 5

  i = 0
  while i < players.length
    playerA = players[i]

    j = i + 1
    while j < players.length
      playerB = players[j]

      if !playerA.I.wipeout && !playerB.I.wipeout && Collision.circular(playerA.circle(), playerB.circle())
        delta = playerB.center().subtract(playerA.center()).norm()

        # Knockback
        if playerB.puck()
          playerB.I.velocity = delta.scale(playerA.I.velocity.length())
        else
          pushA = delta.scale(-2)
          pushB = delta.scale(2)

          playerA.I.velocity = playerA.I.velocity.add(pushA) 
          playerB.I.velocity = playerB.I.velocity.add(pushB)

        # Checking
        projA = playerA.I.velocity.dot(delta)
        projB = -playerB.I.velocity.dot(delta)

        max = Math.max(projA, projB)

        if max > threshold
          console.log max

          if projA == max
            playerB.wipeout(pushB)
          else
            playerA.wipeout(pushA)

      j += 1
    i += 1

  players.each (player) ->
    center = player.center()
    radius = player.I.radius

    # Wall Collisions
    if center.x - radius < WALL_LEFT
      player.I.velocity.x = -player.I.velocity.x
      player.I.x += player.I.velocity.x

    if center.x + radius > WALL_RIGHT
      player.I.velocity.x = -player.I.velocity.x
      player.I.x += player.I.velocity.x

    if center.y - radius < WALL_TOP
      player.I.velocity.y = -player.I.velocity.y
      player.I.y += player.I.velocity.y

    if center.y + radius > WALL_BOTTOM
      player.I.velocity.y = -player.I.velocity.y
      player.I.y += player.I.velocity.y

    # TODO: Blood Collisions


engine.start()

