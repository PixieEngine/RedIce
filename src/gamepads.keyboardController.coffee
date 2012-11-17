Gamepads.KeyboardController = (I={}) ->
  Object.reverseMerge I,
    axisMapping: [
      ["left", "right"]
      ["up", "down"]
    ]
    buttonMapping:
      "A": 'z'
      "B": 'x'
  
      # X/C, Y/D are interchangeable
      "C": 'c'
      "D": 'v'
      "X": 'c'
      "Y": 'v'
  
      "SELECT": "shift"
      "START": "return"

    debugColor: "#000"

  tap = Point(0, 0)
  buttonKeys = Object.keys(I.buttonMapping)
  buttonValues = buttonKeys.map (key) ->
    I.buttonMapping[key]

  processTaps = ->
    [x, y] = I.axisMapping.map ([negative, positive]) ->
      justPressed[positive] - justPressed[negative]

    tap = Point(x, y)

  self = Core().include(Bindable).extend
    actionDown: (buttons...) ->
      buttons.inject false, (down, button) ->
        down || if button is "ANY"
          buttonValues.inject false, (down, button) ->
            down || keydown[button]
        else
          keydown[I.buttonMapping[button]]

    # true if button was just pressed
    buttonPressed: (button) ->
      keyname = I.buttonMapping[button]

      return justPressed[keyname]

    position: (stick=0) ->
      [x, y] = I.axisMapping.map ([negative, positive]) ->
        keydown[positive] - keydown[negative]

      tap = Point(x, y)

    tap: ->
      tap

    update: ->
      processTaps()

    drawDebug: (canvas) ->
      lineHeight = 18

      p = self.position()
      
      ["x", "y"].each (key, i) ->
        canvas.drawText
          color: I.debugColor
          text: p[key]
          x: 0
          y: i * lineHeight

      buttonKeys.each (button, i) ->
        canvas.drawText
          color: I.debugColor
          text: self.actionDown(button)
          x: 250
          y: i * lineHeight
