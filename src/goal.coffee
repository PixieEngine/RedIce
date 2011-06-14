Goal = (I) ->
  I ||= {}

  $.reverseMerge I,
    color: "green"
    height: 32
    width: 12
    x: WALL_LEFT + ARENA_WIDTH/20 - 12
    y: WALL_TOP + ARENA_HEIGHT/2 - 16

  self = GameObject(I)

  wallSegments = ->
    walls = [{
      center: Point(I.x + I.width/2, I.y)
      halfWidth: I.width/2
      halfHeight: 2
    }, {
      center: Point(I.x + I.width/2, I.y + I.height)
      halfWidth: I.width/2
      halfHeight: 2
    }]

    if I.right
      walls.push
        center: Point(I.x + I.width, I.y + I.height/2)
        halfWidth: 2
        halfHeight: I.height/2
    else
      walls.push
        center: Point(I.x, I.y + I.height/2)
        halfWidth: 2
        halfHeight: I.height/2

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
          normal = puck.center().subtract(velocity).subtract(wall.center).norm()

          velocityProjection = velocity.dot(normal)

          debugger

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

      if withinGoal(circle)
        puck.destroy()

        Sound.play("crowd#{rand(3)}")

        engine.add
          class: "Puck"

        self.trigger "score"

  return self

