Player = (I) ->
  $.reverseMerge I,
    boost: 0
    boostCooldown: 0
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
    shootCooldown: 0
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
  teamColor = I.color = PLAYER_COLORS[I.controller % 2]
  actionDown = CONTROLLERS[I.controller].actionDown

  maxShotPower = 20

  I.name ||= "Player #{I.controller + 1}"

  heading = 0

  drawFloatingNameTag = (canvas) ->
    canvas.font("bold 16px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")

    padding = 6
    lineHeight = 16
    textWidth = canvas.measureText(I.name)

    backgroundColor = Color(playerColor)
    backgroundColor.a "0.5"

    yOffset = 32

    center = self.center()

    topLeft = center.subtract(Point(textWidth/2 + padding, lineHeight/2 + padding + yOffset))
    rectWidth = textWidth + 2*padding
    rectHeight = lineHeight + 2*padding

    canvas.fillColor(backgroundColor)
    canvas.fillRoundRect(topLeft.x, topLeft.y, rectWidth, rectHeight, 4)

    canvas.fillColor("#FFF")
    canvas.fillText(I.name, topLeft.x + padding, topLeft.y + lineHeight + padding/2)

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
        I.blood.leftSkate += rand(10)
        I.blood.rightSkate += rand(10)

    controlCircle: ->
      p = Point.fromAngle(heading).scale(16)

      c = self.center().add(p)
      speed = I.velocity.magnitude()
      c.radius = 8 + ((100 - speed * speed)/100 * 8).clamp(-7, 8)

      return c

    controlPuck: (puck) ->
      return if I.shootCooldown

      puckControl = 2

      p = Point.fromAngle(heading).scale(32)
      targetPuckPosition = self.center().add(p)

      puckVelocity = puck.I.velocity

      positionDelta = targetPuckPosition.subtract(puck.center().add(puckVelocity))

      if positionDelta.magnitude() > puckControl
        positionDelta = positionDelta.norm().scale(puckControl)

      puck.I.velocity = puck.I.velocity.add(positionDelta)

    draw: (canvas) ->
      center = self.center()
      canvas.fillCircle(center.x, center.y, I.radius, I.color)

      drawControlCircle(canvas)
      drawFloatingNameTag(canvas)

    puck: ->
      false

    wipeout: (push) ->
      I.falls += 1
      I.color = Color(teamColor).lighten(0.25)
      I.wipeout = 25
      I.blood.face += rand(20) + rand(20) + rand(20) + I.falls * 3

      push = push.scale(15)

      Sound.play("hit#{rand(4)}")
      Sound.play("crowd#{rand(3)}")

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
    stealPower = 10
    circle = self.controlCircle()

    if power < 5
      # Steal Attempt
      circle.radius *= 1.5

      if Collision.circular(circle, puck.circle())
        p = Point.fromAngle(Random.angle()).scale(stealPower)

        puck.I.velocity = puck.I.velocity.add(p)

    else
      # Shot or pass
      if Collision.circular(circle, puck.circle())

        p = Point.fromAngle(heading).scale(power * 2)
        puck.I.velocity = puck.I.velocity.add(p)

    I.shootPower = 0

  lastLeftSkatePos = null
  lastRightSkatePos = null

  drawBloodStreaks = ->
    if (blood = I.blood.face) && rand(2) == 0
      I.blood.face -= 1

      color = Color(BLOOD_COLOR)

      currentPos = self.center()
      (rand(I.blood.face)/3).floor().clamp(1, 8).times ->
        p = currentPos.add(Point.fromAngle(Random.angle()).scale(rand()*rand()*16))

        bloodCanvas.fillCircle(p.x, p.y, (rand(blood/4)*rand()*rand()).clamp(0, 4), color)

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
    I.boost = I.boost.approach(0, 1)
    I.boostCooldown = I.boostCooldown.approach(0, 1)
    I.wipeout = I.wipeout.approach(0, 1)
    I.shootCooldown = I.shootCooldown.approach(0, 1)

    heading = Point.direction(Point(0, 0), I.velocity)

    drawBloodStreaks()

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

    if I.wipeout
      lastLeftSkatePos = null
      lastRightSkatePos = null
    else
      I.color = teamColor

      if !I.shootCooldown && actionDown "A"
        I.shootPower += 1

        chargePhase = Math.sin(Math.TAU/4 * I.age) * 0.2 * I.shootPower / maxShotPower

        I.color = Color(teamColor).lighten(chargePhase)

        if I.shootPower == maxShotPower
          I.shootCooldown = 5
      else if I.shootPower
        I.shootCooldown = 4

        shootPuck()
      else if !I.boostCooldown && actionDown "B"
        I.boostCooldown += 20
        I.boost = 10
        movement = movement.scale(I.boost)

      I.velocity = I.velocity.add(movement)

  self

