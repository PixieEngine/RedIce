Fan = (I) ->
  $.reverseMerge I,
    duration: 16 + rand(64)
    sprite: Fan.sprites.rand()
    width: 32
    height: 32
    x: rand(App.width).snap(32)
    y: rand(WALL_TOP).snap(32)

  self = GameObject(I)

  if config.throwBottles && !rand(50)
    engine.add
      class: "Bottle"
      x: I.x
      y: I.y

  return self

Fan.sprites ||= [
  Sprite.loadByName "fans_active"
]

