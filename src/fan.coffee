Fan = (I) ->
  Object.reverseMerge I,
    sprites: Fan.sprites.rand()
    width: 128
    height: 128
    zIndex: -10

  self = GameObject(I)
  
  startX = I.x
  startY = I.y

  self.bind "update", ->
    I.sprite = I.sprites[1][0]
    
    I.x = startX + (I.age / 6).floor() % 4

  return self

Fan.sprites ||= [1, 2].map (n) ->
  ["e", "s", "w"].map (d) ->
    Sprite.loadSheet "crowd_#{n}_#{d}", 512, 512, 0.25
