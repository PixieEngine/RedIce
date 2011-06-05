window.engine = Engine 
  canvas: $("canvas").powerCanvas()

engine.add
  sprite: Sprite.loadByName "title"

engine.add
  class: "Player"

engine.add
  class: "Player"
  controller: 1

engine.add
  class: "Player"
  controller: 2
  radius: 8
  width: 16
  height: 16

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

      if !playerA.I.wipeout && !playerB.I.wipeout && Collision.circular(playerA.circle(), playerB.circle())
        delta = playerB.center().subtract(playerA.center()).norm()

        # Knockback
        pushA = delta.scale(-2)
        pushB = delta.scale(2)

        playerA.I.velocity = playerA.I.velocity.add(pushA)
        playerB.I.velocity = playerB.I.velocity.add(pushB)

        # Checking
        projA = playerA.I.velocity.dot(delta)
        projB = -playerB.I.velocity.dot(delta)

        max = Math.max(projA, projB)

        if max > threshold
          console.log max

          if projA == max
            playerB.wipeout()
          else
            playerA.wipeout()

      j += 1
    i += 1


engine.start()

