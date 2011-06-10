Zamboni = (I) ->
  $.reverseMerge I,
    blood: 0
    color: "yellow"
    radius: 16
    width: 64
    height: 32
    x: 0
    y: ARENA_HEIGHT/2 + ARENA_TOP
    velocity: Point(1, 0)
    zIndex: 10

  SWEEPER_SIZE

  path = []

  generatePath = () ->
    ARENA_WIDTH / SWEEPER_SIZE = horizontalPoints
    ARENA_HEIGHT / SWEEPER_SIZE = verticalPoints

    # Start at middle
    path.push Point(0, verticalPoints/2)

    (horizontalPoints/2).floor().times (x) ->
      (verticalPoints/2).floor().times (y) ->
        xEnd = horizontalPoints -1 - x
        yEnd = verticalPoints - 1 - y

        path.push Point(x, y)
        path.push Point(xEnd, y)
        path.push Point(xEnd, yEnd)
        path.push Point(x, yEnd)

    # End at middle
    path.push Point(0, verticalPoints/2)

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
      Point(32, 0)
      Point(32, 32)
      Point(0, 32)
    ].map (p) ->
      I.transform.transformPoint(p)

    bloodCanvas.compositeOperation "destination-out"
    bloodCanvas.globalAlpha 0.25

    bloodCanvas.fillColor("#000")
    bloodCanvas.fillShape.apply(null, boxPoints)

    bloodCanvas.globalAlpha 1
    bloodCanvas.compositeOperation "source-over"


  self.bind "step", ->
    I.rotation = heading = Point.direction(Point(0, 0), I.velocity)

    cleanIce() unless I.age < 1

    I.x += I.velocity.x
    I.y += I.velocity.y

    I.zIndex = 1 + (I.y + I.height)/CANVAS_HEIGHT

  self
