Physics = (->
  overlapX = (wall, circle) ->
    (circle.x - wall.center.x).abs() < wall.halfWidth + circle.radius 

  overlapY = (wall, circle) ->
    (circle.y - wall.center.y).abs() < wall.halfHeight + circle.radius

  rectangularOverlap = (wall, circle) ->
    return overlapX(wall, circle) && overlapY(wall, circle)

  threshold = 5

  resolveCollision = (A, B) ->
    normal = B.center().subtract(A.center()).norm()

    # Checking
    powA = A.collisionPower(normal)
    powB = -B.collisionPower(normal)

    max = Math.max(powA, powB)

    if max > threshold
      if powA == max
        A.crush(B)
        B.wipeout(normal)
      else
        B.crush(A)
        A.wipeout(normal.scale(-1))

    # Elastic collisions
    relativeVelocity = A.I.velocity.subtract(B.I.velocity)

    massA = A.mass()
    massB = B.mass()

    totalMass = massA + massB

    pushA = normal.scale(-2 * (relativeVelocity.dot(normal) * (massB / totalMass) + 1))
    pushB = normal.scale(+2 * (relativeVelocity.dot(normal) * (massA / totalMass) + 1))

    # Adding impulse
    A.I.velocity = A.I.velocity.add(pushA)
    B.I.velocity = B.I.velocity.add(pushB)

  resolveCollisions = (objects) ->
    objects.eachPair (a, b) ->
      return unless a.collides() && b.collides()

      if Collision.circular(a.circle(), b.circle())
        resolveCollision(a, b)

  wallCollisions = (objects, dt) ->
    # Arena walls
    walls = [{
        normal: Point(1, 0)
        position: WALL_LEFT
      }, {
        normal: Point(-1, 0)
        position: -WALL_RIGHT
      }, {
        normal: Point(0, 1)
        position: WALL_TOP
      }, {
        normal: Point(0, -1)
        position: -WALL_BOTTOM
    }]

    # Goal wall segments
    wallSegments = engine.find("Goal").map (goal) ->
      goal.walls()
    .flatten()

    objects.each (object) ->
      center = circle = object.circle()
      radius = circle.radius
      velocity = object.I.velocity

      collided = false
      wallSegments.each (wall) ->
        wallToObject = center.subtract(wall.center)

        if rectangularOverlap(wall, circle)
          if wall.horizontal
            normal = Point(0, wallToObject.y.sign())
          else
            normal = Point(wallToObject.x.sign(), 0)

          velocityProjection = velocity.dot(normal)
          # Heading towards wall
          if velocityProjection < 0
            # Reflection Vector
            velocity = velocity.subtract(normal.scale(2 * velocityProjection))

            collided = true

      if collided
        # Adjust velocity and move to (hopefully) non-penetrating position
        object.I.velocity = velocity
        object.I.x += velocity.x * dt
        object.I.y += velocity.y * dt

        Sound.play "clink0" if object.puck()

    objects.each (object) ->
      center = object.center()
      radius = object.I.radius
      velocity = object.I.velocity

      # Wall Collisions
      collided = false
      walls.each (wall) ->
        {position, normal} = wall

        # Penetration Vector
        if center.dot(normal) < radius + position
          velocityProjection = velocity.dot(normal)
          # Heading towards wall
          if velocityProjection < 0
            # Reflection Vector
            velocity = velocity.subtract(normal.scale(2 * velocityProjection))

            collided = true

      if collided
        # Adjust velocity and move to (hopefully) non-penetrating position
        object.I.velocity = velocity
        object.I.x += velocity.x * dt
        object.I.y += velocity.y * dt

        Sound.play "thud0" if object.puck()

  process: (objects) ->
    steps = 5

    dt = 1/steps

    steps.times ->
      objects.invoke "updatePosition", dt

      resolveCollisions(objects, dt)
      wallCollisions(objects, dt)

)()

