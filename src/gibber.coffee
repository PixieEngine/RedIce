Gib = (I={}) ->
  Object.reverseMerge I,
    duration: 60
    rotation: 0
    rotationalVelocity: rand() * 0.2 - 0.1
    width: 32
    height: 32
    x: App.width/2
    y: App.width/2
    velocity: Point.fromAngle(Random.angle()).scale(6 + rand(5))
    z: 48
    zVelocity: rand(10) - 1
    gravity: -0.25
    radius: 16

  self = Base(I).extend
    draw: (canvas) ->
      center = self.center()

      shadowColor = "rgba(0, 0, 0, 0.25)"
      bonusRadius = (-4 + 256/I.z).clamp(-4, 4)
      canvas.drawCircle
        position: center
        radius: I.radius + bonusRadius
        color: shadowColor

      transform = Matrix.translation(I.x + I.width/2, I.y + I.height/2 - I.z)
        .concat(Matrix.rotation(I.rotation))
        .concat(Matrix.translation(-I.width/2, -I.height/2))

      canvas.withTransform transform, ->
        I.sprite.draw(canvas, -I.sprite.width/2, -I.sprite.height/2)

  self.bind "update", ->
    I.rotation += I.rotationalVelocity
    I.z += I.zVelocity
    I.zVelocity += I.gravity

    if I.z <= 0
      I.z = 0
      I.zVelocity = -I.zVelocity * 0.8

    physics.wallCollisions([self], 1)
    self.updatePosition(1)

  return self

Gibber = (name, options={}) ->
  Gib.sprites[name].each (sprite) ->
    engine.add Object.extend
      class: "Gib"
      sprite: sprite[0]
    , options

Gib.sprites =
  zamboni: [1..6].map (i) ->
    Sprite.loadSheet("gibs/zamboni_parts/#{i}", 512, 512, 0.5)
  mutantZamboni: [6..12].map (i) ->
    Sprite.loadSheet("gibs/zamboni_parts/#{i}", 512, 512, 0.5)
