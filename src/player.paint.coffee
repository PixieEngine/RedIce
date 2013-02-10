Player.Paint = (I, self) ->
  Object.reverseMerge I,
    paintColor: "white"
    paintWidth: 15

  controller = engine.controller(I.id)
  actionDown = controller.actionDown

  lastPosition = null
  painting = false

  self.on "update", ->
    p = self.position()
    if actionDown "A", "Y"
      if lastPosition
        bloodCanvas.drawLine
          lineCap: "round"
          start: lastPosition
          end: p
          width: I.paintWidth
          color: I.paintColor

    lastPosition = p

  self.on "paint", (color) ->
    I.paintColor = color

  self.on "shoot", ({power, direction}) ->
    bloodCanvas.drawLine
      lineCap: "round"
      start: self.position()
      end: self.position().add(Point.fromAngle(direction).scale(1000))
      width: I.paintWidth
      color: I.paintColor

  color: ->
    I.paintColor
