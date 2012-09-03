Gamepads = (I={}) ->
  state = {} # holds current and previous states
  controllers = [] # controller cache

  controller: (index=0) ->
    controllers[index] ||= Gamepads.Controller
      index: index
      state: state

  update: ->
    state.previous = state.current
    state.current = navigator.webkitGamepads
    
    controllers.each (controller) ->
      controller?.update()
