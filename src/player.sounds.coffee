Player.Sounds = (I, self) ->

  sfx = (name, n, m="") ->
    Sound.play "#{name} #{rand(n) + 1}#{m}"

  self.on "wipeout", ->
    sfx "Body Hit", 4, "v"

    if rand 5
      sfx "Crowd Cheers", 4
    else
      sfx "Crowd Jeers", 3

    engine.delay 8 / 30, ->
      sfx "Torso Slide", 2, "v"

  self.on "shoot", ->
    sfx "Swing Release", 4

  self.on "slide_stop", ->
    sfx "Slide Stop", 3

  self.on "shot_start", ->
    # sfx "Swing Lift", 6, "m"

  return {}
