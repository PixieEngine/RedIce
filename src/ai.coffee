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

      targetPosition.subtract(self.center()).norm()

    youth: ->
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

  I.role = roles[(I.controller / 2).floor()]

  computeDirection: ->
    directionAI[I.role]()

