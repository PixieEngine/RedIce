Physics = (->
  threshold = 5

  resolveCollision = (A, B) ->
    normal = B.center().subtract(A.center()).norm()

    # Checking
    powA = A.collisionPower(normal)
    powB = -B.collisionPower(normal)

    relativeVelocity = A.I.velocity.subtract(B.I.velocity)

    massA = A.mass()
    massB = B.mass()

    totalMass = massA + massB

    pushA = normal.scale(-2 * (relativeVelocity.dot(normal) * (massB / totalMass) + 1))
    pushB = normal.scale(+2 * (relativeVelocity.dot(normal) * (massA / totalMass) + 1))

    A.I.velocity = A.I.velocity.add(pushA)
    B.I.velocity = B.I.velocity.add(pushB)

    max = Math.max(powA, powB)

    if max > threshold
      if powA == max
        A.crush(B)
        B.wipeout(pushB)
      else
        B.crush(A)
        A.wipeout(pushA)

  resolveCollisions: (objects) ->
    objects.eachPair (a, b) ->
      return unless a.collides() && b.collides()

      if Collision.circular(a.circle(), b.circle())
        resolveCollision(a, b)

  wallCollisions: (objects) ->
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
        object.I.x += velocity.x
        object.I.y += velocity.y

        Sound.play "thud0" if object.puck()

)()

