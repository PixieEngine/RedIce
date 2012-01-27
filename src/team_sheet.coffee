TeamSheet = (I={}) ->
  Object.reverseMerge I,
    team: "spike"

  self = {}

  TeamSheet.bodyStyles.each (style) ->
    self[style] = CharacterSheet
      team: I.team
      character: style

  TeamSheet.headStyles.each (style) ->
    self[style] = Sprite.loadSheet("#{I.team}_#{style}_5", 512, 512)

  return self

TeamSheet.bodyStyles = [
  "tubs"
  "skinny"
  "thick"
]

TeamSheet.headStyles = [
  "bigeyes"
  "jawhead"
  "longface"
  "roundhead"
  "stubs"
]

