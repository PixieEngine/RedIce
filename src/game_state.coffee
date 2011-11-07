GameState = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    update: ->
    draw: ->

  I.objects ||= []

  self = Core(I)

  self.include Bindable

  # Add events and methods here
  self.bind "update", ->
    ; # Add update method behavior

  # We must always return self as the last line
  return self

