Bottle = (I) ->
  $.reverseMerge I,
    color: "#A00"
    radius: 8
    spriteName: "freedomade"
    velocity: Point(rand(5) - 2, 2 + rand(4) + rand(4))
    z: 48
    zVelocity: 4 + rand(6)
    gravity: -0.25

  I.width = I.height = I.radius

  self = Base(I).extend
    draw: (canvas) ->
      center = self.center()

      shadowColor = "rgba(0, 0, 0, 0.15)"
      canvas.fillCircle(center.x, center.y, I.radius, shadowColor)

      I.sprite.draw(canvas, I.x, I.y - I.z)

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

