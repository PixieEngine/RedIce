Bottle = (I) ->
  $.reverseMerge I,
    color: "#A00"
    radius: 8
    rotation: Math.TAU/2
    rotationalVelocity: (rand() * 2 - 1) * Math.TAU/16
    spriteName: "freedomade"
    velocity: Point(rand(5) - 2, 2 + rand(4) + rand(4))
    z: 48
    zVelocity: 4 + rand(6)
    gravity: -0.25

  I.width = I.height = I.radius

  particleSizes = [2, 3, 5]

  addParticleEffect = ->
    engine.add
      class: "Emitter"
      duration: 10
      sprite: Sprite.EMPTY
      velocity: Point(0, 0)
      particleCount: 9
      batchSize: 5
      x: I.x + I.width/2
      y: I.y - I.z
      generator:
        color: Color(0, 255, 0, 0.5)
        duration: 3
        height: (n) ->
          particleSizes.wrap(n)
        maxSpeed: 5
        velocity: (n) ->
          Point.fromAngle(Random.angle()).scale(rand(5) + 1)
        width: (n) ->
          particleSizes.wrap(n)

  self = Base(I).extend
    draw: (canvas) ->
      center = self.center()

      shadowColor = "rgba(0, 0, 0, 0.15)"
      bonusRadius = (-4 + 256/I.z).clamp(-4, 4)
      canvas.fillCircle(center.x, center.y, I.radius + bonusRadius, shadowColor)

      transform = Matrix.translation(I.x + I.width/2, I.y + I.height/2 - I.z).concat(Matrix.rotation(I.rotation)).concat(Matrix.translation(-I.width/2, -I.height/2))

      canvas.withTransform transform, ->
        I.sprite.draw(canvas, 0, 0)

  self.bind "destroy", ->
    addParticleEffect()

  self.bind "step", ->
    self.updatePosition(1)

    I.rotation += I.rotationalVelocity

    I.z += I.zVelocity
    I.zVelocity += I.gravity

    if I.z < 48
      players = engine.find("Player")

      players.each (player) ->
        if Collision.circular(player.circle(), self.circle())
          player.wipeout(player.center().subtract(self.center()))
          self.destroy()

    if I.z < 0
      self.destroy()

  self

