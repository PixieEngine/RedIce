MapState = (I={}) ->
  self = GameState(I)

  playerTeam = config.playerTeam
  defeatedTeams = config.defeatedTeams

  remainingTeams = TEAMS.without([playerTeam].concat(defeatedTeams))
  lastTeam = [playerTeam].concat(defeatedTeams).last()
  nextTeam = remainingTeams.first()

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
