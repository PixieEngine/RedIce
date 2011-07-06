Bottle = (I) ->
  $.reverseMerge I,
    color: "#A00"
    radius: 8
    velocity: Point(rand(5) - 2, 2 + rand(4))
    z: 48
    zVelocity: 4
    gravity: -0.25

  self = Base(I).extend
    draw: (canvas) ->
      shadowColor = "rgba(0, 0, 0, 0.15)"
      canvas.fillCircle(I.x + I.radius, I.y + I.radius, I.radius, shadowColor)

      canvas.fillCircle(I.x + I.radius, I.y + I.radius - I.z, I.radius, I.color)

  self.bind "step", ->
    self.updatePosition(1)

    I.z += I.zVelocity
    I.zVelocity += I.gravity

    if I.z < 48
      players = engine.find("Player")

      players.each (player) ->
        if Collision.circular(player.circle(), self.circle())
          player.wipeout(player.center().subtract(self.center()))
          I.active = false

    if I.z < 0
      I.active = false

  self

