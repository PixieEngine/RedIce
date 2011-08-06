TitleScreen = (I) ->
  $.reverseMerge I,
    backgroundColor: "#00010D"
    callback: $.noop

  titleScreen = $ "<div />",
    css:
      backgroundColor: I.backgroundColor
      fontFamily: "monospace"
      fontSize: "20px"
      fontWeight: "bold"
      left: 0
      margin: "auto"
      position: "absolute"
      textAlign: "center"
      top: 0
      zIndex: 1000
  .appendTo("body")

  titleScreenImage = $ "<img />",
    height: App.height
    src: ResourceLoader.urlFor("images", "title")
    width: App.width
  .appendTo(titleScreen)

  loadingText = $ "<div />",
    text: "Loading..."
    css:
      bottom: "40%"
      color: "#FFF"
      position: "absolute"
      width: "100%"
      zIndex: -1
  .appendTo(titleScreen)

  titleScreenText = $ "<div />",
    text: "Press any key to begin"
    css:
      bottom: "12.5%"
      color: "#00010D"
      position: "absolute"
      width: "100%"
      zIndex: 1
  .appendTo(titleScreen)

  joysticksLabel = $ "<label />",
    text: "Joysticks"
    css:
      position: "absolute"
      bottom: "10px"
      right: "10px"
      zIndex: 2
  .appendTo(titleScreen)

  joysticksConfig = $ "<input />",
    checked: false
    type: "checkbox"
  .appendTo(joysticksLabel)

  $(document).one "keydown", ->
    if config.joysticks = joysticksConfig.attr("checked")
      config.joystickPlayers = config.players
      config.keyboardPlayers = 0

    titleScreen.remove()

    I.callback()

