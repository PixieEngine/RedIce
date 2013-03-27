

do ->
  params = queryString()
  queryStringTeams = [params.team1, params.team2].compact()
  window.teamChoices = queryStringTeams.concat(TEAMS.without(queryStringTeams))

  # TODO Limit to two teams for demo mode

  # TODO move preloading to just prior to usage
  teamChoices.each (name) ->
    teamSprites[name] = TeamSheet
      team: name

# TODO Persistent and adjustable config
window.config =
  playerTeam: null
  defeatedTeams: []
  players: []
  particleEffects: true
  musicVolume: 0.5
  sfxVolume: 0.5
  FPS: 60

Music.volume config.musicVolume
Sound.globalVolume config.sfxVolume

window.bloodCanvas = $("<canvas width=#{2 * App.width} height=#{App.height} />").pixieCanvas()

canvas = $("canvas").pixieCanvas()
# canvas.context().webkitImageSmoothingEnabled = false

["Gamepads", "Timing"].each (module) ->
  Engine.defaultModules.push module

window.engine = Engine
  canvas: canvas
  showFPS: true
  zSort: true
  FPS: config.FPS

$(window).focus ->
  Music.play()
  engine.pause(false)
  # TODO Hide Paused overlay

$(window).blur ->
  Music.pause()
  engine.pause(true)
  # TODO Show Paused overlay

$(document).bind "keydown", "f2", ->
  engine.setState(MapState())

$(document).bind "keydown", "f3", ->
  engine.setState(MatchSetupState())

DEBUG_DRAW = false
$(document).bind "keydown", "0", ->
  DEBUG_DRAW = !DEBUG_DRAW

reverse = false
$(document).bind "keydown", "1", ->
  engine.add
    class: "Zamboni"
    reverse: reverse

  reverse = !reverse

# Special rink before draw
engine.on "beforeDraw", (canvas) ->
  engine.find("Rink").invoke "trigger", "beforeDraw", canvas

engine.on "draw", (canvas) ->
  if DEBUG_DRAW
    canvas.withTransform engine.camera().transform().translate(App.width/2, App.height/2), ->
      engine.find("Player, Puck, Goal, Bottle, Zamboni, Blood, Gib").each (object) ->
        object.trigger("drawDebug", canvas)

    if gamepad = engine.controllers()[2]
      gamepad.drawDebug(canvas)

engine.setState(LoaderState(
  nextState: MainMenuState
))

$ ->
  # engine.setState Cutscene.gameOver.robo

  engine.start()
