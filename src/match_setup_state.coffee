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
        teamIndex: i % 2
        joystick: true
        cpu: true
        bodyIndex: rand(TeamSheet.bodyStyles.length)
        headIndex: rand(TeamSheet.headStyles.length)

      $.extend config.players[i],
        ready: false
        cpu: true

    return config

  self.bind "enter", ->
    engine.clear(false)

    rink.hide()

    if config.music
      Music.volume 0.4
      Music.play "title_screen"

    configurator = engine.add
      class: "Configurator"
      config: initPlayerData()

    configurator.bind "done", (config) ->
      configurator.destroy()

      #TODO We should use strings to set game states
      engine.setState(MatchState())

  return self

