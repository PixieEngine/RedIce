Configurator = (I) ->
  slotWidth = App.width / 6

  Object.reverseMerge I,
    activePlayers: 0
    font: "bold 32px 'Monaco', 'Inconsolata', 'consolas', 'Courier New', 'andale mono', 'lucida console', 'monospace'"
    maxPlayers: MAX_PLAYERS
    width: App.width
    height: App.height
    x: (App.width - slotWidth * config.players.length) / 2
    y: 0

  lineHeight = 11
  verticalPadding = 24
  horizontalPadding = 0

  if config.playerTeam
    teamStyles = [config.playerTeam]
  else
    teamStyles = config.teams[0..1]

  join = (id) ->
    player = I.config.players[id]

    # Can only join in over existing CPU players
    return unless player.cpu

    player.cpu = false
    player.ready = false
    I.activePlayers += 1

    addNameEntry(player)

  addNameEntry = (player) ->
    id = player.id
    backgroundColor = Color(player.color)
    backgroundColor.a = 0.5

    cursorColor = backgroundColor.lighten(0.25)

    nameEntry = engine.add
      backgroundColor: backgroundColor
      class: "NameEntry"
      controller: id
      cursorColor: cursorColor
      name: player.name
      x: I.x + id * slotWidth + 4
      y: I.y + 40

    nameEntry.bind "change", (name) ->
      player.name = name

    nameEntry.bind "done", (name) ->
      nameEntry.destroy()

      player.name = name
      player.optionIndex = 0
      player.tapListener = (p) ->
        return if player.ready

        if p.y
          # Move Cursor
          player.optionIndex = (player.optionIndex + p.y).clamp(0, Configurator.options.length - 1)
        else
          # TODO Scope to when team icon is active
          if (currentOption = Configurator.options[player.optionIndex])
            if currentOption.action
            else
              player[currentOption.name] += p.x

  unbindTapEvents = ->
    I.config.players.each (player) ->
      player.tapListener = null

  finalizeConfig = (config) ->
    [cpus, humans] = config.players.partition (playerData) ->
      playerData.cpu

    [away, home] = humans.partition (playerData) ->
      playerData.team = playerData.teamIndex.mod(teamStyles.length)

    # Rebalance CPU players as needed
    while (home.length < I.maxPlayers / 2) && cpus.length
      cpu = cpus.pop()
      cpu.team = 0

      home.push cpu

    while (away.length < I.maxPlayers / 2) && cpus.length
      cpu = cpus.pop()
      cpu.team = 1

      away.push cpu

    # Repartition now that we've balanced
    [away, home] = config.players.partition (playerData) ->
      playerData.team

    #TODO Add in team style data

    away.each (red, i) ->
      red.slot = i
      red.y = WALL_TOP + ARENA_HEIGHT * (i + 1) / (away.length + 1)
      red.x = WALL_LEFT + ARENA_WIDTH/2 + ARENA_WIDTH / 6
      red.heading = 0.5.rotations
      red.teamStyle = teamStyles.last()

    home.each (blue, i) ->
      blue.slot = i
      blue.y = WALL_TOP + ARENA_HEIGHT * (i + 1) / (home.length + 1)
      blue.x = WALL_LEFT + ARENA_WIDTH/2 - ARENA_WIDTH / 6
      blue.teamStyle = teamStyles.first()

    return config

  self = GameObject(I).extend
    draw: (canvas) ->
      canvas.font I.font

      self.trigger "beforeTransform", canvas

      canvas.withTransform Matrix.translation(I.x, I.y), ->
        I.config.players.each (player, i) ->
          y = 0
          x = player.id * slotWidth

          if player.cpu
            name = "CPU"
            color = Color(Player.CPU_COLOR)
          else
            name = player.name || "P#{(player.id + 1)}"

          nameWidth = canvas.measureText(name)

          player.headStyle = TeamSheet.headStyles.wrap(player.headIndex) || "stubs"
          player.bodyStyle = TeamSheet.bodyStyles.wrap(player.bodyIndex) || "thick"
          player.teamStyle = teamStyles.wrap(player.teamIndex)

          Configurator.images[player.teamStyle].background.draw(canvas, x, 0)
          if player.optionIndex? and !player.ready
            Configurator.active.draw(canvas, x, Configurator.options[player.optionIndex].y)
          Configurator.border.draw(canvas, x, 0)
          Configurator.images[player.teamStyle].nameBubble.draw(canvas, x, 0)
          Configurator.images[player.teamStyle].logo.draw(canvas, x - 42, 375)
          if player.ready
            Configurator.images[player.teamStyle].readyBubbleActive.draw(canvas, x, I.height - 62)
          else
            Configurator.images[player.teamStyle].readyBubble.draw(canvas, x, I.height - 62)

          canvas.centerText
            text: name
            x: x + I.width / 12 + 2
            y: y + lineHeight + verticalPadding + 1
            color: "black"

          canvas.centerText
            text: name
            x: x + I.width / 12
            y: y + lineHeight + verticalPadding
            color: "white"

          y = I.height/2 - 50
          x += I.width/12

          canvas.withTransform Matrix.translation(x, y), (canvas) ->
            # Draw Body Sprite
            if bodySprite = teamSprites[player.teamStyle][player.bodyStyle].slow.front[0]
              bodySprite.draw(canvas, -bodySprite.width/2 - 10, -bodySprite.height/2)

            # Draw Head Sprite
            if headSprite = teamSprites[player.teamStyle][player.headStyle].normal[0]
              headSprite?.draw(canvas, -headSprite.width/2 + 10, -headSprite.height/2 - 40)

  self.on "update", ->
    I.maxPlayers.times (i) ->
      controller = engine.controller(i)

      if controller.actionDown "ANY"
        join(i)

      if (player = I.config.players[i])
        player.tapListener?(controller.tap())

        if (currentOption = Configurator.options[player.optionIndex])
          if currentOption.action == "toggle"
            if controller.actionDown("A")
              player[currentOption.name] = true

            if controller.actionDown("B")
              player[currentOption.name] = false

    readyPlayers = I.config.players.select((player) -> player.ready)

    if readyPlayers.length == I.activePlayers && readyPlayers.length > 0
      unbindTapEvents()
      self.trigger "done", finalizeConfig(I.config)

  return self

Configurator.images = {}
[
  ["blue", "smiley"]
  ["red", "spike"]
  ["purple", "mutant"]
  ["green", "hiss"]
  ["orange", "monster"]
  ["cyan", "robo"]
].map ([team, style]) ->
  Configurator.images[style] =
    background: Sprite.loadByName("gameselect_back_#{team}")
    nameBubble: Sprite.loadByName("gameselect_namebubble_#{team}")
    readyBubble: Sprite.loadByName("gameselect_readybubble_#{team}")
    readyBubbleActive: Sprite.loadByName("gameselect_readybubble2_#{team}")
    logo: Sprite.loadByName("gameselect_#{style}logo")

Configurator.ready = []

Configurator.active = Sprite.loadByName("gameselect_selectglow")
Configurator.border = Sprite.loadByName("gameselect_borders")

Configurator.options = [
  {
    name: "headIndex"
    y: 200
  }, {
    name: "bodyIndex"
    y: 250
  }, {
    name: "teamIndex"
    y: 400
  }, {
    name: "ready"
    action: "toggle"
    y: 650
  }
]

