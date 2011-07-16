Player = (I) ->
  $.reverseMerge I,
    boost: 0
    cooldown:
      boost: 0
      shoot: 0
    collisionMargin: Point(2, 2)
    controller: 0
    falls: 0
    friction: 0.1
    blood:
      face: 0
      body: 0
      leftSkate: 0
      rightSkate: 0
    radius: 16
    width: 32
    height: 32
    x: 192
    y: 128
    shootPower: 0
    wipeout: 0
    velocity: Point()
    zIndex: 1

  PLAYER_COLORS = [
    "#0246E3" # Blue
    "#EB070E" # Red
    "#388326" # Green
    "#F69508" # Orange
    "#563495" # Purple
    "#58C4F5" # Cyan
    "#FFDE49" # Yellow
  ]

  playerColor = PLAYER_COLORS[I.id]
  I.team ||= I.controller % 2
  redTeam = I.team
  standingOffset = Point(0, -16)
  flyingOffset = Point(-24, -16)

  if I.joystick
    controller = Joysticks.getController(I.controller)
    actionDown = controller.actionDown
    axisPosition = controller.axis
  else
    actionDown = CONTROLLERS[I.controller].actionDown
    axisPosition = $.noop

  maxShotPower = 20
  boostMeter = 64

  heading = if redTeam then Math.TAU/2 else 0
  movementDirection = 0

  drawFloatingNameTag = (canvas) ->
    if I.cpu
      name = "CPU"
    else
      name = "P#{(I.id + 1)}"

    padding = 6
    lineHeight = 16
    textWidth = canvas.measureText(name)

    backgroundColor = Color(playerColor)
    backgroundColor.a "0.5"

    yOffset = 48

    center = self.center()

    topLeft = center.subtract(Point(textWidth/2 + padding, lineHeight/2 + padding + yOffset))
    rectWidth = textWidth + 2*padding
    rectHeight = lineHeight + 2*padding

    canvas.fillColor(backgroundColor)
    canvas.fillRoundRect(topLeft.x, topLeft.y, rectWidth, rectHeight, 4)

    canvas.fillColor("#FFF")
    canvas.fillText(name, topLeft.x + padding, topLeft.y + lineHeight + padding/2)

  drawPowerMeters = (canvas) ->
    ratio = (boostMeter - I.cooldown.boost) / boostMeter
    start = self.position().add(Point(0, I.height)).floor()
    padding = 1
    maxWidth = I.width
    height = 3

    canvas.fillColor("#000")
    canvas.fillRoundRect(start.x - padding, start.y - padding, maxWidth + 2*padding, height + 2*padding, 2)

    if I.cooldown.boost == 0
      canvas.fillColor("#0F0")
    else
      canvas.fillColor("#080")
    canvas.fillRoundRect(start.x, start.y, maxWidth * ratio, height, 2)

    if I.shootPower
      maxWidth = 40
      height = 5
      ratio = Math.min(I.shootPower / maxShotPower, 1)
      center = self.center().floor()
      canvas.withTransform Matrix.translation(center.x, center.y).concat(Matrix.rotation(movementDirection)), ->
        canvas.fillColor("#000")
        canvas.fillRoundRect(-(padding + height)/2, -padding, maxWidth + 2*padding, height, 2)

        if I.shootPower >= maxShotPower && (I.age/2).floor() % 2
          canvas.fillColor("#0EF")
        else
          canvas.fillColor("#EE0")
        canvas.fillRoundRect(-height/2, 0, maxWidth * ratio, height, 2)

  drawControlCircle = (canvas) ->
    color = Color(playerColor).lighten(0.10)
    color.a "0.25"

    circle = self.controlCircle()

    canvas.fillCircle(circle.x, circle.y, circle.radius, color)

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

    controlCircle: ->
      p = Point.fromAngle(heading).scale(16)

      c = self.center().add(p)
      speed = I.velocity.magnitude()
      c.radius = 20 + ((100 - speed * speed)/100 * 8).clamp(-7, 8)

      return c

    controlPuck: (puck) ->
      return if I.cooldown.shoot

      puckControl = 4

      p = Point.fromAngle(heading).scale(32)
      targetPuckPosition = self.center().add(p)

      puckVelocity = puck.I.velocity

      positionDelta = targetPuckPosition.subtract(puck.center().add(puckVelocity))

      if positionDelta.magnitude() > puckControl
        positionDelta = positionDelta.norm().scale(puckControl)

      I.hasPuck = true

      puck.I.velocity = puck.I.velocity.add(positionDelta)

    drawShadow: (canvas) ->
      base = self.center().add(0, I.height/2 + 4)

      canvas.withTransform Matrix.scale(1, -0.5, base), ->
        shadowColor = "rgba(0, 0, 0, 0.15)"
        canvas.fillCircle(base.x - 4, base.y + 16, 16, shadowColor)
        canvas.fillCircle(base.x, base.y + 8, 16, shadowColor)
        canvas.fillCircle(base.x + 4, base.y + 16, 16, shadowColor)

    drawFloatingNameTag: drawFloatingNameTag

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

  leftSkatePos = ->
    p = Point.fromAngle(heading - Math.TAU/4).scale(5)

    self.center().add(p)

  rightSkatePos = ->
    p = Point.fromAngle(heading + Math.TAU/4).scale(5)

    self.center().add(p)

  shootPuck = (direction) ->
    puck = engine.find("Puck").first()

    power = Math.min(I.shootPower, maxShotPower)
    circle = self.controlCircle()
    baseShotPower = 15

    # Shot or pass
    if Collision.circular(circle, puck.circle())

      p = Point.fromAngle(direction).scale(baseShotPower + power * 2)
      puck.I.velocity = puck.I.velocity.add(p)

    I.shootPower = 0

  lastLeftSkatePos = null
  lastRightSkatePos = null

  drawBloodStreaks = ->
    if (blood = I.blood.face) && rand(2) == 0
      color = Color(BLOOD_COLOR)

      currentPos = self.center()
      (rand(blood)/3).floor().clamp(0, 2).times ->
        I.blood.face -= 1
        p = currentPos.add(Point.fromAngle(Random.angle()).scale(rand()*rand()*16))

        bloodCanvas.fillCircle(p.x, p.y, (rand(5)*rand()*rand()).clamp(0, 3), color)

    if I.wipeout # Body blood streaks

    else # Skate blood streaks
      currentLeftSkatePos = leftSkatePos()
      currentRightSkatePos = rightSkatePos()

      # Skip certain feet
      cycle = I.age % 30
      if 1 < cycle < 14
        lastLeftSkatePos = null
      if 15 < cycle < 29 
        lastRightSkatePos = null

      if lastLeftSkatePos
        if skateBlood = I.blood.leftSkate
          I.blood.leftSkate -= 1

          color = BLOOD_COLOR
          thickness = (skateBlood/30).clamp(0, 1.5)
        else
          color = ICE_COLOR
          thickness = 1

        bloodCanvas.strokeColor(color)
        bloodCanvas.drawLine(lastLeftSkatePos, currentLeftSkatePos, thickness)

      if lastRightSkatePos 
        if skateBlood = I.blood.rightSkate
          I.blood.rightSkate -= 1

          color = BLOOD_COLOR
          thickness = (skateBlood/30).clamp(0, 1.5)
        else
          color = ICE_COLOR
          thickness = 1

        bloodCanvas.strokeColor(color)        
        bloodCanvas.drawLine(lastRightSkatePos, currentRightSkatePos, thickness)

      lastLeftSkatePos = currentLeftSkatePos
      lastRightSkatePos = currentRightSkatePos

  self.bind "step", ->
    for key, value of I.cooldown
      I.cooldown[key] = value.approach(0, 1)

  self.bind "step", ->
    I.boost = I.boost.approach(0, 1)
    I.wipeout = I.wipeout.approach(0, 1)

    unless I.velocity.magnitude() == 0
      heading = Point.direction(Point(0, 0), I.velocity)

    drawBloodStreaks()

    movementScale = 0.625

    movement = Point(0, 0)

    if I.cpu
      movement = self.computeDirection()
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
      movementDirection = movement.direction()

    if I.wipeout
      lastLeftSkatePos = null
      lastRightSkatePos = null
    else
      if !I.cooldown.shoot && actionDown "B", "X"
        I.shootPower += 1

        movementScale = 0.1
      else if I.shootPower
        I.cooldown.shoot = 4

        shootPuck(movementDirection)
      else if I.cooldown.boost < boostMeter && (actionDown("A", "L", "R") || (axisPosition(4) > 0) || (axisPosition(5) > 0))
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

  self.bind 'afterTransform', drawPowerMeters

  self.bind "update", ->
    I.hflip = (heading > 2*Math.TAU/8 || heading < -2*Math.TAU/8)

    if I.wipeout
      spriteIndex = 17
      unless redTeam
        spriteIndex += 1

      I.spriteOffset = flyingOffset
      I.sprite = wideSprites[spriteIndex]
    else
      cycle = (I.age/4).floor() % 2
      if -Math.TAU/8 <= heading <= Math.TAU/8
        facingOffset = 0
      else if -3*Math.TAU/8 <= heading <= -Math.TAU/8
        facingOffset = 4
      else if Math.TAU/8 < heading <= 3*Math.TAU/8
        facingOffset = 2
      else
        facingOffset = 0

      teamColor = (redTeam) * 16

      spriteIndex = cycle + facingOffset + teamColor

      I.spriteOffset = standingOffset
      I.sprite = sprites[spriteIndex]

  if I.cpu
    self.include AI

  self

