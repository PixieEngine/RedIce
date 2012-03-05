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
    controlRadius: 30
    falls: 0
    friction: 0.1
    heading: 0
    maxShotPower: 20
    movementDirection: 0
    radius: 20
    width: 32
    height: 32
    x: 192
    y: 128
    slot: 0
    shootPower: 0
    shootHoldFrame: 5
    team: 0
    headStyle: "stubs"
    teamStyle: "spike"
    bodyStyle: "tubs"
    wipeout: 0
    velocity: Point()
    zIndex: 1
    scale: 0.75

  if I.joystick
    controller = Joysticks.getController(I.id)
    actionDown = controller.actionDown
    axisPosition = controller.axis
  else
    actionDown = CONTROLLERS[I.controller].actionDown
    axisPosition = $.noop

  particleSizes = [5, 4, 3]
  addSprayParticleEffect = (push, color=BLOOD_COLOR) ->
    return unless config.particleEffects

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
      I.blood.face += rand(20) + rand(20) + rand(20) + I.falls

      I.shootPower = 0

      push = push.norm().scale(30)

      Sound.play("hit#{rand(4)}")
      Sound.play("crowd#{rand(3)}")

      addSprayParticleEffect(push)

      engine.add
        class: "Blood"
        x: I.x + push.x
        y: I.y + push.y

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

    # Testing wipeout animation
    if actionDown("BACK")
      self.wipeout(Point(1, 0))

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
        if I.cooldown.shoot == I.shootCooldownFrameCount - 2 # Shoot on second frame
          shootPuck(I.movementDirection)
      else if I.shootPower
        I.cooldown.shoot = I.shootCooldownFrameCount
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
    # Merge in team_body specific frame/character data
    Object.extend I, teamSprites[I.teamStyle][I.bodyStyle].characterData

    I.headAction = "normal"

    I.hflip = (I.heading > 2*Math.TAU/8 || I.heading < -2*Math.TAU/8)

    spriteSheet = self.spriteSheet()

    speed = I.velocity.magnitude()
    cycleDelay = 16

    # Determine character facing
    if 0 <= I.heading <= Math.TAU/2
      I.facing = "front"
    else
      I.facing = "back"

    if speed < 1
      I.action = "idle"
    else if speed < 6
      I.action = "slow"
      cycleDelay = 4
    else
      I.action = "fast"
      cycleDelay = 3

    if I.wipeout
      I.facing = "front"
      I.action = "fall"
      I.headAction = "pain"
      I.frame = ((25 - I.wipeout) / 3).floor().clamp(0, 5)
    else if power = I.shootPower
      I.facing = "front"
      I.action = "shoot"
      if power < I.maxShotPower
        I.frame = ((power * I.shootHoldFrame + 1) / I.maxShotPower).floor()
      else
        I.headAction = "charged"
        I.frame = I.shootHoldFrame + (I.age / 6).floor() % 2
    else if I.cooldown.shoot
      I.action = "shoot"
      I.facing = "front"
      I.frame = 10 - I.cooldown.shoot
    else
      I.frame = (I.age / cycleDelay).floor()

    # Lock head for front facing actions
    if I.facing == "front"
      headDirection = I.heading.constrainRotation()

      if headDirection < -Math.TAU/4
        headDirection = Math.TAU/2
      else if headDirection < 0
        headDirection = 0
    else
      headDirection = I.heading

    angleSprites = 8
    headIndexOffset = 2
    headPosition = ((angleSprites * -headDirection / Math.TAU).round() + headIndexOffset).mod(angleSprites)

    if headPosition >= 5
      headPosition = 8 - headPosition
      I.headFlip = true
    else
      I.headFlip = false

    I.headSprite = teamSprites[I.teamStyle][I.headStyle][I.headAction][headPosition]

  if I.cpu
    self.include AI

  self.include PlayerState
  self.include PlayerDrawing

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

