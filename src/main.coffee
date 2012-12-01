window.config =
  teams: ["robo", "spike"]
  players: []
  particleEffects: true
  music: false
  joysticks: true

window.teamSprites = {}
config.teams.each (name) ->
  teamSprites[name] = TeamSheet
    team: name

#TODO Manage these extra canvases better
window.rink = Rink
  team: config.teams.first()
window.bloodCanvas = $("<canvas width=#{App.width} height=#{App.height} />")
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

engine.setState(LoaderState(
  nextState: Minigames.Paint
))
engine.start()
