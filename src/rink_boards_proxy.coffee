RinkBoardsProxy = (I={}) ->
  Object.reverseMerge I,
    zIndex: WALL_BOTTOM

  self = GameObject(I).extend
    draw: (canvas) ->
      I.rink.drawFront(canvas)
