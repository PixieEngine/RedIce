MainMenuState = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  self.bind "enter", ->
    rink.hide()

    engine.add
      class: "Menu"

    engine.add
      sprite: "title_text"
      x: App.width/2
      y: App.height/3 - 50

  # We must always return self as the last line
  return self