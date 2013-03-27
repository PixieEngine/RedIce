do ->
  if persistentConfig = Local.get(PERSISTENT_CONFIG)
    # TODO: Whitelist properties
  else
    persistentConfig =
      musicVolume: 0.5
      sfxVolume: 0.5

  window.persistentConfig = persistentConfig

  window.persistConfig = ->
    Local.set(PERSISTENT_CONFIG, persistentConfig)

  persistConfig()

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
