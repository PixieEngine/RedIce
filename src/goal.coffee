Goal = (I) ->
  I ||= {}

  DEBUG_DRAW = false
  WALL_RADIUS = 2
  WIDTH = 32
  HEIGHT = 48

  $.reverseMerge I,
    height: HEIGHT
    width: WIDTH
    x: WALL_LEFT + ARENA_WIDTH/20 - WIDTH
    y: WALL_TOP + ARENA_HEIGHT/2 - HEIGHT/2
    spriteOffset: Point(0, 2 - HEIGHT/2)
    suddenDeath: false
    team: "mutant"

  I.hflip = I.right

  walls = []

  if I.right
    walls.push
      center: Point(I.x + I.width, I.y + I.height/2)
      halfWidth: WALL_RADIUS
      halfHeight: I.height/2
      killSide: -1
  else
    walls.push
      center: Point(I.x, I.y + I.height/2)
      halfWidth: WALL_RADIUS
      halfHeight: I.height/2
      killSide: 1

  walls.push {
    center: Point(I.x + I.width/2, I.y)
    halfWidth: I.width/2
    halfHeight: WALL_RADIUS
    horizontal: true
  }, {
    center: Point(I.x + I.width/2, I.y + I.height)
    halfWidth: I.width/2
    halfHeight: WALL_RADIUS
    horizontal: true
  }

  drawWall = (wall, canvas) ->
    canvas.drawRect
      color: "#0F0"
      x: wall.center.x - wall.halfWidth, 
      y: wall.center.y - wall.halfHeight,
      width: 2 * wall.halfWidth,
      height: 2 * wall.halfHeight

  self = GameObject(I).extend
    center: ->
      Point(I.x + I.width/2, I.y + I.height/2)

    walls: ->
      walls

    withinGoal: (circle) ->
      if circle.x - circle.radius > I.x && circle.x + circle.radius < I.x + I.width
        if circle.y - circle.radius > I.y && circle.y + circle.radius < I.y + I.height
          return true

      return false

    score: ->
      self.trigger "score"
      Sound.play("crowd#{rand(3)}")
      Sound.play("siren")

      if I.suddenDeath
        self.destroy()

  self.bind "destroy", ->
    engine.add
      class: "Shockwave"
      x: I.x + I.width/2
      y: I.y + I.height/2
      velocity: Point(0, 1)

  self.bind "drawDebug", (canvas) ->
    # Draw goal area
    canvas.drawRect
      bounds: I
      color: "rgba(255, 0, 255, 0.5)"

    # Draw walls
    walls.each (wall) ->
      drawWall(wall, canvas)

  self.bind "step", ->
    I.sprite = teamSprites[I.team].goal.back[0]

    I.zIndex = 1 + (I.y + I.height)/CANVAS_HEIGHT

  self.bind "draw", (canvas) ->
    if sprite = teamSprites[I.team].goal.front[0]
      sprite.draw(canvas, -2*sprite.width, -sprite.height)

  self.attrReader "team"
  self.attrAccessor "suddenDeath"

  return self

