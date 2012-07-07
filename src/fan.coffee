Fan = (I) ->
  Object.reverseMerge I,
    sprite: Fan.sprites.rand()
    width: 32
    height: 32

  self = GameObject(I).extend
    center: ->
      Point(I.x + I.width/2, I.y + I.height/2)

  return self

Fan.sprites ||= [
  Sprite.loadByName "crowd_1_s"
  Sprite.loadByName "crowd_2_s"
]
