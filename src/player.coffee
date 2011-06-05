Player = (I) ->
  $.reverseMerge I,
    animationName: "player_grey"
    debugAnimation: true
    boost: 0
    boostCooldown: 0
    collisionMargin: Point(2, 2)
    controller: 0
    includedModules: ["Animated"]
    width: 32
    height: 32
    x: 192
    y: 128
    velocity: Point()

  PLAYER_COLORS = [
    "#00F"
    "#F00"
    "#0F0"
    "#FF0"
    "orange"
    "#F0F"
    "#0FF"
  ]

  I.color = PLAYER_COLORS[I.controller]
  actionDown = CONTROLLERS[I.controller].actionDown

  self = GameObject(I)

  self.bind "step", ->
    I.boost = I.boost.approach(0, 1)
    I.boostCooldown = I.boostCooldown.approach(0, 1)

    movement = Point(0, 0)

    if actionDown "left"
      movement = movement.add(Point(-1, 0))
    if actionDown "right"
      movement = movement.add(Point(1, 0))
    if actionDown "up"
      movement = movement.add(Point(0, -1))
    if actionDown "down"
      movement = movement.add(Point(0, 1))

    movement = movement.norm()

    if !I.boostCooldown && actionDown "B"
      self.transition "check"

      I.boostCooldown += 20
      I.boost = 10
      movement = movement.scale(I.boost)

    I.velocity = I.velocity.add(movement).scale(0.9)

    I.x += I.velocity.x
    I.y += I.velocity.y

  self

