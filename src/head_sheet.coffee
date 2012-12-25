HeadSheet = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    character: "bigeyes"
    team: "spike"
    size: 512
    scale: 0.5

  loadStrip = (action, cells) ->
    if action
      Sprite.loadSheet("#{I.team}/#{I.character}_#{action}_#{cells}", I.size, I.size, I.scale)
    else
      Sprite.loadSheet("#{I.team}/#{I.character}_#{cells}", I.size, I.size, I.scale)

  actions = [
    "charged"
    "pain"
  ]

  self = {}

  actions.each (action) ->
    self[action] = loadStrip(action, 5)

  self.normal = loadStrip(null, 5)

  return self
