DebugDrawable = (I={}, self) ->
  Object.reverseMerge I,
    debugColor: "rgba(255, 0, 255, 0.5)"

  self.on "drawDebug", (canvas) ->
    if I.radius
      center = self.center()

      canvas.drawCircle
        position: center
        radius: I.radius
        color: I.debugColor

  return {}
