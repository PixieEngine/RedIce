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

  self.bind "step", ->
    if puck = engine.find("Puck.active").first()

      # Goal wall puck collisions

      if withinGoal(puck.circle())
        puck.destroy()

        Sound.play("crowd#{rand(3)}")

        engine.add
          class: "Puck"

        self.trigger "score"

  return self

