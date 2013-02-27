Scoreboard = (I) ->
  Object.reverseMerge I,
    gameOver: false
    score:
      home: 0
      away: 0
    period: 0
    periodTime: 60 # seconds
    reverse: false
    time: 0
    zamboniInterval: 30 * 30
    zIndex: App.height / 2
    timeY: 106
    scoreY: 134
    scoreX: 62
    periodY: 136
    periodX: 16
    periodRadiusDelta: 0
    periodYDelta: 0
    imageOffset: Point(0, -48)
    textColor: "#DDE"
    team: "hiss"

  Object.extend I, Scoreboard[I.team]
  I.sprite = teamSprites[I.team].scoreboard[0]

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
      # Nothing, draw on overlay

    score: (team) ->
      I.score[team] += 1 unless I.gameOver

      endGameChecks()

  self.on "overlay", (canvas) ->
    xPosition = App.width/2
    #TODO canvas.withTransform

    I.sprite?.draw(canvas, xPosition - (I.sprite.width / 2) + I.imageOffset.x, I.imageOffset.y)

    time = Math.max(I.time, 0)

    minutes = (time / 60).floor()
    seconds = time.floor().mod(60).toString()

    if seconds.length == 1
      seconds = "0" + seconds

    canvas.font("bold 24px consolas, 'Courier New', 'andale mono', 'lucida console', monospace")

    canvas.drawText
      color: I.textColor
      text: "#{minutes}:#{seconds}"
      x: xPosition - 27
      y: I.timeY

    I.period.clamp(1, 3).times (i) ->
      canvas.drawCircle
        color: "#0F0"
        radius: 2.5 + I.periodRadiusDelta * i
        x: xPosition + (i - 1) * I.periodX
        y: I.periodY + I.periodYDelta * i

    canvas.centerText
      color: I.textColor
      text: I.score.away
      x: xPosition - I.scoreX
      y: I.scoreY
    canvas.centerText
      color: I.textColor
      text: I.score.home
      x: xPosition + I.scoreX
      y: I.scoreY

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

  self.on "update", (dt) ->
    if I.time % I.zamboniInterval == 0
      # No Zamboni very second
      unless I.time == I.periodTime && I.period == 1
        I.reverse = !I.reverse

        engine.add
          class: "Zamboni"
          reverse: I.reverse
          team: [config.awayTeam, config.homeTeam][0|I.reverse]

    I.time -= dt

    if I.gameOver
      # Check for restart
      MAX_PLAYERS.times (i) ->
        controller = engine.controller(i)

        if controller.actionDown "START"
          self.trigger("restart")

    else # Regular play
      if I.time <= 0
        nextPeriod()

  self.attrReader "gameOver"

  return self

Object.extend Scoreboard,
  hiss:
    timeY: 108
    periodY: 131
    periodX: 17
  monster: {}
  mutant:
    scoreY: 132
    imageOffset: Point(-4, -48)
    periodY: 133
    periodX: 16
  smiley:
    scoreY: 144
    periodY: 146
    periodYDelta: -2
    periodRadiusDelta: 1.5
    timeY: 116
  spike: {}
  robo:
    periodY: 128
    timeY: 98
    scoreY: 128
    scoreX: 66
