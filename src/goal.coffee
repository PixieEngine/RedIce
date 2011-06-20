Goal = (I) ->
  I ||= {}

  DEBUG_DRAW = false
  WALL_RADIUS = 2
  WIDTH = 12
  HEIGHT = 32

  $.reverseMerge I,
    color: "green"
    height: HEIGHT
    width: WIDTH
    x: WALL_LEFT + ARENA_WIDTH/20 - WIDTH
    y: WALL_TOP + ARENA_HEIGHT/2 - HEIGHT/2
    spriteOffset: Point(0, -48)

  self = GameObject(I)

  wallSegments = ->
    walls = [{
      center: Point(I.x + I.width/2, I.y)
      halfWidth: I.width/2
      halfHeight: WALL_RADIUS
    }, {
      center: Point(I.x + I.width/2, I.y + I.height)
      halfWidth: I.width/2
      halfHeight: WALL_RADIUS
    }]

    if I.right
      walls.push
        center: Point(I.x + I.width, I.y + I.height/2)
        halfWidth: WALL_RADIUS
        halfHeight: I.height/2
        killSide: -1
    else
      walls.push
        center: Point(I.x, I.y + I.height/2)
        halfWidth: WALL_RADIUS
        halfHeight: I.height/2
        killSide: 1

    return walls

  withinGoal = (circle) ->

    if circle.x + circle.radius > I.x && circle.x - circle.radius < I.x + I.width
      if circle.y + circle.radius > I.y && circle.y - circle.radius < I.y + I.height
        return true

    return false

  overlapX = (wall, circle) ->
    (circle.x - wall.center.x).abs() < wall.halfWidth + circle.radius 

  overlapY = (wall, circle) ->
    (circle.y - wall.center.y).abs() < wall.halfHeight + circle.radius

  overlap = (wall, circle) ->
    return overlapX(wall, circle) && overlapY(wall, circle)

  self.bind "draw", (canvas) ->
    if DEBUG_DRAW
      # Draw Puck Normals
      if puck = engine.find("Puck.active").first()
        velocity = puck.I.velocity

        wallSegments().each (wall) ->
          normal = puck.center().subtract(wall.center).norm()

          deltaCenter = wall.center.subtract(I)

          velocityProjection = velocity.dot(normal)

          normal = normal.scale(16)

          canvas.strokeColor("blue")
          canvas.drawLine(deltaCenter.x, deltaCenter.y, deltaCenter.x + normal.x, deltaCenter.y + normal.y)

  self.bind "step", ->
    if I.right
      I.sprite = tallSprites[7]      
    else
      I.sprite = tallSprites[6]
      I.spriteOffset = Point(-18, -48)

  return self

