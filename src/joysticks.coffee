Joysticks = ( ->
  type = "application/x-boomstickjavascriptjoysticksupport"
  plugin = null
  AXIS_MAX = 32767
  DEAD_ZONE = 256

  states = []

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
    states = plugin.states
)()

