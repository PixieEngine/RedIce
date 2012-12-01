Player.Paint = (I, self) ->
  Object.reverseMerge I,
    paintColor: "white"
    paintWidth: 15

  controller = engine.controller(I.id)
  actionDown = controller.actionDown

  lastPosition = null
  painting = false

  self.bind "update", ->
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

  self.bind "paint", (color) ->
    I.paintColor = color

  color: ->
    I.paintColor
