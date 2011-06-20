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

    i = 0
    while i < objects.length
      A = objects[i]
      j = i + 1
      i += 1

      while j < objects.length
        B = objects[j]
        j += 1

        continue unless A.collides() && B.collides()

        if Collision.circular(A.circle(), B.circle())
          resolveCollision(A, B)

)()

