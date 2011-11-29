window.sprites = Sprite.loadSheet("sprites", 32, 48)
window.wideSprites = Sprite.loadSheet("sprites", 64, 48)
window.tallSprites = Sprite.loadSheet("sprites", 32, 96)

window.tubsSprites =
  fast:
    front: Sprite.loadSheet("tubs_fast_front", 512, 512)
    back: Sprite.loadSheet("spiketubs_fast_ne_strip6", 512, 512)
  slow:
    front: Sprite.loadSheet("spiketubs_slow_se_strip6", 512, 512)
    back: Sprite.loadSheet("tubs_slow_back", 512, 512)
  coast:
    front: Sprite.loadSheet("spiketubs_idle_se_strip2", 512, 512)
    back: Sprite.loadSheet("spiketubs_idle_ne_strip2", 512, 512)
  fall: Sprite.loadSheet("spiketubs_falldown_se_strip6", 512, 512)
  shoot: Sprite.loadSheet("spiketubs_shoot_se_strip11", 512, 512)

window.headSprites =
  stubs: Sprite.loadSheet("SPIKEstubs_norm_strip5", 512, 512)

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

#TODO Manage these extra canvases better
rink = Rink()
window.bloodCanvas = $("<canvas width=#{CANVAS_WIDTH} height=#{CANVAS_HEIGHT} />")
  .appendTo("body")
  .css
    position: "absolute"
    top: 0
    left: 0
    zIndex: "-1"
  .pixieCanvas()

bloodCanvas.strokeColor(BLOOD_COLOR)
# bloodCanvas.fill(BLOOD_COLOR) # For zamboni testing

window.MAX_PLAYERS = 6
window.activePlayers = 0

window.engine = Engine
  canvas: $("canvas").pixieCanvas()
  includedModules: ["Joysticks", "FPSCounter"]
  showFPS: true
  zSort: true

DEBUG_DRAW = false
$(document).bind "keydown", "0", ->
  DEBUG_DRAW = !DEBUG_DRAW

engine.bind "draw", (canvas) ->
  if DEBUG_DRAW
    engine.find("Player, Puck, Goal, Bottle, Zamboni").each (object) ->
      object.trigger("drawDebug", canvas)

  canvas.font("bold 16px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")
  engine.find("Player").invoke "drawFloatingNameTag", canvas

engine.setState(MatchSetupState())
engine.start()

