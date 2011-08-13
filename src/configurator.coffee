Configurator = (I) ->
  $.reverseMerge I,
    activePlayers: 0
    font: "bold 14px 'Monaco', 'Inconsolata', 'consolas', 'Courier New', 'andale mono', 'lucida console', 'monospace'"
    maxPlayers: 6
    teamColors:
      "0": Color("#0246E3")
      "1": Color("#EB070E")

  lineHeight = 11
  verticalPadding = 4
  horizontalPadding = 6

  join = (id) ->
    player = I.config.players[id]

    # Can only join in over existing CPU players
    return unless player.cpu

    player.cpu = false
    player.ready = false
    player.team = 0.5
    I.activePlayers += 1

    backgroundColor = Color(player.color)
    backgroundColor.a(0.5)

    cursorColor = backgroundColor.lighten(0.25)

    nameEntry = engine.add
      backgroundColor: backgroundColor
      class: "NameEntry"
      controller: id
      cursorColor: cursorColor
      x:  id * (App.width / I.maxPlayers)
      y:  20

    nameEntry.bind "done", (name) ->
      nameEntry.destroy()

      player.name = name
      player.tapListener = (p) ->
        unless player.ready
          player.team = (player.team + p.x/2).clamp(0, 1)

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
    #TODO This doesn't balance if the cpu popped is already on the other team
    if cpus.length
      blues.push cpus.pop() while cpus.length && reds.length > blues.length
      reds.push cpus.pop() while cpus.length && blues.length > reds.length

    # Repartition now that we've balanced
    [reds, blues] = config.players.partition (playerData) ->
      playerData.team

    reds.each (red, i) ->
      red.team = 1

      red.y = WALL_TOP + ARENA_HEIGHT * (i + 1) / (reds.length + 1)
      red.x = WALL_LEFT + ARENA_WIDTH/2 + ARENA_WIDTH / 6

    blues.each (blue, i) ->
      blue.team = 0

      blue.y = WALL_TOP + ARENA_HEIGHT * (i + 1) / (blues.length + 1)
      blue.x = WALL_LEFT + ARENA_WIDTH/2 - ARENA_WIDTH / 6

    return config

  self = GameObject(I).extend
    draw: (canvas) ->
      canvas.font I.font

      canvas.withTransform Matrix.translation(I.x, I.y), ->
        I.config.players.each (player, i) ->
          y = i * 40
          x = (player.team) * 300

          if player.cpu
            name = "CPU"
            color = Color(Player.CPU_COLOR)
          else
            name = player.name || "P#{player.id}"
            color = I.teamColors[player.team] || Color(player.color)

            if player.ready
              color.a(1)
            else
              color.a(0.5)

          nameWidth = canvas.measureText(name)

          canvas.fillColor(color)
          canvas.fillRoundRect(x, y, nameWidth + 2 * horizontalPadding, lineHeight + 2 * verticalPadding)

          canvas.fillColor("#FFF")
          canvas.fillText(name, x + horizontalPadding, y + lineHeight + verticalPadding)

  self.bind "step", ->
    I.maxPlayers.times (i) ->
      controller = engine.controller(i)

      if controller.actionDown "ANY"
        join(i)

      if (player = I.config.players[i]) && (player.team != 0.5)
        if controller.actionDown("A")
          player.ready = true

        if controller.actionDown("B")
          player.ready = false

    readyPlayers = I.config.players.select((player) -> player.ready)

    if readyPlayers.length == I.activePlayers && readyPlayers.length > 0
      unbindTapEvents()
      self.trigger "done", finalizeConfig(I.config)

  return self

