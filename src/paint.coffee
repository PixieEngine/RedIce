Paint = (I={}) ->
  Object.reverseMerge I,
    color: "red"
    radius: 30
    zIndex: -1

  self = GameObject(I)

  self.unbind "draw"

  self.on "draw", (canvas) ->
    canvas.withTransform Matrix.scale(1, 1/PERSPECTIVE_RATIO), ->
      canvas.drawCircle
        x: 0
        y: 0
        color: I.color
        radius: I.radius

  self.on "update", ->
    engine.find("Player").each (player) ->
      if Collision.circular(self.circle(), player.circle())
        player.trigger("paint", I.color)

  return self
