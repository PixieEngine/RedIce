GameState = (I={}) ->
  # Set some default properties
  Object.reverseMerge I,
    update: ->

  queuedObjects = []
  I.objects ||= []

  self = Core(I).extend
    ###*
    The add method creates and adds an object to the game world. Two
    other events are triggered around this one: beforeAdd and afterAdd.

    <code><pre>
    # you can add arbitrary entityData and
    # the engine will make it into a GameObject
    engine.add 
      x: 50
      y: 30
      color: "red"

    player = engine.add
      class: "Player"
    </pre></code>

    @name add
    @methodOf Engine#
    @param {Object} entityData The data used to create the game object.
    @returns {GameObject}
    ###
    add: (entityData) ->
      self.trigger "beforeAdd", entityData

      object = GameObject.construct entityData
      object.create()

      self.trigger "afterAdd", object

      if I.updating
        queuedObjects.push object
      else
        I.objects.push object

      return object

    objects: ->
      I.objects.copy()

  self.include Bindable

  # Add events and methods here
  self.bind "update", ->
    I.updating = true

    # TODO Extract this into an Objects or States module
    # and bind it to the 'update' event
    [I.objects, toRemove] = I.objects.partition (object) ->
      object.update()

    toRemove.invoke "trigger", "remove"

    I.updating = false

    I.objects = I.objects.concat(queuedObjects)
    queuedObjects = []

  # We must always return self as the last line
  return self

