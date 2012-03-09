Configurator = (I) ->
  Object.reverseMerge I,
    activePlayers: 0
    font: "bold 32px 'Monaco', 'Inconsolata', 'consolas', 'Courier New', 'andale mono', 'lucida console', 'monospace'"
    maxPlayers: 6
    teamColors:
      "0": Color("#0246E3")
      "1": Color("#EB070E")
    width: App.width
    height: App.height
    x: 0
    y: 0

  lineHeight = 11
  verticalPadding = 24
  horizontalPadding = 0

  teamStyles = ["smiley", "spike"]

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
      x:  id * (App.width / I.maxPlayers) + 4
      y:  40

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

          nameWidth = canvas.measureText(name)

          player.headStyle = TeamSheet.headStyles.wrap(player.headIndex) || "stubs"
          player.bodyStyle = TeamSheet.bodyStyles.wrap(player.bodyIndex) || "thick"
          player.teamStyle = teamStyles.wrap(player.teamIndex) || 0

          Configurator.images[player.teamStyle].background.draw(canvas, x, 0)
          if player.optionIndex? and !player.ready
            Configurator.active.draw(canvas, x, Configurator.options[player.optionIndex].y)
          Configurator.border.draw(canvas, x, 0)
          Configurator.images[player.teamStyle].nameBubble.draw(canvas, x, 0)
          Configurator.images[player.teamStyle].logo.draw(canvas, x - 48, 375)
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

          y = I.height/2
          x += I.width/12

          # Draw Body Sprite
          teamSprites[player.teamStyle][player.bodyStyle].slow.front[0]?.draw(canvas, x - 128, y - 160)

          # Draw Head Sprite
          teamSprites[player.teamStyle][player.headStyle].normal[0]?.draw(canvas, x - 110, y - 200)

  self.bind "step", ->
    I.maxPlayers.times (i) ->
      controller = engine.controller(i)

      if controller.actionDown "ANY"
        join(i)

      if (player = I.config.players[i])
        # TODO Scope to focused on ready button
        if controller.actionDown("A") and false
          player.ready = true

        if controller.actionDown("B")
          player.ready = false

    readyPlayers = I.config.players.select((player) -> player.ready)

    if readyPlayers.length == I.activePlayers && readyPlayers.length > 0
      unbindTapEvents()
      self.trigger "done", finalizeConfig(I.config)

  return self

Configurator.images = {}
[["blue", "smiley"], ["red", "spike"]].map ([team, style]) ->
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
    y: 600
  }
]

