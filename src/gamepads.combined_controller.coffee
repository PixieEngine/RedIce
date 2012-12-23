Gamepads.CombinedController = (sources...) ->

  self = Core().extend
    actionDown: (buttons...) ->
      sources.inject false, (memo, source) ->
        memo or source.actionDown buttons...

    # true if button was just pressed
    buttonPressed: (button) ->
      sources.inject false, (memo, source) ->
        memo or source.buttonPressed(button)

    position: (stick=0) ->
      raw = sources.inject Point(0, 0), (point, source) ->
        point.add(source.position(stick))

      raw.norm()

    tap: ->
      raw = sources.inject Point(0, 0), (point, source) ->
        point.add(source.tap())

      Point(raw.x.sign(), raw.y.sign())

    update: ->
      sources.invoke "update"

    drawDebug: (canvas) ->
      sources.invoke "drawDebug", canvas
