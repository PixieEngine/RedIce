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

      engine.controller(id).bind "tap", (p) ->
        unless player.ready
          player.team = (player.team + p.x/2).clamp(0, 1)

  self = GameObject(I).extend
    draw: (canvas) ->
      canvas.font I.font

      canvas.withTransform Matrix.translation(I.x, I.y), ->
        I.config.players.each (player, i) ->
          y = i * 40
          x = (player.team) * 300

          nameWidth = canvas.measureText(player.name)

          color = I.teamColors[player.team] || Color(player.color)

          if player.ready
            color.a(1)
          else
            color.a(0.5)

          canvas.fillColor(color)
          canvas.fillRoundRect(x, y, nameWidth + 2 * horizontalPadding, lineHeight + 2 * verticalPadding)

          canvas.fillColor("#FFF")
          canvas.fillText(player.name, x + horizontalPadding, y + lineHeight + verticalPadding)

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
      self.trigger "done", I.config

  return self

