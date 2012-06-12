TeamSheet = (I={}) ->
  Object.reverseMerge I,
    team: "spike"

  self = {}

  TeamSheet.bodyStyles.each (style) ->
    self[style] = CharacterSheet
      team: I.team
      character: style
      size: 64

  TeamSheet.headStyles.each (style) ->
    self[style] = HeadSheet
      team: I.team
      character: style
      size: 64

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

