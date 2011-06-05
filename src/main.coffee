window.engine = Engine 
  canvas: $("canvas").powerCanvas()

engine.add
  sprite: Sprite.loadByName "title"

engine.add
  class: "Player"

engine.add
  class: "Player"
  controller: 1

engine.bind "update", ->
  # Resolve Collisions
  players = engine.find("Player")

  threshold = 5

  i = 0
  while i < players.length
    playerA = players[i]

    j = i + 1
    while j < players.length
      playerB = players[j]

      if Collision.circular(playerA.circle(), playerB.circle())
        delta = playerB.position().subtract(playerA.position()).norm()

        projA = playerA.I.velocity.dot(delta)
        projB = -playerB.I.velocity.dot(delta)

        max = Math.max(projA, projB)

        if max > threshold
          console.log max
          # winner
        else
          pushA = -delta
          pushB = delta

          playerA.I.velocity = playerA.I.velocity.add(pushA)
          playerB.I.velocity = playerB.I.velocity.add(pushB)

      j += 1
    i += 1


engine.start()

