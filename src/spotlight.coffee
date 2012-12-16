Spotlight = (I={}) ->
  Object.reverseMerge I,
    x: App.width/2
    y: App.height/2
    spriteOffset: Point(0, -40)
    team: "smiley"
    zIndex: 5

  self = GameObject(I)

  self.bind "update", ->
    I.sprite = Spotlight.sprites.on

  # Draw logo
  self.bind "draw", (canvas) ->
    if logo = Configurator.images[I.team].logo
      canvas.withTransform Matrix.scale(0.75, 0.75), ->
        logo.draw(canvas, -logo.width/2, -logo.height/2 - 64)

  self

Spotlight.sprites =
  on: Sprite.loadByName "spotlight_on"
  off: Sprite.loadByName "spotlight_off"
