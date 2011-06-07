Blood = (I) ->
  $.reverseMerge I,
    blood: 1
    duration: 300
    radius: 2
    sprite: Sprite.NONE
    width: 32
    height: 32

  self = GameObject(I).extend
    circle: () ->
      c = self.center()
      c.radius = I.radius

      return c

  Blood.sprites.rand().draw(bloodCanvas, I.x, I.y)

  self

Blood.sprites ||= [
  Sprite.loadByName "blood"
]

