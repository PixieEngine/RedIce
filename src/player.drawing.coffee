Player.Drawing = (I, self) ->
  Object.reverseMerge I,
    scale: 1

  assetScale = 0.5

  drawBody = (canvas) ->
    if sprite = I.sprite
      sprite.draw(canvas, -sprite.width / 2, -sprite.height / 2)

  self.unbind 'draw'

  offscreen = ->
    camera = engine.camera()
    delta = I.x - camera.I.x

    if delta.abs() > App.width / 2
      delta.sign()
    else
      0

  drawOffscreenToken = (canvas, sign) ->
    x = (1 + sign) * (App.width / 2) - (sign * 16)
    y = I.y

    center = self.center()
    camera = engine.camera()
    scale = (((App.width / 2) / (I.x - camera.I.x).abs()) / 2) + 0.5

    canvas.withTransform Matrix.translation(x, y), ->
      canvas.withTransform Matrix.scale(scale), ->
        canvas.withTransform Matrix.translation(-center.x, -center.y), ->
          self.drawFloatingNameTag(canvas)

  self.on 'overlay', (canvas) ->
    # Check if off screen
    if sign = offscreen()
      drawOffscreenToken(canvas, sign)

  self.on 'draw', (canvas) ->
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

  self.on 'drawDebug', (canvas) ->
    if I.AI_TARGET
      {x, y} = I.AI_TARGET
      canvas.drawCircle {
        x
        y
        radius: 3
        color: "rgba(255, 255, 0, 1)"
      }

    self.drawControlCircles(canvas)

  self.on 'afterTransform', (canvas) ->
    self.drawPowerMeters(canvas)
    self.drawFloatingNameTag(canvas)

  color: ->
    if I.cpu
      Color(Player.CPU_COLOR)
    else
      # Adjust the lightness of each player's name tag slightly,
      # based on team and team slot
      Color(Player.COLORS[I.team]).lighten((I.slot - 1) * 0.1)

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

  name: ->
    if I.cpu
      "CPU"
    else
      I.name || "P#{(I.id + 1)}"

  drawFloatingNameTag: (canvas) ->
    canvas.font("bold 16px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")

    padding = 6
    lineHeight = 16
    textWidth = canvas.measureText(self.name())

    backgroundColor = self.color()

    yOffset = -32

    center = self.center()

    topLeft = center.subtract(Point(textWidth/2 + padding, lineHeight/2 + padding + yOffset))
    rectWidth = textWidth + 2*padding
    rectHeight = lineHeight + 2*padding

    canvas.drawRoundRect
      color: backgroundColor
      position: topLeft.subtract(Point(2, 2))
      width: rectWidth + 4
      height: rectHeight + 4
      radius: 4

    canvas.drawRoundRect
      color: "#FFF"
      position: topLeft
      width: rectWidth
      height: rectHeight
      radius: 4

    backgroundColor.a = 0.10
    canvas.drawRoundRect
      color: backgroundColor
      position: topLeft
      width: rectWidth
      height: rectHeight
      radius: 4

    canvas.drawText
      text: self.name()
      color: "#000"
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
    if I.shotCharge
      ratio = self.shotChargeRatio()

      center = self.center().floor()

      arrowAnimation = Player.Drawing.shootArrow

      if ratio is 1 # Fully Charged
        arrowAnimation = Player.Drawing.chargedArrow
        canvas.withTransform Matrix.translation(center.x - 5, center.y - 40).scale(0.5), (canvas) ->
          Player.Drawing.chargeAura.rand()?.draw(canvas, -256, -256)

      canvas.withTransform Matrix.translation(center.x, center.y).concat(Matrix.scale(0.125 + ratio * 0.375)).concat(Matrix.rotation(I.movementDirection)), (canvas) ->
        arrowAnimation.wrap((I.age/4).floor()).draw(canvas, -256, -256)

  drawPowerMeters: (canvas) ->
    self.drawTurboMeter(canvas)
    self.drawShootMeter(canvas)

  drawControlCircles: (canvas) ->
    color = self.color().lighten(0.10)
    color.a = 0.25

    self.controlCircles().each (circle) ->
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

Player.Drawing.shootArrow = Sprite.loadSheet("arrow_3", 512, 512)
Player.Drawing.chargedArrow = Sprite.loadSheet("arrow_charged_3", 512, 512)
Player.Drawing.chargeAura = Sprite.loadSheet("charge_aura_strip2", 512, 512)

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
