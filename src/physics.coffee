Physics = (I={}) ->
  overlapX = (wall, circle) ->
    (circle.x - wall.center.x).abs() < wall.halfWidth + circle.radius

  overlapY = (wall, circle) ->
    (circle.y - wall.center.y).abs() < wall.halfHeight + circle.radius

  rectangularOverlap = (wall, circle) ->
    return overlapX(wall, circle) && overlapY(wall, circle)

  threshold = 12

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
    goalWallCollisions(objects, dt)
    rinkCornerCollisions(objects, dt)
    rinkWallCollisions(objects, dt)

  goalWallCollisions = (objects, dt) ->
    # Goal wall segments
    wallSegments = engine.find("Goal").map (goal) ->
      goal.walls()
    .flatten()

    objects.each (object) ->
      return unless object.collidesWithWalls()

      center = circle = object.circle()
      radius = circle.radius
      velocity = object.I.velocity

      collided = false
      wallSegments.each (wall) ->
        if rectangularOverlap(wall, circle)
          wallToObject = center.subtract(wall.center)

          if wall.horizontal
            if wallToObject.x.abs() < wall.halfWidth
              normal = Point(0, wallToObject.y.sign())
            else # capsule ends
              capCenter = Point(wallToObject.x.sign() * wall.halfWidth, 0).add(wall.center)

              normal = center.subtract(capCenter).norm()
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
        object.updatePosition(dt, true)

        object.trigger "wallCollision", "goal"

      return

  rinkCornerCollisions = (objects, dt) ->
    return unless rink = engine.find("Rink").first()

    corners = rink.corners()
    cornerRadius = rink.cornerRadius()

    # Rounded rink collisions
    objects.each (object) ->
      return unless object.collidesWithWalls()

      center = object.center()
      radius = object.I.radius
      velocity = object.I.velocity

      corners.each (corner) ->
        {position} = corner

        # Coarse Checks
        switch corner.quadrant
          when 0
            return unless center.x < position.x && center.y < position.y
          when 1
            return unless center.x > position.x && center.y < position.y
          when -1
            return unless center.x < position.x && center.y > position.y
          when -2
            return unless center.x > position.x && center.y > position.y

        distanceToCenter = position.subtract(center)
        normal = distanceToCenter.norm()

        angle = Point.direction(Point(0, 0), normal)
        quadrant = (4 * angle / Math.TAU).floor()

        if quadrant == corner.quadrant && radius * radius + distanceToCenter.dot(distanceToCenter) > cornerRadius * cornerRadius
          velocityProjection = velocity.dot(normal)
          # Heading towards wall
          if velocityProjection < 0
            # Reflection Vector
            velocity = velocity.subtract(normal.scale(2 * velocityProjection))

            # Adjust velocity and move to (hopefully) non-penetrating position
            object.I.velocity = velocity
            object.updatePosition(dt, true)

            object.trigger "wallCollision"

      return

  rinkWallCollisions = (objects, dt) ->
    return unless walls = engine.find("Rink").first()?.walls()

    # Rink Walls
    objects.each (object) ->
      return unless object.collidesWithWalls()

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
        object.updatePosition(dt, true)

        object.trigger "wallCollision"

      return

  process: (objects) ->
    steps = 5

    dt = 1/steps

    steps.times ->
      objects.invoke "updatePosition", dt

      resolveCollisions(objects, dt)
      wallCollisions(objects, dt)

