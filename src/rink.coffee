Rink = (I={}) ->
  Object.reverseMerge I,
    team: config.teams[0]
    spriteSize: 64
    x: 0
    y: 0
    width: 0
    height: 0
    wallLeft: WALL_LEFT
    wallRight: WALL_RIGHT
    wallTop: WALL_TOP
    wallBottom: WALL_BOTTOM

  I.zIndex = I.wallTop

  arenaWidth = ->
    I.wallRight - I.wallLeft

  arenaHeight = ->
    I.wallBottom - I.wallTop

  iceCanvas = $("<canvas width=#{App.width} height=#{App.height} />")
    .css
      position: "absolute"
      top: 0
      left: 0
    .pixieCanvas()

  perspectiveRatio = PERSPECTIVE_RATIO
  perspective = Matrix.scale(1, 1/perspectiveRatio)

  red = "red"
  blue = "blue"
  faceOffSpotRadius = 5
  faceOffCircleRadius = 38
  rinkCornerRadius = Rink.CORNER_RADIUS

  # Draw Arena
  iceCanvas.drawRoundRect
    color: "white"
    x: I.wallLeft
    y: I.wallTop
    width: arenaWidth()
    height: arenaHeight()
    radius: rinkCornerRadius

  # Blue Lines
  for x in [arenaWidth()/3, arenaWidth()*2/3]
    x += I.wallLeft
    iceCanvas.drawLine
      color: blue
      start: Point(x, I.wallTop)
      end: Point(x, I.wallBottom)
      width: 4

  # Center Line
  x = I.wallLeft + arenaWidth()/2
  iceCanvas.drawLine
    color: red
    start: Point(x, I.wallTop)
    end: Point(x, I.wallBottom)
    width: 2

  iceCanvas.withTransform perspective, ->
    # Center Circle
    x = I.wallLeft + arenaWidth()/2
    y = I.wallTop + arenaHeight()/2
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
  x = I.wallLeft + arenaWidth()/10
  iceCanvas.drawLine
    start: Point(x, I.wallTop)
    end: Point(x, I.wallBottom)
    width: 1
    color: red

  iceCanvas.drawRect
    x: x
    y: I.wallTop + arenaHeight()/2 - 16
    width: 16
    height: 32
    stroke:
      color: red

  x = I.wallLeft + arenaWidth()*9/10
  iceCanvas.drawLine
    start: Point(x, I.wallTop)
    end: Point(x, I.wallBottom)
    width: 1
    color: red

  iceCanvas.drawRect
    x: x - 16
    y: I.wallTop + arenaHeight()/2 - 16
    width: 16
    height: 32
    stroke:
      color: red

  iceCanvas.withTransform perspective, ->
    [1, 3].each (verticalQuarter) ->
      y = I.wallTop + verticalQuarter/4 * arenaHeight()

      [1/5, 1/3 + 1/40, 2/3 - 1/40, 4/5].each (faceOffX, i) ->
        x = I.wallLeft + faceOffX * arenaWidth()

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

  spriteScale = 0.125

  backBoardsCanvas = $("<canvas width=#{App.width} height=#{App.height} />")
    .css
      position: "absolute"
      top: 0
      left: 0
    .pixieCanvas()

  Sprite.loadSheet "#{I.team}/wall_n", 512, 512, spriteScale, (sprites) ->
    sprite = sprites[0]
    backBoardsCanvas.withTransform Matrix.translation(I.wallLeft + 2 * I.spriteSize, I.wallTop - I.spriteSize), ->
      sprite.fill(backBoardsCanvas, 0, 0, I.spriteSize * 12, I.spriteSize)

  Sprite.loadSheet "#{I.team}/wall_nw", 1024, 1024, spriteScale, (sprites) ->
    sprite = sprites[0]
    backBoardsCanvas.withTransform Matrix.translation(I.wallLeft, I.wallTop - I.spriteSize), ->
      sprite.draw(backBoardsCanvas, 0, 0)

  Sprite.loadSheet "#{I.team}/wall_nw", 1024, 1024, spriteScale, (sprites) ->
    sprite = sprites[0]
    backBoardsCanvas.withTransform Matrix.translation(I.wallRight, I.wallTop - I.spriteSize), ->
      backBoardsCanvas.withTransform Matrix.scale(-1, 1), ->
        sprite.draw(backBoardsCanvas, 0, 0)

  frontBoardsCanvas = $("<canvas width=#{App.width} height=#{App.height} />")
    .css
      position: "absolute"
      top: 0
      left: 0
    .pixieCanvas()

  Sprite.loadSheet "#{I.team}/wall_sw", 1024, 1024, spriteScale, (sprites) ->
    sprite = sprites[0]
    frontBoardsCanvas.withTransform Matrix.translation(I.wallLeft, I.wallBottom - 112), ->
      sprite.draw(frontBoardsCanvas, 0, 0)

  Sprite.loadSheet "#{I.team}/wall_sw", 1024, 1024, spriteScale, (sprites) ->
    sprite = sprites[0]
    frontBoardsCanvas.withTransform Matrix.translation(I.wallRight, I.wallBottom - 112), ->
      frontBoardsCanvas.withTransform Matrix.scale(-1, 1), ->
        sprite.draw(frontBoardsCanvas, 0, 0)

  Sprite.loadSheet "#{I.team}/wall_s", 512, 512, spriteScale, (sprites) ->
    sprite = sprites[0]
    frontBoardsCanvas.withTransform Matrix.translation(I.wallLeft + I.spriteSize * 2, I.wallBottom - 48), ->
      sprite.fill(frontBoardsCanvas, 0, 0, I.spriteSize * 12, I.spriteSize)

  Sprite.loadSheet "#{I.team}/wall_w", 512, 512, spriteScale, (sprites) ->
    sprite = sprites[0]
    frontBoardsCanvas.withTransform Matrix.translation(I.wallLeft, I.wallTop + 96), (canvas) ->
      sprite.fill(canvas, -I.spriteSize/2, -I.spriteSize/2, I.spriteSize, I.spriteSize * 6)

    frontBoardsCanvas.withTransform Matrix.translation(I.wallRight, I.wallTop + 96), (canvas) ->
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
      zIndex: I.wallBottom

  self.include Rink.Physics

  return self

Rink.CORNER_RADIUS = 96
