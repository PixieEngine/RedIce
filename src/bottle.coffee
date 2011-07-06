Bottle = (I) ->
  $.reverseMerge I,
    color: "#800"
    radius: 8
    velocity: Point(rand(5) - 2, 2 + rand(4))
    z: 48
    zVelocity: 4
    gravity: -0.125

  self = GameObject(I).extend
    draw: (canvas) ->
      shadowColor = "rgba(0, 0, 0, 0.15)"
      canvas.fillCircle(I.x + I.radius, I.y + I.radius, I.radius, shadowColor)

      canvas.fillCircle(I.x + I.radius, I.y + I.radius - I.z, I.radius, I.color)

  self.bind "step", ->
    I.x += I.velocity.x
    I.y += I.velocity.y

    I.z += I.zVelocity
    I.zVelocity += I.gravity

    if I.z < 0
      I.active = false

  self

