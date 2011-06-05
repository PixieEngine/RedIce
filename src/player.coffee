Player = (I) ->
  $.reverseMerge I,
    collisionMargin: Point(2, 2)
    width: 32
    height: 32
    x: 192
    y: 128
    state: {}
    speed: 4
    items: {
    }

  I.sprite = Sprite.loadByName("player")
  walkSprites =
    up: [Sprite.loadByName("walk_up0"), Sprite.loadByName("walk_up1")]
    right: [Sprite.loadByName("walk_right0"), Sprite.loadByName("walk_right1")]
    down: [Sprite.loadByName("walk_down0"), Sprite.loadByName("walk_down1")]
    left: [Sprite.loadByName("walk_left0"), Sprite.loadByName("walk_left1")]

  pickupSprite = Sprite.loadByName("player_get")

  pickupItem = null

  self = GameObject(I).extend
    pickup: (item) ->
      I.state.pickup = 45
      pickupItem = item

      I.items[item.I.name] = true

      if item.I.message
        engine.add
          class: "Text"
          duration: 150
          message: item.I.message
          y: 32

  walkCycle = 0

  facing = Point(0, 0)

  self.bind "draw", (canvas) ->
    if I.state.pickup && pickupItem
      pickupItem.I.sprite.draw(canvas, 8, -8)

  self.bind "step", ->
    movement = Point(0, 0)

    if I.state.pickup
      I.state.pickup -= 1
      I.sprite = pickupSprite
    else
      if keydown.left
        movement = movement.add(Point(-1, 0))
        I.sprite = walkSprites.left.wrap((walkCycle/4).floor())
      if keydown.right
        movement = movement.add(Point(1, 0))
        I.sprite = walkSprites.right.wrap((walkCycle/4).floor())
      if keydown.up
        movement = movement.add(Point(0, -1))
        I.sprite = walkSprites.up.wrap((walkCycle/4).floor())
      if keydown.down
        movement = movement.add(Point(0, 1))
        I.sprite = walkSprites.down.wrap((walkCycle/4).floor())

    if movement.equal(Point(0, 0))
      I.velocity = movement
    else
      walkCycle += 1

      facing = movement.norm()
      I.velocity = facing.scale(I.speed)

      I.velocity.x.abs().times ->
        if !engine.collides(self.collisionBounds(I.velocity.x.sign(), 0), self)
          I.x += I.velocity.x.sign()
        else 
          I.velocity.x = 0

      I.velocity.y.abs().times ->
        if !engine.collides(self.collisionBounds(0, I.velocity.y.sign()), self)
          I.y += I.velocity.y.sign()
        else 
          I.velocity.y = 0

    I.x = I.x.clamp(0, 480 - I.width)
    I.y = I.y.clamp(0, 320 - I.height)

  self

