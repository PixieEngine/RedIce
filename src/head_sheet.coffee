HeadSheet = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    character: "bigeyes"
    team: "spike"
    size: 128

  loadStrip = (action, cells) ->
    if action
      Sprite.loadSheet("25/#{I.team}_#{I.character}_#{action}_#{cells}", I.size, I.size)
    else
      Sprite.loadSheet("25/#{I.team}_#{I.character}_#{cells}", I.size, I.size)

  actions = [
    "charged"
    "pain"
  ]

  self = {}

  actions.each (action) ->
    self[action] = loadStrip(action, 5)

  self.normal = loadStrip(null, 5)

  return self

