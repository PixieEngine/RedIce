Airplane = (I={}) ->
  Object.reverseMerge I,
    x: App.width/2
    y: App.height/2
    start: Point(0, App.height/2)
    destination: Point(App.width, App.height/2 - 100)
    zIndex: 10

  # For Choosing only
  positions = Object.keys Map.positions
  positions.pop() # No Robo
  startIndex = 0

  next = ->
    if I.choose
      for team, position of Map.positions
        if I.destination.x is position.x and I.destination.y is position.y
          config.playerTeam = team

      engine.setState Cutscene.scenes[config.playerTeam]
    else
      engine.setState Cutscene.scenes[I.destinationTeam]

  self = GameObject(I)

  self.bind "update", ->
    I.sprite = Map.sprites.plane

    index = 0
    engine.controllers().each (controller) ->
      tap = controller.tap()
      index -= tap.x - 2 * tap.y

      if controller.buttonPressed "A", "START"
        next()

    if I.choose
      if index != 0
        startIndex += index
        I.start = {x: I.x, y: I.y}
        I.destination = Map.positions[positions.wrap(startIndex)]
        I.age = 0

    I.hflip = I.start.x > I.destination.x

    easingX = Easing.quadraticInOut(I.start.x, I.destination.x)
    easingY = Easing.quadraticInOut(I.start.y, I.destination.y)

    if I.choose
      duration = 15
    else
      duration = 30

    t = I.age / duration # Take three seconds to get there

    if t < 0
      I.x = I.start.x
      I.y = I.start.y
    else if t > 1
      I.x = I.destination.x
      I.y = I.destination.y
    else
      I.x = easingX(t)
      I.y = easingY(t)

    if I.moon
      camera = engine.camera()
      camera.I.cameraBounds.y = -App.height
      camera.I.cameraBounds.height = App.height*2
      camera.follow(self)

  self
