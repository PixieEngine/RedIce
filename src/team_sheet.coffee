TeamSheet = (I={}) ->
  Object.reverseMerge I,
    team: "spike"
    size: 256
    scale: 1

  goalSize = 320
  goalScale = 0.5

  self =
    goal:
      back: Sprite.loadSheet("#{I.team}/goal_back", goalSize, goalSize, goalScale)
      front: Sprite.loadSheet("#{I.team}/goal_front", goalSize, goalSize, goalScale)
      net: Sprite.loadSheet("goal_lasnet", goalSize, goalSize, goalScale)
    scoreboard: Sprite.loadSheet("#{I.team}/scoreboard", I.size, I.size, I.scale)
    zamboni: {}

  ["n", "s", "e"].each (direction) ->
    self.zamboni[direction] = Sprite.loadSheet("#{I.team}/zamboni_drive_#{direction}_2", I.size, I.size, I.scale)

  TeamSheet.bodyStyles.each (style) ->
    self[style] = CharacterSheet
      team: I.team
      character: style
      scale: I.scale
      size: I.size

  TeamSheet.headStyles.each (style) ->
    self[style] = HeadSheet
      team: I.team
      character: style
      scale: I.scale
      size: I.size

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
