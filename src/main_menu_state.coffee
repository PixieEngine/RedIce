MainMenuState = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  # Add events and methods here
  self.bind "update", ->
    if keydown.return
      engine.setState(MatchSetupState())

  self.bind "enter", ->
    engine.add 
      class: "Menu"

    engine.add
      sprite: "title_text"
      x: App.width/2
      y: App.height/6

  # We must always return self as the last line
  return self