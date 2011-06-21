Goal = (I) ->
  I ||= {}

  DEBUG_DRAW = false
  WALL_RADIUS = 2
  WIDTH = 32
  HEIGHT = 48

  $.reverseMerge I,
    color: "green"
    height: HEIGHT
    width: WIDTH
    x: WALL_LEFT + ARENA_WIDTH/20 - WIDTH
    y: WALL_TOP + ARENA_HEIGHT/2 - HEIGHT/2
    spriteOffset: Point(0, -(HEIGHT-2))

  wallSegments = ->
    walls = [{
      center: Point(I.x + I.width/2, I.y)
      halfWidth: I.width/2
      halfHeight: WALL_RADIUS
      horizontal: true
    }, {
      center: Point(I.x + I.width/2, I.y + I.height)
      halfWidth: I.width/2
      halfHeight: WALL_RADIUS
      horizontal: true
    }]

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

    return walls

  drawWall = (wall, canvas) ->
    canvas.fillColor("#0F0")
    canvas.fillRect(
      wall.center.x - wall.halfWidth, 
      wall.center.y - wall.halfHeight,
      2 * wall.halfWidth,
      2 * wall.halfHeight
    )

  self = GameObject(I).extend
    walls: wallSegments

    withinGoal: (circle) ->
      if circle.x + circle.radius > I.x && circle.x - circle.radius < I.x + I.width
        if circle.y + circle.radius > I.y && circle.y - circle.radius < I.y + I.height
          return true

      return false

    score: ->
      self.trigger "score"
      Sound.play("crowd#{rand(3)}")

  self.bind "drawDebug", (canvas) ->
    # Draw goal area
    canvas.fillColor("rgba(255, 0, 255, 0.5)")
    canvas.fillRect(I.x, I.y, I.width, I.height)

    # Draw walls
    wallSegments().each (wall) ->
      drawWall(wall, canvas)

  self.bind "step", ->
    if I.right
      I.sprite = tallSprites[7]      
    else
      I.sprite = tallSprites[6]

  return self

