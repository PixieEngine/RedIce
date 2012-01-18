TeamSheet = (I={}) ->
  Object.reverseMerge I,
    team: "spike"

  headStyles = [
    "bigeyes"
    "jawhead"
    "longface"
    "roundhead"
    "stubs"
  ]

  self = tubs: CharacterSheet
    team: I.team
    character: "tubs"
  skinny: CharacterSheet
    team: I.team
    character: "skinny"

  headStyles.each (style) ->
    self[style] = Sprite.loadSheet("#{I.team}_#{style}_5", 512, 512)

  return self

