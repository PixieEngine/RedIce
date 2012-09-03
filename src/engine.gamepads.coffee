###*
The <code>Gamepads</code> module gives the engine access to gamepads.

    # First you need to add the `Gamepads` module to the engine
    Engine.defaultModules.push "Gamepads"
    
    window.engine = Engine
      ...
    
    # Then you need to get a controller reference
    # id = 0 for player 1, etc.
    controller = engine.controller(id)
    
    # Point indicating direction primary axis is held
    direction = controller.position()
    
    # Check if buttons are held
    controller.actionDown("A")
    controller.actionDown("B")
    controller.actionDown("X")
    controller.actionDown("Y")

@name Gamepads
@fieldOf Engine
@module

@param {Object} I Instance variables
@param {Object} self Reference to the engine
###
Engine.Gamepads = (I, self) ->
  gamepads = Gamepads()
  
  self.bind "beforeUpdate", ->
    # Update the gamepads
    gamepads.update()

  ###*
  Get a controller for a given id.

  @name controller
  @methodOf Engine.Gamepads#

  @param {Number} index The index to get a controller for.
  ###
  controller: (index) ->
    gamepads.controller(index)
