Sound.volume = Sound.globalVolume

Array::maximum = (fn) ->
  @inject([-Infinity, undefined], (memo, item) ->
    value = fn(item)
    [maxValue, maxItem] = memo

    if value > maxValue
      [value, item]
    else
      memo
  ).last()
