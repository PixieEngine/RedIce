Scoreboard = (I) ->
  $.reverseMerge I,
    gameOver: false
    score: {
      home: 0
      away: 0
    }
    period: 0
    periodTime: 1 * 60 * 30
    reverse: false
    sprite: Sprite.loadByName("scoreboard")
    time: 0
    x: rand(App.width).snap(32)
    y: rand(WALL_TOP).snap(32)
    zamboniInterval: 30 * 30
    zIndex: 10

  endGameChecks = ->
    if I.period >= 4
      if I.score.home > I.score.away
        I.winner = "HOME"
      else if I.score.away > I.score.home
        I.winner = "AWAY"

      if I.winner
        I.gameOver = true
        I.time = 0

  nextPeriod = () ->
    I.time = I.periodTime
    I.period += 1

    endGameChecks()

  nextPeriod()

  self = GameObject(I).extend
    draw: (canvas) ->
      I.sprite.draw(canvas, WALL_LEFT + (ARENA_WIDTH - I.sprite.width)/2, 16)

      time = Math.max(I.time, 0)

      minutes = (time / 30 / 60).floor()
      seconds = ((time / 30).floor() % 60).toString()

      if seconds.length == 1
        seconds = "0" + seconds

      canvas.fillColor("red")
      canvas.font("bold 24px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")
      canvas.fillText("#{minutes}:#{seconds}", WALL_LEFT + ARENA_WIDTH/2 - 22, 46)
      canvas.fillText(I.period, WALL_LEFT + ARENA_WIDTH/2 + 18, 84)

      canvas.fillText(I.score.away, WALL_LEFT + ARENA_WIDTH/2 - 72, 60)
      canvas.fillText(I.score.home, WALL_LEFT + ARENA_WIDTH/2 + 90, 60)

      if I.gameOver
        canvas.font("bold 24px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")
        canvas.fillColor("#000")
        canvas.centerText("GAME OVER", 384)

        if I.winner == "HOME"
          canvas.fillColor("#F00")
        else
          canvas.fillColor("#00F")

        canvas.centerText("#{I.winner} WINS", 416)
      else if I.period >= 4
        canvas.font("bold 24px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")
        canvas.fillColor("#0F0")
        canvas.centerText("SUDDEN DEATH", 120)

    score: (team) ->
      I.score[team] += 1 unless I.gameOver

      endGameChecks()

  self.bind "update", ->
    if I.time % I.zamboniInterval == 0
      # No Zamboni very second
      unless I.time == I.periodTime && I.period == 1
        I.reverse = !I.reverse
        engine.add
          class: "Zamboni"
          reverse: I.reverse

    I.time -= 1

    if I.gameOver
      ; #I.time = 0
    else # Regular play
      if I.time == 0
        nextPeriod()

  self.attrReader "gameOver"

  return self

