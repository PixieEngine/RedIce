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
    if puck = engine.find("Puck.active").first()
      circle = puck.circle()
      velocity = puck.I.velocity
      netReflection = velocity

      # Goal wall puck collisions
      collided = false
      wallSegments().each (wall) ->
        if overlap(wall, circle)
          puckPrev = puck.center().subtract(velocity)
          puckToWall = puckPrev.subtract(wall.center)

          if puckToWall.x.sign() == wall.killSide
            debugger
            normal = Point(wall.killSide, 0)
            velocityProjection = velocity.dot(normal)
            netReflection = netReflection.subtract(normal.scale(1 * velocityProjection))

            collided = true


          else
            normal = puckToWall.norm()

            velocityProjection = velocity.dot(normal)

            # Heading towards wall
            if velocityProjection < 0
              # Reflection Vector
              netReflection = netReflection.subtract(normal.scale(2 * velocityProjection))

              collided = true

      if collided
        puck.I.velocity = netReflection
        puck.I.x += puck.I.velocity.x
        puck.I.y += puck.I.velocity.y

        # Refresh puck circle
        circle = puck.circle()

        Sound.play "clink0"

      if withinGoal(circle)
        puck.destroy()

        Sound.play("crowd#{rand(3)}")

        engine.add
          class: "Puck"

        self.trigger "score"

  return self

