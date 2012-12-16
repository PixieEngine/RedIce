MapState = (I={}) ->
  self = GameState(I)

  # TODO: Set Opponent team data
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
    engine.add
      class: "Map"

  return self
