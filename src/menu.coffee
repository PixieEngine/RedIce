Menu = (I={}) ->
  Object.reverseMerge I,
    zIndex: App.height

  # DSLs4Life
  item = (text, fn) ->
    text: text.toUpperCase()
    action: fn

  teamChooser = (option, self=undefined) ->
    text = option.toUpperCase()
    options = TEAMS

    # Load persisted value
    persistedValue = persistentConfig["#{option}Team"]
    optionIndex = options.indexOf(persistedValue)

    currentOption = ->
      options.wrap(optionIndex)

    setText = ->
      self.text = "#{text}: #{currentOption()}"

    persist = ->
      config["#{option}Team"] = currentOption()
      persistentConfig["#{option}Team"] = currentOption()
      persistConfig()

    adjust = (delta) ->
      optionIndex += delta
      persist()
      setText()

    self =
      action: ->
        adjust(1)

    setText()

    return self

  volumeChooser = ({option, source}, self=undefined) ->
    text = option.toUpperCase()
    steps = 10
    options = [0..steps].map (n) ->
      n / steps

    # Load persisted value
    persistedValue = persistentConfig["#{option}Volume"]
    optionIndex = options.indexOf(persistedValue)

    # Default
    if optionIndex is -1
      optionIndex = (steps / 2).floor()

    currentOption = ->
      options.wrap(optionIndex)

    setText = ->
      self.text = "#{text} #{currentOption()}"

    persist = ->
      persistentConfig["#{option}Volume"] = currentOption()
      persistConfig()

    adjust = (delta) ->
      optionIndex += delta
      source.volume currentOption()
      persist()
      setText()

    self =
      action: ->
        adjust(1)

    setText()

    return self

  popSubMenu = ->
    # Don't pop the top menu
    unless I.menus.length is 1
      prevMenu = I.menus.pop()

  gamestate = (name, state) ->
    item name, ->
      engine.setState(state())

  minigame = (name) ->
    item name, ->
      setupState = MinigameSetupState
        nextState: Minigames[name]

      engine.setState(setupState)

  back = item "Back", popSubMenu

  submenu = (name, menuOptions...) ->
    item name, ->
      I.menus.push [back].concat(menuOptions)

  # Set some default properties
  Object.reverseMerge I,
    x: App.width/2
    y: 4*App.height/3 + 32
    sprite: "menu_border_1" # Use the name of a sprite in the images folder
    textColor: "#CCA"
    highlightTextColor: "#FF8"
    shadowColor: "#113"
    font: "48px 'Orbitron'"
    menus: [[
      item "Story", ->
        config.storyMode = true
        engine.setState Cutscene.scenes.intro
      gamestate "Versus", MatchSetupState
      submenu "Mini-Games",
        minigame "Whack-A-Mole"
        minigame "Sumo Push"
        minigame "Paint"
      submenu "Options",
        submenu "VS Teams",
          teamChooser "home"
          teamChooser "away"
        volumeChooser(
          option: "music"
          source: Music
        ),
        volumeChooser(
          option: "sfx"
          source: Sound
        )
    ]]

  # Inherit from game object
  self = GameObject(I)

  if DEMO_MODE
    I.menus = [[
      gamestate "Versus", MatchSetupState
      minigame "Paint"
      item "Purchase", ->
        window.open("https://chrome.google.com/webstore/detail/red-ice/booheljepkdmiiennlkkbghacgnimbdn")
    ]]

  # TODO Expose DSL to eliminate this stupid if statement
  if I.matchPause
    if config.storyMode
      I.menus = [[
        item "Resume", ->
          self.destroy()
        gamestate "Main Menu", MainMenuState
      ]]
    else
      I.menus = [[
        item "Resume", ->
          self.destroy()
        gamestate "Match Setup", MatchSetupState
        gamestate "Main Menu", MainMenuState
      ]]
  else if I.minigamePause
    I.menus = [[
      item "Resume", ->
        self.destroy()
      gamestate "Main Menu", MainMenuState
    ]]

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

  yPositionFn = Easing.quadraticInOut(4*App.height/3 + 32, 2*App.height/3 + 32)

  # Add events and methods here
  self.on "update", ->
    slideDuration = 1.5
    I.y = yPositionFn(I.age.clamp(0, slideDuration) / slideDuration)

    return if I.age < slideDuration

    # Joystick Input
    MAX_PLAYERS.times (i) ->
      joystick = engine.controller(i)

      moveSelection(joystick.tap().y)

      if joystick.buttonPressed "A", "START"
        choose()

  self.unbind "draw"

  self.on "overlay", (canvas) ->
    canvas.withTransform Matrix.translation(I.x, I.y), ->
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
