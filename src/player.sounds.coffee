Player.Sounds = (I, self) ->

  sfx = (name, n, m="") ->
    Sound.play "#{name} #{rand(n) + 1}#{m}"

  self.bind "wipeout", ->
    sfx "Body Hit", 4, "v"

    if rand 5
      sfx "Crowd Cheers", 4
    else
      sfx "Crowd Jeers", 3

    engine.delay 8, ->
      sfx "Torso Slide", 2, "v"

  self.bind "shoot", ->
    sfx "Swing Release", 4

  self.bind "slide_stop", ->
    sfx "Slide Stop", 3

  self.bind "shot_start", ->
    # sfx "Swing Lift", 6, "m"

  return {}