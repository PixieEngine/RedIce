Engine.Stats = (I={}, self) ->
  stats = xStats()

  $(stats.element).css
    position: "absolute"
    right: 0
    bottom: 0
  .appendTo("body")

  return {}
