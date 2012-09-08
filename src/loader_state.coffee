LoaderState = (I={}) ->
  self = GameState(I)
  
  loadingComplete = ->
    false

  # Add events and methods here
  self.bind "update", ->
    # Add update method behavior
    if loadingComplete()
      engine.setState(MainMenuState())
      
  self.bind "overlay", (canvas) ->
    canvas.centerText
      text: "Loading"
      y: App.height/2
      color: "#FFF"

  # We must always return self as the last line
  return self
