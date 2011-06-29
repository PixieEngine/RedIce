Music = (->
  track = $ "<audio />",
    loop: "loop"
  .appendTo('body').get(0)

  track.volume = 0.40

  play: (name) ->
    track.src = "#{BASE_URL}/sounds/#{name}.mp3"
    track.play()
)()

