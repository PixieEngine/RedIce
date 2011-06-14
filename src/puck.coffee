Puck = (I) ->
  DEBUG_DRAW = false

  $.reverseMerge I,
    blood: 0
    color: "black"
    radius: 4
    width: 16
    height: 8
    x: 512 - 8
    y: 384 - 4
    friction: 0.05
    zIndex: 10

  self = Base(I).extend
    bloody: ->
      I.blood = (I.blood + 30).clamp(0, 120)

    wipeout: $.noop

  heading = 0
  lastPosition = null

  drawBloodStreaks = ->
    # Skate blood streaks
    heading = Point.direction(Point(0, 0), I.velocity)

    currentPos = self.center()

    if lastPosition && (blood = I.blood)
      I.blood -= 1

      bloodCanvas.drawLine(lastPosition, currentPos, (blood/20).clamp(1, 6))

    lastPosition = currentPos

  self.bind "draw", (canvas) ->
    if DEBUG_DRAW
      # Draw velocity vector
      x = I.width/2
      y = I.height/2

      scaledVelocity = I.velocity.scale(10)

      canvas.strokeColor("orange")
      canvas.drawLine(x, y, x + scaledVelocity.x, y + scaledVelocity.y)

  self.bind "step", ->
    drawBloodStreaks()

  self

