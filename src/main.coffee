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

config =
  throwBottles: true
  players: 6
  humanPlayers: 2
  keyboardPlayers: 2
  joystickPlayers: 4
  joysticks: true

rink = Rink()
physics = Physics()

window.bloodCanvas = $("<canvas width=#{CANVAS_WIDTH} height=#{CANVAS_HEIGHT} />")
  .appendTo("body")
  .css
    position: "absolute"
    top: 0
    left: 0
    zIndex: "-1"
  .powerCanvas()

bloodCanvas.strokeColor(BLOOD_COLOR)
# bloodCanvas.fill(BLOOD_COLOR) # For zamboni testing

DEBUG_DRAW = false

window.engine = Engine
  canvas: $("canvas").powerCanvas()
  clear: true
  excludedModules: ["HUD"]
  showFPS: true
  zSort: true

Music.play "title_screen"

TitleScreen
  callback: ->
    scoreboard = engine.add
      class: "Scoreboard"

    engine.add
      sprite: Sprite.loadByName("corner_left")
      x: 0
      y: WALL_TOP - 48
      width: 128
      zIndex: 1

    engine.add
      sprite: Sprite.loadByName("corner_left")
      hflip: true
      x: WALL_RIGHT - 96
      y: WALL_TOP - 48
      width: 128
      zIndex: 1

    engine.add
      spriteName: "corner_back_right"
      hflip: true
      x: 32
      y: WALL_BOTTOM - 128
      zIndex: 2

    engine.add
      spriteName: "corner_back_right"
      x: WALL_RIGHT - 96
      y: WALL_BOTTOM - 128
      zIndex: 2

    engine.add
      class: "Boards"
      sprite: Sprite.loadByName("boards_front")
      y: WALL_TOP - 48
      zIndex: 1

    engine.add
      class: "Boards"
      sprite: Sprite.loadByName("boards_back")
      y: WALL_BOTTOM - 48
      zIndex: 10

    config.players.times (i) ->
      y = WALL_TOP + ARENA_HEIGHT*((i/2).floor() + 1)/4
      x = WALL_LEFT + ARENA_WIDTH/2 + ((i%2) - 0.5) * ARENA_WIDTH / 6

      if i < config.keyboardPlayers
        joystick = false
        controller = i
      else
        joystick = true
        controller = i - config.keyboardPlayers

      engine.add
        class: "Player"
        controller: controller
        id: i
        team: i % 2
        cpu: i >= config.humanPlayers
        joystick: joystick
        x: x
        y: y

    engine.add
      class: "Puck"

    leftGoal = engine.add
      class: "Goal"
      team: 0
      x: WALL_LEFT + ARENA_WIDTH/10 - 32

    leftGoal.bind "score", ->
      scoreboard.score "away"

    rightGoal = engine.add
      class: "Goal"
      team: 1
      x: WALL_LEFT + ARENA_WIDTH*9/10

    rightGoal.bind "score", ->
      scoreboard.score "home"

    engine.bind "preDraw", (canvas) ->
      # Draw player shadows
      engine.find("Player").invoke "drawShadow", canvas

    engine.bind "draw", (canvas) ->
      if DEBUG_DRAW
        engine.find("Player, Puck, Goal, Bottle").each (puck) ->
          puck.trigger("drawDebug", canvas)

    engine.bind "update", ->
      Joysticks.update() if config.joysticks

      throwBottles() if config.throwBottles

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

    Music.play "music1"

Joysticks.init()
log Joysticks.status()

throwBottles = ->
  if !rand(20)
    engine.add
      class: "Bottle"
      x: rand App.width
      y: rand WALL_TOP

$(document).bind "keydown", "0", ->
  DEBUG_DRAW = !DEBUG_DRAW

