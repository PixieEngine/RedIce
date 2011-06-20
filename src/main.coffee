Sprite.loadSheet = (name, tileWidth, tileHeight) ->
  directory = App?.directories?.images || "images"

  url = "#{BASE_URL}/#{directory}/#{name}.png"

  sprites = []
  image = new Image()

  image.onload = ->
    (image.height / tileHeight).times (row) ->
      (image.width / tileWidth).times (col) ->
        sprites.push(Sprite.create(image, col * tileWidth, row * tileHeight, tileWidth, tileHeight))

  image.src = url

  return sprites

window.sprites = Sprite.loadSheet("sprites", 32, 48)
window.wideSprites = Sprite.loadSheet("sprites", 64, 48)
window.tallSprites = Sprite.loadSheet("sprites", 32, 96)

window.CANVAS_WIDTH = App.width
window.CANVAS_HEIGHT = App.height

window.WALL_LEFT = 64
window.WALL_RIGHT = CANVAS_WIDTH - WALL_LEFT
window.WALL_TOP = 128
window.WALL_BOTTOM = CANVAS_HEIGHT - WALL_TOP

window.ARENA_WIDTH = WALL_RIGHT - WALL_LEFT
window.ARENA_HEIGHT = WALL_BOTTOM - WALL_TOP

window.BLOOD_COLOR = "#BA1A19"
window.ICE_COLOR = "rgba(192, 255, 255, 0.2)"

window.bloodCanvas = $("<canvas width=#{CANVAS_WIDTH} height=#{CANVAS_HEIGHT} />").powerCanvas()
bloodCanvas.strokeColor(BLOOD_COLOR)
# bloodCanvas.fill(BLOOD_COLOR) # For zamboni testing

periodTime = 1 * 60 * 30
intermissionTime = 1 * 30

period = 0
time = 0
homeScore = 0
awayScore = 0
scoreboard = Sprite.loadByName("scoreboard")

GAME_OVER = false
INTERMISSION = false

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

leftGoal = engine.add
  class: "Goal"

leftGoal.bind "score", ->
  awayScore += 1

rightGoal = engine.add
  class: "Goal"
  right: true
  x: WALL_LEFT + ARENA_WIDTH*19/20

rightGoal.bind "score", ->
  homeScore += 1

intermission = () ->
  INTERMISSION = true
  time = intermissionTime

  engine.add
    class: "Zamboni"
    reverse: period % 2

nextPeriod = () ->
  time = periodTime
  INTERMISSION = false
  period += 1

  if period == 4
    GAME_OVER = true
    #TODO check team scores and choose winner

nextPeriod()

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
  canvas.fillText(period, WALL_LEFT + ARENA_WIDTH/2 + 18, 84)

  canvas.fillText(homeScore, WALL_LEFT + ARENA_WIDTH/2 - 72, 60)
  canvas.fillText(awayScore, WALL_LEFT + ARENA_WIDTH/2 + 90, 60)

engine.bind "draw", (canvas) ->
  engine.find("Player, Puck").each (puck) ->
    puck.trigger("drawDebug", canvas)

  if GAME_OVER
    canvas.font("bold 24px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")
    canvas.fillColor("#000")
    canvas.centerText("GAME OVER", 384)

engine.bind "update", ->
  time -= 1

  if INTERMISSION
    if time == 0
      nextPeriod()
  else if GAME_OVER
    time = 0
  else # Regular play
    if time == 0
      intermission()

  puck = engine.find("Puck").first()

  players = engine.find("Player").shuffle()
  zambonis = engine.find("Zamboni")

  objects = players.concat zambonis
  objects.push puck

  playersAndPuck = players.concat puck

  # Puck handling
  players.each (player) ->
    return if player.I.wipeout

    if Collision.circular(player.controlCircle(), puck.circle())
      player.controlPuck(puck)

  Physics.resolveCollisions(objects)

  Physics.wallCollisions(playersAndPuck)

  playersAndPuck.each (player) ->
    # Blood Collisions
    splats = engine.find("Blood")

    splats.each (splat) ->
      if Collision.circular(player.circle(), splat.circle())
        player.bloody()

engine.start()

bgMusic = $ "<audio />",
  src: BASE_URL + "/sounds/music1.mp3"
  loop: "loop"
.appendTo('body').get(0)

bgMusic.volume = 0.40
bgMusic.play()
