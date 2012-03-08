Configurator = (I) ->
  Object.reverseMerge I,
    activePlayers: 0
    font: "bold 26px 'Monaco', 'Inconsolata', 'consolas', 'Courier New', 'andale mono', 'lucida console', 'monospace'"
    maxPlayers: 6
    teamColors:
      "0": Color("#0246E3")
      "1": Color("#EB070E")
    width: App.width
    height: App.height
    x: 0
    y: 0

  lineHeight = 11
  verticalPadding = 18
  horizontalPadding = 0

  join = (id) ->
    player = I.config.players[id]

    # Can only join in over existing CPU players
    return unless player.cpu

    player.cpu = false
    player.ready = false
    I.activePlayers += 1

    backgroundColor = Color(player.color)
    backgroundColor.a = 0.5

    cursorColor = backgroundColor.lighten(0.25)

    nameEntry = engine.add
      backgroundColor: backgroundColor
      class: "NameEntry"
      controller: id
      cursorColor: cursorColor
      name: player.name
      x:  id * (App.width / I.maxPlayers)
      y:  20

    nameEntry.bind "done", (name) ->
      nameEntry.destroy()

      player.name = name
      player.tapListener = (p) ->
        unless player.ready # TODO Scope to when team icon is active
          player.team = (player.team + p.x).clamp(0, 1)

      engine.controller(id).bind "tap", player.tapListener

  unbindTapEvents = ->
    I.config.players.each (player) ->
      engine.controller(player.id).unbind "tap", player.tapListener

  finalizeConfig = (config) ->
    [cpus, humans] = config.players.partition (playerData) ->
      playerData.cpu

    [reds, blues] = humans.partition (playerData) ->
      playerData.team

    # Rebalance CPU players as needed
    while (blues.length < I.maxPlayers / 2) && cpus.length
      cpu = cpus.pop()
      cpu.team = 0

      blues.push cpu

    while (reds.length < I.maxPlayers / 2) && cpus.length
      cpu = cpus.pop()
      cpu.team = 1

      reds.push cpu

    # Repartition now that we've balanced
    [reds, blues] = config.players.partition (playerData) ->
      playerData.team

    #TODO Add in team style data

    reds.each (red, i) ->
      red.slot = i
      red.y = WALL_TOP + ARENA_HEIGHT * (i + 1) / (reds.length + 1)
      red.x = WALL_LEFT + ARENA_WIDTH/2 + ARENA_WIDTH / 6
      red.heading = 0.5.rotations
      red.teamStyle = "spike"

    blues.each (blue, i) ->
      blue.slot = i
      blue.y = WALL_TOP + ARENA_HEIGHT * (i + 1) / (blues.length + 1)
      blue.x = WALL_LEFT + ARENA_WIDTH/2 - ARENA_WIDTH / 6
      blue.teamStyle = "smiley"

    return config

  self = GameObject(I).extend
    draw: (canvas) ->
      canvas.font I.font

      self.trigger "beforeTransform", canvas

      canvas.withTransform Matrix.translation(I.x, I.y), ->
        I.config.players.each (player, i) ->
          y = 0
          x = player.id * App.width / MAX_PLAYERS

          if player.cpu
            name = "CPU"
            color = Color(Player.CPU_COLOR)
          else
            name = player.name || "P#{(player.id + 1)}"
            color = Color(I.teamColors[player.team] || player.color)

            if player.ready
              color.a = 1
            else
              color.a = 0.5

          nameWidth = canvas.measureText(name)

          if player.team == 1
            player.teamStyle = "spike"
          else if player.team == 0
            player.teamStyle = "smiley"

          player.headStyle = TeamSheet.headStyles.wrap(player.headIndex) || "stubs"
          player.bodyStyle = TeamSheet.bodyStyles.wrap(player.bodyIndex) || "thick"

          Configurator.images[player.team].background.draw(canvas, x, 0)
          Configurator.border.draw(canvas, x, 0)
          Configurator.images[player.team].nameBubble.draw(canvas, x, 0)
          Configurator.images[player.team].readyBubble.draw(canvas, x, I.height - 62)

          # Draw Body Sprite
          canvas.withTransform Matrix.scale(0.5, 0.5, Point(x, y)), (canvas) ->
            teamSprites[player.teamStyle][player.bodyStyle].slow.front[0]?.draw(canvas, x - 256, y - 160)

          # Draw Head Sprite
          canvas.withTransform Matrix.scale(0.5, 0.5, Point(x, y)), (canvas) ->
            teamSprites[player.teamStyle][player.headStyle].normal[0]?.draw(canvas, x - 224, y - 200)

          canvas.centerText
            text: name
            x: x + horizontalPadding + I.width / 12 + 1
            y: y + lineHeight + verticalPadding + 1
            color: "black"

          canvas.centerText
            text: name
            x: x + horizontalPadding + I.width / 12
            y: y + lineHeight + verticalPadding
            color: "white"

  self.bind "step", ->
    I.maxPlayers.times (i) ->
      controller = engine.controller(i)

      if controller.actionDown "ANY"
        join(i)

      if player = I.config.players[i]
        if controller.buttonPressed("LB")
          player.bodyIndex += 1
        if controller.buttonPressed("RB")
          player.headIndex += 1

      if (player = I.config.players[i])
        # TODO Scope to focused on ready button
        if controller.actionDown("A")
          player.ready = true

        if controller.actionDown("B")
          player.ready = false

    readyPlayers = I.config.players.select((player) -> player.ready)

    if readyPlayers.length == I.activePlayers && readyPlayers.length > 0
      unbindTapEvents()
      self.trigger "done", finalizeConfig(I.config)

  return self

Configurator.images = ["blue", "red"].map (team) ->
  {
    background: Sprite.loadByName("gameselect_back_#{team}")
    nameBubble: Sprite.loadByName("gameselect_namebubble_#{team}")
    readyBubble: Sprite.loadByName("gameselect_readybubble_#{team}")
    readyBubbleActive: Sprite.loadByName("gameselect_readybubble2_#{team}")
  }

Configurator.ready = []

Configurator.border = Sprite.loadByName("gameselect_borders")