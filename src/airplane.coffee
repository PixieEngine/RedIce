Airplane = (I={}) ->
  Object.reverseMerge I,
    x: App.width/2
    y: App.height/2
    start: Point(0, App.height/2)
    destination: Point(App.width, App.height/2 - 100)
    zIndex: 10

  next = ->
    if I.choose
      for team, position of Map.positions
        if I.x is position.x and I.y is position.y
          config.playerTeam = team

      engine.setState MapState()
    else
      engine.setState Cutscene.scenes[I.destinationTeam]

  self = GameObject(I)

  easingX = Easing.quadraticInOut(I.start.x, I.destination.x)
  easingY = Easing.quadraticInOut(I.start.y, I.destination.y)

  if I.start.x > I.destination.x
    I.hflip = true

  self.bind "update", ->
    I.sprite = Map.sprites.plane

    if I.choose
      I.x = I.start.x
      I.y = I.start.y

    else
      t = I.age / 90 # Take three seconds to get there

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
        camera.follow(self)

    engine.controllers().each (controller) ->
      if controller.buttonPressed "A", "START"
        next()

  self
