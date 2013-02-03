StoryConfigState = (I={}) ->
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
        cpu: true
        bodyIndex: rand(TeamSheet.bodyStyles.length)
        headIndex: rand(TeamSheet.headStyles.length)
        teamStyle: config.playerTeam

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

      [cpus, players] = config.players.partition (data) ->
        data.cpu

      if players.length is 1
        players.push cpus.pop()

      players.each (data) ->
        data.teamIndex = 0

      cpus.each (data) ->
        data.teamIndex = 1

      #TODO We should use strings to set game states
      engine.setState(MapState())

  return self

