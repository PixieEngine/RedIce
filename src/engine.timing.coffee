# Timing Draw and update
Engine.Timing = (I={}, self) ->

  drawStartTime = null
  updateDuration = null
  updateStartTime = null

  self.on "beforeDraw", ->
    drawStartTime = +new Date

  self.on "overlay", (canvas) ->
    drawDuration = (+new Date) - drawStartTime

    if DEBUG_DRAW
      canvas.drawText
        color: "white"
        text: "ms/draw: #{drawDuration}"
        x: 10
        y: 30

      canvas.drawText
        color: "white"
        text: "ms/update: #{updateDuration}"
        x: 10
        y: 50

  self.on "beforeUpdate", ->
    updateStartTime = +new Date

  self.on "afterUpdate", (canvas) ->
    updateDuration = (+new Date) - updateStartTime

  return {}
