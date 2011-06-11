Goal = (I) ->
  I ||= {}

  $.reverseMerge I,
    color: "green"
    height: 32
    width: 12
    x: WALL_LEFT + ARENA_WIDTH/20 - 12
    y: WALL_TOP + ARENA_HEIGHT/2 - 16

  self = GameObject(I)

  withinGoal = (circle) ->

    if circle.x + circle.radius > I.x && circle.x - circle.radius < I.x + I.width
      if circle.y + circle.radius > I.y && circle.y - circle.radius < I.y + I.height
        return true

    return false

  self.bind "step", ->
    puck = engine.find("Puck.active").first()

    if puck && withinGoal(puck.circle())
      puck.destroy()

      engine.add
        class: "Puck"

      self.trigger "scored"

  return self

