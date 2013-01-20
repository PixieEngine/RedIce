MapState = (I={}) ->
  self = GameState(I)

  playerTeam = config.playerTeam
  defeatedTeams = config.defeatedTeams

  remainingTeams = TEAMS.without([playerTeam].concat(defeatedTeams))
  lastTeam = [playerTeam].concat(defeatedTeams).last()
  nextTeam = config.opponentTeam = remainingTeams.first()

  initTeamData = ->
    # (Re-)Initialize Player data between matches
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

      Object.extend config.players[i],
        ready: false
        cpu: true

    [away, home] = config.players.partition (playerData) ->
      playerData.teamIndex

    # TODO: Load Assets here instead of all upfront
    teamStyles = [config.playerTeam, nextTeam]

    # TODO: Set Arena

    away.each (red, i) ->
      red.slot = i
      red.y = WALL_TOP + ARENA_HEIGHT * (i + 1) / (away.length + 1)
      red.x = WALL_LEFT + ARENA_WIDTH/2 + ARENA_WIDTH / 6
      red.heading = 0.5.rotations
      red.teamStyle = teamStyles[1] # TODO: Real away team

    home.each (blue, i) ->
      blue.slot = i
      blue.y = WALL_TOP + ARENA_HEIGHT * (i + 1) / (home.length + 1)
      blue.x = WALL_LEFT + ARENA_WIDTH/2 - ARENA_WIDTH / 6
      blue.teamStyle = teamStyles[0] # TODO: Real Player team

    # TODO: Preload teams
    # TODO: Merge in p1/p2 data
    # TODO: Set next team

    return config

  initTeamData()

  # TODO: Set Opponent team data
  setOpponentData = ->
    [2, 3].each (i) ->

      Object.extend config.players[i],
        ready: false
        cpu: true

  # Preload Next Team
  AssetLoader.load(nextTeam)

  self.bind "enter", ->
    engine.add
      class: "Map"
      nextTeam: nextTeam
      lastTeam: lastTeam

  return self
