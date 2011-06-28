Scoreboard = (I) ->
  $.reverseMerge I,
    period: 1
    sprite: Sprite.loadByName("scoreboard")
    time: 0
    x: rand(App.width).snap(32)
    y: rand(WALL_TOP).snap(32)
    zIndex: 1

  self = GameObject(I).extend
    draw: (canvas) ->
      I.sprite.draw(canvas, WALL_LEFT + (ARENA_WIDTH - I.sprite.width)/2, 16)

      minutes = (I.time / 30 / 60).floor()
      seconds = ((I.time / 30).floor() % 60).toString()

      if seconds.length == 1
        seconds = "0" + seconds

      canvas.fillColor("red")
      canvas.font("bold 24px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")
      canvas.fillText("#{minutes}:#{seconds}", WALL_LEFT + ARENA_WIDTH/2 - 22, 46)
      canvas.fillText(I.period, WALL_LEFT + ARENA_WIDTH/2 + 18, 84)

      # canvas.fillText(homeScore, WALL_LEFT + ARENA_WIDTH/2 - 72, 60)
      # canvas.fillText(awayScore, WALL_LEFT + ARENA_WIDTH/2 + 90, 60)


  self.bind "update", ->
    I.time += 1

  return self

