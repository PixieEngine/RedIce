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
      else if I.period == 4
        engine.find("Goal").each (goal) ->
          goal.suddenDeath(true)

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

      canvas.font("bold 24px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")

      canvas.drawText
        color: "red"
        text: "#{minutes}:#{seconds}"
        x: WALL_LEFT + ARENA_WIDTH/2 - 22
        y: 46

      canvas.drawText
        color: "red"
        text: I.period
        x: WALL_LEFT + ARENA_WIDTH/2 + 18
        y: 84

      canvas.drawText
        color: "red"
        text: I.score.away
        x: WALL_LEFT + ARENA_WIDTH/2 - 72
        y: 60
      canvas.drawText
        color: "red"
        text: I.score.home
        x: WALL_LEFT + ARENA_WIDTH/2 + 90
        y: 60

      if I.gameOver
        canvas.centerText
          color: "#000"
          text: "GAME OVER"
          y: 384

        if I.winner == "HOME"
          color = "#F00"
        else
          color = "#00F"

        canvas.centerText
          color: color
          text: "#{I.winner} WINS"
          y: 416

      else if I.period >= 4
        canvas.centerText
          color: "#0F0"
          text: "SUDDEN DEATH"
          y: 120

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
      # Check for restart
      MAX_PLAYERS.times (i) ->
        controller = engine.controller(i)

        if controller.actionDown "START"
          self.trigger("restart")

    else # Regular play
      if I.time == 0
        nextPeriod()

  self.attrReader "gameOver"

  return self

