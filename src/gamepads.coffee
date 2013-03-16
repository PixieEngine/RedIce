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

# window.addEventListener "MozGamepadConnected", (event) ->
#   console.log event

# Hacks!

# TODO Display when keyboard input is detected and gamepads have not been detected
$ ->
  anyGamepads = true

  setTimeout ->
    return if anyGamepads
    img = $ "<img>",
      src: "images/gamepad.png"

    text = $ "<span>",
      text: "Plug in your gamepads!"
      css:
        display: "inline-block"
        verticalAlign: "top"
        fontSize: "24px"

    10.times ->
      text.fadeTo('slow', 0.25).fadeTo('fast', 1.0)

    notice = $ "<div>",
      css:
        color: "#000"
        backgroundColor: "white"
        width: "100%"
        position: "absolute"
        bottom: 0
        height: 336
        top: "auto"
    .appendTo("body")
    .append(img)
    .append(text)

    notice.delay(5000).fadeOut()
  , 1000
