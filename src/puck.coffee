Puck = (I) ->
  $.reverseMerge I,
    color: "black"
    radius: 8
    width: 16
    height: 16
    x: 512
    y: 384
    velocity: Point()
    zIndex: 10

  self = GameObject(I).extend
    circle: ->
      c = self.center()
      c.radius = I.radius

      return c

    draw: (canvas) ->
      center = self.center()
      canvas.fillCircle(center.x, center.y, I.radius, I.color)

    puck: ->
      true

    wipeout: $.noop

  self.bind "update", ->
    I.velocity = I.velocity.scale(0.95)

    I.x += I.velocity.x
    I.y += I.velocity.y

  self

