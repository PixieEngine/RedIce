Rink = (I) ->
  I ||= {}

  canvas = $("<canvas width=#{CANVAS_WIDTH} height=#{CANVAS_HEIGHT} />")
    .appendTo("body")
    .css
      position: "absolute"
      top: 0
      left: 0
      zIndex: "-2"
    .powerCanvas()

  red = "red"
  blue = "blue"
  faceOffSpotRadius = 5
  faceOffCircleRadius = 38
  rinkCornerRadius = Rink.CORNER_RADIUS

  # Draw Arena
  canvas.fillColor("white")
  canvas.strokeColor("#888")
  canvas.fillRoundRect(WALL_LEFT, WALL_TOP, ARENA_WIDTH, ARENA_HEIGHT, rinkCornerRadius)

  # Blue Lines
  canvas.strokeColor(blue)
  x = WALL_LEFT + ARENA_WIDTH/3
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 4)
  x = WALL_LEFT + ARENA_WIDTH*2/3
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 4)

  # Center Line
  canvas.strokeColor(red)
  x = WALL_LEFT + ARENA_WIDTH/2
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 2)

  # Center Circle
  x = WALL_LEFT + ARENA_WIDTH/2
  y = WALL_TOP + ARENA_HEIGHT/2
  canvas.fillCircle(x, y, faceOffSpotRadius, blue)
  canvas.context().lineWidth = 2
  canvas.strokeCircle(x, y, faceOffCircleRadius, blue)

  # Goal Lines
  canvas.strokeColor(red)
  x = WALL_LEFT + ARENA_WIDTH/10
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 1)
  canvas.strokeRect(x, WALL_TOP + ARENA_HEIGHT/2 - 16, 16, 32)
  x = WALL_LEFT + ARENA_WIDTH*9/10
  canvas.drawLine(x, WALL_TOP, x, WALL_BOTTOM, 1)
  canvas.strokeRect(x - 16, WALL_TOP + ARENA_HEIGHT/2 - 16, 16, 32)

  [1, 3].each (verticalQuarter) ->
    y = WALL_TOP + verticalQuarter/4 * ARENA_HEIGHT

    [1/5, 1/3 + 1/40, 2/3 - 1/40, 4/5].each (faceOffX, i) ->
      x = WALL_LEFT + faceOffX * ARENA_WIDTH

      canvas.fillCircle(x, y, faceOffSpotRadius, red)
      if i == 0 || i == 3
        canvas.context().lineWidth = 2
        canvas.strokeCircle(x, y, faceOffCircleRadius, red)

  fansSprite = Sprite.loadByName "fans", ->
    fansSprite.fill(canvas, 0, 0, App.width, WALL_TOP)

Rink.CORNER_RADIUS = 96

