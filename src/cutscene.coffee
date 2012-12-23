Cutscene = (I={}) ->
  Object.reverseMerge I,
    text: "Go home and be a family man."

  # Inherit from game object
  self = GameState(I)

  self.bind "enter", ->
    img = engine.add
      sprite: I.sprite
      x: App.width/2
      y: App.height/3

    engine.add
      class: "DialogBox"
      text: I.text
      y: 2/3*App.height

  return self

AssetLoader.group "cutscenes", ->
  Cutscene.scenes = [
    Cutscene(
      text: """
        Look out the window. And doesn't this remind you of when you were in the boat?

        And then later that night you were lying on the ice, looking up at the ceiling,

        and the water in your mind was not dissimilar from the skyscape, and you think to yourself,

        "Why is it that the skyscape is moving, but the ice is still?"

        And also-- Where is it that you're from?
      """
      sprite: Sprite.loadByName "cutscenes/train"
    )
  ]

AssetLoader.load "cutscenes"
