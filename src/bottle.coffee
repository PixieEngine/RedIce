Bottle = (I) ->
  $.reverseMerge I,
    color: "#800"
    radius: 8
    velocity: Point(1, 1)
    z: 48
    zVelocity: 6
    gravity: 0.125

  self = GameObject(I).extend
    draw: (canvas) ->
      canvas.fillCircle(I.x + I.radius, I.y + I.radius - I.z, I.radius, I.color)

      shadowColor = "rgba(0, 0, 0, 0.15)"
      canvas.fillCircle(I.x + I.radius, I.y + I.radius, I.radius, shadowColor)

  self.bind "step", ->
    I.x += I.velocity.x
    I.y += I.velocity.y

    if I.z < 0
      I.active = false

  self

