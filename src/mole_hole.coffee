MoleHole = (I={}) ->
  Object.reverseMerge I,
    radius: 40
    mole: false
    team: false
    heading: rand(Math.TAU)
    struck: 0
    headY: 0
    moleAge: 0

  self = GameObject(I)

  self.include "DebugDrawable"

  self.unbind "draw"

  moleHeight = ->
    declining = (I.moleDuration * 4).clamp(0, 1)
    rising = (I.moleAge * 4).clamp(0, 1)

    Math.min(declining, rising)

  sfx = (name, n, m="") ->
    Sound.play "#{name} #{rand(n) + 1}#{m}"

  self.on "struck", (player) ->
    if I.mole and !I.struck and moleHeight() > 0.5
      I.struck = 0.5
      I.headRotationalVelocity = 0

      sfx "Robo Hit", 3, "v"

      if player.I.teamStyle is I.team
        player.score(-1)
      else
        player.score(+1)

  self.on "draw", (canvas) ->
    canvas.withTransform Matrix.scale(1, 1/PERSPECTIVE_RATIO), ->
      holeRadius = I.radius + 20

      canvas.drawCircle
        x: 0
        y: -5
        color: "#888"
        radius: holeRadius

      if Math.sin(I.struck * Math.TAU / 0.125).sign() > 0
        color = "#AA2"
      else
        color = "#112"

      canvas.drawCircle
        x: 0
        y: 0
        color: color
        radius: holeRadius

    canvas.withTransform Matrix.scale(0.75), ->
      if I.mole
        if I.headFlip
          transform = Matrix.scale(-1, 1)
        else
          transform = Matrix.IDENTITY

        canvas.withTransform transform, (canvas) ->
          sprite = I.headSprite
          {width, height} = sprite
          sprite.draw canvas, -width/2, -height/2 - moleHeight() * 20

  self.on "update", (dt) ->
    # TODO FPS independence
    I.struck = I.struck.approach(0, dt)

    if I.mole
      I.moleDuration -= dt
      I.moleAge += dt

      I.heading += I.headRotationalVelocity * dt

      if I.struck
        I.headAction = "pain"
        I.moleDuration = I.moleDuration.clamp(0, I.struck)

      if I.moleDuration <= 0
        I.mole = false
    else
      if rand() < 0.005
        I.mole = true
        I.moleAge = 0
        I.team = TEAMS.rand()
        I.heading = rand(Math.TAU)
        I.headStyle = TeamSheet.headStyles.rand()
        I.headAction = "normal"
        I.moleDuration = rand(4) + 1
        I.headRotationalVelocity = (rand() - 0.5).sign() * Math.TAU / 5

    if I.mole
      headDirection = I.heading
      angleSprites = 8
      headIndexOffset = 2
      headPosition = ((angleSprites * -headDirection / Math.TAU).round() + headIndexOffset).mod(angleSprites)

      if headPosition >= 5
        headPosition = angleSprites - headPosition
        I.headFlip = true
      else
        I.headFlip = false

      I.headSprite = teamSprites[I.team][I.headStyle][I.headAction][headPosition]

  return self
