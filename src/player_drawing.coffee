PlayerDrawing = (I, self) ->
  Object.reverseMerge I,
    scale: 1

  assetScale = 0.5

  drawBody = (canvas) ->
    if sprite = I.sprite
      sprite.draw(canvas, -sprite.width / 2, -sprite.height / 2)

  self.unbind 'draw'

  self.bind 'draw', (canvas) ->
    if frameData = self.frameData()
      headOffset = Point(frameData.head.x, frameData.head.y)
      headRotation = frameData.head.rotation
      headScale = frameData.head.scale
    else
      headOffset = Point(32, -64).add(Point(3 * Math.sin(I.age * Math.TAU / 31), 2 * Math.cos(I.age * Math.TAU / 27)))
      headRotation = 0
      headScale = 0.75

    drawHead = (canvas) ->
      canvas.withTransform Matrix.translation(currentHeadOffset.x, currentHeadOffset.y), (canvas) ->
        if headSprite = I.headSprite
          canvas.withTransform Matrix.scale(headScale).rotate(headRotation), (canvas) ->
            if I.headFlip
              canvas.withTransform Matrix.HORIZONTAL_FLIP, (canvas) ->
                headSprite.draw(canvas, -headSprite.width / 2, -headSprite.height / 2)
            else
              headSprite.draw(canvas, -headSprite.width / 2, -headSprite.height / 2)

    t = Matrix.IDENTITY
    if I.hflip
      t = Matrix.HORIZONTAL_FLIP
      headRotation = -headRotation

    currentHeadOffset = t.transformPoint(headOffset.scale(assetScale))

    # Sprite Offset
    canvas.withTransform Matrix.translation(0, -32), ->
      drawHead(canvas) if I.facing == "back"
      canvas.withTransform t, drawBody
      drawHead(canvas) if I.facing == "front"

  self.bind 'drawDebug', (canvas) ->
    if I.AI_TARGET
      {x, y} = I.AI_TARGET
      canvas.drawCircle {
        x
        y
        radius: 3
        color: "rgba(255, 255, 0, 1)"
      }

    self.drawControlCircle(canvas)

  self.bind 'afterTransform', (canvas) ->
    self.drawPowerMeters(canvas)
    self.drawFloatingNameTag(canvas)

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
    canvas.font("bold 16px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")

    if I.cpu
      name = "CPU"
    else
      name = I.name || "P#{(I.id + 1)}"

    padding = 6
    lineHeight = 16
    textWidth = canvas.measureText(name)

    backgroundColor = self.color()
    backgroundColor.a = 0.5

    yOffset = -32

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

  drawTurboMeter: (canvas) ->
    ratio = (I.boostMeter - I.cooldown.boost) / I.boostMeter
    padding = 1.25
    maxWidth = 48
    height = 4

    center = self.center()
    start = center.add(Point(-maxWidth/2, 8))

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

  drawShootMeter: (canvas) ->
    if I.shootPower
      ratio = Math.min(I.shootPower / I.maxShotPower, 1)
      superChargeRatio = ((I.shootPower - I.maxShotPower) / I.maxShotPower).clamp(0, 1)
      center = self.center().floor()

      arrowAnimation = PlayerDrawing.shootArrow

      if superChargeRatio is 1
        arrowAnimation = PlayerDrawing.chargedArrow
        canvas.withTransform Matrix.translation(center.x - 5, center.y - 40).scale(0.375), (canvas) ->
          PlayerDrawing.chargeAura.rand()?.draw(canvas, -256, -256)

      canvas.withTransform Matrix.translation(center.x, center.y).concat(Matrix.scale(0.125 + ratio * 0.375)).concat(Matrix.rotation(I.movementDirection)), (canvas) ->
        arrowAnimation.wrap((I.age/4).floor()).draw(canvas, -256, -256)

  drawPowerMeters: (canvas) ->
    self.drawTurboMeter(canvas)
    self.drawShootMeter(canvas)

  drawControlCircle: (canvas) ->
    color = self.color().lighten(0.10)
    color.a = 0.25

    circle = self.controlCircle()

    canvas.drawCircle {
      circle
      color
    }

  transform: ->
    center = self.center()

    transform = Matrix.translation(center.x, center.y)

    transform = transform.concat(Matrix.rotation(I.rotation)) if I.rotation
    transform = transform.concat(Matrix.scale(I.scale))

    if I.spriteOffset
      transform = transform.concat(Matrix.translation(I.spriteOffset.x, I.spriteOffset.y))

    return transform

PlayerDrawing.shootArrow = Sprite.loadSheet("arrow_3", 512, 512)
PlayerDrawing.chargedArrow = Sprite.loadSheet("arrow_charged_3", 512, 512)
PlayerDrawing.chargeAura = Sprite.loadSheet("charge_aura_strip2", 512, 512)

