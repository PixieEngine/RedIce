Menu = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    x: App.width/2
    y: 2*App.height/3 + 32
    sprite: "menu_border_1" # Use the name of a sprite in the images folder
    selectedOption: 0
    options: [
      {
        text: "Versus"
        action: ->
          engine.setState(MatchSetupState())
      }, {
        text: "Mini-Games"
        action: ->
          engine.setState(Minigames.PushOut())
      }, {
        text: "Options"
        action: ->
      }
    ]

  # Inherit from game object
  self = GameObject(I)

  moveSelection = (change) ->
    I.selectedOption += change
    I.selectedOption = I.selectedOption.mod(I.options.length)

  choose = ->
    I.options[I.selectedOption].action()

  # Add events and methods here
  self.bind "update", ->
    # Joystick Input
    MAX_PLAYERS.times (i) ->
      joystick = engine.controller(i)

      moveSelection(joystick.tap().y)

      if joystick.buttonPressed "A", "START"
        choose()


  self.unbind "draw"

  self.bind "draw", (canvas) ->
    sprite = Menu.topSprite
    sprite.draw canvas, -sprite.width/2, -sprite.height

    sprite = Menu.middleSprite
    sprite.draw canvas, -sprite.width/2, 0

    sprite = Menu.bottomSprite
    sprite.draw canvas, -sprite.width/2, 128

    canvas.font("bold 48px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")
    I.options.each (option, i) ->
      canvas.centerText
        text: option.text
        x: 0
        y: i * 64
        color: "white"

      if i is I.selectedOption
        width = 256 + 128
        # TODO Sprite/Animation rather than solid color
        canvas.drawRect
          x: -width/2
          y: i * 64 - 30
          width: width
          height: 32
          color: "rgba(255, 0, 255, 0.25)"

  # We must always return self as the last line
  return self

Menu.topSprite = Sprite.loadByName "menu_border_1"
Menu.middleSprite = Sprite.loadByName "menu_border_2"
Menu.bottomSprite = Sprite.loadByName "menu_border_3"

