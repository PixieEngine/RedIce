Player = (I) ->
  $.reverseMerge I,
    boost: 0
    boostCooldown: 0
    collisionMargin: Point(2, 2)
    controller: 0
    falls: 0
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
    wipeout: 0
    velocity: Point()
    zIndex: 1

  PLAYER_COLORS = [
    "#00F"
    "#F00"
    "#0F0"
    "#FF0"
    "#FFA500"
    "#F0F"
    "#0FF"
  ]

  I.color = PLAYER_COLORS[I.controller]
  actionDown = CONTROLLERS[I.controller].actionDown

  heading = 0

  self = GameObject(I).extend
    bloody: ->
      if I.wipeout
        I.blood.body += rand(5)
      else
        I.blood.leftSkate += rand(10)
        I.blood.rightSkate += rand(10)

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
      I.falls += 1
      I.color = Color(PLAYER_COLORS[I.controller]).lighten(0.25)
      I.wipeout = 25
      I.blood.face += rand(20) + rand(20) + rand(20) + I.falls * 3

      push = push.scale(15)

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

  lastLeftSkatePos = null
  lastRightSkatePos = null

  drawBloodStreaks = ->

    heading = Point.direction(Point(0, 0), I.velocity)

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

    if !I.boostCooldown && actionDown "B"
      I.boostCooldown += 20
      I.boost = 10
      movement = movement.scale(I.boost)

    if I.wipeout
      lastLeftSkatePos = null
      lastRightSkatePos = null
    else
      I.color = PLAYER_COLORS[I.controller]
      I.velocity = I.velocity.add(movement).scale(0.9)

    I.x += I.velocity.x
    I.y += I.velocity.y

  self
