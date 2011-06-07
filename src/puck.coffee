Puck = (I) ->
  $.reverseMerge I,
    blood: 0
    color: "black"
    radius: 4
    width: 16
    height: 8
    x: 512
    y: 384
    velocity: Point()
    zIndex: 10

  self = GameObject(I).extend
    bloody: ->
      I.blood = (I.blood + rand(10)).clamp(0, 40)

    circle: ->
      c = self.center()
      c.radius = I.radius

      return c

    puck: ->
      true

    wipeout: $.noop

  heading = 0
  lastPosition = null

  drawBloodStreaks = ->
    # Skate blood streaks
    heading = Point.direction(Point(0, 0), I.velocity)

    currentPos = self.center()

    if lastPosition && (blood = I.blood)
      I.blood -= 1

      bloodCanvas.drawLine(lastPosition, currentPos, (blood/4).clamp(2, 7))

    lastPosition = currentPos

  self.bind "step", ->
    drawBloodStreaks()

    I.velocity = I.velocity.scale(0.95)

    I.x += I.velocity.x
    I.y += I.velocity.y

  self

