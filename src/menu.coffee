Menu = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    x: App.width/2
    y: App.height/2
    color: "blue"
    sprite: "menu_border_1" # Use the name of a sprite in the images folder

  # Inherit from game object
  self = GameObject(I)

  # Add events and methods here
  self.bind "update", ->
    # Add update method behavior
    
  self.unbind "draw"
  
  self.bind "draw", (canvas) ->
    I.sprite.draw

  # We must always return self as the last line
  return self