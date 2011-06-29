bgMusic = $ "<audio />",
  src: BASE_URL + "/sounds/music1.mp3"
  loop: "loop"
.appendTo('body').get(0)

bgMusic.volume = 0.40
bgMusic.play()

