MainMenuState = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  self.on "enter", ->
    # Reset config modes
    params = queryString()
    teamChoices = [params.team1, params.team2].compact()
    teamChoices = teamChoices.concat(TEAMS.without(teamChoices))

    # TODO move preloading to just prior to usage
    teamChoices.each (name) ->
      teamSprites[name] = TeamSheet
        team: name

    Object.extend config,
      storyMode: false
      homeTeam: teamChoices[1]
      awayTeam: teamChoices[0]
      playerTeam: null
      defeatedTeams: []

    engine.add
      class: "Menu"

    engine.add
      sprite: "title_text"
      x: App.width/2
      y: App.height/3 - 50

    Music.play "Theme to Red Ice"

  # We must always return self as the last line
  return self
