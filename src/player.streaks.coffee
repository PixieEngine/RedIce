Player.Streaks = (I={}, self) ->
  Object.reverseMerge I,
    bloodColor: BLOOD_COLOR
    blood:
      face: 0
      body: 0
      leftSkate: 0
      rightSkate: 0

  self.bind "wipeout", ->
    I.blood.face += rand(20) + rand(20) + rand(20) + I.falls

  self.bind "step", ->
    self.drawBloodStreaks()

  bloody: ->
    if I.wipeout
      I.blood.body += rand(5)
    else
      I.blood.leftSkate = (I.blood.leftSkate + rand(10)).clamp(0, 60)
      I.blood.rightSkate = (I.blood.rightSkate + rand(10)).clamp(0, 60)

  leftSkatePos: ->
    p = Point.fromAngle(I.heading - Math.TAU/4).scale(5)

    self.center().add(p)

  rightSkatePos: ->
    p = Point.fromAngle(I.heading + Math.TAU/4).scale(5)

    self.center().add(p)

  drawBloodStreaks: ->
    if (blood = I.blood.face) && rand(2) == 0
      color = Color(I.bloodColor)

      currentPos = self.center()
      (rand(blood)/3).floor().clamp(0, 2).times ->
        I.blood.face -= 1
        p = currentPos.add(Point.fromAngle(Random.angle()).scale(rand()*rand()*16))

        bloodCanvas.drawCircle
          position: p
          radius: (rand(5)*rand()*rand()).clamp(0, 3)
          color: color

    if I.wipeout # Body blood streaks

    else # Skate blood streaks
      currentLeftSkatePos = self.leftSkatePos()
      currentRightSkatePos = self.rightSkatePos()

      # Skip certain feet
      cycle = I.age % 30
      if 1 < cycle < 14
        I.lastLeftSkatePos = null
      if 15 < cycle < 29
        I.lastRightSkatePos = null

      if I.lastLeftSkatePos
        if skateBlood = I.blood.leftSkate
          I.blood.leftSkate -= 1

          color = I.bloodColor
          thickness = (skateBlood/30).clamp(0, 1.5)
        else
          color = ICE_COLOR
          thickness = 1

        bloodCanvas.drawLine
          start: I.lastLeftSkatePos
          end: currentLeftSkatePos
          width: thickness
          color: color

      if I.lastRightSkatePos
        if skateBlood = I.blood.rightSkate
          I.blood.rightSkate -= 1

          color = I.bloodColor
          thickness = (skateBlood/30).clamp(0, 1.5)
        else
          color = ICE_COLOR
          thickness = 1

        bloodCanvas.strokeColor(color)
        bloodCanvas.drawLine
          start: I.lastRightSkatePos
          end: currentRightSkatePos
          width: thickness
          color: color

      I.lastLeftSkatePos = currentLeftSkatePos
      I.lastRightSkatePos = currentRightSkatePos
