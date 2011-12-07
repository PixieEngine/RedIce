FrameEditorState = (I={}) ->
  Object.reverseMerge I,
    frameIndex: 0
    facingIndex: 0
    actionIndex: 0
    headPositionIndex: 0
    bodyIndex: 0
    teamIndex: 0

  self = GameState(I)

  headPositions = 5
  namespace = ".FRAME_EDITOR"

  teamList = [
    "spike"
  ]

  characterBodies = [
    "tubs"
    "skinny"
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

  p = null
  selectedComponent = null

  headDataObject = null

  componentAt = (position) ->
    #TODO Really check position against object list
    headDataObject

  tools = {}

  defaultHeadData = ->
    {x: 250, y: 200, scale: 0.75}

  extractHeadData = ->
    {x, y, scale} = headDataObject.I

    {x, y, scale}

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

  currentAction = ->
    characterActions.wrap(I.actionIndex)

  currentFacing = ->
    characterFacings.wrap(I.facingIndex)

  currentAnimation = ->
    bodySprites[currentBody()][currentAction()]?[currentFacing()]

  currentFrameData = (dataToSave) ->
    data[currentAction()] ||= {}
    data[currentAction()][currentFacing()] ||= []

    if dataToSave?
      data[currentAction()][currentFacing()][I.frameIndex] = dataToSave
    else    
      data[currentAction()][currentFacing()][I.frameIndex] ||=
        head: defaultHeadData()

  loadFrameData = ->
    # Load the head data
    if d = currentFrameData()
      Object.extend headDataObject.I, d.head

      # TODO load additional metadata

  storeFrameData = ->
    dataToSave = 
      head: extractHeadData()

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
      headSprites.stubs.wrap(I.headPositionIndex)?.draw(canvas, -256, -256)

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
      return: ->
        console.log JSON.stringify(data, null, 2)
      f1: ->
        showHelp = !showHelp
      "ctrl+s": ->
        Local.set("characterData", data)
      "ctrl+shift+s": ->
        saveToServer()
      "ctrl+l": ->
        data = Local.get("characterData") || {}
        loadFrameData()
      "ctrl+shift+l": ->
        loadFromServer()

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
    addCycle("frameIndex", "a", "o")
    addCycle("actionIndex", "shift+tab", "tab")
    addCycle("facingIndex", "'", ",")
    addCycle("bodyIndex", "j", "k")

    for key, fn of hotkeys
      $(document).bind "keydown#{namespace}", key, fn

  self.bind "exit", ->
    $(document).unbind(namespace)

  self.bind "beforeDraw", (canvas) ->
    if currentFacing() == "front"
      currentAnimation()?.wrap(I.frameIndex)?.draw(canvas, 0, 0)

  self.bind "draw", (canvas) ->
    if currentFacing() == "back"
      currentAnimation()?.wrap(I.frameIndex)?.draw(canvas, 0, 0)

  self.bind "overlay", (canvas) ->
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

    if showHelp
      canvas.drawRect
        x: 0
        y: 0
        width: App.width
        height: App.height
        color: "rgba(0, 0, 0, 0.75)"

      y = 80
      lineHeight = 30
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

