ParticleEffect =
  bloodSpray: (options) ->
    {x, y, push, teamStyle} = options

    [2..4].rand().times ->
      if sprite = ParticleEffect.sprites.blood[teamStyle].rand()[0]
        velocity = Point.fromAngle(Random.angle()).scale((rand(5) + 1) * 2).add(push).scale(0.5)

        engine.add
          class: "Particle"
          blood: true
          duration: 12 / 30
          teamStyle: teamStyle
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
          duration: 12 / 30
          x: x
          y: y
          velocity: velocity
          sprite: sprite

do ->
  size = 128
  scale = 1

  ParticleEffect.sprites =
    ice: [2, 4, 5, 6].map (n) ->
      Sprite.loadSheet "gibs/ice_particles/#{n}", size, size, scale

  normalBlood = [1..5].map (n) ->
    Sprite.loadSheet "gibs/blood_particles/#{n}", size, size, scale

  mutantBlood = [6..10].map (n) ->
    Sprite.loadSheet "gibs/blood_particles/#{n}", size, size, scale

  robotBlood = [11..15].map (n) ->
    Sprite.loadSheet "gibs/blood_particles/#{n}", size, size, scale

  monsterBlood = [1..4].map (n) ->
    Sprite.loadSheet "gibs/body_parts/#{n}", size, size, scale

  ParticleEffect.sprites.blood =
    spike: normalBlood
    smiley: normalBlood
    hiss: normalBlood
    monster: monsterBlood
    mutant: mutantBlood
    robo: robotBlood


Particle = (I={}) ->
  Object.reverseMerge I,
    spriteOffset: Point(-32, 0)
    teamStyle: "spike"

  self = GameObject(I)

  I.rotation = I.velocity.direction()

  self.on "update", ->
    I.x += I.velocity.x
    I.y += I.velocity.y

    I.zIndex = I.y

    return unless rink = engine.find("Rink").first()

    return unless sprite = Particle.wallSplats[I.teamStyle].rand()[0]

    if I.blood
      # TODO: Corner splats
      if WALL_LEFT + 128 < I.x < WALL_RIGHT - 128
        if I.y < WALL_TOP
          rink.paintBackWall
            x: I.x
            y: WALL_TOP - 16 - rand(96)
            sprite: sprite

          self.destroy()

        if I.y > WALL_BOTTOM
          rink.paintFrontWall
            x: I.x
            y: WALL_BOTTOM - 16 - rand(64)
            sprite: sprite

          self.destroy()

  return self

do ->
  size = 64
  scale = 1

  normalBlood = [1..4].map (n) ->
    Sprite.loadSheet "gibs/wall_decals/#{n}", size, size, scale

  mutantBlood = [9..12].map (n) ->
    Sprite.loadSheet "gibs/wall_decals/#{n}", size, size, scale

  robotBlood = [13..16].map (n) ->
    Sprite.loadSheet "gibs/wall_decals/#{n}", size, size, scale

  Particle.wallSplats =
    spike: normalBlood
    smiley: normalBlood
    hiss: normalBlood
    monster: normalBlood
    mutant: mutantBlood
    robo: robotBlood
