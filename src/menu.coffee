Menu = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    color: "blue"
    height: 32
    width: 32
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