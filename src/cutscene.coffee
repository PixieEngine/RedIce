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
      "alpha"
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
      background: "intro"
      props: [
        "train"
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
        body:
          rotationPoint: Point()
        "head"
        "mic_hand"
        "paw"
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
      Object.extend datum,
        class: "Prop"
        zIndex: i

    Cutscene.scenes[name] = Cutscene data

AssetLoader.load "cutscenes"
