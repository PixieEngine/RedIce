MainMenuState = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  self.on "enter", ->
    engine.add
      class: "Menu"

    engine.add
      sprite: "title_text"
      x: App.width/2
      y: App.height/3 - 50

    Music.play "Theme to Red Ice"

  # We must always return self as the last line
  return self
