Player.Data = (I, self) ->

  # Load team specific overrides
  Object.extend I, Player.teamData[I.teamStyle]

  self.on "update", ->
    Object.extend I, Player.bodyData[I.bodyStyle]

    # Add in team specific mods
    for key, value of Player.teamDeltas[I.teamStyle]
      I[key] += value

  return {}

Player.defaultData =
  boostMeter: 2 # seconds of boost (assuming no recovery)
  boostMultiplier: 1
  boostRecoveryRate: 0.25 # Multiplier for boost recovery, 1 is 100% recovery of boost used per frame
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

Player.teamData =
  smiley: {}
  spike: {}
  hiss:
    # Weaker Shots
    baseShotPower: 10
    chargeShotPower: 35
  robo:
    bodySoundType: "Robo"
    bodySoundCount: 3
    torsoSlideSoundType: "Robot"
    bloodColor: "#00eadc"
    # Stronger Shots
    baseShotPower: 50
    chargeShotPower: 100
  mutant:
    bodySoundType: "Mutant"
    bodySoundCount: 3
    torsoSlideSoundType: "Mutant"
    # Mutant Blood
    bloodColor: "#5800ea"
    # Stronger Shots
    baseShotPower: 40
    chargeShotPower: 70
    # Faster Shot Charge
    maxShotCharge: 0.75
  monster:
    bodySoundType: "Monster"
    # Stronger Shots
    baseShotPower: 30
    chargeShotPower: 90

# Team ability deltas(+/-)
Player.teamDeltas =
  smiley:
    # Extra Turbo Meter
    boostMeter: +1
    boostRecoveryRate: +0.125
    # Lightweights
    mass: -5
  spike:
    # Spikey
    strength: +0.5
  hiss:
    # Lightweights
    mass: -5
    strength: -0.25
    # Less Turbo Meter
    boostMeter: -1
    # Fast 'n Sticky
    boostMultiplier: +1
    movementSpeed: +1.5
    friction: +0.125
    # Strong Puck Control
    puckControl: +2.5
  moster:
    friction: -0.005
    # Heavyweights
    mass: +5
    movementSpeed: -0.1
    strength: +0.25
    # Extremely Tough
    toughness: +8
  mutant:
    # Slippery Bastards
    friction: -0.025
  robo:
    # Faster
    movementSpeed: +0.3
    # Better Puck Control
    puckControl: +1
