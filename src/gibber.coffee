Gib = (I={}) ->
  wallHeight = 64

  Object.reverseMerge I,
    rotation: 0
    rotationalVelocity: rand() * 0.2 - 0.1
    width: 0
    height: 0
    x: App.width/2
    y: App.width/2
    velocity: Point.fromAngle(Random.angle()).scale(6 + rand(5))
    z: 1.5 * wallHeight
    zVelocity: rand(10) - 1
    gravity: -0.25
    radius: 16

  buffer = 10
  outOfArena = ->
    I.y < WALL_TOP - buffer or
    I.y > WALL_BOTTOM + buffer or
    I.x < WALL_LEFT - buffer or
    I.x > WALL_RIGHT + buffer

  self = Base(I).extend
    collidesWithWalls: ->
      self.collides()

    collides: ->
      I.z <= wallHeight

    wipeout: ->
      if I.z is 0
        I.zVelocity = 3 + rand(10)

      I.rotationalVelocity += rand() * 0.2 - 0.1

    draw: (canvas) ->
      center = self.center()

      shadowColor = "rgba(0, 0, 0, 0.25)"
      radiusMultiple = 1 / (1 + I.z/100)
      canvas.drawCircle
        position: center
        radius: I.radius * radiusMultiple
        color: shadowColor

      transform = Matrix.translation(I.x, I.y - I.z)
        .concat(Matrix.rotation(I.rotation))

      canvas.withTransform transform, ->
        I.sprite.draw(canvas, -I.sprite.width/2, -I.sprite.height/2)

  self.bind "update", ->
    I.rotation += I.rotationalVelocity
    I.z += I.zVelocity
    I.zVelocity += I.gravity

    if I.z <= 0
      I.z = 0

      if I.zVelocity <= 0.5
        I.zVelocity = 0
      else
        I.zVelocity = -I.zVelocity * 0.8

      I.friction = 0.1

      I.rotationalVelocity *= 0.8

      if I.rotationalVelocity <= 0.01
        I.rotationalVelocity = 0

    else
      I.friction = 0

    if I.z <= wallHeight
      if outOfArena()
        self.destroy()

  return self

Gibber = (name, options={}) ->
  Gib.data[name].each (data) ->
    engine.add Object.extend({}, data, {
      class: "Gib"
      sprite: data.sprite[0]
    }, options)

do ->
  fromPart = (i) ->
    Sprite.loadSheet("gibs/zamboni_parts/#{i}", 512, 512, 0.5)

  Gib.data =
    zamboni: [{
      sprite: fromPart(1)
    }, {
      sprite: fromPart(2)
      mass: 4
      radius: 32
    }, {
      sprite: fromPart(3)
      mass: 2
    }, {
      sprite: fromPart(4)
      mass: 0.5
      radius: 12
    }, {
      sprite: fromPart(5)
      radius: 8
    }, {
      sprite: fromPart(6)
      mass: 0.6
      radius: 12
      strength: 2
    }]
    mutantZamboni: [{
      sprite: fromPart(7)
    }, {
      sprite: fromPart(8)
      mass: 3
    }, {
      sprite: fromPart(9)
      mass: 2
    }, {
      sprite: fromPart(10)
      mass: 2
      radius: 12
      strength: 3
    }, {
      sprite: fromPart(11)
      mass: 0.5
    }, {
      sprite: fromPart(12)
      mass: 0.75
      radius: 12
      strength: 2
    }]
    monsterZamboni: [{
      sprite: fromPart(13)
      mass: 3
      strength: 2
    }, {
      sprite: fromPart(14)
      mass: 1
      radius: 12
      strength: 2
    }, {
      sprite: fromPart(15)
      mass: 2
      strength: 2
    }, {
      sprite: fromPart(16)
      mass: 0.5
      radius: 12
      strength: 2
    }]
