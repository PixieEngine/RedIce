AI = (I, self) ->
  I.AIshooting = 0 # How much to charge a shot

  arenaCenter = Point(WALL_LEFT + WALL_RIGHT, WALL_TOP + WALL_BOTTOM).scale(0.5)

  roles = [
    "none"#"youth"
    "none"#"goalie"
    "youth"
    "youth"
  ]

  resetActions = ->
    I.AIturbo = false
    I.AIshoot = false

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
          if I.hasPuck
            targetPosition = towardsCenter # TODO: Better aiming

            if I.shotCharge > 0
              # Nothing, maybe charge longer?
            else
              I.AIshoot = true
          else
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
      I.AIturbo = rand() < (1 / 30)

      if I.hasPuck
        opposingGoal = engine.find("Goal").select (goal) ->
          goal.team() != I.teamStyle
        .first()

        if opposingGoal
          targetPosition = opposingGoal.center()

          if I.AIshooting
            I.AIshooting -= 1
          else
            if rand() < (1 / 60)
              I.AIshooting = rand(10) + 3

          I.AIshoot = I.AIshooting

      else
        targetPosition = engine.find("Puck").first()?.center()

      targetPosition || self.center()

  I.role = roles[I.slot]

  computeDirection: ->
    resetActions()

    if I.AI_TARGET = targetPosition = directionAI[I.role]()

      deltaPosition = targetPosition.subtract(self.center())

      if deltaPosition.length() > 1
        deltaPosition.norm()
      else
        deltaPosition
    else
      Point.ZERO
