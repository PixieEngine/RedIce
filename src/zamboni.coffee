Zamboni = (I) ->
  $.reverseMerge I,
    blood: 0
    color: "yellow"
    strength: 5
    radius: 16
    width: 96
    height: 48
    speed: 10
    x: 0
    y: ARENA_HEIGHT/2 + WALL_TOP
    velocity: Point(1, 0)
    mass: 10
    zIndex: 10

  SWEEPER_SIZE = 48

  if I.reverse
    I.x = App.width

  path = []

  generatePath = () ->
    horizontalPoints = ARENA_WIDTH / SWEEPER_SIZE 
    verticalPoints = ARENA_HEIGHT / SWEEPER_SIZE 

    # Start at middle
    path.push Point(0, verticalPoints/2)

    (horizontalPoints/2 - 1).floor().times (x) ->
      x += 0.5
      y = 3/4 * x + 0.5
      xEnd = horizontalPoints - x
      yEnd = verticalPoints - y

      path.push Point(x, y)
      path.push Point(xEnd, y)
      path.push Point(xEnd, yEnd)
      path.push Point(x, yEnd)
      path.push Point(x, y + 3/4)

    # End at middle
    path.push Point(0, verticalPoints/2)
    path.push Point(-10, verticalPoints/2)

  generatePath()

  particleSizes = [16, 12, 8, 4, 4, 8]
  particleColor = "rgba(255, 255, 0, 0.5)"
  addParticleEffect = ->
    v = I.velocity.norm(5)

    engine.add
      class: "Emitter"
      duration: 9
      sprite: Sprite.EMPTY
      velocity: I.velocity
      particleCount: 6
      batchSize: 3
      x: I.x + I.width/2
      y: I.y + I.height/2
      zIndex: 1 + (I.y + I.height + 1)/CANVAS_HEIGHT
      generator:
        color: particleColor
        duration: 8
        height: (n) ->
          particleSizes.wrap(n)
        maxSpeed: 50
        velocity: (n) ->
          Point.fromAngle(Random.angle()).scale(5).add(v)
        width: (n) ->
          particleSizes.wrap(n)

  self = Base(I).extend
    controlCircle: ->
      self.circle()
    crush: (other) ->
      I.blood = (I.blood + 1).clamp(0, 6) unless other.puck()
    controlPuck: $.noop
    collidesWithWalls: ->
      false
    wipeout: ->
      #TODO Careen into boards and THEN explode
      self.destroy()

  heading = 0
  lastPosition = null
  pathIndex = 0

  cleanIce = ->
    currentPos = self.center()

    boxPoints = [
      Point(SWEEPER_SIZE/2, 0)
      Point(SWEEPER_SIZE, 0)
      Point(SWEEPER_SIZE, SWEEPER_SIZE)
      Point(SWEEPER_SIZE/2, SWEEPER_SIZE)
    ].map (p) ->
      self.getTransform().transformPoint(p)

    bloodCanvas.compositeOperation "destination-out"
    bloodCanvas.globalAlpha 0.25

    bloodCanvas.fillColor("#000")
    bloodCanvas.fillCircle(currentPos.x, currentPos.y, SWEEPER_SIZE/2, "#000")
    bloodCanvas.fillShape.apply(null, boxPoints)

    bloodCanvas.globalAlpha 1
    bloodCanvas.compositeOperation "source-over"

  pathfind = ->
    if path[pathIndex]
      nextTarget = path[pathIndex].scale(SWEEPER_SIZE).add(Point(WALL_LEFT, WALL_TOP))

      if I.reverse
        nextTarget = Matrix.scale(-1, 1, Point(WALL_LEFT + ARENA_WIDTH/2, WALL_TOP + ARENA_HEIGHT/2)).transformPoint(nextTarget)

      nextTarget.radius = 0
      center = self.center()
      center.radius = 5

      if Collision.circular(center, nextTarget)
        pathIndex += 1

      I.velocity = nextTarget.subtract(center).norm().scale(I.speed)

  self.bind "step", ->
    pathfind()

    heading = Point.direction(Point(0, 0), I.velocity)

    cleanIce() unless I.age < 1

    I.hflip = (heading > 2*Math.TAU/8 || heading < -2*Math.TAU/8)

    I.sprite = wideSprites[16 + 8*(I.blood/3).floor()]

  self.bind "destroy", ->
    Sound.play "explosion"
    addParticleEffect()

  self

