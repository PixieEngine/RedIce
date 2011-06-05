Player = (I) ->
  $.reverseMerge I,
    debugAnimation: true
    boost: 0
    boostCooldown: 0
    collisionMargin: Point(2, 2)
    controller: 0
    radius: 16
    width: 32
    height: 32
    x: 192
    y: 128
    wipeout: 0
    velocity: Point()
    zIndex: 1

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

  self = GameObject(I).extend
    circle: ->
      c = self.center()
      c.radius = I.radius

      return c

    draw: (canvas) ->
      center = self.center()
      canvas.fillCircle(center.x, center.y, I.radius, I.color)

    puck: ->
      false

    wipeout: (push) ->
      I.color = Color(PLAYER_COLORS[I.controller]).lighten(0.25)
      I.wipeout = 25

      push = push.scale(15)

      engine.add
        sprite: Sprite.loadByName "blood"
        x: I.x + push.x
        y: I.y + push.y

  self.bind "step", ->
    I.boost = I.boost.approach(0, 1)
    I.boostCooldown = I.boostCooldown.approach(0, 1)
    I.wipeout = I.wipeout.approach(0, 1)

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
      I.boostCooldown += 20
      I.boost = 10
      movement = movement.scale(I.boost)

    if I.wipeout

    else
      I.color = PLAYER_COLORS[I.controller]
      I.velocity = I.velocity.add(movement).scale(0.9)

    I.x += I.velocity.x
    I.y += I.velocity.y

  self

