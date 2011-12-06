CharacterSheet = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    character: "spiketubs"
    size: 512

  {character, size} = I

  loadStrip = (action, facing, cells) ->
    Sprite.loadSheet("#{character}_#{action}_#{facing}_strip#{cells}", size, size)

  FRONT = "se"
  BACK = "ne"
  FAST = "fast"
  SLOW = "slow"
  IDLE = "idle"
  FALL = "falldown"
  SHOOT = "shoot"

  #TODO Metadata

  fast:
    front: loadStrip(FAST, FRONT, 6)
    back: loadStrip(FAST, BACK, 6)
  slow:
    front: loadStrip(SLOW, FRONT, 6)
    back: loadStrip(SLOW, BACK, 6)
  idle:
    front: loadStrip(IDLE, FRONT, 2)
    back: loadStrip(IDLE, BACK, 2)
  fall: loadStrip(FALL, FRONT, 6)
  shoot: loadStrip(SHOOT, FRONT, 11)

