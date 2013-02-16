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
    controlRadius: 50
    falls: 0
    friction: 0.075
    heading: 0
    powerMultiplier: 1
    mass: 10
    maxShotPower: 20
    minShotPower: 20
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
    puckLead: 75
    velocity: Point()

  controller = engine.controller(I.id)
  actionDown = controller.actionDown
  axisPosition = controller.axis or ->

  self = Base(I).extend
    player: ->
      true

    controlCircles: ->
      p = Point.fromAngle(I.heading).scale((I.controlRadius + I.puckLead)/2)

      # Forward Circle
      c1 = self.center().add(p)
      c1.radius = I.controlRadius

      # Self Circle
      c2 = self.center()
      c2.radius = I.controlRadius * 2

      return [c1, c2]

    controlPuck: (puck) ->
      return if I.cooldown.shoot

      puckControl = 2
      maxPuckForce = puckControl / puck.mass()

      p = Point.fromAngle(I.heading).scale(I.puckLead)
      targetPuckPosition = self.center().add(p)

      puckVelocity = puck.I.velocity

      positionDelta = targetPuckPosition.subtract(puck.center().add(puckVelocity))

      if positionDelta.magnitude() > maxPuckForce
        positionDelta = positionDelta.norm().scale(maxPuckForce)

      I.hasPuck = true

      puck.I.velocity = puck.I.velocity.add(positionDelta)

    puckControl: ->
      I.hasPuck

    wipeout: (push) ->
      I.falls += 1
      I.wipeout = 25

      I.shootPower = 0

      push = push.norm().scale(30)

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

  self.include Player.Data

  shootPuck = (direction) ->
    puck = engine.find("Puck").first()

    # TODO Redo power computation to basePower + charge * chargeRate, cap max
    power = Math.min(I.shootPower, I.maxShotPower) * I.powerMultiplier
    power = Math.max(power, I.minShotPower)

    # TODO: Shot/hit circle
    circle = self.controlCircles().first()
    circle.radius *= 2 # Shot hit radius is twice control circle radius

    if I.shootPower > 0
      # Hit everyting in your way!
      # TODO Maybe distribute power evenly
      engine.find("Player, Gib, Zamboni, Puck").without([self]).each (entity) ->
        if Collision.circular(circle, entity.circle())
          mass = entity.mass()
          if entity.player()
            mass = mass / 10 # Hits should launch players

          p = Point.fromAngle(direction).scale(power / mass)

           # Toughness is doubled for swings, normal for checks
          if power >= entity.toughness() * 2
            entity.wipeout(p)

          entity.I.velocity = entity.I.velocity.add(p)

          entity.trigger "struck"

      self.trigger "shoot", {power, direction}

    I.shootPower = 0

  self.on "update", ->
    for key, value of I.cooldown
      I.cooldown[key] = value.approach(0, 1)

  self.on "update", ->
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
          if I.shootPower is 0
            self.trigger "shot_start"

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
        self.trigger "slide_stop"
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

  self.include Player.State
  self.include Player.Drawing
  self.include Player.Streaks
  self.include Player.Sounds

  self
