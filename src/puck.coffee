Puck = (I) ->
  DEBUG_DRAW = false
  DEFAULT_FRICTION = 0.05

  Object.reverseMerge I,
    blood: 0
    color: "black"
    strength: 0.5
    radius: 8
    width: 24
    height: 24
    x: ARENA_CENTER.x
    y: ARENA_CENTER.y
    friction: DEFAULT_FRICTION
    mass: 0.5
    superMassive: false
    maxSpeed: 100
    previousPositions: []

  setSprite = ->
    if I.superMassive
      I.sprite = Puck.sprites[1]
    else
      I.sprite = Puck.sprites[0]

  setSprite()

  self = Base(I).extend
    puckControl: ->
      I.velocity.length() < 40

    wipeout: $.noop

  heading = 0
  lastPosition = null

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
    I.previousPositions.unshift self.center().copy()
    I.previousPositions.length = 10

  self.bind "beforeTransform", (canvas) ->
    positions = I.previousPositions.compact()
    n = positions.length
    start = self.center()
    color = "rgba(0, 0, 255, 0.5)"
    streakWidth = 16

    positions.each (position, i) ->
      midpoint = start.add(position).scale(1/2)

      scale = (n-i)/n
      canvas.drawLine
        start: start
        end: midpoint
        width: scale * streakWidth
        color: color

      scale = (n-(i+0.5))/n
      canvas.drawLine
        start: midpoint
        end: position
        width: scale * streakWidth
        color: color

      start = position

  self.bind "positionUpdated", ->
    return unless I.active

    circle = self.circle()

    # Tunneling debug- HEIGHT/2
    if DEBUG_DRAW
      bloodCanvas.drawCircle
        circle: circle
        color: "rgba(0, 255, 0, 0.1)"

    engine.find("Goal").each (goal) ->
      if goal.withinGoal(circle)
        self.destroy()
        goal.score()

  self.bind "update", setSprite

  self.bind "wallCollision", (type) ->
    I.superMassive = false
    I.friction = DEFAULT_FRICTION

    if I.velocity.length() > 10
      if type is "goal"
        Sound.play "Puck Goalpost #{rand(2) + 1}"
      else
        Sound.play "Puck Wall #{rand(4) + 1}"

  self.bind "superCharge", ->
    I.superMassive = true
    I.friction = 0

  self.bind "struck", ->
    Sound.play "Puck Hit #{rand(4) + 1}"

  self.mass = ->
    if I.superMassive
      9000
    else
      I.mass

  self

Puck.sprites = ["norm", "charge"].map (type) ->
  Sprite.loadByName "puck_#{type}", 24, 24
