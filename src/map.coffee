Map = (I={}) ->
  Object.reverseMerge I,
    sprite: Sprite.NONE
    x: App.width/2
    y: 0
    width: App.width
    height: App.height
    zIndex: -1
    nextTeam: "hiss"
    lastTeam: "smiley"

  self = GameObject(I)

  self.on "update", ->
    I.sprite = Map.sprites.map

  self.on "create", ->
    choose = !I.lastTeam?

    engine.add
      class: "Airplane"
      start: Map.positions[I.lastTeam] || Map.positions.smiley
      destination: Map.positions[I.nextTeam]
      destinationTeam: I.nextTeam
      choose: choose
      moon: I.nextTeam is "robo"

    TEAMS.each (team) ->
      data = Map.positions[team]

      engine.add Object.extend({}, data, class: "Spotlight", team: team)

  self

Map.sprites =
  map: Sprite.loadByName "map"
  plane: Sprite.loadByName "plane"

Map.positions =
  smiley:
    x: 664
    y: 900 - App.height
  spike:
    x: 275
    y: 1007 - App.height
  hiss:
    x: 111
    y: 1334 - App.height
  monster:
    x: 590
    y: 1345 - App.height
  mutant:
    x: 881
    y: 1185 - App.height
  robo:
    x: 704
    y: 194 - App.height
    rotation: -(1.rotations/6)
