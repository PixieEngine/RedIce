window.engine = Engine 
  canvas: $("canvas").powerCanvas()

engine.add
  sprite: Sprite.loadByName "title"

engine.add
  class: "Player"

engine.add
  class: "Player"
  controller: 1

engine.start()

