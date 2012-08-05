Menu = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    x: App.width/2
    y: App.height/2
    sprite: "menu_border_1" # Use the name of a sprite in the images folder
    options: [
      "Versus"
      "Mini-Games"
      "Options"
    ]

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "update", ->
    # Add update method behavior
    
  self.unbind "draw"

  self.bind "draw", (canvas) ->
    sprite = Menu.topSprite
    sprite.draw canvas, -sprite.width/2, -sprite.height
    
    sprite = Menu.middleSprite
    sprite.draw canvas, -sprite.width/2, 0

    sprite = Menu.bottomSprite
    sprite.draw canvas, -sprite.width/2, 96
    
    canvas.font("bold 24px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")
    I.options.each (option, i) ->
      canvas.centerText
        text: option
        x: 0
        y: i * 24
        color: "white"
    
  # We must always return self as the last line
  return self

Menu.topSprite = Sprite.loadByName "menu_border_1"
Menu.middleSprite = Sprite.loadByName "menu_border_2"
Menu.bottomSprite = Sprite.loadByName "menu_border_3"
