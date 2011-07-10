Shockwave = (I) ->
  I ||= {}

  $.reverseMerge I,
    radius: 10
    maxRadius: 150
    offsetHeight: -24
    zIndex: 3

  flameStartColor = "rgba(64, 8, 4, 0.5)"
  flameMiddleColor = "rgba(192, 128, 64, 0.9)"
  flameEndColor = "rgba(192, 32, 16, 1)"
  transparentColor = "rgba(0, 0, 0, 0)"
  shadowColor = "rgba(0, 0, 0, 0.5)"

  constructGradient = (context, min, max, shadow=false) ->
    if shadow
      y = I.y
    else
      y = I.y + I.offsetHeight

    radialGradient = context.createRadialGradient(I.x, y, 0, I.x, y, max)

    if min > 0
      radialGradient.addColorStop(0, transparentColor)
      radialGradient.addColorStop((min - 1)/max, transparentColor)

    if shadow
      radialGradient.addColorStop(min / max, shadowColor)
      radialGradient.addColorStop(1, shadowColor)
    else
      radialGradient.addColorStop(min / max, flameStartColor)
      radialGradient.addColorStop((min + max) / (2 * max), flameMiddleColor)
      radialGradient.addColorStop(1, flameEndColor)

    return radialGradient

  self = GameObject(I).extend
    draw: (canvas) ->
      min = Math.max(I.radius - 20, 0)
      max = I.radius

      g = constructGradient(canvas.context(), min, max, true)
      canvas.fillCircle(I.x, I.y, max, g)

      g = constructGradient(canvas.context(), min, max)
      canvas.fillCircle(I.x, I.y + I.offsetHeight, max, g)

  self.bind "step", ->
    maxCircle = I
    minCircle =
      x: I.x
      y: I.y
      radius: Math.max(I.radius - 20, 0)

    engine.find("Player").each (player) ->
      playerCircle = player.circle()
      if Collision.circular(playerCircle, maxCircle) && !Collision.circular(playerCircle, minCircle)
        player.wipeout(player.center().subtract(I))

    I.radius += 10

    if I.radius > I.maxRadius
      self.destroy()

  self
