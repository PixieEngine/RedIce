Base = (I) ->
  I ||= {}

  $.reverseMerge I,
    fortitude: 1
    friction: 0
    strength: 1
    mass: 1
    velocity: Point(0, 0)

  self = GameObject(I).extend
    bloody: $.noop

    crush: $.noop

    puck: ->
      I.class == "Puck"

    wipeout: $.noop

    # The "Power Rating" for determining who gets wrecked during collisions
    # Fundamentally: I.velocity.dot(normal)
    collisionPower: (normal) ->
      (I.velocity.dot(normal) + I.fortitude) * I.strength

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
    I.velocity = I.velocity.scale(1 - I.friction)

    I.x += I.velocity.x
    I.y += I.velocity.y

    I.zIndex = 1 + (I.y + I.height)/CANVAS_HEIGHT

  self.attrReader "mass"

  self

