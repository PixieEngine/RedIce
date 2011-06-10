Zamboni = (I) ->
  $.reverseMerge I,
    blood: 0
    color: "yellow"
    radius: 16
    width: 96
    height: 48
    x: 0
    y: ARENA_HEIGHT/2 + WALL_TOP
    velocity: Point(1, 0)
    zIndex: 10

  SWEEPER_SIZE = 48

  path = []

  generatePath = () ->
    horizontalPoints = ARENA_WIDTH / SWEEPER_SIZE 
    verticalPoints = ARENA_HEIGHT / SWEEPER_SIZE 

    # Start at middle
    path.push Point(0, verticalPoints/2)

    (horizontalPoints/2).floor().times (x) ->
      x += 0.5
      (verticalPoints/2).floor().times (y) ->
        y += 0.5
        xEnd = horizontalPoints - 1 - x
        yEnd = verticalPoints - 1 - y

        path.push Point(x, y)
        path.push Point(xEnd, y)
        path.push Point(xEnd, yEnd)
        path.push Point(x, yEnd)

    # End at middle
    path.push Point(0, verticalPoints/2)

  generatePath()

  self = Base(I).extend
    wipeout: ->
      #TODO Careen into boards and explode
      Sound.play "explosion"

  heading = 0
  lastPosition = null
  pathIndex = 0

  cleanIce = ->
    currentPos = self.center()

    boxPoints = [
      Point(0, 0)
      Point(SWEEPER_SIZE, 0)
      Point(SWEEPER_SIZE, SWEEPER_SIZE)
      Point(0, SWEEPER_SIZE)
    ].map (p) ->
      I.transform.transformPoint(p)

    bloodCanvas.compositeOperation "destination-out"
    bloodCanvas.globalAlpha 0.25

    bloodCanvas.fillColor("#000")
    bloodCanvas.fillShape.apply(null, boxPoints)

    bloodCanvas.globalAlpha 1
    bloodCanvas.compositeOperation "source-over"


  self.bind "step", ->
    nextTarget = path[pathIndex].scale(SWEEPER_SIZE).add(Point(WALL_LEFT, WALL_TOP))
    nextTarget.radius = 0

    console.log nextTarget
    debugger

    I.velocity = nextTarget.subtract(self.center()).norm().scale(2)

    I.rotation = heading = Point.direction(Point(0, 0), I.velocity)

    if Collision.circular(self.circle(), nextTarget)
      pathIndex += 1

    cleanIce() unless I.age < 1

    I.x += I.velocity.x
    I.y += I.velocity.y

    I.zIndex = 1 + (I.y + I.height)/CANVAS_HEIGHT

  self

