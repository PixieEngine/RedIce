Joysticks = ( ->
  type = "application/x-boomstickjavascriptjoysticksupport"
  plugin = null
  AXIS_MAX = 32767
  DEAD_ZONE = AXIS_MAX * 0.125

  joysticks = []

  buttonMapping =
    "A": 1
    "B": 2

    # X/C, Y/D are interchangeable
    "C": 4
    "D": 8
    "X": 4
    "Y": 8

    "R": 32
    "RB": 32
    "R1": 32

    "L": 16
    "LB": 16
    "L1": 16

  getController: (i) ->
    actionDown: (buttons...) ->
      if stick = joysticks?[i]
        buttons.inject false, (down, button) ->
          down || stick.buttons & buttonMapping[button]
      else
        false

    position: ->
      if stick = joysticks?[i]
        Joysticks.position(stick)
      else
        Point(0, 0)

    axis: (n) ->
      if stick = joysticks?[i]
        stick.axes[n]

  init: ->
    unless plugin
      plugin = document.createElement("object")
      plugin.type = type
      plugin.width = 0
      plugin.height = 0

      $("body").append(plugin)

      plugin.maxAxes = 6

  position: (stick) ->
    p = Point(stick.axes[0], stick.axes[1])

    magnitude = p.magnitude()

    if magnitude > AXIS_MAX
      p.norm()
    else if magnitude < DEAD_ZONE
      Point(0, 0)
    else
      ratio = magnitude / AXIS_MAX

      p.scale(ratio / AXIS_MAX)

  states: ->
    plugin?.joysticks

  status: ->
    plugin?.status

  update: ->
    joysticks = JSON.parse(plugin.joysticksJSON())
)()

