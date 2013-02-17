MatchSetupState = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  # (Re-)Initialize Player data between matches
  initPlayerData = ->
    MAX_PLAYERS.times (i) ->
      Object.reverseMerge config.players[i] ||= {},
        class: "Player"
        color: Player.COLORS[i]
        id: i
        name: ""
        teamIndex: Math.floor(2 * i / MAX_PLAYERS)
        bodyIndex: rand(TeamSheet.bodyStyles.length)
        headIndex: rand(TeamSheet.headStyles.length)

      # Reset Configuration data
      Object.extend config.players[i],
        cpu: true
        optionIndex: undefined
        ready: false

    return config

  self.on "enter", ->
    engine.clear(false)

    activePlayers = config.players.inject 0, (total, data) ->
      if data.cpu
        total
      else
        total + 1

    configurator = engine.add
      class: "Configurator"
      config: initPlayerData()
      activePlayers: 0 # activePlayers

    configurator.on "done", (config) ->
      configurator.destroy()

      #TODO We should use strings to set game states
      engine.setState(MatchState())

  return self

