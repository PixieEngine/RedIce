Sprite.loadSheet = (name, tileWidth, tileHeight) ->
  directory = App?.directories?.images || "images"

  url = "#{BASE_URL}/#{directory}/#{name}.png?#{MTIME}"

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

window.config =
  throwBottles: true
  players: []

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
MAX_PLAYERS = 6
window.activePlayers = 0

window.engine = Engine
  canvas: $("canvas").powerCanvas()
  excludedModules: ["HUD"]
  includedModules: ["Joysticks"]
  showFPS: true
  zSort: true

join = (i) ->
  config.players[i].cpu = false
  window.activePlayers += 1

  backgroundColor = Color(Player.COLORS[i])
  backgroundColor.a(0.5)

  cursorColor = backgroundColor.lighten(0.25)

  nameEntry = engine.add
    backgroundColor: backgroundColor
    class: "NameEntry"
    controller: controllers[i]
    cursorColor: cursorColor
    x:  i * (App.width / MAX_PLAYERS)
    y:  20

  nameEntry.bind "done", (name) ->
    nameEntry.destroy()

    config.players[i].name = name

    configurator = engine.find("Configurator").first()

    if configurator
      configurator.addPlayer
        color: backgroundColor
        id: i
        name: name
        ready: false
        team: 0

gameState = titleScreenUpdate = ->
  controllers.each (controller, i) ->
    if controller.actionDown "ANY"
      titleScreen.trigger("next")
      initPlayerData()

      configurator = engine.add
        class: "Configurator"
        x: 240
        y: 240

      configurator.bind "done", ->
        configurator.destroy()

        configurator.players().each (playerConfig) ->
          id = playerConfig.id

          $.extend config.players[id],
            name: playerConfig.name
            team: if playerConfig.team is -1 then 0 else 1
            joystick: true

        startMatch()

matchSetupUpdate = ->
  controllers.each (controller, i) ->
    if config.players[i].cpu && controller.actionDown "ANY"
      join(i)

matchPlayUpdate = ->
  pucks = engine.find("Puck")
  players = engine.find("Player").shuffle()
  zambonis = engine.find("Zamboni")

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
    splats = engine.find("Blood")

    splats.each (splat) ->
      if Collision.circular(player.circle(), splat.circle())
        player.bloody()

addPlayersFromConfigs = ->
  [cpus, humans] = config.players.partition (playerData) ->
    playerData.cpu

  [reds, blues] = humans.partition (playerData) ->
    playerData.team

  # Rebalance CPU players as needed
  if cpus.length
    cpus.unshift().team = 0 while cpus.length && reds.length > blues.length
    cpus.unshift().team = 1 while cpus.length && blues.length > reds.length

  config.players.each (playerData) ->
    engine.add $.extend(playerData, class: "Player")

controllers = []
MAX_PLAYERS.times (i) ->
  controller = controllers[i] = engine.controller(i)
  controller.bind()

Music.play "title_screen"

restartMatch = ->
  doRestart = ->
    engine.I.objects.clear()
    engine.unbind "afterUpdate", doRestart
    startMatch()

  engine.bind "afterUpdate", doRestart

startMatch = ->
  gameState = matchPlayUpdate

  window.scoreboard = engine.add
    class: "Scoreboard"
    # periodTime: 120
    # period: 3

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

  addPlayersFromConfigs()

  engine.add
    class: "Puck"

  leftGoal = engine.add
    class: "Goal"
    team: 0
    x: WALL_LEFT + ARENA_WIDTH/10 - 32

  leftGoal.bind "score", ->
    scoreboard.score "home"

  rightGoal = engine.add
    class: "Goal"
    team: 1
    x: WALL_LEFT + ARENA_WIDTH*9/10

  rightGoal.bind "score", ->
    scoreboard.score "away"

  Music.play "music1"

nameEntry = ->
  gameState = matchSetupUpdate

titleScreen = TitleScreen
  callback: nameEntry

engine.bind "beforeDraw", (canvas) ->
  # Draw player shadows
  # This needs to be done before draw so that shadows don't appear above sprites
  engine.find("Player").invoke "drawShadow", canvas

engine.bind "draw", (canvas) ->
  if DEBUG_DRAW
    engine.find("Player, Puck, Goal, Bottle, Zamboni").each (object) ->
      object.trigger("drawDebug", canvas)

  canvas.font("bold 16px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")
  engine.find("Player").invoke "drawFloatingNameTag", canvas

engineUpdate = ->
  gameState()

engine.bind "update", engineUpdate

engine.start()

initPlayerData = ->
  MAX_PLAYERS.times (i) ->
    # Player positioning
    y = WALL_TOP + ARENA_HEIGHT*((i/2).floor() + 1)/4
    x = WALL_LEFT + ARENA_WIDTH/2 + ((i%2) - 0.5) * ARENA_WIDTH / 6

    config.players[i] =
      id: i
      x: x
      y: y
      team: i % 2
      joystick: true
      cpu: true

$(document).bind "keydown", "0", ->
  DEBUG_DRAW = !DEBUG_DRAW

MAX_PLAYERS.times (i) ->
  n = i + 1
  $(document).bind "keydown", n.toString(), ->
    if scoreboard.gameOver()
      window.config.joystickPlayers = n
      restartMatch()

