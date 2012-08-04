MatchSetupState = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  # Add events and methods here
  self.bind "update", ->
    if keydown.enter
      engine.setState(MatchSetupState())
      
  self.bind "enter", ->
    

  # We must always return self as the last line
  return self