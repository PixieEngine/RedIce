Player = (I) ->
  $.reverseMerge I,
    collisionMargin: Point(2, 2)
    controller: 0
    width: 32
    height: 32
    x: 192
    y: 128
    velocity: Point()
    maxSpeed: 6
    heading: 0

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

    if actionDown "left"
      movement = movement.add(Point(-1, 0))
    if actionDown "right"
      movement = movement.add(Point(1, 0))
    if actionDown "up"
      movement = movement.add(Point(0, -1))
    if actionDown "down"
      movement = movement.add(Point(0, 1))

    I.velocity = I.velocity.add(movement)

    I.x += I.velocity.x
    I.y += I.velocity.y

  self

