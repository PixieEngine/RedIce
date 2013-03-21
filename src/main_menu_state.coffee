MainMenuState = (I={}) ->
  # Inherit from game object
  self = GameState(I)

  self.on "enter", ->
    # Reset config modes
    Object.extend config,
      storyMode: false
      homeTeam: teamChoices[1]
      awayTeam: teamChoices[0]
      playerTeam: null
      defeatedTeams: []

    engine.delay 0.25, ->
      engine.delay 0.5, ->
        engine.add
          class: "Menu"

      title = engine.add
        sprite: MainMenuState.titleSprite
        x: App.width/2
        y: App.height/3 - 50
        alpha: 0
        scale: 0

      title.on "update", ->
        title.I.scale = title.I.age.clamp(0, 1)
        title.I.alpha = title.I.age.clamp(0, 1)

    Music.play "Theme to Red Ice"

  idleSince = 0
  self.on "update", (dt) ->
    idleSince += dt
    active = engine.controllers().inject false, (memo, controller) ->
      memo || (controller.actionDown("ANY") || (!controller.tap().equal(Point.ZERO)))

    if active
      idleSince = 0
    else if idleSince >= 25
      engine.setState(AttractMode())

  # We must always return self as the last line
  return self

MainMenuState.titleSprite = Sprite.loadByName "title_text"
