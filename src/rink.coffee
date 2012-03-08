Rink = (I={}) ->
  Object.reverseMerge I,
    team: "smiley"
    spriteSize: 64

  canvas = $("<canvas width=#{CANVAS_WIDTH} height=#{CANVAS_HEIGHT} />")
    .appendTo("body")
    .css
      position: "absolute"
      top: 0
      left: 0
      zIndex: "-10"
    .pixieCanvas()

  red = "red"
  blue = "blue"
  faceOffSpotRadius = 5
  faceOffCircleRadius = 38
  rinkCornerRadius = Rink.CORNER_RADIUS

  # Draw Arena
  canvas.drawRoundRect
    color: "white"
    x: WALL_LEFT
    y: WALL_TOP
    width: ARENA_WIDTH
    height: ARENA_HEIGHT
    radius: rinkCornerRadius

  # Blue Lines
  for x in [ARENA_WIDTH/3, ARENA_WIDTH*2/3]
    x += WALL_LEFT
    canvas.drawLine
      color: blue
      start: Point(x, WALL_TOP)
      end: Point(x, WALL_BOTTOM)
      width: 4

  # Center Line
  x = WALL_LEFT + ARENA_WIDTH/2
  canvas.drawLine
    color: red
    start: Point(x, WALL_TOP)
    end: Point(x, WALL_BOTTOM)
    width: 2

  # Center Circle
  x = WALL_LEFT + ARENA_WIDTH/2
  y = WALL_TOP + ARENA_HEIGHT/2
  canvas.drawCircle
    x: x 
    y: y
    radius: faceOffSpotRadius
    color: blue

  canvas.drawCircle
    x: x 
    y: y
    radius: faceOffCircleRadius
    stroke:
      color: blue
      width: 2

  # Goal Lines
  x = WALL_LEFT + ARENA_WIDTH/10
  canvas.drawLine
    start: Point(x, WALL_TOP)
    end: Point(x, WALL_BOTTOM)
    width: 1
    color: red

  canvas.drawRect
    x: x
    y: WALL_TOP + ARENA_HEIGHT/2 - 16
    width: 16
    height: 32
    stroke:
      color: red

  x = WALL_LEFT + ARENA_WIDTH*9/10
  canvas.drawLine
    start: Point(x, WALL_TOP)
    end: Point(x, WALL_BOTTOM)
    width: 1
    color: red

  canvas.drawRect
    x: x - 16
    y: WALL_TOP + ARENA_HEIGHT/2 - 16
    width: 16
    height: 32
    stroke:
      color: red

  [1, 3].each (verticalQuarter) ->
    y = WALL_TOP + verticalQuarter/4 * ARENA_HEIGHT

    [1/5, 1/3 + 1/40, 2/3 - 1/40, 4/5].each (faceOffX, i) ->
      x = WALL_LEFT + faceOffX * ARENA_WIDTH

      canvas.drawCircle
        x: x
        y: y
        radius: faceOffSpotRadius
        color: red

      if i == 0 || i == 3
        canvas.drawCircle
          x: x
          y: y
          radius: faceOffCircleRadius
          stroke:
            color: red
            width: 2

  fansSprite = Sprite.loadByName "fans", ->
    fansSprite.fill(canvas, 0, 0, App.width, WALL_TOP)

  spriteSize = 64

  backBoardsCanvas = $("<canvas width=#{CANVAS_WIDTH} height=#{CANVAS_HEIGHT} />")
    .appendTo("body")
    .css
      position: "absolute"
      top: 0
      left: 0
      zIndex: "-4"
    .pixieCanvas()

  Sprite.loadByName "#{I.spriteSize}/#{I.team}_wall_n", (sprite) ->
    backBoardsCanvas.withTransform Matrix.translation(WALL_LEFT + 128, WALL_TOP - 64), ->
      sprite.fill(backBoardsCanvas, 0, 0, I.spriteSize * 12, I.spriteSize)

  Sprite.loadByName "#{I.spriteSize}/#{I.team}_wall_nw", (sprite) ->
    backBoardsCanvas.withTransform Matrix.translation(WALL_LEFT, WALL_TOP - 64), ->
      sprite.draw(backBoardsCanvas, 0, 0)

  Sprite.loadByName "#{I.spriteSize}/#{I.team}_wall_nw", (sprite) ->
    backBoardsCanvas.withTransform Matrix.translation(WALL_RIGHT, WALL_TOP - 64), ->
      backBoardsCanvas.withTransform Matrix.scale(-1, 1), ->
        sprite.draw(backBoardsCanvas, 0, 0)

  frontBoardsCanvas = $("<canvas width=#{CANVAS_WIDTH} height=#{CANVAS_HEIGHT} />")
    .appendTo("body")
    .css
      position: "absolute"
      top: 0
      left: 0
      zIndex: "1"
    .pixieCanvas()

  Sprite.loadByName "#{I.spriteSize}/#{I.team}_wall_sw", (sprite) ->
    frontBoardsCanvas.withTransform Matrix.translation(WALL_LEFT, WALL_BOTTOM - 112), ->
      sprite.draw(frontBoardsCanvas, 0, 0)

  Sprite.loadByName "#{I.spriteSize}/#{I.team}_wall_sw", (sprite) ->
    frontBoardsCanvas.withTransform Matrix.translation(WALL_RIGHT, WALL_BOTTOM - 112), ->
      frontBoardsCanvas.withTransform Matrix.scale(-1, 1), ->
        sprite.draw(frontBoardsCanvas, 0, 0)

  Sprite.loadByName "#{I.spriteSize}/#{I.team}_wall_s", (sprite) ->
    frontBoardsCanvas.withTransform Matrix.translation(WALL_LEFT + 128, WALL_BOTTOM - 48), ->
      sprite.fill(frontBoardsCanvas, 0, 0, I.spriteSize * 12, I.spriteSize)

  Sprite.loadByName "#{I.spriteSize}/norm_wall_w", (sprite) ->
    frontBoardsCanvas.withTransform Matrix.translation(WALL_LEFT, WALL_TOP + 96), (canvas) ->
      sprite.fill(canvas, -I.spriteSize/2, -I.spriteSize/2, I.spriteSize, I.spriteSize * 6)

    frontBoardsCanvas.withTransform Matrix.translation(WALL_RIGHT, WALL_TOP + 96), (canvas) ->
      canvas.withTransform Matrix.scale(-1, 1), ->
        sprite.fill(canvas, -I.spriteSize/2, -I.spriteSize/2, I.spriteSize, I.spriteSize * 6)

  return {
    show: ->
      [canvas, frontBoardsCanvas, backBoardsCanvas].each (c) ->
        $(c.element).show()
    hide: ->
      [canvas, frontBoardsCanvas, backBoardsCanvas].each (c) ->
        $(c.element).hide()
  }

Rink.CORNER_RADIUS = 96

