Minigames = {}

Minigame = (I={})->
  Object.reverseMerge I,
    music: "Paint"
    playerIncludes: []

  # Inherit from game object
  self = GameState(I)

  self.include PauseHack

  self.addPauseMenu = ->
    engine.add
      class: "Menu"
      minigamePause: true

  self.on "enter", ->
    center = Point(App.width, App.height).scale(0.5)

    config.players.each (playerData, i) ->
      {x, y} = Point.fromAngle(i * Math.TAU/4).scale(100).add(center)

      data = Object.extend {}, playerData,
        x: x
        y: y

      player = engine.add data

      I.playerIncludes.each (name) ->
        player.include Player[name]

    Music.play I.music

  return self
