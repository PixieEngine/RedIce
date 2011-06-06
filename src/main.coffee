CANVAS_WIDTH = App.width
CANVAS_HEIGHT = App.height

WALL_LEFT = 64
WALL_RIGHT = CANVAS_WIDTH - WALL_LEFT
WALL_TOP = 128
WALL_BOTTOM = CANVAS_HEIGHT - WALL_TOP

ARENA_WIDTH = WALL_RIGHT - WALL_LEFT
ARENA_HEIGHT = WALL_BOTTOM - WALL_TOP

BLOOD_COLOR = "#BA1A19"

window.bloodCanvas = $("<canvas width=#{CANVAS_WIDTH} height=#{CANVAS_HEIGHT} />").powerCanvas()
bloodCanvas.strokeColor(BLOOD_COLOR)

window.engine = Engine 
  canvas: $("canvas").powerCanvas()
  zSort: true

engine.add
  class: "Player"

engine.add
  class: "Player"
  controller: 1

engine.add
  class: "Puck"

engine.bind "preDraw", (canvas) ->

  # Draw Arena
  canvas.strokeColor("black")
  canvas.strokeRect(WALL_LEFT, WALL_TOP, ARENA_WIDTH, ARENA_HEIGHT)

  canvas.strokeColor("blue")
  x = WALL_LEFT + ARENA_WIDTH/3
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 4)
  x = WALL_LEFT + ARENA_WIDTH*2/3
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 4)

  canvas.strokeColor("red")
  x = WALL_LEFT + ARENA_WIDTH/2
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 2)

  x = WALL_LEFT + ARENA_WIDTH/20
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 1)
  x = WALL_LEFT + ARENA_WIDTH*19/20
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 1)

  blood = bloodCanvas.element()
  canvas.drawImage(blood, 0, 0, blood.width, blood.height, 0, 0, blood.width, blood.height)

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
    splats = engine.find(".blood=1")

    splats.each (splat) ->
      splatCircle = splat.center()
      splatCircle.radius = 10

      if Collision.circular(player.circle(), splatCircle)
        player.bloody()

engine.start()

