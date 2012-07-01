TeamSheet = (I={}) ->
  Object.reverseMerge I,
    team: "spike"
    size: 512

  self = {}

  self.goal =
    back: Sprite.loadSheet("#{I.team}_goal_back", I.size, I.size, 0.25)
    front: Sprite.loadSheet("#{I.team}_goal_front", I.size, I.size, 0.25)

  TeamSheet.bodyStyles.each (style) ->
    self[style] = CharacterSheet
      team: I.team
      character: style

  TeamSheet.headStyles.each (style) ->
    self[style] = HeadSheet
      team: I.team
      character: style

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
