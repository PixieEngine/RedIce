Blood = (I={}) ->
  Object.reverseMerge I,
    blood: 1
    duration: 300
    radius: 5
    sprite: Sprite.NONE
    debugColor: "rgba(0, 255, 0, 0.5)"

  self = GameObject(I).extend
    circle: () ->
      c = self.center()
      c.radius = I.radius

      return c

  self.on "create", ->
    if sprite = Blood.sprites.rand()[0]
      sprite.draw(bloodCanvas, I.x - sprite.width/2, I.y - sprite.height/2)

  self.include DebugDrawable

  self

Blood.sprites = [1..12].map (n) ->
  Sprite.loadSheet "gibs/floor_decals/#{n}", 512, 512, 0.25
