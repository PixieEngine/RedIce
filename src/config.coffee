do ->
  if persistentConfig = Local.get(PERSISTENT_CONFIG)
    # TODO: Whitelist properties
  else
    persistentConfig =
      musicVolume: 0.5
      sfxVolume: 0.5
      homeTeam: "spike"
      awayTeam: "smiley"

  window.persistentConfig = persistentConfig

  window.persistConfig = ->
    Local.set(PERSISTENT_CONFIG, persistentConfig)

  persistConfig()

  if DEMO_MODE
    teamChoices = TEAMS[0..1]
  else
    persistedTeams = [persistentConfig.homeTeam, persistentConfig.awayTeam].compact()
    teamChoices = persistedTeams.concat(TEAMS.without(persistedTeams))

  $ ->
    # TODO move preloading to just prior to usage
    teamChoices.each (name) ->
      teamSprites[name] = TeamSheet
        team: name

  window.config =
    playerTeam: null
    defeatedTeams: []
    players: []
    particleEffects: true
    musicVolume: 0.5
    sfxVolume: 0.5
    FPS: 60

  # Merge in persistent config
  Object.extend config,
    persistentConfig
