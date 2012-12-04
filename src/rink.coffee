Rink = (I={}) ->
  Object.reverseMerge I,
    team: config.teams[0]
    spriteSize: 64
    zIndex: WALL_TOP
    x: 0
    y: 0
    width: 0
    height: 0

  iceCanvas = $("<canvas width=#{App.width} height=#{App.height} />")
    .css
      position: "absolute"
      top: 0
      left: 0
    .pixieCanvas()

  perspectiveRatio = 4/3
  perspective = Matrix.scale(1, 1/perspectiveRatio)

  red = "red"
  blue = "blue"
  faceOffSpotRadius = 5
  faceOffCircleRadius = 38
  rinkCornerRadius = Rink.CORNER_RADIUS

  # Draw Arena
  iceCanvas.drawRoundRect
    color: "white"
    x: WALL_LEFT
    y: WALL_TOP
    width: ARENA_WIDTH
    height: ARENA_HEIGHT
    radius: rinkCornerRadius

  # Blue Lines
  for x in [ARENA_WIDTH/3, ARENA_WIDTH*2/3]
    x += WALL_LEFT
    iceCanvas.drawLine
      color: blue
      start: Point(x, WALL_TOP)
      end: Point(x, WALL_BOTTOM)
      width: 4

  # Center Line
  x = WALL_LEFT + ARENA_WIDTH/2
  iceCanvas.drawLine
    color: red
    start: Point(x, WALL_TOP)
    end: Point(x, WALL_BOTTOM)
    width: 2

  iceCanvas.withTransform perspective, ->
    # Center Circle
    x = WALL_LEFT + ARENA_WIDTH/2
    y = WALL_TOP + ARENA_HEIGHT/2
    iceCanvas.drawCircle
      x: x
      y: y * perspectiveRatio
      radius: faceOffSpotRadius
      color: blue

    iceCanvas.drawCircle
      x: x
      y: y * perspectiveRatio
      radius: faceOffCircleRadius
      stroke:
        color: blue
        width: 2

  # Goal Lines
  x = WALL_LEFT + ARENA_WIDTH/10
  iceCanvas.drawLine
    start: Point(x, WALL_TOP)
    end: Point(x, WALL_BOTTOM)
    width: 1
    color: red

  iceCanvas.drawRect
    x: x
    y: WALL_TOP + ARENA_HEIGHT/2 - 16
    width: 16
    height: 32
    stroke:
      color: red

  x = WALL_LEFT + ARENA_WIDTH*9/10
  iceCanvas.drawLine
    start: Point(x, WALL_TOP)
    end: Point(x, WALL_BOTTOM)
    width: 1
    color: red

  iceCanvas.drawRect
    x: x - 16
    y: WALL_TOP + ARENA_HEIGHT/2 - 16
    width: 16
    height: 32
    stroke:
      color: red

  iceCanvas.withTransform perspective, ->
    [1, 3].each (verticalQuarter) ->
      y = WALL_TOP + verticalQuarter/4 * ARENA_HEIGHT

      [1/5, 1/3 + 1/40, 2/3 - 1/40, 4/5].each (faceOffX, i) ->
        x = WALL_LEFT + faceOffX * ARENA_WIDTH

        iceCanvas.drawCircle
          x: x
          y: y * perspectiveRatio
          radius: faceOffSpotRadius
          color: red

        if i == 0 || i == 3
          iceCanvas.drawCircle
            x: x
            y: y * perspectiveRatio
            radius: faceOffCircleRadius
            stroke:
              color: red
              width: 2

  spriteSize = 64

  backBoardsCanvas = $("<canvas width=#{App.width} height=#{App.height} />")
    .css
      position: "absolute"
      top: 0
      left: 0
    .pixieCanvas()

  Sprite.loadSheet "#{I.team}/wall_n", 512, 512, 0.125, (sprites) ->
    sprite = sprites[0]
    backBoardsCanvas.withTransform Matrix.translation(WALL_LEFT + 128, WALL_TOP - 64), ->
      sprite.fill(backBoardsCanvas, 0, 0, I.spriteSize * 12, I.spriteSize)

  Sprite.loadSheet "#{I.team}/wall_nw", 1024, 1024, 0.125, (sprites) ->
    sprite = sprites[0]
    backBoardsCanvas.withTransform Matrix.translation(WALL_LEFT, WALL_TOP - 64), ->
      sprite.draw(backBoardsCanvas, 0, 0)

  Sprite.loadSheet "#{I.team}/wall_nw", 1024, 1024, 0.125, (sprites) ->
    sprite = sprites[0]
    backBoardsCanvas.withTransform Matrix.translation(WALL_RIGHT, WALL_TOP - 64), ->
      backBoardsCanvas.withTransform Matrix.scale(-1, 1), ->
        sprite.draw(backBoardsCanvas, 0, 0)

  frontBoardsCanvas = $("<canvas width=#{App.width} height=#{App.height} />")
    .css
      position: "absolute"
      top: 0
      left: 0
    .pixieCanvas()

  Sprite.loadSheet "#{I.team}/wall_sw", 1024, 1024, 0.125, (sprites) ->
    sprite = sprites[0]
    frontBoardsCanvas.withTransform Matrix.translation(WALL_LEFT, WALL_BOTTOM - 112), ->
      sprite.draw(frontBoardsCanvas, 0, 0)

  Sprite.loadSheet "#{I.team}/wall_sw", 1024, 1024, 0.125, (sprites) ->
    sprite = sprites[0]
    frontBoardsCanvas.withTransform Matrix.translation(WALL_RIGHT, WALL_BOTTOM - 112), ->
      frontBoardsCanvas.withTransform Matrix.scale(-1, 1), ->
        sprite.draw(frontBoardsCanvas, 0, 0)

  Sprite.loadSheet "#{I.team}/wall_s", 512, 512, 0.125, (sprites) ->
    sprite = sprites[0]
    frontBoardsCanvas.withTransform Matrix.translation(WALL_LEFT + 128, WALL_BOTTOM - 48), ->
      sprite.fill(frontBoardsCanvas, 0, 0, I.spriteSize * 12, I.spriteSize)

  Sprite.loadSheet "norm_wall_w", 512, 512, 0.125, (sprites) ->
    sprite = sprites[0]
    frontBoardsCanvas.withTransform Matrix.translation(WALL_LEFT, WALL_TOP + 96), (canvas) ->
      sprite.fill(canvas, -I.spriteSize/2, -I.spriteSize/2, I.spriteSize, I.spriteSize * 6)

    frontBoardsCanvas.withTransform Matrix.translation(WALL_RIGHT, WALL_TOP + 96), (canvas) ->
      canvas.withTransform Matrix.scale(-1, 1), ->
        sprite.fill(canvas, -I.spriteSize/2, -I.spriteSize/2, I.spriteSize, I.spriteSize * 6)

  paintCanvas = (sprite, canvas, x, y) ->
    if sprite
      sprite.draw(canvas, x - sprite.width / 2, y - sprite.height / 2)

  self = GameObject(I).extend
    paintFrontWall: ({sprite, x, y}) ->
      frontBoardsCanvas.globalCompositeOperation "destination-over"
      paintCanvas(sprite, frontBoardsCanvas, x, y)
      frontBoardsCanvas.globalCompositeOperation "source-over"

    paintBackWall: ({sprite, x, y}) ->
      paintCanvas(sprite, backBoardsCanvas, x, y)

    draw: (canvas) ->
      canvas.context().drawImage(backBoardsCanvas.element(), 0, 0)

    drawFront: (canvas) ->
      canvas.context().drawImage(frontBoardsCanvas.element(), 0, 0)

  self.bind "beforeDraw", (canvas) ->
    Fan.crowd.invoke("draw", canvas)
    canvas.context().drawImage(iceCanvas.element(), 0, 0)
    canvas.context().drawImage(bloodCanvas.element(), 0, 0)

  self.bind "create", ->
    # Draw the front Rink Boards at the correct zIndex
    engine.add
      class: "RinkBoardsProxy"
      rink: self

  self.include Rink.Physics

  return self

Rink.CORNER_RADIUS = 96
