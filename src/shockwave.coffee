Shockwave = (I) ->
  I ||= {}

  $.reverseMerge I,
    radius: 10
    maxRadius: 150

  flameStartColor = "rgba(192, 32, 16, 0.75)"
  flameEndColor = "rgba(64, 8, 4, 1)"
  transparentColor = "rgba(0, 0, 0, 0)"

  constructGradient = (context, min, max) ->
    radialGradient = context.createRadialGradient(I.x, I.y, 0, I.x, I.y, max)

    if min > 0
      radialGradient.addColorStop(0, transparentColor)
      radialGradient.addColorStor(min - 1, transparentColor)

    radialGradient.addColorStor(min, flameStartColor)
    radialGradient.addColorStor(max, flameEndColor)

    return radialGradient


  self = GameObject(I).extend
    draw: (canvas) ->
      min = Math.max(I.radius - 20, 0)
      max = I.radius

      g = constructGradient(canvas.context(), min, max)

      canvas.fillCircle(I.x, I.y, max, g)

  self.bind "step", ->
    maxCircle = I
    minCircle =
      x: I.x
      y: I.y
      radius: Math.max(I.radius - 20, 0)

    engine.find("Player").each (player) ->
      playerCircle = player.circle()
      if Collision.circular(playerCircle, maxCircle) && !Collision.circular(playerCircle, minCircle)
        player.wipeout()

    I.radius += 10

    if I.radius > I.maxRadius
      self.destroy()

  self

