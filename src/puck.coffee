Puck = (I) ->
  DEBUG_DRAW = false

  $.reverseMerge I,
    blood: 0
    color: "black"
    strength: 0.5
    radius: 8
    width: 16
    height: 8
    x: 512 - 8
    y: (WALL_BOTTOM + WALL_TOP)/2 - 4
    friction: 0.05
    mass: 0.01
    superMassive: true
    zIndex: 10
    spriteOffset: Point(-10, -32)

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

      color = Color(BLOOD_COLOR)
      bloodCanvas.strokeColor(color)
      bloodCanvas.drawLine(lastPosition, currentPos, (blood/20).clamp(1, 6))

    lastPosition = currentPos

  self.bind "drawDebug", (canvas) ->
    center = self.center()
    x = center.x
    y = center.y

    # Draw velocity vector
    scaledVelocity = I.velocity.scale(10)

    canvas.strokeColor("orange")
    canvas.drawLine(x, y, x + scaledVelocity.x, y + scaledVelocity.y)

  self.bind "step", ->
    drawBloodStreaks()

  self.bind "positionUpdated", ->
    return unless I.active

    circle = self.circle()

    # Tunneling debug
    if DEBUG_DRAW
      bloodCanvas.fillCircle(circle.x, circle.y, circle.radius, "rgba(0, 255, 0, 0.1)")

    engine.find("Goal").each (goal) ->
      if goal.withinGoal(circle)
        self.destroy()
        goal.score()

        engine.add
          class: "Puck"

  self.bind "update", ->
    I.sprite = sprites[39]

  self.mass = ->
    if I.superMassive
      9000
    else
      I.mass

  self

