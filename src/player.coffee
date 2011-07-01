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

  playerColor = PLAYER_COLORS[I.controller]
  redTeam = I.controller % 2
  teamColor = I.color = PLAYER_COLORS[redTeam]
  standingOffset = Point(0, -16)
  flyingOffset = Point(-24, -16)

  if I.cpu

  else if I.joystick
    controller = Joysticks.getController(I.controller)
    actionDown = controller.actionDown
  else
    actionDown = CONTROLLERS[I.controller].actionDown

  maxShotPower = 20
  boostTimeout = 20

  I.name ||= "Player #{I.controller + 1}"

  heading = if redTeam then Math.TAU/2 else 0

  drawFloatingNameTag = (canvas) ->
    canvas.font("bold 16px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")

    name = I.controller + 1

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
    ratio = (boostTimeout - I.cooldown.boost) / boostTimeout
    start = self.position().add(Point(0, I.height)).floor()
    padding = 1
    maxWidth = I.width
    height = 3

    canvas.fillColor("#000")
    canvas.fillRoundRect(start.x - padding, start.y - padding, maxWidth + 2*padding, height + 2*padding, 2)
    if ratio == 1
      canvas.fillColor("#0F0")
    else
      canvas.fillColor("#080")
    canvas.fillRoundRect(start.x, start.y, maxWidth * ratio, height, 2)

    if I.shootPower
      yExtension = 16
      ratio = I.shootPower / maxShotPower
      start = self.position().subtract(Point(0, yExtension)).floor()
      padding = 1
      maxHeight = I.height + yExtension
      width = 3
      height = maxHeight * ratio

      canvas.fillColor("#000")
      canvas.fillRoundRect(start.x - padding, start.y - padding, width + 2*padding, maxHeight, 2)

      canvas.fillColor("#EE0")
      canvas.fillRoundRect(start.x, start.y + maxHeight - height, width, height, 2)

  drawControlCircle = (canvas) ->
    color = Color(playerColor).lighten(0.10)
    color.a "0.25"

    circle = self.controlCircle()

    canvas.fillCircle(circle.x, circle.y, circle.radius, color)

  self = Base(I).extend
    bloody: ->
      if I.wipeout
        I.blood.body += rand(5)
      else
        I.blood.leftSkate = (I.blood.leftSkate + rand(10)).clamp(0, 60)
        I.blood.rightSkate = (I.blood.rightSkate + rand(10)).clamp(0, 60)

    #center: ->
    #  Point(I.x + I.width/2, I.y + I.height/2 + 16)

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

      puck.I.velocity = puck.I.velocity.add(positionDelta)

    drawShadow: (canvas) ->
      base = self.center().add(0, I.height/2 + 4)

      canvas.withTransform Matrix.scale(1, -0.5, base), ->
        shadowColor = "rgba(0, 0, 0, 0.15)"
        canvas.fillCircle(base.x - 4, base.y + 16, 16, shadowColor)
        canvas.fillCircle(base.x, base.y + 8, 16, shadowColor)
        canvas.fillCircle(base.x + 4, base.y + 16, 16, shadowColor)

    wipeout: (push) ->
      I.falls += 1
      I.wipeout = 25
      I.blood.face += rand(20) + rand(20) + rand(20) + I.falls

      push = push.norm().scale(30)

      Sound.play("hit#{rand(4)}")
      Sound.play("crowd#{rand(3)}")

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

  shootPuck = ->
    puck = engine.find("Puck").first()

    power = I.shootPower
    circle = self.controlCircle()
    baseShotPower = 15

    # Shot or pass
    if Collision.circular(circle, puck.circle())

      p = Point.fromAngle(heading).scale(baseShotPower + power * 2)
      puck.I.velocity = puck.I.velocity.add(p)

    I.shootPower = 0

  lastLeftSkatePos = null
  lastRightSkatePos = null

  drawBloodStreaks = ->
    if (blood = I.blood.face) && rand(2) == 0
      color = Color(BLOOD_COLOR)

      currentPos = self.center()
      (rand(I.blood.face)/3).floor().clamp(1, 8).times ->
        I.blood.face -= 1
        p = currentPos.add(Point.fromAngle(Random.angle()).scale(rand()*rand()*16))

        bloodCanvas.fillCircle(p.x, p.y, (rand(blood/4)*rand()*rand()).clamp(0, 3), color)

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
          thickness = (skateBlood/15).clamp(0, 2)
        else
          color = ICE_COLOR
          thickness = 1

        bloodCanvas.strokeColor(color)
        bloodCanvas.drawLine(lastLeftSkatePos, currentLeftSkatePos, thickness)

      if lastRightSkatePos 
        if skateBlood = I.blood.rightSkate
          I.blood.rightSkate -= 1

          color = BLOOD_COLOR
          thickness = (skateBlood/15).clamp(0, 2)
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

    if I.wipeout
      lastLeftSkatePos = null
      lastRightSkatePos = null
    else
      if !I.cooldown.shoot && actionDown "A", "Y"
        I.shootPower += 1

        chargePhase = Math.sin(Math.TAU/4 * I.age) * 0.2 * I.shootPower / maxShotPower

        # TODO: Set Shoot animation
        # I.color = Color(teamColor).lighten(chargePhase)

        if I.shootPower == maxShotPower
          I.cooldown.shoot = 5
      else if I.shootPower
        I.cooldown.shoot = 4

        shootPuck()
      else if !I.cooldown.boost && actionDown "B", "X"
        I.cooldown.boost += boostTimeout
        I.boost = 10
        movement = movement.scale(I.boost)

      movement = movement.scale(0.75)

      I.velocity = I.velocity.add(movement)

  self.bind 'after_transform', (canvas) ->
    drawPowerMeters(canvas)
    drawFloatingNameTag(canvas)

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

  self

