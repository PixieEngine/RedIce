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

window.queryString = ->
  urlParams = {}
  match = undefined
  pl = /\+/g # Regex for replacing addition symbol with a space
  search = /([^&=]+)=?([^&]*)/g
  decode =  (s) ->
    return decodeURIComponent(s.replace(pl, " "))

  query  = window.location.search.substring(1)

  while (match = search.exec(query))
    urlParams[decode(match[1])] = decode(match[2])

  return urlParams
