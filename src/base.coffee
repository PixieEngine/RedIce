Base = (I) ->
  I ||= {}

  self = GameObject(I).extend
    bloody: $.noop

    puck: ->
      false

    wipeout: $.noop

    center: (newCenter) ->
      if newCenter?
        I.x = newCenter.x - I.width/2
        I.y = newCenter.y - I.height/2

        self
      else
        Point(I.x + I.width/2, I.y + I.height/2)

  self

