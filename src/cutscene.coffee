Cutscene = (I={}) ->
  Object.reverseMerge I,
    text: "Go home and be a family man."
    nextState: MapState

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

# TODO more robust timing of loading cutscenes
$ ->
  AssetLoader.group "cutscenes", ->
    Cutscene.scenes = [
      Cutscene(
        text: """
          Look out the window. And doesn't this remind you of when you were in the boat?
          And then later that night you were lying, looking up at the ceiling,
          and the static in your mind was not dissimilar from the sky, and you think to yourself,
          "Why is it that the sky is moving, but the ice is still?"
          And also-- Where is it that you're from?
        """
        sprite: Sprite.loadByName "cutscenes/train"
      )
    ]

  AssetLoader.load "cutscenes"
