Joysticks = ( ->
  type = "application/x-boomstickjavascriptjoysticksupport"
  plugin = null
  AXIS_MAX = 32767
  DEAD_ZONE = AXIS_MAX * 0.2
  TRIP_HIGH = AXIS_MAX * 0.75
  TRIP_LOW = AXIS_MAX * 0.5

  # Raw Joysticks data
  previousJoysticks = []
  joysticks = []

  controllers = []

  buttonMappingDefault =
    "A": 1
    "B": 2

    # X/C, Y/D are interchangeable
    "C": 4
    "D": 8
    "X": 4
    "Y": 8

    "R": 32
    "RB": 32
    "R1": 32

    "L": 16
    "LB": 16
    "L1": 16

    "SELECT": 64
    "BACK": 64

    "START": 128

    "HOME": 256
    "GUIDE": 256

    "TL": 512
    "TR": 1024

    "ANY": 0xFFFFFF

  buttonMappingOSX =
    "A": 2048
    "B": 4096

    "C": 8192
    "D": 16384
    "X": 8192
    "Y": 16384

    "R": 512

    "L": 256

    "SELECT": 32
    "BACK": 32

    "START": 16

    "HOME": 1024

    "LT": 64
    "TR": 128

    "ANY": 0xFFFFFF0

  axisMappingDefault =
    0: 0
    1: 1
    2: 2
    3: 3
    4: 4
    5: 5

  axisMappingOSX =
    0: 4
    1: 5
    2: 0
    3: 1
    4: 2
    5: 3

  displayInstallPrompt = (text, url) ->
    $ "<a />",
      css:
        backgroundColor: "yellow"
        boxSizing: "border-box"
        color: "#000"
        display: "block"
        fontWeight: "bold"
        left: 0
        padding: "1em"
        position: "absolute"
        textDecoration: "none"
        top: 0
        width: "100%"
        zIndex: 2000
      href: url
      target: "_blank"
      text: text
    .appendTo("body")

  Controller = (i, remapOSX) ->
    if remapOSX
      buttonMapping = buttonMappingOSX
      axisMapping = axisMappingOSX
    else
      buttonMapping = buttonMappingDefault
      axisMapping = axisMappingDefault

    currentState = ->
      joysticks[i]

    previousState = ->
      previousJoysticks[i]

    axisTrips = []

    self = Core().include(Bindable).extend
      actionDown: (buttons...) ->
        if state = currentState()
          buttons.inject false, (down, button) ->
            down || state.buttons & buttonMapping[button]
        else
          false

      # true if button was just pressed
      buttonPressed: (button) ->
        buttonId = buttonMapping[button]

        return (self.buttons() & buttonId) && !(previousState().buttons & buttonId)

      position: (stick=0) ->
        if state = currentState()
          p = Point(self.axis(axisMapping[2*stick]), self.axis(axisMapping[2*stick+1]))

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
        n = axisMapping[n]

        self.axes()[n] || 0

      axes: ->
        if state = currentState()
          state.axes
        else
          []

      buttons: ->
        if state = currentState()
          state.buttons

      processEvents: ->
        [x, y] = [0, 1].map (n) ->
          if !axisTrips[n] && self.axis(n).abs() > TRIP_HIGH
            axisTrips[n] = true

            return self.axis(n).sign()

          if axisTrips[n] && self.axis(n).abs() < TRIP_LOW
            axisTrips[n] = false

          return 0

        self.trigger("tap", Point(x, y)) if !x || !y

      drawDebug: (canvas) ->
        lineHeight = 18
        canvas.fillColor("#FFF")

        for axis, i in self.axes()
          canvas.fillText(axis, 0, i * lineHeight)

        canvas.fillText(self.buttons(), 0, i * lineHeight)

  getController: (i) ->
    controllers[i] ||= Controller(i)

  init: ->
    unless plugin
      plugin = document.createElement("object")
      plugin.type = type
      plugin.width = 0
      plugin.height = 0

      $("body").append(plugin)

      plugin.maxAxes = 6

      unless plugin.status
        displayInstallPrompt("Your browser does not yet handle joysticks, please click here to install the Boomstick plugin!", "https://github.com/STRd6/Boomstick/wiki")

  status: ->
    plugin?.status

  update: ->
    if plugin.joysticksJSON
      previousJoysticks = joysticks
      joysticks = JSON.parse(plugin.joysticksJSON())

    for controller in controllers
      controller?.processEvents()

  joysticks: ->
    joysticks
)()

