Gamepads = (I={}) ->
  state = {} # holds current and previous states
  controllers = [] # controller cache

  # Capture the current gamepad state
  snapshot = ->
    Array::map.call navigator.webkitGamepads || navigator.webkitGetGamepads?() || [], (x) ->
      axes: x.axes
      buttons: x.buttons

  controller: (index=0) ->
    if controller = controllers[index]
      return controller

    gamepadIndex = (index + 2) % 4 # Offsetting gamepads

    gamepad =
      Gamepads.Controller
        index: gamepadIndex
        state: state

    if index < 1 # TODO Second keyboard controls
      keyboardController = Gamepads.KeyboardController()

      controllers[index] ||= Gamepads.CombinedController(gamepad, keyboardController)
    else
      controllers[index] ||= gamepad

  update: ->
    state.previous = state.current
    state.current = snapshot()

    controllers.each (controller) ->
      controller?.update()

window.addEventListener "MozGamepadConnected", (event) ->
  console.log event
