WinnerOverlay = (I, self) ->
  self.displayWinnerOverlay = (canvas) ->
    canvas.fill "rgba(0, 0, 0, 0.25)"
    canvas.font "30px 'Iceland'"

    canvas.centerText
      y: 256 + 96 + 1
      color: "#000"
      text: "WIN!"
    canvas.centerText
      y: 256 + 96
      color: "#FFF"
      text: "WIN!"

    style = I.winner
    sprite = Configurator.images[style].logo

    x = App.width/2
    y = 256
    sprite.draw(canvas, x - sprite.width/2, y - sprite.height/2)

  return {}
