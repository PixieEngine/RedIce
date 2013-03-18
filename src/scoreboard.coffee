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
    timeSinceLastZamboni: 0 # seconds
    zamboniInterval: 30 # seconds
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

  displayWinnerOverlay = (canvas) ->
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

  displayMenu = ->
    unless menu = engine.first("Menu")
      engine.I.currentState.addPauseMenu()

  endGameChecks = ->
    if I.period >= 4
      if I.score.home > I.score.away
        I.winner = config.homeTeam
      else if I.score.away > I.score.home
        I.winner = config.awayTeam

      if I.winner
        unless I.gameOver
          I.gameOver = true
          engine.delay 1, ->
            displayMenu()

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
      displayWinnerOverlay(canvas)

    else if I.period >= 4
      canvas.centerText
        color: "#0F0"
        text: "SUDDEN DEATH"
        y: 120

  self.on "update", (dt) ->
    I.timeSinceLastZamboni += dt

    if I.timeSinceLastZamboni >= I.zamboniInterval
      I.timeSinceLastZamboni = 0

      # Alternate between home and away team zambonis
      I.reverse = !I.reverse

      engine.add
        class: "Zamboni"
        reverse: I.reverse
        team: [config.awayTeam, config.homeTeam][0|I.reverse] # Choose team based on reverse state

    I.time -= dt

    if I.gameOver
      # Restarting is handled in menu now
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
