Fan = (I) ->
  Object.reverseMerge I,
    sprites: Fan.sprites.rand()
    width: 128
    height: 128
    zIndex: -10

  self = GameObject(I)

  startX = I.x
  startY = I.y

  fov = (1/4).rotations

  # Default to looking straight
  I.sprite = I.sprites[1][0]

  self.bind "update", ->
    # bob back and forth
    xOffset = (I.age / 12).floor() % 5 - 1

    if xOffset > 1
      xOffset = 0

    I.x = startX + xOffset
    I.y = startY + (I.age / 11).floor() % 2

    if puck = engine.find("Puck").first()
      lookDirection = ((puck.position().subtract(self.position()).direction() + fov / 2) / fov).floor().clamp(0, 2)

      I.sprite = I.sprites[lookDirection][0]

  return self

Fan.sprites ||= [1, 2].map (n) ->
  ["e", "s", "w"].map (d) ->
    Sprite.loadSheet "crowd_#{n}_#{d}", 512, 512, 0.25
