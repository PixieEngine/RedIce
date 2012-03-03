Boards = (I) ->
  Object.reverseMerge I,
    width: ARENA_WIDTH - 192
    height: 64
    x: WALL_LEFT + 128

  self = GameObject(I).extend
    draw: (canvas) ->
      canvas.withTransform Matrix.translation(I.x, I.y), ->
        canvas.withTransform Matrix.scale(1/8), ->
          I.sprite.fill(canvas, 0, 0, I.width * 7, 512)

  return self

