window.engine = Engine 
  canvas: $("canvas").powerCanvas()
  includedModules: "Tilemap"

# Add a red square to the scene
engine.loadMap "start", ->
  engine.add
    class: "Player"
    location: "start"

engine.start()

leversTriggered = {}
window.triggerLever = (name) ->
  leversTriggered[name] = true

window.leverTriggered = (name) ->
  leversTriggered[name]

parent.gameControlData =
  Movement: "Arrow Keys"
  "Deploy/Return Cat": "Spacebar"
  "Place Bomb": "Enter"

