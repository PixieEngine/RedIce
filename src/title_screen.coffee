TitleScreen = (I) ->

  directory = App?.directories?.images || "images"

  titleScreen = $ "<img />",
    css:
      left: 0
      margin: "auto"
      position: "absolute"
      top: 0
      zIndex: 1000
    height: App.height
    src: "#{BASE_URL}/#{directory}/title.png"
    width: App.width

  .appendTo("body")

  $(document).one "keydown", ->
    titleScreen.remove()

    I.callback()

