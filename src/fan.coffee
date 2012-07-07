Fan = (I) ->
  Object.reverseMerge I,
    sprite: Fan.sprites.rand()
    width: 32
    height: 32

  self = GameObject(I).extend
    center: ->
      Point(I.x + I.width/2, I.y + I.height/2)

  if config.throwBottles && !rand(50)
    engine.add
      class: "Bottle"
      x: I.x
      y: I.y

  return self

Fan.sprites ||= [
  Sprite.loadByName "fans_active"
]
