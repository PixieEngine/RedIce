Zamboni = (I) ->
  $.reverseMerge I,
    blood: 0
    color: "yellow"
    radius: 16
    width: 64
    height: 32
    x: 512
    y: 384
    velocity: Point(1, 0)
    zIndex: 10

  self = GameObject(I).extend
    bloody: $.noop

    circle: ->
      c = self.center()
      c.radius = I.radius

      return c

    puck: ->
      false

    wipeout: $.noop

  heading = 0
  lastPosition = null

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
    bloodCanvas.globalAlpha 0.5

    bloodCanvas.fillColor("#000")
    bloodCanvas.fillShape.apply(null, boxPoints)

    bloodCanvas.globalAlpha 1
    bloodCanvas.compositeOperation "source-over"


  self.bind "step", ->
    I.rotation = heading = Point.direction(Point(0, 0), I.velocity)

    cleanIce() unless I.age < 1

    I.x += I.velocity.x
    I.y += I.velocity.y

  self
