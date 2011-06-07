Blood = (I) ->
  $.reverseMerge I,
    blood: 1
    duration: 300
    sprite: Sprite.NONE
    x: I.x + push.x
    y: I.y + push.y
    width: 32
    height: 32

  self = GameObject(I)

  Blood.sprites.rand().draw(bloodCanvas, I.x, I.y)

  self

Blood.sprites ||= [
  Sprite.loadByName "blood"
]

