teamChoices = []

do ->
  params = queryString()
  teamChoices = [params.team1, params.team2].compact()
  teamChoices = teamChoices.concat(TEAMS.without(teamChoices))

window.config =
  playerTeam: null
  defeatedTeams: []
  teams: teamChoices.wrap(0, 2)
  players: []
  particleEffects: true
  musicVolume: 0.5
  sfxVolume: 0.5

Music.volume config.musicVolume
Sound.globalVolume config.sfxVolume

# TODO move to preload just prior to usage
config.teams.each (name) ->
  teamSprites[name] = TeamSheet
    team: name

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
  includedModules: ["Gamepads", "Timing"]#, "Stats"]
  showFPS: true
  zSort: true
  FPS: 30

$(window).focus ->
  Music.play()

$(window).blur ->
  # TODO Pause game
  Music.pause()

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

# TODO: Move this into default engine behavior
engine.bind "beforeDraw", (canvas) ->
  engine.objects().invoke "trigger", "beforeDraw", canvas

engine.bind "draw", (canvas) ->
  if DEBUG_DRAW
    engine.find("Player, Puck, Goal, Bottle, Zamboni, Blood, Gib").each (object) ->
      object.trigger("drawDebug", canvas)

engine.setState(LoaderState(
  nextState: MainMenuState
))

# engine.setState Cutscene.scenes.first()

engine.start()
