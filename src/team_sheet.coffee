TeamSheet = (I={}) ->
  Object.reverseMerge I,
    team: "spike"

  tubs: CharacterSheet
    team: I.team
    character: "tubs"
  skinny: CharacterSheet
    team: I.team
    character: "skinny"

