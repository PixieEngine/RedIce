Minigames.Paint = (I={}) ->
  Object.reverseMerge I,
    playerIncludes: [
      "Paint"
    ]

  self = Minigame(I)

  window.physics = Physics()

  self.on "enter", ->
    engine.add
      class: "Rink"
      wallTop: 0
      wallBottom: App.height
      wallLeft: 0
      wallRight: App.width
      lines: false

    colors = [
      "#000000"
      "#FFFFFF"
      "#666666"
      "#DCDCDC"
      "#EB070E"
      "#F69508"
      "#FFDE49"
      "#388326"
      "#0246E3"
      "#563495"
      "#58C4F5"
      "#E5AC99"
      "#5B4635"
      "#FFFEE9"
    ]

    colors.each (color, i) ->
      engine.add
        class: "Paint"
        y: 0
        x: (i + 0.5) * App.width / colors.length
        color: color

  self.on "update", ->
    return if I.paused

    players = engine.find("Player").shuffle()
    zambonis = engine.find("Zamboni")

    objects = players.concat zambonis

    physics.process(objects)

  return self
