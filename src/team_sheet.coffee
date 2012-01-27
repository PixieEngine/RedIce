TeamSheet = (I={}) ->
  Object.reverseMerge I,
    team: "spike"

  self = tubs: CharacterSheet
    team: I.team
    character: "tubs"
  skinny: CharacterSheet
    team: I.team
    character: "skinny"
  thick: CharacterSheet
    team: I.team
    character: "thick"


  TeamSheet.headStyles.each (style) ->
    self[style] = Sprite.loadSheet("#{I.team}_#{style}_5", 512, 512)

  return self

TeamSheet.headStyles = [
  "bigeyes"
  "jawhead"
  "longface"
  "roundhead"
  "stubs"
]

