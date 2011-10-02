PlayerDrawing = (I, self) ->

  lastLeftSkatePos = null
  lastRightSkatePos = null

  leftSkatePos: ->
    p = Point.fromAngle(I.heading - Math.TAU/4).scale(5)

    self.center().add(p)

  rightSkatePos: ->
    p = Point.fromAngle(I.heading + Math.TAU/4).scale(5)

    self.center().add(p)

  drawBloodStreaks: ->
    if (blood = I.blood.face) && rand(2) == 0
      color = Color(BLOOD_COLOR)

      currentPos = self.center()
      (rand(blood)/3).floor().clamp(0, 2).times ->
        I.blood.face -= 1
        p = currentPos.add(Point.fromAngle(Random.angle()).scale(rand()*rand()*16))

        bloodCanvas.fillCircle(p.x, p.y, (rand(5)*rand()*rand()).clamp(0, 3), color)

    if I.wipeout # Body blood streaks

    else # Skate blood streaks
      currentLeftSkatePos = self.leftSkatePos()
      currentRightSkatePos = self.rightSkatePos()

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

  drawShadow: (canvas) ->
    base = self.center().add(0, I.height/2 + 4)

    canvas.withTransform Matrix.scale(1, -0.5, base), ->
      shadowColor = "rgba(0, 0, 0, 0.15)"
      canvas.fillCircle(base.x - 4, base.y + 16, 16, shadowColor)
      canvas.fillCircle(base.x, base.y + 8, 16, shadowColor)
      canvas.fillCircle(base.x + 4, base.y + 16, 16, shadowColor)

  drawFloatingNameTag: (canvas) ->
    if I.cpu
      name = "CPU"
    else
      name = I.name || "P#{(I.id + 1)}"

    padding = 6
    lineHeight = 16
    textWidth = canvas.measureText(name)

    backgroundColor = self.color()
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

  drawPowerMeters: (canvas) ->
    ratio = (I.boostMeter - I.cooldown.boost) / I.boostMeter
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

      ratio = Math.min(I.shootPower / I.maxShotPower, 1)
      superChargeRatio = ((I.shootPower - I.maxShotPower) / I.maxShotPower).clamp(0, 1)

      center = self.center().floor()
      canvas.withTransform Matrix.translation(center.x, center.y).concat(Matrix.rotation(I.movementDirection)), ->
        # Fill background
        canvas.fillColor("#000")
        canvas.fillRoundRect(-(padding + height)/2, -padding, maxWidth + 2*padding, height, 2)

        # Fill Power meter
        canvas.fillColor("#EE0")
        canvas.fillRoundRect(-height/2, 0, maxWidth * ratio, height, 2)

        # Fill Super Meter
        canvas.fillColor("#0EF")
        if superChargeRatio == 1
          if (I.age/2).floor() % 2
            canvas.fillRoundRect(-height/2, 0, maxWidth, height, 2)
        else if superChargeRatio > 0
          canvas.fillRoundRect(-height/2, 0, maxWidth * superChargeRatio, height, 2)

  drawControlCircle: (canvas) ->
    color = self.color().lighten(0.10)
    color.a "0.25"

    circle = self.controlCircle()

    canvas.fillCircle(circle.x, circle.y, circle.radius, color)
