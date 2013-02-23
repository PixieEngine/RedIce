Player.Data = (I, self) ->

  self.on "update", ->
    Object.extend I, Player.bodyData[I.bodyStyle]

    # Add in team specific mods
    for key, value of Player.teamData[I.teamStyle]
      I[key] += value

  return {}

Player.defaultData =
  boostMeter: 64
  boostMultiplier: 2
  boostRecovery: 1
  strength: 1
  puckControl: 2

Player.bodyData =
  skinny:
    friction: 0.075
    mass: 15
    movementSpeed: 1.25
    radius: 18
    toughness: 12
  thick:
    friction: 0.085
    mass: 20
    movementSpeed: 1.1
    toughness: 15
  tubs:
    friction: 0.09
    mass: 40
    movementSpeed: 1.2
    radius: 24
    toughness: 20

for key, value of Player.bodyData
  Player.bodyData[key] = Object.reverseMerge value, Player.defaultData

# Team ability deltas(+/-)
Player.teamData =
  smiley:
    # Extra Turbo Meter
    boostMeter: 32
    boostRecovery: 0.25
    # Lightweights
    mass: -5
  spike:
    strength: 0.5
  hiss:
    # Less Turbo Meter
    boostMeter: -32
    # Fast 'n Sticky
    boostMultiplier: +2
    movementSpeed: +2
    friction: +0.125
    # Strong Puck Control
    puckControl: +2.5
  moster:
    mass: -2
    strength: 0.25
    movementSpeed: -0.1
  mutant:
    movementSpeed: -0.1
    mass: 1
    friction: 0.01
  robo:
    movementSpeed: 0.3
    friction: 0.02
    mass: 3
