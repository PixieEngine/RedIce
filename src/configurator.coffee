Configurator = (I) ->
  $.reverseMerge I,
    font: "bold 14px 'Monaco', 'Inconsolata', 'consolas', 'Courier New', 'andale mono', 'lucida console', 'monospace'"
    players: []
    teamColors:
      "-1": "#0246E3"
      "1": "#EB070E"

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
          color = I.teamColors[player.team] || player.color
          canvas.fillColor(color)
          canvas.fillRoundRect(x, y, nameWidth + 2 * horizontalPadding, lineHeight + 2 * verticalPadding)

          canvas.fillColor("#FFF")
          canvas.fillText(player.name, x + horizontalPadding, y + lineHeight + verticalPadding)

    addPlayer: (player) ->
      I.players[player.id] = player

      engine.controller(player.id).bind "tap", (p) ->
        player.team = (player.team + p.x).clamp(-1, 1)

  return self

