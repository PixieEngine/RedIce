window.CANVAS_WIDTH = App.width
window.CANVAS_HEIGHT = App.height

WALL_LEFT = 64
WALL_RIGHT = CANVAS_WIDTH - WALL_LEFT
WALL_TOP = 128
WALL_BOTTOM = CANVAS_HEIGHT - WALL_TOP

ARENA_WIDTH = WALL_RIGHT - WALL_LEFT
ARENA_HEIGHT = WALL_BOTTOM - WALL_TOP

window.BLOOD_COLOR = "#BA1A19"
window.ICE_COLOR = "rgba(192, 255, 255, 0.2)"

window.bloodCanvas = $("<canvas width=#{CANVAS_WIDTH} height=#{CANVAS_HEIGHT} />").powerCanvas()
bloodCanvas.strokeColor(BLOOD_COLOR)

window.engine = Engine 
  canvas: $("canvas").powerCanvas()
  zSort: true

6.times (i) ->
  y = WALL_TOP + ARENA_HEIGHT*((i/2).floor() + 1)/4
  x = WALL_LEFT + ARENA_WIDTH/2 + ((i%2) - 0.5) * ARENA_WIDTH / 6
  engine.add
    class: "Player"
    controller: i
    x: x
    y: y

engine.add
  class: "Puck"

#engine.add
#  class: "Zamboni"

time = 2 * 60 * 30
scoreboard = Sprite.loadByName("scoreboard")

engine.bind "preDraw", (canvas) ->
  red = "red"
  blue = "blue"
  faceOffSpotRadius = 5
  faceOffCircleRadius = 38

  # Draw Arena
  canvas.strokeColor("black")
  canvas.strokeRect(WALL_LEFT, WALL_TOP, ARENA_WIDTH, ARENA_HEIGHT)

  # Blue Lines
  canvas.strokeColor(blue)
  x = WALL_LEFT + ARENA_WIDTH/3
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 4)
  x = WALL_LEFT + ARENA_WIDTH*2/3
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 4)

  # Center Line
  canvas.strokeColor(red)
  x = WALL_LEFT + ARENA_WIDTH/2
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 2)

  # Center Circle
  x = WALL_LEFT + ARENA_WIDTH/2
  y = WALL_TOP + ARENA_HEIGHT/2
  canvas.fillCircle(x, y, faceOffSpotRadius, blue)
  canvas.context().lineWidth = 2
  canvas.strokeCircle(x, y, faceOffCircleRadius, blue)

  # Goal Lines
  canvas.strokeColor(red)
  x = WALL_LEFT + ARENA_WIDTH/20
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 1)
  canvas.strokeRect(x, WALL_TOP + ARENA_HEIGHT/2 - 16, 16, 32)
  x = WALL_LEFT + ARENA_WIDTH*19/20
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 1)
  canvas.strokeRect(x - 16, WALL_TOP + ARENA_HEIGHT/2 - 16, 16, 32)

  [1, 3].each (verticalQuarter) ->
    y = WALL_TOP + verticalQuarter/4 * ARENA_HEIGHT

    [3/20, 1/3 + 1/40, 2/3 - 1/40, 17/20].each (faceOffX, i) ->
      x = WALL_LEFT + faceOffX * ARENA_WIDTH

      canvas.fillCircle(x, y, faceOffSpotRadius, red)
      if i == 0 || i == 3
        canvas.context().lineWidth = 2
        canvas.strokeCircle(x, y, faceOffCircleRadius, red)

  blood = bloodCanvas.element()
  canvas.drawImage(blood, 0, 0, blood.width, blood.height, 0, 0, blood.width, blood.height)

  # Scoreboard
  scoreboard.draw(canvas, WALL_LEFT + (ARENA_WIDTH - scoreboard.width)/2, 16)
  minutes = (time / 30 / 60).floor()
  seconds = ((time / 30).floor() % 60).toString()

  if seconds.length == 1
    seconds = "0" + seconds

  canvas.fillColor("red")
  canvas.font("bold 24px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")
  canvas.fillText("#{minutes}:#{seconds}", WALL_LEFT + ARENA_WIDTH/2 - 22, 46)

engine.bind "update", ->
  time -= 1

  if time <= 0
    #TODO: End Period
    time = 0

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

    # Blood Collisions
    splats = engine.find("Blood")

    splats.each (splat) ->
      if Collision.circular(player.circle(), splat.circle())
        player.bloody()

engine.start()

