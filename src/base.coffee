Base = (I) ->
  I ||= {}

  self = GameObject(I).extend
    bloody: $.noop

    puck: ->
      false

    wipeout: $.noop

  self

