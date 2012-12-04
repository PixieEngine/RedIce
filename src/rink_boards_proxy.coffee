RinkBoardsProxy = (I={}) ->
  Object.reverseMerge I, {}

  self = GameObject(I).extend
    draw: (canvas) ->
      I.rink.drawFront(canvas)
