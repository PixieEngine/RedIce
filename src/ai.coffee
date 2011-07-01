AI = (I, self) ->

  $.reverseMerge I,
    role: "goalie"

  arenaCenter = Point(WALL_LEFT + WALL_RIGHT, WALL_TOP + WALL_BOTTOM).scale(0.5)

  computeDirection: ->
    if I.hasPuck
      targetPosition = engine.find("Goal").select (goal) ->
        goal.team() != I.team
      .first().center()

    else
      targetPosition = engine.find("Puck").first().center()

    if targetPosition
      targetPosition.subtract(self.center()).norm()
    else
      Point(0, 0)

