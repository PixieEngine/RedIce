TeamSheet = (I={}) ->
  Object.reverseMerge I,
    team: "spike"
    size: 512

  self = {}

  self.goal =
    back: Sprite.loadSheet("#{I.team}_goal_back", 640, 640, 0.2)
    front: Sprite.loadSheet("#{I.team}_goal_front", 640, 640, 0.2)

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
