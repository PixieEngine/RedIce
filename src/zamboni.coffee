Zamboni = (I) ->
  Object.reverseMerge I,
    blood: 0
    careening: false
    fuse: 30
    strength: 10
    toughness: 25
    radius: 45
    rotation: 0
    heading: 0
    speed: 10
    x: 0
    y: ARENA_CENTER.y
    velocity: Point(1, 0)
    mass: 60
    team: config.homeTeam
    cleanColor: "#000"
    cleanRate: 1 / 60
    lastCleaned: 0

  SWEEPER_SIZE = I.radius + 35
  bounds = 256

  if I.reverse
    I.x = WALL_RIGHT + bounds/2

  path = []

  if I.team is "monster"
    I.cleanColor = BLOOD_COLOR
    I.spriteOffset = Point(0, -40)

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

  self = Base(I).extend
    crush: (other) ->
    collidesWithWalls: ->
      I.careening
    wipeout: ->
      if I.careening
        self.destroy()
      else
        I.careening = true

  pathIndex = 0

  cleanIce = ->
    currentPos = self.center()

    bloodCanvas.globalCompositeOperation "destination-out" unless I.team is "monster"
    bloodCanvas.globalAlpha 0.05

    5.times ->
      offset = Point.fromAngle(Random.angle()).scale(SWEEPER_SIZE/4)

      bloodCanvas.drawCircle
        position: currentPos.add(offset)
        radius: rand(SWEEPER_SIZE/4) + SWEEPER_SIZE/4
        color: I.cleanColor

    bloodCanvas.globalAlpha 1
    bloodCanvas.globalCompositeOperation "source-over"

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

  setSprite = ->
    if (I.heading > 2*Math.TAU/8 || I.heading < -2*Math.TAU/8)
      I.scaleX = -1
    else
      I.scaleX = 1

    facing = "e"
    if Math.TAU/8 < I.heading < 3*Math.TAU/8
      facing = "s"
    else if -Math.TAU/8 > I.heading > -3*Math.TAU/8
      facing = "n"

    I.sprite = teamSprites[I.team].zamboni[facing].wrap((I.age / 0.4).floor())

  self.on "update", (dt) ->
    if I.x < -bounds || I.x > WALL_RIGHT + bounds
      I.active = false

    if I.careening
      I.rotation += Math.TAU/10
      I.fuse -= 1

      if I.fuse <= 0
        self.destroy()
    else
      pathfind()

      I.heading = Point.direction(Point(0, 0), I.velocity)

      I.lastCleaned += dt

      while I.lastCleaned >= I.cleanRate
        I.lastCleaned -= I.cleanRate
        cleanIce()

      setSprite()

  self.on "destroy", ->
    engine.add
      class: "Shockwave"
      x: I.x
      y: I.y
      velocity: I.velocity

    if I.team is "mutant"
      Gibber "mutantZamboni",
        x: I.x
        y: I.y
    else if I.team is "monster"
      Gibber "monsterZamboni",
        x: I.x
        y: I.y
    else
      Gibber "zamboni",
        x: I.x
        y: I.y

  setSprite()

  return self
