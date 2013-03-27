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
    engine.clear(true)

    center = Point(App.width, App.height).scale(0.5)

    # TODO: Test only, get real data from configurator
    n = 4
    n.times (i) ->
      {x, y} = Point.fromAngle(i * Math.TAU/4).scale(100).add(center)

      player = engine.add
        class: "Player"
        id: i
        x: x
        y: y

      I.playerIncludes.each (name) ->
        player.include Player[name]

    # Add each player to game based on config data
    config.players.each (playerData) ->
      engine.add Object.extend({}, playerData)

    Music.play I.music

  return self
