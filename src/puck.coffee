Puck = (I) ->
  DEBUG_DRAW = false
  DEFAULT_FRICTION = 0.05

  $.reverseMerge I,
    blood: 0
    color: "black"
    strength: 0.5
    radius: 8
    width: 16
    height: 8
    x: 512 - 8
    y: (WALL_BOTTOM + WALL_TOP)/2 - 4
    friction: DEFAULT_FRICTION
    mass: 0.01
    superMassive: false
    zIndex: 10
    spriteOffset: Point(-10, -32)

  self = Base(I).extend
    bloody: ->
      I.blood = (I.blood + 30).clamp(0, 120)

    wipeout: $.noop

  heading = 0
  lastPosition = null

  particleSizes = [3, 4, 3]
  addParticleEffect = (push, color="#EE0") ->
    push = push.norm(4)

    engine.add
      class: "Emitter"
      duration: 9
      sprite: Sprite.EMPTY
      velocity: I.velocity
      particleCount: 3
      batchSize: 3
      x: I.x + I.width/2
      y: I.y + I.height/2
      zIndex: 1 + (I.y + I.height + 1)/CANVAS_HEIGHT
      generator:
        color: color
        duration: 8
        height: (n) ->
          particleSizes.wrap(n)
        maxSpeed: 50
        velocity: (n) ->
          Point.fromAngle(Random.angle()).scale(rand(5) + 1).add(push)
        width: (n) ->
          particleSizes.wrap(n)

  drawBloodStreaks = ->
    heading = Point.direction(Point(0, 0), I.velocity)

    currentPos = self.center()

    if lastPosition && (blood = I.blood)
      I.blood -= 1

      bloodCanvas.drawLine
        color: BLOOD_COLOR
        start: lastPosition
        end: currentPos, 
        width: (blood/20).clamp(1, 6)

    lastPosition = currentPos

  self.bind "drawDebug", (canvas) ->
    center = self.center()
    x = center.x
    y = center.y

    # Draw velocity vector
    scaledVelocity = I.velocity.scale(10)

    canvas.drawLine
      color: "orange"
      start: Point(x, y)
      end: Point(x + scaledVelocity.x, y + scaledVelocity.y)

  self.bind "step", ->
    drawBloodStreaks()

    if I.superMassive
      addParticleEffect(I.velocity.scale(-1))

  self.bind "positionUpdated", ->
    return unless I.active

    circle = self.circle()

    # Tunneling debug
    if DEBUG_DRAW
      bloodCanvas.drawCircle
        circle: circle
        color: "rgba(0, 255, 0, 0.1)"

    engine.find("Goal").each (goal) ->
      if goal.withinGoal(circle)
        self.destroy()
        goal.score()

        engine.delay 30, ->
          engine.add
            class: "Puck"

  self.bind "update", ->
    I.sprite = sprites[39]

  self.bind "wallCollision", ->
    I.superMassive = false
    I.friction = DEFAULT_FRICTION

  self.bind "superCharge", ->
    I.superMassive = true
    I.friction = 0
    Sound.play "super_power"

  self.mass = ->
    if I.superMassive
      9000
    else
      I.mass

  self

