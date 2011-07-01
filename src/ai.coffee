AI = (I, self) ->

  $.reverseMerge I,
    role: "goalie"

  arenaCenter = Point(WALL_LEFT + WALL_RIGHT, WALL_TOP + WALL_BOTTOM).scale(2)

  computeDirection: ->
    targetPosition = arenaCenter

    direction = targetPosition.subtract(I)

    return direction.norm()

