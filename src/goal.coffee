Goal = (I) ->
  I ||= {}

  $.reverseMerge I,
    color: "green"
    height: 32
    width: 12
    x: WALL_LEFT + ARENA_WIDTH/20 - 12
    y: WALL_TOP + ARENA_HEIGHT/2 - 16

  self = GameObject(I)


  self.bind "step", ->
    puck = engine.find "Puck"

  return self

