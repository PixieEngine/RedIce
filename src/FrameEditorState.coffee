FrameEditorState = (I={}) ->
  self = GameState(I)

  namespace = ".FRAME_EDITOR"

  p = null

  selectedComponent = null

  testObject = null

  componentAt = (position) ->
    testObject

  tools = {}

  tools.move = (->
    activeComponent = null

    mousedown: ({position, button}) ->
      selectedComponent = activeComponent = componentAt(position)

    mousemove: ({position}) ->
      if activeComponent
        activeComponent.position(position)

    mouseup: ->
      activeComponent = null
  )()

  activeTool = tools.move

  self.bind "enter", ->
    testObject = engine.add
      x: 250
      y: 250
      radius: 5
      color: "magenta"

    p = engine.add
      id: 0
      class: "Player"
      joystick: true

    ["mousedown", "mousemove", "mouseup"].each (eventType) ->
      $(document).bind "#{eventType}#{namespace}", (event) ->
        position = Point(event.pageX, event.pageY)
        button = event.which

        activeTool[eventType]?({position, button})

  self.bind "exit", ->
    $(document).unbind(namespace)

  # Add events and methods here
  self.bind "update", ->
    ; # Add update method behavior

  # We must always return self as the last line
  return self

