window.config =
  teams: ["smiley", "spike"]
  players: []
  particleEffects: true
  music: false
  joysticks: true

window.teamSprites = {}
config.teams.each (name) ->
  teamSprites[name] = TeamSheet
    team: name

window.CANVAS_WIDTH = App.width
window.CANVAS_HEIGHT = App.height

window.WALL_LEFT = 0
window.WALL_RIGHT = CANVAS_WIDTH - WALL_LEFT
window.WALL_TOP = 192
window.WALL_BOTTOM = CANVAS_HEIGHT - (WALL_TOP - 128)

window.ARENA_WIDTH = WALL_RIGHT - WALL_LEFT
window.ARENA_HEIGHT = WALL_BOTTOM - WALL_TOP

window.BLOOD_COLOR = "#BA1A19"
window.ICE_COLOR = "rgba(192, 255, 255, 0.2)"

#TODO Manage these extra canvases better
window.rink = Rink
  team: config.teams.first()
window.bloodCanvas = $("<canvas width=#{CANVAS_WIDTH} height=#{CANVAS_HEIGHT} />")
  .appendTo("body")
  .css
    position: "absolute"
    top: 0
    left: 0
    zIndex: "-5"
  .pixieCanvas()

# Sound.globalVolume(0)

bloodCanvas.strokeColor(BLOOD_COLOR)
# bloodCanvas.fill(BLOOD_COLOR) # For zamboni testing

window.MAX_PLAYERS = 6
window.activePlayers = 0

canvas = $("canvas").pixieCanvas()
# canvas.context().webkitImageSmoothingEnabled = false

window.engine = Engine
  canvas: canvas
  includedModules: ["Gamepads"]#, "Stats"]
  showFPS: true
  zSort: true
  FPS: 30

$(document).bind "keydown", "f2", ->
  engine.setState(FrameEditorState())

$(document).bind "keydown", "f3", ->
  engine.setState(MatchSetupState())

DEBUG_DRAW = false
$(document).bind "keydown", "0", ->
  DEBUG_DRAW = !DEBUG_DRAW

$(document).bind "keydown", "1", ->
  engine.add
    class: "Zamboni"

engine.bind "draw", (canvas) ->
  if DEBUG_DRAW
    engine.find("Player, Puck, Goal, Bottle, Zamboni, Blood, Gib").each (object) ->
      object.trigger("drawDebug", canvas)

# Timing Draw and update
drawStartTime = null
updateDuration = null
engine.bind "beforeDraw", ->
  drawStartTime = +new Date
engine.bind "overlay", (canvas) ->
  drawDuration = (+new Date) - drawStartTime
  if DEBUG_DRAW
    canvas.drawText
      color: "white"
      text: "ms/draw: #{drawDuration}"
      x: 10
      y: 30
    canvas.drawText
      color: "white"
      text: "ms/update: #{updateDuration}"
      x: 10
      y: 50
updateStartTime = null
engine.bind "beforeUpdate", ->
  updateStartTime = +new Date
engine.bind "afterUpdate", (canvas) ->
  updateDuration = (+new Date) - updateStartTime

engine.setState(LoaderState())
engine.start()
