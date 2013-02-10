Goal = (I) ->
  I ||= {}

  DEBUG_DRAW = false
  WALL_RADIUS = 2
  WIDTH = 32
  HEIGHT = 60

  Goal.netSprites ||= Sprite.loadSheet("goal_lasnet", 640, 640, 0.25)

  Object.reverseMerge I,
    height: HEIGHT
    width: WIDTH
    x: WALL_LEFT + ARENA_WIDTH/20 - WIDTH
    y: WALL_TOP + ARENA_HEIGHT/2 - HEIGHT/2
    spriteOffset: Point(6, -HEIGHT/2 - 8)
    suddenDeath: false
    team: "smiley"

  if I.right
    I.scaleX = -1

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
      Fan.cheer(6)

      Sound.play "Buzzer"
      Sound.play("Crowd Cheers #{rand(4) + 1}")

      engine.delay 70 / 30, ->
        engine.add
          class: "Puck"

      if I.suddenDeath
        self.destroy()

  self.on "destroy", ->
    engine.add
      class: "Shockwave"
      x: I.x
      y: I.y
      velocity: Point(0, 1)

  self.on "drawDebug", (canvas) ->
    # Draw goal area
    canvas.drawRect
      bounds: I
      color: "rgba(255, 0, 255, 0.5)"

    # Draw walls
    walls.each (wall) ->
      drawWall(wall, canvas)

  self.on "update", ->
    I.sprite = teamSprites[I.team].goal.back[0]

    I.zIndex = I.y + I.height/2

  self.unbind "draw"

  self.on "draw", (canvas) ->
    if sprite = teamSprites[I.team].goal.back[0]
      sprite.draw(canvas, -sprite.width/2, -sprite.height/2)

    if sprite = teamSprites[I.team].goal.front[0]
      sprite.draw(canvas, -sprite.width/2, -sprite.height/2)

    if netSprite = Goal.netSprites[0]
      netSprite.draw(canvas, -netSprite.width/2, -netSprite.height/2)

  self.attrReader "team"
  self.attrAccessor "suddenDeath"

  return self
