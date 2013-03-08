Cutscene = (I={}) ->
  Object.reverseMerge I,
    text: "Go home and be a family man."
    nextState: MatchState

  dialog = null

  next = ->
    if !dialog or dialog.complete()
      if I.team is config.playerTeam
        engine.setState StoryConfigState()
      else
        engine.setState I.nextState()
    else
      dialog.flush()

  # Inherit from game object
  self = GameState(I)

  self.on "enter", ->
    engine.objects().invoke("destroy")

    x = App.width/2
    y = App.height/3

    img = engine.add
      sprite: I.background
      x: x
      y: y

    I.props.each (prop) ->
      engine.add Object.extend {x, y}, prop

    engine.add
      color: engine.backgroundColor()
      width: App.width
      height: App.height/3
      x: App.width/2
      y: 5 / 6 * App.height
      zIndex: 9000

    dialog = engine.add
      class: "DialogBox"
      text: I.text
      y: 2/3*App.height
      zIndex: 9001

  self.on "update", ->
    engine.controllers().each (controller) ->
      if controller.buttonPressed "A", "START"
        next()

  return self

# TODO more robust timing of loading cutscenes and assets

Prop = (I) ->
  self = GameObject(I)

  self.on "update", (dt) ->
    [
      "x"
      "y"
      "alpha"
      "rotation"
      "scaleX"
    ].each (property) ->
      if fn = I["#{property}Fn"]
        I[property] = fn(I.age)

  self.bind "drawDebug", (canvas) ->
    canvas.drawCircle
      x: I.registrationPoint.x
      y: I.registrationPoint.y
      radius: 5
      color: "#F0F"

  return self

danceScaleXFn = (t) ->
  Math.sin((t / 2) * Math.TAU).sign() or 1
danceYFnGen = (y, s=-1) ->
  (t) ->
    height = 100
    t = ((t % 6) - 2) * 2
    y + s * Math.max(-height * (t*t) + height, 0)

