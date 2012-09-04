Gamepads.Controller = (I={}) ->
  Object.reverseMerge I,
    debugColor: "#000"
  
  MAX_BUFFER = 0.03
  AXIS_MAX = 1 - MAX_BUFFER
  DEAD_ZONE = AXIS_MAX * 0.2
  TRIP_HIGH = AXIS_MAX * 0.75
  TRIP_LOW = AXIS_MAX * 0.5
  
  BUTTON_THRESHOLD = 0.5

  buttonMapping =
    "A": 0
    "B": 1

    # X/C, Y/D are interchangeable
    "C": 2
    "D": 3
    "X": 2
    "Y": 3

    "L": 4
    "LB": 4
    "L1": 4

    "R": 5
    "RB": 5
    "R1": 5

    "SELECT": 6
    "BACK": 6

    "START": 7

    "HOME": 8
    "GUIDE": 8

    "TL": 9
    "TR": 10
  
  currentState = ->
    I.state.current?[I.index]

  previousState = ->
    I.state.previous?[I.index]

  axisTrips = []
  tap = Point(0, 0)

  processTaps = ->
    [x, y] = [0, 1].map (n) ->
      if !axisTrips[n] && self.axis(n).abs() > TRIP_HIGH
        axisTrips[n] = true

        return self.axis(n).sign()

      if axisTrips[n] && self.axis(n).abs() < TRIP_LOW
        axisTrips[n] = false

      return 0

    tap = Point(x, y)

  self = Core().include(Bindable).extend
    actionDown: (buttons...) ->
      if state = currentState()
        buttons.inject false, (down, button) ->
          down || if button is "ANY"
            state.buttons.inject false, (down, button) ->
              down || (button > BUTTON_THRESHOLD)
          else
            state.buttons[buttonMapping[button]] > BUTTON_THRESHOLD
      else
        false

    # true if button was just pressed
    buttonPressed: (button) ->
      buttonId = buttonMapping[button]

      return (self.buttons()[buttonId] > BUTTON_THRESHOLD) && !(previousState()?.buttons[buttonId] > BUTTON_THRESHOLD)

    position: (stick=0) ->
      if state = currentState()
        p = Point(self.axis(2*stick), self.axis(2*stick+1))

        magnitude = p.magnitude()

        if magnitude > AXIS_MAX
          p.norm()
        else if magnitude < DEAD_ZONE
          Point(0, 0)
        else
          ratio = magnitude / AXIS_MAX

          p.scale(ratio / AXIS_MAX)

      else
        Point(0, 0)

    axis: (n) ->
      self.axes()[n] || 0

    axes: ->
      if state = currentState()
        state.axes
      else
        []

    buttons: ->
      if state = currentState()
        state.buttons
      else
        []

    tap: ->
      tap

    update: ->
      processTaps()

    drawDebug: (canvas) ->
      lineHeight = 18

      self.axes().each (axis, i) ->
        canvas.drawText
          color: I.debugColor
          text: axis
          x: 0
          y: i * lineHeight

      self.buttons().each (button, i) ->
        canvas.drawText
          color: I.debugColor
          text: button
          x: 250
          y: i * lineHeight

