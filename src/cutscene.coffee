Cutscene = (I={}) ->
  Object.reverseMerge I,
    text: ""
    nextState: MatchState
    props: []

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

  self.on "overlay", (canvas) ->
    if DEBUG_DRAW
      engine.objects().invoke "trigger", "drawDebug", canvas

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

    Music.pause() if I.silence
    Music.play I.music if I.music

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
      "scale"
    ].each (property) ->
      if fn = I["#{property}Fn"]
        I[property] = fn(I.age)

  self.on "beforeUpdate", ->
    if I.frames
      I.sprite = I.spriteSheet.wrap((I.age / I.frameDuration).floor())

  self.bind "drawDebug", (canvas) ->
    canvas.withTransform self.transform(), (canvas) ->
      canvas.drawCircle
        x: I.registrationPoint.x
        y: I.registrationPoint.y
        radius: 5
        color: "#F0F"

  return self

osc = ({period, amplitude, offset, min, max}) ->
  offset ?= 0
  period ?= 1

  if min? and max?
    amplitude = (max - min) / 2
    min += amplitude
  else
    min = 0

  amplitude ?= 1

  return (t) ->
    Math.sin((t / period) * Math.TAU + offset) * amplitude + min

motionOfTheOcean = ->
  min = 256
  max = 280

  osc1 = osc
    min: 256 + 2
    max: 280 - 2
    period: 10

  osc2 = osc
    period: 3
    amplitude: 2

  (t) ->
    (osc1(t) + osc2(t)).clamp(min, max)

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
        music: "Pause"
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
        music: "Snake Or Die"
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
          snake:
            frames: 3
            frameDuration: 0.4
            x: 50
            y: 65
            width: 39
            height: 98
            registrationPoint: Point(0, 49)
            rotationFn: (t) ->
              Math.sin((t / 1.3 + 0.25) * Math.TAU) * Math.TAU / 64 +
              Math.sin((t / 2.5) * Math.TAU) * Math.TAU / 128
          drunk:
            frames: 2
            frameDuration: 2
            x: 442
            y: 126
            width: 72
            height: 106
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
            rotationFn: (t) ->
              Math.sin((t / 11) * Math.TAU) * Math.TAU / 128 +
              Math.sin((t / 1.1 - 0.5) * Math.TAU) * Math.TAU / 128

            x: 600
            y: 350
            registrationPoint: Point(0, 200)

          jerls:
            rotationFn: (t) ->
              Math.sin((t / 4) * Math.TAU) * Math.TAU / 64 +
              Math.sin((t / 7 - 0.5) * Math.TAU) * Math.TAU / 128
            y: 300
            x: 770
            registrationPoint: Point(0, 200)

          fan1_blood:
            rotationFn: (t) ->
              Math.sin((t / 11) * Math.TAU) * Math.TAU / 128 +
              Math.sin((t / 1.1 - 0.5) * Math.TAU) * Math.TAU / 128

            frames: 3
            frameDuration: 0.2
            width: 135
            height: 81
            x: 517
            y: 232
            registrationPoint: Point(83, 318)

          fan2_blood:
            rotationFn: (t) ->
              Math.sin((t / 4) * Math.TAU) * Math.TAU / 64 +
              Math.sin((t / 7 - 0.5) * Math.TAU) * Math.TAU / 128

            frameDuration: 0.2
            frames: 3
            width: 105
            height: 101
            x: 725
            y: 112
            registrationPoint: Point(45, 388)
        ]
      smiley:
        text: """
          Here's a fan now! Hello sir, why are YOU smiling?

          How the HELL should I know?
        """
        music: "Smiley Smile"
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
        music: "Spiked Punch"
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
        music: "Substantially Sumo"
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
        music: "Monsters Don't Get Cold"
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
            x: 200
            y: 530
            yFn: danceYFnGen(570, 1)
            scaleXFn: danceScaleXFn
          bugman:
            x: 200
            y: 250
            yFn: danceYFnGen(250)
            scaleXFn: danceScaleXFn
          vampire_shad:
            x: 400
            y: 550
            yFn: danceYFnGen(570, 1)
            scaleXFn: danceScaleXFn
          vampire:
            x: 400
            y: 260
            yFn: danceYFnGen(260)
            scaleXFn: danceScaleXFn
          mummy_shad:
            x: 600
            y: 550
            yFn: danceYFnGen(560, 1)
            scaleXFn: danceScaleXFn
          mummy:
            x: 600
            y: 275
            yFn: danceYFnGen(275)
            scaleXFn: danceScaleXFn
          dog_shad:
            x: 850
            y: 600
            yFn: danceYFnGen(590, 1)
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
        music: "Credits"
        props: [
          boat:
            yFn: motionOfTheOcean()
          hotdogman:
            frames: 2
            frameDuration: 0.8
            width: 336 / 2
            height: 134
            yFn: do ->
              fn = motionOfTheOcean()

              (t) ->
                fn(t) + 35

            x: 360

          arm:
            yFn: motionOfTheOcean()
            registrationPoint: Point(-20, 128)
            rotationFn: osc
              amplitude: Math.TAU / 64
              period: 4
          body:
            yFn: motionOfTheOcean()
          duder_arm:
            yFn: motionOfTheOcean()
            xFn: do ->
              x = App.width/2
              fn = osc
                amplitude: 4
                period: 5
              fn2 = osc
                amplitude: 2
                period: 3

              (t) ->
                x + fn(t) + fn2(t)
          duder_body:
            yFn: motionOfTheOcean()
        ]
      end:
        text: """
        This is not possible.... We were programmed to NEVER LOSE!
        """
        props: [
          flash:
            noSprite: true
            alphaFn: do ->
              fn = osc
                amplitude: 1
                period: 1.5
              fn2 = osc
                amplitude: 0.5
                period: 0.4
              fn3 = osc
                amplitude: 0.25
                period: 0.17

              (t) ->
                (fn(t) + fn2(t) + fn3(t)).clamp(0, 1)

            color: "#FFF"
            width: App.width
            height: App.height
        ]
        nextState: ->
          Cutscene.scenes.end2
      end2:
        text: """
        And so it ends...
        """
        music: "Credits"
        props: [
          moonhalf:
            scaleFn: (t) ->
              1 + t * 1/300
          rock:
            scaleFn: (t) ->
              1 + t * 1/100
          hunks:
            scaleFn: (t) ->
              1 + t * 1/95
          boatfront:
            xFn: (t) ->
              512 + 5 * t
            yFn: (t) ->
              256 - 1 * t
            scaleFn: (t) ->
              1 - t * 1/250
            rotationFn: (t) ->
              Math.TAU * -t / 200
            registrationPoint: Point(326, -140)
          water:
            scaleFn: (t) ->
              1 + t * 1/90
          boat_debris:
            scaleFn: (t) ->
              1 + t * 1/130
          people:
            scaleFn: (t) ->
              1 + t * 1/120
          people2:
            scaleFn: (t) ->
              1 + t * 1/110
          boatrear:
            xFn: (t) ->
              512 - 2 * t
            yFn: (t) ->
              256 + 2 * t
            rotationFn: (t) ->
              Math.TAU * t / 1000
            scaleFn: (t) ->
              1 + t * 1/150
            registrationPoint: Point(0, 256)
          flash:
            noSprite: true
            alphaFn: (t) ->
              (1 - t/2).clamp(0, 1)
            color: "#FFF"
            width: App.width
            height: App.height
        ]

    for name, data of Cutscene.scenes
      data.background = Sprite.loadByName "cutscenes/#{name}/background"
      data.team ||= name
      data.props = (data.props || []).map (prop, i) ->
        if prop.isString
          sprite: Sprite.loadByName "cutscenes/#{name}/#{prop}"
        else
          Object.keys(prop).map (propName) ->
            propData = prop[propName]

            if propData.noSprite
              # Do nothing
            else if frames = propData.frames
              propData.spriteSheet = Sprite.loadSheet "cutscenes/#{name}/#{propName}_#{frames}", propData.width, propData.height
            else
              sprite = Sprite.loadByName "cutscenes/#{name}/#{propName}"

            Object.extend {},
              sprite: sprite
            , propData

      .flatten().map (datum, i) ->
        Object.reverseMerge datum,
          class: "Prop"
          zIndex: i

      Cutscene.scenes[name] = Cutscene data

    gameOverTexts =
      hiss: "Snake? Snake?! SNAAAAAAAKKKKEEE!!!"
      spike: "Go home and be a family man!"
      mutant: "Call yourselves the ultimate team? Don't make me laugh!"
      robo: "But... the future refused to change."
      monster: "You've met with a terrible fate, haven't you?"
      smiley: "Oh... wow..."

    Cutscene.gameOver = {}
    TEAMS.each (team) ->
      Cutscene.gameOver[team] = Cutscene
        background: Sprite.loadByName "cutscenes/game_over/#{team}"
        nextState: MainMenuState
        text: gameOverTexts[team]

  AssetLoader.load "cutscenes"
