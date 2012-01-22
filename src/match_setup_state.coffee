MatchSetupState = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  # (Re-)Initialize Player data between matches 
  initPlayerData = ->
    MAX_PLAYERS.times (i) ->
      $.reverseMerge config.players[i] ||= {},
        class: "Player"
        color: Player.COLORS[i]
        id: i
        name: ""
        team: i % 2
        joystick: true
        cpu: true
        bodyStyle: if i.even() then "tubs" else "skinny"
        headIndex: 0

      $.extend config.players[i],
        ready: false
        cpu: true

    return config

  self.bind "enter", ->
    engine.clear(false)

    Music.volume 0.4
    Music.play "title_screen"

    configurator = engine.add
      class: "Configurator"
      config: initPlayerData()
      x: 240
      y: 240

    configurator.bind "done", (config) ->
      configurator.destroy()

      #TODO We should use strings to set game states
      engine.setState(MatchState())

  return self

