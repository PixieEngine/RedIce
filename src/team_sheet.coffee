TeamSheet = (I={}) ->
  Object.reverseMerge I,
    team: "spike"
    size: 512
    scale: 0.5

  self =
    goal:
      back: Sprite.loadSheet("#{I.team}/goal_back", 640, 640, 0.25)
      front: Sprite.loadSheet("#{I.team}/goal_front", 640, 640, 0.25)
    scoreboard: Sprite.loadSheet("#{I.team}/scoreboard", I.size, I.size, I.scale)
    zamboni: {}

  ["n", "s", "e"].each (direction) ->
    self.zamboni[direction] = Sprite.loadSheet("#{I.team}/zamboni_drive_#{direction}_2", I.size, I.size, ZAMBONI_SCALE)

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

window.teamSprites = {}
TEAMS.each (name) ->
  # Set up asset groups for loading
  AssetLoader.group name, ->
    teamSprites[name] = TeamSheet
      team: name
