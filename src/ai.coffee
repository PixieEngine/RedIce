AI = (I, self) ->
  arenaCenter = Point(WALL_LEFT + WALL_RIGHT, WALL_TOP + WALL_BOTTOM).scale(0.5)

  roles = [
    "youth"
    "goalie"
    "youth"
    "youth"
  ]

  directionAI =
    none: ->

    goalie: ->
      ownGoal = engine.find("Goal").select (goal) ->
        goal.team() == I.teamStyle
      .first()

      if ownGoal
        targetPosition = ownGoal.center()
        towardsCenter = arenaCenter.subtract(targetPosition).norm(48)

        if puck = engine.find("Puck").first()
          puckPosition = puck.position()

          towardsPuck = puckPosition.subtract(targetPosition)

          if towardsPuck.dot(towardsCenter) > 0
            targetPosition = targetPosition.add(towardsPuck.norm(48))
          else
          targetPosition = targetPosition.add(towardsCenter)
        else
          targetPosition = targetPosition.add(towardsCenter)
      else
        targetPosition = self.center()

      if targetPosition.subtract(self.center()).length() < 10
        self.center()
      else
        targetPosition

    youth: ->
      if I.hasPuck
        opposingGoal = engine.find("Goal").select (goal) ->
          goal.team() != I.teamStyle
        .first()

        if opposingGoal
          targetPosition = opposingGoal.center()

      else
        targetPosition = engine.find("Puck").first()?.center()

      targetPosition || self.center()

  I.role = roles[I.slot]

  computeDirection: ->
    if I.AI_TARGET = targetPosition = directionAI[I.role]()

      deltaPosition = targetPosition.subtract(self.center())

      if deltaPosition.length() > 1
        deltaPosition.norm()
      else
        deltaPosition
    else
      Point.ZERO
