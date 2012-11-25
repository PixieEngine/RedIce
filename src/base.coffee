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

    controlPuck: $.noop
    controlCircle: ->
      x: 0
      y: 0
      radius: 0

    collides: ->
      !I.wipeout

    collidesWithWalls: ->
      true

    toughness: ->
      I.fortitude * 10

    # The "Power Rating" for determining who gets wrecked during collisions
    # Fundamentally: I.velocity.dot(normal)
    collisionPower: (normal) ->
      (I.velocity.dot(normal) + I.fortitude) * I.strength

    center: (newCenter) ->
      if newCenter?
        I.x = newCenter.x - I.width/2
        I.y = newCenter.y - I.height/2

        I.center = newCenter

        self
      else
        I.center

    updatePosition: (dt, noFriction) ->
      if noFriction then friction = 0 else friction = I.friction

      # Optimize to not use any point methods because they create
      # new points and this is a hotspot in the code
      frictionFactor = (1 - friction * dt)
      I.velocity.x *= frictionFactor
      I.velocity.y *= frictionFactor

      I.x += I.velocity.x * dt
      I.y += I.velocity.y * dt

      I.center.x = I.x + I.width/2
      I.center.y = I.y + I.height/2

      self.trigger "positionUpdated"

  if I.velocity? && I.velocity.x? && I.velocity.y?
    I.velocity = Point(I.velocity.x, I.velocity.y)

  self.bind "update", ->
    I.zIndex = 1 + (I.y + I.height)/CANVAS_HEIGHT

  self.include DebugDrawable

  self.attrReader "mass"

  I.center = Point(I.x + I.width/2, I.y + I.height/2)

  self

