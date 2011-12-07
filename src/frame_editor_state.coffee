FrameEditorState = (I={}) ->
  self = GameState(I)

  namespace = ".FRAME_EDITOR"

  characterActions = [
    "fast"
    "slow"
    "idle"
    "shoot"
    "falldown"
  ]

  p = null
  selectedComponent = null
  headPositionIndex = 0
  actionIndex = 0
  facing = "front"
  frameIndex = 0

  headDataObject = null
  componentAt = (position) ->
    headDataObject

  tools = {}

  defaultHeadData = ->
    {x: 250, y: 200, scale: 0.75}

  currentAction = ->
    characterActions.wrap(actionIndex)

  currentAnimation = ->
    tubsSprites[currentAction()]?[facing]

  currentFrameData = ->
    # TODO: Move this wrapping elsewhere
    if currentAnimation().length
      frameIndex = frameIndex.mod currentAnimation().length

    data[currentAction] ||= {}
    data[currentAction][facing] ||= []
    data[currentAction][facing][frameIndex] ||=
      head: defaultHeadData()

  loadFrameData = ->
    # Load the head data
    Object.extend headDataObject.I, currentFrameData().head

    # TODO load additional metadata

  storeFrameData = ->


  data = {}

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
    headDataObject = engine.add
      x: 250
      y: 250
      radius: 5
      color: "cyan"
      scale: 0.75

    headDataObject.bind "draw", (canvas) ->
      headSprites.stubs.wrap(headPositionIndex)?.draw(canvas, -256, -256)

    loadFrameData()

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
        frameIndex -= 1
      right: ->
        frameIndex += 1
      tab: ->
        actionIndex += 1
      enter: ->
        console.log data

    for key, fn of hotkeys
      $(document).bind "keydown#{namespace}", key, fn

  self.bind "exit", ->
    $(document).unbind(namespace)

  self.bind "beforeDraw", (canvas) ->
    currentAnimation()?.wrap(frameIndex)?.draw(canvas, 0, 0)

  self.bind "overlay", (canvas) ->
    canvas.drawText
      position: Point(80, 20)
      color: "white"
      text: facing

    canvas.drawText
      position: Point(120, 20)
      color: "white"
      text: currentAction()

    canvas.drawText
      position: Point(200, 20)
      color: "white"
      text: currentAnimation()?.wrap(frameIndex)

  # We must always return self as the last line
  return self

