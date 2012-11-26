ParticleEffect =
  bloodSpray: (options) ->
    {x, y, push} = options

    [2..4].rand().times ->
      if sprite = ParticleEffect.sprites.blood.rand()[0]
        velocity = Point.fromAngle(Random.angle()).scale((rand(5) + 1) * 2).add(push).scale(0.5)

        engine.add
          class: "Particle"
          duration: 12
          x: x
          y: y
          velocity: velocity
          sprite: sprite

  iceSpray: (options) ->
    {x, y, push} = options

    [1..3].rand().times ->
      if sprite = ParticleEffect.sprites.ice.rand()[0]
        velocity = Point.fromAngle(Random.angle()).scale((rand(5) + 1)).add(push).scale(1)

        engine.add
          class: "Particle"
          duration: 12
          x: x
          y: y
          velocity: velocity
          sprite: sprite

ParticleEffect.sprites =
  blood: [1..5].map (n) ->
    Sprite.loadSheet "gibs/blood_particles/#{n}", 512, 512, 0.25
  ice: [2, 4, 5, 6].map (n) ->
    Sprite.loadSheet "gibs/ice_particles/#{n}", 512, 512, 0.25

Particle = (I={}) ->
  self = GameObject(I)

  I.rotation = I.velocity.direction()

  self.bind "update", ->
    I.x += I.velocity.x
    I.y += I.velocity.y

    I.zIndex = I.y

  return self
