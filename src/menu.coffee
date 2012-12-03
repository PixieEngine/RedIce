Menu = (I={}) ->
  # DSLs4Life
  item = (text, fn) ->
    text: text
    action: fn

  popSubMenu = ->
    # Don't pop the top menu
    unless I.menus.length is 1
      prevMenu = I.menus.pop()

  minigame = (name) ->
    item name, ->
      engine.setState(Minigames[name]())

  back = item "Back", popSubMenu

  submenu = (name, menuOptions...) ->
    item name, ->
      I.menus.push [back].concat(menuOptions)

  # Set some default properties
  Object.reverseMerge I,
    x: App.width/2
    y: 2*App.height/3 + 32
    sprite: "menu_border_1" # Use the name of a sprite in the images folder
    menus: [[
      item "Versus", -> engine.setState(MatchSetupState())
      submenu "Mini-Games",
        minigame "PushOut"
        minigame "Paint"
      submenu "Options",
        item "Coming Soon", ->
    ]]

  # Inherit from game object
  self = GameObject(I)

  options = ->
    I.menus.last()

  selectedOption = ->
    options()[options().selectedIndex || 0]

  moveSelection = (change) ->
    index = options().selectedIndex || 0

    options().selectedIndex = (index + change).mod(options().length)

  choose = ->
    selectedOption().action()

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

    options().each (option, i) ->
      canvas.centerText
        text: option.text
        x: 0
        y: i * 64
        color: "white"

      if option is selectedOption()
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

