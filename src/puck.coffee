Puck = (I) ->
  $.reverseMerge I,
    color: "black"
    radius: 8
    width: 16
    height: 16
    x: 512
    y: 384
    velocity: Point()

  self = GameObject(I).extend
    circle: ->
      c = self.center()
      c.radius = I.radius

      return c

    puck: ->
      true

    wipeout: $.noop

  self.bind "update", ->
    I.x += I.velocity.x
    I.y += I.velocity.y

  self

