# Timing Draw and update
Engine.Timing = (I={}, self) ->

  drawStartTime = null
  updateDuration = null
  updateStartTime = null
  lastUpdateStartTime = null

  self.on "beforeDraw", ->
    drawStartTime = +new Date

  self.on "overlay", (canvas) ->
    drawDuration = (+new Date) - drawStartTime

    lineHeight = 30

    if DEBUG_DRAW
      canvas.drawText
        color: "white"
        text: "ms/draw: #{drawDuration}"
        x: 10
        y: 10 + 1 * lineHeight

      canvas.drawText
        color: "white"
        text: "ms/update: #{updateDuration}"
        x: 10
        y: 10 + 2 * lineHeight

      if lastUpdateStartTime
        canvas.drawText
          color: "white"
          text: "ms/cycle: #{updateStartTime - lastUpdateStartTime}"
          x: 10
          y: 10 + 3 * lineHeight

  self.on "beforeUpdate", ->
    lastUpdateStartTime = updateStartTime
    updateStartTime = +new Date

  self.on "afterUpdate", (canvas) ->
    updateDuration = (+new Date) - updateStartTime

  return {}
