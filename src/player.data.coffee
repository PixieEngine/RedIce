Player.Data = (I, self) ->

  self.on "update", ->
    Object.extend I, Player.bodyData[I.bodyStyle]

    # Add in team specific mods
    for key, value of Player.teamData[I.teamStyle]
      I[key] += value

  return {}

Player.bodyData =
  skinny:
    controlRadius: 50
    friction: 0.075
    mass: 15
    movementSpeed: 1.25
    powerMultiplier: 2
    radius: 18
    strength: 1
    toughness: 20
  thick:
    controlRadius: 50
    friction: 0.09
    mass: 20
    movementSpeed: 1.1
    powerMultiplier: 3
    strength: 1
    toughness: 25
  tubs:
    controlRadius: 50
    friction: 0.1
    mass: 40
    movementSpeed: 1.2
    powerMultiplier: 2.5
    radius: 22
    strength: 1
    toughness: 40

# Team ability deltas
Player.teamData =
  smiley:
    mass: -1
  spike:
    strength: 2
    controlRadius: -10
  hiss:
    movementSpeed: 0.3
    friction: 0.02
  moster:
    mass: -2
    strength: 1
    movementSpeed: -0.1
  mutant:
    movementSpeed: -0.1
    mass: 1
    friction: 0.01
  robo:
    movementSpeed: 0.3
    friction: 0.01
    mass: 3
    powerMultiplier: 2
