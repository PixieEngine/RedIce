Player.WhackAMole = (I, self) ->
  Object.reverseMerge I,
    score: 0

  self.on "shoot", ({power, direction}) ->
    circle = self.controlCircles().first()

    engine.find("MoleHole").each (entity) ->
      if Collision.circular(circle, entity.circle())
        entity.trigger "struck", self

  self.score = (delta) ->
    I.score += delta

  self.on "overlay", (canvas) ->
    padding = 10
    width = (App.width/4) - 2 * padding
    height = 40

    color = self.color()

    x = (width + padding) * (I.id) + 2 * padding
    y = 0

    canvas.drawRoundRect
      x: x - padding/4
      y: y - padding/4
      width: width + padding/2
      height: height + padding / 2
      color: color

    canvas.drawRoundRect
      x: x
      y: y
      width: width
      height: height
      color: "#FFF"

    canvas.drawRoundRect
      x: x
      y: y
      width: width
      height: height
      color: color.transparentize(0.8)

    canvas.centerText
      x: x + width/2
      y: 25
      color: "#000"
      text: "#{self.name()}: #{I.score}"

  return {}
