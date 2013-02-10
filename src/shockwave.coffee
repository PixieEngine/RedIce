Shockwave = (I={}) ->
  Object.reverseMerge I,
    radius: 10
    maxRadius: 150
    zIndex: 3

  drawScorch = ->
    if scorch = Shockwave.sprites.scorch[0]
      bloodCanvas.withTransform Matrix.translation(I.x - scorch.width/2, I.y - scorch.height/2), ->
        scorch.draw bloodCanvas, 0, 0

  self = GameObject(I).extend
    draw: (canvas) ->
      sprite = Shockwave.sprites.explosion[(I.age).clamp(0, 6)]
      sprite?.draw(canvas, I.x - sprite.width / 2, I.y - sprite.height / 2)

  self.on "create", ->
    Sound.play "Zamboni #{rand(5)} N"
    drawScorch()

  self.on "update", ->
    maxCircle = I
    minCircle =
      x: I.x
      y: I.y
      radius: Math.max(I.radius - 20, 0)

    engine.find("Player, Zamboni, Puck").each (object) ->
      objectCircle = object.circle()
      if Collision.circular(objectCircle, maxCircle) && !Collision.circular(objectCircle, minCircle)
        shockwaveForce = object.center().subtract(I).norm(20)
        object.wipeout(shockwaveForce)
        object.I.velocity = object.I.velocity.add(shockwaveForce)

    I.radius += 20

    if I.radius > I.maxRadius
      self.destroy()

  return self

Shockwave.sprites = {}
Shockwave.sprites.scorch = Sprite.loadSheet("gibs/floor_decals/15", 512, 512, 0.5)
Shockwave.sprites.explosion = Sprite.loadSheet("explosion_7_small", 256, 256)
