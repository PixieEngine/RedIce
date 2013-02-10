Player.State = (I={}, self) ->
  # Set some default properties
  Object.reverseMerge I,
    frame: 0
    action: "idle"
    facing: "front"

  jitterSoak = 10

  setFacing = (newFacing) ->
    unless I.cooldown.facing
      I.cooldown.facing = jitterSoak
      I.facing = newFacing

  forceFacing = (newFacing) ->
    I.facing = newFacing
    I.cooldown.facing = jitterSoak

  setFlip = (newFlip) ->
    if I.hflip != newFlip
      unless I.cooldown.flip
        I.cooldown.flip = jitterSoak
        I.hflip = newFlip

  self.on "update", ->
    # Merge in team_body specific frame/character data
    Object.extend I, teamSprites[I.teamStyle][I.bodyStyle].characterData

    I.headAction = "normal"

    setFlip (I.heading > 2*Math.TAU/8 || I.heading < -2*Math.TAU/8)

    spriteSheet = self.spriteSheet()

    speed = I.velocity.magnitude()
    cycleDelay = 16

    # Determine character facing
    if 0 <= I.heading <= Math.TAU/2
      setFacing "front"
    else
      setFacing "back"

    if speed < 1
      I.action = "idle"
    else if speed < 6
      I.action = "slow"
      cycleDelay = 4
    else
      I.action = "fast"
      cycleDelay = 3

    if I.wipeout
      forceFacing "front"
      I.action = "fall"
      I.headAction = "pain"
      I.frame = ((25 - I.wipeout) / 3).floor().clamp(0, 5)
    else if power = I.shootPower
      forceFacing "front"
      I.action = "shoot"
      if power < I.maxShotPower
        I.frame = ((power * I.shootHoldFrame + 1) / I.maxShotPower).floor()
      else
        I.headAction = "charged"
        I.frame = I.shootHoldFrame + (I.age / 6).floor() % 2
    else if I.cooldown.shoot
      I.action = "shoot"
      forceFacing "front"
      I.frame = (10 - I.cooldown.shoot/I.shootCooldownFrameDelay).floor()
    else
      I.frame = (I.age / cycleDelay).floor()

    # Lock head for front facing actions
    if I.facing == "front"
      headDirection = I.heading.constrainRotation()

      if headDirection < -Math.TAU/4
        headDirection = Math.TAU/2
      else if headDirection < 0
        headDirection = 0
    else
      headDirection = I.heading

    angleSprites = 8
    headIndexOffset = 2
    headPosition = ((angleSprites * -headDirection / Math.TAU).round() + headIndexOffset).mod(angleSprites)

    if headPosition >= 5
      headPosition = angleSprites - headPosition
      I.headFlip = true
    else
      I.headFlip = false

    I.headSprite = teamSprites[I.teamStyle][I.headStyle][I.headAction][headPosition]

  # Set the sprite
  self.on "update", ->
    I.sprite = self.spriteSheet()[I.action][I.facing].wrap(I.frame)

  spriteSheet: ->
    teamSprites[I.teamStyle][I.bodyStyle]

  frameData: ->
    self.spriteSheet().data[I.action]?[I.facing]?.wrap(I.frame)

