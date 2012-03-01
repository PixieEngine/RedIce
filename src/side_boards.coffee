SideBoards = (I={}) ->
  Object.reverseMerge I,
    spriteName: "norm_wall_w"
    width: 64
    height: 64
    scale: 1/8
    x: 32
    repetitions: 6

  self = GameObject(I).extend
    draw: (canvas) ->
      canvas.withTransform Matrix.translation(I.x, I.y), ->
        canvas.withTransform Matrix.scale(I.scale), ->
          I.sprite.fill(canvas, 0, 0, 512 * I.repetitions, 512)

  return self

