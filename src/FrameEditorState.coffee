FrameEditorState = (I={}) ->
  self = GameState(I)

  namespace = ".FRAME_EDITOR"

  p = null
  selectedComponent = null
  testObject = null
  headPositionIndex = 0
  action = "fast"
  facing = "front"
  frameIndex = 0

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
      color: "cyan"

    testObject.bind "draw", (canvas) ->
      headScale = 0.75

      canvas.withTransform Matrix.scale(0.75), (canvas) ->
        headSprites.stubs.wrap(headPositionIndex)?.draw(canvas, -256, -256)

    p = engine.add
      id: 0
      class: "Player"
      joystick: true
      x: 800
      y: 600

    ["mousedown", "mousemove", "mouseup"].each (eventType) ->
      $(document).bind "#{eventType}#{namespace}", (event) ->
        position = Point(event.pageX, event.pageY)
        button = event.which

        activeTool[eventType]?({position, button})

    hotkeys =
      up: ->
        headPositionIndex += 1
      down: ->
        headPositionIndex -= 1
      left: ->
        frameIndex += 1
      right: ->
        frameIndex -= 1

    for key, fn of hotkeys
      $(document).bind "keydown#{namespace}", key, fn

  self.bind "exit", ->
    $(document).unbind(namespace)

  self.bind "beforeDraw", (canvas) ->
    tubsSprites[action]?[facing]?.wrap(frameIndex)?.draw(canvas, 0, 0)

  # We must always return self as the last line
  return self
