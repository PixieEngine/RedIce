CharacterSheet = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    character: "tubs"
    team: "spike"
    size: 512

  loadStrip = (action, facing, cells) ->
    Sprite.loadSheet("#{I.team}_#{I.character}_#{action}_#{facing}_#{cells}", I.size, I.size)

  FRONT = "se"
  BACK = "ne"
  FAST = "fast"
  SLOW = "slow"
  IDLE = "idle"
  FALL = "falldown"
  SHOOT = "shoot"

  self =
    metadata: {}
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

  metadataUrl = ResourceLoader.urlFor("data", "#{I.team}_#{I.character}")

  $.getJSON metadataUrl, (data) ->
    Object.extend self.metadata, data

  retrun self

