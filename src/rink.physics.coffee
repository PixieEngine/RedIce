Rink.Physics = (I={}, self) ->
  Object.reverseMerge I,
    cornerRadius: Rink.CORNER_RADIUS

  walls = [{
    normal: Point(1, 0)
    position: I.wallLeft
  }, {
    normal: Point(-1, 0)
    position: -I.wallRight
  }, {
    normal: Point(0, 1)
    position: I.wallTop
  }, {
    normal: Point(0, -1)
    position: -I.wallBottom
  }]

  corners = [{
    position: Point(I.wallLeft + I.cornerRadius, I.wallTop + I.cornerRadius)
    quadrant: 0
  }, {
    position: Point(I.wallRight - I.cornerRadius, I.wallTop + I.cornerRadius)
    quadrant: 1
  }, {
    position: Point(I.wallLeft + I.cornerRadius, I.wallBottom - I.cornerRadius)
    quadrant: -1
  }, {
    position: Point(I.wallRight - I.cornerRadius, I.wallBottom - I.cornerRadius)
    quadrant: -2
  }]

  walls: ->
    walls

  corners: ->
    corners

  cornerRadius: ->
    I.cornerRadius
