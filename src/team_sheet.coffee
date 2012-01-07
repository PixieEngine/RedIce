TeamSheet = (I={}) ->
  Object.reverseMerge I,
    team: "spike"

  tubs: CharacterSheet
    team: I.team
    character: "tubs"
  skinny: CharacterSheet
    team: I.team
    character: "skinny"
  stubs: Sprite.loadSheet("#{I.team}_stubs_5", 512, 512)

