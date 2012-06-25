HeadSheet = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    character: "bigeyes"
    team: "spike"
    size: 512

  loadStrip = (action, cells) ->
    if action
      Sprite.loadSheet("#{I.team}_#{I.character}_#{action}_#{cells}", I.size, I.size, 0.5)
    else
      Sprite.loadSheet("#{I.team}_#{I.character}_#{cells}", I.size, I.size, 0.5)

  actions = [
    "charged"
    "pain"
  ]

  self = {}

  actions.each (action) ->
    self[action] = loadStrip(action, 5)

  self.normal = loadStrip(null, 5)

  return self

