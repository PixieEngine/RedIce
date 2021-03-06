FrameEditorState = (I={}) ->
  Object.reverseMerge I,
    frameIndex: 0
    facingIndex: 0
    actionIndex: 0
    headPositionIndex: 0
    bodyIndex: 0
    headIndex: 0
    teamIndex: 0

  self = GameState(I)

  screenCenter = Point(App.width, App.height).scale(0.5)
  headPositions = 5
  namespace = ".FRAME_EDITOR"

  teamList = [
    "spike"
    "smiley"
    "hiss"
    "mutant"
  ]

  characterHeads = [
    "bigeyes"
    "jawhead"
    "longface"
    "roundhead"
    "stubs"
  ]

  characterBodies = [
    "tubs"
    "skinny"
    "thick"
  ]

  characterActions = [
    "fast"
    "slow"
    "idle"
    "shoot"
    "fall"
  ]

  characterFacings = [
    "front"
    "back"
  ]

  showHelp = false
  helpInfo =
    F1: "Toggle help info"
    "Arrow Keys": "Adjust component position"

  p = null
  selectedComponent = null
  headDataObject = null

  addEventComponent = (position) ->
    selectedComponent = engine.add
      x: position.x
      y: position.y
      radius: 5
      color: "rgba(255, 0, 255, 0.5)"
      name: "shoot"
      type: "event"

  componentAt = (position) ->
    #TODO Really check position against object list
    headDataObject

  adjustComponentPosition = (delta) ->
    selectedComponent.position(selectedComponent.position().add(delta))

  adjustComponentRotation = (delta) ->
    selectedComponent.I.rotation += delta

  adjustComponentScale = (delta) ->
    if selectedComponent.I.name == "shoot"
      selectedComponent.I.radius += delta * 100
    else
      selectedComponent.I.scale += delta

  data = {}
  tools = {}

  defaultHeadData = ->
    {x: 32, y: -64, scale: 0.75, rotation: 0}

  extractHeadData = ->
    {x, y, scale, rotation} = headDataObject.I

    # Discard rotations too close to zero
    if -0.001 < rotation < 0.001
      rotation = 0

    {x, y, scale, rotation}

  extractEventsData = ->
    engine.find(".type=event").map (eventDatum) ->
      {x, y, radius, name, type} = eventDatum.I

      {x, y, radius, name, type}

  constrainIndices = () ->
    if currentAnimation().length
      I.frameIndex = I.frameIndex.mod currentAnimation().length

    I.headPositionIndex = I.headPositionIndex.mod headPositions
    I.actionIndex = I.actionIndex.mod characterActions.length
    I.facingIndex = I.facingIndex.mod characterFacings.length

  currentTeam = ->
    teamList.wrap(I.teamIndex)

  currentBody = ->
    characterBodies.wrap(I.bodyIndex)

  currentHead = ->
    characterHeads.wrap(I.headIndex)

  currentAction = ->
    characterActions.wrap(I.actionIndex)

  currentFacing = ->
    characterFacings.wrap(I.facingIndex)

  currentAnimation = ->
    teamSprites[currentTeam()][currentBody()][currentAction()]?[currentFacing()]

  currentFrameData = (dataToSave) ->
    data[currentAction()] ||= {}
    data[currentAction()][currentFacing()] ||= []

    if dataToSave?
      data[currentAction()][currentFacing()][I.frameIndex] = dataToSave
    else
      data[currentAction()][currentFacing()][I.frameIndex] ||= {
        head: defaultHeadData()
        events: []
      }

  loadFrameData = ->
    # Load the head data
    if d = currentFrameData()
      Object.extend headDataObject.I, d.head

      # TODO load additional metadata

  storeFrameData = ->
    dataToSave =
      head: extractHeadData()
      events: extractEventsData()

    currentFrameData(dataToSave)

  saveToServer = ->
    saveFile
      contents: JSON.stringify(data, null, 2)
      path: "data/#{currentTeam()}_#{currentBody()}.json"

  loadFromServer = ->
    url = ResourceLoader.urlFor("data", "#{currentTeam()}_#{currentBody()}")

    $.getJSON url, (remoteData) ->
      console.log "received remote data"
      console.log remoteData
      data = remoteData
      loadFrameData()

  tools.move = (->
    activeComponent = null

    mousedown: ({position, button}) ->
      if button == 1
        selectedComponent = activeComponent = componentAt(position)
      else if button == 3
        addEventComponent(position)

    mousemove: ({position}) ->
      if activeComponent
        activeComponent.position(position)

    mouseup: ->
      activeComponent = null
  )()

  activeTool = tools.move

  self.on "enter", ->
    engine.cameras().first().I.scroll = Point(0, 0).subtract(screenCenter)

    selectedComponent = headDataObject = engine.add
      x: 32
      y: -64
      rotation: 0
      radius: 5
      color: "cyan"
      scale: 0.75
      type: "head"

    headDataObject.on "draw", (canvas) ->
      teamSprites[currentTeam()][currentHead()].normal.wrap(I.headPositionIndex)?.draw(canvas, -256, -256)

    p = engine.add
      id: 0
      class: "Player"
      x: -screenCenter.x + 128
      y: screenCenter.y - 128

    ["mousedown", "mousemove", "mouseup"].each (eventType) ->
      $(document).bind "#{eventType}#{namespace}", (event) ->
        position = Point(event.pageX, event.pageY).subtract(screenCenter)
        button = event.which

        activeTool[eventType]?({position, button})

    shiftFactor = 10

    hotkeys =
      return: ->
        console.log JSON.stringify(data, null, 2)
      f1: ->
        showHelp = !showHelp
      "[": ->
        adjustComponentRotation(-Math.TAU / 128)
      "]": ->
        adjustComponentRotation(Math.TAU / 128)
      "-": ->
        adjustComponentScale(-0.01)
      "+": ->
        adjustComponentScale(0.01)
      "shift+-": ->
        adjustComponentScale(-0.1)
      "shift++": ->
        adjustComponentScale(0.1)
      insert: ->
        selectedComponent = engine.add
          radius: 50
          color: "rgba(255, 0, 255, 0.5)"
          rotation: 0
          scale: 1
      "ctrl+s": ->
        Local.set("characterData", data)
      "ctrl+shift+s": ->
        saveToServer()
      "ctrl+l": ->
        data = Local.get("characterData") || {}
        loadFrameData()
      "ctrl+shift+l": ->
        loadFromServer()

    ["left", "right", "up", "down"].each (direction) ->
      point = Point[direction.toUpperCase()]
      hotkeys[direction] = ->
        adjustComponentPosition(point)
      hotkeys["shift+#{direction}"] = ->
        adjustComponentPosition(point.scale(shiftFactor))

    adjustIndexVariable = (variableName, amount) ->
      storeFrameData()

      I[variableName] += amount

      constrainIndices()
      loadFrameData()

    addCycle = (variableName, prevKey, nextKey) ->
      hotkeys[prevKey] = ->
        adjustIndexVariable(variableName, -1)

      hotkeys[nextKey] = ->
        adjustIndexVariable(variableName, 1)

      helpInfo[prevKey] = "Decrement #{variableName.underscore().humanize()}"
      helpInfo[nextKey] = "Increment #{variableName.underscore().humanize()}"

    addCycle("headPositionIndex", ";", "q")
    addCycle("frameIndex", "v", "z")
    addCycle("actionIndex", "pageup", "pagedown")
    addCycle("facingIndex", "'", ",")
    addCycle("bodyIndex", "j", "k")
    addCycle("headIndex", "r", "l")
    addCycle("teamIndex", "n", "s")

    for key, fn of hotkeys
      $(document).bind "keydown#{namespace}", key, fn

  self.on "exit", ->
    $(document).unbind(namespace)

  drawBodySprite = (canvas) ->
    canvas.withTransform Matrix.translation(screenCenter.x, screenCenter.y), (canvas) ->
      if sprite = currentAnimation()?.wrap(I.frameIndex)
        sprite.draw(canvas, -sprite.width/2, -sprite.height/2)

  self.on "beforeDraw", (canvas) ->
    drawBodySprite(canvas) if currentFacing() == "front"

  self.on "draw", (canvas) ->
    drawBodySprite(canvas) if currentFacing() == "back"

  lineHeight = 30

  drawComponentInfo = (canvas) ->
    if selectedComponent
      if selectedComponent.I.name
        # Event Metadata Component
        infoProps = ["x", "y", "radius"]
      else
        # Head Component
        infoProps = ["x", "y", "rotation", "scale"]

      for prop, i in infoProps
        value = selectedComponent.I[prop]?.toFixed?(3) || selectedComponent.I[prop]

        canvas.drawText
          position: Point(0, lineHeight * i)
          color: "white"
          text: prop

        canvas.drawText
          position: Point(60, lineHeight * i)
          color: "white"
          text: value

  self.on "overlay", (canvas) ->
    canvas.drawText
      position: Point(60, 20)
      color: "white"
      text: "#{currentTeam()} #{currentBody()}"

    canvas.drawText
      position: Point(140, 20)
      color: "white"
      text: currentFacing()

    canvas.drawText
      position: Point(180, 20)
      color: "white"
      text: currentAction()

    canvas.drawText
      position: Point(260, 20)
      color: "white"
      text: I.frameIndex

    canvas.withTransform Matrix.translation(30, 60), (canvas) ->
      drawComponentInfo(canvas)

    if showHelp
      canvas.drawRect
        x: 0
        y: 0
        width: App.width
        height: App.height
        color: "rgba(0, 0, 0, 0.75)"

      y = 80
      for key, description of helpInfo
        canvas.drawText
          position: Point(200, y)
          color: "white"
          text: key

        canvas.drawText
          position: Point(300, y)
          color: "white"
          text: description

        y += lineHeight

  # We must always return self as the last line
  return self
