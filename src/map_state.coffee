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

    [home, away] = config.players.partition (playerData) ->
      playerData.teamIndex

    # TODO: Load Assets here instead of all upfront
    config.homeTeam = nextTeam
    config.awayTeam = config.playerTeam

    home.each (red, i) ->
      red.slot = i
      red.y = WALL_TOP + ARENA_HEIGHT * (i + 1) / (away.length + 1)
      red.x = WALL_LEFT + ARENA_WIDTH/2 + ARENA_WIDTH / 6
      red.heading = 0.5.rotations
      red.teamStyle = config.homeTeam

    away.each (blue, i) ->
      blue.slot = i
      blue.y = WALL_TOP + ARENA_HEIGHT * (i + 1) / (home.length + 1)
      blue.x = WALL_LEFT + ARENA_WIDTH/2 - ARENA_WIDTH / 6
      blue.teamStyle = config.awayTeam

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

  self.on "enter", ->
    if nextTeam
      engine.add
        class: "Map"
        nextTeam: nextTeam
        lastTeam: lastTeam
    else
      engine.delay 1, ->
        engine.setState Cutscene.scenes.end

  return self
