Boards = (I) ->
  Object.reverseMerge I,
    width: ARENA_WIDTH - 256
    height: 64
    x: WALL_LEFT + 128

  self = GameObject(I).extend
    draw: (canvas) ->
      canvas.withTransform Matrix.translation(I.x, I.y), ->
        I.sprite.fill(canvas, 0, 0, I.width, I.height)

  return self

