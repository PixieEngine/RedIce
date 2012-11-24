Fan = (I) ->
  Object.reverseMerge I,
    sprites: Fan.sprites[[0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 2].rand()]
    width: 128
    height: 128
    cheer: 0

  self = GameObject(I)

  startX = I.x
  startY = I.y

  I.zIndex = I.y

  fov = (1/4).rotations

  # Default to looking straight
  I.sprite = I.sprites[1][0]

  self.bind "update", ->
    I.cheer = I.cheer.approach(0, 1)

    # bob back and forth
    xOffset = (I.age / 12).floor() % 5 - 1

    if xOffset > 1
      xOffset = 0

    I.x = startX + xOffset
    I.y = startY + (I.age / 11).floor() % 2

    if I.cheer
      I.sprite = I.sprites[3][0]
    else if puck = engine.find("Puck").first()
      lookDirection = ((puck.position().subtract(self.position()).direction() + fov / 2) / fov).floor().clamp(0, 2)

      I.sprite = I.sprites[lookDirection][0]

  self.cheer = ->
    I.cheer = 35

  return self

Fan.sprites ||= [1, 2, 3].map (n) ->
  ["e", "s", "w", "cheer"].map (d) ->
    Sprite.loadSheet "crowd/#{n}_#{d}", 512, 512, 0.25

Fan.generateCrowd = ->
  fans = []
  fanSize = 100

  addFanSection = (xOffset) ->
    4.times (x) ->
      2.times (y) ->
        fans.push Fan
          x: (x + 0.5) * fanSize + xOffset
          y: (y + (x % 2) / 2) * 64 + 25
          age: x * 7 + y * 9

  addFanSection(12)
  addFanSection(12 + App.width - 400)

  fans.sort (a, b) ->
    a.I.y - b.I.y

  return fans

Fan.crowd = []

Fan.cheer = (n=1) ->
  n.times ->
    Fan.crowd.rand()?.cheer()
