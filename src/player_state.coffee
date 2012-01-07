PlayerState = (I={}, self) ->
  # Set some default properties
  Object.reverseMerge I,
    frame: 0
    action: "idle"
    facing: "front"

  self.bind "update", ->
    I.sprite = self.spriteSheet()[I.action][I.facing].wrap(I.frame)

  spriteSheet: ->
    teamSprites[I.teamStyle][I.bodyStyle]

  frameData: ->
    self.spriteSheet().data[I.action]?[I.facing]?.wrap(I.frame)

