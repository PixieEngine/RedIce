Joysticks = ( ->
  type = "application/x-boomstickjavascriptjoysticksupport"
  plugin = null
  AXIS_MAX = 32767
  DEAD_ZONE = 256

  joysticks = []

  buttonMapping =
    "A": 0
    "B": 1
    # X/C, Y/D are interchangeable
    "C": 2
    "D": 3
    "X": 2
    "Y": 3

  getController: (i) ->
    actionDown: (buttons...) ->
      if stick = joysticks[i]    
        buttons.inject false, (down, button) ->
          down || stick.buttons[buttonMapping[button]]
      else
        false

    position: ->
      if stick = joysticks[i]
        Joysticks.position(stick)
      else
        Point(0, 0)

  init: ->
    unless plugin
      plugin = document.createElement("object")
      plugin.type = type
      plugin.width = 0
      plugin.height = 0

      $("body").append(plugin)

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
    joysticks = plugin.joysticks
)()

