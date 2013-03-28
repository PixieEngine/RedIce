Rink = (I={}) ->
  Object.reverseMerge I,
    decals: true
    lines: true
    team: config.homeTeam # Default team
    spriteSize: 128
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

  arenaCenter = ->
    Point(arenaWidth(), arenaHeight()).scale(0.5).add(Point(I.wallLeft, I.wallTop))

  sideWallWidth = 12
  wallBottomBuffer = I.spriteSize / 4
  bufferCanvasWidth = App.width * 2

  iceCanvas = $("<canvas width=#{bufferCanvasWidth} height=#{App.height} />")
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
  faceOffCircleRadius = I.spriteSize
  rinkCornerRadius = I.cornerRadius = I.spriteSize

  drawDecals = ->
    style = I.team
    {x, y} = arenaCenter()

    iceCanvas.context().globalAlpha = 0.9

    iceCanvas.withTransform perspective, ->
      sprite = Configurator.images[style].logo
      sprite.draw(iceCanvas, x - sprite.width/2, (y * PERSPECTIVE_RATIO) - sprite.width/2)

    iceCanvas.context().globalAlpha = 1

  # Draw Arena
  iceCanvas.drawRoundRect
    color: "white"
    x: I.wallLeft
    y: I.wallTop
    width: arenaWidth()
    height: arenaHeight()
    radius: rinkCornerRadius

  drawDecals() if I.decals

  drawLines = ->
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
          width: 4

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
                width: 4

  drawLines() if I.lines

  spriteScale = 0.5
  spriteSize = 256

  backBoardsCanvas = $("<canvas width=#{bufferCanvasWidth} height=#{App.height} />")
    .css
      position: "absolute"
      top: 0
      left: 0
    .pixieCanvas()

  Sprite.loadSheet "#{I.team}/wall_n", spriteSize, spriteSize, spriteScale, (sprites) ->
    sprite = sprites[0]
    backBoardsCanvas.withTransform Matrix.translation(I.wallLeft + 2 * I.spriteSize - sideWallWidth, I.wallTop - I.spriteSize), ->
      sprite.fill(backBoardsCanvas, 0, 0, arenaWidth() - I.spriteSize * 4 + 2 * sideWallWidth, I.spriteSize)

  Sprite.loadSheet "#{I.team}/wall_nw", 2 * spriteSize, 2 * spriteSize, spriteScale, (sprites) ->
    sprite = sprites[0]
    backBoardsCanvas.withTransform Matrix.translation(I.wallLeft - sideWallWidth, I.wallTop - I.spriteSize), ->
      sprite.draw(backBoardsCanvas, 0, 0)

  Sprite.loadSheet "#{I.team}/wall_nw", 2 * spriteSize, 2 * spriteSize, spriteScale, (sprites) ->
    sprite = sprites[0]
    backBoardsCanvas.withTransform Matrix.translation(I.wallRight + sideWallWidth, I.wallTop - I.spriteSize), ->
      backBoardsCanvas.withTransform Matrix.scale(-1, 1), ->
        sprite.draw(backBoardsCanvas, 0, 0)

  frontBoardsCanvas = $("<canvas width=#{bufferCanvasWidth} height=#{App.height} />")
    .css
      position: "absolute"
      top: 0
      left: 0
    .pixieCanvas()

  Sprite.loadSheet "#{I.team}/wall_sw", 2 * spriteSize, 2 * spriteSize, spriteScale, (sprites) ->
    sprite = sprites[0]
    frontBoardsCanvas.withTransform Matrix.translation(I.wallLeft - sideWallWidth, I.wallBottom - 2 * I.spriteSize + wallBottomBuffer), ->
      sprite.draw(frontBoardsCanvas, 0, 0)

  Sprite.loadSheet "#{I.team}/wall_sw", 2 * spriteSize, 2 * spriteSize, spriteScale, (sprites) ->
    sprite = sprites[0]
    frontBoardsCanvas.withTransform Matrix.translation(I.wallRight + sideWallWidth, I.wallBottom - 2 * I.spriteSize + wallBottomBuffer), ->
      frontBoardsCanvas.withTransform Matrix.scale(-1, 1), ->
        sprite.draw(frontBoardsCanvas, 0, 0)

  Sprite.loadSheet "#{I.team}/wall_s", 2 * spriteSize, 2 * spriteSize, spriteScale, (sprites) ->
    sprite = sprites[0]
    frontBoardsCanvas.withTransform Matrix.translation(I.wallLeft + I.spriteSize * 2 - sideWallWidth, I.wallBottom - I.spriteSize + wallBottomBuffer), ->
      sprite.fill(frontBoardsCanvas, 0, 0, arenaWidth() - I.spriteSize * 4 + 2 * sideWallWidth, I.spriteSize)

  Sprite.loadSheet "#{I.team}/wall_w", spriteSize, spriteSize, spriteScale, (sprites) ->
    sprite = sprites[0]
    frontBoardsCanvas.withTransform Matrix.translation(I.wallLeft - sideWallWidth, I.wallTop + I.spriteSize * 1.5), (canvas) ->
      sprite.fill(canvas, -I.spriteSize/2, -I.spriteSize/2, I.spriteSize, arenaHeight() - I.spriteSize * 2)

    frontBoardsCanvas.withTransform Matrix.translation(I.wallRight + sideWallWidth, I.wallTop + I.spriteSize * 1.5), (canvas) ->
      canvas.withTransform Matrix.scale(-1, 1), ->
        sprite.fill(canvas, -I.spriteSize/2, -I.spriteSize/2, I.spriteSize, arenaHeight() - I.spriteSize * 2)

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

  # TODO: Get rid of this whole before draw thing
  # move into individual z-indexed elements or proxies
  self.on "beforeDraw", (canvas) ->
    # A little hacky, but what isn't?
    cameraTransform = engine.camera().transform()

    canvas.withTransform cameraTransform, (canvas) ->
      canvas.withTransform Matrix.translation(App.width/2, App.height/2), ->
        Fan.crowd.invoke("draw", canvas)
        canvas.context().drawImage(iceCanvas.element(), 0, 0)
        canvas.context().drawImage(bloodCanvas.element(), 0, 0)

  self.on "create", ->
    # Draw the front Rink Boards at the correct zIndex
    engine.add
      class: "RinkBoardsProxy"
      rink: self
      zIndex: I.wallBottom

  self.include Rink.Physics

  return self
