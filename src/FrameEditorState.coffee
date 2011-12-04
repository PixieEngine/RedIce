FrameEditorState = (I={}) ->
  self = GameState(I)

  p = null

  self.bind "enter", ->
    p = engine.add
      class: "Player"
      joystick: true


    self.cameras().first().follow(p)

  # Add events and methods here
  self.bind "update", ->
    ; # Add update method behavior

  # We must always return self as the last line
  return self

