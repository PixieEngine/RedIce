SideBoards = (I={}) ->
  Object.reverseMerge I,
    spriteName: "norm_wall_w"
    width: 64
    height: 64
    scale: 1/8
    x: 0
    y: WALL_TOP + 32
    repetitions: 5
    flip: 1

  self = GameObject(I).extend
    draw: (canvas) ->
      canvas.withTransform Matrix.translation(I.x, I.y), ->
        canvas.withTransform Matrix.scale(I.flip * I.scale, I.scale), ->
          I.sprite.fill(canvas, -256, -256, 512, 512 * I.repetitions)

  return self

