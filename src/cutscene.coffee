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

    dialog = engine.add
      class: "DialogBox"
      text: I.text
      y: 2/3*App.height

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
    ].each (property) ->
      if fn = I["#{property}Fn"]
        I[property] = fn(I.age)

  return self

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
      background: "tailgate_serpentmen"
    smiley:
      text: """
        Here's a fan now! Hello sir, why are YOU smiling?

        How the HELL should I know?
      """
      background: "smiley_arena"
    spike:
      text: ""
      background: "spike_fans"
    mutant:
      text: """
        MUTANT FEVER! The fans are out in record numbers. Please be advised to stay indoors--
        There is no cure.
      """
      background: "mutant_fever"
    monster:
      text: """
        Ok... show me how it's done.
      """
      background: "monster_graveyard"
    robo:
      text: """
        This is what it's all about.
      """
      background: "on_da_moon"

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
