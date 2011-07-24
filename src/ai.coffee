AI = (I, self) ->
  arenaCenter = Point(WALL_LEFT + WALL_RIGHT, WALL_TOP + WALL_BOTTOM).scale(0.5)

  roles = [
    "youth"
    "goalie"
    "youth"
  ]

  directionAI = 
    goalie: ->
      ownGoal = engine.find("Goal").select (goal) ->
        goal.team() == I.team
      .first()

      if ownGoal
        targetPosition = ownGoal.center()
        targetPosition = targetPosition.add((arenaCenter.subtract(targetPosition)).norm(24))
      else
        targetPosition = self.center()

      if targetPosition.subtract(self.center()).length() < 1
        self.center()
      else
        targetPosition

    youth: ->
      if I.hasPuck
        opposingGoal = engine.find("Goal").select (goal) ->
          goal.team() != I.team
        .first()

        if opposingGoal
          targetPosition = opposingGoal.center()

      else
        targetPosition = engine.find("Puck").first().center()

      targetPosition || self.center()

  I.role = roles[(I.controller / 2).floor()]

  computeDirection: ->
    I.AI_TARGET = targetPosition = directionAI[I.role]()

    deltaPosition = targetPosition.subtract(self.center())

    if deltaPosition.length() > 1
      deltaPosition.norm()
    else
      deltaPosition

