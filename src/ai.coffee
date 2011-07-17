AI = (I, self) ->
  arenaCenter = Point(WALL_LEFT + WALL_RIGHT, WALL_TOP + WALL_BOTTOM).scale(0.5)

  roles = [
    "youth"
    "goalie"
    "youth"
  ]

  directionAI = 
    goalie: ->
      targetPosition = engine.find("Goal").select (goal) ->
        goal.team() == I.team
      .first().center()

      targetPosition.add((arenaCenter.subtract(targetPosition)).norm().scale(16))

    youth: ->
      if I.hasPuck
        targetPosition = engine.find("Goal").select (goal) ->
          goal.team() != I.team
        .first().center()

      else
        targetPosition = engine.find("Puck").first().center()

      targetPosition || self.center()

  I.role = roles[(I.controller / 2).floor()]

  computeDirection: ->
    targetPosition = directionAI[I.role]()

    deltaPosition = targetPosition.subtract(self.center())

    if deltaPosition.length() > 1
      deltaPosition.norm()
    else
      deltaPosition

