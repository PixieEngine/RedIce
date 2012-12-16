TournamentSetupState = (I={}) ->
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
        cpu: i != 0
        bodyIndex: rand(TeamSheet.bodyStyles.length)
        headIndex: rand(TeamSheet.headStyles.length)

      Object.extend config.players[i],
        ready: false
        cpu: true

    return config

  self.bind "enter", ->
    engine.clear(false)

    configurator = engine.add
      class: "Configurator"
      config: initPlayerData()

    configurator.bind "done", (config) ->
      configurator.destroy()

      #TODO We should use strings to set game states
      engine.setState(MapState())

  return self
