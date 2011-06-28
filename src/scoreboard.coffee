Scoreboard = (I) ->
  $.reverseMerge I,
    gameOver: false
    score: {
      home: 0
      away: 0
    }
    period: 0
    periodTime: 1 * 60 * 30
    sprite: Sprite.loadByName("scoreboard")
    time: 0
    x: rand(App.width).snap(32)
    y: rand(WALL_TOP).snap(32)
    zIndex: 10

  nextPeriod = () ->
    I.time = I.periodTime
    I.period += 1

    if I.period == 4
      I.gameOver = true
      #TODO check team scores and choose winner
    else if I.period > 1
      engine.add
        class: "Zamboni"
        reverse: I.period % 2

  nextPeriod()

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

      canvas.fillText(I.score.home, WALL_LEFT + ARENA_WIDTH/2 - 72, 60)
      canvas.fillText(I.score.away, WALL_LEFT + ARENA_WIDTH/2 + 90, 60)

      if I.gameOver
        canvas.font("bold 24px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")
        canvas.fillColor("#000")
        canvas.centerText("GAME OVER", 384)

    score: (team) ->
      I.score[team] += 1

  self.bind "update", ->
    I.time -= 1

    if I.gameOver
      I.time = 0
    else # Regular play
      if I.time == 0
        nextPeriod()

  return self

