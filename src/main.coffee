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

window.WALL_LEFT = 32
window.WALL_RIGHT = CANVAS_WIDTH - WALL_LEFT
window.WALL_TOP = 192
window.WALL_BOTTOM = CANVAS_HEIGHT - (WALL_TOP - 128)

window.ARENA_WIDTH = WALL_RIGHT - WALL_LEFT
window.ARENA_HEIGHT = WALL_BOTTOM - WALL_TOP

window.BLOOD_COLOR = "#BA1A19"
window.ICE_COLOR = "rgba(192, 255, 255, 0.2)"

rink = Rink()
physics = Physics()
useJoysticks = false

window.bloodCanvas = $("<canvas width=#{CANVAS_WIDTH} height=#{CANVAS_HEIGHT} />").powerCanvas()
bloodCanvas.strokeColor(BLOOD_COLOR)
# bloodCanvas.fill(BLOOD_COLOR) # For zamboni testing

num_players = 6

boardsBackSprite = Sprite.loadByName("boards_back")
boardsFrontSprite = 
fansSprite = Sprite.loadByName("fans")

DEBUG_DRAW = false

window.engine = Engine
  backgroundColor: "#00010D"
  canvas: $("canvas").powerCanvas()
  excludedModules: ["HUD"]
  showFPS: true
  zSort: true

scoreboard = engine.add
  class: "Scoreboard"

engine.add
  class: "Boards"
  sprite: Sprite.loadByName("boards_front")
  width: ARENA_WIDTH - 192
  x: WALL_LEFT + 96
  y: WALL_TOP - 48
  zIndex: 1

engine.add
  class: "Boards"
  sprite: Sprite.loadByName("boards_back")
  width: ARENA_WIDTH - 128
  x: WALL_LEFT + 64
  y: WALL_BOTTOM - 48
  zIndex: 10

num_players.times (i) ->
  y = WALL_TOP + ARENA_HEIGHT*((i/2).floor() + 1)/4
  x = WALL_LEFT + ARENA_WIDTH/2 + ((i%2) - 0.5) * ARENA_WIDTH / 6

  engine.add
    class: "Player"
    controller: i
    joystick: useJoysticks
    x: x
    y: y

engine.add
  class: "Puck"

leftGoal = engine.add
  class: "Goal"
  x: WALL_LEFT + ARENA_WIDTH/10 - 32

leftGoal.bind "score", ->
  scoreboard.score "away"

rightGoal = engine.add
  class: "Goal"
  right: true
  x: WALL_LEFT + ARENA_WIDTH*9/10

rightGoal.bind "score", ->
    scoreboard.score "home"

engine.bind "preDraw", (canvas) ->
  # Fans
  fansSprite.fill(canvas, 0, 0, App.width, WALL_TOP)

  rink.draw(canvas)

  blood = bloodCanvas.element()
  canvas.drawImage(blood, WALL_LEFT, WALL_TOP, ARENA_WIDTH, ARENA_HEIGHT, WALL_LEFT, WALL_TOP, ARENA_WIDTH, ARENA_HEIGHT)

  # Draw player shadows
  engine.find("Player").invoke "drawShadow", canvas

engine.bind "draw", (canvas) ->
  # Draw name tags
  engine.find("Player").invoke "drawOverlays", canvas

  if DEBUG_DRAW
    engine.find("Player, Puck, Goal").each (puck) ->
      puck.trigger("drawDebug", canvas)

engine.bind "update", ->
  Joysticks.update() if useJoysticks

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

  physics.process(objects)

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

Joysticks.init()
log Joysticks.status()

