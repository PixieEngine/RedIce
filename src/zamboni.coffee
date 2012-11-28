Zamboni = (I) ->
  $.reverseMerge I,
    blood: 0
    careening: false
    color: "yellow"
    fuse: 30
    fortitude: 2
    strength: 4
    radius: 50
    rotation: 0
    heading: 0
    speed: 8
    x: 0
    y: ARENA_HEIGHT/2 + WALL_TOP
    velocity: Point(1, 0)
    mass: 10
    team: config.teams.rand()
    zIndex: 10
    cleanColor: "#000"

  SWEEPER_SIZE = 48
  bounds = 256

  if I.reverse
    I.x = App.width

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
    controlCircle: ->
      self.circle()
    crush: (other) ->
      I.blood = (I.blood + 1).clamp(0, 6) unless other.puck()
    controlPuck: $.noop
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

    boxPoints = [
      Point(SWEEPER_SIZE/2, 0)
      Point(SWEEPER_SIZE, 0)
      Point(SWEEPER_SIZE, SWEEPER_SIZE)
      Point(SWEEPER_SIZE/2, SWEEPER_SIZE)
    ].map (p) ->
      self.transform().transformPoint(p)

    bloodCanvas.globalCompositeOperation "destination-out" unless I.team is "monster"
    bloodCanvas.globalAlpha 0.25

    bloodCanvas.drawCircle
      position: currentPos
      radius: SWEEPER_SIZE/2
      color: I.cleanColor
    bloodCanvas.drawPoly
      points: boxPoints
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
    I.hflip = (I.heading > 2*Math.TAU/8 || I.heading < -2*Math.TAU/8)

    facing = "e"
    if Math.TAU/8 < I.heading < 3*Math.TAU/8
      facing = "s"
    else if -Math.TAU/8 > I.heading > -3*Math.TAU/8
      facing = "n"

    I.sprite = teamSprites[I.team].zamboni[facing][(I.age/4).floor().mod(2)]

  self.bind "step", ->
    if I.x < -bounds || I.x > App.width + bounds
      I.active = false

    if I.careening
      I.rotation += Math.TAU/10
      I.fuse -= 1

      if I.fuse <= 0
        self.destroy()
    else
      pathfind()

      I.heading = Point.direction(Point(0, 0), I.velocity)

      cleanIce() unless I.age < 1

      setSprite()

  self.bind "destroy", ->
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
