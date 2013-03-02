Blood = (I={}) ->
  Object.reverseMerge I,
    blood: 1
    duration: 10
    radius: 5
    sprite: Sprite.NONE
    teamStyle: "spike"
    debugColor: "rgba(0, 255, 0, 0.5)"

  self = GameObject(I).extend
    circle: ->
      c = self.center()
      c.radius = I.radius

      return c

  self.on "create", ->
    if sprite = Blood.sprites[I.teamStyle].rand()[0]
      sprite.draw(bloodCanvas, I.x - sprite.width/2, I.y - sprite.height/2)

  self.attrReader "color"

  self.include DebugDrawable

  self

do ->
  size = 128

  normalBlood = [1..12].map (n) ->
    Sprite.loadSheet "gibs/floor_decals/#{n}", size, size

  mutantBlood = [25..36].map (n) ->
    Sprite.loadSheet "gibs/floor_decals/#{n}", size, size

  robotBlood = [37..48].map (n) ->
    Sprite.loadSheet "gibs/floor_decals/#{n}", size, size

  monsterBlood = [].concat(normalBlood, mutantBlood, robotBlood)

  Blood.sprites =
    spike: normalBlood
    smiley: normalBlood
    hiss: normalBlood
    monster: monsterBlood
    mutant: mutantBlood
    robo: robotBlood
