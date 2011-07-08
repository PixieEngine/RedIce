Bottle = (I) ->
  $.reverseMerge I,
    color: "#A00"
    radius: 8
    rotation: Math.TAU/2
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
      bonusRadius = (-4 + 256/I.z).clamp(-4, 4)
      canvas.fillCircle(center.x, center.y, I.radius + bonusRadius, shadowColor)

      spriteCenter = center.subtract(0, I.z)

      transform = Matrix.rotation(I.rotation, spriteCenter).concat(Matrix.translation(-I.width/2, -I.height/2))

      canvas.withTransform transform, ->
        I.sprite.draw(canvas)

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

