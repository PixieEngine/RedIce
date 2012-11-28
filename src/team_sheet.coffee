TeamSheet = (I={}) ->
  Object.reverseMerge I,
    team: "spike"
    size: 512

  self =
    goal:
      back: Sprite.loadSheet("#{I.team}/goal_back", 640, 640, 0.25)
      front: Sprite.loadSheet("#{I.team}/goal_front", 640, 640, 0.25)
    scoreboard: Sprite.loadSheet("#{I.team}/scoreboard", 512, 512, 0.5)
    zamboni: {}

  ["n", "s", "e"].each (direction) ->
    self.zamboni[direction] = Sprite.loadSheet("#{I.team}/zamboni_drive_#{direction}_2", 512, 512, ZAMBONI_SCALE)

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
