Player = (I={}) ->
  Object.reverseMerge I,
    boost: 0
    boostMeter: 64
    cooldown:
      boost: 0
      facing: 0
      flip: 0
      shoot: 0
    collisionMargin: Point(2, 2)
    controller: 0
    controlRadius: 30
    falls: 0
    friction: 0.1
    heading: 0
    joystick: true
    powerMultiplier: 1
    maxShotPower: 20
    movementDirection: 0
    movementSpeed: 1.25
    radius: 20
    width: 32
    height: 32
    x: App.width/2
    y: App.height/2
    slot: 0
    shootPower: 0
    shootHoldFrame: 5
    team: 0
    headStyle: "stubs"
    teamStyle: "spike"
    bodyStyle: "tubs"
    wipeout: 0
    shootCooldownFrameDelay: 3
    velocity: Point()

  Object.extend I, Player.bodyData[I.bodyStyle]

  controller = engine.controller(I.id)
  actionDown = controller.actionDown
  axisPosition = controller.axis || $.noop

  self = Base(I).extend
    controlCircle: ->
      p = Point.fromAngle(I.heading).scale(I.controlRadius)

      c = self.center().add(p)
      speed = I.velocity.magnitude()
      c.radius = I.controlRadius + ((100 - speed * speed)/100 * 8).clamp(-7, 8)

      return c

    controlPuck: (puck) ->
      return if I.cooldown.shoot

      puckControl = 0.04
      maxPuckForce = puckControl / puck.mass()

      p = Point.fromAngle(I.heading).scale(48)
      targetPuckPosition = self.center().add(p)

      puckVelocity = puck.I.velocity

      positionDelta = targetPuckPosition.subtract(puck.center().add(puckVelocity))

      if positionDelta.magnitude() > maxPuckForce
        positionDelta = positionDelta.norm().scale(maxPuckForce)

      I.hasPuck = true

      puck.I.velocity = puck.I.velocity.add(positionDelta)

    wipeout: (push) ->
      I.falls += 1
      I.wipeout = 25

      I.shootPower = 0

      push = push.norm().scale(30)

      Sound.play("hit#{rand(4)}")
      Sound.play("crowd#{rand(3)}")
      Fan.cheer(1)

      ParticleEffect.bloodSpray
        push: push
        x: I.center.x + push.x
        y: I.center.y + push.y

      engine.add
        class: "Blood"
        x: I.center.x + push.x
        y: I.center.y + push.y

      self.trigger "wipeout"

  shootPuck = (direction) ->
    puck = engine.find("Puck").first()

    power = Math.min(I.shootPower, I.maxShotPower)
    circle = self.controlCircle()
    circle.radius *= 2 # Shot hit radius is twice control circle radius
    baseShotPower = 15

    # Shot or pass
    if puck and Collision.circular(circle, puck.circle())
      if I.shootPower >= 2 * I.maxShotPower
        puck.trigger "superCharge"

      p = Point.fromAngle(direction).scale(baseShotPower + power * I.powerMultiplier)
      puck.I.velocity = puck.I.velocity.add(p)

    # Hitting people
    else
      # Hit everyting in your way!
      # TODO Maybe distribute power evenly
      engine.find("Player, Gib, Zamboni").without([self]).each (entity) ->
        if Collision.circular(circle, entity.circle())
          p = Point.fromAngle(direction).scale(power * I.powerMultiplier / entity.mass())

          if power > entity.toughness()
            entity.wipeout(p)

          entity.I.velocity = entity.I.velocity.add(p)

    I.shootPower = 0

  self.bind "step", ->
    for key, value of I.cooldown
      I.cooldown[key] = value.approach(0, 1)

  self.bind "step", ->
    I.boost = I.boost.approach(0, 1)
    I.wipeout = I.wipeout.approach(0, 1)

    unless I.velocity.magnitude() == 0
      I.heading = Point.direction(Point(0, 0), I.velocity)

    movementScale = I.movementSpeed

    movement = Point(0, 0)

    if I.cpu
      movement = self.computeDirection()

      # Hot Join
      if controller?.actionDown "START"
        I.cpu = false
    else if controller
      movement = controller.position()

    if movement.x || movement.y
      I.movementDirection = movement.direction()

    if I.wipeout
      I.lastLeftSkatePos = null
      I.lastRightSkatePos = null
    else
      if !I.cooldown.shoot && actionDown "B", "X"
        if I.shootPower < I.maxShotPower
          I.shootPower += 1
        else
          I.shootPower += 2

        movementScale = 0.1
      else if I.cooldown.shoot
        if (I.cooldown.shoot / I.shootCooldownFrameDelay).floor() == I.shootCooldownFrameCount - 2 # Shoot on second frame
          shootPuck(I.movementDirection)
      else if I.shootPower
        I.cooldown.shoot = I.shootCooldownFrameCount * I.shootCooldownFrameDelay
      else if I.cooldown.boost < I.boostMeter && (actionDown("A", "L", "R") || (axisPosition(4) > 0) || (axisPosition(5) > 0))
        if I.cooldown.boost == 0
          bonus = 10
        else
          bonus = 2

        I.cooldown.boost += 4

        movement = movement.scale(bonus)

      # Check cutback
      velocityNorm = I.velocity.norm()
      velocityLength = I.velocity.length()
      movementLength = movement.length()

      if (velocityLength > 4) && (movement.dot(velocityNorm) < (-0.95) * movementLength)
        ParticleEffect.iceSpray
          push: I.velocity
          x: I.center.x
          y: I.center.y

        I.velocity.x = 0
        I.velocity.y = 0
      else
        movement = movement.scale(movementScale)
        I.velocity = I.velocity.add(movement)

      I.hasPuck = false

  if I.cpu
    self.include AI

  self.include PlayerState
  self.include PlayerDrawing
  self.include Player.Streaks

  self

Player.bodyData =
  skinny:
    mass: 1.5
    movementSpeed: 1.25
    powerMultiplier: 2
    radius: 18
  thick:
    mass: 2
    movementSpeed: 1.1
    powerMultiplier: 3
  tubs:
    mass: 4
    movementSpeed: 1
    powerMultiplier: 2.5
    radius: 22
