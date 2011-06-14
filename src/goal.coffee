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
    [{
      center: Point(I.x + I.width/2, I.y)
      halfWidth: I.width/2
      halfHeight: 0
    }, {
      center: Point(I.x + I.width/2, I.y + I.height)
      halfWidth: I.width/2
      halfHeight: 0
    }]

  withinGoal = (circle) ->

    if circle.x + circle.radius > I.x && circle.x - circle.radius < I.x + I.width
      if circle.y + circle.radius > I.y && circle.y - circle.radius < I.y + I.height
        return true

    return false

  overlapX = (wall, circle) ->
    (circle.x - wall.center.x).abs() < wall.halfWidth + circle.radius 

  overlapY = (wall, circle) ->
    debugger
    (circle.y - wall.center.y).abs() < wall.halfHeight + circle.radius

  overlap = (wall, circle) ->
    return overlapX(wall, circle) && overlapY(wall, circle)

  self.bind "step", ->
    if puck = engine.find("Puck.active").first()
      circle = puck.circle()
      velocity = puck.I.velocity

      # Goal wall puck collisions
      collided = false
      wallSegments().each (wall) ->
        if overlapY(wall, circle)
          I.color = "green"
        else
          I.color = "orange"

        if overlap(wall, circle)
          normal = circle.center().subtract(wall.center).norm()

          velocityProjection = velocity.dot(normal)

          debugger

          # Heading towards wall
          if velocityProjection < 0
            # Reflection Vector
            velocity = velocity.subtract(normal.scale(2 * velocityProjection))

            collided = true

      if collided
        puck.I.velocity = velocity
        puck.I.x += velocity.x
        puck.I.y += velocity.y

      if withinGoal(circle)
        puck.destroy()

        Sound.play("crowd#{rand(3)}")

        engine.add
          class: "Puck"

        self.trigger "score"

  return self

