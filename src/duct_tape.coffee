# Some extra functions until updating to the latest gamelib

Function::delay = (wait, args...) ->
  func = this

  setTimeout ->
    func.apply(null, args)
  , wait

Function::defer = (args...) ->
  this.delay.apply this, [1].concat(args)

Array::pluck = (property) ->
  @map (item) ->
    item[property]
