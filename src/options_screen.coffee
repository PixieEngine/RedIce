OptionsScreen = (I) ->
  $.reverseMerge I,
    backgroundColor: "#00010D"
    callback: $.noop

  directory = App?.directories?.images || "images"

  resourceURL = (directory, name, type) ->
    directory = App?.directories?[directory] || directory

    # TODO Add mtime
    "#{BASE_URL}/#{directory}/#{name}.#{type}"

  createSelect = (name, options) ->
    label = $ "<label />"

    select = $ "<select />"

    options.each (option) ->
      optionElement = $"<option />",
        val: option
        text: option

      select.append optionElement

    heading = $ "<h2 />"
      text: name

    label.append heading
    label.append select

    return label

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
  optionsPanel = $ "<div />",
    css:
      margin: auto
      width: "75%"
      zIndex: 1
  .appendTo(optionsScreen)

  $(document).one "keydown", ->
    optionsScreen.remove()

    I.callback()

