Joysticks = ( ->
  type = "application/x-boomstickjavascriptjoysticksupport"
  plugin = null

  init: ->
    unless plugin
      plugin = document.createElement("object")
      plugin.type = type
      plugin.width = 0
      plugin.height = 0

      $("body").append(plugin)

  states: ->
    plugin?.joysticks

  status: ->
    plugin?.status

  position: (stick) ->
    Point(stick.axes[0], stick.axes[1])

)()

