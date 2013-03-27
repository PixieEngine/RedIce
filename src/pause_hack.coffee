PauseHack = (I, self) ->
  self.unbind "update"
  queuedObjects = []

  # TODO This whole thing is a weird compromise to allow for a pause menu
  # Ideally this would be a new gamestate that is pushed onto a gamestate stack
  # where the current gamestate would be visible beneath it, but until that's in place
  # we'll just skip updating all objects except menus if a menu exists
  self.on "update", (elapsedTime) ->
    I.updating = true

    if menu = engine.first "Menu"
      objects = [menu]
    else
      objects = I.objects

    objects.invoke "trigger", "beforeUpdate", elapsedTime
    objects.invoke "update", elapsedTime
    objects.invoke "trigger", "afterUpdate", elapsedTime

    # Still partition all objects to prevent everything from being removed when paused
    [toKeep, toRemove] = I.objects.partition (object) ->
      object.I.active

    toRemove.invoke "trigger", "remove"

    I.objects = toKeep.concat(queuedObjects)
    queuedObjects = []

    I.updating = false

  # TODO: Handle this whole pause menu thing better
  # Overriding add due to queued objects closure
  self.add = (entityData) ->
    self.trigger "beforeAdd", entityData

    object = GameObject.construct entityData
    object.create()

    self.trigger "afterAdd", object

    if I.updating
      queuedObjects.push object
    else
      I.objects.push object

    return object

  return {}
