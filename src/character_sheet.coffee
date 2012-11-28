CharacterSheet = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    character: "tubs"
    team: "spike"
    size: 512

  loadStrip = (action, facing, cells) ->
    Sprite.loadSheet("#{I.team}/#{I.character}_#{action}_#{facing}_#{cells}", I.size, I.size, 0.5)

  FRONT = "se"
  BACK = "ne"
  FAST = "fast"
  SLOW = "slow"
  IDLE = "idle"
  FALL = "falldown"
  SHOOT = "shoot"

  self =
    data: {}
    fast:
      front: loadStrip(FAST, FRONT, 6)
      back: loadStrip(FAST, BACK, 6)
    slow:
      front: loadStrip(SLOW, FRONT, 6)
      back: loadStrip(SLOW, BACK, 6)
    idle:
      front: loadStrip(IDLE, FRONT, 2)
      back: loadStrip(IDLE, BACK, 2)
    fall:
      front: loadStrip(FALL, FRONT, 6)
    shoot:
      front: loadStrip(SHOOT, FRONT, 11)

  self.characterData =
    shootHoldFrame: 5
    shootCooldownFrameCount: 5

  if I.character == "skinny"
    self.characterData.shootHoldFrame = 3
    self.characterData.shootCooldownFrameCount = 6

  if I.character == "thick"
    self.characterData.shootHoldFrame = 5
    self.characterData.shootCooldownFrameCount = 6

  if data = Data["#{I.team}_#{I.character}"]
    Object.extend self.data, data

  return self
