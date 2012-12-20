Menu = (I={}) ->
  # DSLs4Life
  item = (text, fn) ->
    text: text.toUpperCase()
    action: fn

  popSubMenu = ->
    # Don't pop the top menu
    unless I.menus.length is 1
      prevMenu = I.menus.pop()

  gamestate = (name, state) ->
    item name, ->
      engine.setState(state())

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
    textColor: "#CCA"
    highlightTextColor: "#FF8"
    shadowColor: "#113"
    font: "48px 'Orbitron'"
    menus: [[
      # gamestate "Tournament", MapState
      gamestate "Versus", MatchSetupState
      submenu "Mini-Games",
        # minigame "Zamboni Defense"
        minigame "PushOut"
        minigame "Paint"
      submenu "Options",
        item "Config", ->
    ]]

  # Inherit from game object
  self = GameObject(I)

  options = ->
    I.menus.last()

  selectedOption = ->
    options()[options().selectedIndex || 0]

  moveSelection = (change) ->
    if change
      Sound.play "Menu Move Cursor 1"

    index = options().selectedIndex || 0

    options().selectedIndex = (index + change).mod(options().length)

  choose = ->
    Sound.play "Menu Select 1"

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
    spriteWidth = 512
    xOffset = 15
    x = -spriteWidth/2 + xOffset

    sprite = Menu.topSprite
    sprite.draw canvas, x, -sprite.height

    sprite = Menu.middleSprite
    sprite.draw canvas, x, 0

    sprite = Menu.bottomSprite
    sprite.draw canvas, x, 128

    canvas.font(I.font)

    textOffsetY = 10

    options().each (option, i) ->
      textColor = I.textColor
      y = i * 64 + textOffsetY

      if option is selectedOption()
        textColor = I.highlightTextColor
        sprite = Menu.highlightSprite

        sprite.draw(canvas, 0 - sprite.width / 2, y - sprite.height / 2 - 24)

      canvas.centerText
        text: option.text
        x: 2
        y: y + 2
        color: I.shadowColor

      canvas.centerText
        text: option.text
        x: 0
        y: y
        color: textColor

  # We must always return self as the last line
  return self

Menu.topSprite = Sprite.loadByName "menu_border_1"
Menu.middleSprite = Sprite.loadByName "menu_border_2"
Menu.bottomSprite = Sprite.loadByName "menu_border_3"

Menu.highlightSprite = Sprite.loadByName "gibs/wall_decals/4"
