Cutscene = (I={}) ->
  Object.reverseMerge I,
    text: "Go home and be a family man."
    nextState: MatchState

  dialog = null

  next = ->
    if !dialog or dialog.complete()
      engine.setState I.nextState()
    else
      dialog.flush()

  # Inherit from game object
  self = GameState(I)

  self.bind "enter", ->
    img = engine.add
      sprite: I.sprite
      x: App.width/2
      y: App.height/3

    dialog = engine.add
      class: "DialogBox"
      text: I.text
      y: 2/3*App.height

  self.bind "update", ->
    engine.controllers().each (controller) ->
      if controller.buttonPressed "A", "START"
        next()

  return self

# TODO more robust timing of loading cutscenes and assets
$ ->
  AssetLoader.group "cutscenes", ->
    Cutscene.scenes =
      intro:
        text: """
          Look out the window. And doesn't this remind you of when you were in the boat?
          And then later that night you were lying, looking up at the ceiling,
          and the static in your mind was not dissimilar from the sky, and you think to yourself,
          "Why is it that the sky is moving, but the ice is still?"
          And also-- Where is it that you're from?
        """
        sprite: "intro"
        nextState: MapState
      hiss:
        text: """
          What do you like BEST about the Serpentmen?

          They BIT me! WooOo!
        """
        sprite: "tailgate_serpentmen"
      smiley:
        text: """
          Here's a fan now! Hello sir, why are YOU smiling?

          How the HELL should I know?
        """
        sprite: "smiley_arena"
      spike:
        text: ""
        sprite: "spike_fans"
      mutant:
        text: """
          MUTANT FEVER! The fans are out in record numbers. Please be advised to stay indoors--
          There is no cure.
        """
        sprite: "mutant_fever"
      monster:
        text: """
          Ok... show me how it's done.
        """
        sprite: "monster_graveyard"

    for name, data of Cutscene.scenes
      data.sprite = Sprite.loadByName "cutscenes/#{data.sprite}"
      Cutscene.scenes[name] = Cutscene data

  AssetLoader.load "cutscenes"
