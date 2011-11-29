Player = (I) ->
  $.reverseMerge I,
    blood:
      face: 0
      body: 0
      leftSkate: 0
      rightSkate: 0
    boost: 0
    boostMeter: 64
    cooldown:
      boost: 0
      shoot: 0
    collisionMargin: Point(2, 2)
    controller: 0
    falls: 0
    friction: 0.1
    heading: 0
    maxShotPower: 20
    movementDirection: 0
    radius: 16
    width: 32
    height: 32
    x: 192
    y: 128
    slot: 0
    shootPower: 0
    wipeout: 0
    velocity: Point()
    zIndex: 1

  redTeam = I.team
  standingOffset = Point(0, -8)
  flyingOffset = Point(-12, -8)

  if I.joystick
    controller = Joysticks.getController(I.id)
    actionDown = controller.actionDown
    axisPosition = controller.axis
  else
    actionDown = CONTROLLERS[I.controller].actionDown
    axisPosition = $.noop

  I.heading = if redTeam then Math.TAU/2 else 0

  particleSizes = [5, 4, 3]
  addSprayParticleEffect = (push, color=BLOOD_COLOR) ->
    push = push.norm(13)

    engine.add
      class: "Emitter"
      duration: 9
      sprite: Sprite.EMPTY
      velocity: I.velocity
      particleCount: 5
      batchSize: 5
      x: I.x + I.width/2 + push.x
      y: I.y + I.height/2 + push.y
      zIndex: 1 + (I.y + I.height + 1)/CANVAS_HEIGHT
      generator:
        color: color
        duration: 8
        height: (n) ->
          particleSizes.wrap(n)
        maxSpeed: 50
        velocity: (n) ->
          Point.fromAngle(Random.angle()).scale(rand(5) + 1).add(push)
        width: (n) ->
          particleSizes.wrap(n)

  self = Base(I).extend
    bloody: ->
      if I.wipeout
        I.blood.body += rand(5)
      else
        I.blood.leftSkate = (I.blood.leftSkate + rand(10)).clamp(0, 60)
        I.blood.rightSkate = (I.blood.rightSkate + rand(10)).clamp(0, 60)

    color: ->
      if I.cpu
        Color(Player.CPU_COLOR)
      else
        # Adjust the lightness of each player's name tag slightly, 
        # based on team and team slot
        Color(Player.COLORS[I.team]).lighten((I.slot - 1) * 0.1)

    controlCircle: ->
      p = Point.fromAngle(I.heading).scale(16)

      c = self.center().add(p)
      speed = I.velocity.magnitude()
      c.radius = 20 + ((100 - speed * speed)/100 * 8).clamp(-7, 8)

      return c

    controlPuck: (puck) ->
      return if I.cooldown.shoot

      puckControl = 0.04
      maxPuckForce = puckControl / puck.mass()

      p = Point.fromAngle(I.heading).scale(32)
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
      I.blood.face += rand(20) + rand(20) + rand(20) + I.falls

      I.shootPower = 0

      push = push.norm().scale(30)

      Sound.play("hit#{rand(4)}")
      Sound.play("crowd#{rand(3)}")

      addSprayParticleEffect(push)

      (rand(6) + 3).times ->
        engine.add
          class: "Fan"

      engine.add
        class: "Blood"
        x: I.x + push.x
        y: I.y + push.y

  shootPuck = (direction) ->
    puck = engine.find("Puck").first()

    power = Math.min(I.shootPower, I.maxShotPower)
    circle = self.controlCircle()
    baseShotPower = 15

    # Shot or pass
    if puck and Collision.circular(circle, puck.circle())
      if I.shootPower >= 2 * I.maxShotPower
        puck.trigger "superCharge"

      p = Point.fromAngle(direction).scale(baseShotPower + power * 2)
      puck.I.velocity = puck.I.velocity.add(p)

    # Hitting people
    else
      hit = false
      engine.find("Player").without([self]).each (player) ->
        return if hit
        if Collision.circular(circle, player.circle())
          hit = true
          p = Point.fromAngle(direction).scale(power)

          if power > 10
            player.wipeout(p)

          player.I.velocity = player.I.velocity.add(p)

    I.shootPower = 0

  self.bind "step", ->
    for key, value of I.cooldown
      I.cooldown[key] = value.approach(0, 1)

  self.bind "step", ->
    I.boost = I.boost.approach(0, 1)
    I.wipeout = I.wipeout.approach(0, 1)

    unless I.velocity.magnitude() == 0
      I.heading = Point.direction(Point(0, 0), I.velocity)

    self.drawBloodStreaks()

    movementScale = 0.625

    movement = Point(0, 0)

    if I.cpu
      movement = self.computeDirection()

      # Hot Join
      if controller?.actionDown "START"
        I.cpu = false
    else if controller
      movement = controller.position()
    else
      if actionDown "left"
        movement = movement.add(Point(-1, 0))
      if actionDown "right"
        movement = movement.add(Point(1, 0))
      if actionDown "up"
        movement = movement.add(Point(0, -1))
      if actionDown "down"
        movement = movement.add(Point(0, 1))

      movement = movement.norm()

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
      else if I.shootPower
        I.cooldown.shoot = 4

        shootPuck(I.movementDirection)
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
        addSprayParticleEffect(I.velocity, "rgba(128, 202, 255, 1)")

        I.velocity.x = 0
        I.velocity.y = 0
      else
        movement = movement.scale(movementScale)
        I.velocity = I.velocity.add(movement)

      I.hasPuck = false

  self.bind "update", ->
    I.hflip = (I.heading > 2*Math.TAU/8 || I.heading < -2*Math.TAU/8)

    if I.wipeout
      spriteIndex = 17
      unless redTeam
        spriteIndex += 1

      I.spriteOffset = flyingOffset
      I.sprite = wideSprites[spriteIndex]
    else
      cycle = (I.age/4).floor() % 2
      if -Math.TAU/8 <= I.heading <= Math.TAU/8
        facingOffset = 0
      else if -3*Math.TAU/8 <= I.heading <= -Math.TAU/8
        facingOffset = 4
      else if Math.TAU/8 < I.heading <= 3*Math.TAU/8
        facingOffset = 2
      else
        facingOffset = 0

      teamColor = (redTeam) * 16

      spriteIndex = cycle + facingOffset + teamColor

      I.spriteOffset = standingOffset
      I.sprite = sprites[spriteIndex]

    # Testing new  sprites
    if I.id == 0
      speed = I.velocity.magnitude()

      if speed < 1
        speedSheet = "coast"
      else if speed < 6
        speedSheet = "slow"
      else
        speedSheet = "fast"

      if 0 <= I.heading <= Math.TAU/2
        facing = "front"
      else
        facing = "back"

      headSheet = "stubs"
      angleSprites = 8
      headIndexOffset = 2
      headPosition = ((angleSprites * -I.heading / Math.TAU).round() + headIndexOffset).mod(angleSprites)
      if headPosition >= 5
        headPosition = 8 - headPosition
        I.headFlip = true
      else
        I.headFlip = false

      I.headOrder = facing
      I.headSprite = headSprites[headSheet][headPosition]

      if I.wipeout
        I.sprite = tubsSprites.fall[(25 - (I.wipeout / 4).floor()).clamp(0, 5)]
      else if power = I.shootPower
        I.headOrder = "front"
        if power < I.maxShotPower
          I.sprite = tubsSprites.shoot.wrap((power * 8 / I.maxShotPower).floor())
        else
          I.sprite = tubsSprites.shoot.wrap(5 + (I.age/2).floor() % 2)
      else if I.cooldown.shoot
        I.sprite = tubsSprites.shoot[10 - I.cooldown.shoot]
      else
        I.sprite = tubsSprites[speedSheet][facing].wrap((I.age / 2).floor())
      I.scale = 0.375

  if I.cpu
    self.include AI

  self.include PlayerDrawing

  self.bind 'afterTransform', self.drawPowerMeters

  self

Player.COLORS = [
  "#0246E3" # Blue
  "#EB070E" # Red
  "#388326" # Green
  "#F69508" # Orange
  "#563495" # Purple
  "#58C4F5" # Cyan
  "#FFDE49" # Yellow
]

Player.CPU_COLOR = "#888"

