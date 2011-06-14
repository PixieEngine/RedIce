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

  if I.velocity? && I.velocity.x? && I.velocity.y? 
    I.velocity = Point(I.velocity.x, I.velocity.y)

  self.bind "update", ->
    I.x += I.velocity.x
    I.y += I.velocity.y

    I.zIndex = 1 + (I.y + I.height)/CANVAS_HEIGHT

  self

