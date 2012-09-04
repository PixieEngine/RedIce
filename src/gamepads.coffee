Gamepads = (I={}) ->
  state = {} # holds current and previous states
  controllers = [] # controller cache

  # Capture the current gamepad state
  snapshot = ->
    Array::map.call navigator.webkitGamepads || navigator.webkitGetGamepads(), (x) -> 
      axes: x.axes
      buttons: x.buttons

  controller: (index=0) ->
    controllers[index] ||= Gamepads.Controller
      index: index
      state: state

  update: ->
    state.previous = state.current
    state.current = snapshot()

    controllers.each (controller) ->
      controller?.update()
