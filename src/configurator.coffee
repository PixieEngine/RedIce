Configurator = (I) ->
  $.reverseMerge I,
    font: "bold 14px 'Monaco', 'Inconsolata', 'consolas', 'Courier New', 'andale mono', 'lucida console', 'monospace'"
    players: []

  lineHeight = 11
  verticalPadding = 4
  horizontalPadding = 6

  self = GameObject(I).extend
    draw: (canvas) ->
      canvas.font I.font

      canvas.withTransform Matrix.translation(I.x, I.y), ->
        players.each (player, i) ->
          y = i * 40
          x = (player.team + 1) * 150

          nameWidth = canvas.measureText(player.name)
          canvas.fillColor(player.color)
          canvas.fillRoundRect(x, y, nameWidth + 2 * horizontalPadding, lineHeight + 2 * verticalPadding)

          canvas.fillColor("#FFF")
          canvas.fillText(player.name, x + horizontalPadding, y + lineHeight + verticalPadding)

    addPlayer: (player) ->
      players.push player

  return self

