Boards = (I) ->
  $.reverseMerge I,
    width: ARENA_WIDTH - 192
    height: 48

  self = GameObject(I).extend
    draw: (canvas) ->
      canvas.withTransform Matrix.translation(I.x, I.y), ->
        I.sprite.fill(canvas, 0, 0, I.width, I.height)

  return self