$ ->
  AssetLoader.group "cutscenes", ->
    Cutscene.scenes =
      intro:
        text: """
          Look out the window. And doesn't this remind you of when you were in the boat?
          And then later that night you were lying, looking up at the ceiling,
          and the stars in your mind were not dissimilar from the sky, and you think to yourself,
          "Why is it that the sky is moving, but the ice is still?"
          And also-- Where is it that you're from?
        """
        props: [
          tunnel:
            alphaFn: (t) ->
              Math.sin((t / 6) * Math.TAU) * 0.3 + 0.7
            yFn: (t) ->
              App.width / 3 +
              Math.sin((t / 0.5 - 0.25) * Math.TAU) * 7 +
              Math.sin((t / 0.2 + 0.25) * Math.TAU) * 3
            xFn: (t) ->
              t = t % 2
              App.width / 2 + (t/2 * App.width)
            zIndex: -1
          tunnel2:
            alphaFn: (t) ->
              Math.sin((t / 6) * Math.TAU) * 0.3 + 0.7
            yFn: (t) ->
              App.width / 3 +
              Math.sin((t / 0.9 + 0.25) * Math.TAU) * 7 +
              Math.sin((t / 0.2 - 0.25) * Math.TAU) * 3
            xFn: (t) ->
              t = t % 2
              -App.width / 2 + (t/2 * App.width)
            zIndex: -1
          blink:
            alphaFn: (t) ->
              t = t % 10

              blinkDuration = 0.05

              [
                0.95
                3.36
                7.8
              ].inject(false, (blinking, blinkTime) ->
                blinking or (blinkTime <= t <= (blinkTime + blinkDuration))
              ) | 0
          "body"
          head:
            registrationPoint: Point(-50, 80)
            rotationFn: (t) ->
              Math.sin((t / 5) * Math.TAU) * Math.TAU / 64 +
              Math.sin((t / 3 - 0.25) * Math.TAU) * Math.TAU / 128
          mic_hand:
            registrationPoint: Point(-80, 200)
            rotationFn: (t) ->
              Math.sin((t / 5) * Math.TAU) * Math.TAU / 64 +
              Math.sin((t / 3 - 0.25) * Math.TAU) * Math.TAU / 128
          paw:
            registrationPoint: Point(-0, 180)
            rotationFn: (t) ->
              Math.sin((t / 5) * Math.TAU) * Math.TAU / 64 +
              Math.sin((t / 3 - 0.25) * Math.TAU) * Math.TAU / 128
        ]
        nextState: MapState
      hiss:
        text: """
          What do you like BEST about the Serpentmen?

          They BIT me! WooOo!
        """
        props: [
          plane:
            xFn: (t) ->
              App.width - 120 + 15 * t
            yFn: (t) ->
              20 - 1 * t
          balloons:
            x: 95
            yFn: (t) ->
              80 - t * 20
          tail:
            registrationPoint: Point(-370, 170)
            rotationFn: (t) ->
              Math.sin((t / 5) * Math.TAU) * Math.TAU / 64 +
              Math.sin((t / 3 - 0.25) * Math.TAU) * Math.TAU / 128

          "body"
          head:
            registrationPoint: Point(-250, 0)
            rotationFn: (t) ->
              Math.sin((t / 5) * Math.TAU) * Math.TAU / 64 +
              Math.sin((t / 3 - 0.25) * Math.TAU) * Math.TAU / 128
          arm:
            registrationPoint: Point(-245, 45)
            rotationFn: (t) ->
              Math.TAU / 64 +
              Math.sin((t / 5) * Math.TAU) * Math.TAU / 64 +
              Math.sin((t / 3 - 0.25) * Math.TAU) * Math.TAU / 128
            y: App.height / 3 + 20
            x: App.width / 2 - 20
          skeeroy:
            x: 600
            y: 350
          jerls:
            y: 300
            x: App.width * 3/4
        ]
      smiley:
        text: """
          Here's a fan now! Hello sir, why are YOU smiling?

          How the HELL should I know?
        """
        props: [
          arm:
            y: App.height / 3 + 10
            rotationFn: (t) ->
              Math.sin((t / 2) * Math.TAU) * Math.TAU / 600 +
              Math.sin((t / 3 + 0.5) * Math.TAU) * Math.TAU / 980

            registrationPoint: Point(0, 256)
          reporter:
            y: App.height / 3 + 10
            rotationFn: (t) ->
              Math.sin((t / 2) * Math.TAU) * Math.TAU / 600

            registrationPoint: Point(0, 256)
          fan:
            xFn: (t) ->
              App.width / 2 + Math.sin((t / 0.15) * Math.TAU) * 2 + Math.sin((t / 0.04) * Math.TAU) * 1
            yFn: (t) ->
              App.height / 3

        ]
      spike:
        text: ""
        props: [
          chick:
            x: App.width/2
            y: App.height/3
            rotationFn: (t) ->
              Math.sin((t / 0.9 + 0.05) * Math.TAU) * Math.TAU / 600
            registrationPoint: Point(-240, 100)

          reporter:
            xFn: (t) ->
              App.width / 2 + Math.sin((t / 0.9) * Math.TAU) * 10 + Math.sin((t / 0.1) * Math.TAU) * 2
            yFn: (t) ->
              App.height / 3
        ]
      mutant:
        text: """
          MUTANT FEVER! The fans are out in record numbers. Please be advised to stay indoors--
          There is no cure.
        """
        props: [
          head:
            x: 370
            y: 175
            registrationPoint: Point(-80, 150)
            rotationFn: (t) ->
              Math.sin((t / 15) * Math.TAU) * Math.TAU / 256 +
              Math.sin((t / 4 - 0.5) * Math.TAU) * Math.TAU / 128
          arm:
            registrationPoint: Point(-320, 78)
            rotationFn: (t) ->
              Math.sin((t / 15) * Math.TAU) * Math.TAU / 90 +
              Math.sin((t / 5 - 0.25) * Math.TAU) * Math.TAU / 20
          boom:
            x: 750
            y: 20
            registrationPoint: Point(512, 256)
            rotationFn: (t) ->
              Math.sin((t / 15) * Math.TAU) * Math.TAU / 256 +
              Math.sin((t / 4 - 0.25) * Math.TAU) * Math.TAU / 1024
          "tv"
        ]
      monster:
        team: "none" # Go to second cutscene
        text: """
          Ok... show me how it's done.
        """
        props: [
          dog:
            x: 750
            y: 250
            registrationPoint: Point(0, 256)
            rotationFn: (t) ->
              Math.sin((t / 15 - 0.25) * Math.TAU) * Math.TAU / 1024 +
              Math.sin((t / 4 - 0.5) * Math.TAU) * Math.TAU / 1024
          mummy:
            x: 200
            y: 300
            registrationPoint: Point(0, 256)
            rotationFn: (t) ->
              Math.sin((t / 15) * Math.TAU) * Math.TAU / 1024 +
              Math.sin((t / 4 - 0.5) * Math.TAU) * Math.TAU / 1024

        ]
        nextState: ->
          Cutscene.scenes.monster2
      monster2:
        team: "monster"
        text: """

        """
        props: [
          bugman_shad:
            x: 90
            y: 530
            yFn: danceYFnGen(530, 1)
            scaleXFn: danceScaleXFn
          bugman:
            x: 200
            y: 250
            yFn: danceYFnGen(250)
            scaleXFn: danceScaleXFn
          vampire_shad:
            x: 375
            y: 550
            yFn: danceYFnGen(550, 1)
            scaleXFn: danceScaleXFn
          vampire:
            x: 400
            y: 260
            yFn: danceYFnGen(260)
            scaleXFn: danceScaleXFn
          mummy_shad:
            x: 630
            y: 550
            yFn: danceYFnGen(550, 1)
            scaleXFn: danceScaleXFn
          mummy:
            x: 600
            y: 275
            yFn: danceYFnGen(275)
            scaleXFn: danceScaleXFn
          dog_shad:
            x: 1005
            y: 600
            yFn: danceYFnGen(600, 1)
            scaleXFn: danceScaleXFn
          dog:
            x: 850
            y: 250
            yFn: danceYFnGen(250)
            scaleXFn: danceScaleXFn
        ]
      robo:
        text: """
          This is what it's all about.
        """

    for name, data of Cutscene.scenes
      data.background = Sprite.loadByName "cutscenes/#{name}/background"
      data.team ||= name
      data.props = (data.props || []).map (prop, i) ->
        if prop.isString
          sprite: Sprite.loadByName "cutscenes/#{name}/#{prop}"
        else
          Object.keys(prop).map (propName) ->
            Object.extend {},
              sprite: Sprite.loadByName "cutscenes/#{name}/#{propName}"
            , prop[propName]

      .flatten().map (datum, i) ->
        Object.reverseMerge datum,
          class: "Prop"
          zIndex: i

      Cutscene.scenes[name] = Cutscene data

  AssetLoader.load "cutscenes"
