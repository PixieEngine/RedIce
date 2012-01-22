Configurator = (I) ->
  $.reverseMerge I,
    activePlayers: 0
    font: "bold 14px 'Monaco', 'Inconsolata', 'consolas', 'Courier New', 'andale mono', 'lucida console', 'monospace'"
    maxPlayers: 6
    teamColors:
      "0": Color("#0246E3")
      "1": Color("#EB070E")
    width: 600
    height: 480

  lineHeight = 11
  verticalPadding = 4
  horizontalPadding = 6
  iceBg = Sprite.loadByName("ice_bg")

  join = (id) ->
    player = I.config.players[id]

    # Can only join in over existing CPU players
    return unless player.cpu

    player.cpu = false
    player.ready = false
    player.team = 0.5
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
      red.bodyStyle = "tubs"

    blues.each (blue, i) ->
      blue.slot = i
      blue.y = WALL_TOP + ARENA_HEIGHT * (i + 1) / (blues.length + 1)
      blue.x = WALL_LEFT + ARENA_WIDTH/2 - ARENA_WIDTH / 6
      blue.teamStyle = "smiley"
      blue.bodyStyle = "skinny"
      blue.headStyle = "longface"

    return config

  self = GameObject(I).extend
    draw: (canvas) ->
      canvas.font I.font

      self.trigger "beforeTransform", canvas

      canvas.withTransform Matrix.translation(I.x, I.y), ->
        canvas.drawRoundRect
          x: 0
          y: 0
          width: I.width
          height: I.height
          radius: 15
          color: "rgba(0, 0, 0, 0.75)"

        canvas.drawText
          text: "Blue Team"
          position: Point(20, 20)
          color: Player.COLORS[0]

        canvas.drawText
          text: "Red Team"
          position: Point(520, 20)
          color: Player.COLORS[1]

        I.config.players.each (player, i) ->
          y = i * 60 + 30
          x = (player.team) * 500 + 30

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
          else
            player.teamStyle = "smiley"

          player.headStyle = "stubs"

          # Draw Head Sprite
          canvas.withTransform Matrix.scale(0.5, 0.5, Point(x, y)), (canvas) ->
            teamSprites[player.teamStyle][player.headStyle][0]?.draw(canvas, x - 256, y - 256)

          canvas.drawRoundRect {
            x 
            y
            width: nameWidth + 2 * horizontalPadding 
            height: lineHeight + 2 * verticalPadding
            color
          }

          canvas.drawText
            text: name
            x: x + horizontalPadding
            y: y + lineHeight + verticalPadding
            color: "white"

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

  self.bind "beforeTransform", (canvas) ->
    iceBg.fill(canvas, 0, 0, canvas.width(), canvas.height())
    canvas.fill("rgba(0, 0, 0, 0.5)")

  return self

