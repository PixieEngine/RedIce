Configurator = (I) ->
  $.reverseMerge I,
    font: "bold 14px 'Monaco', 'Inconsolata', 'consolas', 'Courier New', 'andale mono', 'lucida console', 'monospace'"
    players: []
    teamColors:
      "-1": Color("#0246E3")
      "1": Color("#EB070E")

  lineHeight = 11
  verticalPadding = 4
  horizontalPadding = 6

  self = GameObject(I).extend
    draw: (canvas) ->
      canvas.font I.font

      canvas.withTransform Matrix.translation(I.x, I.y), ->
        I.players.compact().each (player, i) ->
          y = i * 40
          x = (player.team + 1) * 150

          nameWidth = canvas.measureText(player.name)
          if color = I.teamColors[player.team]
            color.a(0.5) unless player.ready
          else
            color = player.color

          canvas.fillColor(color)
          canvas.fillRoundRect(x, y, nameWidth + 2 * horizontalPadding, lineHeight + 2 * verticalPadding)

          canvas.fillColor("#FFF")
          canvas.fillText(player.name, x + horizontalPadding, y + lineHeight + verticalPadding)

    addPlayer: (player) ->
      I.players[player.id] = player

      engine.controller(player.id).bind "tap", (p) ->
        unless player.ready
          player.team = (player.team + p.x).clamp(-1, 1)

  self.bind "step", ->
    6.times (i) ->
      if (player = I.players[i]) && player.team
        controller = engine.controller(i)

        if controller.actionDown("A")
          player.ready = true

        if controller.actionDown("B")
          player.ready = false

    readyPlayers = I.players.compact().select((player) -> player.ready)

    if readyPlayers.length == activePlayers && readyPlayers.length > 0
      ; #TODO Start game

  return self

