Fan = (I) ->
  $.reverseMerge I,
    duration: 16 + rand(64)
    sprite: Fan.sprites.rand()
    width: 32
    height: 32
    x: rand(App.width).snap(32)
    y: rand(WALL_TOP).snap(32)

  self = GameObject(I)

  return self

Fan.sprites ||= [
  Sprite.loadByName "fans_active"
]

