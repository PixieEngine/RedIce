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

)()

