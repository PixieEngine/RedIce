OptionsScreen = (I) ->
  $.reverseMerge I,
    backgroundColor: "#00010D"
    callback: $.noop

  directory = App?.directories?.images || "images"

  optionsScreen = $ "<div />",
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
      zIndex: 1001
  .appendTo("body")

  $ "<img />",
    height: App.height
    src: "#{BASE_URL}/#{directory}/title.png"
    width: App.width
  .appendTo(optionsScreen)

  $ "<div />",
    text: "Loading..."
    css:
      bottom: "40%"
      color: "#FFF"
      position: "absolute"
      width: "100%"
      zIndex: -1
  .appendTo(optionsScreen)

  # TODO: Add options

  $(document).one "keydown", ->
    options.remove()

    I.callback()

