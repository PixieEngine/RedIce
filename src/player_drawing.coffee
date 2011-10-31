PlayerDrawing = (I, self) ->
  Object.reverseMerge I,
    scale: 1

  self.unbind 'draw'

  self.bind 'draw', (canvas) ->
    if sprite = I.sprite
      if sprite.draw? 
        sprite.draw(canvas, -sprite.width / 2, -sprite.height / 2)
      else
        warn?("Sprite has no draw method!")
    else
      if I.radius?
        canvas.drawCircle
          x: 0
          y: 0
          radius: I.radius
          color: I.color
      else
        canvas.drawRect
          x: -I.width/2
          y: -I.height/2
          width: I.width
          height: I.height
          color: I.color

  self.bind 'drawDebug', (canvas) ->
    if I.AI_TARGET
      {x, y} = I.AI_TARGET
      canvas.drawCircle {
        x
        y
        radius: 3
        color: "rgba(255, 255, 0, 1)"
      }

    drawControlCircle(canvas)

  I.lastLeftSkatePos = null
  I.lastRightSkatePos = null

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

        bloodCanvas.drawCircle
          position: p
          radius: (rand(5)*rand()*rand()).clamp(0, 3)
          color: color

    if I.wipeout # Body blood streaks

    else # Skate blood streaks
      currentLeftSkatePos = self.leftSkatePos()
      currentRightSkatePos = self.rightSkatePos()

      # Skip certain feet
      cycle = I.age % 30
      if 1 < cycle < 14
        I.lastLeftSkatePos = null
      if 15 < cycle < 29 
        I.lastRightSkatePos = null

      if I.lastLeftSkatePos
        if skateBlood = I.blood.leftSkate
          I.blood.leftSkate -= 1

          color = BLOOD_COLOR
          thickness = (skateBlood/30).clamp(0, 1.5)
        else
          color = ICE_COLOR
          thickness = 1

        bloodCanvas.drawLine
          start: I.lastLeftSkatePos
          end: currentLeftSkatePos
          width: thickness
          color: color

      if I.lastRightSkatePos 
        if skateBlood = I.blood.rightSkate
          I.blood.rightSkate -= 1

          color = BLOOD_COLOR
          thickness = (skateBlood/30).clamp(0, 1.5)
        else
          color = ICE_COLOR
          thickness = 1

        bloodCanvas.strokeColor(color)        
        bloodCanvas.drawLine
          start: I.lastRightSkatePos
          end: currentRightSkatePos
          width: thickness
          color: color

      I.lastLeftSkatePos = currentLeftSkatePos
      I.lastRightSkatePos = currentRightSkatePos

  drawShadow: (canvas) ->
    base = self.center().add(0, I.height/2 + 4)

    canvas.withTransform Matrix.scale(1, -0.5, base), ->
      shadowColor = "rgba(0, 0, 0, 0.15)"
      for [x, y] in [[-4, 16], [0, 8], [4, 16]]
        canvas.drawCircle
          x: base.x + x
          y: base.y + y
          radius: 16
          color: shadowColor

  drawFloatingNameTag: (canvas) ->
    if I.cpu
      name = "CPU"
    else
      name = I.name || "P#{(I.id + 1)}"

    padding = 6
    lineHeight = 16
    textWidth = canvas.measureText(name)

    backgroundColor = self.color()
    backgroundColor.a = 0.5

    yOffset = 48

    center = self.center()

    topLeft = center.subtract(Point(textWidth/2 + padding, lineHeight/2 + padding + yOffset))
    rectWidth = textWidth + 2*padding
    rectHeight = lineHeight + 2*padding

    canvas.drawRoundRect
      color: backgroundColor
      position: topLeft
      width: rectWidth
      height: rectHeight
      radius: 4

    canvas.drawText
      text: name
      color: "#FFF"
      x: topLeft.x + padding
      y: topLeft.y + lineHeight + padding/2

  drawPowerMeters: (canvas) ->
    ratio = (I.boostMeter - I.cooldown.boost) / I.boostMeter
    start = self.position().add(Point(0, I.height)).floor()
    padding = 1
    maxWidth = I.width
    height = 3

    canvas.drawRoundRect
      color: "#000"
      x: start.x - padding
      y: start.y - padding 
      width: maxWidth + 2*padding
      height: height + 2*padding
      radius: 2

    if I.cooldown.boost == 0
      color = "#0F0"
    else
      color = "#080"

    canvas.drawRoundRect {
      color
      position: start
      width: maxWidth * ratio
      height
      radius: 2
    }

    if I.shootPower
      maxWidth = 40
      height = 5

      ratio = Math.min(I.shootPower / I.maxShotPower, 1)
      superChargeRatio = ((I.shootPower - I.maxShotPower) / I.maxShotPower).clamp(0, 1)

      center = self.center().floor()
      canvas.withTransform Matrix.translation(center.x, center.y).concat(Matrix.rotation(I.movementDirection)), ->
        # Fill background
        canvas.drawRoundRect {
          color: "#000"
          x: -(padding + height)/2
          y: -padding
          width: maxWidth + 2*padding
          height
          radius: 2
        }

        # Fill Power meter
        canvas.drawRoundRect {
          color: "#EE0"
          x: -height/2
          y: 0
          width: maxWidth * ratio
          height
          radius: 2
        }

        # Fill Super Meter
        color = "#0EF"
        if superChargeRatio == 1
          if (I.age/2).floor() % 2
            canvas.drawRoundRect {
              color
              x: -height/2
              y: 0
              width: maxWidth
              height
              radius: 2
            }
        else if superChargeRatio > 0
          canvas.drawRoundRect {
            color
            x: -height/2
            y: 0
            width: maxWidth * superChargeRatio
            height
            radius: 2
          }

  drawControlCircle: (canvas) ->
    color = self.color().lighten(0.10)
    color.a "0.25"

    circle = self.controlCircle()

    canvas.drawCircle {
      circle
      color
    }

  transform: ->
    center = self.center()

    transform = Matrix.translation(center.x, center.y)

    transform = transform.concat(Matrix.rotation(I.rotation)) if I.rotation
    transform = transform.concat(Matrix.HORIZONTAL_FLIP) if I.hflip
    transform = transform.concat(Matrix.VERTICAL_FLIP) if I.vflip
    transform = transform.concat(Matrix.scale(I.scale))

    if I.spriteOffset
      transform = transform.concat(Matrix.translation(I.spriteOffset.x, I.spriteOffset.y))

    return transform
